## Start Infinity
Create a new `Script` Object and parent it to `ServerScriptService` in Roblox Studio or Via your third party syncing program:
```lua
-- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Variables
local Infinity = require(ReplicatedStorage.Infinity)

-- // Load Modules
-- this is just a basic module-loader. You can advance this by creating module components, and futher, singletons and so on.
-- the reason we introduce a module-loader is because we call :Initialize below, We need to set up a game before we Initialize Infinity. 
-- hence why we call our Modules to create their classes and such before we Initialize Infinity.
for _, Module in ipairs(script:GetChildren()) do 
    require(Module)
end

-- // Init
Infinity:Initialize():Catch(warn)

```

!!! warning "Context is important!"
    It is very important that you first require and initialize infinity on the server before attempting to do so on the client, more about this is discussed below under `Context Matters`
    
--------------------------------

## Initialization & Process
When you first require the Infinity Module, a series of steps are taken to ensure the framework is set up and prepared for what the game damands.

--------------------------------

### Context Matters
The difference between Server-Client is massive, and when it comes to Infinity, It is very important too. The client depends on the server for a multitude of things, not just it's NetworkClasses. 

Ensure that you've loaded the Server-Framework before you load the Client-Framework. The Client-Framework will yield any thread calling Infinity until the server has been :Initialized

--------------------------------

### Pre-Initialization
Infinity before initialization is essentially a table, wrapped as a UserData, You can add and remove things without issue. 
Infinity at this stage should be used to add custom variables, tables, and references you might use in the future, such as Global Game Settings.

!!! warning "Table Contents are Frozen"
    Anything that is added to this Infinity Table will be `locked` in place when the call :Initialize is made, attempting to edit or modify Infinity at that stage will result in an error.

--------------------------------

### Post-Initialization
This is when your classes finally become classes, Each class you've made will finally be added to the Infinity Object, Allowing you to reference a class by doing the following:

```lua
local Infinity = require(game["..."].Infinity)

Infinity:Initialize():Then(function()
    print(Infinity.MyClass)
end)
```

Now, there's a critical problem we have right now, is that, what if our classes require, a different class. Well, Infinity builds Methods & Events into these classes, When you call :Initialize on Infinity, if a class has the function `Initialize` then this function will be fired. 

```lua
local Infinity = require(game["..."].Infinity)
local ClassObject = Infinity.PublicClass:Extend("MyClass")

function ClassObject:Initialized()
    warn(self.Name, "Was Initialized!")
end

Infinity:Initialize():Then(function()
    print(Infinity.MyClass)
end)
```