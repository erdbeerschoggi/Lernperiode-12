-- Spielablauf: Runden starten/beenden, Rematch, Fragen/Antworten/Rateversuche.
local Players = game:GetService("Players")

local Remotes = require(script.Parent.Remotes)
local ShopService = require(script.Parent.ShopService)
local SeatService = require(script.Parent.SeatService)
local FootballPlayers = require(script.Parent.FootballPlayers)
local TextUtils = require(script.Parent.TextUtils)
local TurnService = require(script.Parent.TurnService)

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

-- NEU: difficulty ("easy" / "intermediate" / "hard") kommt aus startSelection
local function beginRound(pair, player1, player2, humanoid1, humanoid2, difficulty)

	local football1, football2 = randomPlayerPair(difficulty)

	pair.started = true
	pair.finished = false
	pair.rematchOpen = false
	pair.selecting = false
	pair.bonusSelecting = false
	pair.difficulty = difficulty

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

	-- (lockPlayer wird jetzt schon in startSelection aufgerufen)

	applyChairSkin(player1, pair.seat1.Parent)
	applyChairSkin(player2, pair.seat2.Parent)

	chairEvent:FireClient(player1, "START", player2.Name)
	chairEvent:FireClient(player2, "START", player1.Name)

	chairEvent:FireClient(player1, "PLAYER_DATA", football2)
	chairEvent:FireClient(player2, "PLAYER_DATA", football1)

	TurnService.start(pair, chairEvent)

end

-- ===== NEU: SCHWIERIGKEITS-AUSWAHL =====
local SELECT_TIME = 10      -- Sekunden, die der andere nach der ersten Wahl hat
local NO_CHOICE_TIME = 30   -- Wenn niemand waehlt: nach so vielen Sekunden zufaellige Stufe

local function sendSelectionUpdate(pair, deadline)

	local timeLeft = math.max(0, math.ceil(deadline - os.clock()))

	for _, p in ipairs({pair.player1, pair.player2}) do
		if p.Parent then
			local opponent = (p == pair.player1) and pair.player2 or pair.player1
			chairEvent:FireClient(p, "DIFFICULTY_UPDATE", {
				mine = pair.choices[p],
				opponent = pair.choices[opponent],
				timeLeft = timeLeft,
			})
		end
	end

end

local function abortSelection(pair, p1, p2, h1, h2)

	TurnService.stop(pair)
	pendingQuestions[p1] = nil
	pendingQuestions[p2] = nil

	pair.finished = true   -- beendet die lockPlayer-Schleifen
	pair.selecting = false
	pair.bonusSelecting = false
	pair.bonusMode = false
	pair.bonusVotes = nil

	for _, p in ipairs({p1, p2}) do
		if p.Parent then
			chairEvent:FireClient(p, "SELECT_CANCEL", "Opponent left.")
		end
	end

	unlockPlayer(pair, h1)
	unlockPlayer(pair, h2)

	activeGames[p1] = nil
	activeGames[p2] = nil

	task.wait(1)

	pair.started = false
	pair.finished = false
	pair.rematchOpen = false
	pair.player1 = nil
	pair.player2 = nil
	pair.humanoid1 = nil
	pair.humanoid2 = nil
	pair.playerData1 = nil
	pair.playerData2 = nil
	pair.choices = nil
	pair.choiceDeadline = nil
	pair.oldSettings = {}

end

-- Freiwilliger Bonus-Modus: kein Einsatz, kein Abzug, bei beidseitigem YES +25 CHF fuer den Sieger.
local BONUS_TIME = 15
local BONUS_REWARD = 25

local function startBonusSelection(pair, player1, player2, humanoid1, humanoid2)
	pair.bonusSelecting = true
	pair.bonusMode = false
	pair.bonusVotes = {}

	chairEvent:FireClient(player1, "BONUS_PROMPT", BONUS_TIME)
	chairEvent:FireClient(player2, "BONUS_PROMPT", BONUS_TIME)

	local deadline = os.clock() + BONUS_TIME
	local lastSecond = -1

	while os.clock() < deadline do
		if not player1.Parent or not player2.Parent
			or not humanoid1.Parent or not humanoid2.Parent then
			abortSelection(pair, player1, player2, humanoid1, humanoid2)
			return false
		end

		local vote1 = pair.bonusVotes[player1]
		local vote2 = pair.bonusVotes[player2]
		if vote1 == false or vote2 == false or (vote1 == true and vote2 == true) then
			break
		end

		local secondsLeft = math.max(0, math.ceil(deadline - os.clock()))
		if secondsLeft ~= lastSecond then
			lastSecond = secondsLeft
			for _, p in ipairs({player1, player2}) do
				local other = (p == player1) and player2 or player1
				chairEvent:FireClient(p, "BONUS_UPDATE", {
					mine = pair.bonusVotes[p],
					opponent = pair.bonusVotes[other],
					timeLeft = secondsLeft,
				})
			end
		end
		task.wait(0.2)
	end

	if not player1.Parent or not player2.Parent
		or not humanoid1.Parent or not humanoid2.Parent then
		abortSelection(pair, player1, player2, humanoid1, humanoid2)
		return false
	end

	pair.bonusMode = pair.bonusVotes[player1] == true and pair.bonusVotes[player2] == true
	chairEvent:FireClient(player1, "BONUS_RESULT", pair.bonusMode)
	chairEvent:FireClient(player2, "BONUS_RESULT", pair.bonusMode)
	task.wait(1.2)
	if not player1.Parent or not player2.Parent
		or not humanoid1.Parent or not humanoid2.Parent then
		abortSelection(pair, player1, player2, humanoid1, humanoid2)
		return false
	end
	return true
end

-- Beide Spieler waehlen eine Schwierigkeit. Sobald einer waehlt, laufen 10 Sekunden.
-- Beide koennen beliebig oft wechseln. Gleiche Wahl -> sofort Start.
-- Zeit um -> eine der beiden Wahlen wird zufaellig genommen.
local function startSelection(pair, player1, player2, humanoid1, humanoid2)

	pair.started = true
	pair.finished = false
	pair.rematchOpen = false
	pair.selecting = true
	pair.bonusSelecting = false
	pair.bonusMode = false
	pair.bonusVotes = nil
	pair.choices = {}
	pair.choiceDeadline = nil

	pair.player1 = player1
	pair.player2 = player2
	pair.humanoid1 = humanoid1
	pair.humanoid2 = humanoid2

	activeGames[player1] = pair
	activeGames[player2] = pair

	pendingQuestions[player1] = nil
	pendingQuestions[player2] = nil

	lockPlayer(pair, humanoid1, pair.seat1)
	lockPlayer(pair, humanoid2, pair.seat2)

	chairEvent:FireClient(player1, "DIFFICULTY_PROMPT", player2.Name)
	chairEvent:FireClient(player2, "DIFFICULTY_PROMPT", player1.Name)

	local startTime = os.clock()
	local lastSent = 0
	local chosen = nil

	while true do

		if not player1.Parent or not player2.Parent
			or not humanoid1.Parent or not humanoid2.Parent then
			abortSelection(pair, player1, player2, humanoid1, humanoid2)
			return
		end

		local c1 = pair.choices[player1]
		local c2 = pair.choices[player2]

		-- Beide haben das Gleiche gewaehlt -> fertig
		if c1 and c1 == c2 then
			chosen = c1
			break
		end

		local deadline = pair.choiceDeadline or (startTime + NO_CHOICE_TIME)

		-- Zeit abgelaufen
		if os.clock() >= deadline then
			if c1 and c2 then
				chosen = (math.random(1, 2) == 1) and c1 or c2
			else
				chosen = c1 or c2
					or FootballPlayers.difficulties[math.random(1, #FootballPlayers.difficulties)]
			end
			break
		end

		-- ca. 1x pro Sekunde den Countdown an die Clients schicken
		if os.clock() - lastSent >= 1 then
			lastSent = os.clock()
			sendSelectionUpdate(pair, deadline)
		end

		task.wait(0.1)

	end

	pair.selecting = false
	pair.bonusSelecting = true

	chairEvent:FireClient(player1, "DIFFICULTY_FINAL", chosen)
	chairEvent:FireClient(player2, "DIFFICULTY_FINAL", chosen)

	task.wait(1.5)

	if not player1.Parent or not player2.Parent
		or not humanoid1.Parent or not humanoid2.Parent then
		abortSelection(pair, player1, player2, humanoid1, humanoid2)
		return
	end

	if not startBonusSelection(pair, player1, player2, humanoid1, humanoid2) then
		return
	end

	beginRound(pair, player1, player2, humanoid1, humanoid2, chosen)

end

local REMATCH_TIME = 15

local function finishGame(pair, winner, loser)

	if pair.finished then
		return
	end

	pair.finished = true
	TurnService.stop(pair)

	-- Give 50 CHF to the winner
	if winner:FindFirstChild("leaderstats") and winner.leaderstats:FindFirstChild("Cash") then
		winner.leaderstats.Cash.Value += 50
		if pair.bonusMode then
			winner.leaderstats.Cash.Value += BONUS_REWARD
		end
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
		startSelection(pair, p1, p2, h1, h2) -- NEU: bei jeder Runde (auch Rematch) neu waehlen
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
	pair.bonusSelecting = false
	pair.bonusMode = false
	pair.bonusVotes = nil

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
				startSelection(pair, player1, player2, humanoid1, humanoid2) -- NEU
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
    Players.PlayerRemoving:Connect(function(player)
        local pair = activeGames[player]
        if pair and pair.turn and not pair.finished then
            task.spawn(function()
                abortSelection(pair, pair.player1, pair.player2, pair.humanoid1, pair.humanoid2)
            end)
        end
    end)
	local pairList = SeatService.build()

	for _, pair in ipairs(pairList) do
		setupPair(pair)
	end

	actionEvent.OnServerEvent:Connect(
		function(player, action, value, turnId)

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

			-- ===== NEU: Schwierigkeit waehlen =====
			if action == "DIFFICULTY" then
				if not pair.selecting then return end
				if typeof(value) ~= "string" or not FootballPlayers.isValidDifficulty(value) then
					return
				end

				pair.choices[player] = value

				-- Beim ersten Klick startet der 10-Sekunden-Timer (wird nicht neu gestartet)
				if not pair.choiceDeadline then
					pair.choiceDeadline = os.clock() + SELECT_TIME
				end

				sendSelectionUpdate(pair, pair.choiceDeadline)
				return
			end

			-- Spieler entscheiden freiwillig, ob die Runde einen Bonus haben soll.
			if action == "BONUS_VOTE" then
				if not pair.bonusSelecting or typeof(value) ~= "boolean" then return end
				if not pair.bonusVotes or pair.bonusVotes[player] ~= nil then return end
				pair.bonusVotes[player] = value
				return
			end

			-- Waehrend der Auswahl sind Fragen/Antworten/Raten gesperrt
			if pair.selecting or pair.bonusSelecting then
				return
			end

			if action == "TURN_SYNC" then
                TurnService.sync(pair, chairEvent, player)
                local data = pair.player1 == player and pair.playerData2 or pair.playerData1
                if data then chairEvent:FireClient(player, "PLAYER_DATA", data) end
                return
            end
            if action ~= "QUESTION" and action ~= "ANSWER" and action ~= "GUESS" then return end
            local errorStatus = action .. "_ERROR"
            if typeof(value) ~= "string" or value:match("^%s*$") or #value > 100 then
                chairEvent:FireClient(player, errorStatus, "Enter between 1 and 100 bytes of text.")
                return
            end
            local ticket = TurnService.claim(pair, player, action, turnId)
            if not ticket then
                chairEvent:FireClient(player, errorStatus, "Please wait for your turn.")
                TurnService.sync(pair, chairEvent, player)
                return
            end
            -- Lock before the yielding text filter: duplicate sends cannot race.
            TurnService.sync(pair, chairEvent)
            local filtered = filterText(value, player, opponent)
            if not TurnService.current(pair, ticket) or activeGames[player] ~= pair
                or not opponent.Parent then return end
            if not filtered or filtered:match("^%s*$") then
                chairEvent:FireClient(player, errorStatus,
                    "Text could not be checked. Try again in a published test with real accounts.")
                TurnService.retry(pair, ticket, action, chairEvent)
                return
            end
            if action == "QUESTION" then
                ticket.question = filtered
                ticket.phase = "ANSWER"
                pendingQuestions[opponent] = ticket.id
                chairEvent:FireClient(player, "QUESTION_SENT")
                chairEvent:FireClient(opponent, "OPPONENT_QUESTION", filtered)
                TurnService.sync(pair, chairEvent)
            elseif action == "ANSWER" then
                pendingQuestions[player] = nil
                chairEvent:FireClient(player, "ANSWER_SENT")
                chairEvent:FireClient(opponent, "OPPONENT_ANSWER", filtered)
                TurnService.advance(pair, chairEvent)
            else
                chairEvent:FireClient(opponent, "OPPONENT_GUESS", filtered)
                local ownFootballPlayer = getOwnFootballPlayer(player)
                if ownFootballPlayer and isCorrectGuess(value, ownFootballPlayer) then
                    TurnService.stop(pair)
                    task.spawn(function() finishGame(pair, player, opponent) end)
                else
                    chairEvent:FireClient(player, "WRONG_GUESS")
                    TurnService.advance(pair, chairEvent)
                end
            end

		end
	)
end

return GameService