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

```
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
            
drawMaps(baseEditable, leftLimbsEditableImage, R15Maps.leftLimbs :: any)
drawMaps(baseEditable, rightLimbsEditableImage, R15Maps.rightLimbs :: any)
drawMaps(baseEditable, torsoEditableImage, R15Maps.torso :: any)

return self
```
]=]


local futures = require(script.Parent.Parent.roblox_packages["luau-futures"])
local gt = require(script.Parent.Parent.roblox_packages.greentea)

local ContentType: Content = gt.custom(function(t) return typeof(t) == 'Content' end, "Content")

local ContentBuildType = gt.build(ContentType)

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

local BodyColorsBuildType = gt.build(bodyColorsType)

local R15ClothingBuildType = gt.build(gt.struct({
    leftLimbsTexture = ContentType,
    rightLimbsTexture = ContentType,
    torsoTexture = ContentType,

    leftLimbsImage = EditableImageType,
    rightLimbsImage = EditableImageType,
    torsoImage = EditableImageType,

    bodyColors = bodyColorsType,

    maps = gt.struct({
        [gt.string()] = gt.struct({
            [gt.number()] = gt.struct({
                position = gt.Vector2(),
				size = gt.Vector2(),
				drawPosition = gt.Vector2(),
				rotation = gt.optional(gt.number()),
            })
        })
    }),
}))

export type R15ClothingImpl = {
    __index: R15ClothingImpl,

    withBodyColors: (self: R15Clothing, bodyColors: typeof(bodyColorsType)) -> (),
    withContent: (self: R15Clothing, content: Content) -> futures.Future<nil, R15Clothing>,

    applyShirt: (self: R15Clothing, characterModel: Model) -> (),
    applyPants: (self: R15Clothing, characterModel: Model) -> (),
    delete: (self: R15Clothing) -> (),
}

export type R15Clothing = typeof(setmetatable({} :: typeof(R15ClothingBuildType:type()), {} :: R15ClothingImpl))

local R15Clothing = {} :: R15ClothingImpl
R15Clothing.__index = R15Clothing

local function R15ClothingIs(value): boolean
	if type(value) == "table" and getmetatable(value) == R15Clothing then
		R15ClothingBuildType:assert(value)

		return true
	end
	return false
end

local R15ClothingType = gt.build(gt.custom(R15ClothingIs, "R15Clothing"))

function R15Clothing.withContent(self, content)
    ContentBuildType:assert(content)
    
end

function R15Clothing.withBodyColors(self, bodyColors)
    R15ClothingType:assert(self)
    BodyColorsBuildType:assert(bodyColors)
    self.bodyColors = bodyColors
    return self
end

function R15Clothing.applyPants(self, characterModel)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)
    
end

function R15Clothing.applyShirt(self, characterModel)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)
    
end

function R15Clothing.delete(self)
    R15ClothingType:assert(self);
    (self.leftLimbsTexture.Object :: EditableImage):Destroy();
    (self.rightLimbsTexture.Object :: EditableImage):Destroy();
    (self.torsoTexture.Object :: EditableImage):Destroy();
    self = setmetatable(self :: any, nil :: any)
end

return R15Clothing