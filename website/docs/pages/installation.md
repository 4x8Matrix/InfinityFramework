## Sample Program
```lua
local function ComputePageName()
    return _G.Page.Class.Name
end

warn(ComputePageName())
```