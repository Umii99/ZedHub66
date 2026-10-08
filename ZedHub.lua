--[[
    ZEDHUB - FINAL STABLE EDITION (GROW A GARDEN)
    - Fix: Error sintaks yang membuat UI tidak muncul
    - Fix: Auto Sell bisa dimatikan normal & Backpack Full akurat
    - Fix: Shop Seed, Gear, & 4 Market Fall Aktif Sempurna
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ZedHubStrictUI") then
    PlayerGui.ZedHubStrictUI:Destroy()
end

-- =========================================================================
-- CONFIGURATION STATE
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

-- Floating Button
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

local Body = Instance.new("Frame", MainFrame)
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 34)
Body.Size = UDim2.new(1, 0, 1, -34)

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

local TabInfo = CreateTab("Info")
local TabEvent = CreateTab("Event")
local TabShop = CreateTab("Shop")
local TabSelling = CreateTab("Auto Selling")
local TabSettings = CreateTab("Settings")

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
        if callback then callback(state, text) end
    end)
    return row
end

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

-- =========================================================================
-- MAPPING KONTROL KE CONFIG
-- =========================================================================

local SecFallHarvest = CreateAccordionSection(TabEvent, "FALL HARVEST", Color3.fromRGB(251, 146, 60))
CreateToggle(SecFallHarvest, "Required Collection Plant", function(state) getgenv().ZedHubConfig.AutoCollect = state end)
CreateToggle(SecFallHarvest, "Required Submit Plant", function(state) getgenv().ZedHubConfig.AutoSubmit = state end)

local SecFallShop = CreateAccordionSection(TabEvent, "FALL SHOP", Color3.fromRGB(236, 72, 153))
CreateSelectedDropdown(SecFallShop, "Fall Shop Pets & Egg", {"Fall Egg", "Salmon", "Chipmunk", "Woodpecker", "Red Squirrel", "Marmot", "Mallard", "Sugar Glider", "Space Squirrel", "Red Panda"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallPets.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Pets & Egg On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallPets.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Cosmetic & Crate", {"Fall Leaf Chair", "Fall Crate", "Maple Flag", "Maple Wreath", "Fall Haybale", "Pile Of Leaves", "Flying Kit", "Autumn Crate", "Fall Mountain"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Cosmetic & Crate On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Seed & Seed Pack", {"Turnip Seed", "Parsley Seed", "Autumn Seed Pack", "Meyers Lemon", "Carnival Pumpkin", "Golden Peach", "Kniphopia", "Maple Resin"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Seed & Seed Pack On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Gear", {"Firefly Jar", "Sky Lantern", "Maple Leaf Kite", "Maple Blower", "Maple Syrup", "Maple Sprinkler", "Bonfire", "Harvest Basket", "Acorn Lollipop", "Golden Acorn"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallGear.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Gear On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallGear.Active = state end)

local SecShadyScarecrown = CreateAccordionSection(TabEvent, "SHADY SCARECROW", Color3.fromRGB(251, 191, 36))
CreateSelectedDropdown(SecShadyScarecrown, "Selected Seed", {"All Seed", "Gold Egg Seed"}, function(items)
    if #items > 0 then getgenv().ZedHubConfig.ShadyScarecrowMode = (items[#items] == "All Seed") and "ALL_SEED" or "GOLD_EGG_SEED" end
end)
CreateActionToggle(SecShadyScarecrown, "Give A Seed On/Off", function(state) getgenv().ZedHubConfig.GiveASeed = state end)

local SecAutoAcorn = CreateAccordionSection(TabEvent, "AUTO ACORN", Color3.fromRGB(56, 189, 248))
CreateActionToggle(SecAutoAcorn, "Auto Shovel Acorn On/Off", function(state) getgenv().ZedHubConfig.AutoShovel = state end)

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

local SecSell = CreateAccordionSection(TabSelling, "AUTO SELLING FRUIT", Color3.fromRGB(129, 140, 248))
CreateToggle(SecSell, "Auto Sell If Backpack Full", function(state) getgenv().ZedHubConfig.AutoSellBackpack = state end)
CreateToggle(SecSell, "Auto Sell Fruit", function(state) getgenv().ZedHubConfig.AutoSellFruit = state end)


-- =========================================================================
-- FULL FIXED MASTER BACKEND ENGINE
-- =========================================================================
local isProcessingScarecrow = false
local IsSelling = false

local function PreciseSellInventory()
    if IsSelling then return end
    IsSelling = true
    pcall(function()
        local character = LocalPlayer.Character
        if not character then IsSelling = false return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then IsSelling = false return end

        local previousCFrame = hrp.CFrame
        hrp.CFrame = CFrame.new(62, 4, -26)
        task.wait(0.4)

        if GameEvents and GameEvents:FindFirstChild("Sell_Inventory") then
            GameEvents.Sell_Inventory:FireServer()
        end
        task.wait(0.5)
        hrp.CFrame = previousCFrame
    end)
    IsSelling = false
end

-- Auto Sell Loop
task.spawn(function()
    while task.wait(2) do
        local backpackOn = getgenv().ZedHubConfig.AutoSellBackpack
        local fruitOn = getgenv().ZedHubConfig.AutoSellFruit

        if backpackOn or fruitOn then
            local count = 0
            pcall(function()
                for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if t:IsA("Tool") then count += 1 end
                end
                local char = LocalPlayer.Character
                if char then
                    for _, t in pairs(char:GetChildren()) do
                        if t:IsA("Tool") then count += 1 end
                    end
                end
            end)

            if fruitOn or (backpackOn and count >= 12) then
                PreciseSellInventory()
                task.wait(3)
            end
        end
    end
end)

local function GetEventRequiredItemName()
    if not PlayerGui then return nil end
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui.Name:lower():find("event") or gui.Name:lower():find("fall") or gui.Name:lower():find("bloom") then
            for _, desc in pairs(gui:GetDescendants()) do
                if desc:IsA("TextLabel") and (desc.Text:lower():find("need") or desc.Text:lower():find("require") or desc.Text:lower():find("/")) then
                    return desc.Text
                end
            end
        end
    end
    return nil
end

-- Auto Collect Required
task.spawn(function()
    while task.wait(1.5) do
        if getgenv().ZedHubConfig.AutoCollect then
            pcall(function()
                local requiredKeyword = GetEventRequiredItemName()
                local myFarm = Workspace:FindFirstChild("Farm")
                if myFarm then
                    for _, plant in pairs(myFarm:GetDescendants()) do
                        if plant:IsA("Model") or plant:IsA("Part") then
                            local pName = plant.Name:lower()
                            local match = false
                            if requiredKeyword and pName:find(requiredKeyword:lower()) then
                                match = true
                            elseif not requiredKeyword and (pName:find("fall") or pName:find("bloom") or pName:find("event")) then
                                match = true
                            end

                            if match then
                                local prompt = plant:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt and prompt.Enabled then
                                    fireproximityprompt(prompt)
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Submit Plant
task.spawn(function()
    while task.wait(2.5) do
        if getgenv().ZedHubConfig.AutoSubmit then
            pcall(function()
                local needed = GetEventRequiredItemName()
                local backpack = LocalPlayer.Backpack
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and (not needed or tool.Name:lower():find(needed:lower()) or tool.Name:lower():find("fall")) then
                        local submitEvt = GameEvents and (GameEvents:FindFirstChild("SubmitFallPlant") or GameEvents:FindFirstChild("SubmitEvent"))
                        if submitEvt then
                            submitEvt:FireServer(tool)
                            task.wait(0.4)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Buy Engine
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
                        buyEvt:FireServer(catName, itemName)
                        task.wait(0.25)
                    end
                end
            end
        end)
    end
end)

-- Shady Scarecrow Automation
local function EquipSpecificSeed(mode)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    if not character then return false end
    local keywords = (mode == "GOLD_EGG_SEED") and {"gold", "egg", "golden"} or {"seed"}

    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool then
        local tName = currentTool.Name:lower()
        for _, kw in pairs(keywords) do if tName:find(kw) then return true end end
    end

    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            local iName = item.Name:lower()
            for _, kw in pairs(keywords) do
                if iName:find(kw) then
                    if currentTool then currentTool.Parent = backpack end
                    item.Parent = character
                    task.wait(0.4)
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while task.wait(4) do
        if getgenv().ZedHubConfig.GiveASeed and not isProcessingScarecrow then
            pcall(function()
                isProcessingScarecrow = true
                local mode = getgenv().ZedHubConfig.ShadyScarecrowMode
                if EquipSpecificSeed(mode) then
                    local scarecrow = nil
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if obj.Name:lower():find("scarecrow") or obj.Name:lower():find("shady") then
                            scarecrow = obj
                            break
                        end
                    end

                    if scarecrow then
                        local npcPart = scarecrow:FindFirstChild("HumanoidRootPart") or scarecrow.PrimaryPart or scarecrow:FindFirstChildWhichIsA("BasePart")
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if npcPart and hrp then
                            local origin = hrp.CFrame
                            local dist = (hrp.Position - npcPart.Position).Magnitude
                            local tween = TweenService:Create(hrp, TweenInfo.new(dist / 25, Enum.EasingStyle.Linear), {CFrame = npcPart.CFrame + Vector3.new(0, 3, 0)})
                            tween:Play()
                            tween.Completed:Wait()
                            task.wait(0.3)

                            local giveEvt = GameEvents and GameEvents:FindFirstChild("ScarecrowGiveSeed")
                            if giveEvt then giveEvt:FireServer(mode)
                            else
                                local p = scarecrow:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if p then fireproximityprompt(p) end
                            end
                            task.wait(0.6)

                            local rTween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - origin.Position).Magnitude / 25, Enum.EasingStyle.Linear), {CFrame = origin})
                            rTween:Play()
                            rTween.Completed:Wait()
                        end
                    end
                end
                isProcessingScarecrow = false
            end)
        end
    end
end)

-- UI Window Controls
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

print("🪐 ZedHub Full Fixed & Stable Loaded Successfully!")
