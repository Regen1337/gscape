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

do
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
end


do
    local long_names = {
        [1] = {10^3 , "Thousand"},
        [2] = {10^6 , "Million"},
        [3] = {10^9 , "Billion"},
        [4] = {10^12, "Trillion"},
        [5] = {10^15, "Quadrillion"},
        [6] = {10^18, "Quintillion"},
    }

    local short_names = {
        [1] = {10^3 , "K"},
        [2] = {10^6 , "M"},
        [3] = {10^9 , "B"},
        [4] = {10^12, "T"},
        [5] = {10^15, "Qd"},
        [6] = {10^18, "Qn"},
    }

    --[==[
        @desc: formats a number to a readable format
        @param: num - the number to format
        @param: long - whether to use long names or not
        @return: string
    ]==]
    function gScape.lib.nformat(num, long)
        local names = long and long_names or short_names
        for i = #names, 1, -1 do
            local v = names[i]
            if num >= v[1] then
                return string.format("%.2f", num / v[1]) .. v[2]
            end
        end
        return tostring(num)
    end
end

