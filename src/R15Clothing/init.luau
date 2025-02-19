--[=[
TODO
1. with(BodyColors/Content)
```luau
--// 바디컬러받아서 self 의 bodyColors 를 바꿔줌
export type withBodyColors -> (self: R15Clothing, bodyColors: BodyColors) -> () 

--// Content 를 받아서 러스트 with 처럼 self content 를 바꿔줌 (future 사용 (비동기))
export type withContent -> (self: R15Clothing, content: Content) -> ()
```

*2. 지금 현제 픽셀로 처리하는거 이제 비율로 처리하기 
```luau
size = (들어온 이미지 크기 * (Vector2.new(585, 559) / 부위크기))
```

3. 바디컬러 적용하기 (메쉬의 컬러 사용하면 됄듯)
근대 아마도 이건 apply 할때 같이 하면 됄꺼같음

4. new api 바꾸기
```luau
type (scale: number?) -> (clothing)

local leftLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) * scale }
local rightLimbsEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(264, 284) * scale }
local torsoEditableImage = AssetService:CreateEditableImage { Size = Vector2.new(388, 272) * scale }
```
]=]

--[=[
NOTE
```luau
local clothing = R15Clothing.new():withBodyColors(BodyColors)
clothing.bodyColors = { Head = Color3.new() }
local clothing = clothing:withContent(content):await()
clothing.source = EditableImage
```



drawMaps.luau 에 scale 추가하기
]=]

local AssetService = game:GetService('AssetService')
local drawMaps = require(script.Parent.util.drawMaps)
local futures = require(script.Parent.Parent.roblox_packages["luau-futures"])
local gt = require(script.Parent.Parent.roblox_packages.greentea)
local maps = require(script.maps) 

local ContentType: Content = gt.custom(function(t) return typeof(t) == 'Content' end, "Content")

local ContentBuildType = gt.build(ContentType)

local EditableImageType: EditableImage = gt.custom(function(t) return typeof(t) == 'Object' end, "EditableImage")

local NumberOptBuildType = gt.build(gt.optional(gt.number()))

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

local BodyColorsBuildType = gt.build(bodyColorsType)

local R15ClothingBuildType = gt.build(gt.struct({
    leftLimbsTexture = ContentType,
    rightLimbsTexture = ContentType,
    torsoTexture = ContentType,

    leftLimbsImage = EditableImageType,
    rightLimbsImage = EditableImageType,
    torsoImage = EditableImageType,

    bodyColors = bodyColorsType,
    maps = (gt.any()) :: maps.R15ClothingMaps,
}))

export type R15ClothingImpl = {
    __index: R15ClothingImpl,

    new: (scale: number?) -> R15Clothing,
    draw: typeof(drawMaps),
    is: (self: R15Clothing) -> boolean,
    withBodyColors: (self: R15Clothing, bodyColors: typeof(bodyColorsType)) -> R15Clothing,
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

function R15Clothing.withBodyColors(self, bodyColors)
    R15ClothingType:assert(self)
    BodyColorsBuildType:assert(bodyColors)
    self.bodyColors = bodyColors
    return self
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

local function applyBodyColors(self: R15Clothing, characterModel: Model)
    for k, v in self.bodyColors :: { [string]: Color3? } do
        if not v then
            continue
        end
        
        local target = characterModel:FindFirstChild(k) :: MeshPart
        
        if not target then
            continue
        end

        target.Color = v
    end
end

function R15Clothing.applyPants(self, characterModel)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)

    self.rightLimbsTexture = Content.fromObject(self.rightLimbsImage)
    self.leftLimbsTexture = Content.fromObject(self.leftLimbsImage)
    self.torsoTexture = Content.fromObject(self.torsoImage)

    applyBodyColors(self, characterModel)

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

    applyBodyColors(self, characterModel)

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