-- Zyro Internal UI Library v3
-- Ultra-Modern Premium Design

local ZyroInternal = {}
ZyroInternal.__index = ZyroInternal

-- Utility functions
local function tween(obj, props, duration, style, dir)
    style = style or Enum.EasingStyle.Quint
    dir = dir or Enum.EasingDirection.Out
    game:GetService("TweenService"):Create(obj, TweenInfo.new(duration, style, dir), props):Play()
end

local function create(class, props)
    local obj = Instance.new(class)
    for prop, value in pairs(props) do
        if prop ~= "Parent" then
            if pcall(function() return obj[prop] end) then
                obj[prop] = value
            end
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

-- Premium Color Palette
local colors = {
    primary = Color3.fromRGB(0, 170, 255),
    background = Color3.fromRGB(12, 12, 15),
    surface = Color3.fromRGB(20, 20, 25),
    surfaceLight = Color3.fromRGB(30, 30, 38),
    surfaceLighter = Color3.fromRGB(40, 40, 50),
    text = Color3.fromRGB(245, 245, 250),
    textDim = Color3.fromRGB(180, 180, 190),
    accent = Color3.fromRGB(0, 170, 255),
    accentDark = Color3.fromRGB(0, 140, 220),
    divider = Color3.fromRGB(40, 40, 50),
    glow = Color3.fromRGB(0, 100, 255)
}

-- Main Window
function ZyroInternal:Window(title, options)
    options = options or {}
    local accentColor = options.AccentColor or colors.accent
    local backgroundColor = options.BackgroundColor or colors.background
    local surfaceColor = options.SurfaceColor or colors.surface
    local textColor = options.TextColor or colors.text
    
    local Zyro = {}
    local tabs = {}
    
    -- Main UI Container
    local ScreenGui = create("ScreenGui", {
        Name = "ZyroInternal",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local MainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 540, 0, 500),
        Position = UDim2.new(0.5, -270, 0.5, -250),
        BackgroundColor3 = backgroundColor,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MainFrame
    })
    
    -- Glow effect
    local glow = create("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0.5, -20, 0.5, -20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = colors.glow,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ImageTransparency = 0.8,
        Parent = MainFrame
    })
    
    -- Top Bar (now at bottom)
    local BottomBar = create("Frame", {
        Name = "BottomBar",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 1, -40),
        BackgroundColor3 = surfaceColor,
        Parent = MainFrame
    })
    
    -- Remove bottom rounding
    create("UIStroke", {
        Color = colors.divider,
        Thickness = 1,
        Parent = MainFrame
    })
    
    local Title = create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "ZYRO",
        TextColor3 = textColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        TextTransparency = 0.2,
        Parent = BottomBar
    })
    
    local CloseButton = create("ImageButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -32, 0.5, -12),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(284, 4),
        ImageRectSize = Vector2.new(24, 24),
        ImageColor3 = textColor,
        Parent = BottomBar
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Bar (now at top)
    local TabBar = create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, -24, 0, 40),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local TabList = create("Frame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = TabBar
    })
    
    local UIListLayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = TabList
    })
    
    -- Content Area
    local ContentArea = create("ScrollingFrame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -24, 1, -96),
        Position = UDim2.new(0, 12, 0, 48),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = accentColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = MainFrame
    })
    
    -- Dragging functionality
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TabBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TabBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Tab functions
    function Zyro:Tab(name)
        local tab = {}
        local tabButton = create("TextButton", {
            Name = name .. "TabButton",
            Size = UDim2.new(0, 100, 1, -8),
            Position = UDim2.new(0, 0, 0.5, -4),
            BackgroundColor3 = surfaceColor,
            Text = name,
            TextColor3 = textColor,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            Parent = TabList
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = tabButton
        })
        
        -- Tab indicator (hidden by default)
        local tabIndicator = create("Frame", {
            Name = "Indicator",
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 1, -3),
            BackgroundColor3 = accentColor,
            Visible = false,
            Parent = tabButton
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 2),
            Parent = tabIndicator
        })
        
        local tabFrame = create("Frame", {
            Name = name .. "TabFrame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Parent = ContentArea
        })
        
        local contentLayout = create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            Parent = tabFrame
        })
        
        tabFrame.Visible = #tabs == 0
        tabIndicator.Visible = #tabs == 0
        tabButton.BackgroundColor3 = tabFrame.Visible and surfaceLight or surfaceColor
        
        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(tabs) do
                otherTab.Frame.Visible = false
                otherTab.Indicator.Visible = false
                tween(otherTab.Button, {BackgroundColor3 = surfaceColor}, 0.2)
            end
            tabFrame.Visible = true
            tabIndicator.Visible = true
            tween(tabButton, {BackgroundColor3 = surfaceLight}, 0.2)
        end)
        
        table.insert(tabs, {
            Button = tabButton,
            Frame = tabFrame,
            Indicator = tabIndicator
        })
        
        -- Tab elements
        function tab:Section(title)
            local section = {}
            local sectionFrame = create("Frame", {
                Name = title .. "Section",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = surfaceColor,
                LayoutOrder = #tabFrame:GetChildren() + 1,
                Parent = tabFrame
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = sectionFrame
            })
            
            create("UIStroke", {
                Color = colors.divider,
                Thickness = 1,
                Parent = sectionFrame
            })
            
            -- Section glow
            local sectionGlow = create("ImageLabel", {
                Name = "Glow",
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0.5, -5, 0.5, -5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = "rbxassetid://5028857084",
                ImageColor3 = colors.glow,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(24, 24, 276, 276),
                ImageTransparency = 0.9,
                Parent = sectionFrame
            })
            
            local sectionTitle = create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -24, 0, 28),
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text = string.upper(title),
                TextColor3 = textColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                Parent = sectionFrame
            })
            
            local divider = create("Frame", {
                Name = "Divider",
                Size = UDim2.new(1, -24, 0, 1),
                Position = UDim2.new(0, 12, 0, 40),
                BackgroundColor3 = colors.divider,
                Parent = sectionFrame
            })
            
            local contentFrame = create("Frame", {
                Name = "Content",
                Size = UDim2.new(1, -24, 0, 0),
                Position = UDim2.new(0, 12, 0, 48),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            local layout = create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = contentFrame
            })
            
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                contentFrame.Size = UDim2.new(1, -24, 0, layout.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 56)
                ContentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 24)
            end)
            
            -- Section elements
            function section:Button(text, callback)
                local button = create("TextButton", {
                    Name = text .. "Button",
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = colors.surfaceLight,
                    Text = text,
                    TextColor3 = textColor,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    LayoutOrder = #contentFrame:GetChildren() + 1,
                    Parent = contentFrame
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = button
                })
                
                -- Button glow
                local buttonGlow = create("ImageLabel", {
                    Name = "Glow",
                    Size = UDim2.new(1, 10, 1, 10),
                    Position = UDim2.new(0.5, -5, 0.5, -5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = colors.glow,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ImageTransparency = 0.95,
                    Parent = button
                })
                
                button.MouseButton1Click:Connect(function()
                    callback()
                    tween(button, {BackgroundColor3 = accentColor}, 0.15)
                    tween(buttonGlow, {ImageTransparency = 0.8}, 0.15)
                    tween(button, {BackgroundColor3 = colors.surfaceLight}, 0.15, nil, nil, 0.15)
                    tween(buttonGlow, {ImageTransparency = 0.95}, 0.15, nil, nil, 0.15)
                end)
                
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = colors.surfaceLighter}, 0.15)
                end)
                
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = colors.surfaceLight}, 0.15)
                end)
                
                return button
            end
            
            function section:Toggle(text, default, callback)
                local toggleValue = default or false
                local toggle = create("TextButton", {
                    Name = text .. "Toggle",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Text = "",
                    LayoutOrder = #contentFrame:GetChildren() + 1,
                    Parent = contentFrame
                })
                
                local toggleFrame = create("Frame", {
                    Name = "ToggleFrame",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Parent = toggle
                })
                
                local toggleText = create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = textColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    Parent = toggleFrame
                })
                
                local toggleSwitch = create("Frame", {
                    Name = "Switch",
                    Size = UDim2.new(0, 50, 0, 26),
                    Position = UDim2.new(1, -50, 0.5, -13),
                    BackgroundColor3 = colors.surfaceLight,
                    Parent = toggleFrame
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleSwitch
                })
                
                -- Toggle glow
                local toggleGlow = create("ImageLabel", {
                    Name = "Glow",
                    Size = UDim2.new(1, 10, 1, 10),
                    Position = UDim2.new(0.5, -5, 0.5, -5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = colors.glow,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ImageTransparency = 0.95,
                    Parent = toggleSwitch
                })
                
                local toggleDot = create("Frame", {
                    Name = "Dot",
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = UDim2.new(0, 2, 0.5, -11),
                    BackgroundColor3 = toggleValue and accentColor or colors.textDim,
                    Parent = toggleSwitch
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleDot
                })
                
                create("UIStroke", {
                    Color = Color3.fromRGB(60, 60, 70),
                    Thickness = 1,
                    Parent = toggleDot
                })
                
                toggle.MouseButton1Click:Connect(function()
                    toggleValue = not toggleValue
                    if toggleValue then
                        tween(toggleDot, {
                            Position = UDim2.new(1, -24, 0.5, -11),
                            BackgroundColor3 = accentColor
                        }, 0.2)
                        tween(toggleGlow, {ImageTransparency = 0.8}, 0.2)
                    else
                        tween(toggleDot, {
                            Position = UDim2.new(0, 2, 0.5, -11),
                            BackgroundColor3 = colors.textDim
                        }, 0.2)
                        tween(toggleGlow, {ImageTransparency = 0.95}, 0.2)
                    end
                    callback(toggleValue)
                end)
                
                return {
                    Set = function(self, value)
                        toggleValue = value
                        if toggleValue then
                            toggleDot.Position = UDim2.new(1, -24, 0.5, -11)
                            toggleDot.BackgroundColor3 = accentColor
                            toggleGlow.ImageTransparency = 0.8
                        else
                            toggleDot.Position = UDim2.new(0, 2, 0.5, -11)
                            toggleDot.BackgroundColor3 = colors.textDim
                            toggleGlow.ImageTransparency = 0.95
                        end
                        callback(toggleValue)
                    end,
                    Get = function(self)
                        return toggleValue
                    end
                }
            end
            
            function section:Slider(text, min, max, default, callback)
                local sliderValue = default or min
                local slider = create("Frame", {
                    Name = text .. "Slider",
                    Size = UDim2.new(1, 0, 0, 56),
                    BackgroundTransparency = 1,
                    LayoutOrder = #contentFrame:GetChildren() + 1,
                    Parent = contentFrame
                })
                
                local sliderText = create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text .. ": " .. sliderValue,
                    TextColor3 = textColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    Parent = slider
                })
                
                local sliderBar = create("Frame", {
                    Name = "Bar",
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundColor3 = colors.surfaceLight,
                    Parent = slider
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderBar
                })
                
                -- Slider glow
                local sliderGlow = create("ImageLabel", {
                    Name = "Glow",
                    Size = UDim2.new(1, 10, 1, 10),
                    Position = UDim2.new(0.5, -5, 0.5, -5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = colors.glow,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ImageTransparency = 0.95,
                    Parent = sliderBar
                })
                
                local sliderFill = create("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((sliderValue - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = accentColor,
                    Parent = sliderBar
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderFill
                })
                
                local sliderDot = create("Frame", {
                    Name = "Dot",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new((sliderValue - min) / (max - min), -8, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(240, 240, 245),
                    Parent = sliderBar
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderDot
                })
                
                create("UIStroke", {
                    Color = accentColor,
                    Thickness = 2,
                    Parent = sliderDot
                })
                
                -- Dot glow
                local dotGlow = create("ImageLabel", {
                    Name = "Glow",
                    Size = UDim2.new(1, 10, 1, 10),
                    Position = UDim2.new(0.5, -5, 0.5, -5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://5028857084",
                    ImageColor3 = colors.glow,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(24, 24, 276, 276),
                    ImageTransparency = 0.9,
                    Parent = sliderDot
                })
                
                local sliding = false
                
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1),
                        0, 1, 0
                    )
                    sliderFill.Size = pos
                    sliderDot.Position = UDim2.new(pos.X.Scale, -8, 0.5, -8)
                    local value = math.floor(min + (max - min) * pos.X.Scale)
                    if value ~= sliderValue then
                        sliderValue = value
                        sliderText.Text = text .. ": " .. sliderValue
                        callback(sliderValue)
                    end
                end
                
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        updateSlider(input)
                        tween(sliderGlow, {ImageTransparency = 0.8}, 0.2)
                        tween(dotGlow, {ImageTransparency = 0.7}, 0.2)
                    end
                end)
                
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                        tween(sliderGlow, {ImageTransparency = 0.95}, 0.2)
                        tween(dotGlow, {ImageTransparency = 0.9}, 0.2)
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
                        updateSlider(input)
                    end
                end)
                
                return {
                    Set = function(self, value)
                        sliderValue = math.clamp(value, min, max)
                        local pos = UDim2.new((sliderValue - min) / (max - min), 0, 1, 0)
                        sliderFill.Size = pos
                        sliderDot.Position = UDim2.new(pos.X.Scale, -8, 0.5, -8)
                        sliderText.Text = text .. ": " .. sliderValue
                        callback(sliderValue)
                    end,
                    Get = function(self)
                        return sliderValue
                    end
                }
            end
            
            -- Other elements (Dropdown, Label) would follow similar patterns...
            
            return section
        end
        
        return tab
    end
    
    -- Toggle UI visibility
    function Zyro:Toggle()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
    
    -- Make UI visible
    ScreenGui.Parent = game:GetService("CoreGui")
    
    return Zyro
end

return ZyroInternal
