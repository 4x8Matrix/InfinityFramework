A NetworkClass is a very special class used to breach the Client-Server, Server-Client relationship, this class will allow you to connect signals, functions, properties and so on, so that the client can access them. 

This Class is alot like the PublicClass, this class will be added to the infinity registry, You can read more about that [here!](../PublicClass)

!!! Information
    This class is in the infinity event register, meaning this class will recieve events such as **Stepped**, **Heartbeat**, and so forth. You can read more about this over [here!](../BaseClass)

    The events fired here are context-bound, Server's Heartbeat wont be sent to the client. 

## NetworkClass Model
<img src="../../../Assets/Images/NetworkCModel.png" width="200">

When a Client joins the game, they will recieve a packet holding important information to structure and replicate NetworkClasses to their Infinity client, from here on the client will create a *ProxyClass* [Internal Infinity Class] which will be used to replicate functions, signals and so on to the server.

This ProxyClass represents the Server-NetworkClass, Call functions and so on as if you were calling the server. This ProxyClass respects the __namecall metamethod when it comes to functions, If you use :, the server will recieve self and so on.

A list of objects which can be replicated through the Infinity Proxy/Net class is:

 - Roblox Objects
 - Roblox Types
 - Infinity Signal

!!! warning
    NetworkClasses are Synced only when a Client joins the game, Attempting to Modify the NetworkClass after Infinitity is Initialized will result in errors.

## NetworkClass API
### NetworkClass Methods
#### Class.Fire
```lua
ClassObject:Fire(FunctionName)
```

This function will invoke functions which have been added to the client proxy class.
however, if there is no function within this proxy class, nothing will be invoked.

*ServerScript*
```lua
local Class = Infinity.NetworkClass:Extend("ClassObject")

function Class.Client:InvokeMethodAbc(Player)
    Class:Fire("Abc", 123)
end
```

*LocalScript*
```lua
Infinity.Hooks:BindHook("Init", function()
    local NetworkClass = Infinity.ClassObject

    function NetworkClass.Abc(...)
        warn("Yes! We got:", ...)
    end

    NetworkClass:InvokeMethodAbc()
end)
```

### NetworkClass Properties
#### Class.Client
```lua
ClassObject.Client -- > Table
```

This table represents what will be replicated to the client, we don't want to share our entire class, that could lead to some really big issues with security and so on. So we dedicate a Table for Client-Replication. 

Functions, Signals and so on not added to this table will not be recieved on the client.

#### Class.Function
```lua
ClassObject.Client -- > Infinity.Net.Function
```

This is the primary net function used to internally communicate things to the client.

!!! Warning
    Changing the behaviour of this function can lead to problems with the class itself working, However if you want to write custom logic for a Net class, this is what you'll have to manipulate.

#### Class.Event
```lua
ClassObject.Client -- > Infinity.Net.Event
```

This is the primary net event used to internally communicate things to the client.

!!! Warning
    Changing the behaviour of this function can lead to problems with the class itself working, However if you want to write custom logic for a Net class, this is what you'll have to manipulate.

## Example
*ServerScript*
```lua
local Class = Infinity.NetworkClass:Extend("ServerTimeService")

Class:NewSignal("Client.UpdatedTime")

-- self refers to the class object, not the Client table. Behaviour has changed slightly there.
function Class.Client:GetServerTime(Player)
    self.Time = tick()
    self.Client.UpdatedTime:Fire(self.Tick)

    return self.Time
end
```

*LocalScript*
```lua
Infinity.Hooks:BindHook("Init", function()
    local NetworkClass = Infinity.ServerTimeService

    while true do
        warn("Delay:", tick() - NetworkClass:GetServerTime())

        task.wait(5)
    end
end)
```