local color = Color(255, 100, 100)
local char_ext = gScape.extentions.get("core.character")
--[==[
    @param sender The entity who send the data
    @param id The character ID
    @param idx The index of the variable
    @param val The value of the variable
]==]
-- Receive a character update from the server and update the local character with the new data
net.Receive(char_ext:getTag() .. ".var.sync", function()
    -- Get the sender of the message
    local sender = net.ReadEntity()
    -- Get the character slot of the character
    local id = net.ReadUInt(8)
    -- Get the variable index name
    local idx = net.ReadString()
    -- Get the variable value
    local val = net.ReadType()
    gScape.lib.log(color, string.format("var.sync Received character %s from %s", id, tostring(sender)))

    -- Create a new character if it doesn't exist or get the existing character
    local character = sender:getCharacterSlot(id) or char_ext.newCharacter({slot = id or 1})
    gScape.lib.log(color, string.format("var.sync Character %s received variable %s with value %s", id, idx, tostring(val)))
    -- Update the variable value
    character.vars[idx] = val
    -- Update the character client-side
    sender:setCharacter(character.vars, LocalPlayer())
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
        gScape.lib.log(color, string.format("vars.sync Failed to receive character %s from %s", id, tostring(sender)))
        return
    end

    -- Print out to the console that the character table was received
    gScape.lib.log(color, string.format("vars.sync Received character %s from %s", id, tostring(sender)))
    PrintTable(tbl)

    -- Set the character table on the sender's character data
    sender:setCharacter(tbl, LocalPlayer())
end

net.Receive(char_ext:getTag() .. ".vars.sync", receiveCharacterVarsSync)

--[==[
    @param sender The entity who send the data
    @param tbl The table of variables
]==]
local function receiveCharacters()
    local sender = net.ReadEntity()
    local characters = net.ReadTable()
    
    sender:setCharacters(characters or {}, LocalPlayer())
    
    gScape.lib.log(color, "Characters received:")
    for i, v in ipairs(LocalPlayer():getCharacters()) do
        gScape.lib.log(color, "Character[" .. v:getSlot() .. "]:")
        PrintTable{v}
    end
end

net.Receive(char_ext:getTag() .. "s.vars.sync", receiveCharacters)

