local RunService = game:GetService("RunService")
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
local TweenService = Services.TweenService
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse();
local mouseVector = Vector2.new(Mouse.X, Mouse.Y);
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

local settings = {
    auto_farm = false,
    tween_speed = 1,
    fast_attack = false,
    offsets = {
        X = 3,
        Y = 10,
        Z = 0,
    },
    tool = "Black Leg",
	auto_third = false,
	auto_second = false
};


local trampoline_call = function(func, ...)
    local funcinfo = debug.getinfo(func);
    local funcenv = getfenv(func);
    local result = {syn.trampoline_call(func, {
        env = funcenv,
        source = funcinfo.source,
        name = funcinfo.name,
        currentline = funcinfo.currentline,
        numparams = funcinfo.numparams,
        is_varag = funcinfo.is_vararg
    }, {
        identity = 2,
        script = script,
        env = funcenv
    }, ...)}
    if (result[1]) then
        return unpack(result, 2);
    end
    error("trampoline call error:\n" .. debug.traceback());
end

local protectInstance = function(instance)
    protectedInstances[#protectedInstances + 1] = instance
end

local tp_to = function(pos)
    local char = LocalPlayer.Character
    if (not char) then return; end
    local root = char:FindFirstChild("HumanoidRootPart");
    if (not root) then return; end
    root.Anchored = true
    wait();
    root.CFrame = pos
    wait();
    root.Anchored = false
    return root;
end

local serverhop = function(order)
    local Servers = {};
    local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100", game.PlaceId, order);
    local starting = tick();
    local Server;
    repeat
        local good, result = pcall(function()
            return game:HttpGet(url);
        end);
        if (not good) then
            wait(2);
            continue;
        end
        local decoded = Services.HttpService:JSONDecode(result);
        if (#decoded.data ~= 0) then
            Servers = decoded.data
            for i, v in pairs(Servers) do
                if (v.maxPlayers and v.playing and v.maxPlayers > v.playing) then
                    Server = v
                    break;
                end
            end
            if (Server) then
                break;
            end
        end
        url = format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100&cursor=%s", game.PlaceId, order, decoded.nextPageCursor);
    until tick() - starting >= 600;
    if (not Server or #Servers == 0) then
        return "no servers found";
    end

    local queue_on_teleport = syn and syn.queue_on_teleport or queue_on_teleport
    if (queue_on_teleport) then
        queue_on_teleport("print('scripthere')");
    end;

    Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id);    
end

local positions = {
    breathing = {
        insect = { 2876, 316, -3917 },
        thunder = { -321, 426, -2384 },
        water = { 710, 260, -2396 },
        wind = { 1792, 333, -3520 }
    },
    locations = {
        ababu_cave = { 1063, 275, -3426 },
        butterfly_mansion = { 3000, 315, -3711 },
        dangerous_woods = { 4005, 341, -3780 },
        final_selection = { 5033, 365, -2426 },
        kabiwaru_village = { 2005, 315, -3104 },
        kiribating_village = { 121, 281, -1719 },
        ouwbayashi_home = { 1708, 315, -4595 },
        slasher_demon = { 4288, 341, -4213 },
        waroru_cave = { 691, 261, -2463 },
        wind_trainer = { 1803, 316, -3418 },
        ushumaru = { -295, 274, -3336 },
        zapiwara_cave = { 83, 274, -2419 },
        zapiwara_mountain = { -326, 425, -2358 }
    }
}

local m = UILibrary:CreateWindow("Fate Hub", "Project Slayers", Color3.fromRGB(100, 0, 255));

local main = m:Tab("Main");

local farming = main:Section("Farming");

local mobs = Workspace:FindFirstChild("Mobs");
local Bosses = mobs:FindFirstChild("Bosses");
local bosses = {
    "All (Rotation)"
};

for i, boss in pairs(Bosses:GetChildren()) do
    if (boss.ClassName == "Folder") then
        boss = boss:FindFirstChildOfClass("Configuration");
    end
    local bossModel = boss:FindFirstChildOfClass("Model");
    if (bossModel) then
        bosses[#bosses + 1] = bossModel.Name
    end
end

local bossSlider = farming:Dropdown("Select Boss", bosses[1], bosses, function(callback)
    settings.boss_name = callback
end);

Bosses.ChildRemoved:Connect(function(boss)
    table.remove(bosses, table.find(bosses, boss:FindFirstChildOfClass("Model").Name));
    bossDropdown:Update();
end);
Bosses.ChildAdded:Connect(function(boss)
    bosses[#bosses + 1] = boss:FindFirstChildOfClass("Model").Name
    bossDropdown:Update();
end);



local Remotes = Services.ReplicatedStorage:WaitForChild("Remotes");
local To_ServerRemotes = Remotes:WaitForChild("To_Server");
local Handle_Initiate_S_ = To_ServerRemotes:WaitForChild("Handle_Initiate_S_");


do
    local char = LocalPlayer.Character 
    local root = char.HumanoidRootPart
    local hum = char.Humanoid
    Handle_Initiate_S_:InvokeServer("fist_combat", LocalPlayer, char, root, hum, 1);
end

local function attackBoss(thread, bossName)
    local threadResumed = false
    local char = LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart");

    local foundBoss = nil
    for i, boss in pairs(Bosses:GetChildren()) do
        if (boss.ClassName == "Folder") then
            boss = boss:FindFirstChildOfClass("Configuration");
        end
        local bossModel = boss:FindFirstChildOfClass("Model");
        if (bossModel and bossModel.Name == bossName) then
            foundBoss = bossModel
        end
    end


    if (not foundBoss) then
        return coroutine.resume(thread);
    end

    local bossRoot = foundBoss:FindFirstChild("HumanoidRootPart");
    if (not bossRoot) then return coroutine.resume(thread); end
    tp_to(bossRoot.CFrame);
    wait(.5);

    local lasttick = tick();
    local connection;
    connection = Services.RunService.Heartbeat:Connect(function()
        local bossPosition = bossRoot.Position
        char = LocalPlayer.Character
        if (not char) then return; end
        root = findFirstChild(char, "HumanoidRootPart");
        if (not root) then return; end
        local humanoid = findFirstChild(char, "Humanoid");
        if (not humanoid) then return; end

        root.CFrame = CFrame.new(bossPosition) * CFrame.new(0, -6, 0);

        local now = tick();
        if ((now - lasttick) > 2) then
            lasttick = now
            for i = 1, 5 do
                Handle_Initiate_S_:InvokeServer("fist_combat", LocalPlayer, char, root, hum, 919);
                wait(.5);
            end
        end
    end);

    task.delay(10, function()
        connection:Disconnect();
    end);

    coroutine.yield();
end

farming:Toggle("Farm Boss", false, function(callback)
    settings.auto_farm = callback
end);
farming:Toggle("Auto Collect", false, function(callback)
    settings.auto_collect = true
end);

local weapons = {};
for i, weapon in pairs(LocalPlayer.Backpack:GetChildren()) do
    if (weapon:FindFirstChild("Mastery_Equipped")) then
        weapons[#weapons + 1] = weapon.Name
    end
end

farming:Dropdown("Select Weapon", weapons[1], weapons, function(callback)
    settings.weapon = callback
end);


local teleports = m:Tab("Teleports");

local breathing = teleports:Section("Breathing Trainers");

for trainer, pos in pairs(positions.breathing) do
    local name = string.upper(string.sub(trainer, 1, 1)) .. string.sub(trainer, 2) .. " Breathing"
    breathing:Button(name, function()
        tp_to(CFrame.new(unpack(pos)));
    end);
end

local locations = teleports:Section("Map Locations");

for location, pos in pairs(positions.locations) do
    local name = string.gsub(location, "_", " ");
    locations:Button(name, function()
        tp_to(CFrame.new(unpack(pos)));
    end);
end

local Servers = teleports:Section("Servers");

Servers:Button("Smallest Server", function()
    serverhop("Asc");
end);
Servers:Button("Other Server", function()
    serverhop("Desc");
end);
Servers:Button("Rejoin Server", function()
    Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId);
end);

local other = teleports:Section("Other Teleports");

other:SetLeft();

other:Button("Sword Repair (Jeph)", function()
    tp_to(CFrame.new( 263, 282, -1511 ));
end);
other:Button("Muzan", function()
    local Muzan = Workspace:FindFirstChild("Muzan");
    if (Muzan) then
        tp_to(Muzan.HumanoidRootPart.CFrame * CFrame.new(5, 0, 0));
    end
end);

local anchored = false
other:Button("Spider Lily", function()
    if (anchored) then
        tp_to(anchored);
    end
    local DemonFlowers = Workspace:FindFirstChild("Demon_Flowers_Spawn");
    local DemonFlower = DemonFlowers:FindFirstChild("Demon_Flower");
    if (DemonFlower) then
        local pos = DemonFlower:GetBoundingBox();
        local hrp, oldpos = tp_to(pos);
        hrp.Anchored = true
        anchored = oldpos
    end
end);

while true do
    if (settings.auto_farm) then
        local thread = coroutine.running();
        attackBoss(thread, settings.boss_name);
    end
    wait();
end