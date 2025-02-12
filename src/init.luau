local AssetService = game:GetService('AssetService')
local R15 = require(script:WaitForChild('R15'))

export type RbxClothing = {
    R15: {
        new: (content: Content) -> (R15.R15),
    },
}

local rbxclothing = {} :: RbxClothing
rbxclothing.R15 = {} :: any

function rbxclothing.R15.new(content)
    local editableImage = AssetService:CreateEditableImageAsync(content)
    
    if editableImage.Size.X ~= 585 or editableImage.Size.Y ~= 559 then
        error('content size is not 585 * 559')
    end

    return setmetatable({
        editableImage=editableImage,
    }, R15)
end

return rbxclothing