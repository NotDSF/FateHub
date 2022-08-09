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

local emptyCFrame = CFrame.new();

function Visuals.new(object, offset)
    local self = {
        drawings = {},
        defaults = {
            Color = Color3.new(1, 1, 1),
            OutlineColor = Color3.new(1, 1, 1),
            Size = 16,
            Visible = true,
            Thickness = 1,
            Filled = false
        }
    };

    local objectType = typeof(object);
    self.object = object
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

function Visuals:SetDefaults(drawing)
    local __newindex = getrawmetatable(drawing).__newindex
    for property, value in self.defaults do
        pcall(__newindex, property, value);
    end
    return drawing;
end

function Visuals:AddDrawing(drawing)
    local drawings = self.drawings
    drawings[#drawings + 1] = drawing
    return drawing;
end

function Visuals:AddText(text, properties)
    local Text = DrawUtils:Create(TextDynamic, properties or {});
    Text.Position = self.basePoint
    Text.Text = text

    self:SetDefaults(Text);
    self:AddDrawing(Text);

    return Text;
end

function Visuals:AddTracer(from, properties)
    local Line = DrawUtils:Create(LineDynamic, properties or {});
    Line.From = from or Point2D.new(viewportSize.X / 2, viewportSize.Y);
    Line.To = self.basePoint

    self:SetDefaults(Line);
    self:AddDrawing(Line);

    return Line;
end

function Visuals:Add2DBox(object, offset1, offset2, properties)
    object = object or self.object
    if (typeof(object) == "Instance" and object:IsA("Part")) then
        local objectSize = object.Size

        local tPoint = PointInstance.new(object, offset1 or CFrame.new(objectSize.X, objectSize.Y, 0));
        local bPoint = PointInstance.new(object, offset2 or CFrame.new(-objectSize.X, -objectSize.Y, 0));
        tPoint.RotationType = CFrameRotationType.CameraRelative
        bPoint.RotationType = CFrameRotationType.CameraRelative

        local _Rect = DrawUtils:Create(RectDynamic, properties or {}, tPoint, bPoint);

        self:SetDefaults(_Rect);
        self:AddDrawing(_Rect);

        return _Rect, tPoint, bPoint;
    end
end

function Visuals:AddHealthBar(character, root, humanoid, colourA, colorB, filled)
    local characterSize = character:GetExtentsSize();

    local offset1 = CFrame.new(characterSize.X / 2 + .5, characterSize.Y / 2, 0);
    local offset2 = CFrame.new(characterSize.X / 2 + 1, -characterSize.Y / 2, 0);

    local healthBarOutline, tPoint, bPoint = self:Add2DBox(root, offset1, offset2, {
        Color = colourA,
        OutlineColor = Color3.new(1, 1, 1),
        OutlineThickness = 2,
        ZIndex = 2,
        Filled = filled or false
    });
    local healthBarHealth, tPoint1 = self:Add2DBox(root, offset1, offset2, {
        Color = colorB
    });
	
	if (not healthBarHealth or not healthBarOutline) then
		return;
	end

    healthBarHealth.Filled = true

    if (filled) then
        tPoint.Offset = CFrame.new(characterSize.X / 2 + .1, characterSize.Y / 2 + .1, 0);
        bPoint.Offset = CFrame.new(characterSize.X / 2 + .1, -characterSize.Y / 2 + .1, 0);
        healthBarOutline.ZIndex = 1
    end

    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        local newHealth, maxHealth = humanoid.Health, humanoid.MaxHealth
        local percentage = newHealth / maxHealth
        local max = offset1.Y
        local newSize = (max * 2) * percentage - max
        tPoint1.Offset = CFrame.new(offset1.X, newSize, 0);
    end);
end

function Visuals:Destroy()
    for i, drawing in pairs(self.drawings) do
        drawing.Visible = false
    end
    table.clear(self.drawings);
end

return Visuals;