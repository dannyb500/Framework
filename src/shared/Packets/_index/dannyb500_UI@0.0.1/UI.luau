local Assert = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Assert)
local Memory = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Memory)
local Stack = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Stack)
local Signal = require(script.Parent.Parent["dannyb500_Signal@0.0.1"].Signal)
local Maid = require(script.Parent.Parent["dannyb500_Maid@0.0.1"].Maid)

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if RunService:IsServer() then
    return {};
end

local Player = game.Players.LocalPlayer
local GUI = Player:WaitForChild("PlayerGui")

local UI = {}
UI.__index = UI;
local function HasProperty(Instance: BasePart, Property: string)
	return pcall(function()
		return Instance[Property]
	end)
end

local function FindStyle(Name: string)
    Assert(ReplicatedStorage:FindFirstChild("Design"),`COULD NOT FIND STYLE DESIGN FOLDER`)
    Assert(ReplicatedStorage.Design:FindFirstChild(Name),`COULD NOT FIND STYLE SHEET {Name}`)
    return ReplicatedStorage.Design[Name];
end

local function SetStyle(self,SGUI: ScreenGui,Style: StyleSheet)
    if SGUI:FindFirstChildWhichIsA("StyleLink") then
        SGUI:FindFirstChildWhichIsA("StyleLink").StyleSheet = Style;
        return 1;
    end
    local Linker = Instance.new("StyleLink")
    self:ApplyProperties(Linker,{
        Name = Style.Name;
        Parent = SGUI;
        StyleSheet = Style;
    })
end

function UI:ConnectEnum(Instance: UIBase,Type: string,fnc:() -> nil)
    print(Instance, Type, fnc)
    self._Maid:Connect(Instance[Type],fnc)
end

function UI:ApplyProperties(Instance: BasePart, Properties: {[string]: any})
    for i, v in Properties do
        if HasProperty(Instance,i) then
            if typeof(v) == "function" then
                self:ConnectEnum(Instance,i,v)
            else
                Instance[i] = v;
            end
        end
        if i == "Tag" then
            CollectionService:AddTag(Instance,v);
        end
    end
    return;
end


function UI.new()
    local ScreenGui = Instance.new("ScreenGui",GUI);
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local self = setmetatable({},UI);
    self.Screen = ScreenGui;

    self.Enum = {
        Activated = "MouseButton1Click";
        Enter = "MouseEnter";
        Leave = "MouseLeave";
    };

    self._Style = nil;

    self._Maid = Maid.new();
    self._Mem = Memory.new();
    self._Stack = Stack.new();
    self._Signal = Signal.new();
    self._Parent = self.Screen;
    
    print(self)
    
    return self
end

function UI:LoadStyleSheet(StyleSheet: string)
    self._Style = FindStyle(StyleSheet);
    SetStyle(self,self.Screen,self._Style)
end

function UI:LinkClass(Class: string)
    
end

function UI:CreateElement(Object: string,Properties: {any}, Children: {})
    local Ins = Instance.new(Object);
	self:ApplyProperties(Ins,Properties)
    
    Ins.Parent = self._Parent;
    
    if not Children then
        return Ins;
    end

    for i, v: {} in Children do
        if typeof(v) ~= "Instance" then
            continue;
        end
        v.Parent = Ins;
    end

    return Ins
end

function UI:Destroy()
    self.Screen:Destroy();
    self._Maid:Destroy();

end

return UI