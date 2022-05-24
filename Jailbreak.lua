-- The types are just to help me with remembering the names

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

type ChassisType = {
    setBackward: (p1: any) -> (...any),
    VehicleEnter: (p1: any) -> (...any),
    UpdateSoundLowQuality: (p1: any, p2: any, p3: any) -> (...any),
    UpdateStats: (p1: any) -> (...any),
    VehicleLeave: (p1: any) -> (...any),
    UnlockCamera: (p1: any) -> (...any),
    runAction: (p1: any) -> (...any),
    UpdatePrePhysics: (p1: any, p2: any) -> (...any),
    InputChanged: (p1: any) -> (...any),
    InputBegan: (p1: any) -> (...any),
    InputEnded: (p1: any) -> (...any),
    SetEvent: (p1: any) -> (...any),
    toggleSirens: () -> (...any),
    SpinOut: (p1: any) -> (...any),
    init: (p1: any) -> (...any),
    AttemptFireMissile: (p1: any) -> (...any),
    LockCamera: (p1: any) -> (...any),
    SetWheelsVisible: (p1: any, p2: any) -> (...any),
    setForward: (p1: any) -> (...any),
    Halt: (p1: any) -> (...any),
    toggleHeadlights: () -> (...any),
    toggleInsideCamera: (p1: any) -> (...any),
    setHandbrakeEnabled: (p1: any) -> (...any),
    UpdatePostPhysics: (p1: any) -> (...any),
    UpdateForces: (p1: any, p2: any) -> (...any),
    UpdateWheelLowQuality: (p1: any, p2: any, p3: any, p4: any) -> (...any),
    SetGravity: (p1: any, p2: any) -> (...any)
}

type VehicleType = {
    updateSpdBarRatio: (p1: any) -> (...any),
    prepareCameraSubject: (p1: any, p2: any) -> (...any),
    setBrakelightsEnabled: (p1: any, p2: any) -> (...any),
    canLocalLock: () -> (...any),
    GetLocalVehiclePacket: () -> (...any),
    CleanVehicleModel: (p1: any) -> (...any),
    promptMissileBuy: () -> (...any),
    OnVehicleExited: table,
    OnVehicleJumpExited: table,
    getHeadlights: (p1: any) -> (...any),
    NitroShopVisible: (p1: any, p2: any) -> (...any),
    Init: (p1: any) -> (...any),
    OnVehicleEntered: table,
    _forceUpdateNitroBar: boolean,
    GetLocalVehicleModel: () -> (...any),
    attemptPassengerEject: (p1: any) -> (...any),
    Classes: table,
    spdBarRatio: table,
    LastVehicleExit: number,
    attemptBuyMissiles: () -> (...any),
    canLocalEject: () -> (...any),
    LastVehicleEject: number,
    toggleLocalLocked: () -> (...any),
    getSeats: (p1: any) -> (...any),
}

if getgenv().FatesHub then error("Fates Hub already loaded!"); end;
getgenv().FatesHub = true;

ToastType = ToastType or {};

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
local Window = Lib:CreateWindow("Fate Hub", "Jailbreak", Color3.fromRGB(255, 50, 150));
Window:SetKeybindClose(Enum.KeyCode.F5);

local Rawget = rawget;
local Type = typeof;
local Getgc = getgc;
local Pairs = pairs;
local info = debug.info;
local ToastNotif = syn.toast_notification;
local filtergc = filtergc;

local function GetLocal(index) 
    return filtergc("table", { Keys = { index } }, true);
end;

local function GetFunction(name) 
    return filtergc("function", { Name = name }, true);
end;

local function SynapseNotification(Content, Type) 
    if not ToastNotif then return warn(Content); end;
    ToastNotif({
        Type = Type or ToastType.Info,
        Duration = 7.5,
        Title = "Fates Hub v1.0.1b",
        Content = Content
    });
end;

SynapseNotification("ALERT: You are running a beta version of Fates Hub.\nPlease report any bugs to the discord server.\nIf you aren't you should use an alt.");

local __equiped;
local __methods = {
    __index = function(self, idx) 
        if not rawget(self, idx) then
            rawset(self, idx, {});
        end;
    
        return rawget(self, idx);
    end
}

local Flags = {};
local GunConfig = setmetatable({}, __methods);
local VehicleConfig = setmetatable({}, __methods);

local Event = GetLocal("FireServer");
local Vehicle: VehicleType = GetLocal("OnVehicleEntered");
local Item = GetLocal("OnLocalItemEquipped");
local Equipped = GetLocal("addEquipCondition");
local InventoryUtils = GetLocal("getAttr");
local Chassis: ChassisType = GetLocal("SetGravity");
local Paraglide = GetLocal("IsFlying");
local IsSkydiving = GetFunction("IsSkydiving");
local InternalFunctions = GetLocal("hems");
local Game = game;
local LocalPlayer = Game.Players.LocalPlayer;
local ReplicatedStorage = Game.ReplicatedStorage;
local UserInputService = Game.UserInputService;
local TweenService = Game.TweenService;
local Workspace = Game.Workspace;
local Camera = Workspace.CurrentCamera;
local WorldToViewportPoint = Camera.WorldToViewportPoint;
local IsMouseButtonPressed = UserInputService.IsMouseButtonPressed;
local GetChildren = Game.GetChildren;
local FindFirstChild = Game.FindFirstChild;
local MakeId = require(ReplicatedStorage.Game.Garage.EnumMake);
local CFrame = CFrame.new;
local Vector3 = Vector3.new;
local sort = table.sort;
local getupvalue = debug.getupvalue;
local setupvalue = debug.setupvalue; 
local Tostring = tostring;
local Checkcaller = checkcaller;
local BackupIndex, BackupNewIndex;

local Keys = {};

-- AutoUpdate
do
    local FakeNetwork = {};
    function FakeNetwork:FireServer(key) 
        Keys[info(2, "n")] = key; -- Will get the function calling fireserver (AttemptVehicleEject for example)
    end;
    
    local function GetKey(name, ...) 
        local CurrentFunction, Backupnetwork;

        CurrentFunction = GetFunction(name);
        Backupnetwork = getupvalue(CurrentFunction, 1);
        setupvalue(CurrentFunction, 1, FakeNetwork);
        CurrentFunction(...);
        setupvalue(CurrentFunction, 1, Backupnetwork);
    end;

    GetKey("AttemptVehicleEject");
    GetKey("AttemptPickPocket", {});
    GetKey("AttemptArrest", {});
end;


for i,v in Pairs(Getgc(true)) do
    if Type(v) == "function" and info(v, "n") == "CheatCheck" then
        hookfunction(v, function() end);
    end;
end;

BackupIndex = hookmetamethod(Game, "__index", newcclosure(function(self, idx) 
    if idx == "WalkSpeed" then
        return 15;
    elseif idx == "JumpPower" then
        return 5;
    end;
    return BackupIndex(self, idx);
end));

BackupNewIndex = hookmetamethod(Game, "__newindex", newcclosure(function(self, idx, val) 
    if not Checkcaller() and Flags[idx] then
        val = val + Flags[idx];
    end;
    return BackupNewIndex(self, idx, val);
end));

for i,v in Pairs(InternalFunctions) do
    if Type(v) == "function" and table.find(debug.getconstants(v), "%d/%d") then
        InternalFunctions[i] = function(nitro, nitromax) 
            return v(Flags.InfiniteNitro and math.huge or nitro, nitromax);
        end;
    end;
end;

-- Vehicle
do
    local VehiclePage = Window:Tab("Main");
    local Main = VehiclePage:Section("Vehicle");

    Main:Toggle("Infinite Nitro", false, function(bool) 
        local NitroTable = GetLocal("NitroLastMax");
        if bool then
            NitroTable.NitroB = NitroTable.Nitro;
            NitroTable.NitroMaxB = NitroTable.NitroLastMax; 
            NitroTable.Nitro = math.huge;
            NitroTable.NitroLastMax = math.huge;
        elseif NitroTable.NitroB then
            NitroTable.Nitro = NitroTable.NitroB;
            NitroTable.NitroLastMax = NitroTable.NitroMaxB; 
        end;
        Flags.InfiniteNitro = bool;
    end);

    Main:Toggle("No Tire Pop", false, function(bool) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet and bool then
            Packet.TirePopDuration = 0;
        elseif Packet then
            if not Packet.TirePopDurationBackup then
                Packet.TirePopDurationBackup = Packet.TirePopDuration;
            end
            Packet.TirePopDuration = Packet.TirePopDurationBackup;
        end;
    end);

    Main:Toggle("Vehicle Fly", false, function(bool)
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Flags.VehicleFly and Packet and Packet.Mass then
            Chassis.SetGravity(Packet, 60);
        end;
        if Packet and not Packet.Mass and bool then
            SynapseNotification("Your current vehicle is not supported.\nIf you enter a supported vehicle then vehicle fly will automatically be applied.", ToastType.Error);
        end;
        Flags.VehicleFly = bool;
    end);

    Main:Slider("Gravity", 1, 100, 20, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet and Packet.Mass then
            Chassis.SetGravity(Packet, value);
        end;
    end);

    Main:Slider("Turn Speed", 1, 100, 1, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.TurnSpeed = value;
        end;
        VehicleConfig.TurnSpeed = value;
    end);

    Main:Slider("Suspension", 1, 100, 4, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.Suspension = value;
        end;
        VehicleConfig.Suspension = value;
    end);

    Main:Slider("Traction", 1, 100, 1, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.Traction = value;
        end;
        VehicleConfig.Traction = value;
    end);

    Main:Slider("Height", 1, 100, 3, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.Height = value;
        end;
        VehicleConfig.Height = value;
    end);

    Main:Slider("Engine Speed", 1, 100, 1, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.GarageEngineSpeed = value;
        end;
        VehicleConfig.GarageEngineSpeed = value;
    end);

    Main:Slider("Brakes", 1, 100, 1, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.GarageBrakes = value or 1;
        end;
        VehicleConfig.GarageBrakes = value or 1;
    end);

    local Vehicles = {};
    for i,v in Pairs(require(ReplicatedStorage.Game.Garage.VehicleData)) do
        Vehicles[i] = v.Make;
    end;
    sort(Vehicles);

    Main:Dropdown("Emulate Vehicle(s)", "none", Vehicles, function(value) 
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.Make = value;
            Packet.EnumMakeId = MakeId[value];
        end;
        Flags.EmulateVehicle = value;
    end);

    Flags.VehicleColor = Main:Colorpicker("Vehicle Color", Color3.fromRGB(255, 0, 0), function(color)
        local Packet = Vehicle.GetLocalVehiclePacket();
        if Packet then
            Packet.Model.Model.Body.Color = color;
        end;
    end);

    local Packet = Vehicle.GetLocalVehiclePacket();
    if Packet then
        Flags.VehicleColor:UpdateColor(Packet.Model.Model.Body.Color);
    end;

    Main = VehiclePage:Section("Combat");

    Main:Toggle("Infinite Ammo", false, function(bool) 
        if __equiped then
            local value = bool and math.huge or __equiped.Config.MagSize;
            InventoryUtils.setAttr(__equiped.inventoryItemValue, "AmmoCurrentLocal", value);
            InventoryUtils.setAttr(__equiped.inventoryItemValue, "AmmoCurrent", value);
            InventoryUtils.setAttr(__equiped.inventoryItemValue, "AmmoLeft", value);
        end;
        Flags.InfiniteAmmo = bool;
    end);

    Main:Toggle("Rapid Fire", false, function(bool) 
        if __equiped and __equiped.Config then
            __equiped.Config.FireFreq = bool and math.huge or 12;
        end;
        GunConfig.FireFreq = bool and math.huge or 12;
    end);

    Main:Toggle("No Reload", false, function(bool) 
        if __equiped and __equiped.Config then
            __equiped.Config.ReloadTime = bool and 0 or 1.5;
        end;
        GunConfig.ReloadTime = bool and 0 or 1.5;
    end);

    Main:Toggle("Automatic", false, function(bool) 
        if __equiped and __equiped.Config then
            __equiped.Config.FireAuto = bool;
        end;
        GunConfig.FireAuto = bool;
    end);

    Main = VehiclePage:Section("Misc");
    Main:SetRight();
    
    Main:Button("Open All Doors", function() 
        local OpenF = GetFunction("DoorSequence");
        for i,v in Pairs(Getgc(true)) do 
            if Type(v) == "table" and Rawget(v, "Settings") and Rawget(v, "State") then
                if v.Settings.ServerOnly or v.State.Open then continue; end;
                OpenF(v);
            end;
        end;
    end);

    Main:Button("Remove Lasers", function() 
        for i,v in Pairs(Game.Workspace:GetDescendants()) do
            if v.Name == "Lasers" then
                v:Destroy();
            end;
        end;
    end);

    Main:Toggle("Auto Pickpocket", false, function(bool) 
        Flags.Pickpocket = bool
    end);    

    Main:Toggle("Auto Arrest", false, function(bool) 
        Flags.Arrest = bool;
    end);

    Main:Toggle("Auto Eject", false, function(bool) 
        Flags.EjectLoop = bool;
    end);

    Main:Toggle("Auto Parachute", false, function(bool) 
        Flags.AutoParachute = bool;
    end);

    Main:Toggle("No Cooldown", false, function(bool) 
        for i,v in Pairs(Getgc(true)) do
            if Type(v) == "table" and Rawget(v, "Duration") then
                if not v.Backup then
                    v.Backup = v.Duration;
                end;
                rawset(v, "Duration", bool and 0 or v.Backup);
            end;
        end;
    end);

    Main:Button("Rejoin", function() 
        Game.TeleportService:TeleportToPlaceInstance(Game.PlaceId, Game.JobId);
    end);
end;

-- Player
local GetClosestPlayer; do
    local Player = Window:Tab("Player");
    local Main = Player:Section("Main");

    Main:Toggle("No Ragdoll", false, function(bool) 
        Flags.NoRagdoll = bool;
    end);

    Main:Slider("WalkSpeed", 1, 200, 16, function(value) 
        LocalPlayer.Character.Humanoid.WalkSpeed = value;
        Flags.WalkSpeed = value;
    end);

    Main:Slider("JumpPower", 1, 200, 50, function(value) 
        LocalPlayer.Character.Humanoid.JumpPower = value;
        Flags.JumpPower = value;
    end);

    local Falling = GetLocal("StartRagdolling");
    local Backup;
    Backup = hookfunction(Falling.StartRagdolling, function(...) 
        if Flags.NoRagdoll then return end;
        return Backup(...);
    end);

    Main = Player:Section("Teleports");

    local function Teleport(Pos)
        local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart;
        local Params = RaycastParams.new();
        Params.FilterDescendantsInstances = { LocalPlayer.Character };

        if Game.Workspace:Raycast(HumanoidRootPart.Position, Vector3(0, 500, 0), Params) then
            return SynapseNotification("Please go outside before teleporting!", ToastType.Error);
        elseif Vehicle.GetLocalVehiclePacket() then
            return SynapseNotification("Please exit your vehicle before teleporting!", ToastType.Error); 
        end;

        local TimeRequired = 80 + math.floor((HumanoidRootPart.Position - Pos).magnitude / 100);
        HumanoidRootPart.CFrame = CFrame(HumanoidRootPart.Position.X, 2000, HumanoidRootPart.Position.Z);
        local Tween = TweenService.Create(TweenService, HumanoidRootPart, TweenInfo.new(TimeRequired), {CFrame=CFrame(Vector3(Pos.X, 2000, Pos.Z))});
        Tween:Play();
        SynapseNotification(string.format("Teleport in progress...\nUnfortunately due to security reasons this will take %ds.", TimeRequired));
        Flags.Teleporting = true;
        Tween.Completed:Wait();
        Flags.Teleporting = false;
        HumanoidRootPart.CFrame = CFrame(HumanoidRootPart.Position.X, Pos.Y + 10, HumanoidRootPart.Position.Z);
    end;

    Main:Button("Bank", function() Teleport(Vector3(11.033385276794, 18.327821731567, 778.54730224609)); end);
    Main:Button("Museum", function() Teleport(Vector3(1059.7930908203, 101.80494689941, 1249.2574462891)); end);
    Main:Button("Jewellery Store", function() Teleport(Vector3(1059.7930908203, 101.80494689941, 1249.2574462891)); end);
    Main:Button("Criminal Base (Volcano)", function() Teleport(Vector3(1815.5421142578, 47.260692596436, -1634.0577392578)); end);
    Main:Button("Criminal Base (Downtown)", function() Teleport(Vector3(-241.9779510498, 18.263689041138, 1614.1091308594)); end);
    Main:Button("Police Station (Inner City)", function() Teleport(Vector3(177.87417602539, 18.581577301025, 1091.3991699219)); end);
    Main:Button("Police Station (City Outskirts)", function() Teleport(Vector3(720.49090576172, 38.615474700928, 1066.9827880859)); end);
    Main:Button("Prison Entrance", function() Teleport(Vector3(-1153.9276123047, 18.398023605347, -1431.1813964844)); end);
    Main:Button("Gas Station", function() Teleport(Vector3(-1558.5793457031, 18.396139144897, 665.70147705078)); end);
    Main:Button("Donut Shop", function() Teleport(Vector3(161.52265930176, 19.215852737427, -1597.4591064453)); end);

    Main = Player:Section("Aimbot");

    Main:Toggle("Enabled", function(bool) 
        Flags.Aimbot = bool;
    end);

    Main:Dropdown("Target Part", "Head", { "Head", "HumanoidRootPart" }, function(value) 
        Flags.AimbotTarget = value;
    end)

    GetClosestPlayer = function() 
        if not LocalPlayer.Character or not FindFirstChild(LocalPlayer.Character, "HumanoidRootPart") then return end;
    
        local LPos = LocalPlayer.Character.HumanoidRootPart.Position;
        local Players = {};
    
        for i,v in Pairs(GetChildren(Game.Players)) do
            if v ~= LocalPlayer and v.TeamColor ~= LocalPlayer.TeamColor then
                local Character = v.Character;
                local HumanoidRootPart = Character and FindFirstChild(Character, "HumanoidRootPart");
                if HumanoidRootPart then
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

Vehicle.OnVehicleEntered:Connect(function(Vehicle) 
    warn("debug: entered vehicle");

    for i,v in Pairs(Vehicle) do
        if Rawget(VehicleConfig, i) then
            Vehicle[i] = VehicleConfig[i];
        end;
    end;

    if Flags.EmulateVehicle then
        Vehicle.Make = Flags.EmulateVehicle;
        Vehicle.EnumMakeId = MakeId[Flags.EmulateVehicle];
    end;

    if Flags.VehicleColor then
        Flags.VehicleColor:UpdateColor(Vehicle.Model.Model.Body.Color);
    end;
end);

Item.OnLocalItemEquipped:Connect(function(Item)
    warn("debug: equipped item");

    __equiped = Item;

    if Flags.InfiniteAmmo then
        InventoryUtils.setAttr(Item.inventoryItemValue, "AmmoCurrentLocal", math.huge);
        InventoryUtils.setAttr(Item.inventoryItemValue, "AmmoCurrent", math.huge);
        InventoryUtils.setAttr(Item.inventoryItemValue, "AmmoLeft", math.huge);
    end;

    for i,v in Pairs(Item.Config) do
        if Rawget(GunConfig, i) then
            Item.Config[i] = GunConfig[i];
        end;
    end;
    Flags.ItemEquipped = true;
end);

Item.OnLocalItemUnequipped:Connect(function() 
    Flags.ItemEquipped = false;
end);

Game.RunService.RenderStepped:Connect(function() 
    if Flags.Aimbot and IsMouseButtonPressed(UserInputService, Enum.UserInputType.MouseButton2) and Flags.ItemEquipped then
        local Closest = GetClosestPlayer();
        if Closest then
            local Target = Flags.AimbotTarget or "Head";
            Camera.CFrame = CFrame(Camera.CFrame.Position, Closest.Character[Target].Position);
        end;
    end;

    if Flags.Teleporting or Flags.AutoParachute and IsSkydiving() then
        Paraglide.Parachute();
    end;

    if Flags.VehicleFly then
        local Vehicle = Vehicle.GetLocalVehiclePacket();
        if Vehicle and Vehicle.Mass then
            Chassis.SetGravity(Vehicle, 0);
            Vehicle.Model.Engine.CFrame = Vehicle.Model.Engine.CFrame + Camera.CFrame.LookVector; -- Fate you will have to implement this function properly (im am not experienced with cframe manipulation)
        end;
    end;

    --[[
            if Flags.Ninja then
        local Closest = GetClosestPlayer();
        local Vehicle = Vehicle.GetLocalVehiclePacket();
        if Vehicle and Closest then
            local C = (Closest.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude;
            if C < 100 then
                if not Vehicle.BackupLift then
                    SynapseNotification("Ninja mode activated.");
                    Vehicle.BackupLift = Vehicle.Lift.Force;
                    Vehicle.Lift.Force = Vector3(0, 999999, 0);
                end;
            elseif Vehicle.BackupLift then
                Vehicle.Lift.Force = Vehicle.BackupLift;
                Vehicle.BackupLift = nil;
                SynapseNotification("Ninja mode deactivated.");
            end;
        end;
    end;
    ]]

    if Flags.Pickpocket then
        local Closest = GetClosestPlayer();
        if Closest and Closest.Team.Name == "Police" then
            Flags.PickpocketRebounce = Flags.PickpocketRebounce or 0;
            if Flags.PickpocketRebounce and Flags.PickpocketRebounce - tick() > 2 then 
                local C = (Closest.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude; 
                if C <= 15 then
                    Event:FireServer(Keys.AttemptPickPocket, Closest.Name);
                    SynapseNotification(string.format("Pickpocketed %s. Run!", Closest.Name));
                    Flags.PickpocketRebounce = tick();
                end;
            end;
        end;
    end;

    if Flags.Arrest then
        local Closest = GetClosestPlayer();
        if Closest and Closest.Team.Name == "Criminal" then
            local C = (Closest.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude; 
            if C <= 15 then
                local EquippedItem = Equipped.getEquipped()[1];
                if EquippedItem and Tostring(EquippedItem.obj) ~= "Handcuffs" or Tostring(EquippedItem.obj) ~= "Cuffed" then
                    for i,v in Pairs(Equipped.getInventoryItemsFor(LocalPlayer)) do
                        if Tostring(v.obj) == "Handcuffs" then
                            Equipped.toggleEquip(v);
                            break;
                        end;
                    end;
                end;

                Event:FireServer(Keys.AttemptArrest, Closest.Name);
            end;
        end;
    end;

    if Flags.EjectLoop then
        for i,v in Pairs(GetChildren(Workspace.Vehicles)) do
            if FindFirstChild(v, "Seat") then
                local C = (v.Seat.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude;
                if C <= 10 then
                    local EquippedItem = Equipped.getEquipped()[1];
                    if EquippedItem and Tostring(EquippedItem.obj) ~= "Handcuffs" or Tostring(EquippedItem.obj) ~= "Cuffed" then
                        for i,v in Pairs(Equipped.getInventoryItemsFor(LocalPlayer)) do
                            if Tostring(v.obj) == "Handcuffs" then
                                Equipped.toggleEquip(v);
                                break;
                            end;
                        end;
                    end;
    
                    Event:FireServer(Keys.AttemptVehicleEject, v);
                end;
            end;
        end;
    end;
end);

SynapseNotification(string.format("Loaded in %ss", tick() - TNow), ToastType.Success);
