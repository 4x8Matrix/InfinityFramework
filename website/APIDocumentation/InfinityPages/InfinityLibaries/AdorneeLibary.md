Adornee Libary is a libary designed to make debugging translations, rotations and such in the roblox 3D environment easier, allowing you to deploy things such as sphere or arrows to help show you what is going on, where your CFrame is facing, and so on.

## AdorneeLibary Methods
### AdorneeLibary.Sphere
```lua
Infinity.Adornee.Sphere(TargetCFrame : CFrame) -- > Object
```

Object creates a new Adornee object which will render in a circle at the given CFrame. 
The return is the parent of these adornee objects.

### AdorneeLibary.Arrow
```lua
Infinity.Adornee.Arrow(TargetCFrame : CFrame) -- > Object
```

Object creates a new Adornee object which will render in a arrow at the given CFrame. 
The return is the parent of these adornee objects.

## Example
The following is an example of how you would use the Arrow function. 
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Infinity = require(ReplicatedStorage:WaitForChild("Infinity"))

Infinity:Initialize():Then(function()
	Infinity.Adornee.Arrow(CFrame.new(Vector3.new(), Vector3.new(10, 0, 10)))
end)
```

Would generate the following;

<img src="../../../SiteAssets/Images/ArrowAdorneeExample.png" width="200">