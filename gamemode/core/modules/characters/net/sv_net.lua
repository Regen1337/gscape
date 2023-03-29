local char_ext = gScape.extentions.get("core.character")
local item_ext = gScape.extentions.get("core.item")

util.AddNetworkString(char_ext:getTag() .. "s.vars.sync")
util.AddNetworkString(char_ext:getTag() .. ".vars.sync")
util.AddNetworkString(char_ext:getTag() .. ".var.sync")

-- items sync
util.AddNetworkString(item_ext:getTag() .. ".vars.sync")
util.AddNetworkString(item_ext:getTag() .. ".var.sync")
