-- Linux v1 ajustado para Roblox
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Linux v1 - Auto Parry"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local status = Instance.new("TextLabel")
status.Parent = frame
status.Text = "Parry: Waiting..."
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0, 40)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Font = Enum.Font.SourceSans
status.TextSize = 16

-- Função para detectar espada no personagem
local function findSword()
    if not player.Character then return nil end

    -- Procura por ferramentas no personagem
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            -- Verifica se a ferramenta tem uma parte que representa a espada
            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
            if handle then
                return handle
            end
        end
    end
    return nil
end

-- Função para detectar objetos próximos
local function autoParry()
    local sword = findSword()
    if not sword then
        status.Text = "Parry: No sword found"
        return
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
            local distance = (sword.Position - obj.Position).Magnitude
            if distance < 10 then
                -- Simula o parry (substitua por lógica específica)
                status.Text = "Parry: Activated"
                task.wait(0.5)
                status.Text = "Parry: Waiting..."
            end
        end
    end
end

-- Conecte-se ao evento de execução
game:GetService("RunService").RenderStepped:Connect(function()
    autoParry()
end)
