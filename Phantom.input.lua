-- Decompiled with the Synapse X Luau decompiler.
 --NOTE: Currently in beta! Not representative of final product.
 local v1 = {};
 local v2 = shared.require("char");
 local v3 = shared.require("Event");
 local u1 = game:GetService("UserInputService");
 local v4 = game:GetService("HapticService");
 local v5 = v4;
 if (v4:IsVibrationSupported(Enum.UserInputType.Gamepad1)) then
     local v6 = v5:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large);
 end
 local u2 = {};
 local v7 = {};
 v7.ButtonX = "x";
 v7.ButtonY = "y";
 v7.ButtonA = "a";
 v7.ButtonB = "b";
 v7.ButtonR1 = "r1";
 v7.ButtonL1 = "l1";
 v7.ButtonR2 = "r2";
 v7.ButtonL2 = "l2";
 v7.ButtonR3 = "r3";
 v7.ButtonL3 = "l3";
 v7.ButtonStart = "start";
 v7.ButtonSelect = "select";
 v7.DPadLeft = "left";
 v7.DPadRight = "right";
 v7.DPadUp = "up";
 v7.DPadDown = "down";
 v1.keyboard = {};
 v1.keyboard.down = {};
 v1.keyboard.onkeydown = v3.new();
 v1.keyboard.onkeyup = v3.new();
 v1.mouse = {};
 v1.mouse.Position = Vector3.new();
 v1.mouse.down = {};
 v1.mouse.onbuttondown = v3.new();
 v1.mouse.onbuttonup = v3.new();
 v1.mouse.onmousemove = v3.new();
 v1.mouse.onscroll = v3.new();
 v1.controller = {};
 v1.controller.down = {};
 v1.controller.onbuttondown = v3.new();
 v1.controller.onbuttonup = v3.new();
 v1.controller.onintegralmove = v3.new();
 v1.consoleon = not u1.KeyboardEnabled;
 local u3 = {};
 local u4 = nil;
 local v8 = {};
 local u5 = nil;
 local f_iskeydown;
 f_iskeydown = function(p1)
     --[[
         Name: iskeydown
         Line: 70
         Upvalues: 
             [1] = u1
 
     --]]
     return u1:GetKeysPressed()[p1];
 end;
 v1.iskeydown = f_iskeydown;
 u1.TextBoxFocused:connect(function()
     --[[
         Name: (empty)
         Line: 74
         Upvalues: 
             [1] = u5
 
     --]]
     u5 = true;
 end);
 u1.TextBoxFocusReleased:connect(function()
     --[[
         Name: (empty)
         Line: 78
         Upvalues: 
             [1] = u5
 
     --]]
     u5 = false;
 end);
 local v9 = u1.InputChanged;
 local u6 = v1;
 local u7 = v7;
 local u8 = u3;
 v9:connect(function(p2)
     --[[
         Name: (empty)
         Line: 82
         Upvalues: 
             [1] = u6
             [2] = u4
             [3] = u7
             [4] = u8
 
     --]]
     local t_Name_1 = p2.UserInputType.Name;
     local t_Position_2 = p2.Position;
     if (t_Name_1 == "MouseMovement") then
         u6.mouse.position = t_Position_2;
         u6.mouse.onmousemove:fire(p2.Delta);
         return;
     end
     if (t_Name_1 == "MouseWheel") then
         u6.mouse.onscroll:fire(t_Position_2.z);
         return;
     end
     if (t_Name_1 == "Gamepad1") then
         local t_Name_3 = p2.KeyCode.Name;
         if (t_Name_3 == "Thumbstick2") then
             local t_magnitude_4 = t_Position_2.magnitude;
             if (t_magnitude_4 >= 0.25) then
                 u4 = ((1 - (0.25 / t_magnitude_4)) / 0.75) * t_Position_2;
                 return;
             end
             if (u4) then
                 u4 = nil;
                 return;
             end
         else
             if ((t_Name_3 == "ButtonL2") or (t_Name_3 == "ButtonR2")) then
                 local v10 = u7[t_Name_3];
                 local v11 = v10;
                 local t_z_5 = t_Position_2.z;
                 if ((t_z_5 >= 0.1) and (not u6.controller.down[v10])) then
                     local v12 = u8[v11];
                     local v13 = v12;
                     if (v12) then
                         u6.keyboard.down[v13] = tick();
                         u6.keyboard.onkeydown:fire(v13);
                     end
                     u6.controller.down[v11] = tick();
                     u6.controller.onbuttondown:fire(v11);
                     return;
                 end
                 if ((t_Position_2.z <= 0.1) and u6.controller.down[v11]) then
                     local v14 = u8[v11];
                     local v15 = v14;
                     if (v14) then
                         u6.keyboard.down[v15] = nil;
                         u6.keyboard.onkeyup:fire(v15);
                     end
                     u6.controller.down[v11] = nil;
                     u6.controller.onbuttonup:fire(v11);
                 end
             end
         end
     end
 end);
 local v16 = u1.InputBegan;
 local u9 = v2;
 local u10 = v1;
 local u11 = v7;
 local u12 = u3;
 v16:connect(function(p3)
     --[[
         Name: (empty)
         Line: 125
         Upvalues: 
             [1] = u5
             [2] = u9
             [3] = u10
             [4] = u11
             [5] = u12
 
     --]]
     local v17 = tick();
     if (not ((not u5) and u9.alive)) then
         return;
     end
     local t_Name_6 = p3.UserInputType.Name;
     if (t_Name_6 ~= "Keyboard") then
         if (t_Name_6 == "Gamepad1") then
             local v18 = u11[p3.KeyCode.Name];
             local v19 = v18;
             if (not ((not ((v18 and (not (v19 == "l2"))) and (not (v19 == "r2")))) and u10.controller.down[v18])) then
                 local v20 = u12[v19];
                 local v21 = v20;
                 if (v20) then
                     u10.keyboard.down[v21] = v17;
                     u10.keyboard.onkeydown:fire(v21);
                 end
                 u10.controller.down[v19] = v17;
                 u10.controller.onbuttondown:fire(v19);
                 return;
             end
         else
             if (t_Name_6 == "MouseButton1") then
                 u10.mouse.down.left = v17;
                 u10.mouse.onbuttondown:fire("left");
                 return;
             end
             if (t_Name_6 == "MouseButton2") then
                 u10.mouse.down.right = v17;
                 u10.mouse.onbuttondown:fire("right");
                 return;
             end
             if (t_Name_6 == "MouseButton3") then
                 u10.mouse.down.middle = v17;
                 u10.mouse.onbuttondown:fire("middle");
             end
         end
         return;
     end
     local v22 = string.lower(p3.KeyCode.Name);
     u10.keyboard.down[v22] = v17;
     u10.keyboard.onkeydown:fire(v22);
 end);
 local v23 = u1.InputEnded;
 local u13 = v1;
 local u14 = v7;
 local u15 = u3;
 v23:connect(function(p4)
     --[[
         Name: (empty)
         Line: 160
         Upvalues: 
             [1] = u5
             [2] = u13
             [3] = u14
             [4] = u15
 
     --]]
     if (u5) then
         return;
     end
     local t_Name_7 = p4.UserInputType.Name;
     if (t_Name_7 ~= "Keyboard") then
         if (t_Name_7 == "Gamepad1") then
             local v24 = u14[p4.KeyCode.Name];
             local v25 = v24;
             if (((v24 and (not (v25 == "l2"))) and (not (v25 == "r2"))) or u13.controller.down[v24]) then
                 local v26 = u15[v25];
                 local v27 = v26;
                 if (v26) then
                     u13.keyboard.down[v27] = nil;
                     u13.keyboard.onkeyup:fire(v27);
                 end
                 u13.controller.down[v25] = nil;
                 u13.controller.onbuttonup:fire(v25);
                 return;
             end
         else
             if (t_Name_7 == "MouseButton1") then
                 u13.mouse.down.left = nil;
                 u13.mouse.onbuttonup:fire("left");
                 return;
             end
             if (t_Name_7 == "MouseButton2") then
                 u13.mouse.down.right = nil;
                 u13.mouse.onbuttonup:fire("right");
                 return;
             end
             if (t_Name_7 == "MouseButton3") then
                 u13.mouse.down.middle = nil;
                 u13.mouse.onbuttonup:fire("middle");
             end
         end
         return;
     end
     local v28 = string.lower(p4.KeyCode.Name);
     u13.keyboard.down[v28] = nil;
     u13.keyboard.onkeyup:fire(v28);
 end);
 local f_firevibration;
 f_firevibration = function(p5)
     --[[
         Name: firevibration
         Line: 193
     --]]
 end;
 v1.controller.firevibration = f_firevibration;
 local f_hide;
 f_hide = function(p6)
     --[[
         Name: hide
         Line: 205
         Upvalues: 
             [1] = u1
 
     --]]
     u1.MouseIconEnabled = false;
 end;
 v1.mouse.hide = f_hide;
 local f_show;
 f_show = function(p7)
     --[[
         Name: show
         Line: 209
         Upvalues: 
             [1] = u1
 
     --]]
     u1.MouseIconEnabled = true;
 end;
 v1.mouse.show = f_show;
 local f_visible;
 f_visible = function()
     --[[
         Name: visible
         Line: 213
         Upvalues: 
             [1] = u1
 
     --]]
     return u1.MouseIconEnabled;
 end;
 v1.mouse.visible = f_visible;
 local f_lockcenter;
 f_lockcenter = function(p8)
     --[[
         Name: lockcenter
         Line: 217
         Upvalues: 
             [1] = u1
 
     --]]
     u1.MouseBehavior = "LockCenter";
 end;
 v1.mouse.lockcenter = f_lockcenter;
 local f_free;
 f_free = function(p9)
     --[[
         Name: free
         Line: 221
         Upvalues: 
             [1] = u1
 
     --]]
     u1.MouseBehavior = "Default";
 end;
 v1.mouse.free = f_free;
 local f_lock;
 f_lock = function(p10)
     --[[
         Name: lock
         Line: 225
         Upvalues: 
             [1] = u1
 
     --]]
     u1.MouseBehavior = "LockCurrentPosition";
 end;
 v1.mouse.lock = f_lock;
 local f_map;
 f_map = function(p11, p12, p13)
     --[[
         Name: map
         Line: 229
         Upvalues: 
             [1] = u3
 
     --]]
     u3[p12] = p13;
 end;
 v1.controller.map = f_map;
 local f_unmap;
 f_unmap = function(p14, p15)
     --[[
         Name: unmap
         Line: 233
         Upvalues: 
             [1] = u3
 
     --]]
     u3[p15] = nil;
 end;
 v1.controller.unmap = f_unmap;
 local f_mapaction;
 f_mapaction = function(p16, p17, p18)
     --[[
         Name: mapaction
         Line: 237
         Upvalues: 
             [1] = u2
 
     --]]
     u2[p17] = p18;
 end;
 v1.mapaction = f_mapaction;
 local u16 = v1;
 local f_step;
 f_step = function(p19)
     --[[
         Name: step
         Line: 241
         Upvalues: 
             [1] = u4
             [2] = u16
 
     --]]
     if (u4) then
         u16.controller.onintegralmove:fire(u4, p19);
     end
 end;
 v1.step = f_step;
 return v1;
 