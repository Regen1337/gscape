gScape = gScape or {}
gScape.config = gScape.config or {}
gScape.core = gScape.core or {}
gScape.core.character = gScape.core.character or {}
gScape.core.character.vars = gScape.core.character.vars or {}

local character = gScape.core.character.default or {}
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

gScape.core.character.default = character