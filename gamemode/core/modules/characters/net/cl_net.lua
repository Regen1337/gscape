net.Receive("netScape.character.vars.update", function()
    local id = net.ReadUInt(8)
    local idx = net.ReadString()
    local val = net.ReadType()
    
end)