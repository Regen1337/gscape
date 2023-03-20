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
            // TODO: send data to player
            net.Start("netScape.character.vars.sync")
                

        elseif receiver:IsPlayer() then
            local data = {}
            for i, v in pairs(self.vars) do
                if gScape.core.character.vars[i] and !gScape.core.character.vars[i].isLocal and !gScape.core.character.vars[i].noReplication then
                    data[i] = v
                end
            end


        end
    end
end

gScape.core.character.default = character