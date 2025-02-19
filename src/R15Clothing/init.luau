local AssetService = game:GetService('AssetService')
local drawMaps = require(script.Parent.util.drawMaps)
local futures = require(script.Parent.Parent.roblox_packages["luau-futures"])
local gt = require(script.Parent.Parent.roblox_packages.greentea)
local maps = require(script.maps) 

local InstanceBodyColorsBuildType: BodyColors = gt.custom(function(t) return t.ClassName == 'BodyColors' end, "BodyColors")

local ContentType: Content = gt.custom(function(t) return typeof(t) == 'Content' end, "Content")

local ContentBuildType = gt.build(ContentType)

local EditableImageType: EditableImage = gt.custom(function(t) return typeof(t) == 'Object' end, "EditableImage")

local NumberOptBuildType = gt.build(gt.optional(gt.number()))

local ModelBuildType = gt.build(gt.custom(function(t) return t.ClassName == 'Model' end, "Model"))

local BodyColorsType = gt.struct({
    Head = gt.optional(gt.Color3()),
    UpperTorso = gt.optional(gt.Color3()),
    LowerTorso = gt.optional(gt.Color3()),
    RightFoot = gt.optional(gt.Color3()),
    RightLowerLeg = gt.optional(gt.Color3()),
    RightUpperLeg = gt.optional(gt.Color3()),
    LeftFoot = gt.optional(gt.Color3()),
    LeftLowerLeg = gt.optional(gt.Color3()),
    LeftUpperLeg = gt.optional(gt.Color3()),
    RightHand = gt.optional(gt.Color3()),
    RightLowerArm = gt.optional(gt.Color3()),
    RightUpperArm = gt.optional(gt.Color3()),
    LeftHand = gt.optional(gt.Color3()),
    LeftLowerArm = gt.optional(gt.Color3()),
    LeftUpperArm = gt.optional(gt.Color3()),
})

local ParamBodyColorsBuildType  = gt.build(gt.union(BodyColorsType, InstanceBodyColorsBuildType))

local R15ClothingBuildType = gt.build(gt.struct({
    leftLimbsTexture = ContentType,
    rightLimbsTexture = ContentType,
    torsoTexture = ContentType,

    leftLimbsImage = EditableImageType,
    rightLimbsImage = EditableImageType,
    torsoImage = EditableImageType,

    maps = (gt.any()) :: maps.R15ClothingMaps,
}))

export type R15ClothingImpl = {
    __index: R15ClothingImpl,

    new: (scale: number?) -> R15Clothing,
    draw: typeof(drawMaps),
    is: (self: R15Clothing) -> boolean,
    withContent: (self: R15Clothing, content: Content) -> futures.Future<any, R15Clothing>,

    applyShirt: (self: R15Clothing, characterModel: Model) -> (),
    applyPants: (self: R15Clothing, characterModel: Model) -> (),
    delete: (self: R15Clothing) -> (),
}

export type R15Clothing = typeof(setmetatable({} :: typeof(R15ClothingBuildType:type()), {} :: R15ClothingImpl))

local R15Clothing = {} :: R15ClothingImpl
R15Clothing.__index = R15Clothing

function R15Clothing.new(scale)
    NumberOptBuildType:assert(scale)
    
    local scale = scale or 1

    local leftLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) * scale }
    local rightLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) * scale }
    local torsoEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(388, 272) * scale }
    
    return setmetatable({
        leftLimbsTexture = Content.fromObject(leftLimbsEditableImage),
        rightLimbsTexture = Content.fromObject(rightLimbsEditableImage),
        torsoTexture = Content.fromObject(torsoEditableImage),
    
        leftLimbsImage = leftLimbsEditableImage,
        rightLimbsImage = rightLimbsEditableImage,
        torsoImage = torsoEditableImage,
    
        bodyColors = {},
        maps = maps,
    }, R15Clothing) :: R15Clothing
end

R15Clothing.draw = drawMaps

function R15Clothing.is(self)
	return type(self) == "table" and getmetatable(self) == R15Clothing and R15ClothingBuildType:matches(self) 
end

local R15ClothingType = gt.build(gt.custom(R15Clothing.is, "R15Clothing"))

function R15Clothing.withContent(self, content)
    R15ClothingType:assert(self)
    ContentBuildType:assert(content)

    return futures.Future.new(function(content: Content)
        if content.SourceType == Enum.ContentSourceType.None then
            return self
        end 
        
        local editableImage = AssetService:CreateEditableImageAsync(content)
        
        drawMaps(editableImage, self.leftLimbsImage, maps.leftLimbs :: any)
        drawMaps(editableImage, self.rightLimbsImage, maps.rightLimbs :: any)
        drawMaps(editableImage, self.torsoImage, maps.torso :: any)

        return self
    end, content) :: any
end

local function applyEditableImages(applyTable: { [number]: string }, content: Content, characterModel: Model)
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

    self.rightLimbsTexture = Content.fromObject(self.rightLimbsImage)
    self.leftLimbsTexture = Content.fromObject(self.leftLimbsImage)
    self.torsoTexture = Content.fromObject(self.torsoImage)

    applyEditableImages({
        "RightFoot",
        "RightLowerLeg",
        "RightUpperLeg"
    }, self.rightLimbsTexture, characterModel)

    applyEditableImages({
        "LeftFoot",
        "LeftLowerLeg",
        "LeftUpperLeg"
    }, self.leftLimbsTexture, characterModel)

    applyEditableImages({
        "LowerTorso",
        "UpperTorso",
    }, self.torsoTexture, characterModel)
end

function R15Clothing.applyShirt(self, characterModel)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)
    
    self.rightLimbsTexture = Content.fromObject(self.rightLimbsImage)
    self.leftLimbsTexture = Content.fromObject(self.leftLimbsImage)
    self.torsoTexture = Content.fromObject(self.torsoImage)

    applyEditableImages({
        "RightHand",
        "RightLowerArm",
        "RightUpperArm"
    }, self.rightLimbsTexture, characterModel)

    applyEditableImages({
        "LeftHand",
        "LeftLowerArm",
        "LeftUpperArm"
    }, self.leftLimbsTexture, characterModel)

    applyEditableImages({
        "LowerTorso",
        "UpperTorso",
    }, self.torsoTexture, characterModel)
end

function R15Clothing.delete(self)
    R15ClothingType:assert(self);
    (self.leftLimbsTexture.Object :: EditableImage):Destroy();
    (self.rightLimbsTexture.Object :: EditableImage):Destroy();
    (self.torsoTexture.Object :: EditableImage):Destroy();
    self = setmetatable(self :: any, nil :: any)
end

return R15Clothing