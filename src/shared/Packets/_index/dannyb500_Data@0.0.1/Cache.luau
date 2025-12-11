local CACHE = {};

local MAX_SIZE = 50;

-- Creates a new Object Pool
function CACHE.new(Size: number | nil, Object: Instance)
    local self = setmetatable({}, {__index = CACHE});
    self._maxSize = Size or 50;
    self.Pool = {};

    for i = 1, self._maxSize do
        local NewObject = Object:Clone();
        NewObject.Parent = nil;
        table.insert(self.Pool, NewObject);
    end

    return self
end

-- Destroys the Cache
function CACHE:Destroy()
    for k in pairs(self.Pool) do
        k:Destroy();
    end
    self.Pool = nil;
    setmetatable(self, nil)
end

--// SETTERS


function CACHE:ReturnToPool(Items: {any})
    for _,v in self.Pool do
		v.Parent = nil;
	end
end

--// GETTERS

function CACHE:GetPool(N: number)
    assert(N and type(N) == "number","Invalid size given")
    local Pool = {}
	local Count = 0;
	
	for _,v in self.Pool do
		if v.Parent ~= nil then
			continue
		end
		Count += 1;
		if Count > N then
			break
		end
		v.Parent = workspace
		table.insert(Pool, v)
	end

	return Pool
end



return CACHE;