local UILibrary = loadfile("UILibrary.lua")();
local Visuals = loadfile("Visuals.lua")();
local services = setmetatable({}, {
    __index = function(self, serviceName)
        local good, service = pcall(game.GetService, game, serviceName);
        if (good) then
            self[serviceName] = service
            return service;
        end
    end
});

local Workspace = services.Workspace
local currentCamera = Workspace.currentCamera
local worldtoscreen = currentCamera.WorldToScreenPoint
local viewportSize = currentCamera.ViewportSize
local ReplicatedStorage = services.ReplicatedStorage
local UserInputService = services.UserInputService
local Players = services.Players
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse();
local mouseVector = Vector2.new(mouse.X, mouse.Y);
local inset = services.GuiService:GetGuiInset();

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

local network = filtergc("table", {
    Keys = {"send"}
})[1]
local pfcamera = filtergc("table", {
    Keys = {"angles", "delta", "offsetspring"}
})[1]
local pfinput = filtergc("table", {
    Keys = {"mouse"}
})[1]

local getbodyparts = filtergc("function", {
    Name = "getbodyparts"
})[1]
local gethealthstate = filtergc("function", {
    Name = "gethealthstate"
})[1]
local setcharacterhash = filtergc("function", {
    Name = "setcharacterhash"
})[1]

local f = nil
local up = nil
local gethealth = function(player)
    if (not up) then
        for i, gethealth in filtergc("function", {
            Name = "gethealth"
        }) do
            if (#debug.getupvalues(gethealth) == 2) then
                up = debug.getupvalue(gethealth, 1);
                local playerData = up[player]
                return playerData.health0, playerData.maxhealth;
            end
        end
    else
        local playerData = up[player]
        return playerData.health0, playerData.maxhealth;
    end
    return 0, 0
end

local players = {};
local characters = debug.getupvalue(getbodyparts, 1);
local crefs = debug.getupvalue(setcharacterhash, 1);
local teamsPlayers = {};
local drawEntries = {};
local keys = {};
local protectedInstances = {};
local locked = false
local flying = false

do
    players = {unpack(Players:GetPlayers(), 2)};
    Players.PlayerAdded:Connect(function(plr)
        players[#players + 1] = plr
    end);
    Players.PlayerRemoving:Connect(function(plr)
        table.remove(players, table.find(players, plr));
    end);

    for i, team in pairs(services.Teams:GetTeams()) do
        for i2, player in pairs(team:GetPlayers()) do
            teamsPlayers[player] = team.Name
        end
        team.PlayerAdded:Connect(function(player)
            teamsPlayers[player] = team.Name
        end);
        team.PlayerRemoved:Connect(function(player)
            teamsPlayers[player] = nil
        end);
    end
end

local settings = {
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
        smoothness = 2,
        lock_on = "head",
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
        backtrack_redirect = "torso",
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
        redirect = "head"
    },

    esp = {
        enabled = true,
        names_enabled = true,
        distance_enabled = true,
        health_enabled = true,
        esp_transparency = 1,
        chams_enabled = false,
        chams_color = color3new(1, 0, 0),
        chams_outline = true,
        chams_outline_color = color3new(1, 1, 1),
        tracers_enabled = true,
        tracer_color = fromRGB(20, 226, 207),
        box_esp = true,
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
        tracer_to = "head",
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

local backup = {};
local updateWeaponSettings = function()
    local wepconfigs = filtergc("table", {
        Keys = {"name", "type", "description"}
    });

    local recoilkeys = {
        "rotkickmin", "rotkickmax", "rotkickmax",
        "transkickmin", "transkickmax", "camkickmin",
        "camkickmax", "aimrotkickmin", "aimrotkickmax",
        "aimtranskickmin","aimtranskickmax", "aimcamkickmin",
        "aimcamkickmax"
    };

    local one = vector3new();
    for i, v in pairs(wepconfigs) do
        if (not backup[v]) then
            backup[v] = {};
            for i2, v2 in pairs(v) do
                backup[i2] = v2
            end
        end

        for i2, v2 in pairs(v) do
            if (table.find(recoilkeys, i2)) then
                if (gunmodSettings.no_recoil) then
                    rawset(v, i2, one);
                else
                    rawset(v, i2, backup[i2]);
                end
            end
        end
    end
end

local FOV = CircleDynamic.new();
FOV.Color = fovSettings.fov_color
FOV.Thickness = 1
FOV.Filled = false
FOV.Radius = fovSettings.fov_radius
FOV.Position = Point2D.new(mouseVector);
FOV.Visible = fovSettings.fov_enabled

local snapLine = LineDynamic.new();
snapLine.Color = fovSettings.fov_color
snapLine.Thickness = .1
snapLine.From = Point2D.new(mouseVector);

local addPlayerDrawings = function(player, char)
    if (player == localPlayer) then return; end;
    local root = findFirstChild(char, "Torso");
    local charVisuals = Visuals.new(root);
    local esp_enabled = espSettings.enabled
    charVisuals:AddText(player.Name, {
        Color = espSettings.color,
        Visible = esp_enabled and espSettings.names_enabled
    }, CFrame.new(0, 4, 0));
    charVisuals:AddTracer(nil, {
        Color = espSettings.color,
        Visible = esp_enabled and espSettings.tracers_enabled
    }, CFrame.new(0, 1,  0));
    -- charVisuals:AddChams(espSettings.chams_color, {
    --     Adornee = char,
    --     Enabled = esp_enabled and espSettings.chams_enabled,
    --     FillColor = espSettings.chams_color,
    --     OutlineColor = espSettings.chams_outline_color
    -- });
    local characterSize = char:GetExtentsSize();
    charVisuals:Add2DBox(root, nil, nil, {
        Color = espSettings.box_color,
        Visible = esp_enabled and espSettings.box_esp
    });

    local healthBar = charVisuals:AddHealthBar(root, root, Color3.new(1, 1, 1), Color3.new(0, 1, 0), false, nil, root.Size * 2);

    drawEntries[player] = charVisuals
end

local getcref = function(player)
    for char, plr in pairs(crefs) do
        if (player == plr) then
            return char;
        end
    end
end

for i, t in pairs(findFirstChild(Workspace, "Players"):GetChildren()) do
    for i2, char in pairs(t:GetChildren()) do
        addPlayerDrawings(rawget(crefs, char), char);
    end
    t.ChildAdded:Connect(function(char)
        addPlayerDrawings(rawget(crefs, char), char);
    end);
end

local ignore = findFirstChild(Workspace, "Ignore");
local ignoreList = {};
for i, folder in pairs(ignore:GetChildren()) do
    folder.ChildAdded:Connect(function(child)
        ignoreList[#ignoreList+1] = child
    end);
    folder.ChildRemoved:Connect(function(child)
        table.remove(ignoreList, table.find(ignoreList, child));
    end);
end
currentCamera.ChildAdded:Connect(function(child)
    table.insert(ignoreList, child);
end);
currentCamera.ChildRemoved:Connect(function(child)
    table.remove(ignoreList, table.find(ignoreList, child));
end);

local isAlive = function(player)
    if (player == localPlayer) then
        local char = player.Character
        return char and char.Parent == ignore;
    else
        local state = trampoline_call(gethealthstate, player);
        return rawget(state, "alive");
    end
end

local isEnemy = function(player)
    return teamsPlayers[localPlayer] ~= teamsPlayers[player]
end

local getClosestPlayer = function()
    local closest = create(6);
    local vector2Distance = math.huge
    local vector3DistanceOnScreen = math.huge
    local vector3Distance = math.huge
    local noPartsVector3Distance = math.huge

    if not isAlive(localPlayer) then return; end
    local localChar = localPlayer.Character

    for player, character in pairs(characters) do
        local localRoot = findFirstChild(localChar, "Torso");

        local redirect = rawget(character, aimbotSettings.lock_on);
        local redirect_rage = rawget(character, rageSettings.redirect);
        if (not redirect) then
            continue;
        end
        if (not drawEntries[player]) then
            addPlayerDrawings(player, getcref(player));
        end

        local position = redirect.Position
        local tuple, visible = worldtoscreen(currentCamera, position);
        local characterVector = vector2new(tuple.X, tuple.Y) + inset;
        local vector2Magnitude = (mouseVector - characterVector).Magnitude
        local vector3Magnitude = (position - localRoot.Position).Magnitude
        local inRenderDistance = vector3Magnitude <= espSettings.render_distance

        local enemy = isEnemy(player);
        local parts = GetPartsObscuringTarget(currentCamera, {currentCamera.CFrame.Position, redirect_rage.CFrame.Position}, {localChar, getcref(player)});

        if (visible and enemy and vector2Magnitude <= vector2Distance and vector2Magnitude <= FOV.Radius and aimbotSettings.closest_cursor) then
            vector2Distance = vector2Magnitude
            closest = {character, characterVector, player, {redirect, redirect_rage}, vector3Magnitude, closest[6], #parts == 0};
        end

        if (visible and enemy and vector3Magnitude <= vector3DistanceOnScreen and vector2Magnitude <= FOV.Radius and aimbotSettings.closest_player) then
            vector3DistanceOnScreen = vector3Magnitude
            closest = {character, characterVector, player, {redirect, redirect_rage}, vector3Magnitude, closest[6], #parts == 0};
        end

        if (vector3Magnitude <= vector3Distance and enemy) then
            vector3Distance = vector3Magnitude
            closest[5] = vector3Distance
        end

        if (enemy and (#parts == 0 or not rageSettings.wall_check) and vector3Magnitude <= noPartsVector3Distance) then
            noPartsVector3Distance = vector3Magnitude
            closest[6] = character
        end

        local notBlacklisted = not tfind(espSettings.show_teams, teamsPlayers[player]);
        if (espSettings.enabled and inRenderDistance and notBlacklisted) then
            local drawEntry = drawEntries[player]
            local teamColor = espSettings.team_colors and player.TeamColor.Color or nil
            local health, maxhealth = gethealth(player);

            drawEntry:SetProperties("TextDynamic", {
                Text = format("%s\n%s%s",
                    espSettings.names_enabled and player.Name or "",
                    espSettings.distance_enabled and format("[%s]", floor(vector3Magnitude)) or "",
                    espSettings.health_enabled and format(" [%s/%s]", floor(health), maxhealth) or ""
                ),
                Color = teamColor,
                Visible = espSettings.names_enabled
            });

            drawEntry:SetProperties("LineDynamic", {
                Color = teamColor,
                Visible = espSettings.tracers_enabled
            });

            drawEntry:SetProperties("RectDynamic", {
                Color = teamColor,
                Visible = espSettings.box_esp
            });

            drawEntry:SetProperties("HealthBar",  {
                Visible = espSettings.health_enabled
            });
            local healthBar = drawEntry:GetDrawings("HealthBar", true);
            if (healthBar) then
                healthBar:UpdateHealth(health, maxhealth);
            end
        else
            local drawEntry = drawEntries[player]
            for index, drawing in pairs(drawEntry:GetDrawings()) do
                if (type(drawing) == "table") then
                    drawing.healthBarHealth.Visible = false
                    drawing.healthBarOutline.Visible = false
                else
                    drawing.Visible = false
                end
            end
        end
    end

    return unpack(closest);
end

local aimsens = rawget(pfcamera, "aimsensitivity");

UserInputService.InputEnded:Connect(function(key, GPE)
    local keyString = split(tostring(key.KeyCode), ".")[3]
    if (not GPE and keys[keyString]) then
        keys[keyString] = false
    end

    if (aimbotSettings.aimbot and key.UserInputType == aimbotSettings.aimlock_key and locked) then
        locked = false
    end
end);

UserInputService.InputBegan:Connect(function(key, GPE)
    local keyString = split(tostring(key.KeyCode), ".")[3]
    if (not GPE) then
        keys[keyString] = true
    end

    if (aimbotSettings.aimbot and key.UserInputType == aimbotSettings.aimlock_key) then
        locked = true
    end
end);

local inputmouse = rawget(pfinput, "mouse");
local onbuttonup = rawget(inputmouse, "onbuttonup");
local onbuttondown = rawget(inputmouse, "onbuttondown");

local closestCharacter, vector, closestPlayer, redirect, vector3Magnitude, closestViewable, viewable;
local rstep = services.RunService.RenderStepped
rstep:Connect(function()
    mouseVector = vector2new(mouse.X, mouse.Y) + inset;
    local mouseVector2D = Point2D.new(mouseVector);

    FOV.Position = mouseVector2D
    snapLine.From = mouseVector2D
    closestCharacter, vector, closestPlayer, redirect, vector3Magnitude, closestViewable, viewable = getClosestPlayer();

    if (locked) then
        if (closestCharacter and closestPlayer) then
            local mousepos = worldtoscreen(currentCamera, mouse.Hit.Position);
            mousemoverel((vector.X - mousepos.X) / (aimbotSettings.smoothness * 2), (vector.Y - mousepos.Y - inset.Y) / (aimbotSettings.smoothness * 2));
        end
    end

    if (vector and fovSettings.snaplines_enabled) then
        snapLine.To = Point2D.new(vector);
        snapLine.Visible = true
        if (fovSettings.snaplines_color_visible) then
            snapLine.Color = viewable and color3new(0, 1, 0) or color3new(1, 0, 0);
        end
    else
        snapLine.Visible = false
    end

    local body = currentCamera:GetChildren();
    if (characterSettings.color_weapon) then
        if (#body == 3) then
            local weaponBody = body[3]
            local parts = {};
            for i,part in pairs(weaponBody:GetDescendants()) do
                if (IsA(part, "MeshPart") or IsA(part, "Part")) then
                    table.insert(parts, part);
                end
            end

            for i = 1, #parts do
                local part = parts[i]
                part.Color = characterSettings.weapon_color
                if (part.Material ~= Enum.Material[characterSettings.weapon_material]) then
                    part.Material = Enum.Material[characterSettings.weapon_material]
                end
            end
        end
    end

    if (characterSettings.color_arms) then
        if (#body == 3) then
            local larm = findFirstChild(currentCamera, "Left Arm");
            local rarm = findFirstChild(currentCamera, "Right Arm");
            local parts = {};
            for i, part in pairs(larm:GetDescendants()) do
                if (IsA(part, "MeshPart") or IsA(part, "Part")) then
                    table.insert(parts, part);
                end
            end
            for i, part in pairs(rarm:GetDescendants()) do
                if (IsA(part, "MeshPart") or IsA(part, "Part")) then
                    table.insert(parts, part);
                end
            end

            for i = 1, #parts do
                local part = parts[i]
                part.Color = characterSettings.arms_color
                if (part.Material ~= Enum.Material[characterSettings.arm_material]) then
                    part.Material = Enum.Material[characterSettings.arm_material]
                end
            end
        end
    end

    if (aimbotSettings.triggerbot) then
        local unitRay = mouse.UnitRay
        local part = findPartOnRayWithIgnoreList(Workspace, Ray.new(unitRay.Origin, unitRay.Direction * 1000), ignoreList);
        local isPlayer;
        for character, player in pairs(crefs) do
            if (part and isEnemy(player) and part:IsDescendantOf(character)) then
                isPlayer = true
                break;
            end
        end
        if (isPlayer) then
            wait(aimbotSettings.triggerbotMS / 1000);
            trampoline_call(onbuttondown.fire, onbuttondown, "left");
            wait();
            trampoline_call(onbuttonup.fire, onbuttonup, "left");
        end
    end
end);

local mainWindow = UILibrary:CreateWindow("Fate Hub", "Phantom Forces", Color3.fromRGB(100, 0, 255));

local visuals = mainWindow:Tab("Visuals");
local players_esp = visuals:Section("ESP");
players_esp:SetLeft();
local team_colors = espSettings.team_colors
players_esp:Toggle("Enable Esp", espSettings.enabled, function(callback)
    espSettings.enabled = callback
    Visuals:SetAllProperties(nil, {
        Visible = callback
    });
end):Colorpicker(espSettings.color, function(callback)
    espSettings.team_colors = false
    espSettings.color = callback
    Visuals:SetAllProperties(nil, {
        Color = callback
    });
    Visuals:SetAllProperties("Chams", {
        FillColor = callback
    });
end);
espSettings.team_colors = team_colors
players_esp:Toggle("Show Names", espSettings.names_enabled, function(callback)
    espSettings.names_enabled = callback
end);
players_esp:Toggle("Show Health", espSettings.health_enabled, function(callback)
    espSettings.health_enabled = callback
end);
players_esp:Toggle("Health bar", espSettings.healthbar_enabled, function(callback)
    espSettings.healthbar_enabled = true
    Visuals:SetAllProperties("HealthBar", {
        Visible = callback
    });
end);
players_esp:Toggle("Show Distance", espSettings.distance_enabled, function(callback)
    espSettings.distance_enabled = callback
end);
players_esp:Toggle("Box Esp", espSettings.box_esp, function(callback)
    espSettings.box_esp = callback
    Visuals:SetAllProperties("RectDynamic", {
        Visible = callback
    });
end):Colorpicker(espSettings.box_color, function(callback)
    espSettings.box_color = callback
    Visuals:SetAllProperties("RectDynamic", {
        Color = callback
    });
end);
players_esp:Toggle("Enable Chams", espSettings.chams_enabled, function(callback)
    espSettings.chams_enabled = callback
    Visuals:SetAllProperties("Chams", {
        Visible = callback
    });
end):Colorpicker(espSettings.chams_color, function(callback)
    espSettings.chams_color = callback
    Visuals:SetAllProperties("Chams", {
        FillColor = callback
    });
end);
players_esp:Toggle("Enable Tracers", espSettings.tracers_enabled, function(callback)
    espSettings.tracers_enabled = callback
    Visuals:SetAllProperties("LineDynamic", {
        Visible = callback
    });
end):Colorpicker(espSettings.tracer_color, function(callback)
    espSettings.tracer_color = callback
    Visuals:SetAllProperties("LineDynamic", {
        Color = callback
    });
end);
players_esp:Toggle("Chams Outline", espSettings.chams_outline, function(callback)
    espSettings.chams_outline = callback
    Visuals:SetAllProperties("Chams", {
        OutlineTransparency = callback and 0 or 1
    });
end):Colorpicker(espSettings.chams_outline_color, function(callback)
    espSettings.chams_outline_color = callback
    Visuals:SetAllProperties("Chams", {
        OutlineColor = callback
    });
end);
players_esp:Toggle("Team Colors", team_colors, function(callback)
    espSettings.team_colors = callback
    if (not callback) then
        Visuals:SetAllProperties({"Line", "Text", "Box"}, {
            Color = espSettings.color
        });
    end
end);
local fn = function(callback)
    if (callback == "Enemies") then
        table.insert(espSettings.show_teams, teamsPlayers[localPlayer]);
    end
    if (callback == "Allies") then
        local teamsChildren = services.Teams:GetChildren();
        local teamsNames = {};
        for i, team in pairs(teamsChildren) do
            local teamName = team.Name
            if (teamName ~= teamsPlayers[localPlayer]) then
                table.insert(teamsNames, team.Name);
            end
        end
        espSettings.show_teams = teamsNames
    end
    espSettings.show_team = callback
end
players_esp:Dropdown("Teams", espSettings.show_team, {"Enemies", "Allies", "All"}, function(callback)
    table.clear(espSettings.show_teams);
    fn(callback);
end); fn(espSettings.show_team);
players_esp:Dropdown("Tracer To", espSettings.tracer_to, {"Head", "Chest"}, function(callback)
    espSettings.tracer_to = callback
end);

players_esp:Dropdown("Tracer From", "Bottom", {"Top", "Bottom", "Left", "Right"}, function(callback)
    local positions = {
        Top = vector2new(viewportSize.X / 2, viewportSize.Y - viewportSize.Y),
        Bottom = vector2new(viewportSize.X / 2, viewportSize.Y),
        Left = vector2new(viewportSize.X - viewportSize.X, viewportSize.Y / 2),
        Right = vector2new(viewportSize.X, viewportSize.Y / 2)
    };
    Visuals:SetAllProperties("LineDynamic", {
        From = Point2D.new(positions[callback]);
    });
end);
players_esp:Slider("Render Distance", 0, 50000, math.clamp(espSettings.render_distance, 0, 50000), function(callback)
    espSettings.render_distance = callback
end, false);

local character = visuals:Section("Self");
character:SetRight();
character:Toggle("Arms Color", characterSettings.color_arms, function(callback)
    characterSettings.color_arms = callback
end):Colorpicker(characterSettings.arms_color, function(callback)
    characterSettings.arms_color = callback
end);

character:Dropdown("Arms Material", characterSettings.arm_material, { "SmoothPlastic", "ForceField", "Neon", "Glass" }, function(callback)
    characterSettings.arm_material = callback
end);

character:Toggle("Weapon Color", characterSettings.color_weapon, function(callback)
    characterSettings.color_weapon = callback
end):Colorpicker(characterSettings.weapon_color, function(callback)
    characterSettings.weapon_color = callback
end);
character:Dropdown("Weapon Material", characterSettings.weapon_material, { "SmoothPlastic", "ForceField", "Neon", "Glass" }, function(callback)
    characterSettings.weapon_material = callback
end);

local world = visuals:Section("World");
world:SetRight();
world:Toggle("No Shadows", false, function(callback)
    for i, v in pairs(game:GetDescendants()) do
        if (IsA(v, "PointLight") or IsA(v, "SurfaceLight") or IsA(v, "SpotLight")) then
            v.Enabled = callback
            v.Shadows = not callback
            v.Range = math.huge
        end
    end
    services.Lighting.GlobalShadows = not callback
end);
world:Slider("Time of Day", 0, 24, floor(services.Lighting.ClockTime), function(callback)
    services.Lighting.ClockTime = callback
end);
world:Colorpicker("Color Correction", color3new(1, 1, 1), function(callback)
    -- services.Lighting.ColorCorrection.TintColor = callback
end);

local other = visuals:Section("Other");
other:SetRight();
other:Toggle("Show Backtrack Hitbox", backtrackSettings.show_backtrack, function(callback)
    backtrackSettings.show_backtrack = callback
end):Colorpicker(backtrackSettings.backtrack_color, function(callback)
    backtrackSettings.backtrack_color = callback
end);
other:Toggle("Bullet Tracers", espSettings.bullet_tracers, function(callback)
    espSettings.bullet_tracers = callback
end):Colorpicker(espSettings.bullet_tracer_color, function(callback)
    espSettings.bullet_tracer_color = callback
end);
other:Toggle("Third Person", characterSettings.third_person, function(callback)
    characterSettings.third_person = callback
end);
other:Slider("Offset X", -15, 15, characterSettings.third_person_values[1], function(callback)
    characterSettings.third_person_values[1] = callback
end);
other:Slider("Offset Y", -15, 15, characterSettings.third_person_values[2], function(callback)
    characterSettings.third_person_values[2] = callback
end);
other:Slider("Offset Z", -15, 15, characterSettings.third_person_values[3], function(callback)
    characterSettings.third_person_values[3] = callback
end);

local legit = mainWindow:Tab("Legit");
local aim = legit:Section("Aim");
aim:Toggle("Enable Aimbot", aimbotSettings.aimbot, function(callback)
    aimbotSettings.aimbot = callback
end):Keybind(aimbotSettings.aimlock_key, function(callback)
    aimbotSettings.aimlock_key = callback
end);
aim:Toggle("Enable TriggerBot", aimbotSettings.triggerbot, function(callback)
    aimbotSettings.triggerbot = callback
end);
aim:Toggle("Show FOV", fovSettings.fov_enabled, function(callback)
    fovSettings.fov_enabled = callback
    FOV.Visible = callback
end):Colorpicker(fovSettings.snaplines_color, function(callback)
    fovSettings.fov_color = callback
    FOV.Color = callback
end);
aim:Toggle("Show Snaplines", fovSettings.snaplines_enabled, function(callback)
    fovSettings.snaplines_enabled = callback
end):Colorpicker(fovSettings.snaplines_color, function(callback)
    fovSettings.snaplines_color = callback
    snapLine.Color = callback
end);
aim:Toggle("Snapline Color Visible", fovSettings.snaplines_color_visible, function(callback)
    fovSettings.snaplines_color_visible = callback
    if (not callback) then
        snapLine.Color = fovSettings.snaplines_color
    end
end)
aim:Slider("TriggerBot MS", 0, 3000, aimbotSettings.triggerbotMS, function(callback)
    aimbotSettings.triggerbotMS = callback
end, false);
aim:Slider("Lock Smoothness", 1, 10, aimbotSettings.smoothness - 1, function(callback)
    aimbotSettings.smoothness = callback + 1
end, false);
aim:Dropdown("Aimlock Part", aimbotSettings.redirect, {"Head", "Chest"}, function(callback)
    aimbotSettings.redirect = callback
end);

local backtrack = legit:Section("Backtrack");
backtrack:Toggle("Enable Backtracking", backtrackSettings.backtrack, function(callback)
    backtrackSettings.backtrack = callback
end);

backtrack:Slider("Backtrack MS", 0, 3000, backtrackSettings.backtrackMS, function(callback)
    backtrackSettings.backtrackMS = callback
end, false);
backtrack:Dropdown("Backtrack redirect", backtrackSettings.backtrack_redirect, {"Head", "Chest"}, function(callback)
    backtrackSettings.BacktrackRedirect = callback
end);

local rage = mainWindow:Tab("Rage");

local ragemain = rage:Section("Main");
ragemain:Toggle("Auto Shoot", rageSettings.auto_shoot, function(callback)
    rageSettings.auto_shoot = callback
end);
ragemain:Toggle("Wall Check", rageSettings.wall_check, function(callback)
    rageSettings.wall_check = callback
end);
ragemain:Toggle("Silent Aim", rageSettings.silent_aim, function(callback)
    rageSettings.silent_aim = callback
end);
ragemain:Toggle("Wallbang", rageSettings.wallbang, function(callback)
    rageSettings.wallbang = callback
end);
ragemain:Toggle("Kill aura", rageSettings.kill_aura, function(callback)
    rageSettings.kill_aura = callback
end);
ragemain:Dropdown("Auto Shoot Target Priority", "All",{""}, function(callback)

end);
ragemain:Dropdown("Redirect Part", rageSettings.redirect, {"Head", "Chest", "Random"}, function(callback)
    rageSettings.redirect = callback
end);

local gunMods = rage:Section("Gun Mods");

gunMods:Toggle("No Recoil", gunmodSettings.no_recoil, function(callback)
    gunmodSettings.no_recoil = callback
    updateWeaponSettings();
end);
gunMods:Toggle("No Weapon Shake", gunmodSettings.no_wep_shake, function(callback)
    gunmodSettings.no_wep_shake = callback
    updateWeaponSettings();
end);
gunMods:Toggle("Instant Scope", gunmodSettings.instant_scope, function(callback)
    gunmodSettings.instant_scope = callback
    updateWeaponSettings();
end);
gunMods:Toggle("Instant Reload", gunmodSettings.instant_reload, function(callback)

end);

local movement = rage:Section("Movement");
movement:Toggle("Auto Strafe", movementSettings.auto_strafe, function(callback)
    movementSettings.auto_strafe = callback
end);
movement:Toggle("Bhop", movementSettings.bhop, function(callback)
    movementSettings.bhop = callback
end);
movement:Toggle("Fly", false, function(callback)
    if (callback) then
        flyChar(currentCamera, localPlayer.Character.HumanoidRootPart, 5);
    else
        flying = false
    end
end);
movement:Slider("Walkspeed", 0, 150, movementSettings.walkspeed, function(callback)
    movementSettings.walkspeed = callback
end);

local antiAim = rage:Section("Anti aim");