local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local chairEvent = ReplicatedStorage:WaitForChild("ChairGameEvent")
local actionEvent = ReplicatedStorage:WaitForChild("GameActionEvent")

local gameStarted = false

local gui = Instance.new("ScreenGui")
gui.Name = "GuessPlayerGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 10
gui.Parent = player:WaitForChild("PlayerGui")

local function rounded(object, amount)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, amount)
	corner.Parent = object
end

local function outline(object)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 160, 255)
	stroke.Transparency = 0.35
	stroke.Thickness = 1.5
	stroke.Parent = object
end

local shopButton = Instance.new("TextButton")
shopButton.Name = "ShopButton"
shopButton.Size = UDim2.fromScale(0.09, 0.12)
shopButton.Position = UDim2.fromScale(0.02, 0.45)
shopButton.AnchorPoint = Vector2.new(0, 0.5)
shopButton.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
shopButton.BackgroundTransparency = 0.15
shopButton.Text = "SHOP"
shopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shopButton.TextScaled = true
shopButton.Font = Enum.Font.GothamBold
shopButton.ZIndex = 20
shopButton.Parent = gui

rounded(shopButton, 15)
outline(shopButton)

local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.Size = UDim2.fromScale(0.52, 0.62)
shopFrame.Position = UDim2.fromScale(0.5, 0.5)
shopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
shopFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
shopFrame.BackgroundTransparency = 0.12
shopFrame.Visible = false
shopFrame.ZIndex = 30
shopFrame.Parent = gui

rounded(shopFrame, 20)
outline(shopFrame)

local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.fromScale(0.7, 0.13)
shopTitle.Position = UDim2.fromScale(0.05, 0.04)
shopTitle.BackgroundTransparency = 1
shopTitle.Text = "SHOP"
shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
shopTitle.TextScaled = true
shopTitle.Font = Enum.Font.GothamBold
shopTitle.TextXAlignment = Enum.TextXAlignment.Left
shopTitle.ZIndex = 31
shopTitle.Parent = shopFrame

local closeShop = Instance.new("TextButton")
closeShop.Size = UDim2.fromScale(0.1, 0.1)
closeShop.Position = UDim2.fromScale(0.86, 0.04)
closeShop.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
closeShop.Text = "X"
closeShop.TextColor3 = Color3.fromRGB(255, 255, 255)
closeShop.TextScaled = true
closeShop.Font = Enum.Font.GothamBold
closeShop.ZIndex = 31
closeShop.Parent = shopFrame

rounded(closeShop, 10)

local shopCash = Instance.new("TextLabel")
shopCash.Size = UDim2.fromScale(0.5, 0.1)
shopCash.Position = UDim2.fromScale(0.05, 0.17)
shopCash.BackgroundTransparency = 1
shopCash.Text = "CHF: 0"
shopCash.TextColor3 = Color3.fromRGB(100, 255, 140)
shopCash.TextScaled = true
shopCash.Font = Enum.Font.GothamBold
shopCash.TextXAlignment = Enum.TextXAlignment.Left
shopCash.ZIndex = 31
shopCash.Parent = shopFrame

-- Color variants for the existing ShopEvent.
local SHOP_CHAIRS = {
	{Id = "Default", Name = "standard", Price = 0, Color = Color3.fromRGB(115, 120, 130)},
	{Id = "Item 1", Name = "red", Price = 100, Color = Color3.fromRGB(255, 80, 80)},
	{Id = "Item 2", Name = "blue", Price = 250, Color = Color3.fromRGB(80, 150, 255)},
	{Id = "Item 3", Name = "green", Price = 150, Color = Color3.fromRGB(65, 195, 110)},
	{Id = "Item 4", Name = "purple", Price = 350, Color = Color3.fromRGB(165, 90, 225)},
	{Id = "Item 5", Name = "gold", Price = 500, Color = Color3.fromRGB(245, 195, 55)},
}
local shopButtons = {}

local shopMessage = Instance.new("TextLabel")
shopMessage.Name = "ShopMessage"
shopMessage.Size = UDim2.fromScale(0.9, 0.1)
shopMessage.Position = UDim2.fromScale(0.05, 0.27)
shopMessage.BackgroundTransparency = 1
shopMessage.Text = "Buy a color or choose one you already own."
shopMessage.TextColor3 = Color3.fromRGB(230, 235, 245)
shopMessage.TextWrapped = true
shopMessage.TextSize = 15
shopMessage.Font = Enum.Font.GothamMedium
shopMessage.ZIndex = 31
shopMessage.Parent = shopFrame

local chairList = Instance.new("ScrollingFrame")
chairList.Name = "ChairList"
chairList.Size = UDim2.fromScale(0.9, 0.57)
chairList.Position = UDim2.fromScale(0.05, 0.39)
chairList.BackgroundTransparency = 1
chairList.BorderSizePixel = 0
chairList.ScrollBarThickness = 6
chairList.CanvasSize = UDim2.new()
chairList.AutomaticCanvasSize = Enum.AutomaticSize.Y
chairList.ZIndex = 31
chairList.Parent = shopFrame

local chairGrid = Instance.new("UIGridLayout")
chairGrid.CellSize = UDim2.new(0.48, -4, 0, 112)
chairGrid.CellPadding = UDim2.new(0.04, 0, 0, 10)
chairGrid.SortOrder = Enum.SortOrder.LayoutOrder
chairGrid.Parent = chairList

for index, item in ipairs(SHOP_CHAIRS) do
	local button = Instance.new("TextButton")
	button.Name = "ChairButton_" .. index
	button.LayoutOrder = index
	button.BackgroundColor3 = item.Color
	button.Text = item.Name .. "\n" .. item.Price .. " CHF\nLoading ..."
	button.TextColor3 = Color3.fromRGB(10, 15, 25)
	button.TextSize = 19
	button.TextWrapped = true
	button.Font = Enum.Font.GothamBold
	button.ZIndex = 32
	button.Parent = chairList
	rounded(button, 12)
	shopButtons[item.Id] = button
end

shopButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = not shopFrame.Visible
end)

closeShop.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

local waitingText = Instance.new("TextLabel")
waitingText.Size = UDim2.fromScale(0.34, 0.07)
waitingText.Position = UDim2.fromScale(0.33, 0.08)
waitingText.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
waitingText.BackgroundTransparency = 0.18
waitingText.TextColor3 = Color3.new(1, 1, 1)
waitingText.Font = Enum.Font.GothamBold
waitingText.TextScaled = true
waitingText.Text = "Waiting for Player 2..."
waitingText.Visible = false
waitingText.Parent = gui

rounded(waitingText, 15)
outline(waitingText)

local gameFrame = Instance.new("Frame")
gameFrame.Size = UDim2.fromScale(1, 1)
gameFrame.BackgroundTransparency = 1
gameFrame.Visible = false
gameFrame.Parent = gui

local QUESTIONS = {
	"Am I older than 30?",
	"Am I a striker?",
	"Am I a midfielder?",
	"Am I a winger?",
	"Am I a goalkeeper?",
	"Am I European?",
	"Have I won the World Cup?",
	"Have I won the Champions League?",
	"Have I won the European Championship?",
	"Have I won the Ballon d'Or?",
	"Do I have more than 5 league titles?",
	"Is my shirt number 10?",
	"Do I play for a club in the top 5 leagues?",
	"Custom question:...."
}

local questionFrame = Instance.new("Frame")
questionFrame.Name = "QuestionsFrame"
questionFrame.Size = UDim2.fromScale(0.54, 0.30)
questionFrame.Position = UDim2.fromScale(0.16, 0.075)
questionFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
questionFrame.BackgroundTransparency = 0.18
questionFrame.Parent = gameFrame
rounded(questionFrame, 18)
outline(questionFrame)

local questionTitle = Instance.new("TextLabel")
questionTitle.Size = UDim2.fromScale(0.92, 0.15)
questionTitle.Position = UDim2.fromScale(0.04, 0.025)
questionTitle.BackgroundTransparency = 1
questionTitle.Text = "CHOOSE A QUESTION"
questionTitle.TextColor3 = Color3.new(1, 1, 1)
questionTitle.TextScaled = true
questionTitle.Font = Enum.Font.GothamBold
questionTitle.Parent = questionFrame

local questionList = Instance.new("ScrollingFrame")
questionList.Name = "QuestionList"
questionList.Size = UDim2.fromScale(0.92, 0.76)
questionList.Position = UDim2.fromScale(0.04, 0.20)
questionList.BackgroundTransparency = 1
questionList.BorderSizePixel = 0
questionList.ScrollBarThickness = 5
questionList.CanvasSize = UDim2.new()
questionList.AutomaticCanvasSize = Enum.AutomaticSize.Y
questionList.Parent = questionFrame

local questionGrid = Instance.new("UIGridLayout")
questionGrid.CellSize = UDim2.new(0.48, -4, 0, 55)
questionGrid.CellPadding = UDim2.new(0.04, 0, 0, 8)
questionGrid.SortOrder = Enum.SortOrder.LayoutOrder
questionGrid.Parent = questionList

local questionStatus = Instance.new("TextLabel")
questionStatus.Size = UDim2.fromScale(0.54, 0.055)
questionStatus.Position = UDim2.fromScale(0.16, 0.38)
questionStatus.BackgroundTransparency = 1
questionStatus.TextColor3 = Color3.fromRGB(220, 220, 220)
questionStatus.Text = ""
questionStatus.TextSize = 16
questionStatus.TextWrapped = true
questionStatus.Font = Enum.Font.Gotham
questionStatus.Parent = gameFrame

for index, question in ipairs(QUESTIONS) do
	local button = Instance.new("TextButton")
	button.Name = "Question" .. index
	button.LayoutOrder = index
	button.BackgroundColor3 = Color3.fromRGB(34, 43, 61)
	button.Text = question
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 14
	button.TextWrapped = true
	button.Font = Enum.Font.GothamMedium
	button.Parent = questionList
	rounded(button, 9)
	button.Activated:Connect(function()
		if not gameStarted then return end
		actionEvent:FireServer("QUESTION", question)
		questionStatus.Text = "You asked: " .. question .. " (waiting for answer)"
	end)
end

local guessBox = Instance.new("TextBox")
guessBox.Size = UDim2.fromScale(0.38, 0.095)
guessBox.Position = UDim2.fromScale(0.27, 0.46)
guessBox.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
guessBox.BackgroundTransparency = 0.18
guessBox.TextColor3 = Color3.new(1, 1, 1)
guessBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 185)
guessBox.PlaceholderText = "Guess who you are..."
guessBox.Text = ""
guessBox.Font = Enum.Font.GothamMedium
guessBox.TextScaled = true
guessBox.ClearTextOnFocus = false
guessBox.Parent = gameFrame

rounded(guessBox, 14)
outline(guessBox)

local guessStatus = Instance.new("TextLabel")
guessStatus.Size = UDim2.fromScale(0.38, 0.04)
guessStatus.Position = UDim2.fromScale(0.27, 0.56)
guessStatus.BackgroundTransparency = 1
guessStatus.TextColor3 = Color3.fromRGB(220, 220, 220)
guessStatus.Text = ""
guessStatus.TextScaled = true
guessStatus.Font = Enum.Font.Gotham
guessStatus.Parent = gameFrame

local incomingQuestion = nil

local incomingQuestionLabel = Instance.new("TextLabel")
incomingQuestionLabel.Name = "IncomingQuestion"
incomingQuestionLabel.Size = UDim2.fromScale(0.54, 0.074)
incomingQuestionLabel.Position = UDim2.fromScale(0.16, 0.65)
incomingQuestionLabel.BackgroundTransparency = 1
incomingQuestionLabel.Text = "Waiting for opponent's question..."
incomingQuestionLabel.TextColor3 = Color3.new(1, 1, 1)
incomingQuestionLabel.TextSize = 18
incomingQuestionLabel.TextWrapped = true
incomingQuestionLabel.Font = Enum.Font.GothamBold
incomingQuestionLabel.Parent = gameFrame

local answerBox = Instance.new("TextBox")
answerBox.Name = "AnswerBox"
answerBox.Size = UDim2.fromScale(0.36, 0.083)
answerBox.Position = UDim2.fromScale(0.16, 0.73)
answerBox.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
answerBox.BackgroundTransparency = 0.18
answerBox.TextColor3 = Color3.new(1, 1, 1)
answerBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 185)
answerBox.PlaceholderText = "Type your answer..."
answerBox.Text = ""
answerBox.Font = Enum.Font.GothamMedium
answerBox.TextScaled = true
answerBox.ClearTextOnFocus = false
answerBox.Parent = gameFrame
rounded(answerBox, 14)
outline(answerBox)

local sendAnswerButton = Instance.new("TextButton")
sendAnswerButton.Name = "SendAnswerButton"
sendAnswerButton.Size = UDim2.fromScale(0.16, 0.083)
sendAnswerButton.Position = UDim2.fromScale(0.54, 0.73)
sendAnswerButton.BackgroundColor3 = Color3.fromRGB(34, 43, 61)
sendAnswerButton.Text = "SEND ANSWER"
sendAnswerButton.TextColor3 = Color3.new(1, 1, 1)
sendAnswerButton.TextScaled = true
sendAnswerButton.Font = Enum.Font.GothamBold
sendAnswerButton.Parent = gameFrame
rounded(sendAnswerButton, 14)
outline(sendAnswerButton)

local answerStatus = Instance.new("TextLabel")
answerStatus.Name = "AnswerStatus"
answerStatus.Size = UDim2.fromScale(0.54, 0.05)
answerStatus.Position = UDim2.fromScale(0.16, 0.83)
answerStatus.BackgroundTransparency = 1
answerStatus.TextColor3 = Color3.fromRGB(220, 220, 220)
answerStatus.Text = ""
answerStatus.TextSize = 16
answerStatus.TextWrapped = true
answerStatus.Font = Enum.Font.Gotham
answerStatus.Parent = gameFrame

local function submitAnswer()
	if not gameStarted then return end
	if not incomingQuestion then
		answerStatus.Text = "Wait until the opponent asks a question."
		return
	end
	local answer = answerBox.Text:match("^%s*(.-)%s*$")
	if not answer or answer == "" then
		answerStatus.Text = "Type an answer first."
		return
	end
	actionEvent:FireServer("ANSWER", answer)
	answerBox.Text = ""
	answerStatus.Text = "Sending answer..."
end

sendAnswerButton.Activated:Connect(submitAnswer)
answerBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		submitAnswer()
	end
end)

local cash = Instance.new("TextLabel")
cash.Size = UDim2.fromScale(0.20, 0.065)
cash.Position = UDim2.fromScale(0.76, 0.04)
cash.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
cash.BackgroundTransparency = 0.15
cash.Text = "CHF: 0"
cash.TextColor3 = Color3.new(1, 1, 1)
cash.TextScaled = true
cash.Font = Enum.Font.GothamBold
cash.Parent = gui

rounded(cash, 15)
outline(cash)

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.fromScale(0.22, 0.62)
infoFrame.Position = UDim2.fromScale(0.75, 0.17)
infoFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
infoFrame.BackgroundTransparency = 0.18
infoFrame.Parent = gameFrame

rounded(infoFrame, 25)
outline(infoFrame)

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.fromScale(0.9, 0.15)
infoTitle.Position = UDim2.fromScale(0.05, 0.04)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "Opponent's\nPlayer Info"
infoTitle.TextColor3 = Color3.new(1, 1, 1)
infoTitle.TextScaled = true
infoTitle.Font = Enum.Font.GothamBold
infoTitle.Parent = infoFrame

local info = Instance.new("TextLabel")
info.Size = UDim2.fromScale(0.84, 0.74)
info.Position = UDim2.fromScale(0.08, 0.21)
info.BackgroundTransparency = 1
info.Text = [[Nationality: ?
Club: ?
Age: ?
Number: ?
League Titles: ?
UCL Titles: ?
World Cups: ?
Euro Titles: ?
Position: ?
Ballon d'Or: ?]]
info.TextColor3 = Color3.new(1, 1, 1)
info.TextSize = 20
info.TextWrapped = true
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Font = Enum.Font.GothamMedium
info.Parent = infoFrame

local resultText = Instance.new("TextLabel")
resultText.Size = UDim2.fromScale(0.45, 0.15)
resultText.Position = UDim2.fromScale(0.275, 0.4)
resultText.BackgroundColor3 = Color3.fromRGB(10, 15, 20)
resultText.BackgroundTransparency = 0.1
resultText.TextColor3 = Color3.new(1, 1, 1)
resultText.TextScaled = true
resultText.Font = Enum.Font.GothamBold
resultText.Visible = false
resultText.Parent = gui

rounded(resultText, 20)
outline(resultText)



guessBox.FocusLost:Connect(function()
	if guessBox.Text == "" then
		return
	end

	actionEvent:FireServer(
		"GUESS",
		guessBox.Text
	)

	guessStatus.Text =
		"You guessed: " .. guessBox.Text

	guessBox.Text = ""
end)



local function setupCharacter(character)

	local humanoid =
		character:WaitForChild("Humanoid")

	humanoid.Seated:Connect(
		function(sitting, seat)

			if sitting and seat then

				local chair = seat.Parent

				if chair
					and string.match(
						chair.Name,
						"^Chair"
					)
				then

					if not gameStarted then

						player.CameraMode =
							Enum.CameraMode.LockFirstPerson

						waitingText.Text =
							"Waiting for Player 2..."

						waitingText.Visible =
							true

					end

				end

			elseif not gameStarted then

				player.CameraMode =
					Enum.CameraMode.Classic

				waitingText.Visible =
					false

			end

		end
	)

end

if player.Character then
	setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

local function freezeCamera(opponentName)

	local camera =
		workspace.CurrentCamera

	local myCharacter =
		player.Character

	if not myCharacter then
		return
	end

	local myHead =
		myCharacter:FindFirstChild("Head")

	if not myHead then
		myHead =
			myCharacter:WaitForChild(
				"Head",
				3
			)
	end

	if not myHead then
		return
	end

	local opponent =
		Players:FindFirstChild(
			opponentName
		)

	if not opponent then
		return
	end

	local opponentCharacter =
		opponent.Character

	if not opponentCharacter then
		return
	end

	local opponentHead =
		opponentCharacter:FindFirstChild(
			"Head"
		)

	if not opponentHead then
		opponentHead =
			opponentCharacter:WaitForChild(
				"Head",
				3
			)
	end

	if not opponentHead then
		return
	end

	local cameraPosition =
		myHead.Position
		+ Vector3.new(
			0,
			0.15,
			0
		)

	local targetPosition =
		opponentHead.Position
		+ Vector3.new(
			0,
			0.05,
			0
		)

	player.CameraMode =
		Enum.CameraMode.Classic

	camera.CameraType =
		Enum.CameraType.Scriptable

	camera.CFrame =
		CFrame.lookAt(
			cameraPosition,
			targetPosition
		)

	camera.Focus =
		CFrame.new(
			targetPosition
		)

	UserInputService.MouseBehavior =
		Enum.MouseBehavior.Default

	UserInputService.MouseIconEnabled =
		true

end

local function restoreCamera()

	gameStarted = false

	local camera =
		workspace.CurrentCamera

	camera.CameraType =
		Enum.CameraType.Custom

	local character =
		player.Character

	if character then

		local humanoid =
			character:FindFirstChildOfClass(
				"Humanoid"
			)

		if humanoid then
			camera.CameraSubject = humanoid
		end

	end

	player.CameraMode =
		Enum.CameraMode.Classic

	UserInputService.MouseBehavior =
		Enum.MouseBehavior.Default

	UserInputService.MouseIconEnabled =
		true

end

chairEvent.OnClientEvent:Connect(function(status, value)

	if status == "WAITING" then

		waitingText.Text =
			"Waiting for Player 2..."

		waitingText.Visible =
			true

	elseif status == "START" then

		gameStarted = true

		waitingText.Text =
			"GAME STARTED!"

		waitingText.Visible =
			true

		info.Text =
			"Loading player..."

		questionStatus.Text = ""
		guessStatus.Text = ""
		answerStatus.Text = ""
		answerBox.Text = ""
		guessBox.Text = ""
		incomingQuestion = nil
		incomingQuestionLabel.Text = "Waiting for opponent's question..."

		freezeCamera(value)

		task.wait(1)

		waitingText.Visible =
			false

		gameFrame.Visible =
			true

	elseif status == "PLAYER_DATA" then

		info.Text =
			"Player: "
			.. tostring(value.Name)
			.. "\nNationality: "
			.. tostring(value.Nationality)
			.. "\nClub: "
			.. tostring(value.Club)
			.. "\nAge: "
			.. tostring(value.Age)
			.. "\nNumber: "
			.. tostring(value.Number)
			.. "\nLeague Titles: "
			.. tostring(value.LeagueTitles)
			.. "\nUCL Titles: "
			.. tostring(value.UCL)
			.. "\nWorld Cups: "
			.. tostring(value.WorldCups)
			.. "\nEuro Titles: "
			.. tostring(value.Euros)
			.. "\nPosition: "
			.. tostring(value.Position)
			.. "\nBallon d'Or: "
			.. tostring(value.BallonDor)

	elseif status == "OPPONENT_QUESTION" then

		incomingQuestion = tostring(value)
		incomingQuestionLabel.Text = "Opponent asks: " .. incomingQuestion
		answerStatus.Text = "Type your answer below."
		answerBox.Text = ""

	elseif status == "ANSWER_SENT" then

		incomingQuestion = nil
		incomingQuestionLabel.Text = "Waiting for opponent's question..."
		answerStatus.Text = "Answer sent!"

	elseif status == "ANSWER_ERROR" then

		answerStatus.Text = tostring(value)

	elseif status == "OPPONENT_ANSWER" then

		questionStatus.Text = "Opponent answered: " .. tostring(value)

	elseif status == "OPPONENT_GUESS" then

		guessStatus.Text =
			"Opponent guessed: "
			.. tostring(value)

	elseif status == "WRONG_GUESS" then

		guessStatus.Text =
			"Wrong guess!"

	elseif status == "WIN" then

		gameFrame.Visible =
			false

		resultText.Text =
			"YOU WIN!\nYou were "
			.. tostring(value)

		resultText.Visible =
			true

		restoreCamera()

		task.wait(3)

		resultText.Visible =
			false

	elseif status == "LOSE" then

		gameFrame.Visible =
			false

		resultText.Text =
			"YOU LOST!\nYou were "
			.. tostring(value)

		resultText.Visible =
			true

		restoreCamera()

		task.wait(3)

		resultText.Visible =
			false

	end

end)

-- Connect the existing money values and the inventory to the display.
task.spawn(function()
	local shopEvent = ReplicatedStorage:WaitForChild("ShopEvent")
	local leaderstats = player:WaitForChild("leaderstats")
	local cashValue = leaderstats:WaitForChild("Cash")
	local inventory = player:WaitForChild("Inventory")
	local equipped = player:WaitForChild("EquippedChair")

	local function updateShop()
		cash.Text = "CHF: " .. cashValue.Value
		shopCash.Text = "CHF: " .. cashValue.Value
		for _, item in ipairs(SHOP_CHAIRS) do
			local button = shopButtons[item.Id]
			local owned = item.Id == "Default" or inventory:FindFirstChild(item.Id)
			local actionText
			if equipped.Value == item.Id then
				actionText = "Selected"
			elseif owned then
				actionText = "Select (free)"
			elseif cashValue.Value >= item.Price then
				actionText = "Buy"
			else
				actionText = "Not enough CHF"
			end
			local priceText = item.Id == "Default" and "Original colors" or (item.Price .. " CHF")
			button.Text = item.Name .. "\n" .. priceText .. "\n" .. actionText
		end
	end

	shopEvent.OnClientEvent:Connect(function(status, message)
		if status ~= "OK" and status ~= "ERROR" then return end
		shopMessage.Text = tostring(message)
		shopMessage.TextColor3 = status == "ERROR"
			and Color3.fromRGB(255, 145, 145) or Color3.fromRGB(140, 255, 175)
	end)
	for _, item in ipairs(SHOP_CHAIRS) do
		shopButtons[item.Id].Activated:Connect(function()
			-- The server decides price, balance and ownership.
			shopEvent:FireServer("BUY", item.Id)
		end)
	end
	cashValue.Changed:Connect(updateShop)
	inventory.ChildAdded:Connect(updateShop)
	inventory.ChildRemoved:Connect(updateShop)
	equipped.Changed:Connect(updateShop)
	updateShop()
end)