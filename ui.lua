-- ui.lua
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Library = {}

-- Temas disponíveis
local Themes = {
    Purple = {
        Main = Color3.fromRGB(40, 40, 60),
        Secondary = Color3.fromRGB(60, 50, 80),
        Accent = Color3.fromRGB(150, 100, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Blue = {
        Main = Color3.fromRGB(30, 30, 50),
        Secondary = Color3.fromRGB(50, 70, 90),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Red = {
        Main = Color3.fromRGB(50, 30, 30),
        Secondary = Color3.fromRGB(90, 50, 50),
        Accent = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Green = {
        Main = Color3.fromRGB(30, 50, 30),
        Secondary = Color3.fromRGB(50, 90, 50),
        Accent = Color3.fromRGB(50, 255, 50),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Função para criar a biblioteca
function Library:Create()
    local gui = {}
    local elements = {}
    local theme = Themes.Purple -- Tema padrão

    -- Criar a janela principal
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local ContentFolder = Instance.new("Folder")

    ScreenGui.Name = "BeautifulLib"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = theme.Main
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = theme.Secondary
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame

    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.Parent = TitleLabel

    ContentFolder.Name = "ContentFolder"
    ContentFolder.Parent = MainFrame

    -- Função de arrastar a janela
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

    -- Função para criar um toggle
    function gui:CreateToggle(options)
        local toggle = {}
        local element = Instance.new("Frame")
        local button = Instance.new("TextButton")
        local toggleFrame = Instance.new("Frame")
        local toggleCircle = Instance.new("Frame")

        element.Name = "Toggle"
        element.BackgroundTransparency = 1
        element.Size = UDim2.new(1, -20, 0, 30)
        element.Position = UDim2.new(0, 10, 0, #elements * 35 + 40)
        element.Parent = ContentFolder

        button.Name = "Button"
        button.BackgroundTransparency = 1
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Font = Enum.Font.Gotham
        button.Text = "  "..options.Text
        button.TextColor3 = theme.Text
        button.TextSize = 12
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = element

        toggleFrame.Name = "ToggleFrame"
        toggleFrame.BackgroundColor3 = theme.Secondary
        toggleFrame.Size = UDim2.new(0, 50, 0, 25)
        toggleFrame.Position = UDim2.new(1, -50, 0.5, -12)
        toggleFrame.Parent = element

        UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = toggleFrame

        toggleCircle.Name = "ToggleCircle"
        toggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
        toggleCircle.Size = UDim2.new(0, 21, 0, 21)
        toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
        toggleCircle.Parent = toggleFrame

        UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = toggleCircle

        local state = options.Default or false
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        local function updateToggle()
            local tween = TweenService:Create(toggleCircle, tweenInfo, {
                Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            })
            tween:Play()
            toggleFrame.BackgroundColor3 = state and theme.Accent or theme.Secondary
        end

        button.MouseButton1Click:Connect(function()
            state = not state
            updateToggle()
            if options.Callback then
                options.Callback(state)
            end
        end)

        table.insert(elements, element)
        return toggle
    end

    -- Adicione funções para outros elementos (Slider, TextBox, ColorPicker, etc.)

    return gui
end

return Library
