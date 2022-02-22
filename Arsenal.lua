if getgenv().FatesHub then error("Fates Hub already loaded!"); end;
getgenv().FatesHub = true;

ToastType = ToastType or {};

type Toggle = { UpdateToggle: (self: Toggle, toset: boolean) -> nil, UpdateTitle: (self: Toggle, name: string) -> nil }
type Dropdown = { UpdateList: (self: Dropdown, list: {}) -> nil, UpdateTitle: (self: Dropdown, name: string) -> nil }
type Colorpicker = { UpdateColor: (self: Colorpicker, NewColor: Color3) -> nil, UpdateTitle: (self: Colorpicker, name: string) -> nil }
type Keybind = { UpdateBind: (self: Keybind, NewKeybind: Enum.KeyCode) -> nil, UpdateTitle: (self: Keybind, name: string) -> nil }
type UserInput = { UpdateInput: (self: UserInput, NewInput: string) -> nil, UpdateTitle: (self: UserInput, name: string) -> nil }
type Button = { UpdateTitle: (self: Button, name: string) -> nil }
type Slider = {
    UpdateValue: (self: Slider, value: number) -> nil,
    UpdateMin: (self: Slider, min: number) -> nil,
    UpdateMax: (self: Slider, max: number) -> nil,
    UpdateTitle: (self: Slider, name: string) -> nil
}

type Main = {
    Toggle: (self: Main, name: string, default: boolean?, callback: (value: boolean) -> nil) -> Toggle,
    Dropdown: (self: Main, name: string, start: string, list: {}, callback: (selected: string) -> nil) -> Dropdown,
    Slider: (self: Main, name: string, min: number, max: number, default: number, callback: (value: number) -> nil, nofill: boolean?, floor: boolean?) -> Slider,
    Colorpicker: (self: Main, name: string, StartingColor: Color3, callback: (color: Color3) -> nil) -> Colorpicker,
    Keybind: (self: Main, name: string, StartingKey: Enum.KeyCode?, onset: (keycode: Enum.KeyCode) -> nil, oninput: () -> nil) -> Keybind,
    Button: (self: Main, name: string, callback: () -> nil) -> Button,
    UserInput: (self: Main, default: string, callback: () -> nil) -> UserInput
}

type Section = { Section: (self: Section, name: string) -> Main }
type Window = { Tab: (self: Window, name: string) -> Section, VisiblityKey: Enum.KeyCode }
type Library = { CreateWindow: (self: Library, name: string, game: string, colorscheme: Color3?) -> Window }

local TNow = tick();
local Lib: Library = loadstring(readfile("UILib.lua"))();
local Window = Lib:CreateWindow("FH", "Arsenal", Color3.fromRGB(255, 50, 150));
Window:SetKeybindClose(Enum.KeyCode.F5);

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
--local GetDescendants = Game.GetDescendants;
local IsA = Game.IsA;
local Raycast = Workspace.Raycast;
--local match = string.match;
local RaycastParams = RaycastParams.new();
local CFrame = CFrame.new;
local sort = table.sort;
local info = debug.info;
local Delay = task.delay;
local Tick = tick;
local fromHSV = Color3.fromHSV;
local MouseButton2 = Enum.UserInputType.MouseButton2;
local Type = typeof;
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
local Gun = GetLocal("gun").gun;

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

local function GetClosestPlayer(novisible, maxdistance) 
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
                local Between = (HumanoidRootPart.Position - LPos).magnitude;

                if maxdistance and Between > maxdistance then continue; end;

                if novisible then -- doesnt care about visibilty
                    Players[#Players+1] = {Between, v};
                    continue;
                end;

                local _, Visible = WorldToViewportPoint(Camera, HumanoidRootPart.Position);
                if Visible then
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
    RageBot:Slider("Max Distance", 1, 9999, 9999, function(value) Flags.RageBotMaxDistane = value; end);

    local TriggerBot = LegitTab:Section("Trigger");
    TriggerBot:Toggle("Enabled", false, function(value) Flags.TriggerBot = value; end);    
    TriggerBot:Slider("Delay", 0, 10, 0, function(value) Flags.TriggerBotDelay = value end);

    local Aimbot = LegitTab:Section("Aimbot");
    Aimbot:Toggle("Enabled", false, function(value) Flags.Aimbot = value end);
    Aimbot:Toggle("Visible Check", true, function(value) Flags.AimbotVisible = value; end);
    Aimbot:Dropdown("Target", "Head", {"Head", "HumanoidRootPart"}, function(selected) Flags.AimbotTarget = selected; end);
    Aimbot:Slider("Max Distance", 1, 9999, 9999, function(value) Flags.AimbotMaxDistance = value; end)

    local Weapon = LegitTab:Section("Weapon");
    Weapon:Toggle("Infinite Ammo", false, function(value) Flags.InfiniteAmmo = value; end);
    Weapon:Toggle("Rapid Fire", false, function(value) Flags.RapidFire = value; end);
    Weapon:Toggle("Rapid Reload", false, function(value) Flags.RapidReload = value; end);
    Weapon:Toggle("No Recoil", false, function(value) Flags.NoRecoil = value; end);
    Weapon:Toggle("No Spread", false, function(value) Flags.NoSpread = value; end);
    Weapon:Toggle("Rainbow Weapon", false, function(value) Flags.WepRainbow = value; end);

    Flags.AimbotVisible = true;
    Flags.TriggerBotDelay = 0;
    Flags.AimbotMaxDistance = 9999;
    Flags.RageBotMaxDistane = 9999;
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

    Main:Toggle("Full Bright", false, function(value) game.Lighting.Brightness = value and 5 or 3; end);
    Main:Toggle("Shadows", game.Lighting.GlobalShadows, function(value) game.Lighting.GlobalShadows = value; end);
    Main:Slider("FOV", 1, 70, 70, function(value) Flags.FieldOfView = value; end);
    Main:Slider("Time", 1, 24, string.match(game.Lighting.TimeOfDay, "(%d+):%d+:%d+") + 0, function(value) game.Lighting.TimeOfDay = string.format("%d:00:00", value); end);
end;

-- Misc
do 
    local Misc = Window:Tab("Misc");
    local Main = Misc:Section("Main");

    Main:Toggle("Staff Check", true, function(value) 
        if value then
            for i,v in Pairs(GetChildren(GPlayers)) do
                if ModCheck.isMod(v) then
                    SynapseNotification("A moderator is in your game!", ToastType.Warning);
                end;
            end;
        end;
        Flags.ModCheck = value;
    end);
    
    local Options = Misc:Section("Options");
    Options:Keybind("UI Open", Enum.KeyCode.F5, function(Keybind) WindowOptions.VisiblityKey = Keybind; end, function() end);

    for i,v in Pairs(GetChildren(GPlayers)) do
        if ModCheck.isMod(v) then
            SynapseNotification("A moderator is in your game!", ToastType.Warning);
        end;
    end;

    Flags.ModCheck = true;

    --[[
            local Config = Misc:Section("Configs");
    Config:Button("Save Config", function() 
        writefile("test.json", Window:GenerateConfig());
    end);

    Config:Button("Load Config", function() 
        Window:LoadConfig(readfile("test.json"));
    end);
    ]]
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
        local Closest = GetClosestPlayer(not Flags.AimbotVisible, Flags.AimbotMaxDistance);
        if Closest then
            local Target = Flags.AimbotTarget or "Head";
            Camera.CFrame = CFrame(Camera.CFrame.Position, Closest.Character[Target].Position);
        end;
    end;

    if Flags.TriggerBot then
        if Mouse.Target and Mouse.Target then
            local Head = LocalPlayer.Character.Head.Position;
            RaycastParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera, Workspace.Map.Ignore };
            
            local Result = Raycast(Workspace, Head, Mouse.Target.Position - Head, RaycastParams);
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
        local Closest = GetClosestPlayer(not Flags.RageVisible, Flags.RageBotMaxDistane);

        if Closest then
            local Head = LocalPlayer.Character.Head.Position;
            RaycastParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera, Workspace.Map.Ignore };
    
            local Target = Closest.Character[Flags.RageTarget or "Head"].Position;
            local Result = Raycast(Workspace, Head, Target - Head, RaycastParams);
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

    if Flags.WepRainbow and FindFirstChild(Camera, "Arms") then
        for i,v in Pairs(GetChildren(Camera.Arms)) do
            if IsA(v, "MeshPart") then
                local Hue = (Tick() / 5) % 1; -- fates esp coming in clutch
                v.Color = fromHSV(Hue, 1, 1);
            end;
        end;
    end;

    if Flags.RapidFire and Gun.Value then
        local FireRate = FindFirstChild(Gun.Value, "FireRate");
        if FireRate and FireRate.Value ~= .02 then
            FireRate.Value = .02; -- setting to 0 will make you crash
        end;
    end;

    if Flags.RapidReload and Gun.Value then
        local ReloadTime = FindFirstChild(Gun.Value, "ReloadTime");
        if ReloadTime and ReloadTime.Value ~= .02 then
            ReloadTime.Value = .02;
        end;
    end;
end);

SynapseNotification(string.format("Loaded in %ss", Tick() - TNow), ToastType.Success);
