local typeCheck = function(value, errmsg, ...)
    local valueType = typeof(value);
    local expected = {...};
    if (not table.find(expected, valueType)) then
        error(errmsg or string.format("%s expected, got %s", expected[1], valueType), 2);
    end
end

local UI = {
    Element = {},
    Section = {},
    Tab = {},
    Window = {}
};

local DrawingUtils = {};
DrawingUtils.__index = DrawingUtils;

function DrawingUtils.new(drawing)
    local self = {};
    setmetatable(self, DrawingUtils);

    for i, v in pairs(drawing) do
        self[i] = v
    end

    return self;
end

function DrawingUtils:UpdatePosition()
    local drawing = self.Drawing
    if (not drawing.Parent) then
        return;
    end

    local drawingObject = drawing.Object
    local drawingObjectSize = drawing.Size
    local offsets = drawing.Offsets
    if (type(offsets) == "function") then
        offsets = offsets(drawingObject);
    end

    drawingObject.Position = Point2D.new(drawing.Scale(drawing.Parent, drawingObjectSize) + offsets);
end

function DrawingUtils:SetVisible(vis)
    self.Object.Visible = vis
    return true;
end

local Drawing = {
    Texts = {},
    Rects = {},
    Images = {},
    Gradients = {}
};

function Drawing:AddFrame(info)
    typeCheck(info, nil, "table");
    local Rects = self.Rects
    local newFrame = {};

    local rectDynamic = RectDynamic.new();
    local rectmt = getmetatable(rectDynamic);
    if (info.Parent) then
        typeCheck(info.Offsets, "(Drawing.AddText) 'Offsets' is required", "Vector2", "function");
        typeCheck(info.Scale, "(Drawing.AddText) 'Scale is required'", "function");
    end

    for prop, value in pairs(info) do
        if (rectDynamic[prop] or rectmt[prop]) then
            rectDynamic[prop] = value
        end
    end
    rectDynamic.Filled = info.Filled or true

    newFrame.Object = rectDynamic
    newFrame.Parent = info.Parent
    newFrame.Scale = info.Scale
    newFrame.Offsets = info.Offsets
    newFrame.Size = rectDynamic.Size

    Rects[#Rects + 1] = newFrame

    return DrawingUtils.new(newFrame);
end

function Drawing:AddText(info)
    typeCheck(info, nil, "table");
    local Texts = self.Texts
    local newText = {};

    local textDynamic = TextDynamic.new();
    if (info.Parent) then    
        typeCheck(info.Offsets, "(Drawing.AddText) 'Offsets' is required", "Vector2", "function");
        typeCheck(info.Scale, "(Drawing.AddText) 'Scale is required'", "function");    
    end

    for prop, value in pairs(info) do
        if (textDynamic[value]) then
            textDynamic[prop] = value
        end
    end

    newText.Object = textDynamic
    newText.Parent = info.Parent
    newText.Scale = info.Scale
    newText.Offsets = info.Offsets
    newText.Size = textDynamic.TextBounds

    Texts[#Texts + 1] = newText

    return DrawingUtils.new(newText);
end


local Element = UI.Element
Element.__index = Element

function Element.new(name)
    local self = {};
    setmetatable(self, Element);

    self.Name = name

    return self;
end

function Element:SliderFloat()
    local Sliders = self.Sliders
    local newElement = Element.new();


    Sliders[#Sliders + 1] = newElement
    return newElement;
end

local Section = UI.Section
Section.__index = Section

function Section.new()
    local self = {};
    setmetatable(self, Element);

    self.Name = name
    self.Sliders = {};

    return self;
end

function Section:CreateSection(name)
    local Sections = self.Sections
    local newSection = Section.new();
    
    Sections[#Sections + 1] = newSection
    return newSection;
end

local Tab = UI.Tab
Tab.__index = Tab

function Tab.new(name)
    local self = {};
    setmetatable(self, Section);

    self.Name = name
    self.Sections = {};

    return self;
end

function Tab:CreateTab(name)
    local Tabs = self.Tabs
    local newTab = Tab.new(name);

    Tabs[#Tabs + 1] = newTab

    return newTab
end

local Window = UI.Window
Window.__index = Window

function Window.new(title, gameName, colorScheme, defaultFont)
    local self = {};
    setmetatable(self, Tab);

    self.Title = title
    self.Name = gameName
    self.ColorScheme = colorScheme
    self.DefaultFont = defaultFont
    self.Tabs = {};

    local mainFrame = Drawing:AddFrame({
        Size = Vector2.new(500, 450),
        Position = Point2D.new(Vector2.new(710, 583)),
        Color = Color3.fromRGB(25, 25, 25),
        Outlined = true,
        OutlineColor = Color3.fromRGB(4, 4, 4),
        OutlineThickness = 2,
        Visible = true,
        ZIndex = 1
    });

    return self;
end

-- function Window:Init()

-- end

local Window = Window.new("testing");

wait(3);