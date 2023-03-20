gScape = gScape or {}
gScape.lib = gScape.lib or {}

gScape.lib.files = {}

--[==[
    @desc: Includes a file based on the prefix of the file name.
    @param: path - The path to the file.
    @param: prefix - The prefix of the file name.
    @return: void
]==]
gScape.lib.files.include = function(path, prefix)
    local color = Color(255, 215, 0)
    if SERVER then
        if prefix == "sh_" then
            AddCSLuaFile(path)
            include(path)
            gScape.lib.print(color, "Included " .. path .. " on server and client.")
        elseif prefix == "sv_" then
            include(path)
            gScape.lib.print(color, "Included " .. path .. " on server.")
        elseif prefix == "cl_" then
            AddCSLuaFile(path)
            gScape.lib.print(color, "Included " .. path .. " on client.")
        end
    elseif CLIENT then
        if prefix == "sh_" then
            include(path)
            gScape.lib.print(color, "Included " .. path .. " on client.")
        elseif prefix == "cl_" then
            include(path)
            gScape.lib.print(color, "Included " .. path .. " on client.")
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
    for k, v in pairs(files) do
        local psub = string.sub(path, 27)
        gScape.lib.files.include(psub .. v, string.sub(v, 1, 3))
    end
    for k, v in pairs(folders) do
        local psub = string.sub(path, 18)
        gScape.lib.files.includeDir(psub .. v .. "/")
    end
end
