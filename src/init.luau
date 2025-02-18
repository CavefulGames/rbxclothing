local AssetService = game:GetService('AssetService')
local drawMaps = require(script.util.drawMaps)
local futures = require(script.Parent.roblox_packages["luau-futures"])
local gt = require(script.Parent.roblox_packages.greentea)
local maps = require(script.R15Clothing.maps)
local R15Clothing = require(script.R15Clothing)

local ContentOptBuildType = gt.build(gt.optional(gt.custom(function(t) return typeof(t) == 'Content' end, "Content")))

export type Rbxclothing = {
    R15Clothing: {
        new: (((content: Content) -> futures.Future<nil, R15Clothing.R15Clothing>) & (() -> R15Clothing.R15Clothing)),
        maps: maps.R15ClothingMaps,
    },
}

local rbxclothing = {} :: Rbxclothing
rbxclothing.R15Clothing = setmetatable({
    new = function(content)
        ContentOptBuildType:assert(content)

        local self = (setmetatable({
            maps = maps.R15Clothing,
        }, R15Clothing) :: any) :: R15Clothing.R15Clothing

        return self:withContent(content or Content.none)
    end,
    maps = maps.R15Clothing, 
}, {}) :: any

return rbxclothing