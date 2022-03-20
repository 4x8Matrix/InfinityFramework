-- // Variables
local FileSystem = { Name = "FileSystem" }

-- // Methods
function FileSystem:Require(Module, ...)
    local Module = require(Module)
    local ModuleType = type(Module)

    if ModuleType == "function" then
        Module(FileSystem.Infinity, ...)
    end
end

function FileSystem:LoadTable(Table, ...)
    for _, Object in ipairs(Table) do
        if Object.ClassName == "ModuleScript" then
            task.spawn(self.Require, self, Object, ...)
        end
    end
end

function FileSystem:LoadModules(Parent, ...)
    local Children = Parent:GetChildren()

    self:LoadTable(Children, ...)
end

return function(Infinity)
    FileSystem.Infinity = Infinity

    return FileSystem
end