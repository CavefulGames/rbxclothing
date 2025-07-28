local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rbxclothing = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("rbxclothing"))
local R15Clothing = rbxclothing.R15Clothing

local character: Model = player.Character or player.CharacterAdded:Wait()

do
	local shirt = character:FindFirstChildOfClass("Shirt")
    local content = Content.fromAssetId(85420273217173)

	if shirt then
        -- local id = string.match(shirt.ShirtTemplate, "%?id=(.*)$")
        -- print(InsertService:LoadAsset(tonumber(id)))
        content = Content.fromUri(shirt.ShirtTemplate)
    end

    local clothing = R15Clothing.new(0.5):withContentAsync(content)

    clothing:applyShirt(character)
end
