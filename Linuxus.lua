--[[
Script para Roblox - Jogo de Cassino (Minas)
Função: Detectar automaticamente onde estão as bombas escondidas no minigame de minas
Interface: Otimizada para mobile, com design amigável
IMPORTANTE: Esse script é apenas para fins educacionais em um ambiente de simulação!
--]]

-- Aguarda o carregamento do jogo
repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = player:WaitForChild("PlayerGui")

-- Cria interface principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinasDetectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Criar fundo visual decorativo (nuvem com raios)
local background = Instance.new("ImageLabel")
background.Name = "CloudBackground"
background.Size = UDim2.new(0, 300, 0, 300)
background.Position = UDim2.new(0.5, -150, 0.5, -150)
background.BackgroundTransparency = 1
background.Image = "rbxassetid://15260201599" -- imagem de nuvem com raio (substituir se desejar)
background.ZIndex = 0
background.Parent = screenGui

-- Interface quadrada principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 240, 0, 240)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.ZIndex = 1
mainFrame.Parent = screenGui

-- Botão de minimizar/restaurar
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -35, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
toggleButton.Text = "-"
toggleButton.TextScaled = true
toggleButton.ZIndex = 2
toggleButton.Parent = mainFrame

-- Label do script
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Detector de Minas 💣"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.ZIndex = 2
titleLabel.Parent = mainFrame

-- Função para esconder/mostrar interface
local minimized = false
toggleButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, obj in pairs(mainFrame:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= toggleButton and obj ~= titleLabel then
            obj.Visible = not minimized
        end
    end
    toggleButton.Text = minimized and "+" or "-"
end)

-- Detectar bombas
local function getMineTiles()
    local tilesFolder = workspace:FindFirstChild("Tiles") or workspace:FindFirstChildWhichIsA("Folder")
    if not tilesFolder then return {} end
    local tiles = {}
    for _, tile in pairs(tilesFolder:GetChildren()) do
        if tile:IsA("Part") and tile:FindFirstChild("Bomb") then
            table.insert(tiles, tile)
        end
    end
    return tiles
end

local function highlightBombs()
    local tiles = getMineTiles()
    for _, tile in pairs(tiles) do
        if not tile:FindFirstChild("Highlight") then
            local highlight = Instance.new("SelectionBox")
            highlight.Name = "Highlight"
            highlight.Adornee = tile
            highlight.Color3 = Color3.fromRGB(255, 0, 0)
            highlight.LineThickness = 0.1
            highlight.Parent = tile
        end
    end
end

-- Atualiza a cada segundo
while true do
    pcall(highlightBombs)
    wait(1)
end
