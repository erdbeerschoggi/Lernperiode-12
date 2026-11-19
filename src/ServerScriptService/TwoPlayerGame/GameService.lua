-- Spielablauf: Runden starten/beenden, Rematch, Fragen/Antworten/Rateversuche.
local Players = game:GetService("Players")

local Remotes = require(script.Parent.Remotes)
local ShopService = require(script.Parent.ShopService)
local SeatService = require(script.Parent.SeatService)
local FootballPlayers = require(script.Parent.FootballPlayers)
local TextUtils = require(script.Parent.TextUtils)

local chairEvent = Remotes.Chair
local actionEvent = Remotes.Action
local applyChairSkin = ShopService.applyChairSkin
local randomPlayerPair = FootballPlayers.randomPair
local isCorrectGuess = TextUtils.isCorrectGuess
local filterText = TextUtils.filterText

local GameService = {}

local activeGames = {}
local pendingQuestions = {}

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

function GameService.start()
	local pairList = SeatService.build()

	for _, pair in ipairs(pairList) do
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
end

return GameService
