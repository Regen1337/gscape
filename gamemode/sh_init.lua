GM.Name = "gScape"
GM.Author = "regen et al."
GM.Email = "regen@nuke.africa"
GM.Website = "N/A"
DeriveGamemode( "sandbox" )

gScape = {}
gScape.core = {}
gScape.config = {}
gScape.lib = {}

--[==[
    @desc: prints a message to the console with a prefix
    @param: color - the color of the prefix
    @param: ... - the message to print
    @return: void
]==]
function gScape.lib.log(color, ...)
    color = color or color_white
    MsgC(color, "[λScape] ", color_white, ...)
    MsgC(color_white, "\n")
end