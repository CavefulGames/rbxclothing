local rbxclothing = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("rbxclothing"))
local R15Clothing = rbxclothing.R15Clothing

local baseRig = workspace:WaitForChild("Rig") :: Model

local mx = 15
local my = 15

local scale = {
	0.5,
	0.5,
}

--// Get the memory usage of Shirt or Pants
local function getMemory(limbsSize: Vector2?, torsoSize: Vector2?)
	local limbsSize = limbsSize or Vector2.new(264, 284)
	local torsoSize = torsoSize or Vector2.new(388, 272)

	return 4 * limbsSize:Dot(torsoSize)
end

local function formatMemory(memory: number): string
	if memory >= 1024 * 1024 then
		return `{memory / (1024 * 1024)} MB`
	elseif memory >= 1024 then
		return `{memory / 1024} KB`
	else
		return `{memory} B`
	end
end

print("usage memory: ", formatMemory(getMemory()))
