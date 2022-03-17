The hook libary in infinity isn't what you would really define a hook, but much more a simpler type of signal object, allowing you to bind functions to hooks which may or may not exist, likewise with invoking hooks which may exist or not. 

This libary is built for easy global function manipulation without initiating a dozen classes to do it for you.  

## HooksLibary Methods
### HooksLibary.InvokeHook
```lua
Infinity.Hooks.InvokeHook(HookName : Name, ... : Any)
```

This method will invoke all binded functions that are connected to our hook, if no hook is initiated then it will not error, but instead of not try to invoke anything. 

### HooksLibary.BindHook
```lua
Infinity.Hooks.BindHook(HookName : Name, Callback : Function) -- > Function
```

Calling BindHook will initiate a new hook table if there's not a hook defined yet, allowing you to bind to hooks which do not exist yet. 
The callback is the function which will be invoked through `InvokeHook`. 

The return is a function to *disconnect* the callback from the hook registry.