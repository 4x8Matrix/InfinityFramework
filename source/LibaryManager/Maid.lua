-- // Variables
local MaidLibary = { Name = "Maid" }
local MaidObject = { Name = "Maid" } MaidObject.__index = MaidObject

-- // Maid Methods
-- @About: Sort and clean different type of objects.
function MaidObject:Clean(...)
    for _, Object in ipairs(self.Internal) do
        local ObjectType = typeof(Object)

        if ObjectType == "RBXScriptConnection" then
            Object:Disconnect()
        elseif ObjectType == "function" then
            Object(...)
        elseif ObjectType == "Instance" then
            Object:Destroy()
        else
			if Object.Destroy then
				Object:Destroy()
            elseif Object.Disconnect then
                Object:Disconnect()
			else
                warn(("Maid Failed to Clean Object: %s"):format(tostring(Object)))
            end
        end
    end
end

-- @About: Remove an object from the maids cleaning loop
function MaidObject:Remove(Object)
    local Index = table.find(self.Internal, Object)

    if Index then
        table.remove(self.Internal, Index)
    end
end

-- @About: Register an object into the Maids Cleaning loop
function MaidObject:Register(Object)
    self.Internal[#self.Internal + 1] = Object
end

-- // Libary Methods
-- @About: Construct a new Maid Object
function MaidLibary.new()
    local MaidObject = setmetatable({ }, MaidObject)

    MaidObject.Internal = { }

    return MaidLibary.Infinity.Proxy:FromTable(MaidObject)
end

-- // Initialization
return function(Infinity)
    MaidLibary.Infinity = Infinity
    return MaidLibary
end