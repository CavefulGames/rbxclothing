local gt = require(script.Parent.Parent.roblox_packages.greentea)

local ContentType: Content = gt.custom(function(t) return typeof(t) == 'Content' end, "Content")

local ModelBuildType = gt.build(gt.custom(function(t) return t.ClassName == 'Model' end, "Model"))

local R15ClothingBuildType = gt.build(gt.struct({
    leftLimbsTexture = ContentType,
    rightLimbsTexture = ContentType,
    torsoTexture = ContentType,
}))

export type R15ClothingImpl = {
    __index: R15ClothingImpl,
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

local function R15ClothingIs(value): boolean
	if type(value) == "table" and getmetatable(value) == R15Clothing then
		R15ClothingBuildType:assert(value)

		return true
	end
	return false
end

local R15ClothingType = gt.build(gt.custom(R15ClothingIs, "R15Clothing"))

local torsoTarget = {
    "UpperTorso",
    "LowerTorso"
}

local pantTarget = {
    "Foot",
    "LowerLeg",
    "UpperLeg",
    "Foot",
    "LowerLeg",
    "UpperLeg",
}

local shirtTarget = {
    "Hand",
    "LowerArm",
    "UpperArm",
    "Hand",
    "LowerArm",
    "UpperArm",
}

local function applyTorso(self: R15Clothing, characterModel: Model)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)
    
    for _, v in torsoTarget do
        local target = characterModel:FindFirstChild(v)
            
        if not target then
            continue
        end
        
        (target :: MeshPart).TextureContent = self.torsoTexture
    end
end

function R15Clothing.applyPants(self, characterModel)
    R15ClothingType(self)
    ModelBuildType:assert(characterModel)
    
    for i, k in { "Right", "Left" } do
        for _, v in pantTarget do
            local target = characterModel:FindFirstChild(k..v)
            
            if not target then
                continue
            end
            
            (target :: MeshPart).TextureContent = (self)[if i == 1 then 'leftLimbsTexture' else 'rightLimbsTexture']
        end
    end
    applyTorso(self, characterModel)
end

function R15Clothing.applyShirt(self, characterModel)
    R15ClothingType:assert(self)
    ModelBuildType:assert(characterModel)
    
    for i, k in { "Right", "Left" } do
        for _, v in shirtTarget do
            local target = characterModel:FindFirstChild(k..v)
            
            if not target then
                continue
            end
            
            (target :: MeshPart).TextureContent = (self)[if i == 1 then 'leftLimbsTexture' else 'rightLimbsTexture']
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