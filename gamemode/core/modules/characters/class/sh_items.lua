local ext = gScape.extentions.new"core.item"

ext.vars = ext.vars or {} -- var full data
ext.list = ext.list or {} -- list of all items

ext.default = ext.default or {} -- default item meta
ext.default.vars = ext.default.vars or {} -- var meta data


do
    function ext.default.varSync(self, name, receiver)
        if SERVER then
            if IsValid(receiver) then
                net.Start("netScape.item.var.sync")
                    net.WriteEntity(self.player)
                    net.WriteType(self.id)
                    net.WriteString(name)
                    net.WriteType(value)
                net.Send(receiver)
            else
                net.Start("netScape.item.var.sync")
                    net.WriteEntity(self.player)
                    net.WriteType(self.id)
                    net.WriteString(name)
                    net.WriteType(value)
                net.Broadcast()
            end
        end
    end


    --[==[
        @param data
        @param data.name - The name of the property
        @param data.default - The default value of the property
        @param data.alias - The alias of the property, which is used in the replication system
        @param data.onGet - A function that is called when the property is retrieved
        @param data.onSet - A function that is called when the property is set
            @param data.autoReplication - A boolean indicating whether the property should be replicated automatically or not
        @param data.noReplication - A boolean indicating whether the property should be replicated or not
        @param data.isLocal - A boolean indicating whether the property should be replicated to the owner only
    ]==]
    function ext.newVariable(data)
        local upperName, alias = string.upper(string.sub(data.name, 1, 1)) .. string.sub(data.name, 2), data.alias
        ext.vars[data.name] = data
        
        local item = ext.default 
        item.vars[data.name] = data.default

        if data.onGet then
            item["get" .. upperName] = data.onGet   
        else
            item["get" .. upperName] = function(self)
                return self.vars[data.name]
            end
        end
        if data.onSet then
            item["set" .. upperName] = data.onSet
        elseif data.onSet and data.autoReplication then
            local oldSet = data.onSet
            data.onSet = function(self, value, receiver, noReplication, ...)
                oldSet(self, value, ...)
                if !noReplication then self:varSync(data.name, receiver) end
            end
            item["set" .. upperName] = data.onSet
        elseif data.noReplication then
            item["set" .. upperName] = function(self, value)
                self.vars[data.name] = value
            end
        elseif data.isLocal then
            item["set" .. upperName] = function(self, value, noReplication)
                self.vars[data.name] = value
                if !noReplication then self:varSync(data.name, self.player) end
            end
        else
            item["set" .. upperName] = function(self, value, noReplication)
                self.vars[data.name] = value
                if !noReplication then self:varSync(data.name) end
            end
        end

        if alias and istable(alias) then
            for k, v in pairs(alias) do
                item["get" .. string.upper(string.sub(v, 1, 1)) .. string.sub(v, 2)] = item["get" .. upperName]
                item["set" .. string.upper(string.sub(v, 1, 1)) .. string.sub(v, 2)] = item["set" .. upperName]
            end
        elseif alias and isstring(alias) then
            item["get" .. string.upper(string.sub(alias, 1, 1)) .. string.sub(alias, 2)] = item["get" .. upperName]
            item["set" .. string.upper(string.sub(alias, 1, 1)) .. string.sub(alias, 2)] = item["set" .. upperName]
        end

        ext.default = item
    end
end

do
    
end

do
    ext.newVariable{
        name = "name",
        default = "Base Item",
        alias = "nick",
    }

    ext.newVariable{
        name = "id",
        default = 0,
        alias = "identifier",
    }

    ext.newVariable{
        name = "class",
        default = false,
        alias = "type",
    }

    ext.newVariable{
        name = "description",
        default = "This is a base item.",
        alias = "desc",
    }

    ext.newVariable{
        name = "model",
        default = "models/error.mdl",
        alias = "mdl",
    }
    
    ext.newVariable{
        name = "player",
        default = false,
        alias = "owner",
    }
    
    ext.newVariable{
        name = "inventory",
        default = false,
        alias = "inv",
    }

    ext.newVariable{
        name = "slot",
        default = 0,
        alias = "position",
    }

    ext.newVariable{
        name = "amount",
        default = 1,
        alias = "count",
    }

    ext.newVariable{
        name = "stackable",
        default = false,
    }
end

