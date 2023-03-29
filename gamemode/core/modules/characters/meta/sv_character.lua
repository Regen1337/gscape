local char_ext = gScape.extentions.get("core.character")
local character = char_ext.default or {}
local color = Color(255, 100, 100)

do -- character meta
    function character:syncVars(receiver)
        if receiver == nil then
            local players = player.GetAll()
            for i,v in next, players do
                self:syncVars(v)
            end
        elseif receiver == self:getPlayer() then
            local data = {}
            for i, v in next, (self.vars) do
                if char_ext.vars[i] and !char_ext.vars[i].noReplication then
                    data[i] = v
                end
            end
            gScape.lib.log(color, "Sending character data to player " .. receiver:Nick() .. "...")
            net.Start(char_ext:getTag() .. ".vars.sync")
                net.WriteEntity(self:getPlayer())
                net.WriteUInt(self:getSlot(), 8)
                net.WriteTable(data)
            net.Send(self:getPlayer())
        elseif receiver:IsPlayer() then
            local data = {}
            for i, v in next, (self.vars) do
                if char_ext.vars[i] and !char_ext.vars[i].isLocal and !char_ext.vars[i].noReplication then
                    data[i] = v
                end
            end
            gScape.lib.log(color, "Sending character data to player " .. receiver:Nick() .. "...")
            net.Start(char_ext:getTag() .. ".vars.sync")
                net.WriteEntity(self:getPlayer())
                net.WriteUInt(self:getSlot(), 8)
                net.WriteTable(data)
            net.Send(receiver)
        end
    end
end

gScape.extentions.update("core.character", character)