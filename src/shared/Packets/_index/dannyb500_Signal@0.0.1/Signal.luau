--!strict

local Signal = {}
Signal.__index = Signal

--[[
	@public
	@function new()
	@return Signal<T...>
]]
function Signal.new()
	local self = setmetatable({}, Signal)
	self.Callback = {} :: {(...any) -> ()}
	self.Disconnect = function()
		for i,_ in self.Callback do
			table.remove(self.Callback,i)
		end
	end
	self.DisconnectOne = function(Callback: () -> ())
		for i,fnc in self.Callback do
			if fnc ~= Callback then
				continue
			end
			table.remove(self.Callback,i)
			break
		end
	end
	return self
end


--[[
	@public
	@function Connect()
	
	Signal.new():Connect(function()
		
	local signal = Signal.new()
	signal.Connect(function()
	
]]
function Signal:Connect(Callback: () -> ())
	table.insert(self.Callback,Callback)
end


--[[
	@public
	@function Fire()
	
	Fires all functions
]]
function Signal:Fire(...: (any) -> ())
	for _,fnc in self.Callback do
		fnc(...)
	end
end

--[[
	@public
	@function Once()
	Connects a function that disconnects after being fired once
]]
function Signal:Once(Callback: () -> ())
	self:Connect(function(...)
		Callback(...)
		self.Disconnect()
	end)
end

--[[
	@public
	@function Destroy()
	
	Destroys the signal
]]
function Signal:Destroy()
	self.Disconnect()
	setmetatable(self,nil)
end





return Signal
