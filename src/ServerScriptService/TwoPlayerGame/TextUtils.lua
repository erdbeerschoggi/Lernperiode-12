-- Text-Hilfen: Normalisieren, Rate-Prüfung und Chat-Filter.
local TextService = game:GetService("TextService")

local TextUtils = {}

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

TextUtils.normalize = normalize
TextUtils.isCorrectGuess = isCorrectGuess
TextUtils.filterText = filterText

return TextUtils
