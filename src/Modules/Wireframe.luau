local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Types = require(ReplicatedStorage.Shared.Packets:WaitForChild("Types"))

local Client = {
	Test = "e",
} :: Types.FrameworkPacket

export type self = typeof(Client) & Types.FrameworkIndex;


-------------------------
-- SERVICES --
-------------------------

-------------------------
-- VARIABLES --
-------------------------
local Wire = nil;
local Offset = 0;

local SPACING = 20;

local BOX_SIZE = 5;
local BOX_NORMAL = Vector3.yAxis * 5;

local LINE_HEIGHT = 5;
local LINE_EXTRUDE = 5;

local CONE_HEIGHT = 5;
local CONE_RADIUS = 2;
local CONE_SEGMENTS = 11;
local CONE_NORMAL = Vector3.yAxis * 5;

local TEXT_SIZE = 20;
-------------------------
-- PRIVATE FUNCTIONS --
-------------------------

local function Increment()
    Offset += SPACING;
end

local function RenderExample()
    Offset = 0;
    Wire:DrawAxis(Vector3.zero,nil);
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Axis \n Color cannot be changed")
    
    Increment();
    Wire:SetColor("r")
    
    Wire:DrawLine(Vector3.xAxis * Offset,Vector3.new(Offset,Offset,0))
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Line")
    
    Increment();
    Wire:SetColor("g")

    Wire:DrawPath({
        Vector3.xAxis * Offset,
        Vector3.new(Offset,LINE_HEIGHT,0),
        Vector3.new(Offset,LINE_HEIGHT,LINE_EXTRUDE),

    },true);
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Path \n Looped: true")

    Increment();

    Wire:DrawPath({
        Vector3.xAxis * Offset,
        Vector3.new(Offset,LINE_HEIGHT,0),
        Vector3.new(Offset,LINE_HEIGHT,LINE_EXTRUDE),

    },false);
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Path \n Looped: false")


    Increment();
    Wire:SetColor("b")

    Wire:DrawCone(Vector3.xAxis * Offset,CONE_RADIUS,CONE_HEIGHT,CONE_SEGMENTS,CONE_NORMAL);
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Cone")
    
    Increment();
    Wire:SetColor("r")
    Wire:DrawSphere(Vector3.xAxis * Offset,CONE_RADIUS,CONE_SEGMENTS,CONE_NORMAL);
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Sphere")

    Increment();
    Wire:SetColor("g")
    
    Wire:DrawBox(Vector3.xAxis * Offset,BOX_SIZE,BOX_NORMAL)
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Box")
    
    Increment()
    Wire:SetColor("b")
    
    Wire:DrawText(Vector3.xAxis * Offset, TEXT_SIZE, "Hi","Example Text","Yes")

    Wire:SetColor("w")
end

-------------------------
-- PUBLIC FUNCTIONS --
-------------------------

-------------------------
-- FRAMEWORK INIT --
-------------------------

function Client.Init(self: self)
    Wire = self._index.Wire

    -- RunService:BindToRenderStep("Example_WIREFRAME",Enum.RenderPriority.Camera.Name + 1,RenderExample)
    while true do
        task.wait();
        RenderExample()
    end
end

function Client.Start(self: self)

end

return Client
