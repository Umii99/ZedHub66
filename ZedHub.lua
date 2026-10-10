--[[
    ZEDHUB - MIDNIGHT SLATE & NEON BLUE (FULL UI + AUTO BUY SEED, EGG, GEAR)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Ambil Referensi Remote Events & Shop
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents", 5) or ReplicatedStorage
local shop = rawget(getgenv(), "shop") or {}

if PlayerGui:FindFirstChild("ZedHubStrictUI") then
    PlayerGui.ZedHubStrictUI:Destroy()
end

-- =========================================================================
-- CONFIGURATION STATE (DENGAN 3 SHOP UTAMA)
-- =========================================================================
getgenv().ZedHubConfig = {
    MainShopBuy = {
        MainEgg = { Active = false, BuyAll = false, Items = {} },
        MainSeed = { Active = false, BuyAll = false, Items = {} },
        MainGear = { Active = false, BuyAll = false, Items = {} }
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubStrictUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Floating Button (Minimize State)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Parent = ScreenGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(11, 17, 30)
FloatingBtn.BorderColor3 = Color3.fromRGB(59, 130, 246)
FloatingBtn.BorderSizePixel = 1
FloatingBtn.Position = UDim2.new(0, 15, 0, 15)
FloatingBtn.Size = UDim2.new(0, 130, 0, 38)
FloatingBtn.Visible = false
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "🪐 ZedHub [Buka]"
FloatingBtn.TextColor3 = Color3.fromRGB(96, 165, 250)
FloatingBtn.TextSize = 13.5
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 8)

-- Main Frame (Midnight Slate Dark Base)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 30)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 520, 0, 380)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(59, 130, 246)
MainStroke.Thickness = 1.5

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
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🪐 ZedHub  Grow A Garden"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Minimize (-) & Close (X)
local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeBtn.Position = UDim2.new(1, -58, 0.5, -10)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 15
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- Body Layout
local Body = Instance.new("Frame", MainFrame)
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 32)
Body.Size = UDim2.new(1, 0, 1, -32)

-- Sidebar Kiri Utama
local Sidebar = Instance.new("ScrollingFrame", Body)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 125, 1, 0)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2
local SBLayout = Instance.new("UIListLayout", Sidebar)
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 3)

-- Content Holder Kanan
local ContentHolder = Instance.new("Frame", Body)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Position = UDim2.new(0, 130, 0, 0)
ContentHolder.Size = UDim2.new(1, -130, 1, 0)

-- Fungsi Tab Asli
local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame", ContentHolder)
    Page.Name = tabName .. "Page"
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, -8, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 1500)
    Page.ScrollBarThickness = 3
    Page.Visible = false

    local PLayout = Instance.new("UIListLayout", Page)
    PLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PLayout.Padding = UDim.new(0, 6)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    TabBtn.BackgroundTransparency = 0.6
    TabBtn.Size = UDim2.new(1, -6, 0, 32)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = "    " .. tabName
    TabBtn.TextColor3 = Color3.fromRGB(160, 175, 200)
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)

    local TabStroke = Instance.new("UIStroke", TabBtn)
    TabStroke.Color = Color3.fromRGB(59, 130, 246)
    TabStroke.Transparency = 1

    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
                child.BackgroundTransparency = 0.6
                child.TextColor3 = Color3.fromRGB(160, 175, 200)
                local stroke = child:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Transparency = 1 end
            end
        end

        for _, p in pairs(ContentHolder:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end

        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 58, 138)
        TabBtn.BackgroundTransparency = 0.2
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabStroke.Transparency = 0
    end)

    if #ContentHolder:GetChildren() == 1 then
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 58, 138)
        TabBtn.BackgroundTransparency = 0.2
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabStroke.Transparency = 0
    end

    return Page
end

local TabShop = CreateTab("Shop")

-- Fungsi Accordion Section Asli
local function CreateAccordionSection(parent, titleText)
    local sec = Instance.new("Frame", parent)
    sec.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    sec.BackgroundTransparency = 0.3
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 5)

    local mainLayout = Instance.new("UIListLayout", sec)
    mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mainLayout.Padding = UDim.new(0, 6)

    local headerBtn = Instance.new("TextButton", sec)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Size = UDim2.new(1, 0, 0, 32)
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.Text = "  🔹 " .. titleText
    headerBtn.TextColor3 = Color3.fromRGB(147, 197, 253)
    headerBtn.TextSize = 15
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left

    local container = Instance.new("Frame", sec)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y

    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 6)

    local padding = Instance.new("UIPadding", container)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)

    return container
end

-- Fungsi Selected Dropdown Asli Kamu (Pop-up aman di layar)
local function CreateSelectedDropdown(parentSec, titleText, itemsTable, onItemsChanged)
    local dropFrame = Instance.new("Frame", parentSec)
    dropFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    dropFrame.BackgroundTransparency = 0.5
    dropFrame.Size = UDim2.new(1, 0, 0, 32)
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 4)

    local dropBtn = Instance.new("TextButton", dropFrame)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    dropBtn.BackgroundTransparency = 0.4
    dropBtn.Size = UDim2.new(1, 0, 1, 0)
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.Text = "  📂 " .. titleText
    dropBtn.TextColor3 = Color3.fromRGB(147, 197, 253)
    dropBtn.TextSize = 14.5
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 4)

    local summaryLabel = Instance.new("TextLabel", dropBtn)
    summaryLabel.BackgroundTransparency = 1
    summaryLabel.Position = UDim2.new(1, -160, 0, 0)
    summaryLabel.Size = UDim2.new(0, 140, 1, 0)
    summaryLabel.Font = Enum.Font.GothamBold
    summaryLabel.Text = "[0 Selected]"
    summaryLabel.TextColor3 = Color3.fromRGB(96, 165, 250)
    summaryLabel.TextSize = 12.5
    summaryLabel.TextXAlignment = Enum.TextXAlignment.Right

    local popupOverlay = Instance.new("Frame", ScreenGui)
    popupOverlay.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    popupOverlay.Size = UDim2.new(0, 260, 0, 220)
    popupOverlay.Position = UDim2.new(0.5, -130, 0.5, -110)
    popupOverlay.Visible = false
    popupOverlay.ZIndex = 50
    Instance.new("UICorner", popupOverlay).CornerRadius = UDim.new(0, 8)
    
    local popupStroke = Instance.new("UIStroke", popupOverlay)
    popupStroke.Color = Color3.fromRGB(59, 130, 246)
    popupStroke.Thickness = 1.5

    local popupHeader = Instance.new("Frame", popupOverlay)
    popupHeader.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    popupHeader.Size = UDim2.new(1, 0, 0, 30)
    popupHeader.ZIndex = 51
    Instance.new("UICorner", popupHeader).CornerRadius = UDim.new(0, 8)

    local popupTitle = Instance.new("TextLabel", popupHeader)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Position = UDim2.new(0, 10, 0, 0)
    popupTitle.Size = UDim2.new(1, -30, 1, 0)
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.Text = "⚙️ " .. titleText
    popupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    popupTitle.TextSize = 13
    popupTitle.TextXAlignment = Enum.TextXAlignment.Left
    popupTitle.ZIndex = 52

    local closePop = Instance.new("TextButton", popupHeader)
    closePop.BackgroundTransparency = 1
    closePop.Position = UDim2.new(1, -25, 0, 0)
    closePop.Size = UDim2.new(0, 25, 1, 0)
    closePop.Font = Enum.Font.GothamBold
    closePop.Text = "X"
    closePop.TextColor3 = Color3.fromRGB(239, 68, 68)
    closePop.TextSize = 13
    closePop.ZIndex = 52

    local listContainer = Instance.new("ScrollingFrame", popupOverlay)
    listContainer.BackgroundTransparency = 1
    listContainer.Position = UDim2.new(0, 5, 0, 35)
    listContainer.Size = UDim2.new(1, -10, 1, -40)
    listContainer.CanvasSize = UDim2.new(0, 0, 0, (#itemsTable * 30))
    listContainer.ScrollBarThickness = 3
    listContainer.ZIndex = 51

    local listLayout = Instance.new("UIListLayout", listContainer)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)

    local selectedItems = {}

    for _, itemName in ipairs(itemsTable) do
        local itemBtn = Instance.new("TextButton", listContainer)
        itemBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
        itemBtn.Size = UDim2.new(1, 0, 0, 26)
        itemBtn.Font = Enum.Font.GothamBold
        itemBtn.Text = "    " .. itemName
        itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemBtn.TextSize = 12
        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
        itemBtn.ZIndex = 52
        Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 3)

        local isSelected = false
        itemBtn.MouseButton1Click:Connect(function()
            isSelected = not isSelected
            if isSelected then
                itemBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
                table.insert(selectedItems, itemName)
            else
                itemBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
                for i, v in ipairs(selectedItems) do
                    if v == itemName then table.remove(selectedItems, i) end
                end
            end
            summaryLabel.Text = (#selectedItems == 0) and "[0 Selected]" or "[" .. #selectedItems .. " Selected]"
            if onItemsChanged then onItemsChanged(selectedItems) end
        end)
    end

    dropBtn.MouseButton1Click:Connect(function() popupOverlay.Visible = not popupOverlay.Visible end)
    closePop.MouseButton1Click:Connect(function() popupOverlay.Visible = false end)

    return dropFrame
end

-- Fungsi Action Toggle Asli
local function CreateActionToggle(parentSec, text, callback)
    local row = Instance.new("TextButton", parentSec)
    row.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    row.BackgroundTransparency = 0.5
    row.Size = UDim2.new(1, 0, 0, 28)
    row.AutoButtonColor = false
    row.Font = Enum.Font.GothamBold
    row.Text = "    ⚡ " .. text
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.TextSize = 13.5
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        row.BackgroundColor3 = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(30, 41, 59)
        if callback then callback(state) end
    end)
    return row
end

-- === MEMBUAT MENU DI TAB SHOP (EGG, SEED, GEAR) ===
local SecShopEgg = CreateAccordionSection(TabShop, "SHOP EGG")
CreateSelectedDropdown(SecShopEgg, "Shop Egg List", {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythichal Egg", "Bugg Egg", "Junggle Egg"}, function(items) 
    getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items = items 
end)
CreateActionToggle(SecShopEgg, "Auto Buy (Selected)", function(state) 
    getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active = state 
end)
CreateActionToggle(SecShopEgg, "Auto Buy All", function(state) 
    getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll = state 
end)

local SecShopSeed = CreateAccordionSection(TabShop, "SHOP SEED")
CreateSelectedDropdown(SecShopSeed, "Shop Seed List", {"Carrot", "Strawberry", "Blueberry", "Tomato", "Buttercup", "Daffodil", "Corn", "Tulip", "Bamboo", "Watermelon", "Pumpkin", "Coconut", "Manggo", "Pineapple", "Apple", "Grape", "Dragon Fruit", "Cactus", "Papper", "Mushroom"}, function(items) 
    getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items = items 
end)
CreateActionToggle(SecShopSeed, "Auto Buy (Selected)", function(state) 
    getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active = state 
end)
CreateActionToggle(SecShopSeed, "Auto Buy All", function(state) 
    getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll = state 
end)

local SecShopGear = CreateAccordionSection(TabShop, "SHOP GEAR")
CreateSelectedDropdown(SecShopGear, "Shop Gear List", {"Advanced Sprinkler", "Grandmaster", "Godly Sprinkler", "Master Sprinkler", "Basic Sprinkler", "Harvest Tools", "Favorite Tools", "Recall Wrench"}, function(items) 
    getgenv().ZedHubConfig.MainShopBuy.MainGear.Items = items 
end)
CreateActionToggle(SecShopGear, "Auto Buy (Selected)", function(state) 
    getgenv().ZedHubConfig.MainShopBuy.MainGear.Active = state 
end)
CreateActionToggle(SecShopGear, "Auto Buy All", function(state) 
    getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll = state 
end)


-- =========================================================================
-- BACKEND LOOP AUTO BUY (MENGHUBUNGKAN TOMBOL UI KE GAME FIRESERVER)
-- =========================================================================
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local getStock = shop.GetStockGeneric or function(container, mode, item) return item end

            -- 1. Auto Buy Seeds
            if getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active then
                for _, seedName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items) do
                    local stockItem = getStock(PlayerGui.Seed_Shop.Frame.ScrollingFrame, "Normal", seedName)
                    if stockItem and gameEvents:FindFirstChild("BuySeedStock") then
                        gameEvents.BuySeedStock:FireServer("Shop", stockItem)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll then
                local stockItem = getStock(PlayerGui.Seed_Shop.Frame.ScrollingFrame, "Normal", "no")
                if stockItem and gameEvents:FindFirstChild("BuySeedStock") then
                    gameEvents.BuySeedStock:FireServer("Shop", stockItem)
                end
            end

            -- 2. Auto Buy Eggs
            if getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active then
                for _, eggName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items) do
                    local stockItem = getStock(PlayerGui.PetShop_UI.Frame.ScrollingFrame, "Normal", eggName)
                    if stockItem and gameEvents:FindFirstChild("BuyPetEgg") then
                        gameEvents.BuyPetEgg:FireServer(stockItem)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll then
                local stockItem = getStock(PlayerGui.PetShop_UI.Frame.ScrollingFrame, "Normal", "no")
                if stockItem and gameEvents:FindFirstChild("BuyPetEgg") then
                    gameEvents.BuyPetEgg:FireServer(stockItem)
                end
            end

            -- 3. Auto Buy Gears
            if getgenv().ZedHubConfig.MainShopBuy.MainGear.Active then
                for _, gearName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainGear.Items) do
                    local stockItem = getStock(PlayerGui.Gear_Shop.Frame.ScrollingFrame, "Normal", gearName)
                    if stockItem and gameEvents:FindFirstChild("BuyGearStock") then
                        gameEvents.BuyGearStock:FireServer(stockItem)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll then
                local stockItem = getStock(PlayerGui.Gear_Shop.Frame.ScrollingFrame, "Normal", "no")
                if stockItem and gameEvents:FindFirstChild("BuyGearStock") then
                    gameEvents.BuyGearStock:FireServer(stockItem)
                end
            end
        end)
    end
end)

-- Kontrol Jendela (Minimize, Close, Drag)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false FloatingBtn.Visible = true end)
FloatingBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true FloatingBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

print("ZedHub UI Asli + Auto Buy Integrasi 3 Shop Berhasil Dimuat!")
