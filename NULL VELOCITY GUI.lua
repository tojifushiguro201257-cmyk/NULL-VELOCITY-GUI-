local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")

local speedEnabled = false
local customBoost = 100 

local char, humanoid, hrp
local steppedConn, staminaConn
local isBlueLock = false
local staminaValue

local function setupCharacter(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid", 10)
    hrp = newChar:WaitForChild("HumanoidRootPart", 10)
    
    local playerStats = player:FindFirstChild("PlayerStats")
    if playerStats and playerStats:FindFirstChild("Stamina") then
        isBlueLock = true
        staminaValue = playerStats.Stamina
    end
    
    if steppedConn then steppedConn:Disconnect() end
    if staminaConn then staminaConn:Disconnect() end
    
    if isBlueLock and staminaValue then
        staminaConn = rs.Heartbeat:Connect(function()
            if speedEnabled and staminaValue.Parent then
                staminaValue.Value = 100
            end
        end)
    end
    
    steppedConn = rs.Stepped:Connect(function()
        if not speedEnabled or not humanoid or humanoid.Health <= 0 then return end
        
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local totalSpeed = humanoid.WalkSpeed + customBoost
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                totalSpeed = totalSpeed * 1.6
            end
            hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * totalSpeed, hrp.AssemblyLinearVelocity.Y, moveDir.Z * totalSpeed)
        end
    end)
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

local sg = Instance.new("ScreenGui")
sg.Name = "NullVelocityClassic"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

-- BOTÓN FLOTANTE (Círculo con N Clásica)
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0, 65, 0, 65)
menuButton.Position = UDim2.new(0.05, 0, 0.2, 0)
menuButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuButton.Text = "N"
menuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
menuButton.Font = Enum.Font.Bodoni 
menuButton.TextSize = 40
menuButton.Parent = sg

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = menuButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 255, 255)
buttonStroke.Thickness = 2.5
buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
buttonStroke.Parent = menuButton

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 280)
main.Position = UDim2.new(0.5, -110, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
main.Visible = false
main.Parent = sg

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "NULL VELOCITY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = main

-- BOTÓN TOGGLE
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.1, 0, 0.22, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "DISABLED"
toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.Parent = main
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 4)

toggleBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        toggleBtn.Text = "ENABLED"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    else
        toggleBtn.Text = "DISABLED"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.45, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "BOOST VELOCITY"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 14
speedLabel.Parent = main

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.8, 0, 0, 4)
sliderBg.Position = UDim2.new(0.1, 0, 0.58, 0)
sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = main

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(customBoost/500, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 14, 0, 14)
knob.Position = UDim2.new(customBoost/500, -7, 0.5, -7)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.Parent = sliderBg
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.4, 0, 0, 30)
speedInput.Position = UDim2.new(0.3, 0, 0.72, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Cuadro Blanco
speedInput.Text = tostring(customBoost)
speedInput.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto Negro para contraste
speedInput.Font = Enum.Font.SourceSansBold
speedInput.TextSize = 18
speedInput.Parent = main
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 4)

local function updateVisuals(val)
    local ratio = math.clamp(val / 500, 0, 1)
    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    knob.Position = UDim2.new(ratio, -7, 0.5, -7)
    speedInput.Text = tostring(val)
    customBoost = val
end

local sliding = false
knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

uis.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local ratio = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        updateVisuals(math.floor(ratio * 500))
    end
end)

speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then
        updateVisuals(math.clamp(math.floor(num), 0, 500))
    else
        speedInput.Text = tostring(customBoost)
    end
end)


local dragging, dragInput, dragStart, startPos
menuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = menuButton.Position
    end
end)
uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        menuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
menuButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

menuButton.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
