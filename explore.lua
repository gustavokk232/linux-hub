for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Velocity.Magnitude > 10 then
        print("Possível bola:", obj:GetFullName())
    end
end
