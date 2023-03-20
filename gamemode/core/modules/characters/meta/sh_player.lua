local PLAYER = FindMetaTable("Player")

do -- player meta
    function PLAYER:setCharacter(character)
        self.character = character
        if !SERVER then return end
    end

    function PLAYER:setCharacters(characters)
        self.characters = characters
        if !SERVER then return end
    end 

    function PLAYER:setCharacterSlot(character, slot)
        character:setSlot(slot)
        local characters = self:getCharacters()
        characters[slot] = character
        self:setCharacters(characters)
    end
    
    function PLAYER:getCharacter()
        return self.character or {}
    end

    function PLAYER:getCharacters()
        return self.characters or {}
    end

    function PLAYER:getCharacterSlot(slot)
        local characters = self:getCharacters()
        for k, v in ipairs(characters) do
            if v:getSlot() == slot then
                return v
            end
        end
        return false
    end

    function PLAYER:saveCharacter()
        local character = self:getCharacter()
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
        character = gScape.lib.inherit(character, gScape.core.character.default)
        character:setPlayer(self)
        self:setCharacterSlot(character, slot)
    end

    function PLAYER:loadCharacters()
        local characters = {}
        local files, directories = file.Find("gScape/characters/" .. self:SteamID64() .. "/*", "DATA")
        for _, v in next, files do
            local character = util.JSONToTable(file.Read("gScape/characters/" .. self:SteamID64() .. "/" .. v, "DATA"))
            character = gScape.lib.inherit(character, gScape.core.character.default)
            character:setPlayer(self)
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