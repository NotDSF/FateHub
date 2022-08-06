-- Decompiled with the Synapse X Luau decompiler.
 --NOTE: Currently in beta! Not representative of final product.
 local u1 = {};
 local t_LocalPlayer_1 = game:GetService("Players").LocalPlayer;
 local v1 = game:GetService("RunService");
 local v2 = workspace.CurrentCamera;
 local v3 = game:GetService("ReplicatedStorage");
 local v4 = script:WaitForChild("Assets");
 local u2 = script:FindFirstAncestorWhichIsA("ScreenGui");
 u1.JobsLoaded = false;
 local u3 = u2:WaitForChild("PaycheckFrame");
 local v5 = u2:WaitForChild("Bar"):WaitForChild("CharMenu"):WaitForChild("WorkFrame");
 local v6 = u2:WaitForChild("FindJobFrame");
 local f_GoToWork;
 f_GoToWork = function(p1, p2) -- [line 24] GoToWork
     --[[
         Upvalues:
             [1] = u1
     --]]
     if (not u1:GetJobModule(p2)) then
         return;
     end
     u1.Modules.LoadingHandler:ShowLoading("ToWork");
     if (u1:CanStartWorking(p2)) then
         local v7 = u1.Modules.CharacterHandler:GetRoot();
         u1.Modules.CharacterHandler:Detach();
         v7.Anchored = true;
         local v8 = u1.net;
         local v9 = {};
         v9.Type = "ToWork";
         v9.Name = tostring(p2);
         local v10 = v8:InvokeServer(v9);
         v7.Anchored = false;
     end
     u1.Modules.LoadingHandler:HideLoading("ToWork");
 end;
 u1.GoToWork = f_GoToWork;
 local f_TranslateLocation;
 f_TranslateLocation = function(p3, p4) -- [line 46] TranslateLocation
     --[[
         Upvalues: 
             [1] = u1
     --]]
     return tostring(u1.Modules.TranslationHandler:Format("T_Location" .. tostring(p4):gsub(" ", "")):gsub("[\r\n]+", " "));
 end;
 u1.TranslateLocation = f_TranslateLocation;
 local u4 = 0;
 local u5 = false;
 local f_findJob;
 f_findJob = function() -- [line 54] findJob
     --[[
         Upvalues: 
             [1] = u1
     --]]
     local v11 = {};
     local v12 = 0;
     local v13, v14, v15 = pairs(u1.Shared.JobData:GetOrderedData());
     local v16 = v13;
     local v17 = v14;
     local v18 = v15;
     while true do
         local v19, v20 = v16(v17, v18);
         local v21 = v19;
         local v22 = v20;
         if (v19) then
             break;
         end
         local v23 = false;
         v18 = v21;
         local v24 = u1.Modules.ClientStats:Get("Job/Jobs/" .. v22.Name);
         local v25 = v24;
         v12 = v12 + 1;
         local v26 = {};
         v26.Name = "T_Job" .. v22.Title;
         v26.Amount = v24;
         v26._job = v22.Name;
         local v27;
         if (v22.Location) then
             v27 = u1.Modules.TranslationHandler:Format("T_AtLocation", {u1:TranslateLocation(v22.Location)});
             if (not v27) then
                 v23 = true;
             end
         else
             v23 = true;
         end
         if (v23) then
             v27 = "";
         end
         v26._desc = v27 .. (" - " .. u1.Modules.TranslationHandler:Format("T_Level", {math.min(u1.Shared.JobData.MaxLevel, v25)}));
         v11[v12] = v26;
     end
     local v28 = u1.Modules.ListFrameHandler;
     local v29 = {};
     v29.Title = "B_GoToWork";
     v29.ButtonText = "B_Select";
     v29.NameSize = 28;
     local f_OnCreate;
     f_OnCreate = function(p5, p6) -- [line 79] OnCreate
         local v30 = p6.NameLabel;
         v30.Font = "SourceSansBold";
         v30.Position = UDim2.new(v30.Position.X.Scale, v30.Position.X.Offset, 0.5, -7);
         local v31 = v30:clone();
         v31.Font = "SourceSans";
         v31.Text = p5._desc;
         v31.Position = UDim2.new(v31.Position.X.Scale, v31.Position.X.Offset, 0.5, 12);
         v31.Size = UDim2.new(v31.Size.X.Scale, v31.Size.X.Offset, 0, 18);
         v31.Parent = p6;
     end;
     v29.OnCreate = f_OnCreate;
     local v32 = v28:ShowList(v29, v11);
     local v33 = v32;
     if (v32) then
         u1:GoToWork(v33._job);
     end
 end;
 findJob = f_findJob;
 local u6 = u1;
 local u7 = v6;
 local u8 = v1;
 local f_SelectJob;
 f_SelectJob = function(p7) -- [line 114] SelectJob
     --[[
         Upvalues: 
             [1] = u6
             [2] = u4
             [3] = u5
             [4] = u7
             [5] = u8
     --]]
     local v34 = false;
     local v35 = u6.Shared.JobData:GetOrderedData()[u4];
     local v36 = v35;
     local v37;
     if (v35) then
         v37 = v36.Name;
         if (not v37) then
             v34 = true;
         end
     else
         v34 = true;
     end
     if (v34) then
         v37 = nil;
     end
     u5 = false;
     u7:TweenPosition(UDim2.new(u7.Position.X.Scale, u7.Position.X.Offset, 1, 0), "In", "Quad", 1, true, function(p8) -- [line 122] anonymous function
         --[[
             Upvalues: 
                 [1] = u7
         --]]
         if (p8 == Enum.TweenStatus.Completed) then
             u7.Visible = false;
         end
     end);
     u8:UnbindFromRenderStep("JobSelection");
     u6.Modules.InputManager:HideTouchControls("FindJob", false);
     u6.Modules.InputManager:RemoveSelection("SelectJob");
     u6.Modules.InputManager:UnbindAction("SelectJob");
     u6.Modules.CameraHandler:TweenToChar(0);
     if (v37) then
         local v38 = u6.task.run;
         local u9 = v37;
         v38(function() -- [line 131] anonymous function
             --[[
                 Upvalues: 
                     [1] = u6
                     [2] = u9
             --]]
             u6:GoToWork(u9);
         end);
     end
     u6.Modules.MenuUI:SetAllState(true);
 end;
 u1.SelectJob = f_SelectJob;
 local u10 = u1;
 local u11 = v6;
 local u12 = v1;
 local t_CurrentCamera_2 = v2;
 local f_ShowJob;
 f_ShowJob = function(p9, p10) -- [line 136] ShowJob
     --[[
         Upvalues: 
             [1] = u5
             [2] = u10
             [3] = u4
             [4] = u11
             [5] = u12
             [6] = t_CurrentCamera_2
     --]]
     if (not u5) then
         return;
     end
     local v39 = u10.Shared.JobData:GetOrderedData();
     local v40 = u4;
     if (p10 == 0) then
         u4 = 0;
     else
         if (p10 >= 0) then
             local v41 = u4;
             local v42 = #v39;
             local v43;
             if (v42 < v41) then
                 v43 = 0;
             else
                 v43 = u4 + 1;
             end
             u4 = v43;
         else
             local v44 = false;
             local v45 = u4;
             local v46;
             if (v45 < 0) then
                 v46 = #v39;
                 if (not v46) then
                     v44 = true;
                 end
             else
                 v44 = true;
             end
             if (v44) then
                 v46 = u4 - 1;
             end
             u4 = v46;
         end
     end
     local v47 = v39[u4];
     local v48 = u11:WaitForChild("MainFrame");
     local v49 = v48;
     (v48:WaitForChild("WorkLabel")).Size = UDim2.new(10, 0, 0, v48.WorkLabel.Size.Y.Offset);
     local v50 = u10.Modules.GUIHandler.Colors.Main;
     (v48:WaitForChild("Select")).ImageColor3 = v50;
     (u11:WaitForChild("Next")).ImageColor3 = v50;
     (u11:WaitForChild("Back")).ImageColor3 = v50;
     u10.Modules.InputManager:AddSelection("SelectJob");
     u10.Modules.InputManager:BindAction("SelectJob", function(p11, p12, p13) -- [line 168] anonymous function
         --[[
             Upvalues: 
                 [1] = u10
         --]]
         if (p12 == Enum.UserInputState.End) then
             local t_Name_3 = p13.KeyCode.Name;
             if (((t_Name_3 == "DPadLeft") or (t_Name_3 == "Left")) or (t_Name_3 == "ButtonL1")) then
                 u10:ShowJob(-1);
                 return;
             end
             if (((t_Name_3 == "DPadRight") or (t_Name_3 == "Right")) or (t_Name_3 == "ButtonR1")) then
                 u10:ShowJob(1);
                 return;
             end
             u10:SelectJob();
         end
     end, Enum.KeyCode.Return, Enum.KeyCode.ButtonA, Enum.KeyCode.DPadLeft, Enum.KeyCode.Left, Enum.KeyCode.DPadRight, Enum.KeyCode.Right, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1);
     u12:UnbindFromRenderStep("JobSelection");
     if (u4 >= 0) then
         local v51 = false;
         (v49:WaitForChild("WorkLabel")).Text = u10.Modules.TranslationHandler:Format("T_Job" .. v47.Title);
         local v52 = v49:WaitForChild("LocationLabel");
         local v53;
         if (v47.Location) then
             v53 = u10.Modules.TranslationHandler:Format("T_AtLocation", {u10:TranslateLocation(v47.Location)});
             if (not v53) then
                 v51 = true;
             end
         else
             v51 = true;
         end
         if (v51) then
             v53 = "";
         end
         v52.Text = v53;
         local v54 = v49:WaitForChild("Select"):WaitForChild("TextLabel");
         local t_TranslationHandler_4 = u10.Modules.TranslationHandler;
         local v55 = u10:GetJob();
         local v56;
         if (v55 == v47.Name) then
             v56 = "B_Cancel";
         else
             v56 = "B_Select";
         end
         v54.Text = t_TranslationHandler_4:Format(v56);
         local v57 = u10.task.run;
         local u13 = v47;
         local u14 = p10;
         local u15 = v40;
         v57(function() -- [line 190] anonymous function
             --[[
                 Upvalues: 
                     [1] = u10
                     [2] = u13
                     [3] = u14
                     [4] = u15
                     [5] = u12
                     [6] = t_CurrentCamera_2
             --]]
             local v58 = u10:GetJobModule(u13.Name);
             local v59 = v58;
             if (not v58) then
                 return;
             end
             local v60 = false;
             local t_CFrame_5 = v59.Model:WaitForChild("CameraPoint_" .. tostring(u13.Name)).CFrame;
             local v61 = u14;
             if (v61 == 0) then
                 v60 = true;
             else
                 local v62 = u15;
                 if (v62 == 0) then
                     v60 = true;
                 else
                     u10.Modules.CameraHandler:Tween(t_CFrame_5, 0);
                 end
             end
             if (v60) then
                 u10.Modules.CameraHandler:TweenFromChar(t_CFrame_5, 0);
             end
             local v63 = t_CFrame_5 - t_CFrame_5.p;
             local u16 = CFrame.new(t_CFrame_5.p);
             local v64 = u12;
             local u17 = v63;
             v64:BindToRenderStep("JobSelection", 10000, function() -- [line 205] anonymous function
                 --[[
                     Upvalues: 
                         [1] = t_CurrentCamera_2
                         [2] = u16
                         [3] = u17
                 --]]
                 t_CurrentCamera_2.CoordinateFrame = (u16 * CFrame.Angles(0, math.sin(tick() * 0.1) * 0.2, 0)) * u17;
             end);
         end);
     else
         (v49:WaitForChild("WorkLabel")).Text = u10.Modules.TranslationHandler:Format("T_Unemployed");
         (v49:WaitForChild("LocationLabel")).Text = "";
         (v49:WaitForChild("Select"):WaitForChild("TextLabel")).Text = u10.Modules.TranslationHandler:Format("B_Select");
         u10.task.run(u10.Modules.CameraHandler.TweenToChar, nil, 0);
     end
     v49.WorkLabel.Size = UDim2.new(0, v49.WorkLabel.TextBounds.X, 0, v49.WorkLabel.Size.Y.Offset);
     v49.LocationLabel.Size = UDim2.new(1, -(v49.WorkLabel.AbsoluteSize.X + 7), 0, v49.LocationLabel.Size.Y.Offset);
 end;
 u1.ShowJob = f_ShowJob;
 local f_createPaycheck;
 f_createPaycheck = function(p14, p15) -- [line 224] createPaycheck
     --[[
         Upvalues: 
             [1] = u3
             [2] = u1
             [3] = t_LocalPlayer_1
             [4] = u2
     --]]
     local v65 = false;
     local v66 = u3:clone();
     local v67 = v66;
     v66.Position = UDim2.new(0.5, 0, 1, 0);
     v66.Overlay.BackgroundTransparency = 1;
     local v68 = v66.Close;
     local t_Close_6 = v68;
     v68.ImageColor3 = u1.Modules.GUIHandler.Colors.NeutralLight;
     u1.Modules.GUIHandler:RoundedButtonEffect(v68);
     local v69 = tonumber(p14) or 0;
     p14 = v69;
     local v70 = u1.Shared.JobData:GetJob(p15);
     local v71 = v70;
     v66:WaitForChild("CheckMain").AmountLabel.Text = u1.Modules.TranslationHandler:Format("T_Number", {
         v69
     });
     local t_TypeLabel_7 = v66.CheckMain.TypeLabel;
     local v72;
     if (v70 and v70.Title) then
         v72 = u1.Modules.TranslationHandler:Format("T_ForWorkingAs", {u1.Modules.TranslationHandler:Format("T_Job" .. v71.Title)});
         if (not v72) then
             v65 = true;
         end
     else
         v65 = true;
     end
     if (v65) then
         v72 = u1.Modules.TranslationHandler:Format("T_ForWorking");
     end
     t_TypeLabel_7.Text = v72;
     v67.CheckMain.ToLabel.Text = tostring(u1.Modules.TranslationHandler:GetPlayerName(t_LocalPlayer_1));
     v67.CheckMain.AmountTextLabel.Text = u1.Shared.TextModule:TitleCase(u1.Modules.TranslationHandler:ToWords(p14));
     if (v71) then
         local v73 = v67.CheckMain.Dot:clone();
         local v74 = v73;
         v73.Size = UDim2.new(1, 0, 1, 0);
         v73.AnchorPoint = Vector2.new(0, 0);
         local v75 = 1;
         local v76 = v71.ID - 1;
         local v77 = v76;
         local v78 = v75;
         if (not (v76 <= v78)) then
             while true do
                 local v79 = v74:clone();
                 v79.Position = UDim2.new(0, -5 * v75, 0, 0);
                 v79.Parent = v67.CheckMain.Dot;
                 local v80 = v75 + 1;
                 v75 = v80;
                 local v81 = v77;
                 if (v81 < v80) then
                     break;
                 end
             end
         end
         v74:Destroy();
     end
     v67.CheckMain.DateLabel.Text = u1.Modules.TranslationHandler:Format("T_ShortDate", {os.time()});
     v67.TitleLabel.Text = u1.Modules.TranslationHandler:Format("T_Paycheck");
     t_Close_6.TextLabel.Text = u1.Modules.TranslationHandler:Format("B_PaycheckClaim");
     v67.Parent = u2;
     v67.Visible = true;
     v67.Overlay.Modal = true;
     u1.Modules.SoundHandler:Play("Paycheck");
     u1.Modules.InputManager:AddSelection("Paycheck");
     u1.Modules.InputManager:HideTouchControls("Paycheck", true);
     local v82 = u1.Shared.Interpolate;
     local u18 = v67;
     v82:new(0.5, "In", "Quad", function(p16) -- [line 277] anonymous function
         --[[
             Upvalues: 
                 [1] = u18
         --]]
         u18.Overlay.BackgroundTransparency = 1 - (0.5 * p16);
         u18.Position = UDim2.new(0.5, 0, 1 - (0.5 * p16), 0);
         u18.AnchorPoint = Vector2.new(0.5, 0.5 * p16);
     end);
     local u19 = false;
     local u20 = v67;
     local f_close;
     f_close = function() -- [line 284] close
         --[[
             Upvalues: 
                 [1] = u19
                 [2] = u1
                 [3] = u20
         --]]
         if (u19) then
             return;
         end
         u19 = true;
         u1.Modules.InputManager:RemoveSelection("Paycheck");
         u1.Modules.InputManager:UnbindAction("Paycheck");
         u20.Overlay.Modal = false;
         u1.Modules.SoundHandler:Play("MoneyEarned");
         u1.Shared.Interpolate:new(0.5, "Out", "Quad", function(p17) -- [line 293] anonymous function
             --[[
                 Upvalues: 
                     [1] = u20
             --]]
             u20.Overlay.BackgroundTransparency = 0.5 + (0.5 * p17);
             u20.Position = UDim2.new(0.5, 0, 0.5 + (0.5 * p17), 0);
             u20.AnchorPoint = Vector2.new(0.5, 0.5 - (0.5 * p17));
         end);
         u1.Modules.InputManager:HideTouchControls("Paycheck", false);
         u20:Destroy();
     end;
     local v83 = u1.Modules.InputManager;
     local f_close = f_close;
     v83:BindAction("Paycheck", function(p18, p19, p20) -- [line 304] anonymous function
         --[[
             Upvalues: 
                 [1] = f_close
         --]]
         if (p19 == Enum.UserInputState.End) then
             f_close();
         end
     end, Enum.KeyCode.Backspace, Enum.KeyCode.Return, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonA);
     v67.Overlay.Activated:connect(f_close);
     t_Close_6.Activated:connect(f_close);
 end;
 createPaycheck = f_createPaycheck;
 local f_ShowPaycheck;
 f_ShowPaycheck = function(p21, ...) -- [line 315] ShowPaycheck
     --[[
         Upvalues: 
             [1] = u1
     --]]
     return u1.Modules.GUIHandler:Queue(createPaycheck, nil, ...);
 end;
 u1.ShowPaycheck = f_ShowPaycheck;
 local u21 = {};
 local f_UpdateChatBubble;
 f_UpdateChatBubble = function(p22, p23, p24, p25) -- [line 323] UpdateChatBubble
     --[[
         Upvalues: 
             [1] = u1
     --]]
     local v84 = p23:WaitForChild("Body", 1);
     local v85 = v84;
     if (not v84) then
         return;
     end
     local v86 = v85:findFirstChild("TextLabel");
     local v87 = v86;
     local v88 = v85:findFirstChild("IconFrame");
     local v89 = v88;
     v86.Text = u1.Modules.TranslationHandler:CheckFormat(p24);
     local v90, v91, v92 = ipairs(v88:GetChildren());
     local v93 = v90;
     local v94 = v91;
     local v95 = v92;
     while true do
         local v96, v97 = v93(v94, v95);
         local v98 = v96;
         local v99 = v97;
         if (v96) then
             break;
         end
         v95 = v98;
         local v100 = tostring(v99);
         if ((not ((v100 == "Plus") or (v100 == "Icon"))) and v99:IsA("GuiBase2d")) then
             v99:Destroy();
         end
     end
     if (p25) then
         v87.Size = UDim2.new(0.95, 0, 0.53, 0);
         local v101 = typeof(p25);
         if (v101 == "Instance") then
             p25.Parent = v89;
             p25.Visible = true;
         else
             local v102 = type(p25);
             if (v102 == "table") then
                 local v103, v104, v105 = ipairs(p25);
                 local v106 = v103;
                 local v107 = v104;
                 local v108 = v105;
                 while true do
                     local v109, v110 = v106(v107, v108);
                     local v111 = v109;
                     local v112 = v110;
                     if (v109) then
                         break;
                     end
                     local v113 = false;
                     local v114 = false;
                     v108 = v111;
                     local v115 = v89.Icon:clone();
                     local v116 = type(v112);
                     if (v116 == "string") then
                         local v117 = v112:sub(1, 6);
                         if (v117 == "Color_") then
                             v115.Image = "rbxassetid://2132263837";
                             v115.ImageColor3 = BrickColor.new(v112:sub(7)).Color;
                             v115.Size = UDim2.new(0.8, 0, 0.8, 0);
                             v114 = true;
                         else
                             v113 = true;
                         end
                     else
                         v113 = true;
                     end
                     if (v113) then
                         v115.Image = "rbxassetid://" .. v112;
                         v114 = true;
                     end
                     if (v114) then
                         v115.Name = v111 .. "Icon";
                         v115.Visible = true;
                         v115.Parent = v89;
                         if (v111 >= 1) then
                             local v118 = v89.Plus:clone();
                             v118.Name = v111;
                             v118.Visible = true;
                             v118.Parent = v89;
                         end
                     end
                 end
             end
         end
         v89.Visible = true;
     else
         v87.Size = UDim2.new(0.95, 0, 0.9, 0);
         v89.Visible = false;
     end
     local v119 = p23.Size.X.Scale / 5;
     local v120;
     if (p25) then
         v120 = 3;
     else
         v120 = 2;
     end
     local v121 = p23.Size.Y.Scale;
     local v122 = u1.Shared.Interpolate;
     local u22 = v119;
     local u23 = p23;
     local t_Scale_8 = v121;
     local u24 = v120;
     v122:new(0.3, "Out", "Quad", function(p26) -- [line 382] anonymous function
         --[[
             Upvalues: 
                 [1] = u22
                 [2] = u23
                 [3] = t_Scale_8
                 [4] = u24
         --]]
         local v123 = u22 + ((1 - u22) * p26);
         u23.Size = UDim2.new(5 * v123, 0, t_Scale_8 + ((u24 - t_Scale_8) * p26), 0);
         u23.StudsOffset = Vector3.new(0, (1.25 + (u23.Size.Y.Scale * 0.5)) * v123, 0);
     end, true);
 end;
 u1.UpdateChatBubble = f_UpdateChatBubble;
 local u25 = v4;
 local u26 = u1;
 local f_CreateChatBubble;
 f_CreateChatBubble = function(p27, p28, p29, p30) -- [line 390] CreateChatBubble
     --[[
         Upvalues: 
             [1] = u25
             [2] = u26
             [3] = u21
     --]]
     local v124 = u25:findFirstChild("ChatBubble"):clone();
     v124.Size = UDim2.new(0, 0, 0, 0);
     v124.StudsOffset = Vector3.new(0, 0, 0);
     u26:UpdateChatBubble(v124, p29, p30);
     v124.Enabled = true;
     v124.Parent = p28;
     u21[v124] = true;
     return v124;
 end;
 u1.CreateChatBubble = f_CreateChatBubble;
 local u27 = u1;
 local f_DestroyChatBubble;
 f_DestroyChatBubble = function(p31, p32) -- [line 407] DestroyChatBubble
     --[[
         Upvalues: 
             [1] = u21
             [2] = u27
     --]]
     u21[p32] = nil;
     local v125 = u27.task.run;
     local u28 = p32;
     v125(function() -- [line 411] anonymous function
         --[[
             Upvalues: 
                 [1] = u28
                 [2] = u27
         --]]
         local v126 = u28.Size.Y.Scale;
         local v127 = u27.Shared.Interpolate;
         local t_Scale_9 = v126;
         v127:new(0.3, "In", "Quad", function(p33) -- [line 413] anonymous function
             --[[
                 Upvalues: 
                     [1] = u28
                     [2] = t_Scale_9
             --]]
             local v128 = 1 - p33;
             p33 = v128;
             u28.Size = UDim2.new(5 * v128, 0, t_Scale_9 * v128, 0);
             u28.StudsOffset = Vector3.new(0, (1.25 + (u28.Size.Y.Scale * 0.5)) * v128, 0);
         end);
         u28:Destroy();
     end);
 end;
 u1.DestroyChatBubble = f_DestroyChatBubble;
 local f_PlayTakeAnimation;
 f_PlayTakeAnimation = function(p34) -- [line 423] PlayTakeAnimation
     --[[
         Upvalues: 
             [1] = u1
     --]]
     local v129 = u1.Shared.AnimationService:PlayAnimation(u1.Modules.CharacterHandler:GetCharacter(), "TakeItem");
     local v130 = u1.task.delay;
     local v131 = v129.Fade;
     local u29 = v129;
     v130(v131, function() -- [line 425] anonymous function
         --[[
             Upvalues: 
                 [1] = u1
                 [2] = u29
         --]]
         u1.Shared.AnimationService:StopAnimation(u1.Modules.CharacterHandler:GetCharacter(), u29.Name);
     end);
 end;
 u1.PlayTakeAnimation = f_PlayTakeAnimation;
 local u30 = {};
 local f_GetJobModules;
 f_GetJobModules = function(p35) -- [line 435] GetJobModules
     --[[
         Upvalues: 
             [1] = u30
     --]]
     return u30;
 end;
 u1.GetJobModules = f_GetJobModules;
 local f_GetJobModule;
 f_GetJobModule = function(p36, p37) -- [line 439] GetJobModule
     --[[
         Upvalues: 
             [1] = u30
     --]]
     local v132 = u30[p37];
     local v133 = v132;
     if (((not v132) and p37) and (not (p37 == ""))) then
         warn("No job module for " .. tostring(p37));
     end
     return v133;
 end;
 u1.GetJobModule = f_GetJobModule;
 local f_GetCurJobModule;
 f_GetCurJobModule = function(p38) -- [line 449] GetCurJobModule
     --[[
         Upvalues: 
             [1] = u1
     --]]
     return u1:GetJobModule(u1:GetJob());
 end;
 u1.GetCurJobModule = f_GetCurJobModule;
 local f_CanUseWorkstation;
 f_CanUseWorkstation = function(p39, p40, p41) -- [line 454] CanUseWorkstation
     local v134 = false;
     local v135 = p40:WaitForChild("InUse");
     local v136 = v135;
     local v137;
     if (v135.Value) then
         v137 = true;
         local t_Value_10 = v136.Value;
         if (t_Value_10 ~= p41) then
             v134 = true;
         end
     else
         v134 = true;
     end
     if (v134) then
         v137 = not v136.Value;
     end
     return v137;
 end;
 u1.CanUseWorkstation = f_CanUseWorkstation;
 local u31 = "";
 local f_GetJob;
 f_GetJob = function(p42) -- [line 464] GetJob
     --[[
         Upvalues: 
             [1] = u31
     --]]
     return u31;
 end;
 u1.GetJob = f_GetJob;
 local u32 = 0;
 local f_IsWorking;
 f_IsWorking = function(p43, p44) -- [line 470] IsWorking
     --[[
         Upvalues: 
             [1] = u1
     --]]
     local v138 = false;
     local v139;
     if (p44) then
         v138 = true;
     else
         v139 = true;
         local t_Value_11 = u1._jobValue.Value;
         if (t_Value_11 == "") then
             v138 = true;
         end
     end
     if (v138) then
         v139 = u1._jobValue.Value == tostring(p44);
     end
     return v139;
 end;
 u1.IsWorking = f_IsWorking;
 local f_SetWorking;
 f_SetWorking = function(p45, p46) -- [line 474] SetWorking
     --[[
         Upvalues: 
             [1] = u1
     --]]
     u1._jobValue.Value = p46 or "";
 end;
 u1.SetWorking = f_SetWorking;
 local u33 = nil;
 local u34 = nil;
 local f_AddJobTask;
 f_AddJobTask = function(p47, p48) -- [line 481] AddJobTask
     --[[
         Upvalues: 
             [1] = u33
     --]]
     assert(u33, "AddJobTask: Maid required!");
     u33:GiveTask(p48);
 end;
 u1.AddJobTask = f_AddJobTask;
 local u35 = u1;
 local f_AddJobInteraction;
 f_AddJobInteraction = function(p49, p50, p51) -- [line 487] AddJobInteraction
     --[[
         Upvalues: 
             [1] = u34
             [2] = u35
     --]]
     assert(u34, "AddJobTask: JobInteractionObjects table required!");
     table.insert(u34, p50);
     u35.Modules.InteractionHandler:AddInteraction(p50, p51);
 end;
 u1.AddJobInteraction = f_AddJobInteraction;
 local u36 = u1;
 local f_RemoveJobInteraction;
 f_RemoveJobInteraction = function(p52, p53) -- [line 494] RemoveJobInteraction
     --[[
         Upvalues: 
             [1] = u34
             [2] = u36
     --]]
     if (u34) then
         local v140, v141, v142 = ipairs(u34);
         local v143 = v140;
         local v144 = v141;
         local v145 = v142;
         while true do
             local v146, v147 = v143(v144, v145);
             local v148 = v146;
             local v149 = v147;
             if (v146) then
                 return;
             end
             v145 = v148;
             if (v149 == p53) then
                 u36.Modules.InteractionHandler:RemoveInteraction(p53);
                 table.remove(u34, v148);
                 return true;
             end
         end
     else
         return;
     end
 end;
 u1.RemoveJobInteraction = f_RemoveJobInteraction;
 local u37 = u1;
 local u38 = v5;
 local u39 = t_LocalPlayer_1;
 local f_startedWorking;
 f_startedWorking = function(p54) -- [line 510] startedWorking
     --[[
         Upvalues: 
             [1] = u33
             [2] = u37
             [3] = u34
             [4] = u38
             [5] = u32
             [6] = u39
     --]]
     if (not p54) then
         return;
     end
     if (p54.AreaBlock) then
         p54.AreaBlock.Parent = p54.Script;
     end
     if (u33) then
         u33:DoCleaning();
     end
     local v150 = false;
     u33 = u37.maid.new();
     u34 = {};
     u37:AddJobTask(function() -- [line 527] anonymous function
         --[[
             Upvalues: 
                 [1] = u34
                 [2] = u37
         --]]
         local v151, v152, v153 = pairs(u34);
         local v154 = v151;
         local v155 = v152;
         local v156 = v153;
         while true do
             local v157, v158 = v154(v155, v156);
             local v159 = v157;
             local v160 = v158;
             if (v157) then
                 break;
             end
             v156 = v159;
             u37.Modules.InteractionHandler:RemoveInteraction(v160);
         end
         u34 = nil;
     end);
     local v161 = u37.Shared.JobData:GetJob(p54.Name);
     local v162 = v161;
     assert(v161, "No JobData for " .. tostring(p54.Name));
     local v163 = u37._jobValue:WaitForChild("Jobs"):WaitForChild(p54.Name);
     (u38:WaitForChild("WorkFrame")).Visible = true;
     (u38:WaitForChild("NoWorkFrame")).Visible = false;
     local v164 = u37.Modules.TranslationHandler:Format("T_Job" .. v161.Title);
     local v165;
     if (v161.Location) then
         v165 = u37.Modules.TranslationHandler:Format("T_AtLocation", {u37:TranslateLocation(v162.Location)});
         if (not v165) then
             v150 = true;
         end
     else
         v150 = true;
     end
     if (v150) then
         v165 = "";
     end
     (u38.WorkFrame:WaitForChild("WorkLabel")).Text = v164 .. ('<font face="SourceSans" size="24"> ' .. (v165 .. "</font>"));
     local v166 = v163:WaitForChild("Progress");
     local u40 = math.huge;
     local u41 = v163;
     local u42 = v166;
     local f_updatePromotion;
     f_updatePromotion = function() -- [line 556] updatePromotion
         --[[
             Upvalues: 
                 [1] = u37
                 [2] = u41
                 [3] = u38
                 [4] = u42
                 [5] = u40
         --]]
         local v167 = u37.Shared.JobData:GetRequiredPromotionProgress(u41.Value);
         local v168 = u38:WaitForChild("WorkFrame"):WaitForChild("PromotionBar");
         local v169 = v168;
         local v170 = v168:WaitForChild("BarFront");
         local v171 = v168:WaitForChild("BarBack");
         local v172 = u41.Value;
         local t_MaxLevel_12 = u37.Shared.JobData.MaxLevel;
         local v173;
         if (t_MaxLevel_12 < v172) then
             v173 = 1;
             (v170:WaitForChild("ImageLabel")).ImageColor3 = Color3.new(1, 0.7333333333333333, 0);
             v169.Value.Visible = false;
             v169.Star.Visible = true;
         else
             local t_Value_17 = u41.Value;
             if (t_Value_17 == 0) then
                 v173 = 0;
                 (v170:WaitForChild("ImageLabel")).ImageColor3 = Color3.new(0.8627450980392157, 0.8627450980392157, 0.8627450980392157);
                 v169.Value.Visible = false;
                 v169.Star.Visible = false;
             else
                 v173 = u42.Value / v167;
                 (v170:WaitForChild("ImageLabel")).ImageColor3 = u37.Modules.GUIHandler.Colors.Main;
                 v169.Value.Visible = true;
                 v169.Star.Visible = false;
             end
         end
         v169.Level.Text = u37.Modules.TranslationHandler:Format("T_Level", {math.min(u37.Shared.JobData.MaxLevel, u41.Value)});
         v169.Value.Text = tostring(u42.Value) .. ("/" .. tostring(v167));
         local v174, v175, v176 = v170.ImageLabel.ImageColor3:ToHSV();
         v171.ImageLabel.ImageColor3 = Color3.fromHSV(v174, v175, v176 * 0.8);
         v170.Size = UDim2.new(v173, 0, 1, 0);
         v171.Size = UDim2.new(1.01 - v173, 0, 1, 0);
         (u38.WorkFrame.PromotionBar:WaitForChild("TitleLabel")).Text = u37.Modules.TranslationHandler:Format("T_PromotionProgress");
         local v177 = u41.Value;
         local v178 = u40;
         if (v178 <= v177) then
             local t_Value_13 = u41.Value;
             if ((t_Value_13 < u37.Shared.JobData.MaxLevel) and u37.Modules.ClientStats:Get("IsPlaying")) then
                 u37.task.run(function() -- [line 600] anonymous function
                     --[[
                         Upvalues: 
                             [1] = u37
                             [2] = u41
                     --]]
                     local t_GUIHandler_14 = u37.Modules.GUIHandler;
                     local t_TranslationHandler_15 = u37.Modules.TranslationHandler;
                     local t_Value_16 = u41.Value;
                     local v179;
                     if (t_Value_16 == u37.Shared.JobData.MaxLevel) then
                         v179 = "T_MaxPromotion";
                     else
                         v179 = "T_Promotion";
                     end
                     t_GUIHandler_14:Glow(t_TranslationHandler_15:Format(v179), u37.Modules.TranslationHandler:Format("T_Congrats"), 338835471, "SkillIncreased");
                 end);
             end
         end
         u40 = math.max(1, u41.Value);
     end;
     f_updatePromotion();
     u37:AddJobTask(v163.Changed:connect(f_updatePromotion));
     u37:AddJobTask(v166.Changed:connect(f_updatePromotion));
     (u38:WaitForChild("WorkFrame"):WaitForChild("Buttons"):WaitForChild("Action"):WaitForChild("TextLabel")).Text = u37.Modules.TranslationHandler:Format("B_EndShift");
     u38.WorkFrame.Buttons.Action.ImageColor3 = u37.Modules.GUIHandler.Colors.Main;
     (u38.WorkFrame:WaitForChild("EarningsLabel")).Visible = true;
     u38.WorkFrame.EarningsLabel.Text = u37.Modules.TranslationHandler:Format("T_ShiftEarn") .. " ";
     u38.WorkFrame.EarningsLabel.Size = UDim2.new(0, u38.WorkFrame.EarningsLabel.TextBounds.X, 0, u38.WorkFrame.EarningsLabel.Size.Y.Offset);
     (u38.WorkFrame.EarningsLabel:WaitForChild("TextLabel")).Text = u37.Modules.TranslationHandler:FormatCurrency(0, "$");
     (u38.WorkFrame:WaitForChild("TimeLabel")).Visible = true;
     (u38.WorkFrame.TimeLabel:WaitForChild("TextLabel")).Text = "??";
     u38.WorkFrame.TimeLabel.Text = u37.Modules.TranslationHandler:Format("T_ShiftTime") .. " ";
     u38.WorkFrame.TimeLabel.Size = UDim2.new(0, u38.WorkFrame.TimeLabel.TextBounds.X, 0, u38.WorkFrame.TimeLabel.Size.Y.Offset);
     (u38.WorkFrame:WaitForChild("GamepassPurchase")).Visible = not u37.Shared.ProductService:OwnsAsset("Excellent Employee");
     (u38.WorkFrame.GamepassPurchase:WaitForChild("TextLabel")).Text = u37.Modules.TranslationHandler:Format("B_IncreaseEarnings");
     u38.WorkFrame.GamepassPurchase.ImageColor3 = u37.Modules.GUIHandler.Colors.Main;
     local v180 = u32 + 1;
     u32 = v180;
     local v181 = tick();
     local v182 = p54.ShiftLoop;
     local v183 = p54.ShiftRadius;
     local u43 = nil;
     local v184 = u37.Shared.TimeService:GetTimeValue().Changed;
     local u44 = v181;
     local u45 = v180;
     local t_ShiftRadius_18 = v183;
     local u46 = p54;
     local t_ShiftLoop_19 = v182;
     u43 = v184:connect(function() -- [line 639] anonymous function
         --[[
             Upvalues: 
                 [1] = u38
                 [2] = u37
                 [3] = u44
                 [4] = u45
                 [5] = u32
                 [6] = u43
                 [7] = t_ShiftRadius_18
                 [8] = u46
                 [9] = t_ShiftLoop_19
         --]]
         (u38:WaitForChild("WorkFrame"):WaitForChild("TimeLabel"):WaitForChild("TextLabel")).Text = u37.Modules.TranslationHandler:DisplayExactDuration(tick() - u44);
         if (u37:IsWorking()) then
             local v185 = u45;
             if (v185 == u32) then
                 if (t_ShiftRadius_18) then
                     local v186 = u37.Modules.CharacterHandler:GetRoot(true);
                     local v187 = v186;
                     if (v186) then
                         local v188 = (u46.AreaBlock.Position - v187.Position).magnitude;
                         local v189 = t_ShiftRadius_18;
                         if (v189 <= v188) then
                         end
                     end
                     u43:Disconnect();
                     u37.task.run(function() -- [line 655] anonymous function
                         --[[
                             Upvalues: 
                                 [1] = u37
                         --]]
                         u37:StopWorking();
                     end);
                     u37.Modules.GUIHandler:AlertBox("E_LeftWorkplace");
                     return;
                 end
                 if (t_ShiftLoop_19) then
                     local v190 = t_ShiftLoop_19(u46);
                     if (v190 == false) then
                         u37:StopWorking();
                         return;
                     end
                 end
                 return;
             end
         end
         u43:Disconnect();
     end);
     u37:AddJobTask(u43);
     if (p54.RequiredEquipment) then
         local v191 = u37;
         local v192 = u37.Shared.EquipmentService:GetEquippedValue(u39).Changed;
         local u47 = p54;
         v191:AddJobTask(v192:connect(function(p55) -- [line 674] anonymous function
             --[[
                 Upvalues: 
                     [1] = u47
                     [2] = u37
             --]]
             local v193 = tostring(p55);
             if (v193 ~= u47.RequiredEquipment) then
                 u37:StopWorking();
             end
         end));
     end
     p54:StartShift();
 end;
 local u48 = v5;
 local u49 = u1;
 local u50 = t_LocalPlayer_1;
 local f_stoppedWorking;
 f_stoppedWorking = function(p56) -- [line 684] stoppedWorking
     --[[
         Upvalues: 
             [1] = u33
             [2] = u48
             [3] = u21
             [4] = u49
             [5] = u50
     --]]
     if (u33) then
         u33:DoCleaning();
         u33 = nil;
     end
     (u48:WaitForChild("WorkFrame")).Visible = false;
     (u48:WaitForChild("NoWorkFrame")).Visible = true;
     local v194 = u21;
     u21 = {};
     local v195, v196, v197 = pairs(v194);
     local v198 = v195;
     local v199 = v196;
     local v200 = v197;
     while true do
         local v201 = v198(v199, v200);
         local v202 = v201;
         if (v201) then
             break;
         end
         v200 = v202;
         u49:DestroyChatBubble(v202);
     end
     if (not p56) then
         return;
     end
     if (p56.AreaBlock) then
         p56.AreaBlock.Parent = p56.Model;
     end
     if (p56.RequiredEquipment) then
         u49.Shared.EquipmentService:UnequipItem(u50, p56.RequiredEquipment);
     end
     p56:EndShift();
 end;
 local u51 = u1;
 local f_stoppedWorking = f_stoppedWorking;
 local f_startedWorking = f_startedWorking;
 local f_jobChanged;
 f_jobChanged = function() -- [line 721] jobChanged
     --[[
         Upvalues: 
             [1] = u51
             [2] = u31
             [3] = f_stoppedWorking
             [4] = f_startedWorking
     --]]
     local v203 = u51._jobValue.Value;
     if ((v203 == "") or (v203 == "nil")) then
         v203 = nil;
     end
     if (v203 == u31) then
         return;
     end
     local v204 = u31;
     u31 = v203;
     f_stoppedWorking((u51:GetJobModule(v204)));
     f_startedWorking((u51:GetJobModule(v203)));
 end;
 local u52 = 0;
 local u53 = false;
 local u54 = u1;
 local f_showJobError;
 f_showJobError = function(p57, p58) -- [line 747] showJobError
     --[[
         Upvalues: 
             [1] = u53
             [2] = u52
             [3] = u54
     --]]
     if (u53) then
         return;
     end
     local v205 = tick() - u52;
     if (v205 <= 5) then
         return;
     end
     u54.Modules.GUIHandler:AlertBox(p57, p58 or "T_Unable");
     u53 = false;
     u52 = tick();
 end;
 local u55 = 0;
 local u56 = u1;
 local u57 = t_LocalPlayer_1;
 local f_CanStartWorking;
 f_CanStartWorking = function(p59, p60) -- [line 765] CanStartWorking
     --[[
         Upvalues: 
             [1] = u55
             [2] = u56
             [3] = u53
             [4] = u52
             [5] = u57
     --]]
     local v206 = time() - u55;
     if (v206 < 5) then
         return;
     end
     u55 = time();
     local v207 = u56:GetJobModule(p60);
     local v208 = v207;
     local v209 = u56.Shared.JobData:GetJob(p60);
     local v210 = v209;
     if (not (v207 and v209)) then
         return;
     end
     local v211 = u56:GetJob();
     local v212 = v211;
     if (v211 and (not (v212 == ""))) then
         if (u53) then
             return;
         end
         local v213 = tick() - u52;
         if (v213 <= 5) then
             return;
         end
         u56.Modules.GUIHandler:AlertBox("E_EndShiftFirst", "T_Unable");
         u53 = false;
         u52 = tick();
         return;
     end
     local t_HeightScale_20 = u56.Shared.AppearanceService:GetCurrentAgeData(u57).HeightScale;
     if (t_HeightScale_20 <= (v210.MinHeight or 0.9)) then
         if (u53) then
             return;
         end
         local v214 = tick() - u52;
         if (v214 <= 5) then
             return;
         end
         u56.Modules.GUIHandler:AlertBox("E_TooYoung", "T_Unable");
         u53 = false;
         u52 = tick();
         return;
     end
     local t_HeightScale_21 = u56.Shared.AppearanceService:GetCurrentAgeData(u57).HeightScale;
     local v215 = v210.MaxHeight;
     if (not v215) then
         v215 = math.huge;
     end
     if (not (v215 <= t_HeightScale_21)) then
         u55 = 0;
         return true, v208, v210;
     end
     if (u53) then
         return;
     end
     local v216 = tick() - u52;
     if (v216 <= 5) then
         return;
     end
     u56.Modules.GUIHandler:AlertBox("E_TooOld", "T_Unable");
     u53 = false;
     u52 = tick();
 end;
 u1.CanStartWorking = f_CanStartWorking;
 local u58 = u1;
 local f_StartWorking;
 f_StartWorking = function(p61, p62) -- [line 798] StartWorking
     --[[
         Upvalues: 
             [1] = u58
             [2] = u53
             [3] = u52
     --]]
     local v217, v218, v219 = u58:CanStartWorking(p62);
     local v220 = v218;
     if (not v217) then
         return;
     end
     if (v220.CanStartShift and (not v220:CanStartWorking())) then
         return;
     end
     local v221 = u58.net;
     local v222 = {};
     v222.Type = "StartShift";
     v222.Job = p62;
     local v223, v224 = v221:InvokeServer(v222);
     local v225 = v224;
     if (v223) then
         return true;
     end
     if (v225) then
         if (u53) then
             return;
         end
         local v226 = tick() - u52;
         if (v226 <= 5) then
             return;
         end
         u58.Modules.GUIHandler:AlertBox(v225, "T_Unable");
         u53 = false;
         u52 = tick();
     end
 end;
 u1.StartWorking = f_StartWorking;
 local f_StopWorking;
 f_StopWorking = function(p63) -- [line 821] StopWorking
     --[[
         Upvalues: 
             [1] = u1
     --]]
     local v227 = u1.net;
     local v228 = {};
     v228.Type = "EndShift";
     v227:FireServer(v228);
     u1:SetWorking(nil);
     return true;
 end;
 u1.StopWorking = f_StopWorking;
 local u59 = u1;
 local f_RequestStopWorking;
 f_RequestStopWorking = function(p64) -- [line 829] RequestStopWorking
     --[[
         Upvalues: 
             [1] = u59
             [2] = u53
             [3] = u52
     --]]
     local v229 = u59:GetCurJobModule();
     local v230 = v229;
     if (not v229) then
         return;
     end
     if (v230.CanEndShift and (not v230:CanEndShift())) then
         return;
     end
     if (v230.AreaBlock) then
         local v231 = v230.AreaBlock.CFrame:inverse() * u59.Modules.CharacterHandler:GetRoot().CFrame;
         local v232 = v231;
         local v233 = v230.AreaBlock.Size;
         local t_Size_22 = v233;
         local v234 = math.abs(v231.X) - 5;
         if (v234 <= (v233.X * 0.5)) then
             local v235 = math.abs(v232.Y) - 5;
             if (v235 <= (t_Size_22.Y * 0.5)) then
                 local v236 = math.abs(v232.Z) - 5;
                 if (v236 <= (t_Size_22.Z * 0.5)) then
                     if (u53) then
                         return;
                     end
                     local v237 = tick() - u52;
                     if (v237 <= 5) then
                         return;
                     end
                     u59.Modules.GUIHandler:AlertBox("E_LeaveWork", "T_Unable");
                     u53 = false;
                     u52 = tick();
                     return;
                 end
             end
         end
     end
     return u59:StopWorking();
 end;
 u1.RequestStopWorking = f_RequestStopWorking;
 local u60 = v5:WaitForChild("NoWorkFrame"):WaitForChild("ScrollFrame");
 local u61 = 0;
 local f_updateJobLabel;
 f_updateJobLabel = function(p65) -- [line 857] updateJobLabel
     --[[
         Upvalues: 
             [1] = u1
             [2] = u60
     --]]
     local v238 = u1._jobValue:WaitForChild("Jobs"):WaitForChild(p65.Name);
     local v239 = v238;
     local v240 = v238:WaitForChild("Progress");
     local v241 = u60:WaitForChild(p65.Name .. "_Box");
     local v242 = v241;
     local v243 = v241:WaitForChild("Bar");
     local v244 = math.max(u1.Shared.JobData:GetRequiredPromotionProgress(v238.Value), 1);
     local v245 = v238.Value;
     local t_MaxLevel_23 = u1.Shared.JobData.MaxLevel;
     local v246;
     if (t_MaxLevel_23 < v245) then
         v246 = 1;
         v243.ImageColor3 = Color3.fromRGB(255, 187, 0);
         v243.Value.Visible = false;
         v243.Star.Visible = true;
     else
         local t_Value_25 = v239.Value;
         if (t_Value_25 == 0) then
             v246 = 0;
             v243.ImageColor3 = Color3.fromRGB(220, 220, 220);
             v243.Value.Visible = false;
             v243.Star.Visible = false;
         else
             v246 = v240.Value / v244;
             v243.ImageColor3 = u1.Modules.GUIHandler.Colors.Main;
             v243.Value.Visible = true;
             v243.Star.Visible = false;
         end
     end
     local v247 = false;
     v243.Level.Text = u1.Modules.TranslationHandler:Format("T_Level", {math.min(u1.Shared.JobData.MaxLevel, v239.Value)});
     v243.Value.Text = u1.Modules.TranslationHandler:Format("T_Percentage", {math.floor(v246 * 100)});
     v243.UIGradient.Offset = Vector2.new(v246, 0);
     (v242:WaitForChild("Title")).Text = u1.Modules.TranslationHandler:Format("T_Job" .. p65.Title);
     local v248 = v242:WaitForChild("Location");
     local v249;
     if (p65.Location) then
         v249 = u1.Modules.TranslationHandler:Format("T_AtLocation", {u1:TranslateLocation(p65.Location)});
         if (not v249) then
             v247 = true;
         end
     else
         v247 = true;
     end
     if (v247) then
         v249 = "";
     end
     v248.Text = v249;
     v242.LayoutOrder = 5100 - ((v239.Value + v246) * 100);
     v242.GoTo.ImageColor3 = u1.Modules.GUIHandler.Colors.Main;
     local v250 = 0;
     local v251, v252, v253 = ipairs(u60:GetChildren());
     local v254 = v251;
     local v255 = v252;
     local v256 = v253;
     while true do
         local v257, v258 = v254(v255, v256);
         local v259 = v257;
         local v260 = v258;
         if (v257) then
             break;
         end
         v256 = v259;
         local t_ClassName_24 = v260.ClassName;
         if ((t_ClassName_24 == "ImageLabel") and v260.Visible) then
             v250 = v250 + 1;
         end
     end
     (u60:WaitForChild("BackgroundText")).Visible = v250 < 1;
     if (u60.BackgroundText.Visible) then
         u60.BackgroundText.Text = u1.Modules.TranslationHandler:Format("T_NoJobs");
     end
     u60.CanvasSize = UDim2.new(0, 0, 0, ((u60:WaitForChild("WorkBox").AbsoluteSize.Y + 6) * v250) - 6);
 end;
 local u62 = u1;
 local f_jobChanged = f_jobChanged;
 local u63 = v5;
 local u64 = v6;
 local f_updateJobLabel = f_updateJobLabel;
 local u65 = u60;
 local u66 = t_LocalPlayer_1;
 local u67 = u30;
 local f_Start;
 f_Start = function(p66) -- [line 915] Start
     --[[
         Upvalues: 
             [1] = u62
             [2] = f_jobChanged
             [3] = u63
             [4] = u64
             [5] = f_updateJobLabel
             [6] = u65
             [7] = u61
             [8] = u66
             [9] = u67
     --]]
     u62._jobValue = u62.Modules.ClientStats:GetStat("Job");
     f_jobChanged();
     u62.Modules.ClientStats.Updated:connect(function(p67) -- [line 921] anonymous function
         --[[
             Upvalues: 
                 [1] = f_jobChanged
                 [2] = u63
                 [3] = u62
         --]]
         local t_Name_26 = p67.Name;
         if (t_Name_26 == "Job") then
             f_jobChanged();
             return;
         end
         local t_Name_27 = p67.Name;
         if (t_Name_27 == "ShiftEarnings") then
             (u63:WaitForChild("WorkFrame"):WaitForChild("EarningsLabel"):WaitForChild("TextLabel")).Text = u62.Modules.TranslationHandler:FormatCurrency(math.floor(p67.Value), "$");
         end
     end);
     u62.Modules.ClientStats:HookChanged(u62.Modules.ClientStats:GetStat("Job/ShiftEarnings"));
     u62.net:HookEvent("Paycheck", function(p68) -- [line 934] anonymous function
         --[[
             Upvalues: 
                 [1] = u62
         --]]
         u62:ShowPaycheck(p68.Amount, p68.Job);
     end);
     local v261, v262, v263 = ipairs({
         u64:WaitForChild("Back"),
         u64:WaitForChild("Next"),
         u64:WaitForChild("MainFrame"):WaitForChild("Select")
     });
     local v264 = v261;
     local v265 = v262;
     local v266 = v263;
     while true do
         local v267, v268 = v264(v265, v266);
         local v269 = v267;
         local v270 = v268;
         if (v267) then
             break;
         end
         v266 = v269;
         u62.Modules.GUIHandler:RoundedButtonEffect(v270);
         local v271 = v270.Activated;
         local u68 = v270;
         v271:connect(function() -- [line 942] anonymous function
             --[[
                 Upvalues: 
                     [1] = u68
                     [2] = u62
             --]]
             local t_Name_28 = u68.Name;
             if (t_Name_28 == "Select") then
                 u62:SelectJob();
                 return;
             end
             local t_Name_29 = u68.Name;
             if (t_Name_29 == "Next") then
                 u62:ShowJob(1);
                 return;
             end
             local t_Name_30 = u68.Name;
             if (t_Name_30 == "Back") then
                 u62:ShowJob(-1);
             end
         end);
     end
     local v272, v273, v274 = ipairs({
         u63:WaitForChild("NoWorkFrame"):WaitForChild("FindJob"),
         unpack(u63:WaitForChild("WorkFrame"):WaitForChild("Buttons"):GetChildren())
     });
     local v275 = v272;
     local v276 = v273;
     local v277 = v274;
     while true do
         local v278, v279 = v275(v276, v277);
         local v280 = v278;
         local v281 = v279;
         if (v278) then
             break;
         end
         v277 = v280;
         u62.Modules.GUIHandler:RoundedButtonEffect(v281);
         local v282 = v281.Activated;
         local u69 = v281;
         v282:connect(function() -- [line 960] anonymous function
             --[[
                 Upvalues: 
                     [1] = u69
                     [2] = u62
             --]]
             local t_Name_31 = u69.Name;
             if (t_Name_31 == "Action") then
                 u62:RequestStopWorking();
                 return;
             end
             local t_Name_32 = u69.Name;
             if (t_Name_32 == "FindJob") then
                 findJob();
             end
         end);
     end
     u63:GetPropertyChangedSignal("Visible"):connect(function() -- [line 970] anonymous function
         --[[
             Upvalues: 
                 [1] = u63
                 [2] = u62
                 [3] = f_updateJobLabel
         --]]
         if (u63.Visible) then
             local v283, v284, v285 = pairs(u62.Shared.JobData.Data);
             local v286 = v283;
             local v287 = v284;
             local v288 = v285;
             while true do
                 local v289, v290 = v286(v287, v288);
                 local v291 = v289;
                 local v292 = v290;
                 if (v289) then
                     break;
                 end
                 v288 = v291;
                 f_updateJobLabel(v292);
             end
             (u63.NoWorkFrame:WaitForChild("FindJob")).ImageColor3 = u62.Modules.GUIHandler.Colors.Main;
             (u63.NoWorkFrame.FindJob:WaitForChild("TextLabel")).Text = u62.Modules.TranslationHandler:Format("B_GoToWork");
         end
     end);
     local v293, v294, v295 = pairs(u62.Shared.JobData.Data);
     local v296 = v293;
     local v297 = v294;
     local v298 = v295;
     while true do
         local v299, v300 = v296(v297, v298);
         local v301 = v299;
         local v302 = v300;
         if (v299) then
             break;
         end
         v298 = v301;
         v302.Name = v301;
         local v303 = u62._jobValue:WaitForChild("Jobs"):WaitForChild(v301);
         local v304 = v303:WaitForChild("Progress");
         local v305 = u65:WaitForChild("WorkBox"):clone();
         v305.Parent = u65;
         v305.Name = v301 .. "_Box";
         local v306 = v305:WaitForChild("GoTo");
         u62.Modules.GUIHandler:RoundedButtonEffect(v306);
         local v307 = v306.Activated;
         local u70 = v301;
         v307:connect(function() -- [line 996] anonymous function
             --[[
                 Upvalues: 
                     [1] = u62
                     [2] = u70
             --]]
             u62:GoToWork(u70);
         end);
         v305.Visible = true;
         v305.Position = UDim2.new(0, 0, 0, (v305.AbsoluteSize.Y + 6) * u61);
         local u71 = v302;
         local f_update;
         f_update = function() -- [line 1003] update
             --[[
                 Upvalues: 
                     [1] = f_updateJobLabel
                     [2] = u71
             --]]
             f_updateJobLabel(u71);
         end;
         v303.Changed:connect(f_update);
         v304.Changed:connect(f_update);
         f_updateJobLabel(v302);
         u61 = u61 + 1;
     end
     (u65:WaitForChild("WorkBox")).Visible = false;
     local v308 = u63:WaitForChild("WorkFrame"):WaitForChild("GamepassPurchase");
     u62.Modules.GUIHandler:RoundedButtonEffect(v308);
     v308.Activated:connect(function() -- [line 1020] anonymous function
         --[[
             Upvalues: 
                 [1] = u62
         --]]
         u62.Shared.ProductService:CheckGamepass("Excellent Employee");
     end);
     local v309 = u62.Shared.ProductService:GetAssetID("Excellent Employee");
     local v310 = u62.Shared.ProductService.AssetOwned;
     local u72 = v309;
     local u73 = v308;
     v310:connect(function(p69, p70) -- [line 1025] anonymous function
         --[[
             Upvalues: 
                 [1] = u72
                 [2] = u66
                 [3] = u73
         --]]
         if ((p69 == u72) and (p70 == u66)) then
             u73.Visible = false;
         end
     end);
     u62.task.delay(1, function() -- [line 1032] anonymous function
         --[[
             Upvalues: 
                 [1] = u62
                 [2] = u66
         --]]
         local v311 = false;
         while true do
             local v312 = false;
             local v313 = math.floor((u62.Shared.TimeService:GetHours()));
             if (v313 == 8) then
                 local v314 = u62.Shared.TimeService:GetDayNumber(u62.Shared.TimeService:GetDay());
                 if ((v314 < 5) and u62.Shared.AppearanceService:AgeOlderThan(u66, "Kid", true)) then
                     if ((not (v311 or u62:IsWorking())) and u62.Modules.ClientStats:Get("IsPlaying")) then
                         v311 = true;
                         local v315 = u62.Modules.NotificationUI;
                         local v316 = {};
                         local v317 = {};
                         v317.Text = "B_GoToWork";
                         v316[1] = v317;
                         if ((v315:CreateNotification("T_WorkNotificationTitle", nil, "T_WorkNotificationText", v316) and (not u62:IsWorking())) and u62.Modules.ClientStats:Get("IsPlaying")) then
                             findJob();
                         end
                     end
                 else
                     v312 = true;
                 end
             else
                 v312 = true;
             end
             if (v312) then
                 v311 = false;
             end
             u62.task.wait(1);
         end
     end);
     local v318, v319, v320 = ipairs(script:GetChildren());
     local v321 = v318;
     local v322 = v319;
     local v323 = v320;
     while true do
         local v324, v325 = v321(v322, v323);
         local v326 = v324;
         local v327 = v325;
         if (v324) then
             break;
         end
         v323 = v326;
         if (v327:IsA("ModuleScript")) then
             local v328 = require(v327);
             local v329 = tostring(v327);
             v328.Script = v327;
             v328.Name = v329;
             local v330 = v327:WaitForChild("AreaBlock"):clone();
             v330.Name = "JobArea_" .. v328.Name;
             v330.Transparency = 1;
             local v331 = v330.Touched;
             local u74 = v329;
             v331:connect(function(p71) -- [line 1075] anonymous function
                 --[[
                     Upvalues: 
                         [1] = u62
                         [2] = u74
                 --]]
                 local v332 = tostring(p71);
                 if (v332 == "UpperTorso") then
                     local t_Parent_33 = p71.Parent;
                     if (t_Parent_33 == u62.Modules.CharacterHandler:GetCharacter()) then
                         u62:StartWorking(u74);
                     end
                 end
             end);
             v328.AreaBlock = v330;
             assert(v328.LocationName, "No LocationName! " .. tostring(v327));
             v328.Model = workspace:WaitForChild("Environment"):WaitForChild("Locations"):WaitForChild(v328.LocationName);
             v330.Parent = v328.Model;
             v328:Init(u62);
             u67[v329] = v328;
         end
     end
     u62.JobsLoaded = true;
 end;
 u1.Start = f_Start;
 return u1;
 