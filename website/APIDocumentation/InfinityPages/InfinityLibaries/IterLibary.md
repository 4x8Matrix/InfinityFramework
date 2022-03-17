## IterLibary Methods
### IterLibary.new
```lua
Infinity.Iter.new(Table : Table) -- > IterObject
```

This function creates a new [IterObject](#IterObject) which can be used to iterate across arrays, dictionaries, roblox page objects and so fourth. 

### IterLibary.FromVararg
```lua
Infinity.Iter:FromVararg(... : Any) -- > IterObject
```

This function is simply an aliase, helper function to call [IterLibary.new](#iterobjectnext), the only difference is that the arguments given are not packed into a table. 

## IterObect
### IterObject Methods
#### IterObject.Reset
```lua
IterObject:Reset()
```

once this method is called, it will reset the iteration to start at the beginning again. 

!!! warning
    Do not call this inside of the iteration loop, it could cause a potential infinite loop which can cause your studio/environment to crash, if you choose to reset inside of the loop then 

#### IterObject.Stop
```lua
IterObject:Stop()
```

once this function is called, the iteration loop will stop. 

#### IterObject.GetKey
```lua
IterObject:GetKey()
```

this function returns the key in a dictionary, or the index if its an array. 
you should call this from within the iteration loop in order to retrieve the value.

#### IterObject.GetIndex
```lua
IterObject:GetIndex()
```

this function returns the index in a array, will also return the iteration number if called for a dictionary
you should call this from within the iteration loop in order to retrieve the value.

#### IterObject.GetValue
```lua
IterObject:GetValue()
```

this function returns the value of the current iteration loop.

#### IterObject.Next
```lua
IterObject:Next()
```

this function iterates the loop, this function will be called when doing a generic lua loop on this iteration object. 

## Example
```lua
local Iteration = Infinity.Iter.new({ 1, 2, 3 })

for Value in Iteration do
    warn(Value)
end
```