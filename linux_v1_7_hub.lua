-- Arquivo: BladeBallAutoParry.lua

--// Serviços e Jogador
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "Linuxv1_5"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = true

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

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 110)
toggleBtn.Text = "Auto Parry: ON"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BorderSizePixel = 0

-- Botão de minimizar externo
local toggleUI = Instance.new("TextButton", gui)
toggleUI.Size = UDim2.new(0, 100, 0, 30)
toggleUI.Position = UDim2.new(0, 10, 0, 200)
toggleUI.Text = "Mostrar GUI"
toggleUI.TextScaled = true
toggleUI.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleUI.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleUI.BorderSizePixel = 0

toggleUI.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleUI.Text = frame.Visible and "Ocultar GUI" or "Mostrar GUI"
end)

--// Estado
local parryEnabled = true
toggleBtn.MouseButton1Click:Connect(function()
    parryEnabled = not parryEnabled
    toggleBtn.Text = "Auto Parry: " .. (parryEnabled and "ON" or "OFF")
end)

--// Campo de força visual
local forcePart = Instance.new("Part")
forcePart.Anchored = true
forcePart.CanCollide = false
forcePart.Shape = Enum.PartType.Ball
forcePart.Transparency = 1
forcePart.Material = Enum.Material.ForceField
forcePart.Color = Color3.fromRGB(255, 0, 0)
forcePart.Parent = workspace

--// FPS Monitor
spawn(function()
    while task.wait(1) do
        local last = tick()
        local count = 0
        for i = 1, 60 do RunService.Heartbeat:Wait() count += 1 end
        local delta = tick() - last
        fpsLabel.Text = "FPS: " .. math.floor(count / delta)
    end
end)

--// Função de parry (rápida)
local function parry()
    VirtualInputManager:SendKeyEvent(true, "F", false, game)
    RunService.Heartbeat:Wait()
    VirtualInputManager:SendKeyEvent(false, "F", false, game)
end

--// Loop principal
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not parryEnabled or not char or not char:FindFirstChild("HumanoidRootPart") then
        forcePart.Transparency = 1
        status.Text = "Parry: Inativo ou morto"
        return
    end

    local hrp = char.HumanoidRootPart
    local balls = workspace:FindFirstChild("Balls")
    local closest, minDist, velocity = nil, math.huge, nil

    if balls then
        for _, ball in ipairs(balls:GetChildren()) do
            if ball:IsA("BasePart") then
                local toPlayer = (hrp.Position - ball.Position).Unit
                local ballVelocity = ball.Velocity
                local dot = toPlayer:Dot(ballVelocity.Unit)
                local dist = (ball.Position - hrp.Position).Magnitude

                if dot > 0.7 and dist < minDist and ballVelocity.Magnitude > 10 then
                    closest = ball
                    minDist = dist
                    velocity = ballVelocity.Magnitude
                end
            end
        end
    end

    if closest then
        local radius = math.clamp(velocity / 5, 6, 30)
        forcePart.Position = hrp.Position
        forcePart.Size = Vector3.new(radius, radius, radius)
        forcePart.Transparency = 0.3

        status.Text = "Parry: Pronto (" .. math.floor(minDist) .. " studs)"

        if minDist <= radius then
            parry()
            status.Text = "Parry: EXECUTADO"
        end
    else
        forcePart.Transparency = 1
        status.Text = "Parry: Aguardando bola"
    end
end)
