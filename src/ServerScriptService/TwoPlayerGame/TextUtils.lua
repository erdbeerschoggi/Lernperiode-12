-- Text-Hilfen: Normalisieren, Rate-Prüfung und Chat-Filter.
local TextService = game:GetService("TextService")

local TextUtils = {}

local function normalize(text)

	text =
		tostring(text or "")

	-- NEU: Akzente entfernen, damit z.B. "martinez", "leao" oder "calhanoglu" erkannt werden
	local replacements = {
		{"Ä", "a"}, {"ä", "a"}, {"Ö", "o"}, {"ö", "o"}, {"Ü", "u"}, {"ü", "u"},
		{"É", "e"}, {"é", "e"}, {"È", "e"}, {"è", "e"}, {"Ê", "e"}, {"ê", "e"},
		{"Á", "a"}, {"á", "a"}, {"À", "a"}, {"à", "a"}, {"Ã", "a"}, {"ã", "a"}, {"Â", "a"}, {"â", "a"},
		{"Í", "i"}, {"í", "i"}, {"Ï", "i"}, {"ï", "i"}, {"İ", "i"}, {"ı", "i"},
		{"Ó", "o"}, {"ó", "o"}, {"Ò", "o"}, {"ò", "o"}, {"Ô", "o"}, {"ô", "o"},
		{"Ú", "u"}, {"ú", "u"},
		{"Ñ", "n"}, {"ñ", "n"},
		{"Ç", "c"}, {"ç", "c"},
		{"Ğ", "g"}, {"ğ", "g"},
		{"Ş", "s"}, {"ş", "s"},
		{"%-", " "},
	}

	for _, pair in ipairs(replacements) do
		text = string.gsub(text, pair[1], pair[2])
	end

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