-- // Variables
local InfinityWrapper = { }

-- // Methods
function InfinityWrapper:Object(Infinity)
    local Proxy = newproxy(true)
    local Table = getmetatable(Proxy)

    local Name = Infinity.Name or "INFINITY_Infinity"

    Infinity.__proxy = Table

    Table.__index = Infinity
    Table.__newindex = Infinity
    Table.__tostring = function() return Name end
    Table.__metatable = "The metatable is locked"

    return Proxy
end

function InfinityWrapper:Sync(Infinity)
    local Stream = Infinity.Net.Function.new("InfinityInitClientSync")

    if Infinity.IsServer then
        Stream:Bind(function(Player)
            if not Infinity.Initialized then repeat task.wait() until Infinity.Initialized end

            local NetClasses = { }

            for _, Class in ipairs(Infinity.Network) do
                NetClasses[#NetClasses + 1] = Class.Name
            end

            return { Classes = NetClasses }
        end)
    else
        local Synced = false
        local Promise do
            Promise = Stream:Invoke():Then(function(ServerSyncPacket)
                local Classes = ServerSyncPacket.Classes

                for _, ClassName in ipairs(Classes) do
                    Infinity.ProxyClass:Extend(ClassName)
                end

                Synced = true
            end):Catch(function(Exception)
                warn(("Server-Sync Error: %s"):format(Exception))
                task.wait(.5)

                Promise:Retry()
            end) -- :Await()

            -- Fail: Unable to `Await` this, Coroutine.yield effects the logic of Require
        end

        while not Synced do task.wait() end
    end
end

function InfinityWrapper:Inherit(Infinity)
    Infinity.Classes = { }
    Infinity.Network = { }

    Infinity.StaticClass = Infinity.ClassManager:Construct(Infinity, "StaticClass")
    Infinity.PrivateClass = Infinity.ClassManager:Construct(Infinity, "PrivateClass")
    Infinity.PublicClass = Infinity.ClassManager:Construct(Infinity, "PublicClass")

    Infinity.ProxyClass = Infinity.ClassManager:Construct(Infinity, "ProxyClass")
    Infinity.NetworkClass = Infinity.ClassManager:Construct(Infinity, "NetworkClass")
end

function InfinityWrapper:Complete(Infinity)
    if not Infinity.IsServer then
        repeat task.wait() until script.Parent:GetAttribute("InfinityStateFlag")
    end

    self:Inherit(Infinity)
    self:Sync(Infinity)

    return self:Object(Infinity)
end

-- // Initialization
function InfinityWrapper:Initialize()
    return InfinityWrapper
end

return InfinityWrapper:Initialize()