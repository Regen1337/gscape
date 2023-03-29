gScape = gScape or {}
gScape.config = gScape.config or {}

local color = Color(100, 255, 170)
local ext = gScape.extentions.new("core.character")

ext.vars = ext.vars or {}
ext.default  = ext.default or {}
ext.default.vars = ext.default.vars or{}

do
    --[==[
    @desc: Creates a new character variable
    @param: data - The data of the variable
    @param: data.name - The index of the variable
    @param: data.default - The default value of the variable
    @param: data.alias - The alias of the variable
    @param: data.onGet - The function to run when the variable is retrieved
    @param: data.onSet - The function to run when the variable is set, if this is not set, it will be automatically networked
    @param: data.noReplication - Whether or not to replicate the variable
    @param: data.isLocal - Whether or not to replicate the variable locally
    @return: void
    ]==]
    function ext.newCharacterVar(data)
        local upperName, alias = string.upper(string.sub(data.name, 1, 1)) .. string.sub(data.name, 2), data.alias
        ext.vars[data.name] = data
        
        local character = ext.default
        character.vars[data.name] = data.default

        gScape.lib.log(color, "Creating new character variable: " .. data.name)
        gScape.lib.log(color, "Setting default value of " .. data.name .. " to " .. tostring(data.default))

        if data.onGet then
            character["get" .. upperName] = data.onGet
        else
            character["get" .. upperName] = function(self)
                gScape.lib.log(color, "getting " .. data.name)
                return self.vars[data.name]
            end
        end
        
        if data.onSet then
            character["set" .. upperName] = data.onSet
        elseif data.noReplication then
            character["set" .. upperName] = function(self, value)
                self.vars[data.name] = value
                gScape.lib.log(color, "SV Setting " .. data.name .. " to " .. value)
            end
        elseif data.isLocal then
            character["set" .. upperName] = function(self, value, noReplication)
                self.vars[data.name] = value
                gScape.lib.log(color, "LOCAL Setting " .. data.name .. " to " .. tostring(value))
                if noReplication or !SERVER then return end
                net.Start(char_ext:getTag() .. ".var.sync")
                    net.WriteEntity(self:getPlayer())
                    net.WriteUInt(self:getSlot(), 8)
                    net.WriteString(data.name)
                    net.WriteType(value)
                net.Send(self:getPlayer())
            end
        else
            character["set" .. upperName] = function(self, value, noReplication)
                self.vars[data.name] = value
                gScape.lib.log(color, "GLOBAL Setting " .. data.name .. " to " .. tostring(value))
                if noReplication or !SERVER then return end
                net.Start(char_ext:getTag() .. ".var.sync")
                    net.WriteEntity(self:getPlayer())
                    net.WriteUInt(self:getSlot(), 8)
                    net.WriteString(data.name)
                    net.WriteType(value)
                net.Broadcast()
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

        ext.default = character
    end

    --[==[
    @desc: Creates a new character
    @param: data - The data of the character
    @param: data.player - The player of the character
    @param: data.slot - The slot of the character
    @param: data.name - The name of the character
    @param: data.model - The model of the character
    @param: data.inventory - The inventory of the character
    @param: data.skills - The skills of the character
    @param: data.mode - The mode of the character
    @param: data.level - The level of the character
    @param: data.xp - The xp of the character
    @return: void
    ]==]
    function ext.newCharacter(data)
        local char = gScape.lib.inherit({vars = {}}, ext.default)

        if data then
            for i,v in next, data do
                char.vars[i] = v
            end
            gScape.lib.log(color, "Created new character: ", tostring(char), " metatable: ", getmetatable(char))
        else
            gScape.lib.log(color, "ERROR: No data provided to create character.")
        end

        return char
    end
end

do
    ext.newCharacterVar{
        name = "player",
        default = false,
        alias = "ply",
    }

    ext.newCharacterVar{
        name = "slot",
        default = 1,
    }

    ext.newCharacterVar{
        name = "mode",
        default = 1,
    }

    ext.newCharacterVar{
        name = "name",
        default = "nil",
    }

    ext.newCharacterVar{
        name = "model",
        default = gScape.config.character.defaultModel,
    }

    ext.newCharacterVar{
        name = "inventory",
        default = {},
    }

    ext.newCharacterVar{
        name = "skills",
        default = {},
    }

    ext.newCharacterVar{
        name = "level",
        default = 1,
    }

    ext.newCharacterVar{
        name = "xp",
        default = 0,
    }
end