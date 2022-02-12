--[=[
    @About: This class wont be added to the infinity module when Initialized, it allowes you to create Components, then Extend off of that component
    @About: This class will still recieve events such as Initialized, Still partially attached to Infinity.
]=]--

-- // Variables
local PrivateClass = { Name = "PrivateClass", Type = "PrivateClass" }
PrivateClass.Methods = { }

-- // Class Methods

-- // Methods
function PrivateClass:Construct(Class)
    function Class.Extended(Class, ClassName)
        Class.Name = ClassName

        table.insert(Class.Infinity.Classes, Class)
        table.insert(Class.Infinity.Events, Class)
    end

    return Class
end

return PrivateClass