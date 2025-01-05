local players = game.Players:GetPlayers()
local player = game.Players.players[math.random(1, #players)]
local character = player.Character or player.CharacterAdded:Wait()  -- Waits for the character if it isn't loaded yet
local hrp = character:WaitForChild("HumanoidRootPart")  -- Wait for the HumanoidRootPart to exist

-- To store parts to move
local parts = {}

-- Function to generate a random string for DoCheck (unchanged)
function RandomVariable(length)
    local res = ""
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

local DoCheck = RandomVariable(20)
_G.DoCheck = DoCheck

-- Collecting the parts (BlockStd and Ball) from the "Aircraft" model
for i, part in pairs(game.Workspace[game.Players.LocalPlayer.Name .. ' Aircraft']:GetChildren()) do
    if part.ClassName == "Model" and (part.Name == "BlockStd" or part.Name == "Ball") then
        print("Found part: " .. part.Name)
        table.insert(parts, part.PrimaryPart)  -- Assuming "PrimaryPart" exists for each part
    end
end

local speed = 5  -- Speed for movement

-- Main loop to apply force to the parts
while true do
    -- Ensure the model exists
    if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name .. ' Aircraft') then
        break
    end
    
    -- Get the current position of the HumanoidRootPart
    local targetPosition = hrp.Position + Vector3.new(0, 5, 0)  -- Make it slightly above the player

    -- Iterate over the parts and apply force to them
    for _, part in pairs(parts) do
        if part and part.Parent then
            local direction = (targetPosition - part.Position).Unit  -- Direction from part to target position
            local force = part:FindFirstChild("BodyVelocity")

            -- If BodyVelocity doesn't exist, create it
            if not force then
                force = Instance.new("BodyVelocity")
                force.MaxForce = Vector3.new(math.huge, math.huge, math.huge)  -- Make the force unrestricted
                force.Parent = part  -- Parent it to the part
            end

            -- Apply the velocity towards the target position
            force.Velocity = direction * (targetPosition - part.Position).Magnitude * speed
        end
    end
    
    wait(0.1)  -- Wait a small time to prevent overloading
end
