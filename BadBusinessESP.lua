local Visuals = loadfile("Visuals.lua")();

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Teams = game:GetService("Teams");
local Players = game:GetService("Players");

local LocalPlayer = Players.LocalPlayer

local TS = filtergc("table", {
    Keys = { "Characters", "Teams", "Network" }
})[1];
local characters = TS.Characters
local teams = TS.Teams


local drawEntries = {};
local addDrawings = function(player, character, color)
    if (player == LocalPlayer) then
        return;
    end

    local body = character:WaitForChild("Body");
    local root = body:WaitForChild("Chest");

    local Visual = Visuals.new(root);
    drawEntries[player] = root

    local Text = Visual:AddText(player.Name, {
        Color = color
    }, CFrame.new(0, 4, 0));
    local Tracer = Visual:AddTracer(nil, {
        Color = color
    }, CFrame.new(0, 2, 0));
    local characterSize = body:GetExtentsSize();
    local Box = Visual:Add2DBox(root, CFrame.new(characterSize.X / 2, characterSize.Y / 2, 0), CFrame.new(-characterSize.X / 2, -characterSize.Y / 2, 0), {
        Color = color
    });
    local healthBar = Visual:AddHealthBar(body, root, Color3.new(1, 1, 1), Color3.new(0, 1, 0));

    local health = character:WaitForChild("Health");
    local maxHealth = health:WaitForChild("MaxHealth");
    health:GetPropertyChangedSignal("Value"):Connect(function()
        healthBar:UpdateHealth(health.Value, maxHealth.Value);
    end);

    healthBar:UpdateHealth(health.Value, maxHealth.Value);
end

local infocache = {};
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

for index, player in pairs(Players:GetPlayers()) do
    local char = trampoline_call(characters.GetCharacter, characters, player);
    local teamName = trampoline_call(teams.GetPlayerTeam, Teams, player);
    local team = Teams:FindFirstChild(teamName);
    if (char) then
        task.spawn(addDrawings, player, char, team.Color.Value);
        print(player.Name .. " added.");
        if (player == LocalPlayer) then
            localCharacter = char
        end
    end
end


local remoteCharKilled = ReplicatedStorage:FindFirstChild("RemoteCharacterKilled", true);
remoteCharKilled.OnClientEvent:Connect(function(char)
    local player = trampoline_call(characters.GetPlayerFromCharacter, characters, char);

    local drawEntry = drawEntries[player]
    if (drawEntry) then
        drawEntry:Destroy();
        roots[player] = nil
        print(player.Name .. " destroyed.");
    end
    if (player == LocalPlayer) then
        localCharacter = nil
    end
end);

local Characters = workspace:FindFirstChild("Characters");

Characters.ChildAdded:Connect(function(char)
    local characterRoot = char:WaitForChild("Root");
    local player = trampoline_call(characters.GetPlayerFromCharacter, characters, char);
    local teamName = trampoline_call(teams.GetPlayerTeam, teams, player);
    local team = Teams:FindFirstChild(teamName);
    if (char) then
        task.spawn(addDrawings, player, char, team.Color.Value);
        print(player.Name .. " added.");
        if (player == LocalPlayer) then
            localCharacter = char
        end
    end
end);

remoteCharKilled = nil
Characters = nil

task.wait(15);

for i, v in pairs(Visuals:GetAllDrawings()) do
    v.Visible = false
end
table.clear(drawEntries);