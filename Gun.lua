-- Decompiled with the Synapse X Luau decompiler.
 --NOTE: Currently in beta! Not representative of final product.
 local v1 = game:GetService("ReplicatedStorage");
 local v2 = game:GetService("Players");
 local v3 = game:GetService("Workspace");
 local t_LocalPlayer_1 = v2.LocalPlayer;
 local v4 = t_LocalPlayer_1.Character;
 local t_Parent_2 = script.Parent.Parent.Parent.Parent;
 local v5 = v3.IgnoreThese;
 local v6 = v1.Network;
 local v7 = v6.ClientToClient;
 local v8 = v6.ClientToClientRF;
 local v9 = v1:WaitForChild("Modules");
 local v10 = require(v9.GlobalStuff);
 local u1 = require(v9.NetworkModule2);
 local u2 = require(script.Parent);
 local u3 = require(script.Parent.Parent.Parent.Shared);
 local u4 = require(script.Parent.Parent.Parent.Controller);
 local u5 = require(t_LocalPlayer_1.PlayerGui.GameUI.GameUIMod);
 local u6 = {};
 u6.__index = u6;
 setmetatable(u6, u2);
 local f_new;
 f_new = function(p1, p2, p3, p4) -- [line 40] new
     --[[
         Upvalues: 
             [1] = u2
             [2] = u6
     --]]
     local v11 = u2.new(p1, p2, p3, p4);
     setmetatable(v11, u6);
     v11.Debounce = 0;
     v11.WModel = nil;
     return v11;
 end;
 u6.new = f_new;
 local f_ConeOfFire;
 f_ConeOfFire = function(p5, p6, p7, p8) -- [line 50] ConeOfFire
     --[[
     --]]
     local v12 = math.random(0, (math.tan(math.rad(p8)) * (p7 - p6).magnitude) * 100) / 100;
     local v13 = math.rad(math.random(0, 360));
     return (CFrame.new(p7, p6) * CFrame.new(math.cos(v13) * v12, math.sin(v13) * v12, 0)).p;
 end;
 u6.ConeOfFire = f_ConeOfFire;
 local f_GenerateEndPositions;
 f_GenerateEndPositions = function(p9, p10, p11, p12, p13) -- [line 62] GenerateEndPositions
     --[[
     --]]
     local v14 = {};
     local v15 = 1;
     local v16 = p12;
     local v17 = v16;
     local v18 = v15;
     if (not (v16 <= v18)) then
         while true do
             table.insert(v14, (p9:ConeOfFire(p10, p11, p13)));
             local v19 = v15 + 1;
             v15 = v19;
             local v20 = v17;
             if (v20 < v19) then
                 break;
             end
         end
     end
     return v14;
 end;
 u6.GenerateEndPositions = f_GenerateEndPositions;
 local f_CanFire;
 f_CanFire = function(p14) -- [line 73] CanFire
     --[[
         Upvalues: 
             [1] = u3
             [2] = u1
     --]]
     if (not p14:CanActivate()) then
         return;
     end
     local t_Ammo_3 = p14.Ammo;
     if (t_Ammo_3 < 0) then
         if (not u3.Reloading) then
             p14:Reload();
         end
         return;
     end
     local v21 = tick() - p14.Debounce;
     if (v21 <= p14.WSettings.Debounce) then
         return;
     end
     if (p14.WSettings.WaitForPose) then
         local t_Index_4 = p14.Index;
         wait(0.1);
         if (t_Index_4 ~= p14.Index) then
             u3.Firing = false;
             return;
         end
     end
     if (u3.PObj.Scoping) then
         u3.PObj.FirePose = true;
         u1:FireServer("ToggleFirePose", true);
     else
         u3:Animate("FirePose");
     end
     return true;
 end;
 u6.CanFire = f_CanFire;
 local f_Activate;
 f_Activate = function(p15) -- [line 115] Activate
     --[[
         Upvalues: 
             [1] = u3
             [2] = u5
             [3] = t_LocalPlayer_1
             [4] = u4
     --]]
     if (u3.Emoting) then
         u5:HideWeapon(t_LocalPlayer_1, false);
     end
     if (p15:CanFire()) then
         u3:ToggleCamLock(false);
         u3.Firing = true;
         p15:ShootLogic();
         u3.Firing = false;
         local t_Ammo_5 = p15.Ammo;
         if (t_Ammo_5 == 0) then
             p15:Reload();
         end
     end
     u4:WaitForIdle();
 end;
 u6.Activate = f_Activate;
 local f_ShootLogic;
 f_ShootLogic = function(p16) -- [line 137] ShootLogic
     --[[
     --]]
     p16:Shoot();
 end;
 u6.ShootLogic = f_ShootLogic;
 local f_Scope;
 f_Scope = function(p17, p18) -- [line 141] Scope
     --[[
         Upvalues: 
             [1] = u3
             [2] = t_Parent_2
             [3] = u5
     --]]
     local t_WSettings_6 = u3.WSettings;
     if (p18 and (not u3.Scoping)) then
         return;
     end
     if (u3.Midair) then
         return;
     end
     if (u3.PObj.SkyDiving) then
         return;
     end
     if (u3.Disabled) then
         return;
     end
     if (u3.Reloading) then
         return;
     end
     if ((u3.Editing or u3.Building) and (not p18)) then
         return;
     end
     if (u3.Emoting) then
         return;
     end
     if ((not p18) and u3.Swapping) then
         return;
     end
     u3.Scoping = not p18;
     if (u3.Scoping) then
         u3:ToggleTightRot(true);
         u3:CrossHairSize();
         u3:Animate("ScopePose");
         wait(0.1);
         if (u3.Scoping and t_WSettings_6.SniperScope) then
             t_Parent_2.CrossHairs.Visible = false;
             u5:ToggleSniperFrame(true);
             return;
         end
     else
         u3:ToggleTightRot(false);
         if (t_WSettings_6.SniperScope) then
             t_Parent_2.CrossHairs.Visible = true;
             u5:ToggleSniperFrame(false);
         end
         u3:CrossHairSize();
         if (u3.PObj.FirePose) then
             u3:Animate("FirePose");
         else
             u3:Animate("IdlePose");
         end
         wait(0.1);
     end
 end;
 u6.Scope = f_Scope;
 return u6;
 