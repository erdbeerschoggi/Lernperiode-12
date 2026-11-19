-- Neue RemoteEvents bitte hier eintragen.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getOrCreate(name)
	local event = ReplicatedStorage:FindFirstChild(name)
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = name
		event.Parent = ReplicatedStorage
	end
	return event
end

return {
	Chair = getOrCreate("ChairGameEvent"),  
	Action = getOrCreate("GameActionEvent"), 
	Shop = getOrCreate("ShopEvent"),        
}
