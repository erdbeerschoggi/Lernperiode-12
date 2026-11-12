local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local catalog = require(RS:WaitForChild("Shared"):WaitForChild("ShopExtensionCatalog"))
local event = RS:WaitForChild("ShopExtensionEvent")
local oldEvent = RS:WaitForChild("ShopEvent")
local assets = RS:WaitForChild("ShopExtensionAssets")
local inventory = player:WaitForChild("Inventory")
local cash = player:WaitForChild("leaderstats"):WaitForChild("Cash")
local equipped = player:WaitForChild("EquippedChair")
local accessory = player:WaitForChild("ShopExtensionEquippedAccessory")
local gui = Instance.new("ScreenGui")
gui.Name = "ShopExtensionGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 40
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")
local function create(class, parent, props)
    local obj = Instance.new(class)
    for key,value in pairs(props) do obj[key] = value end
    obj.Parent = parent
    return obj
end
local function corner(obj)
    create("UICorner",obj,{CornerRadius=UDim.new(0,10)})
end
local function button(parent,text,position,size)
    local b = create("TextButton",parent,{
        Text=text,Position=position,Size=size,BackgroundColor3=Color3.fromRGB(38,65,100),
        TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=15,TextWrapped=true,
    })
    corner(b)
    return b
end
local frame = create("Frame",gui,{
    Size=UDim2.fromScale(.88,.85),Position=UDim2.fromScale(.5,.5),AnchorPoint=Vector2.new(.5,.5),
    BackgroundColor3=Color3.fromRGB(15,20,28),Visible=false,
})
corner(frame)
create("TextLabel",frame,{
    Text="SHOP PREVIEW & ACCESSORIES",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,
    TextSize=21,TextWrapped=true,BackgroundTransparency=1,Size=UDim2.fromScale(.82,.1),Position=UDim2.fromScale(.02,0),
})
local close = button(frame,"X",UDim2.fromScale(.9,.02),UDim2.fromScale(.08,.07))
local balance = create("TextLabel",frame,{
    Size=UDim2.fromScale(.95,.06),Position=UDim2.fromScale(.025,.1),BackgroundTransparency=1,
    TextColor3=Color3.fromRGB(130,255,180),Font=Enum.Font.GothamBold,TextSize=17,
})
local list = create("ScrollingFrame",frame,{
    Size=UDim2.fromScale(.36,.8),Position=UDim2.fromScale(.02,.18),BackgroundTransparency=1,
    BorderSizePixel=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=5,
})
create("UIListLayout",list,{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
local view = create("ViewportFrame",frame,{
    Size=UDim2.fromScale(.57,.48),Position=UDim2.fromScale(.41,.18),BackgroundColor3=Color3.fromRGB(32,42,60),
    Ambient=Color3.fromRGB(180,180,180),LightColor=Color3.new(1,1,1),
})
corner(view)
local camera = create("Camera",view,{FieldOfView=40})
view.CurrentCamera = camera
local title = create("TextLabel",frame,{
    Size=UDim2.fromScale(.57,.09),Position=UDim2.fromScale(.41,.66),BackgroundTransparency=1,
    TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=19,TextWrapped=true,
})
local message = create("TextLabel",frame,{
    Size=UDim2.fromScale(.57,.09),Position=UDim2.fromScale(.41,.75),BackgroundTransparency=1,
    TextColor3=Color3.fromRGB(200,215,235),Font=Enum.Font.Gotham,TextSize=14,TextWrapped=true,
    Text="Select an item on the left. Preview rotates automatically.",
})
local buy = button(frame,"Select an item",UDim2.fromScale(.41,.86),UDim2.fromScale(.36,.1))
local remove = button(frame,"Remove\naccessory",UDim2.fromScale(.79,.86),UDim2.fromScale(.19,.1))
local selected
local preview
local angle = 0
local radius = 10
local pending = false
local rows = {}
local function update()
    balance.Text = "Balance: " .. cash.Value .. " CHF | Items are owned for this server session"
    for _, item in ipairs(catalog) do
        local active = item.Kind and accessory.Value == item.Id or not item.Kind and equipped.Value == item.Id
        rows[item.Id].BackgroundColor3 = selected == item and Color3.fromRGB(50,105,145) or Color3.fromRGB(30,40,58)
        rows[item.Id].Text = item.Name .. " | " .. item.Price .. " CHF\n"
            .. (active and "Equipped" or (inventory:FindFirstChild(item.Id) or item.Id == "Default") and "Owned" or item.Category)
    end
    if not selected then return end
    title.Text = selected.Name .. " - " .. selected.Price .. " CHF"
    local active = selected.Kind and accessory.Value == selected.Id or not selected.Kind and equipped.Value == selected.Id
    local owned = selected.Id == "Default" or inventory:FindFirstChild(selected.Id)
    buy.Text = pending and "Please wait ..." or active and "Equipped" or owned and "Equip for free"
        or cash.Value >= selected.Price and "Buy & equip" or "Not enough CHF"
end
local function show(item)
    selected = item
    if preview then preview:Destroy() preview = nil end
    angle = 0
    local template = assets:FindFirstChild(item.Id)
    if template then
        preview = template:Clone()
        preview.Parent = view
        local _,size = preview:GetBoundingBox()
        radius = math.max(size.Magnitude*1.3,4)
        message.Text = template:GetAttribute("ExampleModel")
            and "Example chair: no Chair game seat was found in this map."
            or "Rotating 3D preview. Purchase only with the Buy button."
    else
        message.Text = "Preparing preview ..."
    end
    update()
end
for index,item in ipairs(catalog) do
    local row = button(list,item.Name,UDim2.new(),UDim2.new(1,-8,0,64))
    row.LayoutOrder = index
    rows[item.Id] = row
    row.Activated:Connect(function() show(item) end)
end
assets.ChildAdded:Connect(function(child)
    if frame.Visible and selected and selected.Id == child.Name then show(selected) end
end)
local function openPanel(item)
    frame.Visible = true
    show(item or selected or catalog[1])
end
local function closePanel()
    frame.Visible = false
    if preview then preview:Destroy() preview = nil end
end
close.Activated:Connect(closePanel)
RunService.RenderStepped:Connect(function(dt)
    if not frame.Visible or not preview then return end
    angle = angle + dt*.45
    camera.CFrame = CFrame.lookAt(Vector3.new(math.sin(angle)*radius,radius*.45,-math.cos(angle)*radius),Vector3.new())
end)
local function reply(status,text)
    if status ~= "OK" and status ~= "ERROR" then return end
    pending = false
    message.Text = tostring(text)
    message.TextColor3 = status == "ERROR" and Color3.fromRGB(255,150,150) or Color3.fromRGB(145,255,185)
    update()
end
event.OnClientEvent:Connect(reply)
oldEvent.OnClientEvent:Connect(reply)
buy.Activated:Connect(function()
    if not selected or pending then return end
    local active = selected.Kind and accessory.Value == selected.Id or not selected.Kind and equipped.Value == selected.Id
    if active then return end
    pending = true
    update()
    if selected.Kind then event:FireServer("BUY",selected.Id) else oldEvent:FireServer("BUY",selected.Id) end
    task.delay(2,function() pending = false update() end)
end)
remove.Activated:Connect(function() event:FireServer("UNEQUIP","") end)
cash.Changed:Connect(update)
equipped.Changed:Connect(update)
accessory.Changed:Connect(update)
inventory.ChildAdded:Connect(update)
inventory.ChildRemoved:Connect(update)
update()
-- Zusaetzlicher Einstieg im bisherigen Shop; bestehende Bedienelemente bleiben bestehen.
task.spawn(function()
    local oldGui = player.PlayerGui:WaitForChild("GuessPlayerGUI",15)
    local oldFrame = oldGui and oldGui:WaitForChild("ShopFrame",15)
    if not oldFrame then return end
    local entry = button(oldFrame,"Preview & accessories",UDim2.fromScale(.55,.17),UDim2.fromScale(.4,.1))
    entry.Name = "ShopExtensionEntry"
    entry.ZIndex = 32
    entry.Activated:Connect(function() openPanel() end)
end)
