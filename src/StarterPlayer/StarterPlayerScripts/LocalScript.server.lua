local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local chairEvent =
	ReplicatedStorage:WaitForChild("ChairGameEvent")

local actionEvent =
	ReplicatedStorage:WaitForChild("GameActionEvent")

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
shopCash.Text = "Cash: $0"
shopCash.TextColor3 = Color3.fromRGB(100, 255, 140)
shopCash.TextScaled = true
shopCash.Font = Enum.Font.GothamBold
shopCash.TextXAlignment = Enum.TextXAlignment.Left
shopCash.ZIndex = 31
shopCash.Parent = shopFrame

local item1 = Instance.new("TextButton")
item1.Size = UDim2.fromScale(0.4, 0.22)
item1.Position = UDim2.fromScale(0.07, 0.35)
item1.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
item1.Text = "ITEM 1\n$100"
item1.TextColor3 = Color3.fromRGB(255, 255, 255)
item1.TextScaled = true
item1.Font = Enum.Font.GothamBold
item1.ZIndex = 31
item1.Parent = shopFrame

rounded(item1, 15)

local item2 = Instance.new("TextButton")
item2.Size = UDim2.fromScale(0.4, 0.22)
item2.Position = UDim2.fromScale(0.53, 0.35)
item2.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
item2.Text = "ITEM 2\n$250"
item2.TextColor3 = Color3.fromRGB(255, 255, 255)
item2.TextScaled = true
item2.Font = Enum.Font.GothamBold
item2.ZIndex = 31
item2.Parent = shopFrame

rounded(item2, 15)

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

local questionBox = Instance.new("TextBox")
questionBox.Size = UDim2.fromScale(0.38, 0.095)
questionBox.Position = UDim2.fromScale(0.27, 0.12)
questionBox.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
questionBox.BackgroundTransparency = 0.18
questionBox.TextColor3 = Color3.new(1, 1, 1)
questionBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 185)
questionBox.PlaceholderText = "Type in your question..."
questionBox.Text = ""
questionBox.Font = Enum.Font.GothamMedium
questionBox.TextScaled = true
questionBox.ClearTextOnFocus = false
questionBox.Parent = gameFrame

rounded(questionBox, 14)
outline(questionBox)

local questionStatus = Instance.new("TextLabel")
questionStatus.Size = UDim2.fromScale(0.38, 0.04)
questionStatus.Position = UDim2.fromScale(0.27, 0.22)
questionStatus.BackgroundTransparency = 1
questionStatus.TextColor3 = Color3.fromRGB(220, 220, 220)
questionStatus.Text = ""
questionStatus.TextScaled = true
questionStatus.Font = Enum.Font.Gotham
questionStatus.Parent = gameFrame

local guessBox = Instance.new("TextBox")
guessBox.Size = UDim2.fromScale(0.38, 0.095)
guessBox.Position = UDim2.fromScale(0.27, 0.27)
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
guessStatus.Position = UDim2.fromScale(0.27, 0.37)
guessStatus.BackgroundTransparency = 1
guessStatus.TextColor3 = Color3.fromRGB(220, 220, 220)
guessStatus.Text = ""
guessStatus.TextScaled = true
guessStatus.Font = Enum.Font.Gotham
guessStatus.Parent = gameFrame

local yesButton = Instance.new("TextButton")
yesButton.Size = UDim2.fromScale(0.23, 0.16)
yesButton.Position = UDim2.fromScale(0.14, 0.69)
yesButton.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
yesButton.BackgroundTransparency = 0.18
yesButton.Text = "✓ YES"
yesButton.TextColor3 = Color3.new(1, 1, 1)
yesButton.TextScaled = true
yesButton.Font = Enum.Font.GothamBold
yesButton.Parent = gameFrame

rounded(yesButton, 20)
outline(yesButton)

local noButton = Instance.new("TextButton")
noButton.Size = UDim2.fromScale(0.23, 0.16)
noButton.Position = UDim2.fromScale(0.43, 0.69)
noButton.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
noButton.BackgroundTransparency = 0.18
noButton.Text = "✕ NO"
noButton.TextColor3 = Color3.new(1, 1, 1)
noButton.TextScaled = true
noButton.Font = Enum.Font.GothamBold
noButton.Parent = gameFrame

rounded(noButton, 20)
outline(noButton)

local cash = Instance.new("TextLabel")
cash.Size = UDim2.fromScale(0.20, 0.065)
cash.Position = UDim2.fromScale(0.76, 0.04)
cash.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
cash.BackgroundTransparency = 0.15
cash.Text = "Cash: $0"
cash.TextColor3 = Color3.new(1, 1, 1)
cash.TextScaled = true
cash.Font = Enum.Font.GothamBold
cash.Parent = gameFrame

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
info.Size = UDim2.fromScale(0.84, 0.70)
info.Position = UDim2.fromScale(0.08, 0.22)
info.BackgroundTransparency = 1
info.Text = [[Nationality: ?
Club: ?
Age: ?
League: ?
Titles: ?
UCL Titles: ?
World Cups: ?
...]]
info.TextColor3 = Color3.new(1, 1, 1)
info.TextSize = 22
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

questionBox.FocusLost:Connect(function()
	if questionBox.Text == "" then
		return
	end

	actionEvent:FireServer(
		"QUESTION",
		questionBox.Text
	)

	questionStatus.Text =
		"You asked: " .. questionBox.Text

	questionBox.Text = ""
end)

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

yesButton.MouseButton1Click:Connect(function()
	actionEvent:FireServer(
		"ANSWER",
		"YES"
	)

	questionStatus.Text =
		"You answered YES"
end)

noButton.MouseButton1Click:Connect(function()
	actionEvent:FireServer(
		"ANSWER",
		"NO"
	)

	questionStatus.Text =
		"You answered NO"
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

player.CharacterAdded:Connect(
	setupCharacter
)

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

chairEvent.OnClientEvent:Connect(
	function(status, value)

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

			freezeCamera(value)

			task.wait(1)

			waitingText.Visible =
				false

			gameFrame.Visible =
				true

		elseif status ==
			"OPPONENT_QUESTION" then

			questionStatus.Text =
				"Opponent asked: "
				.. value

		elseif status ==
			"OPPONENT_ANSWER" then

			questionStatus.Text =
				"Opponent answered: "
				.. value

		elseif status ==
			"OPPONENT_GUESS" then

			guessStatus.Text =
				"Opponent guessed: "
				.. value

		elseif status == "WIN" then

			gameFrame.Visible =
				false

			resultText.Text =
				"YOU WIN!"

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
				"YOU LOST!"

			resultText.Visible =
				true

			restoreCamera()

			task.wait(3)

			resultText.Visible =
				false

		end

	end
)