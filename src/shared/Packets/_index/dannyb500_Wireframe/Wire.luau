local RunService = game:GetService("RunService")
local Terrain = game.Workspace.Terrain

local COS = math.cos;
local SIN = math.sin;
local PI = math.pi;
local PI_2 = 2 * PI;

local Memory = require(script.Parent.Parent["dannyb500_Data"].Memory)
local Colors = require(script.Parent.Parent["dannyb500_Str"].Colors)

local WFH_NAME = "WireframeHandle";
local WFH_PARENT = Terrain;
local WFH_MODULE = {};
local WFH = nil;
local WFH_STATIC = nil;
local WFH_RUNTIME = true;
local WFH_COLOR = nil;

local INTERNAL_TIMER = 0.0;

local WIRE_MEM = Memory.new();

--// WFH_INSTANCE
do
	WFH = WFH_PARENT:FindFirstChild(WFH_NAME)
	WFH_STATIC = WFH_PARENT:FindFirstChild(WFH_NAME.."_STATIC")

	if not WFH then
		WFH = Instance.new("WireframeHandleAdornment");
		WFH.Name = WFH_NAME;
		WFH.Parent = WFH_PARENT;
		WFH.Adornee = workspace;
		WFH.AlwaysOnTop = true;
	end
	if not WFH_STATIC then
		WFH_STATIC = Instance.new("WireframeHandleAdornment");
		WFH_STATIC.Name = WFH_NAME.."_STATIC";
		WFH_STATIC.Parent = WFH_PARENT;
		WFH_STATIC.Adornee = workspace;
		WFH_STATIC.AlwaysOnTop = true;
	end
end

--------------------------------------
--// PRVIATE \\-----------------------
--------------------------------------

local function formatText(Text: {string})
	local T = ``
	for _,v in Text do
		local S;
		if typeof(v) == "string" then
			S = v;
		end
		if typeof(v) == "number" then
			S = tostring(v);
		end
		T ..= ` \n ` .. S
		S = nil;
	end
	return T
end

--// SETTERS \\-----------------------

local function setColor(Color3: Color3 | string)
	if typeof(Color3) == "string" then
		if Colors[Color3] then
			Color3 = Colors[Color3]
		else
			error(`String color not found {Color3}`, 3)
		end
	end
	if not Color3 then
		return;
	end
	WFH.Color3 = Color3
	WFH_STATIC.Color3 = Color3
	WFH_COLOR = Color3;
end

local function setTransparency(n: number)
	assert(WFH,"WFH not found");
	WFH.Transparency = n;
end

--// DRAWING \\-----------------------

local function draw(from: Vector3, to: Vector3)
	WFH:AddLine(from, to);
end

local function drawPath(points: {Vector3}, loop: boolean)
	WFH:AddPath(points, loop);
end

local function drawText(position: Vector3,size: number, ...)
	local Args = {...}
	WFH:AddText(position,formatText(Args),size);
end

local function drawBox(position: Vector3, size: Vector2 | number, lookAt: Vector3 | nil) 
	size = if typeof(size) == "number" then Vector2.new(size,size) else size
	local halfSize = typeof(size) == "number" and size / 2 or size / 2
	
	local pathArray = {
		Vector3.new(-halfSize.X, halfSize.Y, 0),
		Vector3.new(halfSize.X, halfSize.Y, 0),
		Vector3.new(halfSize.X, -halfSize.Y, 0),
		Vector3.new(-halfSize.X, -halfSize.Y, 0)
	}

	local transform = if lookAt then CFrame.lookAt(position,lookAt) else CFrame.new(position)

	for i,v in pathArray do
		pathArray[i] = transform * v
	end

	WFH:AddPath(pathArray, true)
end

local function fillBoxAnimation(position: Vector3, Size: number, lookAt: Vector3 | nil, Cancel, Result) 
	assert(WFH,"WFH not found");
	local CurrentY = -Size
	local C = false;

	if Cancel then 
		Cancel:Connect(function()
			C = true;
		end)
	end

	local transform = if lookAt then CFrame.lookAt(position, lookAt) else CFrame.new(position)

	task.defer(function()
		local halfSize = Size / 2;
		local Draw = {};
		repeat
			for y = -Size, CurrentY, 0.01 do
				table.insert(Draw,{
					Vector3.new(-halfSize, y/2, 0),
					Vector3.new(halfSize, y/2, 0)
				})

				local Calc = {}
				for i, v in Draw do
					table.insert(Calc, transform:PointToWorldSpace(v[1]))
					table.insert(Calc, transform:PointToWorldSpace(v[2]))
				end
				WFH_STATIC:AddPath(Calc, false)
			end

			CurrentY = CurrentY + 0.05
			task.wait(0.025)
			WFH_STATIC:Clear()
			table.clear(Draw)
		until CurrentY > Size or C;
		if Result then
			if Result.Fire then
				Result:Fire(if C then false else true);
			else
				Result(if C then false else true)	
			end
		end
	end)
end

local function drawCircle(position: Vector3, radius: number, segments: number,normal: Vector3)
	radius = radius or 5;
	segments = if segments <= 3 then 3 else segments;
	normal = normal or Vector3.yAxis;

	local CF = CFrame.lookAlong(position,normal)

	local path = {}

	for i = 0, segments do
		local a = i * (PI_2 / segments)
		table.insert(
			path,
			CF:PointToWorldSpace(Vector3.new(COS(a),SIN(a),0) * radius)
		)

	end; drawPath(path,true);
end

local function drawSphere(position: Vector3, radius: number, segments: number)	
	drawCircle(position, radius, segments, Vector3.xAxis)
	drawCircle(position, radius, segments, Vector3.yAxis)
	drawCircle(position, radius, segments, Vector3.zAxis)
end

local function drawAxis(position: Vector3,size: number)
	local c = WFH_COLOR;
	local s = if size then size else 10;
	setColor("r");
	draw(position, position + Vector3.xAxis * s);
	draw(position, position - Vector3.xAxis * s);
	setColor("g");
	draw(position, position + Vector3.yAxis * s);
	draw(position, position - Vector3.yAxis * s);
	setColor("b");
	draw(position, position + Vector3.zAxis * s);
	draw(position, position - Vector3.zAxis * s);
	setColor(c)
end

local function drawCone(position: Vector3, radius: number,height: number, segments: number, normal: Vector3)
	segments = if segments then segments else 16;
	radius = if radius then radius else 16;
	height = if height then height else radius * 2.5
	normal = if normal then normal else Vector3.yAxis

	local top = position + normal * height
	local CF = CFrame.lookAlong(position,normal)

	drawCircle(position,radius,segments,normal)

	for i = 0,segments do
		local a = i * (PI_2 / segments)
		local p = CF:PointToWorldSpace(Vector3.new(COS(a),SIN(a),0) * radius)
		draw(p,top)
	end
end

local function drawRay(origin: Vector3, direction: Vector3, raycast: RaycastResult)
	local c = WFH_COLOR;
	if raycast then
		setColor("g");
		draw(origin,raycast.Position);
	else
		setColor("r");
		draw(origin, origin + direction);
	end
	setColor(c)
end

--------------------------------------

--------------------------------------
--// PUBLIC \\------------------------
--------------------------------------

function WFH_MODULE:SetColor(Color3: Color3 | string)
	WIRE_MEM:Insert(function()
		setColor(Color3);
	end)
end

function WFH_MODULE:SetTransparency(N: number)
	WIRE_MEM:Insert(function()
		setTransparency(N);
	end)
end

function WFH_MODULE:DrawLine(From: Vector3, To: Vector3)
	WIRE_MEM:Insert(function()
		draw(From, To);
	end)
end

function WFH_MODULE:DrawPath(Tbl: {Vector3},Loop: boolean)
	WIRE_MEM:Insert(function()
		drawPath(Tbl,Loop)
	end)
end

function WFH_MODULE:DrawText(Position: Vector3,Size: number, ...: string)
	local Args = {...}
	WIRE_MEM:Insert(function()
		assert(Position,"No position given")
		drawText(Position,Size, unpack(Args));
	end)
end

function WFH_MODULE:DrawBox(Position: Vector3, Size: number, LookAt: Vector3 | nil)
	WIRE_MEM:Insert(function()
		drawBox(Position, Size,LookAt);
	end)
end

function WFH_MODULE:Draw(Position: Vector3, Size: Vector2, LookAt: Vector3 | nil)
	WIRE_MEM:Insert(function()
		drawWH(Position, Size,LookAt);
	end)
end


function WFH_MODULE:DrawSphere(Position: Vector3, Radius: number, Segments: number)
	WIRE_MEM:Insert(function()
		drawSphere(Position,Radius,Segments)
	end)
end

function WFH_MODULE:FillBoxAnimation(Position: Vector3,Size: number, LookAt: Vector3 | nil,Cancel:()->(),Result:()->(boolean))
	WIRE_MEM:Insert(function()
		fillBoxAnimation(Position,Size,LookAt,Cancel,Result);
	end)
end

function WFH_MODULE:DrawCircle(Position: Vector3, Radius: number, Segments: number,Normal: number)
	WIRE_MEM:Insert(function()
		drawCircle(Position,Radius,Segments,Normal)
	end)
end

function WFH_MODULE:DrawAxis(Position: Vector3,Size: number)
	WIRE_MEM:Insert(function()
		drawAxis(Position,Size)
	end)
end

function WFH_MODULE:DrawCone(Position: Vector3, Radius: number,Height: number,Segments: number,Normal: Vector3)
	WIRE_MEM:Insert(function()
		drawCone(Position,Radius,Height,Segments,Normal)
	end)
end

function WFH_MODULE:DrawRay(Origin: Vector3,Direction: Vector3, Raycast: RaycastResult)
	WIRE_MEM:Insert(function()
		drawRay(Origin,Direction,Raycast)
	end)
end

function WFH_MODULE:SetThickness(Number: number)
	WFH.Thickness = Number
end

--------------------------------------
--// INTERNAL \\----------------------
--------------------------------------

local function Update()
	local t = tick();
	if t ~= INTERNAL_TIMER then
		INTERNAL_TIMER = t;
		WFH:Clear()
	end
	for _,fnc in WIRE_MEM:Get() do
		fnc();
	end
	WIRE_MEM:Clear();
end

function WFH_MODULE:UPDATE()
	if WFH_RUNTIME then
		return warn("Update is already being called by main thread")
	end
	Update()
end

function WFH_MODULE:ChangeRuntime(b: boolean)
	WFH_RUNTIME = b
	RunService:UnbindFromRenderStep("WIREFRAME_HANDLE")
	if b then
		RunService:BindToRenderStep("WIREFRAME_HANDLE",Enum.RenderPriority.Camera.Value - 1, Update)
	else
		RunService:UnbindFromRenderStep("WIREFRAME_HANDLE")
		warn("Runtime is disabled for Wireframe. Update needs to be called manually: WFH_MODULE:Update()")
	end
end

WFH_MODULE:ChangeRuntime(WFH_RUNTIME);

return WFH_MODULE;