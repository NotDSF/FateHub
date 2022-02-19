-- The types are just to help me with remembering the names

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
local info = debug.info;
local ToastNotif = syn.toast_notification;

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

for i,v in Pairs(Keys) do
    rconsoleinfo(string.format("Automatically grabbed %s key: %s\n", i, v));
end;

for i,v in Pairs(Getgc(true)) do
    if Type(v) == "function" and info(v, "n") == "CheatCheck" then
        rconsoleinfo("Disabled anti cheat!\n");
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
            warn(string.format("debug: nitro %d %d", nitro, nitromax));
            return v(Flags.InfiniteNitro and math.huge or nitro, nitromax);
        end;
    end;
end;

-- Vehicle
do
    local VehiclePage = UI.New({
        Title = "Vehicle"
    });

    VehiclePage.Toggle({
        Text = "Infinite Nitro",
        Callback = function(bool)
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
        end,
        Enabled = false
    });

    VehiclePage.Toggle({
        Text = "No Tire Pop",
        Callback = function(bool) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet and bool then
                Packet.TirePopDuration = 0;
            elseif Packet then
                if not Packet.TirePopDurationBackup then
                    Packet.TirePopDurationBackup = Packet.TirePopDuration;
                end
                Packet.TirePopDuration = Packet.TirePopDurationBackup;
            end;
        end;
    });

    VehiclePage.Toggle({
        Text = "Vehicle Fly",
        Callback = function(bool)
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Flags.VehicleFly and Packet and Packet.Mass then
                Chassis.SetGravity(Packet, 60);
            end;
            if Packet and not Packet.Mass and bool then
                SynapseNotification("Your current vehicle is not supported.\nIf you enter a supported vehicle then vehicle fly will automatically be applied.", ToastType.Error);
            end;
            Flags.VehicleFly = bool;
        end;
    });

    VehiclePage.Slider({
        Text = "Gravity",
        Min = 1,
        Max = 100,
        Def = 20,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet and Packet.Mass then
                Chassis.SetGravity(Packet, value);
            end;
            --VehicleConfig.Lift.Force = Vector3.new(0, VehicleConfig.Lift.Force.Y * value, 0);
        end;
    });

    VehiclePage.Slider({
        Text = "Turn Speed",
        Min = 1,
        Max = 100,
        Def = 1,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.TurnSpeed = value;
            end;
            VehicleConfig.TurnSpeed = value;
        end;
    });

    VehiclePage.Slider({
        Text = "Suspension",
        Min = 1,
        Max = 100,
        Def = 4,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.Suspension = value;
            end;
            VehicleConfig.Suspension = value;
        end;
    });

    VehiclePage.Slider({
        Text = "Traction",
        Min = 1,
        Max = 100,
        Def = 1,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.Traction = value;
            end;
            VehicleConfig.Traction = value;
        end;
    });

    VehiclePage.Slider({
        Text = "Height",
        Min = 1,
        Max = 100,
        Def = 3,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.Height = value;
            end;
            VehicleConfig.Height = value;
        end;
    });

    VehiclePage.Slider({
        Text = "Engine Speed",
        Min = 1,
        Max = 100,
        Def = 1,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.GarageEngineSpeed = value;
            end;
            VehicleConfig.GarageEngineSpeed = value;
        end;
    });

    VehiclePage.Slider({
        Text = "Brakes",
        Min = 1,
        Max = 100,
        Def = 1,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.GarageBrakes = value or 1;
            end;
            VehicleConfig.GarageBrakes = value or 1;
        end;
    });

    local Vehicles = {};
    for i,v in Pairs(require(ReplicatedStorage.Game.Garage.VehicleData)) do
        Vehicles[i] = v.Make;
    end;
    sort(Vehicles);

    VehiclePage.Dropdown({
        Text = "Emulate Vehicle",
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.Make = value;
                Packet.EnumMakeId = MakeId[value];
            end;
            Flags.EmulateVehicle = value;
        end,
        Options = Vehicles
    });

    Flags.VehicleColor = VehiclePage.ColorPicker({
        Text = "Vehicle Color",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.Model.Model.Body.Color = value;
            end;
        end;
    });

    local Packet = Vehicle.GetLocalVehiclePacket();
    if Packet then
        Flags.VehicleColor:SetColor(Packet.Model.Model.Body.Color);
    end;
end;

-- Combat
do 
    local GunPage = UI.New({
        Title = "Combat"
    });

    GunPage.Toggle({
        Text = "Infinite Ammo",
        Callback = function(bool) 
            if __equiped then
                local value = bool and math.huge or __equiped.Config.MagSize;
                InventoryUtils.setAttr(__equiped.inventoryItemValue, "AmmoCurrentLocal", value);
                InventoryUtils.setAttr(__equiped.inventoryItemValue, "AmmoCurrent", value);
                InventoryUtils.setAttr(__equiped.inventoryItemValue, "AmmoLeft", value);
            end;
            Flags.InfiniteAmmo = bool;
        end,
        Enabled = false
    });

    GunPage.Toggle({
        Text = "Rapid Fire",
        Callback = function(bool) 
            if __equiped and __equiped.Config then
                __equiped.Config.FireFreq = bool and math.huge or 12;
            end;
            GunConfig.FireFreq = bool and math.huge or 12;
        end,
        Enabled = false
    });

    GunPage.Toggle({
        Text = "No Reload",
        Callback = function(bool) 
            if __equiped and __equiped.Config then
                __equiped.Config.ReloadTime = bool and 0 or 1.5;
            end;
            GunConfig.ReloadTime = bool and 0 or 1.5;
        end,
        Enabled = false
    });
    
    GunPage.Toggle({
        Text = "Automatic",
        Callback = function(bool) 
            if __equiped and __equiped.Config then
                __equiped.Config.FireAuto = bool;
            end;
            GunConfig.FireAuto = bool;
        end,
        Enabled = false
    });
end;

-- Misc
do 
    local Misc = UI.New({
        Title = "Misc"
    });

    Misc.Button({
        Text = "Open All Doors",
        Callback = function() 
            local OpenF = GetFunction("DoorSequence");
            for i,v in Pairs(Getgc(true)) do 
                if Type(v) == "table" and Rawget(v, "Settings") and Rawget(v, "State") then
                    if v.Settings.ServerOnly or v.State.Open then continue; end;
                    OpenF(v);
                end;
            end;
        end;
    });

    Misc.Button({
        Text = "Remove Lasers",
        Callback = function() 
            for i,v in Pairs(Game.Workspace:GetDescendants()) do
                if v.Name == "Lasers" then
                    v:Destroy();
                end;
            end;
        end;
    });

    Misc.Toggle({
        Text = "Auto Pickpocket",
        Callback = function(bool) 
            Flags.Pickpocket = bool
        end,
        Enabled = false
    });

    Misc.Toggle({
        Text = "Auto Arrest",
        Callback = function(bool) 
            Flags.Arrest = bool;
        end,
        Enabled = false;
    });

    Misc.Toggle({
        Text = "Auto Eject",
        Callback = function(bool) 
            Flags.EjectLoop = bool;
        end,
        Enabled = false
    });

    Misc.Toggle({
        Text = "Auto Parachute",
        Callback = function(bool) 
            Flags.AutoParachute = bool;
        end,
        Enabled = false
    });

    Misc.Toggle({
        Text = "No Cooldown",
        Callback = function(bool) 
            for i,v in Pairs(Getgc(true)) do
                if Type(v) == "table" and Rawget(v, "Duration") then
                    if not v.Backup then
                        v.Backup = v.Duration;
                    end;
                    rawset(v, "Duration", bool and 0 or v.Backup);
                end;
            end;
        end,
        Enabled = false
    });

    Misc.Button({
        Text = "Rejoin",
        Callback = function() 
            Game.TeleportService:TeleportToPlaceInstance(Game.PlaceId, Game.JobId);
        end
    });
end;

-- Player
do
    local Player = UI.New({
        Title = "Player"
    });

    Player.Toggle({
        Text = "No Ragdoll",
        Callback = function(bool) 
            Flags.NoRagdoll = bool;
        end,
        Enabled = false;
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

    local Falling = GetLocal("StartRagdolling");
    local Backup;
    Backup = hookfunction(Falling.StartRagdolling, function(...) 
        if Flags.NoRagdoll then return end;
        return Backup(...);
    end);
end;

-- Teleport 
do 
    local TeleportUI = UI.New({
        Title = "Teleports"
    });

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

    TeleportUI.Button({ Text = "Bank", Callback = function() Teleport(Vector3(11.033385276794, 18.327821731567, 778.54730224609)); end; });
    TeleportUI.Button({ Text = "Museum", Callback = function() Teleport(Vector3(1059.7930908203, 101.80494689941, 1249.2574462891)); end; });
    TeleportUI.Button({ Text = "Jewellery Store", Callback = function() Teleport(Vector3(115.15441131592, 18.263557434082, 1363.3806152344)); end; });
    TeleportUI.Button({ Text = "Criminal Base (Volcano)", Callback = function() Teleport(Vector3(1815.5421142578, 47.260692596436, -1634.0577392578)); end; });
    TeleportUI.Button({ Text = "Criminal Base (Downtown)", Callback = function() Teleport(Vector3(-241.9779510498, 18.263689041138, 1614.1091308594)); end; });
    TeleportUI.Button({ Text = "Police Station (Inner City)", Callback = function() Teleport(Vector3(177.87417602539, 18.581577301025, 1091.3991699219)); end; });
    TeleportUI.Button({ Text = "Police Station (City Outskirts)", Callback = function() Teleport(Vector3(720.49090576172, 38.615474700928, 1066.9827880859)); end; });
    TeleportUI.Button({ Text = "Prision Entrance", Callback = function() Teleport(Vector3(-1153.9276123047, 18.398023605347, -1431.1813964844)); end; });
    TeleportUI.Button({ Text = "Gas Station", Callback = function() Teleport(Vector3(-1558.5793457031, 18.396139144897, 665.70147705078)); end; });
    TeleportUI.Button({ Text = "Donut Shop", Callback = function() Teleport(Vector3(161.52265930176, 19.215852737427, -1597.4591064453)); end; });
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
        Flags.VehicleColor:SetColor(Vehicle.Model.Model.Body.Color);
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
            if Flags.PickpocketRebounce and Flags.PickpocketRebounce - tick() < 2 then return end;
            local C = (Closest.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude; 
            if C > 15 then return end;

            Event:FireServer(Keys.AttemptPickPocket, Closest.Name);
            SynapseNotification(string.format("Pickpocketed %s. Run!", Closest.Name));
            Flags.PickpocketRebounce = tick();
        end;
    end;

    if Flags.Arrest then
        local Closest = GetClosestPlayer();
        if Closest and Closest.Team.Name == "Criminal" then
            local C = (Closest.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude; 
            if C > 15 then return end;

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

    if Flags.EjectLoop then
        for i,v in Pairs(GetChildren(Workspace.Vehicles)) do
            if FindFirstChild(v, "Seat") then
                local C = (v.Seat.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude;
                if C > 10 then return end;

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
end);

SynapseNotification(string.format("Loaded in %ss", tick() - TNow), ToastType.Success);
-- Will add more features later

--Gun
--[[
    {
    ["FireFreq"] = 12,
    ["CamShakeMagnitude"] = 10,
    ["Price"] = 15000,
    ["BulletSpeed"] = 1050,
    ["ImageId"] = 880310767,
    ["Motion"] = {
        ["RightElbowAngle"] = 0,
        ["LeftElbowAngle"] = 0,
        ["Scope"] = {
            ["Springs"] = {
                ["ItemOffset"] = "vector",
                ["ItemRotation"] = "vector",
                ["NeckRotation"] = "vector"
            }
        },
        ["Hip"] = {
            ["Springs"] = {
                ["ItemOffset"] = "vector",
                ["ItemRotation"] = "vector",
                ["NeckRotation"] = "vector"
            }
        },
        ["RightWristRotation"] = newproxy(),
        ["LeftWristRotation"] = newproxy()
    },
    ["MagSize"] = 30,
    ["ReloadTime"] = 1.5,
    ["FireAuto"] = true,
    ["Sound"] = {
        ["gun_semi_auto_rifle_magazine_unload_01"] = 2121005857,
        ["gun_semi_auto_rifle_shot_01"] = 2121007712,
        ["gun_semi_auto_rifle_magazine_load_01"] = 2121005623,
        ["gun_semi_auto_rifle_dry_fire_01"] = 2121005402
    },
    ["Damage"] = 6
}
]]

--Vehicle
--[[
{
    ["IK"] = {
        ["LeftShoulder"] = newproxy(),
        ["RightShoulder"] = newproxy(),
        ["LeftWrist"] = newproxy(),
        ["RightWrist"] = newproxy(),
        ["RightElbow"] = newproxy(),
        ["LeftElbow"] = newproxy()
    },
    ["Bounce"] = 100,
    ["TireHealth"] = 1,
    ["TurnSpeed"] = 1.4,
    ["Mass"] = 198626.34140599,
    ["Cd"] = 0.4257,
    ["Suspension"] = 4,
    ["DriveThruster"] = newproxy(),
    ["SirenSound"] = newproxy(),
    ["TirePopDuration"] = 7.5,
    ["Traction"] = 1,
    ["WeldSteer"] = newproxy(),
    ["RotY"] = 0,
    ["VisualHalfHeight"] = 1.4000000953674,
    ["PartFrontRight"] = newproxy(),
    ["vSandstone"] = 0,
    ["Sounds"] = {
        ["Grass"] = newproxy(),
        ["Idle"] = newproxy(),
        ["OffLow"] = newproxy(),
        ["OnMid"] = newproxy(),
        ["Asphalt"] = newproxy(),
        ["OnLow"] = newproxy(),
        ["DriftSqueal"] = newproxy(),
        ["OnHigh"] = newproxy(),
        ["Sandstone"] = newproxy()
    },
    ["_flagBrakelightsEnabled"] = false,
    ["Locked"] = false,
    ["Force"] = 794505.36562395,
    ["GarageEngineSpeed"] = 0,
    ["AreTiresPopped"] = false,
    ["LastForward"] = 0,
    ["Gears"] = {
        [1] = 3.27,
        [2] = 3.2,
        [3] = 4.06,
        [4] = 2.37,
        [5] = 1.55,
        [6] = 1.16,
        [7] = 0.85,
        [8] = 0.67
    },
    ["Nitrous"] = {
        [1] = newproxy(),
        [2] = newproxy(),
        [3] = newproxy(),
        [4] = newproxy()
    },
    ["LastAudioScale"] = 1634440555.1666,
    ["seatMaid"] = {
        ["_tasks"] = {
            [1] = newproxy(),
            [2] = "function",
            [3] = newproxy(),
            [4] = newproxy(),
            [5] = "function",
            [6] = "function"
        }
    },
    ["Model"] = newproxy(),
    ["Height"] = 3,
    ["Crr"] = 320,
    ["t3"] = 0,
    ["Lift"] = newproxy(),
    ["Wheels"] = {
        ["WheelFrontRight"] = {
            ["Part"] = newproxy(),
            ["Thruster"] = newproxy()
        },
        ["WheelFrontLeft"] = {
            ["Part"] = newproxy(),
            ["Thruster"] = newproxy()
        },
        ["WheelBackRight"] = {
            ["Part"] = newproxy(),
            ["Thruster"] = newproxy()
        },
        ["WheelBackLeft"] = {
            ["Part"] = newproxy(),
            ["Thruster"] = newproxy()
        }
    },
    ["SoundType"] = "F40",
    ["GarageSuspensionHeight"] = 0,
    ["Cb"] = 18000,
    ["RadioSound"] = newproxy(),
    ["DespawnTime"] = 120,
    ["FrictionThruster"] = newproxy(),
    ["TeamRestrict"] = "Police",
    ["GarageBrakes"] = 0,
    ["Damping"] = 7945.0536562395,
    ["HasSpoiler"] = false,
    ["_flagHeadlightsEnabled"] = false,
    ["EnumMakeId"] = 29,
    ["TiresLastPop"] = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0
    },
    ["PartBackRight"] = newproxy(),
    ["Team"] = "Police",
    ["Rotate"] = newproxy(),
    ["LastRPM"] = 0,
    ["vGrass"] = 0,
    ["LastGear"] = 1,
    ["PartBackLeft"] = newproxy(),
    ["Gear"] = 1,
    ["Type"] = "Chassis",
    ["Seats"] = {
        [1] = {
            ["PlayerTag"] = newproxy(),
            ["IsPassenger"] = false,
            ["PlayerNamev"] = newproxy(),
            ["Depart"] = newproxy(),
            ["Part"] = newproxy()
        },
        [2] = {
            ["PlayerTag"] = newproxy(),
            ["IsPassenger"] = true,
            ["PlayerNamev"] = newproxy(),
            ["Depart"] = newproxy(),
            ["Part"] = newproxy()
        }
    },
    ["vAsphalt"] = 0,
    ["Seat"] = newproxy(),
    ["PartFrontLeft"] = newproxy(),
    ["TirePopProportion"] = 0.5,
    ["WheelRotation"] = 0,
    ["vHeading"] = 0,
    ["LastDrift"] = 0,
    ["serverSeatMaid"] = {
        ["_tasks"] = {}
    },
    ["GarageSelection"] = {
        ["Rim"] = "Blade",
        ["BodyColor"] = "Blue",
        ["WindowColor"] = "Black",
        ["WheelColor"] = "Grey",
        ["SuspensionHeight"] = "Normal",
        ["Engine"] = "Level 1",
        ["Brakes"] = "Level 1"
    },
    ["Make"] = "Camaro",
    ["SeatWeld"] = newproxy()
}
]]
