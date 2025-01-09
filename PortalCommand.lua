local character = game.Players.LocalPlayer.Character
local hrp = character:WaitForChild("HumanoidRootPart")
local head = character:WaitForChild("Head")
local parts = {}
local parts_colors = {}
local hrpt = hrp.Position + hrp.CFrame.LookVector * 5
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
        if part.Name == "TinyBall" or part.Name == "Ball" then
            -- We extract the color values
            print(part.BlockStd.Color)
            table.insert(parts_colors, part.BlockStd.Color)
            table.insert(parts, part.PrimaryPart)
        end
    end
end

local pi = math.pi
local speed = 10
local radius = 7 + pi / 5
local ia = 0
local close = false
local open = true
local portalangle = math.atan2(hrp.CFrame.LookVector.X, hrp.CFrame.LookVector.Z)

while true do

    if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name .. ' Aircraft') then
        break
    end
    local RandomSeed = math.random(100, 999)

    ia = ia + 0.05 + pi / (pi * 7.5)
    if ia > 500 then
        close = true
    end
    if close then
        speed = speed - 0.05
        if speed < 2 then
            speed = 1
        end
    end
    for i, part in pairs(parts) do
        local color = parts_colors[i]
        local angleOffset = ia + (color.R / 1.5 * 360 / 15 / 1.8) * math.pi

        local circlePosition = Vector3.new(
            math.cos(angleOffset) * radius,
            math.sin(angleOffset) * radius + 4.5,
            math.sin(i * RandomSeed) / math.pi
        )
        local rotatedPosition = CFrame.Angles(0, portalangle, 0):PointToWorldSpace(circlePosition)
        local targetPosition = hrpt + rotatedPosition

        if (targetPosition - part.Position).Magnitude < 0.01 then
            continue
        end
		if ia > 100 then
			close = true
		end
        if open == false then
            targetPosition = hrpt + Vector3.new(0, 250, 0)
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
