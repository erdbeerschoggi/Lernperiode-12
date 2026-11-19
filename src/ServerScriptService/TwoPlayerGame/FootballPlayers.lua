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
	}
}

local FootballPlayers = {}
FootballPlayers.list = footballPlayers

-- Gibt zwei verschiedene zufaellige Spieler zurueck.
function FootballPlayers.randomPair()

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

return FootballPlayers
