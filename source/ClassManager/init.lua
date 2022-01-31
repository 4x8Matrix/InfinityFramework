-- // Services
local RunService = game:GetService("RunService")

-- // Variables
local ClassManager = { }

ClassManager.Children = script:GetChildren()
ClassManager.Classes = { }

-- // Methods
function ClassManager:Object(Class)
    local Proxy = newproxy(true)
    local Table = getmetatable(Proxy)

    local Name = Class.Name or "INFINITY_CLASS"

	Table.__index = Class
	Table.__newindex = Class
    Table.__tostring = function() return Name end
    Table.__metatable = "The metatable is locked"

    return Proxy
end

function ClassManager:Construct(Infinity, ClassName)
    local Class = self.Classes.BaseClass:Construct(Infinity)

    Class:__Inherit(self.Classes[ClassName])
    Class:__Initialize(self.Classes[ClassName])

    Class.Construct = nil

    return self:Object(Class)
end

-- // Initialization
function ClassManager:Initialize()
    for _, Value in ipairs(self.Children) do
        ClassManager.Classes[Value.Name] = require(Value)
    end

    return ClassManager
end

return ClassManager:Initialize()