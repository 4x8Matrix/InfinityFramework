-- // Variables
local IterLibary = { Name = "Iter" }
local IterObject = { Name = "Iter" } 

IterObject.__index = IterObject
IterObject.__call = function(self, ...)
    return self:Next(...)
end

-- // Iter Methods
function IterObject:Reset() self.Index = 0 self.Key = nil end

function IterObject:GetKey() return self.Key end
function IterObject:GetIndex() return self.Index end
function IterObject:GetValue() return self.Value end

function IterObject:Next()
    if self.Type == 0 then
        self.Key, self.Value = next(self.Object, self.Key)
    else
        if not self.PageHasInit then
            self.PageData = self.Object:GetCurrentPage()
            self.PageHasInit = true
        end

        if self.PageData and self.PageData[self.Index] then
            self.Key, self.Value = next(self.PageData, self.Key)
        else
            if self.Object.IsFinished then return end

            self.Object:AdvanceToNextPageAsync()
            self.PageData = self.Object:GetCurrentPage()

            self.Index = 0
        end
    end

    self.Index += 1
    return self.Key
end

-- // Libary Methods
function IterLibary.new(Object)
    local self = setmetatable({ }, IterObject)

    self.Object = Object
    self.Typeof = typeof(Object)
    self.Type = (self.Typeof == "table" and 0) or 1
    self.Index = 0

    if self.Type == 0 then
        self.Object = IterLibary.Infinity.Table.Utils:Clone(self.Object)
    end

    return IterLibary.Infinity.Proxy:FromTable(self)
end

-- // Initialization
return function(Infinity)
    IterLibary.Infinity = Infinity
    return IterLibary
end