local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui

-- Criar a interface gráfica
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TemporaryUI"
screenGui.Parent = playerGui

-- Criar o container para o botão
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0, 100, 0, 100)  -- Tamanho do botão
buttonContainer.Position = UDim2.new(1, -110, 1, -110)  -- Posição no canto inferior direito
buttonContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
buttonContainer.BackgroundTransparency = 0.5
buttonContainer.Parent = screenGui

-- Criar o botão
local button = Instance.new("TextButton")
button.Name = "EmoteButton"
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "Emote"
button.TextSize = 18
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.BackgroundTransparency = 0.5
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = buttonContainer

-- Script para a funcionalidade do botão
local function updateEmotesValue()
    local emotesValue = player.PlayerData.Equipped.Emotes.Value
    local emotesList = {}

    for value in string.gmatch(emotesValue, "[^|]+") do
        table.insert(emotesList, value)
    end

    if #emotesList >= 6 then
        emotesList[6] = "Shucks"
    end

    player.PlayerData.Equipped.Emotes.Value = table.concat(emotesList, "|")
end

local function onButtonPressed()
    updateEmotesValue()

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.PlatformStand = true
    humanoid:Move(Vector3.zero)

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")

    local emoteScript = require(game:GetService("ReplicatedStorage").Assets.Emotes.Shucks)
    emoteScript.Created({Character = character})

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://74238051754912"
    local animationTrack = humanoid:LoadAnimation(animation)
    animationTrack:Play()

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://123236721947419"
    sound.Parent = character:WaitForChild("HumanoidRootPart")
    sound.Volume = 0.5
    sound.Looped = false
    sound:Play()

    local args = {
        [1] = "PlayEmote",
        [2] = "Animations",
        [3] = "Shucks"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

    game:GetService("Debris"):AddItem(character:FindFirstChild("Saw"), 24)
    game:GetService("Debris"):AddItem(character:FindFirstChild("PlayerEmoteHand"), 24)

    animationTrack.Stopped:Connect(function()
        humanoid.PlatformStand = false
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity:Destroy()
        end
    end)
end

-- Adiciona o evento de clique no botão
button.MouseButton1Click:Connect(onButtonPressed)

-- Função para lidar com o início do personagem
local function onCharacterAdded(character)
    wait(0.1)
    -- Em caso de a função de input ser chamada antes do personagem aparecer
end

player.CharacterAdded:Connect(onCharacterAdded)

-- Se o personagem já existe, chama a função
if player.Character then
    onCharacterAdded(player.Character)
end
