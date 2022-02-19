
if getgenv().FatesHub then error("Fates Hub already loaded!"); end;
getgenv().FatesHub = true;

ToastType = ToastType or {};

local TNow = tick();
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))();
local UI = Lib.Load({
    Title = "Fates Hub",
    Style = 1,
    SizeX = 500,
    SizeY = 600,
    Theme = "Dark"
});

local Rawget = rawget;
local Type = typeof;
local Getgc = getgc;
local Pairs = pairs;
local ToastNotif = syn.toast_notification;
local Game = game;
local GPlayers = Game.Players;
local LocalPlayer = GPlayers.LocalPlayer;
local UserInputService = Game.UserInputService;
local Workspace = Game.Workspace;
local Camera = Workspace.CurrentCamera;
local WorldToViewportPoint = Camera.WorldToViewportPoint;
local IsMouseButtonPressed = UserInputService.IsMouseButtonPressed;
local GetChildren = Game.GetChildren;
local FindFirstChild = Game.FindFirstChild;
local IsDescendantOf = Game.IsDescendantOf;
local Raycast = Workspace.Raycast;
local RaycastParams = RaycastParams.new;
local CFrame = CFrame.new;
local sort = table.sort;
local info = debug.info;
local MouseButton2 = Enum.UserInputType.MouseButton2;
local Checkcaller = checkcaller;
local Flags = {};
local BackupIndex, BackupNewIndex;

local function GetLocal(index) 
    for i,v in Pairs(Getgc(true)) do
        if Type(v) == "table" and Rawget(v, index) then
            return v;
        end;
    end;
end;

local function GetFunction(name) 
    for i,v in Pairs(Getgc()) do
        if Type(v) == "function" and info(v, "n") == name then
            return v;
        end;
    end;
end;

local format = string.format;
local cprint = rconsoleprint;
local function printf(...) 
    return cprint(format(...) .. "\n");
end;

local function SynapseNotification(Content, Type) 
    if not ToastNotif then return rconsoleprint(Content .. "\n"); end;
    ToastNotif({
        Type = Type or ToastType.Info,
        Duration = 7.5,
        Title = "Fates Hub v1.0.0",
        Content = Content
    });
end;

SynapseNotification("ALERT: You are running a beta version of Fates Hub.\nPlease report any bugs to the discord server.\nIf you aren't you should use an alt.");

local Variables = GetLocal("primarystored");
local Crouch = GetLocal("ctrlcrouch");
local Weapon = GetLocal("firebullet");
local RotCamera = GetFunction("RotCamera");
local ammocount = Variables.ammocount;

BackupIndex = hookmetamethod(Game, "__index", newcclosure(function(self, idx) 
    if idx == "WalkSpeed" then
        return 16;
    elseif idx == "JumpPower" then
        return 50;
    elseif Flags.InfAmmo and self == ammocount and idx == "Value" then
        return 100;
    end;
    return BackupIndex(self, idx);
end));

BackupNewIndex = hookmetamethod(Game, "__newindex", newcclosure(function(self, idx, val) 
    if not Checkcaller() and Flags[idx] then
        val = val + Flags[idx];
    end;
    return BackupNewIndex(self, idx, val);
end));

local BackupRot;
BackupRot = hookfunction(RotCamera, function(...)
    if Flags.NoRecoil then return end;
    return BackupRot(...);
end);

-- Player
do 
    local Player = UI.New({
        Title = "Player"
    });

    Player.Slider({
        Text = "WalkSpeed",
        Min = 1,
        Def = 16,
        Max = 200,
        Callback = function(value) 
            LocalPlayer.Character.Humanoid.WalkSpeed = value;
            Flags.WalkSpeed = value;
        end
    });

    Player.Slider({
        Text = "JumpPower",
        Min = 1,
        Def = 50,
        Max = 200,
        Callback = function(value) 
            LocalPlayer.Character.Humanoid.JumpPower = value;
            Flags.JumpPower = value;
        end;
    });
end;

-- Combat
do 
    local Combat = UI.New({
        Title = "Combat"
    });

    Combat.Toggle({
        Text = "Infinite Ammo",
        Callback = function(bool) 
            Flags.InfAmmo = bool;
        end,
        Enabled = false
    });

    Combat.Toggle({
        Text = "No Recoil",
        Callback = function(bool) 
            Flags.NoRecoil = bool;
        end;
    });

    Combat.Toggle({
        Text = "Trigger Bot",
        Callback = function(bool) 
            Flags.Triggerbot = bool;
        end;
    });

    Combat.Toggle({
        Text = "Rage Bot",
        Callback = function(bool) 
            Flags.Ragebot = bool;
        end;
    });

    Combat.Toggle({
        Text = "Auto Crouch",
        Callback = function(bool) 
            Flags.AutoCrouch = bool;
        end;
    });
end;

-- Aimbot
local GetClosestPlayer; do 
    local Aimbot = UI.New({
        Title = "Aimbot"
    });

    Aimbot.Toggle({
        Text = "Enabled",
        Callback = function(bool) 
            Flags.Aimbot = bool;
        end
    });

    Aimbot.Toggle({
        Text = "Team Check",
        Callback = function(bool) 
            Flags.TeamCheck = bool;
        end
    });

    Aimbot.Dropdown({
        Text = "Target Part",
        Callback = function(value) 
            Flags.AimbotTarget = value;
        end,
        Options = {
            "Head",
            "HumanoidRootPart"
        }
    });

    GetClosestPlayer = function(novisible) 
        if not LocalPlayer.Character or not FindFirstChild(LocalPlayer.Character, "HumanoidRootPart") then return end;
    
        local LPos = LocalPlayer.Character.HumanoidRootPart.Position;
        local Players = {};
    
        for i,v in Pairs(GetChildren(GPlayers)) do
            if v ~= LocalPlayer then
                if Flags.TeamCheck and v.TeamColor == LocalPlayer.TeamColor then 
                    continue;
                end;

                local Character = v.Character;
                local HumanoidRootPart = Character and FindFirstChild(Character, "HumanoidRootPart");
                if HumanoidRootPart then
                    if novisible then -- doesnt care about visibilty
                        local Between = (HumanoidRootPart.Position - LPos).magnitude;
                        Players[#Players+1] = {Between, v};
                        continue;
                    end;

                    local _, Visible = WorldToViewportPoint(Camera, HumanoidRootPart.Position);
                    if Visible then
                        local Between = (HumanoidRootPart.Position - LPos).magnitude;
                        Players[#Players+1] = {Between, v};
                    end;
                end;
            end;
        end;
    
        sort(Players, function(x,y) return x[1] < y[1] end);
    
        return Players[1] and Players[1][2];
    end;
end;

local Mouse = LocalPlayer:GetMouse();

game.RunService.RenderStepped:Connect(function() 
    if Flags.Aimbot and IsMouseButtonPressed(UserInputService, MouseButton2) then
        local Closest = GetClosestPlayer();
        if Closest then
            local Target = Flags.AimbotTarget or "Head";
            Camera.CFrame = CFrame(Camera.CFrame.Position, Closest.Character[Target].Position);
        end;
    end;

    if Flags.Triggerbot then
        if not Mouse.Target or not Mouse.Target.Parent then return end;

        local Parent = Mouse.Target.Parent;
        local Player = FindFirstChild(GPlayers, Parent.Name);
        if not Player or Player == LocalPlayer or Flags.TeamCheck and Player.TeamColor == LocalPlayer.TeamColor then return end;

        Weapon.firebullet();
    end;

    if Flags.Ragebot then
        local Closest = GetClosestPlayer(true); -- will be able to change when we have the new ui
        if not Closest or not FindFirstChild(LocalPlayer.Character, "HumanoidRootPart") then return end;
        
        local Head = LocalPlayer.Character.Head.Position;
        local Params = RaycastParams();
        Params.FilterDescendantsInstances = { LocalPlayer.Character, Camera };

        local Result = Raycast(Workspace, Head, Closest.Character.HumanoidRootPart.Position - Head, Params);
        if Result and IsDescendantOf(Result.Instance, Closest.Character) then
            Camera.CFrame = CFrame(Camera.CFrame.Position, Closest.Character.Head.Position);
            Weapon.firebullet();
        end;
    end;

    if Flags.AutoCrouch then
        local ctrlcrouch = Crouch.ctrlcrouch; 
        ctrlcrouch.Value = not ctrlcrouch.Value;
    end;
end);

SynapseNotification(string.format("Loaded in %ss", tick() - TNow), ToastType.Success);
