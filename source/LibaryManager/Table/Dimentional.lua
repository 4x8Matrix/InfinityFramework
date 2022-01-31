local DimentionalTable = { }

function DimentionalTable:__index(index)
    local object = rawget(self, index)
    local value

    if not object then
        value = setmetatable({ }, DimentionalTable)

        rawset(self, index, value)
    end

    return value
end

function DimentionalTable.new(Source)
    return setmetatable(Source or { }, DimentionalTable)
end

return DimentionalTable