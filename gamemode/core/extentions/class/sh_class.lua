gScape = gScape or {}

gScape.extentions = gScape.extentions or {}
gScape.__ext = gScape.__ext or {}
gScape.__extBase = gScape.__extBase or {}

do
    local base = gScape.__extBase
    local meta = {__index = gScape.__extBase, __tostring = function(o) return string.format("gScape_ext: [%s]", o:getTag()) end}

    do -- base extention
        function base:getTag()
            if not self.__tag then self:setTag() end
            return self.__tag
        end

        function base:setTag()
            self.__tag = "gScape_ext." .. self:getName()
        end

        function base:getItemTag()
            if not self.__item_tag then self:setItemTag() end
            return self.__item_tag
        end

        function base:setItemTag()
            self.__item_tag = self:getName() .. ":" 
        end

        function base:isItemTag(tag)
            return self:getItemTag() == tag
        end

        function base:isTag(tag)
            return self:getTag() == tag
        end

        function base:getName()
            return self.__name
        end

        function base:setName(name)
            self.__name = tostring(name)
            self:setTag()
        end

        gScape.__extBase = base
    end

    do
        function gScape.extentions.new(name)
            local o = setmetatable({__name = tostring(name)}, meta)

            if gScape.__ext[name] then
                gScape.lib.log(color_white, "gScape.__ext[" .. name .. "] is being overwritten")    
            else
                gScape.lib.log(color_white, "gScape.__ext[" .. name .. "] is being created")
            end
            
            gScape.__ext[name] = o

            return o
        end

        function gScape.extentions.extend(name)
            if gScape.__ext[name] then return gScape.__ext[name] else
                error("gScape.__ext[" .. name .. "] does not exist")
            end
        end

        function gScape.extentions.newInterface(name)
            return setmetatable({}, {__index = function(_, k) return gScape.__ext[name][k] end, __tostring = function(o) return String.format("gScape_ext: [%s] [INSTANCE]", o:getTag()) end, _mt = gScape.__ext[name]})
        end

        function gScape.extentions.get(name)
            return gScape.__ext[name]
        end
    end

end