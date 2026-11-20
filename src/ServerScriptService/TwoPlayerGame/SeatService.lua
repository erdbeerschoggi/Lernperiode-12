-- Findet alle Spiel-Sitze in der Map und bildet Paare 
local Players = game:GetService("Players")

local ShopService = require(script.Parent.ShopService)
local applyChairSkin = ShopService.applyChairSkin

local SeatService = {}

-- Gibt die Liste aller Paare zurück
function SeatService.build()
	local seats = {}

	for _, object in ipairs(workspace:GetDescendants()) do

		if object:IsA("Seat") then

			local chair = object.Parent

			if chair and string.match(chair.Name, "^Chair") then
				table.insert(seats, object)
			end

		end

	end

	for _, seat in ipairs(seats) do
		local function refreshColor()
			local humanoid = seat.Occupant
			local seatedPlayer = humanoid and Players:GetPlayerFromCharacter(humanoid.Parent)
			applyChairSkin(seatedPlayer, seat.Parent)
		end
		seat:GetPropertyChangedSignal("Occupant"):Connect(refreshColor)
		refreshColor()
	end

	local pairList = {}
	local used = {}

	for _, seat1 in ipairs(seats) do

		if not used[seat1] then

			local closestSeat = nil
			local closestDistance = math.huge

			for _, seat2 in ipairs(seats) do

				if seat2 ~= seat1 and not used[seat2] then

					local distance =
						(seat1.Position - seat2.Position).Magnitude

					if distance < closestDistance then
						closestDistance = distance
						closestSeat = seat2
					end

				end

			end

			if closestSeat then

				used[seat1] = true
				used[closestSeat] = true

				table.insert(pairList, {
					seat1 = seat1,
					seat2 = closestSeat,
					started = false,
					finished = false,
					player1 = nil,
					player2 = nil,
					humanoid1 = nil,
					humanoid2 = nil,
					playerData1 = nil,
					playerData2 = nil,
					oldSettings = {}
				})

			end

		end

	end

	return pairList
end

return SeatService