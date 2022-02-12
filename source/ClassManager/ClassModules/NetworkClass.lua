--[=[
    @About: A Server-Side Networking class offers a multitude of things, Server-Side Networking class is a class which inherits a Client
    @About: Table, this Client table will have content which'll be replicated to each client which joins the experience.
    @About: This class helps to cover up FE, Allowing the client to execute functions, see variables and so on.
    
    @Important: This class requires you to use the `ProxyClass` in order for you to simulate this NetworkClass. [Handled Internally]
]=]--

-- // Variables
local NetworkClass = { Name = "NetworkClass", Type = "NetworkClass" }
NetworkClass.Methods = { }

-- // Class Methods
function NetworkClass.Methods:Fire(EventName, ...)
    self.Event:Fire({ 0; EventName; { ... }; })
end

-- // Methods
function NetworkClass:Finally(Class)
    Class.Connections = nil

    table.freeze(Class.Client)
end

function NetworkClass:Construct(Class)
    function Class.Extended(Class, ClassName)
        Class.Name = ClassName

        table.insert(Class.Infinity.Classes, Class)
        table.insert(Class.Infinity.Events, Class)
        table.insert(Class.Infinity.Public, Class)
        table.insert(Class.Infinity.Network, Class)

        Class.Connections = { }
        Class.Client = setmetatable({ }, {
            __newindex = function(self, Index, Value)
                local ValueType = typeof(Value)

                if ValueType == "nil" then
                    if typeof(self[Index]) == "userdata" then
                        if Value.Name == "Signal" then Class.Connections[Index]:Disconnect() end
                    end
                end

                if ValueType == "userdata" then
                    if Value.Name == "Signal" then
                        Class.Connections[Index] = Value:Connect(function(...)
                            Class.Event:Fire({ 1, Index, { ... } })
                        end)
                    end
                end

                rawset(self, Index, Value)
            end
        })

        Class.Function = Class.Infinity.Net.Function.new(ClassName)
        Class.Event = Class.Infinity.Net.Event.new(ClassName)

        Class.Function:Bind(function(Client, ClientPacket)
            if ClientPacket[1] == 0 then -- client sync
                if self.ClassPacket then return self.ClassPacket end

                self.ClassPacket = { }

                for Index, Value in next, Class.Client do
                    self.ClassPacket[Index] = {
                        type(Value);
                        Value;
                    }

                    if typeof(Value) == "userdata" then
                        self.ClassPacket[Index][2] = Value.Name
                    end
                end

                return self.ClassPacket
			elseif ClientPacket[1] == 1 then -- call function
				if ClientPacket[2] then -- Namecall
                    return { pcall(Class.Client[ClientPacket[3]], Class, Client, table.unpack(ClientPacket[4])) }
				else
					return { pcall(Class.Client[ClientPacket[3]], Client, table.unpack(ClientPacket[4])) }
				end
            else
                return error("Unsupported ClientPacket Type", math.huge)
            end
        end)
    end

    return Class
end

return NetworkClass