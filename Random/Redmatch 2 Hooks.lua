local Config = {
	RopeColor = BrickColor.Red();
	WinchSpeed = 500;
	WinchForce = 10000;
	MaxDistance = 1000;
	MinDistance = 10;
	RopeThickness = 0.5;
	RopeMultiplier = 10;
	Power = 100;
	RightKey = Enum.KeyCode.E;
	LeftKey = Enum.KeyCode.Q;
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

function CreateAttachment(Parent: Instance, Position: Vector3): Attachment
	local NewAttachment = Instance.new("Attachment")
	NewAttachment.Position = Position
	NewAttachment.Parent = Parent
	return NewAttachment
end

local RopeSystems = {
	Left = {
		Rope = nil,
		Attachment = CreateAttachment(HumanoidRootPart, Vector3.new(-1.5, 0, 0))
	},
	Right = {
		Rope = nil,
		Attachment = CreateAttachment(HumanoidRootPart, Vector3.new(1.5, 0, 0))
	}
}

function UpdateRope(Side: string, Toggle: boolean)
	if RopeSystems[Side].Rope then
		RopeSystems[Side].Rope:Destroy()
		RopeSystems[Side].Rope = nil
	end

	if Toggle then
		local HitPart = Mouse.Target
		local HitCF = Mouse.Hit
		local HitPos = HitCF.Position + (Side == "Right" and HitCF.RightVector or -HitCF.RightVector) * Config.RopeMultiplier
		local Distance = (HitPos - HumanoidRootPart.CFrame.Position).Magnitude

		if not HitPart or Distance > Config.MaxDistance then return end

		local WorldAttachment = CreateAttachment(HitPart, HitPart.CFrame:PointToObjectSpace(HitPos))
		local NewRope = Instance.new("RopeConstraint")
		NewRope.Length = Distance * 1.25
		NewRope.Attachment0 = RopeSystems[Side].Attachment
		NewRope.Attachment1 = WorldAttachment
		NewRope.Color = Config.RopeColor
		NewRope.Thickness = Config.RopeThickness
		NewRope.Visible = true
		NewRope.WinchEnabled = true
		NewRope.WinchForce = Config.WinchForce
		NewRope.WinchSpeed = Config.WinchSpeed
		NewRope.WinchTarget = Config.MinDistance
		NewRope.WinchResponsiveness = Config.Power
		NewRope.Parent = workspace

		RopeSystems[Side].Rope = NewRope

		NewRope.Destroying:Connect(function()
			WorldAttachment:Destroy()
			RopeSystems[Side].Rope = nil
		end)
	end
end

UserInputService.InputBegan:Connect(function(Input: InputObject, GameProcessed: boolean)
	if GameProcessed then return end

	if Input.KeyCode == Config.LeftKey then
		UpdateRope("Left", true)
	elseif Input.KeyCode == Config.RightKey then
		UpdateRope("Right", true)
	end
end)
UserInputService.InputEnded:Connect(function(Input: InputObject, GameProcessed: boolean)
	if GameProcessed then return end

	if Input.KeyCode == Config.LeftKey then
		UpdateRope("Left", false)
	elseif Input.KeyCode == Config.RightKey then
		UpdateRope("Right", false)
	end
end)
