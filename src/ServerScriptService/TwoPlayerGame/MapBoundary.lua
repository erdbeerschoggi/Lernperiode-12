-- Unsichtbare Begrenzungswaende um den Boden unter der SpawnLocation.
local MapBoundary = {}

function MapBoundary.build()
	local spawnLocation = workspace:FindFirstChildWhichIsA("SpawnLocation", true)

	if spawnLocation then

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {spawnLocation}

		local result = workspace:Raycast(
			spawnLocation.Position + Vector3.new(0, 5, 0),
			Vector3.new(0, -500, 0),
			params
		)

		if result and result.Instance and result.Instance:IsA("BasePart") then

			local ground = result.Instance
			local oldWalls = workspace:FindFirstChild("MapBoundaryWalls")

			if oldWalls then
				oldWalls:Destroy()
			end

			local folder = Instance.new("Folder")
			folder.Name = "MapBoundaryWalls"
			folder.Parent = workspace

			local wallHeight = 40
			local wallThickness = 2

			local function createWall(size, offset)

				local wall = Instance.new("Part")
				wall.Size = size
				wall.Anchored = true
				wall.CanCollide = true
				wall.CanTouch = false
				wall.CanQuery = false
				wall.Transparency = 1
				wall.CFrame = ground.CFrame * CFrame.new(offset)
				wall.Parent = folder

			end

			local y =
				ground.Size.Y / 2
				+ wallHeight / 2

			createWall(
				Vector3.new(
					ground.Size.X,
					wallHeight,
					wallThickness
				),
				Vector3.new(
					0,
					y,
					-ground.Size.Z / 2
				)
			)

			createWall(
				Vector3.new(
					ground.Size.X,
					wallHeight,
					wallThickness
				),
				Vector3.new(
					0,
					y,
					ground.Size.Z / 2
				)
			)

			createWall(
				Vector3.new(
					wallThickness,
					wallHeight,
					ground.Size.Z
				),
				Vector3.new(
					-ground.Size.X / 2,
					y,
					0
				)
			)

			createWall(
				Vector3.new(
					wallThickness,
					wallHeight,
					ground.Size.Z
				),
				Vector3.new(
					ground.Size.X / 2,
					y,
					0
				)
			)

		end

	end
end

return MapBoundary
