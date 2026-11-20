-- Alle Fussballer für das Ratespiel. 
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
	},

	-- ===== INTERMEDIATE (Spieler 21-40) =====

	{
		Name = "Granit Xhaka",
		Age = 34,
		Nationality = "Switzerland",
		Club = "Sunderland",
		Number = 34,
		LeagueTitles = 3,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Manuel Akanji",
		Age = 31,
		Nationality = "Switzerland",
		Club = "Inter Mailand",
		Number = 25,
		LeagueTitles = 4,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Center Back",
		BallonDor = 0
	},

	{
		Name = "Florian Wirtz",
		Age = 23,
		Nationality = "Germany",
		Club = "Liverpool",
		Number = 7,
		LeagueTitles = 1,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Virgil van Dijk",
		Age = 35,
		Nationality = "Netherlands",
		Club = "Liverpool",
		Number = 4,
		LeagueTitles = 4,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Center Back",
		BallonDor = 0
	},

	{
		Name = "Phil Foden",
		Age = 26,
		Nationality = "England",
		Club = "Manchester City",
		Number = 47,
		LeagueTitles = 6,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Rodri",
		Age = 30,
		Nationality = "Spain",
		Club = "Manchester City",
		Number = 16,
		LeagueTitles = 4,
		UCL = 1,
		WorldCups = 0,
		Euros = 1,
		Position = "Defensive Midfield",
		BallonDor = 1
	},

	{
		Name = "Son Heung-min",
		Age = 34,
		Nationality = "South Korea",
		Club = "Los Angeles FC",
		Number = 7,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Winger",
		BallonDor = 0
	},

	{
		Name = "Alisson Becker",
		Age = 34,
		Nationality = "Brazil",
		Club = "Liverpool",
		Number = 1,
		LeagueTitles = 2,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Goalkeeper",
		BallonDor = 0
	},

	{
		Name = "Thibaut Courtois",
		Age = 34,
		Nationality = "Belgium",
		Club = "Real Madrid",
		Number = 1,
		LeagueTitles = 6,
		UCL = 2,
		WorldCups = 0,
		Euros = 0,
		Position = "Goalkeeper",
		BallonDor = 0
	},

	{
		Name = "Pedri",
		Age = 23,
		Nationality = "Spain",
		Club = "Barcelona",
		Number = 8,
		LeagueTitles = 3,
		UCL = 0,
		WorldCups = 0,
		Euros = 1,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Joshua Kimmich",
		Age = 31,
		Nationality = "Germany",
		Club = "Bayern München",
		Number = 6,
		LeagueTitles = 9,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Rafael Leão",
		Age = 27,
		Nationality = "Portugal",
		Club = "Galatasaray",
		Number = 10,
		LeagueTitles = 2,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Winger",
		BallonDor = 0
	},

	{
		Name = "Victor Osimhen",
		Age = 27,
		Nationality = "Nigeria",
		Club = "Galatasaray",
		Number = 45,
		LeagueTitles = 2,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Striker",
		BallonDor = 0
	},

	{
		Name = "Lautaro Martínez",
		Age = 29,
		Nationality = "Argentina",
		Club = "Inter Mailand",
		Number = 10,
		LeagueTitles = 2,
		UCL = 0,
		WorldCups = 1,
		Euros = 0,
		Position = "Striker",
		BallonDor = 0
	},

	{
		Name = "Gianluigi Donnarumma",
		Age = 27,
		Nationality = "Italy",
		Club = "Manchester City",
		Number = 25,
		LeagueTitles = 4,
		UCL = 1,
		WorldCups = 0,
		Euros = 1,
		Position = "Goalkeeper",
		BallonDor = 0
	},

	{
		Name = "Trent Alexander-Arnold",
		Age = 28,
		Nationality = "England",
		Club = "Real Madrid",
		Number = 12,
		LeagueTitles = 2,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Right Back",
		BallonDor = 0
	},

	{
		Name = "Federico Valverde",
		Age = 28,
		Nationality = "Uruguay",
		Club = "Real Madrid",
		Number = 8,
		LeagueTitles = 3,
		UCL = 2,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Nico Williams",
		Age = 24,
		Nationality = "Spain",
		Club = "Athletic Bilbao",
		Number = 10,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 1,
		Position = "Winger",
		BallonDor = 0
	},

	{
		Name = "Alexander Isak",
		Age = 27,
		Nationality = "Sweden",
		Club = "Liverpool",
		Number = 9,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Striker",
		BallonDor = 0
	},

	{
		Name = "Bruno Fernandes",
		Age = 32,
		Nationality = "Portugal",
		Club = "Manchester United",
		Number = 8,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	-- ===== HARD (Spieler 41-60) =====

	{
		Name = "Gregor Kobel",
		Age = 28,
		Nationality = "Switzerland",
		Club = "Borussia Dortmund",
		Number = 1,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Goalkeeper",
		BallonDor = 0
	},

	{
		Name = "Dan Ndoye",
		Age = 26,
		Nationality = "Switzerland",
		Club = "Nottingham Forest",
		Number = 14,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Winger",
		BallonDor = 0
	},

	{
		Name = "Nico Schlotterbeck",
		Age = 26,
		Nationality = "Germany",
		Club = "Borussia Dortmund",
		Number = 4,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Center Back",
		BallonDor = 0
	},

	{
		Name = "Hakan Çalhanoğlu",
		Age = 32,
		Nationality = "Turkey",
		Club = "Inter Mailand",
		Number = 20,
		LeagueTitles = 1,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Mikel Oyarzabal",
		Age = 29,
		Nationality = "Spain",
		Club = "Real Sociedad",
		Number = 10,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 1,
		Position = "Striker",
		BallonDor = 0
	},

	{
		Name = "Ronald Araújo",
		Age = 27,
		Nationality = "Uruguay",
		Club = "Barcelona",
		Number = 4,
		LeagueTitles = 3,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Center Back",
		BallonDor = 0
	},

	{
		Name = "Jordan Pickford",
		Age = 32,
		Nationality = "England",
		Club = "Everton",
		Number = 1,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Goalkeeper",
		BallonDor = 0
	},

	{
		Name = "Ademola Lookman",
		Age = 29,
		Nationality = "Nigeria",
		Club = "Atalanta",
		Number = 11,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Winger",
		BallonDor = 0
	},

	{
		Name = "Nicolò Barella",
		Age = 29,
		Nationality = "Italy",
		Club = "Inter Mailand",
		Number = 23,
		LeagueTitles = 2,
		UCL = 0,
		WorldCups = 0,
		Euros = 1,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Jonathan David",
		Age = 26,
		Nationality = "Canada",
		Club = "Juventus",
		Number = 30,
		LeagueTitles = 1,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Striker",
		BallonDor = 0
	},

	{
		Name = "Pedro Porro",
		Age = 27,
		Nationality = "Spain",
		Club = "Tottenham",
		Number = 23,
		LeagueTitles = 1,
		UCL = 0,
		WorldCups = 1,
		Euros = 1,
		Position = "Striker",
		BallonDor = 0
	},

	{
		Name = "Matheus Cunha",
		Age = 27,
		Nationality = "Brazil",
		Club = "Manchester United",
		Number = 10,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Bryan Mbeumo",
		Age = 27,
		Nationality = "Cameroon",
		Club = "Manchester United",
		Number = 19,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Winger",
		BallonDor = 0
	},

	{
		Name = "Joelinton",
		Age = 30,
		Nationality = "Brazil",
		Club = "Newcastle United",
		Number = 7,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Désiré Doué",
		Age = 21,
		Nationality = "France",
		Club = "PSG",
		Number = 14,
		LeagueTitles = 1,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Winger",
		BallonDor = 0
	},

	{
		Name = "Warren Zaïre-Emery",
		Age = 20,
		Nationality = "France",
		Club = "PSG",
		Number = 33,
		LeagueTitles = 3,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Central Midfield",
		BallonDor = 0
	},

	{
		Name = "Rayan Cherki",
		Age = 23,
		Nationality = "France",
		Club = "Manchester City",
		Number = 10,
		LeagueTitles = 0,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Offensive Midfield",
		BallonDor = 0
	},

	{
		Name = "Ederson",
		Age = 33,
		Nationality = "Brazil",
		Club = "Fenerbahçe",
		Number = 31,
		LeagueTitles = 8,
		UCL = 1,
		WorldCups = 0,
		Euros = 0,
		Position = "Goalkeeper",
		BallonDor = 0
	},

	{
		Name = "Jamie Vardy",
		Age = 39,
		Nationality = "England",
		Club = "Burnley FC",
		Number = 10,
		LeagueTitles = 1,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Striker",
		BallonDor = 0
	},

	{
		Name = "Marcus Thuram",
		Age = 29,
		Nationality = "France",
		Club = "Inter Mailand",
		Number = 9,
		LeagueTitles = 2,
		UCL = 0,
		WorldCups = 0,
		Euros = 0,
		Position = "Striker",
		BallonDor = 0
	}
}

local FootballPlayers = {}
FootballPlayers.list = footballPlayers

FootballPlayers.difficulties = { "easy", "intermediate", "hard" }

local difficultyRanges = {
	easy = { 1, 20 },
	intermediate = { 21, 40 },
	hard = { 41, 60 },
}

-- Gibt die gueltige Schwierigkeit zurueck (oder nil, wenn der Wert ungueltig ist).
function FootballPlayers.isValidDifficulty(difficulty)
	return difficultyRanges[difficulty] ~= nil
end

-- Gibt zwei verschiedene zufaellige Spieler der gewaehlten Schwierigkeit zurueck.
function FootballPlayers.randomPair(difficulty)

	local range = difficultyRanges[difficulty] or difficultyRanges.easy
	local minIndex = range[1]
	local maxIndex = math.min(range[2], #footballPlayers)

	local first = math.random(minIndex, maxIndex)
	local second = math.random(minIndex, maxIndex)

	while second == first do
		second = math.random(minIndex, maxIndex)
	end

	return footballPlayers[first], footballPlayers[second]

end

return FootballPlayers