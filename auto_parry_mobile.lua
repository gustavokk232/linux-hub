
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

local function parry()
    local button = nil

    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent.Name == "block" then
            button = obj.Parent
            break
        end
    end

    if button then
        local humanoid = getCharacter():FindFirstChildOfClass("Humanoid")
        if humanoid then
            firetouchinterest(button, humanoid.RootPart, 0)
            task.wait(0.1)
            firetouchinterest(button, humanoid.RootPart, 1)
        end
    end
end

RunService.Heartbeat:Connect(function()
    local character = getCharacter()
    local hrp = getHumanoidRootPart()
    for _, ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do
        if isTargeted(ball, character) then
            local distance = (hrp.Position - ball.Position).Magnitude
            if distance <= 25 then -- distância máxima para parry
                local velocity = ball.Velocity.Magnitude
                local reactionTime = math.clamp(1 - (velocity / 200), 0.1, 0.9)
                task.wait(reactionTime)
                parry()
            end
        end
    end
end)
