--[=[
    @About: A public class will be a table/proxy that is added to the Infinity Module, so any script can access the class and call methods and so on
    @About: This class will recieve all Infinity Events. This isn't a good class for Components.
]=]--

-- // Variables
local PublicClass = { Name = "PublicClass", Type = "PublicClass" }
PublicClass.Methods = { }

-- // Class Methods

-- // Methods
function PublicClass:Construct(Class)
    function Class.Extended(Class, ClassName)
        assert(ClassName ~= nil, "PublicClass requires a ClassName.")

        Class.Name = ClassName

        table.insert(Class.Infinity.Classes, Class)
        table.insert(Class.Infinity.Public, Class)
        table.insert(Class.Infinity.Events, Class)
    end

    return Class
end

return PublicClass