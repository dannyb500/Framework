local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Packets:WaitForChild("Types"))

local Client = {} :: Types.FrameworkIndex

-------------------------
-- SERVICES --
-------------------------
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-------------------------
-- VARIABLES --
-------------------------

local Terrain = Workspace.Terrain

local MAX_WAVE_MAGNITUDE = 1.94 -- studs
local MAX_WAVELENGTH = 85 -- studs
local WAVE_SPEED = 10

local accumulatedTime = 0
local lastUpdateTime = os.clock()
local lastWaterWaveSpeed = Terrain.WaterWaveSpeed


if RunService:IsServer() then
	return {};
end

-------------------------
-- PRIVATE FUNCTIONS --
-------------------------

local function getWavelength()
	local a = math.sqrt(Terrain.WaterWaveSize)
	return a * MAX_WAVELENGTH
end

local function updateAccumulatedTime()
	local currentTime = os.clock()
	local deltaTime = currentTime - lastUpdateTime

	accumulatedTime += deltaTime * lastWaterWaveSpeed

	lastUpdateTime = currentTime
	lastWaterWaveSpeed = Terrain.WaterWaveSpeed
end

local function CalcWaterHeightOffset(X: number, Z: number)
	if Terrain.WaterWaveSize > 0.02 then
		updateAccumulatedTime()

		local w = getWavelength()

		local o = math.cos(2 * math.pi * (X + accumulatedTime) / w) * math.sin(2 * Z * math.pi / w)

		o *= Terrain.WaterWaveSize * MAX_WAVE_MAGNITUDE
		return o
	else
		return 0
	end
end

-------------------------
-- PUBLIC FUNCTIONS --
-------------------------

function Client:CalculateHeight(X: number,Z: number)
	return CalcWaterHeightOffset(X,Z)
end

-------------------------
-- FRAMEWORK INIT --
-------------------------

function Client:Init()

end

function Client:Start()
	Terrain.WaterWaveSpeed = WAVE_SPEED
	lastUpdateTime = os.clock()
	lastWaterWaveSpeed = Terrain.WaterWaveSpeed
end

do
	local c = true
	c = RunService.Stepped:Connect(function()
		c:Disconnect()
		c = nil
	end)

	repeat wait() until not c
end

return Client