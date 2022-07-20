-- Decompiled with the Synapse X Luau decompiler.
 --NOTE: Currently in beta! Not representative of final product.
 math.randomseed(tick());
 local u1 = game:GetService("RunService"):IsStudio();
 local t_Value_1 = game:GetService("ReplicatedFirst"):WaitForChild("GameData"):WaitForChild("Version", 3).Value;
 local t_LocalPlayer_2 = game:GetService("Players").LocalPlayer;
 while true do
     wait(1);
     if (game:IsLoaded() and shared.require) then
         break;
     end
 end
 local v1 = tick();
 local v2 = shared.require("superusers")[t_LocalPlayer_2.UserId];
 pcall(function()
     --[[
         Name: (empty)
         Line: 49
     --]]
     game:GetService("StarterGui"):SetCore("TopbarEnabled", false);
 end);
 local v3 = Instance.new("Folder");
 local v4 = v3;
 v3.Name = "Players";
 v3.Parent = workspace;
 local g_next_3 = next;
 local v5, v6 = game:GetService("Teams"):GetTeams();
 local v7 = v5;
 local v8 = v6;
 while true do
     local v9, v10 = g_next_3(v7, v8);
     local v11 = v9;
     local v12 = v10;
     if (v9) then
         v8 = v11;
         local v13 = Instance.new("Folder");
         v13.Name = v12.TeamColor.Name;
         v13.Parent = v4;
     else
         break;
     end
 end
 local u2 = {};
 local u3 = {};
 local u4 = {};
 local u5 = {};
 local u6 = {};
 local u7 = {};
 local u8 = {};
 local u9 = {};
 u9.raycastwhitelist = {};
 local u10 = {};
 shared.add("hud", u4);
 shared.add("char", u2);
 shared.add("roundsystem", u9);
 shared.add("replication", u7);
 shared.add("PlayerPolicy", (shared.require("PolicyHelper").new(t_LocalPlayer_2)));
 local u11 = shared.require("PublicSettings");
 local v14 = shared.require("RenderSteppedRunner");
 local v15 = shared.require("HeartbeatRunner");
 local u12 = shared.require("network");
 local v16 = shared.require("trash");
 local v17 = v16;
 local u13 = shared.require("vector");
 local u14 = shared.require("cframe");
 local v18 = shared.require("spring");
 local v19 = v18;
 local v20 = shared.require("playerdata");
 local v21 = shared.require("Event");
 local u15 = shared.require("ScreenCull");
 local u16 = shared.require("camera");
 local v22 = shared.require("sequencer");
 local v23 = shared.require("animation");
 local u17 = shared.require("input");
 local u18 = shared.require("particle");
 local u19 = shared.require("effects");
 local v24 = shared.require("tween");
 local u20 = shared.require("uiscaler");
 local v25 = shared.require("InstanceType");
 local v26 = v25;
 local u21 = shared.require("sound");
 local v27 = shared.require("ModifyData");
 local u22 = shared.require("DayCycle");
 local u23 = shared.require("GunDataGetter");
 local f_gunrequire;
 f_gunrequire = function(p1)
     --[[
         Name: gunrequire
         Line: 127
         Upvalues: 
             [1] = u23
             [2] = u1
 
     --]]
     local v28 = u23.getGunModule(p1);
     local v29 = v28;
     if (not v28) then
         return;
     end
     if (u1) then
         return require(v29:Clone());
     end
     return require(v29);
 end;
 local t_getGunModel_4 = u23.getGunModel;
 u23 = print;
 u23("Loading chat module");
 local t_getscale_5 = u20.getscale;
 local u24 = v25.GetString();
 local v30 = game:GetService("Players").LocalPlayer;
 local v31 = v30.PlayerGui;
 local u25 = game.ReplicatedStorage.Misc:WaitForChild("MsgerMain");
 local v32 = v31:WaitForChild("ChatGame");
 local u26 = v32:WaitForChild("TextBox");
 local u27 = v32:WaitForChild("Warn");
 local u28 = v32:WaitForChild("Version");
 local u29 = v32:WaitForChild("GlobalChat");
 local v33 = v25.IsVIP();
 local u30 = 0;
 local u31 = 0;
 local f_updateversionstr;
 f_updateversionstr = function(p2)
     --[[
         Name: updateversionstr
         Line: 167
         Upvalues: 
             [1] = u28
             [2] = t_Value_1
             [3] = u24
 
     --]]
     u28.Text = string.format("<b>Version: %s-%s#%s</b>", t_Value_1, string.lower(u24), p2 or "N/A");
 end;
 u3.updateversionstr = f_updateversionstr;
 u12:add("console", function(p3)
     --[[
         Name: (empty)
         Line: 171
         Upvalues: 
             [1] = t_getscale_5
             [2] = u25
             [3] = u29
 
     --]]
     local v34 = t_getscale_5();
     local v35 = u25:Clone();
     local v36 = v35:FindFirstChild("Tag");
     v35.Text = "[Console]: ";
     v35.TextColor3 = Color3.new(0.4, 0.4, 0.4);
     v35.Msg.Text = p3;
     v35.Parent = u29;
     v35.Msg.Position = UDim2.new(0, v35.TextBounds.x / v34, 0, 0);
 end);
 u12:add("announce", function(p4)
     --[[
         Name: (empty)
         Line: 184
         Upvalues: 
             [1] = t_getscale_5
             [2] = u25
             [3] = u29
 
     --]]
     local v37 = t_getscale_5();
     local v38 = u25:Clone();
     local v39 = v38:FindFirstChild("Tag");
     v38.Text = "[ANNOUNCEMENT]: ";
     v38.TextColor3 = Color3.new(0.9803921568627451, 0.6509803921568628, 0.10196078431372549);
     v38.Msg.Text = p4;
     v38.Parent = u29;
     v38.Msg.Position = UDim2.new(0, v38.TextBounds.x / v37, 0, 0);
 end);
 u12:add("chatted", function(p5, p6, p7, p8, p9)
     --[[
         Name: (empty)
         Line: 197
         Upvalues: 
             [1] = t_getscale_5
             [2] = u25
             [3] = u29
             [4] = u4
 
     --]]
     local v40 = false;
     local v41 = t_getscale_5();
     local v42 = u25:Clone();
     local v43 = v42;
     local v44 = v42:FindFirstChild("Tag");
     v42.Parent = u29;
     local v45;
     if (p7) then
         v45 = p7 .. " ";
         if (not v45) then
             v40 = true;
         end
     else
         v40 = true;
     end
     if (v40) then
         v45 = "";
     end
     v44.Text = v45;
     if (p7) then
         local v46 = string.sub(p7, 0, 1);
         if (v46 == "$") then
             local v47 = string.sub(p7, 2);
             v43.Position = UDim2.new(0.01, 50, 1, 20);
             v44.Staff.Visible = true;
             v44.Staff.Image = "rbxassetid://" .. v47;
             v44.Text = "    ";
         else
             local v48 = (v44.TextBounds.x / v41) + 5;
             v43.Position = UDim2.new(0.01, v48, 1, 20);
             v44.Position = UDim2.new(0, (-v48) + 5, 0, 0);
             if (p8) then
                 v44.TextColor3 = p8;
             end
         end
     end
     if (u4.streamermode and u4.streamermode()) then
         v43.Text = "Player : ";
     else
         v43.Text = p5.Name .. " : ";
     end
     v43.TextColor = p5.TeamColor;
     v43.Msg.Text = p6;
     if (p9) then
         v43.Msg.TextColor3 = Color3.new(1, 0, 0);
     end
     v43.Msg.Position = UDim2.new(0, v43.TextBounds.x / v41, 0, 0);
 end);
 u12:add("printstring", function(...)
     --[[
         Name: (empty)
         Line: 384
     --]]
     local v49 = {...};
     local v50 = "";
     local v51 = 1;
     local v52 = #v50;
     local v53 = v52;
     local v54 = v51;
     if (not (v52 <= v54)) then
         while true do
             v50 = v50 .. ("\t" .. v49[v51]);
             local v55 = v51 + 1;
             v51 = v55;
             local v56 = v53;
             if (v56 < v55) then
                 break;
             end
         end
     end
     local v57 = v50 .. "\n";
     local v58 = 0;
     local v59 = "";
     local v60, v61, v62 = string.gmatch(v57, "(^[\n]*)\n");
     local v63 = v60;
     local v64 = v61;
     local v65 = v62;
     while true do
         local v66 = v63(v64, v65);
         local v67 = v66;
         if (v66) then
             break;
         end
         v65 = v67;
         v58 = v58 + 1;
         v59 = v59 .. ("\n" .. v67);
         if (v58 == 64) then
             print(v59);
             v58 = 0;
             v59 = "";
         end
     end
 end);
 local u32 = u26;
 local u33 = u12;
 local u34 = u27;
 local t_LocalPlayer_6 = v30;
 local f_newchat;
 f_newchat = function()
     --[[
         Name: newchat
         Line: 405
         Upvalues: 
             [1] = u32
             [2] = u33
             [3] = u30
             [4] = u34
             [5] = u31
             [6] = t_LocalPlayer_6
 
     --]]
     local v68 = u32.Text;
     u32.Text = "Press '/' or click here to chat";
     u32.ClearTextOnFocus = true;
     u32.Active = false;
     local v69 = string.sub(v68, 1, 1);
     if (v69 == "/") then
         u33:send("mo\226\128\139dcmd", v68);
         u32.Text = "Press '/' or click here to chat";
         u32.ClearTextOnFocus = true;
         return;
     end
     local v70 = nil;
     local v71 = string.sub(v68, 1, 1);
     if (v71 == "%") then
         v70 = true;
         v68 = string.sub(v68, 2, string.len(v68));
     end
     local v72 = u30;
     if (not (v72 >= 5)) then
         local v73 = string.len(v68);
         if (v73 >= 256) then
             v68 = string.sub(v68, 1, 256);
         end
         u30 = u30 + 1;
         u33:send("chatt\226\128\139ed", v68, v70);
         task.delay(10, function()
             --[[
                 Name: (empty)
                 Line: 453
                 Upvalues: 
                     [1] = u30
 
             --]]
             u30 = u30 - 1;
         end);
         return;
     end
     u34.Visible = true;
     u30 = u30 + 1;
     u31 = u31 + 1;
     u34.Text = "You have been blocked temporarily for spamming.   WARNING : " .. (u31 .. " out of 3");
     local v74 = u31;
     if (v74 >= 3) then
         t_LocalPlayer_6:Kick("Kicked for repeated spamming");
     end
     task.delay(5, function()
         --[[
             Name: (empty)
             Line: 440
             Upvalues: 
                 [1] = u30
                 [2] = u34
 
         --]]
         u30 = u30 - 5;
         u34.Visible = false;
     end);
 end;
 local f_hidechat;
 f_hidechat = function(p10, p11)
     --[[
         Name: hidechat
         Line: 459
         Upvalues: 
             [1] = u29
             [2] = u26
 
     --]]
     u29.Visible = not p11;
     u26.Visible = not p11;
 end;
 u3.hidechat = f_hidechat;
 local f_inmenu;
 f_inmenu = function(p12)
     --[[
         Name: inmenu
         Line: 467
         Upvalues: 
             [1] = u29
             [2] = u26
 
     --]]
     u29.Position = UDim2.new(0, 20, 1, -100);
     u26.Position = UDim2.new(0, 10, 1, -20);
 end;
 u3.inmenu = f_inmenu;
 local f_ingame;
 f_ingame = function(p13)
     --[[
         Name: ingame
         Line: 472
         Upvalues: 
             [1] = u29
             [2] = u26
 
     --]]
     u29.Position = UDim2.new(0, 150, 1, -50);
     u26.Position = UDim2.new(0, 10, 1, -20);
 end;
 u3.ingame = f_ingame;
 u29.ChildAdded:connect(function(p14)
     --[[
         Name: (empty)
         Line: 477
         Upvalues: 
             [1] = t_getscale_5
             [2] = u29
 
     --]]
     task.wait();
     local v75 = t_getscale_5();
     local v76 = u29:GetChildren();
     local v77 = v76;
     local v78 = 1;
     local v79 = #v76;
     local v80 = v79;
     local v81 = v78;
     if (not (v79 <= v81)) then
         while true do
             local v82 = v77[v78];
             local v83 = v82;
             local v84 = v82:FindFirstChild("Tag");
             local v85 = v84;
             local v86 = 20;
             local t_Text_7 = v84.Text;
             if (t_Text_7 ~= "") then
                 v86 = 20 + (v85.TextBounds.x / v75);
                 v83.Position = UDim2.new(0, v86, 1, v83.Position.Y.Offset);
             end
             if (v83.Parent) then
                 v83:TweenPosition(UDim2.new(0, v86, 1, (v78 - (#v77)) * 20), "Out", "Sine", 0.2, true);
             end
             local v87 = #v77;
             if (v87 >= 8) then
                 local v88 = (#v77) - 8;
                 if (v78 < v88) then
                     local t_Name_8 = v83.Name;
                     if (t_Name_8 ~= "Deleted") then
                         v83.Name = "Deleted";
                         local v89 = 1;
                         local v90 = v89;
                         if (not (v90 >= 5)) then
                             while true do
                                 if (v83:FindFirstChild("Msg") and v83:FindFirstChild("Tag")) then
                                     v83.TextTransparency = (v89 * 2) / 10;
                                     v83.TextStrokeTransparency = ((v89 * 2) / 10) + 0.1;
                                     v83.Msg.TextTransparency = (v89 * 2) / 10;
                                     v83.Msg.TextStrokeTransparency = ((v89 * 2) / 10) + 0.1;
                                     v83.Tag.TextTransparency = (v89 * 2) / 10;
                                     v83.Tag.TextStrokeTransparency = ((v89 * 2) / 10) + 0.1;
                                     task.wait(0.03333333333333333);
                                 end
                                 if (v83 and v83.Parent) then
                                     v83:Destroy();
                                 end
                                 local v91 = v89 + 1;
                                 v89 = v91;
                                 if (v91 > 5) then
                                     break;
                                 end
                             end
                         end
                     end
                 end
             end
             local v92 = v78 + 1;
             v78 = v92;
             local v93 = v80;
             if (v93 < v92) then
                 break;
             end
         end
     end
 end);
 u26.Focused:connect(function()
     --[[
         Name: (empty)
         Line: 514
         Upvalues: 
             [1] = u26
 
     --]]
     u26.Active = true;
 end);
 u26.FocusLost:connect(function(p15)
     --[[
         Name: (empty)
         Line: 518
         Upvalues: 
             [1] = u26
             [2] = f_newchat
 
     --]]
     u26.Active = false;
     if (p15) then
         local t_Text_9 = u26.Text;
         if (t_Text_9 ~= "") then
             f_newchat();
         end
     end
 end);
 game:GetService("UserInputService").InputBegan:connect(function(p16)
     --[[
         Name: (empty)
         Line: 525
         Upvalues: 
             [1] = u27
             [2] = u26
             [3] = u4
 
     --]]
     if (u27.Visible) then
         return;
     end
     local t_KeyCode_10 = p16.KeyCode;
     if (not u26.Active) then
         local v94 = Enum.KeyCode.Slash;
         if (t_KeyCode_10 == v94) then
             wait(0.03333333333333333);
             u26:CaptureFocus();
             u26.ClearTextOnFocus = false;
             return;
         end
         local v95 = Enum.KeyCode[u4.voteyes];
         if (t_KeyCode_10 == v95) then
             u4:vote("yes");
             return;
         end
         local v96 = Enum.KeyCode[u4.votedismiss];
         if (t_KeyCode_10 == v96) then
             u4:vote("dismiss");
             return;
         end
         local v97 = Enum.KeyCode[u4.voteno];
         if (t_KeyCode_10 == v97) then
             u4:vote("no");
         end
     end
 end);
 u3.updateversionstr();
 print("Loading hud module");
 local v98 = u20.getscale;
 local t_LocalPlayer_11 = game:GetService("Players").LocalPlayer;
 local t_PlayerTag_12 = game.ReplicatedStorage.Character.PlayerTag;
 local v99 = t_LocalPlayer_11.PlayerGui;
 local v100 = game.ReplicatedStorage;
 local t_ReplicatedStorage_13 = v100;
 local v101 = v100.Misc;
 local t_BloodArc_14 = v101.BloodArc;
 local v102 = v101.Spot;
 local t_Feed_15 = v101.Feed;
 local t_Headshot_16 = v101.Headshot;
 local u35 = v99:WaitForChild("MainGui");
 local u36 = u35:WaitForChild("GameGui");
 local v103 = v99:WaitForChild("NonScaled");
 local v104 = u36:WaitForChild("CrossHud");
 local v105 = v104:WaitForChild("Sprint");
 local v106 = {
     v104:WaitForChild("HR"),
     v104:WaitForChild("HL"),
     v104:WaitForChild("VD"),
     v104:WaitForChild("VU")
 };
 local v107 = u36:WaitForChild("AmmoHud");
 local v108 = v103:WaitForChild("ScopeFrame");
 local v109 = v108;
 local u37 = u36:WaitForChild("Hitmarker");
 local u38 = v103:WaitForChild("NameTag");
 local u39 = u36:WaitForChild("Capping");
 local v110 = u36:WaitForChild("BloodScreen");
 local v111 = u36:WaitForChild("Radar");
 local u40 = u36:WaitForChild("Killfeed");
 local v112 = v103:WaitForChild("Steady"):WaitForChild("Steady");
 local v113 = v112;
 local u41 = u36:WaitForChild("Use");
 local v114 = u36:WaitForChild("Round");
 local u42 = u36:WaitForChild("Spotted");
 local v115 = v99.ChatGame:WaitForChild("GlobalChat");
 local u43 = v112:WaitForChild("Full"):WaitForChild("Bar");
 local v116 = v111:WaitForChild("Me");
 local v117 = v111:WaitForChild("Folder");
 local v118 = (-v116.Size.X.Offset) / 2;
 local v119 = v107:WaitForChild("Frame");
 local u44 = v119:WaitForChild("Ammo");
 local u45 = v119:WaitForChild("GAmmo");
 local u46 = v119:WaitForChild("Mag");
 local v120 = v119:WaitForChild("Health");
 local u47 = v119:WaitForChild("FMode");
 local v121 = v119:WaitForChild("healthbar_back");
 local v122 = v121;
 local v123 = v121:WaitForChild("healthbar_fill");
 local v124 = {
     Color3.new(0.14901960784313725, 0.3137254901960784, 0.2784313725490196),
     Color3.new(0.17647058823529413, 0.5019607843137255, 0.43137254901960786),
     Color3.new(0.8745098039215686, 0.12156862745098039, 0.12156862745098039),
     Color3.new(0.5333333333333333, 0.06666666666666667, 0.06666666666666667)
 };
 local u48 = u39:WaitForChild("Percent");
 local u49 = nil;
 local u50 = nil;
 local u51 = nil;
 local u52 = {};
 local u53 = {};
 local u54 = {};
 local u55 = {};
 local u56 = 0;
 local u57 = 0;
 local u58 = 0;
 local u59 = {};
 local v125 = {};
 v125.gui = v107;
 v125.enabled = true;
 u59.ammohud = v125;
 local v126 = {};
 v126.gui = v111;
 v126.enabled = true;
 u59.radar = v126;
 local v127 = {};
 v127.gui = u40;
 v127.enabled = true;
 u59.killfeed = v127;
 local v128 = {};
 v128.gui = v104;
 v128.enabled = true;
 u59.crossframe = v128;
 local v129 = {};
 v129.gui = v114;
 v129.enabled = true;
 u59.round = v129;
 u4.crossscale = v18.new(0);
 u4.crossscale.s = 10;
 u4.crossscale.d = 0.8;
 u4.crossscale.t = 1;
 u4.crossspring = v18.new(0);
 u4.crossspring.s = 12;
 u4.crossspring.d = 0.65;
 u4.hitspring = v18.new(1);
 u4.hitspring.s = 5;
 u4.hitspring.d = 0.7;
 u4.streamermodenabled = false;
 u4.streamermodetoggle = true;
 local v130 = v99.ChatGame:WaitForChild("Votekick");
 local v131 = v130:WaitForChild("Title");
 local v132 = v130:WaitForChild("Timer");
 local v133 = v130:WaitForChild("Votes");
 local v134 = v130:WaitForChild("Yes");
 local v135 = v130:WaitForChild("No");
 local v136 = v130:WaitForChild("Dismiss");
 local v137 = v130:WaitForChild("Choice");
 local u60 = 0;
 local u61 = 0;
 local u62 = 0;
 local u63 = nil;
 local u64 = nil;
 u4.voteyes = "Y";
 u4.voteno = "N";
 u4.votedismiss = "J";
 v134.Text = "Yes [" .. (string.upper(u4.voteyes) .. "]");
 v135.Text = "No [" .. (string.upper(u4.voteno) .. "]");
 v136.Text = "Dismiss [" .. (string.upper(u4.votedismiss) .. "]");
 local u65 = u4;
 local u66 = v130;
 local u67 = v132;
 local u68 = v133;
 local f_votestep;
 f_votestep = function()
     --[[
         Name: votestep
         Line: 697
         Upvalues: 
             [1] = u65
             [2] = u63
             [3] = u66
             [4] = u67
             [5] = u62
             [6] = u68
             [7] = u61
             [8] = u60
 
     --]]
     if ((not u65.disablevotekick) and u63) then
         u66.Visible = true;
         u67.Text = "Time left: 0:" .. string.format("%.2d", (u62 - tick()) % 60);
         u68.Text = "Votes: " .. (u61 .. (" out of " .. (u60 .. " required")));
         local v138 = u62;
         local v139 = tick();
         if (not (v138 <= v139)) then
             local v140 = u61;
             if (u60 < v140) then
             end
         end
         u63 = false;
         u66.Visible = false;
         return;
     end
     u66.Visible = false;
 end;
 u4.votestep = f_votestep;
 local u69 = v134;
 local u70 = v135;
 local u71 = v136;
 local u72 = v137;
 local u73 = v130;
 local u74 = u12;
 local f_vote;
 f_vote = function(p17, p18)
     --[[
         Name: vote
         Line: 711
         Upvalues: 
             [1] = u63
             [2] = u64
             [3] = u69
             [4] = u70
             [5] = u71
             [6] = u72
             [7] = u73
             [8] = u74
 
     --]]
     if (u63 and (not u64)) then
         u69.Visible = false;
         u70.Visible = false;
         u71.Visible = false;
         u72.Visible = true;
         u64 = true;
         if (p18 == "yes") then
             u72.Text = "Voted Yes";
             u72.TextColor3 = u69.TextColor3;
         else
             if (p18 == "dismiss") then
                 u72.Text = "Vote Dismissed";
                 u72.TextColor3 = u71.TextColor3;
                 u63 = false;
                 u73.Visible = false;
             else
                 u72.Text = "Voted No";
                 u72.TextColor3 = u70.TextColor3;
             end
         end
         u74:send("votef\226\128\139romUI", p18);
     end
 end;
 u4.vote = f_vote;
 local u75 = u4;
 local u76 = v131;
 local u77 = v130;
 local u78 = v134;
 local u79 = v135;
 local u80 = v136;
 local u81 = v137;
 u12:add("startvotekick", function(p19, p20, p21)
     --[[
         Name: (empty)
         Line: 734
         Upvalues: 
             [1] = u75
             [2] = u76
             [3] = u77
             [4] = u78
             [5] = u79
             [6] = u80
             [7] = u81
             [8] = u60
             [9] = u61
             [10] = u62
             [11] = u63
             [12] = u64
 
     --]]
     if (not u75.disablevotekick) then
         u76.Text = "Votekick " .. (p19 .. " out of the server?");
         u77.Visible = true;
         u78.Visible = true;
         u79.Visible = true;
         u80.Visible = true;
         u81.Visible = false;
         u60 = p21;
         u61 = 0;
         u62 = tick() + p20;
         u63 = true;
         u64 = false;
         u75.votestep();
     end
 end);
 u12:add("updatenumvotes", function(p22)
     --[[
         Name: (empty)
         Line: 752
         Upvalues: 
             [1] = u61
 
     --]]
     u61 = p22;
 end);
 local f_gethealthstate;
 f_gethealthstate = function(p23)
     --[[
         Name: gethealthstate
         Line: 757
         Upvalues: 
             [1] = u53
 
     --]]
     local v141 = u53[p23];
     if (not v141) then
         local v142 = {};
         v142.health0 = 0;
         v142.healtick0 = 0;
         v142.alive = false;
         v142.healrate = 0.25;
         v142.maxhealth = 100;
         v142.healwait = 8;
         v141 = v142;
         u53[p23] = v141;
     end
     return v141;
 end;
 local f_streamermode;
 f_streamermode = function()
     --[[
         Name: streamermode
         Line: 775
         Upvalues: 
             [1] = u4
 
     --]]
     if (u4.streamermodenabled) then
         return u4.streamermodetoggle;
     end
 end;
 u4.streamermode = f_streamermode;
 local f_updatehealth;
 f_updatehealth = function(p24, p25)
     --[[
         Name: updatehealth
         Line: 781
         Upvalues: 
             [1] = f_gethealthstate
 
     --]]
     local v143 = f_gethealthstate(p24);
     v143.alive = p25.alive;
     v143.health0 = p25.health0;
     v143.healtick0 = p25.healtick0;
 end;
 u4.updatehealth = f_updatehealth;
 u12:add("updateothershealth", function(p26, p27, p28, p29)
     --[[
         Name: (empty)
         Line: 788
         Upvalues: 
             [1] = f_gethealthstate
             [2] = u8
 
     --]]
     local v144 = f_gethealthstate(p26);
     v144.health0 = p27;
     v144.healtick0 = p28;
     v144.alive = p29;
     if (u8.updatelist) then
         u8.updatelist(p26, "Toggle");
     end
 end);
 u12:add("killfeed", function(p30, p31, p32, p33, p34)
     --[[
         Name: (empty)
         Line: 798
         Upvalues: 
             [1] = u59
             [2] = u20
             [3] = t_Feed_15
             [4] = u40
             [5] = u4
             [6] = t_Headshot_16
 
     --]]
     if (u59.killfeed.enabled) then
         local v145 = u20.getscale();
         local v146 = t_Feed_15:Clone();
         local v147 = v146;
         v146.Parent = u40;
         if (u4.streamermode()) then
             v147.Text = "Player";
             v147.Victim.Text = "Player";
         else
             v147.Text = p30.Name;
             v147.Victim.Text = p31.Name;
         end
         v147.TextColor = p30.TeamColor;
         v147.GunImg.Text = p33;
         v147.Victim.TextColor = p31.TeamColor;
         v147.GunImg.Dist.Text = "Dist: " .. (p32 .. " studs");
         v147.GunImg.Size = UDim2.new(0, v147.GunImg.TextBounds.x / v145, 0, 30);
         v147.GunImg.Position = UDim2.new(0, 15 + (v147.TextBounds.x / v145), 0, -5);
         v147.Victim.Position = UDim2.new(0, (30 + (v147.TextBounds.x / v145)) + (v147.GunImg.TextBounds.x / v145), 0, 0);
         if (p34) then
             local v148 = t_Headshot_16:Clone();
             v148.Parent = v147.Victim;
             v148.Position = UDim2.new(0, 10 + (v147.Victim.TextBounds.x / v145), 0, -5);
         end
         local v149 = task.spawn;
         local u82 = v147;
         v149(function()
             --[[
                 Name: (empty)
                 Line: 828
                 Upvalues: 
                     [1] = u82
 
             --]]
             u82.Visible = true;
             task.wait(20);
             local v150 = 1;
             local v151 = v150;
             if (not (v151 >= 10)) then
                 while true do
                     if (u82.Parent) then
                         u82.TextTransparency = v150 / 10;
                         u82.TextStrokeTransparency = (v150 / 10) + 0.5;
                         u82.GunImg.TextStrokeTransparency = (v150 / 10) + 0.5;
                         u82.GunImg.TextTransparency = v150 / 10;
                         u82.Victim.TextStrokeTransparency = (v150 / 10) + 0.5;
                         u82.Victim.TextTransparency = v150 / 10;
                         task.wait(0.03333333333333333);
                     end
                     local v152 = v150 + 1;
                     v150 = v152;
                     if (v152 > 10) then
                         break;
                     end
                 end
             end
             if (u82 and u82.Parent) then
                 u82:Destroy();
             end
         end);
         local v153 = u40:GetChildren();
         local v154 = v153;
         local v155 = 1;
         local v156 = #v153;
         local v157 = v156;
         local v158 = v155;
         if (not (v156 <= v158)) then
             while true do
                 v154[v155]:TweenPosition(UDim2.new(0.01, 5, 1, ((v155 - (#v154)) * 25) - 25), "Out", "Sine", 0.2, true);
                 local v159 = #v154;
                 if (v159 >= 5) then
                     local v160 = (#v154) - v155;
                     if (v160 > 5) then
                         local v161 = task.spawn;
                         local u83 = v154;
                         v161(function()
                             --[[
                                 Name: (empty)
                                 Line: 852
                                 Upvalues: 
                                     [1] = u83
 
                             --]]
                             local v162 = u83[1];
                             local v163 = v162;
                             local t_Name_17 = v162.Name;
                             if (t_Name_17 ~= "Deleted") then
                                 local v164 = 1;
                                 local v165 = v164;
                                 if (not (v165 >= 10)) then
                                     while true do
                                         if (v163:FindFirstChild("Victim")) then
                                             v163.TextTransparency = v164 / 10;
                                             v163.TextStrokeTransparency = (v164 / 10) + 0.5;
                                             v163.Victim.TextTransparency = v164 / 10;
                                             v163.Victim.TextStrokeTransparency = (v164 / 10) + 0.5;
                                             v163.Name = "Deleted";
                                             v163.GunImg.TextTransparency = v164 / 10;
                                             v163.GunImg.TextStrokeTransparency = (v164 / 10) + 0.5;
                                             task.wait(0.03333333333333333);
                                         end
                                         local v166 = v164 + 1;
                                         v164 = v166;
                                         if (v166 > 10) then
                                             break;
                                         end
                                     end
                                 end
                                 v163:Destroy();
                             end
                         end);
                     end
                 end
                 local v167 = v155 + 1;
                 v155 = v167;
                 local v168 = v157;
                 if (v168 < v167) then
                     break;
                 end
             end
         end
     end
 end);
 local v169 = math.pi / 180;
 local t_GameMode_18 = v100.ServerSettings.GameMode;
 local t_PointLight_19 = v100.GamemodeProps.FlagDrop.Base.PointLight;
 local t_FlagCarry_20 = v100.GamemodeProps.FlagCarry;
 local t_FlagDrop_21 = v100.GamemodeProps.FlagDrop;
 local u84 = BrickColor.new("Bright blue");
 local u85 = BrickColor.new("Bright orange");
 local u86 = {
     u84,
     u85
 };
 local u87 = u36:WaitForChild("Captured");
 local u88 = u36:WaitForChild("Revealed");
 local u89 = {};
 u89.caplight = nil;
 local v170 = u84.Name;
 local v171 = {};
 v171.revealtime = 0;
 v171.droptime = 0;
 v171.carrier = nil;
 v171.carrymodel = nil;
 v171.dropmodel = nil;
 v171.dropped = false;
 v171.basecf = CFrame.new();
 u89[v170] = v171;
 local v172 = u85.Name;
 local v173 = {};
 v173.revealtime = 0;
 v173.droptime = 0;
 v173.carrier = nil;
 v173.carrymodel = nil;
 v173.dropmodel = nil;
 v173.dropped = false;
 v173.basecf = CFrame.new();
 u89[v172] = v173;
 local f_resetflag;
 f_resetflag = function(p35, p36)
     --[[
         Name: resetflag
         Line: 911
         Upvalues: 
             [1] = u89
             [2] = t_LocalPlayer_11
 
     --]]
     local v174 = u89[p35.Name];
     local v175 = v174;
     v174.revealtime = 0;
     v174.carrier = nil;
     local v176 = t_LocalPlayer_11;
     if (not (((p36 == v176) and u89.caplight) and u89.caplight.Parent)) then
         if (v175.carrymodel and v175.carrymodel.Parent) then
             v175.carrymodel:Destroy();
             v175.carrymodel = nil;
         end
         return;
     end
     u89.caplight:Destroy();
     u89.caplight = nil;
 end;
 local f_cleanflags;
 f_cleanflags = function()
     --[[
         Name: cleanflags
         Line: 927
         Upvalues: 
             [1] = u86
             [2] = f_resetflag
             [3] = u89
 
     --]]
     local g_next_22 = next;
     local v177 = u86;
     local v178 = nil;
     while true do
         local v179, v180 = g_next_22(v177, v178);
         local v181 = v179;
         local v182 = v180;
         if (v179) then
             v178 = v181;
             f_resetflag(v182);
             local v183 = u89[v182.Name];
             local v184 = v183;
             if (v183 and v183.dropmodel) then
                 v184.dropmodel:Destroy();
                 v184.dropmodel = nil;
             end
         else
             break;
         end
     end
 end;
 local f_dropflag;
 f_dropflag = function(p37, p38, p39, p40)
     --[[
         Name: dropflag
         Line: 940
         Upvalues: 
             [1] = u89
             [2] = t_FlagDrop_21
             [3] = t_LocalPlayer_11
 
     --]]
     local v185 = u89[p37.Name];
     local v186 = v185;
     local v187;
     if (v185.dropmodel and v185.dropmodel.Parent) then
         v187 = v186.dropmodel;
     else
         v187 = t_FlagDrop_21:Clone();
     end
     local v188 = v187:FindFirstChild("Base");
     local v189 = v188;
     if (not v188) then
         print("no base", v187);
         return;
     end
     local v190 = v187:FindFirstChild("Tag");
     local v191 = v189:FindFirstChild("BillboardGui");
     local v192 = v191;
     local v193 = v189:FindFirstChild("PointLight");
     v190.BrickColor = p37;
     v187.TeamColor.Value = p37;
     v191.Display.BackgroundColor = p37;
     v193.Color = p37.Color;
     local t_TeamColor_23 = t_LocalPlayer_11.TeamColor;
     if (p37 == t_TeamColor_23) then
         local t_Status_24 = v192.Status;
         local v194;
         if (p40) then
             v194 = "Protect";
         else
             v194 = "Dropped";
         end
         t_Status_24.Text = v194;
     else
         local t_Status_25 = v192.Status;
         local v195;
         if (p40) then
             v195 = "Capture";
         else
             v195 = "Pick Up";
         end
         t_Status_25.Text = v195;
     end
     v187:SetPrimaryPartCFrame(p38);
     v187.Location.Value = p38;
     v187.Parent = workspace.Ignore.GunDrop;
     v186.dropmodel = v187;
     v186.droptime = p39;
     v186.dropped = not p40;
     if (p40) then
         u89[p37.Name].basecf = p38;
     end
 end;
 local f_attachflag;
 f_attachflag = function(p41)
     --[[
         Name: attachflag
         Line: 978
         Upvalues: 
             [1] = u7
             [2] = u84
             [3] = u85
             [4] = t_FlagCarry_20
             [5] = u89
 
     --]]
     if (not ((p41 and p41.Parent) and u7.getbodyparts)) then
         return;
     end
     local v196 = false;
     local v197 = p41.TeamColor;
     local v198 = u84;
     local v199;
     if (v197 == v198) then
         v199 = u85;
         if (not v199) then
             v196 = true;
         end
     else
         v196 = true;
     end
     if (v196) then
         v199 = u84;
     end
     local v200 = u7.getbodyparts(p41);
     local v201 = v200;
     if (v200 and v200.torso) then
         local v202 = t_FlagCarry_20:Clone();
         local v203 = v202;
         v202.Tag.BrickColor = v199;
         v202.Tag.BillboardGui.Display.BackgroundColor3 = v199.Color;
         v202.Tag.BillboardGui.AlwaysOnTop = false;
         v202.Base.PointLight.Color = v199.Color;
         local g_next_26 = next;
         local v204, v205 = v202:GetChildren();
         local v206 = v204;
         local v207 = v205;
         while true do
             local v208, v209 = g_next_26(v206, v207);
             local v210 = v208;
             local v211 = v209;
             if (v208) then
                 v207 = v210;
                 local t_Base_27 = v203.Base;
                 if (v211 ~= t_Base_27) then
                     local v212 = Instance.new("Weld");
                     v212.Part0 = v203.Base;
                     v212.Part1 = v211;
                     v212.C0 = v203.Base.CFrame:inverse() * v211.CFrame;
                     v212.Parent = v203.Base;
                 end
                 if (v211:IsA("BasePart")) then
                     v211.Massless = true;
                     v211.CastShadow = false;
                     v211.Anchored = false;
                     v211.CanCollide = false;
                 end
             else
                 break;
             end
         end
         local v213 = Instance.new("Weld");
         v213.Part0 = v201.torso;
         v213.Part1 = v203.Base;
         v213.Parent = v203.Base;
         v203.Parent = workspace.Ignore.Misc;
         u89[v199.Name].carrymodel = v203;
     end
 end;
 local f_nearenemyflag;
 f_nearenemyflag = function(p42, p43)
     --[[
         Name: nearenemyflag
         Line: 1014
         Upvalues: 
             [1] = u84
             [2] = u85
             [3] = u89
             [4] = u4
 
     --]]
     local v214 = false;
     local v215 = p43.TeamColor;
     local v216 = u84;
     local v217;
     if (v215 == v216) then
         v217 = u85;
         if (not v217) then
             v214 = true;
         end
     else
         v214 = true;
     end
     if (v214) then
         v217 = u84;
     end
     if (u89[v217.Name] and u89[v217.Name].basecf) then
         local v218 = u4:getplayerpos(p43);
         local v219 = v218;
         if (v218 and ((u89[v217.Name].basecf.p - v219).Magnitude <= 100)) then
             return true;
         end
     end
     return false;
 end;
 u4.nearenemyflag = f_nearenemyflag;
 local f_gamemodestep;
 f_gamemodestep = function()
     --[[
         Name: gamemodestep
         Line: 1031
         Upvalues: 
             [1] = u87
             [2] = u88
             [3] = t_GameMode_18
             [4] = t_LocalPlayer_11
             [5] = u84
             [6] = u85
             [7] = u89
             [8] = u86
             [9] = f_resetflag
             [10] = f_attachflag
 
     --]]
     u87.Visible = false;
     u88.Visible = false;
     local t_Value_28 = t_GameMode_18.Value;
     if (t_Value_28 == "Capture the Flag") then
         local v220 = false;
         local v221 = t_LocalPlayer_11.TeamColor;
         local v222 = u84;
         local v223;
         if (v221 == v222) then
             v223 = u85;
             if (not v223) then
                 v220 = true;
             end
         else
             v220 = true;
         end
         if (v220) then
             v223 = u84;
         end
         local v224 = u89[v223.Name].carrier;
         local v225 = t_LocalPlayer_11;
         if ((v224 == v225) and u89[v223.Name].revealtime) then
             u87.Visible = true;
             u87.Text = "Capturing Enemy Flag!";
             u88.Visible = true;
             local t_revealtime_29 = u89[v223.Name].revealtime;
             if (tick() <= t_revealtime_29) then
                 u88.Text = "Position revealed in " .. (math.ceil(t_revealtime_29 - tick()) .. " seconds");
             else
                 u88.Text = "Flag position revealed to all enemies!";
             end
         end
         local g_next_30 = next;
         local v226 = u86;
         local v227 = nil;
         while true do
             local v228, v229 = g_next_30(v226, v227);
             local v230 = v228;
             local v231 = v229;
             if (v228) then
                 v227 = v230;
                 local v232 = u89[v231.Name];
                 local v233 = v232;
                 if (v232.carrier) then
                     local v234 = v233.carrier;
                     local v235 = t_LocalPlayer_11;
                     if (v234 ~= v235) then
                         if (not v233.carrier.Parent) then
                             f_resetflag(v231, nil);
                         end
                         if (not v233.carrymodel) then
                             f_attachflag(v233.carrier);
                         end
                         if ((v233.carrymodel and v233.carrymodel.Parent) and v233.revealtime) then
                             local t_BillboardGui_31 = v233.carrymodel.Tag.BillboardGui;
                             local v236 = t_LocalPlayer_11.TeamColor;
                             local t_TeamColor_32 = v233.carrier.TeamColor;
                             local v237;
                             if (v236 == t_TeamColor_32) then
                                 v237 = "Capturing!";
                             else
                                 v237 = "Stolen!";
                             end
                             local v238 = true;
                             local v239 = t_LocalPlayer_11.TeamColor;
                             local t_TeamColor_33 = v233.carrier.TeamColor;
                             if (v239 ~= t_TeamColor_33) then
                                 v238 = v233.revealtime < tick();
                             end
                             t_BillboardGui_31.AlwaysOnTop = v238;
                             t_BillboardGui_31.Distance.Text = v237;
                         end
                     end
                 end
             else
                 break;
             end
         end
     end
 end;
 u4.gamemodestep = f_gamemodestep;
 local u90 = 0;
 local u91 = t_GameMode_18;
 local u92 = v169;
 local u93 = u89;
 local u94 = t_LocalPlayer_11;
 local f_gamemoderenderstep;
 f_gamemoderenderstep = function()
     --[[
         Name: gamemoderenderstep
         Line: 1073
         Upvalues: 
             [1] = u90
             [2] = u91
             [3] = u92
             [4] = u93
             [5] = u94
 
     --]]
     u90 = u90 + 1;
     local t_Value_34 = u91.Value;
     if (t_Value_34 == "Capture the Flag") then
         local g_next_35 = next;
         local v240, v241 = workspace.Ignore.GunDrop:GetChildren();
         local v242 = v240;
         local v243 = v241;
         while true do
             local v244, v245 = g_next_35(v242, v243);
             local v246 = v244;
             local v247 = v245;
             if (v244) then
                 v243 = v246;
                 local t_Name_36 = v247.Name;
                 if (t_Name_36 == "FlagDrop") then
                     v247:SetPrimaryPartCFrame((v247.Location.Value * CFrame.new(0, 0.2 * math.sin((u90 * 5) * u92), 0)) * CFrame.Angles(0, (u90 * 4) * u92, 0));
                     if (u93[v247.TeamColor.Value.Name].dropped) then
                         local v248 = v247.Base:FindFirstChild("BillboardGui");
                         local v249 = v248;
                         local v250 = u93[v247.TeamColor.Value.Name].droptime;
                         local t_droptime_37 = v250;
                         if (v248 and v250) then
                             local v251 = t_droptime_37 + 60;
                             if (tick() <= v251) then
                                 local v252 = math.floor((t_droptime_37 + 60) - tick());
                                 local t_Status_38 = v249.Status;
                                 local v253 = u94.TeamColor;
                                 local t_Value_39 = v247.TeamColor.Value;
                                 local v254;
                                 if (v253 == t_Value_39) then
                                     v254 = "Returning in:";
                                 else
                                     v254 = "Pick up in: ";
                                 end
                                 t_Status_38.Text = v254 .. v252;
                             end
                         end
                     end
                 end
             else
                 break;
             end
         end
     end
 end;
 u4.gamemoderenderstep = f_gamemoderenderstep;
 u4.attachflag = f_attachflag;
 u12:add("stealflag", function(p44, p45)
     --[[
         Name: (empty)
         Line: 1096
         Upvalues: 
             [1] = u84
             [2] = u85
             [3] = u89
             [4] = t_LocalPlayer_11
             [5] = u2
             [6] = t_PointLight_19
             [7] = f_attachflag
 
     --]]
     local v255 = false;
     local v256 = p44.TeamColor;
     local v257 = u84;
     local v258;
     if (v256 == v257) then
         v258 = u85;
         if (not v258) then
             v255 = true;
         end
     else
         v255 = true;
     end
     if (v255) then
         v258 = u84;
     end
     u89[v258.Name].revealtime = p45;
     u89[v258.Name].carrier = p44;
     if (u89[v258.Name].dropmodel) then
         u89[v258.Name].dropmodel:Destroy();
         u89[v258.Name].dropmodel = nil;
     end
     local v259 = t_LocalPlayer_11;
     if (not ((p44 == v259) and u2.rootpart)) then
         f_attachflag(p44);
         return;
     end
     u89.caplight = t_PointLight_19:Clone();
     u89.caplight.Color = v258.Color;
     u89.caplight.Parent = u2.rootpart;
 end);
 u12:add("updateflagrecover", function(p46, p47, p48)
     --[[
         Name: (empty)
         Line: 1115
         Upvalues: 
             [1] = u89
 
     --]]
     local v260 = u89[p46.Name];
     local v261 = v260;
     if (v260.dropmodel) then
         local v262 = v261.dropmodel:FindFirstChild("IsCapping");
         local v263 = v262;
         local v264 = v261.dropmodel:FindFirstChild("CapPoint");
         local v265 = v264;
         if (v262 and v264) then
             v263.Value = p47;
             v265.Value = p48;
         end
     end
 end);
 u12:add("dropflag", function(p49, p50, p51, p52, p53)
     --[[
         Name: (empty)
         Line: 1127
         Upvalues: 
             [1] = f_dropflag
             [2] = f_resetflag
 
     --]]
     f_dropflag(p49, p51, p52, p53);
     f_resetflag(p49, p50);
 end);
 local f_clearmap;
 f_clearmap = function()
     --[[
         Name: clearmap
         Line: 1132
         Upvalues: 
             [1] = f_cleanflags
 
     --]]
     print("Clearing map");
     workspace.Ignore.GunDrop:ClearAllChildren();
     f_cleanflags();
 end;
 u12:add("getrounddata", function(p54)
     --[[
         Name: (empty)
         Line: 1140
         Upvalues: 
             [1] = u86
             [2] = u89
             [3] = u12
             [4] = f_attachflag
             [5] = f_dropflag
 
     --]]
     print("received game round data");
     local v266 = game.ReplicatedStorage.ServerSettings;
     local t_Value_40 = v266.GameMode.Value;
     if ((v266.AllowSpawn.Value and (t_Value_40 == "Capture the Flag")) and p54.ctf) then
         local g_next_41 = next;
         local v267 = u86;
         local v268 = nil;
         while true do
             local v269, v270 = g_next_41(v267, v268);
             local v271 = v269;
             local v272 = v270;
             if (v269) then
                 v268 = v271;
                 local v273 = p54.ctf[v272.Name];
                 local v274 = v273;
                 if (v273 and u89[v272.Name]) then
                     if (v274.droptime) then
                         v274.droptime = u12.fromservertick(v274.droptime);
                     end
                     if (v274.revealtime) then
                         v274.revealtime = u12.fromservertick(v274.revealtime);
                     end
                     u89[v272.Name].basecf = v274.basecf;
                     if (v274.carrier and (not v274.dropped)) then
                         u89[v272.Name].carrier = v274.carrier;
                         u89[v272.Name].revealtime = v274.revealtime;
                         f_attachflag(v274.carrier);
                     else
                         if (v274.dropped) then
                             u89[v272.Name].dropped = true;
                             f_dropflag(v272, v274.dropcf, v274.droptime, false);
                         else
                             u89[v272.Name].dropped = false;
                             f_dropflag(v272, v274.basecf, v274.droptime, true);
                         end
                     end
                 end
             else
                 break;
             end
         end
     end
 end);
 v16.Reset:connect(f_clearmap);
 local f_gethealth;
 f_gethealth = function(p55)
     --[[
         Name: gethealth
         Line: 1177
         Upvalues: 
             [1] = f_gethealthstate
 
     --]]
     local v275 = f_gethealthstate(p55);
     local v276 = v275;
     if (not v275) then
         return 0, 100;
     end
     local t_health0_42 = v276.health0;
     local t_healtick0_43 = v276.healtick0;
     local t_healrate_44 = v276.healrate;
     local t_maxhealth_45 = v276.maxhealth;
     if (not v276.alive) then
         return 0, t_maxhealth_45;
     end
     local v277 = tick() - t_healtick0_43;
     local v278 = v277;
     if (v277 <= 0) then
         return t_health0_42, t_maxhealth_45;
     end
     local v279 = false;
     local v280 = t_health0_42 + ((v278 * v278) * t_healrate_44);
     local v281 = v280;
     local v282;
     if (v280 <= t_maxhealth_45) then
         v282 = v281;
         if (not v282) then
             v279 = true;
         end
     else
         v279 = true;
     end
     if (v279) then
         v282 = t_maxhealth_45;
     end
     return v282, t_maxhealth_45;
 end;
 local u95 = v108.SightFront;
 local t_SightRear_46 = v108.SightRear;
 local t_ReticleImage_47 = t_SightRear_46.ReticleImage;
 local f_updatescope;
 f_updatescope = function(p56, p57, p58, p59)
     --[[
         Name: updatescope
         Line: 1243
         Upvalues: 
             [1] = u95
             [2] = t_SightRear_46
 
     --]]
     u95.Position = p56;
     t_SightRear_46.Position = p57;
     u95.Size = p58;
     t_SightRear_46.Size = p59;
 end;
 u4.updatescope = f_updatescope;
 local f_setscopesettings;
 f_setscopesettings = function(p60, p61)
     --[[
         Name: setscopesettings
         Line: 1251
         Upvalues: 
             [1] = u95
             [2] = t_ReticleImage_47
 
     --]]
     local v283 = u95;
     local v284 = p61.scopelenscolor;
     if (not v284) then
         v284 = Color3.new(0, 0, 0);
     end
     local v285 = false;
     v283.BackgroundColor3 = v284;
     u95.BackgroundTransparency = p61.scopelenstrans or 1;
     local v286 = p61.scopeimagesize or 1;
     t_ReticleImage_47.Image = p61.scopeid;
     local v287 = t_ReticleImage_47;
     local v288;
     if (p61.sightcolor) then
         v288 = Color3.new(p61.sightcolor.r / 255, p61.sightcolor.g / 255, p61.sightcolor.b / 255);
         if (not v288) then
             v285 = true;
         end
     else
         v285 = true;
     end
     if (v285) then
         v288 = p61.scopecolor;
         if (not v288) then
             v288 = Color3.new(1, 1, 1);
         end
     end
     v287.ImageColor3 = v288;
     t_ReticleImage_47.Size = UDim2.new(v286, 0, v286, 0);
     t_ReticleImage_47.Position = UDim2.new((1 - v286) / 2, 0, (1 - v286) / 2, 0);
 end;
 u4.setscopesettings = f_setscopesettings;
 u95 = tick;
 local u96 = u95();
 local u97 = u10;
 local u98 = u41;
 local u99 = u8;
 local u100 = u12;
 local f_gundrop;
 f_gundrop = function(p62, p63, p64)
     --[[
         Name: gundrop
         Line: 1267
         Upvalues: 
             [1] = f_gunrequire
             [2] = u97
             [3] = u98
             [4] = u99
             [5] = u96
             [6] = u100
 
     --]]
     if (p63) then
         local v289 = f_gunrequire(p64);
         local v290 = v289;
         if (v289) then
             local v291 = u97.currentgun;
             local t_currentgun_48 = v291;
             if (v291) then
                 local v292 = u98;
                 local t_controllertype_49 = u99.controllertype;
                 local v293;
                 if (t_controllertype_49 == "controller") then
                     v293 = "Hold Y";
                 else
                     v293 = "Hold V";
                 end
                 local v294 = false;
                 v292.Text = v293 .. (" to pick up [" .. ((v290.displayname or p64) .. "]"));
                 local v295 = v290.type;
                 local t_type_50 = t_currentgun_48.type;
                 if (v295 == t_type_50) then
                     v294 = true;
                 else
                     local v296 = v290.ammotype;
                     local t_ammotype_51 = t_currentgun_48.ammotype;
                     if (v296 == t_ammotype_51) then
                         v294 = true;
                     end
                 end
                 if (v294) then
                     local v297 = tick();
                     if (u96 <= v297) then
                         local v298, v299 = t_currentgun_48:dropguninfo();
                         local v300 = v299;
                         if (v299) then
                             local t_sparerounds_52 = t_currentgun_48.sparerounds;
                             if (v300 <= t_sparerounds_52) then
                                 u96 = v297 + 1;
                                 u100:send("get\226\128\139ammo", p63);
                                 return;
                             end
                         end
                     end
                 end
             else
                 return;
             end
         end
     else
         u98.Text = "";
     end
 end;
 u4.gundrop = f_gundrop;
 local f_getuse;
 f_getuse = function(p65)
     --[[
         Name: getuse
         Line: 1291
         Upvalues: 
             [1] = u41
 
     --]]
     return u41.Text ~= "";
 end;
 u4.getuse = f_getuse;
 local f_enablegamegui;
 f_enablegamegui = function(p66, p67)
     --[[
         Name: enablegamegui
         Line: 1295
         Upvalues: 
             [1] = u36
 
     --]]
     u36.Visible = p67;
 end;
 u4.enablegamegui = f_enablegamegui;
 local f_togglehudobj;
 f_togglehudobj = function(p68, p69, p70)
     --[[
         Name: togglehudobj
         Line: 1306
         Upvalues: 
             [1] = u59
 
     --]]
     local v301 = u59[p69];
     local v302 = v301;
     if (not v301) then
         warn("hud object not found");
         return;
     end
     local v303 = p70;
     p70 = v303;
     v302.gui.Visible = v303;
     v302.enabled = v303;
 end;
 u4.togglehudobj = f_togglehudobj;
 local f_isplayeralive;
 f_isplayeralive = function(p71, p72)
     --[[
         Name: isplayeralive
         Line: 1317
         Upvalues: 
             [1] = f_gethealthstate
 
     --]]
     if (p72) then
         local v304 = f_gethealthstate(p72);
         local v305 = v304;
         if (v304) then
             return v305.alive;
         end
     end
 end;
 u4.isplayeralive = f_isplayeralive;
 local f_timesinceplayercombat;
 f_timesinceplayercombat = function(p73, p74)
     --[[
         Name: timesinceplayercombat
         Line: 1326
         Upvalues: 
             [1] = u54
 
     --]]
     return tick() - (u54[p74] or 0);
 end;
 u4.timesinceplayercombat = f_timesinceplayercombat;
 local f_getplayerpos;
 f_getplayerpos = function(p75, p76)
     --[[
         Name: getplayerpos
         Line: 1330
         Upvalues: 
             [1] = u4
             [2] = u7
 
     --]]
     if (u4:isplayeralive(p76)) then
         return u7.getupdater(p76).getpos();
     end
 end;
 u4.getplayerpos = f_getplayerpos;
 local f_getplayerhealth;
 f_getplayerhealth = function(p77, p78)
     --[[
         Name: getplayerhealth
         Line: 1336
         Upvalues: 
             [1] = f_gethealth
 
     --]]
     return f_gethealth(p78);
 end;
 u4.getplayerhealth = f_getplayerhealth;
 local u101 = "Cross";
 local u102 = u4;
 local u103 = v106;
 local f_setcrosssettings;
 f_setcrosssettings = function(p79, p80, p81, p82, p83, p84, p85)
     --[[
         Name: setcrosssettings
         Line: 1342
         Upvalues: 
             [1] = u102
             [2] = u49
             [3] = u51
             [4] = u101
             [5] = u103
 
     --]]
     u102.crossspring.t = p81;
     u102.crossspring.s = p82;
     u102.crossspring.d = p83;
     u49 = p84;
     u51 = p85;
     if (p80 == "SHOTGUN") then
         u101 = "Shot";
         local v306 = 1;
         local v307 = v306;
         if (not (v307 >= 4)) then
             while true do
                 local g_next_53 = next;
                 local v308, v309 = u103[v306]:GetChildren();
                 local v310 = v308;
                 local v311 = v309;
                 while true do
                     local v312, v313 = g_next_53(v310, v311);
                     local v314 = v312;
                     local v315 = v313;
                     if (v312) then
                         v311 = v314;
                         local v316 = v315.Name;
                         local v317 = u101;
                         if (v316 == v317) then
                             v315.Visible = true;
                         end
                     else
                         break;
                     end
                 end
                 local v318 = v306 + 1;
                 v306 = v318;
                 if (v318 > 4) then
                     return;
                 end
             end
         end
     else
         u101 = "Cross";
         local v319 = 1;
         local v320 = v319;
         if (not (v320 >= 4)) then
             while true do
                 local g_next_54 = next;
                 local v321, v322 = u103[v319]:GetChildren();
                 local v323 = v321;
                 local v324 = v322;
                 while true do
                     local v325, v326 = g_next_54(v323, v324);
                     local v327 = v325;
                     local v328 = v326;
                     if (v325) then
                         v324 = v327;
                         v328.Visible = false;
                     else
                         break;
                     end
                 end
                 local v329 = v319 + 1;
                 v319 = v329;
                 if (v329 > 4) then
                     break;
                 end
             end
         end
     end
 end;
 u4.setcrosssettings = f_setcrosssettings;
 local f_updatesightmark;
 f_updatesightmark = function(p86, p87, p88)
     --[[
         Name: updatesightmark
         Line: 1368
         Upvalues: 
             [1] = u49
             [2] = u51
 
     --]]
     u49 = p87;
     u51 = p88;
 end;
 u4.updatesightmark = f_updatesightmark;
 local f_updatescopemark;
 f_updatescopemark = function(p89, p90)
     --[[
         Name: updatescopemark
         Line: 1373
         Upvalues: 
             [1] = u50
 
     --]]
     u50 = p90;
 end;
 u4.updatescopemark = f_updatescopemark;
 local u104 = u2;
 local u105 = u59;
 local u106 = u4;
 local u107 = v105;
 local u108 = v106;
 local t_getscale_55 = v98;
 local u109 = u16;
 local u110 = u37;
 local f_updatecross;
 f_updatecross = function()
     --[[
         Name: updatecross
         Line: 1377
         Upvalues: 
             [1] = u104
             [2] = u105
             [3] = u106
             [4] = u107
             [5] = u101
             [6] = u108
             [7] = t_getscale_55
             [8] = u51
             [9] = u49
             [10] = u109
             [11] = u110
 
     --]]
     if (not ((u104.speed and u104.sprint) and u105.crossframe.enabled)) then
         return;
     end
     local v330 = (((u106.crossspring.p * 2) * u106.crossscale.p) * ((((u104.speed / 14) * 0.19999999999999996) * 2) + 0.8)) * ((u104.sprint / 2) + 1);
     u107.Visible = false;
     local v331 = u101;
     if (v331 == "Cross") then
         local v332 = 1;
         local v333 = v332;
         if (not (v333 >= 4)) then
             while true do
                 u108[v332].BackgroundTransparency = 1 - (v330 / 20);
                 local v334 = v332 + 1;
                 v332 = v334;
                 if (v334 > 4) then
                     break;
                 end
             end
         end
     else
         local v335 = 1;
         local v336 = v335;
         if (not (v336 >= 4)) then
             while true do
                 u108[v335].BackgroundTransparency = 1;
                 local g_next_57 = next;
                 local v337, v338 = u108[v335]:GetChildren();
                 local v339 = v337;
                 local v340 = v338;
                 while true do
                     local v341, v342 = g_next_57(v339, v340);
                     local v343 = v341;
                     local v344 = v342;
                     if (v341) then
                         v340 = v343;
                         local v345 = v344.Name;
                         local v346 = u101;
                         if (v345 == v346) then
                             v344.BackgroundTransparency = 1 - ((v330 / 20) * (v330 / 20));
                         end
                     else
                         break;
                     end
                 end
                 local v347 = v335 + 1;
                 v335 = v347;
                 if (v347 > 4) then
                     break;
                 end
             end
         end
     end
     u108[1].Position = UDim2.new(0, v330, 0, 0);
     u108[2].Position = UDim2.new(0, (-v330) - 7, 0, 0);
     u108[3].Position = UDim2.new(0, 0, 0, v330);
     u108[4].Position = UDim2.new(0, 0, 0, (-v330) - 7);
     local v348 = t_getscale_55();
     if (not u51) then
         local t_t_56 = u106.crossspring.t;
         if (((t_t_56 == 0) and u49) and u49.Parent) then
             local v349 = u109.currentcamera:WorldToViewportPoint(u49.Position);
             u110.Position = UDim2.new(0, (v349.x / v348) - 125, 0, (v349.y / v348) - 125);
             return;
         end
     end
     u110.Position = UDim2.new(0.5, -125, 0.5, -125);
 end;
 local f_getplayervisible;
 f_getplayervisible = function(p91, p92)
     --[[
         Name: getplayervisible
         Line: 1425
         Upvalues: 
             [1] = u52
 
     --]]
     local v350 = u52[p92];
     local v351 = v350;
     if (v350) then
         return v351.Visible;
     end
 end;
 u4.getplayervisible = f_getplayervisible;
 local u111 = {};
 local f_addnametag;
 f_addnametag = function(p93)
     --[[
         Name: addnametag
         Line: 1433
         Upvalues: 
             [1] = t_LocalPlayer_11
             [2] = u111
             [3] = t_PlayerTag_12
             [4] = u38
             [5] = u52
             [6] = u4
             [7] = u7
             [8] = u15
             [9] = u16
             [10] = f_gethealth
             [11] = u9
             [12] = u55
 
     --]]
     local v352 = t_LocalPlayer_11;
     if (p93 == v352) then
         return;
     end
     local v353 = {};
     u111[p93] = v353;
     local u112 = nil;
     local u113 = nil;
     local u114 = p93;
     local f_playerchanged;
     f_playerchanged = function(p94)
         --[[
             Name: playerchanged
             Line: 1453
             Upvalues: 
                 [1] = u112
                 [2] = u114
                 [3] = t_LocalPlayer_11
                 [4] = u113
 
         --]]
         if (((p94 == "TeamColor") and u112) and u112.Parent) then
             local v354 = u114.TeamColor;
             local t_TeamColor_58 = t_LocalPlayer_11.TeamColor;
             if (v354 == t_TeamColor_58) then
                 u112.Visible = true;
                 u113.Visible = false;
                 u112.TextColor3 = Color3.new(0, 1, 0.9176470588235294);
                 u112.Dot.BackgroundTransparency = 1;
                 u112.Dot.Rotation = 90;
                 u112.Dot.Size = UDim2.new(0, 6, 0, 6);
                 return;
             end
             u112.Visible = false;
             u113.Visible = false;
             u112.TextColor3 = Color3.new(1, 0.0392156862745098, 0.0784313725490196);
             u112.Dot.BackgroundTransparency = 1;
             u112.Dot.Rotation = 45;
             u112.Dot.Size = UDim2.new(0, 4, 0, 4);
         end
     end;
     local u115 = p93;
     local f_playerchanged = f_playerchanged;
     local f_newtag;
     f_newtag = function()
         --[[
             Name: newtag
             Line: 1473
             Upvalues: 
                 [1] = u112
                 [2] = t_PlayerTag_12
                 [3] = u115
                 [4] = u113
                 [5] = u38
                 [6] = f_playerchanged
                 [7] = u52
 
         --]]
         u112 = t_PlayerTag_12:Clone();
         u112.Text = u115.Name;
         u112.Visible = false;
         u113 = u112:WaitForChild("Health");
         u112.Dot.BackgroundTransparency = 1;
         u112.TextTransparency = 1;
         u112.TextStrokeTransparency = 1;
         u112.Parent = u38;
         f_playerchanged("TeamColor");
         u52[u115] = u112;
     end;
     f_newtag();
     local u116 = p93;
     local f_update;
     f_update = function()
         --[[
             Name: update
             Line: 1488
             Upvalues: 
                 [1] = u112
                 [2] = u113
                 [3] = u4
                 [4] = u116
                 [5] = u7
                 [6] = u15
                 [7] = u16
                 [8] = t_LocalPlayer_11
                 [9] = f_gethealth
                 [10] = u9
 
         --]]
         if (not (u112.Parent and u113.Parent)) then
             return;
         end
         if (u4:isplayeralive(u116)) then
             local v355, v356 = u7.getupdater(u116).getpos();
             local v357 = v355;
             local v358 = v356;
             if (v355 and v356) then
                 if (u15.sphere(v357, 4)) then
                     local v359 = u16.cframe;
                     local v360 = u16.currentcamera:WorldToScreenPoint(v358 + v359:VectorToWorldSpace(Vector3.new(0, 0.625, 0)));
                     local v361 = (v357 - v359.Position).magnitude;
                     local v362 = u16.lookvector:Dot((v357 - v359.Position).unit);
                     local v363 = (((1 / (v362 * v362)) - 1) ^ 0.5) * v361;
                     u112.Position = UDim2.new(0, v360.x - 75, 0, v360.y);
                     if (u4.streamermode()) then
                         u112.Text = "Player";
                     else
                         u112.Text = u116.Name;
                     end
                     local v364 = u116.TeamColor;
                     local t_TeamColor_59 = t_LocalPlayer_11.TeamColor;
                     if (v364 == t_TeamColor_59) then
                         u112.Visible = true;
                         u113.Visible = true;
                         u112.TextColor3 = Color3.new(0, 1, 0.9176470588235294);
                         u112.Dot.BackgroundColor3 = Color3.new(0, 1, 0.9176470588235294);
                         local v365, v366 = f_gethealth(u116);
                         local v367 = v365;
                         local v368 = v366;
                         if (v363 <= 4) then
                             u112.TextTransparency = 0.125;
                             u113.BackgroundTransparency = 0.75;
                             u113.Percent.BackgroundTransparency = 0.25;
                             u113.Percent.Size = UDim2.new(v367 / v368, 0, 1, 0);
                             u112.Dot.BackgroundTransparency = 1;
                             return;
                         end
                         if (not (v363 <= 8)) then
                             u112.Dot.BackgroundTransparency = 0.125;
                             u112.TextTransparency = 1;
                             u113.BackgroundTransparency = 1;
                             u113.Percent.BackgroundTransparency = 1;
                             return;
                         end
                         u112.TextTransparency = 0.125 + ((0.875 * (v363 - 4)) / 4);
                         u113.BackgroundTransparency = 0.75 + ((0.25 * (v363 - 4)) / 4);
                         u113.Percent.BackgroundTransparency = 0.25 + ((0.75 * (v363 - 4)) / 4);
                         u113.Percent.Size = UDim2.new(v367 / v368, 0, 1, 0);
                         u112.Dot.BackgroundTransparency = 1;
                         return;
                     end
                     u112.Dot.BackgroundTransparency = 1;
                     u113.Visible = false;
                     u112.TextColor3 = Color3.new(1, 0.0392156862745098, 0.0784313725490196);
                     u112.Dot.BackgroundColor3 = Color3.new(1, 0.0392156862745098, 0.0784313725490196);
                     if (u4:isspotted(u116) and u4:isinsight(u116)) then
                         u112.Visible = true;
                         if (v363 <= 4) then
                             u112.TextTransparency = 0;
                             return;
                         end
                         u112.TextTransparency = 1;
                         u112.Dot.BackgroundTransparency = 0;
                         return;
                     end
                     if ((not u4:isspotted(u116)) and (v363 <= 4)) then
                         local v369 = u16.cframe.p;
                         local v370 = not workspace:FindPartOnRayWithWhitelist(Ray.new(v369, v357 - v369), u9.raycastwhitelist);
                         u112.Visible = v370;
                         if (v370) then
                             if (v363 <= 2) then
                                 u112.Visible = true;
                                 u112.TextTransparency = 0.125;
                                 return;
                             end
                             if (not (v363 <= 4)) then
                                 u112.Visible = false;
                                 return;
                             end
                             u112.Visible = true;
                             u112.TextTransparency = (0.4375 * v363) - 0.75;
                             return;
                         end
                     else
                         u112.Visible = false;
                         u113.Visible = false;
                         return;
                     end
                 else
                     u112.Visible = false;
                     u113.Visible = false;
                     return;
                 end
             end
         else
             u112.Visible = false;
             u113.Visible = false;
         end
     end;
     v353[(#v353) + 1] = p93.Changed:connect(f_playerchanged);
     v353[(#v353) + 1] = t_LocalPlayer_11.Changed:connect(f_playerchanged);
     u55[p93] = f_update;
 end;
 u4.addnametag = f_addnametag;
 u4.removenametag = function(p95)
     --[[
         Name: (empty)
         Line: 1589
         Upvalues: 
             [1] = u55
             [2] = u52
 
     --]]
     u55[p95] = nil;
     if (u52[p95]) then
         u52[p95]:Destroy();
     end
     u52[p95] = nil;
 end;
 game:GetService("Players").PlayerAdded:connect(f_addnametag);
 game:GetService("Players").PlayerRemoving:connect(function(p96)
     --[[
         Name: (empty)
         Line: 1598
         Upvalues: 
             [1] = u53
             [2] = u54
             [3] = u4
             [4] = u111
 
     --]]
     u53[p96] = nil;
     u54[p96] = nil;
     u4.removenametag(p96);
     local v371 = u111[p96];
     local v372 = v371;
     if (v371) then
         local v373 = 1;
         local v374 = #v372;
         local v375 = v374;
         local v376 = v373;
         if (not (v374 <= v376)) then
             while true do
                 v372[v373]:Disconnect();
                 v372[v373] = nil;
                 local v377 = v373 + 1;
                 v373 = v377;
                 local v378 = v375;
                 if (v378 < v377) then
                     break;
                 end
             end
         end
         u111[p96] = nil;
     end
 end);
 local g_next_60 = next;
 local v379, v380 = game:GetService("Players"):GetPlayers();
 local v381 = v379;
 local v382 = v380;
 while true do
     local v383, v384 = g_next_60(v381, v382);
     local v385 = v383;
     local v386 = v384;
     if (v383) then
         v382 = v385;
         f_addnametag(v386);
     else
         break;
     end
 end
 local f_updateplayernames;
 f_updateplayernames = function()
     --[[
         Name: updateplayernames
         Line: 1617
         Upvalues: 
             [1] = u55
             [2] = u52
 
     --]]
     local g_next_61 = next;
     local v387 = u55;
     local v388 = nil;
     while true do
         local v389, v390 = g_next_61(v387, v388);
         local v391 = v389;
         if (v389) then
             v388 = v391;
             if (v391 and v391.Parent) then
                 u55[v391]();
             else
                 u55[v391] = nil;
                 if (u52[v391]) then
                     u52[v391]:Destroy();
                 end
                 u52[v391] = nil;
             end
         else
             break;
         end
     end
 end;
 local f_capping;
 f_capping = function(p97, p98, p99, p100)
     --[[
         Name: capping
         Line: 1632
         Upvalues: 
             [1] = u39
             [2] = u48
 
     --]]
     local v392;
     if (p100 == "ctf") then
         v392 = 100;
     else
         v392 = 50;
     end
     if (not p98) then
         u39.Visible = false;
         return;
     end
     u39.Visible = true;
     local t_Note_62 = u39.Note;
     local v393;
     if (p100 == "ctf") then
         v393 = "Recovering...";
     else
         v393 = "Capturing...";
     end
     t_Note_62.Text = v393;
     u48.Size = UDim2.new(p99 / v392, 0, 1, 0);
 end;
 u4.capping = f_capping;
 local f_setsteadybar;
 f_setsteadybar = function(p101, p102)
     --[[
         Name: setsteadybar
         Line: 1644
         Upvalues: 
             [1] = u43
 
     --]]
     u43.Size = p102;
 end;
 u4.setsteadybar = f_setsteadybar;
 local f_getsteadysize;
 f_getsteadysize = function(p103)
     --[[
         Name: getsteadysize
         Line: 1648
         Upvalues: 
             [1] = u43
 
     --]]
     return u43.Size.X.Scale;
 end;
 u4.getsteadysize = f_getsteadysize;
 local f_setcrossscale;
 f_setcrossscale = function(p104, p105)
     --[[
         Name: setcrossscale
         Line: 1652
         Upvalues: 
             [1] = u4
 
     --]]
     u4.crossscale.t = p105;
 end;
 u4.setcrossscale = f_setcrossscale;
 local f_setcrosssize;
 f_setcrosssize = function(p106, p107)
     --[[
         Name: setcrosssize
         Line: 1656
         Upvalues: 
             [1] = u4
 
     --]]
     u4.crossspring.t = p107;
 end;
 u4.setcrosssize = f_setcrosssize;
 local u117 = nil;
 local u118 = nil;
 local u119 = nil;
 local u120 = u16;
 local u121 = v109;
 local u122 = v113;
 local u123 = u8;
 local u124 = u21;
 local f_setscope;
 f_setscope = function(p108, p109, p110)
     --[[
         Name: setscope
         Line: 1664
         Upvalues: 
             [1] = u120
             [2] = u121
             [3] = u122
             [4] = u123
             [5] = u124
             [6] = u119
             [7] = u117
 
     --]]
     u120.setdirectlookmode(p109);
     u121.Visible = p109;
     local v394 = u122;
     local v395 = p109;
     if (v395) then
         v395 = not p110;
     end
     v394.Visible = v395;
     local v396 = u122;
     local t_controllertype_63 = u123.controllertype;
     local v397;
     if (t_controllertype_63 == "controller") then
         v397 = "Tap LS to Toggle Steady Scope";
     else
         v397 = "Hold Shift to Steady Scope";
     end
     v396.Text = v397;
     if (p109) then
         u124.play("useScope", 0.25);
         u119 = true;
         task.delay(0.5, u117);
     end
     if (not p109) then
         u119 = false;
     end
 end;
 u4.setscope = f_setscope;
 local u125 = u4;
 local u126 = u21;
 u117 = function()
     --[[
         Name: heartIn
         Line: 1681
         Upvalues: 
             [1] = u119
             [2] = u125
             [3] = u126
             [4] = u118
 
     --]]
     if (u119) then
         local v398 = u125:getsteadysize() / 5;
         u126.play("heartBeatIn", 0.05 + v398);
         task.delay(0.3 + v398, u118);
     end
 end;
 local u127 = u4;
 local u128 = u21;
 u118 = function()
     --[[
         Name: heartOut
         Line: 1689
         Upvalues: 
             [1] = u119
             [2] = u127
             [3] = u128
             [4] = u117
 
     --]]
     if (u119) then
         local v399 = u127:getsteadysize() / 4;
         u128.play("heartBeatOut", 0.05 + v399);
         task.delay(0.5 + v399, u117);
     end
 end;
 local f_updateammo;
 f_updateammo = function(p111, p112, p113)
     --[[
         Name: updateammo
         Line: 1699
         Upvalues: 
             [1] = u44
             [2] = u46
             [3] = u45
             [4] = u10
 
     --]]
     if (p112 == "KNIFE") then
         u44.Text = "- - -";
         u46.Text = "- - -";
         return;
     end
     if (p112 ~= "GRENADE") then
         u44.Text = p113;
         u46.Text = p112;
         return;
     end
     u44.Text = "- - -";
     u46.Text = "- - -";
     u45.Text = u10.gammo .. "x";
 end;
 u4.updateammo = f_updateammo;
 local f_updatefiremode;
 f_updatefiremode = function(p114, p115)
     --[[
         Name: updatefiremode
         Line: 1713
         Upvalues: 
             [1] = u47
 
     --]]
     local v400 = u47;
     local v401;
     if (p115 == "KNIFE") then
         v401 = "- - -";
     else
         if (p115 == true) then
             v401 = "AUTO";
         else
             if (p115 == 1) then
                 v401 = "SEMI";
             else
                 if (p115 == "BINARY") then
                     v401 = "BINARY";
                 else
                     v401 = "BURST";
                 end
             end
         end
     end
     v400.Text = v401;
 end;
 u4.updatefiremode = f_updatefiremode;
 local f_firehitmarker;
 f_firehitmarker = function(p116, p117)
     --[[
         Name: firehitmarker
         Line: 1718
         Upvalues: 
             [1] = u4
             [2] = u37
 
     --]]
     u4.hitspring.p = -3;
     if (p117) then
         u37.ImageColor3 = Color3.new(1, 0, 0);
         return;
     end
     u37.ImageColor3 = Color3.new(1, 1, 1);
 end;
 u4.firehitmarker = f_firehitmarker;
 local u129 = {};
 u129.lightred = Color3.new(0.7843137254901961, 0.19607843137254902, 0.19607843137254902);
 u129.lightblue = Color3.new(0, 0.7843137254901961, 1);
 u129.green = Color3.new(0, 1, 0.2);
 u129.red = Color3.new(1, 0, 0);
 local u130 = u59.radar;
 local v402 = math.pi / 180;
 local v403 = t_ReplicatedStorage_13:WaitForChild("MiniMapModels");
 local v404 = t_ReplicatedStorage_13.ServerSettings:WaitForChild("MapName");
 local v405 = v403:WaitForChild("Temp");
 local u131 = 0;
 local u132 = false;
 local u133 = 0;
 local v406 = u36:WaitForChild("MiniMapFrame");
 local u134 = nil;
 local u135 = nil;
 local u136 = nil;
 local v407 = workspace:FindFirstChild("Map");
 local u137 = nil;
 local u138 = nil;
 local u139 = nil;
 local u140 = {};
 u140.players = {};
 u140.objectives = {};
 u140.rings = {};
 local v408 = u36:WaitForChild("Radar");
 local u141 = v408:WaitForChild("Folder");
 local v409 = u35.AbsoluteSize.X;
 local v410 = u35.AbsoluteSize.Y;
 local v411 = v408.AbsoluteSize.X;
 local v412 = v408.AbsoluteSize.Y;
 local u142 = {};
 local u143 = {};
 local u144 = {};
 local u145 = v408:WaitForChild("Me");
 u145.Size = UDim2.new(0, 16, 0, 16);
 u145.Position = UDim2.new(0.5, -8, 0.5, -8);
 local u146 = {};
 u146.players = u145;
 u146.objectives = v408:WaitForChild("Objective");
 local f_reset_minimap;
 f_reset_minimap = function(p118)
     --[[
         Name: reset_minimap
         Line: 1807
     --]]
 end;
 u4.reset_minimap = f_reset_minimap;
 local u147 = v407;
 local u148 = v406;
 local u149 = v404;
 local u150 = v403;
 local u151 = v405;
 local f_set_minimap;
 f_set_minimap = function(p119)
     --[[
         Name: set_minimap
         Line: 1819
         Upvalues: 
             [1] = u147
             [2] = u137
             [3] = u138
             [4] = u136
             [5] = u148
             [6] = u134
             [7] = u149
             [8] = u150
             [9] = u135
             [10] = u151
 
     --]]
     if (u147) then
         u137 = u147.PrimaryPart;
         u138 = u147:FindFirstChild("AGMP");
         local v413 = u148:FindFirstChild("Camera");
         if (not v413) then
             v413 = Instance.new("Camera");
         end
         u136 = v413;
         u136.FieldOfView = 45;
         u148.CurrentCamera = u136;
         u136.Parent = u148;
         if (u134) then
             local v414 = u134.Name;
             local t_Value_64 = u149.Value;
             if (v414 == t_Value_64) then
             end
         end
         if (u134) then
             u134:Destroy();
         end
         local v415 = u150:FindFirstChild(u149.Value);
         local v416 = v415;
         if (v415) then
             u134 = v416:Clone();
             u134.Parent = u148;
             u135 = u134.PrimaryPart;
             return;
         end
         u134 = u151:Clone();
         u134.Parent = u148;
         u135 = u134.PrimaryPart;
         return;
     end
     print("Did not find map");
 end;
 u4.set_minimap = f_set_minimap;
 local f_gen_minimap_pos;
 f_gen_minimap_pos = function(p120)
     --[[
         Name: gen_minimap_pos
         Line: 1854
         Upvalues: 
             [1] = u137
             [2] = u135
             [3] = u136
             [4] = u139
 
     --]]
     local v417, v418 = u136:WorldToViewportPoint(((u137.CFrame:inverse() * p120).p * 0.2) + u135.Position);
     local v419 = v418;
     local v420 = v417.X;
     local v421 = v417.Y;
     local v422 = v420 - 0.5;
     local v423 = 0.5 - v421;
     local v424 = (math.atan(v422 / v423) * 180) / math.pi;
     if (v423 <= 0) then
         v424 = v424 - 180;
     end
     if (v420 >= 1) then
         v420 = 1;
     end
     if (v420 <= 0) then
         v420 = 0;
     end
     if (v421 >= 1) then
         v421 = 1;
     end
     if (v421 <= 0) then
         v421 = 0;
     end
     return v420, v421, math.abs(p120.p.Y - u139.CFrame.p.Y), v419, v424;
 end;
 local f_get_ring;
 f_get_ring = function(p121)
     --[[
         Name: get_ring
         Line: 1885
         Upvalues: 
             [1] = u140
             [2] = u145
             [3] = u129
             [4] = u141
 
     --]]
     if (not u140.rings[p121]) then
         local v425 = u145:Clone();
         v425.Size = UDim2.new(0, 0, 0, 0);
         v425.ImageColor3 = u129.lightred;
         v425.Image = "rbxassetid://2925606552";
         v425.Height.Visible = false;
         v425.Parent = u141;
         u140.rings[p121] = v425;
     end
     return u140.rings[p121];
 end;
 local f_get_arrow;
 f_get_arrow = function(p122, p123)
     --[[
         Name: get_arrow
         Line: 1899
         Upvalues: 
             [1] = u140
             [2] = u146
             [3] = u141
 
     --]]
     if (not u140[p123][p122]) then
         local v426 = u146[p123]:Clone();
         v426.Size = UDim2.new(0, 14, 0, 14);
         v426.Parent = u141;
         u140[p123][p122] = v426;
     end
     return u140[p123][p122];
 end;
 local f_update_minimap_ring;
 f_update_minimap_ring = function(p124, p125)
     --[[
         Name: update_minimap_ring
         Line: 1928
         Upvalues: 
             [1] = f_gen_minimap_pos
             [2] = f_get_ring
             [3] = t_LocalPlayer_11
             [4] = u129
 
     --]]
     local v427 = (tick() - p125.shottime) / p125.lifetime;
     if (v427 >= 1) then
         return;
     end
     local v428 = false;
     local v429, v430, v431, v432 = f_gen_minimap_pos(p125.refcf);
     local v433 = v429;
     local v434 = v430;
     local v435 = f_get_ring(p124);
     local v436 = p125.size0 or 4;
     local v437 = v436 + (((p125.size1 or 30) - v436) * v427);
     local v438 = p125.teamcolor;
     local t_TeamColor_65 = t_LocalPlayer_11.TeamColor;
     local v439;
     if (v438 == t_TeamColor_65) then
         v439 = u129.lightblue;
         if (not v439) then
             v428 = true;
         end
     else
         v428 = true;
     end
     if (v428) then
         v439 = u129.lightred;
     end
     v435.ImageColor3 = v439;
     v435.ImageTransparency = v427;
     v435.Size = UDim2.new(0, v437, 0, v437);
     v435.Position = UDim2.new(v433, (-v437) / 2, v434, (-v437) / 2);
     v435.Visible = true;
 end;
 local u152 = f_gen_minimap_pos;
 local f_get_arrow = f_get_arrow;
 local u153 = t_LocalPlayer_11;
 local u154 = u129;
 local f_update_minimap_object;
 f_update_minimap_object = function(p126, p127, p128, p129, p130, p131, p132, p133)
     --[[
         Name: update_minimap_object
         Line: 1955
         Upvalues: 
             [1] = u152
             [2] = f_get_arrow
             [3] = u153
             [4] = u154
             [5] = u133
             [6] = u132
             [7] = u137
 
     --]]
     local v440, v441, v442, v443, v444 = u152(p129);
     local v445 = v440;
     local v446 = v441;
     local v447 = v443;
     local v448 = v444;
     local v449 = 14;
     local v450 = 0.002 * (v442 ^ 2.5);
     local v451 = f_get_arrow(p131, p132);
     local v452 = nil;
     if (p132 == "players") then
         local v453;
         if (p126) then
             v453 = "rbxassetid://2911984939";
         else
             v453 = "rbxassetid://3116912054";
         end
         local v454 = false;
         v451.Image = v453;
         local t_TeamColor_66 = u153.TeamColor;
         local v455;
         if (p128 == t_TeamColor_66) then
             v455 = u154.lightblue;
             if (not v455) then
                 v454 = true;
             end
         else
             v454 = true;
         end
         if (v454) then
             v455 = u154.red;
         end
         v452 = v455;
         if (p127) then
             v452 = u154.green;
         end
         v451.ImageColor3 = v452;
         v451.Height.ImageColor3 = v451.ImageColor3;
         v451.Height.Visible = (not p127) and p126;
         v451.Height.ImageTransparency = p130 or 0;
         local v456, v457, v458 = p129:ToOrientation();
         local v459 = (v457 * 180) / math.pi;
         local v460 = u133;
         if (u132) then
             v460 = u137.Orientation.Y;
         end
         if (v447) then
             v451.Rotation = v460 - v459;
             v451.ImageTransparency = p130 or v450;
         else
             v451.Rotation = v448;
             v449 = 12;
             local v461;
             if (p126) then
                 v461 = "rbxassetid://2910531391";
             else
                 v461 = "rbxassetid://3116912054";
             end
             v451.Image = v461;
             v451.ImageTransparency = p130 or 0;
         end
         v451.Size = UDim2.new(0, v449, 0, v449);
     else
         if (p132 == "objectives") then
             v452 = p128.Color;
             v451.Label.Text = p133;
             v451.Label.TextColor3 = v452;
             v451.Label.Visible = true;
         end
     end
     v451.ImageColor3 = v452;
     v451.Position = UDim2.new(v445, (-v449) / 2, v446, (-v449) / 2);
     v451.Visible = true;
 end;
 local f_fireradar;
 f_fireradar = function(p134, p135, p136, p137, p138)
     --[[
         Name: fireradar
         Line: 2007
         Upvalues: 
             [1] = t_LocalPlayer_11
             [2] = u142
             [3] = u143
             [4] = u4
 
     --]]
     local v462 = p135.TeamColor ~= t_LocalPlayer_11.TeamColor;
     local v463 = v462;
     local v464 = u142[p135];
     if ((not v464) and v462) then
         local v465 = {};
         v465.refcf = CFrame.new();
         v465.shottime = 0;
         v465.lifetime = 0;
         v464 = v465;
         u142[p135] = v464;
     end
     local v466 = u143[p135];
     if (not v466) then
         local v467 = {};
         v467.refcf = CFrame.new();
         v467.shottime = 0;
         v467.lifetime = 0;
         v467.teamcolor = p135.TeamColor;
         v466 = v467;
         u143[p135] = v466;
     end
     if (u4:isplayeralive(p135)) then
         v466.refcf = p138;
         v466.teamcolor = p135.TeamColor;
         v466.lifetime = p137.pinglife or 0.5;
         v466.size0 = p137.size0;
         v466.size1 = p137.size1;
         local v468 = tick();
         if ((v466.shottime + v466.lifetime) <= v468) then
             v466.shottime = tick();
         end
         if ((not p136) and v463) then
             v464.refcf = p138;
             v464.lifetime = 5;
             v464.shottime = tick();
         end
     end
 end;
 u4.fireradar = f_fireradar;
 local f_set_rel_height;
 f_set_rel_height = function(p139)
     --[[
         Name: set_rel_height
         Line: 2059
         Upvalues: 
             [1] = u131
 
     --]]
     local v469 = u131;
     local v470;
     if (v469 == 0) then
         v470 = 1;
     else
         v470 = 0;
     end
     u131 = v470;
 end;
 u4.set_rel_height = f_set_rel_height;
 local f_set_minimap_style;
 f_set_minimap_style = function(p140)
     --[[
         Name: set_minimap_style
         Line: 2063
         Upvalues: 
             [1] = u132
 
     --]]
     u132 = not u132;
 end;
 u4.set_minimap_style = f_set_minimap_style;
 local u155 = u16;
 local u156 = u2;
 local u157 = u145;
 local u158 = u129;
 local u159 = v402;
 local u160 = u7;
 local u161 = u144;
 local u162 = t_LocalPlayer_11;
 local u163 = u4;
 local f_update_minimap_object = f_update_minimap_object;
 local u164 = u142;
 local u165 = u143;
 local f_update_minimap_ring = f_update_minimap_ring;
 local f_updateminimap;
 f_updateminimap = function()
     --[[
         Name: updateminimap
         Line: 2067
         Upvalues: 
             [1] = u137
             [2] = u135
             [3] = u139
             [4] = u155
             [5] = u156
             [6] = u157
             [7] = u158
             [8] = u131
             [9] = u133
             [10] = u132
             [11] = u136
             [12] = u159
             [13] = u160
             [14] = u161
             [15] = u162
             [16] = u163
             [17] = f_update_minimap_object
             [18] = u164
             [19] = u165
             [20] = f_update_minimap_ring
             [21] = u138
 
     --]]
     if (not u137) then
         return print("No map found");
     end
     if (not u135) then
         return print("No minimap found");
     end
     local v471 = u155:isspectating();
     if (not v471) then
         v471 = u155.currentcamera;
     end
     u139 = v471;
     if (u156.alive) then
         u157.Visible = true;
         u157.ImageColor3 = u158.lightblue;
     else
         u157.Visible = u155:isspectating();
         u157.ImageColor3 = u158.red;
     end
     u157.Height.ImageColor3 = u157.ImageColor3;
     local v472 = ((u137.CFrame:inverse() * u139.CFrame).p * 0.2) * Vector3.new(1, u131, 1);
     local v473, v474, v475 = u155.cframe:ToOrientation();
     u133 = (v474 * 180) / math.pi;
     local v476 = u137.Orientation.Y - u133;
     local v477 = v472 + u135.Position;
     if (u132) then
         u136.CFrame = CFrame.new(v477 + Vector3.new(0, 50, 0)) * CFrame.Angles(-90 * u159, 0, 0);
         u157.Rotation = v476;
     else
         u136.CFrame = (CFrame.new(v477 + Vector3.new(0, 50, 0)) * CFrame.Angles(0, (-v476) * u159, 0)) * CFrame.Angles(-90 * u159, 0, 0);
         u157.Rotation = 0;
     end
     local v478 = 0;
     local v479 = game:GetService("Players"):GetPlayers();
     local v480 = v479;
     local v481 = 1;
     local v482 = #v479;
     local v483 = v482;
     local v484 = v481;
     if (not (v482 <= v484)) then
         while true do
             local v485 = nil;
             local v486 = v480[v481];
             local v487 = v486;
             local v488 = u160.getbodyparts(v486);
             local v489 = u161[v486];
             local v490 = u162 == v486;
             local v491 = u163:isplayeralive(v486);
             if (not v491) then
                 v491 = v490;
                 if (v491) then
                     v491 = u156.alive;
                 end
             end
             if (v488) then
                 v485 = v488.torso;
             else
                 if (v490) then
                     v485 = u156.rootpart;
                 end
             end
             if (not v489) then
                 local v492 = {};
                 v492.lastcf = CFrame.new();
                 v492.alivetick = 0;
                 v489 = v492;
                 u161[v487] = v489;
             end
             if (v485 and v491) then
                 v489.lastcf = v485.CFrame;
                 v489.alivetick = tick();
             end
             local v493 = nil;
             local v494 = not v490;
             if (v494) then
                 v494 = v487.TeamColor == u162.TeamColor;
             end
             if (v491) then
                 if (((not v494) and u163:isspotted(v487)) and u163:isinsight(v487)) then
                     v493 = 0;
                     v494 = true;
                 end
             else
                 local v495 = false;
                 local v496 = (tick() - v489.alivetick) / 5;
                 local v497;
                 if (v496 >= 0.1) then
                     v497 = v496 ^ 0.5;
                     if (not v497) then
                         v495 = true;
                     end
                 else
                     v495 = true;
                 end
                 if (v495) then
                     v497 = 0;
                 end
                 v493 = math.min(v497, 1);
                 v494 = v493 ~= 1;
             end
             local v498 = v489.lastcf;
             local t_lastcf_67 = v498;
             if (v498 and v494) then
                 v478 = v478 + 1;
                 f_update_minimap_object(v491, v490, v487.TeamColor, t_lastcf_67, v493, v478, "players");
             end
             local v499 = v481 + 1;
             v481 = v499;
             local v500 = v483;
             if (v500 < v499) then
                 break;
             end
         end
     end
     local g_next_68 = next;
     local v501 = u164;
     local v502 = nil;
     while true do
         local v503, v504 = g_next_68(v501, v502);
         local v505 = v503;
         local v506 = v504;
         if (v503) then
             v502 = v505;
             local v507 = (v506.shottime + v506.lifetime) - tick();
             if (v505.Parent) then
                 if (v507 >= 0) then
                     local v508 = false;
                     local v509 = u163:isplayeralive(v505);
                     local v510 = (tick() - v506.shottime) / v506.lifetime;
                     local v511;
                     if (v510 >= 0.1) then
                         v511 = v510 ^ 0.5;
                         if (not v511) then
                             v508 = true;
                         end
                     else
                         v508 = true;
                     end
                     if (v508) then
                         v511 = 0;
                     end
                     local v512 = math.min(v511, 1);
                     if (v509 and (not (v512 == 1))) then
                         v478 = v478 + 1;
                         f_update_minimap_object(v509, false, v505.TeamColor, v506.refcf, v512, v478, "players");
                     end
                 end
             else
                 u164[v505] = nil;
             end
         else
             break;
         end
     end
     local v513 = 0;
     local g_next_69 = next;
     local v514 = u165;
     local v515 = nil;
     while true do
         local v516, v517 = g_next_69(v514, v515);
         local v518 = v516;
         local v519 = v517;
         if (v516) then
             v515 = v518;
             local v520 = (v519.shottime + v519.lifetime) - tick();
             if (v518.Parent) then
                 if (v520 >= 0) then
                     v513 = v513 + 1;
                     f_update_minimap_ring(v513, v519);
                 end
             else
                 u165[v518] = nil;
             end
         else
             break;
         end
     end
     local v521 = 0;
     if (u138) then
         local v522 = u138:GetChildren();
         local v523 = v522;
         local v524 = 1;
         local v525 = #v522;
         local v526 = v525;
         local v527 = v524;
         if (not (v525 <= v527)) then
             while true do
                 local v528 = v523[v524];
                 local v529 = v528;
                 local v530 = v528:FindFirstChild("Base");
                 local v531 = v528:FindFirstChild("TeamColor");
                 local v532 = v528:FindFirstChild("Letter");
                 local v533 = nil;
                 local t_Name_70 = v528.Name;
                 if (t_Name_70 == "Flag") then
                     local v534 = false;
                     local v535;
                     if (v532) then
                         v535 = v532.Value;
                         if (not v535) then
                             v534 = true;
                         end
                     else
                         v534 = true;
                     end
                     if (v534) then
                         v535 = "";
                     end
                     v533 = v535;
                 else
                     local t_Name_71 = v529.Name;
                     if (t_Name_71 == "FlagBase") then
                         v533 = "F";
                     else
                         local t_Name_72 = v529.Name;
                         if (t_Name_72 == "HPFlag") then
                             v533 = "P";
                         end
                     end
                 end
                 if (v530) then
                     v521 = v521 + 1;
                     f_update_minimap_object(nil, nil, v531.Value, v530.CFrame, nil, v521, "objectives", v533);
                 end
                 local v536 = v524 + 1;
                 v524 = v536;
                 local v537 = v526;
                 if (v537 < v536) then
                     break;
                 end
             end
         end
     end
 end;
 local f_reset_radar_pool;
 f_reset_radar_pool = function()
     --[[
         Name: reset_radar_pool
         Line: 2216
         Upvalues: 
             [1] = u141
             [2] = u144
 
     --]]
     local v538 = u141:GetChildren();
     local v539 = v538;
     local v540 = 1;
     local v541 = #v538;
     local v542 = v541;
     local v543 = v540;
     if (not (v541 <= v543)) then
         while true do
             v539[v540].Visible = false;
             local v544 = v540 + 1;
             v540 = v544;
             local v545 = v542;
             if (v545 < v544) then
                 break;
             end
         end
     end
     local g_next_73 = next;
     local v546 = u144;
     local v547 = nil;
     while true do
         local v548, v549 = g_next_73(v546, v547);
         local v550 = v548;
         if (v548) then
             v547 = v550;
             if (not v550.Parent) then
                 u144[v550] = nil;
             end
         else
             break;
         end
     end
 end;
 local f_radarstep;
 f_radarstep = function()
     --[[
         Name: radarstep
         Line: 2230
         Upvalues: 
             [1] = u8
             [2] = u130
             [3] = f_reset_radar_pool
             [4] = f_updateminimap
 
     --]]
     if (not u8:isdeployed()) then
         return;
     end
     if (u130.enabled) then
         f_reset_radar_pool();
         f_updateminimap();
     end
 end;
 u4.radarstep = f_radarstep;
 local u166 = u2;
 local u167 = v120;
 local u168 = v110;
 local u169 = v122;
 local u170 = v124;
 local u171 = v123;
 local f_updatehealth;
 f_updatehealth = function()
     --[[
         Name: updatehealth
         Line: 2239
         Upvalues: 
             [1] = u166
             [2] = u167
             [3] = u56
             [4] = u168
             [5] = u169
             [6] = u170
             [7] = u171
 
     --]]
     local v551 = u166.gethealth();
     local v552 = v551;
     local t_maxhealth_74 = u166.maxhealth;
     u167.Text = v551 + ((-v551) % 1);
     local v553 = u56;
     if (v551 <= v553) then
         local v554 = u56 - v552;
         u168.ImageTransparency = u168.ImageTransparency - ((v554 / u56) * 0.7);
         u168.BackgroundTransparency = (u168.BackgroundTransparency - ((v554 / u56) * 0.5)) + 0.3;
     else
         if ((u56 < v552) or (v552 == t_maxhealth_74)) then
             u168.ImageTransparency = u168.ImageTransparency + 0.001;
             u168.BackgroundTransparency = u168.BackgroundTransparency + 0.001;
         else
             if (v552 < 0) then
                 u168.ImageTransparency = 1;
                 u168.BackgroundTransparency = 1;
             end
         end
     end
     u56 = v552;
     local v555 = t_maxhealth_74 / 4;
     if (v552 < v555) then
         u169.BackgroundColor3 = u170[4];
         u171.BackgroundColor3 = u170[3];
     else
         u169.BackgroundColor3 = u170[1];
         u171.BackgroundColor3 = u170[2];
     end
     u171.Size = UDim2.new(math.floor(v552) / t_maxhealth_74, 0, 1, 0);
 end;
 u130 = {};
 local u172 = {};
 local u173 = {};
 local f_spot;
 f_spot = function(p141)
     --[[
         Name: spot
         Line: 2276
         Upvalues: 
             [1] = u2
             [2] = u16
             [3] = t_LocalPlayer_11
             [4] = u4
             [5] = u7
             [6] = u9
             [7] = u172
             [8] = u12
 
     --]]
     local v556 = {};
     if (u2.alive) then
         local v557 = u16.cframe;
         local t_cframe_75 = v557;
         local t_unit_76 = v557.lookVector.unit;
         local v558 = game:GetService("Players"):GetPlayers();
         local v559 = v558;
         local t_TeamColor_77 = t_LocalPlayer_11.TeamColor;
         local v560 = 1;
         local v561 = #v558;
         local v562 = v561;
         local v563 = v560;
         if (not (v561 <= v563)) then
             while true do
                 local v564 = v559[v560];
                 local v565 = v564;
                 if (u4:isplayeralive(v564) and (not (v565.TeamColor == t_TeamColor_77))) then
                     local v566 = u7.getbodyparts(v565);
                     local v567 = v566;
                     if (v566 and v566.head) then
                         local v568 = v567.head.Position - u16.cframe.p;
                         local v569 = t_unit_76:Dot(v568.unit);
                         if ((v569 >= 0.96592582628) and (not workspace:FindPartOnRayWithWhitelist(Ray.new(t_cframe_75.p, v568), u9.raycastwhitelist))) then
                             u172[v565] = tick();
                             v556[(#v556) + 1] = v565;
                         end
                     end
                 end
                 local v570 = v560 + 1;
                 v560 = v570;
                 local v571 = v562;
                 if (v571 < v570) then
                     break;
                 end
             end
         end
         local v572 = #v556;
         if (v572 >= 0) then
             u12:send("spotp\226\128\139layers", v556, tick());
             return true;
         end
     end
 end;
 u4.spot = f_spot;
 u12:add("brokensight", function(p142, p143)
     --[[
         Name: (empty)
         Line: 2311
         Upvalues: 
             [1] = u173
 
     --]]
     if (p142) then
         u173[p142] = p143;
     end
 end);
 u12:add("spotplayer", function(p144)
     --[[
         Name: (empty)
         Line: 2317
         Upvalues: 
             [1] = u130
 
     --]]
     if (p144) then
         u130[p144] = true;
     end
 end);
 u12:add("unspotplayer", function(p145)
     --[[
         Name: (empty)
         Line: 2323
         Upvalues: 
             [1] = u130
 
     --]]
     if (p145) then
         u130[p145] = nil;
     end
 end);
 local f_isspotted;
 f_isspotted = function(p146, p147)
     --[[
         Name: isspotted
         Line: 2329
         Upvalues: 
             [1] = u130
 
     --]]
     return u130[p147];
 end;
 u4.isspotted = f_isspotted;
 local f_isinsight;
 f_isinsight = function(p148, p149)
     --[[
         Name: isinsight
         Line: 2333
         Upvalues: 
             [1] = u173
             [2] = u172
             [3] = t_LocalPlayer_11
 
     --]]
     local v573 = not u173[p149];
     if (not v573) then
         v573 = u172[t_LocalPlayer_11];
     end
     return v573;
 end;
 u4.isinsight = f_isinsight;
 local f_spotstep;
 f_spotstep = function()
     --[[
         Name: spotstep
         Line: 2337
         Upvalues: 
             [1] = u130
             [2] = u4
             [3] = u2
             [4] = t_LocalPlayer_11
             [5] = u7
             [6] = u15
             [7] = u16
             [8] = u9
             [9] = u172
             [10] = u12
             [11] = u42
 
     --]]
     local g_next_78 = next;
     local v574 = u130;
     local v575 = nil;
     while true do
         local v576, v577 = g_next_78(v574, v575);
         local v578 = v576;
         if (v576) then
             local v579 = false;
             v575 = v578;
             local v580 = false;
             if (u4.spectating) then
                 v579 = true;
             else
                 if (u2.alive) then
                     local v581 = v578.TeamColor;
                     local t_TeamColor_79 = t_LocalPlayer_11.TeamColor;
                     if (v581 ~= t_TeamColor_79) then
                         v579 = true;
                     end
                 end
             end
             if (v579) then
                 local v582 = u7.getbodyparts(v578);
                 if (((v582 and v582.torso) and u15.sphere(v582.torso.Position, 4)) and (not workspace:FindPartOnRayWithWhitelist(Ray.new(u16.cframe.p, v582.head.Position - u16.cframe.p), u9.raycastwhitelist))) then
                     local v583 = false;
                     v580 = true;
                     if (u172[v578]) then
                         local v584 = u172[v578];
                         local v585 = tick();
                         if (v584 <= v585) then
                             v583 = true;
                         end
                     else
                         v583 = true;
                     end
                     if (v583) then
                         u172[v578] = tick() + 1;
                         u12:send("updates\226\128\139ight", v578, true);
                     end
                 end
             end
             if ((not v580) and u172[v578]) then
                 u172[v578] = nil;
                 u12:send("updates\226\128\139ight", v578, false, tick());
             end
         else
             break;
         end
     end
     if (u4:isspotted(t_LocalPlayer_11)) then
         u42.Visible = true;
         if (u4:isinsight(t_LocalPlayer_11)) then
             u42.Text = "Spotted by enemy!";
             u42.TextColor3 = Color3.new(1, 0.125, 0.125);
             return;
         end
         u42.Text = "Hiding from enemy...";
         u42.TextColor3 = Color3.new(0.125, 1, 0.125);
         return;
     end
     local v586 = u42:FindFirstChild("Spottimer");
     local v587 = v586;
     if (v586) then
         local t_Value_80 = v587.Timer.Value;
         if (t_Value_80 >= 0) then
             u42.Visible = true;
             u42.Text = "On Radar!";
             u42.TextColor3 = Color3.new(1, 0.8, 0);
             return;
         end
     end
     u42.Visible = false;
 end;
 u4.spotstep = f_spotstep;
 local f_goingloud;
 f_goingloud = function(p150)
     --[[
         Name: goingloud
         Line: 2388
         Upvalues: 
             [1] = u42
 
     --]]
     local v588 = u42:FindFirstChild("Spottimer");
     local v589 = v588;
     local v590;
     if (v588) then
         v590 = v589.Timer;
     else
         local v591 = Instance.new("Model");
         v591.Name = "Spottimer";
         v590 = Instance.new("IntValue");
         v590.Name = "Timer";
         v590.Parent = v591;
         v591.Parent = u42;
     end
     local v592;
     if (v590.Value < 30) then
         v592 = 30;
     else
         local v593 = v590.Value + 30;
         if (v593 >= 200) then
             v592 = 200;
         else
             v592 = v590.Value + 30;
         end
     end
     v590.Value = v592;
 end;
 u4.goingloud = f_goingloud;
 u12:add("shot", function(p151, p152, p153)
     --[[
         Name: (empty)
         Line: 2406
         Upvalues: 
             [1] = u36
             [2] = t_BloodArc_14
             [3] = u16
 
     --]]
     local v594 = u36:GetChildren();
     local v595 = v594;
     local v596 = 1;
     local v597 = #v594;
     local v598 = v597;
     local v599 = v596;
     if (not (v597 <= v599)) then
         while true do
             local t_Name_81 = v595[v596].Name;
             if (t_Name_81 == "BloodArc") then
                 local v600 = v595[v596].Player.Value;
                 local t_Name_82 = p151.Name;
                 if (v600 == t_Name_82) then
                     v595[v596]:Destroy();
                 end
             end
             local v601 = v596 + 1;
             v596 = v601;
             local v602 = v598;
             if (v602 < v601) then
                 break;
             end
         end
     end
     local v603 = t_BloodArc_14:Clone();
     v603.Pos.Value = p152;
     v603.Player.Value = p151.Name;
     v603.Parent = u36;
     u16:hit((((-p153) / 12) + 4.166666666666667) * (u16.cframe.p - p152).unit);
 end);
 u12:add("updatecombat", function(p154)
     --[[
         Name: (empty)
         Line: 2422
         Upvalues: 
             [1] = u54
 
     --]]
     if (p154) then
         u54[p154] = tick();
     end
 end);
 local f_reloadhud;
 f_reloadhud = function(p155)
     --[[
         Name: reloadhud
         Line: 2429
         Upvalues: 
             [1] = u4
             [2] = u19
             [3] = u5
             [4] = u18
             [5] = u36
             [6] = u35
 
     --]]
     u4:reset_minimap();
     u4:set_minimap();
     u4:setscope(false);
     u19:reload();
     u5:reset();
     u18:reset();
     local v604 = u36:GetChildren();
     local v605 = v604;
     local v606 = 1;
     local v607 = #v604;
     local v608 = v607;
     local v609 = v606;
     if (not (v607 <= v609)) then
         while true do
             local t_Name_83 = v605[v606].Name;
             if (t_Name_83 == "BloodArc") then
                 v605[v606]:Destroy();
             end
             local v610 = v606 + 1;
             v606 = v610;
             local v611 = v608;
             if (v611 < v610) then
                 break;
             end
         end
     end
     local v612 = u35:FindFirstChild("KillBar");
     local v613 = v612;
     if (v612) then
         v613:Destroy();
     end
 end;
 u4.reloadhud = f_reloadhud;
 local f_beat;
 f_beat = function()
     --[[
         Name: beat
         Line: 2451
         Upvalues: 
             [1] = f_updateplayernames
             [2] = f_updatehealth
 
     --]]
     f_updateplayernames();
     f_updatehealth();
 end;
 u4.beat = f_beat;
 local u174 = u37;
 local u175 = u4;
 local u176 = u36;
 local f_updatecross = f_updatecross;
 local u177 = u42;
 local f_step;
 f_step = function()
     --[[
         Name: step
         Line: 2456
         Upvalues: 
             [1] = u174
             [2] = u175
             [3] = u176
             [4] = f_updatecross
             [5] = u57
             [6] = u58
             [7] = u177
 
     --]]
     u174.ImageTransparency = u175.hitspring.p;
     if (u176.Visible) then
         local v614 = tick();
         f_updatecross();
         if ((u57 + 0.016666666666666666) <= v614) then
             u175.gamemoderenderstep();
             u57 = v614 + 0.016666666666666666;
         end
         if ((u58 + 0.1) <= v614) then
             u175.spotstep();
             u175.gamemodestep();
             local v615 = u177:FindFirstChild("Spottimer");
             local v616 = v615;
             if (v615) then
                 local t_Value_84 = v616.Timer.Value;
                 if (t_Value_84 >= 0) then
                     v616.Timer.Value = v616.Timer.Value - 1;
                 end
             end
             u58 = v614 + 0.1;
         end
     end
     u175.votestep();
 end;
 u4.step = f_step;
 print("Loading notify module");
 local v617 = u20.getscale;
 local v618 = Vector3.new().Dot;
 local v619 = workspace.FindPartOnRayWithIgnoreList;
 local v620 = game:GetService("Players").LocalPlayer;
 local v621 = game.ReplicatedStorage.Misc;
 local v622 = v620.PlayerGui;
 local u178 = v622:WaitForChild("MainGui");
 local u179 = u178:WaitForChild("GameGui");
 local u180 = u179:WaitForChild("NotifyList");
 local v623 = v621.Main;
 local v624 = v621.Side;
 local v625 = v621.KillBar;
 local v626 = v621.RankBar;
 local v627 = v621.AttachBar;
 local v628 = {};
 v628.kill = {
     "Enemy Killed!"
 };
 v628.collx2 = {
     "Double Collateral!"
 };
 v628.collx3 = {
     "Triple Collateral!"
 };
 v628.collxn = {
     "Multi Collateral!"
 };
 v628.killx2 = {
     "Double Kill!"
 };
 v628.killx3 = {
     "Triple Kill!"
 };
 v628.killx4 = {
     "Quad Kill!"
 };
 v628.killxn = {
     "Multi Kill!"
 };
 v628.backstab = {
     "Backstab!"
 };
 v628.assist = {
     "Assist!"
 };
 v628.suppression = {
     "Suppressed Enemy!"
 };
 v628.assistkill = {
     "Assist Count As Kill!"
 };
 v628.head = {
     "Headshot Bonus!"
 };
 v628.wall = {
     "Wallbang Bonus!"
 };
 v628.spot = {
     "Spot Bonus!"
 };
 v628.long = {
     "Killed from a distance!",
     "Long Shot!"
 };
 v628.squad = {
     "Teammate spawned on you",
     "Squadmate spawned on you"
 };
 v628.flagsteal = {
     "Acquired Enemy Flag!",
     "Stolen Enemy Flag!"
 };
 v628.flagcapture = {
     "Captured Enemy Flag!"
 };
 v628.flagteamcap = {
     "Team Captured Enemy Flag!"
 };
 v628.flagrecover = {
     "Recovered Team Flag!"
 };
 v628.flagdef1 = {
     "Killed Enemy Flag Carrier!"
 };
 v628.flagdef2 = {
     "Protected Flag Carrier!"
 };
 v628.flagdef3 = {
     "Denied Enemy Capture!"
 };
 v628.flagdef4 = {
     "Denied Enemy Pick Up!"
 };
 v628.flagdef5 = {
     "Flag Guard Kill!"
 };
 v628.flagdef6 = {
     "Flag Recover Kill!"
 };
 v628.flagsup1 = {
     "Flag Escort Kill!"
 };
 v628.flagsup2 = {
     "Killed Enemy Flag Escort!"
 };
 v628.flagsup3 = {
     "Assisted by Teammate!"
 };
 v628.flagsup4 = {
     "Protected Flag Carrier Under Fire!",
     "Protected Flag Carrier!"
 };
 v628.flagsup5 = {
     "Saved by Teammate!"
 };
 v628.flagsup6 = {
     "Protected by Teammate!"
 };
 v628.flagoff1 = {
     "Offensive Flag Kill!"
 };
 v628.flagoff2 = {
     "Denied Enemy Flag Recovery!"
 };
 v628.flagoff3 = {
     "Killed Enemy Flag Guard!"
 };
 v628.dogtagself = {
     "Secured Personal Tag!"
 };
 v628.dogtagconfirm = {
     "Kill Confirmed!"
 };
 v628.dogtagteam = {
     "Teammate Confirmed Kill!"
 };
 v628.dogtagdeny = {
     "Denied Enemy Kill!"
 };
 v628.domcap = {
     "Captured a position!"
 };
 v628.domcapping = {
     "Capturing position"
 };
 v628.domdefend = {
     "Defended a position!"
 };
 v628.domassault = {
     "Assaulted a position!"
 };
 v628.domattack = {
     "Attacked a position!"
 };
 v628.dombuzz = {
     "Stopped an enemy capture!"
 };
 v628.kingcap = {
     "Captured the hill!"
 };
 v628.kingholding = {
     "Holding hill"
 };
 v628.kingcapping = {
     "Capturing hill"
 };
 v628.hphold = {
     "Holding point!",
     "Holding position!"
 };
 v628.hpdefend = {
     "Defended position!",
     "Defended point!"
 };
 v628.hpassault = {
     "Assaulted point!",
     "Assaulted position!"
 };
 v628.hpattack = {
     "Attacked position!",
     "Attacked point!"
 };
 v628[" "] = {};
 local f_typeout;
 f_typeout = function(p156, p157)
     --[[
         Name: typeout
         Line: 2595
         Upvalues: 
             [1] = u21
 
     --]]
     p156.AutoLocalize = false;
     local v629 = p157 or 2;
     local v630 = p156.Text;
     p156.Text = "";
     local v631 = task.spawn;
     local t_Text_85 = v630;
     local u181 = p156;
     local u182 = v629;
     v631(function()
         --[[
             Name: (empty)
             Line: 2600
             Upvalues: 
                 [1] = t_Text_85
                 [2] = u181
                 [3] = u182
                 [4] = u21
 
         --]]
         local v632 = 1;
         local v633, v634, v635 = utf8.graphemes(t_Text_85);
         local v636 = v633;
         local v637 = v634;
         local v638 = v635;
         while true do
             local v639, v640 = v636(v637, v638);
             local v641 = v639;
             local v642 = v640;
             if (v639) then
                 break;
             end
             v638 = v641;
             u181.Text = u181.Text .. t_Text_85:sub(v641, v642);
             if ((v632 * u182) <= v641) then
                 u21.play("ui_typeout", 0.2);
                 v632 = v632 + 1;
                 task.wait(0.016666666666666666);
             end
         end
     end);
 end;
 local f_queuetypeout;
 f_queuetypeout = function(p158, p159)
     --[[
         Name: queuetypeout
         Line: 2616
         Upvalues: 
             [1] = u21
 
     --]]
     p158.AutoLocalize = false;
     local v643 = p159 or 3;
     local v644 = p158.Text;
     local t_Text_86 = v644;
     p158.Text = "";
     local v645 = 1;
     local v646, v647, v648 = utf8.graphemes(v644);
     local v649 = v646;
     local v650 = v647;
     local v651 = v648;
     while true do
         local v652, v653 = v649(v650, v651);
         local v654 = v652;
         local v655 = v653;
         if (v652) then
             break;
         end
         v651 = v654;
         p158.Text = p158.Text .. t_Text_86:sub(v654, v655);
         if ((v645 * v643) <= v654) then
             u21.play("ui_typeout", 0.2);
             v645 = v645 + 1;
             task.wait(0.016666666666666666);
         end
     end
 end;
 local t_Side_87 = v624;
 local u183 = u21;
 local f_typeout = f_typeout;
 local f_customaward;
 f_customaward = function(p160, p161)
     --[[
         Name: customaward
         Line: 2635
         Upvalues: 
             [1] = t_Side_87
             [2] = u180
             [3] = u183
             [4] = f_typeout
 
     --]]
     local v656 = t_Side_87:Clone();
     local v657 = v656;
     local v658 = v656:FindFirstChild("Primary");
     v656.Parent = u180;
     u183.play("ui_smallaward", 0.2);
     local v659 = u180:GetChildren();
     local v660 = v659;
     local v661 = 1;
     local v662 = #v659;
     local v663 = v662;
     local v664 = v661;
     if (not (v662 <= v664)) then
         while true do
             local v665 = v660[v661];
             local v666 = v665;
             if (v665:IsA("Frame") and v665.Parent) then
                 v666:TweenPosition(UDim2.new(0, 0, 0, ((#v660) - v661) * 20), "Out", "Sine", 0.05, true);
             end
             local v667 = v661 + 1;
             v661 = v667;
             local v668 = v663;
             if (v668 < v667) then
                 break;
             end
         end
     end
     local v669 = task.spawn;
     local u184 = v658;
     local u185 = p161;
     local u186 = v657;
     v669(function()
         --[[
             Name: (empty)
             Line: 2648
             Upvalues: 
                 [1] = u184
                 [2] = u185
                 [3] = f_typeout
                 [4] = u186
 
         --]]
         u184.Text = u185;
         u184.TextTransparency = 0;
         f_typeout(u184, 3);
         task.wait(5.5);
         local v670 = 1;
         local v671 = v670;
         if (not (v671 >= 10)) then
             while true do
                 u184.TextTransparency = v670 / 10;
                 u184.TextStrokeTransparency = (v670 / 10) + 0.4;
                 task.wait(0.016666666666666666);
                 local v672 = v670 + 1;
                 v670 = v672;
                 if (v672 > 10) then
                     break;
                 end
             end
         end
         task.wait(0.1);
         u186:Destroy();
     end);
 end;
 u5.customaward = f_customaward;
 local t_AttachBar_88 = v627;
 local f_customevent;
 f_customevent = function(p162, p163)
     --[[
         Name: customevent
         Line: 2666
         Upvalues: 
             [1] = t_AttachBar_88
             [2] = u178
 
     --]]
     local v673 = t_AttachBar_88:Clone();
     local v674 = v673.Title;
     local v675 = v673.Attach;
     v673.Position = UDim2.new(0.5, 0, 0.15, 0);
     v674.Text = p162;
     v675.Text = p163;
     v673.Parent = u178;
     local v676 = tick() + 6;
     local u187 = nil;
     local v677 = game:GetService("RunService").RenderStepped;
     local u188 = v676;
     local t_Attach_89 = v675;
     local t_Title_90 = v674;
     local u189 = v673;
     u187 = v677:connect(function()
         --[[
             Name: (empty)
             Line: 2675
             Upvalues: 
                 [1] = u188
                 [2] = t_Attach_89
                 [3] = t_Title_90
                 [4] = u187
                 [5] = u189
 
         --]]
         local v678 = u188 - tick();
         local v679 = v678;
         local v680 = t_Attach_89;
         local v681;
         if (v678 <= 5) then
             v681 = 0;
         else
             local v682 = false;
             if (v679 <= 5.5) then
                 v681 = (v679 - 5) / 0.5;
                 if (not v681) then
                     v682 = true;
                 end
             else
                 v682 = true;
             end
             if (v682) then
                 v681 = 1;
             end
         end
         v680.TextTransparency = v681;
         local v683 = t_Title_90;
         local v684;
         if (v679 <= 5) then
             v684 = 0;
         else
             local v685 = false;
             if (v679 <= 5.5) then
                 v684 = (v679 - 5) / 0.5;
                 if (not v684) then
                     v685 = true;
                 end
             else
                 v685 = true;
             end
             if (v685) then
                 v684 = 1;
             end
         end
         v683.TextTransparency = v684;
         if (v679 < 0) then
             u187:disconnect();
             u189:Destroy();
         end
     end);
 end;
 local t_Side_91 = v624;
 local u190 = u21;
 local u191 = v628;
 local f_typeout = f_typeout;
 local f_smallaward;
 f_smallaward = function(p164, p165)
     --[[
         Name: smallaward
         Line: 2687
         Upvalues: 
             [1] = t_Side_91
             [2] = u190
             [3] = u180
             [4] = u191
             [5] = f_typeout
 
     --]]
     local v686 = p165 or 25;
     local v687 = t_Side_91:Clone();
     local v688 = v687;
     local v689 = v687:FindFirstChild("Primary");
     local v690 = v687:FindFirstChild("Point");
     u190.play("ui_smallaward", 0.2);
     v687.Parent = u180;
     local v691 = u180:GetChildren();
     local v692 = v691;
     local v693 = 1;
     local v694 = #v691;
     local v695 = v694;
     local v696 = v693;
     if (not (v694 <= v696)) then
         while true do
             local v697 = v692[v693];
             local v698 = v697;
             if (v697:IsA("Frame") and v697.Parent) then
                 v698:TweenPosition(UDim2.new(0, 0, 0, ((#v692) - v693) * 20), "Out", "Sine", 0.05, true);
             end
             local v699 = v693 + 1;
             v693 = v699;
             local v700 = v695;
             if (v700 < v699) then
                 break;
             end
         end
     end
     v690.Text = "[+" .. (v686 .. "]");
     local v701 = u191[p164];
     local v702 = v701;
     local v703 = #v701;
     if (v703 >= 1) then
         v689.Text = v702[math.random(1, #v702)];
     else
         v689.Text = v702[1];
     end
     if (p164 == "head") then
         u190.play("headshotkill", 0.45);
     end
     v690.TextTransparency = 0;
     v689.TextTransparency = 0;
     f_typeout(v690, 3);
     f_typeout(v689, 3);
     task.wait(5.5);
     local v704 = 1;
     local v705 = v704;
     if (not (v705 >= 10)) then
         while true do
             v690.TextTransparency = v704 / 10;
             v689.TextTransparency = v704 / 10;
             v690.TextStrokeTransparency = (v704 / 10) + 0.4;
             v689.TextStrokeTransparency = (v704 / 10) + 0.4;
             task.wait(0.016666666666666666);
             local v706 = v704 + 1;
             v704 = v706;
             if (v706 > 10) then
                 break;
             end
         end
     end
     task.wait(0.1);
     v688:Destroy();
 end;
 local t_Main_92 = v623;
 local t_getscale_93 = v617;
 local u192 = v628;
 local u193 = u4;
 local u194 = u21;
 local f_typeout = f_typeout;
 local f_queuetypeout = f_queuetypeout;
 local f_bigaward;
 f_bigaward = function(p166, p167, p168, p169)
     --[[
         Name: bigaward
         Line: 2735
         Upvalues: 
             [1] = t_Main_92
             [2] = t_getscale_93
             [3] = u180
             [4] = u192
             [5] = u193
             [6] = u194
             [7] = f_typeout
             [8] = f_queuetypeout
 
     --]]
     local v707 = t_Main_92:Clone();
     local v708 = v707;
     local v709 = v707:FindFirstChild("Overlay");
     local v710 = v707:FindFirstChild("Primary");
     local v711 = v707:FindFirstChild("Point");
     local v712 = v707:FindFirstChild("Enemy");
     local v713 = t_getscale_93();
     v707.Parent = u180;
     local v714 = u180:GetChildren();
     local v715 = v714;
     local v716 = 1;
     local v717 = #v714;
     local v718 = v717;
     local v719 = v716;
     if (not (v717 <= v719)) then
         while true do
             local v720 = v715[v716];
             local v721 = v720;
             if (v720:IsA("Frame") and v720.Parent) then
                 v721:TweenPosition(UDim2.new(0, 0, 0, ((#v715) - v716) * 20), "Out", "Sine", 0.05, true);
             end
             local v722 = v716 + 1;
             v716 = v722;
             local v723 = v718;
             if (v723 < v722) then
                 break;
             end
         end
     end
     v711.Text = "[+" .. (p169 .. "]");
     local v724 = u192[p166];
     local v725 = v724;
     local v726 = #v724;
     if (v726 >= 1) then
         v710.Text = v725[math.random(1, #v725)];
     else
         v710.Text = v725[1];
     end
     if (u193.streamermode()) then
         v712.Text = "Player";
     else
         v712.Text = p167.Name or "";
     end
     v712.TextColor3 = p167.TeamColor.Color;
     u194.play("ui_begin", 0.4);
     if (p166 == "kill") then
         u194.play("killshot", 0.2);
     end
     v711.TextTransparency = 0;
     v711.TextStrokeTransparency = 0;
     v710.TextTransparency = 0;
     v710.TextStrokeTransparency = 0;
     v712.TextTransparency = 1;
     v712.TextStrokeTransparency = 1;
     v709.ImageTransparency = 0.2;
     v709:TweenSizeAndPosition(UDim2.new(0, 200, 0, 80), UDim2.new(0.5, -150, 0.7, -40), "Out", "Linear", 0, true);
     f_typeout(v711);
     f_typeout(v710);
     local v727 = task.delay;
     local u195 = v709;
     v727(0.05, function()
         --[[
             Name: (empty)
             Line: 2792
             Upvalues: 
                 [1] = u195
 
         --]]
         local v728 = 1;
         local v729 = v728;
         if (not (v729 >= 10)) then
             while true do
                 u195.ImageTransparency = v728 / 10;
                 task.wait(0.1);
                 local v730 = v728 + 1;
                 v728 = v730;
                 if (v730 > 10) then
                     break;
                 end
             end
         end
         u195.Size = UDim2.new(0, 200, 0, 80);
         u195.Position = UDim2.new(0.55, -100, 0.3, -40);
     end);
     v709:TweenSizeAndPosition(UDim2.new(0, 300, 0, 30), UDim2.new(0.5, -150, 0.7, -15), "Out", "Linear", 0.05, true);
     task.wait(0.05);
     v709:TweenSizeAndPosition(UDim2.new(0, 500, 0, 8), UDim2.new(0.5, -150, 0.7, -4), "Out", "Linear", 0.05, true);
     task.wait(1.5);
     local v731 = 1;
     local v732 = v731;
     if (not (v732 >= 2)) then
         while true do
             v710.TextTransparency = 1;
             v710.TextStrokeTransparency = 1;
             u194.play("ui_blink", 0.4);
             task.wait(0.1);
             v710.TextTransparency = 0;
             v710.TextStrokeTransparency = 0;
             task.wait(0.1);
             local v733 = v731 + 1;
             v731 = v733;
             if (v733 > 2) then
                 break;
             end
         end
     end
     v710.TextTransparency = 1;
     v710.TextStrokeTransparency = 1;
     task.wait(0.2);
     v712.TextTransparency = 0;
     v712.TextStrokeTransparency = 0;
     f_queuetypeout(v712, 4);
     v710.TextTransparency = 0;
     v710.TextStrokeTransparency = 0;
     v710.Position = UDim2.new(0.5, (v712.TextBounds.x / v713) + 10, 0.7, -10);
     if (p166 == "kill") then
         v710.Text = "[" .. (p168 .. "]");
     else
         v710.Text = p168;
     end
     f_queuetypeout(v710, 4);
     task.wait(3);
     local v734 = 1;
     local v735 = v734;
     if (not (v735 >= 10)) then
         while true do
             v711.TextTransparency = v734 / 10;
             v710.TextTransparency = v734 / 10;
             v712.TextTransparency = v734 / 10;
             v711.TextStrokeTransparency = (v734 / 10) + 0.4;
             v710.TextStrokeTransparency = (v734 / 10) + 0.4;
             v712.TextStrokeTransparency = (v734 / 10) + 0.4;
             task.wait(0.016666666666666666);
             local v736 = v734 + 1;
             v734 = v736;
             if (v736 > 10) then
                 break;
             end
         end
     end
     task.wait(0.1);
     v708:Destroy();
 end;
 local t_AttachBar_94 = v627;
 local f_unlockedgun;
 f_unlockedgun = function(p170)
     --[[
         Name: unlockedgun
         Line: 2843
         Upvalues: 
             [1] = t_AttachBar_94
             [2] = u178
 
     --]]
     local v737 = t_AttachBar_94:Clone();
     local v738 = v737.Title;
     local v739 = v737.Attach;
     v737.Position = UDim2.new(0.5, 0, 0.15, 0);
     v737.Parent = u178;
     v738.Text = "Unlocked New Weapon!";
     v739.Text = p170;
     local v740 = tick();
     local u196 = nil;
     local v741 = game:GetService("RunService").RenderStepped;
     local u197 = v740;
     local t_Attach_95 = v739;
     local t_Title_96 = v738;
     local u198 = v737;
     u196 = v741:connect(function()
         --[[
             Name: (empty)
             Line: 2854
             Upvalues: 
                 [1] = u197
                 [2] = t_Attach_95
                 [3] = t_Title_96
                 [4] = u196
                 [5] = u198
 
         --]]
         local v742 = tick() - u197;
         local v743 = v742;
         local v744 = t_Attach_95;
         local v745;
         if (v742 <= 2) then
             v745 = 0;
         else
             local v746 = false;
             if (v743 <= 2.5) then
                 v745 = (v743 - 2) / 0.5;
                 if (not v745) then
                     v746 = true;
                 end
             else
                 v746 = true;
             end
             if (v746) then
                 v745 = 1;
             end
         end
         v744.TextTransparency = v745;
         local v747 = t_Title_96;
         local v748;
         if (v743 <= 2) then
             v748 = 0;
         else
             local v749 = false;
             if (v743 <= 2.5) then
                 v748 = (v743 - 2) / 0.5;
                 if (not v748) then
                     v749 = true;
                 end
             else
                 v749 = true;
             end
             if (v749) then
                 v748 = 1;
             end
         end
         v747.TextTransparency = v748;
         if (v743 >= 3) then
             u196:disconnect();
             u198:Destroy();
         end
     end);
 end;
 local t_AttachBar_97 = v627;
 local f_unlockedattach;
 f_unlockedattach = function(p171, p172, p173)
     --[[
         Name: unlockedattach
         Line: 2866
         Upvalues: 
             [1] = t_AttachBar_97
             [2] = u178
 
     --]]
     local v750 = 1;
     local v751 = #p172;
     local v752 = v751;
     local v753 = v750;
     if (not (v751 <= v753)) then
         while true do
             local v754 = p172[v750];
             local v755 = p173[v750];
             local v756 = t_AttachBar_97:Clone();
             local v757 = v756.Money;
             local v758 = v756.Title;
             local v759 = v756.Attach;
             v756.Position = UDim2.new(0.5, 0, 0.15, 0);
             v756.Parent = u178;
             v758.Text = "Unlocked " .. (p171 .. " Attachment");
             v759.Text = v754;
             v757.Text = "[+200]";
             local v760 = tick();
             local u199 = nil;
             local v761 = game:GetService("RunService").RenderStepped;
             local u200 = v760;
             local t_Attach_98 = v759;
             local t_Title_99 = v758;
             local t_Money_100 = v757;
             local u201 = v756;
             u199 = v761:connect(function()
                 --[[
                     Name: (empty)
                     Line: 2882
                     Upvalues: 
                         [1] = u200
                         [2] = t_Attach_98
                         [3] = t_Title_99
                         [4] = t_Money_100
                         [5] = u199
                         [6] = u201
 
                 --]]
                 local v762 = tick() - u200;
                 local v763 = v762;
                 local v764 = t_Attach_98;
                 local v765;
                 if (v762 <= 2) then
                     v765 = 0;
                 else
                     local v766 = false;
                     if (v763 <= 2.5) then
                         v765 = (v763 - 2) / 0.5;
                         if (not v765) then
                             v766 = true;
                         end
                     else
                         v766 = true;
                     end
                     if (v766) then
                         v765 = 1;
                     end
                 end
                 v764.TextTransparency = v765;
                 local v767 = t_Title_99;
                 local v768;
                 if (v763 <= 2) then
                     v768 = 0;
                 else
                     local v769 = false;
                     if (v763 <= 2.5) then
                         v768 = (v763 - 2) / 0.5;
                         if (not v768) then
                             v769 = true;
                         end
                     else
                         v769 = true;
                     end
                     if (v769) then
                         v768 = 1;
                     end
                 end
                 v767.TextTransparency = v768;
                 local v770 = t_Money_100;
                 local v771;
                 if (v763 <= 0.5) then
                     v771 = 1;
                 else
                     if (v763 <= 2.5) then
                         v771 = 0;
                     else
                         local v772 = false;
                         if (v763 <= 3) then
                             v771 = (v763 - 2.5) / 0.5;
                             if (not v771) then
                                 v772 = true;
                             end
                         else
                             v772 = true;
                         end
                         if (v772) then
                             v771 = 1;
                         end
                     end
                 end
                 v770.TextTransparency = v771;
                 if (v763 >= 3) then
                     u199:disconnect();
                     u201:Destroy();
                 end
             end);
             task.wait(3);
             local v773 = v750 + 1;
             v750 = v773;
             local v774 = v752;
             if (v774 < v773) then
                 break;
             end
         end
     end
 end;
 local t_RankBar_101 = v626;
 local f_unlockedgun = f_unlockedgun;
 local f_rankup;
 f_rankup = function(p174, p175, p176)
     --[[
         Name: rankup
         Line: 2897
         Upvalues: 
             [1] = t_RankBar_101
             [2] = u178
             [3] = f_unlockedgun
 
     --]]
     local v775 = t_RankBar_101:Clone();
     local v776 = v775;
     local t_Money_102 = v775.Money;
     local t_Title_103 = v775.Title;
     local t_Rank_104 = v775.Rank;
     local v777 = 0;
     local v778 = u178:GetChildren();
     local v779 = v778;
     local v780 = 1;
     local v781 = #v778;
     local v782 = v781;
     local v783 = v780;
     if (not (v781 <= v783)) then
         while true do
             local v784 = false;
             local t_Name_105 = v779[v780].Name;
             if (t_Name_105 == "RankBar") then
                 v784 = true;
             else
                 local t_Name_106 = v779[v780].Name;
                 if (t_Name_106 == "AttachBar") then
                     v784 = true;
                 end
             end
             if (v784) then
                 v777 = v777 + 1;
             end
             local v785 = v780 + 1;
             v780 = v785;
             local v786 = v782;
             if (v786 < v785) then
                 break;
             end
         end
     end
     v776.Parent = u178;
     t_Rank_104.Text = p175;
     t_Money_102.Text = "+" .. ((((5 * (p175 - p174)) * ((81 + p175) + p174)) / 2) .. " CR");
     local v787 = tick();
     local u202 = nil;
     local v788 = game:GetService("RunService").RenderStepped;
     local u203 = v787;
     local u204 = t_Rank_104;
     local u205 = t_Title_103;
     local u206 = t_Money_102;
     local u207 = v776;
     local u208 = p176;
     u202 = v788:connect(function()
         --[[
             Name: (empty)
             Line: 2915
             Upvalues: 
                 [1] = u203
                 [2] = u204
                 [3] = u205
                 [4] = u206
                 [5] = u202
                 [6] = u207
                 [7] = u208
                 [8] = f_unlockedgun
 
         --]]
         local v789 = tick() - u203;
         local v790 = v789;
         local v791 = u204;
         local v792;
         if (v789 <= 3) then
             v792 = 0;
         else
             local v793 = false;
             if (v790 <= 3.5) then
                 v792 = (v790 - 3) / 0.5;
                 if (not v792) then
                     v793 = true;
                 end
             else
                 v793 = true;
             end
             if (v793) then
                 v792 = 1;
             end
         end
         v791.TextTransparency = v792;
         local v794 = u205;
         local v795;
         if (v790 <= 3) then
             v795 = 0;
         else
             local v796 = false;
             if (v790 <= 3.5) then
                 v795 = (v790 - 3) / 0.5;
                 if (not v795) then
                     v796 = true;
                 end
             else
                 v796 = true;
             end
             if (v796) then
                 v795 = 1;
             end
         end
         v794.TextTransparency = v795;
         local v797 = u206;
         local v798;
         if (v790 <= 0.5) then
             v798 = 1;
         else
             if (v790 <= 3.5) then
                 v798 = 0;
             else
                 local v799 = false;
                 if (v790 <= 4) then
                     v798 = (v790 - 3.5) / 0.5;
                     if (not v798) then
                         v799 = true;
                     end
                 else
                     v799 = true;
                 end
                 if (v799) then
                     v798 = 1;
                 end
             end
         end
         v797.TextTransparency = v798;
         if (v790 >= 4) then
             u202:disconnect();
             u207:Destroy();
             task.spawn(function()
                 --[[
                     Name: (empty)
                     Line: 2924
                     Upvalues: 
                         [1] = u208
                         [2] = f_unlockedgun
 
                 --]]
                 if (u208) then
                     local v800 = 1;
                     local v801 = #u208;
                     local v802 = v801;
                     local v803 = v800;
                     if (not (v801 <= v803)) then
                         while true do
                             f_unlockedgun(u208[v800]);
                             task.wait(3);
                             local v804 = v800 + 1;
                             v800 = v804;
                             local v805 = v802;
                             if (v805 < v804) then
                                 break;
                             end
                         end
                     end
                 end
             end);
         end
     end);
 end;
 local t_PlayerGui_107 = v622;
 local f_reset;
 f_reset = function(p177)
     --[[
         Name: reset
         Line: 2940
         Upvalues: 
             [1] = u178
             [2] = t_PlayerGui_107
             [3] = u179
             [4] = u180
 
     --]]
     u178 = t_PlayerGui_107:WaitForChild("MainGui");
     u179 = u178:WaitForChild("GameGui");
     u180 = u179:WaitForChild("NotifyList");
     if (u178:FindFirstChild("KillBar")) then
         u178.KillBar:Destroy();
     end
 end;
 u5.reset = f_reset;
 u12:add("unlockweapon", f_unlockedgun);
 local v806 = game.ReplicatedStorage.AttachmentModels;
 local f_hideparts;
 f_hideparts = function(p178, p179, p180)
     --[[
         Name: hideparts
         Line: 2956
     --]]
     local v807 = p178:GetChildren();
     local v808 = v807;
     local v809 = nil;
     local v810 = 1;
     local v811 = #v807;
     local v812 = v811;
     local v813 = v810;
     if (not (v811 <= v813)) then
         while true do
             local v814 = false;
             if (p179 == "Optics") then
                 local v815 = false;
                 local t_Name_108 = v808[v810].Name;
                 if (t_Name_108 == "Iron") then
                     v815 = true;
                 else
                     local t_Name_109 = v808[v810].Name;
                     if (t_Name_109 == "IronGlow") then
                         v815 = true;
                     else
                         local t_Name_110 = v808[v810].Name;
                         if ((t_Name_110 == "SightMark") and v808[v810]:FindFirstChild("Decal")) then
                             local t_Decal_111 = v808[v810].Decal;
                             local v816;
                             if (p180) then
                                 v816 = 1;
                             else
                                 v816 = 0;
                             end
                             t_Decal_111.Transparency = v816;
                             v814 = true;
                         else
                             v814 = true;
                         end
                     end
                 end
                 if (v815) then
                     if (p180 and (not v808[v810]:FindFirstChild("Hide"))) then
                         local v817 = Instance.new("IntValue");
                         v817.Name = "Hide";
                         v817.Parent = v808[v810];
                     else
                         local v818 = v808[v810]:FindFirstChild("Hide");
                         local v819 = v818;
                         if (v818) then
                             v819:Destroy();
                         end
                     end
                     local v820 = v808[v810];
                     local v821;
                     if (p180) then
                         v821 = 1;
                     else
                         v821 = 0;
                     end
                     v820.Transparency = v821;
                     v814 = true;
                 end
             else
                 if (p179 == "Underbarrel") then
                     local t_Name_112 = v808[v810].Name;
                     if (t_Name_112 == "Grip") then
                         if (p180 and (not v808[v810]:FindFirstChild("Hide"))) then
                             local v822 = Instance.new("IntValue");
                             v822.Name = "Hide";
                             v822.Parent = v808[v810];
                         else
                             local v823 = v808[v810]:FindFirstChild("Hide");
                             local v824 = v823;
                             if (v823) then
                                 v824:Destroy();
                             end
                         end
                         local v825 = v808[v810];
                         local v826;
                         if (p180) then
                             v826 = 1;
                         else
                             v826 = 0;
                         end
                         v825.Transparency = v826;
                         local v827 = v808[v810]:FindFirstChild("Slot1");
                         if (not v827) then
                             v827 = v808[v810]:FindFirstChild("Slot2");
                         end
                         v809 = v827;
                         v814 = true;
                     else
                         v814 = true;
                     end
                 else
                     if (p179 == "Barrel") then
                         local t_Name_113 = v808[v810].Name;
                         if (t_Name_113 == "Barrel") then
                             if (p180 and (not v808[v810]:FindFirstChild("Hide"))) then
                                 local v828 = Instance.new("IntValue");
                                 v828.Name = "Hide";
                                 v828.Parent = v808[v810];
                             else
                                 local v829 = v808[v810]:FindFirstChild("Hide");
                                 local v830 = v829;
                                 if (v829) then
                                     v830:Destroy();
                                 end
                             end
                             local v831 = v808[v810];
                             local v832;
                             if (p180) then
                                 v832 = 1;
                             else
                                 v832 = 0;
                             end
                             v831.Transparency = v832;
                             local v833 = v808[v810]:FindFirstChild("Slot1");
                             if (not v833) then
                                 v833 = v808[v810]:FindFirstChild("Slot2");
                             end
                             v809 = v833;
                             v814 = true;
                         else
                             v814 = true;
                         end
                     else
                         v814 = true;
                     end
                 end
             end
             if (v814) then
                 local v834 = v810 + 1;
                 v810 = v834;
                 local v835 = v812;
                 if (v835 < v834) then
                     break;
                 end
             end
         end
     end
     return v809;
 end;
 local u209;
 u209 = function(p181, p182, p183, p184)
     --[[
         Name: texturekcmodel
         Line: 3012
         Upvalues: 
             [1] = u209
 
     --]]
     local v836 = p183;
     local g_next_114 = next;
     local v837, v838 = p181:GetChildren();
     local v839 = v837;
     local v840 = v838;
     while true do
         local v841, v842 = g_next_114(v839, v840);
         local v843 = v841;
         local v844 = v842;
         if (v841) then
             v840 = v843;
             if (p184 and v844:IsA("BasePart")) then
                 local t_Name_115 = v844.Name;
                 if (t_Name_115 == "LaserLight") then
                     v844.Material = "SmoothPlastic";
                     if (v844:FindFirstChild("Bar")) then
                         v844.Bar.Scale = Vector3.new(0.1, 1000, 0.1);
                     end
                 end
             end
             if ((v844:FindFirstChild("Mesh") or v844:IsA("UnionOperation")) or v844:IsA("MeshPart")) then
                 v844.Anchored = true;
                 local v845 = v844:FindFirstChild("Slot1");
                 if (not v845) then
                     v845 = v844:FindFirstChild("Slot2");
                 end
                 if (v845) then
                     local g_next_116 = next;
                     local v846, v847 = v844:GetChildren();
                     local v848 = v846;
                     local v849 = v847;
                     while true do
                         local v850, v851 = g_next_116(v848, v849);
                         local v852 = v850;
                         local v853 = v851;
                         if (v850) then
                             v849 = v852;
                             if (v853:IsA("Texture")) then
                                 v853:Destroy();
                             end
                         else
                             break;
                         end
                     end
                     if (v836 and v836[v845.Name]) then
                         local t_Name_117 = v836[v845.Name].Name;
                         if (t_Name_117 ~= "") then
                             local t_BrickProperties_118 = v836[v845.Name].BrickProperties;
                             local v854 = v836[v845.Name].TextureProperties;
                             local t_TextureProperties_119 = v854;
                             local v855 = Instance.new("Texture");
                             local v856 = v855;
                             v855.Name = v845.Name;
                             v855.Texture = "rbxassetid://" .. v854.TextureId;
                             local t_Transparency_120 = v844.Transparency;
                             local v857;
                             if (t_Transparency_120 > 0.8) then
                                 v857 = 1;
                             else
                                 v857 = t_TextureProperties_119.Transparency;
                                 if (not v857) then
                                     v857 = 0;
                                 end
                             end
                             v856.Transparency = v857;
                             v856.StudsPerTileU = t_TextureProperties_119.StudsPerTileU or 1;
                             v856.StudsPerTileV = t_TextureProperties_119.StudsPerTileV or 1;
                             v856.OffsetStudsU = t_TextureProperties_119.OffsetStudsU or 0;
                             v856.OffsetStudsV = t_TextureProperties_119.OffsetStudsV or 0;
                             if (t_TextureProperties_119.Color) then
                                 local v858 = t_TextureProperties_119.Color;
                                 v856.Color3 = Color3.new(v858.r / 255, v858.g / 255, v858.b / 255);
                             end
                             local v859 = 0;
                             local v860;
                             if (v844:IsA("MeshPart") or v844:IsA("UnionOperation")) then
                                 v860 = 5;
                             else
                                 v860 = 0;
                             end
                             local v861 = v859;
                             local v862 = v860;
                             if (not (v862 <= v861)) then
                                 while true do
                                     local v863 = v856:Clone();
                                     v863.Face = v859;
                                     v863.Parent = v844;
                                     local v864 = v859 + 1;
                                     v859 = v864;
                                     local v865 = v860;
                                     if (v865 < v864) then
                                         break;
                                     end
                                 end
                             end
                             v856:Destroy();
                             if (not t_BrickProperties_118.DefaultColor) then
                                 if (v844:IsA("UnionOperation")) then
                                     v844.UsePartColor = true;
                                 end
                                 if (t_BrickProperties_118.Color) then
                                     local v866 = t_BrickProperties_118.Color;
                                     v844.Color = Color3.new(v866.r / 255, v866.g / 255, v866.b / 255);
                                 else
                                     if (t_BrickProperties_118.BrickColor) then
                                         v844.BrickColor = BrickColor.new(t_BrickProperties_118.BrickColor);
                                     end
                                 end
                             end
                             if (t_BrickProperties_118.Material) then
                                 v844.Material = t_BrickProperties_118.Material;
                             end
                             if (t_BrickProperties_118.Reflectance) then
                                 v844.Reflectance = t_BrickProperties_118.Reflectance;
                             end
                         end
                     end
                 end
             else
                 if (v844:IsA("Model")) then
                     u209(v844, p182, p183, p184);
                 end
             end
         else
             break;
         end
     end
 end;
 local t_AttachmentModels_121 = v806;
 local f_hideparts = f_hideparts;
 local f_updategunattachment;
 f_updategunattachment = function(p185, p186, p187, p188, p189)
     --[[
         Name: updategunattachment
         Line: 3094
         Upvalues: 
             [1] = f_gunrequire
             [2] = t_AttachmentModels_121
             [3] = f_hideparts
 
     --]]
     local v867 = false;
     local v868 = p185:GetChildren();
     local v869 = f_gunrequire(p185.Name);
     local v870 = v869;
     local v871;
     if (v869.attachments[p186]) then
         v871 = v870.attachments[p186][p187];
         if (not v871) then
             v867 = true;
         end
     else
         v867 = true;
     end
     if (v867) then
         v871 = {};
     end
     local v872 = false;
     local v873;
     if (v871.altmodel) then
         v873 = t_AttachmentModels_121:FindFirstChild(v871.altmodel);
         if (not v873) then
             v872 = true;
         end
     else
         v872 = true;
     end
     if (v872) then
         v873 = t_AttachmentModels_121:FindFirstChild(p187);
     end
     if (not v873) then
         return;
     end
     local v874 = v873:Clone();
     local v875 = v874;
     local v876 = v874:FindFirstChild("Node");
     local v877 = v871.sidemount;
     if (v877) then
         v877 = t_AttachmentModels_121[v871.sidemount]:Clone();
     end
     v875.Name = p187;
     local v898;
     if (v877) then
         local v878 = false;
         local t_Node_122 = v877.Node;
         local v879;
         if (v871.mountnode) then
             v879 = p188[v871.mountnode];
             if (not v879) then
                 v878 = true;
             end
         else
             v878 = true;
         end
         if (v878) then
             local v880 = false;
             if (p186 == "Optics") then
                 v879 = p188.MountNode;
                 if (not v879) then
                     v880 = true;
                 end
             else
                 v880 = true;
             end
             if (v880) then
                 v879 = false;
                 if (p186 == "Underbarrel") then
                     v879 = p188.UnderMountNode;
                 end
             end
         end
         local v881 = {};
         local v882 = v877:GetChildren();
         local v883 = v882;
         local t_CFrame_123 = t_Node_122.CFrame;
         local v884 = 1;
         local v885 = #v882;
         local v886 = v885;
         local v887 = v884;
         if (not (v885 <= v887)) then
             while true do
                 if (v883[v884]:IsA("BasePart")) then
                     v881[v884] = t_CFrame_123:ToObjectSpace(v883[v884].CFrame);
                 end
                 local v888 = v884 + 1;
                 v884 = v888;
                 local v889 = v886;
                 if (v889 < v888) then
                     break;
                 end
             end
         end
         t_Node_122.CFrame = v879.CFrame;
         local v890 = 1;
         local v891 = #v883;
         local v892 = v891;
         local v893 = v890;
         if (not (v891 <= v893)) then
             while true do
                 if (v883[v890]:IsA("BasePart")) then
                     v883[v890].CFrame = v879.CFrame * v881[v890];
                 end
                 local v894 = v890 + 1;
                 v890 = v894;
                 local v895 = v892;
                 if (v895 < v894) then
                     break;
                 end
             end
         end
         local v896 = false;
         local v897;
         if (v871.node) then
             v897 = p188[v871.node];
             if (not v897) then
                 v896 = true;
             end
         else
             v896 = true;
         end
         if (v896) then
             v897 = v877[p186 .. "Node"];
         end
         v898 = v897;
         v877.Parent = v875;
     else
         local v899 = false;
         local v900;
         if (v871.node) then
             v900 = p188[v871.node];
             if (not v900) then
                 v899 = true;
             end
         else
             v899 = true;
         end
         if (v899) then
             v900 = p188[p186 .. "Node"];
         end
         v898 = v900;
     end
     if (v871.auxmodels) then
         local v901 = {};
         local g_next_124 = next;
         local t_auxmodels_125 = v871.auxmodels;
         local v902 = nil;
         while true do
             local v903, v904 = g_next_124(t_auxmodels_125, v902);
             local v905 = v903;
             local v906 = v904;
             if (v903) then
                 v902 = v905;
                 local v907 = v906.Name;
                 if (not v907) then
                     v907 = p187 .. (" " .. v906.PostName);
                 end
                 local v908 = t_AttachmentModels_121[v907]:Clone();
                 local v909 = v908;
                 local t_Node_126 = v908.Node;
                 v901[v907] = v908;
                 local v910;
                 if (v906.sidemount and v877) then
                     v910 = v877[v906.Node];
                 else
                     if ((v906.auxmount and v901[v906.auxmount]) and v901[v906.auxmount]:FindFirstChild(v906.Node)) then
                         v910 = v901[v906.auxmount][v906.Node];
                     else
                         v910 = p188[v906.Node];
                     end
                 end
                 if (v906.mainnode) then
                     v898 = v909[v906.mainnode];
                 end
                 local v911 = {};
                 local v912 = v909:GetChildren();
                 local v913 = v912;
                 local t_CFrame_127 = t_Node_126.CFrame;
                 local v914 = 1;
                 local v915 = #v912;
                 local v916 = v915;
                 local v917 = v914;
                 if (not (v915 <= v917)) then
                     while true do
                         if (v913[v914]:IsA("BasePart")) then
                             v911[v914] = t_CFrame_127:ToObjectSpace(v913[v914].CFrame);
                         end
                         local v918 = v914 + 1;
                         v914 = v918;
                         local v919 = v916;
                         if (v919 < v918) then
                             break;
                         end
                     end
                 end
                 t_Node_126.CFrame = v910.CFrame;
                 local v920 = 1;
                 local v921 = #v913;
                 local v922 = v921;
                 local v923 = v920;
                 if (not (v921 <= v923)) then
                     while true do
                         if (v913[v920]:IsA("BasePart")) then
                             v913[v920].CFrame = v910.CFrame * v911[v920];
                         end
                         local v924 = v920 + 1;
                         v920 = v924;
                         local v925 = v922;
                         if (v925 < v924) then
                             break;
                         end
                     end
                 end
                 v909.Parent = v875;
             else
                 break;
             end
         end
     end
     local v926 = {};
     local v927 = v875:GetChildren();
     local v928 = v876;
     if (v928) then
         v928 = v876.CFrame;
     end
     local v929 = f_hideparts(p185, p186, true);
     local v930 = 1;
     local v931 = #v927;
     local v932 = v931;
     local v933 = v930;
     if (not (v931 <= v933)) then
         while true do
             if (v927[v930]:IsA("BasePart")) then
                 v926[v930] = v928:ToObjectSpace(v927[v930].CFrame);
             end
             local v934 = v930 + 1;
             v930 = v934;
             local v935 = v932;
             if (v935 < v934) then
                 break;
             end
         end
     end
     local v936 = 1;
     local v937 = #v868;
     local v938 = v937;
     local v939 = v936;
     if (not (v937 <= v939)) then
         while true do
             local v940 = v868[v936];
             local v941 = v940;
             if (v871.transparencymod and v871.transparencymod[v940.Name]) then
                 local v942 = Instance.new("IntValue");
                 v942.Parent = v941;
                 v942.Name = p186 .. "Hide";
                 v942.Value = v941.Transparency;
                 v941.Transparency = v871.transparencymod[v941.Name];
             end
             local v943 = v936 + 1;
             v936 = v943;
             local v944 = v938;
             if (v944 < v943) then
                 break;
             end
         end
     end
     v876.CFrame = v898.CFrame;
     local v945 = 1;
     local v946 = #v927;
     local v947 = v946;
     local v948 = v945;
     if (not (v946 <= v948)) then
         while true do
             if (v927[v945]:IsA("BasePart")) then
                 local v949 = v927[v945];
                 local v950 = v949;
                 v949.CFrame = v898.CFrame * v926[v945];
                 if (v929 and ((v949:FindFirstChild("Mesh") or v949:IsA("UnionOperation")) or v949:IsA("MeshPart"))) then
                     (v929:Clone()).Parent = v950;
                 end
             end
             local v951 = v945 + 1;
             v945 = v951;
             local v952 = v947;
             if (v952 < v951) then
                 break;
             end
         end
     end
     v875.Parent = p185;
 end;
 local f_updategunattachment = f_updategunattachment;
 local u210 = u209;
 local u211 = u12;
 local f_getgunmodel;
 f_getgunmodel = function(p190, p191, p192)
     --[[
         Name: getgunmodel
         Line: 3224
         Upvalues: 
             [1] = t_getGunModel_4
             [2] = f_updategunattachment
             [3] = u210
             [4] = u211
 
     --]]
     local v953 = t_getGunModel_4(p190);
     local v954 = v953;
     if (not v953) then
         u211:send("deb\226\128\139ug", "Failed to find weapon model for", p190);
         error("Failed to find weapon model for", p190);
         return;
     end
     local v955 = v954:Clone();
     local v956 = v955;
     local v957 = v955:FindFirstChild("MenuNodes");
     local v958 = v957;
     v957.Parent = v955;
     v955.PrimaryPart = v957:FindFirstChild("MenuNode");
     if (p191) then
         local g_next_128 = next;
         local v959 = p191;
         local v960 = nil;
         while true do
             local v961, v962 = g_next_128(v959, v960);
             local v963 = v961;
             local v964 = v962;
             if (v961) then
                 v960 = v963;
                 if (v964 ~= "") then
                     f_updategunattachment(v956, v963, v964, v958);
                 end
             else
                 break;
             end
         end
     end
     u210(v956, p191, p192, true);
     return v956;
 end;
 local u212 = u16;
 local t_LocalPlayer_129 = v620;
 local t_KillBar_130 = v625;
 local u213 = u4;
 local u214 = u8;
 u209 = function(p193, p194, p195, p196, p197, p198, p199)
     --[[
         Name: (empty)
         Line: 3247
         Upvalues: 
             [1] = u212
             [2] = t_LocalPlayer_129
             [3] = t_KillBar_130
             [4] = u213
             [5] = u178
             [6] = f_getgunmodel
             [7] = u214
 
     --]]
     local t_cframe_131 = u212.cframe;
     local v965 = t_LocalPlayer_129;
     if (p193 == v965) then
         u212:setfixedcam(CFrame.new(t_cframe_131.p, t_cframe_131.p + t_cframe_131.lookVector));
         return;
     end
     local v966 = t_KillBar_130:Clone();
     if (u213.streamermode()) then
         v966.Killer.Label.Text = "Player";
     else
         v966.Killer.Label.Text = p194;
     end
     local v967 = Instance.new("ObjectValue");
     v967.Name = "Player";
     v967.Value = p193;
     v967.Parent = v966.Killer;
     v966.Weapon.Label.Text = p196;
     v966.Parent = u178;
     v966.Rank.Label.Text = p197;
     local v968 = f_getgunmodel(p195, p198, p199);
     local v969 = v968;
     local v970 = v968.MenuNodes:FindFirstChild("ViewportNode");
     if (not v970) then
         v970 = v969.MenuNodes.MenuNode;
     end
     v969.PrimaryPart = v970;
     v969:SetPrimaryPartCFrame(CFrame.new(0, 0, 0));
     local v971 = Instance.new("Camera");
     v971.CFrame = CFrame.new(((v970.CFrame.p + (v970.CFrame.RightVector * -7)) + (v970.CFrame.lookVector * 4)) + (v970.CFrame.upVector * 4), v970.CFrame.p + (v970.CFrame.lookVector * 1.5));
     v971.FieldOfView = 16;
     v971.Parent = v969;
     v969.Parent = v966.WeaponViewport;
     v966.WeaponViewport.CurrentCamera = v971;
     local g_next_132 = next;
     local v972, v973 = v966.Attachments:GetChildren();
     local v974 = v972;
     local v975 = v973;
     while true do
         local v976, v977 = g_next_132(v974, v975);
         local v978 = v976;
         local v979 = v977;
         if (v976) then
             v975 = v978;
             v979.Type.Text = "None";
         else
             break;
         end
     end
     if (p198) then
         local g_next_133 = next;
         local v980 = p198;
         local v981 = nil;
         while true do
             local v982, v983 = g_next_133(v980, v981);
             local v984 = v982;
             local v985 = v983;
             if (v982) then
                 v981 = v984;
                 if (not ((v984 == "Name") or (v985 == ""))) then
                     v966.Attachments[v984].Type.Text = u214.getattdisplayname(v985);
                 end
             else
                 break;
             end
         end
     end
     if (u213:isplayeralive(p193)) then
         u212:setspectate(p193);
     else
         u212:setfixedcam(CFrame.new(t_cframe_131.p, t_cframe_131.p + t_cframe_131.lookVector));
     end
     local v986 = task.delay;
     local u215 = v969;
     v986(5, function()
         --[[
             Name: (empty)
             Line: 3307
             Upvalues: 
                 [1] = u215
 
         --]]
         u215:Destroy();
     end);
 end;
 u12:add("killed", u209);
 u12:add("unlockedattach", f_unlockedattach);
 u12:add("rankup", f_rankup);
 u12:add("bigaward", function(p200, p201, p202, p203)
     --[[
         Name: (empty)
         Line: 3317
         Upvalues: 
             [1] = f_bigaward
 
     --]]
     f_bigaward(p200, p201, p202, p203);
 end);
 u12:add("smallaward", function(p204, p205)
     --[[
         Name: (empty)
         Line: 3321
         Upvalues: 
             [1] = f_smallaward
 
     --]]
     f_smallaward(p204, p205);
 end);
 u12:add("newevent", f_customevent);
 u12:add("newroundid", function(p206)
     --[[
         Name: (empty)
         Line: 3327
         Upvalues: 
             [1] = u3
 
     --]]
     u3.updateversionstr(p206);
 end);
 local u216 = u2;
 local u217 = u4;
 local f_step;
 f_step = function()
     --[[
         Name: step
         Line: 3331
         Upvalues: 
             [1] = u216
             [2] = u178
             [3] = u217
 
     --]]
     if (not u216.alive) then
         local v987 = u178:FindFirstChild("KillBar");
         local v988 = v987;
         if (v987) then
             local v989 = v988.Killer.Player.Value;
             local t_Value_134 = v989;
             if (v989) then
                 local v990 = false;
                 local v991 = u217:getplayerhealth(t_Value_134);
                 local v992 = v991;
                 v988.Health.Label.Text = math.ceil(v991);
                 local t_Label_135 = v988.Health.Label;
                 local v993;
                 if (v991 <= 20) then
                     v993 = Color3.new(1, 0, 0);
                     if (not v993) then
                         v990 = true;
                     end
                 else
                     v990 = true;
                 end
                 if (v990) then
                     local v994 = false;
                     if (v992 <= 50) then
                         v993 = Color3.new(1, 1, 0);
                         if (not v993) then
                             v994 = true;
                         end
                     else
                         v994 = true;
                     end
                     if (v994) then
                         v993 = Color3.new(0, 1, 0);
                     end
                 end
                 t_Label_135.TextColor3 = v993;
                 return;
             end
             v988.Health.Label.Text = 100;
             v988.Health.Label.TextColor3 = Color3.new(0, 1, 0);
         end
     end
 end;
 u5.step = f_step;
 print("Loading leaderboard module");
 local v995 = game:GetService("Players");
 local t_LocalPlayer_136 = v995.LocalPlayer;
 local v996 = game.ReplicatedStorage.Character.PlayerTag;
 local v997 = t_LocalPlayer_136.PlayerGui;
 local u218 = game:GetService("ReplicatedStorage"):WaitForChild("Misc"):WaitForChild("Player");
 local u219 = v997:WaitForChild("Leaderboard"):WaitForChild("Main");
 local v998 = u219:WaitForChild("TopBar"):WaitForChild("Ping");
 local v999 = u219:WaitForChild("Ghosts");
 local v1000 = u219:WaitForChild("Phantoms");
 local v1001 = v999:WaitForChild("DataFrame");
 local v1002 = v1000:WaitForChild("DataFrame");
 local u220 = v1001:WaitForChild("Data");
 local u221 = v1002:WaitForChild("Data");
 local f_organize;
 f_organize = function()
     --[[
         Name: organize
         Line: 3379
         Upvalues: 
             [1] = u220
             [2] = u221
             [3] = t_LocalPlayer_136
 
     --]]
     local v1003 = game:GetService("Players"):GetPlayers();
     local v1004 = v1003;
     local v1005 = 1;
     local v1006 = #v1003;
     local v1007 = v1006;
     local v1008 = v1005;
     if (not (v1006 <= v1008)) then
         while true do
             local v1009 = false;
             local v1010 = v1004[v1005];
             local v1011 = v1010;
             local v1012 = v1010.TeamColor;
             local t_TeamColor_137 = game.Teams.Ghosts.TeamColor;
             local v1013;
             if (v1012 == t_TeamColor_137) then
                 v1013 = u220;
                 if (not v1013) then
                     v1009 = true;
                 end
             else
                 v1009 = true;
             end
             if (v1009) then
                 v1013 = u221;
             end
             local v1014 = false;
             local v1015 = v1011.TeamColor;
             local t_TeamColor_138 = game.Teams.Ghosts.TeamColor;
             local v1016;
             if (v1015 == t_TeamColor_138) then
                 v1014 = true;
             else
                 v1016 = u220;
                 if (not v1016) then
                     v1014 = true;
                 end
             end
             if (v1014) then
                 v1016 = u221;
             end
             local v1017 = v1013:FindFirstChild(v1011.Name);
             local v1018 = v1016:FindFirstChild(v1011.Name);
             local v1019 = v1018;
             if ((not v1017) and v1018) then
                 v1019.Parent = v1013;
             end
             local v1020 = v1005 + 1;
             v1005 = v1020;
             local v1021 = v1007;
             if (v1021 < v1020) then
                 break;
             end
         end
     end
     local v1022 = u220:GetChildren();
     local v1023 = v1022;
     table.sort(v1022, function(p207, p208)
         --[[
             Name: (empty)
             Line: 3395
         --]]
         return tonumber(p208.Score.Text) < tonumber(p207.Score.Text);
     end);
     local v1024 = 1;
     local v1025 = #v1022;
     local v1026 = v1025;
     local v1027 = v1024;
     if (not (v1025 <= v1027)) then
         while true do
             local v1028 = v1023[v1024];
             local v1029 = v1028;
             v1028.Position = UDim2.new(0, 0, 0, v1024 * 25);
             local v1030 = v1028.Name;
             local t_Name_139 = t_LocalPlayer_136.Name;
             if (v1030 == t_Name_139) then
                 v1029.Username.TextColor3 = Color3.new(1, 1, 0);
             end
             local v1031 = v1024 + 1;
             v1024 = v1031;
             local v1032 = v1026;
             if (v1032 < v1031) then
                 break;
             end
         end
     end
     u220.Parent.CanvasSize = UDim2.new(0, 0, 0, ((#v1023) + 1) * 25);
     local v1033 = u221:GetChildren();
     local v1034 = v1033;
     table.sort(v1033, function(p209, p210)
         --[[
             Name: (empty)
             Line: 3410
         --]]
         return tonumber(p210.Score.Text) < tonumber(p209.Score.Text);
     end);
     local v1035 = 1;
     local v1036 = #v1033;
     local v1037 = v1036;
     local v1038 = v1035;
     if (not (v1036 <= v1038)) then
         while true do
             local v1039 = v1034[v1035];
             local v1040 = v1039;
             v1039.Position = UDim2.new(0, 0, 0, v1035 * 25);
             local v1041 = v1039.Name;
             local t_Name_140 = t_LocalPlayer_136.Name;
             if (v1041 == t_Name_140) then
                 v1040.Username.TextColor3 = Color3.new(1, 1, 0);
             end
             local v1042 = v1035 + 1;
             v1035 = v1042;
             local v1043 = v1037;
             if (v1043 < v1042) then
                 break;
             end
         end
     end
     u221.Parent.CanvasSize = UDim2.new(0, 0, 0, ((#v1034) + 1) * 25);
 end;
 local f_addplayer;
 f_addplayer = function(p211)
     --[[
         Name: addplayer
         Line: 3425
         Upvalues: 
             [1] = u220
             [2] = u221
             [3] = u218
             [4] = u4
             [5] = t_LocalPlayer_136
             [6] = u219
             [7] = f_organize
 
     --]]
     if (u220:FindFirstChild(p211.Name) or u221:FindFirstChild(p211.Name)) then
         return;
     end
     local v1044 = u218:Clone();
     local v1045 = v1044;
     v1044.Name = p211.Name;
     if (u4.streamermode()) then
         v1045.Username.Text = "Player";
     else
         v1045.Username.Text = p211.Name;
     end
     v1045.Kills.Text = 0;
     v1045.Deaths.Text = 0;
     v1045.Streak.Text = 0;
     v1045.Score.Text = 0;
     v1045.Kdr.Text = 0;
     v1045.Rank.Text = 0;
     local v1046 = t_LocalPlayer_136;
     if (p211 == v1046) then
         v1045.Username.TextColor3 = Color3.new(1, 1, 0);
     end
     local v1047 = false;
     local v1048 = p211.TeamColor;
     local t_TeamColor_141 = game.Teams.Ghosts.TeamColor;
     local v1049;
     if (v1048 == t_TeamColor_141) then
         v1049 = u220;
         if (not v1049) then
             v1047 = true;
         end
     else
         v1047 = true;
     end
     if (v1047) then
         v1049 = u221;
     end
     v1045.Parent = v1049;
     if (u219.Visible) then
         f_organize();
     end
 end;
 local f_removeplayer;
 f_removeplayer = function(p212)
     --[[
         Name: removeplayer
         Line: 3457
         Upvalues: 
             [1] = u220
             [2] = u221
             [3] = u219
             [4] = f_organize
 
     --]]
     local v1050 = u220:FindFirstChild(p212.Name);
     local v1051 = v1050;
     local v1052 = u221:FindFirstChild(p212.Name);
     if (v1050) then
         v1051:Destroy();
     end
     if (v1052) then
         v1052:Destroy();
     end
     if (u219.Visible) then
         f_organize();
     end
 end;
 local f_updatestats;
 f_updatestats = function(p213, p214)
     --[[
         Name: updatestats
         Line: 3474
         Upvalues: 
             [1] = u220
             [2] = u221
             [3] = u219
             [4] = f_organize
 
     --]]
     local v1053 = u220:FindFirstChild(p213.Name);
     if (not v1053) then
         v1053 = u221:FindFirstChild(p213.Name);
     end
     if (v1053) then
         local g_next_142 = next;
         local v1054 = p214;
         local v1055 = nil;
         while true do
             local v1056, v1057 = g_next_142(v1054, v1055);
             local v1058 = v1056;
             local v1059 = v1057;
             if (v1056) then
                 v1055 = v1058;
                 v1053[v1058].Text = v1059;
             else
                 break;
             end
         end
     else
         warn("Bar not found for", p213.Name);
     end
     if (u219.Visible) then
         f_organize();
     end
 end;
 local f_streamerscramble;
 f_streamerscramble = function()
     --[[
         Name: streamerscramble
         Line: 3489
         Upvalues: 
             [1] = u4
             [2] = u220
             [3] = u221
 
     --]]
     if (u4.streamermode()) then
         local g_next_143 = next;
         local v1060, v1061 = u220:GetChildren();
         local v1062 = v1060;
         local v1063 = v1061;
         while true do
             local v1064, v1065 = g_next_143(v1062, v1063);
             local v1066 = v1064;
             local v1067 = v1065;
             if (v1064) then
                 v1063 = v1066;
                 v1067.Username.Text = "Player";
             else
                 break;
             end
         end
         local g_next_144 = next;
         local v1068, v1069 = u221:GetChildren();
         local v1070 = v1068;
         local v1071 = v1069;
         while true do
             local v1072, v1073 = g_next_144(v1070, v1071);
             local v1074 = v1072;
             local v1075 = v1073;
             if (v1072) then
                 v1071 = v1074;
                 v1075.Username.Text = "Player";
             else
                 break;
             end
         end
         return;
     end
     local g_next_145 = next;
     local v1076, v1077 = u220:GetChildren();
     local v1078 = v1076;
     local v1079 = v1077;
     while true do
         local v1080, v1081 = g_next_145(v1078, v1079);
         local v1082 = v1080;
         local v1083 = v1081;
         if (v1080) then
             v1079 = v1082;
             v1083.Username.Text = v1083.Name;
         else
             break;
         end
     end
     local g_next_146 = next;
     local v1084, v1085 = u221:GetChildren();
     local v1086 = v1084;
     local v1087 = v1085;
     while true do
         local v1088, v1089 = g_next_146(v1086, v1087);
         local v1090 = v1088;
         local v1091 = v1089;
         if (v1088) then
             v1087 = v1090;
             v1091.Username.Text = v1091.Name;
         else
             break;
         end
     end
 end;
 local f_show;
 f_show = function(p215)
     --[[
         Name: show
         Line: 3509
         Upvalues: 
             [1] = f_streamerscramble
             [2] = f_organize
             [3] = u219
 
     --]]
     f_streamerscramble();
     f_organize();
     u219.Visible = true;
 end;
 u6.show = f_show;
 local f_hide;
 f_hide = function(p216)
     --[[
         Name: hide
         Line: 3515
         Upvalues: 
             [1] = u219
 
     --]]
     u219.Visible = false;
 end;
 u6.hide = f_hide;
 local f_setupleaderboard;
 f_setupleaderboard = function(p217)
     --[[
         Name: setupleaderboard
         Line: 3519
         Upvalues: 
             [1] = f_updatestats
 
     --]]
     local g_next_147 = next;
     local v1092 = p217;
     local v1093 = nil;
     while true do
         local v1094, v1095 = g_next_147(v1092, v1093);
         local v1096 = v1094;
         local v1097 = v1095;
         if (v1094) then
             v1093 = v1096;
             f_updatestats(v1097.player, v1097.stats);
         else
             break;
         end
     end
 end;
 u12:add("updatestats", f_updatestats);
 u12:add("fillboard", f_setupleaderboard);
 v995.PlayerAdded:connect(f_addplayer);
 v995.PlayerRemoving:connect(f_removeplayer);
 local g_next_148 = next;
 local v1098, v1099 = v995:GetPlayers();
 local v1100 = v1098;
 local v1101 = v1099;
 while true do
     local v1102, v1103 = g_next_148(v1100, v1101);
     local v1104 = v1102;
     local v1105 = v1103;
     if (v1102) then
         v1101 = v1104;
         f_addplayer(v1105);
     else
         break;
     end
 end
 game:GetService("UserInputService").InputBegan:connect(function(p218)
     --[[
         Name: (empty)
         Line: 3535
         Upvalues: 
             [1] = u17
             [2] = u219
             [3] = u6
             [4] = f_organize
 
     --]]
     local v1106 = false;
     local v1107 = p218.KeyCode;
     local t_KeyCode_149 = v1107;
     local v1108 = Enum.KeyCode.Tab;
     if ((v1107 == v1108) and (not u17.iskeydown(Enum.KeyCode.LeftAlt))) then
         v1106 = true;
     else
         local v1109 = Enum.KeyCode.ButtonSelect;
         if (t_KeyCode_149 == v1109) then
             v1106 = true;
         end
     end
     if (v1106) then
         if (u219.Visible) then
             u6:hide();
             return;
         end
         f_organize();
         u6:show();
     end
 end);
 local u222 = 60;
 local u223 = tick();
 local u224 = u219;
 local u225 = v998;
 local u226 = u12;
 local f_step;
 f_step = function(p219)
     --[[
         Name: step
         Line: 3550
         Upvalues: 
             [1] = u222
             [2] = u224
             [3] = u225
             [4] = u223
             [5] = u226
 
     --]]
     u222 = (0.95 * u222) + (0.05 / p219);
     if (u224.Visible and u225) then
         local v1110 = tick();
         if (u223 <= v1110) then
             local v1111 = u222 - (u222 % 1);
             if (not (((v1111 == v1111) and (not (v1111 == -(1/0)))) and (not (v1111 == (1/0))))) then
                 v1111 = 60;
                 u222 = v1111;
             end
             u225.Text = "Server Avg Send Ping: " .. ((u226.serverping or 0) .. ("ms\nYour Send Ping: " .. ((u226.playerping or 0) .. ("ms\nAverage FPS: " .. v1111))));
             u223 = tick() + 1;
         end
     end
 end;
 u6.step = f_step;
 print("Loading char module");
 local v1112 = shared.require("WepScript");
 local u227 = math.pi * 2;
 local u228 = Instance.new;
 local u229 = CFrame.new;
 local v1113 = u229();
 local v1114 = CFrame.Angles;
 local v1115 = Vector3.new();
 local v1116 = v1115;
 local u230 = Ray.new;
 local t_Debris_150 = game.Debris;
 local t_Dot_151 = v1115.Dot;
 local v1117 = UDim2.new;
 local t_toObjectSpace_152 = u229().toObjectSpace;
 local u231 = nil;
 local u232 = nil;
 local u233 = nil;
 local v1118 = game:GetService("ReplicatedStorage"):WaitForChild("Character"):WaitForChild("Bodies"):WaitForChild("RefPlayer");
 local u234 = {};
 local t_LocalPlayer_153 = game:GetService("Players").LocalPlayer;
 local t_PlayerGui_154 = t_LocalPlayer_153.PlayerGui;
 local v1119 = game.ReplicatedStorage;
 local t_ReplicatedStorage_155 = v1119;
 local v1120 = workspace:FindFirstChild("Players");
 local v1121 = workspace:WaitForChild("Map");
 local t_AttachmentModels_156 = v1119.AttachmentModels;
 local v1122 = Enum.Material.Air;
 local t_soundfonts_157 = u21.soundfonts;
 local v1123 = u21.materialhitsound;
 local v1124 = {
     Enum.HumanoidStateType.Dead,
     Enum.HumanoidStateType.Flying,
     Enum.HumanoidStateType.Seated,
     Enum.HumanoidStateType.Ragdoll,
     Enum.HumanoidStateType.Physics,
     Enum.HumanoidStateType.Swimming,
     Enum.HumanoidStateType.GettingUp,
     Enum.HumanoidStateType.FallingDown,
     Enum.HumanoidStateType.PlatformStanding,
     Enum.HumanoidStateType.RunningNoPhysics,
     Enum.HumanoidStateType.StrafingNoPhysics
 };
 local v1125 = v1124;
 local v1126 = v22.new();
 local u235 = nil;
 local u236 = false;
 local u237 = false;
 local u238 = false;
 local u239 = false;
 local u240 = 0;
 local u241 = 14;
 local v1127 = v19.new();
 local u242 = v19.new();
 local u243 = u228("Humanoid");
 local v1128 = 1;
 local v1129 = #v1124;
 local v1130 = v1129;
 local v1131 = v1128;
 if (not (v1129 <= v1131)) then
     while true do
         u243:SetStateEnabled(v1125[v1128], false);
         local v1132 = v1128 + 1;
         v1128 = v1132;
         local v1133 = v1130;
         if (v1133 < v1132) then
             break;
         end
     end
 end
 u243.AutomaticScalingEnabled = false;
 u243.AutoRotate = false;
 u243.AutoJumpEnabled = false;
 u243.BreakJointsOnDeath = false;
 u243.HealthDisplayDistance = 0;
 u243.NameDisplayDistance = 0;
 u243.RequiresNeck = false;
 u243.RigType = Enum.HumanoidRigType.R6;
 local u244 = 0;
 local v1134 = v19.new();
 local v1135 = v1134;
 local v1136 = v19.new(1);
 local v1137 = v1136;
 v1136.s = 12;
 v1136.d = 0.95;
 local u245 = {};
 u2.unaimedfov = 80;
 u2.speed = 0;
 u2.distance = 0;
 u2.sprint = false;
 u2.acceleration = v1116;
 local f_setunaimedfov;
 f_setunaimedfov = function(p220)
     --[[
         Name: setunaimedfov
         Line: 3667
         Upvalues: 
             [1] = u2
 
     --]]
     u2.unaimedfov = p220;
 end;
 u2.setunaimedfov = f_setunaimedfov;
 local f_isdirtyfloat;
 f_isdirtyfloat = function(p221)
     --[[
         Name: isdirtyfloat
         Line: 3671
     --]]
     local v1138 = true;
     if (p221 == p221) then
         v1138 = true;
         if (p221 ~= -(1/0)) then
             v1138 = p221 == (1/0);
         end
     end
     return v1138;
 end;
 local f_addgun;
 f_addgun = function(p222)
     --[[
         Name: addgun
         Line: 3675
         Upvalues: 
             [1] = u244
             [2] = u245
 
     --]]
     local v1139 = 1;
     local v1140 = u244;
     local v1141 = v1140;
     local v1142 = v1139;
     if (not (v1140 <= v1142)) then
         while (u245[v1139] ~= p222) do
             local v1143 = v1139 + 1;
             v1139 = v1143;
             local v1144 = v1141;
             if (v1144 < v1143) then
                 break;
             end
         end
         warn("Error, tried to add gun twice");
         return;
     end
     u244 = u244 + 1;
     u245[u244] = p222;
     p222.id = u244;
     return u244;
 end;
 local f_removegun;
 f_removegun = function(p223)
     --[[
         Name: removegun
         Line: 3688
         Upvalues: 
             [1] = u244
             [2] = u245
 
     --]]
     local v1145 = nil;
     local v1146 = 1;
     local v1147 = u244;
     local v1148 = v1147;
     local v1149 = v1146;
     if (not (v1147 <= v1149)) then
         while (u245[v1146] ~= p223) do
             local v1150 = v1146 + 1;
             v1146 = v1150;
             local v1151 = v1148;
             if (v1151 < v1150) then
                 break;
             end
         end
         v1145 = true;
     end
     if (not v1145) then
         warn("Error, tried to remove gun twice");
         return;
     end
     local v1152 = p223.id;
     local t_id_158 = v1152;
     p223.id = nil;
     u245[v1152] = u245[u244];
     u245[u244] = nil;
     u244 = u244 - 1;
     local v1153 = u245[v1152];
     local v1154 = v1153;
     if (v1153) then
         v1154.id = t_id_158;
     end
 end;
 local f_unloadguns;
 f_unloadguns = function()
     --[[
         Name: unloadguns
         Line: 3711
         Upvalues: 
             [1] = u244
             [2] = u245
 
     --]]
     u244 = 0;
     u245 = {};
 end;
 u2.unloadguns = f_unloadguns;
 local v1155 = v19.new(v1116);
 local v1156 = v1155;
 local v1157 = v19.new();
 local v1158 = v1157;
 local v1159 = v19.new(v1116);
 local v1160 = v1159;
 local v1161 = v19.new(0);
 local v1162 = v19.new(0);
 local v1163 = v19.new(0);
 local v1164 = v19.new(0);
 local v1165 = v1164;
 local v1166 = v19.new(1);
 local u246 = v19.new(0);
 local u247 = 1;
 v1127.s = 12;
 v1127.d = 0.9;
 u242.s = 12;
 u242.d = 0.9;
 v1134.d = 0.9;
 v1155.s = 10;
 v1155.d = 0.75;
 v1157.s = 16;
 v1159.s = 16;
 v1161.s = 8;
 v1162.s = 8;
 v1163.s = 20;
 v1164.s = 8;
 v1166.s = 12;
 v1166.d = 0.75;
 u2.crouchspring = v1162;
 u2.pronespring = v1161;
 u2.slidespring = v1163;
 u2.movementmode = "stand";
 local v1167 = u228("BodyVelocity");
 local v1168 = v1167;
 v1167.Name = "\n";
 local u248 = nil;
 local u249 = v19.new(u241);
 u249.s = 8;
 local u250 = v19.new(1.5);
 u250.s = 8;
 v1167.MaxForce = v1116;
 local u251 = "stand";
 local f_getslidecondition;
 f_getslidecondition = function()
     --[[
         Name: getslidecondition
         Line: 3767
         Upvalues: 
             [1] = u249
             [2] = u241
 
     --]]
     return (u241 * 1.2) < u249.p;
 end;
 u2.getslidecondition = f_getslidecondition;
 local f_updatewalkspeed;
 f_updatewalkspeed = function()
     --[[
         Name: updatewalkspeed
         Line: 3771
         Upvalues: 
             [1] = u238
             [2] = u249
             [3] = u247
             [4] = u241
             [5] = u251
 
     --]]
     if (u238) then
         u249.t = (1.4 * u247) * u241;
         return;
     end
     local v1169 = u251;
     if (v1169 == "prone") then
         u249.t = (u247 * u241) / 4;
         return;
     end
     local v1170 = u251;
     if (v1170 == "crouch") then
         u249.t = (u247 * u241) / 2;
         return;
     end
     local v1171 = u251;
     if (v1171 == "stand") then
         u249.t = u247 * u241;
     end
 end;
 local u252 = u2;
 local u253 = u21;
 local u254 = v1161;
 local u255 = v1162;
 local u256 = u4;
 local u257 = v1167;
 local u258 = u17;
 local u259 = u16;
 local u260 = v1116;
 local u261 = u12;
 local u262 = v1127;
 local f_setmovementmode;
 f_setmovementmode = function(p224, p225, p226)
     --[[
         Name: setmovementmode
         Line: 3783
         Upvalues: 
             [1] = u252
             [2] = u251
             [3] = u253
             [4] = u250
             [5] = u254
             [6] = u255
             [7] = u249
             [8] = u247
             [9] = u241
             [10] = u256
             [11] = u240
             [12] = u238
             [13] = u231
             [14] = u243
             [15] = u236
             [16] = u257
             [17] = u258
             [18] = u259
             [19] = u260
             [20] = u235
             [21] = u261
             [22] = u262
 
     --]]
     local t_movementmode_159 = u252.movementmode;
     u252.movementmode = p225;
     u251 = p225;
     if (p225 == "prone") then
         if (not (p226 or (t_movementmode_159 == p225))) then
             u253.play("stanceProne", 0.15);
         end
         u250.t = -1.5;
         u254.t = 1;
         u255.t = 0;
         u249.t = (u247 * u241) / 4;
         u256:setcrossscale(0.5);
         u240 = 0.25;
         if (p226 and u238) then
             local t_y_160 = u231.Velocity.y;
             if (t_y_160 >= -5) then
                 coroutine.wrap(function()
                     --[[
                         Name: (empty)
                         Line: 3797
                         Upvalues: 
                             [1] = u231
 
                     --]]
                     local v1172 = u231.CFrame.lookVector;
                     u231.Velocity = (v1172 * 50) + Vector3.new(0, 40, 0);
                     task.wait(0.1);
                     u231.Velocity = (v1172 * 60) + Vector3.new(0, 30, 0);
                     task.wait(0.4);
                     u231.Velocity = (v1172 * 20) + Vector3.new(0, -10, 0);
                 end)();
             end
         end
     else
         if (p225 == "crouch") then
             if (not (p226 or (t_movementmode_159 == p225))) then
                 u253.play("stanceStandCrouch", 0.15);
             end
             local u263 = false;
             local v1173 = u252.getslidecondition();
             u250.t = 0;
             u254.t = 0;
             u255.t = 1;
             u249.t = (u247 * u241) / 2;
             u256:setcrossscale(0.75);
             u240 = 0.15;
             if (p226 and v1173) then
                 local v1174 = u243:GetState();
                 local v1175 = Enum.HumanoidStateType.Freefall;
                 if (v1174 ~= v1175) then
                     u236 = true;
                     u253.play("slideStart", 0.25);
                     u252.slidespring.t = 1;
                     coroutine.wrap(function()
                         --[[
                             Name: (empty)
                             Line: 3821
                             Upvalues: 
                                 [1] = u252
                                 [2] = u257
                                 [3] = u258
                                 [4] = u263
                                 [5] = u259
                                 [6] = u249
                                 [7] = u260
                                 [8] = u236
                                 [9] = u253
 
                         --]]
                         local v1176 = u252.rootpart;
                         local t_rootpart_161 = v1176;
                         local v1177 = v1176.Velocity.unit;
                         local v1178 = v1176.CFrame:VectorToObjectSpace(v1177);
                         u257.MaxForce = Vector3.new(40000, 10, 40000);
                         local v1179 = tick();
                         while true do
                             local v1180 = tick();
                             local v1181 = v1179 + 0.6666666666666666;
                             if (v1180 <= v1181) then
                                 local v1182 = ((tick() - v1179) * 30) / 0.6666666666666666;
                                 if (u258.keyboard.down.leftshift or u258.controller.down.l3) then
                                     if (u263) then
                                         break;
                                     end
                                     v1177 = u259.cframe:VectorToWorldSpace(v1178);
                                 else
                                     u263 = true;
                                 end
                                 u257.Velocity = v1177 * (40 - v1182);
                                 task.wait();
                             else
                                 break;
                             end
                         end
                         u249.p = t_rootpart_161.Velocity.Magnitude;
                         u257.MaxForce = u260;
                         u257.Velocity = u260;
                         if (u236) then
                             u236 = false;
                             u253.play("slideEnd", 0.15);
                         end
                         u252.slidespring.t = 0;
                     end)();
                 end
             end
         else
             if (p225 == "stand") then
                 if (t_movementmode_159 ~= p225) then
                     u253.play("stanceStandCrouch", 0.15);
                 end
                 u250.t = 1.5;
                 u254.t = 0;
                 u255.t = 0;
                 u249.t = u247 * u241;
                 u256:setcrossscale(1);
                 u240 = 0;
             end
         end
     end
     if (u235 and u235.stancechange) then
         u235.stancechange(p225);
     end
     u261:send("sta\226\128\139nce", p225);
     u238 = false;
     u261:send("spr\226\128\139int", u238);
     u262.t = 0;
 end;
 local f_getstate;
 f_getstate = function()
     --[[
         Name: getstate
         Line: 3879
         Upvalues: 
             [1] = u243
 
     --]]
     return u243:GetState();
 end;
 u2.getstate = f_getstate;
 local f_sprinting;
 f_sprinting = function()
     --[[
         Name: sprinting
         Line: 3883
         Upvalues: 
             [1] = u238
 
     --]]
     return u238;
 end;
 u2.sprinting = f_sprinting;
 u2.setmovementmode = f_setmovementmode;
 local f_setbasewalkspeed;
 f_setbasewalkspeed = function(p227, p228)
     --[[
         Name: setbasewalkspeed
         Line: 3889
         Upvalues: 
             [1] = u241
             [2] = f_updatewalkspeed
 
     --]]
     u241 = p228;
     f_updatewalkspeed();
 end;
 u2.setbasewalkspeed = f_setbasewalkspeed;
 local u264 = u10;
 local u265 = u21;
 local f_setmovementmode = f_setmovementmode;
 local u266 = u12;
 local u267 = v1127;
 local u268 = u17;
 local f_setsprint;
 f_setsprint = function(p229, p230)
     --[[
         Name: setsprint
         Line: 3894
         Upvalues: 
             [1] = u264
             [2] = u236
             [3] = u265
             [4] = f_setmovementmode
             [5] = u238
             [6] = u266
             [7] = u247
             [8] = u237
             [9] = u239
             [10] = u267
             [11] = u249
             [12] = u241
             [13] = u268
 
     --]]
     local t_currentgun_162 = u264.currentgun;
     if (not p230) then
         if (u238) then
             u238 = false;
             u266:send("sp\226\128\139rint", u238);
             u267.t = 0;
             u249.t = u247 * u241;
             if ((u268.mouse.down.right or u268.controller.down.l2) and t_currentgun_162) then
                 local t_type_164 = t_currentgun_162.type;
                 if (t_type_164 ~= "KNIFE") then
                     local t_type_165 = t_currentgun_162.type;
                     if (t_type_165 ~= "Grenade") then
                         t_currentgun_162:setaim(true);
                     end
                 end
             end
         end
         return;
     end
     if (u236) then
         u236 = false;
         u265.play("slideEnd", 0.15);
     end
     f_setmovementmode(nil, "stand");
     u238 = true;
     u266:send("spri\226\128\139nt", u238);
     if (t_currentgun_162) then
         t_currentgun_162.auto = false;
         if (t_currentgun_162 and t_currentgun_162.isaiming()) then
             local t_type_163 = t_currentgun_162.type;
             if (t_type_163 ~= "KNIFE") then
                 t_currentgun_162:setaim(false);
             end
         end
     end
     u247 = 1;
     if (not (u237 or u239)) then
         u267.t = 1;
     end
     u249.t = (1.5 * u247) * u241;
 end;
 u2.setsprint = f_setsprint;
 local u269 = u2;
 local u270 = u21;
 local u271 = v1167;
 local u272 = v1116;
 local u273 = u228;
 local u274 = t_Debris_150;
 local f_parkour;
 f_parkour = function()
     --[[
         Name: parkour
         Line: 3934
         Upvalues: 
             [1] = u235
             [2] = u237
             [3] = u269
             [4] = u270
             [5] = u271
             [6] = u272
             [7] = u273
             [8] = u231
             [9] = u274
 
     --]]
     if ((u235 and (not u237)) and (not u269.grenadehold)) then
         u235:playanimation("parkour");
     end
     u270.play("parkour", 0.25);
     u271.MaxForce = u272;
     local v1183 = u273("BodyPosition");
     v1183.Name = "\n";
     v1183.position = (u231.Position + ((u231.CFrame.lookVector.unit * u269.speed) * 1.5)) + Vector3.new(0, 10, 0);
     v1183.maxForce = Vector3.new(500000, 500000, 500000);
     v1183.P = 4000;
     v1183.Parent = u231;
     u274:AddItem(v1183, 0.5);
 end;
 local f_drawparkourray;
 f_drawparkourray = function(p231, p232, p233, p234)
     --[[
         Name: drawparkourray
         Line: 3951
         Upvalues: 
             [1] = t_Debris_150
 
     --]]
     local v1184 = false;
     local v1185 = Instance.new("Part");
     local v1186;
     if (p232) then
         v1186 = BrickColor.new("Bright red");
         if (not v1186) then
             v1184 = true;
         end
     else
         v1184 = true;
     end
     if (v1184) then
         v1186 = p234;
         if (not v1186) then
             v1186 = BrickColor.new("Bright green");
         end
     end
     v1185.BrickColor = v1186;
     v1185.FormFactor = "Custom";
     v1185.Material = "Neon";
     local v1187;
     if (p232) then
         v1187 = 0.5;
     else
         v1187 = 0.9;
     end
     v1185.Transparency = v1187;
     v1185.Anchored = true;
     v1185.Locked = true;
     v1185.CanCollide = false;
     v1185.Parent = workspace;
     local v1188 = (p231 - p233).Magnitude;
     v1185.Size = Vector3.new(0.05, 0.05, v1188);
     v1185.CFrame = CFrame.new(p231, p233) * CFrame.new(0, 0, (-v1188) / 2);
     t_Debris_150:AddItem(v1185, 5);
 end;
 local v1189 = {};
 local v1190 = {};
 v1190.lower = 1.8;
 v1190.upper = 4;
 v1190.width = 1.5;
 v1190.xrays = 5;
 v1190.yrays = 8;
 v1190.dist = 6;
 v1190.sprintdist = 8;
 v1190.color = BrickColor.new("Bright blue");
 v1189.mid = v1190;
 local v1191 = {};
 v1191.lower = 5;
 v1191.upper = 6;
 v1191.width = 1;
 v1191.xrays = 5;
 v1191.yrays = 7;
 v1191.dist = 8;
 v1191.sprintdist = 10;
 v1191.color = BrickColor.new("Bright green");
 v1189.upper = v1191;
 local u275 = u229;
 local u276 = v1189;
 local u277 = u230;
 local u278 = u9;
 local f_parkourdetection;
 f_parkourdetection = function()
     --[[
         Name: parkourdetection
         Line: 3993
         Upvalues: 
             [1] = u231
             [2] = u275
             [3] = u276
             [4] = u277
             [5] = u238
             [6] = u278
 
     --]]
     local v1192 = u231.CFrame * u275(0, -3, 0);
     local v1193 = false;
     local v1194 = false;
     local t_lookVector_166 = u231.CFrame.lookVector;
     local v1195 = {};
     v1195.mid = {};
     v1195.upper = {};
     local v1196 = {};
     local g_next_167 = next;
     local v1197 = u276;
     local v1198 = nil;
     while true do
         local v1199, v1200 = g_next_167(v1197, v1198);
         local v1201 = v1199;
         local v1202 = v1200;
         if (v1199) then
             v1198 = v1201;
             local v1203 = 0;
             local v1204 = v1202.xrays - 1;
             local v1205 = v1204;
             local v1206 = v1203;
             if (not (v1204 <= v1206)) then
                 while true do
                     local v1207 = 0;
                     local v1208 = v1202.yrays - 1;
                     local v1209 = v1208;
                     local v1210 = v1207;
                     if (not (v1208 <= v1210)) then
                         while true do
                             local v1211 = false;
                             local v1212 = ((v1203 / (v1202.xrays - 1)) - 0.5) * v1202.width;
                             local v1213 = v1212;
                             local v1214 = v1192 * Vector3.new(v1212, ((v1207 / (v1202.yrays - 1)) * (v1202.upper - v1202.lower)) + v1202.lower, 0);
                             local v1215 = v1214;
                             local v1216 = u277;
                             local v1217 = v1214;
                             local v1218;
                             if (u238) then
                                 v1218 = v1202.sprintdist;
                                 if (not v1218) then
                                     v1211 = true;
                                 end
                             else
                                 v1211 = true;
                             end
                             if (v1211) then
                                 v1218 = v1202.dist;
                             end
                             local v1219, v1220 = workspace:FindPartOnRayWithWhitelist(v1216(v1217, t_lookVector_166 * v1218), u278.raycastwhitelist);
                             local v1221 = v1220;
                             if (v1219 and v1219.CanCollide) then
                                 local v1222 = (v1215 - v1221).Magnitude;
                                 local t_Magnitude_168 = v1222;
                                 v1195[v1201][(#v1195[v1201]) + 1] = v1222;
                                 if (v1201 == "mid") then
                                     v1193 = true;
                                     if (v1213 == 0) then
                                         v1196[(#v1196) + 1] = t_Magnitude_168;
                                     end
                                 else
                                     if (v1201 == "upper") then
                                         v1194 = true;
                                     end
                                 end
                             end
                             local v1223 = v1207 + 1;
                             v1207 = v1223;
                             local v1224 = v1209;
                             if (v1224 < v1223) then
                                 break;
                             end
                         end
                     end
                     local v1225 = v1203 + 1;
                     v1203 = v1225;
                     local v1226 = v1205;
                     if (v1226 < v1225) then
                         break;
                     end
                 end
             end
         else
             break;
         end
     end
     if (v1193) then
         local v1227 = {};
         local v1228 = 2;
         local v1229 = #v1196;
         local v1230 = v1229;
         local v1231 = v1228;
         if (not (v1229 <= v1231)) then
             while true do
                 v1227[(#v1227) + 1] = v1196[v1228] - v1196[v1228 - 1];
                 local v1232 = v1228 + 1;
                 v1228 = v1232;
                 local v1233 = v1230;
                 if (v1233 < v1232) then
                     break;
                 end
             end
         end
         local v1234 = nil;
         local v1235 = 0;
         local v1236 = 1;
         local v1237 = #v1227;
         local v1238 = v1237;
         local v1239 = v1236;
         if (not (v1237 <= v1239)) then
             while true do
                 if (v1235 == 0) then
                     v1234 = v1227[v1236];
                     v1235 = 1;
                 else
                     if (math.abs(v1227[v1236] - v1234) <= 0.01) then
                         v1235 = v1235 + 1;
                     else
                         v1235 = v1235 - 1;
                     end
                 end
                 local v1240 = v1236 + 1;
                 v1236 = v1240;
                 local v1241 = v1238;
                 if (v1241 < v1240) then
                     break;
                 end
             end
         end
         local v1242 = 0;
         local v1243 = 1;
         local v1244 = #v1227;
         local v1245 = v1244;
         local v1246 = v1243;
         if (not (v1244 <= v1246)) then
             while true do
                 if (math.abs(v1227[v1243] - v1234) <= 0.01) then
                     v1242 = v1242 + 1;
                 end
                 local v1247 = v1243 + 1;
                 v1243 = v1247;
                 local v1248 = v1245;
                 if (v1248 < v1247) then
                     break;
                 end
             end
         end
         if (((((#v1227) / 2) <= v1242) and (not (v1234 == 0))) and (math.abs(((u276.mid.upper - u276.mid.lower) / u276.mid.yrays) / v1234) <= 2)) then
             return false;
         end
         local v1249 = {};
         v1249.mid = 100;
         v1249.upper = 100;
         local v1250 = {};
         v1250.mid = 0;
         v1250.upper = 0;
         local g_next_169 = next;
         local v1251 = nil;
         while true do
             local v1252, v1253 = g_next_169(v1195, v1251);
             local v1254 = v1252;
             local v1255 = v1253;
             if (v1252) then
                 v1251 = v1254;
                 local v1256 = 1;
                 local v1257 = #v1255;
                 local v1258 = v1257;
                 local v1259 = v1256;
                 if (not (v1257 <= v1259)) then
                     while true do
                         local v1260 = v1255[v1256];
                         local v1261 = v1260;
                         local v1262 = v1249[v1254];
                         if (v1260 <= v1262) then
                             v1249[v1254] = v1261;
                         end
                         if (v1250[v1254] <= v1261) then
                             v1250[v1254] = v1261;
                         end
                         local v1263 = v1256 + 1;
                         v1256 = v1263;
                         local v1264 = v1258;
                         if (v1264 < v1263) then
                             break;
                         end
                     end
                 end
             else
                 break;
             end
         end
         local v1265 = math.abs((((v1250.upper + v1249.upper) - v1250.mid) - v1249.mid) / 2);
         if (not (v1194 and (not (v1194 and (v1265 >= 4))))) then
             return true;
         end
     end
 end;
 local u279 = u2;
 local u280 = v1122;
 local u281 = u10;
 local f_setmovementmode = f_setmovementmode;
 local f_parkourdetection = f_parkourdetection;
 local f_parkour = f_parkour;
 local f_jump;
 f_jump = function(p235, p236)
     --[[
         Name: jump
         Line: 4105
         Upvalues: 
             [1] = u279
             [2] = u280
             [3] = u281
             [4] = u231
             [5] = u251
             [6] = f_setmovementmode
             [7] = u235
             [8] = f_parkourdetection
             [9] = f_parkour
             [10] = u243
 
     --]]
     if (u279.FloorMaterial == u280) then
         return;
     end
     if (u281.currentgun.knife) then
         p236 = p236 * 1.15;
     end
     local v1266 = false;
     local v1267 = u231.CFrame;
     local t_y_170 = u231.Velocity.y;
     local v1268;
     if (p236) then
         v1268 = ((2 * game.Workspace.Gravity) * p236) ^ 0.5;
         if (not v1268) then
             v1266 = true;
         end
     else
         v1266 = true;
     end
     if (v1266) then
         v1268 = 40;
     end
     local v1269;
     if (t_y_170 <= 0) then
         v1269 = v1268;
     else
         v1269 = ((t_y_170 * t_y_170) + (v1268 * v1268)) ^ 0.5;
     end
     local v1270 = u251;
     if (v1270 ~= "prone") then
         local v1271 = u251;
         if (v1271 ~= "crouch") then
             if (u235 and (not u235.isaiming())) then
                 local t_speed_171 = u279.speed;
                 if (((t_speed_171 >= 5) and (u279.velocity.z <= 0)) and f_parkourdetection()) then
                     f_parkour();
                 else
                     u243.JumpPower = v1269;
                     u243.Jump = true;
                 end
                 return true;
             end
             u243.JumpPower = v1269;
             u243.Jump = true;
             return true;
         end
     end
     f_setmovementmode(nil, "stand");
 end;
 u2.jump = f_jump;
 u2.parkourdetection = f_parkourdetection;
 local u282 = false;
 local u283 = nil;
 local u284 = nil;
 local u285 = nil;
 local u286 = nil;
 local u287 = nil;
 local u288 = nil;
 u2.grenadehold = false;
 local f_bfgsounds;
 f_bfgsounds = function()
     --[[
         Name: bfgsounds
         Line: 4167
         Upvalues: 
             [1] = u21
 
     --]]
     u21.play("1PsniperBass", 0.75);
     u21.play("1PsniperEcho", 1);
 end;
 local f_gunbob;
 f_gunbob = function(p237, p238)
     --[[
         Name: gunbob
         Line: 4172
         Upvalues: 
             [1] = u2
             [2] = u227
             [3] = u229
             [4] = u14
 
     --]]
     local v1272 = p237 or 1;
     local v1273 = p238 or 1;
     local v1274 = u2.slidespring.p;
     local v1275 = ((u2.distance * u227) * 3) / 4;
     local v1276 = u2.speed;
     local v1277 = -u2.velocity;
     local v1278 = v1276 * (1 - (v1274 * 0.9));
     return u229(((v1273 * math.cos((v1275 / 8) - 1)) * v1278) / 196, (((1.25 * v1272) * math.sin(v1275 / 4)) * v1278) / 512, 0) * u14.fromaxisangle((Vector3.new(((v1273 * math.sin((v1275 / 4) - 1)) / 256) + ((v1273 * (math.sin(v1275 / 64) - ((v1273 * v1277.z) / 4))) / 512), ((v1273 * math.cos(v1275 / 128)) / 128) - ((v1273 * math.cos(v1275 / 8)) / 256), ((v1273 * math.sin(v1275 / 8)) / 128) + ((v1273 * v1277.x) / 1024)) * math.sqrt(v1278 / 20)) * u227);
 end;
 local f_gunsway;
 f_gunsway = function(p239)
     --[[
         Name: gunsway
         Line: 4203
         Upvalues: 
             [1] = u229
 
     --]]
     local v1279 = os.clock() * 6;
     local v1280 = 2 * (1.1 - p239);
     return u229((math.cos(v1279 / 8) * v1280) / 128, ((-math.sin(v1279 / 4)) * v1280) / 128, (math.sin(v1279 / 16) * v1280) / 64);
 end;
 local f_weldattachment;
 f_weldattachment = function(p240, p241, p242, p243, p244, p245, p246, p247, p248, p249)
     --[[
         Name: weldattachment
         Line: 4208
         Upvalues: 
             [1] = t_AttachmentModels_156
             [2] = t_toObjectSpace_152
             [3] = u228
 
     --]]
     local v1281 = false;
     local v1282;
     if (p246.altmodel) then
         v1282 = t_AttachmentModels_156:FindFirstChild(p246.altmodel);
         if (not v1282) then
             v1281 = true;
         end
     else
         v1281 = true;
     end
     if (v1281) then
         v1282 = t_AttachmentModels_156:FindFirstChild(p243);
     end
     local v1283 = p246.copy or 0;
     local v1284 = nil;
     if (v1282) then
         local v1285 = 0;
         local v1286 = v1283;
         local v1287 = v1286;
         local v1288 = v1285;
         if (not (v1286 <= v1288)) then
             while true do
                 local v1289 = v1282:Clone();
                 local v1290 = v1289;
                 local v1291 = v1289.Node;
                 local t_Node_172 = v1291;
                 local v1292 = {};
                 local t_CFrame_173 = v1291.CFrame;
                 local v1293 = v1289:GetChildren();
                 local v1294 = v1293;
                 local v1295 = 1;
                 local v1296 = #v1293;
                 local v1297 = v1296;
                 local v1298 = v1295;
                 if (not (v1296 <= v1298)) then
                     while true do
                         local v1299 = v1294[v1295];
                         local v1300 = v1299;
                         if (v1299:IsA("BasePart")) then
                             if (p241.weldexception and p241.weldexception[v1300.Name]) then
                                 v1292[v1300] = t_toObjectSpace_152(p240[p241.weldexception[v1300.Name]].CFrame, v1300.CFrame);
                             else
                                 v1292[v1300] = t_toObjectSpace_152(t_CFrame_173, v1300.CFrame);
                             end
                         end
                         local v1301 = v1295 + 1;
                         v1295 = v1301;
                         local v1302 = v1297;
                         if (v1302 < v1301) then
                             break;
                         end
                     end
                 end
                 local v1303 = false;
                 local v1304;
                 if (v1285 == 0) then
                     v1304 = p244.CFrame;
                     if (not v1304) then
                         v1303 = true;
                     end
                 else
                     v1303 = true;
                 end
                 if (v1303) then
                     v1304 = p249[p246.copynodes[v1285]].CFrame;
                 end
                 t_Node_172.CFrame = v1304;
                 if (p242 == "Optics") then
                     local v1305 = p240:GetChildren();
                     local v1306 = v1305;
                     local v1307 = 1;
                     local v1308 = #v1305;
                     local v1309 = v1308;
                     local v1310 = v1307;
                     if (not (v1308 <= v1310)) then
                         while true do
                             local v1311 = false;
                             local v1312 = v1306[v1307];
                             local v1313 = v1312;
                             local t_Name_174 = v1312.Name;
                             if (t_Name_174 == "Iron") then
                                 v1311 = true;
                             else
                                 local t_Name_175 = v1313.Name;
                                 if (t_Name_175 == "IronGlow") then
                                     v1311 = true;
                                 else
                                     local t_Name_176 = v1313.Name;
                                     if ((t_Name_176 == "SightMark") and (not v1313:FindFirstChild("Stay"))) then
                                         v1311 = true;
                                     end
                                 end
                             end
                             if (v1311) then
                                 v1313:Destroy();
                             end
                             local v1314 = v1307 + 1;
                             v1307 = v1314;
                             local v1315 = v1309;
                             if (v1315 < v1314) then
                                 break;
                             end
                         end
                     end
                 else
                     if (p242 == "Underbarrel") then
                         local v1316 = p240:GetChildren();
                         local v1317 = v1316;
                         local v1318 = 1;
                         local v1319 = #v1316;
                         local v1320 = v1319;
                         local v1321 = v1318;
                         if (not (v1319 <= v1321)) then
                             while true do
                                 local v1322 = v1317[v1318];
                                 local v1323 = v1322;
                                 local t_Name_184 = v1322.Name;
                                 if (t_Name_184 == "Grip") then
                                     local v1324 = v1323:FindFirstChild("Slot1");
                                     if (not v1324) then
                                         v1324 = v1323:FindFirstChild("Slot2");
                                     end
                                     v1284 = v1324;
                                     v1323:Destroy();
                                 end
                                 local v1325 = v1318 + 1;
                                 v1318 = v1325;
                                 local v1326 = v1320;
                                 if (v1326 < v1325) then
                                     break;
                                 end
                             end
                         end
                     else
                         if (p242 == "Barrel") then
                             local v1327 = p240:GetChildren();
                             local v1328 = v1327;
                             local v1329 = 1;
                             local v1330 = #v1327;
                             local v1331 = v1330;
                             local v1332 = v1329;
                             if (not (v1330 <= v1332)) then
                                 while true do
                                     local v1333 = v1328[v1329];
                                     local v1334 = v1333;
                                     local t_Name_185 = v1333.Name;
                                     if (t_Name_185 == "Barrel") then
                                         local v1335 = v1334:FindFirstChild("Slot1");
                                         if (not v1335) then
                                             v1335 = v1334:FindFirstChild("Slot2");
                                         end
                                         v1284 = v1335;
                                         v1334:Destroy();
                                     end
                                     local v1336 = v1329 + 1;
                                     v1329 = v1336;
                                     local v1337 = v1331;
                                     if (v1337 < v1336) then
                                         break;
                                     end
                                 end
                             end
                         end
                     end
                 end
                 if (p246.replacemag) then
                     local v1338 = p240:GetChildren();
                     local v1339 = v1338;
                     local v1340 = 1;
                     local v1341 = #v1338;
                     local v1342 = v1341;
                     local v1343 = v1340;
                     if (not (v1341 <= v1343)) then
                         while true do
                             local v1344 = false;
                             local v1345 = false;
                             local v1346 = v1339[v1340];
                             if (v1285 == 0) then
                                 local t_Name_177 = v1346.Name;
                                 if (t_Name_177 == "Mag") then
                                     v1345 = true;
                                 else
                                     v1344 = true;
                                 end
                             else
                                 v1344 = true;
                             end
                             if (v1344) then
                                 if (v1285 >= 0) then
                                     local v1347 = v1346.Name;
                                     local v1348 = "Mag" .. (v1285 + 1);
                                     if (v1347 == v1348) then
                                         v1345 = true;
                                     end
                                 end
                             end
                             if (v1345) then
                                 v1346:Destroy();
                             end
                             local v1349 = v1340 + 1;
                             v1340 = v1349;
                             local v1350 = v1342;
                             if (v1350 < v1349) then
                                 break;
                             end
                         end
                     end
                 end
                 if (p246.replacepart) then
                     local v1351 = p240:GetChildren();
                     local v1352 = v1351;
                     local v1353 = 1;
                     local v1354 = #v1351;
                     local v1355 = v1354;
                     local v1356 = v1353;
                     if (not (v1354 <= v1356)) then
                         while true do
                             local v1357 = v1352[v1353];
                             local v1358 = v1357;
                             local v1359 = v1357.Name;
                             local t_replacepart_178 = p246.replacepart;
                             if (v1359 == t_replacepart_178) then
                                 v1358:Destroy();
                             end
                             local v1360 = v1353 + 1;
                             v1353 = v1360;
                             local v1361 = v1355;
                             if (v1361 < v1360) then
                                 break;
                             end
                         end
                     end
                 end
                 if ((p247 and p247[p243]) and p247[p243].settings) then
                     local g_next_179 = next;
                     local t_settings_180 = p247[p243].settings;
                     local v1362 = nil;
                     while true do
                         local v1363, v1364 = g_next_179(t_settings_180, v1362);
                         local v1365 = v1363;
                         local v1366 = v1364;
                         if (v1363) then
                             v1362 = v1365;
                             if (v1365 == "sightcolor") then
                                 local v1367 = v1290:FindFirstChild("SightMark");
                                 local v1368 = v1367;
                                 if (v1367 and v1367:FindFirstChild("SurfaceGui")) then
                                     local v1369 = v1368.SurfaceGui;
                                     local t_SurfaceGui_181 = v1369;
                                     if (v1369:FindFirstChild("Border") and v1369.Border:FindFirstChild("Scope")) then
                                         t_SurfaceGui_181.Border.Scope.ImageColor3 = Color3.new(v1366.r / 255, v1366.g / 255, v1366.b / 255);
                                     end
                                 end
                             end
                         else
                             break;
                         end
                     end
                 end
                 local v1370 = false;
                 local v1371 = 1;
                 local v1372 = #v1294;
                 local v1373 = v1372;
                 local v1374 = v1371;
                 if (v1372 <= v1374) then
                     v1370 = true;
                 else
                     while true do
                         local v1375 = false;
                         local v1376 = v1294[v1371];
                         local v1377 = v1376;
                         if (v1376:IsA("BasePart")) then
                             if (p246.replacemag) then
                                 local t_Name_182 = v1377.Name;
                                 if (t_Name_182 == "AttMag") then
                                     local v1378;
                                     if (v1285 == 0) then
                                         v1378 = "Mag";
                                     else
                                         v1378 = false;
                                         if (v1285 >= 0) then
                                             v1378 = "Mag" .. (v1285 + 1);
                                         end
                                     end
                                     v1377.Name = v1378;
                                 end
                             end
                             if (p246.replacepart) then
                                 local t_Name_183 = v1377.Name;
                                 if (t_Name_183 == "Part") then
                                     v1377.Name = p246.replacepart;
                                 end
                             end
                             if (v1284 and (v1377:IsA("UnionOperation") or v1377:IsA("MeshPart"))) then
                                 (v1284:Clone()).Parent = v1377;
                             end
                             local v1379;
                             if (p241.weldexception and p241.weldexception[v1377.Name]) then
                                 v1379 = p240[p241.weldexception[v1377.Name]];
                             else
                                 v1379 = p245;
                             end
                             if (v1377 ~= t_Node_172) then
                                 local v1380 = t_toObjectSpace_152(v1379.CFrame, t_Node_172.CFrame);
                                 local v1381 = u228("Weld");
                                 v1381.Part0 = v1379;
                                 v1381.Part1 = v1377;
                                 v1381.C0 = v1380 * v1292[v1377];
                                 v1381.Parent = v1379;
                                 v1377.CFrame = v1379.CFrame * v1381.C0;
                                 local v1382 = v1377.Name;
                                 local v1383 = {};
                                 v1383.part = v1377;
                                 v1383.weld = v1381;
                                 v1383.basec0 = v1380 * v1292[v1377];
                                 v1383.basetransparency = v1377.Transparency;
                                 p248[v1382] = v1383;
                             end
                             v1377.Parent = p240;
                             v1375 = true;
                         else
                             v1375 = true;
                         end
                         if (v1375) then
                             local v1384 = v1371 + 1;
                             v1371 = v1384;
                             local v1385 = v1373;
                             if (v1385 < v1384) then
                                 break;
                             end
                         end
                     end
                     v1370 = true;
                 end
                 if (v1370) then
                     t_Node_172:Destroy();
                     v1290:Destroy();
                     local v1386 = v1285 + 1;
                     v1285 = v1386;
                     local v1387 = v1287;
                     if (v1387 < v1386) then
                         break;
                     end
                 end
             end
         end
     end
     return v1284;
 end;
 local f_texturemodel;
 f_texturemodel = function(p250, p251)
     --[[
         Name: texturemodel
         Line: 4359
         Upvalues: 
             [1] = u19
             [2] = f_texturemodel
 
     --]]
     if (p250) then
         local v1388 = BrickColor.new;
         local g_next_186 = next;
         local v1389, v1390 = p251:GetChildren();
         local v1391 = v1389;
         local v1392 = v1390;
         while true do
             local v1393, v1394 = g_next_186(v1391, v1392);
             local v1395 = v1393;
             local v1396 = v1394;
             if (v1393) then
                 v1392 = v1395;
                 if ((v1396:FindFirstChild("Mesh") or v1396:IsA("UnionOperation")) or v1396:IsA("MeshPart")) then
                     local v1397 = v1396:FindFirstChild("Slot1");
                     if (not v1397) then
                         v1397 = v1396:FindFirstChild("Slot2");
                     end
                     if (v1397 and v1397.Name) then
                         local g_next_187 = next;
                         local v1398, v1399 = v1396:GetChildren();
                         local v1400 = v1398;
                         local v1401 = v1399;
                         while true do
                             local v1402, v1403 = g_next_187(v1400, v1401);
                             local v1404 = v1402;
                             local v1405 = v1403;
                             if (v1402) then
                                 v1401 = v1404;
                                 if (v1405:IsA("Texture")) then
                                     v1405:Destroy();
                                 end
                             else
                                 break;
                             end
                         end
                         local v1406 = p250[v1397.Name];
                         local v1407 = v1406;
                         if (v1406) then
                             local t_Name_188 = v1407.Name;
                             if (t_Name_188 ~= "") then
                                 if (not u19.disable1pcamoskins) then
                                     local v1408 = Instance.new("Texture");
                                     local v1409 = v1408;
                                     v1408.Name = v1397.Name;
                                     v1408.Texture = "rbxassetid://" .. v1407.TextureProperties.TextureId;
                                     local t_Transparency_189 = v1396.Transparency;
                                     local v1410;
                                     if (t_Transparency_189 == 1) then
                                         v1410 = 1;
                                     else
                                         v1410 = v1407.TextureProperties.Transparency;
                                         if (not v1410) then
                                             v1410 = 0;
                                         end
                                     end
                                     v1409.Transparency = v1410;
                                     v1409.StudsPerTileU = v1407.TextureProperties.StudsPerTileU or 1;
                                     v1409.StudsPerTileV = v1407.TextureProperties.StudsPerTileV or 1;
                                     v1409.OffsetStudsU = v1407.TextureProperties.OffsetStudsU or 0;
                                     v1409.OffsetStudsV = v1407.TextureProperties.OffsetStudsV or 0;
                                     if (v1407.TextureProperties.Color) then
                                         local v1411 = v1407.TextureProperties.Color;
                                         v1409.Color3 = Color3.new(v1411.r / 255, v1411.g / 255, v1411.b / 255);
                                     end
                                     local v1412 = 0;
                                     local v1413;
                                     if (v1396:IsA("MeshPart") or v1396:IsA("UnionOperation")) then
                                         v1413 = 5;
                                     else
                                         v1413 = 0;
                                     end
                                     local v1414 = v1412;
                                     local v1415 = v1413;
                                     if (not (v1415 <= v1414)) then
                                         while true do
                                             local v1416 = v1409:Clone();
                                             v1416.Face = v1412;
                                             v1416.Parent = v1396;
                                             local v1417 = v1412 + 1;
                                             v1412 = v1417;
                                             local v1418 = v1413;
                                             if (v1418 < v1417) then
                                                 break;
                                             end
                                         end
                                     end
                                     v1409:Destroy();
                                 end
                                 if (not v1407.BrickProperties.DefaultColor) then
                                     if (v1396:IsA("UnionOperation")) then
                                         v1396.UsePartColor = true;
                                     end
                                     local v1419 = v1407.BrickProperties.Color;
                                     local t_Color_190 = v1419;
                                     if (v1419) then
                                         v1396.Color = Color3.new(t_Color_190.r / 255, t_Color_190.g / 255, t_Color_190.b / 255);
                                     else
                                         if (v1407.BrickProperties.BrickColor) then
                                             v1396.BrickColor = v1388(v1407.BrickProperties.BrickColor);
                                         end
                                     end
                                 end
                                 if (v1407.BrickProperties.Material) then
                                     v1396.Material = v1407.BrickProperties.Material;
                                 end
                                 if (v1407.BrickProperties.Reflectance) then
                                     v1396.Reflectance = v1407.BrickProperties.Reflectance;
                                 end
                             end
                         end
                     end
                 else
                     if (v1396:IsA("Model")) then
                         f_texturemodel(p250, v1396);
                     end
                 end
             else
                 break;
             end
         end
     end
 end;
 local f_weldmodel;
 f_weldmodel = function(p252, p253, p254, p255, p256, p257, p258)
     --[[
         Name: weldmodel
         Line: 4421
         Upvalues: 
             [1] = t_toObjectSpace_152
             [2] = u228
             [3] = t_AttachmentModels_156
             [4] = f_weldattachment
             [5] = f_texturemodel
 
     --]]
     local v1420 = {};
     local v1421 = p252:GetChildren();
     local t_CFrame_191 = p253.CFrame;
     local v1422 = p252:FindFirstChild("MenuNodes");
     if (not p258) then
         local v1423 = 1;
         local v1424 = #v1421;
         local v1425 = v1424;
         local v1426 = v1423;
         if (not (v1424 <= v1426)) then
             while true do
                 local v1427 = v1421[v1423];
                 local v1428 = v1427;
                 if ((not (v1427 == p253)) and v1427:IsA("BasePart")) then
                     local v1429 = v1428.Name;
                     local t_Name_192 = v1429;
                     if ((p255 and p255.removeparts) and p255.removeparts[v1429]) then
                         v1428:Destroy();
                     else
                         if ((p255 and p255.transparencymod) and p255.transparencymod[t_Name_192]) then
                             v1428.Transparency = p255.transparencymod[t_Name_192];
                         end
                         if ((p255 and p255.weldexception) and (p255.weldexception[t_Name_192] and p252:FindFirstChild(p255.weldexception[t_Name_192]))) then
                             local v1430 = p252[p255.weldexception[t_Name_192]];
                             local v1431 = t_toObjectSpace_152(v1430.CFrame, v1428.CFrame);
                             local v1432 = u228("Weld");
                             v1432.Part0 = v1430;
                             v1432.Part1 = v1428;
                             v1432.C0 = v1431;
                             v1432.Parent = p253;
                             v1428.CFrame = t_CFrame_191 * v1431;
                             local v1433 = {};
                             v1433.part = v1428;
                             v1433.weld = v1432;
                             v1433.basec0 = v1431;
                             v1433.basetransparency = v1428.Transparency;
                             v1420[t_Name_192] = v1433;
                         else
                             local v1434 = t_toObjectSpace_152(t_CFrame_191, v1428.CFrame);
                             local v1435 = u228("Weld");
                             v1435.Part0 = p253;
                             v1435.Part1 = v1428;
                             v1435.C0 = v1434;
                             v1435.Parent = p253;
                             v1428.CFrame = t_CFrame_191 * v1434;
                             local v1436 = {};
                             v1436.part = v1428;
                             v1436.weld = v1435;
                             v1436.basec0 = v1434;
                             v1436.basetransparency = v1428.Transparency;
                             v1420[t_Name_192] = v1436;
                         end
                     end
                 end
                 local v1437 = v1423 + 1;
                 v1423 = v1437;
                 local v1438 = v1425;
                 if (v1438 < v1437) then
                     break;
                 end
             end
         end
     end
     if (v1422 and p254) then
         local v1439 = v1422:GetChildren();
         local v1440 = v1439;
         local v1441 = 1;
         local v1442 = #v1439;
         local v1443 = v1442;
         local v1444 = v1441;
         if (not (v1442 <= v1444)) then
             while true do
                 local v1445 = v1440[v1441];
                 local v1446 = t_toObjectSpace_152(t_CFrame_191, v1445.CFrame);
                 local v1447 = u228("Weld");
                 v1447.Part0 = p253;
                 v1447.Part1 = v1445;
                 v1447.C0 = v1446;
                 v1447.Parent = p253;
                 local v1448 = v1441 + 1;
                 v1441 = v1448;
                 local v1449 = v1443;
                 if (v1449 < v1448) then
                     break;
                 end
             end
         end
         local g_next_193 = next;
         local v1450 = p254;
         local v1451 = nil;
         while true do
             local v1452, v1453 = g_next_193(v1450, v1451);
             local v1454 = v1452;
             local v1455 = v1453;
             if (v1452) then
                 v1451 = v1454;
                 if (((not (v1454 == "Name")) and v1455) and (not (v1455 == ""))) then
                     local v1456 = false;
                     local v1457;
                     if (p255.attachments) then
                         v1457 = p255.attachments[v1454][v1455];
                         if (not v1457) then
                             v1456 = true;
                         end
                     else
                         v1456 = true;
                     end
                     if (v1456) then
                         v1457 = {};
                     end
                     local v1458 = v1457.sidemount;
                     if (v1458) then
                         v1458 = t_AttachmentModels_156[v1457.sidemount]:Clone();
                     end
                     local v1459 = false;
                     local v1460;
                     if (v1457.mountweldpart) then
                         v1460 = p252[v1457.mountweldpart];
                         if (not v1460) then
                             v1459 = true;
                         end
                     else
                         v1459 = true;
                     end
                     if (v1459) then
                         v1460 = p253;
                     end
                     local v1461 = v1457.node;
                     if (v1461) then
                         v1461 = v1422[v1457.node];
                     end
                     local v1462 = false;
                     local v1463 = {};
                     if (v1458) then
                         local v1464 = false;
                         local t_Node_194 = v1458.Node;
                         local v1465;
                         if (v1457.mountnode) then
                             v1465 = v1422[v1457.mountnode];
                             if (not v1465) then
                                 v1464 = true;
                             end
                         else
                             v1464 = true;
                         end
                         if (v1464) then
                             local v1466 = false;
                             if (v1454 == "Optics") then
                                 v1465 = v1422.MountNode;
                                 if (not v1465) then
                                     v1466 = true;
                                 end
                             else
                                 v1466 = true;
                             end
                             if (v1466) then
                                 v1465 = false;
                                 if (v1454 == "Underbarrel") then
                                     v1465 = v1422.UnderMountNode;
                                 end
                             end
                         end
                         local v1467 = {};
                         local v1468 = v1458:GetChildren();
                         local v1469 = v1468;
                         local t_CFrame_195 = t_Node_194.CFrame;
                         local v1470 = 1;
                         local v1471 = #v1468;
                         local v1472 = v1471;
                         local v1473 = v1470;
                         if (not (v1471 <= v1473)) then
                             while true do
                                 if (v1469[v1470]:IsA("BasePart")) then
                                     v1467[v1470] = t_toObjectSpace_152(t_CFrame_195, v1469[v1470].CFrame);
                                 end
                                 local v1474 = v1470 + 1;
                                 v1470 = v1474;
                                 local v1475 = v1472;
                                 if (v1475 < v1474) then
                                     break;
                                 end
                             end
                         end
                         t_Node_194.CFrame = v1465.CFrame;
                         local v1476 = 1;
                         local v1477 = #v1469;
                         local v1478 = v1477;
                         local v1479 = v1476;
                         if (not (v1477 <= v1479)) then
                             while true do
                                 local v1480 = v1469[v1476];
                                 local v1481 = v1480;
                                 local t_Name_196 = v1480.Name;
                                 if (v1480:IsA("BasePart")) then
                                     local v1482 = t_toObjectSpace_152(v1460.CFrame, t_Node_194.CFrame);
                                     local v1483 = t_toObjectSpace_152(p253.CFrame, v1460.CFrame);
                                     if (v1481 ~= t_Node_194) then
                                         local v1484 = u228("Weld");
                                         local v1485;
                                         if (v1457.weldtobase) then
                                             v1484.Part0 = p253;
                                             v1484.Part1 = v1481;
                                             v1484.C0 = (v1483 * v1482) * v1467[v1476];
                                             v1481.CFrame = t_Node_194.CFrame * v1467[v1476];
                                             v1485 = t_toObjectSpace_152(t_CFrame_191, v1481.CFrame);
                                         else
                                             v1484.Part0 = v1460;
                                             v1484.Part1 = v1481;
                                             v1484.C0 = v1482 * v1467[v1476];
                                             v1481.CFrame = t_Node_194.CFrame * v1467[v1476];
                                             v1485 = t_toObjectSpace_152(v1460.CFrame, v1481.CFrame);
                                         end
                                         v1484.Parent = p253;
                                         local v1486 = {};
                                         v1486.part = v1481;
                                         v1486.weld = v1484;
                                         v1486.basec0 = v1485;
                                         v1486.basetransparency = v1481.Transparency;
                                         v1420[t_Name_196] = v1486;
                                     end
                                     v1481.Parent = p252;
                                     v1463[v1481.Name] = v1481;
                                     local v1487 = v1481.Name;
                                     local v1488 = v1454 .. "Node";
                                     if ((v1487 == v1488) and (not v1461)) then
                                         v1461 = v1481;
                                     else
                                         local t_Name_197 = v1481.Name;
                                         if (t_Name_197 == "SightMark") then
                                             local v1489 = u228("Model");
                                             v1489.Name = "Stay";
                                             v1489.Parent = v1481;
                                         end
                                     end
                                 end
                                 local v1490 = v1476 + 1;
                                 v1476 = v1490;
                                 local v1491 = v1478;
                                 if (v1491 < v1490) then
                                     break;
                                 end
                             end
                         end
                         t_Node_194.Parent = v1422;
                         v1458:Destroy();
                         v1462 = true;
                     else
                         local v1492 = false;
                         local v1493;
                         if (v1457.node) then
                             v1493 = v1422[v1457.node];
                             if (not v1493) then
                                 v1492 = true;
                             end
                         else
                             v1492 = true;
                         end
                         if (v1492) then
                             v1493 = v1422[v1454 .. "Node"];
                         end
                         v1461 = v1493;
                         v1462 = true;
                     end
                     if (v1462) then
                         local v1494 = false;
                         if (v1457.auxmodels) then
                             local v1495 = {};
                             local g_next_198 = next;
                             local t_auxmodels_199 = v1457.auxmodels;
                             local v1496 = nil;
                             while true do
                                 local v1497, v1498 = g_next_198(t_auxmodels_199, v1496);
                                 local v1499 = v1497;
                                 local v1500 = v1498;
                                 if (v1497) then
                                     v1496 = v1499;
                                     local v1501 = v1500.Name;
                                     if (not v1501) then
                                         v1501 = v1455 .. (" " .. v1500.PostName);
                                     end
                                     local v1502 = t_AttachmentModels_156[v1501]:Clone();
                                     local v1503 = v1502;
                                     local t_Node_200 = v1502.Node;
                                     v1495[v1501] = {};
                                     local v1504;
                                     if (v1500.sidemount and v1463[v1500.Node]) then
                                         v1504 = v1463[v1500.Node];
                                     else
                                         if ((v1500.auxmount and v1495[v1500.auxmount]) and v1495[v1500.auxmount][v1500.Node]) then
                                             v1504 = v1495[v1500.auxmount][v1500.Node];
                                         else
                                             v1504 = v1422[v1500.Node];
                                         end
                                     end
                                     if (v1500.mainnode) then
                                         v1461 = v1503[v1500.mainnode];
                                     end
                                     local v1505 = {};
                                     local v1506 = v1503:GetChildren();
                                     local v1507 = v1506;
                                     local t_CFrame_201 = t_Node_200.CFrame;
                                     local v1508 = 1;
                                     local v1509 = #v1506;
                                     local v1510 = v1509;
                                     local v1511 = v1508;
                                     if (not (v1509 <= v1511)) then
                                         while true do
                                             if (v1507[v1508]:IsA("BasePart")) then
                                                 v1505[v1508] = t_toObjectSpace_152(t_CFrame_201, v1507[v1508].CFrame);
                                             end
                                             local v1512 = v1508 + 1;
                                             v1508 = v1512;
                                             local v1513 = v1510;
                                             if (v1513 < v1512) then
                                                 break;
                                             end
                                         end
                                     end
                                     t_Node_200.CFrame = v1504.CFrame;
                                     local v1514 = 1;
                                     local v1515 = #v1507;
                                     local v1516 = v1515;
                                     local v1517 = v1514;
                                     if (not (v1515 <= v1517)) then
                                         while true do
                                             local v1518 = v1507[v1514];
                                             local v1519 = v1518;
                                             local t_Name_202 = v1518.Name;
                                             if (v1518:IsA("BasePart")) then
                                                 local v1520 = t_toObjectSpace_152(v1460.CFrame, t_Node_200.CFrame);
                                                 local v1521 = t_toObjectSpace_152(p253.CFrame, v1460.CFrame);
                                                 if (v1519 ~= t_Node_200) then
                                                     local v1522 = u228("Weld");
                                                     local v1523;
                                                     if (v1500.weldtobase) then
                                                         v1522.Part0 = p253;
                                                         v1522.Part1 = v1519;
                                                         v1522.C0 = (v1521 * v1520) * v1505[v1514];
                                                         v1519.CFrame = t_Node_200.CFrame * v1505[v1514];
                                                         v1523 = t_toObjectSpace_152(t_CFrame_191, v1519.CFrame);
                                                     else
                                                         v1522.Part0 = v1460;
                                                         v1522.Part1 = v1519;
                                                         v1522.C0 = v1520 * v1505[v1514];
                                                         v1519.CFrame = t_Node_200.CFrame * v1505[v1514];
                                                         v1523 = t_toObjectSpace_152(v1460.CFrame, v1519.CFrame);
                                                     end
                                                     v1522.Parent = p253;
                                                     local v1524 = {};
                                                     v1524.part = v1519;
                                                     v1524.weld = v1522;
                                                     v1524.basec0 = v1523;
                                                     v1524.basetransparency = v1519.Transparency;
                                                     v1420[t_Name_202] = v1524;
                                                 end
                                                 v1519.Parent = p252;
                                                 v1495[v1501][v1519.Name] = v1519;
                                                 local v1525 = v1519.Name;
                                                 local v1526 = v1499 .. "Node";
                                                 if ((v1525 == v1526) and (not v1461)) then
                                                     v1461 = v1519;
                                                 else
                                                     local t_Name_203 = v1519.Name;
                                                     if (t_Name_203 == "SightMark") then
                                                         local v1527 = u228("Model");
                                                         v1527.Name = "Stay";
                                                         v1527.Parent = v1519;
                                                     end
                                                 end
                                             end
                                             local v1528 = v1514 + 1;
                                             v1514 = v1528;
                                             local v1529 = v1516;
                                             if (v1529 < v1528) then
                                                 break;
                                             end
                                         end
                                     end
                                     v1503:Destroy();
                                 else
                                     break;
                                 end
                             end
                             v1494 = true;
                         else
                             v1494 = true;
                         end
                         if (v1494) then
                             local v1530 = false;
                             local v1531;
                             if (v1457.weldpart) then
                                 v1531 = p252[v1457.weldpart];
                                 if (not v1531) then
                                     v1530 = true;
                                 end
                             else
                                 v1530 = true;
                             end
                             if (v1530) then
                                 v1531 = p253;
                             end
                             f_weldattachment(p252, p255, v1454, v1455, v1461, v1531, v1457, p257, v1420, v1422);
                         end
                     end
                 end
             else
                 break;
             end
         end
         v1422:Destroy();
     end
     if (not p258) then
         f_texturemodel(p256, p252);
         v1420.camodata = p256;
         p253.Anchored = false;
         p253.CanCollide = false;
     end
     if (p255) then
         local v1532 = {};
         v1420.gunvars = v1532;
         local v1533 = p255.casetype;
         if (not v1533) then
             v1533 = p255.ammotype;
         end
         v1532.ammotype = v1533;
         v1532.boltlock = p255.boltlock;
     end
     local g_next_204 = next;
     local v1534, v1535 = p252:GetDescendants();
     local v1536 = v1534;
     local v1537 = v1535;
     while true do
         local v1538, v1539 = g_next_204(v1536, v1537);
         local v1540 = v1538;
         local v1541 = v1539;
         if (v1538) then
             v1537 = v1540;
             if (v1541:IsA("BasePart")) then
                 v1541.Massless = true;
                 v1541.Anchored = false;
                 v1541.CanCollide = false;
                 v1541.CanTouch = false;
                 v1541.CanQuery = false;
             end
         else
             break;
         end
     end
     return v1420;
 end;
 local v1542 = game.Workspace.CurrentCamera;
 local u289 = u228;
 local f_weldmodel = f_weldmodel;
 local t_CurrentCamera_205 = v1542;
 local f_loadarms;
 f_loadarms = function(p259, p260, p261, p262, p263)
     --[[
         Name: loadarms
         Line: 4677
         Upvalues: 
             [1] = u285
             [2] = u286
             [3] = u287
             [4] = u288
             [5] = u283
             [6] = u289
             [7] = u284
             [8] = f_weldmodel
             [9] = u231
             [10] = t_CurrentCamera_205
 
     --]]
     if (u285 and u286) then
         u285:Destroy();
         u286:Destroy();
     end
     local v1543 = p260;
     local v1544 = p261;
     u285 = v1543;
     u286 = v1544;
     u287 = u285[p262];
     u288 = u286[p263];
     u283 = u289("Motor6D");
     u284 = u289("Motor6D");
     f_weldmodel(u285, u287);
     f_weldmodel(u286, u288);
     u284.Part0 = u231;
     u284.Part1 = u287;
     u284.Parent = u287;
     u283.Part0 = u231;
     u283.Part1 = u288;
     u283.Parent = u288;
     u285.Parent = t_CurrentCamera_205;
     u286.Parent = t_CurrentCamera_205;
 end;
 u2.loadarms = f_loadarms;
 local u290 = v1161;
 local u291 = v1162;
 local u292 = v1166;
 local u293 = v1127;
 local u294 = v1134;
 local u295 = v1155;
 local u296 = v1116;
 local u297 = v1157;
 local u298 = v1159;
 local u299 = v1164;
 local u300 = u246;
 local u301 = t_ReplicatedStorage_155;
 local f_reloadsprings;
 f_reloadsprings = function(p264)
     --[[
         Name: reloadsprings
         Line: 4702
         Upvalues: 
             [1] = u290
             [2] = u291
             [3] = u292
             [4] = u293
             [5] = u294
             [6] = u295
             [7] = u296
             [8] = u297
             [9] = u298
             [10] = u299
             [11] = u300
             [12] = u249
             [13] = u241
             [14] = u250
             [15] = u248
             [16] = u301
             [17] = u231
 
     --]]
     u290.p = 0;
     u290.t = 0;
     u291.p = 0;
     u291.t = 0;
     u292.p = 1;
     u292.t = 1;
     u292.s = 12;
     u292.d = 0.75;
     u293.p = 0;
     u293.t = 0;
     u293.s = 12;
     u293.d = 0.9;
     u294.p = 0;
     u294.t = 0;
     u294.d = 0.9;
     u295.p = u296;
     u295.t = u296;
     u295.s = 10;
     u295.d = 0.75;
     u297.p = 0;
     u297.t = 0;
     u297.s = 16;
     u298.p = u296;
     u298.t = u296;
     u298.s = 16;
     u299.p = 0;
     u299.t = 0;
     u299.s = 8;
     u300.p = 0;
     u300.t = 0;
     u300.s = 50;
     u300.d = 1;
     u249.p = u241;
     u249.t = u241;
     u249.s = 8;
     u250.p = 1.5;
     u250.t = 1.5;
     u250.s = 8;
     if (u248) then
         u248:Destroy();
     end
     u248 = u301.Effects.MuzzleLight:Clone();
     u248.Parent = u231;
 end;
 u2.reloadsprings = f_reloadsprings;
 local f_pickv3;
 f_pickv3 = function(p265, p266)
     --[[
         Name: pickv3
         Line: 4763
     --]]
     return p265 + (Vector3.new(math.random(), math.random(), math.random()) * (p266 - p265));
 end;
 local f_firemuzzlelight;
 f_firemuzzlelight = function(p267)
     --[[
         Name: firemuzzlelight
         Line: 4767
         Upvalues: 
             [1] = u246
 
     --]]
     u246.a = 100;
 end;
 u2.firemuzzlelight = f_firemuzzlelight;
 local u302 = v22;
 local f_weldmodel = f_weldmodel;
 local u303 = u228;
 local u304 = v1113;
 local u305 = u14;
 local u306 = u2;
 local u307 = u4;
 local u308 = v1126;
 local u309 = v1166;
 local t_CurrentCamera_206 = v1542;
 local u310 = u9;
 local u311 = u10;
 local u312 = u16;
 local u313 = v1114;
 local u314 = u230;
 local u315 = v1116;
 local u316 = t_Dot_151;
 local u317 = u12;
 local u318 = v1127;
 local u319 = v23;
 local u320 = u17;
 local u321 = u19;
 local u322 = v1161;
 local u323 = u229;
 local u324 = v1155;
 local f_gunbob = f_gunbob;
 local f_gunsway = f_gunsway;
 local u325 = v1164;
 local f_loadgrenade;
 f_loadgrenade = function(p268, p269, p270)
     --[[
         Name: loadgrenade
         Line: 4772
         Upvalues: 
             [1] = u302
             [2] = f_gunrequire
             [3] = t_getGunModel_4
             [4] = f_weldmodel
             [5] = u303
             [6] = u304
             [7] = u231
             [8] = u305
             [9] = u282
             [10] = u306
             [11] = u307
             [12] = u308
             [13] = u309
             [14] = t_CurrentCamera_206
             [15] = u235
             [16] = u239
             [17] = u310
             [18] = u311
             [19] = u312
             [20] = u313
             [21] = u314
             [22] = u315
             [23] = u316
             [24] = u317
             [25] = u318
             [26] = u319
             [27] = u238
             [28] = u320
             [29] = u321
             [30] = u322
             [31] = u323
             [32] = u324
             [33] = f_gunbob
             [34] = f_gunsway
             [35] = u325
             [36] = u249
             [37] = u284
             [38] = u283
 
     --]]
     local v1545 = {};
     local v1546 = u302.new();
     local v1547 = f_gunrequire(p269);
     local v1548 = t_getGunModel_4(p269):Clone();
     local v1549 = v1547.mainpart;
     local v1550 = v1547.mainoffset;
     local v1551 = v1548[v1549];
     local v1552 = v1548[v1547.pin];
     local u326 = false;
     local u327 = false;
     local u328 = false;
     local u329 = false;
     local v1553 = Vector3.new(0, -80, 0);
     local u330 = Vector3.new();
     local u331 = Vector3.new();
     local u332 = 0;
     local u333 = 0;
     local u334 = 0;
     local u335 = false;
     local u336 = Vector3.new();
     local u337 = nil;
     local u338 = nil;
     local u339 = nil;
     local v1554 = v1547.fusetime;
     local v1555 = v1547.blastradius;
     local v1556 = v1547.throwspeed;
     local v1557 = v1547.range0;
     local v1558 = v1547.range1;
     local v1559 = v1547.damage0;
     local v1560 = v1547.damage1;
     local v1561 = f_weldmodel(v1548, v1551);
     local v1562 = u303("Motor6D");
     local v1563 = {};
     local v1564 = {};
     v1564.C0 = u304;
     v1563.weld = v1564;
     v1563.basec0 = u304;
     v1561[v1549] = v1563;
     local v1565 = {};
     local v1566 = {};
     v1566.C0 = v1547.larmoffset;
     v1565.weld = v1566;
     v1565.basec0 = v1547.larmoffset;
     v1561.larm = v1565;
     local v1567 = {};
     local v1568 = {};
     v1568.C0 = v1547.rarmoffset;
     v1567.weld = v1568;
     v1567.basec0 = v1547.rarmoffset;
     v1561.rarm = v1567;
     v1562.Part0 = u231;
     v1562.Part1 = v1551;
     v1562.Parent = v1551;
     local v1569 = v1547.equipoffset;
     local v1570 = u305.interpolator(v1547.sprintoffset);
     local v1571 = u305.interpolator(v1547.proneoffset);
     v1545.type = v1547.type;
     v1545.cooking = u328;
     local f_isaiming;
     f_isaiming = function()
         --[[
             Name: isaiming
             Line: 4828
         --]]
         return false;
     end;
     v1545.isaiming = f_isaiming;
     local u340 = v1547;
     local t_mainpart_207 = v1549;
     local u341 = p270;
     local u342 = v1551;
     local u343 = v1548;
     local f_setequipped;
     f_setequipped = function(p271, p272)
         --[[
             Name: setequipped
             Line: 4832
             Upvalues: 
                 [1] = u326
                 [2] = u282
                 [3] = u306
                 [4] = u307
                 [5] = u340
                 [6] = t_mainpart_207
                 [7] = u308
                 [8] = u341
                 [9] = u309
                 [10] = u342
                 [11] = u343
                 [12] = t_CurrentCamera_206
                 [13] = u235
                 [14] = u239
 
         --]]
         if (not (p272 and (not (u326 and u282)))) then
             if ((not p272) and u326) then
                 u309.t = 1;
                 u308:clear();
                 u308:add(function()
                     --[[
                         Name: (empty)
                         Line: 4864
                         Upvalues: 
                             [1] = u326
                             [2] = u343
                             [3] = u239
                             [4] = u235
 
                     --]]
                     u326 = false;
                     u343.Parent = nil;
                     u239 = false;
                     u235 = nil;
                 end);
                 u308:delay(0.5);
             end
             return;
         end
         if (not u306.alive) then
             return;
         end
         u306.grenadehold = true;
         u307:setcrosssettings(u340.type, u340.crosssize, u340.crossspeed, u340.crossdamper, t_mainpart_207);
         u307:updatefiremode("KNIFE");
         u307:updateammo("GRENADE");
         u282 = true;
         u308:clear();
         u341:setequipped(false);
         local v1572 = u308;
         local u344 = p271;
         v1572:add(function()
             --[[
                 Name: (empty)
                 Line: 4845
                 Upvalues: 
                     [1] = u306
                     [2] = u340
                     [3] = u309
                     [4] = u282
                     [5] = u326
                     [6] = u342
                     [7] = u343
                     [8] = t_CurrentCamera_206
                     [9] = u235
                     [10] = u344
 
             --]]
             u306:setbasewalkspeed(u340.walkspeed);
             u309.t = 0;
             u282 = false;
             u326 = true;
             local v1573 = u342:GetChildren();
             local v1574 = v1573;
             local v1575 = 1;
             local v1576 = #v1573;
             local v1577 = v1576;
             local v1578 = v1575;
             if (not (v1576 <= v1578)) then
                 while true do
                     if (v1574[v1575]:IsA("Weld")) then
                         local v1579 = false;
                         if (v1574[v1575].Part1) then
                             local v1580 = v1574[v1575].Part1.Parent;
                             local v1581 = u343;
                             if (v1580 ~= v1581) then
                                 v1579 = true;
                             end
                         else
                             v1579 = true;
                         end
                         if (v1579) then
                             v1574[v1575]:Destroy();
                         end
                     end
                     local v1582 = v1575 + 1;
                     v1575 = v1582;
                     local v1583 = v1577;
                     if (v1583 < v1582) then
                         break;
                     end
                 end
             end
             u343.Parent = t_CurrentCamera_206;
             u235 = u344;
         end);
     end;
     v1545.setequipped = f_setequipped;
     local u345 = nil;
     local u346 = 0;
     local u347 = v1551;
     local u348 = v1562;
     local u349 = v1548;
     local u350 = v1547;
     local t_throwspeed_208 = v1556;
     local u351 = v1553;
     local f_createnade;
     f_createnade = function(p273)
         --[[
             Name: createnade
             Line: 4877
             Upvalues: 
                 [1] = u310
                 [2] = u347
                 [3] = u311
                 [4] = u307
                 [5] = u348
                 [6] = u339
                 [7] = u349
                 [8] = u312
                 [9] = u313
                 [10] = u350
                 [11] = u330
                 [12] = u306
                 [13] = t_throwspeed_208
                 [14] = u231
                 [15] = u331
                 [16] = u314
                 [17] = u334
                 [18] = u338
                 [19] = u337
                 [20] = u345
                 [21] = u333
                 [22] = u315
                 [23] = u351
                 [24] = u336
                 [25] = u316
                 [26] = u305
                 [27] = u335
                 [28] = u346
                 [29] = u317
 
         --]]
         if ((not p273) and u310.lock) then
             return;
         end
         if (not (u347.Parent and (not (u311.gammo < 0)))) then
             return;
         end
         u311.gammo = u311.gammo - 1;
         u307:updateammo("GRENADE");
         local v1584 = tick();
         u348:Destroy();
         u339 = u347:FindFirstChild("Indicator");
         if (u339) then
             u339.Friendly.Visible = true;
         end
         local v1585 = false;
         u347.CastShadow = false;
         u347.Massless = true;
         u347.Anchored = true;
         u347.Trail.Enabled = true;
         u347.Ticking:Play();
         u347.Parent = workspace.Ignore.Misc;
         u349.Parent = nil;
         local v1586 = u312.cframe * u313(math.rad(u350.throwangle or 0), 0, 0);
         local v1587;
         if (u306.alive) then
             v1587 = (v1586.lookVector * t_throwspeed_208) + u231.Velocity;
             if (not v1587) then
                 v1585 = true;
             end
         else
             v1585 = true;
         end
         if (v1585) then
             v1587 = Vector3.new(math.random(-3, 5), math.random(0, 2), math.random(-3, 5));
         end
         local v1588 = false;
         u330 = v1587;
         local v1589;
         if (u306.deadcf) then
             v1589 = u306.deadcf.p;
             if (not v1589) then
                 v1588 = true;
             end
         else
             v1588 = true;
         end
         if (v1588) then
             v1589 = u347.CFrame.p;
         end
         u331 = v1589;
         local v1590 = u312.basecframe.p;
         local v1591, v1592, v1593 = workspace:FindPartOnRayWithWhitelist(u314(v1590, u331 - v1590), u310.raycastwhitelist);
         u331 = v1592 + (0.01 * v1593);
         u334 = v1584;
         u338 = (u312.cframe - u312.cframe.p) * Vector3.new(19.539, -5, 0);
         u337 = u347.CFrame - u347.CFrame.p;
         local v1594 = u347.CFrame;
         local v1595 = {};
         v1595.time = v1584;
         v1595.blowuptime = u333 - v1584;
         local v1596 = {};
         local v1597 = {};
         v1597.t0 = 0;
         v1597.p0 = u331;
         v1597.v0 = u330;
         v1597.offset = u315;
         v1597.rot0 = v1594 - v1594.p;
         v1597.rotv = u338;
         v1597.glassbreaks = {};
         v1596[1] = v1597;
         v1595.frames = v1596;
         u345 = v1595;
         local v1598 = 1;
         local v1599 = ((u333 - v1584) / 0.016666666666666666) + 1;
         local v1600 = v1599;
         local v1601 = v1598;
         if (not (v1599 <= v1601)) then
             local v1605, v1613, v1611, v1612;
             while true do
                 local v1602 = false;
                 local v1603 = false;
                 local v1604 = (u331 + (0.016666666666666666 * u330)) + (0.0001388888888888889 * u351);
                 v1605 = v1604;
                 local v1606 = u330 + (0.016666666666666666 * u351);
                 local v1607, v1608, v1609 = workspace:FindPartOnRayWithWhitelist(u314(u331, (v1604 - u331) - (0.05 * u336)), u310.raycastwhitelist);
                 local v1610 = v1607;
                 v1611 = v1608;
                 v1612 = v1609;
                 v1613 = 0.016666666666666666 * v1598;
                 if (v1607) then
                     local t_Name_209 = v1610.Name;
                     if (t_Name_209 == "Window") then
                         v1602 = true;
                     else
                         local t_Name_210 = v1610.Name;
                         if (t_Name_210 == "Col") then
                             v1602 = true;
                         else
                             u337 = u347.CFrame - u347.CFrame.p;
                             u336 = 0.2 * v1612;
                             u338 = v1612:Cross(u330) / 0.2;
                             local v1614 = v1611 - u331;
                             local v1615 = v1614;
                             local v1616 = 1 - (0.001 / v1614.magnitude);
                             local v1617 = v1616;
                             local v1618;
                             if (v1616 <= 0) then
                                 v1618 = 0;
                             else
                                 v1618 = v1617;
                             end
                             u331 = (u331 + (v1618 * v1615)) + (0.05 * v1612);
                             local v1619 = u316(v1612, u330) * v1612;
                             local v1620 = v1619;
                             local v1621 = u330 - v1619;
                             local v1622 = -u316(v1612, u351);
                             local v1623 = v1622;
                             local v1624 = -1.2 * u316(v1612, u330);
                             local v1625;
                             if (v1622 <= 0) then
                                 v1625 = 0;
                             else
                                 v1625 = v1623;
                             end
                             local v1626 = (10 * v1625) * 0.016666666666666666;
                             local v1627;
                             if (v1624 <= 0) then
                                 v1627 = 0;
                             else
                                 v1627 = v1624;
                             end
                             local v1628 = 1 - ((0.08 * (v1626 + v1627)) / v1621.magnitude);
                             local v1629 = v1628;
                             local v1630;
                             if (v1628 <= 0) then
                                 v1630 = 0;
                             else
                                 v1630 = v1629;
                             end
                             u330 = (v1630 * v1621) - (0.2 * v1620);
                             if (u330.magnitude <= 1) then
                                 break;
                             end
                             local v1631 = u345.frames;
                             local v1632 = (#v1631) + 1;
                             local v1633 = (#v1631) + 1;
                             local v1634 = {};
                             v1634.t0 = v1613 - ((0.016666666666666666 * (v1605 - v1611).magnitude) / (v1605 - u331).magnitude);
                             v1634.p0 = u331;
                             v1634.v0 = u330;
                             v1634.b = u335;
                             v1634.rot0 = u305.fromaxisangle(v1613 * u338) * u337;
                             v1634.offset = 0.2 * v1612;
                             v1634.rotv = u338;
                             v1634.glassbreaks = {};
                             v1631[v1633] = v1634;
                             u335 = true;
                             v1603 = true;
                         end
                     end
                 else
                     v1602 = true;
                 end
                 if (v1602) then
                     u331 = v1605;
                     u330 = v1606;
                     u335 = false;
                     if (v1610) then
                         local t_Name_211 = v1610.Name;
                         if ((t_Name_211 == "Window") and (u346 <= 5)) then
                             u346 = u346 + 1;
                             local v1635 = u345.frames;
                             local v1636 = v1635[#v1635].glassbreaks;
                             local v1637 = (#v1636) + 1;
                             local v1638 = {};
                             v1638.t = v1613;
                             v1638.part = v1610;
                             v1636[v1637] = v1638;
                             v1603 = true;
                         else
                             v1603 = true;
                         end
                     else
                         v1603 = true;
                     end
                 end
                 if (v1603) then
                     local v1639 = v1598 + 1;
                     v1598 = v1639;
                     local v1640 = v1600;
                     if (v1640 < v1639) then
                         break;
                     end
                 end
             end
             local v1641 = u345.frames;
             local v1642 = (#v1641) + 1;
             local v1643 = {};
             v1643.t0 = v1613 - ((0.016666666666666666 * (v1605 - v1611).magnitude) / (v1605 - u331).magnitude);
             v1643.p0 = u331;
             v1643.v0 = u315;
             v1643.b = true;
             v1643.rot0 = u305.fromaxisangle(v1613 * u338) * u337;
             v1643.offset = 0.2 * v1612;
             v1643.rotv = u315;
             v1643.glassbreaks = {};
             v1641[v1642] = v1643;
         end
         u317:send("new\226\128\139grenade", u350.name, u345);
     end;
     local u352 = v1561;
     local u353 = v1547;
     local u354 = v1546;
     local f_createnade = f_createnade;
     local u355 = p270;
     local f_throw;
     f_throw = function(p274)
         --[[
             Name: throw
             Line: 5002
             Upvalues: 
                 [1] = u310
                 [2] = u311
                 [3] = u328
                 [4] = u327
                 [5] = u329
                 [6] = u318
                 [7] = u308
                 [8] = u319
                 [9] = u352
                 [10] = u353
                 [11] = u354
                 [12] = f_createnade
                 [13] = u238
                 [14] = u355
 
         --]]
         if (u310.lock or (u311.gammo < 0)) then
             return;
         end
         if (u328 and (not u327)) then
             local v1644 = tick();
             u327 = true;
             u328 = false;
             p274.cooking = u328;
             u329 = false;
             u318.t = 0;
             u308:add(u319.player(u352, u353.animations.throw));
             u354:delay(0.07);
             u354:add(function()
                 --[[
                     Name: (empty)
                     Line: 5014
                     Upvalues: 
                         [1] = f_createnade
                         [2] = u238
                         [3] = u318
                         [4] = u327
 
                 --]]
                 f_createnade();
                 if (u238) then
                     u318.t = 1;
                 end
                 u327 = false;
             end);
             u308:add(function()
                 --[[
                     Name: (empty)
                     Line: 5019
                     Upvalues: 
                         [1] = u355
 
                 --]]
                 if (u355) then
                     u355:setequipped(true);
                 end
             end);
         end
     end;
     v1545.throw = f_throw;
     local u356 = v1561;
     local u357 = v1547;
     local u358 = v1552;
     local t_fusetime_212 = v1554;
     local f_pull;
     f_pull = function(p275)
         --[[
             Name: pull
             Line: 5027
             Upvalues: 
                 [1] = u328
                 [2] = u327
                 [3] = u239
                 [4] = u308
                 [5] = u319
                 [6] = u356
                 [7] = u357
                 [8] = u307
                 [9] = u358
                 [10] = u332
                 [11] = t_fusetime_212
                 [12] = u333
 
         --]]
         local v1645 = tick();
         if (not (u328 or u327)) then
             if (u239) then
                 u308:add(u319.reset(u356, 0.1));
                 u239 = false;
             end
             u308:add(u319.player(u356, u357.animations.pull));
             local v1646 = u308;
             local u359 = p275;
             local u360 = v1645;
             v1646:add(function()
                 --[[
                     Name: (empty)
                     Line: 5035
                     Upvalues: 
                         [1] = u307
                         [2] = u357
                         [3] = u358
                         [4] = u328
                         [5] = u359
                         [6] = u332
                         [7] = u360
                         [8] = t_fusetime_212
                         [9] = u333
 
                 --]]
                 u307.crossspring.a = u357.crossexpansion;
                 u358:Destroy();
                 u328 = true;
                 u359.cooking = u328;
                 u332 = u360 + t_fusetime_212;
                 u333 = u360 + 5;
             end);
         end
     end;
     v1545.pull = f_pull;
     local u361 = tick();
     local u362 = 1;
     local u363 = nil;
     local v1647 = game:GetService("RunService").RenderStepped;
     local u364 = v1546;
     local u365 = v1545;
     local f_createnade = f_createnade;
     local u366 = v1547;
     local u367 = v1551;
     u363 = v1647:connect(function(p276)
         --[[
             Name: (empty)
             Line: 5048
             Upvalues: 
                 [1] = u364
                 [2] = u328
                 [3] = u327
                 [4] = u306
                 [5] = u365
                 [6] = u329
                 [7] = f_createnade
                 [8] = u332
                 [9] = u320
                 [10] = u307
                 [11] = u366
                 [12] = u367
                 [13] = u345
                 [14] = u362
                 [15] = u361
                 [16] = u321
                 [17] = u315
                 [18] = u305
                 [19] = u339
                 [20] = u314
                 [21] = u312
                 [22] = u310
                 [23] = u363
 
         --]]
         u364.step();
         local v1648 = tick();
         if (u328 and (not u327)) then
             if (u306.alive) then
                 if ((not (u332 < v1648)) and u320.keyboard.down.g) then
                     if (((u332 - v1648) % 1) <= p276) then
                         u307.crossspring.a = u366.crossexpansion;
                     end
                 else
                     u365:throw();
                 end
             else
                 u328 = false;
                 u365.cooking = u328;
                 u329 = false;
                 f_createnade(true);
                 u327 = false;
                 u365:setequipped(false);
             end
         end
         if (u367 and u345) then
             local t_time_213 = u345.time;
             local v1649 = u345.frames;
             local t_frames_214 = v1649;
             local v1650 = v1649[u362];
             local v1651 = v1650.glassbreaks;
             local t_glassbreaks_215 = v1651;
             local v1652 = 1;
             local v1653 = #v1651;
             local v1654 = v1653;
             local v1655 = v1652;
             if (not (v1653 <= v1655)) then
                 while true do
                     local v1656 = t_glassbreaks_215[v1652];
                     local v1657 = v1656;
                     local v1658 = u361;
                     local v1659 = t_time_213 + v1656.t;
                     if ((v1658 <= v1659) and ((t_time_213 + v1657.t) < v1648)) then
                         u321:breakwindow(v1657.part);
                     end
                     local v1660 = v1652 + 1;
                     v1652 = v1660;
                     local v1661 = v1654;
                     if (v1661 < v1660) then
                         break;
                     end
                 end
             end
             local v1662 = t_frames_214[u362 + 1];
             local v1663 = v1662;
             if (v1662 and ((u345.time + v1663.t0) <= v1648)) then
                 u362 = u362 + 1;
                 v1650 = v1663;
             end
             local v1664 = false;
             local v1665 = v1648 - (t_time_213 + v1650.t0);
             local v1666;
             if (v1650.b) then
                 v1666 = u315;
                 if (not v1666) then
                     v1664 = true;
                 end
             else
                 v1664 = true;
             end
             if (v1664) then
                 v1666 = Vector3.new(0, -80, 0);
             end
             local v1667 = ((v1650.p0 + (v1665 * v1650.v0)) + (((v1665 * v1665) / 2) * v1666)) + v1650.offset;
             local v1668 = v1667;
             u367.CFrame = (u305.fromaxisangle(v1665 * v1650.rotv) * v1650.rot0) + v1667;
             if (u339) then
                 u339.Enabled = not workspace:FindPartOnRayWithWhitelist(u314(v1668, u312.cframe.p - v1668), u310.raycastwhitelist);
             end
             if ((t_time_213 + u345.blowuptime) <= v1648) then
                 u363:Disconnect();
                 u367:Destroy();
             end
         end
         u361 = v1648;
     end);
     local t_mainoffset_216 = v1550;
     local u368 = v1561;
     local t_mainpart_217 = v1549;
     local u369 = v1571;
     local u370 = v1570;
     local u371 = v1547;
     local u372 = v1562;
     local f_step;
     f_step = function()
         --[[
             Name: step
             Line: 5107
             Upvalues: 
                 [1] = u231
                 [2] = u312
                 [3] = t_mainoffset_216
                 [4] = u368
                 [5] = t_mainpart_217
                 [6] = u369
                 [7] = u322
                 [8] = u323
                 [9] = u305
                 [10] = u324
                 [11] = f_gunbob
                 [12] = f_gunsway
                 [13] = u370
                 [14] = u325
                 [15] = u249
                 [16] = u318
                 [17] = u371
                 [18] = u309
                 [19] = u372
                 [20] = u284
                 [21] = u283
 
         --]]
         local v1669 = (((((((((u231.CFrame:inverse() * u312.shakecframe) * t_mainoffset_216) * u368[t_mainpart_217].weld.C0) * u369(u322.p)) * u323(0, 0, 1)) * u305.fromaxisangle(u324.v)) * u323(0, 0, -1)) * f_gunbob(0.7, 1)) * f_gunsway(0)) * u370((u325.p / u249.p) * u318.p):Lerp(u371.equipoffset, u309.p);
         u372.C0 = v1669;
         u284.C0 = v1669 * u368.larm.weld.C0;
         u283.C0 = v1669 * u368.rarm.weld.C0;
     end;
     v1545.step = f_step;
     return v1545;
 end;
 u2.loadgrenade = f_loadgrenade;
 local u373 = v22;
 local u374 = t_toObjectSpace_152;
 local u375 = u228;
 local u376 = f_texturemodel;
 local u377 = v1113;
 local u378 = u14;
 local u379 = u2;
 local u380 = u4;
 local u381 = u21;
 local u382 = v1126;
 local u383 = u12;
 local u384 = v1127;
 local t_CurrentCamera_218 = v1542;
 local u385 = v1166;
 local u386 = v23;
 local u387 = u9;
 local u388 = u19;
 local u389 = v1120;
 local u390 = u7;
 local u391 = t_LocalPlayer_153;
 local u392 = t_Dot_151;
 local u393 = v1121;
 local u394 = u230;
 local u395 = u16;
 local u396 = v1161;
 local u397 = u229;
 local u398 = v1155;
 local f_gunbob = f_gunbob;
 local f_gunsway = f_gunsway;
 local u399 = v1164;
 local f_loadknife;
 f_loadknife = function(p277, p278)
     --[[
         Name: loadknife
         Line: 5128
         Upvalues: 
             [1] = f_gunrequire
             [2] = t_getGunModel_4
             [3] = u373
             [4] = u374
             [5] = u375
             [6] = u376
             [7] = u288
             [8] = u377
             [9] = u231
             [10] = u378
             [11] = u282
             [12] = u379
             [13] = u380
             [14] = u381
             [15] = u382
             [16] = u235
             [17] = u383
             [18] = u384
             [19] = t_CurrentCamera_218
             [20] = u385
             [21] = u238
             [22] = u386
             [23] = u239
             [24] = u237
             [25] = u387
             [26] = u388
             [27] = u389
             [28] = u390
             [29] = u391
             [30] = u392
             [31] = u393
             [32] = u394
             [33] = u395
             [34] = u396
             [35] = u397
             [36] = u398
             [37] = f_gunbob
             [38] = f_gunsway
             [39] = u399
             [40] = u249
             [41] = u284
             [42] = u283
 
     --]]
     local v1670 = {};
     local v1671 = f_gunrequire(p277);
     local v1672 = v1671;
     local v1673 = t_getGunModel_4(p277):Clone();
     local v1674 = v1673;
     v1670.knife = true;
     v1670.name = v1671.name;
     v1670.type = v1671.type;
     v1670.camodata = p278;
     v1670.texturedata = {};
     local v1675 = u373.new();
     local u400 = {};
     local v1676 = v1671.mainpart;
     local t_mainpart_219 = v1676;
     local t_mainoffset_220 = v1671.mainoffset;
     local v1677 = v1673[v1676];
     local v1678 = v1677;
     local v1679 = v1673[v1671.tip];
     local v1680 = v1673[v1671.blade];
     local u401 = nil;
     local u402 = false;
     local u403 = false;
     local u404 = 1000;
     local v1681 = v1671.range0;
     local v1682 = v1671.range1;
     local t_damage0_221 = v1671.damage0;
     local t_damage1_222 = v1671.damage1;
     local v1683 = v1677:Clone();
     local v1684 = v1683;
     v1683.Name = "Handle";
     v1683.Parent = v1673;
     local v1685 = {};
     local t_CFrame_223 = v1683.CFrame;
     local v1686 = v1673:GetChildren();
     local v1687 = v1686;
     local v1688 = v1673:FindFirstChild("MenuNodes");
     local v1689 = 1;
     local v1690 = #v1686;
     local v1691 = v1690;
     local v1692 = v1689;
     if (not (v1690 <= v1692)) then
         while true do
             local v1693 = v1687[v1689];
             local v1694 = v1693;
             if (v1693:IsA("BasePart")) then
                 if (not ((v1694 == v1684) or (v1694 == v1678))) then
                     local v1695 = u374(t_CFrame_223, v1694.CFrame);
                     local v1696 = u375("Weld");
                     v1696.Part0 = v1684;
                     v1696.Part1 = v1694;
                     v1696.C0 = v1695;
                     v1696.Parent = v1684;
                     local v1697 = v1694.Name;
                     local v1698 = {};
                     v1698.part = v1694;
                     v1698.weld = v1696;
                     v1698.basec0 = v1695;
                     v1698.basetransparency = v1694.Transparency;
                     v1685[v1697] = v1698;
                 end
                 local v1699 = v1694:FindFirstChild("Trail");
                 local v1700 = v1699;
                 if (v1699 and v1699:IsA("Trail")) then
                     u401 = v1700;
                     u401.Enabled = false;
                 end
                 v1694.Anchored = false;
                 v1694.CanCollide = false;
             end
             local v1701 = v1689 + 1;
             v1689 = v1701;
             local v1702 = v1691;
             if (v1702 < v1701) then
                 break;
             end
         end
     end
     u376(p278, v1674);
     if (v1688) then
         v1688:Destroy();
     end
     local v1703 = v1674:GetChildren();
     local v1704 = v1703;
     local v1705 = 1;
     local v1706 = #v1703;
     local v1707 = v1706;
     local v1708 = v1705;
     if (not (v1706 <= v1708)) then
         while true do
             local v1709 = false;
             local v1710 = v1704[v1705];
             local v1711 = v1710;
             v1670.texturedata[v1710] = {};
             local v1712 = v1710:GetChildren();
             local v1713 = v1712;
             local v1714 = 1;
             local v1715 = #v1712;
             local v1716 = v1715;
             local v1717 = v1714;
             if (v1715 <= v1717) then
                 v1709 = true;
             else
                 while true do
                     local v1718 = v1713[v1714];
                     local v1719 = v1718;
                     if (v1718:IsA("Texture") or v1718:IsA("Decal")) then
                         local v1720 = v1670.texturedata[v1711];
                         local v1721 = {};
                         v1721.Transparency = v1719.Transparency;
                         v1720[v1719] = v1721;
                     end
                     local v1722 = v1714 + 1;
                     v1714 = v1722;
                     local v1723 = v1716;
                     if (v1723 < v1722) then
                         break;
                     end
                 end
                 v1709 = true;
             end
             if (v1709) then
                 if (v1711:IsA("BasePart")) then
                     v1711.CastShadow = false;
                 end
                 local v1724 = v1705 + 1;
                 v1705 = v1724;
                 local v1725 = v1707;
                 if (v1725 < v1724) then
                     break;
                 end
             end
         end
     end
     v1685.camodata = v1670.texturedata;
     local v1726 = u375("Motor6D");
     v1726.Part0 = u288;
     v1726.Part1 = v1684;
     v1726.Parent = v1684;
     local v1727 = u375("Motor6D");
     local v1728 = {};
     local v1729 = {};
     v1729.C0 = u377;
     v1728.weld = v1729;
     v1728.basec0 = u377;
     v1685[t_mainpart_219] = v1728;
     local v1730 = {};
     local v1731 = {};
     v1731.C0 = v1672.larmoffset;
     v1730.weld = v1731;
     v1730.basec0 = v1672.larmoffset;
     v1685.larm = v1730;
     local v1732 = {};
     local v1733 = {};
     v1733.C0 = v1672.rarmoffset;
     v1732.weld = v1733;
     v1732.basec0 = v1672.rarmoffset;
     v1685.rarm = v1732;
     local v1734 = {};
     local v1735 = {};
     v1735.C0 = v1672.knifeoffset;
     v1734.weld = v1735;
     v1734.basec0 = v1672.knifeoffset;
     v1685.knife = v1734;
     v1727.Part0 = u231;
     v1727.Part1 = v1678;
     v1727.Parent = v1678;
     local v1736 = v1672.equipoffset;
     local v1737 = u378.interpolator(v1672.sprintoffset);
     local v1738 = u378.interpolator(v1672.proneoffset);
     local u405 = nil;
     local u406 = v1674;
     local f_destroy;
     f_destroy = function(p279)
         --[[
             Name: destroy
             Line: 5245
             Upvalues: 
                 [1] = u406
 
         --]]
         if (u406:FindFirstChild("Sound")) then
             u406.Sound.Parent = nil;
         end
         u406:Destroy();
     end;
     v1670.destroy = f_destroy;
     local u407 = v1672;
     local u408 = t_mainpart_219;
     local u409 = v1674;
     local u410 = v1685;
     local f_setequipped;
     f_setequipped = function(p280, p281, p282)
         --[[
             Name: setequipped
             Line: 5254
             Upvalues: 
                 [1] = u402
                 [2] = u282
                 [3] = u379
                 [4] = u380
                 [5] = u407
                 [6] = u408
                 [7] = u381
                 [8] = u405
                 [9] = u382
                 [10] = u235
                 [11] = u383
                 [12] = u384
                 [13] = u409
                 [14] = t_CurrentCamera_218
                 [15] = u401
                 [16] = u385
                 [17] = u403
                 [18] = u238
                 [19] = u404
                 [20] = u386
                 [21] = u410
                 [22] = u239
 
         --]]
         if (p281 and (not (u402 and u282))) then
             if (u379.alive) then
                 u380:setcrosssettings(u407.type, u407.crosssize, u407.crossspeed, u407.crossdamper, u408);
                 u380:updatefiremode("KNIFE");
                 u380:updateammo("KNIFE");
                 u381.play("equipCloth", 0.25);
                 u381.play(u407.soundClassification .. "Equip", 0.25);
                 u282 = true;
                 u405 = false;
                 u382:clear();
                 if (u235) then
                     u235:setequipped(false);
                 end
                 u383:send("eq\226\128\139uip", 3);
                 local v1739 = u382;
                 local u411 = p282;
                 local u412 = p280;
                 v1739:add(function()
                     --[[
                         Name: (empty)
                         Line: 5270
                         Upvalues: 
                             [1] = u379
                             [2] = u407
                             [3] = u384
                             [4] = u380
                             [5] = u409
                             [6] = t_CurrentCamera_218
                             [7] = u401
                             [8] = u381
                             [9] = u385
                             [10] = u411
                             [11] = u402
                             [12] = u235
                             [13] = u412
                             [14] = u282
                             [15] = u403
                             [16] = u238
                             [17] = u404
 
                     --]]
                     u379:setbasewalkspeed(u407.walkspeed);
                     u384.s = u407.sprintspeed;
                     u380:setcrosssize(u407.crosssize);
                     if (u409) then
                         u409.Parent = t_CurrentCamera_218;
                     end
                     if (u401) then
                         u401.Enabled = false;
                     end
                     local t_soundClassification_224 = u407.soundClassification;
                     if (t_soundClassification_224 == "saber") then
                         u381.play("saberLoop", 0.25, 1, u409, false, true);
                     end
                     local v1740 = u385;
                     local v1741;
                     if (u411) then
                         v1741 = 32;
                     else
                         v1741 = 16;
                     end
                     v1740.s = v1741;
                     u385.t = 0;
                     u402 = true;
                     u235 = u412;
                     u282 = false;
                     u381.play("equipCloth", 0.25);
                     u403 = false;
                     u379.grenadehold = false;
                     if (u238) then
                         u384.t = 1;
                     end
                     local v1742;
                     if (u411) then
                         v1742 = 2000;
                     else
                         v1742 = 1000;
                     end
                     u404 = v1742;
                 end);
                 if (p282) then
                     u382:delay(0.05);
                     local v1743 = u382;
                     local u413 = p280;
                     local u414 = p282;
                     v1743:add(function()
                         --[[
                             Name: (empty)
                             Line: 5307
                             Upvalues: 
                                 [1] = u413
                                 [2] = u414
 
                         --]]
                         u413:shoot(u414);
                     end);
                 end
             else
                 return;
             end
         else
             if ((not p281) and u402) then
                 u403 = false;
                 u405 = false;
                 u385.t = 1;
                 u382:add(u386.reset(u410, 0.1));
                 u382:add(function()
                     --[[
                         Name: (empty)
                         Line: 5318
                         Upvalues: 
                             [1] = u402
                             [2] = u409
                             [3] = u239
                             [4] = u235
 
                     --]]
                     u402 = false;
                     local v1744 = u409:FindFirstChildOfClass("Sound");
                     local v1745 = v1744;
                     if (v1744) then
                         v1745:Stop();
                     end
                     u409.Parent = nil;
                     u239 = false;
                     u235 = nil;
                 end);
             end
         end
         if (p282 == "death") then
             p280:destroy();
         end
     end;
     v1670.setequipped = f_setequipped;
     local f_inspecting;
     f_inspecting = function(p283)
         --[[
             Name: inspecting
             Line: 5335
             Upvalues: 
                 [1] = u405
 
         --]]
         return u405;
     end;
     v1670.inspecting = f_inspecting;
     local f_isaiming;
     f_isaiming = function()
         --[[
             Name: isaiming
             Line: 5339
         --]]
         return false;
     end;
     v1670.isaiming = f_isaiming;
     local u415 = v1685;
     local u416 = v1672;
     local f_playanimation;
     f_playanimation = function(p284, p285)
         --[[
             Name: playanimation
             Line: 5343
             Upvalues: 
                 [1] = u403
                 [2] = u282
                 [3] = u382
                 [4] = u239
                 [5] = u386
                 [6] = u415
                 [7] = u384
                 [8] = u405
                 [9] = u416
                 [10] = u238
 
         --]]
         if (not (u403 or u282)) then
             u382:clear();
             if (u239) then
                 u382:add(u386.reset(u415, 0.05));
             end
             u239 = true;
             u384.t = 0;
             if (p285 == "inspect") then
                 u405 = true;
             end
             u382:add(u386.player(u415, u416.animations[p285]));
             local v1746 = u382;
             local u417 = p285;
             v1746:add(function()
                 --[[
                     Name: (empty)
                     Line: 5358
                     Upvalues: 
                         [1] = u382
                         [2] = u386
                         [3] = u415
                         [4] = u416
                         [5] = u417
                         [6] = u239
                         [7] = u238
                         [8] = u384
                         [9] = u405
 
                 --]]
                 u382:add(u386.reset(u415, u416.animations[u417].resettime));
                 u239 = false;
                 u382:add(function()
                     --[[
                         Name: (empty)
                         Line: 5361
                         Upvalues: 
                             [1] = u238
                             [2] = u384
                             [3] = u405
 
                     --]]
                     if (u238) then
                         u384.t = 1;
                     end
                     u405 = false;
                 end);
             end);
         end
     end;
     v1670.playanimation = f_playanimation;
     local u418 = v1685;
     local f_reloadcancel;
     f_reloadcancel = function(p286, p287)
         --[[
             Name: reloadcancel
             Line: 5369
             Upvalues: 
                 [1] = u382
                 [2] = u386
                 [3] = u418
                 [4] = u237
                 [5] = u239
                 [6] = u238
                 [7] = u384
 
         --]]
         if (p287) then
             u382:clear();
             u382:add(u386.reset(u418, 0.2));
             u237 = false;
             u239 = false;
             u382:add(function()
                 --[[
                     Name: (empty)
                     Line: 5375
                     Upvalues: 
                         [1] = u238
                         [2] = u384
 
                 --]]
                 if (u238) then
                     u384.t = 1;
                 end
             end);
         end
     end;
     v1670.reloadcancel = f_reloadcancel;
     local u419 = v1678;
     local f_dropguninfo;
     f_dropguninfo = function(p288)
         --[[
             Name: dropguninfo
             Line: 5382
             Upvalues: 
                 [1] = u419
 
         --]]
         return u419.Position;
     end;
     v1670.dropguninfo = f_dropguninfo;
     local u420 = v1685;
     local u421 = v1672;
     local f_shoot;
     f_shoot = function(p289, p290, p291)
         --[[
             Name: shoot
             Line: 5386
             Upvalues: 
                 [1] = u387
                 [2] = u405
                 [3] = u403
                 [4] = u282
                 [5] = u384
                 [6] = u383
                 [7] = u237
                 [8] = u401
                 [9] = u239
                 [10] = u382
                 [11] = u386
                 [12] = u420
                 [13] = u381
                 [14] = u421
                 [15] = u400
                 [16] = u238
 
         --]]
         if (u387.lock) then
             return;
         end
         if (u405) then
             p289:reloadcancel(true);
             u405 = false;
         end
         if (not (u403 or u282)) then
             local t_s_225 = u384.s;
             local v1747 = tick();
             u383:send("st\226\128\139ab");
             u384.t = 0;
             u384.s = 50;
             u403 = true;
             u237 = true;
             if (u401) then
                 u401.Enabled = true;
             end
             if (u239) then
                 u382:add(u386.reset(u420, 0.1));
                 u239 = false;
             end
             local v1748;
             if (p290) then
                 v1748 = "quickstab";
             else
                 v1748 = p291;
                 if (not v1748) then
                     v1748 = "stab1";
                 end
             end
             u381.play(u421.soundClassification, 0.25);
             u400 = {};
             u382:add(u386.player(u420, u421.animations[v1748]));
             local v1749 = u382;
             local u422 = v1748;
             v1749:add(function()
                 --[[
                     Name: (empty)
                     Line: 5419
                     Upvalues: 
                         [1] = u382
                         [2] = u386
                         [3] = u420
                         [4] = u421
                         [5] = u422
 
                 --]]
                 u382:add(u386.reset(u420, u421.animations[u422].resettime));
             end);
             if (u238 or (v1748 == "quickstab")) then
                 u382:delay(u421.animations[v1748].resettime * 0.75);
                 u382:add(function()
                     --[[
                         Name: (empty)
                         Line: 5425
                         Upvalues: 
                             [1] = u238
                             [2] = u384
 
                     --]]
                     if (u238) then
                         u384.t = 1;
                     end
                 end);
             end
             local v1750 = u382;
             local u423 = t_s_225;
             v1750:add(function()
                 --[[
                     Name: (empty)
                     Line: 5431
                     Upvalues: 
                         [1] = u403
                         [2] = u384
                         [3] = u423
                         [4] = u237
                         [5] = u401
 
                 --]]
                 u403 = false;
                 u384.s = u423;
                 u237 = false;
                 if (u401) then
                     u401.Enabled = false;
                 end
             end);
         end
     end;
     v1670.shoot = f_shoot;
     local u424 = t_damage1_222;
     local u425 = t_damage0_221;
     local u426 = v1672;
     local f_knifehitdetection;
     f_knifehitdetection = function(p292, p293, p294, p295, p296)
         --[[
             Name: knifehitdetection
             Line: 5442
             Upvalues: 
                 [1] = u400
                 [2] = u388
                 [3] = u389
                 [4] = u390
                 [5] = u391
                 [6] = u392
                 [7] = u231
                 [8] = u424
                 [9] = u425
                 [10] = u426
                 [11] = u383
                 [12] = u380
 
         --]]
         local v1751 = nil;
         if (not (u400[p292.Parent] or u400[p292])) then
             local t_Name_226 = p292.Name;
             if (t_Name_226 == "Window") then
                 u388:breakwindow(p292, p295.Direction);
                 v1751 = p292;
             else
                 local t_Name_227 = p292.Parent.Name;
                 if (t_Name_227 == "Dead") then
                     u388:bloodhit(p292.Position, p292.CFrame.lookVector);
                     v1751 = p292.Parent;
                 else
                     if (p292:IsDescendantOf(u389)) then
                         local v1752 = u390.getplayerhit(p292);
                         local v1753 = v1752;
                         local v1754 = p292.Parent:FindFirstChild("Head");
                         local v1755 = p292.Parent:FindFirstChild("Torso");
                         if (v1752) then
                             local v1756 = v1753.TeamColor;
                             local t_TeamColor_228 = u391.TeamColor;
                             if (((not (v1756 == t_TeamColor_228)) and v1754) and v1755) then
                                 local v1757 = (((u392(v1755.CFrame.lookVector, (p293 - u231.Position).unit) * 0.5) + 0.5) * (u424 - u425)) + u425;
                                 if (v1757 >= 100) then
                                 end
                                 local t_Name_229 = p292.Name;
                                 if (t_Name_229 == "Head") then
                                     v1757 = v1757 * u426.multhead;
                                 else
                                     local t_Name_230 = p292.Name;
                                     if (t_Name_230 == "Torso") then
                                         v1757 = v1757 * u426.multtorso;
                                     end
                                 end
                                 u383:send("knife\226\128\139hit", v1753, tick(), p292.Name);
                                 u380:firehitmarker(p292.Name == "Head");
                                 u388:bloodhit(p293, true, v1757, Vector3.new(0, -8, 0) + ((p293 - u231.Position).unit * 8));
                             end
                         end
                         v1751 = p292.Parent;
                     else
                         if (p296) then
                             u388:bullethit(p292, p293, p294);
                             v1751 = p292;
                         end
                     end
                 end
             end
             if (v1751) then
                 u400[v1751] = true;
             end
         end
     end;
     local u427 = v1679;
     local u428 = v1680;
     local f_knifehitdetection = f_knifehitdetection;
     local u429 = t_mainoffset_220;
     local u430 = v1685;
     local u431 = t_mainpart_219;
     local u432 = v1738;
     local u433 = v1737;
     local u434 = v1672;
     local u435 = v1727;
     local u436 = v1726;
     local u437 = v1675;
     local u438 = v1670;
     local f_step;
     f_step = function(p297)
         --[[
             Name: step
             Line: 5485
             Upvalues: 
                 [1] = u403
                 [2] = u390
                 [3] = u393
                 [4] = u427
                 [5] = u428
                 [6] = u394
                 [7] = u395
                 [8] = f_knifehitdetection
                 [9] = u231
                 [10] = u429
                 [11] = u430
                 [12] = u431
                 [13] = u432
                 [14] = u396
                 [15] = u397
                 [16] = u378
                 [17] = u398
                 [18] = f_gunbob
                 [19] = f_gunsway
                 [20] = u433
                 [21] = u399
                 [22] = u249
                 [23] = u384
                 [24] = u434
                 [25] = u385
                 [26] = u435
                 [27] = u284
                 [28] = u283
                 [29] = u436
                 [30] = u437
                 [31] = u379
                 [32] = u438
 
         --]]
         if (u403) then
             local v1758 = u390.getallparts();
             local v1759 = v1758;
             v1758[(#v1758) + 1] = u393;
             local v1760 = u427.CFrame.p;
             local v1761 = u428.CFrame.p;
             local t_p_231 = v1760;
             local v1762 = v1761 - v1760;
             local v1763 = v1762;
             local v1764 = v1762.Magnitude;
             local t_Magnitude_232 = v1764;
             local v1765 = 0;
             local t_Magnitude_233 = v1764;
             local v1766 = v1765;
             if (not (v1764 <= v1766)) then
                 while true do
                     local v1767 = u394(u395.cframe.p, (t_p_231 + ((v1765 / t_Magnitude_232) * v1763)) - u395.cframe.p);
                     local v1768 = v1767;
                     local v1769, v1770, v1771 = workspace:FindPartOnRayWithWhitelist(v1767, v1759);
                     local v1772 = v1769;
                     local v1773 = v1770;
                     local v1774 = v1771;
                     if (v1769) then
                         f_knifehitdetection(v1772, v1773, v1774, v1768, v1765 == 0);
                     end
                     local v1775 = v1765 + 0.1;
                     v1765 = v1775;
                     local v1776 = t_Magnitude_233;
                     if (v1776 < v1775) then
                         break;
                     end
                 end
             end
         end
         local v1777 = (((((((((u231.CFrame:inverse() * u395.shakecframe) * u429) * u430[u431].weld.C0) * u432(u396.p)) * u397(0, 0, 1)) * u378.fromaxisangle(u398.v)) * u397(0, 0, -1)) * f_gunbob(0.7, 1)) * f_gunsway(0)) * u433((u399.p / u249.p) * u384.p):Lerp(u434.equipoffset, u385.p);
         u435.C0 = v1777;
         u284.C0 = v1777 * u430.larm.weld.C0:Lerp(u434.larmsprintoffset, (u399.p / u249.p) * u384.p);
         u283.C0 = v1777 * u430.rarm.weld.C0:Lerp(u434.rarmsprintoffset, (u399.p / u249.p) * u384.p);
         u436.C0 = u430.knife.weld.C0;
         u437:step();
         if (not u379.alive) then
             u438:setequipped(false);
         end
     end;
     v1670.step = f_step;
     return v1670;
 end;
 u2.loadknife = f_loadknife;
 local u439 = 0;
 local v1778 = shared.require("InputType");
 local v1779 = shared.require("SamplePointGenerator");
 local u440 = v27;
 local u441 = v1779;
 local u442 = v22;
 local f_weldmodel = f_weldmodel;
 local f_addgun = f_addgun;
 local f_removegun = f_removegun;
 local u443 = v1112;
 local u444 = u228;
 local u445 = v1113;
 local u446 = u14;
 local u447 = u2;
 local u448 = v19;
 local u449 = v1116;
 local u450 = v1134;
 local u451 = u16;
 local u452 = u4;
 local u453 = u12;
 local u454 = u21;
 local u455 = v1126;
 local u456 = v1127;
 local u457 = v1166;
 local t_CurrentCamera_234 = v1542;
 local u458 = u17;
 local u459 = u19;
 local u460 = v23;
 local u461 = v1136;
 local u462 = u10;
 local u463 = t_PlayerGui_154;
 local u464 = u5;
 local u465 = u9;
 local u466 = t_LocalPlayer_153;
 local u467 = v1778;
 local f_pickv3 = f_pickv3;
 local u468 = u230;
 local u469 = u18;
 local u470 = u11;
 local f_bfgsounds = f_bfgsounds;
 local u471 = v1164;
 local u472 = v1117;
 local u473 = u242;
 local u474 = v1155;
 local f_gunbob = f_gunbob;
 local f_gunsway = f_gunsway;
 local u475 = u8;
 local f_loadgun;
 f_loadgun = function(p298, p299, p300, p301, p302, p303, p304)
     --[[
         Name: loadgun
         Line: 5537
         Upvalues: 
             [1] = u440
             [2] = f_gunrequire
             [3] = t_getGunModel_4
             [4] = u441
             [5] = u442
             [6] = f_weldmodel
             [7] = f_addgun
             [8] = f_removegun
             [9] = u443
             [10] = u444
             [11] = u445
             [12] = u446
             [13] = u447
             [14] = u448
             [15] = u449
             [16] = u450
             [17] = u247
             [18] = u451
             [19] = u452
             [20] = f_updatewalkspeed
             [21] = u282
             [22] = u453
             [23] = u237
             [24] = u454
             [25] = u455
             [26] = u235
             [27] = u456
             [28] = u457
             [29] = t_CurrentCamera_234
             [30] = u231
             [31] = u458
             [32] = u238
             [33] = u459
             [34] = u460
             [35] = u239
             [36] = u285
             [37] = u286
             [38] = u461
             [39] = u462
             [40] = u463
             [41] = u464
             [42] = u465
             [43] = u466
             [44] = u467
             [45] = u240
             [46] = f_pickv3
             [47] = u468
             [48] = u439
             [49] = u469
             [50] = u470
             [51] = f_bfgsounds
             [52] = u471
             [53] = u249
             [54] = u472
             [55] = u473
             [56] = u474
             [57] = f_gunbob
             [58] = f_gunsway
             [59] = u284
             [60] = u283
             [61] = u475
 
     --]]
     local v1780 = false;
     local v1781 = u440(f_gunrequire(p298), p301, p302);
     local v1782 = v1781;
     local v1783 = t_getGunModel_4(p298):Clone();
     local v1784 = v1783;
     local v1785 = {};
     v1785.burst = 0;
     v1785.auto = false;
     v1785.firecount = 0;
     v1785.SPG = u441.new(2);
     v1785.attachments = p301;
     v1785.camodata = p303;
     v1785.texturedata = {};
     v1785.transparencydata = {};
     v1785.data = v1781;
     v1785.type = v1781.type;
     v1785.ammotype = v1781.ammotype;
     v1785.name = v1781.name;
     v1785.magsize = v1781.magsize;
     v1785.sparerounds = v1781.sparerounds;
     v1785.gunnumber = p304;
     local u476 = false;
     local v1786 = u442.new();
     local v1787 = v1781.mainpart;
     local t_mainpart_235 = v1787;
     local t_mainoffset_236 = v1781.mainoffset;
     local v1788 = v1783[v1787];
     local v1789 = v1788;
     local u477 = false;
     local u478 = false;
     local v1790 = f_weldmodel;
     local u479 = v1783;
     local v1791 = v1790(u479, v1788, p301, v1781, p303, p302);
     if (v1781.variablefirerate) then
         u479 = v1782.firerate[1];
         if (not u479) then
             v1780 = true;
         end
     else
         v1780 = true;
     end
     if (v1780) then
         u479 = v1782.firerate;
     end
     local u480 = v1782.firemodes;
     local u481 = 1;
     local v1792 = p300;
     if (not v1792) then
         v1792 = v1782.sparerounds;
     end
     local u482 = math.ceil(v1792);
     local t_chamber_237 = v1782.chamber;
     local u483 = v1782.magsize;
     local u484 = p299 or u483;
     local u485 = 0;
     local t_range0_238 = v1782.range0;
     local t_range1_239 = v1782.range1;
     local t_damage0_240 = v1782.damage0;
     local t_damage1_241 = v1782.damage1;
     f_addgun(v1785);
     local f_remove;
     f_remove = function(p305)
         --[[
             Name: remove
             Line: 5583
             Upvalues: 
                 [1] = f_removegun
 
         --]]
         f_removegun(p305);
     end;
     v1785.remove = f_remove;
     local v1793 = v1784:GetChildren();
     local v1794 = v1793;
     local v1795 = 1;
     local v1796 = #v1793;
     local v1797 = v1796;
     local v1798 = v1795;
     if (not (v1796 <= v1798)) then
         while true do
             local v1799 = v1794[v1795];
             local v1800 = v1799;
             v1785.texturedata[v1799] = {};
             v1785.transparencydata[v1799] = v1799.Transparency;
             local v1801 = v1799:GetChildren();
             local v1802 = v1801;
             local v1803 = 1;
             local v1804 = #v1801;
             local v1805 = v1804;
             local v1806 = v1803;
             if (not (v1804 <= v1806)) then
                 while true do
                     local v1807 = v1802[v1803];
                     local v1808 = v1807;
                     if (v1807:IsA("Texture") or v1807:IsA("Decal")) then
                         local v1809 = v1785.texturedata[v1800];
                         local v1810 = {};
                         v1810.Transparency = v1808.Transparency;
                         v1809[v1808] = v1810;
                     end
                     local v1811 = v1803 + 1;
                     v1803 = v1811;
                     local v1812 = v1805;
                     if (v1812 < v1811) then
                         break;
                     end
                 end
             end
             local t_Name_242 = v1800.Name;
             if (t_Name_242 == "LaserLight") then
                 u443:addlaser(v1800);
             end
             if (v1800:IsA("BasePart")) then
                 v1800.CastShadow = false;
             end
             local v1813 = v1795 + 1;
             v1795 = v1813;
             local v1814 = v1797;
             if (v1814 < v1813) then
                 break;
             end
         end
     end
     v1791.camodata = v1785.texturedata;
     local v1815 = u444("Motor6D");
     local v1816 = {};
     v1816.part = v1789;
     v1816.basetransparency = v1789.Transparency;
     local v1817 = {};
     v1817.C0 = u445;
     v1816.weld = v1817;
     v1816.basec0 = u445;
     v1791[t_mainpart_235] = v1816;
     local v1818 = {};
     local v1819 = {};
     v1819.C0 = v1782.larmoffset;
     v1818.weld = v1819;
     v1818.basec0 = v1782.larmoffset;
     v1791.larm = v1818;
     local v1820 = {};
     local v1821 = {};
     v1821.C0 = v1782.rarmoffset;
     v1820.weld = v1821;
     v1820.basec0 = v1782.rarmoffset;
     v1791.rarm = v1820;
     local v1822 = v1784[v1782.barrel];
     local v1823 = v1822;
     v1785.barrel = v1822;
     local v1824 = v1784[v1782.sight];
     if (v1782.altsight) then
         local v1825 = v1784[v1782.altsight];
     end
     local t_hideflash_243 = v1782.hideflash;
     local v1826 = v1782.hideminimap;
     local v1827 = v1782.hiderange or 50;
     local v1828 = CFrame.new;
     local v1829 = CFrame.Angles;
     local v1830 = math.pi / 180;
     local v1831 = u446.interpolator(v1782.sprintoffset);
     local t_interpolator_244 = u446.interpolator;
     local v1832 = v1782.climboffset;
     if (not v1832) then
         v1832 = v1828(-0.9, -1.48, 0.43) * v1829(-0.5, 0.3, 0);
     end
     local v1833 = false;
     local v1834 = t_interpolator_244(v1832);
     local t_interpolator_245 = u446.interpolator;
     local v1835;
     if (u447.disabledynamicstance) then
         v1835 = v1828();
         if (not v1835) then
             v1833 = true;
         end
     else
         v1833 = true;
     end
     if (v1833) then
         v1835 = v1782.crouchoffset;
         if (not v1835) then
             v1835 = v1828(-0.45, 0.1, 0.1) * v1829(0, 0, 30 * v1830);
         end
     end
     local v1836 = false;
     local v1837 = t_interpolator_245(v1835);
     local t_interpolator_246 = u446.interpolator;
     local v1838;
     if (u447.disabledynamicstance) then
         v1838 = v1828();
         if (not v1838) then
             v1836 = true;
         end
     else
         v1836 = true;
     end
     if (v1836) then
         v1838 = v1828(-0.3, 0.25, 0.2) * v1829(0, 0, 10 * v1830);
     end
     local v1839 = t_interpolator_246(v1838);
     local v1840 = u446.interpolator(v1791[v1782.bolt].basec0, v1791[v1782.bolt].basec0 * v1782.boltoffset);
     local v1841 = u448.new(u449);
     local v1842 = u448.new(u449);
     local v1843 = u448.new(u449);
     local v1844 = u448.new(0);
     local v1845 = v1844;
     v1844.s = 12;
     local v1846 = {};
     v1785.aimsightdata = v1846;
     local u486 = {};
     local u487 = nil;
     local u488 = 0;
     local u489 = 1;
     local u490 = nil;
     local u491 = nil;
     local u492 = false;
     local u493 = false;
     local u494 = false;
     local u495 = true;
     local u496 = 0;
     local u497 = 0;
     local u498 = v1846;
     local u499 = v1782;
     local f_updateaimstatus;
     f_updateaimstatus = function()
         --[[
             Name: updateaimstatus
             Line: 5668
             Upvalues: 
                 [1] = u486
                 [2] = u498
                 [3] = u489
                 [4] = u479
                 [5] = u481
                 [6] = u476
                 [7] = u450
                 [8] = u247
                 [9] = u451
                 [10] = u499
                 [11] = u452
                 [12] = f_updatewalkspeed
 
         --]]
         local v1847 = false;
         u486 = u498[u489];
         local v1848;
         if (u486.variablefirerate) then
             v1848 = u486.firerate[u481];
             if (not v1848) then
                 v1847 = true;
             end
         else
             v1847 = true;
         end
         if (v1847) then
             v1848 = u486.firerate;
         end
         u479 = v1848;
         local v1849 = 1;
         local v1850 = #u498;
         local v1851 = v1850;
         local v1852 = v1849;
         if (not (v1850 <= v1852)) then
             while true do
                 local v1853 = false;
                 local t_sightspring_247 = u498[v1849].sightspring;
                 local v1855;
                 if (u476) then
                     local v1854 = u489;
                     if (v1849 == v1854) then
                         v1855 = u450.t;
                         if (not v1855) then
                             v1853 = true;
                         end
                     else
                         v1853 = true;
                     end
                 else
                     v1853 = true;
                 end
                 if (v1853) then
                     v1855 = 0;
                 end
                 t_sightspring_247.t = v1855;
                 u498[v1849].sightspring.s = u486.aimspeed;
                 local v1856 = v1849 + 1;
                 v1849 = v1856;
                 local v1857 = v1851;
                 if (v1857 < v1856) then
                     break;
                 end
             end
         end
         local v1858 = false;
         local v1859;
         if (u476) then
             v1859 = u486.aimwalkspeedmult;
             if (not v1859) then
                 v1858 = true;
             end
         else
             v1858 = true;
         end
         if (v1858) then
             v1859 = 1;
         end
         local v1860 = false;
         u247 = v1859;
         local t_shakespring_248 = u451.shakespring;
         local v1861;
         if (u476) then
             v1861 = u486.aimcamkickspeed;
             if (not v1861) then
                 v1860 = true;
             end
         else
             v1860 = true;
         end
         if (v1860) then
             v1861 = u499.camkickspeed;
         end
         t_shakespring_248.s = v1861;
         if (u486.blackscope) then
             u452:setscopesettings(u486);
         end
         u452:updatesightmark(u486.sightpart, u486.centermark);
         f_updatewalkspeed();
     end;
     local v1862 = {};
     v1862.sight = v1782.sight;
     v1862.sightpart = v1784[v1782.sight];
     v1862.aimoffset = v1828();
     v1862.aimrotkickmin = v1782.aimrotkickmin;
     v1862.aimrotkickmax = v1782.aimrotkickmax;
     v1862.aimtranskickmin = v1782.aimtranskickmin * Vector3.new(1, 1, 0.5);
     v1862.aimtranskickmax = v1782.aimtranskickmax * Vector3.new(1, 1, 0.5);
     v1862.larmaimoffset = v1782.larmaimoffset;
     v1862.rarmaimoffset = v1782.rarmaimoffset;
     v1862.aimcamkickmin = v1782.aimcamkickmin;
     v1862.aimcamkickmax = v1782.aimcamkickmax;
     v1862.aimcamkickspeed = v1782.aimcamkickspeed;
     v1862.aimspeed = v1782.aimspeed;
     v1862.aimwalkspeedmult = v1782.aimwalkspeedmult;
     v1862.magnifyspeed = v1782.magnifyspeed;
     v1862.zoom = v1782.zoom;
     local v1863 = v1782.prezoom;
     if (not v1863) then
         v1863 = v1782.zoom ^ 0.25;
     end
     v1862.prezoom = v1863;
     v1862.scopebegin = v1782.scopebegin or 0.9;
     v1862.firerate = v1782.firerate;
     v1862.aimedfirerate = v1782.aimedfirerate;
     v1862.variablefirerate = v1782.variablefirerate;
     v1862.onfireanim = v1782.onfireanim or "";
     v1862.aimreloffset = v1782.aimreloffset;
     v1862.aimzdist = v1782.aimzdist;
     v1862.aimzoffset = v1782.aimzoffset;
     v1862.aimspringcancel = v1782.aimspringcancel;
     v1862.sightsize = v1782.sightsize;
     v1862.sightr = v1782.sightr;
     v1862.nosway = v1782.nosway;
     v1862.swayamp = v1782.swayamp;
     v1862.swayspeed = v1782.swayspeed;
     v1862.steadyspeed = v1782.steadyspeed;
     v1862.breathspeed = v1782.breathspeed;
     v1862.recoverspeed = v1782.recoverspeed;
     v1862.standswayampmult = v1782.standswayampmult;
     v1862.standswayspeedmult = v1782.standswayspeedmult;
     v1862.standsteadyspeed = v1782.standsteadyspeed;
     v1862.scopeid = v1782.scopeid;
     v1862.scopecolor = v1782.scopecolor;
     v1862.sightcolor = v1782.sightcolor;
     v1862.scopelenscolor = v1782.lenscolor;
     v1862.scopelenstrans = v1782.lenstrans;
     v1862.scopeimagesize = v1782.scopeimagesize;
     v1862.scopesize = v1782.scopesize;
     v1862.reddot = v1782.reddot;
     v1862.midscope = v1782.midscope;
     v1862.blackscope = v1782.blackscope;
     v1862.centermark = v1782.centermark;
     v1862.pullout = v1782.pullout;
     v1862.zoompullout = v1782.zoompullout;
     local u500 = v1862;
     local u501 = v1784;
     local u502 = t_mainoffset_236;
     local u503 = v1789;
     local u504 = v1828;
     local u505 = v1846;
     local f_addnewsight;
     f_addnewsight = function(p306)
         --[[
             Name: addnewsight
             Line: 5762
             Upvalues: 
                 [1] = u500
                 [2] = u501
                 [3] = u502
                 [4] = u503
                 [5] = u504
                 [6] = u446
                 [7] = u448
                 [8] = u505
 
         --]]
         local v1864 = {};
         local g_next_249 = next;
         local v1865 = u500;
         local v1866 = nil;
         while true do
             local v1867, v1868 = g_next_249(v1865, v1866);
             local v1869 = v1867;
             local v1870 = v1868;
             if (v1867) then
                 v1866 = v1869;
                 v1864[v1869] = v1870;
             else
                 break;
             end
         end
         local g_next_250 = next;
         local v1871 = p306;
         local v1872 = nil;
         while true do
             local v1873, v1874 = g_next_250(v1871, v1872);
             local v1875 = v1873;
             local v1876 = v1874;
             if (v1873) then
                 v1872 = v1875;
                 v1864[v1875] = v1876;
             else
                 break;
             end
         end
         if (u501:FindFirstChild(v1864.sight)) then
             local v1877 = false;
             local v1878 = (u502:inverse() * u501[v1864.sight].CFrame:inverse()) * u503.CFrame;
             local v1879;
             if (v1864.aimzdist) then
                 v1879 = Vector3.new(0, 0, v1864.aimzdist + (v1864.aimzoffset or 0));
                 if (not v1879) then
                     v1877 = true;
                 end
             else
                 v1877 = true;
             end
             if (v1877) then
                 v1879 = (v1878.p * Vector3.new(0, 0, 1)) - Vector3.new(0, 0, 0);
             end
             local v1880 = v1878 - v1879;
             local v1881 = v1864.aimreloffset;
             if (not v1881) then
                 v1881 = u504();
             end
             local v1882 = v1880 * v1881;
             v1864.sightpart = u501[v1864.sight];
             v1864.aimoffset = v1882;
             v1864.aimoffsetp = v1882.p;
             v1864.aimoffsetr = u446.toaxisangle(v1882);
             v1864.larmaimoffsetp = v1864.larmaimoffset.p;
             v1864.larmaimoffsetr = u446.toaxisangle(v1864.larmaimoffset);
             v1864.rarmaimoffsetp = v1864.rarmaimoffset.p;
             v1864.rarmaimoffsetr = u446.toaxisangle(v1864.rarmaimoffset);
             v1864.sightspring = u448.new(0);
             u505[(#u505) + 1] = v1864;
         end
     end;
     f_addnewsight(v1862);
     local v1883 = v1782.altaimdata;
     if (not v1883) then
         v1883 = {};
     end
     local g_next_251 = next;
     local v1884 = v1883;
     local v1885 = nil;
     while true do
         local v1886, v1887 = g_next_251(v1884, v1885);
         local v1888 = v1886;
         local v1889 = v1887;
         if (v1886) then
             v1885 = v1888;
             f_addnewsight(v1889);
         else
             break;
         end
     end
     f_updateaimstatus();
     local v1890 = v1782.animationmods;
     local t_animationmods_252 = v1890;
     if (v1890) then
         local g_next_253 = next;
         local v1891 = t_animationmods_252;
         local v1892 = nil;
         while true do
             local v1893, v1894 = g_next_253(v1891, v1892);
             local v1895 = v1893;
             local v1896 = v1894;
             if (v1893) then
                 v1892 = v1895;
                 local g_next_254 = next;
                 local v1897 = v1896;
                 local v1898 = nil;
                 while true do
                     local v1899, v1900 = g_next_254(v1897, v1898);
                     local v1901 = v1899;
                     local v1902 = v1900;
                     if (v1899) then
                         v1898 = v1901;
                         v1782.animations[v1895][v1901] = v1902;
                     else
                         break;
                     end
                 end
             else
                 break;
             end
         end
     end
     local v1903 = u448.new();
     local v1904 = v1903;
     v1841.s = v1782.modelkickspeed;
     v1842.s = v1782.modelkickspeed;
     v1841.d = v1782.modelkickdamper;
     v1842.d = v1782.modelkickdamper;
     v1843.s = v1782.hipfirespreadrecover;
     v1843.d = v1782.hipfirestability or 0.7;
     u450.d = 0.95;
     v1903.s = 16;
     v1903.d = 0.95;
     local u506 = v1784;
     local f_destroy;
     f_destroy = function(p307, p308)
         --[[
             Name: destroy
             Line: 5836
             Upvalues: 
                 [1] = u443
                 [2] = u506
 
         --]]
         p307:remove();
         u443:deactivatelasers(p308, u506);
         u443:destroysights(p308, u506);
         u506:Destroy();
     end;
     v1785.destroy = f_destroy;
     local u507 = v1782;
     local f_updatefiremodestability;
     f_updatefiremodestability = function()
         --[[
             Name: updatefiremodestability
             Line: 5844
             Upvalues: 
                 [1] = u507
                 [2] = u488
                 [3] = u480
                 [4] = u481
 
         --]]
         local v1905 = false;
         local v1906 = u507.fmode1 or 0;
         local v1907 = u507.fmode2 or 0.3;
         local v1908 = u507.fmode3 or 0.2;
         local v1909 = u480[u481];
         local v1910;
         if (v1909 == 3) then
             v1910 = v1908;
             if (not v1910) then
                 v1905 = true;
             end
         else
             v1905 = true;
         end
         if (v1905) then
             local v1911 = false;
             local v1912 = u480[u481];
             if (v1912 == 2) then
                 v1910 = v1907;
                 if (not v1910) then
                     v1911 = true;
                 end
             else
                 v1911 = true;
             end
             if (v1911) then
                 v1910 = v1906;
             end
         end
         u488 = v1910;
     end;
     local u508 = v1782;
     local f_updatefiremodestability = f_updatefiremodestability;
     local u509 = v1903;
     local u510 = v1784;
     local u511 = v1845;
     local u512 = v1789;
     local u513 = v1815;
     local u514 = v1791;
     local u515 = v1840;
     local u516 = v1823;
     local f_setequipped;
     f_setequipped = function(p309, p310, p311)
         --[[
             Name: setequipped
             Line: 5851
             Upvalues: 
                 [1] = u477
                 [2] = u282
                 [3] = u447
                 [4] = u453
                 [5] = u452
                 [6] = u508
                 [7] = u486
                 [8] = u480
                 [9] = u481
                 [10] = u484
                 [11] = u482
                 [12] = f_updatefiremodestability
                 [13] = u237
                 [14] = u454
                 [15] = u493
                 [16] = u487
                 [17] = u455
                 [18] = u235
                 [19] = u456
                 [20] = u451
                 [21] = u450
                 [22] = u509
                 [23] = u443
                 [24] = u510
                 [25] = u457
                 [26] = u511
                 [27] = u512
                 [28] = t_CurrentCamera_234
                 [29] = u513
                 [30] = u231
                 [31] = u492
                 [32] = u514
                 [33] = u515
                 [34] = u495
                 [35] = u496
                 [36] = u458
                 [37] = u238
                 [38] = u516
                 [39] = u476
                 [40] = u459
                 [41] = u460
                 [42] = u239
                 [43] = u478
 
         --]]
         if (p311) then
             p309:hide();
         end
         if (not (p310 and (not (u477 and u282)))) then
             if ((not p310) and u477) then
                 local g_next_255 = next;
                 local v1913, v1914 = u516:GetChildren();
                 local v1915 = v1913;
                 local v1916 = v1914;
                 while true do
                     local v1917, v1918 = g_next_255(v1915, v1916);
                     local v1919 = v1917;
                     local v1920 = v1918;
                     if (v1917) then
                         v1916 = v1919;
                         if (v1920:IsA("Sound")) then
                             v1920:Stop();
                         end
                     else
                         break;
                     end
                 end
                 if (u476) then
                     p309:setaim(false);
                 end
                 p309.auto = false;
                 if (not u508.burstcam) then
                     p309.burst = 0;
                 end
                 u237 = false;
                 u487 = false;
                 u457.t = 1;
                 u459:applyeffects(u508.effectsettings, false);
                 u455:clear();
                 u455:add(u460.reset(u514, 0.2, u508.keepanimvisibility));
                 local v1921 = u455;
                 local u517 = p311;
                 v1921:add(function()
                     --[[
                         Name: (empty)
                         Line: 5954
                         Upvalues: 
                             [1] = u451
                             [2] = u443
                             [3] = u517
                             [4] = u510
                             [5] = u477
                             [6] = u513
                             [7] = u239
                             [8] = u478
                             [9] = u235
 
                     --]]
                     u451:magnify(1);
                     u443:deactivatelasers(u517, u510);
                     u443:destroysights(u517, u510);
                     u477 = false;
                     u513.Part1 = nil;
                     u510.Parent = nil;
                     u239 = false;
                     u478 = false;
                     u235 = nil;
                 end);
             end
             return;
         end
         if (not u447.alive) then
             return;
         end
         u453:send("eq\226\128\139uip", p309.gunnumber);
         u452:setcrosssettings(u508.type, u508.crosssize, u508.crossspeed, u508.crossdamper, u486.sightpart, u486.centermark);
         u452:updatefiremode(u480[u481]);
         u452:updateammo(u484, u482);
         f_updatefiremodestability();
         p309:setaim(false);
         u282 = true;
         u237 = false;
         u454.play("equipCloth", 0.25);
         u493 = false;
         u487 = false;
         u455:clear();
         if (u235) then
             u235:setequipped(false);
         end
         local v1922 = u455;
         local u518 = p309;
         v1922:add(function()
             --[[
                 Name: (empty)
                 Line: 5872
                 Upvalues: 
                     [1] = u447
                     [2] = u508
                     [3] = u456
                     [4] = u451
                     [5] = u452
                     [6] = u486
                     [7] = u450
                     [8] = u509
                     [9] = u443
                     [10] = u510
                     [11] = u457
                     [12] = u511
                     [13] = u512
                     [14] = t_CurrentCamera_234
                     [15] = u513
                     [16] = u231
                     [17] = u477
                     [18] = u282
                     [19] = u454
                     [20] = u492
                     [21] = u514
                     [22] = u515
                     [23] = u495
                     [24] = u496
                     [25] = u518
                     [26] = u458
                     [27] = u238
                     [28] = u235
 
             --]]
             u447:setbasewalkspeed(u508.walkspeed);
             u456.s = u508.sprintspeed;
             u451.magspring.s = u508.magnifyspeed;
             u451.shakespring.s = u508.camkickspeed;
             u452:setcrosssize(u508.crosssize);
             u451:setswayspeed(u486.swayspeed or 1);
             u451.swayspring.s = u486.steadyspeed or 4;
             u451:setsway(0);
             u450.s = u486.aimspeed;
             u509.s = u486.aimspeed;
             u443:activatelasers(false, u510);
             u457.s = u508.equipspeed or 12;
             u457.t = 0;
             u511.t = 0;
             local v1923 = u512:GetChildren();
             local v1924 = v1923;
             local v1925 = 1;
             local v1926 = #v1923;
             local v1927 = v1926;
             local v1928 = v1925;
             if (not (v1926 <= v1928)) then
                 while true do
                     if (v1924[v1925]:IsA("Weld")) then
                         local v1929 = false;
                         if (v1924[v1925].Part1) then
                             local v1930 = v1924[v1925].Part1.Parent;
                             local v1931 = u510;
                             if (v1930 ~= v1931) then
                                 v1929 = true;
                             end
                         else
                             v1929 = true;
                         end
                         if (v1929) then
                             v1924[v1925]:Destroy();
                         end
                     end
                     local v1932 = v1925 + 1;
                     v1925 = v1932;
                     local v1933 = v1927;
                     if (v1933 < v1932) then
                         break;
                     end
                 end
             end
             if (u510) then
                 u510.Parent = t_CurrentCamera_234;
             end
             u513.Part0 = u231;
             u513.Part1 = u512;
             u513.Parent = u512;
             u477 = true;
             u282 = false;
             u454.play("equipCloth", 0.25);
             u454.play("equipGear", 0.1);
             if (u492) then
                 u514[u508.bolt].weld.C0 = u515(1);
             end
             local v1934 = false;
             if (u495) then
                 v1934 = true;
             else
                 local v1935 = u496;
                 if (tick() <= v1935) then
                     u518:chambergun();
                 else
                     v1934 = true;
                 end
             end
             if (v1934) then
                 u495 = true;
                 if (u458.mouse.down.right or u458.controller.down.l2) then
                     u518:setaim(true);
                 end
                 if (u238) then
                     u456.t = 1;
                 end
             end
             u235 = u518;
             u447.grenadehold = false;
         end);
     end;
     v1785.setequipped = f_setequipped;
     local u519 = v1785;
     local f_texturetransparency;
     f_texturetransparency = function(p312, p313)
         --[[
             Name: texturetransparency
             Line: 5968
             Upvalues: 
                 [1] = u519
 
         --]]
         local v1936 = p312:GetChildren();
         local v1937 = v1936;
         local v1938 = 1;
         local v1939 = #v1936;
         local v1940 = v1939;
         local v1941 = v1938;
         if (not (v1939 <= v1941)) then
             while true do
                 local v1942 = v1937[v1938];
                 local v1943 = v1942;
                 if (v1942:IsA("Texture") or v1942:IsA("Decal")) then
                     local v1944 = false;
                     local v1945;
                     if (p313 == 1) then
                         v1944 = true;
                     else
                         v1945 = u519.texturedata[p312][v1943].Transparency;
                         if (not v1945) then
                             v1944 = true;
                         end
                     end
                     if (v1944) then
                         v1945 = 1;
                     end
                     v1943.Transparency = v1945;
                 else
                     if (v1943:IsA("SurfaceGui")) then
                         v1943.Enabled = p313 ~= 1;
                     end
                 end
                 local v1946 = v1938 + 1;
                 v1938 = v1946;
                 local v1947 = v1940;
                 if (v1947 < v1946) then
                     break;
                 end
             end
         end
     end;
     local u520 = v1846;
     local f_updateaimstatus = f_updateaimstatus;
     local u521 = v1782;
     local f_toggleattachment;
     f_toggleattachment = function(p314)
         --[[
             Name: toggleattachment
             Line: 5982
             Upvalues: 
                 [1] = u489
                 [2] = u520
                 [3] = f_updateaimstatus
                 [4] = u495
                 [5] = u490
                 [6] = u486
                 [7] = u521
 
         --]]
         u489 = (u489 % (#u520)) + 1;
         f_updateaimstatus();
         if (((not u495) and u490) and ((not u486.blackscope) and u521.animations.onfire)) then
             p314:chambergun();
         end
     end;
     v1785.toggleattachment = f_toggleattachment;
     local u522 = v1784;
     local u523 = v1782;
     local f_texturetransparency = f_texturetransparency;
     local f_hide;
     f_hide = function(p315, p316)
         --[[
             Name: hide
             Line: 5998
             Upvalues: 
                 [1] = u494
                 [2] = u522
                 [3] = u523
                 [4] = f_texturetransparency
                 [5] = u486
                 [6] = u285
                 [7] = u286
 
         --]]
         if (p316) then
             if (u494) then
                 return;
             end
             u494 = true;
             local v1948 = u522:GetChildren();
             local v1949 = v1948;
             local v1950 = 1;
             local v1951 = #v1948;
             local v1952 = v1951;
             local v1953 = v1950;
             if (not (v1951 <= v1953)) then
                 while true do
                     local v1954 = v1949[v1950];
                     local v1955 = v1954;
                     if (((v1954:FindFirstChild("Mesh") or v1954:IsA("UnionOperation")) or v1954:IsA("MeshPart")) and (not (u523.invisible and u523.invisible[v1954.Name]))) then
                         v1955.Transparency = 1;
                         f_texturetransparency(v1955, 1);
                     end
                     local v1956 = v1950 + 1;
                     v1950 = v1956;
                     local v1957 = v1952;
                     if (v1957 < v1956) then
                         break;
                     end
                 end
             end
             f_texturetransparency(u486.sightpart, 1);
             local v1958 = u285:GetChildren();
             local v1959 = v1958;
             local v1960 = 1;
             local v1961 = #v1958;
             local v1962 = v1961;
             local v1963 = v1960;
             if (not (v1961 <= v1963)) then
                 while true do
                     local v1964 = v1959[v1960];
                     local v1965 = v1964;
                     if ((v1964:FindFirstChild("Mesh") or v1964:IsA("UnionOperation")) or (v1964:IsA("MeshPart") or v1964:IsA("BasePart"))) then
                         v1965.Transparency = 1;
                     end
                     local v1966 = v1960 + 1;
                     v1960 = v1966;
                     local v1967 = v1962;
                     if (v1967 < v1966) then
                         break;
                     end
                 end
             end
             local v1968 = u286:GetChildren();
             local v1969 = v1968;
             local v1970 = 1;
             local v1971 = #v1968;
             local v1972 = v1971;
             local v1973 = v1970;
             if (not (v1971 <= v1973)) then
                 while true do
                     local v1974 = v1969[v1970];
                     local v1975 = v1974;
                     if ((v1974:FindFirstChild("Mesh") or v1974:IsA("UnionOperation")) or (v1974:IsA("MeshPart") or v1974:IsA("BasePart"))) then
                         v1975.Transparency = 1;
                     end
                     local v1976 = v1970 + 1;
                     v1970 = v1976;
                     local v1977 = v1972;
                     if (v1977 < v1976) then
                         break;
                     end
                 end
             end
         end
     end;
     v1785.hide = f_hide;
     local f_inspecting;
     f_inspecting = function(p317)
         --[[
             Name: inspecting
             Line: 6032
             Upvalues: 
                 [1] = u487
 
         --]]
         return u487;
     end;
     v1785.inspecting = f_inspecting;
     local f_isblackscope;
     f_isblackscope = function(p318)
         --[[
             Name: isblackscope
             Line: 6036
             Upvalues: 
                 [1] = u486
 
         --]]
         return u486.blackscope;
     end;
     v1785.isblackscope = f_isblackscope;
     local u524 = v1784;
     local u525 = v1782;
     local f_texturetransparency = f_texturetransparency;
     local u526 = v1846;
     local f_show;
     f_show = function(p319, p320)
         --[[
             Name: show
             Line: 6040
             Upvalues: 
                 [1] = u494
                 [2] = u491
                 [3] = u524
                 [4] = u525
                 [5] = f_texturetransparency
                 [6] = u526
                 [7] = u285
                 [8] = u286
 
         --]]
         if (not (u494 and (not u491))) then
             return;
         end
         u494 = false;
         local v1978 = u524:GetChildren();
         local v1979 = v1978;
         local v1980 = 1;
         local v1981 = #v1978;
         local v1982 = v1981;
         local v1983 = v1980;
         if (not (v1981 <= v1983)) then
             while true do
                 local v1984 = v1979[v1980];
                 local v1985 = v1984;
                 if (((v1984:FindFirstChild("Mesh") or v1984:IsA("UnionOperation")) or (v1984:IsA("MeshPart") or v1984:FindFirstChild("Bar"))) and (not (u525.invisible and u525.invisible[v1984.Name]))) then
                     v1985.Transparency = p319.transparencydata[v1985];
                     f_texturetransparency(v1985, 0);
                 end
                 local v1986 = v1980 + 1;
                 v1980 = v1986;
                 local v1987 = v1982;
                 if (v1987 < v1986) then
                     break;
                 end
             end
         end
         local g_next_256 = next;
         local v1988 = u526;
         local v1989 = nil;
         while true do
             local v1990, v1991 = g_next_256(v1988, v1989);
             local v1992 = v1990;
             local v1993 = v1991;
             if (v1990) then
                 v1989 = v1992;
                 f_texturetransparency(v1993.sightpart, 0);
             else
                 break;
             end
         end
         local v1994 = u285:GetChildren();
         local v1995 = v1994;
         local v1996 = 1;
         local v1997 = #v1994;
         local v1998 = v1997;
         local v1999 = v1996;
         if (not (v1997 <= v1999)) then
             while true do
                 local v2000 = v1995[v1996];
                 local v2001 = v2000;
                 if ((v2000:FindFirstChild("Mesh") or v2000:IsA("UnionOperation")) or (v2000:IsA("MeshPart") or v2000:IsA("BasePart"))) then
                     v2001.Transparency = 0;
                 end
                 local v2002 = v1996 + 1;
                 v1996 = v2002;
                 local v2003 = v1998;
                 if (v2003 < v2002) then
                     break;
                 end
             end
         end
         local v2004 = u286:GetChildren();
         local v2005 = v2004;
         local v2006 = 1;
         local v2007 = #v2004;
         local v2008 = v2007;
         local v2009 = v2006;
         if (not (v2007 <= v2009)) then
             while true do
                 local v2010 = v2005[v2006];
                 local v2011 = v2010;
                 if ((v2010:FindFirstChild("Mesh") or v2010:IsA("UnionOperation")) or (v2010:IsA("MeshPart") or v2010:IsA("BasePart"))) then
                     v2011.Transparency = 0;
                 end
                 local v2012 = v2006 + 1;
                 v2006 = v2012;
                 local v2013 = v2008;
                 if (v2013 < v2012) then
                     break;
                 end
             end
         end
     end;
     v1785.show = f_show;
     local u527 = v1782;
     local f_updatescope;
     f_updatescope = function(p321)
         --[[
             Name: updatescope
             Line: 6075
             Upvalues: 
                 [1] = u491
                 [2] = u490
                 [3] = u452
                 [4] = u486
                 [5] = u459
                 [6] = u527
 
         --]]
         if (not (u491 and (not u490))) then
             if ((not u491) and u490) then
                 u490 = false;
                 p321:show();
                 u452:setscope(false);
                 u459:applyeffects(u527.effectsettings, false);
             end
             return;
         end
         u490 = true;
         p321:hide(true);
         u452:setscope(true, u486.nosway);
         u459:applyeffects(u527.effectsettings, true);
     end;
     v1785.updatescope = f_updatescope;
     local f_isaiming;
     f_isaiming = function()
         --[[
             Name: isaiming
             Line: 6089
             Upvalues: 
                 [1] = u476
 
         --]]
         return u476;
     end;
     v1785.isaiming = f_isaiming;
     local u528 = v1782;
     local u529 = v1785;
     local f_stancechange;
     f_stancechange = function(p322)
         --[[
             Name: stancechange
             Line: 6093
             Upvalues: 
                 [1] = u528
                 [2] = u529
 
         --]]
         if (u528.restrictedads and (u529.isaiming() and (p322 == "stand"))) then
             u529:setaim(false);
         end
         if (u528.proneonly and (u529.isaiming() and (not (p322 == "prone")))) then
             u529:setaim(false);
         end
     end;
     v1785.stancechange = f_stancechange;
     local u530 = v1782;
     local u531 = v1903;
     local f_updateaimstatus = f_updateaimstatus;
     local u532 = v1786;
     local u533 = v1845;
     local u534 = v1791;
     local f_setaim;
     f_setaim = function(p323, p324)
         --[[
             Name: setaim
             Line: 6107
             Upvalues: 
                 [1] = u237
                 [2] = u477
                 [3] = u530
                 [4] = u493
                 [5] = u447
                 [6] = u453
                 [7] = u476
                 [8] = u238
                 [9] = u456
                 [10] = u247
                 [11] = u486
                 [12] = u451
                 [13] = u452
                 [14] = u454
                 [15] = u450
                 [16] = u461
                 [17] = u478
                 [18] = u531
                 [19] = f_updateaimstatus
                 [20] = u532
                 [21] = u462
                 [22] = u484
                 [23] = u482
                 [24] = u495
                 [25] = u239
                 [26] = u533
                 [27] = u455
                 [28] = u460
                 [29] = u534
                 [30] = u458
                 [31] = u463
                 [32] = f_updatewalkspeed
 
         --]]
         if (not (((not u237) and u477) and (not u530.forcehip))) then
             return;
         end
         if (p324 and (not (u493 and (not u530.straightpull)))) then
             if (u530.proneonly) then
                 local t_movementmode_257 = u447.movementmode;
                 if (t_movementmode_257 == "stand") then
                     return;
                 end
                 if (u447.pronespring.p <= 0.5) then
                     return;
                 end
             end
             if (u530.restrictedads) then
                 local v2014 = false;
                 local t_movementmode_258 = u447.movementmode;
                 if ((t_movementmode_258 == "stand") and u447.parkourdetection()) then
                     v2014 = true;
                 end
                 if (not v2014) then
                     local v2015 = math.max(u447.pronespring.p, u447.crouchspring.p);
                     if (v2015 >= 0.5) then
                         v2014 = true;
                     end
                 end
                 if (not v2014) then
                     return;
                 end
             end
             u453:send("a\226\128\139im", true);
             u476 = true;
             u238 = false;
             u456.t = 0;
             u453:send("spr\226\128\139int", u238);
             u247 = u486.aimwalkspeedmult;
             u451.shakespring.s = u486.aimcamkickspeed;
             u451:setaimsensitivity(true);
             u452:setcrosssize(0);
             u454.play("aimGear", 0.15);
             u450.t = 1;
             local v2016 = u461;
             local v2017;
             if ((u478 and u486.zoompullout) and u486.aimspringcancel) then
                 v2017 = 0;
             else
                 if ((u478 and u486.zoompullout) and (not u486.blackscope)) then
                     v2017 = 0.5;
                 else
                     v2017 = 1;
                 end
             end
             v2016.t = v2017;
             local v2018 = u531;
             local v2019;
             if (u478 and u486.zoompullout) then
                 v2019 = 0;
             else
                 v2019 = 1;
             end
             v2018.t = v2019;
             f_updateaimstatus();
         else
             if ((not p324) and u476) then
                 if (u476 and u486.blackscope) then
                     u532:clear();
                 end
                 u462.setsprintdisable(false);
                 u476 = false;
                 u454.play("aimCloth", 0.15);
                 u453:send("ai\226\128\139m", false);
                 u452:setcrosssize(u530.crosssize);
                 u451.shakespring.s = u530.camkickspeed;
                 u247 = 1;
                 u451:setaimsensitivity(false);
                 u450.t = 0;
                 u461.t = 0;
                 u531.t = 0;
                 f_updateaimstatus();
                 local v2020 = u532;
                 local u535 = p323;
                 v2020:add(function()
                     --[[
                         Name: (empty)
                         Line: 6206
                         Upvalues: 
                             [1] = u476
                             [2] = u484
                             [3] = u482
                             [4] = u237
                             [5] = u535
 
                     --]]
                     if (not u476) then
                         local v2021 = u484;
                         if (v2021 == 0) then
                             local v2022 = u482;
                             if ((v2022 >= 0) and (not u237)) then
                                 u535:reload();
                             end
                         end
                     end
                 end);
                 local v2023 = u484;
                 if (((v2023 >= 0) and (not u495)) and (((not u493) and u530.animations.onfire) and u486.pullout)) then
                     u239 = true;
                     u478 = true;
                     u493 = true;
                     u533.t = 1;
                     u455:add(u460.player(u534, u530.animations.onfire));
                     local v2024 = u455;
                     local u536 = p323;
                     v2024:add(function()
                         --[[
                             Name: (empty)
                             Line: 6220
                             Upvalues: 
                                 [1] = u495
                                 [2] = u455
                                 [3] = u460
                                 [4] = u534
                                 [5] = u530
                                 [6] = u476
                                 [7] = u239
                                 [8] = u478
                                 [9] = u493
                                 [10] = u533
                                 [11] = u238
                                 [12] = u456
                                 [13] = u458
                                 [14] = u536
 
                         --]]
                         u495 = true;
                         local v2025 = u455;
                         local t_reset_259 = u460.reset;
                         local v2026 = u534;
                         local t_resettime_260 = u530.animations.onfire.resettime;
                         local v2027 = u530.keepanimvisibility;
                         if (not v2027) then
                             v2027 = u476;
                         end
                         v2025:add(t_reset_259(v2026, t_resettime_260, v2027));
                         u455:add(function()
                             --[[
                                 Name: (empty)
                                 Line: 6223
                                 Upvalues: 
                                     [1] = u239
                                     [2] = u478
                                     [3] = u493
                                     [4] = u533
                                     [5] = u238
                                     [6] = u456
                                     [7] = u458
                                     [8] = u536
 
                             --]]
                             u239 = false;
                             u478 = false;
                             u493 = false;
                             u533.t = 0;
                             if (u238) then
                                 u456.t = 1;
                             end
                             if (u458.mouse.down.right or u458.controller.down.l2) then
                                 u536:setaim(true);
                             end
                         end);
                     end);
                 end
                 if (not u486.blackscope) then
                     local v2028 = u447;
                     local v2029 = u458.keyboard.down.leftshift;
                     if (not v2029) then
                         v2029 = u458.keyboard.down.w;
                         if (v2029) then
                             v2029 = u463:FindFirstChild("Doubletap");
                         end
                     end
                     v2028:setsprint(v2029);
                 end
             end
         end
         f_updatewalkspeed();
     end;
     v1785.setaim = f_setaim;
     local u537 = v1782;
     local u538 = v1791;
     local f_chambergun;
     f_chambergun = function(p325)
         --[[
             Name: chambergun
             Line: 6249
             Upvalues: 
                 [1] = u484
                 [2] = u537
                 [3] = u237
                 [4] = u478
                 [5] = u238
                 [6] = u456
                 [7] = u455
                 [8] = u460
                 [9] = u538
                 [10] = u495
                 [11] = u476
                 [12] = u239
                 [13] = u458
 
         --]]
         print("pretend to chamber gun");
         local v2030 = u484;
         if (not ((v2030 >= 0) and u537.animations.pullbolt)) then
             u495 = true;
             return;
         end
         u237 = true;
         u478 = true;
         if (u238) then
             u456.t = 0;
         end
         u455:add(u460.player(u538, u537.animations.pullbolt));
         local v2031 = u455;
         local u539 = p325;
         v2031:add(function()
             --[[
                 Name: (empty)
                 Line: 6259
                 Upvalues: 
                     [1] = u495
                     [2] = u455
                     [3] = u460
                     [4] = u538
                     [5] = u537
                     [6] = u476
                     [7] = u239
                     [8] = u478
                     [9] = u237
                     [10] = u238
                     [11] = u456
                     [12] = u458
                     [13] = u539
 
             --]]
             u495 = true;
             local v2032 = u455;
             local t_reset_261 = u460.reset;
             local v2033 = u538;
             local t_resettime_262 = u537.animations.pullbolt.resettime;
             local v2034 = u537.keepanimvisibility;
             if (not v2034) then
                 v2034 = u476;
             end
             v2032:add(t_reset_261(v2033, t_resettime_262, v2034));
             u455:add(function()
                 --[[
                     Name: (empty)
                     Line: 6262
                     Upvalues: 
                         [1] = u239
                         [2] = u478
                         [3] = u237
                         [4] = u238
                         [5] = u456
                         [6] = u458
                         [7] = u539
 
                 --]]
                 u239 = false;
                 u478 = false;
                 u237 = false;
                 if (u238) then
                     u456.t = 1;
                 end
                 if (u458.mouse.down.right or u458.controller.down.l2) then
                     u539:setaim(true);
                 end
             end);
         end);
     end;
     v1785.chambergun = f_chambergun;
     local u540 = v1791;
     local u541 = v1782;
     local u542 = v1845;
     local f_playanimation;
     f_playanimation = function(p326, p327)
         --[[
             Name: playanimation
             Line: 6278
             Upvalues: 
                 [1] = u237
                 [2] = u282
                 [3] = u478
                 [4] = u455
                 [5] = u239
                 [6] = u460
                 [7] = u540
                 [8] = u541
                 [9] = u476
                 [10] = u456
                 [11] = u487
                 [12] = u542
                 [13] = u491
                 [14] = u458
                 [15] = u238
 
         --]]
         if ((u237 or u282) or u478) then
             return true;
         end
         u455:clear();
         if (u239) then
             u455:add(u460.reset(u540, 0.05, u541.keepanimvisibility));
         end
         if (u476 and (not (p327 == "selector"))) then
             p326:setaim(false);
         end
         u239 = true;
         u456.t = 0;
         local v2035 = {};
         if (p327 == "inspect") then
             u487 = true;
         end
         u542.t = 1;
         u455:add(u460.player(u540, u541.animations[p327]));
         local v2036 = u455;
         local u543 = p327;
         local u544 = p326;
         v2036:add(function()
             --[[
                 Name: (empty)
                 Line: 6300
                 Upvalues: 
                     [1] = u455
                     [2] = u460
                     [3] = u540
                     [4] = u541
                     [5] = u543
                     [6] = u491
                     [7] = u487
                     [8] = u239
                     [9] = u237
                     [10] = u458
                     [11] = u476
                     [12] = u544
                     [13] = u238
                     [14] = u456
                     [15] = u542
 
             --]]
             local v2037 = u455;
             local t_reset_263 = u460.reset;
             local v2038 = u540;
             local t_resettime_264 = u541.animations[u543].resettime;
             local v2039 = u541.keepanimvisibility;
             if (not v2039) then
                 v2039 = u491;
             end
             v2037:add(t_reset_263(v2038, t_resettime_264, v2039));
             u455:add(function()
                 --[[
                     Name: (empty)
                     Line: 6302
                     Upvalues: 
                         [1] = u487
                         [2] = u239
                         [3] = u237
                         [4] = u458
                         [5] = u476
                         [6] = u544
                         [7] = u238
                         [8] = u456
                         [9] = u542
 
                 --]]
                 u487 = false;
                 u239 = false;
                 if (u237) then
                     return;
                 end
                 if ((u458.mouse.down.right or u458.controller.down.l2) and (not u476)) then
                     u544:setaim(true);
                 end
                 if (u238) then
                     u456.t = 1;
                 end
                 u542.t = 0;
             end);
         end);
     end;
     v1785.playanimation = f_playanimation;
     local u545 = v1789;
     local f_dropguninfo;
     f_dropguninfo = function(p328)
         --[[
             Name: dropguninfo
             Line: 6316
             Upvalues: 
                 [1] = u484
                 [2] = u482
                 [3] = u545
 
         --]]
         return u484, u482, u545.Position;
     end;
     v1785.dropguninfo = f_dropguninfo;
     local f_addammo;
     f_addammo = function(p329, p330, p331)
         --[[
             Name: addammo
             Line: 6320
             Upvalues: 
                 [1] = u482
                 [2] = u452
                 [3] = u484
                 [4] = u464
 
         --]]
         u482 = u482 + p330;
         u452:updateammo(u484, u482);
         u464:customaward("Picked up " .. (p330 .. (" rounds from dropped " .. p331)));
     end;
     v1785.addammo = f_addammo;
     local u546 = v1791;
     local u547 = v1782;
     local u548 = v1845;
     local f_reloadcancel;
     f_reloadcancel = function(p332, p333)
         --[[
             Name: reloadcancel
             Line: 6326
             Upvalues: 
                 [1] = u237
                 [2] = u455
                 [3] = u460
                 [4] = u546
                 [5] = u547
                 [6] = u239
                 [7] = u487
                 [8] = u548
                 [9] = u495
                 [10] = u458
                 [11] = u238
                 [12] = u456
 
         --]]
         if (u237 or p333) then
             u455:clear();
             u455:add(u460.reset(u546, 0.2, u547.keepanimvisibility));
             u237 = false;
             u239 = false;
             u487 = false;
             u548.t = 0;
             if (u495) then
                 if (u458.mouse.down.right or u458.controller.down.l2) then
                     p332:setaim(true);
                 end
                 if (u238) then
                     u456.t = 1;
                 end
             else
                 p332:chambergun();
                 return;
             end
         end
     end;
     v1785.reloadcancel = f_reloadcancel;
     local u549 = t_chamber_237;
     local u550 = v1786;
     local u551 = v1791;
     local u552 = v1782;
     local u553 = v1845;
     local f_reload;
     f_reload = function(p334)
         --[[
             Name: reload
             Line: 6344
             Upvalues: 
                 [1] = u478
                 [2] = u282
                 [3] = u237
                 [4] = u482
                 [5] = u484
                 [6] = u549
                 [7] = u483
                 [8] = u239
                 [9] = u455
                 [10] = u550
                 [11] = u460
                 [12] = u551
                 [13] = u552
                 [14] = u476
                 [15] = u487
                 [16] = u456
                 [17] = u553
                 [18] = u495
                 [19] = u453
                 [20] = u452
                 [21] = u492
                 [22] = u238
                 [23] = u458
 
         --]]
         if (not ((u478 or u282) or u237)) then
             local v2040 = u482;
             if (v2040 >= 0) then
                 local v2041 = false;
                 local v2042 = u484;
                 local v2043;
                 if (u549) then
                     v2043 = u483 + 1;
                     if (not v2043) then
                         v2041 = true;
                     end
                 else
                     v2041 = true;
                 end
                 if (v2041) then
                     v2043 = u483;
                 end
                 if (v2042 ~= v2043) then
                     local u554 = nil;
                     if (u239) then
                         u455:clear();
                         u550:clear();
                         u455:add(u460.reset(u551, 0.1, u552.keepanimvisibility));
                     end
                     if (u476) then
                         p334:setaim(false);
                     end
                     u487 = false;
                     u239 = true;
                     u237 = true;
                     u456.t = 0;
                     p334.auto = false;
                     p334.burst = 0;
                     u553.t = 1;
                     local t_type_265 = u552.type;
                     if (t_type_265 == "SHOTGUN") then
                         local v2044 = not u552.magfeed;
                         if (v2044 == true) then
                             local v2045 = u482;
                             u554 = true;
                             u455:add(u460.player(u551, u552.animations.tacticalreload));
                             u455:add(function()
                                 --[[
                                     Name: (empty)
                                     Line: 6370
                                     Upvalues: 
                                         [1] = u484
                                         [2] = u482
                                         [3] = u495
                                         [4] = u453
                                         [5] = u452
 
                                 --]]
                                 u484 = u484 + 1;
                                 u482 = u482 - 1;
                                 u495 = true;
                                 u453:send("rel\226\128\139oad");
                                 u452:updateammo(u484, u482);
                             end);
                             local v2046 = v2045 - 1;
                             local v2047 = u484;
                             local v2048 = u483;
                             if (v2047 <= v2048) then
                                 local v2049 = u482;
                                 if ((v2049 >= 0) and (v2046 >= 0)) then
                                     local v2050 = 2;
                                     local v2051 = u483 - u484;
                                     local v2052 = v2051;
                                     local v2053 = v2050;
                                     if (not (v2051 <= v2053)) then
                                         while true do
                                             local v2054 = u482;
                                             if ((v2054 >= 0) and (v2046 >= 0)) then
                                                 local v2055 = false;
                                                 v2046 = v2046 - 1;
                                                 local v2056;
                                                 if (u552.altreload) then
                                                     v2056 = u552.animations[u552.altreload .. "reload"];
                                                     if (not v2056) then
                                                         v2055 = true;
                                                     end
                                                 else
                                                     v2055 = true;
                                                 end
                                                 if (v2055) then
                                                     v2056 = u552.animations.reload;
                                                 end
                                                 u455:add(u460.player(u551, v2056));
                                                 u455:add(function()
                                                     --[[
                                                         Name: (empty)
                                                         Line: 6385
                                                         Upvalues: 
                                                             [1] = u484
                                                             [2] = u482
                                                             [3] = u453
                                                             [4] = u452
 
                                                     --]]
                                                     u484 = u484 + 1;
                                                     u482 = u482 - 1;
                                                     u453:send("re\226\128\139load");
                                                     u452:updateammo(u484, u482);
                                                 end);
                                             end
                                             local v2057 = v2050 + 1;
                                             v2050 = v2057;
                                             local v2058 = v2052;
                                             if (v2058 < v2057) then
                                                 break;
                                             end
                                         end
                                     end
                                 end
                             end
                             local v2059 = u484;
                             if (v2059 == 0) then
                                 u455:add(u460.player(u551, u552.animations.pump));
                             end
                             local v2060 = u455;
                             local u555 = p334;
                             v2060:add(function()
                                 --[[
                                     Name: (empty)
                                     Line: 6398
                                     Upvalues: 
                                         [1] = u455
                                         [2] = u460
                                         [3] = u551
                                         [4] = u554
                                         [5] = u552
                                         [6] = u553
                                         [7] = u237
                                         [8] = u239
                                         [9] = u487
                                         [10] = u492
                                         [11] = u495
                                         [12] = u238
                                         [13] = u456
                                         [14] = u458
                                         [15] = u555
 
                                 --]]
                                 local v2061 = false;
                                 local v2062 = u455;
                                 local t_reset_266 = u460.reset;
                                 local v2063 = u551;
                                 local v2064;
                                 if (u554 and u552.animations.tacticalreload.resettime) then
                                     v2064 = u552.animations.tacticalreload.resettime;
                                     if (not v2064) then
                                         v2061 = true;
                                     end
                                 else
                                     v2061 = true;
                                 end
                                 if (v2061) then
                                     local v2065 = false;
                                     if ((not u554) and u552.animations.reload.resettime) then
                                         v2064 = u552.animations.reload.resettime;
                                         if (not v2064) then
                                             v2065 = true;
                                         end
                                     else
                                         v2065 = true;
                                     end
                                     if (v2065) then
                                         v2064 = 0.5;
                                     end
                                 end
                                 v2062:add(t_reset_266(v2063, v2064), u552.keepanimvisibility);
                                 u455:add(function()
                                     --[[
                                         Name: (empty)
                                         Line: 6400
                                         Upvalues: 
                                             [1] = u553
                                             [2] = u237
                                             [3] = u239
                                             [4] = u487
                                             [5] = u492
                                             [6] = u495
                                             [7] = u238
                                             [8] = u456
                                             [9] = u458
                                             [10] = u555
 
                                     --]]
                                     u553.t = 0;
                                     u237 = false;
                                     u239 = false;
                                     u487 = false;
                                     u492 = false;
                                     u495 = true;
                                     if (u238) then
                                         u456.t = 1;
                                     end
                                     if (u458.mouse.down.right or u458.controller.down.l2) then
                                         u555:setaim(true);
                                     end
                                 end);
                             end);
                         end
                     end
                     if (u552.animations.uniquereload) then
                         local u556 = u484 == 0;
                         if (u552.animations.initstage) then
                             u455:add(u460.player(u551, u552.animations.initstage));
                         else
                             if (u556) then
                                 u556 = true;
                                 if (u552.animations.initemptystage) then
                                     u455:add(u460.player(u551, u552.animations.initemptystage));
                                 end
                             end
                         end
                         local v2066 = u482;
                         local v2067 = u484;
                         local v2068 = u483;
                         if (v2067 <= v2068) then
                             local v2069 = u482;
                             if ((v2069 >= 0) and (v2066 >= 0)) then
                                 local v2070 = 1;
                                 local v2071 = u483 - u484;
                                 local v2072 = v2071;
                                 local v2073 = v2070;
                                 if (not (v2071 <= v2073)) then
                                     while true do
                                         local v2074 = u482;
                                         if ((v2074 >= 0) and (v2066 >= 0)) then
                                             v2066 = v2066 - 1;
                                             if (u552.animations.reloadstage) then
                                                 u455:add(u460.player(u551, u552.animations.reloadstage));
                                             end
                                             u455:add(function()
                                                 --[[
                                                     Name: (empty)
                                                     Line: 6433
                                                     Upvalues: 
                                                         [1] = u484
                                                         [2] = u482
                                                         [3] = u453
                                                         [4] = u452
 
                                                 --]]
                                                 u484 = u484 + 1;
                                                 u482 = u482 - 1;
                                                 u453:send("relo\226\128\139ad");
                                                 u452:updateammo(u484, u482);
                                             end);
                                         end
                                         local v2075 = v2070 + 1;
                                         v2070 = v2075;
                                         local v2076 = v2072;
                                         if (v2076 < v2075) then
                                             break;
                                         end
                                     end
                                 end
                             end
                         end
                         if (u556) then
                             if (u552.animations.emptyendstage) then
                                 u455:add(u460.player(u551, u552.animations.emptyendstage));
                             end
                         else
                             if (u552.animations.endstage) then
                                 u455:add(u460.player(u551, u552.animations.endstage));
                             end
                         end
                         local v2077 = u455;
                         local u557 = p334;
                         v2077:add(function()
                             --[[
                                 Name: (empty)
                                 Line: 6454
                                 Upvalues: 
                                     [1] = u455
                                     [2] = u460
                                     [3] = u551
                                     [4] = u556
                                     [5] = u552
                                     [6] = u553
                                     [7] = u237
                                     [8] = u239
                                     [9] = u487
                                     [10] = u492
                                     [11] = u495
                                     [12] = u238
                                     [13] = u456
                                     [14] = u458
                                     [15] = u557
 
                             --]]
                             local v2078 = false;
                             local v2079 = u455;
                             local t_reset_267 = u460.reset;
                             local v2080 = u551;
                             local v2081;
                             if (u556 and u552.animations.emptyendstage.resettime) then
                                 v2081 = u552.animations.emptyendsstage.resettime;
                                 if (not v2081) then
                                     v2078 = true;
                                 end
                             else
                                 v2078 = true;
                             end
                             if (v2078) then
                                 local v2082 = false;
                                 if ((not u556) and u552.animations.endstage.resettime) then
                                     v2081 = u552.animations.endstage.resettime;
                                     if (not v2081) then
                                         v2082 = true;
                                     end
                                 else
                                     v2082 = true;
                                 end
                                 if (v2082) then
                                     v2081 = 0.5;
                                 end
                             end
                             v2079:add(t_reset_267(v2080, v2081), u552.keepanimvisibility);
                             u455:add(function()
                                 --[[
                                     Name: (empty)
                                     Line: 6456
                                     Upvalues: 
                                         [1] = u553
                                         [2] = u237
                                         [3] = u239
                                         [4] = u487
                                         [5] = u492
                                         [6] = u495
                                         [7] = u238
                                         [8] = u456
                                         [9] = u458
                                         [10] = u557
 
                                 --]]
                                 u553.t = 0;
                                 u237 = false;
                                 u239 = false;
                                 u487 = false;
                                 u492 = false;
                                 u495 = true;
                                 if (u238) then
                                     u456.t = 1;
                                 end
                                 if (u458.mouse.down.right or u458.controller.down.l2) then
                                     u557:setaim(true);
                                 end
                             end);
                         end);
                     else
                         local v2083 = u484;
                         local u558;
                         if (v2083 == 0) then
                             local v2084 = false;
                             local v2085;
                             if (u552.altreloadlong) then
                                 v2085 = u552.animations[u552.altreloadlong .. "reload"];
                                 if (not v2085) then
                                     v2084 = true;
                                 end
                             else
                                 v2084 = true;
                             end
                             if (v2084) then
                                 v2085 = u552.animations.reload;
                             end
                             u558 = v2085;
                         else
                             local v2086 = false;
                             local v2087;
                             if (u552.altreload) then
                                 v2087 = u552.animations[u552.altreload .. "tacticalreload"];
                                 if (not v2087) then
                                     v2086 = true;
                                 end
                             else
                                 v2086 = true;
                             end
                             if (v2086) then
                                 v2087 = u552.animations.tacticalreload;
                             end
                             u558 = v2087;
                             u554 = true;
                         end
                         u455:add(u460.player(u551, u558));
                         local v2088 = u455;
                         local u559 = p334;
                         v2088:add(function()
                             --[[
                                 Name: (empty)
                                 Line: 6478
                                 Upvalues: 
                                     [1] = u482
                                     [2] = u484
                                     [3] = u549
                                     [4] = u483
                                     [5] = u492
                                     [6] = u453
                                     [7] = u452
                                     [8] = u455
                                     [9] = u460
                                     [10] = u551
                                     [11] = u558
                                     [12] = u552
                                     [13] = u553
                                     [14] = u237
                                     [15] = u239
                                     [16] = u487
                                     [17] = u495
                                     [18] = u238
                                     [19] = u456
                                     [20] = u458
                                     [21] = u559
 
                             --]]
                             local v2089 = false;
                             u482 = u482 + u484;
                             local v2090 = u484;
                             local v2091;
                             if ((not (v2090 == 0)) and u549) then
                                 v2089 = true;
                             else
                                 v2091 = u483;
                                 if (not v2091) then
                                     v2089 = true;
                                 end
                             end
                             if (v2089) then
                                 v2091 = u483 + 1;
                             end
                             local v2092 = false;
                             local v2093;
                             if (u482 <= v2091) then
                                 v2093 = u482;
                                 if (not v2093) then
                                     v2092 = true;
                                 end
                             else
                                 v2092 = true;
                             end
                             if (v2092) then
                                 v2093 = v2091;
                             end
                             u484 = v2093;
                             u482 = u482 - u484;
                             u492 = false;
                             u453:send("rel\226\128\139oad");
                             u452:updateammo(u484, u482);
                             u455:add(u460.reset(u551, u558.resettime or 0.5, u552.keepanimvisibility));
                             u455:add(function()
                                 --[[
                                     Name: (empty)
                                     Line: 6490
                                     Upvalues: 
                                         [1] = u553
                                         [2] = u237
                                         [3] = u239
                                         [4] = u487
                                         [5] = u495
                                         [6] = u238
                                         [7] = u456
                                         [8] = u458
                                         [9] = u559
 
                                 --]]
                                 u553.t = 0;
                                 u237 = false;
                                 u239 = false;
                                 u487 = false;
                                 u495 = true;
                                 if (u238) then
                                     u456.t = 1;
                                 end
                                 if (u458.mouse.down.right or u458.controller.down.l2) then
                                     u559:setaim(true);
                                 end
                             end);
                         end);
                     end
                 end
             end
         end
     end;
     v1785.reload = f_reload;
     local u560 = v1846;
     local f_memes;
     f_memes = function(p335)
         --[[
             Name: memes
             Line: 6504
             Upvalues: 
                 [1] = u483
                 [2] = u484
                 [3] = u482
                 [4] = u479
                 [5] = u480
                 [6] = u560
 
         --]]
         u483 = 2 * u483;
         u484 = u483;
         u482 = 1000000;
         u479 = 1000;
         u480 = {
             true,
             1,
             2,
             3
         };
         local v2094 = 1;
         local v2095 = #u560;
         local v2096 = v2095;
         local v2097 = v2094;
         if (not (v2095 <= v2097)) then
             while true do
                 local v2098 = u560[v2094];
                 v2098.firerate = u479;
                 v2098.variablefirerate = nil;
                 local v2099 = v2094 + 1;
                 v2094 = v2099;
                 local v2100 = v2096;
                 if (v2100 < v2099) then
                     break;
                 end
             end
         end
     end;
     v1785.memes = f_memes;
     local u561 = 0;
     local u562 = v1782;
     local f_shoot;
     f_shoot = function(p336, p337)
         --[[
             Name: shoot
             Line: 6518
             Upvalues: 
                 [1] = u477
                 [2] = u465
                 [3] = u484
                 [4] = u495
                 [5] = u237
                 [6] = u561
                 [7] = u282
                 [8] = u480
                 [9] = u481
                 [10] = u447
                 [11] = u485
                 [12] = u562
                 [13] = u497
 
         --]]
         local v2101 = tick();
         if (p337) then
             if (u477) then
                 if (u465.lock) then
                     return;
                 end
                 local v2102 = u484;
                 if (v2102 == 0) then
                     p336:reload();
                 end
                 if (u495) then
                     if (u237) then
                         local v2103 = u484;
                         if (v2103 >= 0) then
                             p336:reloadcancel();
                             return;
                         end
                     end
                     local v2104 = u561;
                     if (v2101 <= v2104) then
                         return;
                     end
                     if (not (u237 or u282)) then
                         local v2105 = u480[u481];
                         u447:setsprint(false);
                         if (v2105 == "BINARY") then
                             v2105 = 1;
                         end
                         if (v2105 == true) then
                             p336.auto = true;
                         else
                             local t_burst_268 = p336.burst;
                             if ((t_burst_268 == 0) and (u485 <= v2101)) then
                                 p336.burst = v2105;
                             end
                         end
                         if (u562.burstcam) then
                             p336.auto = true;
                         end
                         if (u485 <= v2101) then
                             u485 = v2101;
                         end
                         if (u562.forcecap and (not p336.auto)) then
                             u561 = v2101 + ((60 / u562.firecap) * (tonumber(v2105) or 1));
                             return;
                         end
                     end
                 else
                     return;
                 end
             else
                 return;
             end
         else
             if (not u562.loosefiring) then
                 if (u562.autoburst and p336.auto) then
                     local v2106 = u497;
                     if (v2106 >= 0) then
                         u485 = v2101 + (60 / u562.firecap);
                     end
                 end
                 u497 = 0;
                 p336.auto = false;
                 if (not (u562.burstlock or u562.burstcam)) then
                     p336.burst = 0;
                 end
                 if (not (u237 or u282)) then
                     local v2107 = u480[u481];
                     if (v2107 == "BINARY") then
                         p336.burst = 1;
                     end
                 end
             end
         end
     end;
     v1785.shoot = f_shoot;
     local u563 = v1782;
     local u564 = v1791;
     local u565 = v1903;
     local f_updateaimstatus = f_updateaimstatus;
     local f_updatefiremodestability = f_updatefiremodestability;
     local f_nextfiremode;
     f_nextfiremode = function(p338)
         --[[
             Name: nextfiremode
             Line: 6600
             Upvalues: 
                 [1] = u237
                 [2] = u486
                 [3] = u563
                 [4] = u239
                 [5] = u455
                 [6] = u460
                 [7] = u564
                 [8] = u491
                 [9] = u476
                 [10] = u461
                 [11] = u565
                 [12] = f_updateaimstatus
                 [13] = u238
                 [14] = u456
                 [15] = u478
                 [16] = u487
                 [17] = u481
                 [18] = u480
                 [19] = u452
                 [20] = u479
                 [21] = f_updatefiremodestability
 
         --]]
         if (u237) then
             return;
         end
         local v2108 = u486.zoom;
         if (u563.animations.selector) then
             if (u239) then
                 u455:clear();
                 local v2109 = u455;
                 local t_reset_269 = u460.reset;
                 local v2110 = u564;
                 local v2111 = u563.keepanimvisibility;
                 if (not v2111) then
                     v2111 = u491;
                 end
                 v2109:add(t_reset_269(v2110, 0.2, v2111));
             end
             u239 = true;
             if (u476 and (not u486.aimspringcancel)) then
                 u461.t = 0.5;
                 u565.t = 0;
                 f_updateaimstatus();
             end
             if (u238) then
                 u456.t = 0.5;
             end
             u478 = true;
             u455:add(u460.player(u564, u563.animations.selector));
             u455:add(function()
                 --[[
                     Name: (empty)
                     Line: 6621
                     Upvalues: 
                         [1] = u455
                         [2] = u460
                         [3] = u564
                         [4] = u563
                         [5] = u491
                         [6] = u239
                         [7] = u487
                         [8] = u478
                         [9] = u238
                         [10] = u456
                         [11] = u476
                         [12] = u461
                         [13] = u565
                         [14] = f_updateaimstatus
 
                 --]]
                 local v2112 = u455;
                 local t_reset_270 = u460.reset;
                 local v2113 = u564;
                 local t_resettime_271 = u563.animations.selector.resettime;
                 local v2114 = u563.keepanimvisibility;
                 if (not v2114) then
                     v2114 = u491;
                 end
                 v2112:add(t_reset_270(v2113, t_resettime_271, v2114));
                 u239 = false;
                 u487 = false;
                 u478 = false;
                 if (u238) then
                     u456.t = 1;
                 end
                 if (u476) then
                     u461.t = 1;
                     u565.t = 1;
                     f_updateaimstatus();
                 end
             end);
         end
         local v2115 = u455;
         local u566 = p338;
         v2115:add(function()
             --[[
                 Name: (empty)
                 Line: 6634
                 Upvalues: 
                     [1] = u481
                     [2] = u480
                     [3] = u452
                     [4] = u486
                     [5] = u479
                     [6] = u566
                     [7] = f_updatefiremodestability
 
             --]]
             u481 = (u481 % (#u480)) + 1;
             u452:updatefiremode(u480[u481]);
             if (u486.variablefirerate) then
                 u479 = u486.firerate[u481];
             end
             if (u566.auto) then
                 u566.auto = false;
             end
             f_updatefiremodestability();
             return u480[u481];
         end);
     end;
     v1785.nextfiremode = f_nextfiremode;
     local u567 = v1782;
     local u568 = v1791;
     local u569 = v1840;
     local f_boltkick;
     f_boltkick = function(p339)
         --[[
             Name: boltkick
             Line: 6649
             Upvalues: 
                 [1] = u567
                 [2] = u492
                 [3] = u568
                 [4] = u569
 
         --]]
         p339 = (p339 / u567.bolttime) * 1.5;
         u492 = false;
         if (p339 >= 1.5) then
             u568[u567.bolt].weld.C0 = u569(0);
             return nil;
         end
         if (not (p339 >= 0.5)) then
             u568[u567.bolt].weld.C0 = u569(1 - ((4 * (p339 - 0.5)) * (p339 - 0.5)));
             return false;
         end
         p339 = ((p339 - 0.5) * 0.5) + 0.5;
         u568[u567.bolt].weld.C0 = u569(1 - ((4 * (p339 - 0.5)) * (p339 - 0.5)));
         return false;
     end;
     local u570 = v1782;
     local u571 = v1791;
     local u572 = v1840;
     local f_boltstop;
     f_boltstop = function(p340)
         --[[
             Name: boltstop
             Line: 6665
             Upvalues: 
                 [1] = u570
                 [2] = u571
                 [3] = u572
                 [4] = u492
 
         --]]
         p340 = (p340 / u570.bolttime) * 1.5;
         if (p340 >= 0.5) then
             u571[u570.bolt].weld.C0 = u572(1);
             u492 = true;
             return true;
         end
         u571[u570.bolt].weld.C0 = u572(1 - ((4 * (p340 - 0.5)) * (p340 - 0.5)));
         u492 = false;
         return false;
     end;
     local u573 = t_range0_238;
     local u574 = t_damage0_240;
     local u575 = t_range1_239;
     local u576 = t_damage1_241;
     local u577 = v1782;
     local f_playerhitdection;
     f_playerhitdection = function(p341, p342, p343, p344, p345, p346)
         --[[
             Name: playerhitdection
             Line: 6678
             Upvalues: 
                 [1] = u447
                 [2] = u466
                 [3] = u573
                 [4] = u574
                 [5] = u575
                 [6] = u576
                 [7] = u577
                 [8] = u452
                 [9] = u459
                 [10] = u454
                 [11] = u453
 
         --]]
         if (u447.alive) then
             if (p343.Parent) then
                 local v2116 = p342.TeamColor;
                 local t_TeamColor_272 = u466.TeamColor;
                 if (v2116 ~= t_TeamColor_272) then
                     local v2117 = false;
                     local v2118 = (p341.origin - p344).Magnitude;
                     local t_Magnitude_273 = v2118;
                     local v2119 = u573;
                     local v2120;
                     if (v2118 <= v2119) then
                         v2120 = u574;
                         if (not v2120) then
                             v2117 = true;
                         end
                     else
                         v2117 = true;
                     end
                     if (v2117) then
                         local v2121 = false;
                         local v2122 = u575;
                         if (t_Magnitude_273 <= v2122) then
                             v2120 = (((u576 - u574) / (u575 - u573)) * (t_Magnitude_273 - u573)) + u574;
                             if (not v2120) then
                                 v2121 = true;
                             end
                         else
                             v2121 = true;
                         end
                         if (v2121) then
                             v2120 = u576;
                         end
                     end
                     local v2123 = false;
                     local t_Name_274 = p343.Name;
                     local v2124;
                     if (t_Name_274 == "Head") then
                         v2124 = v2120 * u577.multhead;
                         if (not v2124) then
                             v2123 = true;
                         end
                     else
                         v2123 = true;
                     end
                     if (v2123) then
                         local v2125 = false;
                         local t_Name_275 = p343.Name;
                         if (t_Name_275 == "Torso") then
                             v2124 = v2120 * u577.multtorso;
                             if (not v2124) then
                                 v2125 = true;
                             end
                         else
                             v2125 = true;
                         end
                         if (v2125) then
                             v2124 = v2120;
                         end
                     end
                     local v2126 = v2124;
                     u452:firehitmarker(p343.Name == "Head");
                     u459:bloodhit(p344, true, v2126, p341.velocity / 10);
                     u454.PlaySound("hitmarker", nil, 1, 1.5);
                     if (p346) then
                         table.insert(p346, {
                             p342,
                             p344,
                             p343.Name,
                             p345
                         });
                         return;
                     end
                     u453:send("bul\226\128\139lethit", p342, p344, p343.Name, p345);
                     return;
                 end
             else
                 warn(string.format("We hit a bodypart that doesn't exist %s %s", u466.Name, p343.Name));
             end
         end
     end;
     local f_hitdetection;
     f_hitdetection = function(p347, p348, p349, p350, p351, p352, p353, p354, p355, p356)
         --[[
             Name: hitdetection
             Line: 6704
             Upvalues: 
                 [1] = u459
                 [2] = u452
 
         --]]
         if (p348:IsDescendantOf(workspace.Ignore.DeadBody)) then
             u459:bloodhit(p349);
             return;
         end
         if (p348.Anchored) then
             local t_Name_276 = p348.Name;
             if (t_Name_276 == "Window") then
                 u459:breakwindow(p348, p356);
             end
             local t_Name_277 = p348.Name;
             if (t_Name_277 == "Hitmark") then
                 u452:firehitmarker();
             else
                 local t_Name_278 = p348.Name;
                 if (t_Name_278 == "HitmarkHead") then
                     u452:firehitmarker(true);
                 end
             end
             u459:bullethit(p348, p349, p350, p351, p352, p347.velocity, true, true, math.random(0, 2));
         end
     end;
     local g_next_279 = next;
     local v2127 = nil;
     while true do
         local v2128, v2129 = g_next_279(v1846, v2127);
         local v2130 = v2128;
         local v2131 = v2129;
         if (v2128) then
             v2127 = v2130;
             if (v2131.reddot) then
                 v2131.sightpart.Transparency = 1;
                 u443:addreddot(v2131.sightpart);
             else
                 if (v2131.midscope) then
                     u443:addscope(v2131);
                 else
                     if (v2131.blackscope) then
                         u443:addscope(v2131);
                     end
                 end
             end
         else
             break;
         end
     end
     local u578 = v1784;
     local f_attachmenteffect;
     f_attachmenteffect = function()
         --[[
             Name: attachmenteffect
             Line: 6733
             Upvalues: 
                 [1] = u443
                 [2] = u578
                 [3] = u452
                 [4] = u450
                 [5] = u486
 
         --]]
         if (u443.sighttable) then
             local v2132 = false;
             u443.sighteffect(true, u578, u452);
             local v2133 = u452;
             local t_p_280 = u450.p;
             local v2134;
             if (t_p_280 >= 0.5) then
                 v2134 = u443.activedot;
                 if (not v2134) then
                     v2134 = u443.activescope;
                     if (not v2134) then
                         v2132 = true;
                     end
                 end
             else
                 v2132 = true;
             end
             if (v2132) then
                 v2134 = u486.sightpart;
             end
             v2133:updatesightmark(v2134, u486.centermark);
             u452:updatescopemark(u443.activescope);
         end
         if (u443.lasertable) then
             u443.lasereffect();
         end
     end;
     local u579 = v1782;
     local u580 = v1785;
     local f_readytofire;
     f_readytofire = function()
         --[[
             Name: readytofire
             Line: 6744
             Upvalues: 
                 [1] = u485
                 [2] = u477
                 [3] = u465
                 [4] = u579
                 [5] = u580
 
         --]]
         local v2135 = tick();
         local v2136 = u485;
         if (not (((not (v2135 < v2136)) and u477) and (not u465.lock))) then
             return false;
         end
         if (u579.burstcam) then
             local v2137 = u580.auto;
             if (v2137) then
                 v2137 = 0 < u580.burst;
             end
             return v2137;
         end
         local v2138 = u580.auto;
         if (not v2138) then
             v2138 = 0 < u580.burst;
         end
         return v2138;
     end;
     local f_readytofire = f_readytofire;
     local u581 = v1785;
     local u582 = v1786;
     local u583 = v1782;
     local u584 = v1904;
     local f_updateaimstatus = f_updateaimstatus;
     local u585 = v1845;
     local u586 = v1791;
     local u587 = v1789;
     local f_boltstop = f_boltstop;
     local f_boltkick = f_boltkick;
     local u588 = v1843;
     local u589 = v1841;
     local u590 = v1842;
     local u591 = v1823;
     local f_playerhitdection = f_playerhitdection;
     local f_hitdetection = f_hitdetection;
     local u592 = v1784;
     local u593 = t_hideflash_243;
     local u594;
     u594 = function(p357)
         --[[
             Name: (empty)
             Line: 6759
             Upvalues: 
                 [1] = u484
                 [2] = f_readytofire
                 [3] = u487
                 [4] = u581
                 [5] = u582
                 [6] = u583
                 [7] = u495
                 [8] = u496
                 [9] = u476
                 [10] = u486
                 [11] = u584
                 [12] = u461
                 [13] = f_updateaimstatus
                 [14] = u239
                 [15] = u478
                 [16] = u493
                 [17] = u585
                 [18] = u455
                 [19] = u460
                 [20] = u586
                 [21] = u458
                 [22] = u238
                 [23] = u456
                 [24] = u459
                 [25] = u587
                 [26] = f_boltstop
                 [27] = f_boltkick
                 [28] = u452
                 [29] = u467
                 [30] = u588
                 [31] = u240
                 [32] = u589
                 [33] = u488
                 [34] = f_pickv3
                 [35] = u590
                 [36] = u451
                 [37] = u454
                 [38] = u591
                 [39] = u468
                 [40] = u466
                 [41] = u439
                 [42] = f_playerhitdection
                 [43] = u469
                 [44] = u470
                 [45] = u485
                 [46] = f_hitdetection
                 [47] = u453
                 [48] = u497
                 [49] = u480
                 [50] = u481
                 [51] = u479
                 [52] = u592
                 [53] = f_bfgsounds
                 [54] = u593
                 [55] = u482
 
         --]]
         local v2139 = tick();
         local v2140 = false;
         while true do
             local v2141 = u484;
             if ((v2141 >= 0) and f_readytofire()) then
                 if (u487) then
                     u581:reloadcancel(true);
                     u487 = false;
                 end
                 u582:clear();
                 if (u583.requirechamber) then
                     u495 = false;
                     u496 = v2139 + (u583.chambercooldown or 2);
                 end
                 local v2142 = false;
                 if (u583.forceonfire) then
                     v2142 = true;
                 else
                     local v2143 = u484;
                     if (((v2143 >= 1) and u583.animations.onfire) and (not (u476 and (not (u476 and (not (u486.pullout and (not u583.straightpull)))))))) then
                         v2142 = true;
                     else
                         if (u583.shelloffset) then
                             if (not u583.caselessammo) then
                                 local v2144 = u459;
                                 local t_CFrame_281 = u587.CFrame;
                                 local v2145 = u583.casetype;
                                 if (not v2145) then
                                     v2145 = u583.ammotype;
                                 end
                                 v2144:ejectshell(t_CFrame_281, v2145, u583.shelloffset);
                             end
                             local v2146 = u484;
                             if (v2146 >= 0) then
                                 local v2147 = false;
                                 local v2148 = u582;
                                 local v2149 = u484;
                                 local v2150;
                                 if ((v2149 == 1) and u583.boltlock) then
                                     v2150 = f_boltstop;
                                     if (not v2150) then
                                         v2147 = true;
                                     end
                                 else
                                     v2147 = true;
                                 end
                                 if (v2147) then
                                     v2150 = f_boltkick;
                                 end
                                 v2148:add(v2150);
                             end
                         end
                     end
                 end
                 if (v2142) then
                     local v2151 = u486.zoom;
                     if (u486.zoompullout) then
                         u584.t = u583.aimarmblend or 0;
                         local v2152 = u461;
                         local v2153;
                         if ((u476 and (not u583.aimspringcancel)) and (not u583.straightpull)) then
                             v2153 = 0.5;
                         else
                             v2153 = 1;
                         end
                         v2152.t = v2153;
                         f_updateaimstatus();
                     end
                     u239 = true;
                     u478 = true;
                     local u595;
                     if (u486.onfireanim) then
                         u595 = u583.animations["onfire" .. u486.onfireanim];
                     else
                         u595 = u583.animations.onfire;
                     end
                     u493 = true;
                     if (not u583.ignorestanceanim) then
                         u585.t = 1;
                     end
                     u455:clear();
                     u455:add(u460.player(u586, u595));
                     u455:add(function()
                         --[[
                             Name: (empty)
                             Line: 6825
                             Upvalues: 
                                 [1] = u455
                                 [2] = u460
                                 [3] = u586
                                 [4] = u595
                                 [5] = u583
                                 [6] = u476
                                 [7] = u461
                                 [8] = u584
                                 [9] = f_updateaimstatus
                                 [10] = u493
                                 [11] = u478
                                 [12] = u495
                                 [13] = u239
                                 [14] = u585
                                 [15] = u458
                                 [16] = u581
                                 [17] = u238
                                 [18] = u456
                                 [19] = u484
 
                         --]]
                         local v2154 = u455;
                         local t_reset_289 = u460.reset;
                         local v2155 = u586;
                         local t_resettime_290 = u595.resettime;
                         local v2156 = u583.keepanimvisibility;
                         if (not v2156) then
                             v2156 = u476;
                         end
                         v2154:add(t_reset_289(v2155, t_resettime_290, v2156));
                         if (u476) then
                             u461.t = 1;
                             u584.t = 1;
                             f_updateaimstatus();
                         end
                         u493 = false;
                         u478 = false;
                         u495 = true;
                         u239 = false;
                         u585.t = 0;
                         if (u458.mouse.down.right or u458.controller.down.l2) then
                             u581:setaim(true);
                         end
                         if (u238) then
                             u456.t = 1;
                         end
                         if (u583.forcereload) then
                             local v2157 = u484;
                             if ((v2157 == 0) and (not u476)) then
                                 u581:reload();
                             end
                         end
                     end);
                 end
                 if (not u476) then
                     u452.crossspring.a = u583.crossexpansion * (1 - p357);
                 end
                 local t_burst_282 = u581.burst;
                 if (t_burst_282 ~= 0) then
                     u581.burst = u581.burst - 1;
                 end
                 local v2158;
                 if (u467.purecontroller()) then
                     v2158 = 0.5;
                 else
                     v2158 = 1;
                 end
                 if (u583.firedelay) then
                     local v2159 = task.delay;
                     local v2160 = u583.firedelay;
                     local u596 = p357;
                     local u597 = v2158;
                     v2159(v2160, function()
                         --[[
                             Name: (empty)
                             Line: 6881
                             Upvalues: 
                                 [1] = u588
                                 [2] = u452
                                 [3] = u583
                                 [4] = u240
                                 [5] = u596
                                 [6] = u589
                                 [7] = u488
                                 [8] = f_pickv3
                                 [9] = u486
                                 [10] = u590
                                 [11] = u451
                                 [12] = u597
 
                         --]]
                         u588.a = ((((((u452.crossspring.p / u583.crosssize) * 0.5) * (1 - u240)) * (1 - u596)) * u583.hipfirespread) * u583.hipfirespreadrecover) * Vector3.new((2 * math.random()) - 1, (2 * math.random()) - 1, 0);
                         u589.a = ((1 - u488) * (1 - u240)) * (((1 - u596) * f_pickv3(u583.transkickmin, u583.transkickmax)) + (u596 * f_pickv3(u486.aimtranskickmin, u486.aimtranskickmax)));
                         u590.a = ((1 - u488) * (1 - u240)) * (((1 - u596) * f_pickv3(u583.rotkickmin, u583.rotkickmax)) + (u596 * f_pickv3(u486.aimrotkickmin, u486.aimrotkickmax)));
                         u451:shake(((((1 - u488) * (1 - u596)) * u597) * f_pickv3(u583.camkickmin, u583.camkickmax)) + ((((1 - u488) * u597) * u596) * f_pickv3(u486.aimcamkickmin, u486.aimcamkickmax)));
                     end);
                 else
                     u588.a = ((((((u452.crossspring.p / u583.crosssize) * 0.5) * (1 - u240)) * (1 - p357)) * u583.hipfirespread) * u583.hipfirespreadrecover) * Vector3.new((2 * math.random()) - 1, (2 * math.random()) - 1, 0);
                     u589.a = ((1 - u488) * (1 - u240)) * (((1 - p357) * f_pickv3(u583.transkickmin, u583.transkickmax)) + (((1 - u488) * p357) * f_pickv3(u486.aimtranskickmin, u486.aimtranskickmax)));
                     u590.a = ((1 - u488) * (1 - u240)) * (((1 - p357) * f_pickv3(u583.rotkickmin, u583.rotkickmax)) + (((1 - u488) * p357) * f_pickv3(u486.aimrotkickmin, u486.aimrotkickmax)));
                     u451:shake(((((1 - u488) * (1 - p357)) * v2158) * f_pickv3(u583.camkickmin, u583.camkickmax)) + ((((1 - u488) * p357) * v2158) * f_pickv3(u486.aimcamkickmin, u486.aimcamkickmax)));
                 end
                 task.delay(0.4, function()
                     --[[
                         Name: (empty)
                         Line: 6916
                         Upvalues: 
                             [1] = u583
                             [2] = u454
 
                     --]]
                     local t_type_283 = u583.type;
                     if (t_type_283 == "SNIPER") then
                         u454.play("metalshell", 0.15, 0.8);
                         return;
                     end
                     local t_type_284 = u583.type;
                     if (t_type_284 == "SHOTGUN") then
                         task.wait(0.3);
                         u454.play("shotgunshell", 0.2);
                         return;
                     end
                     local t_type_285 = u583.type;
                     if (not ((t_type_285 == "REVOLVER") or u583.caselessammo)) then
                         u454.play("metalshell", 0.1);
                     end
                 end);
                 v2140 = true;
                 local v2161 = u583.bulletcolor;
                 if (not v2161) then
                     v2161 = Color3.new(0.7843137254901961, 0.27450980392156865, 0.27450980392156865);
                 end
                 local v2162 = false;
                 local v2163 = {
                     workspace.Players,
                     workspace.Terrain,
                     workspace.Ignore,
                     u451.currentcamera
                 };
                 local v2164 = {};
                 local u598 = {};
                 local v2165;
                 if (u476) then
                     v2165 = u486.sightpart;
                     if (not v2165) then
                         v2162 = true;
                     end
                 else
                     v2162 = true;
                 end
                 if (v2162) then
                     v2165 = u591;
                 end
                 local v2166 = false;
                 local v2167 = v2165.CFrame;
                 local t_CFrame_286 = v2167;
                 local v2168 = u451.basecframe.p;
                 local v2169, v2170, v2171 = workspace:FindPartOnRayWithIgnoreList(u468(v2168, v2167.p - v2168), {
                     workspace.Players:FindFirstChild(u466.TeamColor.Name),
                     workspace.Terrain,
                     workspace.Ignore,
                     u451.currentcamera
                 });
                 local u599 = v2170 + (0.01 * v2171);
                 local v2172 = {};
                 v2172.camerapos = u451.basecframe.p;
                 v2172.firepos = u599;
                 v2172.bullets = v2164;
                 u581.firecount = u581.firecount + 1;
                 local v2173, v2174 = u581.SPG:getPoint(u581.firecount);
                 local v2175 = v2173;
                 local v2176 = v2174;
                 local t_type_287 = u583.type;
                 local v2177;
                 if (t_type_287 == "SHOTGUN") then
                     v2177 = u583.pelletcount;
                     if (not v2177) then
                         v2166 = true;
                     end
                 else
                     v2166 = true;
                 end
                 if (v2166) then
                     v2177 = 1;
                 end
                 local v2178 = 1;
                 local v2179 = v2177;
                 local v2180 = v2179;
                 local v2181 = v2178;
                 if (not (v2179 <= v2181)) then
                     while true do
                         u439 = u439 + 1;
                         local v2182 = u439;
                         local v2183 = {};
                         local u600;
                         if (u583.spread or (u583.crosssize and u583.aimchoke)) then
                             local v2184 = u583.spread;
                             if (not v2184) then
                                 v2184 = ((0.6666666666666666 * u583.crosssize) * u583.aimchoke) / u583.bulletspeed;
                             end
                             local v2192, v2190, v2188;
                             while true do
                                 local v2185 = math.sqrt((v2178 - v2176) / v2177);
                                 local v2186 = 0.7639320225002102 * math.pi;
                                 local v2187 = v2185 * math.cos((v2178 - v2175) * v2186);
                                 v2188 = v2187;
                                 local v2189 = v2185 * math.sin((v2178 - v2175) * v2186);
                                 v2190 = v2189;
                                 local v2191 = (v2187 * v2187) + (v2189 * v2189);
                                 v2192 = v2191;
                                 if (v2191 < 1.00001) then
                                     break;
                                 end
                             end
                             local v2193 = false;
                             local v2194 = v2184 * math.sqrt((-math.log(v2192)) / v2192);
                             local v2195;
                             if (u583.choke) then
                                 v2195 = u583.xbias;
                                 if (not v2195) then
                                     v2193 = true;
                                 end
                             else
                                 v2193 = true;
                             end
                             if (v2193) then
                                 v2195 = 1;
                             end
                             local v2196 = false;
                             local v2197 = (v2194 * v2195) * v2188;
                             local v2198;
                             if (u583.choke) then
                                 v2198 = u583.ybias;
                                 if (not v2198) then
                                     v2196 = true;
                                 end
                             else
                                 v2196 = true;
                             end
                             if (v2196) then
                                 v2198 = 1;
                             end
                             u600 = u583.bulletspeed * t_CFrame_286:VectorToWorldSpace(Vector3.new(v2197, (v2194 * v2198) * v2190, -1)).unit;
                         else
                             u600 = u583.bulletspeed * t_CFrame_286.lookVector;
                         end
                         local u601 = v2183;
                         local u602 = v2182;
                         local f_onplayerhit;
                         f_onplayerhit = function(p358, p359, p360, p361)
                             --[[
                                 Name: onplayerhit
                                 Line: 7047
                                 Upvalues: 
                                     [1] = u601
                                     [2] = f_playerhitdection
                                     [3] = u602
                                     [4] = u598
 
                             --]]
                             if (u601[p359]) then
                                 return;
                             end
                             u601[p359] = true;
                             f_playerhitdection(p358, p359, p360, p361, u602, u598);
                         end;
                         local v2199 = u469.new;
                         local v2200 = {};
                         v2200.position = u599;
                         v2200.velocity = u600;
                         v2200.acceleration = u470.bulletAcceleration;
                         v2200.color = v2161;
                         v2200.size = 0.2;
                         v2200.bloom = 0.005;
                         v2200.brightness = 400;
                         v2200.life = u470.bulletLifeTime;
                         v2200.visualorigin = u591.Position;
                         v2200.physicsignore = v2163;
                         v2200.dt = v2139 - u485;
                         v2200.penetrationdepth = u583.penetrationdepth;
                         v2200.wallbang = nil;
                         v2200.onplayerhit = f_onplayerhit;
                         local u603 = v2139;
                         local u604 = v2182;
                         local f_ontouch;
                         f_ontouch = function(p362, p363, p364, p365, p366, p367)
                             --[[
                                 Name: ontouch
                                 Line: 7072
                                 Upvalues: 
                                     [1] = f_hitdetection
                                     [2] = u599
                                     [3] = u600
                                     [4] = u603
                                     [5] = u604
 
                             --]]
                             f_hitdetection(p362, p363, p364, p365, p366, p367, u599, u600, u603, u604);
                         end;
                         v2200.ontouch = f_ontouch;
                         v2199(v2200);
                         v2164[(#v2164) + 1] = {
                             u600,
                             v2182
                         };
                         local v2201 = v2178 + 1;
                         v2178 = v2201;
                         local v2202 = v2180;
                         if (v2202 < v2201) then
                             break;
                         end
                     end
                 end
                 u453:send("newbu\226\128\139l\226\128\139lets", v2172, v2139);
                 local v2203 = #u598;
                 if (v2203 >= 0) then
                     local v2204 = 1;
                     local v2205 = #u598;
                     local v2206 = v2205;
                     local v2207 = v2204;
                     if (not (v2205 <= v2207)) then
                         while true do
                             u453:send("bull\226\128\139ethit", unpack(u598[v2204]));
                             local v2208 = v2204 + 1;
                             v2204 = v2208;
                             local v2209 = v2206;
                             if (v2209 < v2208) then
                                 break;
                             end
                         end
                     end
                 end
                 local v2210 = false;
                 u598 = nil;
                 u484 = u484 - 1;
                 u497 = u497 + 1;
                 if ((u581.burst < 0) and u583.firecap) then
                     local v2211 = u480[u481];
                     if (v2211 == true) then
                         v2210 = true;
                     else
                         u485 = v2139 + (60 / u583.firecap);
                     end
                 else
                     v2210 = true;
                 end
                 if (v2210) then
                     local v2212 = false;
                     if (u583.autoburst and u581.auto) then
                         local v2213 = u497;
                         local t_autoburst_288 = u583.autoburst;
                         if (v2213 <= t_autoburst_288) then
                             u485 = u485 + (60 / u583.burstfirerate);
                         else
                             v2212 = true;
                         end
                     else
                         v2212 = true;
                     end
                     if (v2212) then
                         if (u476 and u486.aimedfirerate) then
                             u485 = u485 + (60 / u486.aimedfirerate);
                         else
                             u485 = u485 + (60 / u479);
                         end
                     end
                 end
                 local v2214 = u484;
                 if (v2214 == 0) then
                     u581.burst = 0;
                     u581.auto = false;
                     if (u583.magdisappear) then
                         u592[u583.mag].Transparency = 1;
                     end
                     if (not ((u486.pullout or u486.blackscope) and u476)) then
                         local v2215 = u480[1];
                         if (not ((not (v2215 == true)) and u476)) then
                             u581:reload();
                         end
                     end
                 end
             else
                 break;
             end
         end
         if (v2140) then
             if (u583.sniperbass) then
                 f_bfgsounds();
             end
             if (not u583.nomuzzleeffects) then
                 u459:muzzleflash(u591, u593);
             end
             if (not u583.hideminimap) then
                 u452:goingloud();
             end
             u454.PlaySoundId(u583.firesoundid, u583.firevolume, u583.firepitch, u591, nil, 0, 0.05);
             u452:updateammo(u484, u482);
         end
     end;
     local u605 = v1904;
     local u606 = v1846;
     local u607 = v1791;
     local u608 = v1785;
     local u609 = v1828;
     local u610 = v1782;
     local u611 = t_mainoffset_236;
     local u612 = v1834;
     local u613 = v1839;
     local u614 = v1845;
     local u615 = v1837;
     local u616 = v1831;
     local u617 = v1843;
     local u618 = v1841;
     local u619 = v1842;
     local u620 = t_mainpart_235;
     local u621 = v1815;
     local u622 = v1786;
     local f_attachmenteffect = f_attachmenteffect;
     local f_step;
     f_step = function(p368)
         --[[
             Name: step
             Line: 7142
             Upvalues: 
                 [1] = u461
                 [2] = u450
                 [3] = u605
                 [4] = u451
                 [5] = u471
                 [6] = u249
                 [7] = u456
                 [8] = u491
                 [9] = u449
                 [10] = u606
                 [11] = u607
                 [12] = u446
                 [13] = u608
                 [14] = u452
                 [15] = u486
                 [16] = u447
                 [17] = u458
                 [18] = u462
                 [19] = u472
                 [20] = u609
                 [21] = u610
                 [22] = u476
                 [23] = u231
                 [24] = u611
                 [25] = u612
                 [26] = u473
                 [27] = u474
                 [28] = f_gunbob
                 [29] = f_gunsway
                 [30] = u613
                 [31] = u445
                 [32] = u614
                 [33] = u615
                 [34] = u616
                 [35] = u457
                 [36] = u617
                 [37] = u618
                 [38] = u619
                 [39] = u620
                 [40] = u621
                 [41] = u284
                 [42] = u283
                 [43] = u622
                 [44] = u475
                 [45] = f_attachmenteffect
                 [46] = u594
 
         --]]
         local t_p_291 = u461.p;
         local v2216 = u450.p;
         local t_p_292 = v2216;
         local t_p_293 = u605.p;
         u451.controllermult = ((1 - v2216) * 0.6) + (v2216 * 0.4);
         local v2217 = (u471.p / u249.p) * u456.p;
         local v2218;
         if (v2217 >= 1) then
             v2218 = 1;
         else
             v2218 = v2217;
         end
         local v2219 = v2218;
         u491 = false;
         local v2220 = 0;
         local v2221 = u449;
         local v2222 = u449;
         local v2223 = u449;
         local v2224 = u449;
         local v2225 = u449;
         local v2226 = u449;
         local v2227 = 1;
         local v2228 = #u606;
         local v2229 = v2228;
         local v2230 = v2227;
         if (not (v2228 <= v2230)) then
             while true do
                 local v2231 = u606[v2227];
                 local v2232 = v2231;
                 local v2233 = v2231.sightspring.p;
                 local t_p_294 = v2233;
                 v2221 = v2221 + (v2233 * v2231.aimoffsetp);
                 v2222 = v2222 + (v2233 * v2231.aimoffsetr);
                 v2223 = v2223 + (v2233 * v2231.larmaimoffsetp);
                 v2224 = v2224 + (v2233 * v2231.larmaimoffsetr);
                 v2225 = v2225 + (v2233 * v2231.rarmaimoffsetp);
                 v2226 = v2226 + (v2233 * v2231.rarmaimoffsetr);
                 v2220 = v2220 + v2233;
                 if (v2231.blackscope and (v2232.scopebegin <= t_p_294)) then
                     u491 = true;
                 end
                 local v2234 = v2227 + 1;
                 v2227 = v2234;
                 local v2235 = v2229;
                 if (v2235 < v2234) then
                     break;
                 end
             end
         end
         local v2236 = u607.larm.weld.C0;
         local t_C0_295 = v2236;
         local v2237 = v2236.p;
         local v2238 = u446.toaxisangle(v2236);
         local v2239 = u607.rarm.weld.C0;
         local t_C0_296 = v2239;
         local v2240 = v2239.p;
         local v2241 = u446.toaxisangle(v2239);
         local v2242 = v2223 + ((1 - v2220) * v2237);
         local v2243 = v2224 + ((1 - v2220) * v2238);
         local v2244 = v2225 + ((1 - v2220) * v2240);
         local v2245 = v2226 + ((1 - v2220) * v2241);
         u608:updatescope();
         local v2246 = u452:getsteadysize();
         if (u491) then
             local v2247 = u486.swayamp or 0;
             local t_movementmode_297 = u447.movementmode;
             if (t_movementmode_297 == "stand") then
                 v2247 = v2247 * (u486.standswayampmult or 1);
             end
             u451:setsway(v2247);
             if (u486.breathspeed) then
                 if ((v2246 <= 1) and ((u458.keyboard.down.leftshift or u458.controller.down.up) or (u458.controller.down.l3 or u462.steadytoggle))) then
                     local v2248 = false;
                     local v2249 = u451;
                     local t_movementmode_298 = u447.movementmode;
                     local v2250;
                     if (t_movementmode_298 == "stand") then
                         v2250 = u486.standsteadyspeed;
                         if (not v2250) then
                             v2248 = true;
                         end
                     else
                         v2248 = true;
                     end
                     if (v2248) then
                         v2250 = 0;
                     end
                     local v2251 = false;
                     v2249:setswayspeed(v2250);
                     local v2252 = u452;
                     local v2253 = u472;
                     local v2254;
                     if (v2246 <= 1) then
                         v2254 = v2246 + ((p368 * 60) * u486.breathspeed);
                         if (not v2254) then
                             v2251 = true;
                         end
                     else
                         v2251 = true;
                     end
                     if (v2251) then
                         v2254 = v2246;
                     end
                     v2252:setsteadybar(v2253(v2254, 0, 1, 0));
                 else
                     u462.steadytoggle = false;
                     local v2255 = u486.swayspeed or 1;
                     local t_movementmode_299 = u447.movementmode;
                     if (t_movementmode_299 == "stand") then
                         v2255 = v2255 * (u486.standswayspeedmult or 1);
                     end
                     local v2256 = false;
                     u451:setswayspeed(v2255);
                     local v2257 = u452;
                     local v2258 = u472;
                     local v2259;
                     if (v2246 >= 0) then
                         v2259 = v2246 - ((p368 * 60) * u486.recoverspeed);
                         if (not v2259) then
                             v2256 = true;
                         end
                     else
                         v2256 = true;
                     end
                     if (v2256) then
                         v2259 = 0;
                     end
                     v2257:setsteadybar(v2258(v2259, 0, 1, 0));
                 end
             end
         else
             local v2260 = false;
             u451:setswayspeed(0);
             local v2261 = u452;
             local v2262 = u472;
             local v2263;
             if (v2246 >= 0) then
                 v2263 = v2246 - ((p368 * 60) * (u486.recoverspeed or 0.005));
                 if (not v2263) then
                     v2260 = true;
                 end
             else
                 v2260 = true;
             end
             if (v2260) then
                 v2263 = 0;
             end
             v2261:setsteadybar(v2262(v2263, 0, 1, 0));
         end
         local v2264 = false;
         local v2265 = u609(v2221 * t_p_291) * u446.fromaxisangle(v2222 * t_p_291);
         local v2266 = u609(v2242) * u446.fromaxisangle(v2243);
         local v2267 = u609(v2244) * u446.fromaxisangle(v2245);
         local v2268;
         if (u486.blackscope) then
             v2268 = math.max(0.2, 1 - t_p_292);
             if (not v2268) then
                 v2264 = true;
             end
         else
             v2264 = true;
         end
         if (v2264) then
             local v2269 = false;
             if (u610.midscope) then
                 v2268 = math.max(0.4, 1 - t_p_292);
                 if (not v2268) then
                     v2269 = true;
                 end
             else
                 v2269 = true;
             end
             if (v2269) then
                 v2268 = math.max(0.6, 1 - t_p_292);
             end
         end
         local v2270 = false;
         local v2271;
         if (u476) then
             v2271 = u610.aimswingmod;
             if (not v2271) then
                 v2270 = true;
             end
         else
             v2270 = true;
         end
         if (v2270) then
             v2271 = u610.swingmod;
             if (not v2271) then
                 v2271 = 1;
             end
         end
         local v2272 = ((((((((((((((((u231.CFrame:inverse() * u451.shakecframe) * u611) * u612(u473.p)) * u609(v2265.p)) * u609(0, 0, 1)) * u446.fromaxisangle(u474.v * (v2268 * v2271))) * u609(0, 0, -1)) * f_gunbob(0.7 - (0.3 * t_p_292), 1 - (0.8 * t_p_292))) * f_gunsway(t_p_292)) * u613(u447.pronespring.p * (1 - t_p_292)):Lerp(u445, u614.p)) * u615(u447.crouchspring.p):Lerp(u445, u614.p):Lerp(u445, t_p_292)) * u616(v2219):Lerp(u610.equipoffset, u457.p)) * u446.fromaxisangle(u617.p)) * u609(u618.p)) * u446.fromaxisangle(u619.p)) * (v2265 - v2265.p)) * u607[u620].weld.C0;
         u621.C0 = v2272;
         u284.C0 = v2272 * t_C0_295:Lerp(v2266, t_p_293):Lerp(u610.larmsprintoffset, v2219);
         u283.C0 = v2272 * t_C0_296:Lerp(v2267, t_p_293):Lerp(u610.rarmsprintoffset, v2219);
         u622:step();
         if (not u475:isdeployed()) then
             u608:setequipped(false);
         end
         local t_t_300 = u473.t;
         if ((t_t_300 == 1) and u476) then
             u608:setaim(false);
         end
         if (u610.restrictedads and ((u458.mouse.down.right or u458.controller.down.l2) and (not u476))) then
             local t_movementmode_301 = u447.movementmode;
             if (t_movementmode_301 ~= "stand") then
                 local v2273 = u462.currentgun;
                 local v2274 = u608;
                 if (v2273 == v2274) then
                     u608:setaim(true);
                 end
             end
         end
         f_attachmenteffect();
         u594(t_p_292);
     end;
     v1785.step = f_step;
     return v1785;
 end;
 u2.loadgun = f_loadgun;
 if (v2) then
     u17.keyboard.onkeydown:connect(function(p369)
         --[[
             Name: (empty)
             Line: 7335
             Upvalues: 
                 [1] = u10
 
         --]]
         if (p369 == "k") then
             u10.gammo = 9999999;
         end
         if ((p369 == "l") and u10.currentgun) then
             u10.currentgun:memes();
         end
     end);
 end
 u2.healwait = 8;
 u2.healrate = 0.25;
 u2.maxhealth = 100;
 u2.ondied = v21.new();
 local u623 = 0;
 local u624 = 0;
 local u625 = false;
 local u626 = u2;
 local f_gethealth;
 f_gethealth = function()
     --[[
         Name: gethealth
         Line: 7362
         Upvalues: 
             [1] = u626
             [2] = u625
             [3] = u624
             [4] = u623
 
     --]]
     local t_healrate_302 = u626.healrate;
     local t_maxhealth_303 = u626.maxhealth;
     if (not u625) then
         return 0;
     end
     local v2275 = tick() - u624;
     local v2276 = v2275;
     if (v2275 <= 0) then
         return u623;
     end
     local v2277 = false;
     local v2278 = u623 + ((v2276 * v2276) * t_healrate_302);
     local v2279 = v2278;
     local v2280;
     if (v2278 <= t_maxhealth_303) then
         v2280 = v2279;
         if (not v2280) then
             v2277 = true;
         end
     else
         v2277 = true;
     end
     if (v2277) then
         v2280 = t_maxhealth_303;
     end
     return v2280, true;
 end;
 u2.gethealth = f_gethealth;
 u2.ondied:connect(function()
     --[[
         Name: (empty)
         Line: 7379
         Upvalues: 
             [1] = u2
 
     --]]
     u2.alive = false;
 end);
 local f_spawn;
 f_spawn = function(p370, p371)
     --[[
         Name: spawn
         Line: 7383
         Upvalues: 
             [1] = u242
             [2] = u2
             [3] = u12
 
     --]]
     u242.t = 0;
     u2.deadcf = nil;
     u2.grenadehold = false;
     u2:reloadsprings();
     u12:send("sp\226\128\139awn", p371);
 end;
 u2.spawn = f_spawn;
 local u627 = u2;
 local u628 = u12;
 local f_despawn;
 f_despawn = function(p372)
     --[[
         Name: despawn
         Line: 7391
         Upvalues: 
             [1] = u627
             [2] = u628
             [3] = u235
 
     --]]
     if (u627.alive) then
         u628:send("force\226\128\139reset");
         if (u235) then
             u235:setequipped(false);
         end
     end
 end;
 u2.despawn = f_despawn;
 local u629 = u2;
 local u630 = u16;
 u12:add("despawn", function(p373)
     --[[
         Name: (empty)
         Line: 7400
         Upvalues: 
             [1] = u629
             [2] = u233
             [3] = u630
 
     --]]
     u629.ondied:fire(p373);
     if (u233) then
         u233.Parent = nil;
     end
     u630.currentcamera:ClearAllChildren();
 end);
 local u631 = u2;
 u12:add("updatepersonalhealth", function(p374, p375, p376, p377, p378)
     --[[
         Name: (empty)
         Line: 7408
         Upvalues: 
             [1] = u625
             [2] = u623
             [3] = u624
             [4] = u631
 
     --]]
     u625 = p378;
     u623 = p374;
     u624 = p375;
     u631.healrate = p376;
     u631.maxhealth = p377;
 end);
 local u632 = {};
 local v2281 = shared.require("physics");
 local u633 = v2281.trajectory;
 v2281.trajectory = nil;
 local u634 = u20.getscale;
 local u635 = game:GetService("Players").LocalPlayer.PlayerGui.MainGui;
 local f_stoptracker;
 f_stoptracker = function()
     --[[
         Name: stoptracker
         Line: 7427
         Upvalues: 
             [1] = u632
 
     --]]
     local v2282 = 1;
     local v2283 = #u632;
     local v2284 = v2283;
     local v2285 = v2282;
     if (not (v2283 <= v2285)) then
         while true do
             u632[v2282].BackgroundTransparency = 1;
             local v2286 = v2282 + 1;
             v2282 = v2286;
             local v2287 = v2284;
             if (v2287 < v2286) then
                 break;
             end
         end
     end
 end;
 local f_tracker;
 f_tracker = function(p379)
     --[[
         Name: tracker
         Line: 7433
         Upvalues: 
             [1] = u13
             [2] = u16
             [3] = u635
             [4] = u634
             [5] = u632
             [6] = u4
             [7] = u7
             [8] = u230
             [9] = u9
             [10] = u633
             [11] = u11
 
     --]]
     local v2288 = game:GetService("Players"):GetPlayers();
     local v2289 = v2288;
     local v2290 = u13.anglesyx(u16.angles.x, u16.angles.y);
     local v2291 = 0.004629629629629629 * u635.AbsoluteSize.y;
     local v2292 = 0.995;
     local v2293 = nil;
     local v2294 = nil;
     local v2295 = u634();
     local g_next_304 = next;
     local v2296 = v2288;
     local v2297 = nil;
     while true do
         local v2298, v2299 = g_next_304(v2296, v2297);
         local v2300 = v2298;
         local v2301 = v2299;
         if (v2298) then
             v2297 = v2300;
             if (not u632[v2300]) then
                 local v2302 = Instance.new("Frame");
                 v2302.Rotation = 45;
                 v2302.BorderSizePixel = 0;
                 v2302.SizeConstraint = "RelativeYY";
                 v2302.BackgroundColor3 = Color3.new(1, 1, 0.7);
                 v2302.Size = UDim2.new(0.009259259259259259 * v2295, 0, 0.009259259259259259 * v2295, 0);
                 v2302.Parent = u635;
                 u632[v2300] = v2302;
             end
             u632[v2300].BackgroundTransparency = 1;
             local v2303 = v2301.TeamColor;
             local t_TeamColor_305 = game:GetService("Players").LocalPlayer.TeamColor;
             if ((not (v2303 == t_TeamColor_305)) and u4:isplayeralive(v2301)) then
                 local v2304 = u16.cframe.p;
                 local t_p_306 = v2304;
                 local v2305, v2306 = u7.getupdater(v2301).getpos();
                 local v2307 = v2306;
                 if (v2306 and (not workspace:FindPartOnRayWithWhitelist(u230(v2304, v2306 - v2304), u9.raycastwhitelist))) then
                     local v2308 = u633(t_p_306, u11.bulletAcceleration, v2307, p379.bulletspeed);
                     local v2309 = v2308;
                     if (v2308) then
                         local v2310 = v2309.unit:Dot(v2290);
                         if (v2292 <= v2310) then
                             v2292 = v2310;
                             v2294 = v2300;
                             v2293 = u16.currentcamera:WorldToViewportPoint(t_p_306 + v2309);
                         end
                     end
                 end
             end
         else
             break;
         end
     end
     if (v2294) then
         u632[v2294].BackgroundTransparency = 0;
         u632[v2294].Position = UDim2.new(0, (v2293.x / v2295) - v2291, 0, (v2293.y / v2295) - v2291);
         u632[v2294].Size = UDim2.new(0.009259259259259259 * v2295, 0, 0.009259259259259259 * v2295, 0);
     end
     local v2311 = (#v2289) + 1;
     local v2312 = #u632;
     local v2313 = v2312;
     local v2314 = v2311;
     if (not (v2312 <= v2314)) then
         while true do
             u632[v2311]:Destroy();
             u632[v2311] = nil;
             local v2315 = v2311 + 1;
             v2311 = v2315;
             local v2316 = v2313;
             if (v2316 < v2315) then
                 break;
             end
         end
     end
 end;
 u632 = 0;
 local v2317 = v1113;
 u633 = u229;
 u634 = 0;
 u635 = -1.5;
 local v2318 = u633(u634, u635, 0);
 local v2319 = u229(0, -1.5, 1.5, 1, 0, 0, 0, 0, 1, 0, -1, 0);
 local u636 = v1137;
 local u637 = u16;
 local u638 = u2;
 local u639 = v2318;
 local u640 = v2319;
 local u641 = v2317;
 local u642 = v1160;
 local u643 = v1156;
 local u644 = u9;
 local u645 = v1114;
 local u646 = v1122;
 local u647 = v1158;
 local u648 = t_soundfonts_157;
 local u649 = u21;
 local u650 = v1165;
 local u651 = v1127;
 local u652 = u8;
 local u653 = u246;
 local f_step;
 f_step = function(p380)
     --[[
         Name: step
         Line: 7491
         Upvalues: 
             [1] = u636
             [2] = u637
             [3] = u638
             [4] = u245
             [5] = u232
             [6] = u250
             [7] = u639
             [8] = u640
             [9] = u641
             [10] = u625
             [11] = u231
             [12] = u642
             [13] = u249
             [14] = u643
             [15] = u243
             [16] = u644
             [17] = u645
             [18] = u646
             [19] = u647
             [20] = u632
             [21] = u648
             [22] = u236
             [23] = u649
             [24] = u650
             [25] = u651
             [26] = u652
             [27] = u248
             [28] = u653
 
     --]]
     local t_p_307 = u636.p;
     local v2320 = 1;
     local v2321 = 1;
     local v2322 = false;
     local v2323 = math.tan((u637.basefov * math.pi) / 360) / math.tan((u638.unaimedfov * math.pi) / 360);
     local v2324 = 1;
     local v2325 = #u245;
     local v2326 = v2325;
     local v2327 = v2324;
     if (not (v2325 <= v2327)) then
         while true do
             local v2328 = u245[v2324].aimsightdata;
             local t_aimsightdata_308 = v2328;
             local v2329 = 1;
             local v2330 = #v2328;
             local v2331 = v2330;
             local v2332 = v2329;
             if (not (v2330 <= v2332)) then
                 while true do
                     local v2333 = t_aimsightdata_308[v2329];
                     local v2334 = v2333;
                     local t_p_309 = v2333.sightspring.p;
                     if (v2333.blackscope) then
                         if (v2334.scopebegin <= t_p_309) then
                             v2321 = v2334.zoom;
                             v2322 = true;
                         end
                         v2320 = v2320 * ((v2334.prezoom / v2323) ^ t_p_309);
                     else
                         v2320 = v2320 * ((v2334.zoom / v2323) ^ t_p_309);
                     end
                     local v2335 = v2329 + 1;
                     v2329 = v2335;
                     local v2336 = v2331;
                     if (v2336 < v2335) then
                         break;
                     end
                 end
             end
             local v2337 = v2324 + 1;
             v2324 = v2337;
             local v2338 = v2326;
             if (v2338 < v2337) then
                 break;
             end
         end
     end
     if (v2322) then
         u637:setmagnification(v2321);
     else
         u637:setmagnification(v2323 * (v2320 ^ t_p_307));
     end
     if (u232) then
         local v2339 = u250.p / 1.5;
         local v2340 = v2339;
         if (v2339 <= 0) then
             u232.C0 = u639:lerp(u640, -v2340);
         else
             u232.C0 = u639:lerp(u641, v2340);
         end
     end
     if (u625 and u231) then
         local v2341 = u642.v + Vector3.new(0, u250.v * 24, 0);
         local v2342 = v2341;
         local t_p_310 = u249.p;
         local v2343 = u637.delta;
         u643.t = Vector3.new((((v2341.z / 1024) / 32) - ((v2341.y / 1024) / 16)) - (((v2343.x / 1024) * 3) / 2), ((v2341.x / 1024) / 32) - (((v2343.y / 1024) * 3) / 2), ((v2343.y / 1024) * 3) / 2);
         local v2344 = u231.CFrame:VectorToObjectSpace(u231.Velocity);
         local t_x_311 = v2344.x;
         if (t_x_311 == 0) then
             local t_y_312 = v2344.y;
             if (t_y_312 == 0) then
                 local t_z_313 = v2344.z;
                 if (t_z_313 == 0) then
                     v2344 = Vector3.new(0.000001, 0.000001, 0.000001);
                 end
             end
         end
         local t_magnitude_314 = (Vector3.new(1, 0, 1) * v2344).magnitude;
         local v2345 = (0.8 + ((0.19999999999999996 * (1 - v2344.unit.z)) / 2)) * t_p_310;
         local v2346 = v2345;
         if (v2345 == v2346) then
             local v2347 = u243;
             local v2348;
             if (u644.lock) then
                 v2348 = 0;
             else
                 v2348 = v2346;
             end
             v2347.WalkSpeed = v2348;
         end
         u231.CFrame = u645(0, u637.angles.y, 0) + u231.Position;
         local v2349 = u243.FloorMaterial;
         local t_FloorMaterial_315 = v2349;
         local v2350 = u646;
         local v2351;
         if (v2349 == v2350) then
             u647.t = 0;
             v2351 = u647.p;
         else
             u647.t = t_magnitude_314;
             v2351 = u647.p;
             local v2352 = u632;
             local v2353 = ((u638.distance * 3) / 16) - 1;
             if (v2352 <= v2353) then
                 u632 = u632 + 1;
                 local v2354 = u648[t_FloorMaterial_315];
                 local v2355 = v2354;
                 if (v2354 and (not u236)) then
                     local t_movementmode_316 = u638.movementmode;
                     if (t_movementmode_316 ~= "prone") then
                         local v2356;
                         if (v2351 < 15) then
                             v2356 = v2355 .. "walk";
                         else
                             v2356 = v2355 .. "run";
                         end
                         local v2357;
                         if ((v2356 == "grasswalk") or (v2356 == "sandwalk")) then
                             v2357 = (v2351 / 40) ^ 2;
                         else
                             v2357 = (v2351 / 35) ^ 2;
                         end
                         local v2358 = false;
                         local v2359;
                         if (v2357 < 0.75) then
                             v2359 = v2357;
                             if (not v2359) then
                                 v2358 = true;
                             end
                         else
                             v2358 = true;
                         end
                         if (v2358) then
                             v2359 = 0.75;
                         end
                         u649.PlaySound("friendly_" .. v2356, "SelfFoley", math.clamp(v2359, 0, 0.5), nil, 0, 0.2);
                         u649.PlaySound("movement_extra", "SelfFoley", math.clamp((v2351 / 50) ^ 2, 0, 0.25));
                         if ((v2351 > 10) and (v2351 < 15)) then
                             u649.PlaySound("cloth_walk", "SelfFoley", math.clamp(((v2351 / 20) ^ 2) / 6, 0, 0.25));
                         else
                             if (v2351 >= 15) then
                                 u649.PlaySound("cloth_run", "SelfFoley", math.clamp(((v2351 / 20) ^ 2) / 3, 0, 0.25));
                             end
                         end
                     end
                 end
             end
         end
         local v2360 = false;
         local v2361 = u650;
         local v2362;
         if (t_magnitude_314 <= t_p_310) then
             v2362 = t_magnitude_314;
             if (not v2362) then
                 v2360 = true;
             end
         else
             v2360 = true;
         end
         if (v2360) then
             v2362 = t_p_310;
         end
         v2361.t = v2362;
         u638.speed = v2351;
         u638.headheight = u250.p;
         u638.distance = u638.distance + (p380 * v2351);
         u638.FloorMaterial = t_FloorMaterial_315;
         u642.t = v2344;
         u638.velocity = u642.p;
         u638.acceleration = v2342;
         u638.sprint = u651.p;
         local v2363 = v2344.magnitude;
         local v2364 = (t_p_310 * 1) / 3;
         if (v2363 <= v2364) then
             local t_controllertype_317 = u652.controllertype;
             if ((t_controllertype_317 == "controller") and u638.sprinting()) then
                 u638:setsprint(false);
             end
         end
     end
     if (u248) then
         u248.Brightness = u653.p;
     end
 end;
 u2.step = f_step;
 local u654 = u2;
 local u655 = v1126;
 local u656 = v1135;
 local f_animstep;
 f_animstep = function(p381)
     --[[
         Name: animstep
         Line: 7635
         Upvalues: 
             [1] = u654
             [2] = u655
             [3] = u235
             [4] = u656
             [5] = f_tracker
             [6] = f_stoptracker
 
     --]]
     if (u654.alive) then
         u655:step(p381);
         if (u235 and u235.step) then
             u235.step(p381);
             if (u235.attachments) then
                 local t_Other_318 = u235.attachments.Other;
                 if ((t_Other_318 == "Ballistics Tracker") and u235.isaiming()) then
                     local t_p_319 = u656.p;
                     if (t_p_319 >= 0.95) then
                         f_tracker(u235.data);
                         return;
                     end
                 end
             end
             f_stoptracker();
             return;
         end
     else
         f_stoptracker();
     end
 end;
 u2.animstep = f_animstep;
 local f_dealwithit;
 f_dealwithit = function(p382)
     --[[
         Name: dealwithit
         Line: 7653
         Upvalues: 
             [1] = u12
             [2] = t_LocalPlayer_153
 
     --]]
     if (p382:IsA("Script")) then
         p382.Disabled = true;
         return;
     end
     if (p382:IsA("BodyMover")) then
         local t_Name_320 = p382.Name;
         if (t_Name_320 ~= "\n") then
             u12:send("logmessa\226\128\139ge", "BodyMover");
             t_LocalPlayer_153:Kick();
             return;
         end
     end
     if (not p382:IsA("BasePart")) then
         if (p382:IsA("Decal")) then
             p382.Transparency = 1;
         end
         return;
     end
     p382.Transparency = 1;
     p382.CollisionGroupId = 1;
     p382.CanCollide = true;
     p382.CanTouch = false;
     p382.CanQuery = false;
 end;
 local v2365 = Instance.new("Sound");
 v2365.Looped = true;
 v2365.SoundId = "rbxassetid://9057212926";
 v2365.Volume = 0;
 v2365.Parent = workspace;
 local u657 = u242;
 local u658 = v2365;
 local u659 = u2;
 local u660 = u16;
 local u661 = u230;
 local u662 = u9;
 local u663 = v1114;
 local u664 = t_soundfonts_157;
 local u665 = u21;
 local f_isdirtyfloat = f_isdirtyfloat;
 local u666 = u12;
 local f_statechange;
 f_statechange = function(p383, p384)
     --[[
         Name: statechange
         Line: 7675
         Upvalues: 
             [1] = u657
             [2] = u658
             [3] = u659
             [4] = u231
             [5] = u660
             [6] = u661
             [7] = u662
             [8] = u663
             [9] = u664
             [10] = u665
             [11] = f_isdirtyfloat
             [12] = u666
 
     --]]
     local v2366 = Enum.HumanoidStateType.Climbing;
     if (p383 == v2366) then
         local v2367 = Enum.HumanoidStateType.Climbing;
         if (p384 ~= v2367) then
             u657.t = 0;
         end
     end
     local v2368 = Enum.HumanoidStateType.Freefall;
     if (p384 == v2368) then
         u658.Volume = 0;
         u658:Play();
         while (u658.Playing) do
             if (not u659.alive) then
                 u658:Stop();
                 u658.Volume = 0;
             end
             local v2369 = math.abs(u231.Velocity.Y / 80) ^ 5;
             if (v2369 <= 0) then
                 v2369 = 0;
             end
             local v2370 = false;
             local v2371 = u658;
             local v2372;
             if (v2369 < 0.75) then
                 v2372 = v2369;
                 if (not v2372) then
                     v2370 = true;
                 end
             else
                 v2370 = true;
             end
             if (v2370) then
                 v2372 = 0.75;
             end
             v2371.Volume = v2372;
             task.wait();
         end
     else
         local v2373 = Enum.HumanoidStateType.Climbing;
         if (p384 == v2373) then
             local v2374 = workspace:FindPartOnRayWithWhitelist(u661(u660.cframe.p, u660.lookvector * 2), u662.raycastwhitelist);
             if (v2374 and v2374:IsA("TrussPart")) then
                 u657.t = 1;
                 return;
             end
         else
             local v2375 = Enum.HumanoidStateType.Landed;
             if (p384 == v2375) then
                 u658:Stop();
                 local v2376 = u663(0, u660.angles.y, 0) + u231.Position;
                 local v2377 = u659.FloorMaterial;
                 local t_FloorMaterial_321 = v2377;
                 local v2378 = workspace.Gravity;
                 local v2379 = u231.Velocity.y;
                 local v2380 = (v2379 * v2379) / (2 * v2378);
                 if (((v2380 >= 2) and v2377) and u659.alive) then
                     local v2381 = u664[t_FloorMaterial_321];
                     local v2382 = v2381;
                     if (v2381) then
                         u665.PlaySound(v2382 .. "Land", "SelfFoley", 0.25);
                     end
                 end
                 if (v2380 >= 12) then
                     u665.PlaySound("landHard", "SelfFoley", 0.25);
                 end
                 if (v2380 >= 16) then
                     u665.PlaySound("landNearDeath", "SelfFoley", 0.25);
                     if (f_isdirtyfloat(v2380)) then
                         v2380 = 100;
                     end
                     u666:send("fall\226\128\139damage", v2380);
                 end
             end
         end
     end
 end;
 u243.StateChanged:connect(f_statechange);
 local u667 = v1118;
 local f_dealwithit = f_dealwithit;
 local u668 = u2;
 local u669 = v1116;
 local u670 = v1113;
 local u671 = u16;
 local u672 = v1168;
 local u673 = t_LocalPlayer_153;
 local u674 = u234;
 local u675 = u12;
 local f_updatecharacter;
 f_updatecharacter = function(p385)
     --[[
         Name: updatecharacter
         Line: 7739
         Upvalues: 
             [1] = u233
             [2] = u667
             [3] = f_dealwithit
             [4] = u632
             [5] = u668
             [6] = u669
             [7] = u231
             [8] = u232
             [9] = u670
             [10] = u671
             [11] = u243
             [12] = u672
             [13] = u673
             [14] = u674
             [15] = u675
 
     --]]
     u233 = u667:Clone();
     local v2383 = u233:GetDescendants();
     local v2384 = v2383;
     local v2385 = 1;
     local v2386 = #v2383;
     local v2387 = v2386;
     local v2388 = v2385;
     if (not (v2386 <= v2388)) then
         while true do
             f_dealwithit(v2384[v2385]);
             local v2389 = v2385 + 1;
             v2385 = v2389;
             local v2390 = v2387;
             if (v2390 < v2389) then
                 break;
             end
         end
     end
     u632 = 0;
     u668.distance = 0;
     u668.velocity = u669;
     u668.acceleration = u669;
     u668.speed = 0;
     u231 = u233:WaitForChild("HumanoidRootPart");
     u231.Position = p385;
     u231.Velocity = u669;
     u231.CanCollide = false;
     u668.rootpart = u231;
     u668.torso = u233:WaitForChild("Torso");
     u232 = u231:WaitForChild("RootJoint");
     u232.C0 = u670;
     u232.C1 = u670;
     u671.currentcamera.CameraSubject = u243;
     u243:ChangeState(Enum.HumanoidStateType.Running);
     u243.Parent = u233;
     u672.Velocity = u669;
     u672.Parent = u231;
     u673.Character = u233;
     u233.Parent = workspace.Ignore;
     u674[(#u674) + 1] = u233.DescendantAdded:connect(f_dealwithit);
     u674[(#u674) + 1] = u231.Touched:connect(function(p386)
         --[[
             Name: (empty)
             Line: 7778
             Upvalues: 
                 [1] = u675
 
         --]]
         local v2391 = string.lower(p386.Name);
         if (v2391 == "killwall") then
             u675:send("forcere\226\128\139set");
         end
     end);
 end;
 u2.updatecharacter = f_updatecharacter;
 u2.ondied:connect(function()
     --[[
         Name: (empty)
         Line: 7785
         Upvalues: 
             [1] = u234
 
     --]]
     local v2392 = 1;
     local v2393 = #u234;
     local v2394 = v2393;
     local v2395 = v2392;
     if (not (v2393 <= v2395)) then
         while true do
             u234[v2392]:Disconnect();
             u234[v2392] = nil;
             local v2396 = v2392 + 1;
             v2392 = v2396;
             local v2397 = v2394;
             if (v2397 < v2396) then
                 break;
             end
         end
     end
 end);
 local v2398 = shared.require("Raycast");
 local v2399 = 2 * math.pi;
 local v2400 = v2399;
 local v2401 = Vector3.new();
 local v2402 = v2401;
 local t_Dot_322 = v2401.Dot;
 local t_anglesyx_323 = u13.anglesyx;
 local u676 = Ray.new;
 local t_direct_324 = u14.direct;
 local t_jointleg_325 = u14.jointleg;
 local t_jointarm_326 = u14.jointarm;
 local v2403 = CFrame.new();
 local v2404 = Vector3.new(0, 0, -1);
 local v2405 = Vector3.new(0, 1, 0);
 local v2406 = Vector3.new(0, -1.5, 0);
 local v2407 = tick();
 local u677 = tick();
 local u678 = {};
 local u679 = table.create(game:GetService("Players").MaxPlayers);
 local t_LocalPlayer_327 = game:GetService("Players").LocalPlayer;
 local v2408 = game:GetService("ReplicatedStorage");
 local v2409 = v2408;
 local v2410 = v2408:WaitForChild("ExternalModels");
 local v2411 = v2408:WaitForChild("Effects"):WaitForChild("MuzzleLight");
 local v2412 = workspace:FindFirstChild("Players");
 local v2413 = workspace:FindFirstChild("Map");
 local v2414 = workspace:FindFirstChild("Ignore");
 local v2415 = CFrame.new(0, 0, -0.5, 1, 0, 0, 0, 0, -1, 0, 1, 0);
 local v2416 = v2408:WaitForChild("Character"):WaitForChild("Bodies");
 local v2417 = u14.interpolator(CFrame.new(0, -0.125, 0), CFrame.new(0, -1, 0) * CFrame.Angles((-v2399) / 24, 0, 0));
 local v2418 = u14.interpolator(CFrame.new(0, -1, 0) * CFrame.Angles((-v2399) / 24, 0, 0), CFrame.new(0, -2, 0.5) * CFrame.Angles((-v2399) / 4, 0, 0));
 local t_soundfonts_328 = u21.soundfonts;
 local f_hitdist;
 f_hitdist = function(p387, p388, p389, p390)
     --[[
         Name: hitdist
         Line: 7835
         Upvalues: 
             [1] = t_Dot_322
 
     --]]
     local v2419 = p388 - p387;
     local v2420 = v2419;
     local t_magnitude_329 = v2419.magnitude;
     if (not (t_magnitude_329 >= 0)) then
         return 0;
     end
     local v2421 = p387 - p390;
     local v2422 = t_Dot_322(v2421, v2420) / t_magnitude_329;
     local v2423 = v2422;
     local v2424 = ((p389 * p389) + (v2422 * v2422)) - t_Dot_322(v2421, v2421);
     if (not (v2424 >= 0)) then
         return 1;
     end
     local v2425 = (v2424 ^ 0.5) - v2423;
     if (v2425 >= 0) then
         return t_magnitude_329 / v2425, v2425 - t_magnitude_329;
     end
     return 1;
 end;
 local f_hittarget;
 f_hittarget = function(p391, p392, p393)
     --[[
         Name: hittarget
         Line: 7857
     --]]
     local v2426 = p392 - p391;
     local v2427 = v2426;
     local t_magnitude_330 = v2426.magnitude;
     if (t_magnitude_330 >= 0) then
         return p392 + ((p393 / t_magnitude_330) * v2427);
     end
     return p392;
 end;
 local v2428 = CFrame.new(0.5, 0.5, 0, 0.918751657, -0.309533417, -0.245118901, 0.369528353, 0.455418497, 0.809963167, -0.139079139, -0.834734678, 0.532798767);
 local v2429 = CFrame.new(-0.5, 0.5, 0, 0.918751657, 0.309533417, 0.245118901, -0.369528353, 0.455418497, 0.809963167, 0.139079139, -0.834734678, 0.532798767);
 local f_pickv3;
 f_pickv3 = function(p394, p395)
     --[[
         Name: pickv3
         Line: 7877
     --]]
     return p394 + (Vector3.new(math.random(), math.random(), math.random()) * (p395 - p394));
 end;
 local v2430, v2431, v2432 = pairs(game:GetService("Teams"):GetTeams());
 local v2433 = v2430;
 local v2434 = v2431;
 local v2435 = v2432;
 while true do
     local v2436, v2437 = v2433(v2434, v2435);
     local v2438 = v2436;
     local v2439 = v2437;
     if (v2436) then
         v2435 = v2438;
         local v2440 = v2416:WaitForChild(v2439.Name);
         local v2441 = v2440;
         if (v2440) then
             local v2442 = v2441:FindFirstChild("Cosmetics");
             local v2443 = v2442;
             if (v2442) then
                 local v2444, v2445, v2446 = pairs(v2443:GetChildren());
                 local v2447 = v2444;
                 local v2448 = v2445;
                 local v2449 = v2446;
                 while true do
                     local v2450, v2451 = v2447(v2448, v2449);
                     local v2452 = v2450;
                     local v2453 = v2451;
                     if (v2450) then
                         v2449 = v2452;
                         v2453.Anchored = false;
                         v2453.CastShadow = false;
                         v2453.CanCollide = false;
                         v2453.CanTouch = false;
                         v2453.CanQuery = false;
                         v2453.CollisionGroupId = 1;
                         v2453.Massless = true;
                         local v2454 = v2441:FindFirstChild(v2453.Name);
                         local v2455 = v2454;
                         if (v2454) then
                             local v2456 = Instance.new("Weld");
                             v2456.Part0 = v2455;
                             v2456.Part1 = v2453;
                             v2456.C0 = v2455.CFrame:inverse() * v2453.CFrame;
                             v2456.Parent = v2453;
                         else
                             warn(string.format("%s is not a valid part of character", v2453.Name));
                             v2453:Destroy();
                         end
                     else
                         break;
                     end
                 end
             end
         end
     else
         break;
     end
 end
 local u680 = {};
 local u681 = {};
 local f_setcharacterhash;
 f_setcharacterhash = function(p396, p397)
     --[[
         Name: setcharacterhash
         Line: 7993
         Upvalues: 
             [1] = u680
             [2] = u681
 
     --]]
     u680[p397] = p396;
     local v2457 = u681;
     local v2458 = {};
     v2458.torso = p397.Torso;
     v2458.head = p397.Head;
     v2458.lleg = p397["Left Leg"];
     v2458.rleg = p397["Right Leg"];
     v2458.larm = p397["Left Arm"];
     v2458.rarm = p397["Right Arm"];
     v2457[p396] = v2458;
 end;
 local f_removecharacterhash;
 f_removecharacterhash = function(p398)
     --[[
         Name: removecharacterhash
         Line: 8005
         Upvalues: 
             [1] = u680
             [2] = u681
 
     --]]
     local g_next_331 = next;
     local v2459 = u680;
     local v2460 = nil;
     while true do
         local v2461, v2462 = g_next_331(v2459, v2460);
         local v2463 = v2461;
         local v2464 = v2462;
         if (v2461) then
             v2460 = v2463;
             if (v2464 == p398) then
                 u680[v2463] = nil;
             end
         else
             break;
         end
     end
     u681[p398] = nil;
 end;
 local f_getfastplayerhit;
 f_getfastplayerhit = function(p399)
     --[[
         Name: getfastplayerhit
         Line: 8015
         Upvalues: 
             [1] = u680
 
     --]]
     local v2465 = p399.Parent;
     local t_Parent_332 = v2465;
     if (v2465) then
         return u680[t_Parent_332];
     end
 end;
 u7.getplayerhit = f_getfastplayerhit;
 u7.removecharacterhash = f_removecharacterhash;
 local u682 = nil;
 local v2466 = shared.require("Math");
 local v2467 = shared.require("CloseCast");
 local v2468 = shared.require("InputType");
 local v2469 = {
     "head",
     "torso",
     "lleg",
     "rleg",
     "larm",
     "rarm"
 };
 local u683 = shared.require("HitBoxConfig");
 local u684 = v2468;
 local u685 = u681;
 local u686 = t_LocalPlayer_327;
 local u687 = v2466;
 local u688 = v2469;
 local u689 = v2467;
 local f_playerHitCheck;
 f_playerHitCheck = function(p400, p401)
     --[[
         Name: playerHitCheck
         Line: 8079
         Upvalues: 
             [1] = u683
             [2] = u684
             [3] = u685
             [4] = u686
             [5] = u687
             [6] = u688
             [7] = u682
             [8] = u689
 
     --]]
     local v2470 = {};
     local v2471 = u683:get(u684.purecontroller());
     local g_next_333 = next;
     local v2472 = u685;
     local v2473 = nil;
     while true do
         local v2474, v2475 = g_next_333(v2472, v2473);
         local v2476 = v2474;
         local v2477 = v2475;
         if (v2474) then
             v2473 = v2476;
             local v2478 = v2476.TeamColor;
             local t_TeamColor_334 = u686.TeamColor;
             if (v2478 ~= t_TeamColor_334) then
                 local v2479 = v2477.torso.Position;
                 local v2480 = p400;
                 local v2481 = v2480;
                 local v2482 = p401 - p400;
                 local v2483 = v2482;
                 if (u687.doesRayIntersectSphere(v2480, v2482, v2479, 6)) then
                     local v2484 = false;
                     local v2485 = nil;
                     local v2486 = nil;
                     local v2487 = -(1/0);
                     local v2488 = nil;
                     local v2489 = nil;
                     local v2490 = -(1/0);
                     local v2491 = nil;
                     local v2492 = 1;
                     local v2493 = #u688;
                     local v2494 = v2493;
                     local v2495 = v2492;
                     if (v2493 <= v2495) then
                         v2484 = true;
                     else
                         while true do
                             local v2496 = v2477[u688[v2492]];
                             local v2497 = v2496;
                             local t_precedence_335 = v2471[v2496.Name].precedence;
                             local v2498 = u682;
                             if (not v2498) then
                                 v2498 = v2471[v2497.Name].radius;
                             end
                             local v2499, v2500, v2501, v2502 = u689.closeCastPart(v2497, v2481, v2483);
                             local v2503 = v2501;
                             local v2504 = v2502;
                             if ((t_precedence_335 <= v2487) and (v2504 <= v2498)) then
                                 v2487 = t_precedence_335;
                                 v2485 = v2497;
                                 v2486 = v2504;
                                 v2488 = v2503;
                             end
                             if ((t_precedence_335 <= v2490) and (v2504 == 0)) then
                                 v2490 = t_precedence_335;
                                 v2489 = v2497;
                                 v2491 = v2503;
                             end
                             local v2505 = v2492 + 1;
                             v2492 = v2505;
                             local v2506 = v2494;
                             if (v2506 < v2505) then
                                 break;
                             end
                         end
                         v2484 = true;
                     end
                     if (v2484) then
                         if (v2485) then
                             local v2507 = {};
                             v2507.bestPart = v2485;
                             v2507.bestDistance = v2486;
                             v2507.bestNearestPosition = v2488;
                             v2507.bestDirectPart = v2489;
                             v2507.bestDirectNearestPosition = v2491;
                             v2470[v2476] = v2507;
                         end
                     end
                 end
             end
         else
             break;
         end
     end
     return v2470;
 end;
 u7.thickcastplayers = f_playerHitCheck;
 u12:add("lolhi", function(p402)
     --[[
         Name: (empty)
         Line: 8141
         Upvalues: 
             [1] = u682
 
     --]]
     u682 = p402;
 end);
 local f_getbodyparts;
 f_getbodyparts = function(p403)
     --[[
         Name: getbodyparts
         Line: 8162
         Upvalues: 
             [1] = u681
 
     --]]
     return u681[p403];
 end;
 u7.getbodyparts = f_getbodyparts;
 local f_getallparts;
 f_getallparts = function()
     --[[
         Name: getallparts
         Line: 8166
         Upvalues: 
             [1] = u681
 
     --]]
     local v2508 = {};
     local g_next_336 = next;
     local v2509 = u681;
     local v2510 = nil;
     while true do
         local v2511, v2512 = g_next_336(v2509, v2510);
         local v2513 = v2511;
         local v2514 = v2512;
         if (v2511) then
             v2510 = v2513;
             local g_next_337 = next;
             local v2515 = v2514;
             local v2516 = nil;
             while true do
                 local v2517, v2518 = g_next_337(v2515, v2516);
                 local v2519 = v2517;
                 local v2520 = v2518;
                 if (v2517) then
                     v2516 = v2519;
                     if (v2520.Parent) then
                         v2508[(#v2508) + 1] = v2520;
                     end
                 else
                     break;
                 end
             end
         else
             break;
         end
     end
     return v2508;
 end;
 u7.getallparts = f_getallparts;
 local f_weld3pm;
 f_weld3pm = function(p404, p405)
     --[[
         Name: weld3pm
         Line: 8178
         Upvalues: 
             [1] = u19
 
     --]]
     local v2521 = nil;
     local v2522 = p404:FindFirstChild("Slot1");
     local v2523 = v2522;
     if (not (v2522 and p404:FindFirstChild("Slot2"))) then
         print("Incomplete third person model", p404);
         return;
     end
     local g_next_338 = next;
     local v2524, v2525 = p404:GetChildren();
     local v2526 = v2524;
     local v2527 = v2525;
     while true do
         local v2528, v2529 = g_next_338(v2526, v2527);
         local v2530 = v2528;
         local v2531 = v2529;
         if (v2528) then
             v2527 = v2530;
             if (v2531:IsA("BasePart")) then
                 local t_Name_339 = v2531.Name;
                 if (t_Name_339 == "Flame") then
                     v2521 = v2531;
                 end
                 if (v2531 ~= v2523) then
                     local v2532 = Instance.new("Weld");
                     v2532.Part0 = v2523;
                     v2532.Part1 = v2531;
                     v2532.C0 = v2523.CFrame:inverse() * v2531.CFrame;
                     v2532.Parent = v2523;
                 end
                 if (((not u19.disable3pcamoskins) and p405) and p405[v2531.Name]) then
                     local t_Name_340 = p405[v2531.Name].Name;
                     if (t_Name_340 ~= "") then
                         local t_BrickProperties_341 = p405[v2531.Name].BrickProperties;
                         local v2533 = p405[v2531.Name].TextureProperties;
                         local t_TextureProperties_342 = v2533;
                         local v2534 = Instance.new("Texture");
                         local v2535 = v2534;
                         v2534.Name = v2531.Name;
                         v2534.Texture = "rbxassetid://" .. v2533.TextureId;
                         v2534.Transparency = v2533.Transparency or 0;
                         v2534.StudsPerTileU = v2533.StudsPerTileU or 1;
                         v2534.StudsPerTileV = v2533.StudsPerTileV or 1;
                         v2534.OffsetStudsU = v2533.OffsetStudsU or 0;
                         v2534.OffsetStudsV = v2533.OffsetStudsV or 0;
                         if (v2533.Color) then
                             local v2536 = t_TextureProperties_342.Color;
                             v2535.Color3 = Color3.new(v2536.r / 255, v2536.g / 255, v2536.b / 255);
                         end
                         local v2537 = 0;
                         local v2538;
                         if (v2531:IsA("MeshPart")) then
                             v2538 = 5;
                         else
                             v2538 = 0;
                         end
                         local v2539 = v2537;
                         local v2540 = v2538;
                         if (not (v2540 <= v2539)) then
                             while true do
                                 local v2541 = v2535:Clone();
                                 v2541.Face = v2537;
                                 v2541.Parent = v2531;
                                 local v2542 = v2537 + 1;
                                 v2537 = v2542;
                                 local v2543 = v2538;
                                 if (v2543 < v2542) then
                                     break;
                                 end
                             end
                         end
                         local t_DefaultColor_343 = t_BrickProperties_341.DefaultColor;
                         if (t_DefaultColor_343 ~= true) then
                             local v2544 = t_BrickProperties_341.Color;
                             local t_Color_344 = v2544;
                             if (v2544) then
                                 v2531.Color = Color3.new(t_Color_344.r / 255, t_Color_344.g / 255, t_Color_344.b / 255);
                             else
                                 if (t_BrickProperties_341.BrickColor) then
                                     v2531.BrickColor = BrickColor.new(t_BrickProperties_341.BrickColor);
                                 end
                             end
                         end
                         if (t_BrickProperties_341.Material) then
                             v2531.Material = t_BrickProperties_341.Material;
                         end
                         if (t_BrickProperties_341.Reflectance) then
                             v2531.Reflectance = t_BrickProperties_341.Reflectance;
                         end
                     end
                 end
                 v2531.CastShadow = false;
                 v2531.Massless = true;
                 v2531.Anchored = false;
                 v2531.CanCollide = false;
             end
         else
             break;
         end
     end
     return v2521;
 end;
 local v2545 = shared.require("Holode4");
 local v2546 = shared.require("FibDecoder");
 local v2547 = shared.require("Fib2Decoder");
 local v2548 = shared.require("Fib3Decoder");
 local v2549 = shared.require("SmoothReplicationPackager");
 local v2550 = shared.require("ReplicationSmoother");
 local f_readDouble;
 f_readDouble = function(p406)
     --[[
         Name: readDouble
         Line: 8264
     --]]
     local v2551 = p406(1);
     local v2552 = p406(11);
     local v2553 = p406(52);
     local v2554;
     if (v2551 == 0) then
         v2554 = 1;
     else
         v2554 = -1;
     end
     if (v2552 ~= 2047) then
         if (v2552 == 0) then
             return (v2554 * v2553) * 5.e-324;
         end
         return (v2554 * ((v2553 / 4503599627370496) + 1)) * ((2) ^ (v2552 - 1023));
     end
     if (v2553 == 0) then
         return v2554 / 0;
     end
     if (v2553 == 1) then
         return (0/0);
     end
     return -(0/0);
 end;
 local u690 = t_LocalPlayer_327;
 local u691 = v2549;
 local u692 = v2548;
 local u693 = v2547;
 local u694 = v2550;
 local u695 = v22;
 local u696 = v2402;
 local u697 = v2403;
 local u698 = v19;
 local u699 = v2545;
 local u700 = v2415;
 local f_weld3pm = f_weld3pm;
 local u701 = u7;
 local u702 = v2414;
 local u703 = v2413;
 local u704 = v2412;
 local u705 = u19;
 local f_pickv3 = f_pickv3;
 local u706 = u678;
 local u707 = u16;
 local u708 = u15;
 local u709 = v2417;
 local u710 = v2418;
 local f_hitdist = f_hitdist;
 local f_hittarget = f_hittarget;
 local u711 = u676;
 local u712 = v2405;
 local u713 = v2406;
 local u714 = u9;
 local u715 = t_soundfonts_328;
 local u716 = u21;
 local u717 = t_anglesyx_323;
 local u718 = t_direct_324;
 local u719 = v2404;
 local u720 = t_jointleg_325;
 local u721 = v2400;
 local u722 = u14;
 local u723 = t_jointarm_326;
 local u724 = v2429;
 local u725 = v2428;
 local u726 = v2416;
 local u727 = v2409;
 local f_setcharacterhash = f_setcharacterhash;
 local u728 = u4;
 local f_removecharacterhash = f_removecharacterhash;
 local u729 = v2410;
 local f_readDouble = f_readDouble;
 local u730 = u12;
 local f_loadplayer;
 f_loadplayer = function(p407)
     --[[
         Name: loadplayer
         Line: 8289
         Upvalues: 
             [1] = u690
             [2] = u691
             [3] = u692
             [4] = u693
             [5] = u694
             [6] = u695
             [7] = u696
             [8] = u697
             [9] = u698
             [10] = u699
             [11] = u700
             [12] = f_weld3pm
             [13] = u701
             [14] = u702
             [15] = u703
             [16] = u704
             [17] = u705
             [18] = f_pickv3
             [19] = u706
             [20] = u707
             [21] = u708
             [22] = u709
             [23] = u710
             [24] = f_hitdist
             [25] = f_hittarget
             [26] = u711
             [27] = u712
             [28] = u713
             [29] = u714
             [30] = u715
             [31] = u716
             [32] = u717
             [33] = u718
             [34] = u719
             [35] = u720
             [36] = u721
             [37] = u722
             [38] = u723
             [39] = u724
             [40] = u725
             [41] = u726
             [42] = u727
             [43] = f_setcharacterhash
             [44] = u728
             [45] = f_removecharacterhash
             [46] = f_gunrequire
             [47] = u729
             [48] = f_readDouble
             [49] = u730
 
     --]]
     local v2555 = u690;
     if (p407 == v2555) then
         return;
     end
     local v2556 = u691.new(u692.new(0.020833333333333332), Vector3.new());
     local v2557 = u691.new(u693.new(0.020833333333333332), Vector2.new());
     local v2558 = u694.new(10, 0.3333333333333333, 0.5, function(p408, p409, p410, p411, p412)
         --[[
             Name: (empty)
             Line: 8296
         --]]
         if (p410 == p411) then
             return p408;
         end
         local v2559 = (p411 - p412) / (p411 - p410);
         local v2560 = (p412 - p410) / (p411 - p410);
         local v2561 = {};
         v2561.t = (v2559 * p408.t) + (v2560 * p409.t);
         v2561.position = (v2559 * p408.position) + (v2560 * p409.position);
         v2561.velocity = (v2559 * p408.velocity) + (v2560 * p409.velocity);
         v2561.angles = (v2559 * p408.angles) + (v2560 * p409.angles);
         v2561.breakcount = p408.breakcount;
         return v2561;
     end);
     local u731 = nil;
     local u732 = nil;
     local u733 = nil;
     local u734 = nil;
     local v2562 = Instance.new("Motor6D");
     local v2563 = Instance.new("Motor6D");
     local v2564 = Instance.new("Motor6D");
     local v2565 = Instance.new("Motor6D");
     local v2566 = {};
     local v2567 = {};
     local v2568 = u695.new();
     local u735 = nil;
     local u736 = nil;
     local u737 = nil;
     local u738 = nil;
     local u739 = nil;
     local u740 = 0;
     local u741 = u696;
     local u742 = u696;
     local u743 = u696;
     local u744 = u696;
     local u745 = u697;
     local u746 = u697;
     local u747 = u697;
     local u748 = u697;
     local u749 = u697;
     local u750 = u697;
     local u751 = Vector3.new(0, -1, 0);
     local u752 = u696;
     local u753 = Vector3.new(0, 0, -1);
     local u754 = u697;
     local u755 = false;
     local v2569 = u698.new();
     v2569.s = 12;
     v2569.d = 0.8;
     local v2570 = u698.new(1);
     v2570.s = 12;
     local v2571 = u698.new();
     v2571.s = 20;
     v2571.d = 0.8;
     local v2572 = u698.new(u696);
     local v2573 = u698.new(u696);
     local u756 = nil;
     local v2574 = Instance.new("Motor6D");
     v2566.breakcount = 0;
     v2566.lastbreakcount = nil;
     v2566.lastPacketTime = nil;
     v2566.receivedFrameTime = nil;
     v2566.receivedPosition = nil;
     v2566.lastSmoothTime = nil;
     v2566.alive = false;
     local v2575 = u699.new(u696, 12);
     local v2576 = u698.new(u696, 1, 32);
     local v2577 = u698.new(u696, 1, 6);
     local v2578 = u698.new(Vector2.new(), 0.75, 12);
     local v2579 = u698.new(0);
     v2579.s = 4;
     v2579.d = 0.8;
     local v2580 = u698.new(0);
     v2580.s = 8;
     local v2581 = u698.new(1);
     v2581.s = 8;
     local u757 = 0;
     local v2582 = u698.new(0);
     v2582.s = 50;
     v2582.d = 1;
     local u758 = 1;
     local v2583 = {};
     v2583.center = u697;
     v2583.pos = u696;
     v2583.sdown = CFrame.new(0.5, -3, 0);
     v2583.pdown = CFrame.new(0.5, -2.75, 0);
     v2583.weld = v2565;
     v2583.hipcf = CFrame.new(0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0);
     v2583.legcf = u700;
     v2583.angm = 1;
     v2583.torsoswing = 0.1;
     local v2584 = {};
     v2584.makesound = true;
     v2584.center = u697;
     v2584.pos = u696;
     v2584.sdown = CFrame.new(-0.5, -3, 0);
     v2584.pdown = CFrame.new(-0.5, -2.75, 0);
     v2584.weld = v2564;
     v2584.hipcf = CFrame.new(-0.5, -0.5, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0);
     v2584.legcf = u700;
     v2584.angm = -1;
     v2584.torsoswing = -0.1;
     local u759 = v2583;
     local u760 = v2584;
     local v2585 = Instance.new("SoundGroup");
     local v2586 = Instance.new("EqualizerSoundEffect");
     v2586.HighGain = 0;
     v2586.MidGain = 0;
     v2586.LowGain = 0;
     v2586.Parent = v2585;
     v2585.Parent = game:GetService("SoundService");
     local u761 = v2568;
     local u762 = v2569;
     local u763 = v2574;
     local f_equipknife;
     f_equipknife = function(p413, p414, p415)
         --[[
             Name: equipknife
             Line: 8440
             Upvalues: 
                 [1] = u761
                 [2] = u737
                 [3] = u762
                 [4] = u763
                 [5] = u738
                 [6] = u739
                 [7] = u746
                 [8] = u747
                 [9] = u748
                 [10] = u750
                 [11] = u753
                 [12] = u745
                 [13] = u751
                 [14] = u752
                 [15] = u754
                 [16] = u736
                 [17] = f_weld3pm
                 [18] = u733
                 [19] = u701
 
         --]]
         if (p413) then
             u761:clear();
             if (u737) then
                 u762.t = 0;
                 u761:add(function()
                     --[[
                         Name: (empty)
                         Line: 8445
                         Upvalues: 
                             [1] = u762
 
                     --]]
                     return u762.p < 0;
                 end);
                 u761:add(function()
                     --[[
                         Name: (empty)
                         Line: 8448
                         Upvalues: 
                             [1] = u737
                             [2] = u763
 
                     --]]
                     u737.Slot1.Transparency = 1;
                     u737.Slot2.Transparency = 1;
                     u763.Part1 = nil;
                     u737:Destroy();
                 end);
             end
             local v2587 = u761;
             local u764 = p413;
             local u765 = p414;
             local u766 = p415;
             v2587:add(function()
                 --[[
                     Name: (empty)
                     Line: 8455
                     Upvalues: 
                         [1] = u738
                         [2] = u739
                         [3] = u764
                         [4] = u746
                         [5] = u747
                         [6] = u748
                         [7] = u750
                         [8] = u753
                         [9] = u745
                         [10] = u751
                         [11] = u752
                         [12] = u754
                         [13] = u737
                         [14] = u765
                         [15] = u736
                         [16] = f_weld3pm
                         [17] = u766
                         [18] = u733
                         [19] = u763
                         [20] = u762
                         [21] = u701
 
                 --]]
                 u738 = "KNIFE";
                 u739 = u764.dualhand;
                 u746 = CFrame.new(u764.offset3p.p);
                 u747 = u764.offset3p - u764.offset3p.p;
                 u748 = u764.pivot3p;
                 u750 = u764.drawcf3p;
                 u753 = u764.forward3p;
                 u745 = u764.sprintcf3p;
                 u751 = u764.lhold3p;
                 u752 = u764.rhold3p;
                 u754 = u764.stabcf3p;
                 u737 = u765:Clone();
                 u736 = f_weld3pm(u737, u766);
                 u737.Name = "Model";
                 u737.Parent = u733.Parent;
                 u763.Part1 = u737.Slot1;
                 u762.t = 1;
                 if (u701.disable3psounds) then
                     local g_next_345 = next;
                     local v2588, v2589 = u737:GetDescendants();
                     local v2590 = v2588;
                     local v2591 = v2589;
                     while true do
                         local v2592, v2593 = g_next_345(v2590, v2591);
                         local v2594 = v2592;
                         local v2595 = v2593;
                         if (v2592) then
                             v2591 = v2594;
                             if (v2595:IsA("Sound")) then
                                 v2595.Playing = false;
                             end
                         else
                             break;
                         end
                     end
                 end
             end);
         end
     end;
     v2566.equipknife = f_equipknife;
     local u767 = v2568;
     local u768 = v2569;
     local u769 = v2574;
     local u770 = v2572;
     local u771 = v2573;
     local f_equip;
     f_equip = function(p416, p417, p418)
         --[[
             Name: equip
             Line: 8489
             Upvalues: 
                 [1] = u767
                 [2] = u737
                 [3] = u768
                 [4] = u769
                 [5] = u738
                 [6] = u741
                 [7] = u742
                 [8] = u743
                 [9] = u744
                 [10] = u746
                 [11] = u747
                 [12] = u748
                 [13] = u750
                 [14] = u753
                 [15] = u740
                 [16] = u745
                 [17] = u749
                 [18] = u770
                 [19] = u771
                 [20] = u751
                 [21] = u752
                 [22] = u736
                 [23] = f_weld3pm
                 [24] = u733
                 [25] = u735
                 [26] = u701
 
         --]]
         if (p416) then
             u767:clear();
             if (u737) then
                 u768.t = 0;
                 u767:add(function()
                     --[[
                         Name: (empty)
                         Line: 8494
                         Upvalues: 
                             [1] = u768
 
                     --]]
                     return u768.p < 0;
                 end);
                 u767:add(function()
                     --[[
                         Name: (empty)
                         Line: 8497
                         Upvalues: 
                             [1] = u737
                             [2] = u769
 
                     --]]
                     u737.Slot1.Transparency = 1;
                     u737.Slot2.Transparency = 1;
                     u769.Part1 = nil;
                     u737:Destroy();
                 end);
             end
             local v2596 = u767;
             local u772 = p416;
             local u773 = p417;
             local u774 = p418;
             v2596:add(function()
                 --[[
                     Name: (empty)
                     Line: 8504
                     Upvalues: 
                         [1] = u738
                         [2] = u741
                         [3] = u772
                         [4] = u742
                         [5] = u743
                         [6] = u744
                         [7] = u746
                         [8] = u747
                         [9] = u748
                         [10] = u750
                         [11] = u753
                         [12] = u740
                         [13] = u745
                         [14] = u749
                         [15] = u770
                         [16] = u771
                         [17] = u751
                         [18] = u752
                         [19] = u737
                         [20] = u773
                         [21] = u736
                         [22] = f_weld3pm
                         [23] = u774
                         [24] = u733
                         [25] = u769
                         [26] = u768
                         [27] = u735
                         [28] = u701
 
                 --]]
                 u738 = "gun";
                 u741 = u772.transkickmax;
                 u742 = u772.transkickmin;
                 u743 = u772.rotkickmax;
                 u744 = u772.rotkickmin;
                 u746 = CFrame.new(u772.offset3p.p);
                 u747 = u772.offset3p - u772.offset3p.p;
                 u748 = u772.pivot3p;
                 u750 = u772.drawcf3p;
                 u753 = u772.forward3p;
                 u740 = u772.headaimangle3p or 0;
                 u745 = u772.sprintcf3p;
                 u749 = u772.aimpivot3p;
                 u770.s = u772.modelkickspeed;
                 u770.d = u772.modelkickdamper;
                 u771.s = u772.modelkickspeed;
                 u771.d = u772.modelkickdamper;
                 u751 = u772.lhold3p;
                 u752 = u772.rhold3p;
                 u737 = u773:Clone();
                 u736 = f_weld3pm(u737, u774);
                 u737.Name = "Model";
                 u737.Parent = u733.Parent;
                 u769.Part1 = u737.Slot1;
                 u768.t = 1;
                 if (u772.firesoundid) then
                     u735 = u772.firesoundid;
                 end
                 if (u701.disable3psounds) then
                     local g_next_346 = next;
                     local v2597, v2598 = u737:GetDescendants();
                     local v2599 = v2597;
                     local v2600 = v2598;
                     while true do
                         local v2601, v2602 = g_next_346(v2599, v2600);
                         local v2603 = v2601;
                         local v2604 = v2602;
                         if (v2601) then
                             v2600 = v2603;
                             if (v2604:IsA("Sound")) then
                                 v2604.Playing = false;
                             end
                         else
                             break;
                         end
                     end
                 end
             end);
         end
     end;
     v2566.equip = f_equip;
     local u775 = v2576;
     local f_getweaponpos;
     f_getweaponpos = function()
         --[[
             Name: getweaponpos
             Line: 8552
             Upvalues: 
                 [1] = u736
                 [2] = u737
                 [3] = u747
                 [4] = u775
 
         --]]
         if (u736) then
             return u736.CFrame.p;
         end
         if (u737) then
             return (u737.Slot1.CFrame * u747:inverse()) * Vector3.new(0, 0, -2);
         end
         return u775.p;
     end;
     v2566.getweaponpos = f_getweaponpos;
     local u776 = v2571;
     local u777 = p407;
     local f_stab;
     f_stab = function()
         --[[
             Name: stab
             Line: 8562
             Upvalues: 
                 [1] = u737
                 [2] = u738
                 [3] = u776
                 [4] = u702
                 [5] = u703
                 [6] = u704
                 [7] = u777
                 [8] = u733
                 [9] = u705
 
         --]]
         if (u737) then
             local v2605 = u738;
             if (v2605 == "KNIFE") then
                 u776.a = 47;
                 local v2606 = {
                     u702,
                     u703,
                     u704:FindFirstChild(u777.TeamColor.Name)
                 };
                 local v2607 = u733.CFrame;
                 local t_CFrame_347 = v2607;
                 local v2608, v2609, v2610 = workspace:FindPartOnRayWithIgnoreList(Ray.new(v2607.p, v2607.LookVector * 5), v2606);
                 local v2611 = v2609;
                 if (v2608) then
                     u705:bloodhit(v2611, true, 85, Vector3.new(0, -8, 0) + ((v2611 - t_CFrame_347.p).unit * 8), true);
                 end
             end
         end
     end;
     v2566.stab = f_stab;
     local u778 = v2570;
     local u779 = v2572;
     local u780 = v2573;
     local u781 = v2585;
     local u782 = v2586;
     local u783 = v2582;
     local f_kickweapon;
     f_kickweapon = function(p419, p420, p421, p422)
         --[[
             Name: kickweapon
             Line: 8579
             Upvalues: 
                 [1] = u737
                 [2] = u738
                 [3] = u778
                 [4] = u779
                 [5] = f_pickv3
                 [6] = u742
                 [7] = u741
                 [8] = u780
                 [9] = u744
                 [10] = u743
                 [11] = u706
                 [12] = u781
                 [13] = u735
                 [14] = u733
                 [15] = u707
                 [16] = u782
                 [17] = u705
                 [18] = u736
                 [19] = u708
                 [20] = u783
 
         --]]
         if (u737) then
             local v2612 = u738;
             if (v2612 == "gun") then
                 local v2613 = u778.p;
                 u779.a = f_pickv3(u742, u741);
                 u780.a = f_pickv3(u744, u743);
                 local v2614 = #u706;
                 local u784;
                 if (v2614 == 0) then
                     u784 = Instance.new("Sound");
                     u784.Ended:connect(function()
                         --[[
                             Name: (empty)
                             Line: 8589
                             Upvalues: 
                                 [1] = u784
                                 [2] = u706
 
                         --]]
                         u784.Parent = nil;
                         table.insert(u706, u784);
                     end);
                 else
                     u784 = table.remove(u706, 1);
                 end
                 u784.SoundGroup = u781;
                 local v2615 = p420;
                 if (not v2615) then
                     v2615 = u735;
                 end
                 u784.SoundId = v2615;
                 if (p421) then
                     u784.Pitch = p421;
                 end
                 if (p422) then
                     u784.Volume = p422;
                 end
                 local v2616 = (-(u733.Position - u707.cframe.p).magnitude) / 14.6484;
                 u782.HighGain = v2616;
                 u782.MidGain = v2616;
                 u784.Parent = u733;
                 u784:Play();
                 if ((u705.enablemuzzleeffects and u736) and u708.point(u736.Position)) then
                     if (not p419) then
                         u783.a = 125;
                     end
                     local v2617 = u736:FindFirstChild("Smoke");
                     if (not p419) then
                         local g_next_348 = next;
                         local v2618, v2619 = u736:GetChildren();
                         local v2620 = v2618;
                         local v2621 = v2619;
                         while true do
                             local v2622, v2623 = g_next_348(v2620, v2621);
                             local v2624 = v2622;
                             local v2625 = v2623;
                             if (v2622) then
                                 v2621 = v2624;
                                 if ((not (v2625 == v2617)) and v2625:IsA("ParticleEmitter")) then
                                     v2625:Emit(1);
                                 end
                             else
                                 break;
                             end
                         end
                     end
                 end
             end
         end
     end;
     v2566.kickweapon = f_kickweapon;
     local f_getweapon;
     f_getweapon = function()
         --[[
             Name: getweapon
             Line: 8637
             Upvalues: 
                 [1] = u737
 
         --]]
         return u737;
     end;
     v2566.getweapon = f_getweapon;
     local u785 = v2581;
     local f_setsprint;
     f_setsprint = function(p423)
         --[[
             Name: setsprint
             Line: 8641
             Upvalues: 
                 [1] = u785
 
         --]]
         local v2626 = u785;
         local v2627;
         if (p423) then
             v2627 = 0;
         else
             v2627 = 1;
         end
         v2626.t = v2627;
     end;
     v2566.setsprint = f_setsprint;
     local u786 = v2570;
     local f_setaim;
     f_setaim = function(p424)
         --[[
             Name: setaim
             Line: 8645
             Upvalues: 
                 [1] = u786
 
         --]]
         local v2628 = u786;
         local v2629;
         if (p424) then
             v2629 = 0;
         else
             v2629 = 1;
         end
         v2628.t = v2629;
     end;
     v2566.setaim = f_setaim;
     local u787 = v2579;
     local f_setstance;
     f_setstance = function(p425)
         --[[
             Name: setstance
             Line: 8649
             Upvalues: 
                 [1] = u787
 
         --]]
         local v2630 = u787;
         local v2631;
         if (p425 == "stand") then
             v2631 = 0;
         else
             if (p425 == "crouch") then
                 v2631 = 0.5;
             else
                 v2631 = 1;
             end
         end
         v2630.t = v2631;
     end;
     v2566.setstance = f_setstance;
     local u788 = v2566;
     local u789 = v2576;
     local f_getpos;
     f_getpos = function()
         --[[
             Name: getpos
             Line: 8655
             Upvalues: 
                 [1] = u788
                 [2] = u789
                 [3] = u732
 
         --]]
         if (not u788.alive) then
             return;
         end
         local t_p_349 = u789.p;
         local v2632 = u732;
         if (v2632) then
             v2632 = u732.Position;
         end
         return t_p_349, v2632;
     end;
     v2566.getpos = f_getpos;
     local f_gethead;
     f_gethead = function()
         --[[
             Name: gethead
             Line: 8663
             Upvalues: 
                 [1] = u732
 
         --]]
         return u732;
     end;
     v2566.gethead = f_gethead;
     local u790 = v2578;
     local f_getlookangles;
     f_getlookangles = function()
         --[[
             Name: getlookangles
             Line: 8667
             Upvalues: 
                 [1] = u790
 
         --]]
         return u790.p;
     end;
     v2566.getlookangles = f_getlookangles;
     local u791 = v2576;
     local u792 = v2577;
     local u793 = v2575;
     local f_resetSprings;
     f_resetSprings = function(p426)
         --[[
             Name: resetSprings
             Line: 8671
             Upvalues: 
                 [1] = u696
                 [2] = u791
                 [3] = u792
                 [4] = u793
 
         --]]
         local v2633 = p426;
         if (not v2633) then
             v2633 = u696;
         end
         local v2634 = v2633;
         p426 = v2634;
         u791.t = v2634;
         u791.p = v2634;
         u791.v = u696;
         u792.t = u696;
         u792.p = u696;
         u792.v = u696;
         u793._p0 = v2634;
         u793._p1 = v2634;
         u793._a0 = u696;
         u793._j0 = u696;
         u793._v0 = u696;
         u793._t0 = 0;
     end;
     v2566.resetSprings = f_resetSprings;
     local u794 = p407;
     local u795 = v2558;
     local u796 = v2566;
     local u797 = v2578;
     local u798 = v2576;
     local u799 = v2577;
     local u800 = v2575;
     local u801 = v2568;
     local u802 = v2579;
     local u803 = v2581;
     local u804 = v2567;
     local u805 = v2580;
     local u806 = v2569;
     local u807 = v2570;
     local u808 = v2582;
     local u809 = v2572;
     local u810 = v2573;
     local u811 = v2562;
     local u812 = v2563;
     local u813 = v2574;
     local u814 = v2571;
     local f_step;
     f_step = function(p427, p428)
         --[[
             Name: step
             Line: 8690
             Upvalues: 
                 [1] = u794
                 [2] = u733
                 [3] = u795
                 [4] = u796
                 [5] = u734
                 [6] = u704
                 [7] = u797
                 [8] = u798
                 [9] = u799
                 [10] = u800
                 [11] = u757
                 [12] = u737
                 [13] = u755
                 [14] = u801
                 [15] = u802
                 [16] = u803
                 [17] = u709
                 [18] = u710
                 [19] = u758
                 [20] = u759
                 [21] = u760
                 [22] = f_hitdist
                 [23] = u804
                 [24] = u805
                 [25] = f_hittarget
                 [26] = u707
                 [27] = u711
                 [28] = u712
                 [29] = u713
                 [30] = u714
                 [31] = u715
                 [32] = u690
                 [33] = u716
                 [34] = u806
                 [35] = u717
                 [36] = u718
                 [37] = u719
                 [38] = u697
                 [39] = u720
                 [40] = u721
                 [41] = u807
                 [42] = u740
                 [43] = u731
                 [44] = u756
                 [45] = u808
                 [46] = u738
                 [47] = u749
                 [48] = u748
                 [49] = u746
                 [50] = u809
                 [51] = u722
                 [52] = u810
                 [53] = u747
                 [54] = u750
                 [55] = u745
                 [56] = u811
                 [57] = u723
                 [58] = u724
                 [59] = u751
                 [60] = u700
                 [61] = u812
                 [62] = u725
                 [63] = u752
                 [64] = u813
                 [65] = u754
                 [66] = u814
                 [67] = u739
 
         --]]
         debug.profilebegin("rep char " .. (p427 .. (" " .. u794.Name)));
         if (not u733) then
             debug.profileend();
             return;
         end
         local v2635 = nil;
         local v2636 = nil;
         local v2637 = nil;
         local v2638 = nil;
         local v2639 = 0;
         if (u795:isReady()) then
             local v2640 = u795:getFrame(tick());
             local v2641 = v2640;
             local v2642 = v2640.breakcount;
             local t_lastbreakcount_350 = u796.lastbreakcount;
             if (v2642 ~= t_lastbreakcount_350) then
                 u796.resetSprings(v2641.position);
                 u734.Parent = u704[u794.TeamColor.Name];
                 u796.lastbreakcount = v2641.breakcount;
             end
             v2635 = v2641.position;
             v2637 = v2641.position;
             v2636 = v2641.angles;
             v2638 = v2641.velocity;
             local t_t_351 = v2641.t;
             local v2643 = u796.lastSmoothTime;
             if (not v2643) then
                 v2643 = v2641.t;
             end
             v2639 = t_t_351 - v2643;
             u796.lastSmoothTime = v2641.t;
         end
         local v2644 = u797:update(v2636);
         local v2645 = u798:update(v2635);
         local v2646 = u799:update(v2638);
         local v2647, v2648, v2649, v2650 = u800:update(v2639, v2637);
         local v2651 = v2649;
         local v2652 = (0 * v2647) + (1 * v2645);
         local v2653 = (0 * v2648) + (1 * v2646);
         local v2654 = CFrame.Angles(0, u757, 0) + v2652;
         local v2655 = v2654;
         local v2656 = v2653;
         local t_p_352 = v2654.p;
         if (u737) then
             if (p428 and (not u755)) then
                 u737.Slot1.Transparency = 0;
                 u737.Slot2.Transparency = 0;
                 u755 = true;
             else
                 if ((not p428) and u755) then
                     u737.Slot1.Transparency = 1;
                     u737.Slot2.Transparency = 1;
                     u755 = false;
                 end
             end
         end
         u733.CFrame = v2655;
         if (p427 > 1) then
             local v2657 = false;
             u801:step();
             local v2658 = u802.p;
             local t_p_353 = v2658;
             local t_p_354 = u803.p;
             local v2659;
             if (v2658 <= 0.5) then
                 v2659 = u709(2 * t_p_353);
                 if (not v2659) then
                     v2657 = true;
                 end
             else
                 v2657 = true;
             end
             if (v2657) then
                 v2659 = u710((2 * t_p_353) - 1);
             end
             local v2660 = false;
             local t_x_355 = v2644.x;
             local v2661 = v2644.y;
             local t_y_356 = v2661;
             local v2662 = t_p_354 * 0.5;
             local v2663 = v2662;
             local v2664 = u757 - v2661;
             local v2665 = -v2662;
             local v2666;
             if (v2664 <= v2665) then
                 v2666 = t_y_356 - v2663;
                 if (not v2666) then
                     v2660 = true;
                 end
             else
                 v2660 = true;
             end
             if (v2660) then
                 local v2667 = false;
                 local v2668 = u757 - t_y_356;
                 if (v2663 <= v2668) then
                     v2666 = t_y_356 + v2663;
                     if (not v2666) then
                         v2667 = true;
                     end
                 else
                     v2667 = true;
                 end
                 if (v2667) then
                     v2666 = u757;
                 end
             end
             local v2669 = false;
             u757 = v2666;
             local v2670 = (((CFrame.Angles(0, u757, 0) * CFrame.new(0, (0.05 * math.sin(2 * tick())) - 0.55, 0)) * v2659) * CFrame.new(0, 0.5, 0)) + t_p_352;
             local v2671;
             if (t_p_353 >= 0.5) then
                 v2671 = (2 * t_p_353) - 1;
                 if (not v2671) then
                     v2669 = true;
                 end
             else
                 v2669 = true;
             end
             if (v2669) then
                 v2671 = 0;
             end
             u758 = ((0.5 * (1 - t_p_353)) + 0.5) + ((1 - t_p_354) * 0.5);
             local v2672 = (v2655 * u759.sdown):Lerp(v2670 * u759.pdown, v2671);
             local v2673 = v2672;
             local v2674 = (v2655 * u760.sdown):Lerp(v2670 * u760.pdown, v2671);
             local v2675 = v2674;
             local t_p_357 = v2674.p;
             local v2676, v2677 = f_hitdist(u759.center.p, v2672.p, u758, u759.pos);
             local v2678 = v2676;
             local v2679 = v2677;
             if (v2677) then
                 u804.remp = v2679;
             end
             u805.t = v2656.magnitude;
             local v2680 = f_hittarget(u760.center.p, t_p_357, u758);
             if (v2678 <= 1) then
                 u760.pos = ((1 - v2678) * ((v2675 * u760.center:inverse()) * u760.pos)) + (v2678 * v2680);
                 u759.center = v2673;
                 u760.center = v2675;
             else
                 u759.center = v2673;
                 u760.center = v2675;
                 local t_magnitude_360 = (u707.basecframe.p - t_p_357).magnitude;
                 if (u760.makesound and (t_magnitude_360 <= 128)) then
                     local v2681, v2682, v2683, v2684 = workspace:FindPartOnRayWithWhitelist(u711(t_p_357 + u712, u713), u714.raycastwhitelist, true);
                     local v2685 = v2684;
                     if (v2681) then
                         local v2686 = u715[v2685];
                         local v2687 = v2686;
                         if (v2686) then
                             local v2688 = u794.TeamColor;
                             local t_TeamColor_361 = u690.TeamColor;
                             local v2690, v2689;
                             if (v2688 == t_TeamColor_361) then
                                 v2689 = "friendly_" .. v2687;
                                 v2690 = 1.4142135623730951 / (t_magnitude_360 / 5);
                             else
                                 v2689 = "enemy_" .. v2687;
                                 v2690 = 3.872983346207417 / (t_magnitude_360 / 5);
                             end
                             if (v2689 == "enemy_wood") then
                                 v2690 = 3.1622776601683795 / (t_magnitude_360 / 5);
                             end
                             local v2691;
                             if (u805.p < 15) then
                                 v2691 = v2689 .. "walk";
                             else
                                 v2691 = v2689 .. "run";
                             end
                             u716.PlaySound(v2691, nil, v2690, 1, nil, nil, u733, 128, 10);
                         end
                     end
                 end
                 u759.pos = v2673.p + (u758 * (u759.pos - v2673.p).unit);
                 u760.pos = v2680;
                 local v2692 = u760;
                 local v2693 = u759;
                 u759 = v2692;
                 u760 = v2693;
             end
             if (p427 > 2) then
                 local v2694 = false;
                 local t_p_358 = u806.p;
                 local v2695 = u717(t_x_355, t_y_356);
                 local v2696 = u805.p / 8;
                 local v2697 = v2696;
                 local v2698;
                 if (v2696 <= 1) then
                     v2698 = v2697;
                     if (not v2698) then
                         v2694 = true;
                     end
                 else
                     v2694 = true;
                 end
                 if (v2694) then
                     v2698 = 1;
                 end
                 local v2699 = v2698;
                 local v2700 = u804.remp * (2 - (u804.remp / u758));
                 local v2701 = v2700;
                 local v2702;
                 if (v2700 <= 0) then
                     v2702 = 0;
                 else
                     v2702 = v2701;
                 end
                 local v2703 = v2702;
                 local v2704 = v2703;
                 local v2705 = (u718(v2670, u719, v2695, ((0.5 * t_p_354) * (1 - t_p_353)) * t_p_358) * CFrame.Angles(0, v2703 * u759.torsoswing, 0)) * CFrame.new(0, -3, 0);
                 local v2706 = (((u718(u697, Vector3.new(0, 1, 0), Vector3.new(0, 333.3333333333333, 0) + v2651, 1 - v2671) * (v2705 - v2705.p)) * CFrame.new(0, 3, 0)) + v2705.p) + Vector3.new(0, (v2703 * v2699) / 16, 0);
                 local v2707 = v2706;
                 u733.CFrame = v2706;
                 u759.weld.C0 = u720(1, 1.5, u759.hipcf, v2706:inverse() * u759.pos, ((v2671 * u721) / 5) * u759.angm) * u759.legcf;
                 u760.weld.C0 = u720(1, 1.5, u760.hipcf, v2706:inverse() * (u760.pos + (((v2703 * v2699) / 3) * Vector3.new(0, 1, 0))), ((v2671 * u721) / 5) * u760.angm) * u760.legcf;
                 local v2708 = u807.p;
                 local t_p_359 = v2708;
                 u731.C0 = ((v2706:inverse() * u718(v2706 * CFrame.new(0, 0.825, 0), u719, v2695)) * CFrame.Angles(0, 0, (1 - v2708) * u740)) * CFrame.new(0, 0.675, 0);
                 if (u756) then
                     u756.Brightness = u808.p;
                 end
                 if (u737) then
                     local v2709 = u738;
                     if (v2709 == "gun") then
                         local v2710 = u750:Lerp(CFrame.Angles(v2704 / 10, v2704 * u759.torsoswing, 0) * u745:Lerp(((((v2707:inverse() * u718(v2707 * u749:Lerp(u748, t_p_359), u719, v2695)) * u746) * CFrame.new(u809.p)) * u722.fromaxisangle(u810.p)) * u747, t_p_354), t_p_358);
                         u811.C0 = u723(1, 1.5, u724, v2710 * u751) * u700;
                         u812.C0 = u723(1, 1.5, u725, v2710 * u752) * u700;
                         u813.C0 = v2710;
                     else
                         local v2711 = u738;
                         if (v2711 == "KNIFE") then
                             local v2712 = u750:Lerp(u745:Lerp((((v2707:inverse() * u718(v2707 * u748, u719, v2695)) * u746) * u747) * u697:Lerp(u754, u814.p), t_p_354), t_p_358);
                             if (u739) then
                                 u811.C0 = u723(1, 1.5, u724, v2712 * u751) * u700;
                             else
                                 u811.C0 = u723(1, 1.5, u724, u751) * u700;
                             end
                             u812.C0 = u723(1, 1.5, u725, v2712 * u752) * u700;
                             u813.C0 = v2712;
                         end
                     end
                 end
             end
         end
         debug.profileend();
     end;
     v2566.step = f_step;
     local u815 = v2566;
     local u816 = p407;
     local u817 = v2562;
     local u818 = v2563;
     local u819 = v2564;
     local u820 = v2565;
     local u821 = v2574;
     local f_spawn;
     f_spawn = function(p429)
         --[[
             Name: spawn
             Line: 8887
             Upvalues: 
                 [1] = u815
                 [2] = u816
                 [3] = u734
                 [4] = u726
                 [5] = u733
                 [6] = u732
                 [7] = u731
                 [8] = u817
                 [9] = u818
                 [10] = u819
                 [11] = u820
                 [12] = u821
                 [13] = u756
                 [14] = u727
                 [15] = f_setcharacterhash
                 [16] = u728
 
         --]]
         if (u815.alive) then
             return;
         end
         u815.alive = true;
         local v2713 = u816.TeamColor;
         local t_TeamColor_362 = game:GetService("Teams").Ghosts.TeamColor;
         local v2714;
         if (v2713 == t_TeamColor_362) then
             v2714 = "Ghosts";
         else
             v2714 = "Phantoms";
         end
         u734 = u726:WaitForChild(v2714):Clone();
         u734.Name = "Player";
         u734.Torso.Anchored = true;
         u733 = u734.Torso;
         u732 = u734.Head;
         u731 = u733.Neck;
         u817.Part0 = u733;
         u818.Part0 = u733;
         u819.Part0 = u733;
         u820.Part0 = u733;
         u817.Part1 = u734["Left Arm"];
         u818.Part1 = u734["Right Arm"];
         u819.Part1 = u734["Left Leg"];
         u820.Part1 = u734["Right Leg"];
         u817.Parent = u733;
         u818.Parent = u733;
         u819.Parent = u733;
         u820.Parent = u733;
         u821.Part0 = u733;
         u821.Parent = u733;
         u756 = u727.Effects.MuzzleLight:Clone();
         u756.Parent = u733;
         f_setcharacterhash(u816, u734);
         u815.resetSprings(p429);
         local v2715 = u728.updatehealth;
         local v2716 = u816;
         local v2717 = {};
         v2717.alive = true;
         v2717.health0 = 100;
         v2717.healtick0 = tick();
         v2715(v2716, v2717);
     end;
     v2566.spawn = f_spawn;
     local u822 = v2566;
     local u823 = v2562;
     local u824 = v2563;
     local u825 = v2564;
     local u826 = v2565;
     local u827 = v2574;
     local u828 = p407;
     local u829 = v2558;
     local f_died;
     f_died = function()
         --[[
             Name: died
             Line: 8935
             Upvalues: 
                 [1] = u822
                 [2] = u734
                 [3] = u823
                 [4] = u824
                 [5] = u825
                 [6] = u826
                 [7] = u827
                 [8] = u756
                 [9] = u737
                 [10] = u733
                 [11] = f_removecharacterhash
                 [12] = u828
                 [13] = u728
                 [14] = u829
 
         --]]
         if (not u822.alive) then
             return;
         end
         local v2718 = u734;
         u734 = nil;
         u822.alive = false;
         u823.Parent = nil;
         u824.Parent = nil;
         u825.Parent = nil;
         u826.Parent = nil;
         u827.Parent = nil;
         u756:Destroy();
         u756 = nil;
         if (u737) then
             u737:Destroy();
             u737 = nil;
         end
         local g_next_363 = next;
         local v2719, v2720 = u733:GetChildren();
         local v2721 = v2719;
         local v2722 = v2720;
         while true do
             local v2723, v2724 = g_next_363(v2721, v2722);
             local v2725 = v2723;
             local v2726 = v2724;
             if (v2723) then
                 v2722 = v2725;
                 if (v2726:IsA("Sound")) then
                     v2726:Stop();
                     v2726.Parent = nil;
                 end
             else
                 break;
             end
         end
         f_removecharacterhash(u828);
         local v2727 = u728.updatehealth;
         local v2728 = u828;
         local v2729 = {};
         v2729.alive = false;
         v2729.health0 = 0;
         v2729.healtick0 = tick();
         v2727(v2728, v2729);
         u822.breakcount = 0;
         u822.lastbreakcount = nil;
         u822.lastPacketTime = nil;
         u822.receivedFrameTime = nil;
         u822.receivedPosition = nil;
         u822.lastSmoothTime = nil;
         u829:init();
         return v2718;
     end;
     v2566.died = f_died;
     local u830 = p407;
     local u831 = v2566;
     local f_updatestate;
     f_updatestate = function(p430)
         --[[
             Name: updatestate
             Line: 8986
             Upvalues: 
                 [1] = u728
                 [2] = u830
                 [3] = u831
                 [4] = f_gunrequire
                 [5] = u729
 
         --]]
         if (p430.healthstate) then
             u728.updatehealth(u830, p430.healthstate);
         end
         if (p430.stance) then
             u831.setstance(p430.stance);
         end
         if (p430.sprint) then
             u831.setsprint(p430.sprint);
         end
         if (p430.aim) then
             u831.setaim(p430.aim);
         end
         if (p430.weapon) then
             local v2730 = p430.weapon;
             local v2731 = f_gunrequire(v2730);
             local v2732 = v2731;
             local v2733 = u729:FindFirstChild(v2730);
             local v2734 = v2733;
             if (v2731 and v2733) then
                 local t_type_364 = v2732.type;
                 if (t_type_364 == "KNIFE") then
                     u831.equipknife(v2732, v2734);
                 else
                     u831.equip(v2732, v2734);
                 end
             else
                 print("Couldn't find a 3rd person weapon");
             end
         end
         if (p430.healthstate and p430.healthstate.alive) then
             u831.spawn();
         end
     end;
     v2566.updatestate = f_updatestate;
     local u832 = v2556;
     local u833 = v2557;
     local u834 = v2566;
     local u835 = v2558;
     local f_updateReplication;
     f_updateReplication = function(p431)
         --[[
             Name: updateReplication
             Line: 9026
             Upvalues: 
                 [1] = f_readDouble
                 [2] = u832
                 [3] = u833
                 [4] = u696
                 [5] = u834
                 [6] = u835
 
         --]]
         local v2735 = tick();
         local v2736 = f_readDouble(p431);
         local v2737 = u832:readAndUpdate(p431);
         local v2738 = u833:readAndUpdate(p431);
         local v2739 = u696;
         if (u834.receivedPosition and u834.receivedFrameTime) then
             v2739 = (v2737 - u834.receivedPosition) / (v2736 - u834.receivedFrameTime);
         end
         local v2740 = false;
         if (u834.lastPacketTime) then
             local v2741 = v2735 - u834.lastPacketTime;
             if (v2741 >= 0.5) then
                 v2740 = true;
                 u834.breakcount = u834.breakcount + 1;
             end
         end
         local v2742 = {};
         v2742.t = v2736;
         v2742.position = v2737;
         v2742.velocity = v2739;
         v2742.angles = v2738;
         v2742.breakcount = u834.breakcount;
         u835:receive(v2735, v2736, v2742, v2740);
         u834.receivedPosition = v2737;
         u834.receivedFrameTime = v2736;
         u834.lastPacketTime = v2735;
     end;
     v2566.updateReplication = f_updateReplication;
     local u836 = v2556;
     local u837 = v2557;
     local f_initstate;
     f_initstate = function(p432)
         --[[
             Name: initstate
             Line: 9064
             Upvalues: 
                 [1] = u836
                 [2] = u837
 
         --]]
         local v2743, v2744 = unpack(p432);
         u836:initializeState(unpack(v2743));
         u837:initializeState(unpack(v2744));
     end;
     v2566.initstate = f_initstate;
     local v2745 = p407:GetPropertyChangedSignal("TeamColor");
     local u838 = v2566;
     local u839 = p407;
     v2745:Connect(function()
         --[[
             Name: (empty)
             Line: 9070
             Upvalues: 
                 [1] = u838
                 [2] = u839
                 [3] = u734
                 [4] = u704
 
         --]]
         if (u838.alive) then
             u734.Parent = u704[u839.TeamColor.Name];
         end
     end);
     u730:send("stat\226\128\139e", p407);
     return v2566;
 end;
 local f_getupdater;
 f_getupdater = function(p433)
     --[[
         Name: getupdater
         Line: 9081
         Upvalues: 
             [1] = u679
             [2] = f_loadplayer
 
     --]]
     if (u679[p433]) then
         if (u679[p433]) then
             return u679[p433].updater;
         end
     else
         local v2746 = f_loadplayer(p433);
         local v2747 = v2746;
         if (v2746) then
             local v2748 = u679;
             local v2749 = {};
             v2749.updater = v2747;
             v2749.lastupdate = 0;
             v2749.lastlevel = 0;
             v2749.lastupframe = 0;
             v2748[p433] = v2749;
             return v2747;
         end
     end
 end;
 u7.getupdater = f_getupdater;
 u12:add("state", function(p434, p435)
     --[[
         Name: (empty)
         Line: 9103
         Upvalues: 
             [1] = f_getupdater
 
     --]]
     local v2750 = f_getupdater(p434);
     local v2751 = v2750;
     if (v2750) then
         v2751.updatestate(p435);
     end
 end);
 u12:add("stance", function(p436, p437)
     --[[
         Name: (empty)
         Line: 9111
         Upvalues: 
             [1] = f_getupdater
 
     --]]
     local v2752 = f_getupdater(p436);
     local v2753 = v2752;
     if (v2752) then
         v2753.setstance(p437);
     end
 end);
 u12:add("sprint", function(p438, p439)
     --[[
         Name: (empty)
         Line: 9118
         Upvalues: 
             [1] = f_getupdater
 
     --]]
     local v2754 = f_getupdater(p438);
     local v2755 = v2754;
     if (v2754) then
         v2755.setsprint(p439);
     end
 end);
 u12:add("aim", function(p440, p441)
     --[[
         Name: (empty)
         Line: 9125
         Upvalues: 
             [1] = f_getupdater
 
     --]]
     local v2756 = f_getupdater(p440);
     local v2757 = v2756;
     if (v2756) then
         v2757.setaim(p441);
     end
 end);
 u12:add("stab", function(p442)
     --[[
         Name: (empty)
         Line: 9132
         Upvalues: 
             [1] = f_getupdater
 
     --]]
     local v2758 = f_getupdater(p442);
     local v2759 = v2758;
     if (v2758) then
         v2759.stab();
     end
 end);
 u12:add("newspawn", function(p443, p444)
     --[[
         Name: (empty)
         Line: 9139
         Upvalues: 
             [1] = f_getupdater
 
     --]]
     local v2760 = f_getupdater(p443);
     local v2761 = v2760;
     if (v2760) then
         v2761.spawn(p444);
     end
 end);
 local u840 = f_getupdater;
 local u841 = v2410;
 u12:add("equip", function(p445, p446, p447)
     --[[
         Name: (empty)
         Line: 9146
         Upvalues: 
             [1] = u840
             [2] = f_gunrequire
             [3] = u841
 
     --]]
     local v2762 = u840(p445);
     local v2763 = v2762;
     if (v2762) then
         local v2764 = f_gunrequire(p446);
         local v2765 = v2764;
         local v2766 = u841:FindFirstChild(p446);
         local v2767 = v2766;
         if (v2764 and v2766) then
             local t_type_365 = v2765.type;
             if (t_type_365 == "KNIFE") then
                 v2763.equipknife(v2765, v2767, p447);
                 return;
             end
             v2763.equip(v2765, v2767, p447);
         end
     end
 end);
 local f_hiteffects;
 f_hiteffects = function(p448, p449, p450, p451)
     --[[
         Name: hiteffects
         Line: 9161
         Upvalues: 
             [1] = u19
             [2] = u4
 
     --]]
     u19:bloodhit(p448, true, p450, p449.unit * 50);
     if (p451) then
         u4:firehitmarker();
     end
 end;
 local v2768 = {};
 v2768.Frag = function(p452, p453, p454, p455)
     --[[
         Name: (empty)
         Line: 9169
         Upvalues: 
             [1] = u16
             [2] = u21
             [3] = t_LocalPlayer_327
             [4] = u4
             [5] = f_getupdater
             [6] = u676
             [7] = u9
             [8] = f_hiteffects
 
     --]]
     local t_range0_366 = p452.range0;
     local t_range1_367 = p452.range1;
     local t_damage0_368 = p452.damage0;
     local t_damage1_369 = p452.damage1;
     local v2769 = (u16.basecframe.p - p454).magnitude;
     local t_magnitude_370 = v2769;
     p453.Position = p454;
     if (v2769 < 50) then
         u21.play("fragClose", 2, 1, p453, true);
     else
         if (t_magnitude_370 < 200) then
             u21.play("fragMed", 3, 1, p453, true);
         else
             if (t_magnitude_370 >= 200) then
                 u21.play("fragFar", 3, 1, p453, true);
             end
         end
     end
     local v2770 = Instance.new("Explosion");
     v2770.Position = p454;
     v2770.BlastRadius = p452.blastradius;
     v2770.BlastPressure = 0;
     v2770.DestroyJointRadiusPercent = 0;
     v2770.Parent = workspace;
     local g_next_371 = next;
     local v2771, v2772 = game:GetService("Players"):GetPlayers();
     local v2773 = v2771;
     local v2774 = v2772;
     while true do
         local v2775, v2776 = g_next_371(v2773, v2774);
         local v2777 = v2775;
         local v2778 = v2776;
         if (v2775) then
             v2774 = v2777;
             local v2779 = v2778.TeamColor;
             local t_TeamColor_372 = t_LocalPlayer_327.TeamColor;
             if ((not (v2779 == t_TeamColor_372)) and u4:isplayeralive(v2778)) then
                 local v2780 = f_getupdater(v2778).getpos();
                 local v2781 = v2780;
                 if (v2780) then
                     local v2782 = v2781 - p454;
                     local v2783 = v2782;
                     local v2784 = v2782.magnitude;
                     local t_magnitude_373 = v2784;
                     if ((v2784 <= t_range1_367) and (not workspace:FindPartOnRayWithWhitelist(u676(p454, v2782), u9.raycastwhitelist, true))) then
                         local v2785 = false;
                         local v2786;
                         if (t_magnitude_373 <= t_range0_366) then
                             v2786 = t_damage0_368;
                             if (not v2786) then
                                 v2785 = true;
                             end
                         else
                             v2785 = true;
                         end
                         if (v2785) then
                             local v2787 = false;
                             if (t_magnitude_373 <= t_range1_367) then
                                 v2786 = (((t_damage1_369 - t_damage0_368) / (t_range1_367 - t_range0_366)) * (t_magnitude_373 - t_range0_366)) + t_damage0_368;
                                 if (not v2786) then
                                     v2787 = true;
                                 end
                             else
                                 v2787 = true;
                             end
                             if (v2787) then
                                 v2786 = t_damage1_369;
                             end
                         end
                         f_hiteffects(v2781, v2783, v2786, p455);
                     end
                 end
             end
         else
             break;
         end
     end
 end;
 local u842 = t_LocalPlayer_327;
 local u843 = v2414;
 local u844 = v2768;
 local u845 = v2402;
 local u846 = u14;
 local u847 = u19;
 local u848 = u676;
 local u849 = u16;
 local u850 = u9;
 u12:add("newgrenade", function(p456, p457, p458)
     --[[
         Name: (empty)
         Line: 9209
         Upvalues: 
             [1] = f_gunrequire
             [2] = t_getGunModel_4
             [3] = u842
             [4] = u843
             [5] = u844
             [6] = u845
             [7] = u846
             [8] = u847
             [9] = u848
             [10] = u849
             [11] = u850
 
     --]]
     local v2788 = f_gunrequire(p457);
     local v2789 = t_getGunModel_4(p457).Trigger:Clone();
     local v2790 = v2789;
     local v2791 = v2789:FindFirstChild("Indicator");
     local v2792 = p456 == u842;
     local v2793 = v2792;
     if (v2792) then
         v2790.Transparency = 1;
     else
         v2790.Trail.Enabled = true;
         if (v2791) then
             local v2794 = p456.TeamColor;
             local t_TeamColor_374 = u842.TeamColor;
             if (v2794 == t_TeamColor_374) then
                 v2791.Friendly.Visible = true;
             else
                 v2791.Enemy.Visible = true;
             end
         end
     end
     v2790.Anchored = true;
     v2790.Ticking:Play();
     v2790.Parent = u843.Misc;
     local u851 = v2788;
     local u852 = v2790;
     local u853 = v2793;
     local f_explode;
     f_explode = function(p459)
         --[[
             Name: explode
             Line: 9236
             Upvalues: 
                 [1] = u844
                 [2] = u851
                 [3] = u852
                 [4] = u853
 
         --]]
         local v2795 = false;
         local v2796 = u844;
         local v2797;
         if (u851.grenadetype and u844[u851.grenadetype]) then
             v2797 = u851.grenadetype;
             if (not v2797) then
                 v2795 = true;
             end
         else
             v2795 = true;
         end
         if (v2795) then
             v2797 = "Frag";
         end
         v2796[v2797](u851, u852, p459, u853);
         u852:Destroy();
     end;
     local v2798 = p458.time;
     local v2799 = v2798 - tick();
     local u854 = v2798;
     local u855 = 1;
     local u856 = nil;
     local v2800 = game:GetService("RunService").RenderStepped;
     local u857 = v2799;
     local t_time_375 = v2798;
     local u858 = p458;
     local u859 = v2790;
     local u860 = v2793;
     local u861 = v2791;
     local f_explode = f_explode;
     u856 = v2800:connect(function(p460)
         --[[
             Name: (empty)
             Line: 9245
             Upvalues: 
                 [1] = u857
                 [2] = t_time_375
                 [3] = u858
                 [4] = u859
                 [5] = u855
                 [6] = u845
                 [7] = u860
                 [8] = u846
                 [9] = u854
                 [10] = u847
                 [11] = u861
                 [12] = u848
                 [13] = u849
                 [14] = u850
                 [15] = f_explode
                 [16] = u856
 
         --]]
         local v2801 = tick();
         local v2802 = v2801 + ((u857 * ((t_time_375 + u858.blowuptime) - v2801)) / (u858.blowuptime + u857));
         if (u859 and u858) then
             local v2803 = u858.frames;
             local v2804 = v2803[u855];
             local v2805 = v2803[u855 + 1];
             local v2806 = v2805;
             if (v2805 and ((t_time_375 + v2806.t0) <= v2802)) then
                 u855 = u855 + 1;
                 v2804 = v2806;
             end
             local v2807 = false;
             local v2808 = v2802 - (t_time_375 + v2804.t0);
             local v2809;
             if (v2804.b) then
                 v2809 = u845;
                 if (not v2809) then
                     v2807 = true;
                 end
             else
                 v2807 = true;
             end
             if (v2807) then
                 v2809 = Vector3.new(0, -80, 0);
             end
             local v2810 = ((v2804.p0 + (v2808 * v2804.v0)) + (((v2808 * v2808) / 2) * v2809)) + v2804.offset;
             if (not u860) then
                 local v2811 = u846.fromaxisangle(v2808 * v2804.rotv) * v2804.rot0;
                 local v2812 = v2804.glassbreaks;
                 local t_glassbreaks_376 = v2812;
                 local v2813 = 1;
                 local v2814 = #v2812;
                 local v2815 = v2814;
                 local v2816 = v2813;
                 if (not (v2814 <= v2816)) then
                     while true do
                         local v2817 = t_glassbreaks_376[v2813];
                         local v2818 = v2817;
                         if (v2817.part) then
                             local v2819 = u854;
                             local v2820 = t_time_375 + v2818.t;
                             if ((v2819 <= v2820) and ((t_time_375 + v2818.t) < v2802)) then
                                 u847:breakwindow(v2818.part);
                             end
                         end
                         local v2821 = v2813 + 1;
                         v2813 = v2821;
                         local v2822 = v2815;
                         if (v2822 < v2821) then
                             break;
                         end
                     end
                 end
                 u859.CFrame = v2811 + v2810;
                 if (u861) then
                     u861.Enabled = not workspace:FindPartOnRayWithWhitelist(u848(v2810, u849.cframe.p - v2810), u850.raycastwhitelist, true);
                 end
             end
             if ((t_time_375 + u858.blowuptime) < v2802) then
                 f_explode(v2810);
                 u856:Disconnect();
             end
         end
         u854 = v2802;
     end);
 end);
 local u862 = 1.25;
 local u863 = os.clock();
 local f_suppressionmult;
 f_suppressionmult = function()
     --[[
         Name: suppressionmult
         Line: 9298
         Upvalues: 
             [1] = u863
             [2] = u862
 
     --]]
     return (((2.718281828459045) ^ ((-(os.clock() - u863)) / 1)) * (1.25 - u862)) + u862;
 end;
 local f_normalizesuppression;
 f_normalizesuppression = function()
     --[[
         Name: normalizesuppression
         Line: 9303
         Upvalues: 
             [1] = f_suppressionmult
             [2] = u862
             [3] = u863
 
     --]]
     u862 = ((f_suppressionmult() - 0.5) / 1.1331484530668263) + 0.5;
     u863 = os.clock();
 end;
 local u864 = t_LocalPlayer_327;
 local u865 = v2412;
 local u866 = u16;
 local u867 = f_getupdater;
 local u868 = u4;
 local u869 = u18;
 local u870 = u11;
 local u871 = t_Dot_322;
 local u872 = u21;
 local u873 = u12;
 local u874 = u13;
 local u875 = v2413;
 local u876 = u19;
 u12:add("newbullets", function(p461)
     --[[
         Name: (empty)
         Line: 9311
         Upvalues: 
             [1] = u864
             [2] = u865
             [3] = u866
             [4] = u867
             [5] = u868
             [6] = u869
             [7] = u870
             [8] = u871
             [9] = f_suppressionmult
             [10] = u872
             [11] = u873
             [12] = u874
             [13] = f_normalizesuppression
             [14] = u875
             [15] = u876
 
     --]]
     local v2823 = nil;
     local t_player_377 = p461.player;
     local t_hideflash_378 = p461.hideflash;
     local t_hideminimap_379 = p461.hideminimap;
     local t_hiderange_380 = p461.hiderange;
     local t_pingdata_381 = p461.pingdata;
     local t_soundid_382 = p461.soundid;
     local t_snipercrack_383 = p461.snipercrack;
     local t_firepos_384 = p461.firepos;
     local v2824 = p461.pitch * (1 + (0.05 * math.random()));
     local t_volume_385 = p461.volume;
     local t_bullets_386 = p461.bullets;
     local v2825 = p461.bulletcolor;
     if (not v2825) then
         v2825 = Color3.new(0.7843137254901961, 0.27450980392156865, 0.27450980392156865);
     end
     local t_penetrationdepth_387 = p461.penetrationdepth;
     local v2826 = p461.suppression or 1;
     local v2827 = t_player_377.TeamColor ~= u864.TeamColor;
     local v2828 = {
         u865,
         workspace.Terrain,
         workspace.Ignore,
         u866.currentcamera
     };
     local v2829 = u867(t_player_377);
     local v2830 = v2829;
     if (v2829) then
         v2830.kickweapon(t_hideflash_378, t_soundid_382, v2824, t_volume_385);
         v2823 = v2830:getweaponpos();
     end
     if (not (t_hideminimap_379 and (not (t_hideminimap_379 and ((t_firepos_384 - u866.cframe.p).Magnitude <= t_hiderange_380))))) then
         local v2831 = v2830.getlookangles();
         local v2832 = CFrame.new(t_firepos_384) * CFrame.Angles(v2831.x, v2831.y, 0);
         local v2833 = v2832;
         if (v2832) then
             u868:fireradar(t_player_377, t_hideminimap_379, t_pingdata_381, v2833);
         end
     end
     local u877 = false;
     local u878 = false;
     local v2834 = 1;
     local v2835 = #t_bullets_386;
     local v2836 = v2835;
     local v2837 = v2834;
     if (not (v2835 <= v2837)) then
         while true do
             local v2838 = t_bullets_386[v2834];
             local t_new_388 = u869.new;
             local v2839 = {};
             v2839.position = t_firepos_384;
             v2839.velocity = v2838;
             v2839.acceleration = u870.bulletAcceleration;
             v2839.physicsignore = v2828;
             v2839.color = v2825;
             v2839.size = 0.2;
             v2839.bloom = 0.005;
             v2839.brightness = 400;
             v2839.life = u870.bulletLifeTime;
             v2839.visualorigin = v2823;
             v2839.penetrationdepth = t_penetrationdepth_387;
             v2839.thirdperson = true;
             local v2840 = v2827;
             if (v2840) then
                 local u879 = p461;
                 local u880 = v2826;
                 local u881 = t_snipercrack_383;
                 local u882 = t_player_377;
                 v2840 = function(p462, p463)
                     --[[
                         Name: (empty)
                         Line: 9370
                         Upvalues: 
                             [1] = u866
                             [2] = u871
                             [3] = u879
                             [4] = f_suppressionmult
                             [5] = u880
                             [6] = u877
                             [7] = u881
                             [8] = u872
                             [9] = u878
                             [10] = u873
                             [11] = u882
                             [12] = u874
                             [13] = f_normalizesuppression
 
                     --]]
                     local v2841 = p463 * p462.velocity;
                     local v2842 = v2841;
                     local v2843 = p462.position - v2841;
                     local v2844 = v2843;
                     local v2845 = u866.cframe.p;
                     local t_p_389 = v2845;
                     local v2846 = u871(v2845 - v2843, v2841) / u871(v2841, v2841);
                     if ((v2846 >= 0) and (v2846 <= 1)) then
                         local v2847 = ((v2844 + (v2846 * v2842)) - t_p_389).magnitude;
                         local t_magnitude_390 = v2847;
                         local v2848 = (math.clamp(((t_p_389 - u879.firepos).magnitude - u879.range0) / (u879.range1 - u879.range0), 0, 1) * (u879.damage1 - u879.damage0)) + u879.damage0;
                         local v2849 = f_suppressionmult() * u880;
                         local v2850;
                         if (v2847 <= 2) then
                             v2850 = 2;
                         else
                             v2850 = t_magnitude_390;
                         end
                         local v2851 = ((((v2849 / v2850) * u879.bulletspeed) / 512) * v2848) / u879.damage0;
                         if (t_magnitude_390 <= 50) then
                             if (not u877) then
                                 if (u881) then
                                     u872.PlaySound("crackBig", nil, 8 / t_magnitude_390);
                                 else
                                     if (t_magnitude_390 < 5) then
                                         u872.PlaySound("crackSmall", nil, 2);
                                     else
                                         u872.PlaySound("whizz", nil, 2 / t_magnitude_390);
                                     end
                                 end
                                 u877 = true;
                             end
                             if ((not u878) and (t_magnitude_390 <= 15)) then
                                 u878 = true;
                                 u873:send("supp\226\128\139ressionassist", u882, v2851);
                             end
                         end
                         u866:suppress(u874.random(v2851, v2851));
                         f_normalizesuppression();
                     end
                 end;
             end
             v2839.onstep = v2840;
             local f_ontouch;
             f_ontouch = function(p464, p465, p466, p467, p468, p469)
                 --[[
                     Name: ontouch
                     Line: 9405
                     Upvalues: 
                         [1] = u875
                         [2] = u876
                         [3] = u865
 
                 --]]
                 if (p465:IsDescendantOf(u875)) then
                     u876:bullethit(p465, p466, p467, p468, p469, p464.velocity, true, true);
                     return;
                 end
                 if (p465:IsDescendantOf(u865)) then
                     u876:bloodhit(p466, true, nil, p464.velocity / 10, true);
                 end
             end;
             v2839.ontouch = f_ontouch;
             t_new_388(v2839);
             local v2852 = v2834 + 1;
             v2834 = v2852;
             local v2853 = v2836;
             if (v2853 < v2852) then
                 break;
             end
         end
     end
 end);
 local u883 = nil;
 local u884 = 2;
 local u885 = 1;
 local f_sethighms;
 f_sethighms = function(p470)
     --[[
         Name: sethighms
         Line: 9422
         Upvalues: 
             [1] = u884
 
     --]]
     u884 = p470;
 end;
 u7.sethighms = f_sethighms;
 local f_setlowms;
 f_setlowms = function(p471)
     --[[
         Name: setlowms
         Line: 9426
         Upvalues: 
             [1] = u885
 
     --]]
     u885 = p471;
 end;
 u7.setlowms = f_setlowms;
 local u886 = 0;
 local u887 = 0;
 local v2854 = table.create(game:GetService("Players").MaxPlayers);
 local v2855 = table.create(game:GetService("Players").MaxPlayers);
 local v2856 = coroutine.create;
 local u888 = v2855;
 local u889 = u15;
 local v2857 = v2856(function()
     --[[
         Name: (empty)
         Line: 9435
         Upvalues: 
             [1] = u888
             [2] = u886
             [3] = u887
             [4] = u889
 
     --]]
     while true do
         local v2858 = u888[1].lastupframe;
         local v2859 = u886;
         if (v2858 == v2859) then
             coroutine.yield(true);
         else
             local v2860 = u887;
             local v2861 = tick();
             if (v2860 <= v2861) then
                 coroutine.yield(true);
             end
         end
         local v2862 = table.remove(u888, 1);
         local v2863 = v2862;
         local v2864 = v2862.updater;
         local t_updater_391 = v2864;
         if (v2864.alive) then
             local v2865 = false;
             if (t_updater_391) then
                 local v2866, v2867 = t_updater_391.getpos();
                 local v2868 = v2866;
                 local v2869 = v2867;
                 if (v2866 and v2867) then
                     local v2870 = u889.sphere(v2868, 4);
                     if (not v2870) then
                         v2870 = u889.sphere(v2869, 4);
                     end
                     v2865 = v2870;
                 end
             end
             if (v2865) then
                 t_updater_391.step(3, true);
             else
                 t_updater_391.step(1, false);
             end
         end
         v2863.lastupframe = u886;
         table.insert(u888, v2863);
     end
 end);
 local u890 = u679;
 local u891 = v2854;
 local u892 = v2855;
 local f_removecharacterhash = f_removecharacterhash;
 local u893 = v2857;
 local u894 = u12;
 local f_resumerep;
 f_resumerep = function()
     --[[
         Name: resumerep
         Line: 9476
         Upvalues: 
             [1] = u890
             [2] = u891
             [3] = u892
             [4] = f_removecharacterhash
             [5] = u886
             [6] = u887
             [7] = u885
             [8] = u884
             [9] = u893
             [10] = u883
             [11] = u894
 
     --]]
     local g_next_392 = next;
     local v2871 = u890;
     local v2872 = nil;
     while true do
         local v2873, v2874 = g_next_392(v2871, v2872);
         local v2875 = v2873;
         local v2876 = v2874;
         if (v2873) then
             v2872 = v2875;
             if (v2875.Parent) then
                 if ((v2876 and v2876.updater) and (not u891[v2876])) then
                     u891[v2876] = true;
                     table.insert(u892, v2876);
                 end
             else
                 print("PLAYER IS GONE", v2875);
                 local v2877 = 1;
                 local v2878 = #u892;
                 local v2879 = v2878;
                 local v2880 = v2877;
                 if (not (v2878 <= v2880)) then
                     while true do
                         if (u892[v2877] == v2876) then
                             warn("Updater was in queue", v2875);
                             table.remove(u892, v2877);
                         end
                         local v2881 = v2877 + 1;
                         v2877 = v2881;
                         local v2882 = v2879;
                         if (v2882 < v2881) then
                             break;
                         end
                     end
                 end
                 if (v2876 and v2876.updater) then
                     local v2883 = v2876.updater;
                     local t_updater_393 = v2883;
                     local v2884 = v2883.died();
                     local v2885 = v2884;
                     if (v2884) then
                         v2885:Destroy();
                     end
                     local v2886, v2887, v2888 = pairs(t_updater_393);
                     local v2889 = v2886;
                     local v2890 = v2887;
                     local v2891 = v2888;
                     while true do
                         local v2892, v2893 = v2889(v2890, v2891);
                         local v2894 = v2892;
                         if (v2892) then
                             v2891 = v2894;
                             t_updater_393[v2894] = nil;
                         else
                             break;
                         end
                     end
                 end
                 u890[v2875] = nil;
                 u891[v2876] = nil;
                 f_removecharacterhash(v2875);
             end
         else
             break;
         end
     end
     u886 = u886 + 1;
     u887 = tick() + ((u885 + u884) / 1000);
     local v2895 = #u892;
     if (v2895 >= 0) then
         local v2896, v2897 = coroutine.resume(u893);
         local v2898 = v2897;
         if (not v2896) then
             warn("CRITICAL: Replication thread yielded or errored");
             if (not u883) then
                 u883 = true;
                 u894:send("de\226\128\139b\226\128\139ug", string.format("Replication thread broke.\n%s", v2898));
             end
         end
     end
 end;
 local u895 = u2;
 local u896 = u16;
 local u897 = u12;
 local f_update;
 f_update = function()
     --[[
         Name: update
         Line: 9532
         Upvalues: 
             [1] = u677
             [2] = u895
             [3] = u896
             [4] = u897
 
     --]]
     local v2899 = tick();
     if ((u677 < v2899) and u895.alive) then
         u677 = (v2899 + 0.022222222222222223) - ((v2899 - u677) % 0.022222222222222223);
         local v2900 = u896.angles;
         u897:send("repup\226\128\139date", u895.rootpart.Position, Vector2.new(v2900.x, v2900.y), v2899);
     end
 end;
 u7.update = f_update;
 local f_step;
 f_step = function()
     --[[
         Name: step
         Line: 9543
         Upvalues: 
             [1] = f_resumerep
 
     --]]
     f_resumerep();
 end;
 u7.step = f_step;
 local f_cleanup;
 f_cleanup = function()
     --[[
         Name: cleanup
         Line: 9549
         Upvalues: 
             [1] = u678
 
     --]]
     local v2901 = 1;
     local v2902 = #u678;
     local v2903 = v2902;
     local v2904 = v2901;
     if (not (v2902 <= v2904)) then
         while true do
             u678[v2901]:Destroy();
             u678[v2901] = nil;
             local v2905 = v2901 + 1;
             v2901 = v2905;
             local v2906 = v2903;
             if (v2906 < v2905) then
                 break;
             end
         end
     end
 end;
 u7.cleanup = f_cleanup;
 local u898 = {};
 local v2907 = shared.require("BitBuffer229");
 local v2908 = v2549.new(v2548.new(0.020833333333333332), Vector3.new());
 local v2909 = v2549.new(v2547.new(0.020833333333333332), Vector2.new());
 local u899 = v2907.newReader();
 local f_read;
 f_read = function(p472)
     --[[
         Name: read
         Line: 9565
         Upvalues: 
             [1] = u899
 
     --]]
     return u899:read(p472);
 end;
 local u900 = t_LocalPlayer_327;
 local u901 = v2908;
 local u902 = v2909;
 local u903 = f_getupdater;
 local u904 = u899;
 local f_read = f_read;
 u12:add("bulkplayerupdate", function(p473)
     --[[
         Name: (empty)
         Line: 9569
         Upvalues: 
             [1] = u898
             [2] = u900
             [3] = u901
             [4] = u902
             [5] = u903
             [6] = u904
             [7] = f_read
 
     --]]
     if (p473.newarray) then
         u898 = p473.newarray;
     end
     if (p473.initstates) then
         local v2910 = p473.initstates;
         local t_initstates_394 = v2910;
         local v2911 = 1;
         local v2912 = #v2910;
         local v2913 = v2912;
         local v2914 = v2911;
         if (not (v2912 <= v2914)) then
             while true do
                 local v2915 = t_initstates_394[v2911];
                 local v2916 = u898[v2911];
                 local v2917 = v2916;
                 local v2918 = u900;
                 if (v2916 == v2918) then
                     local v2919, v2920 = unpack(v2915);
                     u901:initializeState(unpack(v2919));
                     u902:initializeState(unpack(v2920));
                 else
                     u903(v2917).initstate(v2915);
                 end
                 local v2921 = v2911 + 1;
                 v2911 = v2921;
                 local v2922 = v2913;
                 if (v2922 < v2921) then
                     break;
                 end
             end
         end
     end
     if (p473.packets) then
         local t_packets_395 = p473.packets;
         local v2923 = 1;
         local v2924 = #u898;
         local v2925 = v2924;
         local v2926 = v2923;
         if (not (v2924 <= v2926)) then
             while true do
                 local v2927 = u898[v2923];
                 local v2928 = u904:load(t_packets_395[v2923]);
                 local v2929 = f_read(1);
                 if (v2929 == 1) then
                     local v2930 = u900;
                     if (v2927 == v2930) then
                         f_read(64);
                         u901:readAndUpdate(f_read);
                         u902:readAndUpdate(f_read);
                     else
                         u903(v2927).updateReplication(f_read);
                     end
                 end
                 local v2931 = v2923 + 1;
                 v2923 = v2931;
                 local v2932 = v2925;
                 if (v2932 < v2931) then
                     break;
                 end
             end
         end
     end
 end);
 v17.Reset:connect(u7.cleanup);
 print("Requiring menu module");
 local v2933 = require(script.Parent.UIScript);
 local v2934 = {};
 v2934.superuser = v2;
 v2934.uiscaler = u20;
 v2934.vector = u13;
 v2934.cframe = u14;
 v2934.network = u12;
 v2934.playerdata = v20;
 v2934.effects = u19;
 v2934.animation = v23;
 v2934.input = u17;
 v2934.char = u2;
 v2934.camera = u16;
 v2934.chat = u3;
 v2934.hud = u4;
 v2934.leaderboard = u6;
 v2934.replication = u7;
 v2934.menu = u8;
 v2934.roundsystem = u9;
 v2934.gamelogic = u10;
 v2934.instancetype = v26;
 v2933(v2934);
 print("Requiring unlockstats module");
 local v2935 = require(script.Parent.UnlockStats);
 local v2936 = {};
 v2936.vector = u13;
 v2936.cframe = u14;
 v2936.network = u12;
 v2936.playerdata = v20;
 v2936.event = v21;
 v2936.sequencer = v22;
 v2936.particle = u18;
 v2936.sound = u21;
 v2936.effects = u19;
 v2936.tween = v24;
 v2936.animation = v23;
 v2936.input = u17;
 v2936.char = u2;
 v2936.camera = u16;
 v2936.chat = u3;
 v2936.hud = u4;
 v2936.notify = u5;
 v2936.leaderboard = u6;
 v2936.replication = u7;
 v2936.menu = u8;
 v2936.roundsystem = u9;
 v2936.gamelogic = u10;
 v2935(v2936);
 print("Loading roundsystem module client");
 local u905 = shared.require("Quotes");
 local v2937 = shared.require("ObjectiveManagerClient");
 local v2938 = workspace.Map;
 local v2939 = game:GetService("ReplicatedStorage"):WaitForChild("ServerSettings");
 local u906 = v2939:WaitForChild("Countdown");
 local u907 = v2939:WaitForChild("Timer");
 local u908 = v2939:WaitForChild("MaxScore");
 local u909 = v2939:WaitForChild("GhostScore");
 local u910 = v2939:WaitForChild("PhantomScore");
 local u911 = v2939:WaitForChild("ShowResults");
 local u912 = v2939:WaitForChild("Winner");
 local u913 = v2939:WaitForChild("GameMode");
 local t_LocalPlayer_396 = game:GetService("Players").LocalPlayer;
 local v2940 = t_LocalPlayer_396:WaitForChild("PlayerGui"):WaitForChild("MainGui");
 local u914 = v2940:WaitForChild("CountDown");
 local u915 = u914:WaitForChild("TeamName");
 local u916 = u914:WaitForChild("Title");
 local u917 = u914:WaitForChild("Number");
 local u918 = u914:WaitForChild("Tip");
 local v2941 = v2940:WaitForChild("GameGui"):WaitForChild("Round");
 local v2942 = v2941:WaitForChild("Score");
 local u919 = v2941:WaitForChild("GameMode");
 local u920 = v2942:WaitForChild("Ghosts");
 local u921 = v2942:WaitForChild("Phantoms");
 local u922 = v2942:WaitForChild("Time");
 local u923 = v2940:WaitForChild("EndMatch");
 local u924 = u923:WaitForChild("Quote");
 local u925 = u923:WaitForChild("Result");
 local u926 = u923:WaitForChild("Mode");
 u9.lock = false;
 u9.raycastwhitelist = {
     v2938
 };
 local u927 = nil;
 local u928 = v2937;
 local f_setupobjectives;
 f_setupobjectives = function(p474)
     --[[
         Name: setupobjectives
         Line: 9740
         Upvalues: 
             [1] = u928
             [2] = u927
 
     --]]
     u928:clear();
     if (u927) then
         u927:Disconnect();
     end
     local v2943 = p474:FindFirstChild("AGMP");
     local v2944 = v2943;
     if (v2943) then
         local g_next_397 = next;
         local v2945, v2946 = v2944:GetChildren();
         local v2947 = v2945;
         local v2948 = v2946;
         while true do
             local v2949, v2950 = g_next_397(v2947, v2948);
             local v2951 = v2949;
             local v2952 = v2950;
             if (v2949) then
                 v2948 = v2951;
                 u928:add(v2952);
             else
                 break;
             end
         end
         u927 = v2944.ChildAdded:connect(function(p475)
             --[[
                 Name: (empty)
                 Line: 9753
                 Upvalues: 
                     [1] = u928
 
             --]]
             u928:add(p475);
         end);
     end
 end;
 u12:add("newmap", f_setupobjectives);
 f_setupobjectives(v2938);
 local f_spawnplayer;
 f_spawnplayer = function()
     --[[
         Name: spawnplayer
         Line: 9762
         Upvalues: 
             [1] = u8
 
     --]]
     u8:roundstartspawn();
 end;
 local f_updateteam;
 f_updateteam = function(p476)
     --[[
         Name: updateteam
         Line: 9767
         Upvalues: 
             [1] = u919
             [2] = u913
             [3] = t_LocalPlayer_396
             [4] = u920
             [5] = u921
 
     --]]
     u919.Text = u913.Value;
     local v2953 = t_LocalPlayer_396.TeamColor;
     local t_TeamColor_398 = game.Teams.Phantoms.TeamColor;
     if (v2953 == t_TeamColor_398) then
         u920.Position = UDim2.new(0.5, -48, 0, 44);
         u921.Position = UDim2.new(0.5, -48, 0, 28);
         return;
     end
     u921.Position = UDim2.new(0.5, -48, 0, 44);
     u920.Position = UDim2.new(0.5, -48, 0, 28);
 end;
 u4.updateteam = f_updateteam;
 local f_updatescore;
 f_updatescore = function()
     --[[
         Name: updatescore
         Line: 9778
         Upvalues: 
             [1] = u920
             [2] = u909
             [3] = u908
             [4] = u921
             [5] = u910
 
     --]]
     u920.Percent.Size = UDim2.new(u909.Value / u908.Value, 0, 1, 0);
     u920.Point.Text = u909.Value;
     u921.Percent.Size = UDim2.new(u910.Value / u908.Value, 0, 1, 0);
     u921.Point.Text = u910.Value;
 end;
 local f_count;
 f_count = function()
     --[[
         Name: count
         Line: 9785
         Upvalues: 
             [1] = u9
             [2] = u918
             [3] = u17
             [4] = u2
             [5] = u915
             [6] = t_LocalPlayer_396
             [7] = u914
             [8] = u917
             [9] = u907
             [10] = u916
 
     --]]
     u9.lock = true;
     local v2954 = u918;
     local v2955;
     if (u17.consoleon) then
         v2955 = "Press ButtonSelect to return to menu";
     else
         v2955 = "Press F5 to return to menu";
     end
     v2954.Text = v2955;
     if (u2.alive) then
         local v2956 = u915;
         local v2957 = t_LocalPlayer_396.TeamColor;
         local t_TeamColor_399 = game.Teams.Ghosts.TeamColor;
         local v2958;
         if (v2957 == t_TeamColor_399) then
             v2958 = "Ghosts";
         else
             v2958 = "Phantoms";
         end
         v2956.Text = v2958;
         u915.Visible = true;
         u915.TextColor3 = t_LocalPlayer_396.TeamColor.Color;
         u914.Visible = true;
         u917.FontSize = 9;
         u917.Text = u907.Value;
         local v2959 = 9;
         local v2960 = v2959;
         if (not (v2960 <= 7)) then
             while true do
                 u917.FontSize = v2959;
                 task.wait(0.03333333333333333);
                 local v2961 = v2959 + -1;
                 v2959 = v2961;
                 if (v2961 < 7) then
                     break;
                 end
             end
         end
         local t_Value_400 = u907.Value;
         if (t_Value_400 == 0) then
             task.wait(1);
             u9.lock = false;
             task.wait(2);
             u914.Visible = false;
             return;
         end
         u914.BackgroundTransparency = 0.5;
         u917.TextTransparency = 0;
         u916.TextTransparency = 0;
         u916.TextStrokeTransparency = 0.5;
     end
 end;
 local f_matchclock;
 f_matchclock = function()
     --[[
         Name: matchclock
         Line: 9813
         Upvalues: 
             [1] = u907
             [2] = u922
 
     --]]
     local v2962 = u907.Value % 60;
     if (v2962 <= 10) then
         v2962 = "0" .. v2962;
     end
     u922.Text = math.floor(u907.Value / 60) .. (":" .. v2962);
 end;
 local f_timerchange;
 f_timerchange = function()
     --[[
         Name: timerchange
         Line: 9821
         Upvalues: 
             [1] = u906
             [2] = u922
             [3] = f_count
             [4] = u911
             [5] = u9
             [6] = u914
             [7] = f_matchclock
 
     --]]
     if (u906.Value) then
         u922.Text = "COUNTDOWN";
         f_count();
         return;
     end
     if (not u911.Value) then
         u9.lock = false;
     end
     u914.Visible = false;
     f_matchclock();
 end;
 local f_setresult;
 f_setresult = function()
     --[[
         Name: setresult
         Line: 9834
         Upvalues: 
             [1] = u911
             [2] = u9
             [3] = u924
             [4] = u905
             [5] = u923
             [6] = u926
             [7] = u913
             [8] = u912
             [9] = t_LocalPlayer_396
             [10] = u925
 
     --]]
     if (not u911.Value) then
         u923.Visible = false;
         return;
     end
     u9.lock = true;
     u924.Text = u905[math.random(1, #u905)];
     u923.Visible = true;
     u926.Text = u913.Value;
     local v2963 = u912.Value;
     local t_TeamColor_401 = t_LocalPlayer_396.TeamColor;
     if (v2963 == t_TeamColor_401) then
         u925.Text = "VICTORY";
         u925.TextColor = BrickColor.new("Bright green");
         return;
     end
     local v2964 = u912.Value;
     local v2965 = BrickColor.new("Black");
     if (v2964 == v2965) then
         u925.Text = "STALEMATE";
         u925.TextColor = BrickColor.new("Bright orange");
         return;
     end
     u925.Text = "DEFEAT";
     u925.TextColor = BrickColor.new("Bright red");
 end;
 if (u906.Value) then
     f_count();
 end
 f_setresult();
 u907.Changed:connect(f_timerchange);
 u909.Changed:connect(f_updatescore);
 u910.Changed:connect(f_updatescore);
 u911.Changed:connect(f_setresult);
 f_updatescore();
 print("Loading game logic module");
 local v2966 = u2.loadknife;
 local v2967 = u2.loadgun;
 u2.loadknife = nil;
 u2.loadgun = nil;
 local v2968 = game.Debris;
 local v2969 = game.ReplicatedStorage;
 local v2970 = game:GetService("RunService");
 local v2971 = game:GetService("Players").LocalPlayer;
 local v2972 = v2971.PlayerGui;
 local u929 = {};
 local u930 = 1;
 local u931 = nil;
 local u932 = nil;
 local u933 = nil;
 local u934 = nil;
 local u935 = nil;
 local u936 = nil;
 local u937 = nil;
 local u938 = nil;
 local u939 = nil;
 local u940 = 0;
 u10.currentgun = nil;
 u10.gammo = 3;
 local f_setsprintdisable;
 f_setsprintdisable = function(p477)
     --[[
         Name: setsprintdisable
         Line: 9887
         Upvalues: 
             [1] = u937
 
     --]]
     u937 = p477;
 end;
 u10.setsprintdisable = f_setsprintdisable;
 local u941 = u10;
 local u942 = u2;
 local u943 = u929;
 local f_switch;
 f_switch = function(p478)
     --[[
         Name: switch
         Line: 9891
         Upvalues: 
             [1] = u933
             [2] = u941
             [3] = u942
             [4] = u930
             [5] = u943
 
     --]]
     if (((not u933) and u941.currentgun) and (not u942.grenadehold)) then
         local v2973;
         if (p478 == "one") then
             v2973 = 1;
         else
             if (p478 == "two") then
                 v2973 = 2;
             else
                 v2973 = (((u930 + p478) - 1) % (#u943)) + 1;
             end
         end
         u930 = v2973;
         local v2974 = u943[u930];
         local v2975 = v2974;
         if (v2974) then
             local t_currentgun_402 = u941.currentgun;
             if (v2975 ~= t_currentgun_402) then
                 u941.currentgun:setequipped(false);
                 u941.currentgun = v2975;
                 v2975:setequipped(true);
                 task.wait(0.4);
                 u933 = false;
             end
         end
     end
 end;
 local u944 = u929;
 local u945 = u2;
 local t_ReplicatedStorage_403 = v2969;
 local t_loadgun_404 = v2967;
 local t_loadknife_405 = v2966;
 local u946 = u10;
 local u947 = u4;
 local u948 = u8;
 local u949 = u17;
 local u950 = u3;
 local u951 = u19;
 local u952 = u16;
 local f_loadmodules;
 f_loadmodules = function(p479, p480, p481, p482, p483, p484)
     --[[
         Name: loadmodules
         Line: 9906
         Upvalues: 
             [1] = u944
             [2] = u931
             [3] = u945
             [4] = t_ReplicatedStorage_403
             [5] = u930
             [6] = t_loadgun_404
             [7] = t_loadknife_405
             [8] = u946
             [9] = u947
             [10] = u948
             [11] = u949
             [12] = u950
             [13] = u951
             [14] = u952
 
     --]]
     local v2976 = 1;
     local v2977 = #u944;
     local v2978 = v2977;
     local v2979 = v2976;
     if (not (v2977 <= v2979)) then
         while true do
             local v2980 = u944[v2976];
             local v2981 = v2980;
             if (v2980) then
                 v2981:destroy("death");
                 u944[v2976] = nil;
             end
             local v2982 = v2976 + 1;
             v2976 = v2982;
             local v2983 = v2978;
             if (v2983 < v2982) then
                 break;
             end
         end
     end
     if (u931) then
         u931:destroy();
     end
     u945.updatecharacter(p479);
     u945:loadarms(t_ReplicatedStorage_403.Character["Left Arm"]:Clone(), t_ReplicatedStorage_403.Character["Right Arm"]:Clone(), "Arm", "Arm");
     u930 = 1;
     u944[1] = t_loadgun_404(p480.Name, false, false, p480.Attachments, p482, p480.Camo, 1);
     if (p481) then
         u944[2] = t_loadgun_404(p481.Name, false, false, p481.Attachments, p483, p481.Camo, 2);
     end
     u931 = t_loadknife_405(p484.Name or "KNIFE", p484.Camo);
     u946.gammo = 3;
     u947:updateammo("GRENADE", 3);
     u948.hidemenu();
     u948.setlighting();
     u949.mouse.hide();
     u949.mouse.lockcenter();
     u947:updateteam();
     u947:enablegamegui(true);
     u947:set_minimap();
     u950:ingame();
     u951:enableshadows(u951.shadows);
     u945.alive = true;
     u952.type = "firstperson";
     u946.currentgun = u944[u930];
     u946.currentgun:setequipped(true);
 end;
 local u953 = u10;
 local t_loadknife_406 = v2966;
 local f_swapknife;
 f_swapknife = function(p485, p486, p487)
     --[[
         Name: swapknife
         Line: 9956
         Upvalues: 
             [1] = u933
             [2] = u953
             [3] = u931
             [4] = t_loadknife_406
 
     --]]
     u933 = true;
     local v2984 = u953.currentgun;
     local v2985 = u931;
     if (v2984 == v2985) then
         u953.currentgun:setequipped(false);
     else
         u931:destroy();
     end
     if (not p487) then
         task.wait(0.4);
     end
     u931 = nil;
     if (not p487) then
         task.wait(0.1);
     end
     u931 = t_loadknife_406(p485, p486);
     u953.currentgun = u931;
     u953.currentgun:setequipped(true);
     if (not p487) then
         task.wait(0.4);
     end
     u933 = false;
 end;
 local u954 = u10;
 local u955 = u929;
 local t_loadgun_407 = v2967;
 local f_swapgun;
 f_swapgun = function(p488, p489, p490, p491, p492, p493, p494, p495)
     --[[
         Name: swapgun
         Line: 9983
         Upvalues: 
             [1] = u933
             [2] = u930
             [3] = u954
             [4] = u955
             [5] = t_loadgun_407
             [6] = u934
 
     --]]
     u933 = true;
     u930 = p494;
     if (u954.currentgun) then
         u954.currentgun:setequipped(false);
     end
     if (not p495) then
         task.wait(0.4);
     end
     if (u955[p494]) then
         u955[p494]:destroy();
         u955[p494] = nil;
     end
     if (not p495) then
         task.wait(0.4);
     end
     local v2986 = t_loadgun_407(p488, p489, p490, p491, p492, p493, p494);
     u955[p494] = v2986;
     u954.currentgun = v2986;
     u934 = v2986;
     v2986:setequipped(true);
     if (not p495) then
         task.wait(0.4);
     end
     u933 = false;
 end;
 local f_removeweapon;
 f_removeweapon = function(p496)
     --[[
         Name: removeweapon
         Line: 10017
         Upvalues: 
             [1] = u929
 
     --]]
     if (u929[p496]) then
         u929[p496]:remove();
         u929[p496] = nil;
     end
 end;
 local v2987 = u17.mouse.onbuttondown;
 local u956 = u10;
 v2987:connect(function(p497)
     --[[
         Name: (empty)
         Line: 10024
         Upvalues: 
             [1] = u956
             [2] = u933
 
     --]]
     if (not (u956.currentgun and (not u933))) then
         return;
     end
     if (not ((p497 == "left") and u956.currentgun.shoot)) then
         if (p497 == "right") then
             if (u956.currentgun.inspecting()) then
                 u956.currentgun:reloadcancel(true);
             end
             if (u956.currentgun.setaim) then
                 u956.currentgun:setaim(true);
                 return;
             end
             local t_type_409 = u956.currentgun.type;
             if (t_type_409 == "KNIFE") then
                 u956.currentgun:shoot(false, "stab2");
             end
         end
         return;
     end
     if (u956.currentgun.inspecting()) then
         u956.currentgun:reloadcancel(true);
     end
     local t_type_408 = u956.currentgun.type;
     if (t_type_408 == "KNIFE") then
         u956.currentgun:shoot(false, "stab1");
         return;
     end
     u956.currentgun:shoot(true);
 end);
 u17.mouse.onscroll:connect(function(p498)
     --[[
         Name: (empty)
         Line: 10053
         Upvalues: 
             [1] = u2
             [2] = f_switch
 
     --]]
     if (not u2.grenadehold) then
         local v2988;
         if (p498 >= 0) then
             v2988 = 1;
         else
             v2988 = -1;
         end
         f_switch(v2988);
     end
 end);
 u17.mouse.onbuttonup:connect(function(p499)
     --[[
         Name: (empty)
         Line: 10060
         Upvalues: 
             [1] = u10
 
     --]]
     if (not u10.currentgun) then
         return;
     end
     if ((p499 == "left") and u10.currentgun.shoot) then
         local t_type_410 = u10.currentgun.type;
         if (t_type_410 ~= "KNIFE") then
             u10.currentgun:shoot(false);
             return;
         end
     else
         if ((p499 == "right") and u10.currentgun.setaim) then
             u10.currentgun:setaim(false);
         end
     end
 end);
 local v2989 = u17.keyboard.onkeydown;
 local u957 = u17;
 local u958 = u4;
 local u959 = u10;
 local u960 = u2;
 local u961 = u9;
 local u962 = v2970;
 local t_PlayerGui_411 = v2972;
 local t_Debris_412 = v2968;
 local u963 = v2;
 local u964 = u929;
 local u965 = u12;
 local u966 = f_switch;
 local u967 = v26;
 local t_LocalPlayer_413 = v2971;
 local u968 = u1;
 local u969 = u7;
 v2989:connect(function(p500)
     --[[
         Name: (empty)
         Line: 10074
         Upvalues: 
             [1] = u957
             [2] = u958
             [3] = u959
             [4] = u960
             [5] = u961
             [6] = u962
             [7] = u940
             [8] = u932
             [9] = u937
             [10] = u938
             [11] = u933
             [12] = u936
             [13] = u931
             [14] = u934
             [15] = u935
             [16] = t_PlayerGui_411
             [17] = t_Debris_412
             [18] = u963
             [19] = u930
             [20] = u964
             [21] = u965
             [22] = u966
             [23] = u939
             [24] = u967
             [25] = t_LocalPlayer_413
             [26] = u968
             [27] = u969
 
     --]]
     if ((p500 == "f6") and (not u957.keyboard.down.leftcontrol)) then
         u958.streamermodetoggle = not u958.streamermodetoggle;
     end
     if (not (u959.currentgun and u960.alive)) then
         return;
     end
     if (((u961.lock and (not (p500 == "h"))) and (not ((p500 == "q") or (p500 == "f")))) and (not (((p500 == "one") or (p500 == "two")) or (p500 == "three")))) then
         return;
     end
     if (u962:IsStudio()) then
         u957.mouse:lockcenter();
     end
     if (p500 == "space") then
         local v2990 = u940;
         local v2991 = tick();
         if (v2990 <= v2991) then
             if (u960:jump(4)) then
                 u940 = tick() + 0.6666666666666666;
                 return;
             end
             u940 = tick() + 0.25;
             return;
         end
     else
         if (p500 == "c") then
             if (not (u960.getslidecondition() and (not u932))) then
                 local v2992 = u960;
                 local t_movementmode_414 = u960.movementmode;
                 local v2993;
                 if (t_movementmode_414 == "crouch") then
                     v2993 = "prone";
                 else
                     v2993 = "crouch";
                 end
                 v2992:setmovementmode(v2993);
                 return;
             end
             u932 = true;
             u960:setmovementmode("crouch", u932);
             task.wait(0.2);
             u937 = false;
             task.wait(0.9);
             u932 = false;
             return;
         end
         if (p500 == "x") then
             if (u960.sprinting() and (not u932)) then
                 u932 = true;
                 u960:setmovementmode("prone", u932);
                 task.wait(0.8);
                 u937 = false;
                 if (u960.sprinting() and (not u937)) then
                     u960:setsprint(true);
                 end
                 task.wait(1.8);
                 u932 = false;
                 return;
             end
             if (not u932) then
                 local v2994 = u960;
                 local t_movementmode_415 = u960.movementmode;
                 local v2995;
                 if (t_movementmode_415 == "crouch") then
                     v2995 = "stand";
                 else
                     v2995 = "crouch";
                 end
                 v2994:setmovementmode(v2995);
                 return;
             end
         else
             if (p500 == "leftcontrol") then
                 if (not (u960.getslidecondition() and (not u932))) then
                     u960:setmovementmode("prone");
                     return;
                 end
                 u932 = true;
                 u960:setmovementmode("crouch", u932);
                 task.wait(0.2);
                 u937 = false;
                 task.wait(0.9);
                 u932 = false;
                 return;
             end
             if (p500 == "z") then
                 if (u960.sprinting() and (not u932)) then
                     u932 = true;
                     u960:setmovementmode("prone", u932);
                     task.wait(0.8);
                     u937 = false;
                     task.wait(1.8);
                     u932 = false;
                     return;
                 end
                 if (not u932) then
                     u960:setmovementmode("stand");
                     return;
                 end
             else
                 if (p500 == "r") then
                     if ((u938 or u960.grenadehold) or u933) then
                         return;
                     end
                     if (u959.currentgun.reload and (not u959.currentgun.data.loosefiring)) then
                         u959.currentgun:reload();
                         return;
                     end
                 else
                     if (p500 == "e") then
                         if (((not u960.grenadehold) and u959.currentgun.playanimation) and (not u936)) then
                             u936 = true;
                             if (u958:spot()) then
                                 u959.currentgun:playanimation("spot");
                             end
                             task.wait(1);
                             u936 = false;
                             return;
                         end
                     else
                         if (p500 == "f") then
                             if (u938 or u960.grenadehold) then
                                 return;
                             end
                             local v2996 = u959.currentgun;
                             local v2997 = u931;
                             if (v2996 == v2997) then
                                 u959.currentgun:shoot();
                                 return;
                             end
                             u938 = true;
                             if (u931) then
                                 u934 = u959.currentgun;
                                 u959.currentgun = u931;
                             end
                             u959.currentgun:setequipped(true, "stab1");
                             u933 = true;
                             task.wait(0.5);
                             if ((not u957.keyboard.down.f) and u934) then
                                 u959.currentgun = u934;
                                 if (u934) then
                                     u934:setequipped(true);
                                 end
                             end
                             u933 = false;
                             task.wait(0.5);
                             u938 = false;
                             return;
                         end
                         if (p500 == "g") then
                             if (not ((u938 or u933) or u960.grenadehold)) then
                                 local t_gammo_416 = u959.gammo;
                                 if (t_gammo_416 >= 0) then
                                     u935 = u960:loadgrenade("FRAG", u959.currentgun);
                                     u935:setequipped(true);
                                     task.wait(0.3);
                                     u933 = false;
                                     u935:pull();
                                     return;
                                 end
                             end
                         else
                             if (p500 == "h") then
                                 if (u959.currentgun.isaiming() and u959.currentgun.isblackscope()) then
                                     return;
                                 end
                                 if (not ((u960.grenadehold or u936) or u959.currentgun.inspecting())) then
                                     u959.currentgun:playanimation("inspect");
                                     return;
                                 end
                             else
                                 if (p500 == "leftshift") then
                                     if (u959.currentgun.isaiming() and u959.currentgun.isblackscope()) then
                                         return;
                                     end
                                     if (not u937) then
                                         if (u957.sprinttoggle) then
                                             u960:setsprint(not u960.sprinting());
                                             return;
                                         end
                                         u960:setsprint(true);
                                         return;
                                     end
                                 else
                                     if (p500 == "w") then
                                         if (t_PlayerGui_411:FindFirstChild("Doubletap") or u960.sprinting()) then
                                             if (u959.currentgun.isaiming() and u959.currentgun.isblackscope()) then
                                                 return;
                                             end
                                             if (not u937) then
                                                 u960:setsprint(true);
                                                 return;
                                             end
                                         else
                                             local v2998 = Instance.new("Model");
                                             v2998.Name = "Doubletap";
                                             v2998.Parent = t_PlayerGui_411;
                                             t_Debris_412:AddItem(v2998, 0.2);
                                             return;
                                         end
                                     else
                                         if (p500 == "q") then
                                             if (u960.grenadehold or u933) then
                                                 return;
                                             end
                                             if (u959.currentgun.inspecting()) then
                                                 u959.currentgun:reloadcancel(true);
                                             end
                                             if (u959.currentgun.setaim) then
                                                 u959.currentgun:setaim(not u959.currentgun.isaiming());
                                                 return;
                                             end
                                         else
                                             if (p500 == "m") then
                                                 if (u963) then
                                                     if (u957.mouse:visible()) then
                                                         u957.mouse:hide();
                                                         return;
                                                     end
                                                     u957.mouse:show();
                                                     return;
                                                 end
                                             else
                                                 if (p500 == "t") then
                                                     if (u959.currentgun.toggleattachment) then
                                                         u959.currentgun:toggleattachment();
                                                         return;
                                                     end
                                                 else
                                                     if (p500 == "v") then
                                                         if (u933 or u960.grenadehold) then
                                                             return;
                                                         end
                                                         if (u958:getuse()) then
                                                             local u970 = u959.currentgun;
                                                             task.delay(0.15, function()
                                                                 --[[
                                                                     Name: (empty)
                                                                     Line: 10269
                                                                     Upvalues: 
                                                                         [1] = u957
                                                                         [2] = u960
                                                                         [3] = u970
                                                                         [4] = u931
                                                                         [5] = u930
                                                                         [6] = u959
                                                                         [7] = u964
                                                                         [8] = u965
 
                                                                 --]]
                                                                 if (not u957.keyboard.down.v) then
                                                                     return;
                                                                 end
                                                                 local v2999 = workspace.Ignore.GunDrop:GetChildren();
                                                                 local v3000 = v2999;
                                                                 local v3001 = 8;
                                                                 local v3002 = nil;
                                                                 local v3003 = nil;
                                                                 local v3004 = 1;
                                                                 local v3005 = #v2999;
                                                                 local v3006 = v3005;
                                                                 local v3007 = v3004;
                                                                 if (not (v3005 <= v3007)) then
                                                                     while true do
                                                                         local v3008 = v3000[v3004];
                                                                         local v3009 = v3008;
                                                                         local t_Name_417 = v3008.Name;
                                                                         if (t_Name_417 == "Dropped") then
                                                                             local v3010 = (v3009.Slot1.Position - u960.rootpart.Position).magnitude;
                                                                             local t_magnitude_418 = v3010;
                                                                             if (v3010 <= v3001) then
                                                                                 if (v3009:FindFirstChild("Gun")) then
                                                                                     v3001 = t_magnitude_418;
                                                                                     v3002 = v3009;
                                                                                     v3003 = nil;
                                                                                 else
                                                                                     if (v3009:FindFirstChild("Knife")) then
                                                                                         v3001 = t_magnitude_418;
                                                                                         v3003 = v3009;
                                                                                         v3002 = nil;
                                                                                     end
                                                                                 end
                                                                             end
                                                                         end
                                                                         local v3011 = v3004 + 1;
                                                                         v3004 = v3011;
                                                                         local v3012 = v3006;
                                                                         if (v3012 < v3011) then
                                                                             break;
                                                                         end
                                                                     end
                                                                 end
                                                                 if (not v3002) then
                                                                     if (v3003) then
                                                                         u965:send("swapw\226\128\139eapon", v3003, 3);
                                                                         print("sent knife");
                                                                     end
                                                                     return;
                                                                 end
                                                                 local v3013 = u970;
                                                                 local v3014 = u931;
                                                                 if (v3013 == v3014) then
                                                                     u930 = 2;
                                                                     u959.currentgun = u964[u930];
                                                                     u970 = u959.currentgun;
                                                                     u959.currentgun:setequipped(true);
                                                                 end
                                                                 u965:send("swa\226\128\139pweapon", v3002, u930);
                                                             end);
                                                             return;
                                                         end
                                                         if (u959.currentgun.nextfiremode) then
                                                             u959.currentgun:nextfiremode();
                                                             return;
                                                         end
                                                     else
                                                         if ((p500 == "one") or (p500 == "two")) then
                                                             if (not u960.grenadehold) then
                                                                 u966(p500);
                                                                 return;
                                                             end
                                                         else
                                                             if (p500 == "three") then
                                                                 local v3015 = u959.currentgun;
                                                                 local v3016 = u931;
                                                                 if ((v3015 == v3016) or u960.grenadehold) then
                                                                     return;
                                                                 end
                                                                 if (u931) then
                                                                     u934 = u959.currentgun;
                                                                     u959.currentgun = u931;
                                                                 end
                                                                 u959.currentgun:setequipped(true);
                                                                 task.wait(0.5);
                                                                 u933 = false;
                                                                 return;
                                                             end
                                                             if ((p500 == "f5") or (p500 == "f8")) then
                                                                 if (u939 or u957.keyboard.down.leftshift) then
                                                                     return;
                                                                 end
                                                                 u939 = true;
                                                                 u960:despawn();
                                                                 if (not (u967.IsTest() or u967.IsVIP())) then
                                                                     local v3017 = game:GetService("ReplicatedStorage"):WaitForChild("Misc").RespawnGui.Title:Clone();
                                                                     local v3018 = v3017;
                                                                     v3017.Parent = t_LocalPlayer_413.PlayerGui:FindFirstChild("MainGui");
                                                                     local v3019 = 5;
                                                                     local v3020 = v3019;
                                                                     if (not (v3020 <= 0)) then
                                                                         while true do
                                                                             if (not u968) then
                                                                                 v3018.Count.Text = v3019;
                                                                                 task.wait(1);
                                                                             end
                                                                             local v3021 = v3019 + -1;
                                                                             v3019 = v3021;
                                                                             if (v3021 < 0) then
                                                                                 break;
                                                                             end
                                                                         end
                                                                     end
                                                                     v3018:Destroy();
                                                                 end
                                                                 u939 = false;
                                                                 return;
                                                             end
                                                             if (p500 == "l") then
                                                                 local g_next_419 = next;
                                                                 local v3022, v3023 = game:GetService("Players"):GetPlayers();
                                                                 local v3024 = v3022;
                                                                 local v3025 = v3023;
                                                                 while true do
                                                                     local v3026, v3027 = g_next_419(v3024, v3025);
                                                                     local v3028 = v3026;
                                                                     local v3029 = v3027;
                                                                     if (v3026) then
                                                                         v3025 = v3028;
                                                                         local t_LocalPlayer_420 = game:GetService("Players").LocalPlayer;
                                                                         if (v3029 ~= t_LocalPlayer_420) then
                                                                             local v3030 = u969.getupdater(v3029);
                                                                             local v3031 = v3030;
                                                                             if (v3030) then
                                                                                 print(v3029, v3031.getpos(), v3031.getlookangles());
                                                                             end
                                                                         end
                                                                     else
                                                                         break;
                                                                     end
                                                                 end
                                                             end
                                                         end
                                                     end
                                                 end
                                             end
                                         end
                                     end
                                 end
                             end
                         end
                     end
                 end
             end
         end
     end
 end);
 u17.keyboard.onkeyup:connect(function(p501)
     --[[
         Name: (empty)
         Line: 10352
         Upvalues: 
             [1] = u10
             [2] = u17
             [3] = u2
 
     --]]
     if (not u10.currentgun) then
         return;
     end
     if (((p501 == "leftshift") or ((p501 == "w") and (not u17.keyboard.down.leftshift))) and (not u17.sprinttoggle)) then
         u2:setsprint(false);
     end
 end);
 u17.controller:map("a", "space");
 u17.controller:map("x", "r");
 u17.controller:map("r1", "g");
 u17.controller:map("up", "h");
 u17.controller:map("r3", "f");
 u17.controller:map("right", "v");
 u17.controller:map("down", "e");
 u17.controller:map("left", "t");
 local u971 = nil;
 local v3032 = u17.controller.onbuttondown;
 local u972 = u10;
 local u973 = u9;
 local u974 = u2;
 local u975 = u4;
 local u976 = u17;
 local u977 = u929;
 local u978 = u12;
 v3032:connect(function(p502)
     --[[
         Name: (empty)
         Line: 10372
         Upvalues: 
             [1] = u972
             [2] = u973
             [3] = u974
             [4] = u932
             [5] = u937
             [6] = u936
             [7] = u975
             [8] = u933
             [9] = u971
             [10] = u976
             [11] = u931
             [12] = u930
             [13] = u977
             [14] = u978
             [15] = u939
 
     --]]
     if (not u972.currentgun) then
         return;
     end
     if (u973.lock) then
         return;
     end
     if (p502 ~= "b") then
         if (not ((p502 == "r2") and u972.currentgun.shoot)) then
             if (p502 == "l2") then
                 if (u972.currentgun.inspecting()) then
                     u972.currentgun:reloadcancel(true);
                 end
                 if (u972.currentgun.setaim) then
                     u972.currentgun:setaim(true);
                     return;
                 end
                 local t_type_422 = u972.currentgun.type;
                 if (t_type_422 == "KNIFE") then
                     u972.currentgun:shoot(false, "stab2");
                     return;
                 end
             else
                 if (p502 == "l1") then
                     if (u974.sprinting() and (not u932)) then
                         u932 = true;
                         u974:setmovementmode("prone", u932);
                         task.wait(0.8);
                         u937 = false;
                         task.wait(1.8);
                         u932 = false;
                         return;
                     end
                     if (((not u974.grenadehold) and u972.currentgun.playanimation) and (not u936)) then
                         u936 = true;
                         if (u975:spot()) then
                             u972.currentgun:playanimation("spot");
                         end
                         task.wait(1);
                         u936 = false;
                         return;
                     end
                 else
                     if (p502 == "y") then
                         if (u933 or u974.grenadehold) then
                             return;
                         end
                         u971 = false;
                         if (u975:getuse()) then
                             task.delay(0.2, function()
                                 --[[
                                     Name: (empty)
                                     Line: 10434
                                     Upvalues: 
                                         [1] = u976
                                         [2] = u971
                                         [3] = u974
                                         [4] = u972
                                         [5] = u931
                                         [6] = u930
                                         [7] = u977
                                         [8] = u978
 
                                 --]]
                                 if (not u976.controller.down.y) then
                                     return;
                                 end
                                 u971 = true;
                                 local v3033 = workspace.Ignore.GunDrop:GetChildren();
                                 local v3034 = v3033;
                                 local v3035 = 8;
                                 local v3036 = nil;
                                 local v3037 = nil;
                                 local v3038 = 1;
                                 local v3039 = #v3033;
                                 local v3040 = v3039;
                                 local v3041 = v3038;
                                 if (not (v3039 <= v3041)) then
                                     while true do
                                         local v3042 = v3034[v3038];
                                         local v3043 = v3042;
                                         local t_Name_423 = v3042.Name;
                                         if (t_Name_423 == "Dropped") then
                                             local v3044 = (v3043.Slot1.Position - u974.rootpart.Position).magnitude;
                                             local t_magnitude_424 = v3044;
                                             if (v3044 <= v3035) then
                                                 if (v3043:FindFirstChild("Gun")) then
                                                     v3035 = t_magnitude_424;
                                                     v3036 = v3043;
                                                     v3037 = nil;
                                                 else
                                                     if (v3043:FindFirstChild("Knife")) then
                                                         v3035 = t_magnitude_424;
                                                         v3037 = v3043;
                                                         v3036 = nil;
                                                     end
                                                 end
                                             end
                                         end
                                         local v3045 = v3038 + 1;
                                         v3038 = v3045;
                                         local v3046 = v3040;
                                         if (v3046 < v3045) then
                                             break;
                                         end
                                     end
                                 end
                                 if (not v3036) then
                                     if (v3037) then
                                         u978:send("swapwe\226\128\139apon", v3037, 3);
                                     end
                                     return;
                                 end
                                 local v3047 = u972.currentgun;
                                 local v3048 = u931;
                                 if (v3047 == v3048) then
                                     u930 = 2;
                                     u972.currentgun = u977[u930];
                                     u972.currentgun:setequipped(true);
                                 end
                                 u978:send("swap\226\128\139weapon", v3036, u930);
                             end);
                             return;
                         end
                     else
                         if (p502 == "l3") then
                             if (u972.currentgun.isaiming() and u972.currentgun.isblackscope()) then
                                 u972.steadytoggle = not u972.steadytoggle;
                                 return;
                             end
                             if (not u937) then
                                 if (u972.currentgun.isaiming() and u972.currentgun.setaim) then
                                     u972.steadytoggle = false;
                                     u972.currentgun:setaim(false);
                                 end
                                 u974:setsprint(not u974.sprinting());
                                 return;
                             end
                         else
                             if (p502 == "select") then
                                 if (u939) then
                                     return;
                                 end
                                 u939 = true;
                                 local v3049 = 1;
                                 local v3050 = v3049;
                                 if (not (v3050 >= 20)) then
                                     while true do
                                         task.wait(0.1);
                                         if (u939) then
                                             local v3051 = v3049 + 1;
                                             v3049 = v3051;
                                             if (v3051 > 20) then
                                                 break;
                                             end
                                         else
                                             break;
                                         end
                                     end
                                     return;
                                 end
                                 if (u939) then
                                     u939 = false;
                                     u974:despawn();
                                 end
                             end
                         end
                     end
                 end
             end
             return;
         end
         if (u972.currentgun.inspecting()) then
             u972.currentgun:reloadcancel(true);
         end
         u972.currentgun:shoot(true);
         return;
     end
     local t_movementmode_421 = u974.movementmode;
     if (t_movementmode_421 == "crouch") then
         u974:setmovementmode("prone");
         return;
     end
     if (not (u974.sprinting() and (not u932))) then
         u974:setmovementmode("crouch");
         return;
     end
     u932 = true;
     u974:setmovementmode("crouch", u932);
     task.wait(1);
     u932 = false;
 end);
 local v3052 = u17.controller.onbuttonup;
 local u979 = u10;
 local u980 = f_switch;
 v3052:connect(function(p503)
     --[[
         Name: (empty)
         Line: 10498
         Upvalues: 
             [1] = u979
             [2] = u971
             [3] = u980
             [4] = u939
 
     --]]
     if (not u979.currentgun) then
         return;
     end
     if (p503 == "r2") then
         u979.currentgun:shoot(false);
         return;
     end
     if (p503 == "y") then
         if (not u971) then
             u980(1);
             return;
         end
     else
         if ((p503 == "l2") and u979.currentgun.setaim) then
             u979.steadytoggle = false;
             if (u979.currentgun.isaiming()) then
                 u979.currentgun:setaim(false);
                 return;
             end
         else
             if ((p503 == "select") and u939) then
                 u939 = false;
             end
         end
     end
 end);
 local f_controllerstep;
 f_controllerstep = function()
     --[[
         Name: controllerstep
         Line: 10522
         Upvalues: 
             [1] = u10
             [2] = u17
             [3] = u2
 
     --]]
     if (not u10.currentgun) then
         return;
     end
     if (u17.controller.down.b) then
         local v3053 = u17.controller.down.b + 0.5;
         local v3054 = tick();
         if (v3053 <= v3054) then
             local t_movementmode_425 = u2.movementmode;
             if (t_movementmode_425 ~= "prone") then
                 u2:setmovementmode("prone");
             end
         end
     end
 end;
 u10.controllerstep = f_controllerstep;
 local v3055 = u2.ondied;
 local u981 = u4;
 local u982 = u10;
 local u983 = u8;
 local t_LocalPlayer_426 = v2971;
 local u984 = u2;
 v3055:connect(function(p504)
     --[[
         Name: (empty)
         Line: 10529
         Upvalues: 
             [1] = u940
             [2] = u981
             [3] = u982
             [4] = u983
             [5] = t_LocalPlayer_426
             [6] = u984
 
     --]]
     u940 = 0;
     u981:setscope(false);
     if (u982.currentgun) then
         u982.currentgun:setequipped(false, "death");
         u982.currentgun = nil;
     end
     if (not p504) then
         task.wait(5);
     end
     u983:loadmenu(true);
     if (not t_LocalPlayer_426:FindFirstChild("ForceR")) then
         u984:setmovementmode("stand");
     end
 end);
 u12:add("spawn", f_loadmodules);
 u12:add("swapgun", f_swapgun);
 u12:add("removeweapon", f_removeweapon);
 u12:add("swapknife", f_swapknife);
 u12:add("addammo", function(p505, p506, p507)
     --[[
         Name: (empty)
         Line: 10554
         Upvalues: 
             [1] = u929
 
     --]]
     if (u929[p505]) then
         u929[p505]:addammo(p506, p507);
     end
 end);
 u8:loadmenu();
 u12:add("setuiscale", u20.setscale);
 local u985 = workspace.Ignore.DeadBody;
 local u986 = shared.require("ExplosionForce");
 local u987 = shared.require("ExplosionForceMesh");
 local u988 = shared.require("ragdolltable");
 local f_newCollisionPart;
 f_newCollisionPart = function(p508)
     --[[
         Name: newCollisionPart
         Line: 10573
     --]]
     local v3056 = Instance.new("Part");
     v3056.TopSurface = 0;
     v3056.BottomSurface = 0;
     v3056.Size = p508.Size;
     v3056.Color = p508.Color;
     v3056.CastShadow = false;
     v3056.Anchored = false;
     v3056.CanTouch = false;
     v3056.CanQuery = false;
     v3056.Name = p508.Name;
     v3056.CFrame = p508.CFrame;
     v3056.Velocity = p508.Velocity;
     v3056.CollisionGroupId = 3;
     return v3056;
 end;
 local u989;
 u989 = function(p509, p510)
     --[[
         Name: weldball
         Line: 10590
     --]]
     local v3057 = false;
     local v3058 = Instance.new("Part");
     local v3059 = v3058;
     v3058:BreakJoints();
     v3058.Shape = "Ball";
     v3058.TopSurface = 0;
     v3058.BottomSurface = 0;
     v3058.formFactor = "Custom";
     v3058.Size = Vector3.new(0.25, 0.25, 0.25);
     v3058.Transparency = 1;
     v3058.CastShadow = false;
     v3058.Massless = true;
     v3058.CollisionGroupId = 3;
     local v3060 = Instance.new("Weld");
     local v3061 = v3060;
     v3060.Part0 = p509;
     v3060.Part1 = v3058;
     local v3062;
     if (p510) then
         v3057 = true;
     else
         v3062 = CFrame.new(0, -0.5, 0);
         if (not v3062) then
             v3057 = true;
         end
     end
     if (v3057) then
         v3062 = p510;
     end
     v3061.C0 = v3062;
     v3061.Parent = v3059;
     v3059.Parent = p509;
     game.Debris:AddItem(v3059, 5);
 end;
 local f_weldtorso;
 f_weldtorso = function(p511, p512)
     --[[
         Name: weldtorso
         Line: 10611
         Upvalues: 
             [1] = u988
 
     --]]
     local v3063 = Instance.new("Part");
     v3063.CastShadow = false;
     v3063.Size = Vector3.new(0.1, 0.1, 0.1);
     v3063.Shape = "Ball";
     v3063.TopSurface = "Smooth";
     v3063.BottomSurface = "Smooth";
     v3063.Transparency = 1;
     v3063.CanCollide = false;
     v3063.Massless = true;
     v3063.CollisionGroupId = 3;
     v3063.Parent = p511;
     game.Debris:AddItem(v3063, 5);
     local v3064 = Instance.new("Weld");
     v3064.Part0 = p511;
     v3064.Part1 = v3063;
     v3064.C0 = u988[p511.Name].c;
     v3064.Parent = v3063;
     local v3065 = Instance.new("Attachment");
     local v3066 = v3065;
     v3065.CFrame = u988[p511.Name].a;
     v3065.Parent = p512;
     local v3067 = Instance.new("Attachment");
     local v3068 = v3067;
     v3067.CFrame = u988[p511.Name].b;
     v3067.Parent = p511;
     if (u988[p511.Name].d0) then
         v3066.Axis = u988[p511.Name].d0;
         v3068.Axis = u988[p511.Name].d1;
     end
     local v3069 = Instance.new("BallSocketConstraint");
     v3069.Attachment0 = v3066;
     v3069.Attachment1 = v3068;
     v3069.Restitution = 0.5;
     v3069.LimitsEnabled = true;
     v3069.UpperAngle = 70;
     v3069.Parent = p512;
 end;
 local f_ragdoll;
 f_ragdoll = function(p513, p514, p515, p516, p517)
     --[[
         Name: ragdoll
         Line: 10800
         Upvalues: 
             [1] = u988
             [2] = f_weldtorso
             [3] = u989
             [4] = u985
             [5] = u987
             [6] = u986
 
     --]]
     local v3070 = p516;
     if (not v3070) then
         v3070 = Vector3.new();
     end
     p516 = v3070;
     p517 = p517 or 20;
     local v3071 = p513:Clone();
     local v3072 = v3071;
     local v3073 = nil;
     local v3074 = v3071:FindFirstChild("Torso");
     local v3075, v3076, v3077 = pairs(v3071:GetChildren());
     local v3078 = v3075;
     local v3079 = v3076;
     local v3080 = v3077;
     while true do
         local v3081, v3082 = v3078(v3079, v3080);
         local v3083 = v3081;
         local v3084 = v3082;
         if (v3081) then
             v3080 = v3083;
             if (v3084:IsA("BasePart")) then
                 local t_Transparency_427 = v3084.Transparency;
                 if (t_Transparency_427 == 0) then
                     v3084.TopSurface = 0;
                     v3084.BottomSurface = 0;
                     v3084.CastShadow = false;
                     v3084.Anchored = false;
                     v3084.CanCollide = true;
                     v3084.CanTouch = false;
                     v3084.CanQuery = false;
                     v3084.CollisionGroupId = 3;
                     if (v3084.Name == p514) then
                         v3073 = v3084;
                     end
                 end
             end
         else
             break;
         end
     end
     local v3085, v3086, v3087 = pairs(u988);
     local v3088 = v3085;
     local v3089 = v3086;
     local v3090 = v3087;
     while true do
         local v3091, v3092 = v3088(v3089, v3090);
         local v3093 = v3091;
         if (v3091) then
             v3090 = v3093;
             local v3094 = v3072:FindFirstChild(v3093);
             local v3095 = v3094;
             if (v3094) then
                 f_weldtorso(v3095, v3074);
             end
         else
             break;
         end
     end
     u989(v3074, CFrame.new(0, 0.5, 0));
     v3072.Name = "Dead";
     v3072.Parent = u985;
     if (p515) then
         local v3096, v3097, v3098 = pairs(v3072:GetChildren());
         local v3099 = v3096;
         local v3100 = v3097;
         local v3101 = v3098;
         while true do
             local v3102, v3103 = v3099(v3100, v3101);
             local v3104 = v3102;
             local v3105 = v3103;
             if (v3102) then
                 v3101 = v3104;
                 if (v3105:IsA("BasePart") and u987[v3105.Name]) then
                     v3105:ApplyImpulseAtPosition(u986.computeMeshExplosionForce(p515, v3105.CFrame, v3105.Size, u987[v3105.Name]) * 300, p515);
                 end
             else
                 break;
             end
         end
     else
         if (v3073) then
             v3073:ApplyImpulseAtPosition(p516 * p517, v3073.Position);
         end
     end
     local v3106 = {};
     local v3107, v3108, v3109 = pairs(v3072:GetDescendants());
     local v3110 = v3107;
     local v3111 = v3108;
     local v3112 = v3109;
     while true do
         local v3113, v3114 = v3110(v3111, v3112);
         local v3115 = v3113;
         local v3116 = v3114;
         if (v3113) then
             v3112 = v3115;
             if (v3116:IsA("BasePart") or v3116:IsA("Decal")) then
                 table.insert(v3106, v3116);
             end
         else
             break;
         end
     end
     local v3117 = task.delay;
     local u990 = v3106;
     v3117(5, function()
         --[[
             Name: (empty)
             Line: 10856
             Upvalues: 
                 [1] = u990
 
         --]]
         local v3118, v3119, v3120 = pairs(u990);
         local v3121 = v3118;
         local v3122 = v3119;
         local v3123 = v3120;
         while true do
             local v3124, v3125 = v3121(v3122, v3123);
             local v3126 = v3124;
             local v3127 = v3125;
             if (v3124) then
                 v3123 = v3126;
                 if (v3127:IsA("BasePart")) then
                     v3127.Anchored = true;
                 end
             else
                 break;
             end
         end
     end);
     local v3128 = task.delay;
     local u991 = v3106;
     local u992 = v3072;
     v3128(30, function()
         --[[
             Name: (empty)
             Line: 10864
             Upvalues: 
                 [1] = u991
                 [2] = u992
 
         --]]
         local v3129 = 1;
         local v3130 = v3129;
         if (not (v3130 >= 20)) then
             while true do
                 local v3131, v3132, v3133 = pairs(u991);
                 local v3134 = v3131;
                 local v3135 = v3132;
                 local v3136 = v3133;
                 while true do
                     local v3137, v3138 = v3134(v3135, v3136);
                     local v3139 = v3137;
                     local v3140 = v3138;
                     if (v3137) then
                         v3136 = v3139;
                         v3140.Transparency = v3129 / 20;
                     else
                         break;
                     end
                 end
                 task.wait(0.016666666666666666);
                 local v3141 = v3129 + 1;
                 v3129 = v3141;
                 if (v3141 > 20) then
                     break;
                 end
             end
         end
         u992:Destroy();
     end);
 end;
 u12:add("died", function(p518, p519, p520, p521, p522)
     --[[
         Name: (empty)
         Line: 10875
         Upvalues: 
             [1] = u7
             [2] = u19
             [3] = f_ragdoll
 
     --]]
     local v3142 = u7.getupdater(p518);
     local v3143 = v3142;
     if (v3142) then
         local v3144 = v3143.died();
         local v3145 = v3144;
         if (v3144) then
             if (u19.ragdolls) then
                 f_ragdoll(v3145, p519, p520, p521, p522);
             end
             v3145:Destroy();
         end
     end
 end);
 u985 = {};
 u986 = "failed to load";
 u987 = "http request failed";
 u988 = "could not fetch";
 u989 = "thumbnail";
 local u993 = {
     u986,
     u987,
     u988,
     "download sound",
     u989
 };
 game:GetService("LogService").MessageOut:connect(function(p523, p524)
     --[[
         Name: (empty)
         Line: 10897
         Upvalues: 
             [1] = u993
             [2] = u12
 
     --]]
     local v3146 = Enum.MessageType.MessageError;
     if (p524 == v3146) then
         local v3147 = 1;
         local v3148 = #u993;
         local v3149 = v3148;
         local v3150 = v3147;
         if (not (v3148 <= v3150)) then
             while (not string.find(string.lower(p523), u993[v3147])) do
                 local v3151 = v3147 + 1;
                 v3147 = v3151;
                 local v3152 = v3149;
                 if (v3152 < v3151) then
                     break;
                 end
             end
             return;
         end
         u12:send("deb\226\128\139ug", p523);
     end
 end);
 u12:add("lightingt", function(p525)
     --[[
         Name: (empty)
         Line: 10909
         Upvalues: 
             [1] = u22
 
     --]]
     u22.setSeed(p525);
 end);
 print("Framework finished loading, duration:", tick() - v1);
 game:GetService("RunService").Heartbeat:wait();
 u12:ready();
 shared.close();
 v17.Reset:connect(u21.clear);
 v14:addTask("input", u17.step);
 v14:addTask("char", u2.step);
 v14:addTask("notify", u5.step, {
     "char"
 });
 v14:addTask("camera", u16.step, {
     "input",
     "char"
 });
 v14:addTask("menu", u8.step, {
     "camera"
 });
 v14:addTask("particle", u18.step, {
     "camera"
 });
 v14:addTask("repupdate", u7.update, {
     "camera"
 });
 v14:addTask("weaponstep", u2.animstep, {
     "char",
     "particle",
     "camera"
 });
 v14:addTask("hud", u4.step, {
     "char",
     "camera",
     "weaponstep"
 });
 v14:addTask("leaderboard", u6.step);
 v14:addTask("controllerstep", u10.controllerstep, {
     "char",
     "input"
 });
 v14:addTask("tween", v24.step, {
     "weaponstep"
 });
 v15:addTask("replication", u7.step);
 v15:addTask("daycycle", u22.step);
 v15:addTask("dynobj", u22.objStep);
 v15:addTask("blood", u19.bloodstep);
 v15:addTask("hudbeat", u4.beat);
 v15:addTask("radar", u4.radarstep);
 local u994 = workspace:FindFirstChild("Map");
 local u995 = workspace.Ignore.GunDrop;
 local f_cancapture;
 f_cancapture = function(p526, p527)
     --[[
         Name: cancapture
         Line: 10944
         Upvalues: 
             [1] = u2
 
     --]]
     if (not u2.alive) then
         return false;
     end
     local v3153 = u2.rootpart.Position - p526;
     local v3154 = v3153;
     if (not (v3153.magnitude <= p527)) then
         return false;
     end
     local t_Y_429 = v3154.Y;
     if ((t_Y_429 > 10) or (v3154.Y <= 0)) then
         return false;
     end
     return true;
 end;
 v15:addTask("dropcheck", function()
     --[[
         Name: (empty)
         Line: 10965
         Upvalues: 
             [1] = u995
             [2] = u4
             [3] = u2
 
     --]]
     local v3155 = u995:GetChildren();
     local v3156 = 8;
     u4:gundrop(false);
     if (u2.alive) then
         local v3157 = 1;
         local v3158 = #v3155;
         local v3159 = v3158;
         local v3160 = v3157;
         if (not (v3158 <= v3160)) then
             while true do
                 local v3161 = v3155[v3157];
                 local v3162 = v3161;
                 local t_Name_430 = v3161.Name;
                 if ((t_Name_430 == "Dropped") and v3161:FindFirstChild("Slot1")) then
                     local v3163 = (v3162.Slot1.Position - u2.rootpart.Position).magnitude;
                     local t_magnitude_431 = v3163;
                     if (v3163 <= v3156) then
                         v3156 = t_magnitude_431;
                         if (v3162:FindFirstChild("Gun")) then
                             u4:gundrop(v3162, v3162.Gun.Value);
                         else
                             if (v3162:FindFirstChild("Knife")) then
                                 u4:gundrop(v3162, v3162.Knife.Value);
                             end
                         end
                     end
                 end
                 local v3164 = v3157 + 1;
                 v3157 = v3164;
                 local v3165 = v3159;
                 if (v3165 < v3164) then
                     break;
                 end
             end
         end
     end
 end);
 v15:addTask("flagcheck", function()
     --[[
         Name: (empty)
         Line: 10987
         Upvalues: 
             [1] = u2
             [2] = u995
             [3] = u4
             [4] = u994
             [5] = t_LocalPlayer_2
             [6] = f_cancapture
             [7] = u12
 
     --]]
     if (u2.alive) then
         local v3166 = u995:GetChildren();
         u4:capping(false);
         if (u994) then
             local v3167 = u994:FindFirstChild("AGMP");
             local v3168 = v3167;
             if (v3167) then
                 local v3169 = v3168:GetChildren();
                 local v3170 = v3169;
                 local v3171 = 1;
                 local v3172 = #v3169;
                 local v3173 = v3172;
                 local v3174 = v3171;
                 if (not (v3172 <= v3174)) then
                     while true do
                         local v3175 = v3170[v3171];
                         local v3176 = v3175;
                         if (v3175:FindFirstChild("IsCapping") and v3175.IsCapping.Value) then
                             local v3177 = v3176.TeamColor.Value;
                             local t_TeamColor_432 = t_LocalPlayer_2.TeamColor;
                             if (((not (v3177 == t_TeamColor_432)) and u2.rootpart) and f_cancapture(v3176.Base.Position, 15)) then
                                 u4:capping(v3176, v3176.CapPoint.Value);
                             end
                         end
                         local v3178 = v3171 + 1;
                         v3171 = v3178;
                         local v3179 = v3173;
                         if (v3179 < v3178) then
                             break;
                         end
                     end
                 end
             end
             local v3180 = 1;
             local v3181 = #v3166;
             local v3182 = v3181;
             local v3183 = v3180;
             if (not (v3181 <= v3183)) then
                 while true do
                     local v3184 = v3166[v3180];
                     local v3185 = v3184;
                     if (v3184:FindFirstChild("Base")) then
                         local t_Name_433 = v3185.Name;
                         if (t_Name_433 == "FlagDrop") then
                             if (f_cancapture(v3185.Base.Position, 8)) then
                                 local v3186 = v3185.TeamColor.Value;
                                 local t_TeamColor_434 = t_LocalPlayer_2.TeamColor;
                                 if (((v3186 == t_TeamColor_434) and v3185:FindFirstChild("IsCapping")) and v3185.IsCapping.Value) then
                                     u4:capping(v3185, v3185.CapPoint.Value, "ctf");
                                 end
                                 u12:send("captur\226\128\139eflag", v3185.TeamColor.Value);
                             end
                         else
                             local t_Name_435 = v3185.Name;
                             if ((t_Name_435 == "DogTag") and f_cancapture(v3185.Base.Position, 6)) then
                                 u12:send("captur\226\128\139edogtag", v3185);
                             end
                         end
                     end
                     local v3187 = v3180 + 1;
                     v3180 = v3187;
                     local v3188 = v3182;
                     if (v3188 < v3187) then
                         break;
                     end
                 end
                 return;
             end
         end
     else
         u4:capping(false);
     end
 end);
 u994 = Instance.new;
 u995 = "BindableEvent";
 local v3189 = u994(u995);
 v3189.Event:Connect(function()
     --[[
         Name: (empty)
         Line: 11041
         Upvalues: 
             [1] = u2
 
     --]]
     u2:despawn();
 end);
 game:GetService("StarterGui"):SetCore("ResetButtonCallback", v3189);
 