-- // Varables
local FunctionLibary = { Name = "NetEvent" } FunctionLibary.__index = FunctionLibary
local FunctionObject = { Name = "NetEvent" } FunctionObject.__index = FunctionObject

-- // Object Methods
function FunctionObject:Bind(Function)
    self.Function = Function
end

function FunctionObject:Invoke(...)
    return FunctionLibary.Infinity.Promise.new(function(Promise, ...)
        if FunctionLibary.Infinity.IsServer then
            local Arg1 = select(1, ...)

            if type(Arg1) ~= "userdata" then return Promise:Reject("Argument #1 Expected Player") end
            if Arg1.ClassName ~= "Player" then return Promise:Reject("Argument #1 Expected Player") end

            local Result = { pcall(self.Object.InvokeClient, self.Object, ...) }
            local Success = table.remove(Result, 1)

            return (Success and Promise:Resolve(table.unpack(Result))) or Promise:Reject(Result[2])
        else
            local Result = { pcall(self.Object.InvokeServer, self.Object, ...) }
            local Success = table.remove(Result, 1)

            return (Success and Promise:Resolve(table.unpack(Result))) or Promise:Reject(Result[2])
        end
    end, ...)
end

-- // Libary Methods
function FunctionLibary.new(EventName, Function)
    local FunctionObject = setmetatable({ }, FunctionObject)

    FunctionObject.Function = Function
    FunctionObject.CallNumber = 0

    function FunctionObject.OnInvoke(...)
        if FunctionObject.Function then return FunctionObject.Function(...) end
    end

    if FunctionLibary.Infinity.IsServer then
        FunctionObject.Object = Instance.new("RemoteFunction")
        FunctionObject.Object.Name = EventName
        FunctionObject.Object.Parent = FunctionLibary.Folder

        FunctionObject.Object.OnServerInvoke = FunctionObject.OnInvoke
    else
        FunctionObject.Object = FunctionLibary.Folder:WaitForChild(EventName)
        FunctionObject.Object.OnClientInvoke = FunctionObject.OnInvoke
    end

    return FunctionLibary.Infinity.Proxy:FromTable(FunctionObject)
end

return function(Infinity)
    FunctionLibary.Infinity = Infinity

    if not FunctionLibary.Infinity.IsPlugin then
        if FunctionLibary.Infinity.IsServer then
            FunctionLibary.Folder = Instance.new("Folder")

            FunctionLibary.Folder.Name = "InfinityRemoteFunctions"
            FunctionLibary.Folder.Parent = game:GetService("ReplicatedStorage")
        else
            FunctionLibary.Folder = game:GetService("ReplicatedStorage"):WaitForChild("InfinityRemoteFunctions")
        end
    end

    return setmetatable({ Functions = { } }, FunctionLibary)
end