DeriveGamemode( "sandbox" )

GM.Name = "gScape"
GM.Author = "regen"
GM.Email = "regen@420blaze.it"
GM.Website = "https://iliketouwu.com"

GM.Credits = [==[
    -__ __- _______________________________________________________________________________________________ -__ __-     
    -__ __- LOLLOLOLOOLOLOLOLO____LO|||LOLOLOLOL___OOOLLLLLOL||||||||P||||||||A____|||ING||||||||I||| -__ __-
    -__ __- LOLLOLOL||||||||LOLOLOLOLOLOLOLOLOOOLLLLLOOL||||||||_____EADI||||||||T||||||||IS -__ __-
    -__ __- LOLLOLOLOOLOLOLOLOLOLOL____OLOLOLOOOLLLLLOOL||||||||E____AD||||||||G||||||||I|| -__ __-
    -__ __- LOLLOLOL||||||||LOLOLOL|||OLOLOLOLOLOOOLLLLL||||||||____OPREA||||||||T||||||||I||||||||-__ __-
    -__ __- LOLLOLOLOOLOLOLOL||||||||OL____OLOLOO___OLLLLLOOLS|||||O|||P____REA||||||||NG||||||||H||||||||__ __-
    -__ __- LOLLOLOLOOLOLOLOLOLOLOLOLOLOLOOOLLLLLOOL||||T||||REA____D||||||||||||||| -__ __-
    -__ __- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||-__ __-     

]==]

gScape = {}

gScape.core = {} -- core files
gScape.config = {} -- config files
gScape.lib = {} -- library files

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

