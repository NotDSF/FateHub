local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local localPlayer = game:GetService("Players").LocalPlayer
local mouse = localPlayer:GetMouse();
local inset = game:GetService("GuiService"):GetGuiInset();

local debug = true

local vector2new = Vector2.new
local fromRGB = Color3.fromRGB
local color3new = Color3.new

local tweens = {
    Out = {
        Quint = function(t, b, c, d)
            return c * ((t / d - 1) ^ 5 + 1) + b
        end
    }
}

local createTween = function(value, direction, style, duration, callback, yield)
    local tweenFunc = tweens[direction][style]
    local tnow = tick();
    local thread = coroutine.running();

    local co;
    co = game:GetService("RunService").RenderStepped:Connect(function()
        local now = tick();
        local diff = now - tnow
        if (diff < duration) then
            callback(tweenFunc(duration - (duration - diff), 0, value, duration));
        else
            co:Disconnect();
            callback(value);
            coroutine.resume(thread);
        end
    end);

    if (yield) then
        coroutine.yield(thread);
    end
end

local len = function(tbl)
    local n = 0
    for index, value in pairs(tbl) do
        n += 1
    end
    return n;
end

local textSize = function(obj)
    return {Size=obj.TextBounds};
end

local center = function(obj)
    local vec2 = obj.Position.ScreenPos
    local center = vector2new(vec2.X, vec2.Y);
    return center;
end

local topLeft = function(obj, size)
    local vec2 = obj.Position.ScreenPos
    local topLeft = vector2new(vec2.X - (obj.Size.X - size.X) / 2, vec2.Y - (obj.Size.Y - size.Y) / 2);
    return topLeft;
end
local centerLeft = function(obj, size)
    local vec2 = obj.Position.ScreenPos
    local topLeft = topLeft(obj, size);
    return vector2new(topLeft.X, vec2.Y);
end
local topRight = function(obj, size)
    local vec2 = obj.Position.ScreenPos
    local topRight = vector2new(vec2.X + (obj.Size.X - size.X) / 2, vec2.Y - (obj.Size.Y - size.Y) / 2);
    return topRight;
end
local centerRight = function(obj, size)
    local vec2 = obj.Position.ScreenPos
    local topRight = topRight(obj, size);
    return vector2new(topRight.X, vec2.Y);
end

local drawings = {};
for i = 1, 15 do
    drawings[i] = {};
end

local utils = {};
function utils:UpdatePositions(...)
    for ZIndex, objects in pairs(drawings) do
        for index, object in pairs(objects) do
            local construct = object[2]
            if (construct) then
                local offsets;
                if (type(construct.offsets) == "function") then
                    offsets = construct.offsets(object[1]);
                else
                    offsets = vector2new(unpack(construct.offsets));
                end
                local isText = typeof(object[1]) == "TextDynamic"
                local size = isText and object[1].TextBounds or object[1].Size
                object[1].Position = Point2D.new(construct.scale(construct.parent, size) + offsets);
            end
        end
    end
end

function utils:GetInfo(drawing)
    for ZIndex, objects in pairs(drawings) do
        for index, object in pairs(objects) do
            if (drawing == object[1]) then
                return object;
            end
        end
    end
end

function utils:UpdateOffsets(drawing, newoffsets)
    for ZIndex, objects in pairs(drawings) do
        for index, object in pairs(objects) do
            if (drawing == object[1]) then
                object[2].offsets = newoffsets
            end
        end
    end
end

function utils:GetOffsets(drawing)
    for ZIndex, objects in pairs(drawings) do
        for index, object in pairs(objects) do
            if (drawing == object[1]) then
                return object[2].offsets;
            end
        end
    end
end

function utils:SetAllVisible(objects, visible)
    for index, object in pairs(objects) do
        if (type(object) == "table") then
            utils:SetAllVisible(object, visible);
        else
            object.Visible = visible
        end
    end
end

local newFrame = function(props, info)
    local frame = RectDynamic.new();
    for prop, value in pairs(props) do
        frame[prop] = value
    end
    table.insert(drawings[frame.ZIndex], {frame, info});
    return frame;
end

local fontMain;
local newText = function(props, info)
    local text = TextDynamic.new();
    for prop, value in pairs(props) do
        text[prop] = value
    end
    table.insert(drawings[text.ZIndex], {text, info});
    return text;
end

local newImage = function(props, info)
    local image = ImageDynamic.new();
    for prop, value in pairs(props) do
        image[prop] = value
    end
    print(true, image.Position)
    table.insert(drawings[image.ZIndex], {image, info});
    return image;
end

local events = {
    onClick = {},
    onPress = {},
    onRelease = {},
    onScroll = {},
    onEnter = {},
    onLeave = {},
};

function events:Register(event, drawing, callback)
    if (type(drawing) == "table") then
        for index, drawingobj in pairs(drawing) do
            self["on" .. event][drawingobj] = callback
        end
    else
        self["on" .. event][drawing] = callback
    end
    return Enum.ContextActionResult.Sink;
end

local inBounds = function(objpos, objsize)
    local inX = mouse.X <= objpos.X + objsize.X / 2 and mouse.X + objsize.X / 2 >= objpos.X
    local inY = mouse.Y + inset.Y <= objpos.Y + objsize.Y / 2 and mouse.Y + inset.Y + objsize.Y / 2 >= objpos.Y
    return inX and inY;
end

local cursor, debugFrame;

local getObjectInMouseLocation = function()
    local objectFound, objectZIndex = nil, 0
    for ZIndex, objects in pairs(drawings) do
        for index, object in pairs(objects) do
            local drawing = object[1]
            local isText = typeof(drawing) == "TextDynamic"
            local size = isText and drawing.TextBounds or drawing.Size
            if (drawing.Visible and drawing ~= cursor and drawing ~= debugFrame and ZIndex > objectZIndex and inBounds(drawing.Position.ScreenPos, size)) then
                objectFound, objectZIndex = drawing, ZIndex
            end
        end
    end
    return objectFound;
end
local getObjectsInMouseLocation = function()
    local found = {};
    for ZIndex, objects in pairs(drawings) do
        for index, object in pairs(objects) do
            local drawing = object[1]
            local isText = typeof(drawing) == "TextDynamic"
            local size = isText and drawing.TextBounds or drawing.Size
            if (drawing.Visible and drawing ~= cursor and drawing ~= debugFrame and inBounds(drawing.Position.ScreenPos, size)) then
                table.insert(found, drawing);
            end
        end
    end
    return found;
end

local UILib = {};
function UILib:CreateWindow(title, gameName, colorScheme, font)
    fontMain = font
    cursor = newFrame({
        Color = color3new(1, 1, 1),
        Size = vector2new(5, 5),
        ZIndex = 15
    });
    debugFrame = newFrame({
        Color = color3new(1, 0, 0),
        Outlined = true,
        OutlineColor = color3new(1, 0, 0),
        OutlineThickness = 0,
        Visible = false,
        ZIndex = 14
    });
    local gradient = game:HttpGet("https://i.imgur.com/TO0775d.png");

    local mainFrame = newFrame({
        Filled = true,
        Size = vector2new(500, 450),
        Position = Point2D.new(vector2new(710, 583)),
        Color = fromRGB(25, 25, 25),
        Outlined = true,
        OutlineColor = fromRGB(4, 4, 4),
        OutlineThickness = 2,
        Visible = true,
        ZIndex = 1
    });

    do
        local outlineThickness = mainFrame.OutlineThickness
        local mainSize, mainPos = mainFrame.Size + vector2new(-outlineThickness, outlineThickness), mainFrame.Position.ScreenPos
        local min = mainPos - mainSize / 2
        local max = mainPos + mainSize / 2
        local outline = vector2new(outlineThickness + 1, outlineThickness + 1);

        task.spawn(function()
            createTween(500, "Out", "Quint", 1, function(val)
                local rect = Rect.new(min, vector2new(max.X - mainSize.X + val, 0) + outline);
                for i = 1, 15 do
                    setcliprect(i, rect);
                end
            end, true);
            createTween(450, "Out", "Quint", 1, function(val)
                mainSize, mainPos = mainFrame.Size, mainFrame.Position.ScreenPos
                min = mainPos - mainSize / 2
                max = mainPos + mainSize / 2
                outline = vector2new(outlineThickness + 1, -outlineThickness * -2);

                local rect = Rect.new(min - outline, vector2new(max.X, max.Y - mainSize.Y + val) + outline);
                for i = 1, 15 do
                    setcliprect(i, rect);
                end
            end, true);
            local rect = Rect.new(0, 0, 1920, 1080);
            for i = 1, 15 do
                setcliprect(i, rect);
            end
        end);
    end


    local dist;
    events:Register("Click", mainFrame, function()
        dist = vector2new(mouse.X, mouse.Y) - mainFrame.Position.ScreenPos
    end)
    events:Register("Press", mainFrame, function()
        local mainFramePos = mainFrame.Position.ScreenPos
        mainFrame.Position = Point2D.new(vector2new(mouse.X - dist.X, mouse.Y - dist.Y));
        utils:UpdatePositions();
    end);

    local pressing = {};
    local focusInputText, focusInputRaw;
    local lastMousePos = vector2new(mouse.X, mouse.Y);
    ContextActionService:BindCoreActionAtPriority("FH_Mouse", function(actionName, inputState, inputObject)
        local mousePos = vector2new(mouse.X, mouse.Y);
        local object = getObjectInMouseLocation();
        local onClick = events.onClick[object]
        local onPress = events.onPress[object]
        local onRelease = events.onRelease[object]

        if (inputObject.UserInputType == Enum.UserInputType.MouseWheel) then
            local objects = getObjectsInMouseLocation();
            local onScroll;
            for i, object in pairs(objects) do
                local callback = events.onScroll[object]
                if (callback) then
                    onScroll = callback
                end
            end
            if (onScroll) then
                onScroll(inputObject.Position.Z);
            end

            if (object) then
                return Enum.ContextActionResult.Sink;
            else
                return Enum.ContextActionResult.Pass;
            end
        end

        if (inputObject.UserInputType == Enum.UserInputType.MouseMovement) then
            if (inputState == Enum.UserInputState.Change) then
                for obj, callback in pairs(events.onPress) do
                    if (pressing[obj]) then
                        local mouseup = mousePos.Y - lastMousePos.Y < 0
                        callback(mouseup);
                        lastMousePos =  mousePos
                    end
                end
            end

            local mainFrameSize = mainFrame.Size
            local mainFramePos = mainFrame.Position.ScreenPos
            if (inBounds(mainFramePos, mainFrameSize)) then
                cursor.Visible = true
                cursor.Position = Point2D.new(mousePos + inset);
                if (debug and object) then
                    debugFrame.Position = Point2D.new(object.Position.ScreenPos);
                    debugFrame.Size = typeof(object) == "TextDynamic" and textSize(object).Size or object.Size
                    debugFrame.Visible = true
                end
                return Enum.ContextActionResult.Sink;
            else
                cursor.Visible = false
                if (debug) then
                    debugFrame.Visible = false
                end
            end
        end
        if (inputObject.UserInputType == Enum.UserInputType.MouseButton1) then
            if (inputState == Enum.UserInputState.Begin) then
                local inputted = false
                if (onClick) then
                    onClick();
                    inputted = true
                end
                if (onPress) then
                    inputted = true
                    pressing[object] = true
                    local mouseup = mouse.Y - lastMousePos.Y < 0
                    onPress(mouseup);
                end
                if (inputted) then
                    return Enum.ContextActionResult.Sink;
                end
            end
            if (inputState == Enum.UserInputState.End) then
                if (onRelease) then
                    onRelease();
                end
                table.clear(pressing);
            end
            return Enum.ContextActionResult.Pass;
        end
    end, false, 3001, Enum.UserInputType.MouseWheel, Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseButton1);

    ContextActionService:BindCoreActionAtPriority("FH_Keyboard", function(actionName, inputState, inputObject)
        if (focusInputText) then
            if (inputObject.KeyCode == Enum.KeyCode.Return) then
                focusInputText = nil
            end
            local keysPressed = UserInputService:GetKeysPressed();
            if (#keysPressed == 1) then
                local stringForKeyCode = UserInputService:GetStringForKeyCode(keysPressed[1].KeyCode);
                if (#stringForKeyCode == 1) then
                    focusInputText(string.lower(stringForKeyCode));
                    return Enum.ContextActionResult.Sink;
                end
            elseif (#keysPressed == 2) then
                local isShift = keysPressed[1].KeyCode == Enum.KeyCode.LeftShift or keysPressed[1].KeyCode == Enum.KeyCode.RightShift
                local stringForKeyCode = UserInputService:GetStringForKeyCode(keysPressed[2].KeyCode);
                if (isShift and #stringForKeyCode == 1) then
                    focusInputText(stringForKeyCode);
                    return Enum.ContextActionResult.Sink;
                end
            end
            return Enum.ContextActionResult.Sink;
        end
        if (focusInputRaw) then
            focusInputRaw(inputObject);
        end
        return Enum.ContextActionResult.Pass;
    end, false, 3001, unpack(Enum.KeyCode:GetEnumItems()));

    local mainTitle = newText({
        Text = title,
        Color = color3new(1, 1, 1),
        Size = 18,
        Visible = true,
        ZIndex = 2
    }, { scale = topLeft, parent = mainFrame, offsets = {7, 2} });

    utils:UpdatePositions();

    local ret = {};
    local tabs = {};
    local tabsVisible = {};

    function ret:Tab(tabName)
        local mainTab = newFrame({
            Filled = true,
            Size = vector2new(480, 385),
            Color = fromRGB(20, 20, 20),
            Outlined = true,
            OutlineThickness = 1,
            OutlineColor = fromRGB(40, 40, 40),
            Visible = true,
            ZIndex = 2
        }, { parent = mainFrame, scale = topLeft, offsets = {10, 55} });

        local currentTabAmount = len(tabs);
        local tabTitleFrame = newFrame({
            Filled = true,
            Size = vector2new(70, 20),
            Color = fromRGB(20, 20, 20),
            ZIndex = 2
        }, { parent = mainFrame, scale = topLeft, offsets = function(self)
            return vector2new(11 + (currentTabAmount * self.Size.X), 33) + vector2new(-1, 1 + mainTab.OutlineThickness)
        end });

        local tabTitle = newText({
            Text = tabName,
            Color = color3new(1, 1, 1),
            Size = 14,
            ZIndex = 3
        }, { parent = tabTitleFrame, scale = center, offsets = {0, 0} });

        local onTabSwitched = {};

        local switchTab = function(callback)
            for i, tab in pairs(tabs) do
                if (tab.mainTab ~= mainTab) then
                    utils:SetAllVisible(tab.sections, false);
                    tab.titleFrame.Color = fromRGB(22, 22, 22);
                    tab.tabTitle.Color = color3new(1, 1, 1);
                    tabsVisible[tab.mainTab] = false
                end
            end
            tabTitle.Color = colorScheme
            tabTitleFrame.Color = fromRGB(20, 20, 20)
            utils:SetAllVisible(tabs[mainTab].sections, true);
            tabsVisible[mainTab] = true

            for i, callback in pairs(onTabSwitched) do
                callback(tabName);
            end
        end
        events:Register("Click", {tabTitleFrame, tabTitle}, switchTab);

        tabs[mainTab] = {
            mainTab = mainTab,
            titleFrame = tabTitleFrame,
            tabTitle = tabTitle,
            sections = {}
        }

        utils:UpdatePositions();
        switchTab();

        local ret = {};
        local R, L = {}, {}
        local RLToggle = false

        local function updateSections(RL, Section)
            local SectionSpace = 10
            local LastY = Section and Section.Position.ScreenPos.Y + Section.Size.Y + SectionSpace or 15
            local Sectional = RL == 'R' and R or L
            local SX = RL == 'R' and 250 or 10
            for i = ((Section and table.find(Sectional, Section)or 0) + 1), #Sectional do
                local CurrentSection = Sectional[i]
                utils:UpdateOffsets(CurrentSection, {SX, LastY});
                LastY = LastY + CurrentSection.Size.Y + SectionSpace
            end
            utils:UpdatePositions();
        end

        function ret:Section(sectionName)
            local sections = tabs[mainTab].sections

            local section = newFrame({
                Filled = true,
                Size = vector2new(220, 20);
                Color = fromRGB(17, 17, 17),
                Outlined = true,
                OutlineThickness = 1,
                OutlineColor = fromRGB(40, 40, 40),
                Visible = tabsVisible[mainTab],
                ZIndex = 3
            }, { parent = mainTab, scale = topLeft, offsets = {0,0} });

            local sectionTitle = newText({
                Text = sectionName,
                Size = 15,
                Color = colorScheme,
                Visible = tabsVisible[mainTab],
                ZIndex = 4
            }, { parent = section, scale = topLeft, offsets = {15, -10} });

            local invisFrame = newFrame({
                Filled = true,
                Size = vector2new(sectionTitle.TextBounds.X + 10, 1),
                Color = fromRGB(17, 17, 17),
                Outlined = true,
                OutlineThickness = 1,
                OutlineColor = fromRGB(17, 17, 17),
                Visible = tabsVisible[mainTab],
                ZIndex = 3
            }, { parent = section, scale = topLeft, offsets = {10, 0} });

            sections[section] = {
                Main = section,
                sectionTitle = sectionTitle,
                invisFrame = invisFrame,
                elements = {}
            };
            utils:UpdatePositions();

            local ret = {};
            local SectionTable = {}
            local Sectional = RLToggle and 'R' or 'L'

            function ret:SetLeft()
                local CurrentSec = Sectional == 'R' and R or L
                table.remove(CurrentSec, table.find(CurrentSec, section))
                table.insert(L, section)
                Sectional = 'L'
                updateSections('R', section); updateSections('L', section);
            end

            function ret:SetRight()
                local CurrentSec = Sectional == 'R' and R or L
                table.remove(CurrentSec, table.find(CurrentSec, section))
                table.insert(R, section)
                Sectional = 'R'
                updateSections('R'); updateSections('L')
            end

            table.insert(RLToggle and R or L, section); updateSections(Sectional)
            RLToggle = not RLToggle

            local sectionalY = 15

            local elements = sections[section].elements
            function ret:Button(name, callback)
                local buttonFrame = newFrame({
                    Filled = true,
                    Size = vector2new(200, 15),
                    Color = fromRGB(17, 17, 17),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(40, 40, 40),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 4
                }, { parent = section, scale = topLeft, offsets = {13, sectionalY + 2} });

                local buttonText = newText({
                    Text = name,
                    Color = fromRGB(200, 200, 200),
                    Size = 14,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5,
                }, { parent = buttonFrame, scale = center, offsets = {0, 0} });

                events:Register("Click", {buttonText, buttonFrame}, function()
                    callback();
                end);

                section.Size = section.Size + vector2new(0, 20);
                sectionalY += 20

                updateSections(Sectional);
                utils:UpdatePositions();
                table.insert(elements, {
                    frame = buttonFrame,
                    text = buttonText
                });
            end

            function ret:Slider(name, min, max, default, callback, nofill)
                local sliderFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(17, 17, 17),
                    Size = vector2new(200, 30),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 4
                }, { parent = section, scale = topLeft, offsets = {13, sectionalY} });
                local title = newText({
                    Text = string.format("%s | %s", name, default),
                    Size = 14,
                    Color = colorScheme,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = sliderFrame, scale = topLeft, offsets = {0, 0} });
                local sliderBounds = newFrame({
                    Filled = true,
                    Color = fromRGB(25, 25, 25),
                    Size = vector2new(200, 10),
                    Outlined = true,
                    OutlineColor = fromRGB(40, 40, 40),
                    OutlineThickness = 1,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = sliderFrame, scale = topLeft, offsets = {0, 20} });
                local slider = newFrame({
                    Filled = true,
                    Color = colorScheme,
                    Size = vector2new(200, 10),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 6
                }, { parent = sliderFrame, scale = topLeft, offsets = {0, 20} });

                local range = max - min
                local offset = (default - min) / range * sliderBounds.Size.X
                slider.Size = vector2new(offset, 10);

                events:Register("Press", {slider, sliderBounds}, function()
                    local size = sliderBounds.Size.X
                    local pos = sliderBounds.Position.ScreenPos.X + size / 2
                    local offset = size - math.abs(math.clamp(mouse.X - pos, -size, 0)) + min;
                    
                    local value = math.floor(offset / size * (max - min));
                    slider.Size = vector2new(offset, slider.Size.Y);
                    title.Text = string.format("%s | %s", name, value);
                    callback(value);
                    utils:UpdatePositions();
                end);

                section.Size = section.Size + vector2new(0, 35);
                sectionalY += 35

                updateSections(Sectional);
                utils:UpdatePositions();
                table.insert(elements, {
                    frame = sliderFrame,
                    text = title,
                    slider = slider,
                    sliderBounds = sliderBounds
                });
            end

            function ret:Toggle(name, default, callback)
                local toggleFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(17, 17, 17),
                    Size = vector2new(200, 20),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 4,
                }, { parent = section, scale = topLeft, offsets = {13, sectionalY} });
                local toggleTitle = newText({
                    Size = 14,
                    Text = name,
                    Color = default and color3new(1, 1, 1) or fromRGB(150, 150, 150),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = toggleFrame, scale = centerLeft, offsets = {22, 0} });
                local statusFrame = newFrame({
                    Filled = true,
                    Size = vector2new(15, 15),
                    Color = default and colorScheme or fromRGB(22, 22, 22),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(40, 40, 40),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = toggleFrame, scale = topLeft, offsets = {0, 3} })

                local toggled = default
                events:Register("Click", {statusFrame, toggleTitle, toggleFrame}, function()
                    toggled = not toggled
                    callback(toggled);
                    statusFrame.Color = toggled and colorScheme or fromRGB(22, 22, 22);
                    toggleTitle.Color = toggled and color3new(1, 1, 1) or fromRGB(150, 150, 150);
                end);

                section.Size = section.Size + vector2new(0, 22);
                sectionalY += 22

                updateSections();
                utils:UpdatePositions();
                table.insert(elements, {
                    frame = toggleFrame,
                    title = toggleTitle,
                    status = statusFrame
                });
            end

            function ret:Dropdown(name, default, list, callback)
                local dropdownFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(17, 17, 17),
                    Size = vector2new(200, 35),
                    Outlined = true,
                    OutlineColor = fromRGB(17, 17, 17),
                    OutlineThickness = 1,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 4
                }, { parent = section, scale = topLeft, offsets = {13, sectionalY} });
                local dropdownTitle = newText({
                    Size = 14,
                    Text = name,
                    Color = fromRGB(200, 200, 200),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = dropdownFrame, scale = topLeft, offsets = {0, 0} });
                local dropdownButton = newFrame({
                    Filled = true,
                    Color = fromRGB(20, 20, 20),
                    Size = vector2new(200, 15),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(40, 40, 40),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = dropdownFrame, scale = topLeft, offsets = {1, 20} });
                local dropdownButtonText = newText({
                    Color = colorScheme,
                    Text = default,
                    Size = 15,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 6
                }, { parent = dropdownButton, scale = center, offsets = {0, 0}});
                local dropdown = newFrame({
                    Filled = true,
                    Size = vector2new(200, 0),
                    Color = fromRGB(17, 17, 17),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(40, 40, 40),
                    Visible = false,
                    ZIndex = 7,
                }, { parent = dropdownFrame, scale = topLeft, offsets = {1, 37}});
                local scrollBar = newFrame({
                    Filled = true,
                    Size = vector2new(1, 0),
                    Color = colorScheme,
                    Visible = false,
                    ZIndex = 11
                }, { parent = dropdown, scale = topRight, offsets = {0, 0} });

                local updateScroll = function()
                    local dropdownPos = dropdown.Position.ScreenPos
                    local rect = Rect.new(dropdownPos - Vector2.new(dropdown.Size.X, 0), dropdownPos + dropdown.Size);
                    for i = 1, 3 do
                        setcliprect(dropdown.ZIndex + i, rect);
                    end
                    utils:UpdatePositions();
                end

                local dropElements = {};
                local dropToggle = false
                local updateDropdown = function(list)
                    local added = 0
                    local lastSelected, lastSelectedText;

                    for index, element in pairs(list) do
                        local elementFrame = newFrame({
                            Filled = true,
                            Color = fromRGB(20, 20, 20),
                            Size = vector2new(200, 20);
                            Outlined = true,
                            OutlineThickness = 1,
                            OutlineColor = fromRGB(30, 30, 30),
                            Visible = false,
                            ZIndex = 8
                        }, { parent = dropdown, scale = topLeft, offsets = {0, added * 20} });
                        local elementTitle = newText({
                            Text = tostring(element),
                            Size = 14,
                            Color = fromRGB(175, 175, 175),
                            Visible = false,
                            ZIndex = 10
                        }, { parent = elementFrame, scale = center, offsets = {0, 0} });

                        events:Register("Click", {elementFrame, elementTitle}, function()
                            callback(element);
                            dropdownButtonText.Text = tostring(element);
                            lastSelected, lastSelectedText = elementFrame, elementTitle
                            if (lastSelected) then
                                lastSelectedText.Color = fromRGB(175, 175, 175);
                            end

                            dropToggle = not dropToggle
                            dropdown.Size = vector2new(200, dropToggle and 200 or 0);
                            dropdown.Visible = dropToggle
                            utils:SetAllVisible(dropElements, dropToggle);
                            updateScroll();
                        end);

                        added += 1
                        table.insert(dropElements, {elementFrame, elementTitle});
                    end
                end

                local onDrop = function()
                    dropToggle = not dropToggle
                    dropdown.Size = vector2new(200, dropToggle and math.min(#dropElements * 20, 200) or 0);
                    dropdown.Visible = dropToggle

                    -- removed until i fix scaling
                    -- scrollBar.Size = vector2new(2, dropToggle and math.clamp(#dropElements * 20, 0, 180) or 0);
                    -- scrollBar.Visible = dropToggle
                    updateScroll();

                    local dropdownPos = dropdown.Position.ScreenPos
                    for i, element in pairs(dropElements) do
                        local elementFrame, elementTitle = element[1], element[2]
                        local pos = elementFrame.Position.ScreenPos
                        local visible = pos.Y < dropdownPos.Y + dropdown.Size.Y / 2
                        elementFrame.Visible = visible
                        elementTitle.Visible = visible
                    end
                end
                local dropdownScroll = function(z)
                    local absv = math.abs(z);
                    local scrollingUp = absv == z
                    local dropdownPos = dropdown.Position.ScreenPos
                    local scrollAmount = scrollingUp and 7 or -7

                    for i, element in pairs(dropElements) do
                        local elementFrame, elementTitle = element[1], element[2]
                        local pos = elementFrame.Position.ScreenPos
                        local visible = pos.Y > dropdownPos.Y - dropdown.Size.Y / 2 - 10
                        if (scrollingUp) then
                            if (i == 1 and pos.Y > dropdownPos.Y - dropdown.Size.Y / 2 + 8) then
                                break;
                            end
                        end
                        if (not scrollingUp) then
                            local lastElement = dropElements[#dropElements]
                            local pos = lastElement[1].Position.ScreenPos
                            local visible = pos.Y < dropdownPos.Y + dropdown.Size.Y / 2 - 8
                            if (visible) then
                                break;
                            end
                        end
                        local offsets = utils:GetOffsets(elementFrame);
                        utils:UpdateOffsets(elementFrame, {offsets[1], offsets[2] +  scrollAmount});
                        local scrolloffsets = utils:GetOffsets(scrollBar);
                        utils:UpdateOffsets(scrollBar, {scrolloffsets[1], math.clamp(scrolloffsets[2] - scrollAmount , 0, 200 - scrollBar.Size.Y)});
                        elementFrame.Visible = visible
                        elementTitle.Visible = visible
                    end
                    utils:UpdatePositions();
                end
                events:Register("Scroll", dropdown, dropdownScroll);
                events:Register("Press", scrollBar, function(up)
                    dropdownScroll(up and 1 or -1);
                end);

                events:Register("Click", {dropdownButton, dropdownButtonText}, onDrop);
                table.insert(onTabSwitched, function(tab)
                    if (tab == tabName) then
                        dropToggle = not dropToggle
                        onDrop();
                    end
                end);
                updateDropdown(list);

                section.Size = section.Size + vector2new(0, 40);
                sectionalY += 40

                updateSections(Sectional);
                utils:UpdatePositions();
                table.insert(elements, {
                    frame = dropdownFrame,
                    title = dropdownTitle,
                    dropButton = dropdownButton,
                    dropButtonText = dropdownButtonText,
                    dropElements = dropElements
                });
            end

            function ret:UserInput(name, default, callback)
                local userInputFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(17, 17, 17),
                    Size = vector2new(200, 20),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(17, 17, 17),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 4
                }, { parent = section, scale = topLeft, offsets = {13, sectionalY} });
                local userInputTitle = newText({
                    Text = name,
                    Color = fromRGB(200, 200, 200),
                    Size = 14,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = userInputFrame, scale = topLeft, offsets = {0, 0} });
                local inputBoxFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(17, 17, 17),
                    Size = Vector2.new(115, 15),
                    Outlined = true,
                    OutlineColor = fromRGB(40, 40, 40),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 6
                }, { parent = userInputFrame, scale = topLeft, offsets = {85, 3} });
                local inputBoxText = newText({
                    Text = default,
                    Size = 15,
                    Color = colorScheme,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 7
                }, { parent = inputBoxFrame, scale = center, offsets = {0, 0} });

                events:Register("Click", {inputBoxFrame, inputBoxText}, function()
                    inputBoxText.Text = ""
                    
                    focusInputText = function(k)
                        inputBoxText.Text ..= k
                        callback(inputBoxText.Text);
                    end
                end);

                section.Size = section.Size + vector2new(0, 23);
                sectionalY += 23

                updateSections();
                utils:UpdatePositions();
                table.insert(elements, {
                    frame = userInputFrame,
                    title = userInputTitle,
                    inputBox = inputBoxFrame,
                    inputBoxText = inputBoxText
                });
            end

            function ret:Keybind(name, defaultKey, callback)
                local keybindFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(17, 17, 17),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(17, 17, 17),
                    Size = vector2new(200, 15),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 4
                }, { parent = section, scale = topLeft, offsets = {13, sectionalY} });
                local title = newText({
                    Color = fromRGB(200, 200, 200),
                    Text = name,
                    Size = 14,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = keybindFrame, scale = topLeft, offsets = {0, 0} });
                local currentKey = newText({
                    Text = string.format("[%s]", tostring(string.split(tostring(defaultKey), ".")[3])),
                    Color = colorScheme,
                    Size = 14,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5,
                }, { parent = keybindFrame, scale = centerRight, offsets = {0, 0} });

                events:Register("Click", currentKey, function()
                    currentKey.Text = "[...]"
                    utils:UpdatePositions();
                    focusInputRaw = function(key)
                        currentKey.Text = string.format("[%s]", tostring(string.split(tostring(key.KeyCode), ".")[3]));
                        focusInputRaw = nil
                        utils:UpdatePositions();
                    end
                end);
                section.Size = section.Size + vector2new(0, 15);
                sectionalY += 15

                updateSections();
                utils:UpdatePositions();
                table.insert(elements, {
                    frame = keybindFrame,
                    title = title,
                    currentKey = currentKey
                });
            end

            function ret:Colorpicker(name, defaultColor, callback)
                local colorpickerFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(17, 17, 17),
                    Size = Vector2.new(200, 20),
                    Outlined = true,
                    OutlineColor = fromRGB(17, 17, 17),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 4
                }, { parent = section, scale = topLeft, offsets = {13, sectionalY } });
                local colorPickerTitle = newText({
                    Text = name,
                    Color = fromRGB(200, 200, 200);
                    Size = 14,
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = colorpickerFrame, scale = topLeft, offsets = {0, 0} });
                local statusColor = newFrame({
                    Filled = true,
                    Color = defaultColor or fromRGB(255, 255, 255),
                    Size = Vector2.new(15, 15),
                    Visible = tabsVisible[mainTab],
                    ZIndex = 5
                }, { parent = colorpickerFrame, scale = topLeft, offsets = {185, 3} });
                
                local mainPicker = newFrame({
                    Filled = true,
                    Color = fromRGB(20, 20, 20),
                    Size = vector2new(210, 237),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(40, 40, 40),
                    Visible = false,
                    ZIndex = 7
                }, { parent = colorpickerFrame, scale = topLeft, offsets = {210, 0} });
                local colors = newImage({
                    Image = ImageRef.new(gradient),
                    Size = Vector2.new(174, 175),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(20, 20, 20),
                    Visible = false,
                    ZIndex = 8
                }, { parent = mainPicker, scale = topLeft, offsets = {5, 5} });
                local hueSlider = newFrame({
                    Filled = true,
                    Color = fromRGB(255, 255, 255),
                    Size = Vector2.new(20, 175),
                    Outlined = true,
                    OutlineThickness = 1,
                    OutlineColor = fromRGB(20, 20, 20),
                    Visible = false,
                    ZIndex = 9
                }, { parent = mainPicker, scale = topLeft, offsets = {185, 5} });
                local chosenColor = newFrame({
                    Filled = true,
                    Size = Vector2.new(20, 20),
                    Color = defaultColor or  color3new(),
                    Visible = false,
                    ZIndex = 9
                }, { parent = mainPicker, scale = topLeft, offsets = {185, 185} });
                local hexFrame = newFrame({
                    Filled = true,
                    Size = vector2new(174, 20),
                    Color = fromRGB(20, 20, 20),
                    Outlined = true,
                    OutlineColor = fromRGB(20, 20, 20),
                    OutlineThickness = 1,
                    Visible = false,
                    ZIndex = 9
                }, { parent = mainPicker, scale = topLeft, offsets = {5, 185} });
                local hexTitle = newText({
                    Size = 14,
                    Text = "Hex",
                    Color = fromRGB(200, 200, 200),
                    Visible = false,
                    ZIndex = 9
                }, { parent = hexFrame, scale = topLeft, offsets = {0, 0} });
                local hexValueHolder = newFrame({
                    Filled = true,
                    Color = fromRGB(20, 20, 20),
                    Outlined = true,
                    OutlineColor = fromRGB(40, 40, 40),
                    OutlineThickness =  1,
                    Size = vector2new(140, 20),
                    Visible = false,
                    ZIndex = 9
                }, { parent = hexFrame, scale = topLeft, offsets = {33, 0} });
                local hexValueText = newText({
                    Text = "  #" .. (defaultColor and defaultColor:ToHex() or "  #FFFFFF"),
                    Color = fromRGB(175, 175, 175),
                    Size = 14,
                    Visible = false,
                    ZIndex = 10
                }, { parent = hexValueHolder, scale = topLeft, offsets = {0, 0} });

                local rValueFrame = newFrame({
                    Filled = true,
                    Size = Vector2.new(45, 15),
                    Color = fromRGB(20, 20, 20);
                    OutlineColor = fromRGB(40, 40, 40),
                    OutlineThickness = 1,
                    Outlined = true,
                    Visible = false,
                    ZIndex = 9
                }, { parent = mainPicker, scale = topLeft, offsets = {5, 215} });
                local rValueText = newText({
                    Text = defaultColor and tostring(math.floor(defaultColor.R)) or "255",
                    Color = color3new(1, 0, 0);
                    Size = 14,
                    Visible = false,
                    ZIndex = 10
                }, { parent = rValueFrame, scale = center, offsets = {0, 0} });
                local gValueFrame = newFrame({
                    Filled = true,
                    Size = Vector2.new(45, 15),
                    Color = fromRGB(20, 20, 20);
                    OutlineColor = fromRGB(40, 40, 40),
                    OutlineThickness = 1,
                    Outlined = true,
                    Visible = false,
                    ZIndex = 9
                }, { parent = mainPicker, scale = topLeft, offsets = {105, 215} });
                local gValueText = newText({
                    Text = defaultColor and tostring(math.floor(defaultColor.G)) or "255",
                    Color = color3new(0, 1, 0);
                    Size = 14,
                    Visible = false,
                    ZIndex = 10
                }, { parent = gValueFrame, scale = center, offsets = {0, 0} });
                local bValueFrame = newFrame({
                    Filled = true,
                    Size = Vector2.new(45, 15),
                    Color = fromRGB(20, 20, 20);
                    OutlineColor = fromRGB(40, 40, 40),
                    OutlineThickness = 1,
                    Outlined = true,
                    Visible = false,
                    ZIndex = 9
                }, { parent = mainPicker, scale = topLeft, offsets = {55, 215} });
                local bValueText = newText({
                    Text = defaultColor and tostring(math.floor(defaultColor.B)) or "255",
                    Color = color3new(0, 0, 1);
                    Size = 14,
                    Visible = false,
                    ZIndex = 10
                }, { parent = bValueFrame, scale = center, offsets = {0, 0} });
                local rainbowFrame = newFrame({
                    Filled = true,
                    Color = fromRGB(25, 25, 25),
                    Size = Vector2.new(50, 15),
                    Outlined = true,
                    OutlineColor = fromRGB(40, 40, 40),
                    OutlineThickness = 1,
                    Visible = false,
                    ZIndex = 9,
                }, { parent = mainPicker, scale = topLeft, offsets = {155, 215} });
                local rainbowText = newText({
                    Text = "Rainbow",
                    Size = 14,
                    Color = fromRGB(175, 175, 175),
                    Visible = false,
                    ZIndex = 10
                }, { parent = rainbowFrame, scale = center, offsets = {0, 0} });



                local colorPickerElems = {mainPicker, colors, hueSlider, chosenColor, hexFrame, hexTitle, hexValueHolder, hexValueText, rValueFrame, rValueText, gValueText, gValueFrame, bValueText, bValueFrame, rainbowFrame, rainbowText};
                events:Register("Click", {statusColor}, function()
                    utils:SetAllVisible(colorPickerElems, not mainPicker.Visible);
                    mainPicker.Position = Point2D.new(vector2new(mainPicker.Size.X / 2 + mouse.X + 5, mouse.Y + mainPicker.Size.Y / 2 + 20));
                    utils:UpdatePositions();
                end);
                
                sectionalY += 20
                section.Size = section.Size + vector2new(0, 20);
                updateSections();
                utils:UpdatePositions();

                table.insert(elements, {
                    colorpickerFrame = colorpickerFrame,
                    colorPickerTitle = colorPickerTitle,
                    statusColor = statusColor,
                    colorPickerElems
                });

            end

            return ret;
        end
        return ret;
    end
    return ret;
end

-- if (not isfile("cursor.png")) then
--     writefile("cursor.png", game:HttpGet("https://assets.webiconspng.com/uploads/2017/09/Cursor-PNG-Image-67490-300x300.png"));
-- end

local UI = UILib:CreateWindow("nig hub", "test", fromRGB(255, 238, 0), defaultFont);

local UISettings = UI:Tab("Settings");

local colors = UISettings:Section("Colors");
colors:Button("Invert Colors", function()
    for ZIndex, objects in pairs(drawings) do
        for i, object in pairs(objects) do
            local drawing = object[1]
            local drawingColor = drawing.Color
            drawing.Color = color3new(1 - drawingColor.R, 1 - drawingColor.G, 1 - drawingColor.B);
        end
    end
end);

colors:Colorpicker("Color scheme", fromRGB(255, 238, 0), function()
    
end);

local uiFonts = UISettings:Section("Fonts");
local fontCache = {};
uiFonts:Dropdown("Active Font", "NotoSans_Regular", {unpack(Font.ListDefault())}, function(newFont)
    task.spawn(function()
        local sizeCache = fontCache[newFont] or {};
        for ZIndex, objects in pairs(drawings) do
            for i, object in pairs(objects) do
                local drawing = object[1]
                if (typeof(drawing) == "TextDynamic") then
                    local textSize = drawing.Size
                    local font = sizeCache[textSize] or Font.RegisterDefault(newFont, {
                        PixelSize = drawing.Size
                    });
                    drawing.Font = font
                    if (not sizeCache[textSize]) then
                        sizeCache[textSize] = font
                    end
                end
            end
        end
        utils:UpdatePositions();

        fontCache[newFont] = sizeCache
    end);
end);

wait(10);
ContextActionService:UnbindCoreAction("FH_Mouse");
ContextActionService:UnbindCoreAction("FH_Keyboard");
for i, v in pairs(drawings) do
    for i2, v2 in pairs(v) do
        v2[1].Visible = false
    end
end