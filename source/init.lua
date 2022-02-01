-- // Services
local RunService = game:GetService("RunService")

-- // Variables
local Infinity = { Name = "InfinityFramework", Author = "@AsyncMatrix" } Infinity.__index = Infinity

-- // Infinity Initialization
function Infinity:Initialize(...)
    return self.Promise.new(function(Promise, ...)
        local Proxy = self.__proxy self.__proxy = nil

        for _, Class in next, self.Classes do
            if Class.Initialized then
                local Success, Result = pcall(Class.Initialized, Class, ...)

                if not Success then
                    Promise:Reject(Class.Name .. " : " .. Result)
                end
            end

            if self.ClassManager.Classes[Class.Type].Finally then
                local Success, Result = pcall(self.ClassManager.Classes[Class.Type].Finally, self.ClassManager.Classes[Class.Type], Class, ...)

                if not Success then
                    Promise:Reject(Class.Name .. " : " .. Result)
                end
            end

            if not Class.IgnoreInfinityRegister then self[Class.Name] = Class end
        end

        self.Initialized = true
        self.Active = nil
        self.Classes = nil

        if self.IsServer then 
            script:SetAttribute("InfinityStateFlag", true) 
        end

        Proxy.__newindex = function() return error("Infinity is Read-Only", math.huge) end
        Promise:Resolve()
    end, ...)
end

-- // Base Infinity Constructor
function Infinity.new()
    local self = setmetatable({ }, Infinity)

    self.IsStudio = RunService:IsStudio()
    self.IsServer = RunService:IsServer()

    self.ClassManager = require(script.ClassManager)
    self.LibaryManager = require(script.LibaryManager)

    self.Wrapper = require(script.InfinityWrapper)
    self.Stepped = (self.IsServer and RunService.Heartbeat) or RunService.RenderStepped

    self.LibaryManager:Export(self)
    return self.Wrapper:Complete(self)
end

return Infinity.new()