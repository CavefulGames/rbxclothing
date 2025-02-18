local AssetService = game:GetService('AssetService')
local drawMaps = require(script.util.drawMaps)
local futures = require(script.Parent.roblox_packages["luau-futures"])
local gt = require(script.Parent.roblox_packages.greentea)
local maps = require(script.R15Clothing.maps)
local R15Clothing = require(script.R15Clothing)

local ContentOptBuildType = gt.build(gt.optional(gt.custom(function(t) return typeof(t) == 'Content' end, "Content")))

export type Rbxclothing = {
    R15Clothing: {
        new: ((content: Content) -> futures.Future<nil, R15Clothing.R15Clothing>) & (() -> R15Clothing.R15Clothing),
        maps: maps.R15ClothingMaps,
    },
}

local rbxclothing = {} :: Rbxclothing
rbxclothing.R15Clothing = {
    new = function(content)
        ContentOptBuildType:assert(content)
        local future = futures.Future.new(function(content: Content)
            local leftLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
            local rightLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
            local torsoEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(388, 272) }

            local self = setmetatable({
                leftLimbsTexture = Content.fromObject(leftLimbsEditableImage),
                rightLimbsTexture = Content.fromObject(rightLimbsEditableImage),
                torsoTexture = Content.fromObject(torsoEditableImage),

                leftLimbsImage = leftLimbsEditableImage,
                rightLimbsImage = rightLimbsEditableImage,
                torsoImage = torsoEditableImage,

                bodyColors = {},
            }, R15Clothing) :: R15Clothing.R15Clothing

            if not content.Object then
                return self
            end

            local baseEditable = AssetService:CreateEditableImageAsync(content)
            
            drawMaps(baseEditable, leftLimbsEditableImage, maps.R15Clothing.leftLimbs :: any)
            drawMaps(baseEditable, rightLimbsEditableImage, maps.R15Clothing.rightLimbs :: any)
            drawMaps(baseEditable, torsoEditableImage, maps.R15Clothing.torso :: any)

            return self
        end, content or Content.none)

        return (not content and future:await():unwrapOk() or future) :: any
    end,
    maps = maps.R15Clothing, 
}

return rbxclothing