-- // Services
local RunService = game:GetService("RunService")

-- // Variables
local Infinity = { Name = "InfinityFramework" } Infinity.__index = Infinity

-- // Infinity Initialization
function Infinity:Initialize(...)
    return self.Promise.new(function(Promise, ...)
        local Proxy = self.__proxy self.__proxy = nil

        RunService.Heartbeat:Wait()

        for _, Class in ipairs(self.Classes) do
            if self.ClassManager.Classes[Class.Type].Finally then
                local Success, Result = pcall(
                    self.ClassManager.Classes[Class.Type].Finally,
                    self.ClassManager.Classes[Class.Type],
                    Class,
                    ...
                )

                if not Success then
                    Promise:Reject(Class.Name .. " : " .. Result)
                end
            end
        end

        for _, Class in ipairs(self.Public) do
            self[Class.Name] = Class
        end

        for _, Class in ipairs(self.Classes) do
            if Class.Initialize then
                local Success, Result = pcall(Class.Initialize, Class, ...)

                if not Success then
                    Promise:Reject(Class.Name .. " : " .. Result)
                end
            end
        end

        script:SetAttribute("InfinityStateFlag", true)

        self.Hooks:InvokeHook("Init")
        self.ClassManager:BuildEventLoop(self.Events)

        self.Initialized = true

        self.Events = nil
        self.Public = nil
        self.Classes = nil

        Proxy.__newindex = function() return error("Infinity is Read-Only", math.huge) end

        Promise:Resolve()
    end, ...)
end

function Infinity:SyncInfinity()
    local Stream = self.Net.Function.new("InfinitySync")

    if self.IsServer then
        Stream:Bind(function(Player)
            if not self.Initialized then repeat task.wait() until self.Infinity.Initialized end

            local NetClasses = { }

            for _, Class in ipairs(self.Network) do
                table.insert(NetClasses, Class.Name)
            end

            return { Classes = NetClasses }
        end)
    else
        local Synced = false
        local Promise do
            Promise = Stream:Invoke():Then(function(ServerSyncPacket)
                local Classes = ServerSyncPacket.Classes

                for _, ClassName in ipairs(Classes) do
                    self.ProxyClass:Extend(ClassName)
                end

                Synced = true
            end):Catch(function(Promise, Exception)
                warn(("Infinity // Critical // Client-Server Sync: %s"):format(Exception))
                task.wait(.5)

                Promise:Retry()
            end) -- :Await()

            -- Fail: Unable to `Await` this, Coroutine.yield effects the logic of Require
        end

        while not Synced do task.wait() end
    end
end

-- // Base Infinity Constructor
function Infinity.new()
    local self = setmetatable({ }, Infinity)

    self.IsStudio = RunService:IsStudio()
    self.IsServer = RunService:IsServer()
    self.IsPlugin = pcall(RunService.IsEdit, RunService)

    self.Classes = { }
    self.Network = { }
    self.Events = { }
    self.Public = { }

    self.ClassManager = require(script.ClassManager):Init(self)
    self.LibaryManager = require(script.LibaryManager):Init(self)

    self.Wrapper = require(script.InfinityWrapper):Init(self)
    self.Stepped = (self.IsServer and RunService.Heartbeat) or RunService.RenderStepped

    self.LibaryManager:DeployLibaries()
    self.ClassManager:ConstructClasses()

    if not self.IsPlugin then
        self:SyncInfinity()
    end

    return self.Wrapper:Complete()
end

return Infinity.new()