-- // Services
local StudioService = game:GetService("StudioService")
local PlayersService = game:GetService("Players")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

-- // Variables
local PluginLibary = { Name = "Plugin" }

-- // Properties
PluginLibary.Closing = false
PluginLibary.Closed = false

-- // Events
PluginLibary.StudioModeChanged = UserGameSettings.StudioModeChanged
PluginLibary.FullscreenChanged = UserGameSettings.FullscreenChanged

-- // Toolbar Methods
function PluginLibary:IsToolbar(ToolbarName)
	return self:GetToolbar(ToolbarName) ~= nil
end

function PluginLibary:CreateToolbar(ToolbarName)
    assert(self.Initialized == true, "PluginLibary Initialization Required; Please call :Init on the Plugin Libary")

	local ToolbarObject = self.Plugin:CreateToolbar(ToolbarName)
	local ToolbarReference = Instance.new("ObjectValue")

	ToolbarReference.Name = ToolbarName
	ToolbarReference.Value = ToolbarObject
	ToolbarReference.Parent = StudioService

	return ToolbarObject
end

function PluginLibary:RemoveToolbar(ToolbarName)
    local ToolbarReference = StudioService:FindFirstChild(ToolbarName)

    if ToolbarReference then
        ToolbarReference.Value:Destroy()
        ToolbarReference:Destroy()
    end
end

function PluginLibary:GetToolbar(ToolbarName)
	local ToolbarReference = StudioService:FindFirstChild(ToolbarName)

	return ToolbarReference and ToolbarReference.Value
end

-- // Selection Methods
function PluginLibary:GetSelection() return Selection:Get() end
function PluginLibary:SetSelection(Objects) return Selection:Set(Objects) end
function PluginLibary:Select(Object) return Selection:Set({ Object }) end
function PluginLibary:IsSelected(Object) return table.find(Selection:Get(), Object) ~= nil end
function PluginLibary:Unselect() return Selection:Set({ }) end

-- // Studio Methods
function PluginLibary:InStudioMode() return UserGameSettings:InStudioMode() end
function PluginLibary:IsFullScreen() return UserGameSettings.Fullscreen end

function PluginLibary:PromptImportFile(...) return StudioService:PromptImportFile(...) end
function PluginLibary:PromptImportFiles(...) return StudioService:PromptImportFiles(...) end
function PluginLibary:GetClassIconData(...) return StudioService:GetClassIcon(...) end

function PluginLibary:IsTeamCreateSession(...) return PlayersService.LocalPlayer ~= nil end

function PluginLibary:GetActivePlayers() return PlayersService:GetChildren() end
function PluginLibary:GetLocalUserId() return StudioService:GetUserId() end

function PluginLibary:CreateHistoryFunction(HistoryName, Function, ...)
	return function(...)
		local Results
		
		ChangeHistoryService:SetWaypoint(HistoryName)
		Results = table.pack(Function(...))
		ChangeHistoryService:SetWaypoint(HistoryName)
		
		return table.unpack(Results)
	end
end

-- // Initiation
function PluginLibary:Init()
    PluginLibary.PluginMaid = self.Infinity.Maid.new()
    PluginLibary.Environment = getfenv(2)

    assert(PluginLibary.Environment.plugin ~= nil, "Expected `plugin`, found void.")

    PluginLibary.Locale = StudioService.StudioLocaleId

    PluginLibary.Plugin = PluginLibary.Environment["plugin"]
    PluginLibary.PluginMaid:Register(PluginLibary.Plugin.Unloading:Connect(function()
        PluginLibary.Closing = true
    end))

    PluginLibary.PluginMaid:Register(PluginLibary.Plugin.Deactivation:Connect(function()
        PluginLibary.Closed = true

        PluginLibary.PluginMaid:Clean()
    end))

    self.Initialized = false
end

-- // Initialization
return function(Infinity)
    PluginLibary.Infinity = PluginLibary

    return Infinity.IsPlugin and PluginLibary
end