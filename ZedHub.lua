--[[
    ZedHub Ultimate HTML-Style Edition - Grow A Garden
    Struktur Persis HTML: Sidebar, Tab, Section, & Toggle List Lengkap
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ZedHubHTMLStyle") then
    PlayerGui.ZedHubHTMLStyle:Destroy()
end

-- Global Config Store
getgenv().ZedHubConfig = {
    AutoCollect = false,
    AutoSubmitFallBloom = false,
    GiveASeed = false,
    AutoShovel = false,
    AutoSellBackpack = false,
    AutoSellFruit = false,
    FallMarketBuy = { Gear = false, Seed = false, Pets = false, Crate = false },
    ShopBuy = { Egg = false, Seed = false, Gear = false }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubHTMLStyle"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = PlayerGui
end

-- Floating Button (Minimize)
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

-- Main Frame
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

-- Top Bar
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
Title.Size = UDim2.new(0, 380, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🪐 ZedHub - Grow A Garden (HTML Structure)"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

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

-- Body Layout
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

local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = tabName .. "Page"
    Page.Parent = ContentHolder
    Page.Active = true
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, -5, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 3
    Page.Visible = false

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)

    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)

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

-- Pembuatan Tab Utama Sesuai HTML
local TabInfo = CreateTab("Info")
local TabEvent = CreateTab("Event Fall")
local TabSelling = CreateTab("Auto Selling")
local TabShop = CreateTab("Shop")

-- Komponen Container Box (Section)
local function CreateSection(parent, titleText)
    local section = Instance.new("Frame")
    section.Parent = parent
    section.BackgroundColor3 = Color3.fromRGB(3, 7, 18)
    section.BackgroundTransparency = 0.5
    section.Size = UDim2.new(1, -10, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", section).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = section
    stroke.Color = Color3.fromRGB(59, 130, 246)
    stroke.Transparency = 0.6

    local layout = Instance.new("UIListLayout")
    layout.Parent = section
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)

    local header = Instance.new("TextLabel")
    header.Parent = section
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 28)
    header.Font = Enum.Font.GothamBold
    header.Text = "  📂 " .. titleText
    header.TextColor3 = Color3.fromRGB(96, 165, 250)
    header.TextSize = 11
    header.TextXAlignment = Enum.TextXAlignment.Left

    return section
end

-- Komponen Tombol Toggle Interaktif
local function CreateToggle(parent, labelText, callback)
    local row = Instance.new("TextButton")
    row.Parent = parent
    row.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    row.BackgroundTransparency = 0.6
    row.Size = UDim2.new(1, -10, 0, 28)
    row.AutoButtonColor = false
    row.Font = Enum.Font.GothamMedium
    row.Text = "     " .. labelText
    row.TextColor3 = Color3.fromRGB(200, 210, 225)
    row.TextSize = 10.5
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

    local box = Instance.new("Frame")
    box.Parent = row
    box.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    box.Position = UDim2.new(1, -26, 0.5, -8)
    box.Size = UDim2.new(0, 16, 0, 16)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)

    local check = Instance.new("TextLabel")
    check.Parent = box
    check.BackgroundTransparency = 1
    check.Size = UDim2.new(1, 0, 1, 0)
    check.Font = Enum.Font.GothamBold
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 9

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(30, 41, 59)
        check.Text = state and "✓" or ""
        if callback then callback(state) end
    end)
    return row
end

-- === STRUKTUR KONTEN LENGKAP SEPERTI HTML ASLI ===

-- 1. Tab Info
local SecInfo = CreateSection(TabInfo, "General Settings")
CreateToggle(SecInfo, "Auto Collect Required", function(v) getgenv().ZedHubConfig.AutoCollect = v end)
CreateToggle(SecInfo, "Auto Submit Fall Bloom", function(v) getgenv().ZedHubConfig.AutoSubmitFallBloom = v end)

-- 2. Tab Event Fall
local SecFallMain = CreateSection(TabEvent, "Event Fall Control")
CreateToggle(SecFallMain, "Give A Seed", function(v) getgenv().ZedHubConfig.GiveASeed = v end)
CreateToggle(SecFallMain, "Auto Shovel Acorn", function(v) getgenv().ZedHubConfig.AutoShovel = v end)

local SecFallGear = CreateSection(TabEvent, "Market Fall - Gear Options")
CreateToggle(SecFallGear, "Leaf Rake", function(v) print("Leaf Rake:", v) end)
CreateToggle(SecFallGear, "Scarecrow Stick", function(v) print("Scarecrow Stick:", v) end)
CreateToggle(SecFallGear, "Golden Acorn", function(v) print("Golden Acorn:", v) end)

local SecFallSeed = CreateSection(TabEvent, "Market Fall - Seeds & Pets")
CreateToggle(SecFallSeed, "Pumpkin Seed", function(v) print("Pumpkin Seed:", v) end)
CreateToggle(SecFallSeed, "Fall Pet Crate", function(v) print("Fall Pet Crate:", v) end)

-- 3. Tab Auto Selling
local SecSell = CreateSection(TabSelling, "Selling Controller")
CreateToggle(SecSell, "Auto Sell If Backpack Full", function(v) getgenv().ZedHubConfig.AutoSellBackpack = v end)
CreateToggle(SecSell, "Auto Sell Fruit", function(v) getgenv().ZedHubConfig.AutoSellFruit = v end)

-- 4. Tab Shop
local SecShopEgg = CreateSection(TabShop, "Shop Eggs Selection")
CreateToggle(SecShopEgg, "Common Egg", function(v) print("Common Egg:", v) end)
CreateToggle(SecShopEgg, "Rare Egg", function(v) print("Rare Egg:", v) end)
CreateToggle(SecShopEgg, "Mythical Egg", function(v) print("Mythical Egg:", v) end)

local SecShopGear = CreateSection(TabShop, "Shop Gear Selection")
CreateToggle(SecShopGear, "Watering Can Pro", function(v) print("Watering Can Pro:", v) end)
CreateToggle(SecShopGear, "Advanced Shovel", function(v) print("Advanced Shovel:", v) end)

-- Tombol Kontrol Jendela
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

-- Draggable Function
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

print("ZedHub HTML-Style Loaded Successfully!")
