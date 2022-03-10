-- // Varables
local EventLibary = { Name = "NetEvent" } EventLibary.__index = EventLibary
local EventObject = { Name = "NetEvent" } EventObject.__index = EventObject

-- // Object Methods
function EventObject:Connect(Routine)
    local EventName = EventLibary.Infinity.IsServer and "OnServerEvent" or "OnClientEvent"

    return self.Object[EventName]:Connect(function(...)
        Routine(...)
    end)
end

function EventObject:Fire(...)
    if EventLibary.Infinity.IsServer then
        local Arg1 = select(1, ...)

        if type(Arg1) == "userdata" and Arg1.ClassName == "Player" then
            self.Object:FireClient(...)
        else
            self.Object:FireAllClients(...)
        end
    else
        self.Object:FireServer(...)
    end
end

-- // Libary Methods
function EventLibary.new(EventName)
    local EventObject = setmetatable({ }, EventObject)

    EventObject.CallNumber = 0

    if EventLibary.Infinity.IsServer then
        EventObject.Object = Instance.new("RemoteEvent")
        EventObject.Object.Name = EventName
        EventObject.Object.Parent = EventLibary.Folder
    else
        EventObject.Object = EventLibary.Folder:WaitForChild(EventName)
    end

    return EventLibary.Infinity.Proxy:FromTable(EventObject)
end

return function(Infinity)
    EventLibary.Infinity = Infinity

    if not EventLibary.Infinity.IsPlugin then
        if EventLibary.Infinity.IsServer then
            EventLibary.Folder = Instance.new("Folder")

            EventLibary.Folder.Name = "InfinityRemoteEvents" 
            EventLibary.Folder.Parent = game:GetService("ReplicatedStorage")
        else
            EventLibary.Folder = game:GetService("ReplicatedStorage"):WaitForChild("InfinityRemoteEvents")
        end
    end

    return setmetatable({ Events = { } }, EventLibary)
end