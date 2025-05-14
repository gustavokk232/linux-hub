-- Blade Ball Auto Parry Script - Linux v1.5
-- Autor: ChatGPT + Você

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "Linuxv1_5"

-- Painel principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Linux v1.5"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(138, 43, 226)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -10, 0, 25)
status.Position = UDim2.new(0, 5, 0, 35)
status.Text = "Parry: Esperando..."
status.TextScaled = true
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 255, 255)

local fpsLabel = Instance.new("TextLabel", frame)
fpsLabel.Size = UDim2.new(1, -10, 0, 25)
fpsLabel.Position = UDim2.new(0, 5, 0, 65)
fpsLabel.Text = "FPS: Calculando..."
fpsLabel.TextScaled = true
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Botão de minimizar/restaurar
local toggleFrameBtn = Instance.new("TextButton", gui)
toggleFrameBtn.Size = UDim2.new(0, 25, 0, 25)
toggleFrameBtn.Position = UDim2.new(0, 255, 0, 10)
toggleFrameBtn.Text = "-"
toggleFrameBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleFrameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFrameBtn.BorderSizePixel = 0

local minimized = false
toggleFrameBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Visible = not minimized
    toggleFrameBtn.Text = minimized and "+" or "-"
end)

-- Botão de ativar parry
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 110)
toggleBtn.Text = "Auto Parry: ON"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BorderSizePixel = 0

local parryEnabled = true
toggleBtn.MouseButton1Click:Connect(function()
    parryEnabled = not parryEnabled
    toggleBtn.Text = "Auto Parry: " .. (parryEnabled and "ON" or "OFF")
end)

-- Campo de força visual
local forcePart = Instance.new("Part")
forcePart.Anchored = true
forcePart.CanCollide = false
forcePart.Shape = Enum.PartType.Ball
forcePart.Material = Enum.Material.ForceField
forcePart.Color = Color3.fromRGB(255, 255, 255)
forcePart.Transparency = 0.7
forcePart.Size = Vector3.new(15, 15, 15)
forcePart.Parent = workspace

-- FPS monitor
spawn(function()
    while task.wait(1) do
        local last = tick()
        local count = 0
        for _ = 1, 60 do task.wait() count += 1 end
        local delta = tick() - last
        fpsLabel.Text = "FPS: " .. math.floor(count / delta)
    end
end)

-- Parry universal (PC/Mobile)
local UIS = game:GetService("UserInputService")
local function parry()
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
        local blockBtn = plr:FindFirstChild("PlayerGui"):FindFirstChild("Block", true)
        if blockBtn and (blockBtn:IsA("ImageButton") or blockBtn:IsA("TextButton")) then
            pcall(function()
                blockBtn:Activate()
            end)
        end
    else
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, "F", false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, "F", false, game)
    end
end

-- Loop principal
while task.wait(0.03) do
    local char = plr.Character
    if not parryEnabled or not char or not char:FindFirstChild("HumanoidRootPart") then
        forcePart.Transparency = 1
        status.Text = "Parry: Inativo ou morto"
        continue
    end

    local hrp = char.HumanoidRootPart
    local balls = workspace:FindFirstChild("Balls")
    local closest, minDist, velocity = nil, math.huge, nil

    if balls then
        for _, ball in ipairs(balls:GetChildren()) do
            if ball:IsA("BasePart") and ball.Color == Color3.fromRGB(255, 0, 0) then
                local dist = (ball.Position - hrp.Position).Magnitude
                local directionToPlayer = (hrp.Position - ball.Position).Unit
                local ballDirection = ball.Velocity.Unit
                local approaching = ball.Velocity.Magnitude > 10 and directionToPlayer:Dot(ballDirection) > 0.75
                if dist < minDist and approaching then
                    closest = ball
                    minDist = dist
                    velocity = ball.Velocity.Magnitude
                end
            end
        end
    end

    if closest then
        local radius = math.clamp(velocity / 5, 6, 30)
        forcePart.Position = hrp.Position
        forcePart.Size = Vector3.new(radius, radius, radius)
        forcePart.Transparency = 0.3
        forcePart.Color = Color3.fromRGB(255, 0, 0)

        status.Text = "Parry: Pronto (" .. math.floor(minDist) .. ")"
        if minDist <= radius then
            parry()
            status.Text = "Parry: EXECUTADO"
        end
    else
        forcePart.Position = hrp.Position
        forcePart.Transparency = 0.7
        forcePart.Color = Color3.fromRGB(255, 255, 255)
        status.Text = "Parry: Aguardando bola"
    end
end
