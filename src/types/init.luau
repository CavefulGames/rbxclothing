local futures = require(script.Parent:WaitForChild('Packages'):WaitForChild('luau-futures'))
local maps = require(script:WaitForChild('maps'))
local R15Clothing = require(script:WaitForChild('R15Clothing'))

--[=[
```luau
local rbxclothing = rbxclothing
```
]=]
export type Rbxclothing = {
    R15Clothing: {
        new: (content: Content) -> futures.Future<nil, R15Clothing>,
        maps: maps.R15ClothingMaps,
    },
}

--[=[
```luau
local clothing = rbxclothing.R15Clothing.new(content):unwrap()
```
]=]
export type R15Clothing = R15Clothing.R15Clothing

export type R15ClothingImpl = R15Clothing.R15ClothingImpl

export type Maps = maps.Maps

return {}