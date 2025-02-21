local Library = {}
local UserInputService = game:GetService("UserInputService")

-- 🎨 Paleta de cores
local Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(230, 230, 230),
        Highlight = Color3.fromRGB(85, 170, 255),
        Shadow = Color3.fromRGB(0, 0, 0, 0.3)
    }
}

-- 📌 Criar a Interface Principal
function Library:Create(title)
    local theme = Themes.Dark
    local gui = {}

    -- 📌 Criar a GUI
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local ContentFolder = Instance.new("Folder")

    ScreenGui.Name = "ModernLib"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- 🎨 Janela Principal
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.Size = UDim2.new(0, 320, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- 🔥 Sombra
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.Image = "rbxassetid://1316045217" 
    Shadow.ImageTransparency = 0.5

    -- 🔲 Arredondamento
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- 🏷️ Barra de Título
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = theme.Accent
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Parent = MainFrame

    -- 📌 Texto do Título
    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Text = title or "Painel Moderno"
    TitleLabel.Parent = TitleBar

    -- 📌 Conteúdo da GUI
    ContentFolder.Name = "ContentFolder"
    ContentFolder.Parent = MainFrame

    -- 🚀 Função para criar Botões
    function gui:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = MainFrame
        Button.BackgroundColor3 = theme.Highlight
        Button.Size = UDim2.new(0.8, 0, 0, 40)
        Button.Position = UDim2.new(0.1, 0, 0, 50)
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.TextColor3 = theme.Text
        Button.TextSize = 14

        -- 🔲 Arredondamento do botão
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = Button

        -- 💡 Hover Effect
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        end)
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = theme.Highlight
        end)

        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
    end

    -- 🎯 Drag para mover a GUI
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return gui
end

return Library
