-- // Services
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")

return function(Infinity)
    -- // Variables
    local CoreSingleton = Infinity.PublicClass:Extend("InfinityCoreGui")

    -- // Variables
    CoreSingleton:NewSignal("OnSetCore")

    -- // Methods
    function CoreSingleton:IsConsoleOpen() return self:GetCore("DeveloperConsoleVisible") end

    function CoreSingleton:IsMenuOpen() return GuiService.MenuIsOpen end
    function CoreSingleton:IsEmoteMenuOpen() return GuiService:GetEmotesMenuOpen() end
    function CoreSingleton:IsInspectMenuOpen() return GuiService:GetInspectMenuEnabled() end

    function CoreSingleton:GetCore(...)
        return Infinity.Promise:Race({ 
            Infinity.Promise.new(function(Promise, ...)
                local Success, Result = pcall(StarterGui.GetCore, StarterGui, "DeveloperConsoleVisible")

                return (Success and Promise:Resolve(Result)) or Promise:Reject(Result)
            end, ...):Catch(function(Promise, Exception)
                warn("Infinity // SetCore: " .. Exception)
                task.wait(.5)

                Promise:Retry()
            end)
        }):GetResult()
    end

    function CoreSingleton:SetCore(...)
        return Infinity.Promise:Race({ 
            Infinity.Promise.new(function(Promise, ...)
                local Success, Result = pcall(StarterGui.SetCore, StarterGui, ...)

                return (Success and Promise:Resolve(Result)) or Promise:Reject(Result)
            end, ...):Catch(function(Promise, Exception)
                warn("Infinity // SetCore: " .. Exception)
                task.wait(.5)
                
                Promise:Retry()
            end)
        }):GetResult()
    end

    return CoreSingleton
end