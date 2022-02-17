-- // Services
local SoundService = game:GetService("SoundService")
local SoundEffects = { 
    "PitchShift", "Compressor", "Tremolo", "Flange", "Reverb", "Echo", "Distortion", "Chorus", "Equalizer"
}

return function(Infinity)
    -- // Variables
    local SoundSingleton = Infinity.PublicClass:Extend("InfinitySound")
    local SoundGroup = Infinity.PrivateClass:Extend("SoundGroup")

    SoundSingleton.Group = SoundGroup

    -- // Group Methods
    function SoundGroup:AddSound(SoundObject)
        SoundObject.Parent = self.SoundGroup
    end

    function SoundGroup:RemoveSound(SoundObject)
        SoundObject.Parent = SoundService
    end

    function SoundGroup:OnExtended(Class, GroupName)
        Class.SoundGroup = Infinity.Utils:NewInstance("Sound", { Parent = SoundService; Name = GroupName })

        for _, SoundEffect in ipairs(SoundEffects) do
            Class[SoundEffect] = Infinity.Utils:NewInstance(SoundEffect .. "SoundEffect", { Parent = Class.SoundGroup; Enabled = false; Name = SoundEffect })
        end
    end

    -- // Service Methods
    function SoundSingleton:LoadAssetFromID(Id)
        if not string.find(Id, "/") then
            Id = "rbxassetid://" .. Id
        end

        return Infinity.Utils:NewInstance("Sound", { SoundId = Id })
    end

    function SoundSingleton:RegisterSound(SoundObject)
        return SoundObject:Extend(SoundObject)
    end

    function SoundSingleton:RegisterSounds(Array)
        for _, Sound in ipairs(Array) do
            local SoundObject = Sound

            if type(Sound) == "number" then
                SoundObject = self:LoadAssetFromID(Sound)
            end

            self:RegisterSound(SoundObject)
        end
    end
    
    return SoundSingleton
end