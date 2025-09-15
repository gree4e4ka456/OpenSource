local FlyConfiguration = {
	Key = Enum.KeyCode.Q;
	Speed = 100;
	FOV = 110;
}

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:FindFirstChildWhichIsA("Humanoid") or Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.one * 10000
BodyVelocity.Velocity = Vector3.zero
BodyVelocity.P = 20000
BodyVelocity.Parent = Character
local BodyGyro = Instance.new("BodyGyro")
BodyGyro.MaxTorque = Vector3.one * 400000
BodyGyro.P = 3000
BodyGyro.D = 500
BodyGyro.Parent = Character

local WindSound = Instance.new("Sound")
WindSound.SoundId = "rbxassetid://3308152153"
WindSound.Name = "WindSound"
WindSound.Parent = HumanoidRootPart
WindSound.Volume = 0.5

local FlyMoving = Instance.new("BoolValue")
local IsFlying = false
local LastLookVector = Vector3.new()
local LastMoveVector = Vector3.new()
local CurrentSwayAngle = 0
local MovementSwayAngle = 0

local function GetMovementDirection(): Vector3
	if Humanoid.MoveDirection == Vector3.zero then
		return Vector3.zero
	end

	local cameraLook = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
	local relativeDirection = CFrame.new(Vector3.zero, cameraLook):VectorToObjectSpace(Humanoid.MoveDirection)
	local worldDirection = (Camera.CFrame * CFrame.new(relativeDirection)).Position - Camera.CFrame.Position

	return worldDirection == Vector3.zero and worldDirection or worldDirection.Unit
end

local function SetFlyingState(Toggle: boolean)
	IsFlying = Toggle

	if IsFlying then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		BodyVelocity.Parent = HumanoidRootPart
		BodyGyro.Parent = HumanoidRootPart
	else
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		BodyVelocity.Parent = Character
		BodyGyro.Parent = Character
	end
end

UserInputService.InputBegan:Connect(function(Input: InputObject, GPE: boolean)
	if GPE or Input.KeyCode ~= FlyConfiguration.Key then return end

	SetFlyingState(not IsFlying)
end)

FlyMoving:GetPropertyChangedSignal("Value"):Connect(function()
	if FlyMoving.Value then
		TweenService:Create(Camera, TweenInfo.new(0.5), {FieldOfView = FlyConfiguration.FOV}):Play()
		WindSound:Play()
	else
		TweenService:Create(Camera, TweenInfo.new(0.5), {FieldOfView = 70}):Play()
		WindSound:Stop()
	end
end)

RunService.RenderStepped:Connect(function(deltaTime: number)
	if IsFlying then
		Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		BodyGyro.CFrame = Camera.CFrame

		local MoveDirection = GetMovementDirection()
		FlyMoving.Value = MoveDirection ~= Vector3.zero

		TweenService:Create(BodyVelocity, TweenInfo.new(0.3), {Velocity = MoveDirection * FlyConfiguration.Speed}):Play()
	else
		FlyMoving.Value = false
	end
end)
