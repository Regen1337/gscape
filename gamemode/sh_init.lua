GM.Name = "gScape"
GM.Author = "regen et al."
GM.Email = "regen@nuke.africa"
GM.Website = "N/A"
DeriveGamemode( "sandbox" )

gScape = {}
gScape.core = {}
gScape.config = {}
gScape.lib = {}

function gScape.lib.print(color, ...)
    color = color or color_white
    MsgC(color, "[λScape] ", color_white, ...)
    MsgC(color_white, "\n")
end