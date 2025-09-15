-- E to fake dash for M1 cancel combo

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Animations = {}
local ActiveConnections = {}
local Disconnect = function(i)
	if ActiveConnections[i] then
		ActiveConnections[i]:Disconnect()
		ActiveConnections[i] = nil
	end
end

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera, Character, Humanoid, RootPart, Animator, AnimationTracks

local Configuration = {
	Dash = {Toggle = true, Multiplier = 1.075, FreeForward = false};
	FakeDash = {Multiplier = 1.5, Time = 0.15, Debounce = false};
	FreeJump = true;
}

do
	local RightDash = Instance.new("Animation")
	RightDash.Parent = ReplicatedFirst
	RightDash.AnimationId = "rbxassetid://10480793962"
	RightDash.Name = "RightDash"

	local LeftDash = Instance.new("Animation")
	LeftDash.Parent = ReplicatedFirst
	LeftDash.AnimationId = "rbxassetid://10480796021"
	LeftDash.Name = "LeftDash"

	local FrontDash = Instance.new("Animation")
	FrontDash.Parent = ReplicatedFirst
	FrontDash.AnimationId = "rbxassetid://10479335397"
	FrontDash.Name = "FrontDash"

	table.insert(Animations, RightDash)
	table.insert(Animations, LeftDash)
	table.insert(Animations, FrontDash)
end


local SetupCharacter = function(NewCharacter)
	if not NewCharacter then return end

    Camera = workspace.CurrentCamera
	Character = NewCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
	Animator = Humanoid:WaitForChild("Animator")
    AnimationTracks = {}

	Disconnect("DescendantAdded")
	ActiveConnections["DescendantAdded"] = Character.DescendantAdded:Connect(function(Descendant)
        if Configuration.Dash.Toggle then
            if Descendant.Name == "dodgevelocity" then
                while Descendant:IsDescendantOf(workspace) do
                    Descendant.Velocity *= Configuration.Dash.Multiplier
                    RunService.RenderStepped:Wait()
                end
            end
        end
        if Descendant:IsA("Accessory") then
            if (Configuration.Dash.FreeForward and Descendant.Name == "Freeze") or (Configuration.FreeJump and Descendant.Name == "NoJump") then
                wait()
                Descendant:Destroy()
            end
        end
	end)

    for _, Animation in Animations do
        local Loaded = Animator:LoadAnimation(Animation)
        if Loaded then
            Loaded.Priority = Enum.AnimationPriority.Action
            AnimationTracks[Animation.Name] = Loaded
        end
    end
end
LocalPlayer.CharacterAdded:Connect(SetupCharacter)
SetupCharacter(LocalPlayer.Character)

UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE or not (Humanoid and RootPart) then return end

    if Input.KeyCode == Enum.KeyCode.E then
        local Direction = (UserInputService:IsKeyDown(Enum.KeyCode.A)) and -1 or 1
        local Animation = (Direction == 1) and AnimationTracks["RightDash"] or AnimationTracks["LeftDash"]

        local dodgevelocity = Instance.new("BodyVelocity")
        dodgevelocity.Name = "fakedodge"
        dodgevelocity.MaxForce = Vector3.new(1, 0, 1) * 50000
        dodgevelocity.Velocity = Vector3.zero
        if Animation then
            Animation:Play()
        end
        
        local Active = true
        task.delay(Configuration.FakeDash.Time, function() Active = false end)

        dodgevelocity.Parent = RootPart
        while Active do
            dodgevelocity.Velocity =  Camera.CFrame.RightVector * Direction * 100 * Configuration.FakeDash.Multiplier
            RunService.RenderStepped:Wait()
        end

        RootPart.AssemblyLinearVelocity *= 0.5

        dodgevelocity:Destroy()
    end
end)
