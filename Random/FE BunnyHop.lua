local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local HRP = Humanoid.RootPart
local Animator: Animator = Humanoid:WaitForChild("Animator")

local Configuration = {
	AutoBHop = true;
	JumpPower = 40;
	ForceReset = 0.275;
	ForceMultiplier = 1.5;
	ForceLimit = 250;
	JumpCooldown = 0.125;
	AirAcceleration = 70
}

local LastLook = HRP.CFrame.LookVector
local AirMultiplier = 0
local JumpCount = 0
local JumpDebounce = false
local IsOnGround = false
local ResetTask: thread = nil

local BHopVelocity = Instance.new("BodyVelocity")
BHopVelocity.P = 10000
BHopVelocity.MaxForce = Vector3.new(1, 0, 1) * 1e35
BHopVelocity.Velocity = Vector3.zero
BHopVelocity.Name = "BHopVelocity"

local HopAnimation = Instance.new("Animation")
HopAnimation.AnimationId = "rbxassetid://182724289"
local HopTrack = Animator:LoadAnimation(HopAnimation)
HopTrack.Priority = Enum.AnimationPriority.Action

workspace.Gravity = 196.2
Humanoid.UseJumpPower = true
Humanoid.JumpPower = Configuration.JumpPower

UserInputService.JumpRequest:Connect(function()
	if not Configuration.AutoBHop and JumpDebounce then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		return 
	else
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end

	JumpDebounce = true
	task.delay(Configuration.JumpCooldown, function()
		JumpDebounce = false
	end)
end)

local ResetForce = function(Active: boolean)
	if Active then
		ResetTask = task.delay(Configuration.ForceReset, function()
			JumpCount = 0
			AirMultiplier = 0
		end)
	else
		if ResetTask then
			task.cancel(ResetTask)
			ResetTask = nil
		end
	end
end

Humanoid.StateChanged:Connect(function(Old, New)
	if New == Enum.HumanoidStateType.Jumping then
		Humanoid.HipHeight = 1
		JumpCount += 1

		HopTrack:Play(5, 5, 10)
		IsOnGround = false
		ResetForce(false)
		BHopVelocity.Parent = HRP
	elseif New == Enum.HumanoidStateType.Landed then
		Humanoid.HipHeight = 0
		
		HopTrack:Stop()
		IsOnGround = true
		ResetForce(true)
		BHopVelocity.Parent = nil
	elseif New == Enum.HumanoidStateType.Freefall then
		AirMultiplier += (LastLook - HRP.CFrame.LookVector).Magnitude * Configuration.AirAcceleration
	end
end)

RunService.RenderStepped:Connect(function()	
	if BHopVelocity.Parent then
		local Multiplier = math.clamp(Configuration.ForceMultiplier + AirMultiplier + JumpCount, 1, Configuration.ForceLimit)
		BHopVelocity.Velocity = HRP.CFrame.LookVector * Multiplier
	end
	
	LastLook = HRP.CFrame.LookVector
end)
