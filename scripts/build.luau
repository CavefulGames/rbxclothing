local roblox = require("@lune/roblox")
local fs = require("@lune/fs")
local process = require("@lune/process")

if not fs.isDir("build") then
	fs.writeDir("build")
end

if fs.isFile("build/rbxclothing.rbxl") then
	fs.removeFile("build/rbxclothing.rbxl")
end
local build_process = process.create("rojo", { "build", "default.project.json", "--output", "build/rbxclothing.rbxl" })

if not build_process:status().ok then
	print(build_process.stderr:read())
	return
end

fs.writeFile(
	"build/rbxclothing.rbxm",
	roblox.serializeModel({
		(roblox.deserializeModel(fs.readFile("build/rbxclothing.rbxl"))[1] :: any):FindFirstChild("Packages"),
	})
)