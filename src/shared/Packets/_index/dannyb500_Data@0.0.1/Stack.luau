local Stack = {}
Stack.__index = Stack

--[[
    @public
    @function new()
    @return Stack<T>
]]
function Stack.new()
    local self = setmetatable({}, Stack)
    self._stack = {} :: {any}
    return self
end

--[[
    @public
    @function Push()
    @param value any
]]
function Stack:Push(value: any)
    table.insert(self._stack, value)
end

--[[
    @public
    @function Pop()
    @return any
]]
function Stack:Pop(): any
    return table.remove(self._stack, #self._stack)
end

--[[
    @public
    @function Peek()
    @return any
]]
function Stack:Peek(): any
    return self._stack[#self._stack]
end

--[[
    @public
    @function IsEmpty()
    @return boolean
]]
function Stack:IsEmpty(): boolean
    return #self._stack == 0
end