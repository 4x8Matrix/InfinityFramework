## About
The class is essentially as close as you can get to a BaseClass, The class has no events and no special features inherited from Infinity.

This class is essentially the BaseClass, Therefore this class would also be a good candidate for a custom class, handled by your own scripts you could serialize a StaticClass into a Component, System, Service etc. Static Class is designed to be a clean slate for you to do what you want with it. 

For example, a reason why you might want to use this class is for a libary, libaries contain static methods and variables which you can reference at a later date, this class would be a good candidate for that.

## Example
*Script #1*
```lua
local StaticClass = Infinity.StaticClass:Extend()

StaticClass.Abc = 123
StaticClass.Abc123 = function()

end

Infinity.StaticLibary = StaticClass
```
*Script #2*
```lua
Infinity.Hooks:BindHook("Init", function()
    local Class = Infinity.StaticLibary

    Class.Abc123()
end)
```