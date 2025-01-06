local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()
local mode = 1
local camera = workspace.CurrentCamera

local parts = {}

local aircraft = workspace:FindFirstChild(player.Name .. " Aircraft")
if aircraft then
    print("Aircraft found!")
    for _, part in pairs(aircraft:GetChildren()) do
        if part:IsA("Model") and part.Name == "BlockStd" and part.PrimaryPart and part.PrimaryPart.Color == Color3.fromRGB(0, 255, 0) then
            print("Found part: " .. part.Name)
            table.insert(parts, part.PrimaryPart)
        else
            print("Ignored part: " .. part.Name)
        end
    end
else
    warn("Aircraft not found for player: " .. player.Name)
end

local speed = 3
local RunService = game:GetService("RunService")

local connection
connection = RunService.Heartbeat:Connect(function()
    if not workspace:FindFirstChild(player.Name .. " Aircraft") then
        warn("Aircraft model no longer exists.")
        connection:Disconnect()
        return
    end

    local targetPosition = hrp.Position
    local targetRotation = hrp.CFrame

    if mode == 1 then
        targetPosition = hrp.Position + Vector3.new(0, 10, 0) + Vector3.new(
            math.random(-0.3, 0.3),
            math.random(-0.3, 0.6),
            math.random(-0.3, 0.3)
        )
        targetRotation = hrp.CFrame
    elseif mode == 2 then
        targetPosition = mouse.Hit.Position + Vector3.new(0, 15, 0)
        targetRotation = CFrame.lookAt(hrp.Position, targetPosition)
    end

    for _, part in pairs(parts) do
        if part and part.Parent then
            local direction = (targetPosition - part.Position).Unit
            local distance = (targetPosition - part.Position).Magnitude

            local force = part:FindFirstChild("BodyVelocity")
            if not force then
                force = Instance.new("BodyVelocity")
                force.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                force.Parent = part
            end
            force.Velocity = direction * speed * math.clamp(distance, 0, 50)

            local bodyGyro = part:FindFirstChild("BodyGyro")
            if not bodyGyro then
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyGyro.P = 300
                bodyGyro.D = 100
                bodyGyro.Parent = part
            end
            bodyGyro.CFrame = targetRotation
        end
    end
end)

mouse.KeyDown:Connect(function(key)
    if key:lower() == "m" then
        mode = (mode == 1) and 2 or 1
        print("Mode switched to: " .. mode)
    end
end)
