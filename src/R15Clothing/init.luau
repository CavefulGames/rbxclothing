local AssetService = game:GetService('AssetService')
local drawMaps = require(script.Parent.util.drawMaps)
local futures = require(script.Parent.Parent.roblox_packages["luau-futures"])
local gt = require(script.Parent.Parent.roblox_packages.greentea)
local maps = require(script.maps)

local ContentType: Content = gt.custom(function(t) return typeof(t) == 'Content' end, "Content")

local EditableImageType: EditableImage = gt.custom(function(t) return typeof(t) == 'Object' end, "EditableImage")

local ModelBuildType = gt.build(gt.custom(function(t) return t.ClassName == 'Model' end, "Model"))

local bodyColorsType = gt.struct({
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

local R15ClothingBuildType = gt.build(gt.struct({
    leftLimbsTexture = ContentType,
    rightLimbsTexture = ContentType,
    torsoTexture = ContentType,

    leftLimbsImage = EditableImageType,
    rightLimbsImage = EditableImageType,
    torsoImage = EditableImageType,

    bodyColors = bodyColorsType
}))

export type R15ClothingImpl = {
    __index: R15ClothingImpl,

    withBodyColors: (self: R15Clothing, bodyColors: BodyColors) -> (),
    withContent: (self: R15Clothing, content: Content) -> futures.Future<nil, R15Clothing>,

    applyShirt: (self: R15Clothing, characterModel: Model) -> (),
    applyPants: (self: R15Clothing, characterModel: Model) -> (),
    delete: (self: R15Clothing) -> (),
}

--[=[
```luau
local clothing = rbxclothing.R15Clothing.new(content):unwrap()
```
]=]
export type R15Clothing = typeof(setmetatable({} :: typeof(R15ClothingBuildType:type()), {} :: R15ClothingImpl))

local R15Clothing = {} :: R15ClothingImpl
R15Clothing.__index = R15Clothing

function R15Clothing.withBodyColors(self, bodyColors)
    self.bodyColors.Head = bodyColors.HeadColor3
    self.bodyColors.LeftFoot = bodyColors.LeftLegColor3
    self.bodyColors.LeftLowerLeg = bodyColors.LeftLegColor3
    self.bodyColors.LeftUpperLeg = bodyColors.LeftLegColor3
    self.bodyColors.RightFoot = bodyColors.RightLegColor3
    self.bodyColors.RightLowerLeg = bodyColors.RightLegColor3
    self.bodyColors.RightUpperLeg = bodyColors.RightLegColor3
    self.bodyColors.LeftHand = bodyColors.LeftArmColor3
    self.bodyColors.LeftLowerArm = bodyColors.LeftArmColor3
    self.bodyColors.LeftUpperArm = bodyColors.LeftArmColor3
    self.bodyColors.RightHand = bodyColors.RightArmColor3
    self.bodyColors.RightLowerArm = bodyColors.RightArmColor3
    self.bodyColors.RightUpperArm = bodyColors.RightArmColor3
    self.bodyColors.LowerTorso = bodyColors.TorsoColor3
    self.bodyColors.UpperTorso = bodyColors.TorsoColor3

    return self
end

function R15Clothing.withContent(self, content)
    return futures.Future.new(function(content: Content)
        local leftLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
        local rightLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) }
        local torsoEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(388, 272) }

        self = setmetatable({
            leftLimbsTexture = Content.fromObject(leftLimbsEditableImage),
            rightLimbsTexture = Content.fromObject(rightLimbsEditableImage),
            torsoTexture = Content.fromObject(torsoEditableImage),

            leftLimbsImage = leftLimbsEditableImage,
            rightLimbsImage = rightLimbsEditableImage,
            torsoImage = torsoEditableImage,

            bodyColors = {},
        }, R15Clothing) :: R15Clothing

        if not content.Object then
            return self
        end

        local baseEditable = AssetService:CreateEditableImageAsync(content)
        
        drawMaps(baseEditable, leftLimbsEditableImage, maps.R15Clothing.leftLimbs :: any)
        drawMaps(baseEditable, rightLimbsEditableImage, maps.R15Clothing.rightLimbs :: any)
        drawMaps(baseEditable, torsoEditableImage, maps.R15Clothing.torso :: any)

        return self
    end, content) :: any
end

local function R15ClothingIs(value): boolean
	if type(value) == "table" and getmetatable(value) == R15Clothing then
		R15ClothingBuildType:assert(value)

		return true
	end
	return false
end

local R15ClothingType = gt.build(gt.custom(R15ClothingIs, "R15Clothing"))

local bodyParts = {
    torso = {
        "UpperTorso",
        "LowerTorso",
    },
    pants = {
        leftLimbsTexture = {
            "LeftFoot",
            "LeftLowerLeg",
            "LeftUpperLeg",
        },
        rightLimbsTexture = {
            "RightFoot",
            "RightLowerLeg",
            "RightUpperLeg",
        },
    },
    shirt = {
        leftLimbsTexture = {
            "LeftHand",
            "LeftLowerArm",
            "LeftUpperArm",
        },
        rightLimbsTexture = {
            "RightHand",
            "RightLowerArm",
            "RightUpperArm",
        },
    },
}

local function syncClothing(self: R15Clothing, characterModel: Model)
    self.leftLimbsTexture = Content.fromObject(self.leftLimbsImage)
    self.rightLimbsTexture = Content.fromObject(self.rightLimbsImage)
    self.torsoTexture = Content.fromObject(self.torsoImage)

    for k, v in bodyParts.torso do
        local color = self.bodyColors[v]

        if not color then
            continue
        end

        local target = characterModel:FindFirstChild(v)

        if not target then
            continue
        end

        (target :: MeshPart).Color = color
    end

    for _, t in bodyParts.shirt do
        for k, v in t :: any do
            local color = self.bodyColors[v]
    
            if not color then
                continue
            end
    
            local target = characterModel:FindFirstChild(v)
    
            if not target then
                continue
            end
    
            (target :: MeshPart).Color = color
        end
    end

    for _, t in bodyParts.pants do
        for k, v in t :: any do
            local color = self.bodyColors[v]
    
            if not color then
                continue
            end
    
            local target = characterModel:FindFirstChild(v)
    
            if not target then
                continue
            end
    
            (target :: MeshPart).Color = color
        end
    end

    if not self.bodyColors.Head then
        return
    end

    if not characterModel:FindFirstChild('Head') then
        return
    end

    (characterModel:FindFirstChild('Head') :: MeshPart).Color = self.bodyColors.Head
end

local function applyTorso(self: R15Clothing, characterModel: Model)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)

    for _, v in bodyParts.torso do
        local target = characterModel:FindFirstChild(v)
            
        if not target then
            continue
        end
        
        (target :: MeshPart).TextureContent = self.torsoTexture
    end
end

function R15Clothing.applyPants(self, characterModel)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)
    
    syncClothing(self, characterModel)

    for k, v in bodyParts.pants do
        for _, t in v :: any do
            local target = characterModel:FindFirstChild(t)
            
            if not target then
                continue
            end
            
            (target :: MeshPart).TextureContent = self[k]
        end 
        
    end

    applyTorso(self, characterModel)
end

function R15Clothing.applyShirt(self, characterModel)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)
    
    syncClothing(self, characterModel)

    for k, v in bodyParts.shirt do
        for _, t in v :: any do
            local target = characterModel:FindFirstChild(t)
            
            if not target then
                continue
            end
            
            (target :: MeshPart).TextureContent = self[k]
        end 
        
    end

    applyTorso(self, characterModel)
end

function R15Clothing.delete(self)
    R15ClothingType:assert(self);
    (self.leftLimbsTexture.Object :: EditableImage):Destroy();
    (self.rightLimbsTexture.Object :: EditableImage):Destroy();
    (self.torsoTexture.Object :: EditableImage):Destroy();
    self = setmetatable(self :: any, nil :: any)
end

return R15Clothing