local Widgets = {}
Widgets.colors = {
    panel = Color3.fromRGB(15,23,38), card = Color3.fromRGB(26,38,57), input = Color3.fromRGB(9,16,28),
    text = Color3.fromRGB(245,248,255), muted = Color3.fromRGB(190,205,225),
    blue = Color3.fromRGB(47,112,206), green = Color3.fromRGB(27,123,79), red = Color3.fromRGB(166,55,65),
}
function Widgets.create(class, parent, properties)
    local obj = Instance.new(class)
    for key, value in pairs(properties or {}) do obj[key] = value end
    obj.Parent = parent
    return obj
end
function Widgets.corner(obj, radius)
    Widgets.create("UICorner", obj, {CornerRadius = UDim.new(0,radius or 10)})
end
function Widgets.padding(obj, amount)
    Widgets.create("UIPadding",obj,{
        PaddingTop=UDim.new(0,amount),PaddingBottom=UDim.new(0,amount),
        PaddingLeft=UDim.new(0,amount),PaddingRight=UDim.new(0,amount),
    })
end
function Widgets.text(parent, name, value, size, bold)
    return Widgets.create("TextLabel",parent,{
        Name=name,Text=value,TextSize=size or 16,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextColor3=Widgets.colors.text,BackgroundTransparency=1,RichText=false,TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,
    })
end
function Widgets.button(parent, name, value, color)
    local obj = Widgets.create("TextButton",parent,{
        Name=name,Text=value,TextSize=16,Font=Enum.Font.GothamBold,TextColor3=Widgets.colors.text,
        BackgroundColor3=color or Widgets.colors.blue,AutoButtonColor=true,TextWrapped=true,RichText=false,
        Size=UDim2.fromOffset(140,44),Selectable=true,
    })
    Widgets.corner(obj)
    return obj
end
function Widgets.input(parent, name, placeholder)
    local obj = Widgets.create("TextBox",parent,{
        Name=name,Text="",PlaceholderText=placeholder,TextSize=17,Font=Enum.Font.Gotham,
        TextColor3=Widgets.colors.text,PlaceholderColor3=Widgets.colors.muted,BackgroundColor3=Widgets.colors.input,
        ClearTextOnFocus=false,MultiLine=false,TextXAlignment=Enum.TextXAlignment.Left,RichText=false,
    })
    Widgets.corner(obj)
    Widgets.padding(obj,10)
    return obj
end
function Widgets.enabled(button, enabled)
    button.Active = enabled
    button.Selectable = enabled
    button.AutoButtonColor = enabled
    button.BackgroundTransparency = enabled and 0 or .6
    button.TextTransparency = enabled and 0 or .35
end
return Widgets
