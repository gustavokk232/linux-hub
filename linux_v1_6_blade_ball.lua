-- Linux v1.6 - Auto Parry simples e eficaz

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "Linux16_UI"
gui.ResetOnSpawn = false

-- UI básica
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "Ativar Auto Parry"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
button.TextColor3 = Color3.fromRGB(0, 255, 127)
button.BorderSizePixel = 0
button.Active = true
button.Draggable = true

-- Função de parry
local function doParry()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

-- Detectar bola
local function findBall()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closest, distance = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") and obj.Velocity.Magnitude > 5 then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < distance then
                closest = obj
                distance = dist
            end
        end
    end
    return closest, distance
end

-- Loop de parry
local running = false
local function startParryLoop()
    RunService:UnbindFromRenderStep("LinuxParry")
    if running then
        running = false
        button.Text = "Ativar Auto Parry"
        return
    end

    running = true
    button.Text = "Desativar Auto Parry"

    RunService:BindToRenderStep("LinuxParry", Enum.RenderPriority.Character.Value, function()
        local ball, dist = findBall()
        if ball and dist < 13 then
            doParry()
        end
    end)
end

button.MouseButton1Click:Connect(startParryLoop)

-- Reinício após a morte
player.CharacterAdded:Connect(function(char)
    character = char
    wait(1)
end)
