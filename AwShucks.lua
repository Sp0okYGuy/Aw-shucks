-- Infinite Shield and Health Script
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Function to keep shield and health active forever
local function applyGodmode()
    -- Infinite Health
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge

    -- Loop to keep reapplying in case damage is taken
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health < math.huge then
            humanoid.Health = math.huge
        end
    end)

    -- Infinite Spawn Shield (if exists)
    local function keepShield()
        while true do
            local shield = char:FindFirstChildOfClass("ForceField")
            if not shield then
                Instance.new("ForceField", char)
            end
            task.wait(1) -- Check every second
        end
    end

    -- Run shield loop in background
    task.spawn(keepShield)
end

-- Apply on first load
applyGodmode()

-- If you respawn, reapply
plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    applyGodmode()
end)
