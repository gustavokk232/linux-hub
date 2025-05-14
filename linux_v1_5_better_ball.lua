
-- Linux v1.5 - Auto Parry (Melhor Detecção da Bola)

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
local function findFastMovingObject()
    local best = nil
    local closestDist = math.huge
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Velocity.Magnitude > 50 then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < closestDist and not player.Character:IsAncestorOf(obj) then
                closestDist = dist
                best = obj
            end
        end
    end
    return best
end

local function getSword(char)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            return tool
        end
    end
end

-- Main Logic
local function monitorCharacter(char)
    RunService:UnbindFromRenderStep("LinuxParryLoop")

    RunService:BindToRenderStep("LinuxParryLoop", 1, function()
        local ball = findFastMovingObject()
        local sword = getSword(char)

        if not ball or not sword then return end

        local swordPos = sword:FindFirstChild("Handle") and sword.Handle.Position or char:FindFirstChild("HumanoidRootPart").Position
        local distance = (swordPos - ball.Position).Magnitude
        if distance < 12 then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            status.Text = "Status: Parry Triggered"
            wait(0.3)
            status.Text = "Status: Waiting..."
        end
    end)
end

monitorCharacter(character)

player.CharacterAdded:Connect(function(char)
    character = char
    char:WaitForChild("HumanoidRootPart", 5)
    wait(1)
    monitorCharacter(char)
end)
