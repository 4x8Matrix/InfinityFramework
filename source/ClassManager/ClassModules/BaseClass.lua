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
function ClassObject.Methods:NewState(StateFullName, Value)
    local SignalPath = string.split(StateFullName, ".")
    local Base = self

    for Index, Value in ipairs(SignalPath) do
        if Index == #SignalPath then
            Base[Value] = self.Infinity.State.new(Value)
        else
            Base[Value] = Base[Value] or { }

            Base = Base[Value]
        end
    end

    return Base[Value]
end

function ClassObject.Methods:NewSignal(SignalFullName, Value)
    local SignalPath = string.split(SignalFullName, ".")
    local Base = self

    for Index, Value in ipairs(SignalPath) do
        if Index == #SignalPath then
            Base[Value] = self.Infinity.Signal.new(Value)
        else
            Base[Value] = Base[Value] or { }

            Base = Base[Value]
        end
    end

    return Base[Value]
end

function ClassObject.Methods:NewSymbol(SymbolName)
    local SymbolPath = string.split(SymbolName, ".")
    local Base = self

    for Index, Value in ipairs(SymbolPath) do
        if Index == #SymbolPath then
            Base[Value] = newproxy(true)

            getmetatable(Base[Value]).__tostring = function()
                return Value
            end
        else
            Base[Value] = Base[Value] or { }

            Base = Base[Value]
        end
    end

    return Base[SymbolName]
end

function ClassObject.Methods:IsSuper(Object)
    return self.Super == Object
end

function ClassObject.Methods:Maid()
    if self.MaidObject then
        self.MaidObject:Destroy()
    end

    self.MaidObject = self.Infinity.Maid.new()
    return self.MaidObject
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
            elseif Value.Name == "Maid" then
                Value:Destroy()
            end
        elseif typeof(Value) == "RBXScriptConnection" then
            Value:Disconnect()
        elseif typeof(Value) == "Instance" then
            Value:Disconnect()
        end

        self[Index] = nil
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

function ClassObject.Methods:Extend(...)
    local ClassMetatable = { __index = self; }
    local ClassPrototype = setmetatable({ Super = self; }, ClassMetatable)
    local ClassObject = self.Infinity.Proxy:FromTable(ClassPrototype)

    function ClassObject:OnExtended() end

    if ClassPrototype.Extended then ClassObject:Extended(...) end

    if self.OnExtended then
        self:OnExtended(ClassObject, ...)
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