local PLAYER = FindMetaTable("Player")
local color = Color(255, 100, 100)

do -- player meta
    -- only send all characters to the owner of the character; TODO
    function PLAYER:setCharacter(data, receiver)
        local char_ext = gScape.extentions.get("core.character")
        -- Create a new character based on the data passed to this function
        local character = char_ext.newCharacter(data or {})
        -- Set the player of the character to this player with noReplication set to true
        character:setPlayer(self, true)
        -- Set the current character to this one
        self.character = character

        -- If this is a slot, add it to characters
        if data.slot then
            self.characters = self:getCharacters() or {}
            self.characters[data.slot] = character
        end

        -- If this is the server, sync the variables and set the characters
        if SERVER then
            gScape.lib.log(color, "[gScape] Syncing variables for player " .. self:Nick())
            local success, err = pcall(character.syncVars, character)
            if not success then
                gScape.lib.log(color, "[gScape] Failed to sync variables for player " .. self:Nick())
                gScape.lib.log(color, "[gScape] Error: " .. err)
            else
                gScape.lib.log(color, "[gScape] Synced variables for player " .. self:Nick())
            end
            gScape.lib.log(color, "[gScape] Syncing characters for player " .. self:Nick())
            success, err = pcall(self.setCharacters, self, self:getCharacters() or {}, receiver)
            if not success then
                gScape.lib.log(color, "[gScape] Failed to sync characters for player " .. self:Nick())
                gScape.lib.log(color, "[gScape] Error: " .. err)
            else
                gScape.lib.log(color, "[gScape] [setChar] Synced characters for player " .. self:Nick())
            end
        end
    end

    function PLAYER:setCharacters(data, receiver)
        -- Create a new table of characters
        local characters = {}
        -- Loop through the data and create a new character for each one
        for k, v in pairs(data) do
            local character = char_ext.newCharacter(v.vars or {})
            character:setPlayer(self, true)
            characters[k] = character
        end
        -- Set the characters to the new table
        self.characters = characters
        -- If this is the server, sync the characters
        if SERVER then
            gScape.lib.log(color, "[gScape] Syncing characters for player " .. self:Nick())
            local success, err = pcall(self.syncCharacters, self, receiver)
            if not success then
                gScape.lib.log(color, "[gScape] Failed to sync characters for player " .. self:Nick())
                gScape.lib.log(color, "[gScape] Error: " .. err)
            else
                gScape.lib.log(color, "[gScape] [setChars] Synced characters for player " .. self:Nick())
            end
        end
    end

    function PLAYER:syncCharacters(receiver)
        if !SERVER then return end

        local characters = {}
        for k, v in ipairs(self:getCharacters()) do
            characters[k] = v
        end

        if !receiver then
            -- loop through all players and send them their characters
            for _, v in ipairs(player.GetAll()) do
                gScape.lib.log(color, "Sending characters to " .. v:Nick())
                self:syncCharacters(v)
            end
        elseif receiver == self then
            -- loop through all characters and remove any variables marked as "noReplication"
            for k, v in ipairs(characters) do
                for k2, v2 in next, (v.vars) do
                    if char_ext.vars[k2] and char_ext.vars[k2].noReplication then
                        characters[k].vars[k2] = nil
                    end
                end
            end

            -- send to the player
            gScape.lib.log(color, "Sending characters to "..self:Nick())
            net.Start(char_ext:getTag() .. "s.vars.sync")
                net.WriteEntity(self)
                net.WriteTable(characters)
            net.Send(self)
        elseif receiver:IsPlayer() then
            -- loop through all characters and remove any variables marked as "noReplication" or "isLocal"
            for k, v in ipairs(characters) do
                for k2, v2 in next, (v.vars) do
                    if char_ext.vars[k2] and (char_ext.vars[k2].noReplication or char_ext.vars[k2].isLocal) then
                        characters[k].vars[k2] = nil
                    end
                end
            end

            -- send to the player
            gScape.lib.log(color, "Sending characters to "..receiver:Nick())
            net.Start(char_ext:getTag() .. "s.vars.sync")
                net.WriteEntity(self)
                net.WriteTable(characters)
            net.Send(receiver)
        else
            error("Invalid receiver for syncCharacters: "..tostring(receiver))
        end
    end
    
    function PLAYER:getCharacter()
        return self.character or false
    end

    function PLAYER:getCharacters()
        return self.characters or {}
    end

    function PLAYER:getCharacterSlot(slot)
        for k, v in ipairs(self:getCharacters()) do
            if v:getSlot() == slot then
                return v
            end
        end
        return false
    end

    --TODO BEYOND
    function PLAYER:saveCharacter()
        local character = self:getCharacter()
        if !character then return end
        file.Write("gScape/characters/" .. self:SteamID64() .. "/" .. character:getSlot() .. ".txt", util.TableToJSON(character))
    end

    function PLAYER:saveCharacters()
        local characters = self:getCharacters()
        for _, v in ipairs(characters) do
            file.Write("gScape/characters/" .. self:SteamID64() .. "/" .. v:getSlot() .. ".txt", util.TableToJSON(v))
        end
    end

    function PLAYER:loadCharacter(slot)
        local character = util.JSONToTable(file.Read("gScape/characters/" .. self:SteamID64() .. "/" .. slot .. ".txt", "DATA"))
        self:setCharacter(character.vars, self)
    end

    function PLAYER:loadCharacters()
        local characters = {}
        local files, directories = file.Find("gScape/characters/" .. self:SteamID64() .. "/*", "DATA")
        for _, v in next, files do
            local character = util.JSONToTable(file.Read("gScape/characters/" .. self:SteamID64() .. "/" .. v, "DATA"))
            characters[character.vars.slot] = character
        end
        self:setCharacters(characters, self)
    end

    function PLAYER:hasCharacter()
        local characters = self:getCharacters()
        if #characters > 0 then
            return true
        else
            return false
        end
    end

    function PLAYER:hasCharacterSlot(slot)
        local characters = self:getCharacters()
        for _, v in ipairs(characters) do
            if v:getSlot() == slot then
                return true
            end
        end
        return false
    end

    function PLAYER:getAvailableCharacterSlot()
        local characters = self:getCharacters()
        for i = 1, gScape.config.character.maxSlots do
            local available = true
            for k, v in pairs(characters) do
                if v:getSlot() == i then
                    available = false
                end
            end
            if available then
                return i
            end
        end
        return false
    end

end