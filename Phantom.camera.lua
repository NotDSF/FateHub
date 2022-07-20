-- Decompiled with the Synapse X Luau decompiler.
 --NOTE: Currently in beta! Not representative of final product.
 local u1 = {};
 local v1 = shared.require("hud");
 local v2 = shared.require("char");
 local v3 = shared.require("input");
 local v4 = shared.require("spring");
 local v5 = shared.require("vector");
 local v6 = shared.require("cframe");
 local v7 = shared.require("ScreenCull");
 local v8 = shared.require("replication");
 local v9 = shared.require("CameraSweep");
 local t_fromaxisangle_1 = v6.fromaxisangle;
 local v10 = math.pi;
 local v11 = 2 * v10;
 local u2 = CFrame.new;
 local u3 = CFrame.Angles;
 local v12 = v10 / 180;
 local v13 = game:GetService("Players").LocalPlayer;
 local v14 = workspace.CurrentCamera;
 u1.currentcamera = v14;
 u1.type = "menu";
 u1.subcf = u2();
 u1.sensitivity = 1;
 u1.aimsensitivity = 1;
 u1.sensitivitymult = 1;
 u1.controlleraimmult = 1;
 u1.controllersens = 1;
 u1.controlleraimsens = 1;
 u1.controlleraccel = 2.5;
 u1.controlleraimaccel = 1;
 u1.controllerymult = 1;
 u1.startspeed = 0;
 u1.directlook = false;
 u1.directlookenabled = true;
 u1.xinvert = 1;
 u1.basefov = 80;
 u1.offset = Vector3.new(0, 1.5, 0);
 u1.angles = Vector3.new();
 u1.maxangle = 0.496875 * v10;
 u1.minangle = -0.496875 * v10;
 u1.maxoffsetangle = math.pi / 6;
 u1.basecframe = u2();
 u1.shakecframe = u2();
 u1.cframe = u2();
 u1.lookvector = Vector3.new(0, 0, -1);
 u1.shakespring = v4.new(Vector3.new());
 u1.magspring = v4.new(0);
 u1.swayspring = v4.new(0);
 u1.swayspeed = v4.new(0);
 u1.zanglespring = v4.new(0);
 u1.offsetspring = v4.new(Vector3.new());
 u1.delta = Vector3.new();
 u1.menufov = 60;
 u1.spectatetype = "thirdperson";
 local u4 = 0.016666666666666666;
 local u5 = false;
 local u6 = false;
 local u7 = 0;
 local u8 = nil;
 local u9 = nil;
 local u10 = nil;
 local u11 = nil;
 u1.shakespring.s = 12;
 u1.shakespring.d = 0.65;
 u1.magspring.s = 12;
 u1.magspring.d = 1;
 u1.swayspring.s = 4;
 u1.swayspring.d = 1;
 u1.swayspeed.s = 6;
 u1.swayspeed.d = 1;
 u1.swayspeed.t = 1;
 u1.zanglespring.s = 8;
 u1.offsetspring.s = 16;
 u1.currentcamera.CameraType = "Scriptable";
 local u12 = v4.new(Vector3.new());
 u12.s = 32;
 u12.d = 0.65;
 local u13 = v4.new(Vector3.new());
 u13.s = 20;
 u13.d = 0.75;
 local v15 = v4.new(Vector3.new());
 v15.s = 16;
 v15.d = 0.75;
 local v16 = v4.new(Vector3.new());
 v16.s = 10;
 v16.d = 0.8;
 local v17 = math.tan(45 * v12);
 local u14 = v4.new(0);
 u14.s = 30;
 local u15 = v4.new(0);
 u15.s = 30;
 local u16 = {};
 u16.c0 = u2();
 u16.c1 = u2();
 local f_isdirtyfloat;
 f_isdirtyfloat = function(p1)
     --[[
         Name: isdirtyfloat
         Line: 115
     --]]
     local v18 = true;
     if (p1 == p1) then
         v18 = true;
         if (p1 ~= -(1/0)) then
             v18 = p1 == (1/0);
         end
     end
     return v18;
 end;
 local f_setsensitivity;
 f_setsensitivity = function(p2, p3)
     --[[
         Name: setsensitivity
         Line: 119
         Upvalues: 
             [1] = u1
 
     --]]
     u1.sensitivity = p3;
 end;
 u1.setsensitivity = f_setsensitivity;
 local f_setaimsensitivity;
 f_setaimsensitivity = function(p4, p5)
     --[[
         Name: setaimsensitivity
         Line: 123
         Upvalues: 
             [1] = u1
 
     --]]
     local v19 = false;
     local v20 = u1;
     local v21;
     if (p5) then
         v21 = u1.aimsensitivity;
         if (not v21) then
             v19 = true;
         end
     else
         v19 = true;
     end
     if (v19) then
         v21 = 1;
     end
     local v22 = false;
     v20.sensitivitymult = v21;
     local v23 = u1;
     local v24;
     if (p5) then
         v24 = u1.controlleraimsens;
         if (not v24) then
             v22 = true;
         end
     else
         v22 = true;
     end
     if (v22) then
         v24 = 1;
     end
     v23.controlleraimmult = v24;
 end;
 u1.setaimsensitivity = f_setaimsensitivity;
 local f_shake;
 f_shake = function(p6, p7)
     --[[
         Name: shake
         Line: 128
         Upvalues: 
             [1] = u1
 
     --]]
     u1.shakespring.a = p7;
 end;
 u1.shake = f_shake;
 local f_magnify;
 f_magnify = function(p8, p9)
     --[[
         Name: magnify
         Line: 132
         Upvalues: 
             [1] = u1
 
     --]]
     u1.magspring.t = math.log(p9);
 end;
 u1.magnify = f_magnify;
 local f_suppress;
 f_suppress = function(p10, p11)
     --[[
         Name: suppress
         Line: 141
         Upvalues: 
             [1] = u12
 
     --]]
     u12.a = p11;
 end;
 u1.suppress = f_suppress;
 local f_hit;
 f_hit = function(p12, p13)
     --[[
         Name: hit
         Line: 145
         Upvalues: 
             [1] = u1
             [2] = u13
 
     --]]
     local v25 = u1.cframe:vectorToObjectSpace(p13);
     u13.a = Vector3.new(v25.z, 0, -v25.x) * 0.25;
 end;
 u1.hit = f_hit;
 local f_setmagnification;
 f_setmagnification = function(p14, p15)
     --[[
         Name: setmagnification
         Line: 150
         Upvalues: 
             [1] = u1
 
     --]]
     local v26 = math.log(p15);
     u1.magspring.p = v26;
     u1.magspring.t = v26;
     u1.magspring.v = 0;
 end;
 u1.setmagnification = f_setmagnification;
 local f_setmagnificationspeed;
 f_setmagnificationspeed = function(p16, p17)
     --[[
         Name: setmagnificationspeed
         Line: 157
         Upvalues: 
             [1] = u1
 
     --]]
     u1.magspring.s = p17;
 end;
 u1.setmagnificationspeed = f_setmagnificationspeed;
 local f_setswayspeed;
 f_setswayspeed = function(p18, p19)
     --[[
         Name: setswayspeed
         Line: 161
         Upvalues: 
             [1] = u1
 
     --]]
     u1.swayspeed.t = p19 or 1;
 end;
 u1.setswayspeed = f_setswayspeed;
 local f_setsway;
 f_setsway = function(p20, p21)
     --[[
         Name: setsway
         Line: 165
         Upvalues: 
             [1] = u1
 
     --]]
     u1.swayspring.t = p21;
 end;
 u1.setsway = f_setsway;
 local u17 = u1;
 local f_isspectating;
 f_isspectating = function(p22)
     --[[
         Name: isspectating
         Line: 169
         Upvalues: 
             [1] = u17
             [2] = u9
             [3] = u8
 
     --]]
     local v27 = false;
     local t_type_2 = u17.type;
     if (t_type_2 == "spectate") then
         v27 = u9;
         if (v27) then
             v27 = u8;
         end
     end
     return v27;
 end;
 u1.isspectating = f_isspectating;
 local u18 = v8;
 local u19 = u1;
 local u20 = v15;
 local f_setspectate;
 f_setspectate = function(p23, p24)
     --[[
         Name: setspectate
         Line: 173
         Upvalues: 
             [1] = u18
             [2] = u19
             [3] = u9
             [4] = u10
             [5] = u8
             [6] = u20
 
     --]]
     local v28 = u18.getupdater(p24);
     local v29 = v28;
     if (v28) then
         u19.type = "spectate";
         u9 = p24;
         u10 = v29;
         u8 = v29.gethead();
         local v30 = u8.CFrame * Vector3.new(1, 1, 6.5);
         u20.t = v30;
         u20.p = v30;
         u20.v = Vector3.new();
     end
 end;
 u1.setspectate = f_setspectate;
 local u21 = u1;
 local f_setfixedcam;
 f_setfixedcam = function(p25, p26)
     --[[
         Name: setfixedcam
         Line: 188
         Upvalues: 
             [1] = u21
             [2] = u8
 
     --]]
     u21.type = "fixed";
     u8 = p26;
 end;
 u1.setfixedcam = f_setfixedcam;
 local u22 = u1;
 local u23 = u16;
 local u24 = u2;
 local f_setmenucam;
 f_setmenucam = function(p27, p28)
     --[[
         Name: setmenucam
         Line: 193
         Upvalues: 
             [1] = u22
             [2] = u11
             [3] = u23
             [4] = u24
 
     --]]
     local v31 = p28:WaitForChild("CharStage");
     local v32 = p28:WaitForChild("GunStage");
     u22.type = "menu";
     u11 = p28;
     u23.c0 = u24(v31.CamPos.Position, v31.Focus.Position);
     u23.c1 = u24(v32.CamPos.Position, v32.Focus.Position);
 end;
 u1.setmenucam = f_setmenucam;
 local f_setmenucf;
 f_setmenucf = function(p29, p30, p31)
     --[[
         Name: setmenucf
         Line: 203
         Upvalues: 
             [1] = u16
             [2] = u2
 
     --]]
     u16[p30] = u2(p31.CamPos.Position, p31.Focus.Position);
 end;
 u1.setmenucf = f_setmenucf;
 local f_setmenufov;
 f_setmenufov = function(p32, p33)
     --[[
         Name: setmenufov
         Line: 207
         Upvalues: 
             [1] = u14
 
     --]]
     u14.t = p33;
 end;
 u1.setmenufov = f_setmenufov;
 local f_setmenuspring;
 f_setmenuspring = function(p34, p35)
     --[[
         Name: setmenuspring
         Line: 211
         Upvalues: 
             [1] = u15
 
     --]]
     u15.t = p35;
 end;
 u1.setmenuspring = f_setmenuspring;
 local f_setfirstpersoncam;
 f_setfirstpersoncam = function(p36)
     --[[
         Name: setfirstpersoncam
         Line: 215
         Upvalues: 
             [1] = u1
 
     --]]
     u1.type = "firstperson";
     u1.FieldOfView = u1.basefov;
 end;
 u1.setfirstpersoncam = f_setfirstpersoncam;
 local u25 = v5;
 local u26 = u1;
 local u27 = v10;
 local u28 = v11;
 local f_setlookvector;
 f_setlookvector = function(p37, p38, p39, p40)
     --[[
         Name: setlookvector
         Line: 220
         Upvalues: 
             [1] = u5
             [2] = u25
             [3] = u26
             [4] = u27
             [5] = u28
             [6] = u4
 
     --]]
     u5 = true;
     if (p39 and p40) then
         local v33 = math.cos(tick());
         local v34 = math.sin(tick());
         local v35 = (v33 * p39) - (v34 * p40);
         local v36 = (v34 * p39) + (v33 * p40);
         p39 = v35;
         p40 = v36;
     end
     local v37 = false;
     local v38, v39 = u25.toanglesyx(p38);
     local v40 = v38 + (p39 or 0);
     local v41 = v39 + (p40 or 0);
     local t_y_3 = u26.angles.y;
     local v42;
     if (u26.maxangle <= v40) then
         v42 = u26.maxangle;
         if (not v42) then
             v37 = true;
         end
     else
         v37 = true;
     end
     if (v37) then
         local v43 = false;
         local t_minangle_4 = u26.minangle;
         if (v40 <= t_minangle_4) then
             v42 = u26.minangle;
             if (not v42) then
                 v43 = true;
             end
         else
             v43 = true;
         end
         if (v43) then
             v42 = v40;
         end
     end
     local v44 = Vector3.new(v42, ((((v41 + u27) - t_y_3) % u28) - u27) + t_y_3, 0);
     u26.delta = (v44 - u26.angles) / u4;
     u26.angles = v44;
 end;
 u1.setlookvector = f_setlookvector;
 local f_changemenufov;
 f_changemenufov = function(p41, p42)
     --[[
         Name: changemenufov
         Line: 239
         Upvalues: 
             [1] = u14
 
     --]]
     local v45 = u14.t + p42;
     local v46 = v45;
     local v47;
     if (v45 <= 0) then
         v47 = 0;
     else
         local v48 = false;
         if (v46 <= 3) then
             v47 = v46;
             if (not v47) then
                 v48 = true;
             end
         else
             v48 = true;
         end
         if (v48) then
             v47 = 3;
         end
     end
     u14.t = v47;
 end;
 u1.changemenufov = f_changemenufov;
 local u29 = 0;
 local u30 = u1;
 local u31 = v16;
 local u32 = v2;
 local u33 = v11;
 local u34 = u3;
 local u35 = t_fromaxisangle_1;
 local u36 = u12;
 local u37 = u13;
 local u38 = v12;
 local t_CurrentCamera_5 = v14;
 local t_LocalPlayer_6 = v13;
 local u39 = v1;
 local f_isdirtyfloat = f_isdirtyfloat;
 local u40 = v5;
 local u41 = v15;
 local u42 = v10;
 local u43 = v9;
 local u44 = u2;
 local u45 = u16;
 local u46 = u15;
 local u47 = v17;
 local u48 = u14;
 local u49 = v7;
 local f_step;
 f_step = function(p43)
     --[[
         Name: step
         Line: 250
         Upvalues: 
             [1] = u4
             [2] = u5
             [3] = u30
             [4] = u6
             [5] = u7
             [6] = u31
             [7] = u32
             [8] = u29
             [9] = u33
             [10] = u34
             [11] = u35
             [12] = u36
             [13] = u37
             [14] = u38
             [15] = t_CurrentCamera_5
             [16] = u9
             [17] = u10
             [18] = t_LocalPlayer_6
             [19] = u8
             [20] = u39
             [21] = f_isdirtyfloat
             [22] = u40
             [23] = u41
             [24] = u42
             [25] = u43
             [26] = u44
             [27] = u11
             [28] = u45
             [29] = u46
             [30] = u47
             [31] = u48
             [32] = u49
 
     --]]
     u4 = p43;
     if (u5) then
         u30.delta = Vector3.new();
     end
     if (u6) then
         u6 = false;
     else
         u7 = 0;
     end
     u5 = false;
     u31.t = u32.acceleration;
     local t_type_7 = u30.type;
     if (t_type_7 == "firstperson") then
         local v49 = u32.rootpart.CFrame;
         local v50 = Vector3.new(0, u32.headheight, 0);
         u29 = u29 + (p43 * u30.swayspeed.p);
         local v51 = u29;
         local v52 = 0.5 * u32.speed;
         local v53 = (((u32.distance * u33) / 4) * 3) / 4;
         local v54 = u30.swayspring.p;
         local v55 = ((u34(0, u30.angles.y, 0) * u34(u30.angles.x, 0, 0)) * u35(u30.offsetspring.p)) * u34(0, 0, u30.zanglespring.p);
         u30.basecframe = v55 + (v49 * v50);
         local v56 = ((v55 * u35(u30.shakespring.p)) * u35((v52 * math.cos(v53 + 2)) / 2048, (v52 * math.cos(v53 / 2)) / 2048, (v52 * math.cos((v53 / 2) + 2)) / 4096)) * u35((v54 * math.cos((2 * v51) + 2)) / 2048, (v54 * math.cos((2 * v51) / 2)) / 2048, (v54 * math.cos(((2 * v51) / 2) - 2)) / 4096);
         local v57 = ((v56 * u35(Vector3.new(0, 0, 1):Cross((u31.v / 4096) / 16) * Vector3.new(1, 0, 0))) * u35(u36.p + u37.p)) + (v49 * v50);
         t_CurrentCamera_5.FieldOfView = (2 * math.atan(math.tan((u30.basefov * u38) / 2) / ((2.718281828459045) ^ u30.magspring.p))) / u38;
         t_CurrentCamera_5.CFrame = v57;
         u30.shakecframe = v56 + (v49 * v50);
         u30.cframe = v57;
         u30.lookvector = v57.lookVector;
     else
         local t_type_8 = u30.type;
         if (t_type_8 == "spectate") then
             local v58 = false;
             if (u9 and u10) then
                 local v59 = u9;
                 local v60 = t_LocalPlayer_6;
                 if (((not (v59 == v60)) and u8) and u39:isplayeralive(u9)) then
                     if (u10 and u10.step) then
                         u10.step(3, true);
                     end
                     local v61 = u8.CFrame;
                     local t_CFrame_9 = v61;
                     local v62 = v61.p;
                     local t_p_10 = v62;
                     if ((f_isdirtyfloat(v62.x) or f_isdirtyfloat(v62.y)) or f_isdirtyfloat(v62.z)) then
                         return;
                     end
                     local t_spectatetype_11 = u30.spectatetype;
                     if (t_spectatetype_11 == "thirdperson") then
                         local v63, v64 = u40.toanglesyx(t_CFrame_9.lookVector);
                         local v65 = (u34(0, v64, 0) * u34(v63, 0, 0)) + u41.p;
                         if (v65.RightVector:Dot(t_CFrame_9.RightVector) <= 0) then
                             v65 = v65 * u34(0, 0, u42);
                         end
                         local v66 = v65 * CFrame.new(1, 1, 0);
                         local v67 = v66 * Vector3.new(0, 0, 6.5);
                         u41.t = t_p_10;
                         local v68 = v67 - v66.Position;
                         u30.cframe = v66 + (u43.sweep(t_CurrentCamera_5, v66, v68, {
                             u8,
                             workspace.Terrain,
                             workspace.Ignore
                         }) * v68);
                         u30.lookvector = u30.cframe.lookVector;
                         t_CurrentCamera_5.CFrame = u30.cframe;
                     else
                         local t_spectatetype_12 = u30.spectatetype;
                         if (t_spectatetype_12 == "firstperson") then
                             local v69, v70 = u40.toanglesyx(t_CFrame_9.lookVector);
                             local v71 = (u34(0, v70, 0) * u34(v69, 0, 0)) + t_p_10;
                             t_CurrentCamera_5.CFrame = v71;
                             u30.cframe = v71;
                             u30.lookvector = v71.lookVector;
                         end
                     end
                 else
                     v58 = true;
                 end
             else
                 v58 = true;
             end
             if (v58) then
                 if (not (u39.spectating or u39:isplayeralive(u9))) then
                     u9 = nil;
                     u8 = nil;
                     if (u32.deadcf) then
                         u30:setfixedcam(u32.deadcf);
                     end
                 end
             end
             t_CurrentCamera_5.FieldOfView = u30.basefov;
         else
             local t_type_13 = u30.type;
             if (t_type_13 == "fixed") then
                 if (u8) then
                     local v72 = u8 * u44(0, 1, 2);
                     t_CurrentCamera_5.CFrame = v72;
                     u30.cframe = v72;
                     u30.lookvector = u30.cframe.lookVector;
                 end
                 t_CurrentCamera_5.FieldOfView = u30.basefov;
             else
                 local t_type_14 = u30.type;
                 if (t_type_14 == "menu") then
                     if (u11) then
                         local v73 = u45.c0:Lerp(u45.c1, u46.p);
                         u30.currentcamera.CFrame = v73;
                         u30.cframe = v73;
                         u30.lookvector = u30.cframe.lookVector;
                     end
                     t_CurrentCamera_5.FieldOfView = (2 / u38) * math.atan(u47 / ((2.718281828459045) ^ u48.p));
                 end
             end
         end
     end
     u49.step(t_CurrentCamera_5.CFrame, t_CurrentCamera_5.ViewportSize, t_CurrentCamera_5.FieldOfView);
 end;
 u1.step = f_step;
 local f_getClosestAngle;
 f_getClosestAngle = function(p44, p45)
     --[[
         Name: getClosestAngle
         Line: 391
     --]]
     return ((((p45 - p44) + math.pi) % (2 * math.pi)) - math.pi) + p44;
 end;
 local f_toAnglesYXZ;
 f_toAnglesYXZ = function(p46, p47, p48)
     --[[
         Name: toAnglesYXZ
         Line: 395
         Upvalues: 
             [1] = f_getClosestAngle
 
     --]]
     local v74, v75, v76, v77, v78, v79, v80, v81, v82, v83, v84, v85 = p46:components();
     local v86 = v79;
     local v87 = v80;
     local v88 = v81;
     local v89 = v82;
     local v90 = v85;
     local v92, v91, v93;
     if (v81 <= 0) then
         v91 = math.atan2(-v89, -math.sqrt((v87 * v87) + (v88 * v88)));
         v92 = math.atan2(-v86, -v90);
         v93 = math.atan2(-v87, -v88);
     else
         v91 = math.atan2(-v89, math.sqrt((v87 * v87) + (v88 * v88)));
         v92 = math.atan2(v86, v90);
         v93 = math.atan2(v87, v88);
     end
     local v94 = f_getClosestAngle((p47 + p48) / 2, v91);
     local v95 = f_getClosestAngle((p47 + p48) / 2, math.pi - v91);
     if (((p47 < v94) and (v94 <= p48)) or ((v95 < p47) or (p48 <= v95))) then
         return v94, v92, v93;
     end
     return v95, f_getClosestAngle(0, v92 + math.pi), f_getClosestAngle(0, v93 + math.pi);
 end;
 local f_limitAnglesYX;
 f_limitAnglesYX = function(p49, p50, p51)
     --[[
         Name: limitAnglesYX
         Line: 424
     --]]
     local v96, v97, v98, v99, v100, v101, v102, v103, v104, v105, v106, v107 = p49:components();
     local v108 = v99;
     local v109 = v100;
     local v110 = v101;
     local v111 = v105;
     local v112 = v106;
     local v113 = v107;
     local v114 = math.atan2(-v104, v103);
     local v115 = math.atan2(-v105, v99);
     if (v114 <= p50) then
         local v116 = math.cos(p50);
         local v117 = math.sin(p50);
         v114 = p50;
         v115 = math.atan2(((-v111) + (v110 * v116)) + (v109 * v117), (v108 + (v113 * v116)) + (v112 * v117));
     else
         if (p51 <= v114) then
             local v118 = math.cos(p51);
             local v119 = math.sin(p51);
             v114 = p51;
             v115 = math.atan2(((-v111) + (v110 * v118)) + (v109 * v119), (v108 + (v113 * v118)) + (v112 * v119));
         end
     end
     return v114, v115;
 end;
 local f_getOffsetAxisAngle;
 f_getOffsetAxisAngle = function(p52, p53)
     --[[
         Name: getOffsetAxisAngle
         Line: 443
     --]]
     local v120, v121 = p52:toObjectSpace(p53):toAxisAngle();
     return v121 * v120;
 end;
 local f_setdirectlookmode;
 f_setdirectlookmode = function(p54)
     --[[
         Name: setdirectlookmode
         Line: 449
         Upvalues: 
             [1] = u1
 
     --]]
     if (u1.directlook == p54) then
         return;
     end
     u1.directlook = p54;
     if (not p54) then
         u1.offsetspring.t = Vector3.new();
     end
 end;
 u1.setdirectlookmode = f_setdirectlookmode;
 local f_resetStance;
 f_resetStance = function()
     --[[
         Name: resetStance
         Line: 459
         Upvalues: 
             [1] = u3
             [2] = u1
             [3] = t_fromaxisangle_1
             [4] = f_toAnglesYXZ
             [5] = f_getClosestAngle
 
     --]]
     local v122, v123, v124 = f_toAnglesYXZ((u3(0, u1.angles.y, 0) * u3(u1.angles.x, 0, 0)) * t_fromaxisangle_1(u1.offsetspring.p), u1.minangle, u1.maxangle);
     local v125 = f_getClosestAngle(u1.angles.y, v123);
     u1.offsetspring.p = Vector3.new();
     u1.offsetspring.t = Vector3.new();
     u1.zanglespring.p = v124;
     u1.angles = Vector3.new(v122, v125, 0);
 end;
 local f_vectorApproach;
 f_vectorApproach = function(p55, p56, p57)
     --[[
         Name: vectorApproach
         Line: 474
     --]]
     local v126 = p56 - p55;
     local v127 = v126;
     if (v126.magnitude <= p57) then
         return p56;
     end
     return p55 + (p57 * v127.unit);
 end;
 local f_approach;
 f_approach = function(p58, p59, p60)
     --[[
         Name: approach
         Line: 483
     --]]
     local v128 = p59 - p58;
     local v129 = v128;
     if (math.abs(v128) <= p60) then
         return p59;
     end
     if (v129 <= 0) then
         return p58 - p60;
     end
     return p58 + p60;
 end;
 local f_zCorrect;
 f_zCorrect = function(p61, p62)
     --[[
         Name: zCorrect
         Line: 496
         Upvalues: 
             [1] = f_toAnglesYXZ
             [2] = u1
             [3] = f_approach
             [4] = u3
 
     --]]
     local v130, v131, v132 = f_toAnglesYXZ(p61, u1.minangle - u1.maxoffsetangle, u1.maxangle + u1.maxoffsetangle);
     return u3(0, v131, 0) * u3(v130, 0, (f_approach(v132, 0, 2 * p62)));
 end;
 local u50 = u1;
 local u51 = u3;
 local u52 = t_fromaxisangle_1;
 local f_limitAnglesYX = f_limitAnglesYX;
 local u53 = f_getClosestAngle;
 local f_getOffsetAxisAngle = f_getOffsetAxisAngle;
 local f_applylookdelta;
 f_applylookdelta = function(p63)
     --[[
         Name: applylookdelta
         Line: 508
         Upvalues: 
             [1] = u50
             [2] = u51
             [3] = u52
             [4] = f_limitAnglesYX
             [5] = u53
             [6] = u4
             [7] = f_getOffsetAxisAngle
 
     --]]
     if (not (u50.directlookenabled and u50.directlook)) then
         local v133 = u50.angles.x + p63.x;
         local v134 = u50.angles.y + p63.y;
         local v135 = math.clamp(v133, u50.minangle, u50.maxangle);
         u50.delta = f_getOffsetAxisAngle((u51(0, u50.angles.y, 0) * u51(u50.angles.x, 0, 0)) * u52(u50.offsetspring.p), (u51(0, v134, 0) * u51(v135, 0, 0)) * u52(u50.offsetspring.p)) / u4;
         u50.angles = Vector3.new(v135, v134, 0);
         return;
     end
     local v136 = u50.zanglespring.p;
     local v137 = ((u51(0, u50.angles.y, 0) * u51(u50.angles.x, 0, 0)) * u52(u50.offsetspring.p)) * u52(p63);
     local v138, v139 = f_limitAnglesYX(v137, u50.minangle, u50.maxangle);
     local v140 = u53(u50.angles.y, v139);
     u50.delta = p63 / u4;
     u50.angles = Vector3.new(v138, v140, 0);
     local v141 = f_getOffsetAxisAngle(u51(0, v140, 0) * u51(v138, 0, 0), v137);
     u50.offsetspring.p = v141;
     u50.offsetspring.t = v141;
 end;
 local v142 = v3.mouse.onmousemove;
 local u54 = u1;
 local u55 = v12;
 local u56 = v10;
 local f_applylookdelta = f_applylookdelta;
 v142:connect(function(p64)
     --[[
         Name: (empty)
         Line: 559
         Upvalues: 
             [1] = u5
             [2] = u54
             [3] = u55
             [4] = u56
             [5] = f_applylookdelta
 
     --]]
     u5 = true;
     local v144;
     if (u54.directlookenabled and u54.directlook) then
         local v143 = ((u54.sensitivity * u54.sensitivitymult) * math.atan(math.tan((u54.basefov * u55) / 2) / ((2.718281828459045) ^ u54.magspring.p))) / (32 * u56);
         v144 = Vector3.new(((-v143) * p64.y) * u54.xinvert, (-v143) * p64.x, 0);
     else
         local v145 = ((u54.sensitivity * u54.sensitivitymult) * math.atan(math.tan((u54.basefov * u55) / 2) / ((2.718281828459045) ^ u54.magspring.p))) / (32 * u56);
         local v146 = ((u54.sensitivity * u54.sensitivitymult) * math.atan(math.tan((u54.basefov * u55) / 2))) / (32 * u56);
         local v147 = math.cos(u54.angles.x);
         v144 = Vector3.new(((-v145) * p64.y) * u54.xinvert, (-((v145 * (1 - ((1 - v147) ^ (v146 / v145)))) / v147)) * p64.x, 0);
     end
     f_applylookdelta(v144);
 end);
 local v148 = v3.controller.onintegralmove;
 local u57 = u1;
 local u58 = v12;
 local f_applylookdelta = f_applylookdelta;
 v148:connect(function(p65, p66)
     --[[
         Name: (empty)
         Line: 579
         Upvalues: 
             [1] = u6
             [2] = u5
             [3] = u7
             [4] = u57
             [5] = u58
             [6] = f_applylookdelta
 
     --]]
     u6 = true;
     u5 = true;
     local v149 = p65;
     local v150 = (((0.25 * u7) * u57.controllersens) * u57.controlleraimmult) * math.atan(math.tan((u57.basefov * u58) / 2) / ((2.718281828459045) ^ u57.magspring.p));
     f_applylookdelta((Vector3.new(((v150 * v149.y) * u57.controllerymult) * u57.xinvert, (-v150) * v149.x, 0)));
     local v151 = v149.magnitude;
     local t_magnitude_15 = v151;
     local v152 = u7;
     local v153 = u57.startspeed * v151;
     if (v152 <= v153) then
         u7 = u57.startspeed * t_magnitude_15;
     end
     if (u7 <= t_magnitude_15) then
         local v154 = u57.sensitivitymult;
         local t_aimsensitivity_16 = u57.aimsensitivity;
         if (v154 == t_aimsensitivity_16) then
             u7 = u7 + ((p66 * u57.controlleraimaccel) * t_magnitude_15);
         else
             u7 = u7 + ((p66 * u57.controlleraccel) * t_magnitude_15);
         end
     end
     local v155 = u7;
     if (t_magnitude_15 <= v155) then
         u7 = t_magnitude_15;
     end
 end);
 return u1;
 