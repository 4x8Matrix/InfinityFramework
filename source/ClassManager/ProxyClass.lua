--[=[
    @About: This is the NetworkingClass for the Client, This class will be used as a proxy for each NetworkClass which exists on the server.
    @About: These classes will only appear after you've initialized the Infinity Framework.
]=]--

-- // Variables
local ProxyClass = { Name = "ProxyClass", Type = "ProxyClass" }
ProxyClass.Methods = { }
ProxyClass.Generics = { "number", "boolean", "nil", "string", "table" }

-- // Class Methods

-- // Methods
function ProxyClass:Construct(Class)
    function Class.Extended(Class, ClassName)
        Class.Infinity.Classes[#Class.Infinity.Classes + 1] = Class

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
                    Class[Index] = function(...)
                        local Args = { ... }
                        local IsNamecall = select(1, ...) == Class
                        if IsNamecall then table.remove(Args, 1) end

                        local Promise = Class.Function:Invoke({ 1; IsNamecall; Index; Args })

                        Promise:Catch(function(Exception)
                            warn("Exception During Class-Sync:", Exception)
							task.wait(.5)

                            Promise:Retry()
                        end)

                        repeat task.wait() until Promise.Status == Class.Infinity.Promise.Resolved
                        return Promise:GetResult()
                    end
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
        end)

        Promise:Catch(function(Exception)
            warn("Exception During Class-Sync:", Exception)
            task.wait(.5)

            Promise:Retry()
        end)

        repeat task.wait() until Promise.Status == Class.Infinity.Promise.Resolved
    end

    return Class
end

return ProxyClass