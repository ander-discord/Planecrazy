local character = game.Players.LocalPlayer.Character
local hrp = character:WaitForChild("HumanoidRootPart")
local hrpt = hrp.Position
local head = character:WaitForChild("Head")
local headPosition = head.Position + Vector3.new(0, 5, 0)

local parts = {}
local parts_colors = {}
_G.Enabled = true

-- Function to generate a random variable (not used in logic but retained)
function RandomVariable(length)
    local res = ""
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

local DoCheck = RandomVariable(20)
_G.DoCheck = DoCheck

-- Get parts from Aircraft model and their colors
for i, part in pairs(game.Workspace[game.Players.LocalPlayer.Name .. ' Aircraft']:GetChildren()) do
    if part.ClassName == "Model" then
        if part.Name == "BlockStd" or part.Name == "Ball" then
            -- We extract the color values
            print(part.BlockStd.Color)
            table.insert(parts_colors, part.BlockStd.Color)
            table.insert(parts, part.PrimaryPart)
        end
    end
end

local speed = 10
local radius = 30  -- Radius of the circle
local ia = 0    -- Angle variable for circular movement

while true do
    -- Check if Aircraft model still exists, otherwise stop the loop
    if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name .. ' Aircraft') then
        break
    end

    -- Increment angle for circular movement
    ia = ia + 0.5

    -- Move each part towards its corresponding target position
    for i, part in pairs(parts) do
        local color = parts_colors[i]
        local angleOffset = ia + (color.R * 360/15/1.8) * math.pi

        -- Calculate the circular target position for the part
        local xOffset = math.cos(angleOffset) * radius
        local zOffset = math.sin(angleOffset) * radius
        local targetPosition = hrpt + Vector3.new(xOffset, 0, zOffset)

        if (targetPosition - part.Position).Magnitude < 0.01 then
            continue
        end

        -- Calculate direction from the part's current position to the target position
        local direction = (targetPosition - part.Position).Unit

        -- Create or get the BodyVelocity instance
        local force
        if part:FindFirstChild("BodyVelocity") then
            force = part.BodyVelocity
        else
            force = Instance.new("BodyVelocity", part)
            force.MaxForce = Vector3.new(math.huge, math.huge, math.huge)  -- Allow force to move the part freely
        end

        -- Apply velocity towards the target, with adjusted speed
        force.Velocity = direction * (targetPosition - part.Position).Magnitude * speed

        force.Parent = part
    end

    task.wait()
end
