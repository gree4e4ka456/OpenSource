local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local DragRequest = ReplicatedStorage.DragRequest

workspace.ChildAdded:Connect(function(Hider)
	if Hider.Name == "Hider" then
		local RootPart = Hider:WaitForChild("HumanoidRootPart", 1.488)
		local Torso = Hider:WaitForChild("Torso")

		if RootPart then
			RootPart.AncestryChanged:Wait()
		else
			task.wait()
		end

		local Active = true
		while Active do
			local Draggeby
			repeat
				pcall(function() DragRequest:InvokeServer(Hider, true) end)
				task.wait(0.1)
				Draggeby = Torso:FindFirstChild("Draggeby")
			until
				Draggeby and Draggeby.Value == Player.UserId

			for _, Part in Hider:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanCollide = false
					Part.CanTouch = false
				end
			end
		
			local BV = Instance.new("BodyVelocity")
			BV.MaxForce = Vector3.new(0, "inf", 0)
			BV.Velocity = Vector3.new(0, -5000, 0)
			BV.Parent = Torso
			task.wait(0.25)
			if not Torso:IsDescendantOf(workspace) then
				Active = false
			end
		end
	end
end)
