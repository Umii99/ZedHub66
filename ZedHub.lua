--[[
    ZEDHUB - HIPHUB EXACT STYLE POPUP DROPDOWN (GROW A GARDEN)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
    AllowSellIfBackpackFull = false,
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
ScreenGui.Parent = PlayerGui

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

-- Main Frame (Proporsi Hiphub: 520 x 310)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 30)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 520, 0, 310)
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
TopBar.Size = UDim2.new(1, 0, 0, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
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
FPSLabel.Position = UDim2.new(1, -110, 0.5, -9)
FPSLabel.Size = UDim2.new(0, 45, 0, 18)
FPSLabel.Font = Enum.Font.GothamMedium
FPSLabel.Text = "60 FPS"
FPSLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FPSLabel.TextSize = 9.5
Instance.new("UICorner", FPSLabel).CornerRadius = UDim.new(0, 4)

-- Tombol Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeBtn.Position = UDim2.new(1, -55, 0.5, -9)
MinimizeBtn.Size = UDim2.new(0, 18, 0, 18)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 13
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -9)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 9.5
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

-- Body Layout
local Body = Instance.new("Frame", MainFrame)
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 30)
Body.Size = UDim2.new(1, 0, 1, -30)

-- Sidebar Kiri Utama
local Sidebar = Instance.new("ScrollingFrame", Body)
Sidebar.BackgroundColor3 = Color3.fromRGB(2, 6, 23)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2
local SBLayout = Instance.new("UIListLayout", Sidebar)
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 3)

-- User Profile Box di Bawah Sidebar
local UserBox = Instance.new("Frame", Sidebar)
UserBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
UserBox.Size = UDim2.new(1, -6, 0, 34)
UserBox.Position = UDim2.new(0, 3, 0, 210)
Instance.new("UICorner", UserBox).CornerRadius = UDim.new(0, 5)
local UserTxt = Instance.new("TextLabel", UserBox)
UserTxt.BackgroundTransparency = 1
UserTxt.Size = UDim2.new(1, 0, 1, 0)
UserTxt.Font = Enum.Font.GothamBold
UserTxt.Text = "  👤 user_123\n  💎 Premium"
UserTxt.TextColor3 = Color3.fromRGB(148, 163, 184)
UserTxt.TextSize = 9

-- Content Holder Kanan
local ContentHolder = Instance.new("Frame", Body)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Position = UDim2.new(0, 125, 0, 0)
ContentHolder.Size = UDim2.new(1, -125, 1, 0)

-- Fungsi Tab dengan Gaya Highlighting Premium
local function CreateTab(tabName)
    local Page = Instance.new("ScrollingFrame", ContentHolder)
    Page.Name = tabName .. "Page"
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, -8, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 2500)
    Page.ScrollBarThickness = 3
    Page.Visible = false

    local PLayout = Instance.new("UIListLayout", Page)
    PLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PLayout.Padding = UDim.new(0, 6)

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    TabBtn.BackgroundTransparency = 0.6
    TabBtn.Size = UDim2.new(1, -6, 0, 28)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = "    " .. tabName
    TabBtn.TextColor3 = Color3.fromRGB(160, 175, 200)
    TabBtn.TextSize = 11
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

local TabInfo = CreateTab("Info")
local TabEvent = CreateTab("Event")
local TabShop = CreateTab("Shop")
local TabSelling = CreateTab("Auto Selling")
local TabSettings = CreateTab("Settings")

local function CreateAccordionSection(parent, titleText)
    local sec = Instance.new("Frame", parent)
    sec.BackgroundColor3 = Color3.fromRGB(3, 7, 18)
    sec.BackgroundTransparency = 0.4
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 5)
    
    local stroke = Instance.new("UIStroke", sec)
    stroke.Color = Color3.fromRGB(59, 130, 246)
    stroke.Transparency = 0.6

    local mainLayout = Instance.new("UIListLayout", sec)
    mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mainLayout.Padding = UDim.new(0, 5)

    local headerBtn = Instance.new("TextButton", sec)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Size = UDim2.new(1, 0, 0, 28)
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.Text = "  🔹 " .. titleText
    headerBtn.TextColor3 = Color3.fromRGB(147, 197, 253)
    headerBtn.TextSize = 13
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left

    local chevron = Instance.new("TextLabel", headerBtn)
    chevron.BackgroundTransparency = 1
    chevron.Position = UDim2.new(1, -22, 0, 0)
    chevron.Size = UDim2.new(0, 18, 1, 0)
    chevron.Font = Enum.Font.GothamBold
    chevron.Text = "▲"
    chevron.TextColor3 = Color3.fromRGB(147, 197, 253)
    chevron.TextSize = 10.5

    local container = Instance.new("Frame", sec)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ClipsDescendants = true

    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 5)

    local padding = Instance.new("UIPadding", container)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)

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
    row.Size = UDim2.new(1, 0, 0, 24)
    row.AutoButtonColor = false
    row.Font = Enum.Font.Gotham
    row.Text = "    " .. text
    row.TextColor3 = Color3.fromRGB(210, 220, 240)
    row.TextSize = 10.5
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

    local box = Instance.new("Frame", row)
    box.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    box.Position = UDim2.new(1, -18, 0.5, -5)
    box.Size = UDim2.new(0, 10, 0, 10)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 2)

    local check = Instance.new("TextLabel", box)
    check.BackgroundTransparency = 1
    check.Size = UDim2.new(1, 0, 1, 0)
    check.Font = Enum.Font.GothamBold
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 8.5

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

-- Dropdown Hiphub Exact Style: Floating Overlay Popup Menu
local function CreateSelectedDropdown(parentSec, titleText, itemsTable, onItemsChanged)
    local dropFrame = Instance.new("Frame", parentSec)
    dropFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
    dropFrame.BackgroundTransparency = 0.5
    dropFrame.Size = UDim2.new(1, 0, 0, 26)
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 4)

    local dropBtn = Instance.new("TextButton", dropFrame)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    dropBtn.BackgroundTransparency = 0.4
    dropBtn.Size = UDim2.new(1, 0, 1, 0)
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.Text = "  📂 " .. titleText
    dropBtn.TextColor3 = Color3.fromRGB(147, 197, 253)
    dropBtn.TextSize = 10.5
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 4)

    local summaryLabel = Instance.new("TextLabel", dropBtn)
    summaryLabel.BackgroundTransparency = 1
    summaryLabel.Position = UDim2.new(1, -155, 0, 0)
    summaryLabel.Size = UDim2.new(0, 130, 1, 0)
    summaryLabel.Font = Enum.Font.GothamBold
    summaryLabel.Text = "[0 Selected]"
    summaryLabel.TextColor3 = Color3.fromRGB(96, 165, 250)
    summaryLabel.TextSize = 10
    summaryLabel.TextXAlignment = Enum.TextXAlignment.Right

    local dropArrow = Instance.new("TextLabel", dropBtn)
    dropArrow.BackgroundTransparency = 1
    dropArrow.Position = UDim2.new(1, -20, 0, 0)
    dropArrow.Size = UDim2.new(0, 15, 1, 0)
    dropArrow.Font = Enum.Font.GothamBold
    dropArrow.Text = "▼"
    dropArrow.TextColor3 = Color3.fromRGB(147, 197, 253)
    dropArrow.TextSize = 9

    -- Pop-up Floating Overlay persis ala Hiphub di tengah/atas menu utama
    local popupOverlay = Instance.new("Frame", ScreenGui)
    popupOverlay.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
    popupOverlay.BackgroundTransparency = 0.15
    popupOverlay.Size = UDim2.new(0, 240, 0, 185)
    popupOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
    popupOverlay.Position = UDim2.new(0.5, 0, 0.5, 0)
    popupOverlay.Visible = false
    popupOverlay.ZIndex = 10
    Instance.new("UICorner", popupOverlay).CornerRadius = UDim.new(0, 8)

    local popupStroke = Instance.new("UIStroke", popupOverlay)
    popupStroke.Color = Color3.fromRGB(59, 130, 246)
    popupStroke.Thickness = 1.5

    -- Header Pop-up (Judul & Tombol Close / Tab Mini ala Hiphub)
    local popupHeader = Instance.new("Frame", popupOverlay)
    popupHeader.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    popupHeader.Size = UDim2.new(1, 0, 0, 28)
    popupHeader.ZIndex = 11
    Instance.new("UICorner", popupHeader).CornerRadius = UDim.new(0, 8)

    local popupTitle = Instance.new("TextLabel", popupHeader)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Position = UDim2.new(0, 10, 0, 0)
    popupTitle.Size = UDim2.new(0, 160, 1, 0)
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.Text = "⚙️ " .. titleText
    popupTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
    popupTitle.TextSize = 11
    popupTitle.TextXAlignment = Enum.TextXAlignment.Left
    popupTitle.ZIndex = 12

    local popupClose = Instance.new("TextButton", popupHeader)
    popupClose.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    popupClose.Position = UDim2.new(1, -24, 0.5, -9)
    popupClose.Size = UDim2.new(0, 18, 0, 18)
    popupClose.Font = Enum.Font.GothamBold
    popupClose.Text = "X"
    popupClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    popupClose.TextSize = 9
    popupClose.ZIndex = 12
    Instance.new("UICorner", popupClose).CornerRadius = UDim.new(0, 4)

    -- Container Konten di dalam Pop-up (Search Bar + List)
    local popupBody = Instance.new("Frame", popupOverlay)
    popupBody.BackgroundTransparency = 1
    popupBody.Position = UDim2.new(0, 0, 0, 32)
    popupBody.Size = UDim2.new(1, 0, 1, -32)
    popupBody.ZIndex = 11

    local pbLayout = Instance.new("UIListLayout", popupBody)
    pbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pbLayout.Padding = UDim.new(0, 4)

    local pbPadding = Instance.new("UIPadding", popupBody)
    pbPadding.PaddingTop = UDim.new(0, 4)
    pbPadding.PaddingLeft = UDim.new(0, 6)
    pbPadding.PaddingRight = UDim.new(0, 6)
    pbPadding.PaddingBottom = UDim.new(0, 6)

    -- Kotak Search di dalam Pop-up
    local searchBox = Instance.new("TextBox", popupBody)
    searchBox.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
    searchBox.BackgroundTransparency = 0.3
    searchBox.Size = UDim2.new(1, 0, 0, 24)
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "🔍 Search item..."
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(240, 240, 255)
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 135, 160)
    searchBox.TextSize = 11
    searchBox.ZIndex = 12
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

    -- Scrolling List Container di dalam Pop-up
    local listContainer = Instance.new("ScrollingFrame", popupBody)
    listContainer.BackgroundTransparency = 1
    listContainer.Size = UDim2.new(1, 0, 0, 118)
    listContainer.CanvasSize = UDim2.new(0, 0, 0, (#itemsTable * 26) + 10)
    listContainer.ScrollBarThickness = 3
    listContainer.ZIndex = 12

    local listLayout = Instance.new("UIListLayout", listContainer)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)

    local selectedItems = {}
    local itemRows = {}

    for _, itemName in ipairs(itemsTable) do
        local itemRow = Instance.new("TextButton", listContainer)
        itemRow.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
        itemRow.BackgroundTransparency = 0.5
        itemRow.Size = UDim2.new(1, 0, 0, 23)
        itemRow.AutoButtonColor = false
        itemRow.Font = Enum.Font.GothamMedium
        itemRow.Text = "    " .. itemName
        itemRow.TextColor3 = Color3.fromRGB(200, 215, 240)
        itemRow.TextSize = 11
        itemRow.TextXAlignment = Enum.TextXAlignment.Left
        itemRow.ZIndex = 13
        Instance.new("UICorner", itemRow).CornerRadius = UDim.new(0, 3)

        table.insert(itemRows, {Btn = itemRow, Name = itemName})

        local isSelected = false
        itemRow.MouseButton1Click:Connect(function()
            isSelected = not isSelected
            
            if isSelected then
                itemRow.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
                itemRow.BackgroundTransparency = 0.1
                itemRow.TextColor3 = Color3.fromRGB(255, 255, 255)
                table.insert(selectedItems, itemName)
            else
                itemRow.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
                itemRow.BackgroundTransparency = 0.5
                itemRow.TextColor3 = Color3.fromRGB(200, 215, 240)
                for i, v in ipairs(selectedItems) do
                    if v == itemName then table.remove(selectedItems, i) end
                end
            end

            if #selectedItems == 0 then
                summaryLabel.Text = "[0 Selected]"
            elseif #selectedItems == 1 then
                summaryLabel.Text = "[" .. selectedItems[1] .. "]"
            else
                summaryLabel.Text = "[" .. #selectedItems .. " Items Selected]"
            end
            
            if onItemsChanged then onItemsChanged(selectedItems) end
        end)
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        local visibleCount = 0
        for _, rowData in ipairs(itemRows) do
            if query == "" or string.find(rowData.Name:lower(), query) then
                rowData.Btn.Visible = true
                visibleCount = visibleCount + 1
            else
                rowData.Btn.Visible = false
            end
        end
        listContainer.CanvasSize = UDim2.new(0, 0, 0, (visibleCount * 26) + 10)
    end)

    local isListOpen = false
    dropBtn.MouseButton1Click:Connect(function()
        isListOpen = not isListOpen
        popupOverlay.Visible = isListOpen
        dropArrow.Text = isListOpen and "▲" or "▼"
    end)

    popupClose.MouseButton1Click:Connect(function()
        isListOpen = false
        popupOverlay.Visible = false
        dropArrow.Text = "▼"
        searchBox.Text = ""
    end)

    return dropFrame
end

local function CreateActionToggle(parentSec, text, callback)
    local row = Instance.new("TextButton", parentSec)
    row.BackgroundColor3 = Color3.fromRGB(30, 27, 75)
    row.BackgroundTransparency = 0.3
    row.Size = UDim2.new(1, 0, 0, 26)
    row.AutoButtonColor = false
    row.Font = Enum.Font.GothamBold
    row.Text = "    ⚡ " .. text
    row.TextColor3 = Color3.fromRGB(234, 179, 8)
    row.TextSize = 10.5
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

    local box = Instance.new("Frame", row)
    box.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
    box.Position = UDim2.new(1, -18, 0.5, -5)
    box.Size = UDim2.new(0, 10, 0, 10)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 2)

    local check = Instance.new("TextLabel", box)
    check.BackgroundTransparency = 1
    check.Size = UDim2.new(1, 0, 1, 0)
    check.Font = Enum.Font.GothamBold
    check.Text = ""
    check.TextColor3 = Color3.fromRGB(255, 255, 255)
    check.TextSize = 8.5

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(234, 179, 8) or Color3.fromRGB(60, 40, 20)
        check.Text = state and "✓" or ""
        if callback then callback(state) end
    end)
    return row
end

-- === TAB EVENT & SHOP ===
local SecFallHarvest = CreateAccordionSection(TabEvent, "FALL HARVEST")
CreateToggle(SecFallHarvest, "Required Collection Plant", function(state) getgenv().ZedHubConfig.AutoCollect = state end)
CreateToggle(SecFallHarvest, "Required Submit Plant", function(state) getgenv().ZedHubConfig.AutoSubmit = state end)

local SecFallShop = CreateAccordionSection(TabEvent, "FALL SHOP")
CreateSelectedDropdown(SecFallShop, "Fall Shop Pets & Egg", {"Fall Egg", "Salmon", "Chipmunk", "Woodpecker", "Red Squirrel", "Marmot", "Mallard", "Sugar Glider", "Space Squirrel", "Red Panda"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallPets.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Pets & Egg On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallPets.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Cosmetic & Crate", {"Fall Leaf Chair", "Fall Crate", "Maple Flag", "Maple Wreath", "Fall Haybale", "Pile Of Leaves", "Flying Kit", "Autumn Crate", "Fall Mountain"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Cosmetic & Crate On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Seed & Seed Pack", {"Turnip Seed", "Parsley Seed", "Autumn Seed Pack", "Meyers Lemon", "Carnival Pumpkin", "Golden Peach", "Kniphopia", "Maple Resin"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Seed & Seed Pack On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Active = state end)

CreateSelectedDropdown(SecFallShop, "Fall Shop Gear", {"Firefly Jar", "Sky Lantern", "Maple Leaf Kite", "Maple Blower", "Maple Syrup", "Maple Sprinkler", "Bonfire", "Harvest Basket", "Acorn Lollipop", "Golden Acorn"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallGear.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Gear On/Off", function(state) getgenv().ZedHubConfig.FallMarketBuy.FallGear.Active = state end)

local SecShadyScarecrown = CreateAccordionSection(TabEvent, "SHADY SCARECROW")
CreateSelectedDropdown(SecShadyScarecrown, "Selected Seed", {"All Seed", "Gold Egg Seed"}, function(items)
    if #items > 0 then getgenv().ZedHubConfig.ShadyScarecrowMode = (items[#items] == "All Seed") and "ALL_SEED" or "GOLD_EGG_SEED" end
end)
CreateActionToggle(SecShadyScarecrown, "Give A Seed On/Off", function(state) getgenv().ZedHubConfig.GiveASeed = state end)

local SecAutoAcorn = CreateAccordionSection(TabEvent, "AUTO ACORN")
CreateActionToggle(SecAutoAcorn, "Auto Shovel Acorn On/Off", function(state) getgenv().ZedHubConfig.AutoShovel = state end)

local SecShopEgg = CreateAccordionSection(TabShop, "SHOP EGG")
CreateSelectedDropdown(SecShopEgg, "Shop Egg List", {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythichal Egg", "Bugg Egg", "Junggle Egg"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items = items end)
CreateActionToggle(SecShopEgg, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active = state end)
CreateActionToggle(SecShopEgg, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll = state end)

local SecShopSeed = CreateAccordionSection(TabShop, "SHOP SEED")
CreateSelectedDropdown(SecShopSeed, "Shop Seed List", {"Carrot", "Strawberry", "Blueberry", "Tomato", "Buttercup", "Daffodil", "Corn", "Tulip", "Bamboo", "Watermelon", "Pumpkin", "Coconut", "Manggo", "Pineapple", "Apple", "Grape", "Dragon Fruit", "Cactus", "Papper", "Mushroom", "Cacao Bean", "Beanstalk", "Ember Lily", "Suggar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco", "Crimson Thorn", "Zebra", "Zinkle", "Octobloom", "Alien Apple", "Aurum Spire"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items = items end)
CreateActionToggle(SecShopSeed, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active = state end)
CreateActionToggle(SecShopSeed, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll = state end)

local SecShopGear = CreateAccordionSection(TabShop, "SHOP GEAR")
CreateSelectedDropdown(SecShopGear, "Shop Gear List", {"Advanced Sprinkler", "Grandmaster", "Godly Sprinkler", "Master Sprinkler", "Basic Sprinkler", "Harvest Tools", "Favorite Tools", "Recall Wrench", "Cleaning Spray", "Cleansing Shard", "Level Up Lollipop"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainGear.Items = items end)
CreateActionToggle(SecShopGear, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.Active = state end)
CreateActionToggle(SecShopGear, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll = state end)


-- === TAB AUTO SELLING ===
local SecSell = CreateAccordionSection(TabSelling, "AUTO SELLING FRUIT")

CreateToggle(SecSell, "Allow Sell If Backpack Full", function(state)
    getgenv().ZedHubConfig.AllowSellIfBackpackFull = state
end)

CreateToggle(SecSell, "Auto Sell Fruit", function(state)
    getgenv().ZedHubConfig.AutoSellFruit = state
end)

local WebhookBody = CreateAccordionSection(TabInfo, "WEBHOOK")
local WebhookBox = Instance.new("TextBox", WebhookBody)
WebhookBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
WebhookBox.Size = UDim2.new(1, 0, 0, 28)
WebhookBox.Font = Enum.Font.Gotham
WebhookBox.PlaceholderText = "URL Webhook Discord..."
WebhookBox.Text = ""
WebhookBox.TextColor3 = Color3.fromRGB(240, 240, 255)
WebhookBox.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
WebhookBox.TextSize = 10.5
Instance.new("UICorner", WebhookBox).CornerRadius = UDim.new(0, 4)

local ServerBody = CreateAccordionSection(TabInfo, "SERVER")
local ServerRow = Instance.new("Frame", ServerBody)
ServerRow.BackgroundTransparency = 1
ServerRow.Size = UDim2.new(1, 0, 0, 28)

local ServerInput = Instance.new("TextBox", ServerRow)
ServerInput.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
ServerInput.Size = UDim2.new(0.68, 0, 1, 0)
ServerInput.Font = Enum.Font.Gotham
ServerInput.PlaceholderText = "2007"
ServerInput.Text = ""
ServerInput.TextColor3 = Color3.fromRGB(240, 240, 255)
ServerInput.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
ServerInput.TextSize = 10.5
Instance.new("UICorner", ServerInput).CornerRadius = UDim.new(0, 4)

local ClickBtn = Instance.new("TextButton", ServerRow)
ClickBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
ClickBtn.Position = UDim2.new(0.71, 0, 0, 0)
ClickBtn.Size = UDim2.new(0.29, 0, 1, 0)
ClickBtn.Font = Enum.Font.GothamBold
ClickBtn.Text = "Click"
ClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickBtn.TextSize = 10.5
Instance.new("UICorner", ClickBtn).CornerRadius = UDim.new(0, 4)


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

print("ZedHub Hiphub Exact Style Popup Dropdown UI Loaded Successfully!")
