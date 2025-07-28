local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rbxclothing = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("rbxclothing"))
local R15Clothing = rbxclothing.R15Clothing

local character: Model = player.Character or player.CharacterAdded:Wait()

local assetsIds = {
    shirt = 85420273217173,
    pants = 140429600392212,
}

local scale = 0.5

do
    local content = Content.fromAssetId(assetsIds.shirt)
    local clothing = R15Clothing.new(scale):withContentAsync(content)

    clothing:applyShirt(character)
end

do
    local content = Content.fromAssetId(assetsIds.pants)
    local clothing = R15Clothing.new(scale):withContentAsync(content)

    clothing:applyPants(character)
end

