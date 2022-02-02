## Properties
### Infinity.Name
[ [string](https://developer.roblox.com/en-us/articles/String) ] : 
Returns the Object Name.

----------------------------
### Infinity.IsStudio
[ [boolean](https://developer.roblox.com/en-us/articles/Boolean) ] : 
Aliase for [RunService:IsStudio()](https://developer.roblox.com/en-us/api-reference/function/RunService/IsStudio)

----------------------------
### Infinity.IsServer
[ [boolean](https://developer.roblox.com/en-us/articles/Boolean) ] : 
Aliase for [RunService:IsServer()](https://developer.roblox.com/en-us/api-reference/function/RunService/IsServer)

----------------------------
### Infinity.StaticClass
[ [PublicClass](classes/publicClass.md) ] : The base PublicClass object used to :Extend objects from. 

----------------------------
### Infinity.PrivateClass
[ [PrivateClass](classes/privateClass.md) ] : The base PrivateClass object used to :Extend objects from. 

----------------------------
### Infinity.PublicClass
[ [PublicClass](classes/publicClass.md) ] : The base PublicClass object used to :Extend objects from. 

----------------------------
### Infinity.NetworkClass
[ [NetworkClass](classes/netClass.md) ] : The base NetworkClass object used to :Extend objects from. 

## Functions

### Infinity.Initialize
```lua
Infinity:Initialize(<Any>...) -> InfinityPromise 
```
The main Initialization method which'll Initialize all Infinity Classes & So on. 
This method returns a [Promise](libs/promise.md), From this promise you can run Asynchronous tasks, An example of a [Fail-Safe](https://en.wikipedia.org/wiki/Fail-safe) system would be the following. 

```lua
local GlobalSettings = { GameVersion = "1.0.0" }
local Promise = Infinity:Initialize(GlobalSettings)

Promise:Then(function()
    print("[Infinity]:", "Loaded!")
end)

Promise:Catch(function(Exception)
    warn("[Infinity][Critical]:", Exception)

    -- Instead of being `Hopeless` when our system fails. We could introduce failure systems.
    -- For example, we could attempt to retry our framework, or just teleport all players
    -- To a different game and use Analytics to post an Error.

    task.wait(5)
    Promise:Retry()
end)
```

!!! warning "Caution"
    The following example will reload a system infinitely, Which is really not good if we're using datastores or using exessive API's 
    Roblox's end, this is an example of what you can do.