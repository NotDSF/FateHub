
if getgenv().FatesHub then error("Fates Hub already loaded!"); end;
getgenv().FatesHub = true;

ToastType = ToastType or {};

type Main = {
    Toggle: (self: Main, name: string, default: boolean?, callback: (value: boolean) -> nil) -> nil,
    Dropdown: (self: Main, name: string, start: string, list: {}, callback: (selected: string) -> nil) -> nil,
    Slider: (self: Main, name: string, min: number, max: number, default: number, callback: (value: number) -> nil, nofill: boolean?, floor: boolean?) -> nil,
    Colorpicker: (self: Main, name: string, StartingColor: Color3, callback: (color: Color3) -> nil) -> nil,
    Keybind: (self: Main, name: string, StartingKey: Enum.KeyCode?, onset: (keycode: Enum.KeyCode) -> nil, oninput: () -> nil) -> nil,
    Button: (self: Main, name: string, callback: () -> nil) -> nil
}

type Section = { Section: (self: Section, name: string) -> Main }
type Window = { Tab: (self: Window, name: string) -> Section }
type Library = { CreateWindow: (self: Library, name: string, game: string) -> Window }

local TNow = tick();
local Lib: Library = loadstring(readfile("UILib.lua"))();
local Window = Lib:CreateWindow("FH", "Arsenal");

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
local Delay = task.delay;
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
local ModCheck = GetLocal("isMod");
local RotCamera = GetFunction("RotCamera");
local ammocount = Variables.ammocount;
local equipped = Variables.equipped;
local currentspread = GetLocal("currentspread").currentspread;

BackupIndex = hookmetamethod(Game, "__index", newcclosure(function(self, idx) 
    if idx == "WalkSpeed" then
        return 16;
    elseif idx == "JumpPower" then
        return 50;
    elseif Flags.InfiniteAmmo and self == ammocount and idx == "Value" then
        return 100;
    elseif Flags.FieldOfView and self == Camera and idx == "FieldOfView" then
        return Flags.FieldOfView;
    elseif Flags.NoSpread and self == currentspread and idx == "Value" then
        return 0;
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

local function GetClosestPlayer(novisible) 
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

-- Legit
do 
    local LegitTab = Window:Tab("Legit");

    local Options = LegitTab:Section("Options");
    Options:Toggle("Team Check", false, function(value) Flags.TeamCheck = value; end);

    local RageBot = LegitTab:Section("Rage");
    RageBot:Toggle("Enabled", false, function(value) Flags.RageBot = value; end);
    RageBot:Toggle("Visible Check", false, function(value) Flags.RageVisible = value; end);
    RageBot:Dropdown("Target", "Head", {"Head", "HumanoidRootPart"}, function(selected) Flags.RageTarget = selected; end);

    local TriggerBot = LegitTab:Section("Trigger");
    TriggerBot:Toggle("Enabled", false, function(value) Flags.TriggerBot = value; end);    
    TriggerBot:Slider("Delay", 0, 10, 0, function(value) Flags.TriggerBotDelay = value end);

    local Aimbot = LegitTab:Section("Aimbot");
    Aimbot:Toggle("Enabled", false, function(value) Flags.Aimbot = value end);
    Aimbot:Toggle("Visible Check", true, function(value) Flags.AimbotVisible = value; end);
    Aimbot:Dropdown("Target", "Head", {"Head", "HumanoidRootPart"}, function(selected) Flags.AimbotTarget = selected; end);

    local Weapon = LegitTab:Section("Weapon");
    Weapon:Toggle("Infinite Ammo", false, function(value) Flags.InfiniteAmmo = value; end);
    Weapon:Toggle("No Recoil", false, function(value) Flags.NoRecoil = value; end);
    Weapon:Toggle("No Spread", false, function(value) Flags.NoSpread = value; end);

    Flags.AimbotVisible = true;
    Flags.TriggerBotDelay = 0;
end;

-- Player
do 
    local Player = Window:Tab("Player");
    local Main = Player:Section("Main");

    Main:Slider("WalkSpeed", 1, 200, LocalPlayer.Character.Humanoid.WalkSpeed, function(value) 
        Flags.WalkSpeed = value;
    end);

    Main:Slider("JumpHeight", 1, 200, LocalPlayer.Character.Humanoid.JumpHeight, function(value) 
        Flags.JumpHeight = value;
    end);

    local AntiAim = Player:Section("Anti Aim");
    AntiAim:Toggle("Auto Crouch", false, function(value) Flags.AutoCrouch = value; end);
    AntiAim:Slider("Delay", 0, 10, 0, function(value) Flags.AntiAimDelay = value; end);

    Flags.AntiAimDelay = 0;
end;

-- Visual
do 
    local Visual = Window:Tab("Visual");
    local Main = Visual:Section("Main");

    Main:Slider("FOV", 1, 150, 70, function(value) Flags.FieldOfView = value; end);
end;

-- Misc
do 
    local Misc = Window:Tab("Misc");
    local Main = Misc:Section("Main");

    Main:Toggle("Staff Check", false, function(value) 
        if value then
            for i,v in Pairs(GetChildren(GPlayers)) do
                if ModCheck.isMod(v) then
                    SynapseNotification("A moderator is in your game!", ToastType.Warning);
                end;
            end;
        end;
        Flags.ModCheck = value;
    end);
end;

local Mouse = LocalPlayer:GetMouse();

game.Players.PlayerAdded:Connect(function(player) 
    if Flags.ModCheck and ModCheck.isMod(player) then
        SynapseNotification("A moderator is in your game!", ToastType.Warning);
    end;
end);

game.RunService.RenderStepped:Connect(function() 
    if equipped.Value == "none" then return end;

    if Flags.Aimbot and IsMouseButtonPressed(UserInputService, MouseButton2) then
        local Closest = GetClosestPlayer(not Flags.AimbotVisible);
        if Closest then
            local Target = Flags.AimbotTarget or "Head";
            Camera.CFrame = CFrame(Camera.CFrame.Position, Closest.Character[Target].Position);
        end;
    end;

    if Flags.TriggerBot then
        if Mouse.Target and Mouse.Target then
            local Head = LocalPlayer.Character.Head.Position;
            local Params = RaycastParams();
            Params.FilterDescendantsInstances = { LocalPlayer.Character, Camera, Workspace.Map.Ignore };
            
            local Result = Raycast(Workspace, Head, Mouse.Target.Position - Head, Params);
            if Result and FindFirstChild(GPlayers, Result.Instance.Parent.Name) then
                local Player = FindFirstChild(GPlayers, Result.Instance.Parent.Name);
                -- Cannot return due to it not reaching other FLAGS!
                if Flags.TeamCheck then
                    if Player.TeamColor ~= LocalPlayer.TeamColor then
                        Delay(Flags.TriggerBotDelay, Weapon.firebullet);
                    end;
                else
                    Delay(Flags.TriggerBotDelay, Weapon.firebullet);
                end;
            end;
        end;
    end;

    if Flags.RageBot and FindFirstChild(LocalPlayer.Character, "HumanoidRootPart") then
        local Closest = GetClosestPlayer(not Flags.RageVisible);

        if Closest then
            local Head = LocalPlayer.Character.Head.Position;
            local Params = RaycastParams();
            Params.FilterDescendantsInstances = { LocalPlayer.Character, Camera, Workspace.Map.Ignore };
    
            local Target = Closest.Character[Flags.RageTarget or "Head"].Position;
            local Result = Raycast(Workspace, Head, Target - Head, Params);
            if Result and IsDescendantOf(Result.Instance, Closest.Character) then
                Camera.CFrame = CFrame(Camera.CFrame.Position, Target);
                Weapon.firebullet();
            end;
        end;
    end;

    if Flags.AutoCrouch then
        local ctrlcrouch = Crouch.ctrlcrouch; 
        Delay(Flags.AntiAimDelay, function() 
            ctrlcrouch.Value = not ctrlcrouch.Value;
        end);
    end;
end);

SynapseNotification(string.format("Loaded in %ss", tick() - TNow), ToastType.Success);
