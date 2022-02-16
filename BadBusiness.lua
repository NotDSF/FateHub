-- not done
local ProtectInstance = loadstring(readfile("ProtectInstance.lua"))();

-- if (not ProtectInstance) then error("protectinstance  missing"); return end

local wait = task.wait

local Workspace = game:GetService("Workspace");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService")
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse();
local MouseVector = Vector2.new(Mouse.X, Mouse.Y + 36);

local CurrentCamera = Workspace.CurrentCamera

local Settings = {
    NoRecoil = false,
    InstantAimTime = false,
    FireMode = nil, --[[ Auto, Semi, Burst ]]
    FieldOfView = nil,
    FireRate = nil, --[[ 1 - 10 ]]

    FovRadius = 150,

    Aimbot = false,
    AimlockKey = Enum.UserInputType.MouseButton2,
    Smoothnes = 1,

    Redirect = "Head",

    ClosestCursor = false,
    ClosestPlayer = false,

    Backtrack = false,
    BacktrackMS = 500,
    ShowBacktrack = false,

    Triggerbot = false,
    TriggerbotMS = 0,

    SilentAim = false,
    Wallbang = false
}

local Locked = false

local filtergc = filtergc or function(Type, Args)
    local Results = {}
    for Index, Value in pairs(getgc(true)) do
        if (type(Value) == Type) then
            local Keys = Args.Keys
            local Good = true
            for Index2, Value2 in pairs(Keys) do
                if (not rawget(Value, Value2)) then
                    Good = false
                    break
                end
            end
            if (Good) then
                table.insert(Results, Value);
            end
        end
    end
    return Results
end

local TS = filtergc("table", {
    Keys = { "Characters", "Teams" }
})[1];
local Network = TS.Network

local WeaponConfigDefault = filtergc("table", {
    Keys = { "Controller", "Animators", "Model", "Slot", "Category" }
});

local Characters = {}
local Teams = {}
local Trackers = {}
local Keys = {}
local OldAnims = {}


local UpdateWeaponSettings = function()
    local Items = Characters[LocalPlayer]:WaitForChild("Backpack"):WaitForChild("Items");

    for Index, Value in pairs(WeaponConfigDefault) do
        if (Items:FindFirstChild(Value.Model)) then
            local Recoil = Value.Recoil
            if (Settings.NoRecoil and Recoil and type(Recoil) == 'table') then
                local RecoilSettings = Recoil.Default
                if (RecoilSettings) then
                    RecoilSettings.RecoilMovement =  Vector2.new(1, 1);
                    RecoilSettings.CameraRotationVariance = Vector3.new(1, 1);
                    RecoilSettings.RecoilMovementVariance = Vector2.new(1, 1);
                    RecoilSettings.RecoilRecenterTime = 0
                    RecoilSettings.RecoilMovementTime = 0
                    RecoilSettings.RecoilCrouchScale = 0
                    RecoilSettings.RecoileProneScale = 0
                end
            end
            local Aim = Value.Aim
            if (Settings.InstantAimTime and Aim and type(Aim) == 'number') then
                if (type(Aim.AimTime) == 'number') then
                    Aim.AimTime = 0
                    print(true, Value.Model);
                end
            end
            local FireModeList = Value.FireModeList
            if (Settings.FireMode and type(FireModeList) == 'table') then
                Value.FireModeList = {Settings.FireMode}
            end
        end
    end
end

local SetFOV = function(FOV)
    TS.Camera.FieldOfView = math.clamp(FOV or 90 --[[Default is 90]], 45, 270);
end

local FlyCharacter = function(Camera, Root, Humanoid, Speed)
    local BodyGyro = Instance.new("BodyGyro");
    local BodyVelocity = Instance.new("BodyVelocity");

    local Character = Root.Parent
    local Animate = Character:FindFirstChild("Animate");

    if (Animate) then
        pcall(function()
            local IdleAnim1 = "507766388"

            local Run = Animate.run.RunAnim
            OldAnims[Run] = Run.AnimationId
            Run.AnimationId = IdleAnim1
            local Walk = Animate.walk.WalkAnim
            OldAnims[Walk] = Walk.AnimationId
            Walk.AnimationId = IdleAnim1
            local Fall = Animate.fall.FallAnim
            OldAnims[Fall] = Fall.AnimationId
            Fall.AnimationId = IdleAnim1
            local Jump = Animate.jump.JumpAnim
            OldAnims[Jump] = Jump.AnimationId
            Jump.AnimationId = IdleAnim1
        end)
    end

    ProtectInstance(BodyGyro);
    ProtectInstance(BodyVelocity);
    BodyGyro.Parent = Root
    BodyVelocity.Parent = Root
    BodyGyro.P = 9e9
    BodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 9e9
    BodyGyro.CFrame = Root.CFrame
    BodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 9e9
    BodyVelocity.Velocity = Vector3.new(0, 0.1, 0);
    Humanoid = Humanoid or Character:FindFirstChildOfClass("Humanoid");
    if (Humanoid) then
        Humanoid:ChangeState(8);
        Humanoid.StateChanged:Connect(function()
            Humanoid:ChangeState(8);
            Humanoid.PlatformStand = false
        end);
    end

    local Table1 = { W = 0; A = 0; S = 0; D = 0 }
    Camera = Camera or CurrentCamera
    Speed = math.clamp(Speed or 3, 1, 9);
    task.spawn(function()
        while (true) do
            Table1["W"] = Keys["W"] and Speed or 0
            Table1["A"] = Keys["A"] and -Speed or 0
            Table1["S"] = Keys["S"] and -Speed or 0
            Table1["D"] = Keys["D"] and Speed or 0
            if ((Table1["W"] + Table1["S"]) ~= 0 or (Table1["A"] + Table1["D"]) ~= 0) then
                BodyVelocity.Velocity = ((Camera.CoordinateFrame.lookVector * (Table1["W"] + Table1["S"])) + ((Camera.CoordinateFrame * CFrame.new(Table1["A"] + Table1["D"], (Table1["W"] + Table1["S"]) * 0.2, 0).Position) - Camera.CoordinateFrame.Position)) * 50
            else
                BodyVelocity.Velocity = Vector3.new(0, 0.1, 0);
            end
            BodyGyro.CFrame = Camera.CoordinateFrame
            wait()
        end
    end);
end

local FOV = Drawing.new("Circle");
FOV.Color = Color3.fromRGB(255, 255, 255);
FOV.Thickness = 1
FOV.Transparency = 1
FOV.Filled = false
FOV.Radius = Settings.FovRadius
FOV.Position = MouseVector
FOV.Visible = true

local SnapLine = Drawing.new("Line");
SnapLine.Color = Color3.fromRGB(255, 255, 255);
SnapLine.Thickness = .1
SnapLine.Transparency = 1
SnapLine.From = MouseVector

task.spawn(function()
    while task.wait(Settings.BacktrackMS / 1000) do
        for Character, CharTrackers in pairs(Trackers) do
            for Index2, Tracker in pairs(CharTrackers) do
                Tracker:Destroy();
            end
        end
    end
end)

local HandleTracking = function(Player, Character)
    Trackers[Character] = {}
    while true do
        if (Settings.Backtrack) then
            local Root = Character:FindFirstChild("Root");
            if (Root and Character.Parent) then
                local Cloned = Instance.new("Part");
                Cloned.CFrame = Root.CFrame
                Cloned.Anchored = true
                Cloned.CanCollide = false
                Cloned.Transparency = Settings.ShowBacktrack and .4 or 1
                Cloned.Size = Vector3.new(1.6, 4, 1.2);
                Cloned.Parent = Workspace
                table.insert(Trackers[Character], Cloned);
            else
                break;
            end
        end
        wait();
    end
end

local IsEnemy = function(Player)
    return Teams[LocalPlayer] ~= Teams[Player]
end

for Index, Player in pairs(Players:GetPlayers()) do
    local Team = TS.Teams:GetPlayerTeam(Player);
    Teams[Player] = Team

    local Character = TS.Characters:GetCharacter(Player);
    if (Character) then
        Characters[Player] = Character
        Character.AncestryChanged:Connect(function()
            Characters[Player] = nil
        end)
        Character:WaitForChild("Root");
        if (IsEnemy(Player)) then
            task.spawn(HandleTracking, Player, Character);
        end
        if (Player == LocalPlayer) then
            UpdateWeaponSettings();
        end
    end
end
TS.Characters.CharacterAdded:Connect(function(Player, Character)
    Characters[Player] = Character
    local Root = Character:WaitForChild("Root");
    if (IsEnemy(Player)) then
        HandleTracking(Player, Character);
    end
    Character.AncestryChanged:Connect(function()
        Characters[Player] = nil
    end)
    if (Player == LocalPlayer) then
        UpdateWeaponSettings();
    end
end)
TS.Teams.TeamChanged:Connect(function(Player, Team)
    Teams[Player] = Team
end)

local GetClosestPlayerVec2 = function()
    local Closest = table.create(3);
    local Vector2Distance = math.huge
    local Vector3Distance = math.huge
    local Hitbox = Characters[LocalPlayer] and Characters[LocalPlayer]:FindFirstChild("Hitbox");
    for Player, Character in pairs(Characters) do
        if (Player ~= LocalPlayer and Hitbox and IsEnemy(Player) and Character:FindFirstChild("Hitbox")) then
            if (Hitbox.Parent.Health.Value > 0) then
                local LocalRoot = Hitbox.Parent.Root
                local Position = Character.Hitbox[Settings.Redirect].Position
                local Tuple, Visible = CurrentCamera:WorldToViewportPoint(Position);
                local CharacterVector = Vector2.new(Tuple.X, Tuple.Y);
                local Vector2Magnitude = (MouseVector - CharacterVector).Magnitude;

                if (Visible and Vector2Magnitude <= Vector2Distance and Vector2Magnitude <= FOV.Radius and Settings.ClosestCursor) then
                    Vector2Distance = Vector2Magnitude
                    Closest = {Character, CharacterVector, Player}
                end

                local Vector3Magnitude = (Position - LocalRoot.Position).Magnitude
                if (Visible and Vector3Magnitude <= Vector3Distance and Vector2Magnitude <= FOV.Radius and Settings.ClosestPlayer) then
                    Vector3Distance = Vector3Magnitude
                    Closest = {Character, CharacterVector, Player}
                end
            end
        end
    end
    return unpack(Closest);
end

UserInputService.InputEnded:Connect(function(Key, GPE)
    local KeyString = string.split(tostring(Key.KeyCode), ".")[3]
    if (not GPE and Keys[KeyString]) then
        Keys[KeyString] = false
    end

    if (Settings.Aimbot and Key.UserInputType == Settings.AimlockKey and Locked) then
        Locked = false
    end
end)


UserInputService.InputBegan:Connect(function(Key, GPE)
    local KeyString = string.split(tostring(Key.KeyCode), ".")[3]
    if (not GPE) then
        Keys[KeyString] = true
    end

    if (Settings.Aimbot and Key.UserInputType == Settings.AimlockKey) then
        Locked = true
    end
end)

RunService.RenderStepped:Connect(function()
    MouseVector = Vector2.new(Mouse.X, Mouse.Y + 36);

    FOV.Position = MouseVector
    SnapLine.From = MouseVector
    local ClosestCharacter, Vector, Player = GetClosestPlayerVec2();

    if (Locked) then
        if (ClosestCharacter and Player) then
            mousemoverel((Vector.X - MouseVector.X) / Settings.Smoothnes, (Vector.Y - MouseVector.Y) / Settings.Smoothnes);
        end
    end

    if (Vector) then
        SnapLine.To = Vector
        SnapLine.Visible = true
    else
        SnapLine.Visible = false
    end
end)

debug.setupvalue(TS.Projectiles.KillProjectile, 1, true);

local OldInitProjectile = TS.Projectiles.InitProjectile
TS.Projectiles.InitProjectile = function(...)
    local Args = {...}
    if (Settings.SilentAim or Settings.Backtrack and Args[5] == LocalPlayer) then
        local ClosestCharacter, Vector, Player = GetClosestPlayerVec2();
        local Hitbox;
        if (ClosestCharacter and Player) then
            Hitbox = ClosestCharacter.Hitbox
            local Viewable = CurrentCamera:GetPartsObscuringTarget({CurrentCamera.CFrame.Position, Hitbox[Settings.Redirect].CFrame.Position}, {Characters[LocalPlayer], ClosestCharacter});
            if (Settings.SilentAim and #Viewable == 0 or Settings.Wallbang) then
                Args[3] = (Hitbox[Settings.Redirect].CFrame.Position + (Vector3.new(math.random(1, 10), math.random(1, 10), math.random(1, 10)) / 10)) - Args[4]
                return OldInitProjectile(unpack(Args));
            end
        end

        if (Settings.Backtrack) then
            local UnitRay = Mouse.UnitRay
            local LocalCharacter = Characters[LocalPlayer]
            local IgnoreList = {LocalCharacter}
            local EquippedWeapon = LocalCharacter.Backpack.Equipped.Value
            for Index, Child in pairs(Workspace:GetChildren()) do
                if (Child.Name == EquippedWeapon.Name) then
                    table.insert(IgnoreList, Child);
                end
            end
            local Part = Workspace:FindPartOnRayWithIgnoreList(Ray.new(UnitRay.Origin, UnitRay.Direction * 1000), IgnoreList);

            for Character, CharacterTrackers in pairs(Trackers) do
                local DoBackTrack = table.find(CharacterTrackers, Part);
                if (DoBackTrack and Hitbox) then
                    Args[3] = (Hitbox[Settings.Redirect].CFrame.Position + (Vector3.new(math.random(1, 10), math.random(1, 10), math.random(1, 10)) / 10)) - Args[4]
                    return OldInitProjectile(unpack(Args));
                end
            end
        end

    end
    return OldInitProjectile(...);
end

local CheckPlayers;
CheckPlayers = function()
    if (Settings.Triggerbot) then
        local UnitRay = Mouse.UnitRay
        local LocalCharacter = Characters[LocalPlayer]
        if (not LocalCharacter) then return end
        local Backpack = LocalCharacter:FindFirstChild("Backpack");
        if (not Backpack) then return end
        local IgnoreList = {LocalCharacter}
        local EquippedWeapon = LocalCharacter.Backpack.Equipped.Value
        for Index, Child in pairs(Workspace:GetChildren()) do
            if (Child.Name == EquippedWeapon.Name) then
                table.insert(IgnoreList, Child);
            end
        end
        local Part = Workspace:FindPartOnRayWithIgnoreList(Ray.new(UnitRay.Origin, UnitRay.Direction * 1000), IgnoreList);
        local IsPlayer;
        for Player, Character in pairs(Characters) do
            if (Part and IsEnemy(Player) and Part:IsDescendantOf(Character)) then
                IsPlayer = true
                break;
            end
        end
        if (IsPlayer) then
            wait(Settings.TriggerbotMS / 1000);
            mouse1press();
            mouse1release();
            wait();
            CheckPlayers();
        end
    end
end

Mouse.Move:Connect(CheckPlayers);

Settings.NoRecoil = true
Settings.Triggerbot = true
Settings.Aimbot = true
Settings.InstantAimTime = true
Settings.ClosestCursor = true
Settings.Backtrack = true
Settings.ShowBacktrack = true
if (Characters[LocalPlayer]) then
    UpdateWeaponSettings();
end