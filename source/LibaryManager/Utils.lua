-- // Variables
local UtilsLibary = { Name = "Utils" }

-- // Methods
function UtilsLibary:InheritProperties(BaseObject, BaseProperties)
    for Index, Value in next, BaseProperties do
        BaseObject[Index] = Value
    end

    return BaseObject
end

function UtilsLibary:CloneInstance(BaseObject, BaseProperties, BaseChildren)
	local BaseProperties = BaseProperties or { }
	local BaseChildren = BaseChildren or { }
	
	local Object = self:InheritProperties(BaseObject:Clone(), BaseProperties)
	
	for _, ChildObject in ipairs(BaseChildren) do
		ChildObject.Parent = Object
	end
	
	return Object
end

function UtilsLibary:NewInstance(ObjectClass, BaseProperties, BaseChildren)
	local BaseProperties = BaseProperties or { }
	local BaseChildren = BaseChildren or { }
	
	local Object = self:InheritProperties(Instance.new(ObjectClass), BaseProperties)
	
	for _, ChildObject in ipairs(BaseChildren) do
		ChildObject.Parent = Object
	end
	
	return Object
end

function UtilsLibary:WaitForChildOfType(Object, Class)
    local ChildObject = Object:FindFirstChildOfClass(Class)
    
    while true do
        if ChildObject then return ChildObject end

        task.wait()
        ChildObject = Object:FindFirstChildOfClass(Class)
    end
end

function UtilsLibary:WaitForChildExtended(Parent, ObjectPath)
    local ObjectPathSplit = ObjectPath:split(".")
    local Object = Parent

    for Index = 1, #ObjectPathSplit do
        Object = Object:WaitForChild(ObjectPathSplit[Index])
    end

    return Object
end

return UtilsLibary