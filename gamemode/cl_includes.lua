//config
do
    include("config/sh_config.lua")
end

//libraries
do 
    -- files 
    local sh_includes = "lib/files/sh_includes.lua"
    include(sh_includes)

    -- meta
    local sh_inherit = "lib/meta/sh_inherit.lua"
    include(sh_inherit)

    local sh_player = "lib/meta/sh_player.lua"
    include(sh_player)

    -- timer 
    local sh_timer = "lib/timer/sh_timer.lua"
    include(sh_timer)

    -- overrides
    local cl_hudDisable = "lib/overrides/hud/cl_disable.lua"
    include(cl_hudDisable)

end

//core
do
    -- extension
    local sh_class = "core/exts/sh_extclass.lua"
    include(sh_class)

    local sh_hooks = "core/exts/sh_exthooks.lua"
    include(sh_hooks)

    //modules 
    
    --// characters
    -- class
    local sh_character = "core/modules/characters/class/sh_character.lua"
    include(sh_character)

    local sh_inventory = "core/modules/characters/class/sh_inventory.lua"
    include(sh_inventory)

    local sh_items = "core/modules/characters/class/sh_items.lua"
    include(sh_items)

    -- meta
    local sh_playerMeta = "core/modules/characters/meta/sh_player.lua"
    include(sh_playerMeta)

    local sh_inventoryMeta = "core/modules/characters/meta/sh_inventory.lua"
    include(sh_inventoryMeta)

    -- net
    local sh_net = "core/modules/characters/net/sh_net.lua"
    include(sh_net)

    local cl_net = "core/modules/characters/net/cl_net.lua"
    include(cl_net)

    --// hud
    local cl_npcOverHead = "core/modules/hud/cl_npcoverhead.lua"
    include(cl_npcOverHead)

end
