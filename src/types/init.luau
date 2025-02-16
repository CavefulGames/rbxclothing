local futures = require(script.Parent:WaitForChild('Packages'):WaitForChild('luau_futures'))
local maps = require(script:WaitForChild('maps'))
local R15Clothing = require(script:WaitForChild('R15Clothing'))

--[=[
```luau
local rbxclothing = rbxclothing
```
]=]
export type Rbxclothing = {
    R15Clothing: {
        new: (content: Content) -> futures.Poll<Content, R15Clothing>,
        maps: maps.R15ClothingMaps,
    },
}

--[=[
```luau
local clothing = rbxclothing.R15Clothing.new(content):unwrap()
```
]=]
export type R15Clothing = R15Clothing.Clothing

export type R15ClothingImpl = R15Clothing.ClothingImpl

export type Maps = maps.Maps

return {}