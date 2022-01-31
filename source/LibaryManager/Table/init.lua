-- // Variables
local TableLibary = { Name = "Table" }

-- // Table-Sub Libaries
TableLibary.Utils = require(script.Utils)
TableLibary.Dimentional = require(script.Dimentional)

-- // Initialize
for Index, Value in next, table do
    TableLibary[Index] = Value
end

return TableLibary