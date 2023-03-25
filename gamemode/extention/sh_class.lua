gScape = gScape or {}
gScape.__ext = gScape.__ext or {}
gScape.__extBase = gScape.__extBase or {}

do
    local base = gScape.__extBase

    function base:getTag()
        return self.__tag
    end

    function base:setTag(tag)
        self.__tag = tag
    end
    
    function base:isTag(tag)
        return self.__tag == tag
    end
    
    
end