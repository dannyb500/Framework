local StyleMap = {

    --// COLOR PROPERTIES
    ["background-color"] = "BackgroundColor3",
    ["color"] = "TextColor3",
    
    ["border-color"] = "UIStroke.Color", 
    ["border-size"] = "UIStroke.Thickness",

    --// TEXT PROPERTIES
    ["Font-family"] = function(value)
        return Font.new(value,Enum.FontWeight.Light,Enum.FontStyle.Normal)
    end,
    ["font-size"] = "TextSize",
    ["font-weight"] = "Font",
    ["text-align"] = "TextXAlignment",
    ["text-valign"] = "TextYAlignment",
    ["line-height"] = "TextSize",

    --// SPACING, LAYOUT, & DIMENSIONS
    ["padding"] = "UIPadding", 
	["margin"] = "Padding", 
	["list"] = "UIListLayout";
    ["display"] = "LayoutObject", 
    
    -- Width/Height
    ["width"] = "Size.X", 
    ["height"] = "Size.Y", 
    ["min-width"] = "AspectRatioConstraint",

    --// VISUAL PROPERTIES
    ["border-radius"] = "UICorner",
    
    ["opacity"] = "BackgroundTransparency", 
    
    ["z-index"] = "ZIndex",
}

return StyleMap