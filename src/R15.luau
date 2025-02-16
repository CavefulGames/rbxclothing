local AssetService = game:GetService('AssetService')
local pixel = require('./util/pixel')
local draw = require('./util/draw')

export type R15 = typeof(setmetatable({} :: {
    editableImage: EditableImage,
}, {} :: R15Impl))

export type Result = typeof(setmetatable({} :: {
    leftLimbsTexture: Content,
    rightLimbsTexture: Content,
    torsoTexture: Content,
}, {} :: ResultImpl))

export type ResultImpl = {
    __index: ResultImpl,
    apply: (self: Result, characterModel: Model & { [string]: MeshPart } & any) -> (),
}

export type R15Impl = {
    __index: R15Impl,
    unwrap: (self: R15) -> Result,
}

local result = {} :: ResultImpl
result.__index = result

function result.apply(self, characterModel)
	characterModel['LeftLowerArm'].TextureContent = self.leftLimbsTexture
	characterModel['LeftUpperArm'].TextureContent = self.leftLimbsTexture
	characterModel['LeftHand'].TextureContent = self.leftLimbsTexture
	characterModel['RightLowerArm'].TextureContent = self.rightLimbsTexture
	characterModel['RightUpperArm'].TextureContent = self.rightLimbsTexture
	characterModel['RightHand'].TextureContent = self.rightLimbsTexture
	characterModel['LeftLowerLeg'].TextureContent = self.leftLimbsTexture
	characterModel['LeftUpperLeg'].TextureContent = self.leftLimbsTexture
	characterModel['LeftFoot'].TextureContent = self.leftLimbsTexture
	characterModel['RightLowerLeg'].TextureContent = self.rightLimbsTexture
	characterModel['RightUpperLeg'].TextureContent = self.rightLimbsTexture
	characterModel['RightFoot'].TextureContent = self.rightLimbsTexture
	characterModel['LowerTorso'].TextureContent = self.torsoTexture
	characterModel['UpperTorso'].TextureContent = self.torsoTexture
end

local R15 = {} :: R15Impl
R15.__index = R15

function R15.unwrap(self)
    local leftLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
    local rightLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
    local torsoEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(388, 272) }

	draw(self.editableImage, leftLimbsEditableImage, pixel.R15.leftLimbs :: any)
    draw(self.editableImage, rightLimbsEditableImage, pixel.R15.rightLimbs :: any)
    draw(self.editableImage, torsoEditableImage, pixel.R15.torso :: any)

    return setmetatable({
        leftLimbsTexture = Content.fromObject(leftLimbsEditableImage),
        rightLimbsTexture = Content.fromObject(rightLimbsEditableImage),
        torsoTexture = Content.fromObject(torsoEditableImage),
    }, result)
end

return R15