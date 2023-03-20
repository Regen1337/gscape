do -- @desc: draw health bar for nearby npcs
    local function getNearByNPCs()
        local ply = LocalPlayer()
        local npcs = {}
        for k, v in pairs(ents.GetAll()) do
            if v:IsNPC() and v:Health() > 0 and v:GetPos():Distance(ply:GetPos()) < 1000 then
                table.insert(npcs, v)
            end
        end
        return npcs
    end

    local function scaleHealthBar(npc)
        local ply = LocalPlayer()
        local distance = npc:GetPos():Distance(ply:GetPos())
        local scale = 1
        if distance < 1000 && npc:Health() > 1 then
            scale = 1 - (distance - 100) / 1000
        else
            scale = 0
        end
        return scale
    end

    local function drawHealthBar()
        local ply = LocalPlayer()
        local npcs = getNearByNPCs()
        for k, v in pairs(npcs) do
            local scale = scaleHealthBar(v)
            local pos = v:EyePos() + Vector(0, 0, 10)
            local pos2d = pos:ToScreen()
            local health = v:Health()
            local maxHealth = v:GetMaxHealth()
            local healthPercent = health / maxHealth
            local healthBarWidth = 75 * scale
            local healthBarHeight = 7.5 * scale
            local healthBarX = pos2d.x - healthBarWidth / 2
            local healthBarY = pos2d.y - healthBarHeight / 2
            local healthBarColor = Color(0, 255, 0, 255)
            local healthBarBackgroundColor = Color(255, 0, 0, 255)
            local healthBarBackgroundWidth = healthBarWidth
            local healthBarBackgroundHeight = healthBarHeight
            local healthBarBackgroundX = healthBarX
            local healthBarBackgroundY = healthBarY
            local healthBarBackground = {
                {x = healthBarBackgroundX, y = healthBarBackgroundY},
                {x = healthBarBackgroundX + healthBarBackgroundWidth, y = healthBarBackgroundY},
                {x = healthBarBackgroundX + healthBarBackgroundWidth, y = healthBarBackgroundY + healthBarBackgroundHeight},
                {x = healthBarBackgroundX, y = healthBarBackgroundY + healthBarBackgroundHeight}
            }
            local healthBar = {
                {x = healthBarX, y = healthBarY},
                {x = healthBarX + healthBarWidth * healthPercent, y = healthBarY},
                {x = healthBarX + healthBarWidth * healthPercent, y = healthBarY + healthBarHeight},
                {x = healthBarX, y = healthBarY + healthBarHeight}
            }
            surface.SetDrawColor(healthBarBackgroundColor)
            surface.DrawPoly(healthBarBackground)
            surface.SetDrawColor(healthBarColor)
            surface.DrawPoly(healthBar)
        end
    end

    hook.Add("HUDPaint", "drawHealthBar", drawHealthBar)
end