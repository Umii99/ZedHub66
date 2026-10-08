--[[
    ZEDHUB - FINAL FULL INTEGRATED SCRIPT (GROW A GARDEN)
    - UI Murni milikmu dengan callback CreateToggle ON/OFF yang sempurna
    - Backend Auto Sell Mutlak (Membaca Max Capacity & Item Count langsung dari game seperti Zetsu)
    - Backend Auto Buy (Selected & Buy All untuk Main Shop & 4 Fall Market)
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ZedHubStrictUI") then
    PlayerGui.ZedHubStrictUI:Destroy()
end

-- =========================================================================
-- CONFIGURATION STATE (Pusat Kendali Engine & UI State)
-- =========================================================================
getgenv().ZedHubConfig = {
    AutoCollect = false,
    AutoSubmit = false,
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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubStrictUI"
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
FloatingBtn.Size = UDim2.new(0, 120, 0, 36)
FloatingBtn.Visible = false
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "🪐 ZedHub [Buka]"
FloatingBtn.TextColor3 = Color3.fromRGB(96, 165, 250)
FloatingBtn.TextSize = 12
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 8)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 30)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 580, 0, 350)
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
TopBar.Size = UDim2.new(1, 0, 0, 34)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🪐 ZedHub  Grow A Garden"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- FPS Label di Top Bar
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Parent = TopBar
FPSLabel.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
FPSLabel.Position = UDim2.new(1, -120, 0.5, -10)
FPSLabel.Size = UDim2.new(0, 52, 0, 20)
FPSLabel.Font = Enum.Font.GothamMedium
FPSLabel.Text = "60 FPS"
FPSLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FPSLabel.TextSize = 10
Instance.new("UICorner", FPSLabel).CornerRadius = UDim.new(0, 4)

-- Tombol Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -10)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 14
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- Body Layout
local Body = Instance.new("Frame", MainFrame)
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 34)
Body.Size = UDim2.new(1, 0, 1, -34)

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
SBLayout.Padding = UDim.new(0, 4)

-- User Profile Box di Bawah Sidebar
local UserBox = Instance.new("Frame", Sidebar)
UserBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
UserBox.Size = UDim2.new(1, -6, 0, 38)
UserBox.Position = UDim2.new(0, 3, 0, 220)
Instance.new("UICorner", UserBox).CornerRadius = UDim.new(0, 6)
local UserTxt = Instance.new("TextLabel", UserBox)
UserTxt.BackgroundTransparency = 1
UserTxt.Size = UDim2.new(1, 0, 1, 0)
UserTxt.Font = Enum.Font.GothamBold
UserTxt.Text = "  👤 user_123\n  💎 Premium"
UserTxt.TextColor3 = Color3.fromRGB(148, 163, 184)
UserTxt.TextSize = 9.5
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
    Page.Size = UDim2.new(1, -10, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 2500)
    Page.ScrollBarThickness = 3
    Page.Visible = false

    local PLayout = Instance.new("UIListLayout", Page)
    PLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PLayout.Padding = UDim.new(0, 8)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    TabBtn.BackgroundTransparency = 0.6
    TabBtn.Size = UDim2.new(1, -6, 0, 32)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = "    " .. tabName
    TabBtn.TextColor3 = Color3.fromRGB(160, 175, 200)
    TabBtn.TextSize = 11.5
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

-- Tab Menu Utama di Sidebar
local TabInfo = CreateTab("Info")
local TabEvent = CreateTab("Event")
local TabShop = CreateTab("Shop")
local TabSelling = CreateTab("Auto Selling")
local TabSettings = CreateTab("Settings")

-- Fungsi Accordion Buka-Tutup
local function CreateAccordionSection(parent, titleText, accentColor)
    local sec = Instance.new("Frame", parent)
    sec.BackgroundColor3 = Color3.fromRGB(3, 7, 18)
    sec.BackgroundTransparency = 0.4
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", sec)
    stroke.Color = accentColor or Color3.fromRGB(59, 130, 246)
    stroke.Transparency = 0.6

    local mainLayout = Instance.new("UIListLayout", sec)
    mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mainLayout.Padding = UDim.new(0, 6)

    local headerBtn = Instance.new("TextButton", sec)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Size = UDim2.new(1, 0, 0, 30)
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.Text = "  🔹 " .. titleText
    headerBtn.TextColor3 = accentColor or Color3.fromRGB(96, 165, 250)
    headerBtn.TextSize = 11.5
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left

    local chevron = Instance.new("TextLabel", headerBtn)
    chevron.BackgroundTransparency = 1
    chevron.Position = UDim2.new(1, -24, 0, 0)
    chevron.Size = UDim2.new(0, 20, 1, 0)
    chevron.Font = Enum.Font.GothamBold
    chevron.Text = "▲"
    chevron.TextColor3 = accentColor or Color3.fromRGB(96, 165, 250)
    chevron.TextSize = 10

    local container = Instance.new("Frame", sec)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ClipsDescendants = true

    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 6)

    local padding = Instance.new("UIPadding", container)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)

    local isOpen = true
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        container.Visible = isOpen
        chevron.Text = isOpen and "▲" or "▼"
    end)

    return container
end

-- Tombol Checkbox
local function CreateToggle(parentSec, text, callback)
    local row = Instance.new("TextButton", parentSec)
    row.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    row.BackgroundTransparency = 0.6
    row.Size = UDim2.new(1, 0, 0, 26)
    row.AutoButtonColor = false
    row.Font = Enum.Font.Gotham
    row.Text = "    " .. text
    row.TextColor3 = Color3.fromRGB(210, 220, 240)
    row.TextSize = 11
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

    local box = Instance.new("Frame", row)
    box.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    box.Position = UDim2.new(1, -20, 0.5, -6)
    box.Size = UDim2.new(0, 12, 0, 12)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)

    local check = Instance.new("TextLabel", box)
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
        
        if callback then 
            callback(state) 
        end
    end)
    return row
end

-- Tombol Selected (Dropdown List Buka-Tutup)
local function CreateSelectedDropdown(parentSec, titleText, itemsTable, onItemsChanged)
    local dropFrame = Instance.new("Frame", parentSec)
    dropFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
    dropFrame.BackgroundTransparency = 0.5
    dropFrame.Size = UDim2.new(1, 0, 0, 0)
    dropFrame.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)

    local dropLayout = Instance.new("UIListLayout", dropFrame)
    dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropLayout.Padding = UDim.new(0, 4)

    local dropBtn = Instance.new("TextButton", dropFrame)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    dropBtn.BackgroundTransparency = 0.4
    dropBtn.Size = UDim2.new(1, 0, 0, 26)
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.Text = "  📂 " .. titleText .. " [Selected]"
    dropBtn.TextColor3 = Color3.fromRGB(147, 197, 253)
    dropBtn.TextSize = 10.5
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 4)

    local listContainer = Instance.new("Frame", dropFrame)
    listContainer.BackgroundTransparency = 1
    listContainer.Size = UDim2.new(1, 0, 0, 0)
    listContainer.AutomaticSize = Enum.AutomaticSize.Y
    listContainer.Visible = false

    local listLayout = Instance.new("UIListLayout", listContainer)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)

    local listPadding = Instance.new("UIPadding", listContainer)
    listPadding.PaddingLeft = UDim.new(0, 10)
    listPadding.PaddingBottom = UDim.new(0, 4)

    local selectedItems = {}

    for _, itemName in ipairs(itemsTable) do
        CreateToggle(listContainer, itemName, function(active)
            if active then
                table.insert(selectedItems, itemName)
            else
                for i, v in ipairs(selectedItems) do
                    if v == itemName then table.remove(selectedItems, i) end
                end
            end
            if onItemsChanged then onItemsChanged(selectedItems) end
        end)
    end

    local isListOpen = false
    dropBtn.MouseButton1Click:Connect(function()
        isListOpen = not isListOpen
        listContainer.Visible = isListOpen
    end)

    return dropFrame
end

-- Tombol Khusus Action On/Off
local function CreateActionToggle(parentSec, text, callback)
    local row = Instance.new("TextButton", parentSec)
    row.BackgroundColor3 = Color3.fromRGB(30, 27, 75)
    row.BackgroundTransparency = 0.3
    row.Size = UDim2.new(1, 0, 0, 28)
    row.AutoButtonColor = false
    row.Font = Enum.Font.GothamBold
    row.Text = "    ⚡ " .. text
    row.TextColor3 = Color3.fromRGB(234, 179, 8)
    row.TextSize = 11
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

    local box = Instance.new("Frame", row)
    box.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
    box.Position = UDim2.new(1, -22, 0.5, -6)
    box.Size = UDim2.new(0, 12, 0, 12)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)

    local check = Instance.new("TextLabel", box)
    check.BackgroundTransparency = 1
    check.Size = UDim2.new(1, 0, 1, 0)
    check.Font = Enum.Font.GothamBold
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 9

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(234, 179, 8) or Color3.fromRGB(60, 40, 20)
        check.Text = state and "✓" or ""
        if callback then callback(state) end
    end)
    return row
end

-- === PENGISIAN KONTEN TAB EVENT ===

local SecFallHarvest = CreateAccordionSection(TabEvent, "FALL HARVEST", Color3.fromRGB(251, 146, 60))
CreateToggle(SecFallHarvest, "Required Collection Plant", function(state) getgenv().ZedHubConfig.AutoCollect = state end)
CreateToggle(SecFallHarvest, "Required Submit Plant", function(state) getgenv().ZedHubConfig.AutoSubmit = state end)

-- Fall Shop
local SecFallShop = CreateAccordionSection(TabEvent, "FALL SHOP", Color3.fromRGB(236, 72, 153))
CreateSelectedDropdown(SecFallShop, "Fall Shop Pets & Egg", {"Fall Egg", "Salmon", "Chipmunk", "Woodpecker", "Red Squirrel", "Marmot", "Mallard", "Sugar Glider", "Space Squirrel", "Red Panda"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallPets.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Pets & Egg On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallPets.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Cosmetic & Crate", {"Fall Leaf Chair", "Fall Crate", "Maple Flag", "Maple Wreath", "Fall Haybale", "Pile Of Leaves", "Flying Kit", "Autumn Crate", "Fall Mountain"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Cosmetic & Crate On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Seed & Seed Pack", {"Turnip Seed", "Parsley Seed", "Autumn Seed Pack", "Meyers Lemon", "Carnival Pumpkin", "Golden Peach", "Kniphopia", "Maple Resin"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Seed & Seed Pack On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Gear", {"Firefly Jar", "Sky Lantern", "Maple Leaf Kite", "Maple Blower", "Maple Syrup", "Maple Sprinkler", "Bonfire", "Harvest Basket", "Acorn Lollipop", "Golden Acorn"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallGear.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Gear On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallGear.Active = state end)

-- Shady Scarecrown
local SecShadyScarecrown = CreateAccordionSection(TabEvent, "SHADY SCARECROW", Color3.fromRGB(251, 191, 36))
CreateSelectedDropdown(SecShadyScarecrown, "Selected Seed", {"All Seed", "Gold Egg Seed"}, function(items)
    if #items > 0 then getgenv().ZedHubConfig.ShadyScarecrowMode = (items[#items] == "All Seed") and "ALL_SEED" or "GOLD_EGG_SEED" end
end)
CreateActionToggle(SecShadyScarecrown, "Give A Seed On/Off", function(state) getgenv().ZedHubConfig.GiveASeed = state end)

-- Auto Acorn
local SecAutoAcorn = CreateAccordionSection(TabEvent, "AUTO ACORN", Color3.fromRGB(56, 189, 248))
CreateActionToggle(SecAutoAcorn, "Auto Shovel Acorn On/Off", function(state) getgenv().ZedHubConfig.AutoShovel = state end)


-- === PENGISIAN KONTEN TAB SHOP ===

local SecShopEgg = CreateAccordionSection(TabShop, "SHOP EGG", Color3.fromRGB(168, 85, 247))
CreateSelectedDropdown(SecShopEgg, "Shop Egg List", {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythichal Egg", "Bugg Egg", "Junggle Egg"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items = items end)
CreateActionToggle(SecShopEgg, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active = state end)
CreateActionToggle(SecShopEgg, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll = state end)

local SecShopSeed = CreateAccordionSection(TabShop, "SHOP SEED", Color3.fromRGB(52, 211, 153))
CreateSelectedDropdown(SecShopSeed, "Shop Seed List", {"Carrot", "Strawberry", "Blueberry", "Tomato", "Buttercup", "Daffodil", "Corn", "Tulip", "Bamboo", "Watermelon", "Pumpkin", "Coconut", "Manggo", "Pineapple", "Apple", "Grape", "Dragon Fruit", "Cactus", "Papper", "Mushroom", "Cacao Bean", "Beanstalk", "Ember Lily", "Suggar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco", "Crimson Thorn", "Zebra", "Zinkle", "Octobloom", "Alien Apple", "Aurum Spire"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items = items end)
CreateActionToggle(SecShopSeed, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active = state end)
CreateActionToggle(SecShopSeed, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll = state end)

local SecShopGear = CreateAccordionSection(TabShop, "SHOP GEAR", Color3.fromRGB(59, 130, 246))
CreateSelectedDropdown(SecShopGear, "Shop Gear List", {"Advanced Sprinkler", "Grandmaster", "Godly Sprinkler", "Master Sprinkler", "Basic Sprinkler", "Harvest Tools", "Favorite Tools", "Recall Wrench", "Cleaning Spray", "Cleansing Shard", "Level Up Lollipop"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainGear.Items = items end)
CreateActionToggle(SecShopGear, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.Active = state end)
CreateActionToggle(SecShopGear, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll = state end)


-- === TAB AUTO SELLING ===
local SecSell = CreateAccordionSection(TabSelling, "AUTO SELLING FRUIT", Color3.fromRGB(129, 140, 248))

CreateToggle(SecSell, "Auto Sell If Backpack Full", function(state)
    getgenv().ZedHubConfig.AutoSellBackpack = state
end)

CreateToggle(SecSell, "Auto Sell Fruit", function(state)
    getgenv().ZedHubConfig.AutoSellFruit = state
end)

local WebhookBody = CreateAccordionSection(TabInfo, "WEBHOOK", Color3.fromRGB(251, 191, 36))
local WebhookBox = Instance.new("TextBox", WebhookBody)
WebhookBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
WebhookBox.Size = UDim2.new(1, 0, 0, 30)
WebhookBox.Font = Enum.Font.Gotham
WebhookBox.PlaceholderText = "URL Webhook Discord..."
WebhookBox.Text = ""
WebhookBox.TextColor3 = Color3.fromRGB(240, 240, 255)
WebhookBox.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
WebhookBox.TextSize = 11
Instance.new("UICorner", WebhookBox).CornerRadius = UDim.new(0, 4)

local ServerBody = CreateAccordionSection(TabInfo, "SERVER", Color3.fromRGB(96, 165, 250))
local ServerRow = Instance.new("Frame", ServerBody)
ServerRow.BackgroundTransparency = 1
ServerRow.Size = UDim2.new(1, 0, 0, 30)

local ServerInput = Instance.new("TextBox", ServerRow)
ServerInput.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
ServerInput.Size = UDim2.new(0.68, 0, 1, 0)
ServerInput.Font = Enum.Font.Gotham
ServerInput.PlaceholderText = "2007"
ServerInput.Text = ""
ServerInput.TextColor3 = Color3.fromRGB(240, 240, 255)
ServerInput.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
ServerInput.TextSize = 11
Instance.new("UICorner", ServerInput).CornerRadius = UDim.new(0, 4)

local ClickBtn = Instance.new("TextButton", ServerRow)
ClickBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
ClickBtn.Position = UDim2.new(0.71, 0, 0, 0)
ClickBtn.Size = UDim2.new(0.29, 0, 1, 0)
ClickBtn.Font = Enum.Font.GothamBold
ClickBtn.Text = "Click"
ClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickBtn.TextSize = 11
Instance.new("UICorner", ClickBtn).CornerRadius = UDim.new(0, 4)


-- =========================================================================
-- MASTER BACKEND AUTOMATION ENGINE (Precise Max Capacity & Count Sync)
-- =========================================================================
local IsSelling = false

local function GetBackpackCapacityInfo()
    local character = LocalPlayer.Character
    local currentCount = 0
    local maxCapacity = 50 -- Angka default cadangan

    -- 1. Menghitung jumlah item buah aktif di tas & karakter
    local function ScanFolder(folder)
        if not folder then return end
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("Tool") then
                local nameLower = string.lower(item.Name)
                if not string.find(nameLower, "seed") and not string.find(nameLower, "sprinkler") and not string.find(nameLower, "wrench") then
                    currentCount = currentCount + 1
                end
            end
        end
    end

    if Backpack then ScanFolder(Backpack) end
    if character then ScanFolder(character) end

    -- 2. Membaca batas kapasitas maksimum langsung dari atribut game
    if LocalPlayer:GetAttribute("MaxInventory") then
        maxCapacity = LocalPlayer:GetAttribute("MaxInventory")
    elseif LocalPlayer:GetAttribute("BackpackCapacity") then
        maxCapacity = LocalPlayer:GetAttribute("BackpackCapacity")
    elseif LocalPlayer:GetAttribute("PlantCapacity") then
        maxCapacity = LocalPlayer:GetAttribute("PlantCapacity")
    elseif LocalPlayer:GetAttribute("MaxCapacity") then
        maxCapacity = LocalPlayer:GetAttribute("MaxCapacity")
    else
        -- Memeriksa folder data internal pemain
        for _, child in ipairs(LocalPlayer:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Configuration") then
                local foundMax = child:FindFirstChild("MaxInventory") or 
                                 child:FindFirstChild("BackpackCapacity") or 
                                 child:FindFirstChild("Capacity") or 
                                 child:FindFirstChild("MaxCapacity")
                if foundMax and foundMax:IsA("ValueBase") then
                    maxCapacity = foundMax.Value
                    break
                end
            end
        end
    end

    return currentCount, maxCapacity
end

local function SellInventory()
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    local ShecklesCount = (Leaderstats and Leaderstats:FindFirstChild("Sheckles")) or 
                          LocalPlayer:FindFirstChild("PlayerSheckles") or
                          (Leaderstats and Leaderstats:FindFirstChild("PlayerSheckles"))
                          
    local PreviousSheckles = ShecklesCount and ShecklesCount.Value or 0
    local Previous = Character:GetPivot()

    if IsSelling then return end
    IsSelling = true

    Character:PivotTo(CFrame.new(62, 4, -26))
    task.wait(0.3)
    
    local sellEvt = GameEvents and (
        GameEvents:FindFirstChild("Sell_Inventory") or 
        GameEvents:FindFirstChild("SellInventory") or 
        GameEvents:FindFirstChild("Sell")
    )

    while task.wait(0.2) do
        local backpackOn = getgenv().ZedHubConfig.AutoSellBackpack
        local fruitOn = getgenv().ZedHubConfig.AutoSellFruit
        if not backpackOn and not fruitOn then 
            break 
        end

        if ShecklesCount and ShecklesCount.Value ~= PreviousSheckles then break end
        
        if sellEvt then
            pcall(function()
                sellEvt:FireServer()
            end)
        end
    end
    
    Character:PivotTo(Previous)
    task.wait(0.3)
    IsSelling = false
end

-- Looping Utama: Bandingkan Total Buah dengan Kapasitas Maksimum Asli Game
task.spawn(function()
    while task.wait(1) do
        local backpackOn = getgenv().ZedHubConfig.AutoSellBackpack
        local fruitOn = getgenv().ZedHubConfig.AutoSellFruit

        if (backpackOn or fruitOn) and not IsSelling then
            local currentItems, maxLimit = GetBackpackCapacityInfo()

            -- 1. Jika "Auto Sell Fruit" dicentang -> Jual terus menerus
            if fruitOn and not backpackOn then
                SellInventory()
                
            -- 2. Jika "Auto Sell If Backpack Full" dicentang -> Diam total jika belum full, langsung sell pas menyentuh limit max
            elseif backpackOn and not fruitOn then
                if currentItems >= maxLimit then
                    SellInventory()
                end
            end
        end
    end
end)

-- Auto Buy Engine (Main Shop & 4 Fall Market)
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local buyEvt = GameEvents and (GameEvents:FindFirstChild("BuyEventShop") or GameEvents:FindFirstChild("BuyMarketItem") or GameEvents:FindFirstChild("BuySeedStock") or GameEvents:FindFirstChild("BuyItem"))
            if not buyEvt then return end

            for catName, data in pairs(getgenv().ZedHubConfig.FallMarketBuy) do
                if data.BuyAll then
                    buyEvt:FireServer(catName, "BUY_ALL")
                    task.wait(0.3)
                elseif data.Active and data.Items and #data.Items > 0 then
                    for _, itemName in pairs(data.Items) do
                        if not data.Active then break end
                        buyEvt:FireServer(catName, itemName)
                        task.wait(0.25)
                    end
                end
            end

            for catName, data in pairs(getgenv().ZedHubConfig.MainShopBuy) do
                if data.BuyAll then
                    buyEvt:FireServer(catName, "BUY_ALL")
                    task.wait(0.3)
                elseif data.Active and data.Items and #data.Items > 0 then
                    for _, itemName in pairs(data.Items) do
                        if not data.Active then break end
                        buyEvt:FireServer(catName, itemName)
                        task.wait(0.25)
                    end
                end
            end
        end)
    end
end)


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

print("ZedHub UI & Perfect Capacity-Sync Backend Loaded Successfully!")
