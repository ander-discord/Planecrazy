local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local character = player.Character
local hrp = character:WaitForChild("HumanoidRootPart")
local hrpt = hrp.Position
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
    if part.ClassName == "Model" then
        if part.Name == "TinyBall" or part.Name == "Ball" then
			print(part.BlockStd.Color)
            table.insert(parts_colors, part.BlockStd.Color)
            table.insert(parts, part.PrimaryPart)
        end
    end
end

local speed = 10
local radius = 10
local ia = 0
local shoothit_pos = nil
local shooted = false

mouse.Button1Down:Connect(function()
	if shooted == false then shooted = true end
	hrp.Anchored = true
	shoothit_pos = hrpt
	local mousehit = mouse.Hit.Position
	speed = 15
	wait(0.1)
	speed = 10
	shoothit_pos = mousehit
	wait(0.4)
	hrp.Anchored = false
end)

while true do
	hrpt = hrp.Position
    if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name .. ' Aircraft') then
        break
    end

    for i, part in pairs(parts) do
		if parts_colors[i] == Color3.new(0.8, 0.8, 0) then
    		targetPosition = shoothit_pos
		end
		if shooted == false then
			continue
		end
        if (targetPosition - part.Position).Magnitude < 1 then
			print(1)
			shoothit_pos = hrpt + Vector3.new(0, 1000, 0)
        end

        local direction = (targetPosition - part.Position).Unit

        local force
        if part:FindFirstChild("BodyVelocity") then
            force = part.BodyVelocity
        else
            force = Instance.new("BodyVelocity", part)
            force.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end

        force.Velocity = direction * (targetPosition - part.Position).Magnitude * speed

        force.Parent = part
    end

    task.wait()
end
