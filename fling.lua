-- Referências para os elementos da GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Criar um Frame principal
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0.4, 0, 0.3, 0)
frame.Position = UDim2.new(0.3, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

-- Adicionar bordas arredondadas ao Frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.1, 0)
uiCorner.Parent = frame

-- Criar um TextBox moderno
local textBox = Instance.new("TextBox")
textBox.Name = "PlayerNameInput"
textBox.Size = UDim2.new(0.8, 0, 0.4, 0)
textBox.Position = UDim2.new(0.1, 0, 0.2, 0)
textBox.PlaceholderText = "Digite o nome do jogador"
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BorderSizePixel = 0
textBox.TextScaled = true
textBox.Parent = frame

-- Adicionar bordas arredondadas ao TextBox
local uiCornerTextBox = Instance.new("UICorner")
uiCornerTextBox.CornerRadius = UDim.new(0.1, 0)
uiCornerTextBox.Parent = textBox

-- Criar um TextButton moderno
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(0.6, 0, 0.2, 0)
executeButton.Position = UDim2.new(0.2, 0, 0.7, 0)
executeButton.Text = "Executar"
executeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.BorderSizePixel = 0
executeButton.TextScaled = true
executeButton.Parent = frame

-- Adicionar bordas arredondadas ao TextButton
local uiCornerButton = Instance.new("UICorner")
uiCornerButton.CornerRadius = UDim.new(0.1, 0)
uiCornerButton.Parent = executeButton

-- Adicionar animação de hover ao TextButton
executeButton.MouseEnter:Connect(function()
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

executeButton.MouseLeave:Connect(function()
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
end)

-- Criar um botão de fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BorderSizePixel = 0
closeButton.TextScaled = true
closeButton.Parent = frame

-- Adicionar bordas arredondadas ao CloseButton
local uiCornerCloseButton = Instance.new("UICorner")
uiCornerCloseButton.CornerRadius = UDim.new(0.1, 0)
uiCornerCloseButton.Parent = closeButton

-- Função para tornar o Frame arrastável
local dragging
local dragInput
local startPos

local function updatePosition(input)
    local delta = input.Position - dragInput
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updatePosition(input)
    end
end)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Função para obter um jogador pelo nome parcial
local function GetPlayer(name)
    name = name:lower()
    for _, x in next, Players:GetPlayers() do
        if x ~= Player then
            if x.Name:lower():find(name) or x.DisplayName:lower():find(name) then
                return x
            end
        end
    end
    return nil
end

-- Função para flingar o jogador alvo
local function SkidFling(targetPlayer)
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = humanoid and humanoid.RootPart

    local tCharacter = targetPlayer.Character
    local tHumanoid = tCharacter and tCharacter:FindFirstChildOfClass("Humanoid")
    local tRootPart = tHumanoid and tHumanoid.RootPart
    local tHead = tCharacter and tCharacter:FindFirstChild("Head")
    local accessory = tCharacter and tCharacter:FindFirstChildOfClass("Accessory")
    local handle = accessory and accessory:FindFirstChild("Handle")

    if not rootPart then return end -- Verifica se o RootPart existe antes de continuar

    local function FPos(basePart, pos, ang)
        rootPart.CFrame = CFrame.new(basePart.Position) * pos * ang
        character:SetPrimaryPartCFrame(CFrame.new(basePart.Position) * pos * ang)
        rootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        rootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local function SFBasePart(basePart)
        local timeToWait = 1000
        local time = tick()
        local angle = 0

        repeat
            if rootPart and tHumanoid then
                if basePart.Velocity.Magnitude < 50 then
                    angle = angle + 100

                    FPos(basePart, CFrame.new(0, 1.5, 0) + tHumanoid.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()

                    FPos(basePart, CFrame.new(0, -1.5, 0) + tHumanoid.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()

                    FPos(basePart, CFrame.new(2.25, 1.5, -2.25) + tHumanoid.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()

                    FPos(basePart, CFrame.new(-2.25, -1.5, 2.25) + tHumanoid.MoveDirection * basePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                else
                    FPos(basePart, CFrame.new(0, 1.5, tHumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                end
            else
                break
            end
        until basePart.Velocity.Magnitude > 500 or basePart.Parent ~= targetPlayer.Character or targetPlayer.Parent ~= Players or not targetPlayer.Character == tCharacter or tHumanoid.Sit or humanoid.Health <= 0 or tick() > time + timeToWait
    end

    if tRootPart and tHead then
        SFBasePart(tHead)
    elseif tRootPart and not tHead then
        SFBasePart(tRootPart)
    elseif not tRootPart and tHead then
        SFBasePart(tHead)
    elseif accessory and handle then
        SFBasePart(handle)
    end
end

-- Função executada quando o botão é clicado
executeButton.MouseButton1Click:Connect(function()
    local targetName = textBox.Text
    local targetPlayer = GetPlayer(targetName)

    if targetPlayer then
        SkidFling(targetPlayer)
    else
        -- Notifica que o jogador não foi encontrado
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Jogador não encontrado",
            Text = "Não foi possível encontrar um jogador com esse nome.",
            Duration = 3
        })
    end
end)

-- Função para fechar a GUI quando o botão de fechar é clicado
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Loop para executar uma ação periodicamente
local player = game.Players.LocalPlayer
local running = true

-- Conecta a função para parar o loop quando o personagem for recriado
player.CharacterAdded:Connect(function()
    running = false
end)

-- Função para executar a ação periodicamente
local function performAction()
    -- Loop com controle de iterações
    for i = 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999, math.huge do
        if not running then
            break
        end

        if not player.Character or not player.Character.Parent then
            running = false
            break
        end

        -- Ação a ser executada
        print("Ação sendo executada...")  -- Substitua isso com a ação real que você deseja executar
        -- Espera 1 segundo antes de continuar para a próxima iteração
        wait(1)
    end
end

-- Inicia a função para executar a ação
performAction()
