local TorsoXRotation = 10
local TorsoZRotation = 15
local LegRotation = 10

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")

local HumanoidRootPart = Character.HumanoidRootPart
local Torso = Character.Torso
local RootJoint = HumanoidRootPart.RootJoint
local LeftHipJoint = Torso["Left Hip"]
local RightHipJoint = Torso["Right Hip"]

local Force = nil
local Direction = nil
local Value1 = 0
local Value2 = 0

local RootJointC0 = RootJoint.C0
local LeftHipJointC0 = LeftHipJoint.C0
local RightHipJointC0 = RightHipJoint.C0

RunService.RenderStepped:Connect(function()
	Force = HumanoidRootPart.Velocity * Vector3.new(1, 0, 1)
	if Force.Magnitude > 0.001 then
		Direction = Force.Unit
		Value1 = HumanoidRootPart.CFrame.RightVector:Dot(Direction)
		Value2 = HumanoidRootPart.CFrame.LookVector:Dot(Direction)
	else
		Value1 = 0
		Value2 = 0
	end
	
	TweenService:Create(RootJoint, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {C0 = RootJoint.C0:Lerp(RootJointC0 * CFrame.Angles(math.rad(Value2 * TorsoZRotation), math.rad(-Value1 * TorsoXRotation), 0), 0.5)}):Play()
	TweenService:Create(LeftHipJoint, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {C0 = LeftHipJoint.C0:Lerp(LeftHipJointC0 * CFrame.Angles(math.rad(Value1 * LegRotation), 0, 0), 0.5)}):Play()
	TweenService:Create(RightHipJoint, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {C0 = RightHipJoint.C0:Lerp(RightHipJointC0 * CFrame.Angles(math.rad(-Value1 * LegRotation), 0, 0), 0.5)}):Play()
end)
