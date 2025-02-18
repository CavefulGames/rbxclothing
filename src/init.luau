local AssetService = game:GetService('AssetService')
local drawMaps = require(script.util.drawMaps)
local futures = require(script.Parent.roblox_packages["luau-futures"])
local gt = require(script.Parent.roblox_packages.greentea)
local R15Maps = require(script.R15Clothing.maps)
local R15Clothing = require(script.R15Clothing)

local ContentOptBuildType = gt.build(gt.optional(gt.custom(function(t) return typeof(t) == 'Content' end, "Content")))

export type Rbxclothing = {
    R15Clothing: {
        new: ((content: Content) -> futures.Future<nil, R15Clothing.R15Clothing>) & (() -> R15Clothing.R15Clothing),
        maps: R15Maps.R15ClothingMaps,
    },
}

local rbxclothing = {} :: Rbxclothing
rbxclothing.R15Clothing = {
    new = function(content)
        ContentOptBuildType:assert(content)
        
    end,
    maps = R15Maps, 
}

return rbxclothing