gScape = gScape or {}
gScape.lib = gScape.lib or {}

--[==[
    @desc: Inherit a table from a metatable
    @param: t - table to inherit
    @param: mt - metatable to inherit from
    @return: table with metatable
]==]
function gScape.lib.inherit( t, mt )
    local meta = {__index = mt, __call = mt}
    return setmetatable( t or {}, meta )
end