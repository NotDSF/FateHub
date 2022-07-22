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
	target_only_attacking = true,
    offsets = {
        X = 3,
        Y = 10,
        Z = 0,
    },
    tool = "Fishman Karate",
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

local tweento = function(pos, noyield)
    local char = LocalPlayer.Character
    if (char) then
        local root = char.HumanoidRootPart
        local distance = (root.Position - pos.Position).Magnitude
        local tweenInfo = TweenInfo.new(distance / 250 * settings.tween_speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
        local tween = TweenService:Create(root, tweenInfo, { CFrame = pos });
        tween:Play();
        if (not noyield) then
            tween.Completed:Wait();
        end
        return true;
    end
    return false
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

local CombatFrameworkOld = require(LocalPlayer.PlayerScripts.CombatFramework);
local CombatFramework = debug.getupvalue(CombatFrameworkOld, 2);
local CameraShaker = require(ReplicatedStorage.Util.CameraShaker);
CameraShaker:Stop();

local attack = function()
    local char = LocalPlayer.Character
    if (char) then
        local toolEquipped = char:FindFirstChildOfClass("Tool");
        if (not toolEquipped) then
            local combat = findFirstChild(LocalPlayer.Backpack, settings.tool);
            if (combat) then
                combat.Parent = char;
            end
        end
        local connections = getconnections(Mouse.Button1Down);
        if (connections[1]) then
            connections[1].Function();
        end
    end

    return char;
end


RunService.RenderStepped:Connect(function()
	local activeController = CombatFramework.activeController

	local char = LocalPlayer.Character

	if (not char or not activeController) then return; end
	if (settings.auto_farm) then
		activeController.hitboxMagnitude = 55
	end

	if (settings.fast_attack) then
		if findFirstChild(char, "Black Leg") then
			activeController.timeToNextAttack = 3
		elseif findFirstChild(char, "Electro") then
			activeController.timeToNextAttack = 2
		else
			activeController.timeToNextAttack = 0
		end

		activeController.attacking = false
		activeController.increment = 3
		activeController.blocking = false
		activeController.timeToNextBlock = 0
		char.Humanoid.Sit = false
	end	
end)

local fastattack = function()
	local char = LocalPlayer.Character
	if (not char) then return; end
    attack();

    local stun = findFirstChild(char, "Stun");
    if (stun) then
        stun.Value = 0
    end
end

local enemies = Workspace:FindFirstChild("Enemies");

local getNPCsFromName = function(find)
    local char = LocalPlayer.Character
    if (not char) then return; end
    local localRoot = findFirstChild(char, "HumanoidRootPart");
    local localPos = localRoot.Position

    local enemiesChildren = enemies:GetChildren();
    local found = {};
    for i = 1, #enemiesChildren do
        local enemy = enemiesChildren[i]
        if (string.find(enemy.Name, find)) then
            local root = findFirstChild(enemy, "HumanoidRootPart");
            if (root) then
                found[#found + 1] = {enemy, (localPos - root.Position).Magnitude};
            end
        end
    end

    repeat
        local swapped = false
        for i = 2, #found do
            if (found[i - 1][2] > found[i][2]) then
                found[i], found[i - 1] = found[i - 1], found[i]
                swapped = true
            end
        end
    until swapped == false;

    for i = 1, #found do
        found[i] = found[i][1]
    end

    return found;
end

local getClosestNPC = function(list)
    local char = LocalPlayer.Character
    local pos = nil
    if (char) then
        local root = char.HumanoidRootPart
        local dist, npc = math.huge, nil;
        local enemiesChildren = enemies:GetChildren();
        local n = list and #list or #enemiesChildren
        for i = 1, n do
            local enemy = (list or enemiesChildren)[i]
            local enemyRoot = findFirstChild(enemy, "HumanoidRootPart");
            local enemyHumanoid = findFirstChild(enemy, "Humanoid");
            local mag = enemyRoot and (root.Position - enemyRoot.Position).Magnitude or false
            if (enemyRoot and dist > mag and enemyHumanoid and enemyHumanoid.Health ~= 0) then
                pos = enemyRoot.CFrame
                dist = mag
                npc = enemy
            end
        end
        return npc, pos;
    end
end

local one = cframenew(1, 1, 1);
local bring = function(npc, offset)
    sethiddenproperty(LocalPlayer, "SimulationRadius", 2000);
    wait();

    local char = LocalPlayer.Character
    local localRoot = findFirstChild(char, "HumanoidRootPart");
    local root = findFirstChild(npc, "HumanoidRootPart");

    if (localRoot and root and isnetworkowner(root)) then
        root.CFrame = localRoot.CFrame * (offset or one);
    end
end

local questOrder = {
	{
		levels = { 1, 10 },
		NPCName = "Bandit",
		questNumber = 1,
		questPosition = { 1060, 16, 1547 },
		questName = "BanditQuest1"
	},
	{
		levels = { 11, 15 },
		NPCName = "Monkey",
		questNumber = 1,
		questPosition = { -1604, 36, 154 },
		questName = "JungleQuest"
	},
	{
		levels = { 16, 30 },
		NPCName = "Gorilla",
		questNumber = 2,
		questPosition = { -1601, 36, 153 },
		questName = "JungleQuest"
	},
	{
		levels = { 31, 40 },
		NPCName = "Pirate",
		questNumber = 1,
		questPosition = { -1140, 4, 3827 },
		questName = "BuggyQuest1"
	},
	{
		levels = { 41, 60 },
		NPCName = "Brute",
		questNumber = 2,
		questPosition = { -1140, 4, 3827 },
		questName = "BuggyQuest1"
	},
	{
		levels = { 61, 75 },
		NPCName = "Desert Bandit",
		questNumber = 1,
		questPosition = { 896, 6, 4390 },
		questName = "DesertQuest"
	},
	{
		levels = { 76, 90 },
		NPCName = "Desert Officer",
		questNumber = 2,
		questPosition = { 896, 6, 4390 },
		questName = "DesertQuest"
	},
	{
		levels = { 91, 100 },
		NPCName = "Snow Bandit",
		questNumber = 1,
		questPosition = { 1386, 87, -1298 },
		questName = "SnowQuest"
	},
	{
		levels = { 101, 120 },
		NPCName = "Snowman",
		questNumber = 2,
		questPosition = { 1386, 87, -1298 },
		questName = "SnowQuest"
	},
	{
		levels = { 121, 150 },
		NPCName = "Chief Petty Officer",
		questNumber = 1,
		questPosition = { -5035, 28, 4324 },
		questName = "MarineQuest2"
	},
	{
		levels = { 151, 175 },
		NPCName = "Sky Bandit",
		questNumber = 1,
		questPosition = { -4841, 717, -2623 },
		questName = "SkyQuest"
	},
	{
		levels = { 176, 250 },
		NPCName = "Dark Master",
		questNumber = 2,
		questPosition = { -4841, 717, -2623 },
		questName = "SkyQuest"
	},
	{
		levels = { 251, 275 },
		NPCName = "Toga Warrior",
		questNumber = 1,
		questPosition = { -1576, 7, -2983 },
		questName = "ColosseumQuest"
	},
	{
		levels = { 276, 300 },
		NPCName = "Gladiator",
		questNumber = 2,
		questPosition = { -1576, 7, -2983 },
		questName = "ColosseumQuest"
	},
	{
		levels = { 301, 330 },
		NPCName = "Military Soldier",
		questNumber = 1,
		questPosition = { -5316, 12, 8517 },
		questName = "MagmaQuest"
	},
	{
		levels = { 301, 375 },
		NPCName = "Military Spy",
		questNumber = 2,
		questPosition = { -5316, 12, 8517 },
		questName = "MagmaQuest"
	},
	{
		levels = { 376, 400 },
		NPCName = "Fishman Warrior",
		questNumber = 1,
		questPosition = { 61122, 18, 1568 },
		questName = "FishmanQuest"
	},
	{
		levels = { 401, 450 },
		NPCName = "Fishman Commando",
		questNumber = 2,
		questPosition = { 61122, 18, 1568 },
		questName = "FishmanQuest"
	},
	{
		levels = { 451, 475 },
		NPCName = "God's Guard",
		questNumber = 1,
		questPosition = { -4721, 845, -1954 },
		questName = "SkyExp1Quest"
	},
	{
		levels = { 476, 525 },
		NPCName = "Shanda",
		questNumber = 2,
		questPosition = { -7863, 5545, -379 },
		questName = "SkyExp1Quest"
	},
	{
		levels = { 526, 550 },
		NPCName = "Royal Squad",
		questNumber = 1,
		questPosition = { -7902, 5635, -1411 },
		questName = "SkyExp2Quest"
	},
	{
		levels = { 551, 625 },
		NPCName = "Royal Soldier",
		questNumber = 2,
		questPosition = { -7902, 5635, -1411 },
		questName = "SkyExp2Quest"
	},
	{
		levels = { 626, 650 },
		NPCName = "Galley Pirate",
		questNumber = 1,
		questPosition = { 5254, 38, 4049 },
		questName = "FountainQuest"
	},
	{
		levels = { 701, 725 },
		NPCName = "Raider",
		questNumber = 1,
		questPosition = { -424, 73, 1836 },
		questName = "Area1Quest"
	},
	{
		levels = { 726, 775 },
		NPCName = "Mercenary",
		questNumber = 2,
		questPosition = { -424, 73, 1836 },
		questName = "Area1Quest"
	},
	{
		levels = { 776, 875 },
		NPCName = "Swan Pirate",
		questNumber = 1,
		questPosition = { 632, 73, 918 },
		questName = "Area2Quest"
	},
	{
		levels = { 876, 900 },
		NPCName = "Marine Lieutenant",
		questNumber = 1,
		questPosition = { -2442, 73, -3219 },
		questName = "MarineQuest3"
	},
	{
		levels = { 901, 950 },
		NPCName = "Marine Captain",
		questNumber = 2,
		questPosition = { -2442, 73, -3219 },
		questName = "MarineQuest3"
	},
	{
		levels = { 951, 975 },
		NPCName = "Zombie",
		questNumber = 1,
		questPosition = { -5492, 48, -793 },
		questName = "ZombieQuest"
	},
	{
		levels = { 976, 1000 },
		NPCName = "Vampire",
		questNumber = 2,
		questPosition = { -5492, 48, -793 },
		questName = "ZombieQuest"
	},
	{
		levels = { 1001, 1050 },
		NPCName = "Snow Trooper",
		questNumber = 1,
		questPosition = { 604, 401, -5371 },
		questName = "SnowMountainQuest"
	},
	{
		levels = { 1051, 1100 },
		NPCName = "Winter Warrior",
		questNumber = 2,
		questPosition = { 604, 401, -5371 },
		questName = "SnowMountainQuest"
	},
	{
		levels = { 1101, 1125 },
		NPCName = "Lab Subordinate",
		questNumber = 1,
		questPosition = { -6060, 15, -4904 },
		questName = "IceSideQuest"
	},
	{
		levels = { 1126, 1175 },
		NPCName = "Horned Warrior",
		questNumber = 2,
		questPosition = { -6060, 15, -4904 },
		questName = "IceSideQuest"
	},
	{
		levels = { 1176, 1200 },
		NPCName = "Magma Ninja",
		questNumber = 1,
		questPosition = { -5431, 15, -5296 },
		questName = "FireSideQuest"
	},
	{
		levels = { 1201, 1350 },
		NPCName = "Lava Pirate",
		questNumber = 2,
		questPosition = { -5431, 15, -5296 },
		questName = "FireSideQuest"
	},
	{
		levels = { 1351, 1375 },
		NPCName = "Arctic Warrior",
		questNumber = 1,
		questPosition = { 5669, 28, -6482 },
		questName = "FrostQuest"
	},
	{
		levels = { 1376, 1425 },
		NPCName = "Snow Lurker",
		questNumber = 2,
		questPosition = { 5669, 28, -6482 },
		questName = "FrostQuest"
	},
	{
		levels = { 1426, 1450 },
		NPCName = "Sea Soldier",
		questNumber = 1,
		questPosition = { -3052, 236, -10148 },
		questName = "ForgottenQuest"
	},
	{
		levels = { 1451, 1500 },
		NPCName = "Water Fighter",
		questNumber = 2,
		questPosition = { -3052, 236, -10148 },
		questName = "ForgottenQuest"
	},
	{
		levels = { 1501, 1525 },
		NPCName = "Pirate Millionaire",
		questNumber = 1,
		questPosition = { -290, 42, 5581 },
		questName = "PiratePortQuest"
	},
	{
		levels = { 1526, 1575 },
		NPCName = "Pistol Billionaire",
		questNumber = 2,
		questPosition = { -290, 42, 5581 },
		questName = "PiratePortQuest"
	},
	{
		levels = { 1576, 1600 },
		NPCName = "Dragon Crew Warrior",
		questNumber = 1,
		questPosition = { 5832, 51, -1101 },
		questName = "AmazonQuest"
	},
	{
		levels = { 1601, 1625 },
		NPCName = "Dragon Crew Archer",
		questNumber = 2,
		questPosition = { 5832, 51, -1101 },
		questName = "AmazonQuest"
	},
	{
		levels = { 1626, 1650 },
		NPCName = "Female Islander",
		questNumber = 1,
		questPosition = { 5448, 601, 751 },
		questName = "AmazonQuest2"
	},
	{
		levels = { 1651, 1700 },
		NPCName = "Giant Islander",
		questNumber = 2,
		questPosition = { 5448, 601, 751 },
		questName = "AmazonQuest2"
	},
	{
		levels = { 1701, 1725 },
		NPCName = "Marine Commodore",
		questNumber = 1,
		questPosition = { 2180, 27, -6741 },
		questName = "MarineTreeIsland"
	},
	{
		levels = { 1726, 1775 },
		NPCName = "Marine Rear Admiral",
		questNumber = 2,
		questPosition = { 2180, 27, -6741 },
		questName = "MarineTreeIsland"
	},
	{
		levels = { 1776, 1800 },
		NPCName = "Fishman Raider",
		questNumber = 1,
		questPosition = { -10581, 330, -8761 },
		questName = "DeepForestIsland3"
	},
	{
		levels = { 1801, 1825 },
		NPCName = "Fishman Captain",
		questNumber = 2,
		questPosition = { -10581, 330, -8761 },
		questName = "DeepForestIsland3"
	},
	{
		levels = { 1826, 1850 },
		NPCName = "Forest Pirate",
		questNumber = 1,
		questPosition = { -13234, 331, -7625 },
		questName = "DeepForestIsland"
	},
	{
		levels = { 1851, 1900 },
		NPCName = "Mythological Pirate",
		questNumber = 2,
		questPosition = { -13234, 331, -7625 },
		questName = "DeepForestIsland"
	},
	{
		levels = { 1901, 1925 },
		NPCName = "Jungle Pirate",
		questNumber = 1,
		questPosition = { -12680, 389, -9902 },
		questName = "DeepForestIsland2"
	},
	{
		levels = { 1926, 1975 },
		NPCName = "Musketeer Pirate",
		questNumber = 2,
		questPosition = { -12680, 389, -9902 },
		questName = "DeepForestIsland2"
	},
	{
		levels = { 1976, 2000 },
		NPCName = "Reborn Skeleton",
		questNumber = 1,
		questPosition = { -9480, 142, 5566 },
		questName = "HauntedQuest1"
	},
	{
		levels = { 2001, 2025 },
		NPCName = "Living Zombie",
		questNumber = 2,
		questPosition = { -9480, 142, 5566 },
		questName = "HauntedQuest1"
	},
	{
		levels = { 2026, 2050 },
		NPCName = "Demonic Soul",
		questNumber = 1,
		questPosition = { -9516, 178, 6078 },
		questName = "HauntedQuest2"
	},
	{
		levels = { 2051, 2075 },
		NPCName = "Posessed Mummy",
		questNumber = 2,
		questPosition = { -9516, 178, 6078 },
		questName = "HauntedQuest2"
	},
	{
		levels = { 2076, 2100 },
		NPCName = "Peanut Scout",
		questNumber = 1,
		questPosition = { -2104, 38, -10194 },
		questName = "NutsIslandQuest"
	},
	{
		levels = { 2101, 2125 },
		NPCName = "Peanut President",
		questNumber = 2,
		questPosition = { -2104, 38, -10194 },
		questName = "NutsIslandQuest"
	},
	{
		levels = { 2126, 2150 },
		NPCName = "Ice Cream Chef",
		questNumber = 1,
		questPosition = { -820, 65, -10966 },
		questName = "IceCreamIslandQuest"
	},
	{
		levels = { 2151, 2300 },
		NPCName = "Ice Cream Commander",
		questNumber = 2,
		questPosition = { -820, 65, -10966 },
		questName = "IceCreamIslandQuest"
	},
};

local forcelvl = nil
local getQuestInfo = function()
    local level = forcelvl or LocalPlayer.Data.Level.Value + 1

    for i, questInfo in pairs(questOrder) do
        local NPClevels = questInfo.levels
        if (level >= NPClevels[1] and level <= NPClevels[2]) then
            return questInfo;
        end
    end
end

local remotes = ReplicatedStorage:FindFirstChild("Remotes");
local commF = remotes.CommF_

local startQuest = function()
    local questInfo = getQuestInfo();
    local questPosition = cframenew(unpack(questInfo.questPosition));
    local char = LocalPlayer.Character
    local root = findFirstChild(char, "HumanoidRootPart");
    local oldPos = root.CFrame
    local distance = (root.Position - questPosition.Position).Magnitude
	local spawnSet = false
	local lvl = forcelvl or LocalPlayer.Data.Level.Value + 1
	if (376 <= lvl and 450 >= lvl) then
		print("true in bounds");
		local portal = Workspace._WorldOrigin.PlayerSpawns.Pirates.Fishman:GetBoundingBox();
		local portalDist = (oldPos.Position - portal.Position).Magnitude
		local exitPortal = workspace.Map.TeleportSpawn.Exit.CFrame
		local exitPortalDist = (oldPos.Position - exitPortal.Position).Magnitude
		if ((portalDist >= 3000 or portalDist <= 500) and (oldPos.Position - questPosition.Position).Magnitude >= 1000) then
			print("tping to portal fishman");
			tweento(portal);
			for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
			spawnSet = true
			wait(3);
		end
	elseif (lvl == 450) then
		LocalPlayer.Character:BreakJoints();
		LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart");
	end
    tweento(questPosition);
    if (distance > 1000) then
        wait();
        if (not spawnSet) then
			print("setting dumb spawn");
			for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
		end
    end
    commF:InvokeServer("StartQuest", questInfo.questName, questInfo.questNumber);
end

local questActive = function()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
    local MainUI = PlayerGui:FindFirstChild("Main");
    local Quest = MainUI:FindFirstChild("Quest");
    return Quest.Visible, Quest;
end

local activeQuestData = function()
    local active, questUI = questActive();
    if (not active) then commF:InvokeServer("AbandonQuest"); wait(); startQuest(); wait(.1); active, questUI = questActive(); end
    local questTitle = questUI:FindFirstChild("QuestTitle", true);
    if (questTitle) then
        local title = questTitle:FindFirstChild("Title");
        local progress = string.match(title.Text, ".*(%d/%d)");
        local killData = string.split(progress, "/");
        return {
            killed = tonumber(killData[1]),
            amountToKill = tonumber(killData[2])
        };
    end
    return {
        killed = 0,
        amountToKill = 0
    };
end

local characterPos = vector3new();
local attackingNPCs = {};
local offsets = settings.offsets;

local doQuest = function()
    table.clear(attackingNPCs);

    local thread = coroutine.running();
    local threadResumed = false
    local questConnections = {};

    local active = questActive();
    if (not active) then
        startQuest();
        wait(.5);
    end

    local currentQuestData = activeQuestData();
    local questInfo = getQuestInfo();

    local char = LocalPlayer.Character
    local attackingPosition = CFrame.new(settings.offsets.X, settings.offsets.Y, settings.offsets.Z);
    local offset = CFrame.new(-3, -(settings.offsets.Y - 5), 0);

    local function wakeNPC(npc, first)
        local npcHumanoid = npc:WaitForChild("Humanoid");
        if (npcHumanoid.Health == 0 or table.find(attackingNPCs, npc)) then return; end

		npcHumanoid.Died:Connect(function()
            table.remove(attackingNPCs, table.find(attackingNPCs, npc));
            wait(.1);
            if (not threadResumed and not questActive()) then
                coroutine.resume(thread);
                threadResumed = true
                for i, connection in pairs(questConnections) do
                    connection:Disconnect();
                end
            end
        end);
        attackingNPCs[#attackingNPCs + 1] = npc

        local localRoot = char:FindFirstChild("HumanoidRootPart");
        local npcRoot = npc:FindFirstChild("HumanoidRootPart");
        local oldPosition = localRoot.CFrame
        if (first) then
            tweento(npcRoot.CFrame);
            wait();
        end
        local con;
        con = RunService.Heartbeat:Connect(function()
            if (localRoot and npcRoot) then
                localRoot.CFrame = npcRoot.CFrame * attackingPosition
                attack();
            end
        end);
        wait(.1);
        con:Disconnect();
        localRoot.CFrame = oldPosition
        task.spawn(function()
            for i = 1, 3 do
                bring(npc, offset);
                wait(.1);
            end
        end);
    end

    local aliveNPCs = getNPCsFromName(questInfo.NPCName);
    for i = 1, currentQuestData.amountToKill - currentQuestData.killed do
        local npc = aliveNPCs[i]
        if (npc) then
            wakeNPC(npc, i == 1);
        end
    end

    questConnections[#questConnections + 1] = RunService.Heartbeat:Connect(function()
        if (not settings.auto_farm) then
            coroutine.resume(thread);
            threadResumed = true
            for i, connection in pairs(questConnections) do
                connection:Disconnect();
            end
            return;
        end

        char = LocalPlayer.Character
        if (not char) then return; end
        local localRoot = char:FindFirstChild("HumanoidRootPart");
        if (localRoot) then
            local _, pos = getClosestNPC(attackingNPCs);
            if (pos) then
                local newpos = pos * attackingPosition
                localRoot.CFrame = newpos
                characterPos = localRoot.Position
                if (settings.fast_attack) then
                    fastattack();
                else
                    attack();
                end
            end
            for i = 1, #attackingNPCs do
                local npc = attackingNPCs[i]
                if (npc) then
                    local root = findFirstChild(npc, "HumanoidRootPart");
                    if (root and (characterPos - root.Position).Magnitude > 30) then
                        bring(npc, offset);
                    end
                end
            end
        end

		if (#attackingNPCs == 0) then
			local aliveNPCs = getNPCsFromName(questInfo.NPCName);
			for i = 1, currentQuestData.amountToKill - currentQuestData.killed do
				local npc = aliveNPCs[i]
				if (npc) then
					wakeNPC(npc, i == 1);
				end
			end
		end

        attackingPosition = CFrame.new(settings.offsets.X, settings.offsets.Y, settings.offsets.Z);
    end);

    questConnections[#questConnections + 1] = enemies.ChildAdded:Connect(function(npc)
        local npcName = npc.Name
        if (string.find(npcName, questInfo.NPCName)) then
            wakeNPC(npc);
        end
    end);

    coroutine.yield();
	if (settings.auto_third or settings.auto_second) then
		checksea();
	end
end

local getBartiloProgress = function()
	return commF:InvokeServer("BartiloQuestProgress", "Bartilo");
end
checksea = function()
	if (getBartiloProgress() == 0) then
		-- tweento(CFrame.new(456, 73, 299));
		-- commF:InvokeServer("StartQuest", "BartiloQuest", 1);
		-- tweento(CFrame.new(1057, 137, 1242));
		-- local swan = enemies:FindFirstChild("Swan Pirate [Lv. 775]");
		-- repeat wait() swan = findFirstChild(enemies, "Swan Pirate [Lv. 775]"); until swan ~= nil;
		forcelvl = 767
		doQuest();
		forcelvl = nil
		
		wait(.2);
		print(getBartiloProgress());
	end

	-- tweento(CFrame.new(-1836, 11, 1714));

	-- tweento(CFrame.new(-1850, 13, 1750));
	
	-- tweento(CFrame.new(-1858, 19, 1712));
	
	-- tweento(CFrame.new(-1803, 16, 1750));
	
	-- tweento(CFrame.new(-1858, 16, 1724));
	
	-- tweento(CFrame.new(-1869, 15, 1681));
	
	-- tweento(CFrame.new(-1800, 16, 1684));
	
	-- tweento(CFrame.new(-1819, 14, 1717));
	
	-- tweento(CFrame.new(-1813, 14, 1724));

end


local getbladehits;
for i, v in pairs(getgc(true)) do
    if (type(v) == "table") then
        local bladeHits = rawget(v, "getBladeHits");
        if (bladeHits and type(bladeHits) == "function") then
            local old = bladeHits
            v.getBladeHits = function(...)
                if (settings.auto_farm and settings.target_only_attacking) then
                    local torsos = {}
                    for i2 , v2 in pairs(attackingNPCs) do
                        local torso = findFirstChild(v2, "UpperTorso");
                        if (torso and (characterPos - torso.Position).Magnitude < 30) then
                            torsos[#torsos + 1] = torso
                        end
                    end
                    return torsos;
                end
                return old(...);
            end
            break;
        end
    end
end

local mainWindow = UILibrary:CreateWindow("Fate Hub", "Blox Fruits", Color3.fromRGB(100, 0, 255));

local main = mainWindow:Tab("Main");
local autoFarm = main:Section("Auto Farm");


autoFarm:Toggle("Enable AutoFarm", settings.auto_farm, function(callback)
    settings.auto_farm = callback
end);
autoFarm:Toggle("Fast Attack", settings.fast_attack, function(callback)
    settings.fast_attack = callback
end);
autoFarm:Toggle("Only Attack NPC Target", settings.target_only_attacking, function(callback)
	settings.target_only_attacking = callback
end);

local tools = {};
local updateWeapons = function()
	table.clear(tools);

	for i, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if (tool:IsA("Tool") and tool.ToolTip == "Melee") then
			tools[#tools + 1] = tool.Name
		end
	end
	for i, tool in pairs(LocalPlayer.Character:GetChildren()) do
		if (tool:IsA("Tool")  and tool.ToolTip == "Melee") then
			tools[#tools + 1] = tool.Name
		end
	end
	LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
		if (tool.ToolTip == "Melee" and not table.find(tools, tool.Name)) then
			tools[#tools + 1] = tool.Name
		end
	end);
	LocalPlayer.Backpack.ChildRemoved:Connect(function(tool)
		if (tool.ToolTip == "Melee" and table.find(tools, tool.Name)) then
			table.remove(tools, table.find(tools, tool.Name));
		end
	end);
end


updateWeapons();
settings.tool = tools[1]
local weapons = autoFarm:Dropdown("Weapon", tools[1], tools, function(callback)
	settings.tool = callback
end);
autoFarm:Button("Refresh Weapons", function()
	updateWeapons();
	weapons:UpdateList(tools);
end);

autoFarm:Slider("Distance Y", 5, 20, settings.offsets.Y, function(callback)
    settings.offsets.Y = callback
end);

local collectChests = function(safe)
	for i, v in pairs(Workspace:GetChildren()) do
		if (string.sub(v.Name, 1, 5) == "Chest") then
			local char = LocalPlayer.Character
			if (not char) then
				char = LocalPlayer.CharacterAdded:Wait();
			end
			local root = char:WaitForChild("HumanoidRootPart", 10);
			if (not root) then
				break;
			end
			repeat
				root.CFrame = v.CFrame
				char:BreakJoints();
				for i1 = 1, 3 do
					wait();
					firetouchinterest(v, root, 0);
					wait();
					firetouchinterest(v, root, 1);
				end
				wait(.1);
			until v.Parent ~= Workspace or not root or not char;
			wait(.1);
			print("e")
		end
	end
	print("done");
end
autoFarm:Button("Collect All Chests", function(callback)
	collectChests();
end);

local autoWorld = main:Section("Auto World");

autoWorld:Toggle("Auto Third Sea", settings.auto_third, function(callback)
	settings.auto_third = callback
	checksea();
end);

local autoStats = main:Section("Auto Stats");

local statAmount = 50
autoStats:Slider("Stat Amount", 0, 500, statAmount, function(callback)
	statAmount = callback
end);
local statsAuto = {
	Melee = false,
	Defense = false,
	Sword = false,
	Gun = false,
	["Demon Fruit"] = false
};

local points = LocalPlayer:WaitForChild("Data"):WaitForChild("Points")
for stat, enabled in pairs(statsAuto) do
	autoStats:Toggle(stat, enabled, function(callback)
		statsAuto[stat] = callback
	end);
end

task.spawn(function()
	while true do
		local currentPoints = points.Value
		local sharing = 0
		for stat, enabled in pairs(statsAuto) do
			if (enabled) then
				sharing += 1
			end
		end
		local sharedAmount = sharing == 0 and 1 or math.min(currentPoints, statAmount) / sharing
		if (currentPoints >= statAmount) then
			for stat, enabled in pairs(statsAuto) do
				if (enabled) then
					commF:InvokeServer("AddPoint", stat, math.floor(sharedAmount));
				end
			end
		end
		points:GetPropertyChangedSignal("Value"):Wait();
	end
end);

local autoTrain = main:Section("Auto Train");

local autoTrainining = {
	buso = false,
	observation = false
}
autoTrain:Toggle("Auto Train Buso", false, function(callback)
	autoTrainining.buso = callback
end);
autoTrain:Toggle("Auto Train Observation", false, function(callback)
	autoTrainining.observation = callback
end);

task.spawn(function()
	while true do
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
		char:WaitForChild("Humanoid");
		char:WaitForChild("HumanoidRootPart");
		wait(.1);
		if (autoTrainining.buso) then
			if (not char:FindFirstChild("HasBuso")) then
				commF:InvokeServer("Buso");
			end
		end
		if (autoTrainining.observation) then

		end
		wait();
	end
end);

local misc = main:Section("Misc");
misc:SetRight();

local doSaberQuest = false
local function startSaberQuest()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
	local root = char:WaitForChild("HumanoidRootPart");
	local locations = Workspace._WorldOrigin.Locations
	local map = workspace.Map
	local jungle = locations.Jungle
	local jungleIsland = map.Jungle

	local progress = commF:InvokeServer("ProQuestProgress");
	local platesDone = true
	for i, plateDone in pairs(progress.Plates) do
		if (not plateDone) then
			platesDone = false
		end
	end
	local torchUsed = progress.UsedTorch

	local cupUsed = progress.UsedCup

	local questPlates = Workspace.Map.Jungle:WaitForChild("QuestPlates");
	if (not platesDone) then
		tweento(jungle.CFrame * CFrame.new(0, 150, 0));
		for i, plate in pairs(questPlates:GetChildren()) do
			local plateButton = plate:FindFirstChild("Button");
			if (plateButton) then
				tweento(plateButton.CFrame);
				firetouchinterest(plateButton, root, 0);
				wait();
				firetouchinterest(plateButton, root, 1);
			end
		end		
		wait();
		return startSaberQuest();
	end
	
	if (not torchUsed) then
		local door = questPlates.Door
		tweento(door.CFrame);
			
		local torch = jungleIsland.Torch
		repeat
			firetouchinterest(torch, root, 0);
			wait();
			firetouchinterest(torch, root, 1);
			wait(.1);
		until LocalPlayer.Backpack:FindFirstChild("Torch") or char:FindFirstChild("Torch");
		tweento(desert.CFrame * CFrame.new(0, 150, 0));
		tweento(CFrame.new(1115, 4, 4349));
		local torch = LocalPlayer.Backpack:FindFirstChild("Torch") or char:FindFirstChild("Torch");
		torch.Parent = char
		local burn = desertIsland:FindFirstChild("Burn");
		local fire = burn:FindFirstChild("Fire");

		fire:GetPropertyChangedSignal("CanCollide"):Wait();
		return startSaberQuest();
	end

	if (not cupUsed) then
		if (not LocalPlayer.Backpack:FindFirstChild("Cup") and not char:FindFirstChild("Cup")) then
			tweento(CFrame.new(1110, 4, 4362));
			local cup = desertIsland:FindFirstChild("Cup")
			repeat
				firetouchinterest(cup, root, 0);
				wait();
				firetouchinterest(cup, root, 1);
				wait(.1);
			until LocalPlayer.Backpack:FindFirstChild("Cup") or char:FindFirstChild("Cup");
		end
		tweento(CFrame.new(1395, 37, -1321));
		local cup = LocalPlayer.Backpack:FindFirstChild("Cup") or char:FindFirstChild("Cup");
		cup.Parent = char
		wait(1);
		commF:InvokeServer("ProQuestProgress", "FillCup", cup);
		wait(1);
		tweento(CFrame.new(1455, 88, -1388));
		commF:InvokeServer("ProQuestProgress", "SickMan");
		return startSaberQuest();
	end

	print"true";
end

misc:Toggle("Do Saber Quest", false, function(callback)
	doSaberQuest = callback
	startSaberQuest();
end);

local mainGui = LocalPlayer.PlayerGui.Main

misc:Button("Open Inventory", function()
	mainGui.Inventory.Visible = true
end);
misc:Button("Open Fruit Inventory", function()
	mainGui.FruitInventory.Visible = true
end);
misc:Button("Set Nearest Spawn", function()
	for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
end);

local codes = {
    exp2x = {
        "Enyu_is_Pro",
        "Magicbus",
        "Sub2Fer999",
        "Starcodeheo",
        "JCWK",
        "KittGaming",
        "Bluxxy",
        "Sub2OfficialNoobie",
        "TheGreatAce",
        "Axiore",
        "Sub2Daigrock",
        "TantaiGaming",
        "StrawHatMaine",
        "SUB2GAMERROBOT_EXP1"
    },
    statReset = {
        "Sub2UncleKizaru",
        "SUB2GAMERROBOT_RESET1",
    }
}

local currentCode = ""
local codes_ = {};
for codeType, codes2 in pairs(codes) do
	for i, code in pairs(codes2) do
		codes_[#codes_ + 1] = string.format("%s (%s)", codeType, code);
	end
end
local dropdown = misc:Dropdown("Code to redeem", currentCode, codes_, function(callback)
	local code = string.match(callback, "%b()")
	currentCode = string.sub(code, 2, #code - 1);
	print(currentCode);
end);

misc:Button("Redeem Code", function()
	print(remotes.Redeem:InvokeServer(currentCode));
end);


local teleports = mainWindow:Tab("Teleports");

local islands = teleports:Section("Island Teleports");

local setspawnTP = false
islands:Toggle("Set Spawn TP", false, function(callback)
	setspawnTP = callback
end);

local mapLocations = Workspace._WorldOrigin.Locations:GetChildren();
local islands_ = {};

for i, location in pairs(mapLocations) do
	if (location:IsA("Part")) then
		local locationName = location.Name
		if (islands_[locationName]) then
			local n = 1
			local newName
			repeat
				newName = string.format("%s (%s)", locationName, n);
				n += 1
			until not islands_[newName]
			locationName = newName
		end

		local pos = location.CFrame
		islands_[locationName] = pos * CFrame.new(0, 150, 0);
		islands:Button(locationName, function()
			if (setspawnTP) then
				local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
				local root = char:WaitForChild("HumanoidRootPart");
				root.CFrame = pos
				char:BreakJoints();
				for i = 1, 10 do commF:InvokeServer("SetSpawnPoint"); wait() end
			else
				tweento(pos);
			end
		end);
	end
end

local servers = teleports:Section("Servers");

servers:Button("Server Hop Largest", function()
	serverhop("Desc")
end);
servers:Button("Server Hop Smallest", function()
	serverhop("Asc");
end);
servers:Button("Rejoin Server", function()
	Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId);
end);

local lp = mainWindow:Tab("LocalPlayer");

local Shop = mainWindow:Tab("Shop");

local Fruits = Shop:Section("Fruits");
Fruits:Button("Open Fruit Shop", function()
	mainGui.FruitShop.Visible = true
end);
Fruits:Button("Buy Cousin Fruit", function()
	print(commF:InvokeServer("Cousin", "Buy"));
end);

local abilitiesInfo = {
	{ "10,000", "BuyHaki", "Geppo" },
	{ "25,000", "BuyHaki", "Buso" },
	{ "100,000", "BuyHaki", "Soru" },
	{ "750,000", "KenTalk", "Buy" },
}

local Abilities = Shop:Section("Abilities");

for i, abilityInfo in ipairs(abilitiesInfo) do
	Abilities:Button(string.format("Buy %s ($%s)", abilityInfo[3] == "Buy" and "Observation Haki" or abilityInfo[3], abilityInfo[1]), function()
		commF:InvokeServer(unpack(abilityInfo, 2));
	end);
end

local stylesInfo = {
	{ "150,000", "Black Leg" },
	{ "500,000", "Electro" },
	{ "750,000", "Fishman Karate" },
	{ "2,500,000", "Sharkman  Karate" },
	{ "2,500,000", "Death Step" },
	{ "3,000,000", "Electric Claw" },
	{ "3,000,000", "Dragon Talon" },
	{ "3,000,000", "Super Human" },
	{ "(f)1,500", "Dragon Breath" }
}
local Styles = Shop:Section("Fighting Styles");

for i, styleInfo in ipairs(stylesInfo) do
	Styles:Button(string.format("Buy %s (%s)", styleInfo[2], styleInfo[1]), function()
		commF:InvokeServer("Buy" .. styleInfo[2]:gsub(" ", ""));
	end);
end

local swordsInfo = {
	{ "1,000", "Katana" },
	{ "1,000","Cutlass" },
	{ "12,000", "Dual Katana" },
	{ "25,000", "Iron Mace" },
	{ "60,000", "Triple Katana" },
	{ "100,000", "Pipe" },
	{ "400,000", "Dual-Headed Blade" },
	{ "750,000", "Soul Cane" },
	{ "1,200,000", "Bisento" },
};

local Swords = Shop:Section("Swords");

for i, swordInfo in ipairs(swordsInfo) do
	Swords:Button(string.format("Buy %s (%s)", swordInfo[2], swordInfo[1]), function()
		commF:InvokeServer("BuyItem", swordInfo[2]);
	end);
end
Swords:Button("Buy Pole V2 ((f)5,000)", function()
	commF:InvokeServer("ThunderGodTalk");
end);

local gunsInfo = {
	{ "5,000", "Slingshot" },
	{ "8,000", "Musket" },
	{ "30,000", "Refined Slingshot" },
	{ "65,000", "Refined Flintlock" },
	{ "100,500", "Flintlock" },
}
local Guns = Shop:Section("Guns");

for i, gunInfo in pairs(gunsInfo) do
	Guns:Button(string.format("Buy %s (%s)", gunInfo[2], gunInfo[1]), function()
		commF:InvokeServer("BuyItem", gunInfo[2]);
	end);
end
Guns:Button("Buy Kabucha ((f)1,500", function()
	commF:InvokeServer("BlackbeardReward", "Slingshot", "2");
end);

local accessoriesInfo = {
	{ "50,000", "Black Cape" },
	{ "150,000", "Swordsman Hat" },
	{ "500,000", "Tomoe Ring" }
};
local Accessories = Shop:Section("Accessories");

for i, accessoryInfo in pairs(accessoriesInfo) do
	Accessories:Button(string.format("Buy %s (%s)", accessoryInfo[2], accessoryInfo[1]), function()
		commF:InvokeServer("BuyItem", accessoryInfo[2]);
	end);
end


-- local Trainers = Shop:Section("Trainer Dialogues");

-- local dialogueController = require(Services.ReplicatedStorage:WaitForChild("DialogueController"));
-- local dialogues = require(Services.ReplicatedStorage:WaitForChild("DialoguesList"));

-- local trainers = {
-- 	"FishmanKarate Teacher",
-- 	"Haki Teacher",
-- 	"BlackLeg Teacher",
-- 	"Ken Teacher"
-- }

-- for i, dialogueName in pairs(trainers) do
-- 	Trainers:Button(dialogueName, function()
-- 		dialogueController:Start(dialogues[dialogueName:gsub(" ", "")]);
-- 	end);
-- end

-- local other = Shop:Section("Other");
-- other:Button("Black Cousin", function()
-- 	dialogueController:Start(dialogues.RandomFruitSeller);
-- end);

while true do
    if (settings.auto_farm) then
        print("running new quest!!");
        doQuest();
    end
    wait();
end