-- // Variables
local LibaryManager = { }

LibaryManager.Children = script:GetChildren()

LibaryManager.Libaries0 = { }
LibaryManager.Libaries1 = { }

-- // Methods
function LibaryManager:DeployLibaries()
    for _, Value in ipairs(self.Libaries0) do self.Infinity[Value.Name] = Value end
    for _, Value in ipairs(self.Libaries1) do
        local CompiledModule = Value(self.Infinity)

        if CompiledModule then
            self.Infinity[CompiledModule.Name] = CompiledModule
        end
    end
end

-- // Initialization
function LibaryManager:Init(Infinity)
    self.Infinity = Infinity

    for _, Value in ipairs(self.Children) do
        if Value.ClassName ~= "ModuleScript" then return warn(("Invalid Lib-Module: Expected ModuleScript, Got %s [%s]"):format(Value.ClassName, Value:GetFullName())) end

        local Module = require(Value)

        if type(Module) == "function" then
            table.insert(self.Libaries1, Module)
        else
            table.insert(self.Libaries0, Module)
        end
    end

    return LibaryManager
end

return LibaryManager