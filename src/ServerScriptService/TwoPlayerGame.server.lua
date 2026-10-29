local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local chairEvent = ReplicatedStorage:FindFirstChild("ChairGameEvent")

if not chairEvent then
	chairEvent = Instance.new("RemoteEvent")
	chairEvent.Name = "ChairGameEvent"
	chairEvent.Parent = ReplicatedStorage
end

local actionEvent = ReplicatedStorage:FindFirstChild("GameActionEvent")

if not actionEvent then
	actionEvent = Instance.new("RemoteEvent")
	actionEvent.Name = "GameActionEvent"
	actionEvent.Parent = ReplicatedStorage
end

local CORRECT_GUESS = "ok"

local spawnLocation = workspace:FindFirstChildWhichIsA("SpawnLocation", true)

if spawnLocation then

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {spawnLocation}

	local result = workspace:Raycast(
		spawnLocation.Position + Vector3.new(0, 5, 0),
		Vector3.new(0, -500, 0),
		raycastParams
	)

	if result and result.Instance and result.Instance:IsA("BasePart") then

		local ground = result.Instance

		local oldWalls = workspace:FindFirstChild("MapBoundaryWalls")

		if oldWalls then
			oldWalls:Destroy()
		end

		local folder = Instance.new("Folder")
		folder.Name = "MapBoundaryWalls"
		folder.Parent = workspace

		local wallHeight = 40
		local wallThickness = 2

		local function createWall(name, size, offset)

			local wall = Instance.new("Part")

			wall.Name = name
			wall.Size = size
			wall.Anchored = true
			wall.CanCollide = true
			wall.CanTouch = false
			wall.CanQuery = false
			wall.Transparency = 1

			wall.CFrame =
				ground.CFrame
				* CFrame.new(offset)

			wall.Parent = folder

		end

		local y =
			ground.Size.Y / 2
			+ wallHeight / 2

		createWall(
			"FrontWall",
			Vector3.new(
				ground.Size.X,
				wallHeight,
				wallThickness
			),
			Vector3.new(
				0,
				y,
				-ground.Size.Z / 2
			)
		)

		createWall(
			"BackWall",
			Vector3.new(
				ground.Size.X,
				wallHeight,
				wallThickness
			),
			Vector3.new(
				0,
				y,
				ground.Size.Z / 2
			)
		)

		createWall(
			"LeftWall",
			Vector3.new(
				wallThickness,
				wallHeight,
				ground.Size.Z
			),
			Vector3.new(
				-ground.Size.X / 2,
				y,
				0
			)
		)

		createWall(
			"RightWall",
			Vector3.new(
				wallThickness,
				wallHeight,
				ground.Size.Z
			),
			Vector3.new(
				ground.Size.X / 2,
				y,
				0
			)
		)

	end

end

local seats = {}

for _, object in ipairs(workspace:GetDescendants()) do

	if object:IsA("Seat") then

		local chair = object.Parent

		if chair and string.match(chair.Name, "^Chair") then
			table.insert(seats, object)
		end

	end

end

local pairs = {}
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

			table.insert(pairs, {
				seat1 = seat1,
				seat2 = closestSeat,
				started = false,
				finished = false,
				player1 = nil,
				player2 = nil,
				humanoid1 = nil,
				humanoid2 = nil,
				oldSettings = {}
			})

		end

	end

end

local activeGames = {}

local function lockPlayer(pair, humanoid, seat)

	pair.oldSettings[humanoid] = {
		JumpPower = humanoid.JumpPower,
		JumpHeight = humanoid.JumpHeight,
		AutoRotate = humanoid.AutoRotate
	}

	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0
	humanoid.AutoRotate = false

	humanoid:SetStateEnabled(
		Enum.HumanoidStateType.Jumping,
		false
	)

	task.spawn(function()

		while pair.started and not pair.finished do

			if humanoid.Parent and seat.Occupant ~= humanoid then
				seat:Sit(humanoid)
			end

			task.wait(0.1)

		end

	end)

end

local function unlockPlayer(pair, humanoid)

	if not humanoid or not humanoid.Parent then
		return
	end

	local old = pair.oldSettings[humanoid]

	if old then

		humanoid.JumpPower = old.JumpPower
		humanoid.JumpHeight = old.JumpHeight
		humanoid.AutoRotate = old.AutoRotate

	end

	humanoid:SetStateEnabled(
		Enum.HumanoidStateType.Jumping,
		true
	)

	humanoid.Sit = false

	humanoid:ChangeState(
		Enum.HumanoidStateType.GettingUp
	)

end

local function getOpponent(player)

	local pair = activeGames[player]

	if not pair then
		return nil
	end

	if pair.player1 == player then
		return pair.player2
	end

	if pair.player2 == player then
		return pair.player1
	end

	return nil

end

local function filterText(text, fromPlayer, toPlayer)

	if typeof(text) ~= "string" then
		return nil
	end

	text = string.sub(text, 1, 100)

	local success, result = pcall(function()

		return TextService:FilterStringAsync(
			text,
			fromPlayer.UserId,
			Enum.TextFilterContext.PrivateChat
		)

	end)

	if not success then
		return nil
	end

	local success2, filtered = pcall(function()

		return result:GetNonChatStringForUserAsync(
			toPlayer.UserId
		)

	end)

	if success2 then
		return filtered
	end

	return nil

end

local function finishGame(pair, winner, loser)

	if pair.finished then
		return
	end

	pair.finished = true

	chairEvent:FireClient(
		winner,
		"WIN"
	)

	chairEvent:FireClient(
		loser,
		"LOSE"
	)

	task.wait(1)

	unlockPlayer(pair, pair.humanoid1)
	unlockPlayer(pair, pair.humanoid2)

	activeGames[pair.player1] = nil
	activeGames[pair.player2] = nil

	task.wait(2)

	pair.started = false
	pair.finished = false

	pair.player1 = nil
	pair.player2 = nil

	pair.humanoid1 = nil
	pair.humanoid2 = nil

	pair.oldSettings = {}

end

local function setupPair(pair)

	local seat1 = pair.seat1
	local seat2 = pair.seat2

	local function update()

		if pair.started then
			return
		end

		local humanoid1 = seat1.Occupant
		local humanoid2 = seat2.Occupant

		if humanoid1 and not humanoid2 then

			local player =
				Players:GetPlayerFromCharacter(
					humanoid1.Parent
				)

			if player then
				chairEvent:FireClient(
					player,
					"WAITING"
				)
			end

		end

		if humanoid2 and not humanoid1 then

			local player =
				Players:GetPlayerFromCharacter(
					humanoid2.Parent
				)

			if player then
				chairEvent:FireClient(
					player,
					"WAITING"
				)
			end

		end

		if humanoid1 and humanoid2 then

			local player1 =
				Players:GetPlayerFromCharacter(
					humanoid1.Parent
				)

			local player2 =
				Players:GetPlayerFromCharacter(
					humanoid2.Parent
				)

			if player1 and player2 then

				pair.started = true

				pair.player1 = player1
				pair.player2 = player2

				pair.humanoid1 = humanoid1
				pair.humanoid2 = humanoid2

				activeGames[player1] = pair
				activeGames[player2] = pair

				lockPlayer(
					pair,
					humanoid1,
					seat1
				)

				lockPlayer(
					pair,
					humanoid2,
					seat2
				)

				chairEvent:FireClient(
					player1,
					"START",
					player2.Name
				)

				chairEvent:FireClient(
					player2,
					"START",
					player1.Name
				)

			end

		end

	end

	seat1:GetPropertyChangedSignal(
		"Occupant"
	):Connect(update)

	seat2:GetPropertyChangedSignal(
		"Occupant"
	):Connect(update)

end

for _, pair in ipairs(pairs) do
	setupPair(pair)
end

actionEvent.OnServerEvent:Connect(
	function(player, action, value)

		local pair = activeGames[player]

		if not pair
			or not pair.started
			or pair.finished then
			return
		end

		local opponent = getOpponent(player)

		if not opponent then
			return
		end

		if action == "QUESTION" then

			local filtered =
				filterText(
					value,
					player,
					opponent
				)

			if filtered then

				chairEvent:FireClient(
					opponent,
					"OPPONENT_QUESTION",
					filtered
				)

			end

		elseif action == "ANSWER" then

			if value ~= "YES"
				and value ~= "NO" then
				return
			end

			chairEvent:FireClient(
				opponent,
				"OPPONENT_ANSWER",
				value
			)

		elseif action == "GUESS" then

			if typeof(value) ~= "string" then
				return
			end

			local filtered =
				filterText(
					value,
					player,
					opponent
				)

			if filtered then

				chairEvent:FireClient(
					opponent,
					"OPPONENT_GUESS",
					filtered
				)

			end

			local guess =
				string.lower(
					string.gsub(
						value,
						"^%s*(.-)%s*$",
						"%1"
					)
				)

			if guess == CORRECT_GUESS then

				task.spawn(function()

					finishGame(
						pair,
						player,
						opponent
					)

				end)

			end

		end

	end
)