-- // Variables
local IK = { Fabrik = { }; Name = "IK"; }

-- // Functions
-- @Credit: Mike_DFT [Discord: 294158972439756800] In short, a good programmer with very little credit. <3
function IK.Fabrik:Solve(Origin, Target, Objects, Iterations, Margin)
    local ArraySize = #Objects
    local Points = { }

    Iterations = Iterations or 30
    Margin = Margin or .05

	table.insert(Points, Origin)
    for Index = 1, ArraySize do
        local EndPosition = (Objects[Index].CFrame * CFrame.new(0, 0, -(Objects[Index].Size.Z / 2))).Position

		table.insert(Points, EndPosition)
    end

    for _ = 1, Iterations do
		if (Points[ArraySize + 1] - Target).Magnitude <= Margin then
            return Points, true
        end

        -- Reverse
        Points[ArraySize + 1] = Target
        for Iteration = ArraySize, 1, -1 do
            Points[Iteration] = Points[Iteration + 1] + (Points[Iteration] - Points[Iteration + 1]).Unit * Objects[Iteration].Size.Z
        end

        -- Foward
        Points[1] = Origin
        for Iteration = 2, ArraySize + 1 do
            Points[Iteration] = Points[Iteration - 1] + (Points[Iteration] - Points[Iteration - 1]).Unit * Objects[Iteration - 1].Size.Z
        end
    end

    return Points, false
end

return IK