local rbxclothing = require(game:GetService('ReplicatedStorage'):WaitForChild('rbxclothing'))
local R15Clothing = rbxclothing.R15Clothing

local baseRig = workspace:WaitForChild('Rig') :: Model

local mx = 15
local my = 15

local scale = {
    0.5,
    0.5,
}

local function _getMemorey(num: number?, limbsSize: Vector2?, torsoSize: Vector2?)
    local num = num or 24
    local limbsSize = limbsSize or Vector2.new(264, 284)
    local torsoSize = torsoSize or Vector2.new(388, 272)

    return 4 * num * (limbsSize.X * limbsSize.Y + torsoSize.X * torsoSize.Y)
end

local function _test()
    for i=1, my do
        for j=1, mx do
            local shirtClothing = R15Clothing
                .new(scale[1])
                :withContentAsync(Content.fromAssetId(85420273217173))
    
            local pantsClothing = R15Clothing
                .new(scale[2])
                :withContentAsync(Content.fromAssetId(140429600392212))
    
            local cloneRig = baseRig:Clone()
            cloneRig.Name = j + ((i - 1) * mx) :: any
            cloneRig.Parent = workspace
            cloneRig:PivotTo(baseRig:GetPivot() * CFrame.new(4 * j, 0, i * 2))
    
            pantsClothing:applyPants(cloneRig)
            shirtClothing:applyShirt(cloneRig)
        end
    end
end

local function _applyUserCharacter()
    local player = game:GetService('Players').LocalPlayer

    local shirtClothing = R15Clothing
        .new(scale[1])
        :withContentAsync(Content.fromAssetId(85420273217173))
    
    local pantsClothing = R15Clothing
        .new(scale[2])
        :withContentAsync(Content.fromAssetId(140429600392212))

    local character = player.Character or player.CharacterAdded:Wait() :: Model

    pantsClothing:applyPants(character)
    shirtClothing:applyShirt(character)
end

_applyUserCharacter()

baseRig:Destroy()