local RunService = game:GetService("RunService")
local Terrain = game.Workspace.Terrain

local Memory = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Memory)
local Assert = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Assert)
local Colors = require(script.Parent.Parent["dannyb500_Str@0.0.1"].Colors)
local Types =  require(script.Parent.Parent.Parent.Types)


local WFH_NAME = "WireframeHandle";
local WFH_PARENT = Terrain;
local WFH_MODULE = {};
local WFH = nil;
local WFH_STATIC = nil;
local WFH_RUNTIME = true;

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

local function draw(from: Vector3, to: Vector3)
   WFH:AddLine(from, to);
end

local function drawText(position: Vector3,size: number, ...)
    local Args = {...}
    WFH:AddText(position,formatText(Args),size);
end

local function drawBoxOutline(position: Vector3, size: number, lookAt: Vector3 | nil) 
    local halfSize = size / 2 
    
    local pathArray = {
        Vector3.new(-halfSize, halfSize, 0),
        Vector3.new(halfSize, halfSize, 0),
        Vector3.new(halfSize, -halfSize, 0),
        Vector3.new(-halfSize, -halfSize, 0)
    }
    
    local transform = if lookAt then CFrame.lookAt(position,lookAt) else CFrame.new(position)

    for i,v in pathArray do
        pathArray[i] = transform * v
    end

    WFH:AddPath(pathArray, true)
end

local function fillBoxAnimation(position: Vector3,Size: number, lookAt: Model | BasePart,Cancel,Result) 
    Assert(WFH,"WFH not found");
    local CurrentY = -Size
    local C = false;

    if Cancel then 
        Cancel:Connect(function()
            C = true;
        end)
    end

    
    task.defer(function()
        local halfSize = Size / 2;
        local Draw = {};
        repeat
            for y = -Size, CurrentY, 0.01 do

                local transform = if lookAt then
                     CFrame.lookAt(position,lookAt:GetPivot().Position)
                     else
                     CFrame.new(position)
                table.insert(Draw,{
                    Vector3.new(-halfSize, y/2, 0),
                    Vector3.new(halfSize, y/2, 0)
                })

                local Calc = {}
                for i,v in Draw do
                    Calc[1] = transform * v[1]
                    Calc[2] = transform * v[2]
                end
                WFH_STATIC:AddPath(Calc, false)
            end
            
            CurrentY = CurrentY + 0.05
            task.wait(0.025)
            WFH_STATIC:Clear()
            
        until CurrentY > Size or C;
        if Result then
            Result:Fire(if C then false else true);
        end
    end)
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
    WFH_STATIC.Color3 = Color3
end

local function setTransparency(n: number)
    Assert(WFH,"WFH not found");
    WFH.Transparency = n;
end

--------------------------------------
--// PUBLIC \\-----------------------
--------------------------------------

function WFH_MODULE:DrawLine(From: Vector3, To: Vector3)
    WIRE_MEM:Insert(function()
        draw(From, To);
    end)
end

function WFH_MODULE:DrawText(Position: Vector3,Size: number, ...: string)
    local Args = {...}
    WIRE_MEM:Insert(function()
        Assert(Position,"No position given")
        drawText(Position,Size, unpack(Args));
    end)
end

function WFH_MODULE:DrawBoxOutline(Position: Vector3, Size: number,LookAt: Vector3 | nil)
    WIRE_MEM:Insert(function()
        drawBoxOutline(Position, Size,LookAt);
    end)
end

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

function WFH_MODULE:FillBoxAnimation(Position: Vector3,Size: number, LookAt: Vector3 | nil,Cancel:()->(),Result:()->(boolean))
    WIRE_MEM:Insert(function()
        fillBoxAnimation(Position,Size,LookAt,Cancel,Result);
    end)
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