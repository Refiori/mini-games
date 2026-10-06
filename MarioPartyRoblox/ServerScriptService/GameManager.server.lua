local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local MIN_PLAYERS = 2
local LOBBY_TIME = 15
local ROUNDS = 5
local POINTS = {10, 6, 3, 1} -- очки за 1-е, 2-е, 3-е, 4-е место

local statusEvent = ReplicatedStorage:WaitForChild("StatusUpdate")

-- подгружаем все мини-игры из папки
local minigames = {}
for _, module in ServerScriptService.Minigames:GetChildren() do
	table.insert(minigames, require(module))
end

local scores = {}

local function broadcast(text, seconds)
	statusEvent:FireAllClients(text, seconds or 0)
end

local function countdown(seconds, text)
	for i = seconds, 1, -1 do
		broadcast(text, i)
		task.wait(1)
	end
end

local function awardPoints(results) -- results: игроки от 1-го места к последнему
	for place, player in results do
		if player.Parent then
			scores[player] = (scores[player] or 0) + (POINTS[place] or 0)
		end
	end
end

local function respawnEveryone()
	for _, player in Players:GetPlayers() do
		player:LoadCharacter()
	end
end

local function findWinner()
	local best, winner = -1, nil
	for player, score in scores do
		if player.Parent and score > best then
			best, winner = score, player
		end
	end
	return winner, best
end

while true do
	-- ждём игроков
	while #Players:GetPlayers() < MIN_PLAYERS do
		broadcast("Ожидание игроков...")
		task.wait(1)
	end

	scores = {}
	countdown(LOBBY_TIME, "Игра начнётся через")

	for round = 1, ROUNDS do
		if #Players:GetPlayers() < MIN_PLAYERS then break end

		local minigame = minigames[math.random(#minigames)]
		broadcast(("Раунд %d: %s"):format(round, minigame.Name))
		task.wait(3)

		local results = minigame.Run(Players:GetPlayers())
		awardPoints(results)

		broadcast("Раунд окончен!")
		task.wait(3)
		respawnEveryone()
	end

	local winner, score = findWinner()
	if winner then
		broadcast(("Победитель: %s (%d очк.)"):format(winner.Name, score))
	end
	task.wait(8)
end
