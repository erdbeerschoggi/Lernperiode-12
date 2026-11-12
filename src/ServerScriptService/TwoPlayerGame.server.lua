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


-- Shop Items definieren 
local SHOP_ITEMS = {
	["Item 1"] = {Price = 100, Color = Color3.fromRGB(255, 80, 80)},  
	["Item 2"] = {Price = 250, Color = Color3.fromRGB(80, 150, 255)}  
}

-- Geld und Inventar für Spieler initialisieren
Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = 0 
	cash.Parent = leaderstats

	local inventory = Instance.new("Folder")
	inventory.Name = "Inventory"
	inventory.Parent = player

	local equippedChair = Instance.new("StringValue")
	equippedChair.Name = "EquippedChair"
	equippedChair.Value = "Default" 
	equippedChair.Parent = player
end)

-- Verarbeitet Kaufanfragen aus dem Shop
shopEvent.OnServerEvent:Connect(function(player, action, itemName)
	if action == "BUY" then
		local item = SHOP_ITEMS[itemName]
		if item then
			
			if player.Inventory:FindFirstChild(itemName) then
				player.EquippedChair.Value = itemName
				
			elseif player.leaderstats.Cash.Value >= item.Price then
				player.leaderstats.Cash.Value -= item.Price
				
				local ownedItem = Instance.new("StringValue")
				ownedItem.Name = itemName
				ownedItem.Parent = player.Inventory

				player.EquippedChair.Value = itemName
			end
			
		end
	end
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
		Position = "?",
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

			if humanoid.Parent
				and seat.Occupant ~= humanoid then

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

local function finishGame(
	pair,
	winner,
	loser
)

	if pair.finished then
		return
	end

	pair.finished = true

	-- 50 CHF an den Gewinner geben
	if winner:FindFirstChild("leaderstats") and winner.leaderstats:FindFirstChild("Cash") then
		winner.leaderstats.Cash.Value += 50
	end


	chairEvent:FireClient(
		winner,
		"WIN",
		pair.player1 == winner
			and pair.playerData1.Name
			or pair.playerData2.Name
	)

	chairEvent:FireClient(
		loser,
		"LOSE",
		pair.player1 == loser
			and pair.playerData1.Name
			or pair.playerData2.Name
	)

	task.wait(1)

	unlockPlayer(
		pair,
		pair.humanoid1
	)

	unlockPlayer(
		pair,
		pair.humanoid2
	)

	activeGames[pair.player1] = nil
	activeGames[pair.player2] = nil

	task.wait(2)

	pair.started = false
	pair.finished = false

	pair.player1 = nil
	pair.player2 = nil

	pair.humanoid1 = nil
	pair.humanoid2 = nil

	pair.playerData1 = nil
	pair.playerData2 = nil

	pair.oldSettings = {}

end


-- Stühle anpassen, wenn ein Spieler einen Skin aus dem Shop gekauft hat
local function applyChairSkin(player, chairModel)
	local equipped = player:FindFirstChild("EquippedChair")
	if equipped and SHOP_ITEMS[equipped.Value] then
		local newColor = SHOP_ITEMS[equipped.Value].Color
		for _, part in ipairs(chairModel:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Color = newColor
			end
		end
	end
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

				local football1, football2 =
					randomPlayerPair()

				pair.started = true

				pair.player1 =
					player1

				pair.player2 =
					player2

				pair.humanoid1 =
					humanoid1

				pair.humanoid2 =
					humanoid2

				pair.playerData1 =
					football1

				pair.playerData2 =
					football2

				activeGames[player1] =
					pair

				activeGames[player2] =
					pair

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

				-- gekaufte Stuhl-Skins anwenden
				applyChairSkin(player1, seat1.Parent)
				applyChairSkin(player2, seat2.Parent)

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

				chairEvent:FireClient(
					player1,
					"PLAYER_DATA",
					football2
				)

				chairEvent:FireClient(
					player2,
					"PLAYER_DATA",
					football1
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