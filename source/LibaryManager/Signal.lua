-- // Variables
local SignalLibary = { Name = "Signal" }
local SignalObject = { Name = "Signal" } SignalObject.__index = SignalObject
local ConnectionObject = { Name = "Connection" } ConnectionObject.__index = ConnectionObject

SignalLibary.Enabled = newproxy()
SignalLibary.Disabled = newproxy()

-- // Connection Methods
function ConnectionObject.new(Disconnect, Reconnect)
    local ConnectionObject = setmetatable({ Connected = true }, ConnectionObject)

    function ConnectionObject:Destroy(...)
        self.Destroyed = true

        Disconnect(...)
    end

    function ConnectionObject:Disconnect(...)
        self.Connected = false

        Disconnect(...)
    end

    function ConnectionObject:Reconnect(...)
        if self.Destroyed then return end

        self.Connected = false

        Reconnect(...)
    end

    return SignalLibary.Infinity.Proxy:FromTable(ConnectionObject)
end

-- // Signal Methods
function SignalObject:Connect(Routine)
    local Connection
    Connection = ConnectionObject.new(function()
        local Index = table.find(self.Internal.Methods, Routine)
        if Index then table.remove(self.Internal.Methods, Index) end

        Index = table.find(self.Internal.Connections, Routine)
        if Index then table.remove(self.Internal.Connections, Index) end
    end, function()
        self.Internal.Methods[#self.Internal.Methods + 1] = Routine
        self.Internal.Connections[#self.Internal.Connections + 1] = Connection
    end)

    self.Internal.Methods[#self.Internal.Methods + 1] = Routine
    self.Internal.Connections[#self.Internal.Connections + 1] = Connection
    return Connection
end

function SignalObject:Wait()
    self.Internal.Threads[#self.Internal.Threads + 1] = coroutine.running()

    return coroutine.yield()
end

function SignalObject:Fire(...)
    if self.State ~= SignalLibary.Enabled then return end

    local Threads = self.Internal.Threads self.Internal.Threads = { }

    for _, Thread in ipairs(Threads) do
        coroutine.resume(Thread, ...)
    end

    for _, Routine in ipairs(self.Internal.Methods) do
        task.spawn(Routine, ...)
    end
end

function SignalObject:FireIn(Number, ...)
    task.delay(Number, self.Fire, self, ...)
end

function SignalObject:SetState(State)
    if type(State) == "boolean" then State = (State and SignalLibary.Enabled) or SignalLibary.Disabled end

    self.State = State
end

function SignalObject:Destroy()
    for Index, Value in ipairs(self.Internal.Connections) do
        Value:Disconnect()
    end

    self:SetState(SignalLibary.Disabled)
end

-- // Libary Methods
function SignalLibary.new()
    local SignalObject = setmetatable({ }, SignalObject)

    SignalObject.State = SignalLibary.Enabled
    SignalObject.Internal = { Threads = { }; Methods = { }; Connections = { }; }

    return SignalLibary.Infinity.Proxy:FromTable(SignalObject)
end

function SignalLibary:IsSignal(Object)
    return getmetatable(Object) == SignalObject
end

function SignalLibary:IsConnection(Object)
    return getmetatable(Object) == ConnectionObject
end

-- // Initialization
return function(Infinity)
    SignalLibary.Infinity = Infinity
    return SignalLibary
end