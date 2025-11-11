local RunService = game:GetService("RunService")
local Terrain = game.Workspace.Terrain

local Memory = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Memory)
local Assert = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Assert)
local Colors = require(script.Parent.Parent["dannyb500_Str@0.0.1"].Colors)

local WFH_NAME = "WireframeHandle";
local WFH_PARENT = Terrain;
local WFH_MODULE = {};
local WFH = nil;

local INTERNAL_TIMER = 0.0;

local WIRE_MEM = Memory.new();

--// WFH_INSTANCE
do
    WFH = WFH_PARENT:FindFirstChild(WFH_NAME)
    if not WFH then
        WFH = Instance.new("WireframeHandleAdornment");
        WFH.Name = WFH_NAME;
        WFH.Parent = WFH_PARENT;
        WFH.Adornee = workspace;
        WFH.AlwaysOnTop = true;
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
        T ..= ` ` .. S
        S = nil;
    end
    return T
end

local function draw(from: Vector3, to: Vector3)
   WFH:AddLine(from, to);
end

local function drawText(position: Vector3, ...)
    local Args = {...}
    WFH:AddText(position,formatText(Args),nil);
end

local function setColor(Color3: Color3 | string)
    if typeof(Color3) == "string" then
        if Colors[Color3] then
            Color3 = Colors[Color3]
        else
            error(`String color not found {Color3}`, 3)
        end
    end
    WFH.Color3 = Color3
end

--------------------------------------
--// PUBLIC \\-----------------------
--------------------------------------

function WFH_MODULE:DrawLine(From: Vector3, To: Vector3)
    WIRE_MEM:Insert(function()
        draw(From, To)
    end)
end

function WFH_MODULE:DrawText(Position: Vector3, ...: string)
    local Args = {...}
    WIRE_MEM:Insert(function()
        Assert(Position,"No position given")
        drawText(Position, unpack(Args))
    end)
end

function WFH_MODULE:SetColor(Color3: Color3 | string)
    WIRE_MEM:Insert(function()
        setColor(Color3)
    end)
end

--------------------------------------
--// INTERNAL \\----------------------
--------------------------------------

local function Update(DT)
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


RunService:BindToRenderStep("WIREFRAME_HANDLE",Enum.RenderPriority.Camera.Value - 1, Update)

return WFH_MODULE;