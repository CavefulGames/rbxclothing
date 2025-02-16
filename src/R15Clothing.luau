local types = require('./types')
local R15Clothing = {} :: types.R15ClothingImpl
R15Clothing.__index = R15Clothing

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

local function applyTorso(self: types.R15Clothing, characterModel: Model)
    for _, v in torsoTarget do
        local target = characterModel:FindFirstChild(v)
            
        if not target then
            continue
        end
        
        (target :: MeshPart).TextureContent = self.torsoTexture
    end
end

function R15Clothing.applyPants(self, characterModel)
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
    (self.leftLimbsTexture.Object :: EditableImage):Destroy();
    (self.rightLimbsTexture.Object :: EditableImage):Destroy();
    (self.torsoTexture.Object :: EditableImage):Destroy();
    self = nil :: any
end

return R15Clothing