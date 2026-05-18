local player = game.Players.LocalPlayer
local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid")
end

local humanoid = getHumanoid()
local baseWalkSpeed = humanoid.WalkSpeed
local speedBoost = 350
local sistemaAtivo = false

-- Criar a ScreenGui (persiste no respawn)
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Criar botão
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 50)
toggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Sistema: OFF"
toggleButton.Parent = screenGui

-- Deixar arrastável
toggleButton.Active = true
toggleButton.Draggable = true

-- Atualizar aparência do botão
local function atualizarBotao()
    if sistemaAtivo then
        toggleButton.Text = "Sistema: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        toggleButton.Text = "Sistema: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end

-- Ação ao clicar no botão
toggleButton.MouseButton1Click:Connect(function()
    sistemaAtivo = not sistemaAtivo
    atualizarBotao()
    if not sistemaAtivo then
        humanoid.WalkSpeed = baseWalkSpeed
    end
end)

-- Função que aplica o efeito de velocidade
local function conectarHumanoid(hum)
    hum.StateChanged:Connect(function(_, newState)
        if sistemaAtivo then
            if newState == Enum.HumanoidStateType.Jumping then
                hum.WalkSpeed = baseWalkSpeed + speedBoost
            elseif newState == Enum.HumanoidStateType.Landed then
                hum.WalkSpeed = baseWalkSpeed
            end
        end
    end)
end

-- Conectar ao humanoid atual
conectarHumanoid(humanoid)

-- Reconfigurar tudo quando o jogador renascer
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    baseWalkSpeed = humanoid.WalkSpeed
    conectarHumanoid(humanoid)
    if not sistemaAtivo then
        humanoid.WalkSpeed = baseWalkSpeed
    end
end)

-- Atualizar botão no início
atualizarBotao()
