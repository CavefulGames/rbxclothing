local AssetService = game:GetService('AssetService')
local drawMaps = require(script:WaitForChild('util'):WaitForChild('drawMaps'))
local futures = require(script:WaitForChild('Packages'):WaitForChild('luau-futures'))
local types = require(script:WaitForChild('types'))
local maps = require(script:WaitForChild('util'):WaitForChild('maps')).R15Clothing
local R15Clothing = require(script:WaitForChild('R15Clothing'))

local rbxclothing = {} :: types.Rbxclothing
rbxclothing.R15Clothing = {
    new = function(content)
        local future = futures.Future.new(function(content: Content)
            local baseEditable = AssetService:CreateEditableImageAsync(content)
            
            local leftLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
            local rightLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
            local torsoEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(388, 272) }

            drawMaps(baseEditable, leftLimbsEditableImage, maps.leftLimbs :: any)
            drawMaps(baseEditable, rightLimbsEditableImage, maps.rightLimbs :: any)
            drawMaps(baseEditable, torsoEditableImage, maps.torso :: any)

            return setmetatable({
                leftLimbsTexture = Content.fromObject(leftLimbsEditableImage),
                rightLimbsTexture = Content.fromObject(rightLimbsEditableImage),
                torsoTexture = Content.fromObject(torsoEditableImage),
            }, R15Clothing) :: types.R15Clothing
        end, content)

        future:await()
        
        return future:poll()
    end,
    maps = maps, 
}

return rbxclothing