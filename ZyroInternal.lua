-- Modernized Hydra UI Library Recreation
local HydraLib = {}
HydraLib.__index = HydraLib

-- Utility functions
local function Create(instance, properties)
    local obj = Instance.new(instance)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            pcall(function() obj[prop] = value end)
        end
    end
    return obj
end

local function Tween(obj, props, time, easing)
    game:GetService("TweenService"):Create(obj, TweenInfo.new(time or 0.2, easing or Enum.EasingStyle.Quad), props):Play()
end

function HydraLib:Window(title, options)
    options = options or {}
    local accent = options.Accent or Color3.fromRGB(0, 170, 255)
    local dark = options.Dark or Color3.fromRGB(15, 15, 20)
    local darker = options.Darker or Color3.fromRGB(10, 10, 15)
    
    local Hydra = {}
    local tabs = {}
    
    -- Main UI
    local ScreenGui = Create("ScreenGui", {
        Name = "HydraUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = darker,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Main})
    
    -- Title bar (Hydra-style)
    local Top = Create("Frame", {
        Name = "Top",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = dark,
        Parent = Main
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Top
    })
    
    local Title = Create("TextLabel", {
        Text = title or "HYDRA",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Top
    })
    
    -- Hydra-style close button
    local Close = Create("TextButton", {
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        Parent = Top
    })
    
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab bar (Hydra-style with underline)
    local TabList = Create("Frame", {
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 30),
        BackgroundTransparency = 1,
        Parent = Main
    })
    
    local UIListLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabList
    })
    
    -- Content area
    local Container = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = accent,
        Parent = Main
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = Container
    })
    
    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            Tween(Main, {Size = UDim2.new(0, 510, 0, 410)})
        end
    end)
    
    Top.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            Tween(Main, {Size = UDim2.new(0, 500, 0, 400)})
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab system
    function Hydra:Tab(name)
        local tab = {}
        local tabButton = Create("TextButton", {
            Text = name,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundColor3 = dark,
            Size = UDim2.new(0, 80, 1, 0),
            Parent = TabList
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = tabButton})
        
        -- Hydra-style tab indicator
        local indicator = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = accent,
            Visible = false,
            Parent = tabButton
        })
        
        local tabFrame = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = #tabs == 0,
            Parent = Container
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            Parent = tabFrame
        })
        
        indicator.Visible = #tabs == 0
        
        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Frame.Visible = false
                t.Indicator.Visible = false
                Tween(t.Button, {BackgroundColor3 = dark})
            end
            tabFrame.Visible = true
            indicator.Visible = true
            Tween(tabButton, {BackgroundColor3 = darker})
        end)
        
        table.insert(tabs, {
            Button = tabButton,
            Frame = tabFrame,
            Indicator = indicator
        })
        
        -- Section function
        function tab:Section(title)
            local section = {}
            local sectionFrame = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 0),
                BackgroundColor3 = dark,
                Parent = tabFrame
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = sectionFrame})
            
            local sectionTitle = Create("TextLabel", {
                Text = title,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 5, 0, 5),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame
            })
            
            local content = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 30),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                Parent = content
            })
            
            -- Button element
            function section:Button(text, callback)
                local button = Create("TextButton", {
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Color3.new(1, 1, 1),
                    BackgroundColor3 = darker,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = content
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = button})
                
                button.MouseButton1Click:Connect(function()
                    callback()
                    Tween(button, {BackgroundColor3 = accent}, 0.1)
                    Tween(button, {BackgroundColor3 = darker}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.1)
                end)
                
                button.MouseEnter:Connect(function()
                    Tween(button, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)})
                end)
                
                button.MouseLeave:Connect(function()
                    Tween(button, {BackgroundColor3 = darker})
                end)
                
                return button
            end
            
            -- Toggle element
            function section:Toggle(text, default, callback)
                local toggle = Create("TextButton", {
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = content
                })
                
                local toggleFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = darker,
                    Parent = toggle
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = toggleFrame})
                
                local toggleText = Create("TextLabel", {
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                })
                
                local toggleSwitch = Create("Frame", {
                    Size = UDim2.new(0.25, 0, 0, 20),
                    Position = UDim2.new(0.75, -5, 0.5, -10),
                    BackgroundColor3 = default and accent or Color3.fromRGB(60, 60, 70),
                    Parent = toggleFrame
                })
                
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = toggleSwitch})
                
                toggle.MouseButton1Click:Connect(function()
                    default = not default
                    Tween(toggleSwitch, {BackgroundColor3 = default and accent or Color3.fromRGB(60, 60, 70)})
                    callback(default)
                end)
                
                return {
                    Set = function(self, value)
                        default = value
                        toggleSwitch.BackgroundColor3 = default and accent or Color3.fromRGB(60, 60, 70)
                        callback(default)
                    end
                }
            end
            
            return section
        end
        
        return tab
    end
    
    ScreenGui.Parent = game:GetService("CoreGui")
    return Hydra
end

return HydraLib
