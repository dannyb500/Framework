local T = {}
T.__index = T

local Destructors = {
	["function"] = "function";
	["thread"] = "thread";
	
	["Instance"] = "Destroy";
	["RBXScriptConnection"] = "Disconnect";
		
}

local function GetDestructor(Class: any)
	local t = typeof(Class)
	if t == "thread" then
		return Destructors["thread"]
	elseif t == "function" then
		return Destructors["function"]
	elseif Destructors[t] then
		return Destructors[t]
	else
		error(`could not find destructor for {t} {Class}`,4)
	end
end

function T.new()
	local self = setmetatable(
		{
			Tasks = {}
		}
		,T)
	return self
end

function T:Connect(C: RBXScriptConnection,Fnc:(any) -> ())
	local Connection = C:Connect(Fnc)
	table.insert(self.Tasks,{C,"Disconnect"})
	return Connection
end

function T:AddTask(Fnc: () -> ())
	local Destructor = GetDestructor(Fnc)
	table.insert(self.Tasks,{Fnc,Destructor})
end

function T:Cleanup()
	for _,Task in self.Tasks do
		local Fnc = Task[1]
		local D = Task[2]
		if D == Destructors["function"] then
			Fnc()
		elseif D == Destructors["thread"] then
			coroutine.close(Fnc)
		else
			Fnc[D](Fnc)
		end
	end
	table.clear(self.Tasks)
end		

function T:Destroy()
	self:Cleanup()
end
   
return T