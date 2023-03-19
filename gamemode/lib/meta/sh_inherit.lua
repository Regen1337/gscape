gScape = gScape or {}
gScape.lib = gScape.lib or {}

function gScape.lib.inherit( t, mt )
    local mt = mt or {}
    t.__index = mt.__index
    t.__call = mt.__call
    return setmetatable( t, mt )
end

