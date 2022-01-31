local GuidLibary = { }

function GuidLibary:Hexidecimal(Size)
    local HexValues = { }

    for Index = 1, Size do
        local HexValue = ("%x"):format((Index == Size and math.random(8, 11)) or math.random(0, 15))

        table.insert(HexValues, HexValue)
    end

    return table.concat(HexValues)
end

function GuidLibary:GenerateShort()
    return ("%s-%s"):format(
        self:Hexidecimal(16), self:Hexidecimal(5)
    )
end

function GuidLibary:GenerateLong()
    return ("%s-%s-4%s-%s%s-%s"):format(
        self:Hexidecimal(8), self:Hexidecimal(4),
        self:Hexidecimal(3), self:Hexidecimal(1),
        self:Hexidecimal(3), self:Hexidecimal(12)
    )
end

function GuidLibary.new()
    return GuidLibary:GenerateLong()
end

return GuidLibary