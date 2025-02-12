local rbxclothing = require(game:GetService('ReplicatedStorage'):WaitForChild('rbxclothing'))

local clothing = rbxclothing.R15.new(Content.fromAssetId(87742782608088)):unwrap()

local Rig = workspace:WaitForChild('Rig')

Rig.UpperTorso.TextureContent = clothing.torsoTexture

clothing:apply(Rig)

