-- Arquivo: BladeBallAutoParry.lua

--// Serviços e Jogador
local Players = game:GetService("Players")
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

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
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
        for i = 1, 60 do task.wait() count += 1 end
        local delta = tick() - last
        fpsLabel.Text = "FPS: " .. math.floor(count / delta)
    end
end)

--// Função de parry
local function parry()
    VirtualInputManager:SendKeyEvent(true, "F", false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, "F", false, game)
end

--// Loop principal
spawn(function()
    while task.wait(0.03) do
        local char = player.Character
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
    end
end)
