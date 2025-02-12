local AssetService = game:GetService('AssetService')
local pixel = require('./pixel')

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

local function drawEdit(baseEditableImage: EditableImage, wred: EditableImage, pixel: {
	[string]: {
		position: Vector2,
		size: Vector2,
		drawPosition: Vector2,
		rotation: number?,
	}
})
	for k, v in pixel do
		local buf = baseEditableImage:ReadPixelsBuffer(
			v.position,
			v.size + Vector2.one
		)

		if (v :: any).rotation then
			local drawEditableImage = AssetService:CreateEditableImage { Size = v.size + Vector2.one }
			drawEditableImage:WritePixelsBuffer(Vector2.zero, v.size + Vector2.one, buf)

			wred:DrawImageTransformed(
				v.drawPosition + (v.size + Vector2.one) / 2,
				Vector2.one,
				(v :: any).rotation,
				drawEditableImage
			)
			
			drawEditableImage:Destroy()
			
			continue
		end

		wred:WritePixelsBuffer(
			v.drawPosition,
			v.size + Vector2.one,
			buf
		)
	end
end

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

	drawEdit(self.editableImage, leftLimbsEditableImage, pixel.R15.leftLimbs :: any)
    drawEdit(self.editableImage, rightLimbsEditableImage, pixel.R15.rightLimbs :: any)
    drawEdit(self.editableImage, torsoEditableImage, pixel.R15.torso :: any)

    return setmetatable({
        leftLimbsTexture = Content.fromObject(leftLimbsEditableImage),
        rightLimbsTexture = Content.fromObject(rightLimbsEditableImage),
        torsoTexture = Content.fromObject(torsoEditableImage),
    }, result)
end

return R15