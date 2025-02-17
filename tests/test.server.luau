local rbxclothing = require(game:GetService('ReplicatedStorage'):WaitForChild('rbxclothing'))
local R15Clothing = rbxclothing.R15Clothing

local clothing = R15Clothing.new()
clothing.bodyColors = { Head = Color3.new(255, 0, 0) }

local c = clothing:withContent(Content.fromAssetId(85420273217173)):await():unwrapOk()

print(c:applyPants(workspace:WaitForChild('Rig')))

-- local clothing = clothing:withContent(content):await()
-- clothing.source = EditableImage
