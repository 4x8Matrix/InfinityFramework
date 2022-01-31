-- // Variables
local HookLibary = { Name = "Hooks" }

-- // Methods
function HookLibary:InvokeHook(HookName, ...)
    if HookLibary.__hooks[HookName] then
        for _, Value in ipairs(HookLibary.__hooks[HookName]) do
            task.spawn(Value, ...)
        end
    end
end

function HookLibary:BindHook(HookName, Callback)
    if HookLibary.__hooks[HookName] then
        table.insert(HookLibary.__hooks[HookName], Callback)
    else
        HookLibary.__hooks[HookName] = { Callback }
    end

    return function()
        local Index = table.find(HookLibary.__hooks[HookName], Callback)

        if Index then
            table.remove(HookLibary.__hooks[HookName], Index)
        end
    end
end

-- // Initialization
return function(Infinity)
    HookLibary.Infinity = Infinity
    HookLibary.__hooks = { }

    return HookLibary
end