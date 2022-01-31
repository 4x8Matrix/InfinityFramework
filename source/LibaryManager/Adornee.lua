-- // Variables
local AdorneeLibary = { Name = "Adornee" }

-- // Libary Methods
function AdorneeLibary.Sphere(TargetCFrame)
    local Object = Instance.new("Part")
    local Sphere = Instance.new("SphereHandleAdornment")

    --------------------------------------------

    Object.Transparency = 1
    Object.Parent = workspace
    Object.Size = Vector3.new(2, 2, 2)
    Object.Locked = true
    Object.LocalTransparencyModifier = 1
    Object.CFrame = TargetCFrame
    Object.Anchored = true

    Object.CanCollide = false
    Object.CanTouch = false
    Object.CanQuery = false

    --------------------------------------------

    Sphere.ZIndex = 1
    Sphere.AlwaysOnTop = true
    Sphere.Parent = Object
    Sphere.Adornee = Object
    Sphere.Color3 = Color3.fromRGB(13, 105, 172)
    Sphere.Radius = 3

    return Object
end

function AdorneeLibary.Arrow(TargetCFrame)
    local Object = Instance.new("Part")
    local Cylinder = Instance.new("CylinderHandleAdornment")
    local Cone = Instance.new("ConeHandleAdornment")

    --------------------------------------------

    Object.Transparency = 1
    Object.Parent = workspace
    Object.Locked = true
    Object.Size = Vector3.new(2, 2, 2)
    Object.LocalTransparencyModifier = 1
    Object.CFrame = TargetCFrame
    Object.Anchored = true

    Object.CanCollide = false
    Object.CanTouch = false
    Object.CanQuery = false

    --------------------------------------------

    Cylinder.ZIndex = 1
    Cylinder.AlwaysOnTop = true
    Cylinder.Parent = Object
    Cylinder.Adornee = Object
    Cylinder.Color3 = Color3.fromRGB(13, 105, 172)
    Cylinder.Radius = 0.1
    Cylinder.SizeRelativeOffset = Vector3.new(0, 0, -2)
    Cylinder.Height = 4

    --------------------------------------------

    Cone.ZIndex = 1
    Cone.AlwaysOnTop = true
    Cone.Parent = Object
    Cone.Adornee = Object
    Cone.Color3 = Color3.fromRGB(13, 105, 172)
    Cone.Radius = 0.3
    Cone.SizeRelativeOffset = Vector3.new(0, 0, -4)
    Cone.Height = 1

    return Object
end

-- // Initialization
return function(Infinity)
    AdorneeLibary.Infinity = Infinity
    return AdorneeLibary
end