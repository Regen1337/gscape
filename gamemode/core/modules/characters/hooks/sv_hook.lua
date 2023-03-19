// hook when a player connects and load their character in gmod lua
hook.Add("PlayerInitialSpawn", "hookScape.characters.load", function(ply)
    ply:loadCharacters()
end)

hook.Add("PlayerDisconnected", "hookScape.characters.save", function(ply)
    ply:saveCharacters()
end)