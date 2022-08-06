-- Decompiled with the Synapse X Luau decompiler.
 --NOTE: Currently in beta! Not representative of final product.
 local v1 = {};
 v1.LocationName = "BensIceCream";
 local u1 = nil;
 local v2 = game:GetService("Players").LocalPlayer;
 local u2 = nil;
 local u3 = nil;
 local u4 = game:GetService("ReplicatedStorage"):WaitForChild("GameObjects"):WaitForChild("JobAssets"):WaitForChild("BensIceCream");
 local t_LocalPlayer_1 = v2;
 local f_getCup;
 f_getCup = function() -- [line 15] getCup
     --[[
         Upvalues: 
             [1] = u1
             [2] = t_LocalPlayer_1
     --]]
     local v3 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_1);
     local v4 = v3;
     local v5 = tostring(v3);
     if (v5 == "Ice Cream Cup") then
         return v4;
     end
 end;
 local t_LocalPlayer_2 = v2;
 local f_getBall;
 f_getBall = function() -- [line 22] getBall
     --[[
         Upvalues: 
             [1] = u1
             [2] = t_LocalPlayer_2
     --]]
     local v6 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_2);
     local v7 = v6;
     local v8 = tostring(v6);
     local v9;
     if (v8 == "Ice Cream Cup") then
         v9 = v7;
     else
         v9 = nil;
     end
     if (not v9) then
         return;
     end
     local t_Transparency_3 = v9:WaitForChild("Ball1").Transparency;
     if (t_Transparency_3 == 1) then
         return v9.Ball1;
     end
     local t_Transparency_4 = v9:WaitForChild("Ball2").Transparency;
     if (t_Transparency_4 == 1) then
         return v9.Ball2;
     end
     return false;
 end;
 local v10 = {
     "P_Order1",
     "P_Order2"
 };
 local v11 = {
     "P_OrderCorrect1",
     "P_OrderCorrect2",
     "P_OrderCorrect3",
     "P_OrderCorrect4",
     "P_OrderCorrect5",
     "P_OrderCorrect6",
     "P_OrderCorrect7",
     "P_OrderCorrect8",
     "P_OrderCorrect9",
     "P_OrderCorrect10",
     "P_OrderCorrect11",
     "P_OrderCorrect12",
     "P_OrderCorrect13",
     "P_OrderCorrect14",
     "P_OrderCorrect18",
     "P_OrderCorrect19"
 };
 local v12 = {
     "P_OrderWrong1",
     "P_OrderWrong2",
     "P_OrderWrong3",
     "P_OrderWrong4",
     "P_OrderWrong5",
     "P_OrderWrong6",
     "P_OrderWrong7",
     "P_OrderWrong8",
     "P_OrderWrong9",
     "P_OrderWrong10",
     "P_OrderWrong11",
     "P_OrderWrong12",
     "P_OrderWrong13",
     "P_OrderWrong14"
 };
 local u5 = {
     "P_Hello1",
     "P_Hello2",
     "P_Hello3",
     "P_Hello4",
     "P_Hello5",
     "P_Hello6",
     "P_Hello7",
     "P_Hello8"
 };
 local u6 = v10;
 local f_GetOrderPhrase;
 f_GetOrderPhrase = function(p1, p2) -- [line 41] GetOrderPhrase
     --[[
         Upvalues: 
             [1] = u1
             [2] = u5
             [3] = u6
     --]]
     return u1.Modules.TranslationHandler:Format(u5[math.random(#u5)]) .. ("\n" .. u1.Modules.TranslationHandler:Format(u6[math.random(#u6)]));
 end;
 v1.GetOrderPhrase = f_GetOrderPhrase;
 local f_isCorrect;
 f_isCorrect = function(p3, p4) -- [line 45] isCorrect
     --[[
         Upvalues: 
             [1] = u4
     --]]
     local v13 = true;
     local v14, v15, v16 = pairs(p4:GetChildren());
     local v17 = v14;
     local v18 = v15;
     local v19 = v16;
     while true do
         local v20, v21 = v17(v18, v19);
         local v22 = v20;
         local v23 = v21;
         if (v20) then
             break;
         end
         v19 = v22;
         local v24 = v23.Name:sub(1, 4);
         if (v24 == "Ball") then
             local v25 = tonumber(v23.Name:sub(5));
             if (not (v23.Transparency > 0)) then
                 local t_BrickColor_5 = v23.BrickColor;
                 if (t_BrickColor_5 == u4:WaitForChild(p3:WaitForChild("Flavor" .. v25)).Value) then
                     local t_Value_6 = p3.Topping.Value;
                     if (not ((t_Value_6 == "") and ((#v23:GetChildren()) > 1))) then
                         local t_Value_7 = p3.Topping.Value;
                         if ((t_Value_7 == "") or v23:findFirstChild(p3.Topping.Value)) then
                             continue;
                         end
                     end
                     v13 = false;
                     continue;
                 end
             end
             v13 = false;
         end
     end
     return v13;
 end;
 local t_LocalPlayer_8 = v2;
 local u7 = v1;
 local u8 = v11;
 local u9 = v12;
 local f_AddCustomer;
 f_AddCustomer = function(p5, p6, p7) -- [line 62] AddCustomer
     --[[
         Upvalues: 
             [1] = u1
             [2] = t_LocalPlayer_8
             [3] = u3
             [4] = u7
             [5] = u8
             [6] = u9
     --]]
     local v26 = u1.task.run;
     local u10 = p7;
     local u11 = p6;
     v26(function() -- [line 65] anonymous function
         --[[
             Upvalues: 
                 [1] = u10
                 [2] = u1
                 [3] = t_LocalPlayer_8
                 [4] = u3
                 [5] = u11
                 [6] = u7
                 [7] = u8
                 [8] = u9
         --]]
         local v27 = u10:WaitForChild(" ", 1);
         local v28 = v27;
         if (v27) then
             v28.Parent = nil;
         end
         local v29 = u10:WaitForChild("Order", 1);
         local v30 = v29;
         u1:AddJobInteraction(u10, {
             function() -- [line 72] anonymous function
                 --[[
                     Upvalues: 
                         [1] = u1
                         [2] = t_LocalPlayer_8
                         [3] = u3
                         [4] = u10
                         [5] = u11
                 --]]
                 local v31 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_8);
                 local v32 = v31;
                 local v33 = tostring(v31);
                 local v34;
                 if (v33 == "Ice Cream Cup") then
                     v34 = v32;
                 else
                     v34 = nil;
                 end
                 if (v34) then
                     return "I_Give", 0, function() -- [line 74] anonymous function
                         --[[
                             Upvalues: 
                                 [1] = u1
                                 [2] = t_LocalPlayer_8
                                 [3] = u3
                                 [4] = u10
                                 [5] = u11
                         --]]
                         local v35 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_8);
                         local v36 = v35;
                         local v37 = tostring(v35);
                         local v38;
                         if (v37 == "Ice Cream Cup") then
                             v38 = v36;
                         else
                             v38 = nil;
                         end
                         if (v38) then
                             u3 = u10;
                             u1.Shared.EquipmentService:UnequipItem(t_LocalPlayer_8, "Ice Cream Cup", true);
                             local v39 = u1.net;
                             local v40 = {};
                             v40.Type = "JobCompleted";
                             v40.Workstation = u11;
                             v39:FireServer(v40);
                         end
                     end;
                 end
             end
         });
         local v41 = u10:findFirstChild("Head");
         local v42 = v41;
         if (v29 and v41) then
             local v43 = u1:CreateChatBubble(v42, u7:GetOrderPhrase(v30), v28);
             v30.Changed:wait();
             u1:RemoveJobInteraction(u10);
             local v44 = v30.Value == "true";
             local v45 = v44;
             if (not v44) then
                 local t_Value_9 = v30.Value;
                 if (t_Value_9 == "false") then
                 end
             end
             if (v45 ~= nil) then
                 local t_SoundHandler_10 = u1.Modules.SoundHandler;
                 local v46;
                 if (v45) then
                     v46 = "Correct";
                 else
                     v46 = "Incorrect";
                 end
                 t_SoundHandler_10:Play(v46);
             end
             local v47 = false;
             local v48 = u1;
             local v49 = v43;
             local v50;
             if (v45) then
                 v50 = u8[math.random(#u8)];
                 if (not v50) then
                     v47 = true;
                 end
             else
                 v47 = true;
             end
             if (v47) then
                 v50 = u9[math.random(#u9)];
             end
             v48:UpdateChatBubble(v49, v50);
             u1.task.wait(1.5);
             u1:DestroyChatBubble(v43);
         end
     end);
 end;
 v1.AddCustomer = f_AddCustomer;
 v1.ShiftRadius = 15;
 local u12 = v1;
 local t_LocalPlayer_11 = v2;
 local u13 = u4;
 local f_StartShift;
 f_StartShift = function(p8) -- [line 116] StartShift
     --[[
         Upvalues: 
             [1] = u12
             [2] = u1
             [3] = t_LocalPlayer_11
             [4] = u13
             [5] = u2
     --]]
     local v51, v52, v53 = ipairs(u12.Model:WaitForChild("TableObjects"):GetChildren());
     local v54 = v51;
     local v55 = v52;
     local v56 = v53;
     while true do
         local v57, v58 = v54(v55, v56);
         local v59 = v57;
         local v60 = v58;
         if (v57) then
             break;
         end
         v56 = v59;
         local v61 = tostring(v60);
         if (v61 == "IceCreamCups") then
             u1:AddJobInteraction(v60, {
                 function() -- [line 121] anonymous function
                     --[[
                         Upvalues: 
                             [1] = u1
                     --]]
                     return "B_Take", 0, function() -- [line 122] anonymous function
                         --[[
                             Upvalues: 
                                 [1] = u1
                         --]]
                         u1.Modules.SoundHandler:Play("Pop");
                         u1:PlayTakeAnimation();
                         local v62 = u1.net;
                         local v63 = {};
                         v63.Type = "TakeIceCreamCup";
                         v62:FireServer(v63);
                     end;
                 end
             });
         else
             if (((v61 == "Vanilla") or (v61 == "Chocolate")) or (v61 == "Strawberry")) then
                 local v64 = u1;
                 local v65 = v60;
                 local v66 = {};
                 local u14 = v61;
                 local u15 = v60;
                 v66[1] = function() -- [line 130] anonymous function
                     --[[
                         Upvalues: 
                             [1] = u1
                             [2] = t_LocalPlayer_11
                             [3] = u14
                             [4] = u13
                             [5] = u15
                     --]]
                     local v67 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_11);
                     local v68 = v67;
                     local v69 = tostring(v67);
                     local v70;
                     if (v69 == "Ice Cream Cup") then
                         v70 = v68;
                     else
                         v70 = nil;
                     end
                     local v71;
                     if (v70) then
                         local t_Transparency_16 = v70:WaitForChild("Ball1").Transparency;
                         if (t_Transparency_16 == 1) then
                             v71 = v70.Ball1;
                         else
                             local t_Transparency_19 = v70:WaitForChild("Ball2").Transparency;
                             if (t_Transparency_19 == 1) then
                                 v71 = v70.Ball2;
                             else
                                 v71 = false;
                             end
                         end
                     else
                         v71 = nil;
                     end
                     if (v71) then
                         return "B_Add", 0, function() -- [line 132] anonymous function
                             --[[
                                 Upvalues: 
                                     [1] = u1
                                     [2] = t_LocalPlayer_11
                                     [3] = u14
                                     [4] = u13
                                     [5] = u15
                             --]]
                             local v72 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_11);
                             local v73 = v72;
                             local v74 = tostring(v72);
                             local v75;
                             if (v74 == "Ice Cream Cup") then
                                 v75 = v73;
                             else
                                 v75 = nil;
                             end
                             local v76;
                             if (v75) then
                                 local t_Transparency_17 = v75:WaitForChild("Ball1").Transparency;
                                 if (t_Transparency_17 == 1) then
                                     v76 = v75.Ball1;
                                 else
                                     local t_Transparency_18 = v75:WaitForChild("Ball2").Transparency;
                                     if (t_Transparency_18 == 1) then
                                         v76 = v75.Ball2;
                                     else
                                         v76 = false;
                                     end
                                 end
                             else
                                 v76 = nil;
                             end
                             if (v76) then
                                 local v77 = u1.net;
                                 local v78 = {};
                                 v78.Type = "AddIceCreamScoop";
                                 v78.Taste = u14;
                                 v78.Ball = v76;
                                 v77:FireServer(v78);
                                 v76.BrickColor = u13:WaitForChild(tostring(u15)).Value;
                                 v76.Transparency = 0;
                                 u1.Modules.SoundHandler:Play("Pop");
                                 u1:PlayTakeAnimation();
                             end
                         end;
                     end
                 end;
                 v64:AddJobInteraction(v65, v66);
             else
                 if (((v61 == "Sprinkles") or (v61 == "Caramel")) or (v61 == "Nuts")) then
                     local v79 = u1;
                     local v80 = v60;
                     local v81 = {};
                     local u16 = v61;
                     local u17 = v60;
                     v81[1] = function() -- [line 146] anonymous function
                         --[[
                             Upvalues: 
                                 [1] = u1
                                 [2] = t_LocalPlayer_11
                                 [3] = u16
                                 [4] = u13
                                 [5] = u17
                         --]]
                         local v82 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_11);
                         local v83 = v82;
                         local v84 = tostring(v82);
                         local v85;
                         if (v84 == "Ice Cream Cup") then
                             v85 = v83;
                         else
                             v85 = nil;
                         end
                         local v86;
                         if (v85) then
                             local t_Transparency_12 = v85:WaitForChild("Ball1").Transparency;
                             if (t_Transparency_12 == 1) then
                                 v86 = v85.Ball1;
                             else
                                 local t_Transparency_15 = v85:WaitForChild("Ball2").Transparency;
                                 if (t_Transparency_15 == 1) then
                                     v86 = v85.Ball2;
                                 else
                                     v86 = false;
                                 end
                             end
                         else
                             v86 = nil;
                         end
                         if (v86 == false) then
                             local v87 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_11);
                             local v88 = v87;
                             local v89 = tostring(v87);
                             local v90;
                             if (v89 == "Ice Cream Cup") then
                                 v90 = v88;
                             else
                                 v90 = nil;
                             end
                             local v91 = #v90:WaitForChild("Ball1"):GetChildren();
                             if (v91 < 1) then
                                 return "B_Add", 0, function() -- [line 148] anonymous function
                                     --[[
                                         Upvalues: 
                                             [1] = u1
                                             [2] = t_LocalPlayer_11
                                             [3] = u16
                                             [4] = u13
                                             [5] = u17
                                     --]]
                                     local v92 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_11);
                                     local v93 = v92;
                                     local v94 = tostring(v92);
                                     local v95;
                                     if (v94 == "Ice Cream Cup") then
                                         v95 = v93;
                                     else
                                         v95 = nil;
                                     end
                                     local v96 = u1.Shared.EquipmentService:GetEquipped(t_LocalPlayer_11);
                                     local v97 = v96;
                                     local v98 = tostring(v96);
                                     local v99;
                                     if (v98 == "Ice Cream Cup") then
                                         v99 = v97;
                                     else
                                         v99 = nil;
                                     end
                                     local v100;
                                     if (v99) then
                                         local t_Transparency_13 = v99:WaitForChild("Ball1").Transparency;
                                         if (t_Transparency_13 == 1) then
                                             v100 = v99.Ball1;
                                         else
                                             local t_Transparency_14 = v99:WaitForChild("Ball2").Transparency;
                                             if (t_Transparency_14 == 1) then
                                                 v100 = v99.Ball2;
                                             else
                                                 v100 = false;
                                             end
                                         end
                                     else
                                         v100 = nil;
                                     end
                                     if (v100 == false) then
                                         local v101 = #v95:WaitForChild("Ball1"):GetChildren();
                                         if (v101 < 1) then
                                             local v102 = u1.net;
                                             local v103 = {};
                                             v103.Type = "AddIceCreamTopping";
                                             v103.Taste = u16;
                                             v102:FireServer(v103);
                                             local v104 = u13:WaitForChild(tostring(u17)):GetChildren();
                                             local v105, v106, v107 = ipairs(v95:GetChildren());
                                             local v108 = v105;
                                             local v109 = v106;
                                             local v110 = v107;
                                             while true do
                                                 local v111, v112 = v108(v109, v110);
                                                 local v113 = v111;
                                                 local v114 = v112;
                                                 if (v111) then
                                                     break;
                                                 end
                                                 v110 = v113;
                                                 local v115 = tostring(v114):sub(1, 4);
                                                 if (v115 == "Ball") then
                                                     local v116, v117, v118 = pairs(v104);
                                                     local v119 = v116;
                                                     local v120 = v117;
                                                     local v121 = v118;
                                                     while true do
                                                         local v122, v123 = v119(v120, v121);
                                                         local v124 = v122;
                                                         local v125 = v123;
                                                         if (v122) then
                                                             break;
                                                         end
                                                         v121 = v124;
                                                         (v125:clone()).Parent = v114;
                                                     end
                                                 end
                                             end
                                             u1.Modules.SoundHandler:Play("Pop");
                                             u1:PlayTakeAnimation();
                                         end
                                     end
                                 end;
                             end
                         end
                     end;
                     v79:AddJobInteraction(v80, v81);
                 end
             end
         end
     end
     local v126, v127, v128 = ipairs(u2:GetChildren());
     local v129 = v126;
     local v130 = v127;
     local v131 = v128;
     while true do
         local v132, v133 = v129(v130, v131);
         local v134 = v132;
         local v135 = v133;
         if (v132) then
             break;
         end
         v131 = v134;
         local v136 = v135:WaitForChild("Occupied");
         local v137 = v136;
         if (v136.Value) then
             u12:AddCustomer(v135, v137.Value);
         end
         local v138 = u1;
         local v139 = v137.Changed;
         local u18 = v135;
         v138:AddJobTask(v139:connect(function(p9) -- [line 177] anonymous function
             --[[
                 Upvalues: 
                     [1] = u1
                     [2] = u12
                     [3] = u18
             --]]
             if (p9) then
                 u1.task.wait(1);
                 if (u1:IsWorking(script)) then
                     u12:AddCustomer(u18, p9);
                 end
             end
         end));
     end
 end;
 v1.StartShift = f_StartShift;
 local t_LocalPlayer_20 = v2;
 local f_EndShift;
 f_EndShift = function(p10) -- [line 190] EndShift
     --[[
         Upvalues: 
             [1] = u1
             [2] = t_LocalPlayer_20
     --]]
     u1.Shared.EquipmentService:UnequipItem(t_LocalPlayer_20, "Ice Cream Cup");
 end;
 v1.EndShift = f_EndShift;
 local u19 = v1;
 local f_Init;
 f_Init = function(p11, p12) -- [line 196] Init
     --[[
         Upvalues: 
             [1] = u1
             [2] = u2
             [3] = u19
     --]]
     u1 = p12;
     u2 = u19.Model:WaitForChild("CustomerTargets");
 end;
 v1.Init = f_Init;
 return v1;
 