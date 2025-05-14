
-- Linux v1.5 by Você

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LinuxV15UI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Linux v1.5 - Auto Parry"
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.TextScaled = true
title.BackgroundTransparency = 1

local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 0, 0, 35)
status.Size = UDim2.new(1, 0, 0, 25)
status.Text = "Status: Waiting..."
status.TextColor3 = Color3.new(1, 1, 1)
status.TextScaled = true
status.BackgroundTransparency = 1

-- Auto Parry Logic
local function findBall()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("projectile")) then
            return obj
        end
    end
end

local function getSword()
    character = player.Character or player.CharacterAdded:Wait()
    return character:FindFirstChildWhichIsA("Tool")
end

RunService.RenderStepped:Connect(function()
    local ball = findBall()
    local sword = getSword()

    if not ball or not sword then return end

    local distance = (sword.Position - ball.Position).Magnitude
    if distance < 12 then
        -- Trigger parry
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        status.Text = "Status: Parry Triggered"
        wait(0.3)
        status.Text = "Status: Waiting..."
    end
end)
