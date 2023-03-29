print("Loading hook library...")
// This code is used to retrieve the hook table, and sets it to the local variable "_hooks"
local _hooks = hook.Hooks

--[==[
    This do block is used to retrieve the hook table if it is not found in the global hook.Hooks variable.
    This is done by checking the upvalues of the hook.GetTable function.
]==]
do
    if not _hooks then for i = 1, 5 do
        print("Checking upvalue " .. tostring(i))
        local name, value = debug.getupvalue(hook.GetTable, i)
        if name == "Hooks" then _hooks = value break end
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
    if isentity(name) then return end
    
    if not isstring(event) then error("bad argument #1 to 'hook.Add' (string expected, got " .. type(event) .. ")", 0) end
    if not isstring(name) then error("bad argument #2 to 'hook.Add' (string expected, got " .. type(name) .. ")", 0) end
    if not isfunction(func) then error("bad argument #3 to 'hook.Add' (function expected, got " .. type(func) .. ")", 0) end

    if not _hooks[event] then _hooks[event] = {} end
    _hooks[event][name] = func
end

--[==[
    This function removes a event and respective function from the hook list.
    @param event The name of the event.
    @param name The name of the hook.
]==]
function hook.Remove(event, name)
    if not isstring(event) then error("bad argument #1 to 'hook.Remove' (string expected, got " .. type(event) .. ")", 0) end
    if not isstring(name) then error("bad argument #2 to 'hook.Remove' (string expected, got " .. type(name) .. ")", 0) end

    if _hooks[event] then _hooks[event][name] = nil end
end

--[==[
    This function is used to call a event, overriding the default hook.Call function to allow for custom hooks; used internally by hook.Run
    @param event The name of the event.
    @param gm The gamemode table.
    @param ... The arguments to pass to the event.
]==]
function hook.Call(event, gm, ...)
    if not isstring(event) then error("bad argument #1 to 'hook.Call' (string expected, got " .. type(event) .. ")", 0) end
    
    local hooks = _hooks[event]
    
    if hooks then
        local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = ...

        for name, func in next, hooks do
            if isstring(name) then
                a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = func(...)
            elseif IsValid(name) then
                a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = func(name, ...)
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

        for name, tbl in next, gScape.__ext do
            local func = tbl[event]

            if isfunction(func) then
                a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z = func(tbl, ...)
            
                if a or b then
                    return a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
                end
            end
        end
    end

    if not gm then return end

    local func = gm[event]
    if not func then return end
    
    return func(gm, ...)
end

--[[
    The hook.Run function is called whenever an event is triggered.
    @param event The name of the event.
    @param ... The arguments to pass to the event.
]]
function hook.Run(event, ...)
    return hook.Call(event, GAMEMODE or GM, ...)
end