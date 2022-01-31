-- // Variables
local ProxyLibary = { Name = "Proxy" }

-- // Methods
function ProxyLibary:FromTable(Source, Readonly)
    local Proxy = newproxy(true)
    local Table = getmetatable(Proxy)

    local Name = Source.Name or "InfinityProxy"

    Table.__index = Source
    Table.__newindex = (Readonly and { }) or Source
    Table.__tostring = function() return Name end
    Table.__metatable = "The metatable is locked"
    Table.__call = function(...) return Source(...) end

    return Proxy
end

return ProxyLibary