local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))();
local UI = Lib.Load({
    Title = "Fates Hub",
    Style = 1,
    SizeX = 400,
    SizeY = 400,
    Theme = "Dark"
});

local AutoPlay = UI.New({
    Title = "AutoPlay"
});

local Options = {
    Perfect = .05,
    Okay = 2,
    Great = 1
}

local Option = Options.Perfect

AutoPlay.Dropdown({
    Text = "Option",
    Callback = function(Value)
        Option = Options[Value]
    end,
    Options = {
        "Perfect",
        "Great",
        "Okay",
    }
});

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer
local Children = game:GetService("Workspace"):GetChildren();

local Parent;
local Character;
for Index = 1, #Children do
    local Child = Children[Index]
    local ChildChildren = Child:GetChildren();
    for Index2, Child2 in pairs(ChildChildren) do
        local Humanoid = Child2:FindFirstChild("Humanoid");
        if (Humanoid and Humanoid.DisplayName == LocalPlayer.DisplayName) then
            Parent = Child
            Character = Child2
            break;
        end
    end
end

local Pearls = {}
local Children = Parent:GetChildren();
local A, S, D, F;
for Index = 1, #Children do
    local Child = Children[Index]
    local ChildChildren = Child:GetChildren();
    if (#ChildChildren == 9) then
        for Index2 = 1, #ChildChildren do
            local ChildofChild: Part = ChildChildren[Index2]
            if (tostring(ChildofChild.BrickColor) == "Fire Yellow") then
                if ((ChildofChild.Position - Character.HumanoidRootPart.Position).Magnitude <= 20) then
                    if (not A) then
                        A = ChildofChild.CFrame
                    elseif (not S) then
                        S = ChildofChild.CFrame
                    elseif (not D) then
                        D = ChildofChild.CFrame
                    elseif (not F) then
                        F = ChildofChild.CFrame
                    else
                        break;
                    end
                end
            end
        end
    end
end
-- local VIM = game:GetService("VirtualInputManager");
local keypress = function(Key)
    -- VIM:SendKeyEvent(true, Key, false, nil);
    keypress(Key);
end
local keyrelease = function(Key)
    -- VIM:SendKeyEvent(false, Key, false, nil);
    keyrelease(Key);
end


local lasta = tick();
local lasts = tick();
local lastd = tick();
local lastf = tick();

local AX = math.floor(A.X);
local AZ = math.floor(A.Z);
local SX = math.floor(S.X);
local SZ = math.floor(S.Z);
local DX = math.floor(D.X);
local DZ = math.floor(D.Z);
local FX = math.floor(F.X);
local FZ = math.floor(F.Z);
local helda, helds, heldd, heldf;

_G.LOL = game.ItemChanged:Connect(function(Item, Prop)
    local ClassName = Item.ClassName
    if (ClassName:find("Adornment") and Prop == "CFrame") then
        local IsSphere = ClassName == "SphereHandleAdornment"
        local x, z = math.floor(Item.CFrame.X), math.floor(Item.CFrame.Z);
        local now = tick();

        if (math.abs(AX - x) <= Option and math.abs(AZ - z) <= Option and now - lasta > .1) then --0x41
            if (helda and Item.Transparency == 0.5) then
                keyrelease(0x41);
                helda = false
            elseif (Item.Transparency == 0) then
                keypress(0x41);
                if (IsSphere) then
                    helda = true
                else
                    keyrelease(0x41);
                    helda = false
                end
                lasta = tick();
            end
        end
        if (math.abs(DX - x) <= Option and math.abs(DZ - z) <= Option and now - lastd > .1) then --0x44
            if (heldd and Item.Transparency == 0.5) then
                keyrelease(0x44);
                heldd = false
            elseif (Item.Transparency == 0) then
                keypress(0x44);
                if (IsSphere) then
                    heldd = true
                else
                    keyrelease(0x44);
                end
                lastd = tick();
            end
        end
        if (math.abs(SX - x) <= Option and math.abs(SZ - z) <= Option and now - lasts > .1) then --0x53
            if (helds and Item.Transparency == 0.5) then
                keyrelease(0x53);
                helds = false
            elseif (Item.Transparency == 0) then
                keypress(0x53);
                if (IsSphere) then
                    helds = true
                else
                    keyrelease(0x53);
                end
                lasts = tick();
            end
        end
        if (math.abs(FX - x) <= Option and math.abs(FZ - z) <= Option and now - lastf > .1) then --0x46
            if (heldf and Item.Transparency == 0.5) then
                keyrelease(0x46);
                heldf = false
            elseif (Item.Transparency == 0) then
                keypress(0x46);
                if (IsSphere) then
                    heldf = true
                else
                    keyrelease(0x46);
                end
                lastf = tick();
            end
        end
    end
end);
