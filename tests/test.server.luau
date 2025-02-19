local rbxclothing = require(game:GetService('ReplicatedStorage'):WaitForChild('rbxclothing'))
local R15Clothing = rbxclothing.R15Clothing

local clothing = R15Clothing.new()
local clothing = clothing:withContent(Content.fromAssetId(85420273217173)):await():unwrapOk()
print(clothing)
clothing:applyShirt(workspace:WaitForChild('Rig'))

