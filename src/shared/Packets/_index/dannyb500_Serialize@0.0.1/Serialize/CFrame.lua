--!strict

local C = {
	B_S = 18; --// Buffer Size
	CF_BS = 48; -- // CFRAME buffer size
	R_O = 100 --// Deserialized orientation
}

local function Serialize(CF: CFrame)
	local pos,x,y,z = CF.Position,CF:ToOrientation()
	local b = buffer.create(C.B_S);
	
	buffer.writef32(b,0,pos.X)
	buffer.writef32(b,4,pos.Y)
	buffer.writef32(b,8,pos.Z)
	
	buffer.writei16(b,12,math.round(x * 100))
	buffer.writei16(b,14,math.round(y * 100))
	buffer.writei16(b,16,math.round(z * 100))
	
	return b
end

local function Deserialize(b: buffer)
	local pos,orientation
	local x = buffer.readf32(b,0)
	local y = buffer.readf32(b,4)
	local z = buffer.readf32(b,8)
	local ox = buffer.readi16(b,12) / 100
	local oy = buffer.readi16(b,14) / 100
	local oz = buffer.readi16(b,16) / 100
	pos = Vector3.new(x,y,z)
	return CFrame.new(pos) * CFrame.Angles(ox,oy,oz)
end

local function SerializeCF(CF:CFrame)
	local b = buffer.create(C.CF_BS)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = CF:GetComponents()
	buffer.writef32(b, 0, x)
	buffer.writef32(b, 4, y)
	buffer.writef32(b, 8, z)
	buffer.writef32(b, 12, R00)
	buffer.writef32(b, 16, R01)
	buffer.writef32(b, 20, R02)
	buffer.writef32(b, 24, R10)
	buffer.writef32(b, 28, R11)
	buffer.writef32(b, 32, R12)
	buffer.writef32(b, 36, R20)
	buffer.writef32(b, 40, R21)
	buffer.writef32(b, 44, R22)
	return b
end

local function DeserializeCF(b)
	local x = buffer.readf32(b, 0)
	local y = buffer.readf32(b, 4)
	local z = buffer.readf32(b, 8)
	local R00 = buffer.readf32(b, 12)
	local R01 = buffer.readf32(b, 16)
	local R02 = buffer.readf32(b, 20)
	local R10 = buffer.readf32(b, 24)
	local R11 = buffer.readf32(b, 28)
	local R12 = buffer.readf32(b, 32)
	local R20 = buffer.readf32(b, 36)
	local R21 = buffer.readf32(b, 40)
	local R22 = buffer.readf32(b, 44)
	return CFrame.new(x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function EditCF(b: buffer, k: CFrame)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = k:GetComponents()
	buffer.writef32(b, 0, x)
	buffer.writef32(b, 4, y)
	buffer.writef32(b, 8, z)
	buffer.writef32(b, 12, R00)
	buffer.writef32(b, 16, R01)
	buffer.writef32(b, 20, R02)
	buffer.writef32(b, 24, R10)
	buffer.writef32(b, 28, R11)
	buffer.writef32(b, 32, R12)
	buffer.writef32(b, 36, R20)
	buffer.writef32(b, 40, R21)
	buffer.writef32(b, 44, R22)
	return b
end

local function EditBufferCF(b: buffer,k: CFrame)
	local pos,x,y,z = k.Position,k:ToOrientation()
	buffer.writef32(b,0,pos.X)
	buffer.writef32(b,4,pos.Y)
	buffer.writef32(b,8,pos.Z)

	buffer.writei16(b,12,math.round(x * 100))
	buffer.writei16(b,14,math.round(y * 100))
	buffer.writei16(b,16,math.round(z * 100))
	return b
end

return {
	serialize = Serialize;
	deserialize = Deserialize;
	
	serializecf = SerializeCF;
	deserializecf = DeserializeCF;
	edit = EditBufferCF;
	editcf = EditCF;
}