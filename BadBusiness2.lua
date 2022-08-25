local UI = loadfile("UILibrary.lua")();
local Visuals = loadfile("Visuals.lua")();
local protectInstance = loadfile("protectinstance.lua")();

if (not game:IsLoaded()) then
    game.Loaded:Wait();
end

local GetService = game.GetService
local services = setmetatable({}, {
    __index = function(self, serviceName)
        local good, service = pcall(GetService, game, serviceName);
        if (good) then
            self[serviceName] = service
            return service;
        end
    end,
    __mode = "v"
});

local Workspace = services.Workspace
local currentCamera = Workspace.currentCamera
local worldtoscreen = currentCamera.WorldToScreenPoint
local viewportSize = currentCamera.ViewportSize
local ReplicatedStorage = services.ReplicatedStorage
local UserInputService = services.UserInputService
local Players = services.Players
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse();

local findFirstChild = game.FindFirstChild
local waitForChild = game.WaitForChild
local findPartOnRayWithIgnoreList = Workspace.FindPartOnRayWithIgnoreList
local GetPartsObscuringTarget = currentCamera.GetPartsObscuringTarget

local cframenew = CFrame.new
local cframe_angles = CFrame.Angles
local vector3new = Vector3.new
local vector2new = Vector2.new
local color3new = Color3.new
local fromRGB = Color3.fromRGB
local wait = task.wait
local split = string.split
local format = string.format
local floor = math.floor
local rad = math.rad
local random = math.random
local create = table.create
local tfind = table.find
local insert = table.insert
local IsA = game.IsA

local settings = { -- yes this is kinda retarded ik
    gunmods = {
        no_recoil = false,
        instant_scope = false,
        instant_reload = false,
        no_wep_shake = false,
        fire_mode = nil,
        fire_rate = 750
    },

    fov = {
        fov_enabled = false,
        fov_color = color3new(1, 1, 1),
        fov_radius = 150,
        snaplines_enabled = false,
        snaplines_color = color3new(1, 1, 1),
        snaplines_color_visible = true
    },

    aimbot = {
        aimbot_enabled = false,
        aimlock_key = Enum.UserInputType.MouseButton2,
        smoothness = 1,
        lock_on = "Head",
        closest_cursor = true,
        closest_player = false,
        triggerbot = false,
        triggerbotMS = 0,
    },

    backtrack = {
        backtrack = false,
        backtrackMS = 500,
        show_backtrack = false,
        backtrack_color = color3new(1, 0, 0),
        backtrack_redirect = "Chest",
    },

    character = {
        weapon_color = color3new(1, 0, 0),
        weapon_material = "SmoothPlastic",
        color_weapon = false,
        arms_color = color3new(1, 0, 0),
        arm_material = "SmoothPlastic",
        color_arm = false,
        third_person = false,
        third_person_values = {1, 2, 10};
    },

    movement = {
        auto_strafe = false,
        bhop = false,
        walkspeed = 16,
        jumppower = 50,
    },

    rage = {
        kill_aura = false,
        rage_bot = false,
        auto_shoot = false,
        silent_aim = false,
        wall_check = true,
        wallbang = false,
        redirect = "Head"
    },

    esp = {
        enabled = true,
        names_enabled = true,
        distance_enabled = true,
        health_enabled = true,
        healthbar_enabled = true,
        esp_transparency = 1,
        chams_enabled = false,
        chams_color = color3new(1, 0, 0),
        chams_outline = true,
        chams_outline_color = color3new(1, 1, 1),
        tracers_enabled = false,
        tracer_color = fromRGB(20, 226, 207),
        box_esp = false,
        box_color = fromRGB(20, 226, 207),
        team_colors = true,
        thickness = 1.5,
        tracer_thickness = 1.6,
        transparency = .9,
        tracer_transparency = .7,
        size = 16,
        render_distance = 9e9,
        color = fromRGB(20, 226, 207),
        outline_color = color3new(),
        tracer_to = "Head",
        show_team = "Enemies",
        show_teams = {},
        bullet_tracers = false,
        bullet_tracer_color = Color3.fromRGB(1, 0, 0)
    }
};
local espSettings = settings.esp
local characterSettings = settings.character
local aimbotSettings = settings.aimbot
local rageSettings = settings.rage
local fovSettings = settings.fov
local gunmodSettings = settings.gunmods
local backtrackSettings = settings.backtrack
local movementSettings = settings.movement

local TS = filtergc("table", {
    Keys = { "Characters", "Teams", "Network" }
}, true);
if (not TS) then warn("TS NOT FOUND"); return; end

local characters = TS.Characters
local teams = TS.Teams

local infocache = {};
local trampoline_call = function(func, ...)
    local funcinfo = debug.getinfo(func);
    local funcenv = getfenv(func);
    local result = {syn.trampoline_call(func, {
        env = funcenv,
        source = funcinfo.source,
        name = funcinfo.name,
        currentline = funcinfo.currentline,
        numparams = funcinfo.numparams,
        is_varag = funcinfo.is_vararg
    }, {
        identity = 2,
        script = script,
        env = funcenv
    }, ...)}
    if (result[1]) then
        return unpack(result, 2);
    end
    error("trampoline call error:\n" .. debug.traceback());
end

local flyChar = function(camera, root, speed)
    local bodyGyro = Instance.new("BodyGyro");
    local bodyVelocity = Instance.new("BodyVelocity");

    protectInstance(bodyGyro);
    protectInstance(bodyVelocity);
    bodyGyro.Parent = root
    bodyVelocity.Parent = root
    bodyGyro.P = 9e9
    bodyGyro.MaxTorque = Vector3.one * 9e9
    bodyGyro.CFrame = root.CFrame
    bodyVelocity.MaxForce = Vector3.one * 9e9
    bodyVelocity.Velocity = Vector3.zero

    local veczero = Vector3.zero

    local WASD = { W = 0, A = 0, S = 0, D = 0 };
    camera = camera or currentCamera
    speed = math.clamp(speed or 3, 1, 7);
    task.spawn(function()
        flying = true
        while (flying) do
            WASD.W = keys.W and speed or 0
            WASD.A = keys.A and -speed or 0
            WASD.S = keys.S and -speed or 0
            WASD.D = keys.D and speed or 0
            if ((WASD.W + WASD.S) ~= 0 or (WASD.A + WASD.D) ~= 0) then
                bodyVelocity.Velocity = ((camera.CoordinateFrame.lookVector * (WASD.W + WASD.S)) + ((camera.CoordinateFrame * CFrame.new(WASD.A + WASD.D, (WASD.W + WASD.S) * 0.2, 0).Position) - camera.CoordinateFrame.Position)) * 50
            else
                bodyVelocity.Velocity = veczero
            end
            bodyGyro.CFrame = camera.CoordinateFrame
            wait();
        end
        bodyVelocity:Destroy();
        bodyGyro:Destroy();
    end);
end

local drawEntries = {};
local addDrawings = function(player, character, color)
    if (player == LocalPlayer) then
        return;
    end

    local body = character:WaitForChild("Body");
    local root = body:WaitForChild("Chest");

    local Visual = Visuals.new(root);
    drawEntries[player] = root

    local Text = Visual:AddText(player.Name, {
        Color = color,
        Visible = espSettings.names_enabled
    }, CFrame.new(0, 4, 0));
    local Tracer = Visual:AddTracer(nil, {
        Color = color,
        Visible = espSettings.tracers_enabled
    }, CFrame.new(0, 2, 0));
    local characterSize = body:GetExtentsSize();
    local Box = Visual:Add2DBox(root, CFrame.new(characterSize.X / 2, characterSize.Y / 2, 0), CFrame.new(-characterSize.X / 2, -characterSize.Y / 2, 0), {
        Color = color,
        Visible = espSettings.box_esp
    });
    local Highlight = Visual:Highlight(character, {
        FillColor = color,
        Enabled = espSettings.chams_enabled
    });

    local healthBar = Visual:AddHealthBar(body, root, Color3.new(1, 1, 1), Color3.new(0, 1, 0));

    local health = character:WaitForChild("Health");
    local maxHealth = health:WaitForChild("MaxHealth");
    health:GetPropertyChangedSignal("Value"):Connect(function()
        healthBar:UpdateHealth(health.Value, maxHealth.Value);
    end);

    healthBar:UpdateHealth(health.Value, maxHealth.Value);

    healthBar.healthBarOutline.Visible = espSettings.healthbar_enabled
    healthBar.healthBarHealth.Visible = espSettings.healthbar_enabled

    Visual:SetTag(healthBar, "health_bar");
    Visual:SetTag(Text, "text");
    Visual:SetTag(Tracer, "tracer");
    Visual:SetTag(Box, "box");
    Visual:SetTag(Highlight, "chams");
end

local localCharacter = nil;

for index, player in pairs(Players:GetPlayers()) do
    local char = trampoline_call(characters.GetCharacter, characters, player);
    local teamName = trampoline_call(teams.GetPlayerTeam, teams, player);
    local team = services.Teams:FindFirstChild(teamName);
    if (char) then
        task.spawn(addDrawings, player, char, team.Color.Value);
        print(player.Name .. " added.");
        if (player == LocalPlayer) then
            localCharacter = char
        end
    end
end

local remoteCharKilled = ReplicatedStorage:FindFirstChild("RemoteCharacterKilled", true);
remoteCharKilled.OnClientEvent:Connect(function(char)
    local player = trampoline_call(characters.GetPlayerFromCharacter, characters, char);

    local drawEntry = drawEntries[player]
    if (drawEntry) then
        drawEntry:Destroy();
        print(player.Name .. " destroyed.");
    end
    if (player == LocalPlayer) then
        localCharacter = nil
    end
end);

local Characters = workspace:FindFirstChild("Characters");

Characters.ChildAdded:Connect(function(char)
    local characterRoot = char:WaitForChild("Root");
    local player = trampoline_call(characters.GetPlayerFromCharacter, characters, char);
    local teamName = trampoline_call(teams.GetPlayerTeam, teams, player);
    local team = services.Teams:FindFirstChild(teamName);
    if (char) then
        task.spawn(addDrawings, player, char, team.Color.Value);
        print(player.Name .. " added.");
        if (player == LocalPlayer) then
            localCharacter = char
        end
    end
end);

remoteCharKilled = nil
Characters = nil

local mainWindow = UI:CreateWindow("Fate Hub", "Bad Business", Color3.fromRGB(100, 0, 255));

local visuals = mainWindow:Tab("Visuals");
local esp = visuals:Section("Esp");
esp:SetLeft();

esp:Toggle("Enable Esp", espSettings.enabled, function(callback)
    espSettings.enabled = callback
    Visuals:SetProperties("text", {
        Visible = callback and espSettings.enabled
    });
    Visuals:SetProperties("box", {
        Visible = callback and espSettings.box_esp
    });
    Visuals:SetProperties("tracer", {
        Visible = callback and espSettings.tracers_enabled
    });
    Visuals:SetProperties("health_bar", {
        Visible = callback and espSettings.healthbar_enabled
    });
    Visuals:SetProperties("chams", {
        Enabled = callback and espSettings.chams_enabled
    });
end);

esp:Toggle("Show Names", espSettings.names_enabled, function(callback)
    espSettings.names_enabled = callback
    Visuals:SetProperties("text", { Visible = callback });
end);
esp:Toggle("Health bar", espSettings.healthbar_enabled, function(callback)
    espSettings.healthbar_enabled = callback
    Visuals:SetProperties("health_bar", { Visible = callback });
end);
esp:Toggle("Box Esp", espSettings.box_esp, function(callback)
    espSettings.box_esp = callback
    Visuals:SetProperties("box", { Visible = callback });
end):Colorpicker(espSettings.box_color, function(callback)
    espSettings.box_color = callback
    Visuals:SetProperties("box", { Color = callback });
end);
esp:Toggle("Enable Chams", espSettings.chams_enabled, function(callback)
    espSettings.chams_enabled = callback
    Visuals:SetProperties("chams", { Enabled = callback });
end):Colorpicker(espSettings.chams_color, function(callback)
    espSettings.chams_color = callback
    Visuals:SetProperties("chams", { FillColor = callback });
end);
esp:Toggle("Enable Tracers", espSettings.tracers_enabled, function(callback)
    espSettings.tracers_enabled = callback
    Visuals:SetProperties("tracer", { Visible = callback });
end):Colorpicker(espSettings.tracer_color, function(callback)
    espSettings.tracer_color = callback
    Visuals:SetProperties("tracer", { Color = callback });
end);