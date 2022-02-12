-- // Variables
local InfinityWrapper = { }

-- // Methods
function InfinityWrapper:Complete()
    if not self.Infinity.IsServer then
        repeat task.wait() until script.Parent:GetAttribute("InfinityStateFlag")
    end

    local Proxy = newproxy(true)
    local Table = getmetatable(Proxy)

    local Name = self.Infinity.Name or "INFINITY_Infinity"

    self.Infinity.__proxy = Table

    Table.__index = self.Infinity
    Table.__newindex = self.Infinity
    Table.__tostring = function() return Name end
    Table.__metatable = "The metatable is locked"

    return Proxy
end

-- // Initialization
function InfinityWrapper:Init(Infinity)
    self.Infinity = Infinity

    return InfinityWrapper
end

return InfinityWrapper