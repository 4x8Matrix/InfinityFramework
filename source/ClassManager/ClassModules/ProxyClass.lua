--[=[
    @About: This is the NetworkingClass for the Client, This class will be used as a proxy for each NetworkClass which exists on the server.
    @About: These classes will only appear after you've initialized the Infinity Framework.
]=]--

-- // Variables
local ProxyClass = { Name = "ProxyClass", Type = "ProxyClass" }
ProxyClass.Methods = { }
ProxyClass.Generics = { "number", "boolean", "nil", "string", "table" }

-- // Class Methods
function ProxyClass:InitFunction(Class, FuncName)
    Class[FuncName] = function(...)
        local Args = { ... }
        local IsNamecall = select(1, ...) == Class
        if IsNamecall then table.remove(Args, 1) end

        local Promise = Class.Function:Invoke({ 1; IsNamecall; FuncName; Args }):Catch(function(Promise, Exception)
            warn("Infinity // Critical // Proxy-Class Function Call:", Exception)
            task.wait(.5)

            Promise:Retry()
        end)

        Class.Infinity.Promise:Race({ Promise })

        local Results = Promise:GetResult()
        local Success = table.remove(Results, 1)

        if Success then
            return table.unpack(Results)
        else
            warn("Infinity // Error // Server-Proxy Function Call:", Results[2])
        end
    end
end

-- // Methods
function ProxyClass:Construct(Class)
    function Class.Extended(Class, ClassName)
        table.insert(Class.Infinity.Public, Class)
        table.insert(Class.Infinity.Classes, Class)
        table.insert(Class.Infinity.Events, Class)

        Class.Name = ClassName

        Class.Function = Class.Infinity.Net.Function.new(ClassName)
        Class.Event = Class.Infinity.Net.Event.new(ClassName)

        Class.Event:Connect(function(ServerPacket)
            if ServerPacket[1] == 0 then -- server event
                if Class[ServerPacket[2]] then
                    Class[ServerPacket[2]](table.unpack(ServerPacket[3]))
                end
            elseif ServerPacket[1] == 1 then -- server signal
                Class[ServerPacket[2]]:Fire(table.unpack(ServerPacket[3]))
            end
        end)

        local Promise = Class.Function:Invoke({ 0 }):Then(function(ClassData)
            for Index, Value in next, ClassData do
                local ValueType = Value[1]
                local Value = Value[2]

                if table.find(ProxyClass.Generics, ValueType) then
                    Class[Index] = Value
                elseif ValueType == "function" then
                    ProxyClass:InitFunction(Class, Index)
                elseif ValueType == "userdata" then
                    if Value == "Signal" then
                        Class[Index] = Class.Infinity.Signal.new()
                    else
                        warn(("UnknownUserdataException: ProxyClass Unknown Userdata: '%s'"):format(Value))
                    end
                else
                    error(("UnknownTypeException: ProxyClass Unknown Type: '%s'"):format(ValueType))
                end
            end
        end):Catch(function(Promise, Exception)
            warn("Exception During Class-Sync:", Exception)
            task.wait(.5)

            Promise:Retry()
        end)

        Class.Infinity.Promise:Race({ Promise })
    end

    return Class
end

return ProxyClass