-- // Services
local RunService = game:GetService("RunService")

-- // Variables
local ClassManager = { Classes = { } }

ClassManager.ClassModules = require(script.ClassModules)

-- // Methods
function ClassManager:Construct(ClassName)
    local Class = self.Classes.BaseClass:Construct(self.Infinity)

    local Proxy = newproxy(true)
    local Table = getmetatable(Proxy)

    local Name = Class.Name or "INFINITY_CLASS"

	Table.__index = Class
	Table.__newindex = Class
    Table.__tostring = function() return Name end
    Table.__metatable = "The metatable is locked"

    Class:__Inherit(self.Classes[ClassName])
    Class:__Initialize(self.Classes[ClassName])

    Class.Construct = nil

    return Proxy
end

function ClassManager:InvokeClassEvent(EventClasses, Event, ...)
    for _, Class in ipairs(EventClasses) do
        if Class[Event] then
            if Class.Paralell and task.desynchronize then
                task.desynchronize()
                Class[Event](Class, ...)
                task.synchronize()
            else
                Class[Event](Class, ...)
            end
        end
    end
end

function ClassManager:AppendClassToEventLoop(EventClass)
    table.insert(self.__ClassListners, EventClass)
end

function ClassManager:BuildEventLoop(EventClasses)
    for _, Class in ipairs(EventClasses) do
        self:AppendClassToEventLoop(Class)
    end

    if not self.Infinity.IsServer then
        RunService.RenderStepped:Connect(function(...) self:InvokeClassEvent(self.__ClassListners, "Stepped", ...) end)
    end

    RunService.Heartbeat:Connect(function(...) self:InvokeClassEvent(self.__ClassListners, "Heartbeat", ...) end)
end

function ClassManager:ConstructClasses()
    self.Infinity.StaticClass = self:Construct("StaticClass")
    self.Infinity.PrivateClass = self:Construct("PrivateClass")
    self.Infinity.PublicClass = self:Construct("PublicClass")

    if self.Infinity.IsServer then
        self.Infinity.NetworkClass = self:Construct("NetworkClass")
    else
        self.Infinity.ProxyClass = self:Construct("ProxyClass")
    end
end

-- // Initialization
function ClassManager:Init(Infinity)
    self.Infinity = Infinity
    self.__ClassListners = { }

    for _, Value in ipairs(self.ClassModules) do
        ClassManager.Classes[Value.Name] = require(Value)
    end

    return ClassManager
end

return ClassManager