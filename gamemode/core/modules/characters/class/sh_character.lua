gScape = gScape or {}
gScape.config = gScape.config or {}
gScape.core = gScape.core or {}
gScape.core.character = gScape.core.character or {}
gScape.core.character.vars = gScape.core.character.vars or {}

local character = gScape.core.character.default or {}
character.vars = {}
--character.slot = 1 -- 1 = main, 2 = alt, etc
--character.player = nil
--character.name = nil
--character.model = gScape.config.character.defaultModel
--character.inventory = {} -- TODO
--character.skills = {} -- TODO
--character.mode = 1 -- 1 = normal, 2 = ironman, 3 = hardcore ironman
--character.level = 1
--character.xp = 0

gScape.core.character.default = character

do
    --[==[
    @desc: Creates a new character variable
    @param: idx - The index of the variable
    @param: data - The data of the variable
    @param: data.default - The default value of the variable
    @param: data.alias - The alias of the variable
    @param: data.onGet - The function to run when the variable is retrieved
    @param: data.onSet - The function to run when the variable is set, if this is not set, it will be automatically networked
    @param: data.noReplication - Whether or not to replicate the variable
    @param: data.isLocal - Whether or not to replicate the variable locally
    @return: void
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
                    net.Start("netScape.character.vars.sync")
                        net.WriteEntity(self:getPlayer())
                        net.WriteUInt(self:getSlot(), 8)
                        net.WriteString(idx)
                        net.WriteType(value)
                    net.Send(self:getPlayer())
                end
            else
                character["set" .. upperName] = function(self, value)
                    self.vars[idx] = value
                    net.Start("netScape.character.vars.sync")
                        net.WriteEntity(self:getPlayer())
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

    --[==[
    @desc: Creates a new character
    @param: data - The data of the character
    @param: data.player - The player of the character
    @param: data.name - The name of the character
    @param: data.model - The model of the character
    @param: data.inventory - The inventory of the character
    @param: data.skills - The skills of the character
    @param: data.mode - The mode of the character
    @param: data.level - The level of the character
    @param: data.xp - The xp of the character
    @return: void
    ]==]
    function gScape.core.character.create(data)
        local char = {}
        char = gScape.lib.inherit(char, gScape.core.character.default)

        for i,v in next, data do
            char.vars[i] = v
        end

        return char
    end
end