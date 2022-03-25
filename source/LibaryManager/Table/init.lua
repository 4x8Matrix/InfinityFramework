-- // Variables
local TableLibary = { Name = "Table" }

-- // Table-Sub Libaries
TableLibary.Dimentional = require(script.Dimentional)

-- // Initialize
for Index, Value in next, table do
    TableLibary[Index] = Value
end

function TableLibary.Clone(Source)
    local Result = { }

    for Index, Value in pairs(Source) do
        local valueType = type(Value)

        if valueType == "table" then
            Result[Index] = TableLibary.Clone(Value)
        else
            Result[Index] = Value
        end
    end

    return Result
end

function TableLibary.Transform(Source, Transform)
    for Index, Value in pairs(Source) do
        Source[Index] = Transform(Value)
    end

    return Source
end

function TableLibary.GetKeys(Source)
    local Keys = { }

    for Index in pairs(Source) do
        Keys[#Keys + 1] = Index
    end

    return Keys
end

function TableLibary.GetValues(Source)
    local Values = { }

    for _, Value in pairs(Source) do
        Values[#Values + 1] = Value
    end

    return Values
end

function TableLibary.Merge(Table0, Table1)
    for Index, Value in pairs(Table1) do
        Table0[Index] = Value
    end

    return Table0
end

function TableLibary.Fill(TblA, TblB)
    for Index, Object in pairs(TblB) do
        if TblA[Index] then
            if type(TblA[Index]) == "table" then
                TableLibary.Fill(TblA[Index], Object)
            end
        else
            TblA[Index] = Object
        end
    end

    return TblA
end

return TableLibary