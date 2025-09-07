--!strict
local Vec3 = require("../dannyb500_Serialize@0.0.1/Vec3")
local CFrame = require("../dannyb500_Serialize@0.0.1/CFrame")

local Memory = {}
Memory.__index = Memory

--[[

]]

function Memory.new()
	return setmetatable({},Memory)
end

--[[ SETTERS ]]--

--[[
	@function SetVec3
	@description Adds Value to memory
]]
function Memory:Set(Key,Value)
	self[Key] = Value
end

--[[
	@function SetTable
	@description Adds Value to memory
]]
function Memory:SetTable(TableName, Key, Value)
	if not self[TableName] then
		self[TableName] = {}
	end
	if Key ~= nil then
		self[TableName][Key] = Value
	else
		warn("Attempted to use nil as key in SetTable for " .. TableName)
	end
end

--[[
	@function SetCFrame
	@description Converts Value to a Buffer
]]
function Memory:SetCFrame(Key,Value)
	self[Key] = CFrame.serialize(Value)
end

--[[
	@function SetVec3
	@description Converts Value to a Buffer
]]
function Memory:SetVec3(Key,Value)
	self[Key] = Vec3.serialize(Value)
end

--[[ GETTERS ]]--

function Memory:Get(Key)
	return self[Key]
end

function Memory:GetCFrame(Key)
	return CFrame.deserialize(self[Key])
end

function Memory:GetVec3(Key)
	return Vec3.deserialize(self[Key])
end


--[[ DESTRUCTOR ]]--

function Memory:Remove(Key)
	self[Key] = nil
end

function Memory:Clear()
	table.clear(self)
end

function Memory:Destroy()
	table.clear(self)
	setmetatable(self,nil)
end


return Memory
