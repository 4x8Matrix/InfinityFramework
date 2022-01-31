-- // Variables
local MathLibary = { Name = "Math" }

-- // Table-Sub Libaries
MathLibary.Worm = require(script.PerlinWorm)
MathLibary.Guid = require(script.Guid)

-- // Initialize
for Index, Value in next, math do
    MathLibary[Index] = Value
end

function MathLibary:VectorGrid(Vector, GridSize)
    return Vector3.new(
        math.round(Vector.X / GridSize) * GridSize,
        math.round(Vector.Y / GridSize) * GridSize,
        math.round(Vector.Z / GridSize) * GridSize
    )
end

return MathLibary