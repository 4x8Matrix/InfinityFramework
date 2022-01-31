local TableUtils = { }

function TableUtils:Clone(Source)
    local Result = { }

    for Index, Value in pairs(Source) do
        local valueType = type(Value)

        if valueType == "table" then
            Result[Index] = self:Clone(Value)
        else
            Result[Index] = Value
        end
    end

    return Result
end

function TableUtils:Transform(Source, Transform)
    for Index, Value in pairs(Source) do
        Source[Index] = Transform(Value)
    end
end

function TableUtils:GetKeys(Source)
    local Keys = { }

    for Index in pairs(Source) do
        Keys[#Keys + 1] = Index
    end

    return Keys
end

function TableUtils:GetValues(Source)
    local Values = { }

    for _, Value in pairs(Source) do
        Values[#Values + 1] = Value
    end

    return Values
end

return TableUtils