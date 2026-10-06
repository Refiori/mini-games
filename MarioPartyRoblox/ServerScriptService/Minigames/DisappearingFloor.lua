local module = {}
module.Name = "Исчезающий пол"
module.Duration = 60

function module.Run(participants)
	local arena = Instance.new("Folder")
	arena.Name = "Arena"
	arena.Parent = workspace

	-- строим пол 8x8 плиток на высоте 100
	local tiles = {}
	for x = 1, 8 do
		for z = 1, 8 do
			local tile = Instance.new("Part")
			tile.Size = Vector3.new(8, 1, 8)
			tile.Anchored = true
			tile.Position = Vector3.new(x * 8, 100, z * 8)
			tile.Parent = arena
			table.insert(tiles, tile)
		end
	end

	-- телепортируем игроков на арену
	local alive = {}
	for _, plr in participants do
		local char = plr.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:PivotTo(CFrame.new(math.random(16, 56), 105, math.random(16, 56)))
			table.insert(alive, plr)
		end
	end

	local eliminated = {}
	local startTime = os.clock()

	while #alive > 1 and os.clock() - startTime < module.Duration do
		task.wait(1)

		-- убираем случайную плитку
		if #tiles > 0 then
			table.remove(tiles, math.random(#tiles)):Destroy()
		end

		-- выбывают те, кто упал ниже пола
		for i = #alive, 1, -1 do
			local plr = alive[i]
			local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if not root or root.Position.Y < 80 then
				table.insert(eliminated, plr)
				table.remove(alive, i)
			end
		end
	end

	-- итоговые места: сначала выжившие, потом выбывшие с конца
	local results = {}
	for _, plr in alive do table.insert(results, plr) end
	for i = #eliminated, 1, -1 do table.insert(results, eliminated[i]) end

	arena:Destroy()
	return results
end

return module
