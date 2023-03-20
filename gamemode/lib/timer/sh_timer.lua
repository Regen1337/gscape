local interval = engine.TickInterval() * 2

--[==[
    @desc: Runs a function on the next tick, debounced by the given id
    @param: id - string - the id to debounce by
    @param: func - function - the function to run
    @return: void
]==]
function timer.nextTickDebounced(id, func)
    if timer.Exists(id) then return end
    timer.Create(id, interval, 1, func)
end

--[==[
    @desc: Runs a function on the next tick
    @param: func - function - the function to run
    @return: void
]==]
function timer.nextTick(func)
    timer.Simple(interval, func)
end