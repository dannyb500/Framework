local Instance = require(script.Parent.Parent["dannyb500_Instance@0.0.1"].Instance)
local Assert = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Assert)
local Memory = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Memory)
local Stack = require(script.Parent.Parent["dannyb500_Data@0.0.1"].Stack)
local Signal = require(script.Parent.Parent["dannyb500_Signal@0.0.1"].Signal)
local Maid = require(script.Parent.Parent["dannyb500_Maid@0.0.1"].Maid)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if RunService:IsServer() then
    return warn("ignore")
end

local Player = game.Players.LocalPlayer
local GUI = Player:WaitForChild("PlayerGui")

local UI = {}
UI.__index = UI;

local function FindStyle(Name: string)
    if not ReplicatedStorage:FindFirstChild("Design") then
        return nil,error("COULD NOT FIND STYLE DESIGN FOLDER");
    end
    if not ReplicatedStorage.Design:FindFirstChild(Name) then
        return nil,error("COULD NOT FIND STYLE SHEET")
    end
    return ReplicatedStorage.Design[Name];
end

local function SetStyle(SGUI: ScreenGui,Style: StyleSheet)
    if SGUI:FindFirstChildWhichIsA("StyleLink") then
        SGUI:FindFirstChildWhichIsA("StyleLink").StyleSheet = Style;
        return 1;
    end
    Instance.new("StyleLink",{
        Name = Style.Name;
        Parent = SGUI;
        StyleSheet = Style; 
    })
end

function UI.new()
    local ScreenGui = Instance.new("ScreenGui",{
        Parent = GUI
    });

    local self = setmetatable({},UI);
    self.Screen = ScreenGui;

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
    SetStyle(self.Screen,self._Style)
end

function UI:CreateElement(Object: string,Properties: {any}, Children: {})
    local Ins = Instance.new(Object,Properties);
    Ins.Parent = self._Parent;

    if not Children then
        return Ins;
    end
    
    for _, v: {} in Children do
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