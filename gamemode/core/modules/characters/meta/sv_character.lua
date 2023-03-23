local character = gScape.core.character.default or {}
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
            for i, v in pairs(self.vars) do
                if gScape.core.character.vars[i] and !gScape.core.character.vars[i].noReplication then
                    data[i] = v
                end
            end
            gScape.lib.log(color, "Sending character data to player " .. receiver:Nick() .. "...")
            net.Start("netScape.character.vars.sync")
                net.WriteEntity(self:getPlayer())
                net.WriteUInt(self:getSlot(), 8)
                net.WriteTable(data)
            net.Send(self.vars.player)
        elseif receiver:IsPlayer() then
            local data = {}
            for i, v in pairs(self.vars) do
                if gScape.core.character.vars[i] and !gScape.core.character.vars[i].isLocal and !gScape.core.character.vars[i].noReplication then
                    data[i] = v
                end
            end
            gScape.lib.log(color, "Sending character data to player " .. receiver:Nick() .. "...")
            net.Start("netScape.character.vars.sync")
                net.WriteEntity(self:getPlayer())
                net.WriteUInt(self:getSlot(), 8)
                net.WriteTable(data)
            net.Send(receiver)
        end
    end
end

gScape.core.character.default = character