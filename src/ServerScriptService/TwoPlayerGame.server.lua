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

local shopEvent = ReplicatedStorage:FindFirstChild("ShopEvent")
if not shopEvent then
	shopEvent = Instance.new("RemoteEvent")
	shopEvent.Name = "ShopEvent"
	shopEvent.Parent = ReplicatedStorage
end

-- Existing item IDs and prices are kept.
local SHOP_ITEMS = {
	["Default"] = {Name = "standard", Price = 0},
	["Item 1"] = {Name = "red", Price = 100, Color = Color3.fromRGB(255, 80, 80)},
	["Item 2"] = {Name = "blue", Price = 250, Color = Color3.fromRGB(80, 150, 255)},
	["Item 3"] = {Name = "green", Price = 150, Color = Color3.fromRGB(65, 195, 110)},
	["Item 4"] = {Name = "purple", Price = 350, Color = Color3.fromRGB(165, 90, 225)},
	["Item 5"] = {Name = "gold", Price = 500, Color = Color3.fromRGB(245, 195, 55)},
}

-- Only change colors: do not replace, move or recreate seats.
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

-- Reuse existing values; never reset money on initialization.
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

-- Use the existing ShopEvent; no second money system.
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

	-- Check ownership first: selecting an owned color is always free.
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

	-- No wait between the balance check and the deduction.
	cash.Value = cash.Value - item.Price
	local ownedItem = Instance.new("StringValue")
	ownedItem.Name = itemName
	ownedItem.Value = itemName
	ownedItem.Parent = inventory
	equipped.Value = itemName
	updateSeatedChair(player)
	shopEvent:FireClient(player, "OK", item.Name .. " purchased and selected.")
end)

local footballPlayers = {
	{
		Name = "Cristiano Ronaldo",
		Age = 41,
		Nationality = "Portugal",
		Club = "Al Nassr",
		Number = 7,
		LeagueTitles = 8,
		UCL = 5,
		WorldCups = 0,
		Euros = 1,
		Position = "striker",
		BallonDor = 5
	},

	{
		Name = "Lionel Messi",
		Age = 39,
		Nationality = "Argentina",
		Club = "Inter Miami",
		Number = 10,
		LeagueTitles = 13,
		UCL = 4,
		WorldCups = 1,
		Euros = 0,
		Position = "winger",
		BallonDor = 8
	},

	{
		Name = "Kylian Mbappe",
		Age = 27,
		Nationality = "France",
		Club = "Real Madrid",
		Number = 10,
		LeagueTitles = 7,
		UCL = 0,
		WorldCups = 1,
		Euros = 0,
		Position = "striker",
		BallonDor = 0
	},

	{
		Name = "Erling Haaland",
		Age = 26,
		Nationality = "Norway",
		Club = "Manchester City",
		Number = 9,
		LeagueTitles = 4,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "striker",
		BallonDor = 0
	},

	{
		Name = "Lamine Yamal",
		Age = 19,
		Nationality = "Spain",
		Club = "Barcelona",
		Number = 10,
		LeagueTitles = 3,
		UCL = 0,
		WorldCups = 1,
		Euros = 1,
		Position = "winger",
		BallonDor = 0
	},

	{
		Name = "Jude Bellingham",
		Age = 23,
		Nationality = "England",
		Club = "Real Madrid",
		Number = 5,
		LeagueTitles = 1,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Michael Olise",
		Age = 24,
		Nationality = "France",
		Club = "Bayern München",
		Number = 17,
		LeagueTitles = 2,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Robert Lewandowski",
		Age = 38,
		Nationality = "Poland",
		Club = "Chicago Fire",
		Number = 9,
		LeagueTitles = 14,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "striker",
		BallonDor = 0
	},

	{
		Name = "Neymar Jr.",
		Age = 34,
		Nationality = "Brazil",
		Club = "Santos FC",
		Number = 10,
		LeagueTitles = 8,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "winger",
		BallonDor = 0
	},

	{
		Name = "Jamal Musiala",
		Age = 24,
		Nationality = "Germany",
		Club = "Bayern München",
		Number = 10,
		LeagueTitles = 6,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Vinicius jr",
		Age = 26,
		Nationality = "Brazil",
		Club = "Real Madrid",
		Number = 7,
		LeagueTitles = 2,
		UCL = 2,
		WorldCups = 0,
		Euros = 0,
		Position = "winger",
		BallonDor = 0
	},

	{
		Name = "Luka Modric",
		Age = 41,
		Nationality = "Croatia",
		Club = "Ac Milan",
		Number = 14,
		LeagueTitles = 7,
		UCL = 6,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 1
	},

	{
		Name = "Kevin de Bruyne",
		Age = 35,
		Nationality = "Belgium",
		Club = "SSC Neapel",
		Number = 11,
		LeagueTitles = 7,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Harry Kane",
		Age = 33,
		Nationality = "England",
		Club = "Bayern München",
		Number = 9,
		LeagueTitles = 2,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Striker",
		BallonDor = 1
	},

	{
		Name = "Manuel Neuer",
		Age = 40,
		Nationality = "Germany",
		Club = "Bayern München",
		Number = 1,
		LeagueTitles = 13,
		UCL = 2,
		WorldCups = 1,
		Euros = 0,
		Position = "Goalkeeper",
		BallonDor = 0
	},

	{
		Name = "Thomas Müller",
		Age = 37,
		Nationality = "Germany",
		Club = "Vancouver Whitecaps",
		Number = 13,
		LeagueTitles = 12,
		UCL = 2,
		WorldCups = 1,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Mohamed Salah",
		Age = 34,
		Nationality = "Egypt",
		Club = "Trabzonspor",
		Number = 11,
		LeagueTitles = 4,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "winger",
		BallonDor = 0
	},

	{
		Name = "Karim Benzema",
		Age = 38,
		Nationality = "France",
		Club = "Al-Hilal",
		Number = 9,
		LeagueTitles = 9,
		UCL = 5,
		WorldCups = 0,
		Euros = 0,
		Position = "striker",
		BallonDor = 1
	},

	{
		Name = "Xherdan Shaqiri",
		Age = 35,
		Nationality = "Switzerland",
		Club = "Fc Basel",
		Number = 10,
		LeagueTitles = 6,
		UCL = 2,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Ousmane Dembélé",
		Age = 29,
		Nationality = "France",
		Club = "PSG",
		Number = 10,
		LeagueTitles = 4,
		UCL = 1,
		WorldCups = 1,
		Euros = 0,
		Position = "striker/winger",
		BallonDor = 0
	}
}

local spawnLocation = workspace:FindFirstChildWhichIsA("SpawnLocation", true)

if spawnLocation then

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {spawnLocation}

	local result = workspace:Raycast(
		spawnLocation.Position + Vector3.new(0, 5, 0),
		Vector3.new(0, -500, 0),
		params
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

		local function createWall(size, offset)

			local wall = Instance.new("Part")
			wall.Size = size
			wall.Anchored = true
			wall.CanCollide = true
			wall.CanTouch = false
			wall.CanQuery = false
			wall.Transparency = 1
			wall.CFrame = ground.CFrame * CFrame.new(offset)
			wall.Parent = folder

		end

		local y =
			ground.Size.Y / 2
			+ wallHeight / 2

		createWall(
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

-- Update colors independent of the round state, also when standing up.
for _, seat in ipairs(seats) do
	local function refreshColor()
		local humanoid = seat.Occupant
		local seatedPlayer = humanoid and Players:GetPlayerFromCharacter(humanoid.Parent)
		applyChairSkin(seatedPlayer, seat.Parent)
	end
	seat:GetPropertyChangedSignal("Occupant"):Connect(refreshColor)
	refreshColor()
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
				playerData1 = nil,
				playerData2 = nil,
				oldSettings = {}
			})

		end

	end

end

local activeGames = {}
local pendingQuestions = {}

local function randomPlayerPair()

	local first =
		math.random(
			1,
			#footballPlayers
		)

	local second =
		math.random(
			1,
			#footballPlayers
		)

	while second == first do

		second =
			math.random(
				1,
				#footballPlayers
			)

	end

	return footballPlayers[first], footballPlayers[second]

end
local function lockPlayer(pair, humanoid, seat)

	if not pair.oldSettings[humanoid] then
		pair.oldSettings[humanoid] = {
			JumpPower = humanoid.JumpPower,
			JumpHeight = humanoid.JumpHeight,
			AutoRotate = humanoid.AutoRotate
		}
	end

	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0
	humanoid.AutoRotate = false

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)

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

	if not humanoid
		or not humanoid.Parent then
		return
	end

	local old =
		pair.oldSettings[humanoid]

	if old then

		humanoid.JumpPower =
			old.JumpPower

		humanoid.JumpHeight =
			old.JumpHeight

		humanoid.AutoRotate =
			old.AutoRotate

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

	local pair =
		activeGames[player]

	if not pair then
		return nil
	end

	if pair.player1 == player then
		return pair.player2
	end

	return pair.player1

end

local function getOwnFootballPlayer(player)

	local pair =
		activeGames[player]

	if not pair then
		return nil
	end

	if pair.player1 == player then
		return pair.playerData1
	end

	return pair.playerData2

end

local function normalize(text)

	text =
		tostring(text or "")

	text = text:gsub("Ä", "a")
	text = text:gsub("ä", "a")
	text = text:gsub("Ö", "o")
	text = text:gsub("ö", "o")
	text = text:gsub("Ü", "u")
	text = text:gsub("ü", "u")
	text = text:gsub("É", "e")
	text = text:gsub("é", "e")
	text = text:gsub("È", "e")
	text = text:gsub("è", "e")
	text = text:gsub("Á", "a")
	text = text:gsub("á", "a")

	text =
		string.lower(text)

	text =
		string.gsub(
			text,
			"^%s*(.-)%s*$",
			"%1"
		)

	return text

end

local function isCorrectGuess(guess, playerData)

	local guessed =
		normalize(guess)

	local correct =
		normalize(playerData.Name)

	if guessed == correct then
		return true
	end

	if #guessed >= 4
		and string.find(
			correct,
			guessed,
			1,
			true
		)
	then
		return true
	end

	return false

end

local function filterText(
	text,
	fromPlayer,
	toPlayer
)

	if typeof(text) ~= "string" then
		return nil
	end

	text =
		string.sub(
			text,
			1,
			100
		)

	local success, result =
		pcall(function()

			return TextService:FilterStringAsync(
				text,
				fromPlayer.UserId,
				Enum.TextFilterContext.PrivateChat
			)

		end)

	if not success then
		return nil
	end

	local success2, filtered =
		pcall(function()

			return result:GetNonChatStringForUserAsync(
				toPlayer.UserId
			)

		end)

	if success2 then
		return filtered
	end

	return nil

end
local function beginRound(pair, player1, player2, humanoid1, humanoid2)

	local football1, football2 = randomPlayerPair()

	pair.started = true
	pair.finished = false
	pair.rematchOpen = false

	pair.player1 = player1
	pair.player2 = player2
	pair.humanoid1 = humanoid1
	pair.humanoid2 = humanoid2
	pair.playerData1 = football1
	pair.playerData2 = football2

	activeGames[player1] = pair
	activeGames[player2] = pair

	pendingQuestions[player1] = nil
	pendingQuestions[player2] = nil

	lockPlayer(pair, humanoid1, pair.seat1)
	lockPlayer(pair, humanoid2, pair.seat2)

	applyChairSkin(player1, pair.seat1.Parent)
	applyChairSkin(player2, pair.seat2.Parent)

	chairEvent:FireClient(player1, "START", player2.Name)
	chairEvent:FireClient(player2, "START", player1.Name)

	chairEvent:FireClient(player1, "PLAYER_DATA", football2)
	chairEvent:FireClient(player2, "PLAYER_DATA", football1)

end

local REMATCH_TIME = 15

local function finishGame(pair, winner, loser)

	if pair.finished then
		return
	end

	pair.finished = true

	-- Give 50 CHF to the winner
	if winner:FindFirstChild("leaderstats") and winner.leaderstats:FindFirstChild("Cash") then
		winner.leaderstats.Cash.Value += 50
	end

	chairEvent:FireClient(winner, "WIN",
		pair.player1 == winner and pair.playerData1.Name or pair.playerData2.Name)

	chairEvent:FireClient(loser, "LOSE",
		pair.player1 == loser and pair.playerData1.Name or pair.playerData2.Name)

	pendingQuestions[pair.player1] = nil
	pendingQuestions[pair.player2] = nil

	-- ===== REMATCH ABSTIMMUNG =====
	local p1, p2 = pair.player1, pair.player2
	local h1, h2 = pair.humanoid1, pair.humanoid2

	pair.votes = {}
	pair.rematchOpen = true

	chairEvent:FireClient(p1, "REMATCH_PROMPT", 0)
	chairEvent:FireClient(p2, "REMATCH_PROMPT", 0)

	local function yesCount()
		return (pair.votes[p1] == true and 1 or 0) + (pair.votes[p2] == true and 1 or 0)
	end

	local result = "TIMEOUT"
	local startTime = os.clock()

	while os.clock() - startTime < REMATCH_TIME do
		if not p1.Parent or not p2.Parent then
			result = "LEFT"
			break
		end
		if pair.votes[p1] == false or pair.votes[p2] == false then
			result = "DECLINED"
			break
		end
		if yesCount() == 2 then
			result = "REMATCH"
			break
		end
		if not h1.Parent or not h2.Parent
			or pair.seat1.Occupant ~= h1 or pair.seat2.Occupant ~= h2 then
			result = "LEFT"
			break
		end
		task.wait(0.2)
	end

	pair.rematchOpen = false

	if result == "REMATCH" then
		task.wait(0.5)
		beginRound(pair, p1, p2, h1, h2)
		return
	end

	-- Kein Rematch -> aufräumen wie vorher
	local message = "No rematch."
	if result == "LEFT" then
		message = "Opponent left."
	elseif result == "DECLINED" then
		message = "Rematch declined."
	end

	for _, p in ipairs({p1, p2}) do
		if p.Parent then
			chairEvent:FireClient(p, "REMATCH_END", message)
		end
	end

	unlockPlayer(pair, h1)
	unlockPlayer(pair, h2)

	pendingQuestions[p1] = nil
	pendingQuestions[p2] = nil
	activeGames[p1] = nil
	activeGames[p2] = nil

	task.wait(2)

	pair.started = false
	pair.finished = false
	pair.rematchOpen = false
	pair.votes = nil

	pair.player1 = nil
	pair.player2 = nil
	pair.humanoid1 = nil
	pair.humanoid2 = nil
	pair.playerData1 = nil
	pair.playerData2 = nil
	pair.oldSettings = {}

end


local function setupPair(pair)

	local seat1 = pair.seat1
	local seat2 = pair.seat2

	local function update()

		if pair.started then
			return
		end

		local humanoid1 =
			seat1.Occupant

		local humanoid2 =
			seat2.Occupant

		if humanoid1
			and not humanoid2 then

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

		if humanoid2
			and not humanoid1 then

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
				beginRound(pair, player1, player2, humanoid1, humanoid2)
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

		if action == "REMATCH" then
			local rematchPair = activeGames[player]
			if not rematchPair or not rematchPair.rematchOpen then return end
			if typeof(value) ~= "boolean" then return end
			if rematchPair.votes[player] ~= nil then return end

			rematchPair.votes[player] = value

			local yes = 0
			for _, p in ipairs({rematchPair.player1, rematchPair.player2}) do
				if rematchPair.votes[p] == true then yes += 1 end
			end

			for _, p in ipairs({rematchPair.player1, rematchPair.player2}) do
				if p.Parent then
					chairEvent:FireClient(p, "REMATCH_UPDATE", yes)
				end
			end
			return
		end

		local pair =
			activeGames[player]

		if not pair
			or not pair.started
			or pair.finished then
			return
		end

		local opponent =
			getOpponent(player)

		if not opponent then
			return
		end

		if action == "QUESTION" then
			if typeof(value) ~= "string" or value:match("^%s*$") then
				return
			end

			local filtered = filterText(value, player, opponent)
			if not filtered then
				return
			end

			pendingQuestions[opponent] = (pendingQuestions[opponent] or 0) + 1
			chairEvent:FireClient(opponent, "OPPONENT_QUESTION", filtered)

		elseif action == "ANSWER" then
			if typeof(value) ~= "string" or value:match("^%s*$") then
				return
			end

			local questionNumber = pendingQuestions[player]
			if not questionNumber then
				chairEvent:FireClient(player, "ANSWER_ERROR", "No question to answer yet.")
				return
			end

			local filtered = filterText(value, player, opponent)
			if not filtered then
				chairEvent:FireClient(player, "ANSWER_ERROR", "Your answer could not be sent.")
				return
			end

			if not pair.started or pair.finished or activeGames[player] ~= pair then
				return
			end
			if pendingQuestions[player] ~= questionNumber then
				chairEvent:FireClient(player, "ANSWER_ERROR", "A newer question arrived. Please answer that one.")
				return
			end

			pendingQuestions[player] = nil
			chairEvent:FireClient(opponent, "OPPONENT_ANSWER", filtered)
			chairEvent:FireClient(player, "ANSWER_SENT")

		elseif action == "GUESS" then

			if typeof(value)
				~= "string" then
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

			local ownFootballPlayer =
				getOwnFootballPlayer(
					player
				)

			if ownFootballPlayer
				and isCorrectGuess(
					value,
					ownFootballPlayer
				)
			then

				task.spawn(function()

					finishGame(
						pair,
						player,
						opponent
					)

				end)

			else

				chairEvent:FireClient(
					player,
					"WRONG_GUESS"
				)

			end

		end

	end
)