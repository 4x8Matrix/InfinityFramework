local function ConcatString(...)
    local Result = ""

    for _, Object in ipairs({ ... }) do
        Result ..= " " .. tostring(Object)
    end

    return Result
end

return function(Infinity)
    -- // Variables
    local ConsoleSingleton = Infinity.PublicClass:Extend("InfinityConsole")
    ConsoleSingleton.IOCache = { }
    local IOMap = {
        -- Method : Function : Args : Format

        { "Log", print, { }, "Infinity // %s: %s" }; -- Level 1
        { "Warn", warn, { }, "Infinity // %s: %s" }; -- Level 2
        { "Error", error, { }, "Infinity // %s: %s" }; -- Level 3
        { "Critical", error, { math.huge }, "Infinity // %s: %s" }; -- Level 4
    }

    function ConsoleSingleton:GetCache(MaxLogs)
        if MaxLogs > #ConsoleSingleton.IOCache then MaxLogs = #ConsoleSingleton.IOCache end

        local Logs = { }

        for Index, _ in ipairs(self.IOCache) do
            if Index > MaxLogs then return Logs end

            table.insert(Logs, self.IOCache[#self.IOCache - (Index - 1)])
        end

        return Logs
    end

    -- // Methods
    for _, IOMapData in ipairs(IOMap) do
        ConsoleSingleton[IOMapData[1]] = function(self, ...)
            table.insert(self.IOCache, {
                Timestamp = os.date();
                Type = IOMapData[1];

                Message = string.format(
                    IOMapData[4],
                    debug.info(2, "s"),
                    ConcatString(...)
                );
            })

            return IOMapData[2](
                string.format(
                    IOMapData[4],
                    debug.info(2, "s"),
                    ConcatString(...)
                ),
                table.unpack(IOMapData[3])
            )
        end
    end
end