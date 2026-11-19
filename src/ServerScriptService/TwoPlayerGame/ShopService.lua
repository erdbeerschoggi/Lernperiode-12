
local Players = game:GetService("Players")

local shopEvent = require(script.Parent.Remotes).Shop


local SHOP_ITEMS = {
	["Default"] = {Name = "standard", Price = 0},
	["Item 1"] = {Name = "red", Price = 100, Color = Color3.fromRGB(255, 80, 80)},
	["Item 2"] = {Name = "blue", Price = 250, Color = Color3.fromRGB(80, 150, 255)},
	["Item 3"] = {Name = "green", Price = 150, Color = Color3.fromRGB(65, 195, 110)},
	["Item 4"] = {Name = "purple", Price = 350, Color = Color3.fromRGB(165, 90, 225)},
	["Item 5"] = {Name = "gold", Price = 500, Color = Color3.fromRGB(245, 195, 55)},
}


local originalChairColors = setmetatable({}, {__mode = "k"})
local initializedPlayers = {}
local lastShopRequest = {}

local function applyChairSkin(player, chairModel)
	if not chairModel or not chairModel.Name:match("^Chair") then return end
	local equipped = player and player:FindFirstChild("EquippedChair")
	local item = equipped and SHOP_ITEMS[equipped.Value]
	local inventory = player and player:FindFirstChild("Inventory")
	local owned = equipped and (equipped.Value == "Default"
		or (inventory and inventory:FindFirstChild(equipped.Value)))
	local color = owned and item and item.Color

	for _, part in ipairs(chairModel:GetDescendants()) do
		if part:IsA("BasePart") and not part:GetAttribute("KeepShopColor") then
			if originalChairColors[part] == nil then
				originalChairColors[part] = part.Color
			end
			part.Color = color or originalChairColors[part]
		end
	end
end

local function updateSeatedChair(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local seat = humanoid and humanoid.SeatPart
	if seat and seat:IsA("Seat") then
		applyChairSkin(player, seat.Parent)
	end
end


local ShopService = {}
ShopService.applyChairSkin = applyChairSkin


function ShopService.start()
	local function setupShopPlayer(player)
		if initializedPlayers[player] then return end
		initializedPlayers[player] = true
		local leaderstats = player:FindFirstChild("leaderstats")
		if not leaderstats then
			leaderstats = Instance.new("Folder")
			leaderstats.Name = "leaderstats"
			leaderstats.Parent = player
		end
		if not leaderstats:FindFirstChild("Cash") then
			local cash = Instance.new("IntValue")
			cash.Name = "Cash"
			cash.Value = 0
			cash.Parent = leaderstats
		end
		if not player:FindFirstChild("Inventory") then
			local inventory = Instance.new("Folder")
			inventory.Name = "Inventory"
			inventory.Parent = player
		end
		local equipped = player:FindFirstChild("EquippedChair")
		if not equipped then
			equipped = Instance.new("StringValue")
			equipped.Name = "EquippedChair"
			equipped.Value = "Default"
			equipped.Parent = player
		end
		equipped.Changed:Connect(function() updateSeatedChair(player) end)
		updateSeatedChair(player)
	end
	Players.PlayerAdded:Connect(setupShopPlayer)
	for _, player in ipairs(Players:GetPlayers()) do setupShopPlayer(player) end
	Players.PlayerRemoving:Connect(function(player)
		initializedPlayers[player] = nil
		lastShopRequest[player] = nil
	end)


	shopEvent.OnServerEvent:Connect(function(player, action, itemName)
		if action ~= "BUY" or typeof(itemName) ~= "string" then return end
		local item = SHOP_ITEMS[itemName]
		if not item then return end
		local now = os.clock()
		if lastShopRequest[player] and now - lastShopRequest[player] < 0.2 then return end
		lastShopRequest[player] = now

		local stats = player:FindFirstChild("leaderstats")
		local cash = stats and stats:FindFirstChild("Cash")
		local inventory = player:FindFirstChild("Inventory")
		local equipped = player:FindFirstChild("EquippedChair")
		if not cash or not inventory or not equipped then return end

		if itemName == "Default" or inventory:FindFirstChild(itemName) then
			equipped.Value = itemName
			updateSeatedChair(player)
			shopEvent:FireClient(player, "OK", item.Name .. " selected.")
			return
		end
		if cash.Value < item.Price then
			shopEvent:FireClient(player, "ERROR", "You need " .. (item.Price - cash.Value) .. " more CHF.")
			return
		end

		cash.Value = cash.Value - item.Price
		local ownedItem = Instance.new("StringValue")
		ownedItem.Name = itemName
		ownedItem.Value = itemName
		ownedItem.Parent = inventory
		equipped.Value = itemName
		updateSeatedChair(player)
		shopEvent:FireClient(player, "OK", item.Name .. " purchased and selected.")
	end)
end

return ShopService
