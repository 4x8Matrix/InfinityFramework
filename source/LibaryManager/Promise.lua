-- // Variables
local PromiseLibary = { Name = "Promise" }
local PromiseObject = { Name = "Promise" } PromiseObject.__index = PromiseObject

PromiseLibary.Rejected = newproxy()
PromiseLibary.Resolved = newproxy()

-- // Promise Methods
function PromiseObject:GetResult()
	return (self.HasResult and table.unpack(self.Result)) or self.Result
end

function PromiseObject:Finally(Method)
    if self.Status and self.Status == PromiseLibary.Resolved then
        task.spawn(Method, self:GetResult())
    end

    self.Internal.Finally = Method

    return self
end

function PromiseObject:Catch(Method)
    if self.Status and self.Status == PromiseLibary.Rejected then
        task.spawn(Method, self, self:GetResult())
    end

    self.Internal.Catch = Method

    return self
end

function PromiseObject:Then(Method)
    if self.Status and self.Status == PromiseLibary.Resolved then
        task.spawn(Method, self:GetResult())
    end

    self.Internal.Then[#self.Internal.Then + 1] = Method

    return self
end

function PromiseObject:Retry()
    self.Status = nil

    self.Internal.Thread = coroutine.create(self.Internal.Routine)
    self.Success, self.Internal.Result = coroutine.resume(self.Internal.Thread, self, table.unpack(self.Internal.Args))

    if not self.HasResult then
        PromiseLibary.Result = self.Internal.Result

        self.Internal.Result = nil
    end

    if not self.Success then
        error(("Promise Thread Failed: %s\n%s"):format(debug.info(self.Internal.__, "n"), debug.info(self.Internal.Thread)), math.huge)
    end
end

function PromiseObject:Cancel()
    self.Cancelled = true
end

function PromiseObject:Await()
    if self.Status then
        return self.Status == PromiseLibary.Resolved, self:GetResult()
	else
		self.Internal.Await[#self.Internal.Await + 1] = coroutine.running()
		
        return coroutine.yield()
    end
end

function PromiseObject:AwaitSuccess()
    if self.Status == PromiseLibary.Resolved then
        return self:GetResult()
	else
		self.Internal.Await[#self.Internal.Await + 1] = coroutine.running()

        local Success, Result = coroutine.yield()

        if Success then
            return Result
        else
            task.wait(.5)

            return self:AwaitSuccess()
        end
    end
end

function PromiseObject:Resolve(...)
    if self.Status then return end
    self.Status = PromiseLibary.Resolved

	if select("#", ...) > 0 then self.HasResult = true self.Result = { ... } end

    for _, Method in ipairs(self.Internal.Then) do
        task.spawn(Method, ...)

        if self.Cancelled then
            self.Cancelled = nil

            break
        end
    end

    for _, Routine in ipairs(self.Internal.Await) do
        local Success, Result = coroutine.resume(Routine, true, ...)

        if not Success then
            return error(Result, math.huge)
        end
    end

    if self.Internal.Finally then
        task.spawn(self.Internal.Finally, ...)
    end

    self.Internal.Await = { }
end

function PromiseObject:Reject(...)
    if self.Status then return end
    self.Status = PromiseLibary.Rejected

    if select("#", ...) > 0 then self.HasResult = true self.Result = { ... } end

    for _, Routine in ipairs(self.Internal.Await) do
        local Success, Result = coroutine.resume(Routine, false, ...)

        if not Success then
            return error(Result, math.huge)
        end
    end

    self.Internal.Await = { }
    if self.Internal.Catch then
        task.spawn(self.Internal.Catch, self, ...)
    else
        warn(("Unhandled Promise Rejection: %s\n%s"):format(self:GetResult() or "???", debug.traceback(self.Internal.Thread)))
    end
end

-- // Libary Methods
function PromiseLibary.new(Routine, ...)
    local PromiseObject = setmetatable({ }, PromiseObject)

    PromiseObject.Internal = { Thread = coroutine.create(Routine); Routine = Routine; Await = {  }; Then = {  }; Args = { ... } }
    PromiseObject.Success, PromiseObject.Internal.Result = coroutine.resume(PromiseObject.Internal.Thread, PromiseObject, ...)

    if not PromiseObject.Success then
		error(("Promise Thread Failed: %s"):format(PromiseObject.Internal.Result), math.huge)
    end

    if not PromiseObject.HasResult then
        PromiseLibary.Result = PromiseObject.Internal.Result

        PromiseObject.Internal.Result = nil
    end

    return PromiseLibary.Infinity.Proxy:FromTable(PromiseObject)
end

function PromiseLibary:Wrap(Method, ...)
    return self.new(function(Promise, ...)
        local Results = table.pack(pcall(Method, ...))
        local Success = table.remove(Results, 1)

        return Success and Promise:Resolve(table.unpack(Results)) or Promise:Reject(table.unpack(Results))
    end, ...)
end

function PromiseLibary:IsPromise(Object)
    return getmetatable(Object) == PromiseObject
end

function PromiseLibary:UntilSettled(Objects)
    for _, Value in ipairs(Objects) do Value:Await() end
end

function PromiseLibary:Any(Objects)
    while true do
        for _, Promise in ipairs(Objects) do
           if Promise.Status then
               return Promise
           end
        end

        task.wait()
    end
end

function PromiseLibary:Race(Objects)
    while true do
        for _, Promise in ipairs(Objects) do
           if Promise.Status == PromiseLibary.Resolved then
               return Promise
           end
        end

        task.wait()
    end
end

-- // Initialization
return function(Infinity)
    PromiseLibary.Infinity = Infinity
    return PromiseLibary
end