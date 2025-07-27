local AssetService = game:GetService("AssetService")
local drawMap = require(script.Parent.drawMap)
local gt = require(script.Parent.Parent.roblox_packages.greentea)
local maps = require(script.maps)

local ContentBuildType = gt.isTypeof("Content")

local EditableImageType: EditableImage = gt.custom(function(t)
	return typeof(t) == "Object" and t:IsA("EditableImage")
end)

local NumberOptBuildType = gt.build(gt.optional(gt.number()))

local ModelBuildType = gt.build(gt.isA("Model") :: Model)

local R15ClothingBuildType = gt.build(gt.struct({
	leftLimbsImage = EditableImageType,
	rightLimbsImage = EditableImageType,
	torsoImage = EditableImageType,

	maps = (gt.any()) :: maps.R15ClothingMaps,
	scale = gt.number(),
}))

--[=[
    @class R15Clothing

    R15's clothing
]=]
export type R15ClothingImpl = {
	__index: R15ClothingImpl,

    --[=[
        @within R15Clothing

        R15Clothing type

        ```luau
        type R15Clothing = typeof(R15Clothing.type)
        ```
    ]=]
	type: typeof(R15ClothingBuildType:type()),

    --[=[
        @within R15Clothing

        Create a R15Clothing

        ```luau
        local clothing = R15Clothing.new()
        ```

        @param scale -- The scale of editableimage
    ]=]
	new: (scale: typeof(NumberOptBuildType:type())) -> R15Clothing,

    --[=[
        @within R15Clothing
    
        Check the param is R15Clothing

        ```luau
        local isR15Clothing: boolean = R15Clothing.is(self)
        ```
    ]=]
	is: (self: R15Clothing) -> boolean,

    --[=[
        @within R15Clothing

        Add content with content

        ```luau
        local clothing = R15Clothing.new():withContentAsync(Content.fromAssetId(AssetId))
        ```

        @param content -- Content to add
    ]=]
	withContentAsync: (self: R15Clothing, content: Content) -> R15Clothing,

    --[=[
        @within R15Clothing

        Apply shirt to the model

        ```luau
        local clothing = R15Clothing.new():withContentAsync(Content.fromAssetId(AssetId))
        clothing:applyShirt(workspace.Rig)
        ```

        @param characterModel -- Target to apply
    ]=]
	applyShirt: (self: R15Clothing, characterModel: typeof(ModelBuildType:type())) -> (),

    --[=[
        @within R15Clothing

        Apply pants to the model

        ```luau
        local clothing = R15Clothing.new():withContentAsync(Content.fromAssetId(AssetId))
        clothing:applyPants(workspace.Rig)
        ```

        @param characterModel -- Target to apply
    ]=]
	applyPants: (self: R15Clothing, characterModel: typeof(ModelBuildType:type())) -> (),

    --[=[
        @within R15Clothing

        Delete editable image and self

        ```luau
        local clothing = R15Clothing.new():withContentAsync(Content.fromAssetId(AssetId))
        clothing:applyPants(workspace.Rig)
        clothing:delete()
        ```
    ]=]
    delete: (self: R15Clothing) -> (),
}

export type R15Clothing = typeof(setmetatable({} :: typeof(R15ClothingBuildType:type()), {} :: R15ClothingImpl))

local R15Clothing = {} :: R15ClothingImpl
R15Clothing.__index = R15Clothing

function R15Clothing.new(scale)
	NumberOptBuildType:assert(scale)

	local scale = scale or 1

	local leftLimbsEditableImage = AssetService:CreateEditableImage({ Size = Vector2.new(264, 284) * scale })
	local rightLimbsEditableImage = AssetService:CreateEditableImage({ Size = Vector2.new(264, 284) * scale })
	local torsoEditableImage = AssetService:CreateEditableImage({ Size = Vector2.new(388, 272) * scale })

	return setmetatable({
		leftLimbsImage = leftLimbsEditableImage,
		rightLimbsImage = rightLimbsEditableImage,
		torsoImage = torsoEditableImage,

		maps = maps,
		scale = scale,
	}, R15Clothing) :: R15Clothing
end

function R15Clothing.is(self)
	if type(self) == "table" and getmetatable(self) == R15Clothing then
		R15ClothingBuildType:assert(self)

		return true
	end
	return false
end

R15Clothing.type = R15ClothingBuildType:type()

local R15ClothingType = gt.build(gt.custom(R15Clothing.is, "R15Clothing"))

function R15Clothing.withContentAsync(self, content)
	R15ClothingType:assert(self)
	ContentBuildType:assert(content)

	local editableImage = AssetService:CreateEditableImageAsync(content)

	drawMap(editableImage, self.leftLimbsImage, maps.leftLimbs :: any, self.scale)
	drawMap(editableImage, self.rightLimbsImage, maps.rightLimbs :: any, self.scale)
	drawMap(editableImage, self.torsoImage, maps.torso :: any, self.scale)
	
	return self
end

local function applyEditableImages(
	applyTable: { [number]: string },
	editableImage: EditableImage,
	characterModel: Model
)
	local content = Content.fromObject(editableImage)
	for _, v in applyTable do
		local target = characterModel:FindFirstChild(v) :: MeshPart

		if not target then
			continue
		end

		target.TextureContent = content
	end
end

function R15Clothing.applyPants(self, characterModel)
	R15ClothingType:assert(self)
	ModelBuildType:assert(characterModel)

	applyEditableImages({
		"RightFoot",
		"RightLowerLeg",
		"RightUpperLeg",
	}, self.rightLimbsImage, characterModel)

	applyEditableImages({
		"LeftFoot",
		"LeftLowerLeg",
		"LeftUpperLeg",
	}, self.leftLimbsImage, characterModel)

	applyEditableImages({
		"LowerTorso",
		"UpperTorso",
	}, self.torsoImage, characterModel)
end

function R15Clothing.applyShirt(self, characterModel)
	R15ClothingType:assert(self)
	ModelBuildType:assert(characterModel)

	applyEditableImages({
		"RightHand",
		"RightLowerArm",
		"RightUpperArm",
	}, self.rightLimbsImage, characterModel)

	applyEditableImages({
		"LeftHand",
		"LeftLowerArm",
		"LeftUpperArm",
	}, self.leftLimbsImage, characterModel)

	applyEditableImages({
		"LowerTorso",
		"UpperTorso",
	}, self.torsoImage, characterModel)
end

function R15Clothing.delete(self)
	R15ClothingType:assert(self)
	self.leftLimbsImage:Destroy()
	self.rightLimbsImage:Destroy()
	self.torsoImage:Destroy()
	self = setmetatable(self :: any, nil :: any)
end

return R15Clothing
