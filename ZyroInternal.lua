-- Zyro Internal UI Library
-- By: Your Name Here

local ZyroInternal = {}
ZyroInternal.__index = ZyroInternal

-- Utility functions
local function tween(obj, props, duration, style, dir)
    style = style or Enum.EasingStyle.Quad
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

-- Main Window
function ZyroInternal:Window(title, options)
    options = options or {}
    local accentColor = options.AccentColor or Color3.fromRGB(0, 170, 255)
    local backgroundColor = options.BackgroundColor or Color3.fromRGB(25, 25, 25)
    local textColor = options.TextColor or Color3.fromRGB(255, 255, 255)
    
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
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = backgroundColor,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MainFrame
    })
    
    create("UIStroke", {
        Color = accentColor,
        Thickness = 1,
        Parent = MainFrame
    })
    
    -- Top Bar
    local TopBar = create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = backgroundColor,
        Parent = MainFrame
    })
    
    create("UIStroke", {
        Color = accentColor,
        Thickness = 1,
        Parent = TopBar
    })
    
    local Title = create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Zyro Internal",
        TextColor3 = textColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        Parent = TopBar
    })
    
    local CloseButton = create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = textColor,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = TopBar
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Bar
    local TabBar = create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = backgroundColor,
        Parent = MainFrame
    })
    
    create("UIStroke", {
        Color = accentColor,
        Thickness = 1,
        Parent = TabBar
    })
    
    local TabList = create("Frame", {
        Name = "TabList",
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Parent = TabBar
    })
    
    local UIListLayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabList
    })
    
    -- Content Area
    local ContentArea = create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
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
            Size = UDim2.new(0, 80, 1, 0),
            BackgroundColor3 = backgroundColor,
            Text = name,
            TextColor3 = textColor,
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            Parent = TabList
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = tabButton
        })
        
        local tabFrame = create("ScrollingFrame", {
            Name = name .. "TabFrame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = accentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = ContentArea
        })
        
        create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            Parent = tabFrame
        })
        
        tabFrame.Visible = #tabs == 0
        tabButton.BackgroundColor3 = tabFrame.Visible and accentColor or backgroundColor
        
        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(tabs) do
                otherTab.Frame.Visible = false
                otherTab.Button.BackgroundColor3 = backgroundColor
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
                Size = UDim2.new(1, -20, 0, 0),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                LayoutOrder = #tabFrame:GetChildren(),
                Parent = tabFrame
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = sectionFrame
            })
            
            create("UIStroke", {
                Color = accentColor,
                Thickness = 1,
                Parent = sectionFrame
            })
            
            local sectionTitle = create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = textColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamSemibold,
                TextSize = 13,
                Parent = sectionFrame
            })
            
            local contentFrame = create("Frame", {
                Name = "Content",
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 30),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            local layout = create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                Parent = contentFrame
            })
            
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                contentFrame.Size = UDim2.new(1, -10, 0, layout.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(1, -20, 0, layout.AbsoluteContentSize.Y + 35)
                tabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
            end)
            
            -- Section elements
            function section:Button(text, callback)
                local button = create("TextButton", {
                    Name = text .. "Button",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Text = text,
                    TextColor3 = textColor,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = button
                })
                
                create("UIStroke", {
                    Color = accentColor,
                    Thickness = 1,
                    Parent = button
                })
                
                button.MouseButton1Click:Connect(function()
                    callback()
                    tween(button, {BackgroundColor3 = accentColor}, 0.1)
                    tween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.1, nil, nil, 0.1)
                end)
                
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.1)
                end)
                
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.1)
                end)
                
                return button
            end
            
            function section:Toggle(text, default, callback)
                local toggleValue = default or false
                local toggle = create("TextButton", {
                    Name = text .. "Toggle",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = "",
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local toggleFrame = create("Frame", {
                    Name = "ToggleFrame",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Parent = toggle
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = toggleFrame
                })
                
                create("UIStroke", {
                    Color = accentColor,
                    Thickness = 1,
                    Parent = toggleFrame
                })
                
                local toggleText = create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = textColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = toggleFrame
                })
                
                local toggleSwitch = create("Frame", {
                    Name = "Switch",
                    Size = UDim2.new(0.25, 0, 0, 20),
                    Position = UDim2.new(0.75, -5, 0.5, -10),
                    BackgroundColor3 = toggleValue and accentColor or Color3.fromRGB(65, 65, 65),
                    Parent = toggleFrame
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = toggleSwitch
                })
                
                toggle.MouseButton1Click:Connect(function()
                    toggleValue = not toggleValue
                    tween(toggleSwitch, {BackgroundColor3 = toggleValue and accentColor or Color3.fromRGB(65, 65, 65)}, 0.1)
                    callback(toggleValue)
                end)
                
                return {
                    Set = function(self, value)
                        toggleValue = value
                        tween(toggleSwitch, {BackgroundColor3 = toggleValue and accentColor or Color3.fromRGB(65, 65, 65)}, 0.1)
                        callback(toggleValue)
                    end,
                    Get = function(self)
                        return toggleValue
                    end
                }
            end
            
            function section:Slider(text, min, max, default, callback)
                local sliderValue = default or min
                local slider = create("TextButton", {
                    Name = text .. "Slider",
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    Text = "",
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local sliderFrame = create("Frame", {
                    Name = "SliderFrame",
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Parent = slider
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = sliderFrame
                })
                
                create("UIStroke", {
                    Color = accentColor,
                    Thickness = 1,
                    Parent = sliderFrame
                })
                
                local sliderText = create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 5, 0, 5),
                    BackgroundTransparency = 1,
                    Text = text .. ": " .. sliderValue,
                    TextColor3 = textColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = sliderFrame
                })
                
                local sliderBar = create("Frame", {
                    Name = "Bar",
                    Size = UDim2.new(1, -10, 0, 5),
                    Position = UDim2.new(0, 5, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(65, 65, 65),
                    Parent = sliderFrame
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 2),
                    Parent = sliderBar
                })
                
                local sliderFill = create("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((sliderValue - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = accentColor,
                    Parent = sliderBar
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 2),
                    Parent = sliderFill
                })
                
                local sliding = false
                
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1),
                        0, 1, 0
                    )
                    sliderFill.Size = pos
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
                        sliderFill.Size = UDim2.new((sliderValue - min) / (max - min), 0, 1, 0)
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
                local dropdown = create("TextButton", {
                    Name = text .. "Dropdown",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = "",
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local dropdownFrame = create("Frame", {
                    Name = "DropdownFrame",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Parent = dropdown
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = dropdownFrame
                })
                
                create("UIStroke", {
                    Color = accentColor,
                    Thickness = 1,
                    Parent = dropdownFrame
                })
                
                local dropdownText = create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text .. ": " .. dropdownValue,
                    TextColor3 = textColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = dropdownFrame
                })
                
                local dropdownArrow = create("TextLabel", {
                    Name = "Arrow",
                    Size = UDim2.new(0.2, 0, 1, 0),
                    Position = UDim2.new(0.8, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = textColor,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = dropdownFrame
                })
                
                local dropdownOptions = create("Frame", {
                    Name = "Options",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Visible = false,
                    Parent = dropdownFrame
                })
                
                create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = dropdownOptions
                })
                
                create("UIStroke", {
                    Color = accentColor,
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
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                        Text = option,
                        TextColor3 = textColor,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
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
                        dropdownArrow.Text = "▼"
                        callback(dropdownValue)
                    end)
                end
                
                optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownOptions.Size = UDim2.new(1, 0, 0, optionsLayout.AbsoluteContentSize.Y)
                end)
                
                dropdown.MouseButton1Click:Connect(function()
                    dropdownOpen = not dropdownOpen
                    dropdownOptions.Visible = dropdownOpen
                    dropdownArrow.Text = dropdownOpen and "▲" or "▼"
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
                    TextColor3 = textColor,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = #contentFrame:GetChildren(),
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
