--!strict

local C = {
	B = 8; --// Buffer Size
}

local function Serialize(Vec2: Vector3)
	local b = buffer.create(C.B);
	buffer.writef32(b,0,Vec2.X)
	buffer.writef32(b,4,Vec2.Y)	
	return b
end

local function EditBuffer(b: buffer,k: Vector2)
	buffer.writef32(b,0,k.X)
	buffer.writef32(b,4,k.Y)
	return b
end

local function Deserialize(b: buffer)
	return vector.create(buffer.readf32(b,0),buffer.readf32(b,4))
end

return {
	serialize = Serialize;
	deserialize = Deserialize;
	edit = EditBuffer;
}