local currentCamera = workspace.CurrentCamera
local viewportSize = currentCamera.ViewportSize

local Visuals = {};
Visuals.__index = Visuals

local DrawUtils = {};
DrawUtils.__index = DrawUtils

function DrawUtils:Create(class, properties, ...)
    local object = class.new(...);
    for property, value in properties do
        object[property] = value
    end

    return object;
end

local visualObjects = {};
local allDrawings = {};

local emptyCFrame = CFrame.new();

function Visuals.new(object, offset)
    local self = {
        drawings = {},
        defaults = {
            Color = Color3.new(1, 1, 1),
            Outlined = true,
            OutlineColor = Color3.new(0, 0, 0),
            Size = 17,
            Visible = true,
            Thickness = 1,
            Filled = false
        },
        visualObjects = visualObjects
    };

    local objectType = typeof(object);
    self.object = object
    self.objectType = objectType
    self.baseOffset = offset or emptyCFrame

    if (objectType == "Instance") then
        self.basePoint = PointInstance.new(object, offset or emptyCFrame);
    elseif (objectType == "Vector3") then
        self.basePoint = Point3D.new(object);
    else
        error(string.format("expected type Instance or Vector3, got %s.", objectType));
    end

    visualObjects[object] = self

    return setmetatable(self, Visuals);
end

function Visuals:SetDefaults(drawing, properties)
    local __newindex = getrawmetatable(drawing).__newindex
    for property, value in self.defaults do
        if (properties[property] == nil) then
            pcall(__newindex, drawing, property, value);
        end
    end
    return drawing;
end

function Visuals:MakePosition(offset)
    if (offset) then
        if (self.objectType == "Instance") then
            return PointInstance.new(self.object, self.baseOffset * offset);
        elseif (self.objectType == "Vector3") then
            return Point3D.new(self.object + offset);
        end
    end
    return self.basePoint;
end

function Visuals:AddDrawing(drawing)
    local drawings = self.drawings
    drawings[#drawings + 1] = {
        drawing = drawing,
        type = typeof(drawing)
    };
	allDrawings[#allDrawings + 1] = drawings[#drawings]
    return drawing;
end

function Visuals:AddText(text, properties, offset)
    properties = properties or {};
    local Text = DrawUtils:Create(TextDynamic, properties);
    Text.Position = self:MakePosition(offset);
    Text.Text = text

    self:SetDefaults(Text, properties);
    self:AddDrawing(Text);


    return Text;
end

function Visuals:AddTracer(from, properties, offset)
    properties = properties or {};
    local Line = DrawUtils:Create(LineDynamic, properties);
    Line.From = from or Point2D.new(viewportSize.X / 2, viewportSize.Y);
    Line.To = self:MakePosition(offset);

    self:SetDefaults(Line, properties);
    self:AddDrawing(Line);

    return Line;
end

function Visuals:Add2DBox(object, offset1, offset2, properties)
    properties = properties or {};
    object = object or self.object
    if (typeof(object) == "Instance" and object:IsA("Part") or object:IsA("Model")) then
        local objectSize = object:IsA("Model") and object:GetExtentsSize() or object.Size

        local tPoint = PointInstance.new(object, offset1 or CFrame.new(objectSize.X, objectSize.Y, 0));
        local bPoint = PointInstance.new(object, offset2 or CFrame.new(-objectSize.X, -objectSize.Y, 0));
        tPoint.RotationType = CFrameRotationType.CameraRelative
        bPoint.RotationType = CFrameRotationType.CameraRelative

        local _Rect = DrawUtils:Create(RectDynamic, properties, tPoint, bPoint);

        self:SetDefaults(_Rect, properties);
        self:AddDrawing(_Rect);

        return _Rect, tPoint, bPoint;
    end
end

function Visuals:AddHealthBar(character, root, colourA, colorB, filled, humanoid, size)
    local characterSize = size or character:GetExtentsSize();

    local offset1 = CFrame.new(characterSize.X / 2 + .5, characterSize.Y / 2, 0);
    local offset2 = CFrame.new(characterSize.X / 2 + 1, -characterSize.Y / 2, 0);

    local healthBarOutline, tPoint, bPoint = self:Add2DBox(root, offset1, offset2, {
        Color = colourA,
        OutlineColor = Color3.new(1, 1, 1),
        OutlineThickness = 1,
        Outlined = not not filled,
        Filled = filled or false,
        ZIndex = filled and 1 or 2
    });
    local healthBarHealth, tPoint1 = self:Add2DBox(root, offset1, offset2, {
        Color = colorB,
        Outlined = false,
        Filled = true,
        ZIndex = filled and 2 or 1
    });

    if (not healthBarHealth or not healthBarOutline) then
        return;
    end


    for i, drawingData in pairs(self.drawings) do
        if (drawingData.drawing == healthBarOutline or drawingData.drawing == healthBarHealth) then
            self.drawings[i] = nil
        end
    end

    local updateHealth = function(_self, currentHealth, maxHealth)
        local percentage = currentHealth / maxHealth
        local max = offset1.Y
        local newSize = (max * 2) * percentage - max
        tPoint1.Offset = CFrame.new(offset1.X, newSize, 0);
    end

    local setFilled = function(_self, _filled)
        healthBarOutline.Filled = _filled or false
        healthBarOutline.Outlined = _filled
        healthBarOutline.ZIndex = _filled and 1 or 2

        healthBarHealth.ZIndex = filled and 2 or 1
    end

    if (humanoid) then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            updateHealth(humanoid.Health, humanoid.MaxHealth);
        end);
    end

	local ret = {
        UpdateHealth = updateHealth,
        SetFilled = setFilled,
		healthBarHealth = healthBarHealth,
		healthBarOutline = healthBarOutline
    };

	local drawings = self.drawings
    drawings[#drawings + 1] = {
        drawing = ret,
        type = "HealthBar"
    };

    return ret;
end

function Visuals:Destroy()
    for i, drawingData in pairs(self.drawings) do
        drawingData.drawing.Visible = false
    end
    table.clear(self.drawings);
end

function Visuals:GetDrawings(drawingType, first)
    local results = {};
    for i, drawingData in pairs(self.drawings) do
        if (drawingType == nil or drawingType == drawingData.type) then
            results[#results + 1] = drawingData.drawing
        end
    end

    return first and results[1] or results;
end

function Visuals:GetAllDrawings()
    return allDrawings;
end

function Visuals:SetProperties(drawingType, values)
	local t = type(drawingType) == "table";
	for i, drawingData in pairs(self.drawings) do
        if (drawingType == nil or drawingType == drawingData.type or (t and table.find(drawingType, drawingData.type))) then
            for property, value in pairs(values) do
                drawingData.drawing[property] = value
            end
        end
    end
end

function Visuals:SetAllProperties(drawingType, values)
	local t = type(drawingType) == "table";
    for i, drawingData in pairs(allDrawings) do
		local _type = drawingData.type
        if ((drawingType == nil or drawingType == _type or (t and table.find(drawingType, type))) and not t == "HealthBar") then
            for property, value in pairs(values) do
                drawingData.drawing[property] = value
            end
        end
    end
end

--[[
local players = game:GetService("Players"):GetPlayers();

local localplayer = game.Players.LocalPlayer
for i, player in pairs(players) do
    if (player.Character and player ~= localplayer) then
        local character = player.Character
        local root = character:FindFirstChild("HumanoidRootPart");
        local Visual = Visuals.new(root, CFrame.new(0, 4, 0));
        Visual:AddText(player.Name);
        Visual:AddTracer(nil, nil, CFrame.new(0, -2, 0));
        Visual:AddHealthBar(character, root, Color3.new(1, 1, 1), Color3.new(0, 1, 0), false, character.Humanoid);
        local size = character:GetExtentsSize();
        Visual:Add2DBox(root, CFrame.new(size.X / 2, size.Y / 2, 0), CFrame.new(-size.X / 2, -size.Y / 2, 0));
    end
end]]

return Visuals;