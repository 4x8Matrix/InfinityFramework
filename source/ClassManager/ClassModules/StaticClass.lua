--[=[
    @About: This is the BaseClass, There's nothing added to it, This class would be good for libaries and such.
]=]--

-- // Variables
local StaticClass = { Name = "StaticClass", Type = "StaticClass" }
StaticClass.Methods = { }

-- // Class Methods

-- // Methods
function StaticClass:Construct(Class)
    return Class
end

return StaticClass