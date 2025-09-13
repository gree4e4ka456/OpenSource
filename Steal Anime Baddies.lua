local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local ActiveCache = {}
ActiveCache.Connections = {}
ActiveCache.Coroutines = {}

ActiveCache.Cleanup = {
    Disconnect = function(Index)
        if ActiveCache.Connections[Index] then
            ActiveCache.Connections[Index]:Disconnect()
            ActiveCache.Connections[Index] = nil
        end
    end;
}

local Character, Humanoid, RootPart
local UpdateCharacter = function(NewCharacter)
    ActiveCache.Cleanup.Disconnect("Stun")
    ActiveCache.Cleanup.Disconnect("Walk")

    if not (NewCharacter and NewCharacter:IsDescendantOf(workspace)) then return end
    Character = NewCharacter
    Humanoid = Character:WaitForChild("Humanoid", 3)
    RootPart = Character:WaitForChild("HumanoidRootPart", 3)
    if not (Humanoid and RootPart) then return end

    local WalkMultiplier = 0.2
    ActiveCache.Connections.Walk = RunService.RenderStepped:Connect(function()
        local MoveDirection = Humanoid.MoveDirection
        if MoveDirection.Magnitude > 0 then
            RootPart.CFrame = RootPart.CFrame + MoveDirection * WalkMultiplier
        end
    end)
    local Stunned = false
    ActiveCache.Connections.Stun = Character:GetAttributeChangedSignal("KnockGrace"):Connect(function()
        Stunned = Character:GetAttribute("KnockGrace")

        while Stunned do
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            RootPart.Massless = true
            RootPart.AssemblyLinearVelocity = Vector3.zero
            RootPart.AssemblyAngularVelocity = Vector3.zero
            task.wait()
        end

        RootPart.Massless = Stunned
    end)
end; task.spawn(UpdateCharacter, LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

local MyBase, BaseMain
local Bases = {}
local Barricades = {}
for _, Base in workspace.Map.Bases:GetChildren() do
    Bases[#Bases + 1] = Base
    Barricades[#Barricades + 1] = Base.Barrier.Barricade

    if not MyBase and Base.Important.Sign.SignPart.SurfaceGui.TextLabel.Text == (LocalPlayer.Name .. "'s Slot") then
        MyBase = Base
        BaseMain = MyBase.Important.Base
    end
end

do
    local LockButton = MyBase.Important.LockButton
    LockButton.CanCollide = false
    LockButton.Transparency = 0.5
    LockButton.Size = Vector3.one * 3

    local Collects = {}
    for _, Pad in MyBase.Important.NPCPads:GetChildren() do
        Collects[#Collects + 1] = Pad.Collect
    end

    RunService.RenderStepped:Connect(function()
        if not RootPart then return end

        task.spawn(firetouchinterest, LockButton, RootPart, 0.1)

        for _, Collect in Collects do
            task.spawn(firetouchinterest, Collect, RootPart, 0.1)
            Collect.CFrame = RootPart.CFrame
        end

        LockButton.CFrame = RootPart.CFrame
    end)
end

UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE then return end
    if not RootPart then return end

    local Key = Input.KeyCode.Name:lower()
    if Key == "z" then
        RootPart.CFrame = BaseMain.CFrame
    elseif Key == "x" then
        local OldCFrame = RootPart.CFrame
        RootPart.CFrame = BaseMain.CFrame
        task.wait(0.2)
        RootPart.CFrame = OldCFrame
    end
end)

local FuckTrap = function(Trap)
    local HitBox = Trap:WaitForChild("HitBox", 3)
    if HitBox then
        HitBox.CanQuery = false
        HitBox.CanCollide = false
        HitBox.CanTouch = false
    end
end
for _, Trap in workspace:GetChildren() do
    if Trap.Name == "Trap" then
        task.spawn(FuckTrap, Trap)
    end
end
workspace.ChildAdded:Connect(function(Trap)
    if Trap.Name == "Trap" then
        task.spawn(FuckTrap, Trap)
    end
end)

local Beautify = function(Clothing)
    if Clothing:IsA("Shirt") or Clothing:IsA("Pants") or Clothing:IsA("ShirtGraphic") then
        task.defer(function()
            while Clothing:IsDescendantOf(workspace) do
                wait()
                Clothing:Destroy()
            end
        end)
    end
end

for _, Descendant in workspace:GetDescendants() do
    Beautify(Descendant)
end
workspace.DescendantAdded:Connect(function(Descendant)
    Beautify(Descendant)
end)


while wait() do
    for _, Barricade in Barricades do
        Barricade.CanCollide = false
        Barricade.CanTouch = false
        Barricade.CanQuery = false
    end
end
