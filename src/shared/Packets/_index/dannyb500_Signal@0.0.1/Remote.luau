
local Trove = require("../../OpenSource/Trove")
local Signal = require("./Signal")

local RunService = game:GetService("RunService")


local IsServer = RunService:IsServer()
local Store = if not IsServer then script:WaitForChild("Remotes") else Instance.new("Folder")
Store.Name = "Remotes"
Store.Parent = script


local Remote = {}
Remote.__index = Remote

local function MkDir(Name)
	if not Store:FindFirstChild(Name) then
		local Folder = Instance.new("Folder")
		Folder.Name = Name
		Folder.Parent = Store
	end
	return Store[Name]
end

--[[
	@public
	@function new()
	@returns Remote
	Creates a new Remote instance to manage Roblox RemoteEvents and UnreliableRemoteEvents
]]
function Remote.new(MobuleName: string,Name: string, Type: string | RemoteEvent)
	local self = setmetatable({}, Remote)
	
	self._trove = Trove.new()
	self._signal = Signal.new()
	self._name = Name
	self._type = Type
	self._event = nil;
	
	if IsServer then
		self._event = if Type == "UNRELIABLE" then
			Instance.new("UnreliableRemoteEvent") else
			Instance.new("RemoteEvent") 
		local Dir = MkDir(MobuleName)
		self._event.Name = Name
		self._event.Parent = Dir
		
		self._trove:Connect(self._event.OnServerEvent,function(...)
			self._signal:Fire(...)
		end)
	else
		self._event = Type
		
		self._trove:Connect(self._event.OnClientEvent,function(...)
			self._signal:Fire(...)
		end)
	end
	
	return self
end

function Remote.GetRemotes()
	return Store:GetChildren()
end

function Remote:Fire(...: any)
	if IsServer then
		self._event:FireAllClients(...)
	else
		self._event:FireServer(...)
	end
end

function Remote:FireOther(Player: Player,...: any)
	if IsServer then
		for _,Player in game.Players:GetPlayers() do
			if Player ~= Player then
				self._event:FireClient(Player,...)
			end
		end
	end
	
end

function Remote:FireClient(Player: Player,...: any)
	if IsServer then
		self._event:FireClient(Player,...)
	else
		error("Cannot fire client from server")		
	end
end

function Remote:Connect(callback: () -> (any))
	return self._signal:Connect(callback)
end

function Remote:GetRemoteFolder()
	return Store
end

function Remote:Destroy()
	self._trove:Destroy()
	setmetatable(self,nil)
end


return Remote