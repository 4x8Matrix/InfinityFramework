local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")

local Camera = workspace.CurrentCamera

local FloorVector = Vector3.new(1, 0, 1)
local ZeroVector = Vector3.new()

return function(Infinity)
    -- // Variables
    local VRSingleton = Infinity.PublicClass:Extend("InfinityVR")

    -- // Symbols
    VRSingleton:NewSymbol("Mode.Sit")
    VRSingleton:NewSymbol("Mode.Standing")

    -- // Signals
    VRSingleton:NewSignal("OnUpdate")

    VRSingleton:NewSignal("ButtonPressed")
    VRSingleton:NewSignal("ThumbstickMoved")

    VRSingleton:NewSignal("OnHeadUpdated")
    VRSingleton:NewSignal("OnLeftHandUpdated")
    VRSingleton:NewSignal("OnRightHandUpdated")

    -- // VR Variables
    VRSingleton.Scale = 1
    VRSingleton.Height = 4

    VRSingleton.Enabled = UserInputService.VREnabled

    VRSingleton.Position = Vector3.new()
    VRSingleton.CFrames = { }

    -- // Functions
    function VRSingleton:SetPointerState(State)
        Infinity.CoreGui:SetCore("VRLaserPointerMode", State)
    end

    function VRSingleton:SetControllerState(State)
        Infinity.CoreGui:SetCore("VREnableControllerModels", State)
    end

    function VRSingleton:UpdateCamera()
        Camera.CFrame = CFrame.new()
    end

    function VRSingleton:Recenter()
        VRService:RecenterUserHeadCFrame()
    end

    function VRSingleton:MoveTo(Position)
        self.Position = Position
    end

    function VRSingleton:MoveIn(Direction, RelativeToCamera)
        if RelativeToCamera then
            local CameraLookVector = (Camera.CFrame.LookVector * FloorVector).Unit
            local CameraRelative = CFrame.lookAt(ZeroVector, CameraLookVector)
            local MoveVector = CameraRelative:VectorToObjectSpace(Direction.Unit).Unit * 10

            self.Position = (CFrame.new(MoveVector):ToWorldSpace(CFrame.new(self.Position)))
        else
            self.Position += Direction
        end
    end

    VRSingleton.HeadChanged = UserInputService.UserCFrameChanged:Connect(function(Type, Value)
        local Signal = (Type == Enum.UserCFrame.Head and VRSingleton.OnHeadUpdated) or
                       (Type == Enum.UserCFrame.LeftHand and VRSingleton.OnLeftHandUpdated) or
                       VRSingleton.OnRightHandUpdated

        Camera.CameraType = "Scriptable"
        Camera.HeadScale = VRSingleton.Scale

        VRSingleton.CFrames[Type.Name] = Value
        VRSingleton.OnUpdate:Fire()
        Signal:Fire(Camera.CFrame * Value)
    end)
end