-- // Variables
local WatchdogLibary = { Name = "Watchdog" }

-- // Methods
function WatchdogLibary.new(Time, Callback, Function, ...)
    local Thread = coroutine.create(Function)

    task.delay(Time, function()
        if coroutine.status(Thread) == "dead" then return end

        Callback(coroutine.close(Thread))
    end)

    return coroutine.resume(Thread, ...)
end

-- // Initialization
return WatchdogLibary