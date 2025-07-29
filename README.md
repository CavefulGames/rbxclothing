# rbxclothing
rbxclothing is a library that allows you to put on pants and shirts using EditableImage without using Humanoid

## Installation
via pesde
```sh
pesde add caveful_games/rbxclothing
```

## Example
example.client.luau
```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rbxclothing = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("rbxclothing"))
local R15Clothing = rbxclothing.R15Clothing

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local character: Model = player.Character or player.CharacterAdded:Wait()

local scale = 0.5

local id = 85420273217173
local content = Content.fromAssetId(id)

local clothing = R15Clothing.new(scale):withContentAsync(content)

clothing:applyShirt(character)
```

## Note
Roblox's `EditableImage` has a memory usage limit

## Dependencies
[greentea](https://github.com/Corecii/GreenTea) <br>
