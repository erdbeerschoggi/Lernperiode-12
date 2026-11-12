-- Ein Modell fuer Ausstellung, Vorschau und getragenes Accessoire.
local Models = {}
local gold = Color3.fromRGB(245,195,55)
local blue = Color3.fromRGB(60,150,255)
local dark = Color3.fromRGB(25,30,45)
local function part(model, name, size, position, color, material)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = CFrame.new(position)
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Parent = model
    return p
end
function Models.accessory(kind)
    local m = Instance.new("Model")
    m.Name = "ShopExtensionAccessory"
    if kind == "Crown" then
        part(m,"Vorne",Vector3.new(2.1,.28,.16),Vector3.new(0,.65,-.6),gold,Enum.Material.Metal)
        part(m,"Hinten",Vector3.new(2.1,.28,.16),Vector3.new(0,.65,.6),gold,Enum.Material.Metal)
        for _, x in ipairs({-1,1}) do
            part(m,"Seite",Vector3.new(.16,.28,1.2),Vector3.new(x,.65,0),gold,Enum.Material.Metal)
        end
        for _, x in ipairs({-.85,0,.85}) do
            part(m,"Zacke",Vector3.new(.22,.55,.2),Vector3.new(x,1,-.6),gold,Enum.Material.Metal)
            local jewel = part(m,"Edelstein",Vector3.new(.18,.18,.18),Vector3.new(x,.72,-.72),blue,Enum.Material.Neon)
            jewel.Shape = Enum.PartType.Ball
        end
    elseif kind == "Headphones" then
        part(m,"Buegel",Vector3.new(2.55,.22,.38),Vector3.new(0,.68,0),dark)
        for _, x in ipairs({-1.2,1.2}) do
            part(m,"Band",Vector3.new(.2,.85,.38),Vector3.new(x,.28,0),dark)
            part(m,"Ohrmuschel",Vector3.new(.45,.85,.65),Vector3.new(x,-.1,0),blue)
        end
    elseif kind == "Backpack" then
        part(m,"Tasche",Vector3.new(1.65,1.9,.6),Vector3.new(0,0,0),blue)
        part(m,"Fach",Vector3.new(1.3,.75,.25),Vector3.new(0,-.4,.4),dark)
        part(m,"Griff",Vector3.new(.7,.15,.25),Vector3.new(0,1.05,0),dark)
        for _, x in ipairs({-.6,.6}) do
            part(m,"Gurt",Vector3.new(.18,1.7,.12),Vector3.new(x,0,-.36),dark)
        end
    end
    m.WorldPivot = CFrame.new()
    return m
end
function Models.chair(source, color)
    local m = Instance.new("Model")
    m.Name = "Ausstellungsmodell"
    if source then
        -- Nur Geometrie kopieren: keine Scripts, Seats oder Spiellogik.
        for _, original in ipairs(source:GetDescendants()) do
            if original:IsA("BasePart") then
                local p
                if original:IsA("Seat") or original:IsA("VehicleSeat") then
                    p = Instance.new("Part")
                    p.Size = original.Size
                    p.CFrame = original.CFrame
                    p.Color = original.Color
                    p.Material = original.Material
                else
                    p = original:Clone()
                    if p then p:ClearAllChildren() end
                end
                if p then
                    p.Anchored = true
                    p.CanCollide = false
                    p.CanTouch = false
                    p.CanQuery = false
                    if color and not original:GetAttribute("KeepShopColor") then p.Color = color end
                    p.Parent = m
                end
            end
        end
    end
    if #m:GetChildren() == 0 then
        -- ZIP enthaelt keine Map. Ersatz, wenn im Studio kein Chair-Modell existiert.
        m:SetAttribute("ExampleModel", true)
        local c = color or Color3.fromRGB(115,120,130)
        part(m,"Sitz",Vector3.new(3,.4,3),Vector3.new(0,2,0),c)
        part(m,"Lehne",Vector3.new(3,3,.35),Vector3.new(0,3.5,1.35),c)
        for _, x in ipairs({-1.2,1.2}) do
            for _, z in ipairs({-1.2,1.2}) do
                part(m,"Bein",Vector3.new(.3,2,.3),Vector3.new(x,1,z),c)
            end
        end
    end
    local box = m:GetBoundingBox()
    m.WorldPivot = box
    m:PivotTo(CFrame.new())
    return m
end
return Models
