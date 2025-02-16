local pathfs = require('../lune_packages/pathfs')
local serde = require('@lune/serde')

local publish_project = {
    name = "rbxclothing",
    tree = {
        ["$path"] = "src",
        Packages = {
            ["$path"] = "roblox_packages"
        }
    }
}

pathfs.fs.writeFile('default.project.json', serde.encode("json", publish_project))