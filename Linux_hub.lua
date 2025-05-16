-- Linux Hub - Blade Ball
-- Auto Parry + Clash Assist + Painel GUI (minimizável)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CONFIG
local PARry_RADIUS = 25
local AUTO_PARRY = false
local CLASH_ASSIST = false
local PING_BASED = true

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "LinuxHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Position = UDim2.new(0, 20, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Linux Hub - Blade Ball"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16

-- Toggle Function Generator
local function createToggle(name, posY, default, callback)
    local Toggle = Instance.new("TextButton", MainFrame)
    Toggle.Size = UDim2.new(1, -20, 0, 25)
    Toggle.Position = UDim2.new(0, 10, 0, posY)
    Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.TextSize = 14

    local state = default
    Toggle.Text = name .. ": " .. (state and "ON" or "OFF")

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- Toggle Buttons
createToggle("Auto Parry", 40, false, function(state) AUTO_PARRY = state end)
createToggle("Clash Assist", 70, false, function(state) CLASH_ASSIST = state end)
createToggle("Ping Based", 100, true, function(state) PING_BASED = state end)

-- Minimize Button
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 120, 0, 30)
ToggleButton.Position = UDim2.new(0, 20, 0.5, 120)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextSize = 14
ToggleButton.Text = "Minimizar Painel"

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "Minimizar Painel" or "Mostrar Painel"
end)

-- Auto Parry Logic
RunService.Heartbeat:Connect(function()
    if not AUTO_PARRY then return end

    local balls = workspace:FindFirstChild("Balls")
    if not balls then return end

    for _, ball in ipairs(balls:GetChildren()) do
        if ball:IsA("BasePart") and ball.Color == Color3.fromRGB(255, 0, 0) then
            local dist = (ball.Position - HumanoidRootPart.Position).Magnitude
            if dist <= PARry_RADIUS then
                local blockButton = PlayerGui:FindFirstChild("block", true)
                if blockButton and blockButton:IsA("ImageButton") then
                    blockButton:Activate()
                end
            end
        end
    end
end)

-- Em breve: Clash Assist (baseado na lógica de ataque simultâneo)
