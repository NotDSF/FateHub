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


local incDist = 10
local tp_to = function(pos)
    local char = LocalPlayer.Character
    if (not char) then return; end
    local root = char:FindFirstChild("HumanoidRootPart");
    local hum = char:FindFirstChild("Humanoid");

    local posX = pos.Position.X
    local posY = pos.Position.Y + 30
    local posZ = pos.Position.Z

    while true do
        local x = root.Position.X
        local y = root.Position.Y
        local z = root.Position.Z

        if (x > posX and (x - posX) > 5) then
            x -= math.min(incDist, x - posX)
        elseif (x < posX and (posX - x) > 5) then
             x += math.min(incDist, posX - x);
        end
        if (y > posY and (y - posY) > 5) then
            y -= math.min(incDist, y - posY)
        elseif (y < posY and (posY - y) > 5) then
            y += math.min(incDist, posY - y);
        end
        if (z > posZ and (z - posZ) > 5) then
            z -= math.min(incDist, z - posZ)
        elseif (z < posZ and (posZ - z) > 5) then
             z += math.min(incDist, posZ - z);
        end
        local rootPos = root.Position
        local posPos = pos.Position
        local pos1 = Vector3.new(rootPos.X, 0, rootPos.Z);
        local pos2 = Vector3.new(posPos.X, 0, posPos.Z);
        if ((pos1 - pos2).Magnitude < 5) then
            break;
        end
        root.Anchored = false
        root.CFrame = CFrame.new(x, y, z);
        wait();
        root.Anchored = true
        hum:ChangeState(Enum.HumanoidStateType.Landed);
    end
    root.Anchored = false
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

local living = Workspace:FindFirstChild("Living");
local gameLocations = Workspace:FindFirstChild("Locations");

local mainWindow = UILibrary:CreateWindow("Fate Hub", "Your Bizzare Adventure", Color3.fromRGB(100, 0, 255));

local visuals = mainWindow:Tab("Teleports");

local locations = visuals:Section("Locations");


local locations_ = {};
for i, location in pairs(gameLocations:GetChildren()) do
    local locationName = location.Name
    if (locations_[locationName]) then
        local n = 1
        local newName
        repeat
            newName = string.format("%s (%s)", locationName, n);
            n += 1
        until not locations_[newName]
        locationName = newName
    end
    locations_[locationName] = location.CFrame
    locations:Button(locationName, function()
        tp_to(locations_[locationName]);
    end);
end