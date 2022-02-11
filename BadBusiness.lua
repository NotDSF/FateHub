-- not done
local ProtectInstance = loadstring(readfile("ProtectInstance.lua"))();

if (not ProtectInstance) then error("protectinstance  missing"); return end

local Workspace = game:GetService("Workspace");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService")
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse();

local CurrentCamera = Workspace.CurrentCamera

local Settings = {
    NoRecoil = false,
    InstantAimTime = false,
    FireMode = nil, --[[ Auto, Semi, Burst ]]
    FieldOfView = nil,
    FireRate = nil, --[[ 1 - 10 ]]

    Aimbot = false,
    AimlockKey = Enum.UserInputType.MouseButton2,

    SilentAim = true,
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

local Network = filtergc("table", {
    Keys = { "Characters", "Teams" }
})[1];

local WeaponConfigDefault = filtergc("table", {
    Keys = { "Controller", "Animators", "Model", "Slot", "Category" }
});

local UpdateWeaponSettings = function()
    for Index, Value in pairs(WeaponConfigDefault) do
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
            end
        end
        local FireModeList = Value.FireModeList
        if (Settings.FireMode and type(FireModeList) == 'table') then
            Value.FireModeList = {Settings.FireMode}
        end
    end
end

local SetFOV = function(FOV)
    Network.Camera.FieldOfView = math.clamp(FOV or 90 --[[Default is 90]], 45, 270);
end

local OldAnims = {}
local Keys = {}

UserInputService.InputEnded:Connect(function(Key, GPE)
    local KeyString = string.split(tostring(Key.KeyCode), ".")[3]
    if (not GPE and Keys[KeyString]) then
        Keys[KeyString] = false
    end

    if (Settings.Aimbot and Key.KeyCode == Settings.AimlockKey and Locked) then
        Locked = false
    end
end)
UserInputService.InputBegan:Connect(function(Key, GPE)
    local KeyString = string.split(tostring(Key.KeyCode), ".")[3]
    if (not GPE) then
        Keys[KeyString] = true
    end

    if (Settings.Aimbot and Key.KeyCode == Settings.AimlockKey) then
        Locked = true
    end
end)

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
    local wait = task.wait
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

-- Settings.NoRecoil = true
-- Settings.InstantAimTime = true
-- Settings.FireMode = "Auto"
-- UpdateWeaponSettings();
-- SetFOV(180);

-- wait(5);
-- FlyCharacter(nil, Network.Characters:GetCharacter(LocalPlayer).Root, nil, 10);


local FOV = Drawing.new("Circle");
FOV.Color = Color3.fromRGB(255, 255, 255);
FOV.Thickness = 1
FOV.Transparency = 1
FOV.Filled = false
FOV.Radius = 150
FOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36);
FOV.Visible = true

local Characters = {}
local Teams = {}

for Index, Player in pairs(Players:GetPlayers()) do
    local Character = Network.Characters:GetCharacter(Network.Characters, Player);
    if (Character) then
        Characters[Player] = Character
        local Destroying;
        Destroying = Character.Destroying:Connect(function()
            Characters[Player] = nil
            Destroying:Disconnect();
        end)
    end

    local Team = Network.Teams:GetPlayerTeam(Player);
    Teams[Player] = Team
end
Network.Characters.CharacterAdded:Connect(function(Player, Character)
    Characters[Player] = Character
end)
Network.Teams.TeamChanged:Connect(function(Player, Team)
    Teams[Player] = Team
end)

local GetClosestPlayerVec2 = function()
    local Closest = table.create(2);
    local Vector2Distance = math.huge

    local MouseVector = Vector2.new(Mouse.X, Mouse.Y);
    for Player, Character in pairs(Characters) do
        local CharacterRoot = Character:FindFirstChild("Root");
        if (CharacterRoot) then
            local Tuple, Visible = CurrentCamera:WorldToScreenPoint(CharacterRoot.Position);
            local Vector2Magnitude = (MouseVector - Vector2.new(Tuple.X, Tuple.Y)).Magnitude;
            if (Visible and Vector2Magnitude <= Vector2Distance and Vector2Magnitude <= FOV.Radius) then
                Vector2Distance = Vector2Magnitude
                Closest = {Character, Player}
            end
        end
    end
    return Closest[1], Closest[2]
end


local IsEnemy = function(Player)
    return Teams[LocalPlayer] ~= Teams[Player]
end


RunService.RenderStepped:Connect(function()
    FOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36);

    if (Locked) then
        local ClosestCharacter, Player = GetClosestPlayerVec2();
        if (ClosestCharacter and Player and IsEnemy(Player)) then
            local Root = ClosestCharacter.Root
            CurrentCamera.CFrame = Root.CFrame
        end
    end
end)

debug.setupvalue(Network.Projectiles.KillProjectile, 1, true);

local OldInitProjectile = Network.Projectiles.InitProjectile
Network.Projectiles.InitProjectile = function(...)
    local Args = {...}
    if (Settings.SilentAim and Args[5] == LocalPlayer) then
        local ClosestCharacter, Player = GetClosestPlayerVec2();
        if (ClosestCharacter and Player and IsEnemy(Player)) then
            local CharacterRoot = ClosestCharacter.Root
            local Viewable = CurrentCamera:GetPartsObscuringTarget({CurrentCamera.CFrame.Position, CharacterRoot.CFrame.Position}, {Characters[LocalPlayer], ClosestCharacter});
            if (#Viewable == 0 or Settings.Wallbang) then
                Args[3] = (CharacterRoot.CFrame.Position + (Vector3.new(math.random(1, 10), math.random(1, 10), math.random(1, 10)) / 10)) - Args[4]
                return OldInitProjectile(unpack(Args));
            end
        end
    end
    return OldInitProjectile(...);
end
