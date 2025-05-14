
-- Linux v1.5 Final Mobile - Auto Parry com UI acessível para celular

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Melhor interface para celular
local function createMobileUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "LinuxMobileUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, -20, 0, 20)
    frame.Size = UDim2.new(0, 180, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = "Linux v1.5"
    title.TextColor3 = Color3.fromRGB(0, 255, 127)
    title.Font = Enum.Font.SourceSansBold
    title.TextScaled = true

    local status = Instance.new("TextLabel", frame)
    status.Position = UDim2.new(0, 0, 0, 28)
    status.Size = UDim2.new(1, 0, 0, 45)
    status.BackgroundTransparency = 1
    status.Text = "Status: Aguardando..."
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.Font = Enum.Font.SourceSans
    status.TextScaled = true

    return status
end

local statusLabel = createMobileUI()

-- Detecta espada
local function getSword(char)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            return tool
        end
    end
end

-- Detecta bola com base em nome + velocidade
local function findBall()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local candidates = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Velocity.Magnitude > 5 then
            local name = obj.Name:lower()
            if name:find("ball") or name:find("projectile") or name:find("orb") then
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

-- Envia toque de parry
local function doParry()
    if UIS.TouchEnabled then
        -- Mobile parry: simula toque na tecla F (melhor se mapeado por executor)
        local button = Instance.new("BindableEvent")
        button.Event:Connect(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) end)
        button:Fire()
    else
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end
end

-- Loop de defesa
local function startParryLoop(char)
    RunService:UnbindFromRenderStep("LinuxParryLoop")

    RunService:BindToRenderStep("LinuxParryLoop", 1, function()
        local ball = findBall()
        local sword = getSword(char)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not ball or not sword or not hrp then return end

        local swordPos = sword:FindFirstChild("Handle") and sword.Handle.Position or hrp.Position
        local distance = (ball.Position - swordPos).Magnitude

        if distance < 13 then
            doParry()
            statusLabel.Text = "Status: Parry feito!"
            wait(0.4)
            statusLabel.Text = "Status: Aguardando..."
        end
    end)
end

startParryLoop(character)

-- Reinício automático
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    char:WaitForChild("HumanoidRootPart", 5)
    wait(1)
    startParryLoop(char)
end)
