----------------------------------------
--[[ 
--  LoadModules({Folder})
--
--]]
----------------------------------------

local Shared = {}
Shared.__index = Shared

local Remote = require("./_index/dannyb500_Signal@0.0.1/Remote")

-------------------------
-- SERVICES --
-------------------------
local RunService = game:GetService("RunService")

-------------------------
-- VARIABLES --
-------------------------
local isServer = RunService:IsServer() and "Server" or "Client"
local ignoreServer = false -- True: yeidls until server modules have loaded

local Index = script.Parent:WaitForChild("_index")

-------------------------
-- PRIVATE FUNCTIONS --
-------------------------

--[[
	@private
	@function AttemptRequire
    @desc Checks if the server/ignored so the modules can load
    @YIELDS
]]
local function CanLoad()
	if isServer == "Server" then
		script:SetAttribute("CanStart", false)
		return true
	else
		if ignoreServer then
			return true
		end

		repeat
			task.wait(0.1)
			print("Waiting for server...")
		until script:GetAttribute("CanStart") == true
		return true
	end
end

--[[
	@private
	@function AttemptRequire
    @desc Attempts to require module 
]]
local function AttemptRequire(Module: ModuleScript)
	local Loaded = nil
	xpcall(function()
		-- task.spawn(function()
			Loaded = require(Module)
		-- end)
	end, function()
		error(`Failed to require {Module.Name} : {debug.traceback()}`)
	end)
	print(`{Module.Name} required`, Loaded)
	return Loaded
end

--[[
	@private 
	@function Construct
	@desc Inits all Signals for remove events¬
]]
local function Construct(Modules)
	for Name, Module in Modules do
		Module.Interop = {}
		Module._events = {}
		Module._index = {}

		for Key, Value in Module do
			if typeof(Value) ~= "table" then
				continue
			end
			if Value["_SIGNAL"] then
				Module[Key] = Remote.new(Name, Key, Value["_SIGNAL"])
			end
		end
	end
	return true
end

--[[
	@private
	@function LoadClasses
	@desc Requires all classes inside _index
]]
local function LoadClasses()
	local Classes = {}
	for _, Folder in Index:GetChildren() do
		for _, ModuleLoader in Folder:GetChildren() do
			if not ModuleLoader:IsA("ModuleScript") then
				continue
			end
			Classes[ModuleLoader.Name] = AttemptRequire(ModuleLoader)
		end
	end
	Construct(Classes)
	return Classes
end

--[[
	@private
	@function LoadModules
	@desc Loads all the modules from Container of folders
]]
local function LoadModules(Containers: { Folder })
	if not CanLoad() then
		return warn("Cannot load")
	end
	local Modules = {}
	
	for _, Container: Folder in Containers do
		for _, Module: Instance in Container:GetChildren() do
			if not Module:IsA("ModuleScript") then
				continue
			end

			local Success = AttemptRequire(Module)
			print(Success, `{Module.Name} Loaded`)
			Modules[Module.Name] = Success
		end
	end

	return Modules
end

-------------------------
-- PUBLIC FUNCTIONS --
-------------------------

--[[
	@constructor
	@function new
	@desc Creates a new instance of Shared
]]
function Shared.new()
	local self = setmetatable({}, Shared)
	self._index = LoadClasses()
	self.Interop = {}
	self._loaded = false;
	self._started = false;

	return self
end

--[[
	@function LoadModules
	@desc Loads modules from a folder into Interop
]]
function Shared:LoadModules(Container: { Folder })
	local Modules = LoadModules(Container)
	if Modules then
		for ModuleName, Module in Modules do
			self.Interop[ModuleName] = Module
		end
	end
end

--[[
	@function Init
	@desc Inits all modules that have an Init function
]]
function Shared:Init()
	print(self,"FRAMEWORK")
	if self._loaded then
		return warn("Already loaded")
	end
	for _,Module in self.Interop do
		Module._index = self._index
		Module.Interop = self.Interop
		Module._events = Module._events or {}
	end

	for _, module in self._index do
		if typeof(module) == "table" and typeof(module.Init) == "function" then
			module:Init()
		end
	end
	for _, module in self.Interop do
		if typeof(module) == "table" and typeof(module.Init) == "function" then
			module:Init()
		end
	end
	self._loaded = true
	return true
end

--[[
	@function Start
	@desc Starts all modules that have a Start function
]]
function Shared:Start()
	if isServer == "Server" then
		script:SetAttribute("CanStart", true)
	end
	if self._started then
		return warn("Already started")
	end

	for _, module in self._index do
		if typeof(module) == "table" and typeof(module.Start) == "function" then
			module:Start()
		end
	end
	for _, module in self.Interop do
		if typeof(module) == "table" and typeof(module.Start) == "function" then
			module:Start()
		end
	end
	self._started = true
	return true
end

return setmetatable(Shared, {
	__index = function(t, i)
		local value = rawget(t, i)
		if value == nil then
			return nil
		else
			return value
		end
	end,
	__newindex = function()
		error("Cannot modify read-only table")
	end,
	__metatable = "protected",
})
