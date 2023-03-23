--[==[
    @param sender The entity who send the data
    @param id The character ID
    @param idx The index of the variable
    @param val The value of the variable
]==]
-- Receive a character update from the server and update the local character with the new data
net.Receive("netScape.character.var.sync", function()
    -- Get the sender of the message
    local sender = net.ReadEntity()
    -- Get the character slot of the character
    local id = net.ReadUInt(8)
    -- Get the variable index name
    local idx = net.ReadString()
    -- Get the variable value
    local val = net.ReadType()
    print(string.format("var.sync Received character %s from %s", id, sender))

    -- Create a new character if it doesn't exist or get the existing character
    local character = sender:getCharacterSlot(id) or gScape.core.character.create({slot = id or 1})
    print(string.format("var.sync Character %s received variable %s with value %s", id, idx, val))
    -- Update the variable value
    character.vars[idx] = val
    -- Send the updated character back to the server
    sender:setCharacter(character.vars, id, LocalPlayer())
end)

--[==[
    @param sender The entity who send the data
    @param id The character ID
    @param tbl The table of variables
]==]
local function receiveCharacterVarsSync()
    -- Read the sender and the character ID from the net message
    local sender = net.ReadEntity()
    local id = net.ReadUInt(8)

    -- Read the character table from the net message
    local tbl = net.ReadTable()

    -- Check to see if the sender is a valid entity
    if (not IsValid(sender)) then
        return
    end

    -- Check to see if the character table is valid and the ID is valid
    if (not tbl or not id) then
        print(string.format("vars.sync Failed to receive character %s from %s", id, sender))
        return
    end

    -- Print out to the console that the character table was received
    print(string.format("vars.sync Received character %s from %s", id, sender))
    print("vars.sync Received character table:")
    PrintTable(tbl)

    -- Set the character table on the sender's character data
    sender:setCharacter(tbl, id, LocalPlayer())
end

net.Receive("netScape.character.vars.sync", receiveCharacterVarsSync)

--[==[
    @param sender The entity who send the data
    @param tbl The table of variables
]==]
local function receiveCharacters()
    local sender = net.ReadEntity()
    local characters = net.ReadTable()
    
    print("Received characters from " .. sender)
    
    sender:setCharacters(characters or {}, LocalPlayer())
    
    print("Characters received:")
    for i, v in ipairs(characters) do
        print("\t" .. v)
    end
end

net.Receive("netScape.characters.sync", receiveCharacters)