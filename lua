-- kakauHub
function AtualizarCor(botao, ativo)
    if ativo then
        botao.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Verde para ativado
    else
        botao.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho para desativado
    end
end


local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local settingsData = { hubTheme = "escuro", confirmOnClose = false }
local function saveSettings()
    local folder = PlayerGui:FindFirstChild("kakauHubSettings") or Instance.new("Folder", PlayerGui)
    folder.Name = "kakauHubSettings"
    for k, v in pairs(settingsData) do
        local vObj = folder:FindFirstChild(k) or Instance.new("StringValue", folder)
        vObj.Name = k
        vObj.Value = tostring(v)
    end
end
local function loadSettings()
    local folder = PlayerGui:FindFirstChild("kakauHubSettings")
    if not folder then return end
    for _, vObj in ipairs(folder:GetChildren()) do
        if vObj.Name == "confirmOnClose" then
            settingsData.confirmOnClose = (vObj.Value == "true")
        elseif vObj.Name == "hubTheme" then
            settingsData.hubTheme = "escuro"
        end
    end
end
loadSettings()

local normalSize = UDim2.new(0.6, 0, 0.62, 0)
local normalPos  = UDim2.new(0.5, 0, 0.48, 0)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "kakauHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local TabFrames = {}

local function makeHeader(tab, text)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -20, 0, 28)
    header.Position = UDim2.new(0, 10, 0, 0)
    header.BackgroundTransparency = 1
    header.Text = text
    header.Font = Enum.Font.GothamBold
    header.TextColor3 = Color3.fromRGB(255,60,60)
    header.TextSize = 19
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = TabFrames[tab]
end

local function makeRow(tab, labelText, control)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, 38)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.Parent = TabFrames[tab]

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 130, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    if control then
        control.Parent = row
    end
    return row
end

-- Main Frame/UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = normalSize
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = normalPos
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 16)


local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBar.BackgroundTransparency = 0.35
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
addCorner(TopBar, 15)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 80, 1, 0)
fpsLabel.Position = UDim2.new(1, -90, 0, 0) -- Ao lado do título
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Verde vibrante
fpsLabel.TextSize = 18
fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsLabel.Parent = TopBar

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0, 80, 1, 0)
pingLabel.Position = UDim2.new(1, -180, 0, 0) -- Ao lado do FPS
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextColor3 = Color3.fromRGB(0, 200, 255) -- Azul vibrante
pingLabel.TextSize = 18
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Parent = TopBar

local function updateFPS()
    local lastTime = tick()
    local fpsCounter = 0
    RunService.RenderStepped:Connect(function()
        fpsCounter = fpsCounter + 1
        if tick() - lastTime >= 1 then
            fpsLabel.Text = "FPS: " .. fpsCounter
            fpsCounter = 0
            lastTime = tick()
        end
    end)
end

local function updatePing()
    while true do
        local success, ping = pcall(function()
            return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if success then
            pingLabel.Text = "Ping: " .. ping .. "ms"
        else
            pingLabel.Text = "Ping: N/A"
        end
        task.wait(1) -- Atualiza a cada segundo
    end
end

updateFPS()
task.spawn(updatePing)

local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.Position = UDim2.new(0,0,1,-3)
Accent.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Accent.BorderSizePixel = 0
Accent.Parent = TopBar
addCorner(Accent, 1)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "kakauHub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 23
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Drag
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
end

local HubBtn = Instance.new("TextButton")
HubBtn.Name = "HubBtn"
HubBtn.Text = "≡"
HubBtn.Font = Enum.Font.GothamBold
HubBtn.TextSize = 26
HubBtn.TextColor3 = Color3.fromRGB(255,255,255)
HubBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HubBtn.BackgroundTransparency = 0.28
HubBtn.Size = UDim2.new(0, 44, 0, 44)
HubBtn.Position = UDim2.new(0.93, 0, 0.91, 0)
HubBtn.Visible = true
HubBtn.ZIndex = 10
HubBtn.Parent = ScreenGui
addCorner(HubBtn, 14)

do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        HubBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    HubBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = HubBtn.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    HubBtn.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
end

local TABLIST = {
    {Name="Main",Label="Main"},
    {Name="Visual",Label="Visual"},
    {Name="Poderes",Label="Poderes"},
    {Name="Admin",Label="Admin"},
}

-- SCROLLING ABAS (INTEGRADO)
local TabBarArea = Instance.new("ScrollingFrame")
TabBarArea.Name = "TabBarArea"
TabBarArea.Size = UDim2.new(1, -10, 0, 52)
TabBarArea.Position = UDim2.new(0, 5, 0, 44)
TabBarArea.BackgroundColor3 = Color3.fromRGB(0,0,0)
TabBarArea.BackgroundTransparency = 0.31
TabBarArea.BorderSizePixel = 0
TabBarArea.Parent = MainFrame
TabBarArea.ScrollingDirection = Enum.ScrollingDirection.X
TabBarArea.CanvasSize = UDim2.new(0, 0, 1, 0)
TabBarArea.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBarArea.ScrollBarThickness = 4
TabBarArea.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60)
addCorner(TabBarArea, 10)

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.FillDirection = Enum.FillDirection.Horizontal
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 8)
tabListLayout.Parent = TabBarArea

local Tabs = {}
for i,tab in ipairs(TABLIST) do
    Tabs[tab.Name] = Instance.new("TextButton")
    local btn = Tabs[tab.Name]
    btn.Name = tab.Name
    btn.Text = tab.Label
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 17
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.45
    btn.Size = UDim2.new(0, 130, 0, 42)
    btn.BorderSizePixel = 0
    btn.Parent = TabBarArea
    addCorner(btn, 10)
end

local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -(TabBarArea.Position.Y.Offset + TabBarArea.Size.Y.Offset))
ContentArea.AnchorPoint = Vector2.new(0, 0)
ContentArea.Position = UDim2.new(0, 0, 0, TabBarArea.Position.Y.Offset + TabBarArea.Size.Y.Offset)
ContentArea.BackgroundColor3 = Color3.fromRGB(0,0,0)
ContentArea.BackgroundTransparency = 0.49
ContentArea.BorderSizePixel = 0
ContentArea.ScrollingDirection = Enum.ScrollingDirection.Y
ContentArea.CanvasSize = UDim2.new(0,0,0,0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.ScrollBarThickness = 5
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60)
ContentArea.ScrollBarImageTransparency = 0.3
ContentArea.Parent = MainFrame
addCorner(ContentArea, 12)
if ContentArea:FindFirstChild("SmoothScrollingEnabled") ~= nil then
    ContentArea.SmoothScrollingEnabled = true
end

for _,tab in ipairs(TABLIST) do
    local frame = Instance.new("Frame")
    frame.Name = tab.Name.."TabFrame"
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.LayoutOrder = 0
    frame.Parent = ContentArea
    TabFrames[tab.Name] = frame

    -- Cada aba agora recebe um UIListLayout VERTICAL para deixar os elementos em coluna!
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame
end
TabFrames["Main"].Visible = true

--------------------------------------------------
-- ========== MAIN ==========
makeHeader("Main","Bem-vindo ao kakauHub!")
makeRow("Main","Use as abas acima para acessar os poderes e visuais.",nil)

--------------------------------------------------
-- ========== VISUAL ==========
makeHeader("Visual","Visuais")


local function criarBotao(text, cor, txtOn, txtOff, getState, setState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 32)
    AtualizarCor(btn, getState()) -- Define a cor ao criar o botão
    btn.Text = getState() and txtOn or txtOff
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 15
    addCorner(btn, 8)
    btn.MouseButton1Click:Connect(function()
        setState(not getState())
        AtualizarCor(btn, getState()) -- Atualiza a cor quando clicado
        btn.Text = getState() and txtOn or txtOff
    end)
    return btn
end


--------------------------------------------------
-- ========== PODERES ==========
makeHeader("Poderes","Poderes")




--------------------------------------------------
-- ========== SWITCH ABAS ==========
local function showTab(tab)
    for name, frame in pairs(TabFrames) do
        frame.Visible = false
    end
    TabFrames[tab].Visible = true
end
for name,btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function() showTab(name) end)
end

local hubOpened = false
local function animateOpen()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = normalSize,
        Position = normalPos
    })
    tween:Play()
    hubOpened = true
end
local function animateClose()
    if settingsData.confirmOnClose then
        saveSettings()
    end
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    hubOpened = false
end
HubBtn.MouseButton1Click:Connect(function()
    if hubOpened then
        animateClose()
    else
        animateOpen()
    end
end)

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "KakauHub",
        Text = "KakauHub iniciado!",
        Duration = 4
    })
end)


task.wait(0.1)
animateOpen()
# kakauhub-facillity.
