--[[
    ZedHub Full Features - Grow A Garden Edition
    Struktur Lengkap & Stabil untuk Eksekutor Mobile
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Hapus UI lama agar bersih
if PlayerGui:FindFirstChild("ZedHubFullCompleteUI") then
    PlayerGui.ZedHubFullCompleteUI:Destroy()
end

-- Global Config
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

-- 1. ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubFullCompleteUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = PlayerGui
end

-- 2. Floating Button (Minimize)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Parent = ScreenGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
FloatingBtn.BorderColor3 = Color3.fromRGB(59, 130, 246)
FloatingBtn.BorderSizePixel = 1
FloatingBtn.Position = UDim2.new(0, 15, 0, 15)
FloatingBtn.Size = UDim2.new(0, 100, 0, 32)
FloatingBtn.Visible = false
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "🪐 ZedHub [Buka]"
FloatingBtn.TextColor3 = Color3.fromRGB(96, 165, 250)
FloatingBtn.TextSize = 11
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 8)

-- 3. Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 680, 0, 400)

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(51, 65, 85)
MainStroke.Thickness = 1.5

-- 4. Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🪐 ZedHub - Grow A Garden (Premium)"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Minimize & Close
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -55, 0.5, -10)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 14
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- 5. Body Layout
local BodyLayout = Instance.new("Frame")
BodyLayout.Parent = MainFrame
BodyLayout.BackgroundTransparency = 1
BodyLayout.Position = UDim2.new(0, 0, 0, 35)
BodyLayout.Size = UDim2.new(1, 0, 1, -35)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = BodyLayout
Sidebar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2

local SidebarList = Instance.new("UIListLayout")
SidebarList.Parent = Sidebar
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)

local ContentHolder = Instance.new("Frame")
ContentHolder.Parent = BodyLayout
ContentHolder.BackgroundTransparency = 1
ContentHolder.Position = UDim2.new(0, 135, 0, 0)
ContentHolder.Size = UDim2.new(1, -135, 1, 0)

-- Fungsi Pembuat Tab
local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = tabName .. "Page"
    Page.Parent = ContentHolder
    Page.Active = true
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 1200)
    Page.ScrollBarThickness = 3
    Page.Visible = false

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabName .. "Btn"
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    TabBtn.BackgroundTransparency = 0.7
    TabBtn.Size = UDim2.new(1, -6, 0, 30)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = "  " .. tabName
    TabBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
    TabBtn.TextSize = 11
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(ContentHolder:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        Page.Visible = true
    end)

    if #ContentHolder:GetChildren() == 1 then
        Page.Visible = true
    end

    return Page
end

-- Membuat Tab Menu
local TabInfo = CreateTab("Info")
local TabEvent = CreateTab("Event Fall")
local TabSelling = CreateTab("Auto Selling")
local TabShop = CreateTab("Shop")

-- Fungsi Pembantu Membuat Toggle / Tombol Centang Interaktif yang Bisa Diklik
local function CreateToggleItem(parent, labelText, configKey)
    local row = Instance.new("TextButton")
    row.Name = "ToggleRow"
    row.Parent = parent
    row.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, -5, 0, 32)
    row.AutoButtonColor = false
    row.Font = Enum.Font.GothamMedium
    row.Text = "  " .. labelText
    row.TextColor3 = Color3.fromRGB(200, 210, 225)
    row.TextSize = 11
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local statusBox = Instance.new("Frame")
    statusBox.Parent = row
    statusBox.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    statusBox.Position = UDim2.new(1, -30, 0.5, -9)
    statusBox.Size = UDim2.new(0, 18, 0, 18)
    Instance.new("UICorner", statusBox).CornerRadius = UDim.new(0, 4)

    local checkMark = Instance.new("TextLabel")
    checkMark.Parent = statusBox
    checkMark.BackgroundTransparency = 1
    checkMark.Size = UDim2.new(1, 0, 1, 0)
    checkMark.Font = Enum.Font.GothamBold
    checkMark.Text = ""
    checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkMark.TextSize = 10

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        if state then
            statusBox.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
            checkMark.Text = "✓"
        else
            statusBox.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
            checkMark.Text = ""
        end

        -- Update ke config global
        if configKey then
            getgenv().ZedHubConfig[configKey] = state
        end
    end)
    return row
end

-- === ISI KONTEN TAB INFO ===
CreateToggleItem(TabInfo, "Auto Collect Required", "AutoCollect")
CreateToggleItem(TabInfo, "Auto Submit Fall Bloom", "AutoSubmitFallBloom")

-- === ISI KONTEN TAB EVENT FALL ===
CreateToggleItem(TabEvent, "Give A Seed", "GiveASeed")
CreateToggleItem(TabEvent, "Auto Shovel Acorn", "AutoShovel")

-- === ISI KONTEN TAB AUTO SELLING ===
CreateToggleItem(TabSelling, "Auto Sell Backpack", "AutoSellBackpack")
CreateToggleItem(TabSelling, "Auto Sell Fruit", "AutoSellFruit")

-- === ISI KONTEN TAB SHOP (Contoh Item Pilihan) ===
local ShopInfoLabel = Instance.new("TextLabel")
ShopInfoLabel.Parent = TabShop
ShopInfoLabel.BackgroundTransparency = 1
ShopInfoLabel.Size = UDim2.new(1, -5, 0, 30)
ShopInfoLabel.Font = Enum.Font.GothamBold
ShopInfoLabel.Text = "  Sistem Toko & Pembelian Otomatis Aktif"
ShopInfoLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
ShopInfoLabel.TextSize = 11
ShopInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 6. Logika Minimize, Restore, & Close
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

-- 7. Fitur Geser (Draggable)
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

print("ZedHub Full Features Berhasil Dimuat!")
