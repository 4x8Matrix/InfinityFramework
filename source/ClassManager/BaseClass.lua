--[=[
    @About: This is the base class, the class which is used to construct each and every other class.
    @About: This class isn't avliable for public/accessbility use, you can't just create a `BaseClass` you need to inherit this from
    @About: the other classes.
]=]--

-- // Variables
local BaseClass = { Name = "BaseClass", Type = "BaseClass" }
local ClassObject = { Name = "ClassObject" } ClassObject.__index = ClassObject
ClassObject.Methods = { }

-- // Class Methods
function ClassObject.Methods:NewState(StateName, Value) self[StateName] = self.Infinity.State.new(Value) return self[StateName] end
function ClassObject.Methods:NewSignal(SignalName, Value) self[SignalName] = self.Infinity.State.new(Value) return self[SignalName] end
function ClassObject.Methods:NewSymbol(SymbolName)
    self[SymbolName] = newproxy(true)

    getmetatable(self[SymbolName]).__tostring = function()
        return SymbolName
    end
end

function ClassObject.Methods:NewMaid()
    if self.Maid then
        self.Maid:Destroy()
    end

    self.Maid = self.Infinity.Maid.new()

    return self.Maid
end

function ClassObject.Methods:Await(Object)
    if self[Object] then return self[Object] end
    repeat task.wait() until self[Object]

    return self[Object]
end

function ClassObject.Methods:GetMethods()
    local Methods = { }

    for Index, Value in next, self do
        if type(Value) == "function" then
            Methods[Index] = Value
        end
    end

    return Methods
end

function ClassObject.Methods:Destroy()
    for Index, Value in next, self do
        if type(Value) == "userdata" then
            if Value.Name == "Signal" then
                Value:Destroy()
            elseif Value.Name == "Connection" then
                Value:Disconnect()
            end
        elseif typeof(Value) == "RBXScriptConnection" then
            Value:Disconnect()
        end
    end
end

function ClassObject.Methods:__Initialize(Prototype)
    Prototype:Construct(self)
end

function ClassObject.Methods:__Inherit(Prototype)
    for Index, Value in pairs(Prototype.Methods or { }) do
        self[Index] = Value
    end

    self.Type = Prototype.Type
    self.Name = Prototype.Name
    -- Eventually there'll be more things to initialize
end

function ClassObject.Methods:Extend(Name)
    local ClassMetatable = { __index = self }
    local ClassPrototype = setmetatable({ Name = Name }, ClassMetatable)
    local ClassObject = self.Infinity.Proxy:FromTable(ClassPrototype)

    function ClassObject:OnExtended() end

    if ClassPrototype.Extended then ClassObject:Extended(Name, ClassMetatable) end

    if self.OnExtended then
        self:OnExtended(ClassObject)
    end

    ClassMetatable.__metatable = "the metatable is locked"
    return ClassObject
end

-- // Methods
function BaseClass:Construct(Infinity, Class)
    local BaseClass = setmetatable({ }, Class)

    BaseClass.Infinity = Infinity
    BaseClass.Name = self.Name
    BaseClass.Type = self.Type

    for Index, Value in pairs(ClassObject.Methods) do
        BaseClass[Index] = Value
    end

    return BaseClass
end

return BaseClass