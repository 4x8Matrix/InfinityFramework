Once Infinity is installed, it's quite simple to take advantage of, to reference Infinity you're going to have to require the Infinity Source/Module. 

```lua
-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Variables
local Infinity = require(ReplicatedStorage:WaitForChild("Infinity"))
```

From here, we can access libaries, classes and singletons! 
As an example, I'll be show off how to use the custom iteration Infinity allows you to do!

```lua
local Iteration = Infinity.Iter:FromVararg(1, 2, 3, "Hello", "World")

for Value in Iteration do
    warn("Value:", Value)
    warn("Index:", Iteration:GetIndex())
    warn("Key:", Iteration:GetKey())
end
```

The following code will interpret any arguments passed into the method **FromVararg** and Iterate though them. The iteration object also accepts roblox-pages as an input, allowing you to iterate through global leaderboards and so on. 

--------------------------------

Extending Infinity classes is also a feature which developers can take advantage of, When you extend a class, you inherit that classes properties, methods and so on. Allowing you to create an extention from that class.

Below is an example of how we would create virtual boat classes that we can manipulate! 

```lua

-- // Classes
local BoatSingleton = Infinity.PublicClass:Extend("BoatSingleton") -- This would be our Singleton/Service
local GenericBoat = Infinity.PrivateClass:Extend("BoatObject") -- This would be our Component

-- // GenericBoat Signals
GenericBoat:NewSignal("CaptainChanged")

-- // GenericBoat Methods
function GenericBoat:SetCaptain(Player)
    self.Captain = Player
    self.CaptainChanged:Fire(Player)

    -- Whenever we call NewSignal, NewSymbol etc, the result will always be added to the class.
    -- This way we do not need to manually assign it!
end

function GenericBoat:GetModelRoot()
    -- self.Model refers to the Model we added in our :OnExtend function below!

    return self.Model.PrimaryPart
end

function GenericBoat:OnExtended(Class, Model)
    -- This function is called when :Extend is called on our `GenericBoat` object
    -- We get the new class, and any arguments given through the :Extend function! 

    Class.Model = Model
end

-- // BoatSingleton Methods
function BoatSingleton:CreateVirtualBoat(BoatModel)
    -- The BoatModel argument will be the 2nd argument passed into the :OnExtended function above!

    local OurBoatObject = GenericBoat:Extend(BoatModel)

    print(OurBoatObject:GetModelRoot()) -- > BoatModel's Primary Part

    return OurBoatObject
end

```

!!! Note
    The code above isn't a complete example of a boat system, there's alot more which could be put into it.