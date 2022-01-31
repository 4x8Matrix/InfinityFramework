-- // Variables
local LibaryManager = { }

LibaryManager.Children = script:GetChildren()

LibaryManager.Libaries = { }
LibaryManager.Compile = { }

-- // Methods
function LibaryManager:Export(Base)
    for _, Value in ipairs(self.Libaries) do Base[Value.Name] = Value end
    for Index, Value in ipairs(self.Compile) do
        local CompiledModule = Value(Base, Index)

        Base[CompiledModule.Name] = CompiledModule
    end
end

-- // Initialization
function LibaryManager:Initialize()
    for _, Value in ipairs(self.Children) do
        if Value.ClassName ~= "ModuleScript" then return warn(("Invalid Lib-Module: Expected ModuleScript, Got %s [%s]"):format(Value.ClassName, Value:GetFullName())) end

        local Module = require(Value)

        if type(Module) == "function" then
            self.Compile[#self.Compile + 1] = Module
        else
            self.Libaries[#self.Libaries + 1] = Module
        end
    end

    return LibaryManager
end

return LibaryManager:Initialize()