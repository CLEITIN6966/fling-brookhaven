-- Defina a posição para onde o personagem será teleportado
local teleportPosition = Vector3.new(0, 9999999999999999999, 0) -- Substitua pelos valores desejados

-- Obtenha o personagem do jogador
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local loopActive = true

-- Função para teleportar o personagem em loop
local function teleportLoop()
    while loopActive do
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        end
        wait(0) -- Espera 1 segundo antes de teleportar novamente
    end
end

-- Inicia o loop de teletransporte
spawn(teleportLoop)

-- Conecta a função ao evento CharacterAdded para parar o loop quando o personagem reiniciar
player.CharacterAdded:Connect(function()
    loopActive = false -- Para o loop
end)
