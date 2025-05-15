
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local function getCharacter()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function getHumanoidRootPart()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

local function isTargeted(ball, character)
    local red = Color3.fromRGB(255, 0, 0)
    if (ball:IsA("BasePart") and ball.Color == red) then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Color == red then
                return true
            end
        end
    end
    return false
end

local function tapBlockButton()
    for _, gui in ipairs(lp.PlayerGui:GetDescendants()) do
        if gui:IsA("ImageButton") and gui.Name == "block" then
            pcall(function()
                gui:Activate()
            end)
        end
    end
end

local autoParry = true
local distanceThreshold = 55

RunService.Heartbeat:Connect(function()
    if not autoParry then return end
    local char = getCharacter()
    local hrp = getHumanoidRootPart()
    for _, ball in pairs(workspace.Balls:GetChildren()) do
        if ball:IsA("BasePart") then
            local distance = (ball.Position - hrp.Position).Magnitude
            if distance <= distanceThreshold and isTargeted(ball, char) then
                tapBlockButton()
            end
        end
    end
end)
