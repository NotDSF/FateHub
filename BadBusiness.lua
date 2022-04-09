local UILibrary = loadfile("UILibrary.lua")();
local VisualsLib = loadfile("Visuals.lua")();
local Visuals = VisualsLib.new();
local Services = setmetatable({}, {
    __index = function(self, serviceName)
        local good, service = pcall(game.GetService, game, serviceName);
        if (good) then
            self[serviceName] = service
            return service;
        end
    end
});

local Workspace = Services.Workspace
local currentCamera = Workspace.currentCamera
local worldtoscreen = currentCamera.WorldToScreenPoint
local viewportSize = currentCamera.ViewportSize
local ReplicatedStorage = Services.ReplicatedStorage
local UserInputService = Services.UserInputService
local Players = Services.Players
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse();
local mouseVector = Vector2.new(mouse.X, mouse.Y);
local inset = Services.GuiService:GetGuiInset();

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

local TS = filtergc("table", {
    Keys = { "Characters", "Teams", "Network" }
})[1];
local Network = TS.Network
local Characters = TS.Characters
local Teams = TS.Teams

local aliveCharacters = {};
local drawEntries = {};
local teamsPlayers = {};
local trackers = {};
local keys = {};
local protectedInstances = {};
local locked = false
local flying = false

local controlScriptClosure = getscriptclosure(localPlayer.PlayerScripts.ControlScript);
local changestate = debug.getproto(controlScriptClosure, 14, true)[1];
local getspeed = debug.getproto(controlScriptClosure, 2, true)[1]

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
        snaplines_color = color3new(1, 1, 1)
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
        wallbang = false,
        redirect = "Head"
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
        show_teams = {};
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

local protectInstance = function(instance)
    protectedInstances[#protectedInstances + 1] = instance
end

local __namecall;
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    if (not checkcaller() and getnamecallmethod() == "GetDescendants") then
        local descendants = __namecall(self, ...);
        local filteredDescendants = {};
        for index, descendant in pairs(descendants) do
            if (not table.find(protectedInstances, descendant)) then
                filteredDescendants[#filteredDescendants + 1] = descendant
            end
        end
        return filteredDescendants;
    end
    return __namecall(self, ...);
end);

local __newindex;
__newindex = hookmetamethod(game, "__newindex", function(self, prop, value)
    if (characterSettings.third_person and self == currentCamera and prop == "CFrame") then
        value *= cframenew(unpack(characterSettings.third_person_values));
    end
    return __newindex(self, prop, value);
end);

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

task.spawn(function()
    while task.wait(backtrackSettings.backtrackMS / 1000) do
        for char, charTrackers in pairs(trackers) do
            for index2, tracker in pairs(charTrackers) do
                tracker:Destroy();
                charTrackers[index2] = nil
            end
        end
    end
end);

local backup = {};
local updateWeaponSettings = function() -- will change
    if (not aliveCharacters[localPlayer]) then return; end;

    local items = waitForChild(waitForChild(aliveCharacters[localPlayer], "Backpack"), "Items");
    for index, value in pairs(filtergc("table", {
        Keys = { "Controller", "Animators", "Model", "Slot", "Category" }
    })) do
        if (findFirstChild(items, value.Model)) then
            local recoil = value.Recoil
            if (recoil and type(recoil) == "table") then
                local recoilSettings = recoil.Default
                if (recoilSettings) then
                    if (not backup[recoilSettings]) then
                        backup[recoilSettings] = {};
                        for i, v in pairs(recoilSettings) do
                            backup[recoilSettings][i] = v
                        end
                    end

                    if (gunmodSettings.no_recoil) then
                        recoilSettings.RecoilMovement = vector2new(1, 1);
                        recoilSettings.CameraRotationVariance = vector3new(1, 1);
                        recoilSettings.RecoilMovementVariance = vector2new(1, 1);
                        recoilSettings.RecoilRecenterTime = 0
                        recoilSettings.RecoilMovementTime = 0
                        recoilSettings.RecoilCrouchScale = 0
                        recoilSettings.RecoilProneScale = 0
                    else
                        local backup = backup[recoilSettings]
                        if (backup) then
                            recoilSettings.RecoilMovement = backup.RecoilMovement
                            recoilSettings.CameraRotationVariance = backup.CameraRotationVariance
                            recoilSettings.RecoilMovementVariance = backup.RecoilMovementVariance
                            recoilSettings.RecoilRecenterTime = backup.RecoilRecenterTime
                            recoilSettings.RecoilMovementTime = backup.RecoilMovementTime
                            recoilSettings.RecoilCrouchScale = backup.RecoilCrouchScale
                            recoilSettings.RecoilProneScale = backup.RecoilProneScale
                        end
                    end

                    if (gunmodSettings.no_wep_shake) then
                        for i, v in pairs(recoilSettings) do
                            if (type(v) == "vector") then
                                recoilSettings[i] = vector3new(0, 0);
                            end
                        end
                    else
                        local backup = backup[recoilSettings]
                        for i, v in pairs(recoilSettings) do
                            if (type(v) == "vector") then
                                recoilSettings[i] = backup[i]
                            end
                        end
                    end
                end
                
            end

            local aim = value.Aim
            if (type(aim) == "table" and type(aim.AimTime) == "number") then
                if (gunmodSettings.instant_scope) then
                    if (not backup[value.Aim]) then
                        backup[value.Aim] = {};
                        for i, v in pairs(value.Aim) do
                            backup[value.Aim][i] = v
                        end
                    end
                    aim.AimTime = 0
                else
                    local backup = backup[value.Aim]
                    if (backup) then
                        aim.AimTime = backup.AimTime
                    end
                end
            end

        end
    end
end

local handleTracking = function(player, character) -- will remake
    trackers[character] = {}
    while true do
        if (backtrackSettings.backtrack) then
            local character = aliveCharacters[player]
            if (character) then
                local cloned = Instance.new("Part");
                cloned.CFrame = character.Root.CFrame
                cloned.Anchored = true
                cloned.CanCollide = false
                cloned.Transparency = 1
                cloned.Size = Vector3.new(1.6, 4, 1.2);
                cloned.Color = backtrackSettings.backtrack_color
                cloned.Parent = Workspace
                table.insert(trackers[character], cloned);
                if (backtrackSettings.show_backtrack) then
                    for i, tracker in pairs(trackers[character]) do
                        if (i == 1) then
                            tracker.Transparency = .4
                        else
                            tracker.Transparency = 1
                        end
                    end
                end
            else
                break;
            end
        end
        wait();
    end
end

local isEnemy = function(player)
    local enemyTeam = teamsPlayers[player]
    if (enemyTeam == "FFA") then
        return true;
    end
    return enemyTeam ~= teamsPlayers[localPlayer];
end
local getTeamColor;
do
    local teamColorCache = {};
    getTeamColor = function(team)
        local cache = teamColorCache[team]
        if (cache) then
            return cache;
        end
        local color = findFirstChild(Services.Teams, team).Color
        if (team) then
            local value = color.Value
            teamColorCache[team] = value
            return value;
        end
    end
end

local addPlayerDrawings = function(player)
    if (player == localPlayer) then return; end;
    local char = aliveCharacters[player]
    if (not char) then return; end
    local root = waitForChild(char, "Root");
    local charVisuals = Visuals:Add(root);
    local esp_enabled = espSettings.enabled
    charVisuals:AddText(player.Name, {
        Offset = {0, 4},
        Color = espSettings.color,
        Visible = esp_enabled and espSettings.names_enabled
    });
    charVisuals:AddTracer(nil, {
        Offset = {0, 1},
        Color = espSettings.color,
        Visible = esp_enabled and espSettings.tracers_enabled
    });
    charVisuals:AddChams(espSettings.chams_color, {
        Adornee = char,
        Enabled = esp_enabled and espSettings.chams_enabled,
        FillColor = espSettings.chams_color,
        OutlineColor = espSettings.chams_outline_color
    });
    charVisuals:Add2DBox(vector3new(root.Size.X, root.Size.Y), vector3new(-root.Size.X, -root.Size.Y), {
        Color = espSettings.box_color,
        Visible = esp_enabled and espSettings.box_esp
    });
    drawEntries[player] = charVisuals
end

for i, team in pairs(Services.Teams:GetChildren()) do
    team.Players.ChildAdded:Connect(function(obj)
        local player = obj.Value
        teamsPlayers[player] = team.Name
    end);
end

Players.PlayerRemoving:Connect(function(player)
    aliveCharacters[player] = nil
    local drawEntry = drawEntries[player]
    if (drawEntry) then
        drawEntry:Destroy();
    end
end);

for index, player in pairs(Players:GetPlayers()) do
    local Team = Teams:GetPlayerTeam(player);
    teamsPlayers[player] = Team
    local char = Characters:GetCharacter(player);
    if (char) then
        aliveCharacters[player] = char
    end
    if (player == localPlayer and char) then
        updateWeaponSettings();
    end
    task.spawn(addPlayerDrawings, player);
end

Workspace.Characters.ChildAdded:Connect(function(char)
    local root = waitForChild(char, "Root");
    local player = Characters:GetPlayerFromCharacter(char);
    aliveCharacters[player] = char
    if (player == localPlayer) then
        updateWeaponSettings();
    end
    addPlayerDrawings(player);
end);

local remoteCharKilled = findFirstChild(ReplicatedStorage, "RemoteCharacterKilled", true);
remoteCharKilled.OnClientEvent:Connect(function(char)
    local player = Characters:GetPlayerFromCharacter(char);
    aliveCharacters[player] = nil
    local drawEntry = drawEntries[player]
    if (drawEntry) then
        drawEntry:Destroy();
    end
end);

local FOV = Drawing.new("Circle");
FOV.Color = fovSettings.fov_color
FOV.Thickness = 1
FOV.Transparency = 1
FOV.Filled = false
FOV.Radius = fovSettings.fov_radius
FOV.Position = mouseVector
FOV.Visible = true

local snapLine = Drawing.new("Line");
snapLine.Color = fovSettings.fov_color
snapLine.Thickness = .1
snapLine.Transparency = 1
snapLine.From = mouseVector

local getClosestPlayer = function()
    local closest = create(6);
    local vector2Distance = math.huge
    local vector3DistanceOnScreen = math.huge
    local vector3Distance = math.huge
    local noPartsVector3Distance = math.huge

    local localChar = aliveCharacters[localPlayer]
    if (not localChar) then return; end;

    local localHitbox = findFirstChild(localChar, "Hitbox");
    for player, character in pairs(aliveCharacters) do
        local hitbox = findFirstChild(character, "Hitbox");
        if (player ~= localPlayer and localHitbox and hitbox) then
            local localRoot = localChar.Root
            local redirect = findFirstChild(hitbox, aimbotSettings.lock_on);
            local redirect_rage = findFirstChild(hitbox, rageSettings.redirect);
            if (not redirect) then
                continue;
            end

            local position = redirect.Position
            local tuple, visible = worldtoscreen(currentCamera, position);
            local characterVector = vector2new(tuple.X, tuple.Y) + inset;
            local vector2Magnitude = (mouseVector - characterVector).Magnitude
            local vector3Magnitude = (position - localRoot.Position).Magnitude
            local inRenderDistance = vector3Magnitude <= espSettings.render_distance

            local enemy = isEnemy(player);

            if (visible and enemy and vector2Magnitude <= vector2Distance and vector2Magnitude <= FOV.Radius and aimbotSettings.closest_cursor) then
                vector2Distance = vector2Magnitude
                closest = {character, characterVector, player, {redirect, redirect_rage}, vector3Magnitude, closest[6]};
            end

            if (visible and enemy and vector3Magnitude <= vector3DistanceOnScreen and vector2Magnitude <= FOV.Radius and aimbotSettings.closest_player) then
                vector3DistanceOnScreen = vector3Magnitude
                closest = {character, characterVector, player, {redirect, redirect_rage}, vector3Magnitude, closest[6]};
            end

            if (vector3Magnitude <= vector3Distance and enemy) then
                vector3Distance = vector3Magnitude
                closest[5] = vector3Distance
            end

            local parts = GetPartsObscuringTarget(currentCamera, {currentCamera.CFrame.Position, redirect_rage.CFrame.Position}, {localChar, character});
            if (enemy and #parts == 0 and vector3Magnitude <= noPartsVector3Distance) then
                noPartsVector3Distance = vector3Magnitude
                closest[6] = character
            end

            local notBlacklisted = not tfind(espSettings.show_teams, teamsPlayers[player]);
            if (espSettings.enabled and inRenderDistance and visible and notBlacklisted) then
                local drawEntry = drawEntries[player]
                local text = drawEntry:Get("TextDynamic");
                local tracer = drawEntry:Get("LineDynamic");
                local box = drawEntry:Get("RectDynamic");
                local health = character.Health
                text.Text = format("%s\n%s%s",
                    espSettings.names_enabled and player.Name or "",
                    espSettings.distance_enabled and format("[%s]",
                        floor(vector3Magnitude)
                    ) or "",
                    espSettings.health_enabled and format(" [%s/%s]",
                        floor(health.Value),
                        floor(health.MaxHealth.Value)
                    )  or ""
                );

                if (espSettings.team_colors) then
                    local teamColor = getTeamColor(teamsPlayers[player]);
                    text.Color = teamColor
                    tracer.Color = teamColor
                    box.Color = teamColor
                end

                tracer.Visible = espSettings.tracers_enabled
                text.Visible = espSettings.names_enabled
                box.Visible = espSettings.box_esp

            else
                local drawEntry = drawEntries[player]
                for index, drawing in pairs(drawEntry:Get()) do
                    drawing.Visible = false
                end
            end
        end
    end

    return unpack(closest);
end

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

local backpack, equippedWeapon, ignoreList;
local closestCharacter, vector, closestPlayer, redirect, vector3Magnitude, closestViewable;
Services.RunService.RenderStepped:Connect(function()
    mouseVector = vector2new(mouse.X, mouse.Y) + inset;
    local localCharacter = aliveCharacters[localPlayer]

    FOV.Position = mouseVector
    snapLine.From = mouseVector
    closestCharacter, vector, closestPlayer, redirect, vector3Magnitude, closestViewable = getClosestPlayer();

    if (locked) then
        if (closestCharacter and closestPlayer) then
            mousemoverel((vector.X - mouseVector.X) / aimbotSettings.smoothness, (vector.Y - mouseVector.Y) / aimbotSettings.smoothness);
        end
    end

    if (vector and fovSettings.snaplines_enabled) then
        snapLine.To = vector
        snapLine.Visible = true
    else
        snapLine.Visible = false
    end

    if (rageSettings.kill_aura and vector3Magnitude and vector3Magnitude < 50 and closestCharacter) then
        if (not backpack) then
            backpack = aliveCharacters[localPlayer].Backpack
        end
        local equipped = backpack.Equipped.value
        local knife = backpack.Melee.value
        Network:Fire("Item", "Equip", knife);
        local redirect_rage = redirect[2]
        for index = 1, 3 do
            if (localCharacter) then
                Network:Fire("Item_Melee", "StabBegin", knife);
                Network:Fire("Item_Melee", "Stab", knife, redirect_rage, redirect_rage.Position, (localCharacter.Root.CFrame * cframe_angles(0, -rad(-3 * 5), 0)).LookVector * (75 + -3));
            end
            wait();
        end
    end

    if (aimbotSettings.triggerbot) then
        if (not backpack or backpack.Parent ~= localCharacter) then
            if (not localCharacter) then return end
            backpack = findFirstChild(localCharacter, "Backpack");
            if (not backpack) then return end
            ignoreList = {localCharacter};
            equippedWeapon = localCharacter.Backpack.Equipped.value
            if (not equippedWeapon) then return end
            for index, child in pairs(Workspace:GetChildren()) do
                if (child.Name == equippedWeapon.Name) then
                    table.insert(ignoreList, child);
                end
            end
        end

        local unitRay = Mouse.UnitRay
        local part = findPartOnRayWithIgnoreList(Workspace, Ray.new(unitRay.Origin, unitRay.Direction * 1000), ignoreList);
        local isPlayer;
        for player, character in pairs(aliveCharacters) do
            if (part and isEnemy(player) and part:IsDescendantOf(character)) then
                isPlayer = true
                break;
            end
        end
        if (isPlayer) then
            wait(aimbotSettings.triggerbotMS / 1000)
            mouse1press(); -- change to fire wep func instead of mouse1press
            mouse1release();
        end
    end

    if (characterSettings.color_weapon) then
        if (localCharacter) then
            equippedWeapon = localCharacter.Backpack.Equipped.value
            if (not equippedWeapon) then
                return;
            end
            local weaponBody;
            for index, child in pairs(Workspace:GetChildren()) do
                if (child.Name == equippedWeapon.Name) then
                    weaponBody = child.Body
                end
            end
            if (not weaponBody) then
                return;
            end
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
        local arms = findFirstChild(Workspace, "Arms");
        local parts = {};
        for i, part in pairs(arms:GetDescendants()) do
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

    if (rageSettings.auto_shoot and closestViewable) then
        mouse1press();
        mouse1release();
    end
end);

task.spawn(function()
    local mt = setmetatable({}, {});
    mt.__index = mt
    while wait() do
        local char = aliveCharacters[localPlayer]
        local state;
        if (char) then
            state = findFirstChild(char, "State");
            if (movementSettings.bhop and state) then
                debug.setupvalue(changestate, 16, 9e9);
                debug.setupvalue(changestate, 23, 0);
                debug.setupvalue(changestate, 13, mt);
                changestate("Jump", false);
                -- state.Grounded.Changed:Wait();
                local grounded = state.Grounded
                local isGrounded = grounded.Value
                repeat
                    task.wait();
                until grounded.Value ~= isGrounded or not aliveCharacters[localPlayer]
            end
            if (movementSettings.auto_strafe and state) then
                local sprinting = findFirstChild(state, "Sprinting");
                if (sprinting and not sprinting.Value) then
                    task.wait(.1);
                    changestate("Sprint", false);
                end
            end
        end
    end
end);

local vector3newhook;
vector3newhook = hookfunction(getrenv().Vector3.new, function(...)
    local caller = debug.getinfo(2, "n");
    if (caller.name == "GetMovementInput") then
        if (select("#", ...) == 0) then
            if (movementSettings.auto_strafe) then
                return vector3newhook(0, 0, -1);
            end
        end
    end
    return vector3newhook(...);
end);

hookfunction(getspeed, function()
    return -movementSettings.walkspeed / 16 + 1
end);

local initProjectile;
initProjectile = hookfunction(TS.Projectiles.InitProjectile, function(...)
    local args = {...}
    if (rageSettings.auto_shoot or rageSettings.silent_aim or backtrackSettings.backtrack and args[5] == localPlayer) then
        local hitbox;
        local target_char = closestViewable

        if (rageSettings.auto_shoot and target_char) then
            hitbox = target_char.Hitbox
            args[3] = (hitbox[rageSettings.redirect].CFrame.Position + (Vector3.new(random(1, 10), random(1, 10), random(1, 10)) / 10)) - args[4]
            return initProjectile(unpack(args));
        end

        if (closestCharacter and closestPlayer) then
            hitbox = closestCharacter.Hitbox
            local viewable = GetPartsObscuringTarget(currentCamera, {currentCamera.CFrame.Position, hitbox[rageSettings.redirect].CFrame.Position}, {aliveCharacters[localPlayer], closestCharacter});
            if (rageSettings.silent_aim and #viewable == 0 or rageSettings.wallbang) then
                args[3] = (hitbox[rageSettings.redirect].CFrame.Position + (Vector3.new(random(1, 10), random(1, 10), random(1, 10)) / 10)) - args[4]
                return initProjectile(unpack(args));
            end
        end

        if (backtrackSettings.backtrack) then
            local unitRay = mouse.UnitRay
            local localCharacter = aliveCharacters[localPlayer]
            local ignoreList = {localCharacter}
            if (localCharacter) then
                local equippedWeapon = localCharacter.Backpack.Equipped.value
                for index, child in pairs(Workspace:GetChildren()) do
                    if (child.Name == equippedWeapon.Name) then
                        table.insert(ignoreList, child);
                    end
                end
                local part = findPartOnRayWithIgnoreList(Workspace, Ray.new(unitRay.Origin, unitRay.Direction * 1000), ignoreList);

                for character, characterTrackers in pairs(trackers) do
                    local DoBackTrack = table.find(characterTrackers, part);
                    if (DoBackTrack and hitbox) then
                        args[3] = (hitbox[aimbotSettings.lock_on].CFrame.Position + (Vector3.new(random(1, 10), random(1, 10), random(1, 10)) / 10)) - args[4]
                        return initProjectile(unpack(args));
                    end
                end
            end
        end
    end
    return initProjectile(...);
end);


local mainWindow = UILibrary:CreateWindow("Fate Hub", "Bad Business", Color3.fromRGB(100, 0, 255));

local visuals = mainWindow:Tab("Visuals");
local players_esp = visuals:Section("ESP");
local team_colors = espSettings.team_colors
players_esp:Toggle("Enable Esp", espSettings.enabled, function(callback)
    espSettings.enabled = callback
    Visuals:SetProperties("Box", {
        Visible = callback and espSettings.box_esp
    });
    Visuals:SetProperties("Chams", {
        Visible = callback and espSettings.chams_enabled
    });
    Visuals:SetProperties("Text", {
        Visible = callback and espSettings.names_enabled
    });
    Visuals:SetProperties("Line", {
        Visible = callback and espSettings.tracers_enabled
    });
end):Colorpicker(espSettings.color, function(callback)
    espSettings.team_colors = false
    espSettings.color = callback
    Visuals:SetProperties({"Box", "Text", "Line"}, {
        Color = callback
    });
    Visuals:SetProperties("Chams", {
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
end);
players_esp:Toggle("Show Distance", espSettings.distance_enabled, function(callback)
    espSettings.distance_enabled = callback
end);
players_esp:Toggle("Box Esp", espSettings.box_esp, function(callback)
    espSettings.box_esp = callback
    Visuals:SetProperties("Box", {
        Visible = callback
    });
end):Colorpicker(espSettings.box_color, function(callback)
    espSettings.box_color = callback
    Visuals:SetProperties("Box", {
        Color = callback
    });
end);
players_esp:Toggle("Enable Chams", espSettings.chams_enabled, function(callback)
    espSettings.chams_enabled = callback
    Visuals:SetProperties("Chams", {
        Visible = callback
    });
end):Colorpicker(espSettings.chams_color, function(callback)
    espSettings.chams_color = callback
    Visuals:SetProperties("Chams", {
        FillColor = callback
    });
end);
players_esp:Toggle("Enable Tracers", espSettings.tracers_enabled, function(callback)
    espSettings.tracers_enabled = callback
    Visuals:SetProperties("Line", {
        Visible = callback
    });
end):Colorpicker(espSettings.tracer_color, function(callback)
    espSettings.tracer_color = callback
    Visuals:SetProperties("Line", {
        Color = callback
    });
end);
players_esp:Toggle("Chams Outline", espSettings.chams_outline, function(callback)
    espSettings.chams_outline = callback
    Visuals:SetProperties("Chams", {
        OutlineTransparency = callback and 0 or 1
    });
end):Colorpicker(espSettings.chams_outline_color, function(callback)
    espSettings.chams_outline_color = callback
    Visuals:SetProperties("Chams", {
        OutlineColor = callback
    });
end);
players_esp:Toggle("Team Colors", team_colors, function(callback)
    espSettings.team_colors = callback
    if (not callback) then
        Visuals:SetProperties({"Line", "Text", "Box"}, {
            Color = espSettings.color
        });
    end
end);
local fn = function(callback)
    if (callback == "Enemies") then
        table.insert(espSettings.show_teams, teamsPlayers[localPlayer]);
    end
    if (callback == "Allies") then
        local teamsChildren = Services.Teams:GetChildren();
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
    Visuals:SetProperties("Line", {
        From = Point2D.new(positions[callback]);
    });
end);
players_esp:Slider("Render Distance", 0, 50000, math.clamp(espSettings.render_distance, 0, 50000), function(callback)
    espSettings.render_distance = callback
end, false);

local character = visuals:Section("Self");
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

visuals:Section("");

local world = visuals:Section("World");
world:Toggle("No Shadows", false, function(callback)
    for i, v in pairs(game:GetDescendants()) do
        if (IsA(v, "PointLight") or IsA(v, "SurfaceLight") or IsA(v, "SpotLight")) then
            v.Enabled = callback
            v.Shadows = not callback
            v.Range = math.huge
        end
    end
    Services.Lighting.GlobalShadows = not callback
end);
world:Slider("Time of Day", 0, 24, floor(Services.Lighting.ClockTime), function(callback)
    Services.Lighting.ClockTime = callback
end);
world:Colorpicker("Color Correction", Services.Lighting.ColorCorrection.TintColor, function(callback)
    Services.Lighting.ColorCorrection.TintColor = callback
end);

visuals:Section("");

local other = visuals:Section("Other");
other:Toggle("Show Backtrack Hitbox", backtrackSettings.show_backtrack, function(callback)
    backtrackSettings.show_backtrack = callback
end):Colorpicker(backtrackSettings.backtrack_color, function(callback)
    backtrackSettings.backtrack_color = callback
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
aim:Slider("TriggerBot MS", 0, 3000, aimbotSettings.triggerbotMS, function(callback)
    aimbotSettings.triggerbotMS = callback
end, false);
aim:Slider("Lock Smoothness", 1, 10, aimbotSettings.smoothness, function(callback)
    aimbotSettings.smoothness = callback
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
ragemain:Toggle("Silent Aim", rageSettings.silent_aim, function(callback)
    rageSettings.silent_aim = callback
end);
ragemain:Toggle("Wallbang", rageSettings.wallbang, function(callback)
    rageSettings.wallbang = callback
end);
ragemain:Toggle("Kill aura", rageSettings.kill_aura, function(callback)
    rageSettings.kill_aura = callback
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
        flyChar(currentCamera, aliveCharacters[localPlayer].Root, 5);
    else
        flying = false
    end
end);
movement:Slider("Walkspeed", 0, 150, movementSettings.walkspeed, function(callback)
    movementSettings.walkspeed = callback
end);

local antiAim = rage:Section("Anti aim");
