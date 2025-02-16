local pathfs = require('../lune_packages/pathfs')
local serde = require('@lune/serde')

local test_project = {
    name = "rbxclothing",
    tree = {
        ["$className"] = "DataModel",

        ReplicatedStorage = {
            rbxclothing = {
                ["$path"] = "src",
                Packages = {
                    ["$path"] = "roblox_packages"
                }
            }
        },

        ServerScriptService = {
            rbxclothingTest = {
                ["$path"] = "tests/test.server.luau",
                config = {
                    ["$path"] = "tests/config.luau"
                }
            }
        }
    }
}

pathfs.fs.writeFile('default.project.json', serde.encode("json", test_project))
