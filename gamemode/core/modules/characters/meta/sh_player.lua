local PLAYER = FindMetaTable("Player")

do -- player meta
    function PLAYER:setCharacter(vars, slot)
        local characters = self:getCharacters()
        local character = gScape.core.character.create(vars or {})
        character.vars.player = self

        if vars.slot then
            character.vars.slot = slot
            characters[slot] = character
            self:setCharacters(characters)
        end

        self.character = character
        if !SERVER then return end
        self.character:syncVars()
    end

    function PLAYER:setCharacters(characters)
        for i,v in ipairs(characters) do
            v = gScape.core.character.create(v.vars or {})
            v.vars.player = self
        end
        self.characters = characters
        self:syncCharacters()
    end

    function PLAYER:syncCharacters()
        if !SERVER then return end
        local characters = self:getCharacters()
        net.Start("netScape.characters.vars.sync")
            net.WriteEntity(self)
            net.WriteTable(characters)
        net.Send(self)
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
        self:setCharacter(character.vars, slot)
    end

    function PLAYER:loadCharacters()
        local characters = {}
        local files, directories = file.Find("gScape/characters/" .. self:SteamID64() .. "/*", "DATA")
        for _, v in next, files do
            local character = util.JSONToTable(file.Read("gScape/characters/" .. self:SteamID64() .. "/" .. v, "DATA"))
            characters[character:getSlot()] = character
        end
        self:setCharacters(characters)
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