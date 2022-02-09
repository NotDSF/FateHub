-- not done

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer

local Settings = {
    NoRecoil = false,
    InstantAimTime = false,
    FireMode = {
        Auto = false,
        Semi = false,
        Burst = false
    },
    FieldOfView = nil,
    FireRate = nil --[[ 1 - 10 ]]
}

local filtergc = filtergc or function(Type, Args)
    local Results = {}
    for Index, Value in pairs(getgc(true)) do
        if (type(Value) == Type) then
            local Keys = Args.Keys
            local Good = true
            for Index2, Value2 in pairs(Keys) do
                print(Value,Value2)
                if (not rawget(Value, Value2)) then
                    Good = false
                    break
                end
            end
            if (Good) then
                table.insert(Results, Value);
            end
        end
    end
    return Results
end

local Network = filtergc("table", {
    Keys = { "Characters", "Teams" }
})[1];
local Camera = filtergc("table", {
    Keys = { "Recoil", "SpectatePlayer", "Stride", "FieldOfView" }
})[1];
local WeaponConfigDefault = filtergc("table", {
    Keys = { "Controller", "Animators", "Model", "Slot", "Category" }
});

local UpdateWeaponSettings = function()
    for Index, Value in pairs(WeaponConfigDefault) do
        local Recoil = Value.Recoil
        if (Settings.NoRecoil and Recoil and type(Recoil) == 'table') then
            local RecoilSettings = Recoil.Default
            if (RecoilSettings) then
                RecoilSettings.RecoilMovement =  Vector2.new(1, 1);
                RecoilSettings.CameraRotationVariance = Vector3.new(1, 1);
                RecoilSettings.RecoilMovementVariance = Vector2.new(1, 1);
                RecoilSettings.RecoilRecenterTime = 0
                RecoilSettings.RecoilMovementTime = 0
                RecoilSettings.RecoilCrouchScale = 0
                RecoilSettings.RecoileProneScale = 0
            end
        end
        local Aim = Value.Aim
        if (Settings.InstantAimTime and Aim and type(Aim) == 'number') then
            if (type(Aim.AimTime) == 'number') then
                Aim.AimTime = 0
            end
        end
        local FireModes = Value.FireModes
        if (Settings.FireRate and type(FireModes) == 'table') then
            local Auto = FireModes.Auto
            if (type(Auto) == 'table' and type(Auto.FireRate) == 'number') then
                Auto.FireRate = Settings.FireRate * 100
            end
        end
    end
end

local SetFOV = function(FOV)
    Network.Camera.FieldOfView = math.clamp(FOV or 90 --[[Default is 90]], 45, 270);
end