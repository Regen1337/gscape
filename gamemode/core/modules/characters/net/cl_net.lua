--[==[
    @param receiver The entity to receive the data
    @param id The character ID
    @param idx The index of the variable
    @param val The value of the variable
]==]
net.Receive("netScape.character.var.sync", function()
    local sender = net.ReadEntity()
    local id = net.ReadUInt(8)
    local idx = net.ReadString()
    local val = net.ReadType()
    
    local character = sender:getCharacterSlot(id) or gScape.core.character.default.vars
    character.vars[idx] = val
    sender:setCharacter(character.vars)
    sender:setCharacterSlot(id, character)
end)

--[==[
    @param receiver The entity to receive the data
    @param id The character ID
    @param tbl The table of variables
]==]
net.Receive("netScape.character.vars.sync", function()
    local sender = net.ReadEntity()
    local id = net.ReadUInt(8)
    local tbl = net.ReadTable()
    
    sender:setCharacter(tbl.vars)
    sender:setCharacterSlot(id, tbl)
end)

--[==[
    @param receiver The entity to receive the data
    @param tbl The table of variables
]==]
net.Receive("netScape.characters.vars.sync", function()
    local sender = net.ReadEntity()
    local tbl = net.ReadTable()
    
    sender:setCharacters(tbl)
end)