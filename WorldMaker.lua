local character = game.Players.LocalPlayer.Character
local hrp = character:WaitForChild("HumanoidRootPart")
local head = character:WaitForChild("Head")
local headPosition = head.Position + Vector3.new(0, 5, 0)

local parts = {}
local parts_colors = {}
_G.Enabled = true

function RandomVariable(length)
    local res = ""
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

local DoCheck = RandomVariable(20)
_G.DoCheck = DoCheck

for i, part in pairs(game.Workspace[game.Players.LocalPlayer.Name .. ' Aircraft']:GetChildren()) do
    if part.ClassName == "Model" and part.Name == "BlockStd" then
        print(part.BlockStd.Color)
        table.insert(parts_colors, part.BlockStd.Color)
        table.insert(parts, part.PrimaryPart)
    end
end

local speed = 5
local targetposition = Vector3.new(0, 0, 0)

while true do
    for i, part in pairs(parts) do
        local color = parts_colors[i]
        targetposition = hrp.Position + Vector3.new(0, 7, 0) + Vector3.new(
            color.R * 730,
            color.G * 730,
            color.B * -730 
        )
        local direction = (targetposition - part.Position).Unit
        local force
        if part:FindFirstChild("BodyVelocity") then
            force = part.BodyVelocity
        else
            force = Instance.new("BodyVelocity", part)
            force.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end
        force.Velocity = direction * (targetposition - part.Position).Magnitude * speed
        
    end
    wait(0)
end
