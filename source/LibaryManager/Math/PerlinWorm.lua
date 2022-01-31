local PerlinWorms = { }

function PerlinWorms.new(Size, Seed, Resolution, TargetCFrame)
    local TargetCFrame = TargetCFrame or CFrame.new(math.random(5, 10), math.random(5, 10), math.random(5, 10))
    local Resolution = (Resolution or 4) + .1
    local Seed = Seed or tick()

    local Points = { }

    for _ = 1, Size do
        local X = math.noise(TargetCFrame.X / Resolution, Seed)
        local Y = math.noise(TargetCFrame.Y / Resolution, Seed)
        local Z = math.noise(TargetCFrame.Z / Resolution, Seed)

        TargetCFrame *= CFrame.Angles(X * 2, Y * 2, Z * 2) * CFrame.new(0, 0, -Resolution)

        Points[#Points + 1] = TargetCFrame.Position
    end

    return Points
end

return PerlinWorms