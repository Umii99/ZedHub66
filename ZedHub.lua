--[[
    ZedHub UI Premium - Grow A Garden Edition
    Dikonversi dari struktur UI Web ke Roblox Luau
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui

-- Hapus UI lama jika ada
if PlayerGui:FindFirstChild("ZedHubUI") then
    PlayerGui.ZedHubUI:Destroy()
end

-- Konfigurasi Global
getgenv().ZedHubConfig = {
    AutoCollect = false,
    AutoSubmitFallBloom = false,
    GiveASeed = false,
    AutoShovel = false,
    ShadyScarecrowMode = "GOLD_EGG_SEED",
    AutoSellBackpack = false,
    AutoSellFruit = false,
    FallMarketBuy = {
        FallGear = { Active = false, BuyAll = false, Items = {} },
        FallSeed = { Active = false, BuyAll = false, Items = {} },
        FallPets = { Active = false, BuyAll = false, Items = {} },
        FallCrate = { Active = false, BuyAll = false, Items = {} }
    },
    MainShopBuy = {
        MainEgg = { Active = false, BuyAll = false, Items = {} },
        MainSeed = { Active = false, BuyAll = false, Items = {} },
        MainGear = { Active = false, BuyAll = false, Items = {} }
    }
}

-- Buat ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Tombol Floating / Minimize (Muncul saat Hub diminimize)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Parent = ScreenGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
FloatingBtn.BorderColor3 = Color3.fromRGB(59, 130, 246)
FloatingBtn.BorderSizePixel = 1
FloatingBtn.Position = UDim2.new(0, 15, 0, 15)
FloatingBtn.Size = UDim2.new(0, 95, 0, 32)
FloatingBtn.Visible = false
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "🪐 ZedHub [Buka]"
FloatingBtn.TextColor3 = Color3.fromRGB(96, 165, 250)
FloatingBtn.TextSize = 11

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 10)
FloatCorner.Parent = FloatingBtn

-- Main Frame (Ukuran Proporsional Landscape)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderColor3 = Color3.fromRGB(51, 65, 85)
MainFrame.BorderSizePixel = 1
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 680, 0, 400)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Top Title Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 36)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(0, 250, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🪐 ZedHub  (Grow A Garden)"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Minimize & Close di TopBar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -55, 0.5, -10)
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 14
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- Body Layout (Sidebar + Content)
local BodyLayout = Instance.new("Frame")
BodyLayout.Parent = MainFrame
BodyLayout.BackgroundTransparency = 1
BodyLayout.Position = UDim2.new(0, 0, 0, 36)
BodyLayout.Size = UDim2.new(1, 0, 1, -36)

-- Left Sidebar Navigation
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = BodyLayout
Sidebar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

-- Content Area Holder
local ContentArea = Instance.new("Frame")
ContentArea.Parent = BodyLayout
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 135, 0, 0)
ContentArea.Size = UDim2.new(1, -135, 1, 0)

-- Fungsi Membuat Tab Konten
local tabs = {}
local function CreateTab(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Parent = ContentArea
    page.Active = true
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 800)
    page.ScrollBarThickness = 3
    page.Visible = false

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)

    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Parent = Sidebar
    btn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    btn.BackgroundTransparency = 0.8
    btn.Size = UDim2.new(1, -8, 0, 28)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(148, 163, 184)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(ContentArea:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        page.Visible = true
    end)

    if #ContentArea:GetChildren() == 1 then
        page.Visible = true
    end

    return page
end

-- Tab 1: Info
local TabInfo = CreateTab("Info")
-- Tab 2: Event Fall
local TabEvent = CreateTab("Event Fall")
-- Tab 3: Auto Selling
local TabSelling = CreateTab("Auto Selling")
-- Tab 4: Shop
local TabShop = CreateTab("Shop")

-- Logika Tombol Minimize & Restore
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingBtn.Visible = true
end)

FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Fitur Draggable Sederhana untuk Roblox Mobile/PC
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("ZedHub UI Berhasil Dimuat Terlebih Dahulu!")
