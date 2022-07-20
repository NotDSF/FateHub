if FatesHub then error("Fates Hub already loaded!"); end;
getgenv().FatesHub = true;

ToastType = ToastType or {};

if not isfolder("FatesHub") then makefolder("FatesHub") end;
if not isfolder("FatesHub/configs") then makefolder("FatesHub/configs") end;
if not isfolder("FatesHub/configs/BigPaintball") then makefolder("FatesHub/configs/BigPaintball") end;

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

local Import do
    local request = syn.request;
    local format = string.format;
    local HttpService = game.HttpService;
    local decode = syn.crypt.base64.decode;

    Import = function(name) 
        local Response = request({
            Url = format("https://api.github.com/repos/NotDSF/FateHub/contents/%s", name),
            Headers = {
                Authorization = "bearer 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"
            }
        });

        local ResponseBody = HttpService.JSONDecode(HttpService, Response.Body);
        local res, err = loadstring(decode(ResponseBody.content));
        if not res then
            return err;
        end;

        return res();
    end;
end;

local TNow = tick();
local Lib: Library = Import("UILibrary.lua");
local Window = Lib:CreateWindow("Fate Hub", "Big Paintball", Color3.fromRGB(255, 50, 150));
Window:SetKeybindClose(Enum.KeyCode.F5);

local Pairs = pairs;
local ToastNotif = syn.toast_notification;
local Game = game;
local GPlayers = Game.Players;
local LocalPlayer = GPlayers.LocalPlayer;
local Workspace = Game.Workspace;
local Camera = Workspace.CurrentCamera;
local WorldToViewportPoint = Camera.WorldToViewportPoint;
local GetChildren = Game.GetChildren;
local FindFirstChild = Game.FindFirstChild;
local IsDescendantOf = Game.IsDescendantOf;
local Raycast = Workspace.Raycast;
local RaycastParams = RaycastParams.new();
local CFrame = CFrame.new;
local sort = table.sort;
local Tick = tick;
local fromHSV = Color3.fromHSV;
local Color3 = Color3.new;
local Vector2 = Vector2.new;
local Vector3 = Vector3.new;
local PointInstance = PointInstance.new;
local RectDynamic = RectDynamic.new;
local TextDynamic = TextDynamic.new;
local format = string.format;
local floor = math.floor;
local Mouse = LocalPlayer:GetMouse();
local getnamecallmethod = getnamecallmethod;
local LineDynamic = LineDynamic.new;
local Point2D = Point2D.new;
local Ray = Ray.new;
local unpack = unpack;
local LineOffset = Vector2(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y);

local Flags, ESPObjects, ESPLines = {}, {}, {};
local BackupNamecall;

local function SynapseNotification(Content, Type) 
    if not ToastNotif then return rconsoleprint(Content .. "\n"); end;
    ToastNotif({
        Type = Type or ToastType.Info,
        Duration = 7.5,
        Title = "Fates Hub v1.0.0",
        Content = Content
    });
end;

local FOV = Circle.new()
FOV.Visible = false;
FOV.Thickness = 1;
FOV.Radius = 200;
FOV.Position = Vector2(Mouse.X, Mouse.Y);
FOV.Color = fromHSV(0, 0.0, 1);
FOV.NumSides = 0;

local function IsTeam(player) 
    if game.Workspace.__VARIABLES.RoundType.Value == "FFA" then
        return false;
    end;
    return LocalPlayer.Team == player.Team;
end;

local function AddBox(player) 
    local Character = player.Character;
    local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart");
    
    Character.ChildAdded:Connect(function(child) 
        if child.Name == "HumanoidRootPart" and not ESPObjects[Character] then
            AddBox(player);
        end;
    end);

    if not HumanoidRootPart then return end;

    local Top = PointInstance(HumanoidRootPart, CFrame(Vector3(2.2, 3, 0)));
    local Bottom = PointInstance(HumanoidRootPart, CFrame(Vector3(-2.2, -3, 0)));
    local TextPoint = PointInstance(HumanoidRootPart, CFrame(Vector3(0, 3.8, 0)));

    local LineBottom = PointInstance(HumanoidRootPart, CFrame(Vector3(-2.6, -3, 0)));
    local LineTop = PointInstance(HumanoidRootPart, CFrame(Vector3(-2.6, 3, 0)));

    local Rect = RectDynamic(Top, Bottom);
    local Text = TextDynamic(TextPoint);
    local HealthBar = LineDynamic(LineBottom, LineTop);

    HealthBar.Visible = true;
    HealthBar.Color = Color3(0.0, 1.0, 0.082352);
    HealthBar.Outlined = true;

    Text.Text = player.Name;
    Text.Color = Color3(1, 1, 1);
    Text.Outlined = true;
    Text.Size = 18;

    Rect.Thickness = 1;
    Rect.Color = Color3(1, 1, 1);
    Rect.Outlined = true;

    local Object = {};
    Object.Rect = Rect;
    Object.Text = Text;
    Object.Player = player;
    Object.Character = Character;
    Object.TextPoint = TextPoint;
    Object.HealthBar = HealthBar;
    Object.HealthBarTop = LineTop;

    player.CharacterRemoving:Connect(function(char)
        if ESPObjects[char] then
            ESPObjects[char] = nil;         
        end;
    end);

    player.CharacterAdded:Connect(function(char) 
        if not ESPObjects[char] then
            AddBox(player);
        end;
    end);

    ESPObjects[Character] = Object;
end;

local function AddLine(player) 
    local Character = player.Character;
    local Head = FindFirstChild(Character, "Head");

    Character.ChildAdded:Connect(function(child) 
        if child.Name == "Head" and not ESPLines[Character] then
            AddLine(player);
        end;
    end);

    if not Head then return end;

    local To = Point2D();
    To.PointVec2 = LineOffset;

    local Line = LineDynamic();
    Line.Visible = true;
    Line.From = PointInstance(Head);
    Line.To = To;
    Line.Color = Color3(255, 255, 255)
    Line.Thickness = 1;

    local Object = {};
    Object.Line = Line;
    Object.Player = player;
    Object.Character = Character;

    player.CharacterRemoving:Connect(function(char)
        if ESPLines[char] then
            ESPObjects[char] = nil;         
        end;
    end);

    player.CharacterAdded:Connect(function(char) 
        if not ESPLines[char] then
            AddLine(player);
        end;
    end);

    ESPLines[Character] = Object;
end;

local function GetClosestPlayer(novisible, maxdistance) 
    if not LocalPlayer.Character or not FindFirstChild(LocalPlayer.Character, "HumanoidRootPart") then return end;

    local LPos = LocalPlayer.Character.HumanoidRootPart.Position;
    local Players = {};

    for i,v in Pairs(GetChildren(GPlayers)) do
        if v ~= LocalPlayer then
            if IsTeam(v) then 
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

local function GetClosestPlayerFromVector2(pos) 
    if not LocalPlayer.Character or not FindFirstChild(LocalPlayer.Character, "HumanoidRootPart") then return end;

    local Players = {};

    for i,v in Pairs(GetChildren(GPlayers)) do
        if v ~= LocalPlayer then
            if IsTeam(v) then 
                continue;
            end;

            local Character = v.Character;
            local HumanoidRootPart = Character and FindFirstChild(Character, "HumanoidRootPart");

            if HumanoidRootPart then
                local Vector, Visible = WorldToViewportPoint(Camera, HumanoidRootPart.Position);
                local Between = (Vector2(Vector.X, Vector.Y) - pos).magnitude;

                if Visible and Between <= FOV.Radius then
                    Players[#Players+1] = {Between, v};
                end;
            end;
        end;
    end;

    sort(Players, function(x,y) return x[1] < y[1] end);

    return Players[1] and Players[1][2];
end;

SynapseNotification("ALERT: You are running a beta version of Fates Hub.\nPlease report any bugs to the discord server.\nIf you aren't you should use an alt.");

local EntityHandler = require(game:GetService("ReplicatedStorage").Framework.Modules["6 | GunCmds"]);

-- Main
do
    local Main = Window:Tab("Main");

    local Weapon = Main:Section("Weapon");
    Weapon:Toggle("Enable Cheats", false, function(value) Flags.EnableWepCheats = value; end);
    Weapon:Toggle("Automatic", true, function(value) Flags.AutomaticWeapon = value; end);
    Weapon:Slider("Fire Rate", 0.1, 10, 0.1, function(value) Flags.FireRate = value; end);
    Weapon:Slider("Bullet Velocity", 1, 9999, 700, function(value) Flags.Velocity = value; end);

    Flags.EnableWepCheats = false;
    Flags.AutomaticWeapon = true;
    Flags.FireRate = 0.1;
    Flags.Velocity = 700;

    local SilentAim, SilentToggle = Main:Section("Silent Aim");
    SilentToggle = SilentAim:Toggle("Enabled", false, function(value) Flags.SilentAim = value; end);
    SilentAim:Dropdown("Target", "Head", {"Head", "HumanoidRootPart"}, function(selected) Flags.SilentAimTarget = selected; end);
    SilentAim:Keybind("Toggle Key", nil, function() end, function() 
        SynapseNotification(format("%s Silent Aim", not Flags.SilentAim and "Enabled" or "Disabled"), ToastType.Warning);
        SilentToggle:UpdateToggle(not Flags.SilentAim);
    end);

    local FOVCircle = SilentAim:Toggle("Show FOV Circle", true, function(value) FOV.Visible = value; end);
    SilentAim:Slider("FOV", 1, 2000, 200, function(value) FOV.Radius = value; end);
    SilentAim:Slider("Circle Thickness", 1, 100, 1, function(value) FOV.Thickness = value; end);
    SilentAim:Slider("Circle Sides", 0, 100, 0, function(value) FOV.NumSides = value; end);
    FOVCircle:Colorpicker(Color3(0.313725, 0.988235, 0), function(value) FOV.Color = value; end);

    local RageBot, RageToggle = Main:Section("Rage");
    RageToggle = RageBot:Toggle("Enabled", false, function(value) Flags.RageBot = value; end);
    RageBot:Toggle("Visible Check", false, function(value) Flags.RageVisible = value; end);
    RageBot:Dropdown("Target", "Head", {"Head", "HumanoidRootPart"}, function(selected) Flags.RageTarget = selected; end);
    RageBot:Slider("Max Distance", 1, 9999, 9999, function(value) Flags.RageBotMaxDistane = value; end);
    RageBot:Keybind("Toggle Key", nil, function() end, function() 
        SynapseNotification(format("%s Rage", not Flags.RageBot and "Enabled" or "Disabled"), ToastType.Warning);
        RageToggle:UpdateToggle(not Flags.RageBot);
    end);

    Flags.RageBotMaxDistane = 9999;
    Flags.SilentAimTarget = "Head";
end;

-- Visual
do 
    local Visual = Window:Tab("Visual");
    local Main = Visual:Section("Main");

    Main:Toggle("Full Bright", false, function(value) game.Lighting.Brightness = value and 5 or 3; end);
    Main:Toggle("Shadows", game.Lighting.GlobalShadows, function(value) game.Lighting.GlobalShadows = value; end);
    Main:Slider("FOV", 1, 120, 70, function(value) LocalPlayer.Settings.FOV.Value = value; end);
    Main:Slider("Time", 1, 24, string.match(game.Lighting.TimeOfDay, "(%d+):%d+:%d+") + 0, function(value) game.Lighting.TimeOfDay = string.format("%d:00:00", value); end);

    local ESP = Visual:Section("ESP");

    ESP:Toggle("Box ESP", false, function(value) 
        if value then
            for i,v in Pairs(GetChildren(GPlayers)) do
                if v ~= LocalPlayer and v.Character and FindFirstChild(v.Character, "HumanoidRootPart") then
                    AddBox(v);
                end;
            end;
        else
            for i,v in Pairs(ESPObjects) do
                v.Rect.Visible = false;
                v.Text.Visible = false;
                ESPObjects[i] = nil;
            end;
        end;
        Flags.ESP = value;
    end);

    ESP:Toggle("Tracer ESP", false, function(value) 
        if value then
            for i,v in Pairs(GetChildren(GPlayers)) do
                if v ~= LocalPlayer and v.Character and FindFirstChild(v.Character, "HumanoidRootPart") then
                    AddLine(v);
                end;
            end;
        else
            for i,v in Pairs(ESPLines) do
                v.Line.Visible = false;
                ESPLines[i] = nil;
            end;
        end;
        Flags.Tracers = value;
    end);

    local TeamToggle = ESP:Toggle("Show Team", true, function(value) Flags.ShowTeam = value; end);
    local EnemyToggle = ESP:Toggle("Show Enemy", true, function(value) Flags.ShowEnemy = value; end);

    ESP:Toggle("Box Outline", true, function(value) Flags.BoxOutline = value; end);
    ESP:Slider("Box Thickness", 1, 100, 1, function(value) Flags.ESPBoxThickness = value; end);

    ESP:Toggle("Text Outline", true, function(value) Flags.TextOutline = value; end);
    ESP:Slider("Text Size", 1, 20, 18, function(value) Flags.TextSize = value; end);
    ESP:Slider("Text Offset X", -10, 10, 0, function(value) local c = Flags.TextOffset; Flags.TextOffset = CFrame(Vector3(value, c.Y, c.Z)); end);
    ESP:Slider("Text Offset Y", -10, 10, 3.8, function(value) local c = Flags.TextOffset; Flags.TextOffset = CFrame(Vector3(c.X, value, c.Z)); end);
    ESP:Slider("Tracer Offset Y", 0, LineOffset.Y, LineOffset.Y, function(value) LineOffset = Vector2(LineOffset.X, value) end);
    ESP:Slider("Max Distance", 1, 2000, 1000, function(value) Flags.ESPMaxDistance = value; end);

    TeamToggle:Colorpicker(Color3(0.274509, 0.972549, 0.392156), function(value) Flags.ESPTeamColor = value; end);
    EnemyToggle:Colorpicker(Color3(0.972549, 0.274509, 0.286274), function(value) Flags.ESPEnemyColor = value; end);

    Flags.ESPTeamColor = Color3(0.286274, 0.968627, 0.4);
    Flags.ESPEnemyColor = Color3(0.972549, 0.439215, 0.447058);

    Flags.ESPBoxThickness = 1;
    Flags.ESPMaxDistance = 1000;
    Flags.ShowTeam = true;
    Flags.ShowEnemy = true;
    Flags.BoxOutline = true;
    Flags.TextOutline = true;
    Flags.TextSize = 18;
    Flags.TextOffset = CFrame(Vector3(0, 3.8, 0));
end;

BackupNamecall = hookmetamethod(game, "__namecall", function(self, ...) 
    local method = getnamecallmethod();
    local args = {...};

    if method == "FindPartOnRayWithWhitelist" and Flags.SilentAim then
        local MouseVector = Vector2(Mouse.X, Mouse.Y);
        local Closest = GetClosestPlayerFromVector2(MouseVector);
        local Head = LocalPlayer.Character.Head.Position;

        if not Closest then return BackupNamecall(self, ...) end;

        local Target = Closest.Character[Flags.SilentAimTarget];
        local Result = Raycast(Workspace, Head, Target.Position - Head);
        if Result and not IsDescendantOf(Result.Instance, Closest.Character) or not Result then return BackupNamecall(self, ...) end;

        args[1] = Ray(args[1].Origin, Target.Position - args[1].Origin);
    end;

    return BackupNamecall(self, unpack(args));
end);

Mouse.Move.Connect(Mouse.Move, function() FOV.Position = Vector2(Mouse.X, Mouse.Y); end);

Game.RunService.RenderStepped.Connect(Game.RunService.RenderStepped, function()
    if Flags.ESP then
        for i,v in Pairs(ESPObjects) do
            local Player = v.Player;
            local Character = v.Character;
            local Distance = floor((LocalPlayer.Character.Head.Position - Character.Head.Position).magnitude);
            local Rect, Text, HealthBar = v.Rect, v.Text, v.HealthBar;

            Text.Visible = Distance < Flags.ESPMaxDistance;
            Rect.Visible = Distance < Flags.ESPMaxDistance;
            HealthBar.Visible = Distance < Flags.ESPMaxDistance;

            if Distance < Flags.ESPMaxDistance then
                Rect.Outlined = Flags.BoxOutline;
                Rect.Thickness = Flags.ESPBoxThickness;

                Text.Outlined = Flags.TextOutline;
                Text.Size = Flags.TextSize;

                if Flags.TextOffset ~= v.TextPoint.Offset then
                    v.TextPoint.Offset = Flags.TextOffset;
                end;

                -- I hate this CODE
                if IsTeam(Player) then
                    Color = Flags.ESPTeamColor;
                    Text.Visible = Flags.ShowTeam;
                    Rect.Visible = Flags.ShowTeam;
                    HealthBar.Visible = Flags.ShowTeam;
                else
                    Color = Flags.ESPEnemyColor;
                    Text.Visible = Flags.ShowEnemy;
                    Rect.Visible = Flags.ShowEnemy;
                    HealthBar.Visible = Flags.ShowEnemy;
                end;
                
                v.HealthBarTop.Offset = CFrame(Vector3(-2.6, math.clamp(3 + ((-6 / 100) * (100 - Character.Humanoid.Health)), 0, 3), 0));
                Text.Text = format("%s | %d | [%d | 100]", Player.Name, Distance, Character.Humanoid.Health);
                Text.Color = Color;
                Rect.Color = Color;
            end;
        end;
    end;

    if Flags.Tracers then
        for i,v in Pairs(ESPLines) do
            local Player = v.Player;
            local Character = v.Character;
            local Distance = floor((LocalPlayer.Character.Head.Position - Character.Head.Position).magnitude) < Flags.ESPMaxDistance;

            v.Line.Visible = Distance;
            
            if Distance then
                v.Line.To.PointVec2 = LineOffset;

                if IsTeam(Player) then
                    Color = Flags.ESPTeamColor;
                    v.Line.Visible = Flags.ShowTeam;
                else
                    Color = Flags.ESPEnemyColor;
                    v.Line.Visible = Flags.ShowEnemy;
                end;
    
                v.Line.Color = Color;
            end;
        end;
    end;

    if Flags.EnableWepCheats then
        local Gun = select(2, EntityHandler.GetEquipped(LocalPlayer));

        Gun.automatic = Flags.AutomaticWeapon;
        Gun.shotrate = Flags.FireRate;
        Gun.velocity = Flags.Velocity;
    end;

    if not FindFirstChild(LocalPlayer, "__SPAWNED") then return end;

    if Flags.RageBot and FindFirstChild(LocalPlayer.Character, "HumanoidRootPart") then
        local Closest = GetClosestPlayer(not Flags.RageVisible, Flags.RageBotMaxDistane);

        if Closest then
            local Head = LocalPlayer.Character.Head.Position;
            RaycastParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    
            local Target = FindFirstChild(Closest.Character, Flags.RageTarget or "Head");
            if Target then
                local Result = Raycast(Workspace, Head, Target.Position - Head, RaycastParams);
                if Result and IsDescendantOf(Result.Instance, Closest.Character) then
                    Camera.CFrame = CFrame(Camera.CFrame.Position, Target.Position);
                    mouse1click();
                end;
            end;
        end;
    end;
end);

SynapseNotification(format("Loaded in %ss", Tick() - TNow), ToastType.Success);
FOV.Visible = true;
