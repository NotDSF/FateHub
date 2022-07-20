if (not game:IsLoaded()) then
    game.Loaded:Wait();
end

for i, v in pairs(_G.Connections or {}) do
    v:Disconnect();
end
_G.Connections = {};

local timings = {
    perfect = .55,
    okay = 4,
    great = 2
};

local timing = timings.perfect
local hitChance = 100

local UI = loadfile("UILib.lua")();
local mainWindow = UI:CreateWindow("Fate Hub", "Robeats", Color3.fromRGB(0, 255, 150));

local autoPlay = mainWindow:Tab("AutoPlay");
local autoPlayAccuracy = autoPlay:Section("Accuracy");

autoPlayAccuracy:Dropdown("Autoplay", "Perect", {"Perfect", "Great", "Okay"}, function(callback)
    timing = timings[string.lower(callback)]
end);

autoPlayAccuracy:Slider("Hit Chance", 0, 100, 100, function(callback)
    hitChance = callback
end);

local infocache = {};
local trampoline_call = function(func, ...)
    local funcinfo = infocache[func] or debug.getinfo(func);
    if (not infocache[func]) then
        infocache[func] = funcinfo
    end
    local funcenv = getfenv(func);
    local result = {syn.trampoline_call(func, funcenv, {
        env = funcenv,
        source = funcinfo.source,
        name = funcinfo.name,
        currentline = funcinfo.currentline,
        numparams = funcinfo.numparams,
        is_varag = funcinfo.is_vararg
    }, 2, ...)}
    if (result[1]) then
        return unpack(result, 2);
    end
end

local networkKeys = {
    "_ui_manager", "_players", "_characters",
    "_world_effect_manager", "_effects", "_input",
    "_sfx_manager", "_object_pool", "_adorn_pool"
};

local network = filtergc("table", {
    Keys = networkKeys
})[1];

local input, input_began, input_ended;
do
    local inputBeganConnections = getconnections(game:GetService("UserInputService").InputBegan);
    for i, v in pairs(inputBeganConnections) do
        if (v.Function) then
            local source = getinfo(v.Function).source
            if (source == "=ReplicatedStorage.Shared.InputUtil") then
                input = debug.getupvalue(v.Function, 4);
                input_began, input_ended = rawget(input, "input_began"), rawget(input, "input_ended");
            end
        end
    end
end

local notes = {
    a = { isHolding = false; lastPressed = tick() };
    s = { isHolding = false; lastPressed = tick() };
    d = { isHolding = false; lastPressed = tick() };
    f = { isHolding = false; lastPressed = tick() };
}

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer

local getCharacter = function()
    local character, parent
    local workspaceChildren = game:GetService("Workspace"):GetChildren();
    for i = 1, #workspaceChildren do
        local child = workspaceChildren[i]
        local childChildren = child:GetChildren();
        for i2, child2 in pairs(childChildren) do
            local humanoid = child2:FindFirstChild("Humanoid");
            if (humanoid and humanoid.DisplayName == LocalPlayer.DisplayName) then
                parent = child
                character = child2
                break;
            end
        end
    end
    return character, parent
end

local getNotes = function()
    for i, v in pairs(notes) do
        notes[i].position = nil
    end

    local character, parent = getCharacter();

    for i, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Part") and v.Name == "Outer") then
            local mag = (v.Position - character.HumanoidRootPart.Position).Magnitude
            if (mag <= 20) then
                if (not notes.a.position) then
                    notes.a.position = v.Position
                elseif (not notes.s.position) then
                    notes.s.position = v.Position
                elseif (not notes.d.position) then
                    notes.d.position = v.Position
                elseif (not notes.f.position) then
                    notes.f.position = v.Position
                else
                    break;
                end
            end
        end
    end
end

if (not LocalPlayer.Character) then
    local character, parent = getCharacter();
    if (not character) then
        LocalPlayer.CharacterAdded:Wait();
    end

    if (character and parent) then
        getNotes();
    end
end

local c1 = LocalPlayer.CharacterRemoving:Connect(function()
    local character, parent = getCharacter();
    repeat
        task.wait(.5);
        character, parent = getCharacter();
    until character and parent
    local sound = parent:FindFirstChildOfClass("Sound");
    sound:GetPropertyChangedSignal("Volume");
    getNotes();
end);

local keypress = function(key)
    trampoline_call(input_began, input, key);
end
local keyrelease = function(key)
    trampoline_call(input_ended, input, key);
end

local changed;
changed = game.ItemChanged:Connect(function(instance, prop)
    local className = instance.ClassName
    if (string.find(className, "Adornment") and prop == "CFrame") then
        local isSphere = className == "SphereHandleAdornment"
        local transparency = instance.Transparency
        local position = instance.CFrame.Position
        local now = tick();
        local a, d, s, f = notes.a, notes.d, notes.s, notes.f

        if ((a.position - position).Magnitude <= timing and now - a.lastPressed > .05) then --0x41
            if (a.isHolding and transparency == 0.5) then
                keyrelease(Enum.KeyCode.A);
                a.isHolding = false
            elseif (transparency == 0) then
                keypress(Enum.KeyCode.A);
                if (isSphere) then
                    a.isHolding = true
                else
                    keyrelease(Enum.KeyCode.A);
                end
                a.lastPressed = now
            end
        end
        if ((d.position - position).Magnitude <= timing and now - d.lastPressed > .05) then --0x44
            if (d.isHolding and transparency == 0.5) then
                keyrelease(Enum.KeyCode.D);
                d.isHolding = false
            elseif (transparency == 0) then
                keypress(Enum.KeyCode.D);
                if (isSphere) then
                    d.isHolding = true
                else
                    keyrelease(Enum.KeyCode.D);
                end
                d.lastPressed = now
            end
        end
        if ((s.position - position).Magnitude <= timing and now - s.lastPressed > .05) then --0x53
            if (s.isHolding and transparency == 0.5) then
                keyrelease(Enum.KeyCode.S);
                s.isHolding = false
            elseif (transparency == 0) then
                keypress(Enum.KeyCode.S);
                if (isSphere) then
                    s.isHolding = true
                else
                    keyrelease(Enum.KeyCode.S);
                end
                s.lastPressed = now
            end
        end
        if ((f.position - position).Magnitude <= timing and now - f.lastPressed > .05) then --0x46
            if (f.isHolding and transparency == 0.5) then
                keyrelease(Enum.KeyCode.F);
                f.isHolding = false
            elseif (transparency == 0) then
                keypress(Enum.KeyCode.F);
                if (isSphere) then
                    f.isHolding = true
                else
                    keyrelease(Enum.KeyCode.F);
                end
                f.lastPressed = now
            end
        end
    end
end);

table.insert(_G.Connections, c1);
table.insert(_G.Connections, changed);