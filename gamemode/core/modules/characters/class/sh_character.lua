gScape = gScape or {}
gScape.config = gScape.config or {}
gScape.core = gScape.core or {}
gScape.core.character = gScape.core.character or {}

local PLAYER = FindMetaTable("Player")

local character = {}
character.name = "null"
character.model = gScape.config.character.defaultModel
character.inventory = {} -- TODO
character.skills = {} -- TODO
character.slot = 1 -- 1 = main, 2 = alt, etc
character.mode = 1 -- 1 = normal, 2 = ironman, 3 = hardcore ironman
character.level = 1
character.xp = 0

do
    function PLAYER:setCharacter(character)
        self.character = character
        if !SERVER then return end
        net.Start("netScape.character.update")
            net.WriteTable(character)
        net.Send(self)
    end

    function PLAYER:setCharacters(characters)
        self.characters = characters
        if !SERVER then return end
        net.Start("netScape.characters.update")
            net.WriteTable(characters)
        net.Send(self)
    end 

    function PLAYER:setCharacterSlot(slot)
        local character = self:getCharacter()
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
        for k, v in pairs(characters) do
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
        for k, v in pairs(characters) do
            file.Write("gScape/characters/" .. self:SteamID64() .. "/" .. v:getSlot() .. ".txt", util.TableToJSON(v))
        end
    end

    function PLAYER:loadCharacter(slot)
        local character = util.JSONToTable(file.Read("gScape/characters/" .. self:SteamID64() .. "/" .. slot .. ".txt", "DATA"))
        character:setPlayer(self)
        character = gScape.lib.inherit(character, gScape.core.character.default)
        self:setCharacterSlot(slot)
    end

    function PLAYER:loadCharacters()
        local characters = {}
        local files, directories = file.Find("gScape/characters/" .. self:SteamID64() .. "/*", "DATA")
        for k, v in pairs(files) do
            local character = util.JSONToTable(file.Read("gScape/characters/" .. self:SteamID64() .. "/" .. v, "DATA"))
            character:setPlayer(self)
            character = gScape.lib.inherit(character, gScape.core.character.default)
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
        for k, v in pairs(characters) do
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

do



    function character:getPlayer()
        return self.player
    end

    function character:setPlayer(player)
        self.player = player
    end

    function character:getName()
        return self.name
    end

    function character:setName(name)
        self.name = name
    end

    function character:getModel()
        return self.model
    end

    function character:setModel(model)
        self.model = model
    end

    function character:getInventory()
        return self.inventory
    end

    function character:setInventory(inventory)
        self.inventory = inventory
    end

    function character:getSlot()
        return self.slot
    end

    function character:setSlot(slot)
        self.slot = slot
    end

    function character:getMode()
        return self.mode
    end

    function character:setMode(mode)
        self.mode = mode
    end

    function character:getLevel()
        return self.level
    end

    function character:setLevel(level)
        self.level = level
    end

    function character:getXP()
        return self.xp
    end

    function character:setXP(xp)
        self.xp = xp
    end
end

gScape.core.character.default = character


