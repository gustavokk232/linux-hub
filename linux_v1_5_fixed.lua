
-- Linux v1.5 - Auto Parry (Com Reconexão)

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI
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

-- Utility
local function findBall()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("projectile")) then
            return obj
        end
    end
end

local function getSword(char)
    return char:FindFirstChildWhichIsA("Tool")
end

-- Main Logic
local function monitorCharacter(char)
    RunService:UnbindFromRenderStep("LinuxParryLoop")

    RunService:BindToRenderStep("LinuxParryLoop", 1, function()
        local ball = findBall()
        local sword = getSword(char)

        if not ball or not sword then return end

        local distance = (sword.Handle.Position - ball.Position).Magnitude
        if distance < 12 then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            status.Text = "Status: Parry Triggered"
            wait(0.2)
            status.Text = "Status: Waiting..."
        end
    end)
end

monitorCharacter(character)

player.CharacterAdded:Connect(function(char)
    character = char
    char:WaitForChild("HumanoidRootPart", 5)
    wait(1) -- give time for tool and ball to appear
    monitorCharacter(char)
end)
