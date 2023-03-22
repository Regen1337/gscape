--[==[
    @param sender The entity who send the data
    @param id The character ID
    @param idx The index of the variable
    @param val The value of the variable
]==]
net.Receive("netScape.character.var.sync", function()
    local sender = net.ReadEntity()
    local id = net.ReadUInt(8)
    local idx = net.ReadString()
    local val = net.ReadType()
    print(string.format("var.sync Received character %s from %s", id, sender))

    local character = sender:getCharacterSlot(id) or gScape.core.character.default
    character.vars[idx] = val
    sender:setCharacter(character.vars, id, LocalPlayer())
end)

--[==[
    @param sender The entity who send the data
    @param id The character ID
    @param tbl The table of variables
]==]
net.Receive("netScape.character.vars.sync", function()
    local sender = net.ReadEntity()
    local id = net.ReadUInt(8)
    local tbl = net.ReadTable()
    print(string.format("vars.sync Received character %s from %s", id, sender))

    sender:setCharacter(tbl or {}, id, LocalPlayer())
end)

--[==[
    @param sender The entity who send the data
    @param tbl The table of variables
]==]
net.Receive("netScape.characters.sync", function()
    local sender = net.ReadEntity()
    local tbl = net.ReadTable()
    print(string.format("Received characters from %s", sender))
    
    sender:setCharacters(tbl or {}, LocalPlayer())
end)