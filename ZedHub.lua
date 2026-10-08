--[[
    ZedHub Final Accurate Replica - Grow A Garden Edition
    Struktur Persis Sesuai Video Referensi Asli
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ZedHubFinalUI") then
    PlayerGui.ZedHubFinalUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubFinalUI"
ScreenGui.ResetOnSpawn = false
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = PlayerGui end

-- Floating Button (Minimize State)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Parent = ScreenGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
FloatingBtn.BorderColor3 = Color3.fromRGB(59, 130, 246)
FloatingBtn.BorderSizePixel = 1
FloatingBtn.Position = UDim2.new(0, 15, 0, 15)
FloatingBtn.Size = UDim2.new(0, 110, 0, 32)
FloatingBtn.Visible = false
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "🪐 ZedHub [Buka]"
FloatingBtn.TextColor3 = Color3.fromRGB(96, 165, 250)
FloatingBtn.TextSize = 11
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 8)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 30)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 640, 0, 370)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(51, 65, 85)
MainStroke.Thickness = 1.2

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 32)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🪐 ZedHub  Grow A Garden"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

-- FPS Label di Top Bar
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Parent = TopBar
FPSLabel.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
FPSLabel.Position = UDim2.new(1, -115, 0.5, -9)
FPSLabel.Size = UDim2.new(0, 50, 0, 18)
FPSLabel.Font = Enum.Font.GothamMedium
FPSLabel.Text = "60 FPS"
FPSLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FPSLabel.TextSize = 9
Instance.new("UICorner", FPSLabel).CornerRadius = UDim.new(0, 4)

-- Tombol Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeBtn.Position = UDim2.new(1, -58, 0.5, -9)
MinimizeBtn.Size = UDim2.new(0, 18, 0, 18)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 12
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -9)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 9
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- Body Layout
local Body = Instance.new("Frame", MainFrame)
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 32)
Body.Size = UDim2.new(1, 0, 1, -32)

-- Sidebar Kiri Utama
local Sidebar = Instance.new("ScrollingFrame", Body)
Sidebar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2
local SBLayout = Instance.new("UIListLayout", Sidebar)
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 3)

-- User Profile Box di Bawah Sidebar
local UserBox = Instance.new("Frame", Sidebar)
UserBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
UserBox.Size = UDim2.new(1, -6, 0, 36)
UserBox.Position = UDim2.new(0, 3, 0, 240)
Instance.new("UICorner", UserBox).CornerRadius = UDim.new(0, 6)
local UserTxt = Instance.new("TextLabel", UserBox)
UserTxt.BackgroundTransparency = 1
UserTxt.Size = UDim2.new(1, 0, 1, 0)
UserTxt.Font = Enum.Font.GothamBold
UserTxt.Text = "  👤 user_123\n  💎 Premium"
UserTxt.TextColor3 = Color3.fromRGB(148, 163, 184)
UserTxt.TextSize = 9
UserTxt.TextXAlignment = Enum.TextXAlignment.Left

-- Content Holder Kanan
local ContentHolder = Instance.new("Frame", Body)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Position = UDim2.new(0, 135, 0, 0)
ContentHolder.Size = UDim2.new(1, -135, 1, 0)

local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame", ContentHolder)
    Page.Name = tabName .. "Page"
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 800)
    Page.ScrollBarThickness = 3
    Page.Visible = false

    local PLayout = Instance.new("UIListLayout", Page)
    PLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PLayout.Padding = UDim.new(0, 6)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    TabBtn.BackgroundTransparency = 0.6
    TabBtn.Size = UDim2.new(1, -6, 0, 30)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = "    " .. tabName
    TabBtn.TextColor3 = Color3.fromRGB(160, 175, 200)
    TabBtn.TextSize = 10.5
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(ContentHolder:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        Page.Visible = true
    end)

    if #ContentHolder:GetChildren() == 1 then Page.Visible = true end
    return Page
end

local TabInfo = CreateTab("Info")
local TabEvent = CreateTab("Event")
local TabSelling = CreateTab("Auto Selling")
local TabShop = CreateTab("Shop")
local TabSettings = CreateTab("Settings")

-- Layout 2 Kolom (Kiri & Kanan Sesuai Video)
local function CreateTwoColumnLayout(parentTab)
    local container = Instance.new("Frame", parentTab)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -6, 0, 330)

    local leftCol = Instance.new("ScrollingFrame", container)
    leftCol.Name = "LeftCol"
    leftCol.BackgroundTransparency = 1
    leftCol.Position = UDim2.new(0, 0, 0, 0)
    leftCol.Size = UDim2.new(0.48, 0, 1, 0)
    leftCol.CanvasSize = UDim2.new(0, 0, 0, 500)
    leftCol.ScrollBarThickness = 2
    local lLayout = Instance.new("UIListLayout", leftCol)
    lLayout.SortOrder = Enum.SortOrder.LayoutOrder
    lLayout.Padding = UDim.new(0, 5)

    local rightCol = Instance.new("ScrollingFrame", container)
    rightCol.Name = "RightCol"
    rightCol.BackgroundTransparency = 1
    rightCol.Position = UDim2.new(0.52, 0, 0, 0)
    rightCol.Size = UDim2.new(0.48, 0, 1, 0)
    rightCol.CanvasSize = UDim2.new(0, 0, 0, 500)
    rightCol.ScrollBarThickness = 2
    local rLayout = Instance.new("UIListLayout", rightCol)
    rLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rLayout.Padding = UDim.new(0, 5)

    return leftCol, rightCol
end

-- Fungsi Membuat Kotak Section Box
local function CreateSection(parentCol, titleText)
    local sec = Instance.new("Frame", parentCol)
    sec.BackgroundColor3 = Color3.fromRGB(3, 7, 18)
    sec.BackgroundTransparency = 0.4
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", sec)
    stroke.Color = Color3.fromRGB(59, 130, 246)
    stroke.Transparency = 0.6

    local layout = Instance.new("UIListLayout", sec)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)

    local header = Instance.new("TextLabel", sec)
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 24)
    header.Font = Enum.Font.GothamBold
    header.Text = "  🔸 " .. titleText
    header.TextColor3 = Color3.fromRGB(96, 165, 250)
    header.TextSize = 10
    header.TextXAlignment = Enum.TextXAlignment.Left

    return sec
end

-- Fungsi Toggle Item
local function CreateToggle(parentSec, text)
    local row = Instance.new("TextButton", parentSec)
    row.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    row.BackgroundTransparency = 0.6
    row.Size = UDim2.new(1, -6, 0, 24)
    row.AutoButtonColor = false
    row.Font = Enum.Font.Gotham
    row.Text = "    " .. text
    row.TextColor3 = Color3.fromRGB(200, 210, 230)
    row.TextSize = 9.5
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

    local box = Instance.new("Frame", row)
    box.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    box.Position = UDim2.new(1, -22, 0.5, -6)
    box.Size = UDim2.new(0, 12, 0, 12)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)

    local check = Instance.new("TextLabel", box)
    check.BackgroundTransparency = 1
    check.Size = UDim2.new(1, 0, 1, 0)
    check.Font = Enum.Font.GothamBold
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 8

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(30, 41, 59)
        check.Text = state and "✓" or ""
    end)
    return row
end

-- === PENGISIAN KONTEN TAB SESUAI VIDEO REFERENSI ===

-- 1. Tab Shop
local ShopLeft, ShopRight = CreateTwoColumnLayout(TabShop)
local SecShopSeed = CreateSection(ShopLeft, "SHOP SEED")
CreateToggle(SecShopSeed, "Carrot")
CreateToggle(SecShopSeed, "Strawberry")
CreateToggle(SecShopSeed, "Blueberry")
CreateToggle(SecShopSeed, "Tomato")
CreateToggle(SecShopSeed, "Auto Buy (Selected)")
CreateToggle(SecShopSeed, "Auto Buy All")

local SecAllSeed = CreateSection(ShopRight, "ALL SEED")
CreateToggle(SecAllSeed, "Carrot")
CreateToggle(SecAllSeed, "Strawberry")
CreateToggle(SecAllSeed, "Advanced Sprinkler")
CreateToggle(SecAllSeed, "Grandmaster")
CreateToggle(SecAllSeed, "Godly Sprinkler")
CreateToggle(SecAllSeed, "Auto Buy (Selected)")
CreateToggle(SecAllSeed, "Auto Buy All")

-- 2. Tab Event (Market Fall & Scarecrow)
local EventLeft, EventRight = CreateTwoColumnLayout(TabEvent)
local SecFall = CreateSection(EventLeft, "MARKET FALL CONTROLLER")
CreateToggle(SecFall, "Give A Seed")
CreateToggle(SecFall, "Auto Shovel Acorn")

local SecFallGear = CreateSection(EventRight, "MARKET FALL - GEAR")
CreateToggle(SecFallGear, "Leaf Rake")
CreateToggle(SecFallGear, "Scarecrow Stick")
CreateToggle(SecFallGear, "Acorn Lolipop")

-- 3. Tab Info
local InfoLeft, InfoRight = CreateTwoColumnLayout(TabInfo)
local SecServer = CreateSection(InfoLeft, "SERVER SETTINGS")
CreateToggle(SecServer, "Auto Collect Required")
CreateToggle(SecServer, "Auto Submit Fall Bloom")

-- 4. Tab Auto Selling
local SellLeft, SellRight = CreateTwoColumnLayout(TabSelling)
local SecSell = CreateSection(SellLeft, "AUTO SELLING FRUIT")
CreateToggle(SecSell, "Auto Sell If Backpack Full")
CreateToggle(SecSell, "Auto Sell Fruit")

-- === KONTROL JENDELA (Minimize, Close, Draggable) ===

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

-- Sistem Draggable Halus di TopBar
local dragging, dragStart, startPos
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

print("ZedHub Final Replica Loaded Successfully!") 
