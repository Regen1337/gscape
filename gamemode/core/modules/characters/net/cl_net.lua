--[==[
    @param receiver The entity to receive the data
    @param id The character ID
    @param idx The index of the variable
    @param val The value of the variable
]==]
net.Receive("netScape.character.vars.sync", function()
    local sender = net.ReadEntity()
    local id = net.ReadUInt(8)
    local idx = net.ReadString()
    local val = net.ReadType()
    
    receiver:
end)
