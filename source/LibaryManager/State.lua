-- // Variables
local StateLibary = { Name = "State" }
local StateObject = { Name = "StateObject" } StateObject.__index = StateObject

-- // Methods
function StateObject:Get() return self.Value end
function StateObject:Set(Value) self.Value = Value self.Changed:Fire() end

function StateObject:Update(Transform) self.Value = Transform(self.Value) self.Changed:Fire() end

function StateObject:Inc(Value) self.Value = self.Value + Value self.Changed:Fire() end
function StateObject:Dec(Value) self.Value = self.Value - Value self.Changed:Fire() end

function StateLibary.new(Value)
    local Signal = StateLibary.Infinity.Signal

    return setmetatable({ 
        Value = Value;
        Changed = Signal.new();
    }, StateObject)
end

-- // Initialization
return function(Infinity)
    StateLibary.Infinity = Infinity
    return StateLibary
end