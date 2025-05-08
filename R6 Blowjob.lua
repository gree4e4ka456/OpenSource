local Target = "Name"

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")	
local HRP = Character:WaitForChild("HumanoidRootPart")

local TargetPlayer = Players:FindFirstChild(Target)
local TargetCharacter = TargetPlayer.Character or TargetPlayer.CharacterAdded:Wait()
local TargetHRP = TargetCharacter:WaitForChild("HumanoidRootPart")

local FrameOffsets = {
	[1] = {P = Vector3.new(0, -2.25, -1.235), O = Vector3.new(-5, -180, 0)},
	[2] = {P = Vector3.new(0, -2.285, -0.975), O = Vector3.new(5, 180, 0)}
}

local Duration = 0.5
local Frames = 30

local OrientationToAngles = function(Orientation: Vector3) 
	return CFrame.Angles(math.rad(Orientation.X), math.rad(Orientation.Y), math.rad(Orientation.Z)) 
end

local LerpCFrame = function(Start: CFrame, Finish: CFrame, Alpha: number): CFrame
	return Start:Lerp(Finish, Alpha)
end

local Freeze = Instance.new("BodyVelocity")
Freeze.MaxForce = Vector3.one * 1e10
Freeze.Velocity = Vector3.zero
Freeze.Parent = HRP
while Character.Parent and TargetCharacter.Parent do
	if TargetHRP then
		for i, FrameData in ipairs(FrameOffsets) do
			Humanoid.Sit = true

			local TargetPosition = TargetHRP.CFrame.Position + FrameData.P
			local TargetOrientation = OrientationToAngles(FrameData.O)
			local TargetCFrame = CFrame.new(TargetPosition) * TargetOrientation

			local StartCFrame = HRP.CFrame

			for Step = 1, Frames do
				local Alpha = Step / Frames
				HRP.CFrame = LerpCFrame(StartCFrame, TargetCFrame, Alpha)
				task.wait(Duration / Frames)
			end

			HRP.CFrame = TargetCFrame
		end
	end

	task.wait()
end
Freeze:Destroy()
