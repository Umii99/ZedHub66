--[[
    ZEDHUB - MIDNIGHT SLATE & NEON BLUE (PREMIUM THEME + AUTO BUY INTEGRATION)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local playerGui = PlayerGui

-- Ambil Referensi Remote Events & Shop Module (Sesuaikan path game jika diperlukan)
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents", 5) or ReplicatedStorage
local shop = {} -- Placeholder atau modul asli game kamu jika ada

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
        Active = false,
        FallGear = { Items = {} },
        FallSeed = { Items = {} },
        FallPets = { Items = {} },
        FallCrate = { Items = {} }
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
MainStroke.Color = Color3.fromRGB(59, 130, 246) -- Neon Blue Border
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

-- FPS Label di Top Bar
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Parent = TopBar
FPSLabel.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
FPSLabel.Position = UDim2.new(1, -115, 0.5, -10)
FPSLabel.Size = UDim2.new(0, 48, 0, 20)
FPSLabel.Font = Enum.Font.GothamMedium
FPSLabel.Text = "60 FPS"
FPSLabel.TextColor3 = Color3.fromRGB(148, 163, 184)
FPSLabel.TextSize = 11
Instance.new("UICorner", FPSLabel).CornerRadius = UDim.new(0, 4)

-- Tombol Minimize (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeBtn.Position = UDim2.new(1, -58, 0.5, -10)
MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 15
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
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

-- User Profile Box di Bawah Sidebar
local UserBox = Instance.new("Frame", Sidebar)
UserBox.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
UserBox.Size = UDim2.new(1, -6, 0, 38)
UserBox.Position = UDim2.new(0, 3, 0, 210)
Instance.new("UICorner", UserBox).CornerRadius = UDim.new(0, 5)
local UserTxt = Instance.new("TextLabel", UserBox)
UserTxt.BackgroundTransparency = 1
UserTxt.Size = UDim2.new(1, 0, 1, 0)
UserTxt.Font = Enum.Font.GothamBold
UserTxt.Text = "  👤 user_123\n  💎 Premium"
UserTxt.TextColor3 = Color3.fromRGB(148, 163, 184)
UserTxt.TextSize = 10.5

-- Content Holder Kanan
local ContentHolder = Instance.new("Frame", Body)
ContentHolder.BackgroundColor3 = Color3.fromRGB(11, 17, 30)
ContentHolder.BackgroundTransparency = 1
ContentHolder.BorderSizePixel = 0
ContentHolder.Position = UDim2.new(0, 130, 0, 0)
ContentHolder.Size = UDim2.new(1, -130, 1, 0)

-- Fungsi Tab
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

local TabInfo = CreateTab("Info")
local TabEvent = CreateTab("Event")
local TabShop = CreateTab("Shop")
local TabSelling = CreateTab("Auto Selling")
local TabSettings = CreateTab("Settings")

-- Fungsi Accordion Section
local function CreateAccordionSection(parent, titleText)
    local sec = Instance.new("Frame", parent)
    sec.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    sec.BackgroundTransparency = 0.3
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 5)
    
    local stroke = Instance.new("UIStroke", sec)
    stroke.Color = Color3.fromRGB(59, 130, 246)
    stroke.Transparency = 0.5

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

    local chevron = Instance.new("TextLabel", headerBtn)
    chevron.BackgroundTransparency = 1
    chevron.Position = UDim2.new(1, -22, 0, 0)
    chevron.Size = UDim2.new(0, 18, 1, 0)
    chevron.Font = Enum.Font.GothamBold
    chevron.Text = "▲"
    chevron.TextColor3 = Color3.fromRGB(147, 197, 253)
    chevron.TextSize = 12

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

-- Fungsi Toggle Standar
local function CreateToggle(parentSec, text, callback)
    local row = Instance.new("TextButton", parentSec)
    row.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    row.BackgroundTransparency = 0.5
    row.Size = UDim2.new(1, 0, 0, 28)
    row.AutoButtonColor = false
    row.Font = Enum.Font.GothamBold
    row.Text = "    " .. text
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.TextSize = 13.5
    row.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

    local pill = Instance.new("Frame", row)
    pill.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    pill.Position = UDim2.new(1, -42, 0.5, -8)
    pill.Size = UDim2.new(0, 36, 0, 16)
    local pillCorner = Instance.new("UICorner", pill)
    pillCorner.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", pill)
    knob.BackgroundColor3 = Color3.fromRGB(148, 163, 184)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.Size = UDim2.new(0, 12, 0, 12)
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        if state then
            pill.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Position = UDim2.new(1, -14, 0.5, -6)
        else
            pill.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
            knob.BackgroundColor3 = Color3.fromRGB(148, 163, 184)
            knob.Position = UDim2.new(0, 2, 0.5, -6)
        end
        if callback then callback(state) end
    end)
    return row
end

-- Dropdown Pop-up dengan List Lengkap
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
    summaryLabel.Position = UDim2.new(1, -230, 0, 0)
    summaryLabel.Size = UDim2.new(0, 210, 1, 0)
    summaryLabel.Font = Enum.Font.GothamBold
    summaryLabel.Text = "[0 Selected]"
    summaryLabel.TextColor3 = Color3.fromRGB(96, 165, 250)
    summaryLabel.TextSize = 13.5
    summaryLabel.TextXAlignment = Enum.TextXAlignment.Right

    local dropArrow = Instance.new("TextLabel", dropBtn)
    dropArrow.BackgroundTransparency = 1
    dropArrow.Position = UDim2.new(1, -20, 0, 0)
    dropArrow.Size = UDim2.new(0, 15, 1, 0)
    dropArrow.Font = Enum.Font.GothamBold
    dropArrow.Text = "▼"
    dropArrow.TextColor3 = Color3.fromRGB(147, 197, 253)
    dropArrow.TextSize = 11

    local popupOverlay = Instance.new("Frame", ScreenGui)
    popupOverlay.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    popupOverlay.BackgroundTransparency = 0.05
    popupOverlay.Size = UDim2.new(0, 285, 0, 275)
    popupOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
    popupOverlay.Position = UDim2.new(0.69, 0, 0.55, 0)
    popupOverlay.Visible = false
    popupOverlay.ZIndex = 10
    Instance.new("UICorner", popupOverlay).CornerRadius = UDim.new(0, 8)

    local popupStroke = Instance.new("UIStroke", popupOverlay)
    popupStroke.Color = Color3.fromRGB(59, 130, 246)
    popupStroke.Thickness = 1.5

    local popupHeader = Instance.new("Frame", popupOverlay)
    popupHeader.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    popupHeader.Size = UDim2.new(1, 0, 0, 32)
    popupHeader.ZIndex = 11
    Instance.new("UICorner", popupHeader).CornerRadius = UDim.new(0, 8)

    local popupTitle = Instance.new("TextLabel", popupHeader)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Position = UDim2.new(0, 12, 0, 0)
    popupTitle.Size = UDim2.new(1, -20, 1, 0)
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.Text = "⚙️ " .. titleText
    popupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    popupTitle.TextSize = 13.5
    popupTitle.TextXAlignment = Enum.TextXAlignment.Left
    popupTitle.ZIndex = 12

    local popupBody = Instance.new("Frame", popupOverlay)
    popupBody.BackgroundTransparency = 1
    popupBody.Position = UDim2.new(0, 0, 0, 34)
    popupBody.Size = UDim2.new(1, 0, 1, -34)
    popupBody.ZIndex = 11

    local pbLayout = Instance.new("UIListLayout", popupBody)
    pbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pbLayout.Padding = UDim.new(0, 5)

    local pbPadding = Instance.new("UIPadding", popupBody)
    pbPadding.PaddingTop = UDim.new(0, 4)
    pbPadding.PaddingLeft = UDim.new(0, 8)
    pbPadding.PaddingRight = UDim.new(0, 8)
    pbPadding.PaddingBottom = UDim.new(0, 8)

    local searchBox = Instance.new("TextBox", popupBody)
    searchBox.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    searchBox.BackgroundTransparency = 0.3
    searchBox.Size = UDim2.new(1, 0, 0, 28)
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "🔍 Search item..."
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.PlaceholderColor3 = Color3.fromRGB(160, 185, 220)
    searchBox.TextSize = 13
    searchBox.ZIndex = 12
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

    local listContainer = Instance.new("ScrollingFrame", popupBody)
    listContainer.BackgroundTransparency = 1
    listContainer.Size = UDim2.new(1, 0, 0, 185)
    listContainer.CanvasSize = UDim2.new(0, 0, 0, (#itemsTable * 32) + 10)
    listContainer.ScrollBarThickness = 3
    listContainer.ZIndex = 12

    local listLayout = Instance.new("UIListLayout", listContainer)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)

    local selectedItems = {}
    local itemRows = {}

    for _, itemName in ipairs(itemsTable) do
        local itemRow = Instance.new("TextButton", listContainer)
        itemRow.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
        itemRow.BackgroundTransparency = 0.4
        itemRow.Size = UDim2.new(1, 0, 0, 28)
        itemRow.AutoButtonColor = false
        itemRow.Font = Enum.Font.GothamBold
        itemRow.Text = "    " .. itemName
        itemRow.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemRow.TextSize = 14.5
        itemRow.TextXAlignment = Enum.TextXAlignment.Left
        itemRow.ZIndex = 13
        Instance.new("UICorner", itemRow).CornerRadius = UDim.new(0, 3)

        table.insert(itemRows, {Btn = itemRow, Name = itemName})

        local isSelected = false
        itemRow.MouseButton1Click:Connect(function()
            isSelected = not isSelected
            
            if isSelected then
                itemRow.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
                itemRow.BackgroundTransparency = 0.1
                itemRow.TextColor3 = Color3.fromRGB(255, 255, 255)
                table.insert(selectedItems, itemName)
            else
                itemRow.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
                itemRow.BackgroundTransparency = 0.4
                itemRow.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        listContainer.CanvasSize = UDim2.new(0, 0, 0, (visibleCount * 32) + 10)
    end)

    local isListOpen = false
    dropBtn.MouseButton1Click:Connect(function()
        isListOpen = not isListOpen
        popupOverlay.Visible = isListOpen
        dropArrow.Text = isListOpen and "▲" or "▼"
    end)

    return dropFrame
end

-- Fungsi Action Toggle
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

    local pill = Instance.new("Frame", row)
    pill.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    pill.Position = UDim2.new(1, -42, 0.5, -8)
    pill.Size = UDim2.new(0, 36, 0, 16)
    local pillCorner = Instance.new("UICorner", pill)
    pillCorner.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", pill)
    knob.BackgroundColor3 = Color3.fromRGB(148, 163, 184)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.Size = UDim2.new(0, 12, 0, 12)
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local state = false
    row.MouseButton1Click:Connect(function()
        state = not state
        if state then
            pill.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Position = UDim2.new(1, -14, 0.5, -6)
        else
            pill.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
            knob.BackgroundColor3 = Color3.fromRGB(148, 163, 184)
            knob.Position = UDim2.new(0, 2, 0.5, -6)
        end
        if callback then callback(state) end
    end)
    return row
end

-- === TAB EVENT & SHOP ===
local SecFallShop = CreateAccordionSection(TabEvent, "FALL SHOP")
CreateSelectedDropdown(SecFallShop, "Select Fall Market Seed Shop", {"Turnip Seed", "Parsley Seed", "Autumn Seed Pack", "Meyers Lemon", "Carnival Pumpkin"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Fall Shop", function(state) getgenv().ZedHubConfig.FallMarketBuy.Active = state end)

local SecShopEgg = CreateAccordionSection(TabShop, "SHOP EGG")
CreateSelectedDropdown(SecShopEgg, "Shop Egg List", {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythichal Egg"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items = items end)
CreateActionToggle(SecShopEgg, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active = state end)
CreateActionToggle(SecShopEgg, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll = state end)

local SecShopSeed = CreateAccordionSection(TabShop, "SHOP SEED")
CreateSelectedDropdown(SecShopSeed, "Shop Seed List", {"Carrot", "Strawberry", "Blueberry", "Tomato", "Corn", "Pumpkin"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items = items end)
CreateActionToggle(SecShopSeed, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active = state end)
CreateActionToggle(SecShopSeed, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll = state end)

local SecShopGear = CreateAccordionSection(TabShop, "SHOP GEAR")
CreateSelectedDropdown(SecShopGear, "Shop Gear List", {"Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainGear.Items = items end)
CreateActionToggle(SecShopGear, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.Active = state end)
CreateActionToggle(SecShopGear, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll = state end)

-- === LOOP EKSEKUSHI AUTO BUY (BACKEND LOGIC) ===
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- 1. Auto Buy Main Seeds
            if getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active then
                for _, seedName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items) do
                    local stockItem = shop.GetStockGeneric and shop.GetStockGeneric(playerGui.Seed_Shop.Frame.ScrollingFrame, "Normal", seedName)
                    if stockItem and gameEvents:FindFirstChild("BuySeedStock") then
                        gameEvents.BuySeedStock:FireServer("Shop", stockItem)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll then
                local stockItem = shop.GetStockGeneric and shop.GetStockGeneric(playerGui.Seed_Shop.Frame.ScrollingFrame, "Normal", "no")
                if stockItem and gameEvents:FindFirstChild("BuySeedStock") then
                    gameEvents.BuySeedStock:FireServer("Shop", stockItem)
                end
            end

            -- 2. Auto Buy Main Eggs
            if getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active then
                for _, eggName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items) do
                    local stockItem = shop.GetStockGeneric and shop.GetStockGeneric(playerGui.PetShop_UI.Frame.ScrollingFrame, "Normal", eggName)
                    if stockItem and gameEvents:FindFirstChild("BuyPetEgg") then
                        gameEvents.BuyPetEgg:FireServer(stockItem)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll then
                local stockItem = shop.GetStockGeneric and shop.GetStockGeneric(playerGui.PetShop_UI.Frame.ScrollingFrame, "Normal", "no")
                if stockItem and gameEvents:FindFirstChild("BuyPetEgg") then
                    gameEvents.BuyPetEgg:FireServer(stockItem)
                end
            end

            -- 3. Auto Buy Main Gears
            if getgenv().ZedHubConfig.MainShopBuy.MainGear.Active then
                for _, gearName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainGear.Items) do
                    local stockItem = shop.GetStockGeneric and shop.GetStockGeneric(playerGui.Gear_Shop.Frame.ScrollingFrame, "Normal", gearName)
                    if stockItem and gameEvents:FindFirstChild("BuyGearStock") then
                        gameEvents.BuyGearStock:FireServer(stockItem)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll then
                local stockItem = shop.GetStockGeneric and shop.GetStockGeneric(playerGui.Gear_Shop.Frame.ScrollingFrame, "Normal", "no")
                if stockItem and gameEvents:FindFirstChild("BuyGearStock") then
                    gameEvents.BuyGearStock:FireServer(stockItem)
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

print("ZedHub UI + Auto Buy Integrated Successfully!")
