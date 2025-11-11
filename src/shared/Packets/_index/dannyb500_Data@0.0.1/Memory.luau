--!strict
local Serialize = require("../dannyb500_Serialize@0.0.1/Serialize")
local CFrame = Serialize.CFrame
local Vec3 = Serialize.Vec3

local Memory = {}
Memory.__index = Memory

--[[

]]

function Memory.new()
	return setmetatable({Cache = {}},Memory)
end

--[[ SETTERS ]]--

--[[
	@function Set
	@description Adds Value to memory
]]
function Memory:Set(Key,Value)
	self.Cache[Key] = Value
end

--[[
	@function Insert
	@description Inserts Value to memory with a number as index
]]
function Memory:Insert(Value)
	table.insert(self.Cache,Value);
end

--[[
	@function SetTable
	@description Adds Value to memory
]]
function Memory:SetTable(TableName, Key, Value)
	if not self.Cache[TableName] then
		self.Cache[TableName] = {}
	end
	if Key ~= nil then
		self.Cache[TableName][Key] = Value
	else
		warn("Attempted to use nil as key in SetTable for " .. TableName)
	end
end

--[[
	@function SetCFrame
	@description Converts Value to a Buffer
]]
function Memory:SetCFrame(Key,Value)
	self.Cache[Key] = CFrame.serialize(Value)
end

--[[
	@function SetVec3
	@description Converts Value to a Buffer
]]
function Memory:SetVec3(Key,Value)
	self.Cache[Key] = Vec3.serialize(Value)
end

--[[ GETTERS ]]--

--[[
if Key is NULL it will return Cache
]]
function Memory:Get(Key)
	if self.Cache[Key] then
		return self.Cache[Key]
	else
		return self.Cache
	end
end

function Memory:GetCFrame(Key)
	return CFrame.deserialize(self.Cache[Key])
end

function Memory:GetVec3(Key)
	return Vec3.deserialize(self.Cache[Key])
end


--[[ DESTRUCTOR ]]--

function Memory:Remove(Key)
	self.Cache[Key] = nil
end

function Memory:Clear()
	table.clear(self.Cache)
end

function Memory:Destroy()
	self:Clear()
	setmetatable(self,nil)
end


return Memory
