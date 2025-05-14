local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "DetectorUI"

local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(1, 0, 0, 50)
label.Position = UDim2.new(0, 0, 0, 0)
label.Text = "Procurando bola..."
label.TextScaled = true
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.BorderSizePixel = 0

game:GetService("RunService").RenderStepped:Connect(function()
    local closest, dist = nil, math.huge
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Velocity.Magnitude > 15 then
            local d = (obj.Position - hrp.Position).Magnitude
            if d < dist then
                closest = obj
                dist = d
            end
        end
    end

    if closest then
        label.Text = "Detectado: " .. closest.Name .. " (" .. math.floor(dist) .. " studs)"
    else
        label.Text = "Nenhuma bola detectada"
    end
end)
