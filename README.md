local DarkUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Configurações de estilo
local STYLE = {
    Background = Color3.fromRGB(25, 25, 25),
    Foreground = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(0, 120, 215),
    TextColor = Color3.fromRGB(255, 255, 255),
    BorderSize = 2,
    CornerRadius = UDim.new(0, 6),
    AnimationTime = 0.15
}

-- Função utilitária para criar elementos
local function CreateElement(type, props)
    local element = Instance.new(type)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            element.Parent = value
        else
            element[prop] = value
        end
    end
    return element
end

-- Criação da janela principal
function DarkUI.CreateWindow(name)
    local DragInput, DragStart, StartPos
    local dragging, resizing = false, false
    
    local Window = CreateElement("ScreenGui", {
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })
    
    local MainFrame = CreateElement("Frame", {
        Size = UDim2.new(0, 350, 0, 400),
        Position = UDim2.new(0.5, -175, 0.5, -200),
        BackgroundColor3 = STYLE.Background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Window
    })
    
    -- Cabeçalho arrastável
    local Header = CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = STYLE.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = MainFrame
    })
    
    -- Área de redimensionamento
    local ResizeHandle = CreateElement("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(1, -10, 1, -10),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    -- Estilização
    CreateElement("UICorner", {CornerRadius = STYLE.CornerRadius, Parent = MainFrame})
    CreateElement("UIStroke", {
        Color = STYLE.Accent,
        Thickness = STYLE.BorderSize,
        Parent = MainFrame
    })
    
    -- Interações
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)
    
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            DragStart = input.Position
            StartPos = MainFrame.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
                StartPos.X.Scale, StartPos.X.Offset + delta.X,
                StartPos.Y.Scale, StartPos.Y.Offset + delta.Y
            )
        elseif resizing then
            local delta = input.Position - DragStart
            MainFrame.Size = UDim2.new(
                StartPos.X.Scale, math.clamp(StartPos.X.Offset + delta.X, 300, 600),
                StartPos.Y.Scale, math.clamp(StartPos.Y.Offset + delta.Y, 200, 800)
            )
        end
    end)
    
    return Window, MainFrame
end

-- Componente Toggle
function DarkUI.CreateToggle(parent, title, default)
    local toggleValue = default or false
    local ToggleFrame = CreateElement("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local ToggleButton = CreateElement("TextButton", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -55, 0.5, -12.5),
        BackgroundColor3 = STYLE.Foreground,
        AutoButtonColor = false,
        Text = "",
        Parent = ToggleFrame
    })
    
    local ToggleKnob = CreateElement("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 3, 0.5, -10),
        BackgroundColor3 = STYLE.TextColor,
        Parent = ToggleButton
    })
    
    CreateElement("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleButton})
    CreateElement("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleKnob})
    CreateElement("TextLabel", {
        Text = title,
        TextColor3 = STYLE.TextColor,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Parent = ToggleFrame
    })
    
    local function UpdateToggle()
        local newPosition = toggleValue and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        TweenService:Create(ToggleKnob, TweenInfo.new(STYLE.AnimationTime), {Position = newPosition}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(STYLE.AnimationTime), {
            BackgroundColor3 = toggleValue and STYLE.Accent or STYLE.Foreground
        }):Play()
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggleValue = not toggleValue
        UpdateToggle()
    end)
    
    UpdateToggle()
    return {Value = toggleValue}
end

-- Componente Dropdown
function DarkUI.CreateDropdown(parent, title, options)
    local dropdownOpen = false
    local DropdownFrame = CreateElement("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    -- Implementação similar ao toggle com lista de opções
    -- (Código omitido para brevidade)
    
    return {Value = nil} -- Retorna o valor selecionado
end

-- Componente Slider
function DarkUI.CreateSlider(parent, title, min, max)
    local SliderFrame = CreateElement("Frame", {
        Size = UDim2.new(1, -20, 0, 50),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    -- Implementação do slider com arrasto
    -- (Código omitido para brevidade)
    
    return {Value = min} -- Retorna o valor atual
end

-- Componente ColorPicker
function DarkUI.CreateColorPicker(parent, title)
    local ColorFrame = CreateElement("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    -- Implementação do seletor de cores
    -- (Código omitido para brevidade)
    
    return {Color = Color3.new(1,1,1)} -- Retorna a cor selecionada
end

return DarkUI
