-- tryhard r6 korblox and headless skin changer script

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Load = function(Character: Model)
	if not (Character and Character:IsDescendantOf(workspace)) then return end
	
	for _, Accessory in Character:GetDescendants() do
		if Accessory:IsA("Accessory") or Accessory:IsA("Shirt") or Accessory:IsA("Pants") or Accessory:IsA("ShirtGraphic") or Accessory:IsA("CharacterMesh") then
			Accessory:Destroy()
		end
	end
	
	local BodyColors: BodyColors = Character:WaitForChild("Body Colors")
	for _, Color in {"Head"; "Torso"; "RightArm"; "LeftArm"; "RightLeg"; "LeftLeg"} do
		BodyColors[Color .. "Color3"] = Color3.fromRGB(255, 255, 255)
	end	
	
	local Shirt = Instance.new("Shirt")
	Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=14758728557"
	Shirt.Parent = Character

	local Pants = Instance.new("Pants")
	Pants.PantsTemplate = "http://www.roblox.com/asset/?id=18128691253"
	Pants.Parent = Character
	
	local Head, Torso = Character:WaitForChild("Head"), Character:WaitForChild("Torso")
	
	local Mesh = Head:WaitForChild("Mesh")
	Mesh.MeshId = 15093053680
	
	local Korblox = Instance.new("CharacterMesh")
	Korblox.BodyPart = Enum.BodyPart.RightLeg
	Korblox.MeshId = 101851696
	Korblox.OverlayTextureId = 101851254
	Korblox.Parent = Character
	
	local Blackfur
	do
		Blackfur = Instance.new("Accessory")
		Blackfur.Name = "3.0 Black Forsaken Neck Fur"
		Blackfur.Parent = Character
		
		local Handle = Instance.new("Part")
		Handle.Size = Vector3.new(2.297, 1.058, 1.507)
		Handle.CanCollide = false
		Handle.CanQuery = false
		Handle.CanTouch = false
		Handle.Parent = Blackfur
		
		local SpecialMesh = Instance.new("SpecialMesh")
		SpecialMesh.MeshId = "rbxassetid://129098541998284"
		SpecialMesh.TextureId = "rbxassetid://110163591733532"
		SpecialMesh.Parent = Handle
		
		local AccessoryWeld = Instance.new("Weld")
		AccessoryWeld.C0 = CFrame.new(Vector3.new(-0.003, 0.307, 0.146)) * CFrame.fromOrientation(0, math.rad(180), 0)
		AccessoryWeld.C1 = CFrame.new(Vector3.new(0, 1.2, 0))
		AccessoryWeld.Part0 = Handle
		AccessoryWeld.Part1 = Torso
		AccessoryWeld.Parent = Blackfur
	end
end; task.spawn(Load, LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(Load)
