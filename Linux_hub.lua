-- Linux Hub - Blade Ball (Refeito com base no Lunar Hub)
-- Auto Parry otimizado para mobile e PC, com base em cor da bola e distância

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Função de ping (retorna o tempo médio de latência)
local function getPing()
    local stats = LocalPlayer:FindFirstChild("NetworkStats")
    if stats and stats:FindFirstChild("Data Ping") then
        return stats["Data Ping"].Value
    end
    return 80 -- padrão se não encontrar
end

-- Variáveis
local autoParryEnabled = false
local pingBasedEnabled = true
local parryRadius = 25
local debounce = false

-- GUI
local gui = Instance.new("ScreenGui", PlayerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Name = "LinuxHub"

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Linux Hub - Blade Ball"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextSize = 16

local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 25)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

createButton("Auto Parry: OFF", 40, function(btn)
    autoParryEnabled = not autoParryEnabled
    btn.Text = "Auto Parry: " .. (autoParryEnabled and "ON" or "OFF")
end)

createButton("Ping Based: ON", 70, function(btn)
    pingBasedEnabled = not pingBasedEnabled
    btn.Text = "Ping Based: " .. (pingBasedEnabled and "ON" or "OFF")
end)

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 0.5, 90)
toggleBtn.Text = "Minimizar Painel"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "Minimizar Painel" or "Mostrar Painel"
end)

-- Função para detectar bola
RunService.Heartbeat:Connect(function()
    if not autoParryEnabled or debounce then return end

    local ballsFolder = workspace:FindFirstChild("Balls")
    if not ballsFolder then return end

    for _, ball in ipairs(ballsFolder:GetChildren()) do
        if ball:IsA("BasePart") and ball.Color == Color3.fromRGB(255, 0, 0) then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local distance = (ball.Position - char.HumanoidRootPart.Position).Magnitude
            if distance <= parryRadius then
                debounce = true
                local blockBtn = PlayerGui:FindFirstChild("block", true)
                if blockBtn and blockBtn:IsA("ImageButton") then
                    local delayTime = pingBasedEnabled and (getPing() / 1000) or 0.1
                    task.delay(delayTime, function()
                        pcall(function() blockBtn:Activate() end)
                        task.delay(0.5, function() debounce = false end)
                    end)
                else
                    debounce = false
                end
                break
            end
        end
    end
end)
