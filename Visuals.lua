if (not flagSet) then
    setfflag("RenderHighlightPass3", "True");
    getgenv().flagSet = true
end

local Visuals = {};
Visuals.__index = Visuals

local DrawUtils = {};
DrawUtils.__index = DrawUtils

local color3New = Color3.new
local fromRGB = Color3.fromRGB
local cframeNew = CFrame.new
local vector3New = Vector3.new
local currentCamera = workspace.CurrentCamera
local viewportSize = currentCamera.ViewportSize

function DrawUtils:SetVisible(object, visible)
    object.Visible = visible
end

function DrawUtils:SetProperties(object, properties)
    for i, v in pairs(properties) do
        object[i] = v
    end
end

function Visuals.new()
    Visuals.Objects = {
        Line = {},
        Text = {},
        Box = {},
        Chams = {},
        Circle = {}
    };
    return setmetatable({}, Visuals);
end

function Visuals:Add(object)
    assert(typeof(object) == 'Instance');
    local pInstance = PointInstance.new(object);
    Visuals.Objects[pInstance] = {};
    local objectDrawings = Visuals.Objects[pInstance]
    local defaultColor = color3New(1, 1, 1);
    local defaultColorSecondary = color3New();

    local DrawEntry = {};
    DrawEntry.__index = DrawEntry
    function DrawEntry:AddText(text, options)
        options = options or {};

        local textDynamic = TextDynamic.new();
        textDynamic.Position = PointInstance.new(object, options.Offset and CFrame.new(Vector3.new(unpack(options.Offset))))
        options.Offset = nil
        DrawUtils:SetProperties(textDynamic, options);
        textDynamic.Text = text
        textDynamic.Color = options.Color or defaultColor
        textDynamic.Outlined = options.Outlined or true   
        textDynamic.OutlineColor = options.OutlineColor or defaultColorSecondary
        textDynamic.Size = options.Size or 16

        table.insert(objectDrawings, textDynamic);
        table.insert(Visuals.Objects.Text, textDynamic);
        return textDynamic;
    end

    function DrawEntry:AddTracer(from, options)
        options = options or {};
        from = from or Point2D.new(viewportSize.X / 2, viewportSize.Y);

        local lineDynamic = LineDynamic.new();
        lineDynamic.To = PointInstance.new(object, options.Offset and CFrame.new(Vector3.new(unpack(options.Offset))))
        options.Offset = nil
        DrawUtils:SetProperties(lineDynamic, options);
        lineDynamic.Color = options.Color or defaultColor
        lineDynamic.Opacity = options.Opacity or 1
        lineDynamic.Thickness = options.Thickness or 1.6 

        lineDynamic.From = from

        table.insert(objectDrawings, lineDynamic);
        table.insert(Visuals.Objects.Line, lineDynamic);
        return lineDynamic;
    end

    function DrawEntry:Add2DBox(tPoint, bPoint, options)
        options = options or {};
        local objectSize = object.Size
        tPoint = PointInstance.new(object, cframeNew(tPoint or vector3New(objectSize.X, objectSize.Y, 0)));
        bPoint = PointInstance.new(object, cframeNew(bPoint or vector3New(-objectSize.X, -objectSize.Y, 0)));
        tPoint.RotationType = CFrameRotationType.CameraRelative
        bPoint.RotationType = CFrameRotationType.CameraRelative

        local rectDynamic = RectDynamic.new(tPoint, bPoint);
        DrawUtils:SetProperties(rectDynamic, options);
        rectDynamic.Thickness = options.Thickness or 1
        rectDynamic.Color = options.Color or defaultColor
        rectDynamic.Outlined = options.Outlined or true
        rectDynamic.OutlineColor = options.OutlineColor or defaultColorSecondary 
        rectDynamic.Filled = options.Filled or false

        table.insert(objectDrawings, rectDynamic);
        table.insert(Visuals.Objects.Box, rectDynamic);
        return rectDynamic;
    end

    function DrawEntry:Add3DBox(pos, options)
        options = options or {};
    end

    function DrawEntry:AddCircle(size, options)
        options = options or {};

        local circleDynamic = CircleDynamic.new(options.Offset);
        options.Offset = nil
        DrawUtils:SetProperties(circleDynamic, options);
        circleDynamic.Radius = size
        circleDynamic.Color = options.Color or defaultColor
        circleDynamic.Thickness = options.Thickness or .1
        circleDynamic.Opacity = options.Opacity or 1
        circleDynamic.Position = pInstance

        table.insert(Visuals.Objects.Circle, circleDynamic);
        table.insert(objectDrawings, circleDynamic);
        return circleDynamic;
    end

    function DrawEntry:AddChams(color, options)
        options = options or {};

        local highlight = Instance.new("Highlight");
        DrawUtils:SetProperties(highlight, options);
        highlight.FillColor = color or defaultColor
        highlight.Adornee = options.Adornee or object
        highlight.Parent = gethui();
        local proxy = setmetatable({_INSTANCE=highlight}, {
            __newindex = function(self, prop, value)
                if (prop == "Visible") then
                    highlight.Enabled = value
                end
            end,
            __index = function(self, prop)
                return highlight[prop]
            end
        });

        table.insert(Visuals.Objects.Chams, proxy);
        table.insert(objectDrawings, proxy);
        return proxy;
    end

    function DrawEntry:Destroy()
        for i, drawing in pairs(objectDrawings) do
            local type = type(drawing);
			if (type == "table") then
                drawing.Adornee = nil
                continue;
            elseif (type ~= "string") then
				DrawUtils:SetVisible(drawing, false);
				objectDrawings[i] = nil
			end
        end
    end

    function DrawEntry:Get(drawingType)
        if (not drawingType) then
            return objectDrawings;
        end
        for i, objdrawing in pairs(objectDrawings) do
            local type = typeof(objdrawing)
            if (type == drawingType) then
                return objdrawing;
            end
            if (type == "table" and drawingType == "Chams") then
                return objdrawing;
            end
        end
    end

    return DrawEntry;
end

function Visuals:Render()
    for pInstance, drawingsForObject in pairs(Visuals.Objects) do
        for i, drawing in pairs(drawingsForObject) do
            DrawUtils:SetVisible(drawing, true);
        end
    end
end

function Visuals:SetProperties(obj, props)
    if (type(obj) == "table") then
        for i, object in pairs(obj) do
            local drawingsForObject = Visuals.Objects[object]
            for _, drawing in pairs(drawingsForObject) do
                for i2, value in pairs(props) do
                    drawing[i2] = value
                end
            end
        end
    else
        local drawingsForObject = Visuals.Objects[obj]
        for i, drawing in pairs(drawingsForObject) do
            for i2, value in pairs(props) do
                drawing[i2] = value
            end
        end
    end
end

function Visuals:Destroy()
    for pInstance, drawingsForObject in pairs(Visuals.Objects) do
        for i, drawing in pairs(drawingsForObject) do
            if (type(drawing) == "table") then
                drawing.Adornee = nil
            end
            DrawUtils:SetVisible(drawing, false);
            drawingsForObject[i] = nil
        end
        drawingsForObject[pInstance] = nil
    end
end


return Visuals;

-- local Visuals = Visuals.new();
-- local Drawing = Visuals:Add(game.Players.LocalPlayer.Character.HumanoidRootPart);
-- Drawing:AddText("Name", {
--     Offset = {0, 3}
-- });

-- wait(3);

-- Drawing:Destroy();