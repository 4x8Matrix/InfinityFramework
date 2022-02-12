## About
A PublicClass represents a global, accessable class. 

When Infinity is Initialized, this class will be added to the Infinity pool, allowing you to reference this class through Infinity, this will allow all of your modules and so on to manipulate the functions, states, signals and so on inside of this class.

!!! Warning
    When you Extend a PublicClass, you have to define a ClassName argument. 
    This is because PublicClasses require a ClassName in order to be added to the infinity registry, without a Name, you would not be able to reference it through Infinity.

!!! Information
    This class is in the infinity event register, meaning this class will recieve events such as **Stepped**, **Heartbeat**, and so forth. You can read more about this over [here!](../BaseClass)

## Example

!!! Information
    ModuleScript's Parent is Script#1. Therefore allowing Infinity.FileSystem:LoadModules to require the ModuleScript!

**Module Script**
```lua
local Class = Infinity.PublicClass:Extend("ClassName") -- Argument #1: ClassName is really important!

-- Just a psuedo class to use as an example

Class.Random = math.random

function Class:ComputeRandomNumber(Val0, Val1)
    return self.Random(Val0, Val1)
end
```

**Script #1**
```lua
local Infinity = require(game["..."].Infinity)

-- This will require all modules under the parent script.
Infinity.FileSystem:LoadModules(script)
Infinity:Initialize():Then(function()
    local Class = Infinity.ClassName -- This is a reference to our Class-Object we constructed in the ModuleScript

    print(Class:ComputeRandomNumber()) -- We can access that classes functions and so on.
end)
```