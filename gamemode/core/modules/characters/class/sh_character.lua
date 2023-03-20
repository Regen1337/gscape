gScape = gScape or {}
gScape.config = gScape.config or {}
gScape.core = gScape.core or {}
gScape.core.character = gScape.core.character or {}
gScape.core.character.vars = gScape.core.character.vars or {}


local PLAYER = FindMetaTable("Player")

local character = {}
character.vars = {}
character.slot = 1 -- 1 = main, 2 = alt, etc
--character.player = nil
--character.name = nil
--character.model = gScape.config.character.defaultModel
--character.inventory = {} -- TODO
--character.skills = {} -- TODO
--character.mode = 1 -- 1 = normal, 2 = ironman, 3 = hardcore ironman
--character.level = 1
--character.xp = 0

do
    --[==[
        @param idx string
        @param data table
        @param data.default any
            default value for the variable
        @param data.alias string or table
            if alias is a string, then it will be used as an alias for the variable
            if alias is a table, then it will be used as a list of aliases for the variable
        @param data.onGet function
            override the default get function
        @param data.onSet function
            override the default set function, will not automatically replicate the variable
        @param data.noReplication boolean
            if noReplication is true, then the variable will not be replicated to the client
        @param data.isLocal boolean
            if isLocal is true, then the variable will only be replicated to the player who set it
        @return void
    ]==]

    function gScape.core.character.newVariable(idx, data)
        gScape.core.character.vars[idx] = data
        character.vars[idx] = data.default
        local upperName, alias = string.upper(string.sub(idx, 1, 1)) .. string.sub(idx, 2), data.alias

        if data.onGet then
            character["get" .. upperName] = data.onGet
        else
            character["get" .. upperName] = function(self)
                return self.vars[idx]
            end
        end
        
        if SERVER then
            if data.onSet then
                character["set" .. upperName] = data.onSet
            elseif data.noReplication then
                character["set" .. upperName] = function(self, value)
                    self.vars[idx] = value
                end
            elseif data.isLocal then
                character["set" .. upperName] = function(self, value)
                    self.vars[idx] = value
                    net.Start("netScape.character.vars.update")
                        net.WriteUInt(self:getSlot(), 8)
                        net.WriteString(idx)
                        net.WriteType(value)
                    net.Send(self:getPlayer())
                end
            else
                character["set" .. upperName] = function(self, value)
                    self.vars[idx] = value
                    net.Start("netScape.character.vars.update")
                        net.WriteUInt(self:getSlot(), 8)
                        net.WriteString(idx)
                        net.WriteType(value)
                    net.Broadcast()
                end
            end
        end

        if alias and istable(alias) then
            for k, v in pairs(alias) do
                character["get" .. string.upper(string.sub(v, 1, 1)) .. string.sub(v, 2)] = character["get" .. upperName]
                character["set" .. string.upper(string.sub(v, 1, 1)) .. string.sub(v, 2)] = character["set" .. upperName]
            end
        elseif alias and isstring(alias) then
            character["get" .. string.upper(string.sub(alias, 1, 1)) .. string.sub(alias, 2)] = character["get" .. upperName]
            character["set" .. string.upper(string.sub(alias, 1, 1)) .. string.sub(alias, 2)] = character["set" .. upperName]
        end

    end
end


do -- player meta
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

do -- character meta
    function character:sync()

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