local rbxclothing = require(game:GetService('ReplicatedStorage'):WaitForChild('rbxclothing'))
local config = require(script:WaitForChild('config'))

for i, v in config.rigNames do
    local rig = workspace:WaitForChild(v)

    if not v then
        continue
    end

    local shirtClothing = rbxclothing.R15Clothing.new(Content.fromAssetId(config.assetIds[i][1])):unwrap():unwrapOk()
    local pantClothing = rbxclothing.R15Clothing.new(Content.fromAssetId(config.assetIds[i][2])):unwrap():unwrapOk()

    pantClothing:applyPants(rig)
    shirtClothing:applyShirt(rig)
end
