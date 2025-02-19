local R15Clothing = require(script.R15Clothing)

export type Rbxclothing = {
    R15Clothing: R15Clothing.R15ClothingImpl,
}

local rbxclothing = {} :: Rbxclothing
rbxclothing.R15Clothing = R15Clothing

return rbxclothing