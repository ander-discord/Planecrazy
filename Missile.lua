local missileSpeed = 5000  -- Constant speed for the missile (no distance-based adjustment)

local parts = {}
local player = game.Players.LocalPlayer

-- Find the player's aircraft and missile parts
local aircraft = workspace:FindFirstChild(player.Name .. " Aircraft")

if aircraft then
    print("Aircraft found!")
    for _, part in pairs(aircraft:GetChildren()) do
        if part:IsA("Model") and part.Name == "BlockStd" and part.PrimaryPart and part.PrimaryPart.Color == Color3.fromRGB(255, 0, 0) then
            print("Found part: " .. part.Name)
            table.insert(parts, part.PrimaryPart)
        else
            print("Ignored part: " .. part.Name)
        end
    end
else
    warn("Aircraft not found for player: " .. player.Name)
end

-- Manually specify the target player
local targetPlayerName = "anderasvi123_1"  -- Replace this with the desired target player's name
local targetPlayer = game.Players:FindFirstChild(targetPlayerName)

-- Function to highlight the target player
function highlightTargetPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Create a Highlight object (a glowing outline)
            local highlight = Instance.new("Highlight")
            highlight.Parent = humanoidRootPart
            highlight.Adornee = humanoidRootPart
            highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Red color for highlight
            highlight.FillTransparency = 0.5  -- Set transparency (0 is opaque, 1 is fully transparent)
            highlight.OutlineTransparency = 0  -- No transparency on the outline
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)  -- Red outline color
        end
    end
end

-- Function to track missile towards the target player
function trackMissile(missileBlock)
    if targetPlayer and targetPlayer.Character then
        local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetHumanoidRootPart then
            -- Get the target's current position and velocity
            local targetPos = targetHumanoidRootPart.Position
            local targetVelocity = targetPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity
            
            -- Predict the future position of the target
            local futureTargetPos = targetPos + targetVelocity * 1.25  -- Predict the future position (constant time to impact)

            -- Calculate the direction to the future position
            local direction = (futureTargetPos - missileBlock.Position).unit

            -- Apply velocity to the missile block (constant missile speed)
            missileBlock.Velocity = direction * missileSpeed

            -- Apply body gyro for rotation to face the future position
            local bodyGyro = missileBlock:FindFirstChild("BodyGyro")
            if not bodyGyro then
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bodyGyro.P = 300
                bodyGyro.D = 100
                bodyGyro.Parent = missileBlock
            end

            -- Keep the missile locked on the predicted future position
            bodyGyro.CFrame = CFrame.lookAt(missileBlock.Position, futureTargetPos)
        end
    end
end

-- Use RunService for periodic updates
local RunService = game:GetService("RunService")

-- Highlight the target player as soon as possible
highlightTargetPlayer(targetPlayer)

RunService.Heartbeat:Connect(function()
    -- If the aircraft doesn't exist, stop tracking
    if not workspace:FindFirstChild(player.Name .. " Aircraft") then
        return
    end

    -- Track each missile part
    for _, part in pairs(parts) do
        trackMissile(part)
    end
end)

