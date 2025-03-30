-- Zyro Internal UI Library v2
-- Modern, Clean, Spacious Design

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

-- Color palette
local colors = {
    primary = Color3.fromRGB(100, 150, 255),
    background = Color3.fromRGB(20, 20, 25),
    surface = Color3.fromRGB(30, 30, 38),
    surfaceLight = Color3.fromRGB(40, 40, 50),
    text = Color3.fromRGB(240, 240, 245),
    accent = Color3.fromRGB(100, 150, 255),
    divider = Color3.fromRGB(50, 50, 60)
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
        Size = UDim2.new(0, 520, 0, 480),
        Position = UDim2.new(0.5, -260, 0.5, -240),
        BackgroundColor3 = backgroundColor,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame
    })
    
    create("UIStroke", {
        Color = Color3.fromRGB(50, 50, 60),
        Thickness = 1,
        Parent = MainFrame
    })
    
    -- Top Bar
    local TopBar = create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = surfaceColor,
        Parent = MainFrame
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TopBar
    })
    
    create("UIStroke", {
        Color = Color3.fromRGB(50, 50, 60),
        Thickness = 1,
        Parent = TopBar
    })
    
    local Title = create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Zyro Internal",
        TextColor3 = textColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        Parent = TopBar
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
        Parent = TopBar
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Bar
    local TabBar = create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, -24, 0, 36),
        Position = UDim2.new(0, 12, 0, 42),
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
        Size = UDim2.new(1, -24, 1, -90),
        Position = UDim2.new(0, 12, 0, 84),
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
    
    TopBar.InputBegan:Connect(function(input)
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
    
    TopBar.InputChanged:Connect(function(input)
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
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
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
        tabButton.BackgroundColor3 = tabFrame.Visible and accentColor or surfaceColor
        
        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(tabs) do
                otherTab.Frame.Visible = false
                otherTab.Button.BackgroundColor3 = surfaceColor
            end
            tabFrame.Visible = true
            tabButton.BackgroundColor3 = accentColor
        end)
        
        table.insert(tabs, {
            Button = tabButton,
            Frame = tabFrame
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
                
                button.MouseButton1Click:Connect(function()
                    callback()
                    tween(button, {BackgroundColor3 = accentColor}, 0.15)
                    tween(button, {BackgroundColor3 = colors.surfaceLight}, 0.15, nil, nil, 0.15)
                end)
                
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(
                        colors.surfaceLight.R * 255 + 10,
                        colors.surfaceLight.G * 255 + 10,
                        colors.surfaceLight.B * 255 + 10
                    )}, 0.15)
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
                    Size = UDim2.new(0, 48, 0, 24),
                    Position = UDim2.new(1, -48, 0.5, -12),
                    BackgroundColor3 = colors.surfaceLight,
                    Parent = toggleFrame
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleSwitch
                })
                
                local toggleDot = create("Frame", {
                    Name = "Dot",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 2, 0.5, -10),
                    BackgroundColor3 = toggleValue and accentColor or Color3.fromRGB(120, 120, 130),
                    Parent = toggleSwitch
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleDot
                })
                
                toggle.MouseButton1Click:Connect(function()
                    toggleValue = not toggleValue
                    if toggleValue then
                        tween(toggleDot, {
                            Position = UDim2.new(1, -22, 0.5, -10),
                            BackgroundColor3 = accentColor
                        }, 0.2)
                    else
                        tween(toggleDot, {
                            Position = UDim2.new(0, 2, 0.5, -10),
                            BackgroundColor3 = Color3.fromRGB(120, 120, 130)
                        }, 0.2)
                    end
                    callback(toggleValue)
                end)
                
                return {
                    Set = function(self, value)
                        toggleValue = value
                        if toggleValue then
                            toggleDot.Position = UDim2.new(1, -22, 0.5, -10)
                            toggleDot.BackgroundColor3 = accentColor
                        else
                            toggleDot.Position = UDim2.new(0, 2, 0.5, -10)
                            toggleDot.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
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
                    end
                end)
                
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
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
            
            function section:Dropdown(text, options, default, callback)
                local dropdownValue = default or options[1]
                local dropdownOpen = false
                local dropdown = create("Frame", {
                    Name = text .. "Dropdown",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    LayoutOrder = #contentFrame:GetChildren() + 1,
                    Parent = contentFrame
                })
                
                local dropdownButton = create("TextButton", {
                    Name = "Button",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = colors.surfaceLight,
                    Text = "",
                    Parent = dropdown
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropdownButton
                })
                
                local dropdownText = create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text .. ": " .. dropdownValue,
                    TextColor3 = textColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    Parent = dropdownButton
                })
                
                local dropdownIcon = create("ImageLabel", {
                    Name = "Icon",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -28, 0.5, -8),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3926305904",
                    ImageRectOffset = Vector2.new(364, 284),
                    ImageRectSize = Vector2.new(36, 36),
                    ImageColor3 = textColor,
                    Rotation = dropdownOpen and 180 or 0,
                    Parent = dropdownButton
                })
                
                local dropdownOptions = create("Frame", {
                    Name = "Options",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 6),
                    BackgroundColor3 = colors.surfaceLight,
                    Visible = false,
                    Parent = dropdown
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropdownOptions
                })
                
                create("UIStroke", {
                    Color = colors.divider,
                    Thickness = 1,
                    Parent = dropdownOptions
                })
                
                local optionsLayout = create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = dropdownOptions
                })
                
                for i, option in pairs(options) do
                    local optionButton = create("TextButton", {
                        Name = option .. "Option",
                        Size = UDim2.new(1, -12, 0, 28),
                        Position = UDim2.new(0, 6, 0, 6 + (i-1)*32),
                        BackgroundColor3 = colors.surface,
                        Text = option,
                        TextColor3 = textColor,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        LayoutOrder = i,
                        Parent = dropdownOptions
                    })
                    
                    create("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = optionButton
                    })
                    
                    optionButton.MouseButton1Click:Connect(function()
                        dropdownValue = option
                        dropdownText.Text = text .. ": " .. dropdownValue
                        dropdownOpen = false
                        dropdownOptions.Visible = false
                        tween(dropdownIcon, {Rotation = 0}, 0.2)
                        callback(dropdownValue)
                    end)
                    
                    optionButton.MouseEnter:Connect(function()
                        tween(optionButton, {BackgroundColor3 = Color3.fromRGB(
                            colors.surface.R * 255 + 10,
                            colors.surface.G * 255 + 10,
                            colors.surface.B * 255 + 10
                        )}, 0.15)
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        tween(optionButton, {BackgroundColor3 = colors.surface}, 0.15)
                    end)
                end
                
                optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownOptions.Size = UDim2.new(1, 0, 0, optionsLayout.AbsoluteContentSize.Y + 12)
                end)
                
                dropdownButton.MouseButton1Click:Connect(function()
                    dropdownOpen = not dropdownOpen
                    dropdownOptions.Visible = dropdownOpen
                    tween(dropdownIcon, {Rotation = dropdownOpen and 180 or 0}, 0.2)
                end)
                
                return {
                    Set = function(self, value)
                        if table.find(options, value) then
                            dropdownValue = value
                            dropdownText.Text = text .. ": " .. dropdownValue
                            callback(dropdownValue)
                        end
                    end,
                    Get = function(self)
                        return dropdownValue
                    end
                }
            end
            
            function section:Label(text)
                local label = create("TextLabel", {
                    Name = text .. "Label",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Color3.fromRGB(180, 180, 190),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = #contentFrame:GetChildren() + 1,
                    Parent = contentFrame
                })
                
                return label
            end
            
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
