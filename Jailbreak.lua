local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))();
local UI = Lib.Load({
    Title = "Fates Hub | Jailbreak",
    Style = 1,
    SizeX = 400,
    SizeY = 400,
    Theme = "Dark"
});

local function GetLocal(index) 
    for i,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, index) then
            return v;
        end;
    end;
end;

local __equiped;
local __methods = {
    __index = function(self, idx) 
        if not rawget(self, idx) then
            rawset(self, idx, {});
        end;
    
        return rawget(self, idx);
    end
}

local WepTypes = {
    Rifle = require(game.ReplicatedStorage.Game.Item.Rifle);
}

local Flags = {};
local GunConfig = setmetatable({}, __methods);
local VehicleConfig = setmetatable({}, __methods);

local Event = GetLocal("FireServer");
local Vehicle = GetLocal("OnVehicleEntered");
local Item = GetLocal("OnLocalItemEquipped");
local InventoryUtils = GetLocal("getAttr");
local InternalFunctions = GetLocal("hems");
local LocalPlayer = game.Players.LocalPlayer;
local UserInputService = game.UserInputService;
local Camera = game.Workspace.CurrentCamera;
local WorldToViewportPoint = Camera.WorldToViewportPoint;
local BackupMt;

BackupMt = hookmetamethod(game, "__index", newcclosure(function(self, idx) 
    if idx == "WalkSpeed" then
        return 16;
    elseif idx == "JumpPower" then
        return 50;
    end;
    return BackupMt(self, idx);
end));

for i,v in pairs(InternalFunctions) do
    if type(v) == "function" and table.find(debug.getconstants(v), "%d/%d") then
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
            Flags.InfiniteNitro = bool;
        end,
        Enabled = false
    });

    VehiclePage.Toggle({
        Text = "No Tire Pop",
        Callback = function(bool) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.TirePopDuration = 0;
            end;
            VehicleConfig.TirePopDuration = 0;
        end;
    });

    VehiclePage.Slider({
        Text = "Vehicle Bounce",
        Min = 0,
        Max = 100,
        Def = 100,
        Callback = function(value) 
            local Packet = Vehicle.GetLocalVehiclePacket();
            if Packet then
                Packet.Bounce = value;
            end;
            VehicleConfig.Bounce = value;
        end
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
end;

-- Combat
do 
    local GunPage = UI.New({
        Title = "Combat"
    });

    GunPage.Slider({
        Text = "FireRate Multiplier",
        Min = 2,
        Max = 100,
        Def = 2,
        Callback = function(value) 
            if __equiped and __equiped.Config then
                __equiped.Config.FireFreq = __equiped.Config.FireFreq * value;
            end;
            GunConfig.FireFreq = GunConfig.FireFreq * value;
        end;
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

    GunPage.Dropdown({
        Text = "Emulate Weapon",
        Callback = function(Value) 
            if WepTypes[Value] then
                GunConfig = setmetatable(WepTypes[Value], __methods);
            end;
        end,
        Options = {
            "Rifle"
        }
    });
end;

-- Misc
do 
    local Misc = UI.New({
        Title = "Misc"
    });

    Misc.Toggle({
        Text = "Loop Eject",
        Callback = function(bool) 
            Flags.EjectLoop = bool;
        end,
        Enabled = false
    });

    Misc.Toggle({
        Text = "No Cooldown",
        Callback = function(bool) 
            for i,v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Duration") then
                    if not v.Backup then
                        v.Backup = v.Duration;
                    end;
                    rawset(v, "Duration", bool and 0 or v.Backup);
                end;
            end;
        end,
        Enabled = false
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
        end
    })

    Player.Slider({
        Text = "JumpPower",
        Min = 1,
        Def = 50,
        Max = 200,
        Callback = function(value) 
            LocalPlayer.Character.Humanoid.JumpPower = value;
        end
    });

    local Falling = GetLocal("StartRagdolling");
    local Backup;
    Backup = hookfunction(Falling.StartRagdolling, function(...) 
        if Flags.NoRagdoll then return end;
        return Backup(...)
    end);
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
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end;
    
        local LPos = LocalPlayer.Character.HumanoidRootPart.Position;
        local Players = {};
    
        for i,v in pairs(game.Players:GetChildren()) do
            if v ~= LocalPlayer then
                local Character = v.Character;
                local HumanoidRootPart = Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
                if HumanoidRootPart then
                    if v.TeamColor == LocalPlayer.TeamColor then
                        continue;
                    end;
    
                    local _, Visible = WorldToViewportPoint(Camera, HumanoidRootPart.Position);
                    if Visible then
                        local Between = (HumanoidRootPart.Position - LPos).magnitude;
                        Players[#Players+1] = {Between, Character};
                    end;
                end;
            end;
        end;
    
        table.sort(Players, function(x,y) return x[1] < y[1] end);
    
        return Players[1] and Players[1][2];
    end;
end

Vehicle.OnVehicleEntered:Connect(function(Vehicle) 
    warn("debug: entered vehicle");

    for i,v in pairs(Vehicle) do
        if rawget(VehicleConfig, i) then
            Vehicle[i] = VehicleConfig[i];
        end;
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

    for i,v in pairs(Item.Config) do
        if rawget(GunConfig, i) then
            Item.Config[i] = GunConfig[i];
        end;
    end;
    Flags.ItemEquipped = true;
end);

Item.OnLocalItemUnequipped:Connect(function() 
    Flags.ItemEquipped = false;
end);

game.RunService.Stepped:Connect(function() 
    if Flags.EjectLoop then
        for i,v in pairs(game.Workspace.Vehicles:GetChildren()) do
            Event:FireServer("l59h3mcg", v);
        end;
    end;

    if Flags.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and Flags.ItemEquipped then
        local Closest = GetClosestPlayer();
        if Closest then
            local Target = Flags.AimbotTarget or "Head";
            local _, Visible = WorldToViewportPoint(Camera, Closest[Target].Position);
            if Visible then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest[Target].Position);
                --Camera.CFrame = CFrame(Camera.CFrame.Position, Closest[Target].Position); for first person
            end;
        end
    end
end);

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
