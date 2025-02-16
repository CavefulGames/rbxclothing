export type ClothingImpl = {
    __index: ClothingImpl,
    applyShirt: (self: Clothing, characterModel: Model) -> (),
    applyPants: (self: Clothing, characterModel: Model) -> (),
    delete: (self: Clothing) -> (),
}

--[=[
```luau
local clothing = rbxclothing.R15Clothing.new(content):unwrap()
```
]=]
export type Clothing = typeof(setmetatable({} :: {
    leftLimbsTexture: Content,
    rightLimbsTexture: Content,
    torsoTexture: Content,
}, {} :: ClothingImpl))


return {}