local character = gScape.core.character.default or {}

do -- character meta
    function character:syncVars(receiver)
        if receiver == nil then
            local players = player.GetAll()
            for i,v in next, players do
                self:syncVars(v)
            end
        elseif receiver == self.vars.player then
            local data = {}
            for i, v in pairs(self.vars) do
                if gScape.core.character.vars[i] and !gScape.core.character.vars[i].noReplication then
                    data[i] = v
                end
            end
            print("Sending character data to player " .. receiver:Nick() .. "...")
            net.Start("netScape.character.vars.sync")
                net.WriteEntity(self.vars.player)
                net.WriteUInt(character:getSlot(), 8)
                net.WriteTable(data)
            net.Send(self.vars.player)
        elseif receiver:IsPlayer() then
            local data = {}
            for i, v in pairs(self.vars) do
                if gScape.core.character.vars[i] and !gScape.core.character.vars[i].isLocal and !gScape.core.character.vars[i].noReplication then
                    data[i] = v
                end
            end
            print("Sending character data to player " .. receiver:Nick() .. "...")
            net.Start("netScape.character.vars.sync")
                net.WriteEntity(self.vars.player)
                net.WriteUInt(character:getSlot(), 8)
                net.WriteTable(data)
            net.Send(receiver)
        end
    end
end

gScape.core.character.default = character