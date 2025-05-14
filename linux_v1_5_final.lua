
-- Linux v1.5 Final - Auto Parry com detecção e reinício aprimorados

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local function createGUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "LinuxV15"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
    status.Text = "Status: Aguardando..."
    status.TextColor3 = Color3.new(1, 1, 1)
    status.TextScaled = true
    status.BackgroundTransparency = 1

    return status
end

local statusLabel = createGUI()

-- Busca por espada
local function getSword(char)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            return tool
        end
    end
end

-- Busca por bola ativa
local function findBall()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local candidates = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if (name:find("ball") or name:find("projectile")) and obj.Velocity.Magnitude > 5 then
                table.insert(candidates, obj)
            end
        end
    end

    local closest, closestDist = nil, math.huge
    for _, ball in ipairs(candidates) do
        local dist = (ball.Position - hrp.Position).Magnitude
        if dist < closestDist then
            closest = ball
            closestDist = dist
        end
    end
    return closest
end

-- Parry loop
local function startParry(char)
    RunService:UnbindFromRenderStep("LinuxParryLoop")

    RunService:BindToRenderStep("LinuxParryLoop", 1, function()
        local sword = getSword(char)
        local ball = findBall()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not sword or not ball or not hrp then return end

        local swordPos = sword:FindFirstChild("Handle") and sword.Handle.Position or hrp.Position
        local distance = (ball.Position - swordPos).Magnitude

        if distance < 13 then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            statusLabel.Text = "Status: Parry feito!"
            wait(0.3)
            statusLabel.Text = "Status: Aguardando..."
        end
    end)
end

startParry(character)

-- Reiniciar após morte
player.CharacterAdded:Connect(function(char)
    character = char
    char:WaitForChild("HumanoidRootPart", 5)
    wait(1)
    startParry(char)
end)
