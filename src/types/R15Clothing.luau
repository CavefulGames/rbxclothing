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
export type R15Clothing = typeof(setmetatable({} :: {
    leftLimbsTexture: Content,
    rightLimbsTexture: Content,
    torsoTexture: Content,
}, {} :: R15ClothingImpl))

return {}