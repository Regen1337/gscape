local interval = engine.TickInterval() * 2

function timer.nextTickDebounced(id, func)
    if timer.Exists(id) then return end
    timer.Create(id, interval, 1, func)
end

function timer.nextTick(func)
    timer.Simple(interval, func)
end