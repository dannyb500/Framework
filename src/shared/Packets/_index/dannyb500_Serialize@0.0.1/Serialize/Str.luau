--!strict

local function Serialize(Str: string)
	local b = buffer.create(#Str);
	buffer.writestring(b,0,Str)
	return b
end

local function EditBuffer(b: buffer,k: string)
	buffer.writestring(b,0,k)
	return b
end

local function Deserialize(b: buffer,s: number)
	return buffer.readstring(b,0,s)
end

return {
	serialize = Serialize;
	deserialize = Deserialize;
	edit = EditBuffer;
}