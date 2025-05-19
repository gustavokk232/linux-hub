-- DEAD RILLS MOBILE GUI (Completo)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local runService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DeadRillsGUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 200, 0, 230)
main.Position = UDim2.new(0, 10, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.BorderSizePixel = 0
main.Visible = true

local minimize = Instance.new("TextButton", gui)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(0, 10, 0.35, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BorderSizePixel = 0
minimize.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

local yOffset = 10
local function addButton(name, callback)
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(0, 180, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yOffset)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = name .. ": OFF"
	btn.BorderSizePixel = 0
	local enabled = false
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
		callback(enabled)
	end)
	yOffset = yOffset + 40
end

-- Speed Hack
addButton("Speed", function(on)
	humanoid.WalkSpeed = on and 30 or 16
end)

-- Auto Heal
addButton("Auto Heal", function(on)
	_G.AutoHeal = on
	while _G.AutoHeal and wait(1) do
		if humanoid.Health < humanoid.MaxHealth then
			humanoid.Health += 5
		end
	end
end)

-- Auto Farm
addButton("Auto Farm", function(on)
	_G.AutoFarm = on
	while _G.AutoFarm and wait(0.5) do
		for _, enemy in pairs(workspace:GetDescendants()) do
			if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
				if (enemy.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 30 then
					enemy.Humanoid:TakeDamage(10)
				end
			end
		end
	end
end)

-- Teleport (zona segura exemplo)
addButton("Teleport SafeZone", function(on)
	if on then
		local target = workspace:FindFirstChild("SafeZone") or workspace:FindFirstChild("Spawn") or nil
		if target then
			character:MoveTo(target.Position)
		end
	end
end)

-- Hitbox Expander
addButton("Expand Hitbox", function(on)
	for _, mob in pairs(workspace:GetDescendants()) do
		if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
			local name = mob.Name:lower()
			if name:find("zumbi") or name:find("wolf") or name:find("vamp") or name:find("bandit") or name:find("lobo") then
				local part = mob.HumanoidRootPart
				if on then
					part.Size = Vector3.new(10,10,10)
					part.Transparency = 0.7
					part.Material = Enum.Material.Neon
				else
					part.Size = Vector3.new(2,2,1)
					part.Transparency = 1
					part.Material = Enum.Material.Plastic
				end
			end
		end
	end
end)
