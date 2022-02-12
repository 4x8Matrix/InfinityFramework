The 'BaseClass' is the base of each class, every Infinity class inherits its functions, properties and so on from this class. 

!!! Warning
    This class is not designed to be constructed or extended from, this class is essentially a structure for other classes, in no way is it meant to represent it's own class. 

## Event Register
Some classes are subjected to recieve events, the purpose of this is to make your life as a develop easier. To recieve an event, you'll have to create a function within the class. Infinity will then invoke this function when that specific event is fired.

The events are as follows.

### Heartbeat
```lua
function Class:Heartbeat(...)
    self:CalculateAbc(...)
end
```

The Heartbeat function will be invoked each [Heartbeat](https://developer.roblox.com/en-us/api-reference/event/RunService/Heartbeat)

!!! Infomation
    This event only applies to classes inside of the Infinity-Event register, classes such as *StaticClass* will not recieve these events.

!!! Warning
    Infinity Events are Single-Threaded, on each new render, it will go through all classes with the RenderStepped function, and it will run them [ No thread assigned to it. ]

--------------------
### Stepped
```lua
function Class:Stepped(...)
    self:CalculateAbc(...)
end
```

The Heartbeat function will be invoked each [RenderStepped](https://developer.roblox.com/en-us/api-reference/event/RunService/RenderStepped)

!!! Infomation
    This event only applies to classes inside of the Infinity-Event register, classes such as *StaticClass* will not recieve these events.

!!! Warning
    Infinity Events are Single-Threaded, on each new render, it will go through all classes with the RenderStepped function, and it will run them [ No thread assigned to it. ]

--------------------
### OnExtended
```lua
function Class:OnExtended(SubClass: <Infinity.BaseClass>Infinity.Class, ...: any)
    SubClass.Name = select(1, ...)
end
```

 - `Class`: The class which is being extended from
 - `SubClass`: The class which is being created from the Extend function
 - `...`: Any variables passed into the Extend function.

OnExtended is a special function to allow a developer to edit sub-classes which are created from our Class object. This class will not yet be defined, so a developer can access and manipulate the class in whatever way they would like too. 

--------------------
### Initialize
```lua
function Class:Initialize(...)
    self.Abc = 1

    print("Whoo Hoo!")
end
```

 - `...`: Variables passed into the Infinity:Initialize function. 

This method will be invoked when Infinity is Initialized, At this point you can access all public classes and so on, allowing you to define infinity services and so on within the class.

## FullName Subjection
Objects subjected to being a FullName will have their strings parsed in a unique way, The string will be split by it's periods " *.* " and a new table will be added into the previous table (if there is no previous table, then the previous table will be the class itself).

```lua
local Class = Infinity.PrivateClass:Extend()

Class:NewState("StatesTable.State123", "StateValue")

-- State123 is the Key.
-- StatesTable is the newly created table.

-- Infinity will create a new table called StatesTable,
-- Infinity will construct a new State object with the value of StateValue
-- Infinity will set StatesTable.State123 as the result of that object

print(Class.StatesTable) -- > Table { State }

-- Things like this are awesome for Signals and so on.
Class:NewSignal("GameEvents.MainEvent")
```

## BaseClass API
### BaseClass Methods
#### Class.NewState
```lua
ClassObject:NewState(StateFullName: string, StateValue: any) --> Infinity.State
```

Helper function used to create a new Infinity state object, the constructed state is added to the class and returned
For more information on state objects, look [here](../../InfinityLibaries/StateLibary)

!!! Info
    FullName Strings are subject to [FullName-Subjection](#fullname-subjection), The string passed into this function will be parsed and handled in a unique way.

--------------------
#### Class.NewSignal
```lua
ClassObject:NewSignal(SignalFullName: string) --> Infinity.Signal
```

Helper function used to create a new Infinity signal object, the constructed signal is added to the class and returned
For more information on signal objects, look [here](../../InfinityLibaries/SignalLibary)

!!! Info
    FullName Strings are subject to [FullName-Subjection](#fullname-subjection), The string passed into this function will be parsed and handled in a unique way.

--------------------
#### Class.NewSymbol
```lua
ClassObject:NewSymbol(SymbolFullName: string) --> userdata
```

Symbols are an interpretation of our roblox enumeration system, each class has the ability to assign custom symbols to itself, these symbols represent class enumerations, for example they could represent a class state, weather it's active or dead.

!!! Info
    FullName Strings are subject to [FullName-Subjection](#fullname-subjection), The string passed into this function will be parsed and handled in a unique way.

--------------------
#### Class.IsSuper
```lua
ClassObject:IsSuper(SuperClass: <Infinity.BaseClass>Infinity.Class) --> bool
```

Returns if the super given in the first argument is the super of the current class object

--------------------
#### Class.Maid
```lua
ClassObject:Maid() -- > Infinity.Maid
```

Creates a maid object to handle and clean up the class, to access the maid object you'll have to either reference it as a maid object or index the class with 'MaidObject'

When this class is destroyed, the method :Destroy will be called on the maid, destroying all connections etc you have connected to the maid object.

--------------------
#### Class.Await
```lua
ClassObject:Await(ObjectName: string) -- > Object
```

Await yields the current thread until an object has been found inside of the class, this can be used to pause execution until a flag has been met on an object and so forth. 

--------------------
#### Class.GetMethods
```lua
ClassObject:GetMethods() -- > { MethodName: Method }
```

Returns a dictionary of methods/functions that have been added to the class object.

--------------------
#### Class.Destroy
```lua
ClassObject:Destroy()
```

Initiates an iteration through the class object, destroying, disconnecting and removing objects within the class itself. 

!!! Warning  
    When calling this method, there is a chance you can break all sub-classes which have been extended from this class. 

    References up-stream can be broken by removing them from this class.

--------------------
#### Class.Extend
```lua
ClassObject:Extend(...<any>) -- > Sub-Class of ClassObject
```

This method is used to create extentions of every class inside of the Infinity framework, This function is added to each Class and can be called on each class, allowing you to infinitly extend and create components from other components.

The result of an extend is a subclass of the class you just extended from, everything from ClassObject will be inherited into this new SubClass which will reference functions and so on from our previous classes.

!!! Information
    When you extend a class, Infinity does a measure of things to initiate a new sub-class, this includes inheriting values, calling the *OnExtended* function, and so on. 

    Some classes may require specific arguments when extending from it, for example, PublicClass requires a ClassName argument!

### BaseClass Properties
#### Class.Type
```lua
ClassObject.Type --> String
```
Returns the type of Class it is, Ranging from PublicClass to Proxy/Network Class

--------------------
#### Class.Name
```lua
ClassObject.Name --> String
```
The name of the class, the name can be set by the class or during the extention of a class.

--------------------
#### Class.Infinity
```lua
ClassObject.Infinity --> Infinity
```
A reference to the Infinity Framework, Internal use mostly.

--------------------
#### Class.Super
```lua
ClassObject.Infinity --> ClassObject
```
Returns the [Super Class](https://www.w3schools.com/java/ref_keyword_super.asp#:~:text=The%20super%20keyword%20refers%20to,methods%20with%20the%20same%20name.) to this class. 