local rbxclothing = require(game:GetService('ReplicatedStorage'):WaitForChild('rbxclothing'))
local config = require(script:WaitForChild('config'))

for i, v in config.rigNames do
    local rig = workspace:WaitForChild(v)

    local shirtClothing = rbxclothing.R15Clothing.new(Content.fromAssetId(config.assetIds[i][1])):await():unwrapOk()
    local pantClothing = rbxclothing.R15Clothing.new(Content.fromAssetId(config.assetIds[i][2])):await():unwrapOk()
    
    pantClothing:applyPants(rig)
    shirtClothing:applyShirt(rig)
end
