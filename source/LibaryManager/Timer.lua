-- // Variables
local TimerLibary = { Name = "Timer" }
local TimerObject = { Name = "Timer" } TimerObject.__index = TimerObject

-- // Timer Methods
function TimerObject:Start() self.Clock = os.clock() self.Started:Fire() end
function TimerObject:Stop() self.Cancelled:Fire() return self.Time end
function TimerObject:Continue() self.Started:Fire() end

function TimerObject:GetTimeMS() return math.round((os.clock() - self.Clock) * 1000) end
function TimerObject:GetTimeS() return math.round(os.clock() - self.Clock) end
function TimerObject:GetTimeM() return self:GetTimeS() / 60 end
function TimerObject:GetTimeH() return self:GetTimeS() / 60 / 60 end

-- // Libary Methods
function TimerLibary.new()
    local TimerObject = setmetatable({ }, TimerObject)
    local Signal = TimerLibary.Infinity.Signal

    TimerObject.Time = 0

    TimerObject.Cancelled = Signal.new()
    TimerObject.Started = Signal.new()

    TimerObject.Started:Connect(function()
        if TimerObject.Active then return else TimerObject.Active = true end

        TimerObject.Cancelled:Wait()
        TimerObject.Active = false
        TimerObject.Time = os.clock() - TimerObject.Clock
    end)

    return TimerLibary.Infinity.Proxy:FromTable(TimerObject)
end

-- // Initialization
return function(Infinity)
    TimerLibary.Infinity = Infinity
    return TimerLibary
end