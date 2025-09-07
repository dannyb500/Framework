--!strict

local C = {
	B = 12; --// Buffer Size
}

local function Serialize(Vec3: Vector3)
	local b = buffer.create(C.B);
	buffer.writef32(b,0,Vec3.X)
	buffer.writef32(b,4,Vec3.Y)
	buffer.writef32(b,8,Vec3.Z)
	return b
end

local function EditBuffer(b: buffer,k: Vector3)
	buffer.writef32(b,0,k.X)
	buffer.writef32(b,4,k.Y)
	buffer.writef32(b,8,k.Z)
	return b
end

local function Deserialize(b: buffer)
	return vector.create(buffer.readf32(b,0),buffer.readf32(b,4),buffer.readf32(b,8))
end

return {
	serialize = Serialize;
	deserialize = Deserialize;
	edit = EditBuffer;
}