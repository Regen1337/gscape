gScape = gScape or {}
gScape.lib = gScape.lib or {}

gScape.lib.files = {}
local color = Color(255, 215, 0)

--[==[
    @desc: Includes a file based on the prefix of the file name.
    @param: path - The path to the file.
    @param: prefix - The prefix of the file name.
    @return: void
]==]
local function Include(path)
    local success, err = pcall(function()
        include(path)
        gScape.lib.log(color, "Included " .. path .. ".")
    end)
    if not success then
        gScape.lib.log(color, "Failed to include " .. path .. ".")
        gScape.lib.log(color, err)
    end
end

local function addCSLuaFile(path)
    local success, err = pcall(function()
        AddCSLuaFile(path)
        gScape.lib.log(color, "Added " .. path .. " to client.")
    end)
    if not success then
        gScape.lib.log(color, "Failed to add " .. path .. " to client.")
        gScape.lib.log(color, err)
    end
end

gScape.lib.files.include = function(path, prefix)
    if SERVER then
        if prefix == "sh_" then
            Include(path)
            addCSLuaFile(path)
        elseif prefix == "sv_" then
            Include(path)
        elseif prefix == "cl_" then
            addCSLuaFile(path)
        end
    elseif CLIENT then
        if prefix == "sh_" then
            Include(path)
        elseif prefix == "cl_" then
            Include(path)
        end
    end
end

--[==[
    @desc: Includes all files in a directory, recursively.
    @param: path - The path to the directory.
    @return: void
]==]
gScape.lib.files.includeDir = function(path)
    path = "gamemodes/gscape/" .. path
    local files, folders = file.Find(path ..  "*", "GAME")
    for k, v in next, (folders) do
        local psub = string.sub(path, 18)
        gScape.lib.files.includeDir(psub .. v .. "/")
    end
    for k, v in next, (files) do
        local psub = string.sub(path, 27)
        gScape.lib.files.include(psub .. v, string.sub(v, 1, 3))
    end
end
