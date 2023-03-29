//config
do
    include("config/sh_config.lua")
    AddCSLuaFile("config/sh_config.lua")

    include("config/sv_config.lua")

    AddCSLuaFile("config/cl_config.lua")
end

//libraries
do 
    -- files 
    local sh_includes = "lib/files/sh_includes.lua"
    include(sh_includes)
    AddCSLuaFile(sh_includes)

    -- meta
    local sh_inherit = "lib/meta/sh_inherit.lua"
    include(sh_inherit)
    AddCSLuaFile(sh_inherit)

    local sh_player = "lib/meta/sh_player.lua"
    include(sh_player)
    AddCSLuaFile(sh_player)

    -- timer 
    local sh_timer = "lib/timer/sh_timer.lua"
    include(sh_timer)
    AddCSLuaFile(sh_timer)

    -- overrides
    local cl_hudDisable = "lib/overrides/hud/cl_disable.lua"
    AddCSLuaFile(cl_hudDisable)
    
end

//core
do
    -- extension
    local sh_class = "core/exts/sh_extclass.lua"
    include(sh_class)
    AddCSLuaFile(sh_class)

    local sh_hooks = "core/exts/sh_exthooks.lua"
    include(sh_hooks)
    AddCSLuaFile(sh_hooks)

    //modules 
    
    --// characters
    -- class
    local sh_character = "core/modules/characters/class/sh_character.lua"
    include(sh_character)
    AddCSLuaFile(sh_character)

    local sh_inventory = "core/modules/characters/class/sh_inventory.lua"
    include(sh_inventory)
    AddCSLuaFile(sh_inventory)

    local sh_items = "core/modules/characters/class/sh_items.lua"
    include(sh_items)
    AddCSLuaFile(sh_items)

    -- meta
    local sv_characterMeta = "core/modules/characters/meta/sv_character.lua"
    include(sv_characterMeta)

    local sh_playerMeta = "core/modules/characters/meta/sh_player.lua"
    include(sh_playerMeta)
    AddCSLuaFile(sh_playerMeta)

    local sh_inventoryMeta = "core/modules/characters/meta/sh_inventory.lua"
    include(sh_inventoryMeta)
    AddCSLuaFile(sh_inventoryMeta)

    -- net
    local sh_net = "core/modules/characters/net/sh_net.lua"
    include(sh_net)
    AddCSLuaFile(sh_net)

    local sv_net = "core/modules/characters/net/sv_net.lua"
    include(sv_net)

    local cl_net = "core/modules/characters/net/cl_net.lua"
    AddCSLuaFile(cl_net)

    --// hud
    local cl_npcOverHead = "core/modules/hud/cl_npcoverhead.lua"
    AddCSLuaFile(cl_npcOverHead)

end


--[[// config files
gScape.lib.files.includeDir("gamemode/config/")

// libraries
gScape.lib.files.includeDir("gamemode/lib/meta/")
gScape.lib.files.includeDir("gamemode/lib/timer/")
gScape.lib.files.includeDir("gamemode/lib/overrides/")

// core
// core - extension
gScape.lib.files.includeDir("gamemode/core/exts/")

// core - modules
gScape.lib.files.includeDir("gamemode/core/modules/")
]]
