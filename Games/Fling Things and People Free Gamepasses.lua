local CONFIGURATION = {
    RANGE = 40;
    ESCAPE = 4;
}

local UserInputService = game:GetService("UserInputService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

ReplicatedStorage.DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0));
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 195));
}))
Player.CharacterAdded:Connect(function(Character)
    for i = 1, 10 do
        pcall(function() 
            for _, connection in getconnections(ReplicatedStorage.GamepassEvents.FurtherReachBoughtNotifier.OnClientEvent) do
                for i in debug.getupvalues(connection.Function) do
                    debug.setupvalue(connection.Function, i, CONFIGURATION.RANGE)
                end
            end
        end)
        task.wait()
    end
end)

UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE then return end
    
    if Input.KeyCode == Enum.KeyCode.Z then
        local Character = Player.Character
        local RootPart = (Character) and Character:FindFirstChild("HumanoidRootPart")
        if RootPart then
            RootPart.AssemblyLinearVelocity = Vector3.zero
            RootPart.AssemblyAngularVelocity = Vector3.zero
        end
    elseif Player.IsHeld.Value and Input.KeyCode == Enum.KeyCode.Space then -- TODO: fix this bullshit
        ReplicatedStorage.CharacterEvents.Struggle:FireServer()
    end
end)

local GrabParts = ReplicatedFirst.GrabParts
GrabParts.BeamPart.GrabBeam.Texture = "rbxassetid://8933355899"
