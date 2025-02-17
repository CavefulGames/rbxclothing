local AssetService = game:GetService('AssetService')
local drawMaps = require(script.util.drawMaps)
local futures = require(script.Packages["luau-futures"])
local gt = require(script.Packages.greentea)
local maps = require(script.util.maps)
local R15Clothing = require(script.R15Clothing)

local ContentBuildType = gt.build(gt.custom(function(t) return typeof(t) == 'Content' end, "Content"))

export type Rbxclothing = {
    R15Clothing: {
        new: (content: Content) -> futures.Future<nil, R15Clothing.R15Clothing>,
        maps: maps.R15ClothingMaps,
    },
}

local rbxclothing = {} :: Rbxclothing
rbxclothing.R15Clothing = {
    new = function(content)
        ContentBuildType:assert(content)
        return futures.Future.new(function(content: Content)
            local baseEditable = AssetService:CreateEditableImageAsync(content)
            
            local leftLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
            local rightLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
            local torsoEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(388, 272) }

            drawMaps(baseEditable, leftLimbsEditableImage, maps.R15Clothing.leftLimbs :: any)
            drawMaps(baseEditable, rightLimbsEditableImage, maps.R15Clothing.rightLimbs :: any)
            drawMaps(baseEditable, torsoEditableImage, maps.R15Clothing.torso :: any)

            return setmetatable({
                leftLimbsTexture = Content.fromObject(leftLimbsEditableImage),
                rightLimbsTexture = Content.fromObject(rightLimbsEditableImage),
                torsoTexture = Content.fromObject(torsoEditableImage),
            }, R15Clothing) :: R15Clothing.R15Clothing
        end, content) :: any
    end,
    maps = maps.R15Clothing, 
}

return rbxclothing