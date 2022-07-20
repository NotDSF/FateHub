-- Decompiled with the Synapse X Luau decompiler.
 --NOTE: Currently in beta! Not representative of final product.
 local v1 = game:GetService("Players");
 local u1 = game:GetService("Workspace");
 local v2 = game:GetService("ReplicatedStorage");
 local v3 = game:GetService("UserInputService");
 local v4 = game:GetService("Lighting");
 local v5 = game:GetService("TweenService");
 local v6 = game:GetService("SoundService");
 local v7 = game:GetService("RunService");
 local v8 = v7.RenderStepped;
 local v9 = v7.Heartbeat;
 local v10 = v1.LocalPlayer;
 local v11 = v10.Character;
 local v12 = v11:WaitForChild("Head");
 local u2 = v11:WaitForChild("Humanoid");
 local u3 = v11:WaitForChild("HumanoidRootPart");
 local u4 = v10:GetMouse();
 local t_CurrentCamera_1 = u1.CurrentCamera;
 local v13 = v2.Modules;
 local u5 = require(v13.GlobalStuff);
 local v14 = require(v13.PlayerObj);
 local v15 = require(v13.NetworkModule2);
 local u6 = require(script.Shared);
 local v16 = require(script.CoreData);
 local u7 = require(script.Controller);
 local v17 = require(v10.PlayerGui.GameUI.GameUIMod);
 local v18 = v2.Network;
 local v19 = v18.ClientToClient;
 local v20 = v18.ClientToClientRF;
 local v21 = v18.LookDir;
 local t_Parent_2 = script.Parent;
 local t_WallHealth_3 = t_Parent_2.WallHealth;
 local t_ActionIndicator_4 = t_Parent_2.ActionIndicator;
 local t_StaticActionHint_5 = t_Parent_2.StaticActionHint;
 local u8 = {
     u1.BuildStuff,
     u1.TempBuilds,
     u1.Map,
     u1.Terrain
 };
 local v22 = {
     u1.BuildStuff,
     u1.Map
 };
 local u9 = 0.00023999999999999998 * v16.Settings.Sensitivity;
 local v23 = Vector3.new(0, 0, 0);
 local u10 = v16.Keybinds.Edit[1];
 local u11 = v16.Keybinds.Interact[1];
 local u12 = true;
 local u13 = 0;
 local u14 = 0;
 local u15 = nil;
 local u16 = nil;
 local u17 = u6;
 local u18 = v14;
 local t_LocalPlayer_6 = v10;
 local u19 = v2;
 local u20 = v17;
 local t_Character_7 = v11;
 local u21 = v4;
 local u22 = t_CurrentCamera_1;
 local u23 = u4;
 local u24 = u1;
 local u25 = u2;
 local f_SetUp;
 f_SetUp = function() -- [line 73] SetUp
     --[[
         Upvalues: 
             [1] = u17
             [2] = u18
             [3] = t_LocalPlayer_6
             [4] = u19
             [5] = u9
             [6] = u20
             [7] = t_Character_7
             [8] = u21
             [9] = u22
             [10] = u23
             [11] = u24
             [12] = u25
     --]]
     u17.PObj = u18:Get(t_LocalPlayer_6);
     if (u19.IsMobile.Value) then
         u17.IS_MOBILE = true;
         u9 = u9 * 5;
     end
     local v24, v25, v26 = pairs(script:GetDescendants());
     local v27 = v24;
     local v28 = v25;
     local v29 = v26;
     while true do
         local v30, v31 = v27(v28, v29);
         local v32 = v30;
         local v33 = v31;
         if (v30) then
             break;
         end
         v29 = v32;
         if (v33:IsA("ModuleScript")) then
             local t_Parent_8 = v33.Parent;
             if (t_Parent_8 ~= script.Inputs) then
                 require(v33);
             end
         end
     end
     u20:ToggleGameUI(true);
     u20:UpdateSubject(t_LocalPlayer_6, t_Character_7);
     u21.DepthOfField.Enabled = false;
     u22.CameraType = "Scriptable";
     u22.FieldOfView = 70;
     game.StarterGui:SetCoreGuiEnabled("PlayerList", false);
     u23.Icon = "rbxasset://textures/Blank.png";
     u23.TargetFilter = u24.IgnoreThese;
     t_LocalPlayer_6.PlayerGui.Chat.Frame.Position = UDim2.new(0, 0, 0, 0);
     u25:SetStateEnabled(Enum.HumanoidStateType.Swimming, false);
     local v34;
     if (u17.IS_MOBILE) then
         v34 = require(script.Inputs.Mobile);
     else
         v34 = require(script.Inputs.KBM);
     end
     v34:Initialize();
 end;
 SetUp = f_SetUp;
 local f_PostInitSetUp;
 f_PostInitSetUp = function() -- [line 120] PostInitSetUp
     --[[
         Upvalues: 
             [1] = u7
     --]]
     u7:Equip(3);
     if (_G.BR) then
         u7:SkyDive();
     end
 end;
 PostInitSetUp = f_PostInitSetUp;
 local f_UpdateWS;
 f_UpdateWS = function() -- [line 128] UpdateWS
     --[[
         Upvalues: 
             [1] = u6
             [2] = u2
             [3] = u3
             [4] = u1
             [5] = u8
             [6] = u5
     --]]
     if (u6.Midair) then
         return;
     end
     local v35 = 19;
     if (u6.IsKnocked) then
         v35 = 3;
     else
         if (u6.Crouching) then
             v35 = 10;
         else
             if (u6.PObj.Swinging) then
                 v35 = 10;
             else
                 if ((u6.PObj.Scoping or u6.Sideway) or u6.PObj.Throwing) then
                     v35 = 10;
                 else
                     if (u6.PObj.FirePose or u6.Reloading) then
                         v35 = 14;
                     end
                 end
             end
         end
     end
     if (u2.MoveDirection.magnitude >= 0) then
         local v36, v37, v38 = u1:FindPartOnRayWithWhitelist(Ray.new(u3.Position, Vector3.new(0, -5, 0)), u8);
         local v39 = v38;
         if (v36) then
             local v40 = false;
             local t_X_9 = v39.X;
             if (t_X_9 == 0) then
                 local t_Z_10 = v39.Z;
                 if (t_Z_10 ~= 0) then
                     v40 = true;
                 end
             else
                 v40 = true;
             end
             if (v40) then
                 local v41 = math.cos(v39.Y / v39.magnitude);
                 local v42 = u5:VectorAngle(u2.MoveDirection, Vector3.new(v39.X, 0, v39.Z));
                 local v43 = math.pi / 2;
                 if (v43 <= v42) then
                     v42 = math.pi - v42;
                 end
                 local v44 = v35 + (((v35 / math.cos(v41)) - v35) * math.cos(v42));
                 if (v44 <= 40) then
                     v35 = v44;
                 end
             end
         end
     end
     u2.WalkSpeed = v35;
 end;
 UpdateWS = f_UpdateWS;
 local f_UpdateWallHealthAndEdit;
 f_UpdateWallHealthAndEdit = function() -- [line 171] UpdateWallHealthAndEdit
     --[[
         Upvalues: 
             [1] = u4
             [2] = t_WallHealth_3
             [3] = t_ActionIndicator_4
             [4] = t_CurrentCamera_1
             [5] = t_Parent_2
             [6] = u5
             [7] = u10
     --]]
     local v45 = u4.Target;
     local t_Target_11 = v45;
     if (not v45) then
         t_WallHealth_3.Visible = false;
         t_ActionIndicator_4.Visible = false;
         return;
     end
     local v46 = t_Target_11:GetAttribute("HV");
     local v47 = v46;
     if (v46) then
         local t_magnitude_12 = (t_Target_11.Position - t_CurrentCamera_1.CFrame.p).magnitude;
         if (t_magnitude_12 <= 30) then
             local v48 = t_Target_11:GetAttribute("MaxHV") or 150;
             local v49 = t_CurrentCamera_1:WorldToScreenPoint(t_Target_11.Position + Vector3.new(0, 2, 0));
             t_WallHealth_3.Position = UDim2.new(0, v49.X, 0, math.max(t_Parent_2.AbsoluteSize.Y * 0.1, v49.Y));
             t_WallHealth_3.Frame.Size = UDim2.new(v47 / v48, 0, 1, 0);
             t_WallHealth_3.Visible = true;
             if (not u5:CanEdit(t_Target_11)) then
                 t_ActionIndicator_4.Visible = false;
                 return;
             end
             local v50 = t_CurrentCamera_1:WorldToScreenPoint(t_Target_11.Position);
             t_ActionIndicator_4.Text = u10;
             t_ActionIndicator_4.Action.Text = "EDIT";
             t_ActionIndicator_4.Position = UDim2.new(0, v50.X, 0, v50.Y);
             t_ActionIndicator_4.Visible = true;
             return;
         end
     end
     t_WallHealth_3.Visible = false;
     t_ActionIndicator_4.Visible = false;
 end;
 UpdateWallHealthAndEdit = f_UpdateWallHealthAndEdit;
 local f_InteractionHint;
 f_InteractionHint = function() -- [line 207] InteractionHint
     --[[
         Upvalues: 
             [1] = u6
             [2] = t_StaticActionHint_5
             [3] = u11
     --]]
     local v51, v52 = u6:CheckInteraction();
     local v53 = v51;
     local v54 = v52;
     if (v51) then
         t_StaticActionHint_5.Visible = true;
         if ((v53 == "Weapon") or (v53 == "Ammo")) then
             local v55 = t_StaticActionHint_5;
             local v56;
             if (u6.IS_MOBILE) then
                 v56 = "Tap";
             else
                 v56 = u11;
             end
             v55.Text = "[" .. (v56 .. ("] " .. v54.Parent.Name));
             return;
         end
     else
         t_StaticActionHint_5.Visible = false;
     end
 end;
 InteractionHint = f_InteractionHint;
 local u26 = u4;
 local u27 = v3;
 local u28 = t_CurrentCamera_1;
 local u29 = u6;
 local u30 = v4;
 local u31 = v17;
 local u32 = t_Parent_2;
 local f_DeadFunc;
 f_DeadFunc = function() -- [line 221] DeadFunc
     --[[
         Upvalues: 
             [1] = u26
             [2] = u27
             [3] = u28
             [4] = u29
             [5] = u30
             [6] = u16
             [7] = u31
             [8] = u32
     --]]
     u26.Icon = "";
     u27.MouseBehavior = Enum.MouseBehavior.Default;
     wait(1);
     u28.FieldOfView = 80;
     if (u29.PObj.WModel) then
         u29.PObj.WModel:Destroy();
     end
     u30.Sounds.Drinking:Stop();
     u16:Disconnect();
     u31:ToggleGameUI(false);
     u31:HotbarVisible(true);
     u32:Destroy();
 end;
 DeadFunc = f_DeadFunc;
 SetUp();
 u2.Jumping:Connect(function(p1) -- [line 247] anonymous function
     --[[
         Upvalues: 
             [1] = u7
             [2] = u6
     --]]
     if (p1) then
         u7:Scope(true);
         if (u6:IsNotBusy()) then
             u6.Midair = true;
             u6:Jumped();
             if (u6.Crouching) then
                 u7:Crouch();
             end
             if (u6.CurrTool:IsGun() and (u6.CurrTool.Ammo >= 0)) then
                 u6:Animate("FirePose");
             end
         end
     end
 end);
 local v57 = u2.StateChanged;
 local u33 = v15;
 local u34 = u6;
 local u35 = u7;
 v57:Connect(function(p2, p3) -- [line 266] anonymous function
     --[[
         Upvalues: 
             [1] = u15
             [2] = u33
             [3] = u34
             [4] = u35
             [5] = u14
     --]]
     if (p3 == Enum.HumanoidStateType.Freefall) then
         if (u15) then
             u33:FireServer("UpdateLastPlatformPos", u15);
         end
         if (u34.Crouching) then
             u35:Crouch();
             return;
         end
     else
         if ((p3 == Enum.HumanoidStateType.Landed) or (p3 == Enum.HumanoidStateType.Climbing)) then
             u34.Midair = false;
             u14 = tick();
             u35:WaitForIdle(0.2);
         end
     end
 end);
 u2:GetAttributeChangedSignal("Dancing"):Connect(function() -- [line 282] anonymous function
     --[[
         Upvalues: 
             [1] = u2
             [2] = u6
             [3] = u7
     --]]
     if (u2:GetAttribute("Dancing")) then
         u6.Disabled = true;
         return;
     end
     u6.Disabled = false;
     if (not u7:InBuildMode()) then
         u7:Equip();
     end
 end);
 u2.Died:Connect(function() -- [line 294] anonymous function
     --[[
         Upvalues: 
             [1] = u4
     --]]
     u4.Icon = "";
     wait(1);
     DeadFunc();
 end);
 local t_Character_13 = v11;
 local u36 = u2;
 local u37 = u3;
 local u38 = v23;
 local u39 = u6;
 local u40 = u7;
 local u41 = u1;
 local u42 = v22;
 local u43 = v3;
 local u44 = t_CurrentCamera_1;
 local u45 = u5;
 local t_LookDir_14 = v21;
 local v58 = v8:Connect(function(p4) -- [line 302] anonymous function
     --[[
         Upvalues: 
             [1] = t_Character_13
             [2] = u36
             [3] = u37
             [4] = u38
             [5] = u12
             [6] = u39
             [7] = u40
             [8] = u13
             [9] = u14
             [10] = u41
             [11] = u42
             [12] = u15
             [13] = u43
             [14] = u44
             [15] = u45
             [16] = u9
             [17] = t_LookDir_14
     --]]
     if (t_Character_13) then
         local t_Parent_15 = t_Character_13.Parent;
         if (t_Parent_15 ~= nil) then
             local t_Health_16 = u36.Health;
             if (t_Health_16 < 0) then
                 return;
             end
             local t_Y_17 = u37.Position.Y;
             if (t_Y_17 <= -400) then
                 u36.Health = 0;
             end
             local t_MoveDirection_18 = u36.MoveDirection;
             if (t_MoveDirection_18 == u38) then
                 if (u12) then
                     u12 = false;
                     if (u39:IsNotBusy() and u39.CurrTool:IsGun()) then
                         u39:Animate("FirePose");
                         coroutine.resume(coroutine.create(function() -- [line 323] anonymous function
                             --[[
                                 Upvalues: 
                                     [1] = u40
                             --]]
                             u40:WaitForIdle();
                         end));
                     end
                 end
             else
                 u12 = true;
             end
             local v59 = u37.Velocity;
             local t_Velocity_19 = v59;
             local t_magnitude_20 = v59.magnitude;
             if (((t_magnitude_20 <= 1) and u39.Scoping) and (u39.WSettings and u39.WSettings.FirstShotAccuracy)) then
                 if (u39.FirstShotAccuracyTime) then
                     local v60 = tick() - u39.FirstShotAccuracyTime;
                     local t_FirstShotAccuracy_21 = u39.WSettings.FirstShotAccuracy;
                     if (t_FirstShotAccuracy_21 <= v60) then
                         u39.FirstShotAccurate = true;
                         u39:CrossHairSize(0);
                     end
                 else
                     u39.FirstShotAccuracyTime = tick();
                 end
             else
                 if (u39.FirstShotAccurate) then
                     u39:CrossHairSize();
                 end
                 u39.FirstShotAccuracyTime = nil;
                 u39.FirstShotAccurate = false;
             end
             if (t_Velocity_19.magnitude >= 1) then
                 u39:ToggleCamLock(false);
                 if (u39.Emoting and (not u39.IsKnocked)) then
                     u39.Emoting = false;
                     u40:Equip();
                 end
             end
             local v61 = u13 % 4;
             if (((v61 == 0) and (not u39.Midair)) and ((tick() - u14) >= 0.2)) then
                 local v62, v63 = u41:FindPartOnRayWithWhitelist(Ray.new(u37.Position, Vector3.new(0, -10, 0)), u42);
                 local v64 = v62;
                 if (v62) then
                     u15 = v64.Position;
                 end
             end
             local v65 = t_Velocity_19;
             local v66 = (v65 - Vector3.new(0, v65.Y, 0)).magnitude;
             local t_magnitude_22 = v66;
             local t_CurrSpeed_23 = u39.CurrSpeed;
             u39.CurrSpeed = v66;
             if ((v66 >= 4) and (t_CurrSpeed_23 < 4)) then
                 if (not u39.Firing) then
                     u39:CrossHairSize();
                 end
             else
                 if (((t_magnitude_22 < 4) and (t_CurrSpeed_23 >= 4)) and (not u39.Firing)) then
                     u39:CrossHairSize();
                 end
             end
             local t_Y_24 = t_Velocity_19.Y;
             if (t_Y_24 <= -150) then
                 u37.Velocity = Vector3.new(t_Velocity_19.X, -150, t_Velocity_19.Z);
             end
             if (u39.IS_MOBILE) then
             end
             if (not u39.IS_MOBILE) then
                 u43.MouseBehavior = u39.MouseBehavior;
             end
             local v67 = u44;
             local v68 = u45;
             local t_FieldOfView_25 = u44.FieldOfView;
             local v69;
             if (u39.Scoping) then
                 v69 = u39.FOV;
                 if (not v69) then
                     v69 = 55;
                 end
             else
                 v69 = 80;
             end
             v67.FieldOfView = v68:NumLerp(t_FieldOfView_25, v69, 0.3);
             u39.CurrSens = u9 * (u44.FieldOfView / 70);
             UpdateWS();
             InteractionHint();
             UpdateWallHealthAndEdit();
             u39:UpdateCamera(p4);
             u40:CheckBuilding();
             u40:EditSelect();
             local v70 = math.clamp(u39:GetCamRot().Y, -math.rad(89), math.rad(89));
             local v71 = v70;
             u39.PObj.LookDir = v70;
             u39.PObj.YLookDir = u39.YLookDir;
             if (not (u13 >= 15)) then
                 u13 = u13 + 1;
                 return;
             end
             u13 = 0;
             t_LookDir_14:FireServer(v71);
             return;
         end
     end
     DeadFunc();
 end);
 PostInitSetUp();
 return (function(p5, p6, p7, p8, p9, p10, p11) -- [line 440] anonymous function
     --[[
     --]]
     local g_pairs_26 = pairs;
     local v72 = table.getn;
     if (not v72) then
         v72 = function(p12) -- [line 440] anonymous function
             --[[
             --]]
             return #p12;
         end;
     end
     local v73 = unpack;
     if (not v73) then
         v73 = table.unpack;
     end
     local v74 = getfenv;
     if (not v74) then
         v74 = function() -- [line 440] anonymous function
             --[[
             --]]
             return _ENV;
         end;
     end
     local t_char_27 = p5.char;
     local v75 = p7;
     local v76 = table.insert;
     local g_select_28 = select;
     local g_tonumber_29 = tonumber;
     local t_byte_30 = p5.byte;
     local t_sub_31 = p5.sub;
     local g_setmetatable_32 = setmetatable;
     local v77 = {};
     local v78 = p6;
     local v79 = v78;
     if (not (v79 >= 255)) then
         while true do
             v77[v78] = t_char_27(v78);
             local v80 = v78 + 1;
             v78 = v80;
             if (v80 > 255) then
                 break;
             end
         end
     end
     local v81 = false;
     local u46 = p9;
     local u47 = p10;
     local u48 = g_tonumber_29;
     local u49 = t_sub_31;
     local u50 = t_char_27;
     local u51 = v77;
     local u52 = v75;
     local f_h;
     f_h = function(p13) -- [line 440] h
         --[[
             Upvalues: 
                 [1] = u46
                 [2] = u47
                 [3] = u48
                 [4] = u49
                 [5] = u50
                 [6] = u51
                 [7] = u52
         --]]
         local v82 = {};
         local v83 = 256;
         local u53 = u47;
         local u54 = p13;
         local f_f;
         f_f = function() -- [line 440] f
             --[[
                 Upvalues: 
                     [1] = u48
                     [2] = u49
                     [3] = u54
                     [4] = u53
                     [5] = u47
             --]]
             local v84 = u48(u49(u54, u53, u53), 36);
             u53 = u53 + u47;
             local v85 = u48(u49(u54, u53, (u53 + v84) - u47), 36);
             u53 = u53 + v84;
             return v85;
         end;
         local v86 = u50(f_f());
         v82[u47] = v86;
         while (u53 <= (#p13)) do
             local v87 = f_f();
             local v88 = v87;
             local v89;
             if (u51[v87]) then
                 v89 = u51[v88];
             else
                 v89 = v86 .. u49(v86, u47, 1);
             end
             u51[v83] = v86 .. u49(v89, u47, 1);
             local v90 = (#v82) + u47;
             local v91 = v89;
             local v92 = v89;
             local v93 = v83 + u47;
             v82[v90] = v91;
             v86 = v92;
             v83 = v93;
         end
         return u52(v82);
     end;
     local v94 = f_h("21G1M21H27621D21E27621H222233151X21D21H25C21D21R27A22N22Z1827G21G25E25V25N26Z21D21Q27A22922X1I1D1Y1Z26825U25P26L26H21D21K27A22H23H1F1321121625C24A26Y26V26I24E23P21D21N27A22E27N1L21R21G26726V25J26Y26X28N26C21D27G27622422P1J1E21D21O27A22722P1E191Z21I25X26125P21D21L27A22023F1H1I2341L26425X26426X26X24C29427A22822V1822Q27J27A22J22P1I171V1W26Q25V26227U27927622D22P1O1N21O1Z25J21G27A27622P24Q23921D21F29P2331E1721Q21E21D21027A22222Z1C1E21L21125X25Q25P26Y26723Q23Z24K24L24T22L2AT2AU21H1H2AY2AK21H22022Q1T1R21H21G2AS2BS2392AX2A227623J2331H1721D21A27A22M22V1I161021325I25Q26F26O26624324923L24T25A2A423F2301V1K21D1M1X25P26021D21I27A23A22Z1B27827A22Y22Z1D1N21L21G25T21D21P28R2DB21A21R2BF25Y2BR2AU1X2BV29D22Z1T1I21R21425J2D727L23F1I2C821H2332331L1M27V27A22C22P1V1321O1M26026325T26Z27221D21C27A2972991Z2DD27622622Z1V1M28V23R2AZ27A22Z2311E1B1W21E2DU27A2192AY2DN27627M1821B21R21F25J2672E527627C152FR21H2A427O27W2FJ22Q1J1021D21626F25Q26526W26I21121H21C21I21G21F22P21F2GF2A721L22Q22R27G21L2D827621G2GQ21H2E922422Z1F27521G2A82762CH2B3131Z25I25O25P26K2AU21G28A27A1Z2GR2BS2HB2C22AU2392761O21H28Q27621F1S2HG29O2AT2AT21D1N2AU2HU2762HF2HJ2AU1L29O2I321H21J2BS2HV27A1L2GR2IB2D82132GR2D82FE27A2952HH2HJ27P2762382HI2GR2BW2IK2762392IV21P2IX24V24S2J22J224C1A2IV2112IX2HH25H2J622B2JD2JE2DW29B27A2392331R1C21L21E25D26625P2HB2HY27A2HN2I72HH2I92IV2HJ2AT2I92AU2HN2HP21H2ID2C22IB2BW2762I92K221H2B02KB21H1W2I72HX2AU2KI2AT21N1P2HQ21H1K2K02GU2JT2762KS2AT2HR2AU28A2IB2KK27A2L12KU2AU2B82BR2I22I92GT2131J2762D82KD21H2CF2I82LK2HW2KV2KR2I32LA21H2LC2LE2LR2GC2AU2LJ2KC2IO2LN2KX2HO1F2LF21H2192KT2L32762M62LM2AU2M121F29C27A2172KJ2LN2MH2L92KG2LS2M42IM2LI2KG2JY2L627A2M121H2LQ2MN2LU2FE2LX2LL2IQ2IS2KG2EY21H2DF2DH2DJ25T2IV2152J92BS25X1A2H121H22922O1T1121F21F25I26325N26F2HB2HD276122HM2HO27A2IH2K82JW27A2LH2BS2LY2HH2K12LK2K721G2MS27G2LT2LK29C2AT2D82M821H2OH2MT2762I02MW2KG2DU2LD2M42LH2N12MS21H2IR27A2FE22J2AU1E2NY2K52O12BR2O12K62HG2O421H2P72I92KA2O62LK2P72AT2P92OB2IB2I92P72D82K52HI2LG2PD2GR2PO2IC2C12OC2LK2PO142C227G2GB2JX2GU2OA2II2LK2CF2OB27G2D82K72IL2Q02PA2C22ET2AT27W2P72B02KI2762OB2792ET2752AU2B02LY2P72792QP2K62GZ2DN2ET2ET21H162762792QX2GR2DN2R02P729C2MH2QQ2GR29C29C28A2OB2RJ2OQ2RM2OL21H2152QI21G2RN2B02RP29C2182BS2DN2LY2RP2M42ED2C227K2AT2M62S521G27K27K2FZ182762FZ2IC2GZ29O2DN27K21F2162762NV2O921H2KA2SH2SS2AU2BW2131G2C228Q21B2O02B821H21M2T52IN28Q2MS2P728Q2142IC2GR28Q28Q1X2PU2762T62T42TJ21H2GB2TM2P92B82TM2AU28Q2B82PW2C22T62TD2RH2TY2T72TI2OT2TO21H2I62PD1I2762TS2O02UD2TT27A2T62IH2TX21G2GB2KS2U12UK2U62TI2L72NZ2HH2IH2T62PR2U62UI2RT2TM2122BS2V12Q52762SF21H2TI2FE2QP2KI2MF2761U2762TI2R02KE2UB2V72PU2SN2762V12L22R82AU2P92SV2UG2SW2UR27A2KA2NV21H102VF21H2V12HH2V82HJ2OB2TI2B02IK2HF2UW2761Y2T72HH2MA2IN2RZ2VC2AU2M62RZ27A192762RZ2FE2Q52TI2RZ2VH2PU2WX2VJ2UQ2BS2TI2W42BS2KM2IN2TI2MS2W82Q72HY2OB2KI27G29C2KF2VK22X2HJ2XE2LN2XJ2BR2QP2TI2NV2U52KI2WF27A2LJ2X82W72GZ2TI2SL2KE1B2W222F2HJ29O2OK2Y52XO2W22XR2LT2KI2SO2XV2W22MS2VM2VK2MS2K22KA27K2VX2L02AU1D2762KI2X12P72HF2MP27A2KI2OX2YZ2VK2762YW21H2FI2X52N22TU2BS2YY2UA2BR2OZ2PB21H");
     local v96;
     if (bit or bit32) then
         local v95 = bit;
         if (not v95) then
             v95 = bit32;
         end
         v96 = v95.bxor;
         if (not v96) then
             v81 = true;
         end
     else
         v81 = true;
     end
     if (v81) then
         local u55 = p10;
         local u56 = p6;
         v96 = function(p14, p15) -- [line 440] anonymous function
             --[[
                 Upvalues: 
                     [1] = u55
                     [2] = u56
             --]]
             local v97 = u55;
             local v98 = u56;
             while true do
                 local v99 = u56;
                 if (v99 <= p14) then
                     local v100 = u56;
                     if (v100 <= p15) then
                         local v101 = p14 % 2;
                         local v102 = p15 % 2;
                         local v103 = v102;
                         if (v101 ~= v102) then
                             v98 = v98 + v97;
                         end
                         local v104 = (p14 - v101) / 2;
                         local v105 = (p15 - v103) / 2;
                         local v106 = v97 * 2;
                         p14 = v104;
                         p15 = v105;
                         v97 = v106;
                     else
                         break;
                     end
                 else
                     break;
                 end
             end
             if (p14 <= p15) then
                 p14 = p15;
             end
             while true do
                 local v107 = u56;
                 if (v107 <= p14) then
                     local v108 = p14 % 2;
                     local v109 = v108;
                     local v110 = u56;
                     if (v110 <= v108) then
                         v98 = v98 + v97;
                     end
                     local v111 = (p14 - v109) / 2;
                     local v112 = v97 * 2;
                     p14 = v111;
                     v97 = v112;
                 else
                     break;
                 end
             end
             return v98;
         end;
     end
     local u57 = p10;
     local u58 = p6;
     local f_a;
     f_a = function(p16, p17, p18) -- [line 440] a
         --[[
             Upvalues: 
                 [1] = u57
                 [2] = u58
         --]]
         if (p18) then
             local v113 = (p16 / ((2) ^ (p17 - u57))) % ((2) ^ (((p18 - u57) - (p17 - u57)) + u57));
             return v113 - (v113 % u57);
         end
         local v114 = false;
         local v115 = (2) ^ (p17 - u57);
         local v116 = v115;
         local v117;
         if (v116 < (p16 % (v115 + v115))) then
             v117 = u57;
             if (not v117) then
                 v114 = true;
             end
         else
             v114 = true;
         end
         if (v114) then
             v117 = u58;
         end
         return v117;
     end;
     local u59 = p10;
     local u60 = p6;
     local u61 = t_byte_30;
     local u62 = v94;
     local u63 = v96;
     local f_n;
     f_n = function() -- [line 440] n
         --[[
             Upvalues: 
                 [1] = u61
                 [2] = u62
                 [3] = u59
                 [4] = u63
         --]]
         local v118, v119, v120, v121 = u61(u62, u59, u59 + 3);
         local v122 = u63(v118, 53);
         local v123 = u63(v119, 53);
         local v124 = u63(v120, 53);
         local v125 = u63(v121, 53);
         u59 = u59 + 4;
         return (((v125 * 16777216) + (v124 * 65536)) + (v123 * 256)) + v122;
     end;
     local u64 = t_byte_30;
     local u65 = v94;
     local u66 = v96;
     local f_t;
     f_t = function() -- [line 440] t
         --[[
             Upvalues: 
                 [1] = u64
                 [2] = u65
                 [3] = u59
                 [4] = u66
         --]]
         local v126, v127 = u64(u65, u59, u59 + 2);
         local v128 = u66(v126, 53);
         local v129 = u66(v127, 53);
         u59 = u59 + 2;
         return (v129 * 256) + v128;
     end;
     local u67 = v96;
     local u68 = t_byte_30;
     local u69 = v94;
     local u70 = p10;
     local f_h;
     f_h = function() -- [line 440] h
         --[[
             Upvalues: 
                 [1] = u67
                 [2] = u68
                 [3] = u69
                 [4] = u59
                 [5] = u70
         --]]
         local v130 = u67(u68(u69, u59, u59), 53);
         u59 = u59 + u70;
         return v130;
     end;
     local u71 = g_select_28;
     local f_P;
     f_P = function(...) -- [line 440] P
         --[[
             Upvalues: 
                 [1] = u71
         --]]
         return {...}, u71("#", ...);
     end;
     local u72 = p10;
     local f_h = f_h;
     local u73 = p6;
     local f_t = f_t;
     local f_n = f_n;
     local f_a = f_a;
     local u74 = t_sub_31;
     local u75 = v94;
     local u76 = t_byte_30;
     local u77 = v72;
     local u78 = v77;
     local u79 = v96;
     local u80 = nil;
     local u81 = v76;
     local f_B;
     f_B = function() -- [line 440] B
         --[[
             Upvalues: 
                 [1] = u72
                 [2] = f_h
                 [3] = u73
                 [4] = f_t
                 [5] = f_n
                 [6] = f_a
                 [7] = u74
                 [8] = u75
                 [9] = u59
                 [10] = u76
                 [11] = u77
                 [12] = u78
                 [13] = u79
                 [14] = u60
                 [15] = u80
                 [16] = u81
         --]]
         local v131 = false;
         local v132 = {};
         local v133 = {};
         local v134 = {};
         local v135 = {};
         v135[6] = nil;
         v135[3] = v134;
         v135[u72] = {};
         v135[2] = v133;
         v135[5] = v132;
         v135[4] = nil;
         local v136 = {};
         local v137 = {};
         local v138 = u72;
         local v139 = f_h();
         local v140;
         if (v139 == u73) then
             v140 = f_t() * 2;
             if (not v140) then
                 v131 = true;
             end
         else
             v131 = true;
         end
         if (v131) then
             v140 = f_n();
         end
         local v141 = v138;
         local v142 = v140;
         if (not (v142 <= v141)) then
             while true do
                 local v143 = f_h();
                 local v151;
                 if (v143 == u72) then
                     local v144 = false;
                     local v145 = f_n();
                     local v146 = f_n();
                     local v147 = u72;
                     local v148 = (f_a(v146, u72, 20) * 4294967296) + v145;
                     local v149 = f_a(v146, 21, 31);
                     local v150 = (-u72) ^ f_a(v146, 32);
                     if (v149 == u73) then
                         if (v148 == u73) then
                             v151 = v150 * u73;
                         else
                             v149 = u72;
                             v147 = u73;
                             v144 = true;
                         end
                     else
                         if (v149 == 2047) then
                             local v152 = false;
                             local v153;
                             if (v148 == u73) then
                                 v153 = u72;
                                 if (not v153) then
                                     v152 = true;
                                 end
                             else
                                 v152 = true;
                             end
                             if (v152) then
                                 v153 = u73;
                             end
                             v151 = v150 * (v153 / u73);
                         else
                             v144 = true;
                         end
                     end
                     if (v144) then
                         v151 = (v150 * ((2) ^ (v149 - 1023))) * (v147 + (v148 / 4503599627370496));
                     end
                 else
                     if (v143 == 4) then
                         local v154 = "";
                         local v155, v156 = f_n();
                         local v157 = v155;
                         if (v157 == u73) then
                             v151 = v154;
                         else
                             local v158 = u74(u75, u59, (u59 + v157) - u72);
                             local v159 = {u76(v158, u72, #v158)};
                             local v160 = v159;
                             u59 = u59 + v157;
                             local v161 = u72;
                             local v162 = u77(v159);
                             local v163 = v162;
                             local v164 = v161;
                             if (not (v162 <= v164)) then
                                 while true do
                                     v154 = v154 .. u78[u79(v160[v161], 53)];
                                     local v165 = v161 + 1;
                                     v161 = v165;
                                     local v166 = v163;
                                     if (v166 < v165) then
                                         break;
                                     end
                                 end
                             end
                             v151 = v154;
                         end
                     else
                         if (v143 == u73) then
                             v151 = f_h() ~= u73;
                         else
                             if (v143 == 2) then
                                 local v167 = f_n();
                                 v151 = u74(u75, u59, (u59 + v167) - u72);
                                 u59 = u59 + v167;
                             else
                                 v151 = nil;
                             end
                         end
                     end
                 end
                 v137[v138] = v151;
                 local v168 = v138 + 1;
                 v138 = v168;
                 local v169 = v140;
                 if (v169 < v168) then
                     break;
                 end
             end
         end
         local v170 = u60;
         if (v170 <= u72) then
             u60 = u72;
             local v171 = f_t();
             v135[7] = u74(u75, u59, (u59 + v171) - u72);
             u59 = u59 + v171;
         end
         local v172 = u72;
         local v173 = f_n();
         local v174 = v173;
         local v175 = v172;
         if (not (v173 <= v175)) then
             while true do
                 v132[v172 - u72] = u80();
                 local v176 = v172 + 1;
                 v172 = v176;
                 local v177 = v174;
                 if (v177 < v176) then
                     break;
                 end
             end
         end
         v135[4] = f_h();
         local v178 = u72;
         local v179 = f_n();
         local v180 = v179;
         local v181 = v178;
         if (not (v179 <= v181)) then
             while true do
                 local v182 = false;
                 local v183 = f_h();
                 local v184 = v183;
                 local v185 = f_a(v183, u72, u72);
                 if (v185 == u73) then
                     local v186 = f_t();
                     local v187 = f_h() == u72;
                     local v188 = v187;
                     local v189 = f_t();
                     local v190 = {};
                     local v191 = f_a(v184, 4, 6);
                     local v192 = f_a(v184, 2, 3);
                     local v193 = {};
                     local v194 = {};
                     v194[4] = v189;
                     v194[9] = v187;
                     v194[2] = nil;
                     v194[7] = v186;
                     if (v192 == 2) then
                         v194[9] = f_n() - 65536;
                     end
                     if (v192 == 3) then
                         local v195 = f_n() - 65536;
                         local v196 = f_t();
                         v194[9] = v195;
                         v194[2] = v196;
                     end
                     if (v192 == u72) then
                         v194[9] = f_n();
                     end
                     if (v192 == u73) then
                         local v197 = f_t();
                         local v198 = f_t();
                         v194[9] = v197;
                         v194[2] = v198;
                     end
                     local v199 = f_a(v191, 2, 2);
                     if (v199 == u72) then
                         v190[9] = 9;
                         v194[9] = v137[v194[9]];
                     end
                     local v200 = f_a(v191, 3, 3);
                     if (v200 == u72) then
                         v190[2] = 2;
                         v194[2] = v137[v194[2]];
                     end
                     local v201 = f_a(v191, u72, u72);
                     if (v201 == u72) then
                         v190[4] = 4;
                         v194[4] = v137[v194[4]];
                     end
                     if (v188) then
                         u81(v135[u72], v194);
                         v194[3] = v190;
                     end
                     v133[v178] = v194;
                     v182 = true;
                 else
                     v182 = true;
                 end
                 if (v182) then
                     local v202 = v178 + 1;
                     v178 = v202;
                     local v203 = v180;
                     if (v203 < v202) then
                         break;
                     end
                 end
             end
         end
         return v135;
     end;
     local u82 = p6;
     local u83 = p10;
     local u84 = g_select_28;
     local f_P = f_P;
     local u85 = g_setmetatable_32;
     local u86 = nil;
     local u87 = v73;
     local u88 = g_pairs_26;
     local u89 = t_char_27;
     local u90 = v96;
     local f_I;
     f_I = function(p19, p20, p21, p22) -- [line 440] I
         --[[
             Upvalues: 
                 [1] = u82
                 [2] = u83
                 [3] = u84
                 [4] = f_P
                 [5] = u85
                 [6] = u86
                 [7] = u87
                 [8] = u88
                 [9] = u89
                 [10] = u90
         --]]
         local v204 = p19[2];
         local v205 = p19[5];
         local v206 = {};
         local v207 = u82;
         local v208 = p19[6];
         local v209 = p19[u83];
         local u91 = p19[4];
         local u92 = v204;
         local u93 = v205;
         local u94 = v207;
         local u95 = p20;
         local u96 = p21;
         local u97 = v209;
         return function(...) -- [line 440] anonymous function
             --[[
                 Upvalues: 
                     [1] = u84
                     [2] = u83
                     [3] = u91
                     [4] = u92
                     [5] = u93
                     [6] = f_P
                     [7] = u82
                     [8] = u94
                     [9] = u85
                     [10] = u95
                     [11] = u86
                     [12] = u96
                     [13] = u87
                     [14] = u88
                     [15] = u97
                     [16] = u89
                     [17] = u90
             --]]
             local v210 = {};
             local v211 = {...};
             local v212 = u84("#", ...) - u83;
             local v213 = v212;
             local v214 = {};
             local v215 = u91;
             local v216 = u92;
             local v217 = u93;
             local v218 = u83;
             local v219 = {};
             local v220 = -u83;
             local v221 = u82;
             local v222 = v212;
             local v223 = v221;
             if (not (v212 <= v223)) then
                 while true do
                     if (v215 < v221) then
                         v214[v221 - v215] = v211[v221 + u83];
                     else
                         v210[v221] = v211[v221 + u83];
                     end
                     local v224 = v221 + 1;
                     v221 = v224;
                     local v225 = v222;
                     if (v225 < v224) then
                         break;
                     end
                 end
             end
             local v226 = (v213 - v215) + u83;
             while true do
                 local v227 = v216[v218];
                 local v228 = v227;
                 local v229 = v227[7];
                 local v230 = u94;
                 local v231 = u82;
                 if (v231 <= v230) then
                     v210[v228[4]] = v228[9];
                 end
                 if (v229 < 33) then
                     if (v229 < 16) then
                         if (v229 < 7) then
                             if (v229 < 3) then
                                 if (v229 < u83) then
                                     if (v229 == u82) then
                                         v210[v228[4]] = v210[v228[9]][v210[v228[2]]];
                                     else
                                         local v232 = false;
                                         local v233;
                                         if (v210[v228[4]]) then
                                             v233 = v228[9];
                                             if (not v233) then
                                                 v232 = true;
                                             end
                                         else
                                             v232 = true;
                                         end
                                         if (v232) then
                                             v233 = v218 + u83;
                                         end
                                         v218 = v233;
                                     end
                                 else
                                     if (v229 == 2) then
                                         local v234 = v217[v228[9]];
                                         local v235 = {};
                                         local v236 = u85;
                                         local v237 = {};
                                         local v238 = {};
                                         local u98 = v235;
                                         local f___index;
                                         f___index = function(p23, p24) -- [line 440] __index
                                             --[[
                                                 Upvalues: 
                                                     [1] = u98
                                                     [2] = u83
                                             --]]
                                             local v239 = u98[p24];
                                             return v239[u83][v239[2]];
                                         end;
                                         v238.__index = f___index;
                                         local u99 = v235;
                                         local f___newindex;
                                         f___newindex = function(p25, p26, p27) -- [line 440] __newindex
                                             --[[
                                                 Upvalues: 
                                                     [1] = u99
                                                     [2] = u83
                                             --]]
                                             local v240 = u99[p26];
                                             v240[u83][v240[2]] = p27;
                                         end;
                                         v238.__newindex = f___newindex;
                                         local v241 = v236(v237, v238);
                                         local v242 = u83;
                                         local v243 = v228[2];
                                         local v244 = v243;
                                         local v245 = v242;
                                         if (not (v243 <= v245)) then
                                             while true do
                                                 v218 = v218 + u83;
                                                 local v246 = v216[v218];
                                                 local v247 = v246;
                                                 local v248 = v246[7];
                                                 if (v248 == 7) then
                                                     v235[v242 - u83] = {
                                                         v210,
                                                         v247[9]
                                                     };
                                                 else
                                                     v235[v242 - u83] = {
                                                         u95,
                                                         v247[9]
                                                     };
                                                 end
                                                 v219[(#v219) + u83] = v235;
                                                 local v249 = v242 + 1;
                                                 v242 = v249;
                                                 local v250 = v244;
                                                 if (v250 < v249) then
                                                     break;
                                                 end
                                             end
                                         end
                                         v210[v228[4]] = u86(v234, v241, u96);
                                     else
                                         v210[v228[4]] = v210[v228[9]] - v210[v228[2]];
                                     end
                                 end
                             else
                                 if (v229 < 5) then
                                     if (v229 == 4) then
                                         v210[v228[4]] = v210[v228[9]][v210[v228[2]]];
                                     else
                                         local v251 = false;
                                         local v252 = v210[v228[4]];
                                         local v253;
                                         if (v252 == v210[v228[2]]) then
                                             v253 = v228[9];
                                             if (not v253) then
                                                 v251 = true;
                                             end
                                         else
                                             v251 = true;
                                         end
                                         if (v251) then
                                             v253 = v218 + u83;
                                         end
                                         v218 = v253;
                                     end
                                 else
                                     if (v229 == 6) then
                                         local v254 = v228[4];
                                         local v255 = {v210[v254](u87(v210, v254 + u83, v228[9]))};
                                         local v256 = u82;
                                         local v257 = v254;
                                         local v258 = v228[2];
                                         local v259 = v258;
                                         local v260 = v257;
                                         if (not (v258 <= v260)) then
                                             while true do
                                                 v256 = v256 + u83;
                                                 v210[v257] = v255[v256];
                                                 local v261 = v257 + 1;
                                                 v257 = v261;
                                                 local v262 = v259;
                                                 if (v262 < v261) then
                                                     break;
                                                 end
                                             end
                                         end
                                     else
                                         v210[v228[4]] = v210[v228[9]];
                                     end
                                 end
                             end
                         else
                             if (v229 < 11) then
                                 if (v229 < 9) then
                                     if (v229 == 8) then
                                         local v263 = v228[4];
                                         local v264 = {v210[v263](u87(v210, v263 + u83, v228[9]))};
                                         local v265 = u82;
                                         local v266 = v263;
                                         local v267 = v228[2];
                                         local v268 = v267;
                                         local v269 = v266;
                                         if (not (v267 <= v269)) then
                                             while true do
                                                 v265 = v265 + u83;
                                                 v210[v266] = v264[v265];
                                                 local v270 = v266 + 1;
                                                 v266 = v270;
                                                 local v271 = v268;
                                                 if (v271 < v270) then
                                                     break;
                                                 end
                                             end
                                         end
                                     else
                                         local v272 = false;
                                         local v273;
                                         if (v210[v228[4]]) then
                                             v273 = v218 + u83;
                                             if (not v273) then
                                                 v272 = true;
                                             end
                                         else
                                             v272 = true;
                                         end
                                         if (v272) then
                                             v273 = v228[9];
                                         end
                                         v218 = v273;
                                     end
                                 else
                                     if (v229 >= 10) then
                                         v210[v228[4]][v210[v228[9]]] = v228[2];
                                     else
                                         local v274 = v228[4];
                                         local v275 = v274;
                                         local v276 = v210[v274];
                                         local v277 = 50 * v228[2];
                                         local v278 = v274 + u83;
                                         local v279 = v228[9];
                                         local v280 = v279;
                                         local v281 = v278;
                                         if (not (v279 <= v281)) then
                                             while true do
                                                 v276[(v277 + v278) - v275] = v210[v278];
                                                 local v282 = v278 + 1;
                                                 v278 = v282;
                                                 local v283 = v280;
                                                 if (v283 < v282) then
                                                     break;
                                                 end
                                             end
                                         end
                                     end
                                 end
                             else
                                 if (v229 < 13) then
                                     if (v229 >= 12) then
                                         local v284, v285, v286 = u88(u97);
                                         local v287 = v284;
                                         local v288 = v285;
                                         local v289 = v286;
                                         while true do
                                             local v290, v291 = v287(v288, v289);
                                             local v292 = v290;
                                             local v293 = v291;
                                             if (v290) then
                                                 break;
                                             end
                                             v289 = v292;
                                             local v294, v295, v296 = u88(v293[3]);
                                             local v297 = v294;
                                             local v298 = v295;
                                             local v299 = v296;
                                             while true do
                                                 local v300, v301 = v297(v298, v299);
                                                 local v302 = v300;
                                                 local v303 = v301;
                                                 if (v300) then
                                                     break;
                                                 end
                                                 v299 = v302;
                                                 local v304 = {v293[v303]:byte(u83, #v293[v303])};
                                                 local v305 = v304;
                                                 local v306 = "";
                                                 local v307 = v228[4];
                                                 local v308 = v228[9];
                                                 local v309 = u83;
                                                 local v310 = #v304;
                                                 local v311 = v310;
                                                 local v312 = v309;
                                                 if (not (v310 <= v312)) then
                                                     while true do
                                                         local v313 = v306 .. u89(u90(v305[v309], v307));
                                                         local v314 = (v307 + v308) % 256;
                                                         v306 = v313;
                                                         v307 = v314;
                                                         local v315 = v309 + 1;
                                                         v309 = v315;
                                                         local v316 = v311;
                                                         if (v316 < v315) then
                                                             break;
                                                         end
                                                     end
                                                 end
                                                 local v317 = {};
                                                 v293[v303] = v306;
                                                 v293[3] = v317;
                                             end
                                         end
                                     else
                                         v210[v228[4]][v210[v228[9]]] = v228[2];
                                         local v318 = v218 + u83;
                                         local v319 = v216[v318];
                                         v210[v319[4]] = u95[v319[9]];
                                         local v320 = v318 + u83;
                                         local v321 = v216[v320];
                                         local v322 = v321[4];
                                         local v323 = v210[v321[9]];
                                         v210[v322 + u83] = v323;
                                         v210[v322] = v323[v321[2]];
                                         local v324 = v320 + u83;
                                         local v325 = v216[v324];
                                         v210[v325[4]] = v325[9];
                                         local v326 = v324 + u83;
                                         local v327 = v216[v326];
                                         v210[v327[4]] = v210[v327[9]];
                                         v218 = v326 + u83;
                                         local v328 = v216[v218];
                                         local v329 = v328[4];
                                         v210[v329](u87(v210, v329 + u83, v328[9]));
                                     end
                                 else
                                     if (v229 < 14) then
                                         v210[v228[4]] = v228[9];
                                     else
                                         if (v229 == 15) then
                                             v210[v228[4]] = {};
                                         else
                                             local v330 = v228[4];
                                             local v331 = {v210[v330](u87(v210, v330 + u83, v228[9]))};
                                             local v332 = u82;
                                             local v333 = v330;
                                             local v334 = v228[2];
                                             local v335 = v334;
                                             local v336 = v333;
                                             if (not (v334 <= v336)) then
                                                 while true do
                                                     v332 = v332 + u83;
                                                     v210[v333] = v331[v332];
                                                     local v337 = v333 + 1;
                                                     v333 = v337;
                                                     local v338 = v335;
                                                     if (v338 < v337) then
                                                         break;
                                                     end
                                                 end
                                             end
                                             local v339 = false;
                                             local v340 = v218 + u83;
                                             local v341 = v216[v340];
                                             v210[v341[4]] = v210[v341[9]];
                                             local v342 = v340 + u83;
                                             local v343 = v216[v342];
                                             v210[v343[4]] = v210[v343[9]];
                                             local v344 = v342 + u83;
                                             local v345 = v216[v344];
                                             v210[v345[4]] = v210[v345[9]];
                                             local v346 = v344 + u83;
                                             local v347 = v216[v346];
                                             v210[v347[4]] = v347[9] ~= u82;
                                             local v348 = v346 + u83;
                                             local v349 = v216[v348][4];
                                             v210[v349](v210[v349 + u83]);
                                             local v350 = v348 + u83;
                                             local v351 = v216[v350];
                                             v210[v351[4]] = v210[v351[9]][v351[2]];
                                             local v352 = v350 + u83;
                                             local v353 = v216[v352];
                                             v210[v353[4]] = v210[v353[9]][v353[2]];
                                             local v354 = v352 + u83;
                                             local v355 = v354;
                                             local v356 = v216[v354];
                                             local v357 = v356;
                                             local v358 = v210[v356[4]];
                                             local v359;
                                             if (v358 == v210[v356[2]]) then
                                                 v359 = v357[9];
                                                 if (not v359) then
                                                     v339 = true;
                                                 end
                                             else
                                                 v339 = true;
                                             end
                                             if (v339) then
                                                 v359 = v355 + u83;
                                             end
                                             v218 = v359;
                                         end
                                     end
                                 end
                             end
                         end
                     else
                         if (v229 < 24) then
                             if (v229 < 20) then
                                 if (v229 < 18) then
                                     if (v229 == 17) then
                                         v210[v228[4]] = v228[9];
                                         local v360 = v218 + u83;
                                         local v361 = v216[v360][4];
                                         v210[v361](v210[v361 + u83]);
                                         local v362 = v360 + u83;
                                         local v363 = v216[v362];
                                         v210[v363[4]] = u96[v363[9]];
                                         local v364 = v362 + u83;
                                         local v365 = v216[v364];
                                         v210[v365[4]] = v210[v365[9]][v365[2]];
                                         local v366 = v364 + u83;
                                         local v367 = v216[v366];
                                         v210[v367[4]] = v367[9];
                                         local v368 = v366 + u83;
                                         local v369 = v216[v368];
                                         v210[v369[4]] = v369[9];
                                         local v370 = v368 + u83;
                                         local v371 = v216[v370];
                                         v210[v371[4]] = v371[9];
                                         local v372 = v370 + u83;
                                         local v373 = v216[v372];
                                         local v374 = v373[4];
                                         v210[v374] = v210[v374](u87(v210, v374 + u83, v373[9]));
                                         local v375 = v372 + u83;
                                         local v376 = v216[v375];
                                         v210[v376[4]] = u96[v376[9]];
                                         v218 = v375 + u83;
                                         local v377 = v216[v218];
                                         v210[v377[4]] = v210[v377[9]][v377[2]];
                                     else
                                         v210[v228[4]] = v210[v228[9]][v228[2]];
                                     end
                                 else
                                     if (v229 >= 19) then
                                         v210[v228[4]] = v210[v228[9]] - v210[v228[2]];
                                     else
                                         v210[v228[4]] = u95[v228[9]];
                                     end
                                 end
                             else
                                 if (v229 < 22) then
                                     if (v229 >= 21) then
                                         v210[v228[4]] = u95[v228[9]];
                                     else
                                         v210[v228[4]] = v210[v228[9]];
                                     end
                                 else
                                     if (v229 == 23) then
                                         local v378 = v210[v228[4]];
                                         if (v378 <= v228[2]) then
                                             v218 = v228[9];
                                         else
                                             v218 = v218 + u83;
                                         end
                                     else
                                         local v379 = v228[4];
                                         v210[v379](v210[v379 + u83]);
                                     end
                                 end
                             end
                         else
                             if (v229 < 28) then
                                 if (v229 < 26) then
                                     if (v229 >= 25) then
                                         local v380 = v228[4];
                                         local v381 = v210[v228[9]];
                                         v210[v380 + u83] = v381;
                                         v210[v380] = v381[v228[2]];
                                     else
                                         local v382 = v228[4];
                                         if (v382 <= v210[v228[2]]) then
                                             v218 = v228[9];
                                         else
                                             v218 = v218 + u83;
                                         end
                                     end
                                 else
                                     if (v229 >= 27) then
                                         local v383 = v228[4];
                                         if (v383 <= v210[v228[2]]) then
                                             v218 = v218 + u83;
                                         else
                                             v218 = v228[9];
                                         end
                                     else
                                         local v384 = v228[4];
                                         v210[v384](v210[v384 + u83]);
                                     end
                                 end
                             else
                                 if (v229 < 30) then
                                     if (v229 == 29) then
                                         local v385 = v228[4];
                                         v210[v385] = v210[v385](v210[v385 + u83]);
                                     else
                                         v210[v228[4]] = u96[v228[9]];
                                     end
                                 else
                                     if (v229 < 31) then
                                         local v386 = v217[v228[9]];
                                         local v387 = {};
                                         local v388 = u85;
                                         local v389 = {};
                                         local v390 = {};
                                         local u100 = v387;
                                         local f___index;
                                         f___index = function(p28, p29) -- [line 440] __index
                                             --[[
                                                 Upvalues: 
                                                     [1] = u100
                                                     [2] = u83
                                             --]]
                                             local v391 = u100[p29];
                                             return v391[u83][v391[2]];
                                         end;
                                         v390.__index = f___index;
                                         local u101 = v387;
                                         local f___newindex;
                                         f___newindex = function(p30, p31, p32) -- [line 440] __newindex
                                             --[[
                                                 Upvalues: 
                                                     [1] = u101
                                                     [2] = u83
                                             --]]
                                             local v392 = u101[p31];
                                             v392[u83][v392[2]] = p32;
                                         end;
                                         v390.__newindex = f___newindex;
                                         local v393 = v388(v389, v390);
                                         local v394 = u83;
                                         local v395 = v228[2];
                                         local v396 = v395;
                                         local v397 = v394;
                                         if (not (v395 <= v397)) then
                                             while true do
                                                 v218 = v218 + u83;
                                                 local v398 = v216[v218];
                                                 local v399 = v398;
                                                 local v400 = v398[7];
                                                 if (v400 == 7) then
                                                     v387[v394 - u83] = {
                                                         v210,
                                                         v399[9]
                                                     };
                                                 else
                                                     v387[v394 - u83] = {
                                                         u95,
                                                         v399[9]
                                                     };
                                                 end
                                                 v219[(#v219) + u83] = v387;
                                                 local v401 = v394 + 1;
                                                 v394 = v401;
                                                 local v402 = v396;
                                                 if (v402 < v401) then
                                                     break;
                                                 end
                                             end
                                         end
                                         v210[v228[4]] = u86(v386, v393, u96);
                                     else
                                         if (v229 == 32) then
                                             v210[v228[4]]();
                                         else
                                             local v403 = v228[4];
                                             v210[v403] = v210[v403](v210[v403 + u83]);
                                         end
                                     end
                                 end
                             end
                         end
                     end
                 else
                     if (v229 < 50) then
                         if (v229 < 41) then
                             if (v229 < 37) then
                                 if (v229 < 35) then
                                     if (v229 >= 34) then
                                         v210[v228[4]] = v210[v228[9]][v228[2]];
                                     else
                                         v218 = v228[9];
                                     end
                                 else
                                     if (v229 >= 36) then
                                         v210[v228[4]] = u96[v228[9]];
                                     else
                                         local v404 = v228[4];
                                         v210[v404] = v210[v404](u87(v210, v404 + u83, v228[9]));
                                     end
                                 end
                             else
                                 if (v229 < 39) then
                                     if (v229 >= 38) then
                                         v210[v228[4]] = v228[9];
                                         local v405 = v218 + u83;
                                         local v406 = v216[v405];
                                         v210[v406[4]] = v406[9];
                                         local v407 = v405 + u83;
                                         local v408 = v216[v407];
                                         local v409 = v408[4];
                                         v210[v409] = v210[v409](u87(v210, v409 + u83, v408[9]));
                                         local v410 = v407 + u83;
                                         local v411 = v216[v410];
                                         v210[v411[4]] = u96[v411[9]];
                                         local v412 = v410 + u83;
                                         local v413 = v216[v412];
                                         v210[v413[4]] = v210[v413[9]][v413[2]];
                                         local v414 = v412 + u83;
                                         local v415 = v216[v414];
                                         v210[v415[4]] = v210[v415[9]];
                                         local v416 = v414 + u83;
                                         local v417 = v216[v416];
                                         v210[v417[4]] = v210[v417[9]] - v210[v417[2]];
                                         local v418 = v416 + u83;
                                         local v419 = v216[v418];
                                         local v420 = v419[4];
                                         v210[v420] = v210[v420](u87(v210, v420 + u83, v419[9]));
                                         local v421 = v418 + u83;
                                         local v422 = v216[v421];
                                         local v423 = v422[4];
                                         local v424 = v210[v422[9]];
                                         v210[v423 + u83] = v424;
                                         v210[v423] = v424[v422[2]];
                                         v218 = v421 + u83;
                                         local v425 = v216[v218];
                                         v210[v425[4]] = v210[v425[9]];
                                     else
                                         v210[v228[4]] = v228[9];
                                     end
                                 else
                                     if (v229 == 40) then
                                         local v426 = v228[4];
                                         v210[v426] = v210[v426](u87(v210, v426 + u83, v228[9]));
                                     else
                                         local v427 = false;
                                         local v428;
                                         if (v210[v228[4]]) then
                                             v428 = v228[9];
                                             if (not v428) then
                                                 v427 = true;
                                             end
                                         else
                                             v427 = true;
                                         end
                                         if (v427) then
                                             v428 = v218 + u83;
                                         end
                                         v218 = v428;
                                     end
                                 end
                             end
                         else
                             if (v229 < 45) then
                                 if (v229 < 43) then
                                     if (v229 >= 42) then
                                         local v429 = v228[4];
                                         local v430 = v429;
                                         local v431 = v210[v429];
                                         local v432 = 50 * v228[2];
                                         local v433 = v429 + u83;
                                         local v434 = v228[9];
                                         local v435 = v434;
                                         local v436 = v433;
                                         if (not (v434 <= v436)) then
                                             while true do
                                                 v431[(v432 + v433) - v430] = v210[v433];
                                                 local v437 = v433 + 1;
                                                 v433 = v437;
                                                 local v438 = v435;
                                                 if (v438 < v437) then
                                                     break;
                                                 end
                                             end
                                         end
                                     else
                                         local v439 = v210[v228[4]];
                                         if (v439 <= v228[2]) then
                                             v218 = v228[9];
                                         else
                                             v218 = v218 + u83;
                                         end
                                     end
                                 else
                                     if (v229 >= 44) then
                                         v210[v228[4]] = u95[v228[9]];
                                         local v440 = v218 + u83;
                                         local v441 = v216[v440];
                                         v210[v441[4]] = u95[v441[9]];
                                         local v442 = v440 + u83;
                                         local v443 = v216[v442];
                                         v210[v443[4]] = v210[v443[9]] - v210[v443[2]];
                                         local v444 = v442 + u83;
                                         local v445 = v444;
                                         local v446 = v216[v444];
                                         local v447, v448, v449 = u88(u97);
                                         local v450 = v447;
                                         local v451 = v448;
                                         local v452 = v449;
                                         while true do
                                             local v453, v454 = v450(v451, v452);
                                             local v455 = v453;
                                             local v456 = v454;
                                             if (v453) then
                                                 break;
                                             end
                                             v452 = v455;
                                             local v457, v458, v459 = u88(v456[3]);
                                             local v460 = v457;
                                             local v461 = v458;
                                             local v462 = v459;
                                             while true do
                                                 local v463, v464 = v460(v461, v462);
                                                 local v465 = v463;
                                                 local v466 = v464;
                                                 if (v463) then
                                                     break;
                                                 end
                                                 v462 = v465;
                                                 local v467 = {v456[v466]:byte(u83, #v456[v466])};
                                                 local v468 = v446[4];
                                                 local v469 = v446[9];
                                                 local v470 = v467;
                                                 local v471 = "";
                                                 local v472 = v468;
                                                 local v473 = v469;
                                                 local v474 = u83;
                                                 local v475 = #v467;
                                                 local v476 = v475;
                                                 local v477 = v474;
                                                 if (not (v475 <= v477)) then
                                                     while true do
                                                         local v478 = v471 .. u89(u90(v470[v474], v472));
                                                         local v479 = (v472 + v473) % 256;
                                                         v471 = v478;
                                                         v472 = v479;
                                                         local v480 = v474 + 1;
                                                         v474 = v480;
                                                         local v481 = v476;
                                                         if (v481 < v480) then
                                                             break;
                                                         end
                                                     end
                                                 end
                                                 local v482 = {};
                                                 v456[v466] = v471;
                                                 v456[3] = v482;
                                             end
                                         end
                                         local v483 = false;
                                         local v484 = v445 + u83;
                                         local v485 = v216[v484];
                                         v210[v485[4]] = v210[v485[9]][v485[2]];
                                         local v486 = v484 + u83;
                                         local v487 = v216[v486];
                                         v210[v487[4]] = u95[v487[9]];
                                         local v488 = v486 + u83;
                                         local v489 = v488;
                                         local v490 = v216[v488];
                                         local v491 = v490;
                                         local v492;
                                         if (v210[v490[4]]) then
                                             v492 = v489 + u83;
                                             if (not v492) then
                                                 v483 = true;
                                             end
                                         else
                                             v483 = true;
                                         end
                                         if (v483) then
                                             v492 = v491[9];
                                         end
                                         v218 = v492;
                                     else
                                         local v493 = v228[4];
                                         if (v493 <= v210[v228[2]]) then
                                             v218 = v218 + u83;
                                         else
                                             v218 = v228[9];
                                         end
                                     end
                                 end
                             else
                                 if (v229 < 47) then
                                     if (v229 == 46) then
                                         local v494 = v228[4];
                                         local v495 = v210[v228[9]];
                                         v210[v494 + u83] = v495;
                                         v210[v494] = v495[v228[2]];
                                     else
                                         local v496 = v228[4];
                                         local v497 = {};
                                         local v498 = u83;
                                         local v499 = #v219;
                                         local v500 = v499;
                                         local v501 = v498;
                                         if (not (v499 <= v501)) then
                                             while true do
                                                 local v502 = false;
                                                 local v503 = v219[v498];
                                                 local v504 = v503;
                                                 local v505 = u82;
                                                 local v506 = #v503;
                                                 local v507 = v506;
                                                 local v508 = v505;
                                                 if (v506 <= v508) then
                                                     v502 = true;
                                                 else
                                                     while true do
                                                         local v509 = v504[v505];
                                                         local v510 = v509;
                                                         local v511 = v509[u83];
                                                         local v512 = v509[2];
                                                         if ((v511 == v210) and (v496 < v512)) then
                                                             v497[v512] = v511[v512];
                                                             v510[u83] = v497;
                                                         end
                                                         local v513 = v505 + 1;
                                                         v505 = v513;
                                                         local v514 = v507;
                                                         if (v514 < v513) then
                                                             break;
                                                         end
                                                     end
                                                     v502 = true;
                                                 end
                                                 if (v502) then
                                                     local v515 = v498 + 1;
                                                     v498 = v515;
                                                     local v516 = v500;
                                                     if (v516 < v515) then
                                                         break;
                                                     end
                                                 end
                                             end
                                         end
                                     end
                                 else
                                     if (v229 < 48) then
                                         local v517 = v228[4];
                                         v210[v517](u87(v210, v517 + u83, v228[9]));
                                     else
                                         if (v229 >= 49) then
                                             return;
                                         end
                                         v210[v228[4]] = v228[9];
                                         local v518 = v218 + u83;
                                         local v519 = v216[v518];
                                         local v520 = v519[4];
                                         v210[v520] = v210[v520](u87(v210, v520 + u83, v519[9]));
                                         local v521 = v518 + u83;
                                         local v522 = v216[v521];
                                         v210[v522[4]] = v210[v522[9]][v522[2]];
                                         local v523 = v521 + u83;
                                         local v524 = v216[v523];
                                         local v525 = v524[4];
                                         local v526 = v210[v524[9]];
                                         v210[v525 + u83] = v526;
                                         v210[v525] = v526[v524[2]];
                                         local v527 = v523 + u83;
                                         local v528 = v216[v527][4];
                                         v210[v528] = v210[v528](v210[v528 + u83]);
                                         local v529 = v527 + u83;
                                         local v530 = v216[v529];
                                         v210[v530[4]] = v210[v530[9]][v530[2]];
                                         local v531 = v529 + u83;
                                         local v532 = v216[v531];
                                         v210[v532[4]] = u96[v532[9]];
                                         local v533 = v531 + u83;
                                         local v534 = v216[v533];
                                         v210[v534[4]] = v210[v534[9]][v534[2]];
                                         local v535 = v533 + u83;
                                         local v536 = v216[v535][4];
                                         v210[v536] = v210[v536](v210[v536 + u83]);
                                         v218 = v535 + u83;
                                         local v537 = v216[v218];
                                         v210[v537[4]] = u96[v537[9]];
                                     end
                                 end
                             end
                         end
                     else
                         if (v229 < 59) then
                             if (v229 < 54) then
                                 if (v229 < 52) then
                                     if (v229 >= 51) then
                                         v218 = v228[9];
                                     else
                                         local v538 = v228[4];
                                         v210[v538] = v210[v538](v210[v538 + u83]);
                                         local v539 = v218 + u83;
                                         local v540 = v216[v539];
                                         v210[v540[4]] = u96[v540[9]];
                                         local v541 = v539 + u83;
                                         local v542 = v216[v541];
                                         v210[v542[4]] = u96[v542[9]];
                                         local v543 = v541 + u83;
                                         local v544 = v216[v543];
                                         v210[v544[4]] = v210[v544[9]][v544[2]];
                                         local v545 = v543 + u83;
                                         local v546 = v216[v545];
                                         v210[v546[4]] = v210[v546[9]][v546[2]];
                                         local v547 = v545 + u83;
                                         local v548 = v216[v547];
                                         v210[v548[4]] = v210[v548[9]][v548[2]];
                                         local v549 = v547 + u83;
                                         local v550 = v216[v549];
                                         v210[v550[4]] = v210[v550[9]][v550[2]];
                                         local v551 = v549 + u83;
                                         local v552 = v216[v551];
                                         v210[v552[4]] = v210[v552[9]][v552[2]];
                                         local v553 = v551 + u83;
                                         local v554 = v216[v553][4];
                                         v210[v554] = v210[v554](v210[v554 + u83]);
                                         v218 = v553 + u83;
                                         local v555 = v216[v218];
                                         v210[v555[4]] = v210[v555[9]][v555[2]];
                                     end
                                 else
                                     if (v229 >= 53) then
                                         v210[v228[4]][v210[v228[9]]] = v228[2];
                                     else
                                         v210[v228[4]] = v210[v228[9]];
                                         local v556 = v218 + u83;
                                         v210[v216[v556][4]]();
                                         local v557 = v556 + u83;
                                         local v558 = v216[v557];
                                         local v559 = v558[4];
                                         local v560 = v210[v558[9]];
                                         v210[v559 + u83] = v560;
                                         v210[v559] = v560[v558[2]];
                                         local v561 = v557 + u83;
                                         local v562 = v216[v561];
                                         v210[v562[4]] = v210[v562[9]];
                                         local v563 = v561 + u83;
                                         local v564 = v216[v563];
                                         v210[v564[4]] = v210[v564[9]];
                                         local v565 = v563 + u83;
                                         v210[v216[v565][4]] = {};
                                         local v566 = v565 + u83;
                                         local v567 = v216[v566];
                                         v210[v567[4]] = v210[v567[9]];
                                         v218 = v566 + u83;
                                         local v568 = v216[v218];
                                         local v569 = v568[4];
                                         local v570 = v569;
                                         local v571 = v210[v569];
                                         local v572 = 50 * v568[2];
                                         local v573 = v569 + u83;
                                         local v574 = v568[9];
                                         local v575 = v574;
                                         local v576 = v573;
                                         if (not (v574 <= v576)) then
                                             while true do
                                                 v571[(v572 + v573) - v570] = v210[v573];
                                                 local v577 = v573 + 1;
                                                 v573 = v577;
                                                 local v578 = v575;
                                                 if (v578 < v577) then
                                                     break;
                                                 end
                                             end
                                         end
                                     end
                                 end
                             else
                                 if (v229 < 56) then
                                     if (v229 == 55) then
                                         local v579, v580, v581 = u88(u97);
                                         local v582 = v579;
                                         local v583 = v580;
                                         local v584 = v581;
                                         while true do
                                             local v585, v586 = v582(v583, v584);
                                             local v587 = v585;
                                             local v588 = v586;
                                             if (v585) then
                                                 break;
                                             end
                                             v584 = v587;
                                             local v589, v590, v591 = u88(v588[3]);
                                             local v592 = v589;
                                             local v593 = v590;
                                             local v594 = v591;
                                             while true do
                                                 local v595, v596 = v592(v593, v594);
                                                 local v597 = v595;
                                                 local v598 = v596;
                                                 if (v595) then
                                                     break;
                                                 end
                                                 v594 = v597;
                                                 local v599 = {v588[v598]:byte(u83, #v588[v598])};
                                                 local v600 = v228[4];
                                                 local v601 = v228[9];
                                                 local v602 = v599;
                                                 local v603 = "";
                                                 local v604 = v600;
                                                 local v605 = v601;
                                                 local v606 = u83;
                                                 local v607 = #v599;
                                                 local v608 = v607;
                                                 local v609 = v606;
                                                 if (not (v607 <= v609)) then
                                                     while true do
                                                         local v610 = v603 .. u89(u90(v602[v606], v604));
                                                         local v611 = (v604 + v605) % 256;
                                                         v603 = v610;
                                                         v604 = v611;
                                                         local v612 = v606 + 1;
                                                         v606 = v612;
                                                         local v613 = v608;
                                                         if (v613 < v612) then
                                                             break;
                                                         end
                                                     end
                                                 end
                                                 local v614 = {};
                                                 v588[v598] = v603;
                                                 v588[3] = v614;
                                             end
                                         end
                                         local v615 = v218 + u83;
                                         local v616 = v216[v615];
                                         v210[v616[4]] = u96[v616[9]];
                                         local v617 = v615 + u83;
                                         local v618 = v216[v617];
                                         v210[v618[4]] = u95[v618[9]];
                                         local v619 = v617 + u83;
                                         local v620 = v216[v619];
                                         v210[v620[4]] = v210[v620[9]][v210[v620[2]]];
                                         local v621 = v619 + u83;
                                         local v622 = v216[v621][4];
                                         v210[v622] = v210[v622](v210[v622 + u83]);
                                         local v623 = v621 + u83;
                                         local v624 = v216[v623];
                                         v210[v624[4]] = v210[v624[9]][v624[2]];
                                         local v625 = v623 + u83;
                                         local v626 = v625;
                                         local v627 = v216[v625];
                                         local v628 = v627;
                                         local v629 = v210[v627[4]];
                                         if (v629 <= v627[2]) then
                                             v218 = v628[9];
                                         else
                                             v218 = v626 + u83;
                                         end
                                     else
                                         v210[v228[4]] = v210[v228[9]];
                                         local v630 = v218 + u83;
                                         local v631 = v216[v630];
                                         v210[v631[4]] = v631[9];
                                         local v632 = v630 + u83;
                                         local v633 = v216[v632][4];
                                         v210[v633](v210[v633 + u83]);
                                         local v634 = v632 + u83;
                                         local v635 = v216[v634];
                                         v210[v635[4]] = v210[v635[9]];
                                         local v636 = v634 + u83;
                                         local v637 = v216[v636];
                                         v210[v637[4]] = v637[9];
                                         local v638 = v636 + u83;
                                         local v639 = v216[v638][4];
                                         v210[v639](v210[v639 + u83]);
                                         local v640 = v638 + u83;
                                         local v641 = v640;
                                         local v642 = v216[v640][4];
                                         local v643 = {};
                                         local v644 = u83;
                                         local v645 = #v219;
                                         local v646 = v645;
                                         local v647 = v644;
                                         if (not (v645 <= v647)) then
                                             while true do
                                                 local v648 = false;
                                                 local v649 = v219[v644];
                                                 local v650 = v649;
                                                 local v651 = u82;
                                                 local v652 = #v649;
                                                 local v653 = v652;
                                                 local v654 = v651;
                                                 if (v652 <= v654) then
                                                     v648 = true;
                                                 else
                                                     while true do
                                                         local v655 = v650[v651];
                                                         local v656 = v655;
                                                         local v657 = v655[u83];
                                                         local v658 = v655[2];
                                                         if ((v657 == v210) and (v642 < v658)) then
                                                             v643[v658] = v657[v658];
                                                             v656[u83] = v643;
                                                         end
                                                         local v659 = v651 + 1;
                                                         v651 = v659;
                                                         local v660 = v653;
                                                         if (v660 < v659) then
                                                             break;
                                                         end
                                                     end
                                                     v648 = true;
                                                 end
                                                 if (v648) then
                                                     local v661 = v644 + 1;
                                                     v644 = v661;
                                                     local v662 = v646;
                                                     if (v662 < v661) then
                                                         break;
                                                     end
                                                 end
                                             end
                                         end
                                         v218 = v216[v641 + u83][9];
                                     end
                                 else
                                     if (v229 < 57) then
                                         local v663 = v228[4];
                                         local v664 = {};
                                         local v665 = u83;
                                         local v666 = #v219;
                                         local v667 = v666;
                                         local v668 = v665;
                                         if (not (v666 <= v668)) then
                                             while true do
                                                 local v669 = false;
                                                 local v670 = v219[v665];
                                                 local v671 = v670;
                                                 local v672 = u82;
                                                 local v673 = #v670;
                                                 local v674 = v673;
                                                 local v675 = v672;
                                                 if (v673 <= v675) then
                                                     v669 = true;
                                                 else
                                                     while true do
                                                         local v676 = v671[v672];
                                                         local v677 = v676;
                                                         local v678 = v676[u83];
                                                         local v679 = v676[2];
                                                         if ((v678 == v210) and (v663 < v679)) then
                                                             v664[v679] = v678[v679];
                                                             v677[u83] = v664;
                                                         end
                                                         local v680 = v672 + 1;
                                                         v672 = v680;
                                                         local v681 = v674;
                                                         if (v681 < v680) then
                                                             break;
                                                         end
                                                     end
                                                     v669 = true;
                                                 end
                                                 if (v669) then
                                                     local v682 = v665 + 1;
                                                     v665 = v682;
                                                     local v683 = v667;
                                                     if (v683 < v682) then
                                                         break;
                                                     end
                                                 end
                                             end
                                         end
                                     else
                                         if (v229 == 58) then
                                             local v684 = v228[4];
                                             if (v684 <= v210[v228[2]]) then
                                                 v218 = v228[9];
                                             else
                                                 v218 = v218 + u83;
                                             end
                                         else
                                             local v685, v686, v687 = u88(u97);
                                             local v688 = v685;
                                             local v689 = v686;
                                             local v690 = v687;
                                             while true do
                                                 local v691, v692 = v688(v689, v690);
                                                 local v693 = v691;
                                                 local v694 = v692;
                                                 if (v691) then
                                                     break;
                                                 end
                                                 v690 = v693;
                                                 local v695, v696, v697 = u88(v694[3]);
                                                 local v698 = v695;
                                                 local v699 = v696;
                                                 local v700 = v697;
                                                 while true do
                                                     local v701, v702 = v698(v699, v700);
                                                     local v703 = v701;
                                                     local v704 = v702;
                                                     if (v701) then
                                                         break;
                                                     end
                                                     v700 = v703;
                                                     local v705 = {v694[v704]:byte(u83, #v694[v704])};
                                                     local v706 = v228[4];
                                                     local v707 = v228[9];
                                                     local v708 = v705;
                                                     local v709 = "";
                                                     local v710 = v706;
                                                     local v711 = v707;
                                                     local v712 = u83;
                                                     local v713 = #v705;
                                                     local v714 = v713;
                                                     local v715 = v712;
                                                     if (not (v713 <= v715)) then
                                                         while true do
                                                             local v716 = v709 .. u89(u90(v708[v712], v710));
                                                             local v717 = (v710 + v711) % 256;
                                                             v709 = v716;
                                                             v710 = v717;
                                                             local v718 = v712 + 1;
                                                             v712 = v718;
                                                             local v719 = v714;
                                                             if (v719 < v718) then
                                                                 break;
                                                             end
                                                         end
                                                     end
                                                     local v720 = {};
                                                     v694[v704] = v709;
                                                     v694[3] = v720;
                                                 end
                                             end
                                             local v721 = v218 + u83;
                                             local v722 = v216[v721];
                                             v210[v722[4]] = u96[v722[9]];
                                             local v723 = v721 + u83;
                                             local v724 = v216[v723];
                                             local v725 = v724[4];
                                             local v726 = v210[v724[9]];
                                             v210[v725 + u83] = v726;
                                             v210[v725] = v726[v724[2]];
                                             local v727 = v723 + u83;
                                             local v728 = v216[v727];
                                             v210[v728[4]] = v728[9];
                                             local v729 = v727 + u83;
                                             local v730 = v216[v729];
                                             local v731 = v730[4];
                                             v210[v731] = v210[v731](u87(v210, v731 + u83, v730[9]));
                                             local v732 = v729 + u83;
                                             local v733 = v216[v732];
                                             v210[v733[4]] = u96[v733[9]];
                                             local v734 = v732 + u83;
                                             local v735 = v216[v734];
                                             local v736 = v735[4];
                                             local v737 = v210[v735[9]];
                                             v210[v736 + u83] = v737;
                                             v210[v736] = v737[v735[2]];
                                             local v738 = v734 + u83;
                                             local v739 = v216[v738];
                                             v210[v739[4]] = v739[9];
                                             local v740 = v738 + u83;
                                             local v741 = v216[v740];
                                             local v742 = v741[4];
                                             v210[v742] = v210[v742](u87(v210, v742 + u83, v741[9]));
                                             v218 = v740 + u83;
                                             local v743 = v216[v218];
                                             v210[v743[4]] = u96[v743[9]];
                                         end
                                     end
                                 end
                             end
                         else
                             if (v229 < 63) then
                                 if (v229 < 61) then
                                     if (v229 == 60) then
                                         v210[v228[4]] = v228[9] ~= u82;
                                     else
                                         v210[v228[4]] = {};
                                     end
                                 else
                                     if (v229 == 62) then
                                         local v744 = false;
                                         local v745 = v210[v228[4]];
                                         local v746;
                                         if (v745 == v210[v228[2]]) then
                                             v746 = v228[9];
                                             if (not v746) then
                                                 v744 = true;
                                             end
                                         else
                                             v744 = true;
                                         end
                                         if (v744) then
                                             v746 = v218 + u83;
                                         end
                                         v218 = v746;
                                     else
                                         local v747 = false;
                                         local v748;
                                         if (v210[v228[4]]) then
                                             v748 = v218 + u83;
                                             if (not v748) then
                                                 v747 = true;
                                             end
                                         else
                                             v747 = true;
                                         end
                                         if (v747) then
                                             v748 = v228[9];
                                         end
                                         v218 = v748;
                                     end
                                 end
                             else
                                 if (v229 < 65) then
                                     if (v229 >= 64) then
                                         return;
                                     end
                                     local v749, v750, v751 = u88(u97);
                                     local v752 = v749;
                                     local v753 = v750;
                                     local v754 = v751;
                                     while true do
                                         local v755, v756 = v752(v753, v754);
                                         local v757 = v755;
                                         local v758 = v756;
                                         if (v755) then
                                             break;
                                         end
                                         v754 = v757;
                                         local v759, v760, v761 = u88(v758[3]);
                                         local v762 = v759;
                                         local v763 = v760;
                                         local v764 = v761;
                                         while true do
                                             local v765, v766 = v762(v763, v764);
                                             local v767 = v765;
                                             local v768 = v766;
                                             if (v765) then
                                                 break;
                                             end
                                             v764 = v767;
                                             local v769 = {v758[v768]:byte(u83, #v758[v768])};
                                             local v770 = v769;
                                             local v771 = "";
                                             local v772 = v228[4];
                                             local v773 = v228[9];
                                             local v774 = u83;
                                             local v775 = #v769;
                                             local v776 = v775;
                                             local v777 = v774;
                                             if (not (v775 <= v777)) then
                                                 while true do
                                                     local v778 = v771 .. u89(u90(v770[v774], v772));
                                                     local v779 = (v772 + v773) % 256;
                                                     v771 = v778;
                                                     v772 = v779;
                                                     local v780 = v774 + 1;
                                                     v774 = v780;
                                                     local v781 = v776;
                                                     if (v781 < v780) then
                                                         break;
                                                     end
                                                 end
                                             end
                                             local v782 = {};
                                             v758[v768] = v771;
                                             v758[3] = v782;
                                         end
                                     end
                                 else
                                     if (v229 < 66) then
                                         local v783 = v228[4];
                                         v210[v783](u87(v210, v783 + u83, v228[9]));
                                     else
                                         if (v229 >= 67) then
                                             v210[v228[4]]();
                                         else
                                             v210[v228[4]] = v228[9] ~= u82;
                                         end
                                     end
                                 end
                             end
                         end
                     end
                 end
                 v218 = v218 + u83;
             end
         end;
     end;
     return v73({f_I(f_B(), {}, v74())()}) or nil;
 end)(string, 0, table.concat, {}, "", 1, ({
     1
 })[1]);
 