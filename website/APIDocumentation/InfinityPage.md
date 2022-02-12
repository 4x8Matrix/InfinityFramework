## Infinity Registry
The Infinity registy is essentially a dictionary holding alot of key classes, properties, methods and so on. 
The Infinity module itself is the Registry, once you initialize infinity, classes will be added to infinity directly, allowing you to access Infinity classes like;

*Script #1*
```lua
local Class = Infinity.PublicClass:Extend("MyPublicClass")

Class.Variable = "Hello, World!"
```
*Script #2*
```lua
-- This hooks gets invoked when Infinity gets initialized, allowing us to connect to the infinity Init-Pipeline
Infinity.Hooks:BindHook("Init", function()
    local MyClass = Infinity.MyPublicClass

    print(MyClass.Variable)
end)
```

!!! Important
    Below is an example of what you should NOT do.

```lua
-- This hooks gets invoked when Infinity gets initialized, allowing us to connect to the infinity Init-Pipeline
local MyClass = Infinity.MyPublicClass

print(MyClass.Variable) -- > This will error, Indexing nil 'Variable' 
-- Infinity hasn't started yet, any `PublicClass` objects aren't in the Infinity Registry
```


## Infinity Model
### Infinity Require Model
<img src="/Assets/Images/InfinityRModel.png" width="400">

The Infinity Require model explains what hapens when you first require the Infinity Module, There's alot more going on than what you'd assume. 

!!! Warning
    Infinity that is called on the client will yield until it's master (Server Infinity) is Initialized, If your script isn't loading or Infinity isn't loading, make sure that your server Infinity is Initialized and loaded!

    Infinity Clients need the Master in order to recieve critical information about NetClasses and so on.

### Infinity Initialize Model
<img src="/Assets/Images/InfinityIModel.png" width="400">

The Infinity initialize model is very different from the Require Model, This model represents what happens when you call :Initialize on the Infinity object. 

## Infinity API
### Infinity Methods
#### Infinity.Initialize
```lua
Infinity:Initialize(...:any) -> Infinity.Promise
```

This is the function which will initialize infinity and it's classes. It is required that you register all required modules before calling this function, after you call this function classes such as PublicClass & NetworkClass cannot be initiated. 

This method will also lock the Infinity Registry, attempting to write to Infinity will result in an error, however you were able too in it's pre-initialized state.

For an example, I'll be a script I use for most of my Infinity-Client tests.

```lua
-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- // Variables
local ClockInit = os.clock()
local Infinity = require(ReplicatedStorage:WaitForChild("Infinity"))

-- // Load FileSystem

-- LoadModules loops through the objects children, requiring them
-- if the child returns a function, this childs function is executed with
-- the one argument of infinitu itself.

Infinity.FileSystem:LoadModules(script.Singletons)
Infinity.FileSystem:LoadModules(script.Components)
Infinity.FileSystem:LoadModules(script.Interface)
Infinity.FileSystem:LoadModules(script.Logic)

-- // Init
Infinity:Initialize():Then(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    Infinity.Console:Log(("Client Initialized [%sms]"):format(os.clock() - ClockInit))
end):Catch(function(Promise, Exception)
	Infinity.Console:Warn(Exception)

    -- At this point you can impliment a custom system to teleport you into the same game
    -- Or have a backup system ready to deploy if this system fails.
end)
```

### Infinity Properties
#### Infinity.IsServer
```lua
Infinity.IsSever --> Bool
```

Aliase for RunService:IsServer()

#### Infinity.IsStudio
```lua
Infinity.IsStudio --> Bool
```

Aliase for RunService:IsStudio()
