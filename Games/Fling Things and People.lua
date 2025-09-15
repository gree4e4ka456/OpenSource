-- free further extend. made on swift executor

local CONFIGURATION = {
    RANGE = 40;
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

local GrabParts = ReplicatedFirst.GrabParts
GrabParts.BeamPart.GrabBeam.Texture = "rbxassetid://8933355899"
