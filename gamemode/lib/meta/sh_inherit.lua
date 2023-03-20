gScape = gScape or {}
gScape.lib = gScape.lib or {}

--[==[
    @desc: Inherit a table from a metatable
    @param: t - table to inherit
    @param: mt - metatable to inherit from
    @return: table with metatable
]==]
function gScape.lib.inherit( t, mt )
    local mt = mt or {}
    t.__index = mt.__index
    t.__call = mt.__call
    return setmetatable( t, mt )
end

