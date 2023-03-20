local character = gScape.core.character.default or {}

do -- character meta
    function character:sync()
    end

    function character:getPlayer()
        return self.player
    end

    function character:setPlayer(player)
        self.player = player
    end

    function character:getName()
        return self.name
    end

    function character:setName(name)
        self.name = name
    end

    function character:getModel()
        return self.model
    end

    function character:setModel(model)
        self.model = model
    end

    function character:getInventory()
        return self.inventory
    end

    function character:setInventory(inventory)
        self.inventory = inventory
    end

    function character:getSlot()
        return self.slot
    end

    function character:setSlot(slot)
        self.slot = slot
    end

    function character:getMode()
        return self.mode
    end

    function character:setMode(mode)
        self.mode = mode
    end

    function character:getLevel()
        return self.level
    end

    function character:setLevel(level)
        self.level = level
    end

    function character:getXP()
        return self.xp
    end

    function character:setXP(xp)
        self.xp = xp
    end
end

gScape.core.character.default = character