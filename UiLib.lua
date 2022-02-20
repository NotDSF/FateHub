if getgenv().fah then
    getgenv().fah:Destroy()
end

local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local Mouse = game.Players.LocalPlayer:GetMouse()

local Instance_new = Instance.new
local UDim2_new = UDim2.new
local UDim2_fromOffset = UDim2.fromOffset
local fromRGB = Color3.fromRGB
local Colorscheme = Color3.fromRGB(255, 50, 150)

-- Config
local SectionSpace = 10

local UiLib = {}
local Tabs = {}

local function UiElements(Section)
    local Ret = {}
    local SectionalY = 15
    
    function Ret:Toggle(Name, Default, Callback)
        local ToggleMain = Instance_new('TextButton')
        local Title = Instance_new('TextLabel')
        local Status = Instance_new('Frame')
        
        ToggleMain.BackgroundColor3 = fromRGB(17, 17, 17)
        ToggleMain.BorderColor3 = fromRGB(17, 17, 17)
        ToggleMain.AutoButtonColor = false
        ToggleMain.Position = UDim2_fromOffset(13, SectionalY)
        ToggleMain.Size = UDim2_fromOffset(200, 20)
        ToggleMain.Text = ''
        ToggleMain.Parent = Section
        
        Title.BackgroundTransparency = 1
        Title.Position = UDim2_fromOffset(22, 0)
        Title.Size = UDim2_fromOffset(135, 20)
        Title.Font = Enum.Font.SourceSans
        Title.Text = Name
        Title.TextColor3 = Default and fromRGB(225, 225, 225) or fromRGB(150, 150, 150)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = ToggleMain

        Status.BackgroundColor3 = Default and Colorscheme or fromRGB(22, 22, 22)
        Status.BorderColor3 = fromRGB(40, 40, 40)
        Status.Position = UDim2_fromOffset(0, 3)
        Status.Size = UDim2_fromOffset(15, 15)
        Status.Parent = ToggleMain

        local Toggle = Default
        local EnterTween = TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = fromRGB(200, 200, 200)})
        
        ToggleMain.MouseButton1Click:Connect(function( ... )
            Toggle = not Toggle
            Callback(Toggle)

            TweenService:Create(Status, TweenInfo.new(0.2), {
                BackgroundColor3 = (Toggle and Colorscheme or fromRGB(22, 22, 22))
            }):Play()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = (Toggle and fromRGB(225, 225, 225) or fromRGB(150, 150, 150))
            }):Play()
        end)

        ToggleMain.MouseEnter:Connect(function()
            EnterTween:Play()
        end)
        ToggleMain.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Toggle and fromRGB(225, 225, 225) or fromRGB(150, 150, 150)}):Play()
        end)

        SectionalY = SectionalY + 20
        Section.Size = Section.Size + UDim2_fromOffset(0, 20)
    end
    function Ret:Dropdown(Name, Default, List, Callback)
        local DropdownFrame = Instance_new('Frame')
        local Drop = Instance_new('ScrollingFrame')
        local Title = Instance_new('TextLabel')
        local DropButton = Instance_new('TextButton')

        DropdownFrame.BackgroundColor3 = fromRGB(17, 17, 17)
        DropdownFrame.BorderColor3 = fromRGB(17, 17, 17)
        DropdownFrame.Position = UDim2_fromOffset(13, SectionalY)
        DropdownFrame.Size = UDim2_fromOffset(200, 35)
        DropdownFrame.Parent = Section

        Title.BackgroundTransparency = 1
        Title.Size = UDim2_fromOffset(200, 20)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = Name
        Title.TextColor3 = fromRGB(200, 200, 200)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = DropdownFrame

        DropButton.BackgroundColor3 = fromRGB(20, 20, 20)
        DropButton.BorderColor3 = fromRGB(40, 40, 40)
        DropButton.AutoButtonColor = false
        DropButton.Position = UDim2_fromOffset(1, 20)
        DropButton.Size = UDim2_fromOffset(170, 15)
        DropButton.Font = Enum.Font.SourceSansSemibold
        DropButton.Text = tostring(Default)
        DropButton.TextColor3 = Colorscheme
        DropButton.TextSize = 14
        DropButton.Parent = DropdownFrame

        Drop.BackgroundColor3 = fromRGB(17, 17, 17)
        Drop.BorderColor3 = fromRGB(40, 40, 40)
        Drop.Position = UDim2_new(0, 1, 0, 37)
        Drop.Size = UDim2_fromOffset(170, 0)
        Drop.ZIndex = 2
        Drop.ScrollBarImageColor3 = Colorscheme
        Drop.ScrollBarThickness = 2
        Drop.Visible = false
        Drop.Parent = DropdownFrame

        local InstancedButtons = {}
        local DropToggle = false

        local function UpdateDropdown(List)
            for i,v in pairs(InstancedButtons) do v:Destroy() end

            local x = 0
            local LastSelected = nil

            for i,v in pairs(List) do
                local Button = Instance_new('TextButton')
                local Title = Instance_new('TextLabel')

                Button.BackgroundColor3 = fromRGB(20, 20, 20)
                Button.BorderColor3 = fromRGB(30, 30, 30)
                Button.Position = UDim2_fromOffset(0, x*20)
                Button.Size = UDim2_fromOffset(170, 20)
                Button.Text = ''
                Button.ZIndex = 2
                Button.Parent = Drop

                Title.BackgroundTransparency = 1
                Title.Position = UDim2_fromOffset(10, 0)
                Title.Size = UDim2_fromOffset(160, 20)
                Title.Font = Enum.Font.SourceSansSemibold
                Title.Text = tostring(v)
                Title.TextColor3 = fromRGB(175, 175, 175)
                Title.TextSize = 14
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.ZIndex = 2
                Title.Parent = Button

                Button.MouseButton1Click:Connect(function()
                    Callback(v)
                    DropButton.Text = tostring(v)
                    LastSelected = Button
                    if LastSelected then
                        TweenService:Create(LastSelected:FindFirstChild('TextLabel'), TweenInfo.new(0.2), {
                            TextColor3 = fromRGB(175, 175, 175)
                        }):Play()
                    end
                    TweenService:Create(Title, TweenInfo.new(0.2), {
                        TextColor3 = ColorschemeS
                    }):Play()
                end)

                Button.MouseEnter:Connect(function()
                    if LastSelected ~= Button then
                        TweenService:Create(Title, TweenInfo.new(0.2), {
                            TextColor3 = fromRGB(225, 225, 225)
                        }):Play()
                    end
                end)
                Button.MouseLeave:Connect(function()
                    if LastSelected ~= Button then
                        TweenService:Create(Title, TweenInfo.new(0.2), {
                            TextColor3 = fromRGB(175, 175, 175)
                        }):Play()
                    end
                end)

                x = x + 1
            
                table.insert(InstancedButtons, Button)
            end
            Drop.CanvasSize = UDim2_fromOffset(0, x*20)
        end

        DropdownFrame.MouseEnter:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(225, 225, 225)
            }):Play()
        end)

        DropdownFrame.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(200, 200, 200)
            }):Play()
        end)

        DropButton.MouseButton1Click:Connect(function()
            DropToggle = not DropToggle
            Drop:TweenSize(UDim2_fromOffset(170, DropToggle and 200 or 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
            task.wait(DropToggle and 0 or 0.1)
            Drop.Visible = DropToggle
        end)
        
        UpdateDropdown(List)

        SectionalY = SectionalY + 40
        Section.Size = Section.Size + UDim2_fromOffset(0, 40)
    end
    function Ret:Slider(Name, Min, Max, Def, Callback, noFill, FloorCallback)
        local SliderFrame = Instance_new('Frame')
        local Title = Instance_new('TextLabel')
        local SliderBounds = Instance_new('Frame')
        local Slider = Instance_new('Frame')

        SliderFrame.BackgroundColor3 = fromRGB(17, 17, 17)
        SliderFrame.BorderColor3 = fromRGB(17, 17, 17)
        SliderFrame.Position = UDim2_fromOffset(13, SectionalY)
        SliderFrame.Size = UDim2_fromOffset(200, 30)
        SliderFrame.Parent = Section

        Title.BackgroundTransparency = 1
        Title.Size = UDim2_fromOffset(200, 20)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.TextColor3 = Colorscheme
        Title.RichText = true
        Title.Text = string.format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', Name, Def)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = SliderFrame

        SliderBounds.BackgroundColor3 = fromRGB(25, 25, 25)
        SliderBounds.BorderColor3 = fromRGB(40, 40, 40)
        SliderBounds.Position = UDim2_fromOffset(0, 20)
        SliderBounds.Size = UDim2_fromOffset(200, 10)
        SliderBounds.Parent = SliderFrame

        Slider.BackgroundColor3 = Colorscheme
        Slider.BorderColor3 = fromRGB(40, 40, 40)
        Slider.Position = UDim2_fromOffset(0, 20)
        Slider.Size = UDim2_fromOffset(200, 10)
        Slider.Parent = SliderFrame

        local Range = Max - Min
        local clamp = math.clamp
        local format = string.format
        local floor = math.floor

        local thing = (Def - Min) / Range * SliderBounds.AbsoluteSize.X
        Slider.Size = UDim2_fromOffset(noFill and 2 or thing, 10)
        Slider.Position = UDim2_fromOffset(noFill and thing or 0, 20)
        
        SliderBounds.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local Position = SliderBounds.AbsolutePosition.X
                local Size = SliderBounds.AbsoluteSize.X

                local Ratio = (Mouse.X - Position) / Size
                local Value = (Ratio * Range) + Min
                Title.Text = format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', Name, floor(Value))

                Callback(FloorCallback and floor(Value) or Value)
                Slider:TweenSizeAndPosition(
                    UDim2_fromOffset(noFill and 2 or Ratio * Size, 10),
                    UDim2_fromOffset(noFill and Ratio * Size or 0, 20),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quint,
                    0.1,
                    true
                )

                local MouseMove = Mouse.Move:Connect(function()
                    local Ratio = clamp((Mouse.X - Position) / Size, 0, 1)
                    local Value = (Ratio * Range) + Min

                    Callback(FloorCallback and floor(Value) or Value)

                    Title.Text = format('<font color="rgb(200, 200, 200)">%s</font> <font color="rgb(40, 40, 40)"> | </font> %s', Name, floor(Value))
                    Slider:TweenSizeAndPosition(
                        UDim2_fromOffset(noFill and 2 or Ratio * Size, 10),
                        UDim2_fromOffset(noFill and Ratio * Size or 0, 20),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quint,
                        0.1,
                        true
                    )
                end)
                local EndedCon = nil
                EndedCon = SliderBounds.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseMove:Disconnect()
                        EndedCon:Disconnect()
                    end
                end)
            end
        end)

        SectionalY = SectionalY + 35
        Section.Size = Section.Size + UDim2_fromOffset(0, 35)
    end
    function Ret:Colorpicker(Name, Def, Callback)
        local Main = Instance_new("TextButton")
        local Title = Instance_new('TextLabel')
        local StatusColor = Instance_new('Frame')

        local Colorpicker = Instance_new('Frame')
        local Colors = Instance_new('ImageLabel')
        local ColorsGradient = Instance_new('UIGradient')
        local HueSlider = Instance_new('Frame')
        local HueGradient = Instance_new('UIGradient')
        local ChosenColor = Instance_new('Frame')
        local Divider = Instance_new('Frame')
        local Divider2 = Instance_new('Frame')
        local Hex = Instance_new('Frame')
        local HexTitle = Instance_new('TextLabel')
        local HexValue = Instance_new('TextBox')
        local C = Instance_new('Frame')
        local CTitle = Instance_new('TextLabel')
        local CValue = Instance_new('TextBox')
        local OK = Instance_new('TextButton')
        local Cancel = Instance_new('TextButton')

        Main.BackgroundColor3 = fromRGB(17, 17, 17)
        Main.AutoButtonColor = false
        Main.BorderColor3 = fromRGB(17, 17, 17)
        Main.Position = UDim2_fromOffset(13, SectionalY)
        Main.Size = UDim2_fromOffset(200, 20)
        Main.Text = ''
        Main.Parent = Section
        
        Title.BackgroundTransparency = 1
        Title.Size = UDim2_fromOffset(200, 20)
        Title.Font = Enum.Font.SourceSans
        Title.Text = Name
        Title.TextColor3 = fromRGB(200, 200, 200)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Main

        StatusColor.BackgroundColor3 = Def or fromRGB(255, 255, 255)
        StatusColor.BorderColor3 = fromRGB(40, 40, 40)
        StatusColor.Position = UDim2_fromOffset(185, 3)
        StatusColor.Size = UDim2_fromOffset(15, 15)
        StatusColor.Parent = Main

        Colorpicker.BackgroundColor3 = fromRGB(20, 20, 20)
        Colorpicker.BorderColor3 = fromRGB(40, 40, 40)
        Colorpicker.Size = UDim2_fromOffset(215, 265)
        Colorpicker.Visible = false
        Colorpicker.Parent = Section.Parent.Parent.Parent

        Colors.BackgroundColor3 = fromRGB(255, 255, 255)
        Colors.BorderColor3 = fromRGB(20, 20, 20)
        Colors.Position = UDim2_fromOffset(5, 5)
        Colors.Size = UDim2_fromOffset(200, 175)
        Colors.Image = 'http://www.roblox.com/asset/?id=8863257882'
        Colors.Parent = Colorpicker

        ColorsGradient.Parent = Colors

        HueSlider.BackgroundColor3 = fromRGB(255, 255, 255)
        HueSlider.BorderColor3 = fromRGB(20, 20, 20)
        HueSlider.Position = UDim2_fromOffset(5, 185)
        HueSlider.Size = UDim2_fromOffset(175, 10)
        HueSlider.Parent = Colorpicker

        HueGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1/6, fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(2/6, fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.5, fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(4/6, fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(5/6, fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(1, fromRGB(255, 0, 0))
        }
        HueGradient.Parent = HueSlider

        ChosenColor.BackgroundColor3 = Def or fromRGB(255, 255, 255)
        ChosenColor.BorderColor3 = fromRGB(40, 40, 40)
        ChosenColor.Position = UDim2_fromOffset(185, 185)
        ChosenColor.Size = UDim2_fromOffset(20, 20)
        ChosenColor.Parent = Colorpicker

        Divider.BackgroundColor3 = fromRGB(40, 40, 40)
        Divider.BorderSizePixel = 0
        Divider.Position = UDim2_fromOffset(5, 211)
        Divider.Size = UDim2_fromOffset(200, 1)
        Divider.ZIndex = 2
        Divider.Parent = Colorpicker

        Divider2.BackgroundColor3 = fromRGB(40, 40, 40)
        Divider2.BorderSizePixel = 0
        Divider2.Position = UDim2_fromOffset(70, 212)
        Divider2.Size = UDim2_fromOffset(1, 35)
        Divider2.Parent = Colorpicker

        Hex.BackgroundColor3 = fromRGB(20, 20, 20)
        Hex.BorderColor3 = fromRGB(20, 20, 20)
        Hex.Position = UDim2_fromOffset(5, 215)
        Hex.Size = UDim2_fromOffset(60, 30)
        Hex.Parent = Colorpicker

        HexTitle.BackgroundTransparency = 1
        HexTitle.Size = UDim2_new(1, 0, 0.5, 0)
        HexTitle.Font = Enum.Font.SourceSansSemibold
        HexTitle.Text = 'Hex'
        HexTitle.TextColor3 = fromRGB(200, 200, 200)
        HexTitle.TextSize = 14
        HexTitle.Parent = Hex

        HexValue.BackgroundColor3 = fromRGB(20, 20, 20)
        HexValue.BorderColor3 = fromRGB(40, 40, 40)
        HexValue.Position = UDim2_new(0, 0, 0.5, 0)
        HexValue.Size = UDim2_new(1, 0, 0.5, 0)
        HexValue.ClearTextOnFocus = false 
        HexValue.Font = Enum.Font.SourceSans
        HexValue.Text = '#' ..  Def:ToHex() or '#FFFFFF'
        HexValue.TextColor3 = fromRGB(175, 175, 175)
        HexValue.TextSize = 14
        HexValue.Parent = Hex

        C.BackgroundColor3 = fromRGB(20, 20, 20)
        C.BorderColor3 = fromRGB(20, 20, 20)
        C.Size = UDim2_fromOffset(45, 30)
        C.Parent = Colorpicker

        CTitle.BackgroundTransparency = 1
        CTitle.Size = UDim2_new(1, 0, 0.5, 0)
        CTitle.Font = Enum.Font.SourceSansSemibold
        CTitle.TextSize = 14

        CValue.BackgroundColor3 = fromRGB(20, 20, 20)
        CValue.BorderColor3 = fromRGB(40, 40, 40)
        CValue.Position = UDim2_new(0, 0, 0.5, 0)
        CValue.Size = UDim2_new(1, 0, 0.5, 0)
        CValue.ClearTextOnFocus = false 
        CValue.Font = Enum.Font.SourceSans
        CValue.TextColor3 = fromRGB(175, 175, 175)
        CValue.TextSize = 14

        local RC, RTitle, RValue = C:Clone(), CTitle:Clone(), CValue:Clone()
        local GC, GTitle, GValue = C:Clone(), CTitle:Clone(), CValue:Clone()
        local BC, BTitle, BValue = C:Clone(), CTitle:Clone(), CValue:Clone()

        RC.Position = UDim2_fromOffset(75, 215)
        RC.Parent = Colorpicker
        RTitle.TextColor3 = fromRGB(255, 0, 0)
        RTitle.Text = 'R'
        RTitle.Parent = RC
        RValue.Text = Def and math.floor(Def.R) or '255'
        RValue.Parent = RC

        GC.Position = UDim2_fromOffset(120, 215)
        GC.Parent = Colorpicker
        GTitle.TextColor3 = fromRGB(0, 255, 0)
        GTitle.Text = 'G'
        GTitle.Parent = GC
        GValue.Text = Def and math.floor(Def.G) or '255'
        GValue.Parent = GC

        BC.Position = UDim2_fromOffset(165, 215)
        BC.Parent = Colorpicker
        BTitle.TextColor3 = fromRGB(0, 0, 255)
        BTitle.Text = 'B'
        BTitle.Parent = BC
        BValue.Text = Def and math.floor(Def.B) or '255'
        BValue.Parent = BC

        OK.BackgroundColor3 = fromRGB(25, 25, 25)
        OK.BorderColor3 = fromRGB(40, 40, 40)
        OK.Position = UDim2_fromOffset(135, 250)
        OK.Size = UDim2_fromOffset(25, 13)
        OK.Parent = Colorpicker
        OK.Font = Enum.Font.SourceSans
        OK.Text = 'OK'
        OK.TextColor3 = fromRGB(175, 175, 175)
        OK.TextSize = 13

        Cancel.BackgroundColor3 = fromRGB(25, 25, 25)
        Cancel.BorderColor3 = fromRGB(40, 40, 40)
        Cancel.Position = UDim2_fromOffset(165, 250)
        Cancel.Size = UDim2_fromOffset(45, 13)
        Cancel.Parent = Colorpicker
        Cancel.Font = Enum.Font.SourceSans
        Cancel.Text = 'Cancel'
        Cancel.TextColor3 = fromRGB(175, 175, 175)
        Cancel.TextSize = 13

        C:Destroy()

        local ColorTrack = Def or fromRGB(255, 255, 255)

        local V2N = Vector2.new
        local clamp = math.clamp
        local floor = math.floor
        local fromHSV = Color3.fromHSV

        local StoredValues = {Hue = 0, Sat = 0, Val = 1}

        local function UpdateColor(Clr)
            local H, S, V = Clr:ToHSV()
            
            StoredValues.Hue = H; StoredValues.Sat = S; StoredValues.Val = V
            
            ChosenColor.BackgroundColor3 = Clr
            ColorsGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, fromHSV(H, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }
            
            RValue.Text = floor(Clr.R * 255)
            GValue.Text = floor(Clr.G * 255)
            BValue.Text = floor(Clr.B * 255)
            
            HexValue.Text = '#' .. Clr:ToHex()
        end

        Colors.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPosition = Colors.AbsolutePosition
                local ColorsSize = Colors.AbsoluteSize
                
                local Diff = Vector2.new(Mouse.X, Mouse.Y) - AbsPosition
                local Sat = Diff.X / ColorsSize.X
                local Val = Diff.Y / ColorsSize.Y
                
                UpdateColor(fromHSV(StoredValues.Hue, 1 - Sat, 1 - Val))
                
                local MouseMove = Mouse.Move:Connect(function()
                    local Diff = Vector2.new(Mouse.X, Mouse.Y) - AbsPosition
                    local Sat = clamp(Diff.X / ColorsSize.X, 0, 1)
                    local Val =  clamp(Diff.Y / ColorsSize.Y, 0, 1)
                    UpdateColor(fromHSV(StoredValues.Hue, 1 - Sat, 1 - Val))
                end)
                
                local EndedCon = nil
                EndedCon = Colors.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseMove:Disconnect()
                        EndedCon:Disconnect()
                    end
                end)
            end
        end)

        HueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local Position, Size = HueSlider.AbsolutePosition.X, HueSlider.AbsoluteSize.X
                
                local Hue = (Mouse.X - Position) / Size
                UpdateColor(fromHSV(1 - Hue, StoredValues.Sat, StoredValues.Val))
                
                local MouseMove = Mouse.Move:Connect(function()
                    local Hue = clamp((Mouse.X - Position) / Size, 0, 1)
                    
                    UpdateColor(fromHSV(1 - Hue, StoredValues.Sat, StoredValues.Val))
                end)
                
                local EndedCon = nil 
                EndedCon = HueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        MouseMove:Disconnect()
                        EndedCon:Disconnect()
                    end
                end)
            end
        end)

        RValue.FocusLost:Connect(function(isEnter)
            local Int = tostring(RValue.Text)
            if isEnter and Int then 
                local CC = fromHSV(StoredValues.Hue, StoredValues.Sat, StoredValues.Sat) 
                UpdateColor(Color3.new(clamp(Int, 0, 255) / 255, CC.G, CC.B))
            end
        end)

        GValue.FocusLost:Connect(function(isEnter)
            local Int = tostring(GValue.Text)
            if isEnter and Int then 
                local CC = fromHSV(StoredValues.Hue, StoredValues.Sat, StoredValues.Sat) 
                UpdateColor(Color3.new(CC.R, clamp(Int, 0, 255) / 255, CC.B))
            end
        end)

        BValue.FocusLost:Connect(function(isEnter)
            local Int = tostring(BValue.Text)
            if isEnter and Int then 
                local CC = fromHSV(StoredValues.Hue, StoredValues.Sat, StoredValues.Sat) 
                UpdateColor(Color3.new(CC.R, CC.G, clamp(Int, 0, 255) / 255))
            end
        end)

        HexValue.FocusLost:Connect(function(isEnter)
            local Hex = Color3.fromHex(string.gsub(HexValue.Text, '#', ''))
            if isEnter and Hex then UpdateColor(Hex) end
        end)

        OK.MouseButton1Click:Connect(function()
            local newColor = ChosenColor.BackgroundColor3
            Callback(newColor)
            StatusColor.BackgroundColor3 = newColor
            ColorTrack = newColor
            Colorpicker.Visible = false
        end)

        Cancel.MouseButton1Click:Connect(function()
            Colorpicker.Visible = false
        end)

        Main.MouseButton1Click:Connect(function()
            Colorpicker.Visible = true
            Colorpicker.Position = UDim2_fromOffset(Mouse.X, Mouse.Y)
        end)

        Main.MouseEnter:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(225, 225, 225)
            }):Play()
        end)

        Main.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(200, 200, 200)
            }):Play()
        end)

        SectionalY = SectionalY + 20
        Section.Size = Section.Size + UDim2_fromOffset(0, 20)
    end
    function Ret:Keybind(Name, DefaultKey, setCallback, InputCallback)
        local Keybind = Instance_new('TextButton')
        local Title = Instance_new('TextLabel')
        local CurrentKey = Instance_new('TextLabel')

        Keybind.BackgroundColor3 = fromRGB(17, 17, 17)
        Keybind.BorderColor3 = fromRGB(17, 17, 17)
        Keybind.AutoButtonColor = false
        Keybind.Position = UDim2_fromOffset(13, SectionalY)
        Keybind.Size = UDim2_fromOffset(200, 15)
        Keybind.Text = ''
        Keybind.Parent = Section

        Title.BackgroundTransparency = 1
        Title.Size = UDim2_fromOffset(165, 15)
        Title.Font = Enum.Font.SourceSans
        Title.Text = Name
        Title.TextColor3 = fromRGB(200, 200, 200)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Keybind
        
        CurrentKey.BackgroundTransparency = 1
        CurrentKey.Position = UDim2_fromOffset(120, 0)
        CurrentKey.Size = UDim2_fromOffset(80, 15)
        CurrentKey.Font = Enum.Font.SourceSans
        CurrentKey.Text = DefaultKey and string.format('[%s]', string.split(tostring(DefaultKey), '.')[3]) or 'none'
        CurrentKey.TextColor3 = Colorscheme
        CurrentKey.TextSize = 14
        CurrentKey.TextXAlignment = Enum.TextXAlignment.Right
        CurrentKey.Parent = Keybind

        local KeyTrack = DefaultKey

        UserInputService.InputBegan:Connect(function(input, gp)
            if input.KeyCode == KeyTrack and not gp then
                InputCallback()
            end
        end)

        Keybind.MouseButton1Click:Connect(function()
            local InputBegan = nil
            InputBegan = UserInputService.InputBegan:Connect(function(input, gp)
                if input.UserInputType == Enum.UserInputType.Keyboard and not gp then
                    KeyTrack = input.KeyCode
                    setCallback(input.KeyCode)
                    CurrentKey.Text = string.format('[%s]', string.split(tostring(input.KeyCode), '.')[3])
                    InputBegan:Disconnect()
                end
            end)
        end)

        Keybind.MouseEnter:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(225, 225, 225)
            }):Play()
        end)

        Keybind.MouseLeave:Connect(function()
            TweenService:Create(Title, TweenInfo.new(0.2), {
                TextColor3 = fromRGB(200, 200, 200)
            })
        end)

        SectionalY = SectionalY + 15
        Section.Size = Section.Size + UDim2_fromOffset(0, 15)
    end
    function Ret:Button(Name, Callback)
        local Button = Instance_new('TextButton')

        Button.BackgroundColor3 = fromRGB(17, 17, 17)
        Button.BorderColor3 = fromRGB(40, 40, 40)
        Button.AutoButtonColor = false
        Button.Position = UDim2_fromOffset(13, SectionalY)
        Button.Size = UDim2_fromOffset(130, 15)
        Button.Font = Enum.Font.SourceSansSemibold
        Button.Text = '  ' .. Name
        Button.TextColor3 = fromRGB(200, 200, 200)
        Button.TextSize = 14
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.Parent = Section

        Button.MouseButton1Click:Connect(Callback)

        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = fromRGB(15, 15, 15),
                TextColor3 = Colorscheme
            }):Play()
        end)

        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = fromRGB(17, 17, 17),
                TextColor3 = fromRGB(200, 200, 200)
            }):Play() 
        end)

        SectionalY = SectionalY + 20
        Section.Size = Section.Size + UDim2_fromOffset(0, 20)
    end

    return Ret
end

local function Section(Tab)
    local Ret = {}
    local R, L = {}, {}
    local RLToggle = false

    local function UpdatePositions(RL, Section)
        local LastY = Section and Section.Position.Y.Offset + Section.AbsoluteSize.Y + SectionSpace or 15
        local Sectional = RL == 'R' and R or L
        local SX = RL == 'R' and 250 or 10
        for i=(Section and table.find(Sectional, Section)+1 or 1), #Sectional do
            local CurrentSection = Sectional[i]
            print(i, CurrentSection)
            CurrentSection.Position = UDim2_fromOffset(SX, LastY)
            LastY = LastY + CurrentSection.AbsoluteSize.Y + SectionSpace
        end
    end

    local function UpdateTabScroll()
        local Ry, Ly = 15, 15
        for i,v in pairs(R) do Ry = Ry + v.AbsoluteSize.Y + SectionSpace end
        for i,v in pairs(L) do Ly = Ly + v.AbsoluteSize.Y + SectionSpace end

        Tab.CanvasSize = UDim2_fromOffset(0, math.max(Ry, Ly) + 15)
    end

    function Ret:Section(Name)
        local Section = Instance_new('Frame')
        local BorderHide = Instance_new('Frame')
        local Title = Instance_new('TextLabel')

        Section.BackgroundColor3 = fromRGB(17, 17, 17)
        Section.BorderColor3 = fromRGB(40, 40, 40)
        Section.Position = UDim2_fromOffset(RLToggle and 250 or 10, 15)
        Section.Size = UDim2_fromOffset(220, 20)
        Section.Parent = Tab

        Title.BackgroundTransparency = 1
        Title.Position = UDim2_fromOffset(15, -10)
        Title.Size = UDim2_fromOffset(185, 20)
        Title.Font = Enum.Font.SourceSansSemibold
        Title.Text = Name
        Title.TextColor3 = Colorscheme
        Title.TextSize = 15
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 2
        Title.Parent = Section

        BorderHide.BackgroundColor3 = fromRGB(17, 17, 17)
        BorderHide.BorderColor3 = fromRGB(17, 17, 17)
        BorderHide.Position = UDim2_fromOffset(10, 0)
        BorderHide.Size = UDim2_fromOffset(Title.TextBounds.X + 10, 1)
        BorderHide.Parent = Section

        local Sectional = RLToggle and 'R' or 'L'

        Section:GetPropertyChangedSignal('Size'):Connect(function()
            UpdatePositions(Sectional, Section)
            UpdateTabScroll()
        end)

        table.insert(RLToggle and R or L, Section); UpdatePositions(Sectional)
        RLToggle = not RLToggle

        return UiElements(Section)
    end
    
    return Ret
end

local function Tab(Window)
    local Ret = {} 
    
    function Ret:Tab(Name)
        local TabFrame = Instance_new('ScrollingFrame')
        local TabButton = Instance_new('TextButton')
        local BorderHide = Instance_new('Frame')

        TabFrame.BackgroundColor3 = fromRGB(20, 20, 20)
        TabFrame.BorderColor3 = fromRGB(40, 40, 40)
        TabFrame.Position = UDim2_fromOffset(10, 55)
        TabFrame.Size = UDim2_fromOffset(480, 385)
        TabFrame.Visible = false
        TabFrame.ScrollBarThickness = 2
        TabFrame.ScrollBarImageColor3 = Colorscheme
        TabFrame.Parent = Window

        TabButton.AutoButtonColor = false
        TabButton.BackgroundColor3 = fromRGB(22, 22, 22)
        TabButton.BorderColor3 = fromRGB(22, 22, 22)
        TabButton.Position = UDim2_fromOffset(11 + 71 * #Tabs, 33)
        TabButton.Size = UDim2_fromOffset(70, 20)
        TabButton.Font = Enum.Font.SourceSansSemibold
        TabButton.TextColor3 = fromRGB(225, 225, 225)
        TabButton.TextSize = 14
        TabButton.Parent = Window

        BorderHide.BackgroundColor3 = fromRGB(20, 20, 20)
        BorderHide.BorderSizePixel = 0
        BorderHide.Position = UDim2_fromOffset(-1, 21)
        BorderHide.Size = UDim2_fromOffset(70, 1)
        BorderHide.Visible = false
        BorderHide.Parent = TabButton

        if #Tabs < 1 then
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = fromRGB(20, 20, 20)
            TabButton.BorderColor3 = fromRGB(20, 20, 20)
            TabButton.TextColor3 = Colorscheme
            BorderHide.Visible = true
        end

        TabButton.MouseButton1Click:Connect(function()
            for i,v in pairs(Tabs) do
                local B = v.Button
                v.Tab.Visible = false
                B.BackgroundColor3 = fromRGB(22, 22, 22)
                B.BorderColor3 = fromRGB(22, 22, 22)
                B.TextColor3 = fromRGB(225, 225, 225)
                v.BorderHide.Visible = false
            end

            TabFrame.Visible = true
            TabButton.BackgroundColor3 = fromRGB(20, 20, 20)
            TabButton.BorderColor3 = fromRGB(20, 20, 20)
            TabButton.TextColor = Colorscheme
            BorderHide.Visible = true
        end)

        table.insert(Tabs, {
            Tab = TabFrame,
            Button = TabButton,
            BorderHide = BorderHide
        })

        return Section(TabFrame)
    end
    return Ret
end

function UiLib:CreateWindow(Name, Game)
    local ScreenGui = Instance_new('ScreenGui')
    local MainFrame = Instance_new('Frame')
    local Title = Instance_new('TextLabel')
    local StatusFrame = Instance_new('Frame')
    local GameName = Instance_new('TextLabel')
    local ElapsedTime = Instance_new('TextLabel')
    local CurrentTime = Instance_new('TextLabel')
    local Divider, Divider2 = Instance_new('Frame'), Instance_new('Frame')

    local Viewport = game.Workspace.Camera.ViewportSize;
    local CenterCoords = Vector2.new(math.floor(Viewport.X/2), math.floor(Viewport.Y/2));

    getgenv().fah = ScreenGui
    ScreenGui.Parent = game.CoreGui

    MainFrame.BackgroundColor3 = fromRGB(25, 25, 25)
    MainFrame.BorderColor3 = fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2_new(0, CenterCoords.X - 500 / 2, 0, CenterCoords.Y - 450 / 2)
    MainFrame.Size = UDim2_fromOffset(0, 25) -- UDim2_fromOffset(500, 450)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    Title.BackgroundTransparency = 1
    Title.Position = UDim2_fromOffset(7, 2)
    Title.Size = UDim2_fromOffset(100, 26)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = Name
    Title.RichText = true
    Title.TextColor3 = fromRGB(220, 220, 220)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    StatusFrame.BackgroundColor3 = fromRGB(25, 25, 25)
    StatusFrame.BorderColor3 = fromRGB(25, 25, 25)
    StatusFrame.Parent = MainFrame

    GameName.BackgroundTransparency = 1
    GameName.Size = UDim2_fromOffset(200, 15)
    GameName.Font = Enum.Font.SourceSansSemibold
    GameName.Text = Game
    GameName.TextColor3 = fromRGB(255, 255, 255)
    GameName.TextSize = 15
    GameName.TextXAlignment = Enum.TextXAlignment.Left
    GameName.Parent = StatusFrame

    Divider.BackgroundColor3 = fromRGB(45, 45, 45)
    Divider.Position = UDim2_fromOffset(GameName.TextBounds.X + 10, 0)
    Divider.Size = UDim2_fromOffset(0, 2, 0, 17)
    Divider.Parent = StatusFrame

    ElapsedTime.BackgroundTransparency = 1
    ElapsedTime.Position = UDim2_fromOffset(Divider.Position.X.Offset + 10, 0)
    ElapsedTime.Size = UDim2_fromOffset(55, 15)
    ElapsedTime.Font = Enum.Font.SourceSansSemibold
    ElapsedTime.Text = '00:00:00'
    ElapsedTime.TextColor3 = fromRGB(200, 200, 200)
    ElapsedTime.TextSize = 15
    ElapsedTime.TextXAlignment = Enum.TextXAlignment.Left
    ElapsedTime.Parent = StatusFrame

    Divider2.BackgroundColor3 = fromRGB(45, 45, 45)
    Divider2.Position = UDim2_fromOffset(ElapsedTime.Position.X.Offset + ElapsedTime.TextBounds.X + 10, 0)
    Divider2.Size = UDim2_fromOffset(2, 17)
    Divider2.Parent = StatusFrame

    CurrentTime.BackgroundTransparency = 1
    CurrentTime.Position = UDim2_fromOffset(Divider2.Position.X.Offset + 10, 0)
    CurrentTime.Size = UDim2_fromOffset(55, 15)
    CurrentTime.Font = Enum.Font.SourceSansSemibold
    CurrentTime.Text = os.date('%X')
    CurrentTime.TextColor3 = fromRGB(200, 200, 200)
    CurrentTime.TextSize = 15
    CurrentTime.TextXAlignment = Enum.TextXAlignment.Left
    CurrentTime.Parent = StatusFrame

    local StatusLength = CurrentTime.Position.X.Offset + CurrentTime.AbsoluteSize.X
    local VisiblityToggle = true
    local LoadTime = os.time()

    StatusFrame.Size = UDim2_fromOffset(StatusLength, 15)
    StatusFrame.Position = UDim2_fromOffset(500 - StatusLength, 7)

    --[[task.spawn(function()
        while task.wait(1) do
            ElapsedTime.Text = os.time() - LoadTime

        end
    end)]]

    task.spawn(function()
        MainFrame:TweenSize(UDim2_fromOffset(500, 25), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
        task.wait(0.2)
        MainFrame:TweenSize(UDim2_fromOffset(500, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.2, true)
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if input.KeyCode == Enum.KeyCode.BackSlash and not gp then
            VisiblityToggle = not VisiblityToggle
            
            MainFrame.Visible = VisiblityToggle
        end
    end)

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            for i,v in pairs(game.CoreGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)) do
                if v:IsDescendantOf(MainFrame) and v ~= MainFrame then return end
            end

            local Dist = Vector2.new(Mouse.X, Mouse.Y) - MainFrame.AbsolutePosition

            local MouseMove = Mouse.Move:Connect(function()
                MainFrame.Position = UDim2_fromOffset(Mouse.X - Dist.X, Mouse.Y - Dist.Y)
            end)
            local EndedCon = nil
            EndedCon = MainFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    MouseMove:Disconnect()
                    EndedCon:Disconnect()
                end
            end)
        end
    end)

    return Tab(MainFrame)
end

return UiLib;

--[[
    local Window = UiLib:CreateWindow('<font color="rgb(0, 0, 255)">FH</font> v3', 'test')
local tab1 = Window:Tab('test1')
local Section1 = tab1:Section('test')
local Section2 = tab1:Section('a')
local Section3 = tab1:Section('Rage')

Section1:Toggle('test', false, function(a)
    print(a)
end)
Section1:Toggle('fh winning?', true, function() end)
Section1:Dropdown('test', 'default', {'ab', 'ac'}, function(a) 
      print(a) 
end)
Section1:Slider('yooo', -50, 50, 0, function(v) 
      print(v) 
end)
Section1:Slider('yooo', -50, 50, 0, function(v) 
      print(v) 
end, true)
Section1:Colorpicker('Colorpicker', Color3.fromRGB(0, 0, 255), function(a)
      print(a)
end)
Section1:Button('what', function()
      print('ok buton') 
end)
Section1:Keybind('Keybind', nil, function(a)
      print('Set to: ', a) 
end, function() 
      print('tess') 
end)

]]
