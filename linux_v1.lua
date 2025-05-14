local a=game.Players.LocalPlayer
local b=a:WaitForChild("PlayerGui")
local c=Instance.new("Frame",b)
c.Size=UDim2.new(0,300,0,150)
c.Position=UDim2.new(0,10,0,10)
c.BackgroundColor3=Color3.new()
c.BackgroundTransparency=0.5
c.BorderSizePixel=0
local d=Instance.new("TextLabel",c)
d.Size=UDim2.new(1,-40,0,30)
d.Text="Linux"
d.TextColor3=Color3.fromRGB(138,43,226)
d.TextSize=18
d.TextAlign=Enum.TextAlign.Center
d.BackgroundTransparency=1
local e=Instance.new("TextLabel",c)
e.Size=UDim2.new(1,0,0,30)
e.Position=UDim2.new(0,0,0,40)
e.Text="Parry: Waiting"
e.TextColor3=Color3.new(1,1,1)
e.TextSize=14
e.TextAlign=Enum.TextAlign.Center
local f=Instance.new("TextButton",c)
f.Size=UDim2.new(0,30,0,30)
f.Position=UDim2.new(1,-40,0,0)
f.Text="_"
f.TextColor3=Color3.new(1,1,1)
f.TextSize=20
f.BackgroundColor3=Color3.fromRGB(255,0,0)
f.BorderSizePixel=0
f.TextButtonMode=Enum.TextButtonMode.Scriptable
local g=false
f.MouseButton1Click:Connect(function()
    if g then
        c.Size=UDim2.new(0,300,0,150)
        e.Visible=true
        f.Text="_"
    else
        c.Size=UDim2.new(0,300,0,40)
        e.Visible=false
        f.Text="+"
    end
    g=not g
end)
local h=game.Workspace:WaitForChild("BladeBall")
local i=game.Workspace:WaitForChild("Sword")
local j,k,l=5,0,2
while true do
    local m=(h.Position-i.Position).Magnitude
    if m<=j then
        local n=tick()
        if n-k>=l then
            k=n
            e.Text="Parry: Success!"
            local o=Instance.new("Part")
            o.Size=Vector3.new(1,1,1)
            o.Position=h.Position
            o.Color=Color3.fromRGB(255,0,0)
            o.Anchored=true
            o.CanCollide=false
            o.Parent=game.Workspace
            game.Debris:AddItem(o,1)
            h.Velocity=-h.Velocity
        end
    else
        e.Text="Parry: Waiting"
    end
    wait(0.1)
end
