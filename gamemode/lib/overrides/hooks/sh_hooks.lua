// This code is used to retrieve the hook table, and sets it to the local variable "_hooks"
local _hooks = hook.Hooks

--[==[
    This do block is used to retrieve the hook table if it is not found in the global hook.Hooks variable.
    This is done by checking the upvalues of the hook.GetTable function.
]==]
do
    if not _hooks then for i = 1, 5 do
        local name, value = debug.getupvalue(hook.GetTable, i)
        if name = ["Hooks"] then _hooks = value break end
    end end

    _hooks = _hooks or {}
    hook.Hooks = _hooks
end

--This function returns the table of hooks.
function hook.GetTable() return _hooks end

--[==[ 
    Adds a function to the event hook list.
    @param event The name of the event.
    @param name The name of the hook.
    @param func The hook function.
]==]
function hook.Add(event, name, func)
    if not isstring(event) then error("bad argument #1 to 'hook.Add' (string expected, got " .. type(event) .. ")", 2) end
    if not isstring(name) then error("bad argument #2 to 'hook.Add' (string expected, got " .. type(name) .. ")", 2) end
    if not isfunction(func) then error("bad argument #3 to 'hook.Add' (function expected, got " .. type(func) .. ")", 2) end

    if not _hooks[event] then _hooks[event] = {} end
    _hooks[event][name] = func
end

--[==[
    This function removes a event and respective function from the hook list.
    @param event The name of the event.
    @param name The name of the hook.
]==]
function hook.Remove(event, name)
    if not isstring(event) then error("bad argument #1 to 'hook.Remove' (string expected, got " .. type(event) .. ")", 2) end
    if not isstring(name) then error("bad argument #2 to 'hook.Remove' (string expected, got " .. type(name) .. ")", 2) end

    if _hooks[event] then _hooks[event][name] = nil end
end

function hook.Call(event, gm, ...)
    if not isstring(event) then error("bad argument #1 to 'hook.Call' (string expected, got " .. type(event) .. ")", 2) end
    
    local hooks = _hooks[event]
    
    if hooks then
        local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = ...

        for name, func in next, hooks do
            if isstring(name) then
                a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = xpcall(func, debug.traceback, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
            elseif IsValid(name) then
                a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = xpcall(func, debug.traceback, name, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
            else
                _hooks[event] = nil
            end

            if a or b then
                return a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
            end
        end
    end

    if gScape and gScape.__ext then
        local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = ...

        for name, func in next, gScape.__ext do
            local func = func[event]

            if isfunction(func) then
                a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = xpcall(func, debug.traceback, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
            
                if a or b then
                    return a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
                end
            end
        end
    end

    if not gm then return end

    local _gm = gm[event]
    if not _gm then return end
    
    return _gm(gm, ...)
end

--[[
    The hook.Run function is called whenever an event is triggered.
    @param event The name of the event.
    @param ... The arguments to pass to the event.
]]
function hook.Run(event, ...)
    return hook.Call(event, GAMEMODE or GM, ...)
end

--[==[
    This function overrides the hook.Call function in the _R table.
]==]
function hook.oRegistry()
    if hook.oCall then return end

    local _R = debug.getregistry()
    local hookCall

    for i = 1, 65536 do
        local value = _R[i]
        local name = isfunction(v) and debug.getinfo(v).short_src

        if name and name == "lua/includes/modules/hook.lua" then hookCall = i break end
    end

    if not hookCall then return end
    gScape.lib.log(String.format("hook.oRegistry: hookCall = _R[%s]", hookCall))

    hook.oCall = _R[hookCall]
    hook.oCall_Index = hookCall
    _R[hookCall] = hook.Call
end

timer.nextTick(hook.oRegistry)


