local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local catalog = require(RS:WaitForChild("Shared"):WaitForChild("ShopExtensionCatalog"))
local models = require(RS.Shared:WaitForChild("ShopExtensionModels"))
local event = Instance.new("RemoteEvent")
event.Name = "ShopExtensionEvent"
event.Parent = RS
local assets = Instance.new("Folder")
assets.Name = "ShopExtensionAssets"
assets.Parent = RS
local items = {}
for _, item in ipairs(catalog) do items[item.Id] = item end
local lastRequest = {}
local initialized = {}

local function equip(player)
    local char = player.Character
    if not char then return end
    local old = char:FindFirstChild("ShopExtensionAccessory")
    if old then old:Destroy() end
    local value = player:FindFirstChild("ShopExtensionEquippedAccessory")
    local item = value and items[value.Value]
    local inventory = player:FindFirstChild("Inventory")
    if not item or not item.Kind or not inventory or not inventory:FindFirstChild(item.Id) then return end
    local target = item.Kind == "Backpack" and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")) or char:FindFirstChild("Head")
    if not target then return end
    local model = models.accessory(item.Kind)
    local offset = CFrame.new()
    if item.Kind == "Backpack" then offset = CFrame.new(0,0,target.Size.Z/2 + .4) end
    model:PivotTo(target.CFrame * offset)
    for _, p in ipairs(model:GetChildren()) do
        if p:IsA("BasePart") then
            p.Anchored = false
            p.Massless = true
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = target
            weld.Part1 = p
            weld.Parent = p
        end
    end
    model.Parent = char
end
local function setup(player)
    if initialized[player] then return end
    initialized[player] = true
    local value = Instance.new("StringValue")
    value.Name = "ShopExtensionEquippedAccessory"
    value.Parent = player
    value.Changed:Connect(function() equip(player) end)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Head",10)
        character:WaitForChild("Humanoid",10)
        -- CharacterAppearanceLoaded kann spaeter nochmals aufrufen.
        equip(player)
    end)
    player.CharacterAppearanceLoaded:Connect(function() equip(player) end)
    equip(player)
end
Players.PlayerAdded:Connect(setup)
for _, player in ipairs(Players:GetPlayers()) do setup(player) end
Players.PlayerRemoving:Connect(function(player)
    initialized[player] = nil
    lastRequest[player] = nil
end)
event.OnServerEvent:Connect(function(player, action, id)
    if type(action) ~= "string" or type(id) ~= "string" then return end
    if action ~= "BUY" and action ~= "UNEQUIP" then return end
    local now = os.clock()
    if lastRequest[player] and now - lastRequest[player] < .25 then return end
    lastRequest[player] = now
    local selected = player:FindFirstChild("ShopExtensionEquippedAccessory")
    if not selected then return end
    if action == "UNEQUIP" then
        selected.Value = ""
        event:FireClient(player,"OK","Accessory removed.")
        return
    end
    local item = items[id]
    if not item or item.Category ~= "Accessories" then return end
    local stats = player:FindFirstChild("leaderstats")
    local cash = stats and stats:FindFirstChild("Cash")
    local inventory = player:FindFirstChild("Inventory")
    if not cash or not inventory then
        event:FireClient(player,"ERROR","Shop is loading. Please try again.")
        return
    end
    if inventory:FindFirstChild(id) then
        selected.Value = id
        event:FireClient(player,"OK",item.Name .. " equipped.")
        return
    end
    if cash.Value < item.Price then
        event:FireClient(player,"ERROR","You need " .. (item.Price-cash.Value) .. " more CHF.")
        return
    end
    -- Ohne Yield zwischen Pruefung, Abzug und Inventareintrag.
    cash.Value = cash.Value - item.Price
    local owned = Instance.new("StringValue")
    owned.Name = id
    owned.Value = id
    owned.Parent = inventory
    selected.Value = id
    event:FireClient(player,"OK",item.Name .. " purchased and equipped.")
end)

-- Nur Vorlagen fuer die 3D-Vorschau im Shop erzeugen.
-- Keine Ausstellungsmodelle, Podeste oder Schilder in Workspace anlegen.
task.spawn(function()
    task.wait(1)
    local source
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Seat") and object.Parent and object.Parent.Name:match("^Chair") then
            source = object.Parent
            break
        end
    end
    for _, item in ipairs(catalog) do
        local template = item.Kind and models.accessory(item.Kind) or models.chair(source,item.Color)
        template.Name = item.Id
        template.Parent = assets
    end
end)
