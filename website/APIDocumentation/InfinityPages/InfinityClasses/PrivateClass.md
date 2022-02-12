## About
A BoatClass represents a class which will not be added to the Infinity registry, allowing you to create classes that are not attached, yet still recieve things such as events from Infinity. 

This class is not effected by the Infinity Initialization pipeline, however will still recieve events such as *Initialize*

This classes best use-case would be creating components, you would use this class to create unique objects which can be used to achieve a multitude of things. 

!!! Information
    This class is in the infinity event register, meaning this class will recieve events such as **Stepped**, **Heartbeat**, and so forth. You can read more about this over [here!](../BaseClass)

## Example
!!! Information
    ModuleScript's Parent is Script#1. Therefore allowing Infinity.FileSystem:LoadModules to require the ModuleScript!

*ModuleScript*
```lua
local BoatClass = Infinity.BoatClass:Extend("MyCoolClass") -- It is suggested that you define a name.

BoatClass:NewSignal("DriverChanged")

function BoatClass:SetDriver(Player)
    self.Driver = Player
    self.DriverChanged:Fire(Player)
end

return BoatClass
```

*Script #1*
```lua
local BoatClass = require(script.ModuleScript)
local BoatObject = BoatClass:Extend()

BoatObject:SetDriver(game.Players.AsynchronousMatrix)
```