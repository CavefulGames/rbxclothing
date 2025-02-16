local pathfs = require('../lune_packages/pathfs')
local serde = require('@lune/serde')

local test_project = {
    name = "rbxclothing",
    tree = {
        ["$className"] = "DataModel",

        ReplicatedStorage = {
            rbxclothing = {
                ["$path"] = "src"
            }
        },

        ServerScriptService = {
            rbxclothingTest = {
                ["$path"] = "tests/test.server.luau"
            }
        }
    }
}

pathfs.fs.writeFile('default.project.json', serde.encode("json", test_project))