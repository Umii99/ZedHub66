--[[
    ZEDHUB - MIDNIGHT SLATE & NEON BLUE (FINAL INTEGRATED AUTO SELL & PREVENT MODE)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gameEvents = ReplicatedStorage:WaitForChild("GameEvents", 5) or ReplicatedStorage
local shop = rawget(getgenv(), "shop") or {}

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
    EnablePreventMode = false,
    
    PreventSellFruits = {},
    PreventSellMutation = {},
    PreventSellVariant = {},
    
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

-- Tabel 'enabled' sebagai pemicu backend
local enabled = {
    ["Select Fall Market Seed Shop"] = getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Items,
    ["Select Fall Market Gear Shop"] = getgenv().ZedHubConfig.FallMarketBuy.FallGear.Items,
    ["Select Fall Market Cosmetic Shop"] = getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Items,
    ["Select Fall Market Pet Shop"] = getgenv().ZedHubConfig.FallMarketBuy.FallPets.Items,
    ["Auto Sell"] = false,
    ["Allow Sell If Backpack Is Max"] = false,
    ["Enable Prevent Mode"] = false,
    ["Prevent Sell Fruits"] = {},
    ["Prevent Sell Mutation"] = {},
    ["Prevent Sell Variant"] = {},
    ["Delay To Sell Inventory"] = 1,
}

-- =========================================================================
-- HELPER & AUTO SCAN (SINKRON DENGAN SPEED HUB BACKEND)
-- =========================================================================
-- 1. Cleansing String Name (StipFlavourText)
local function StipFlavourText(arg)
    if arg and arg ~= "" then
        return arg:gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")
    end
    return nil
end

-- 2. Scan Dinamis Data Game untuk List Dropdown Prevent
local scannedFruits = {}
local scannedMutations = {}
local scannedVariants = {"Normal", "Silver", "Gold", "Rainbow"}

local function FetchGameAPIData()
    pcall(function()
        for _, module in ipairs(ReplicatedStorage:GetDescendants()) do
            if module:IsA("ModuleScript") then
                if module.Name:lower():find("fruit") or module.Name:lower():find("crop") then
                    local data = require(module)
                    if type(data) == "table" then
                        for name, _ in pairs(data) do
                            if type(name) == "string" and not table.find(scannedFruits, name) then
                                table.insert(scannedFruits, name)
                            end
                        end
                    end
                elseif module.Name:lower():find("mutation") then
                    local data = require(module)
                    if type(data) == "table" then
                        for name, _ in pairs(data) do
                            if type(name) == "string" and not table.find(scannedMutations, name) then
                                table.insert(scannedMutations, name)
                            end
                        end
                    end
                end
            end
        end
    end)

    if #scannedFruits == 0 then
        scannedFruits = {
            "Golden Peach", "Meyer Lemon", "Carnival Pumpkin", "Kniphofia", "Turnip", 
            "Parsley", "Aurum Spire", "Alien Apple", "Elder Strawberry", "Crimson Thorn",
            "Carrot", "Strawberry", "Blueberry", "Tomato", "Watermelon", "Pumpkin", "Dragon Fruit"
        }
    end

    if #scannedMutations == 0 then
        scannedMutations = {
            "Gigantic", "Golden", "Rainbow", "Shocked", "Frozen", "Glossy", 
            "Wet", "Chilled", "Sandy", "Pollinated", "Bloodlit", "Eclipsed", "Aurora", "Celestial"
        }
    end
end

FetchGameAPIData()

-- 3. Filter Pengecekan Item Prevent Mode
local function ShouldPreventItem(tool)
    if not enabled["Enable Prevent Mode"] then return false end

    local rawName = tool.Name
    local cleanName = StipFlavourText(rawName) or rawName

    local preventFruits = enabled["Prevent Sell Fruits"] or {}
    local preventMutations = enabled["Prevent Sell Mutation"] or {}
    local preventVariants = enabled["Prevent Sell Variant"] or {}

    -- Filter Buah
    if table.find(preventFruits, cleanName) or table.find(preventFruits, rawName) then
        return true
    end

    -- Filter Mutasi dari Atribut
    local mut = tool:GetAttribute("Mutation") or tool:GetAttribute("m")
    if mut and table.find(preventMutations, tostring(mut)) then
        return true
    end

    -- Filter Varian dari Atribut
    local var = tool:GetAttribute("Variant") or tool:GetAttribute("v")
    if var and table.find(preventVariants, tostring(var)) then
        return true
    end

    return false
end

-- =========================================================================
-- FUNGSI SELL & TOOL (LENGKAP DENGAN PREVENT MODE)
-- =========================================================================
local sellFunction = {}
local tbl6 = {
    Sell = function()
        local character = LocalPlayer and LocalPlayer.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        local cFrame = humanoidRootPart.CFrame
        
        humanoidRootPart.CFrame = CFrame.new(36.5854721, 2.76619363, 0.426784277, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        task.wait(0.3)
        if gameEvents:FindFirstChild("Sell_Item") then
            gameEvents.Sell_Item:FireServer()
        elseif gameEvents:FindFirstChild("SellFruit") then
            gameEvents.SellFruit:FireServer()
        end
        task.wait(0.3)
        humanoidRootPart.CFrame = cFrame
    end,
    
    CallSell = function(arg)
        local tbl7 = {}
        local tbl8 = {}

        if LocalPlayer:FindFirstChild("Backpack") then
            for _, child in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if not (arg and not enabled[arg]) then
                    -- Integrasi Filter Prevent Mode
                    if child:IsA("Tool") and child:GetAttribute("b") == "j" and not child:GetAttribute("d") then
                        if not ShouldPreventItem(child) then
                            table.insert(tbl7, child)
                        end
                    end
                    continue
                end
                break
            end
        end

        if LocalPlayer.Character then
            for _, v_7 in ipairs(LocalPlayer.Character:GetChildren()) do
                if v_7:IsA("Tool") then
                    v_7.Parent = LocalPlayer.Backpack
                end
            end
        end

        for _, v_7 in ipairs(tbl7) do
            if not (arg and not enabled[arg]) then
                pcall(function()
                    for _, v_8 in ipairs(v_7:GetDescendants()) do
                        if v_8:IsA("BasePart") then v_8:Destroy() end
                    end
                end)

                v_7.Parent = LocalPlayer.Character
                table.insert(tbl8, v_7)
                continue
            end
            break
        end

        if #tbl8 > 0 then
            tbl6.Sell()
        end
    end,
}
sellFunction = tbl6

local toolFunction = {
    IsMaxInventory = function()
        local maxed = false
        pcall(function()
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local character = LocalPlayer.Character
            local count = 0
            if backpack then count = count + #backpack:GetChildren() end
            if character then
                for _, v in ipairs(character:GetChildren()) do
                    if v:IsA("Tool") then count = count + 1 end
                end
            end
            if count >= 20 then maxed = true end
        end)
        return maxed
    end
}

-- =========================================================================
-- UI INITIALIZATION
-- =========================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZedHubStrictUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

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

local Body = Instance.new("Frame", MainFrame)
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 32)
Body.Size = UDim2.new(1, 0, 1, -32)

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

local ContentHolder = Instance.new("Frame", Body)
ContentHolder.BackgroundColor3 = Color3.fromRGB(11, 17, 30)
ContentHolder.BackgroundTransparency = 1
ContentHolder.BorderSizePixel = 0
ContentHolder.Position = UDim2.new(0, 130, 0, 0)
ContentHolder.Size = UDim2.new(1, -130, 1, 0)

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

    MainFrame.InputBegan:Connect(function(input)
        if isListOpen and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            task.delay(0.05, function()
                if isListOpen then
                    isListOpen = false
                    popupOverlay.Visible = false
                    dropArrow.Text = "▼"
                    searchBox.Text = ""
                end
            end)
        end
    end)

    return dropFrame
end

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
local SecFallHarvest = CreateAccordionSection(TabEvent, "FALL HARVEST")
CreateToggle(SecFallHarvest, "Required Collection Plant", function(state) getgenv().ZedHubConfig.AutoCollect = state end)
CreateToggle(SecFallHarvest, "Required Submit Plant", function(state) getgenv().ZedHubConfig.AutoSubmit = state end)

local SecFallShop = CreateAccordionSection(TabEvent, "FALL SHOP")
CreateSelectedDropdown(SecFallShop, "Select Fall Market Pet Shop", {"Fall Egg", "Salmon", "Chipmunk", "Woodpecker", "Red Squirrel", "Marmot", "Mallard", "Sugar Glider", "Space Squirrel", "Red Panda"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallPets.Items = items end)
CreateSelectedDropdown(SecFallShop, "Select Fall Market Cosmetic Shop", {"Fall Leaf Chair", "Fall Crate", "Maple Flag", "Maple Wreath", "Fall Haybale", "Pile Of Leaves", "Flying Kit", "Autumn Crate", "Fall Mountain"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Items = items end)
CreateSelectedDropdown(SecFallShop, "Select Fall Market Seed Shop", {"Turnip", "Parsley", "Autumn Seed Pack", "Meyer Lemon", "Carnival Pumpkin", "Golden Peach", "Kniphofia", "Maple Resin"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Items = items end)
CreateSelectedDropdown(SecFallShop, "Select Fall Market Gear Shop", {"Firefly Jar", "Sky Lantern", "Maple Leaf Kite", "Maple Blower", "Maple Syrup", "Maple Sprinkler", "Bonfire", "Harvest Basket", "Acorn Lollipop", "Golden Acorn"}, function(items) getgenv().ZedHubConfig.FallMarketBuy.FallGear.Items = items end)
CreateActionToggle(SecFallShop, "Auto Buy Fall Shop", function(state) getgenv().ZedHubConfig.FallMarketBuy.Active = state end)

local SecShadyScarecrown = CreateAccordionSection(TabEvent, "SHADY SCARECROW")
CreateSelectedDropdown(SecShadyScarecrown, "Selected Seed", {"All Seed", "Gold Egg Seed"}, function(items)
    if #items > 0 then getgenv().ZedHubConfig.ShadyScarecrowMode = (items[#items] == "All Seed") and "ALL_SEED" or "GOLD_EGG_SEED" end
end)
CreateToggle(SecShadyScarecrown, "Give A Seed On/Off", function(state) getgenv().ZedHubConfig.GiveASeed = state end)

local SecAutoAcorn = CreateAccordionSection(TabEvent, "AUTO ACORN")
CreateToggle(SecAutoAcorn, "Auto Shovel Acorn On/Off", function(state) getgenv().ZedHubConfig.AutoShovel = state end)

local SecShopEgg = CreateAccordionSection(TabShop, "SHOP EGG")
CreateSelectedDropdown(SecShopEgg, "Shop Egg List", {"Common Egg", "Uncommon Egg", "Rare Egg", "Mythichal Egg", "Bugg Egg", "Junggle Egg"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items = items end)
CreateActionToggle(SecShopEgg, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active = state end)
CreateActionToggle(SecShopEgg, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll = state end)

local SecShopSeed = CreateAccordionSection(TabShop, "SHOP SEED")
CreateSelectedDropdown(SecShopSeed, "Shop Seed List", {"Carrot", "Strawberry", "Blueberry", "Tomato", "Buttercup", "Daffodil", "Corn", "Tulip", "Bamboo", "Watermelon", "Pumpkin", "Coconut", "Manggo", "Pineapple", "Apple", "Grape", "Dragon Fruit", "Cactus", "Papper", "Mushroom", "Cacao Bean", "Beanstalk", "Ember Lily", "Suggar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco", "Crimson Thorn", "Zebra", "Zinkle", "Octobloom", "Alien Apple", "Aurum Spire"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items = items end)
CreateActionToggle(SecShopSeed, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active = state end)
CreateActionToggle(SecShopSeed, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll = state end)

local SecShopGear = CreateAccordionSection(TabShop, "SHOP GEAR")
CreateSelectedDropdown(SecShopGear, "Shop Gear List", {"Trowel", "Watering Can", "Advanced Sprinkler", "Grandmaster", "Godly Sprinkler", "Master Sprinkler", "Basic Sprinkler", "Harvest Tools", "Favorite Tools", "Recall Wrench", "Cleaning Spray", "Cleansing Shard", "Level Up Lollipop"}, function(items) getgenv().ZedHubConfig.MainShopBuy.MainGear.Items = items end)
CreateActionToggle(SecShopGear, "Auto Buy (Selected)", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.Active = state end)
CreateActionToggle(SecShopGear, "Auto Buy All", function(state) getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll = state end)


-- === TAB AUTO SELLING & PREVENT MODE (TERHUBUNG FULL KE BACKEND) ===
local SecSell = CreateAccordionSection(TabSelling, "AUTO SELLING")

CreateToggle(SecSell, "Allow Sell If Backpack Is Max", function(state)
    enabled["Allow Sell If Backpack Is Max"] = state
    getgenv().ZedHubConfig.AllowSellIfBackpackFull = state
end)

CreateToggle(SecSell, "Auto Sell", function(state)
    enabled["Auto Sell"] = state
    getgenv().ZedHubConfig.AutoSellFruit = state
end)

local SecPrevent = CreateAccordionSection(TabSelling, "PREVENT MODE")

CreateToggle(SecPrevent, "Enable Prevent Mode", function(state)
    enabled["Enable Prevent Mode"] = state
    getgenv().ZedHubConfig.EnablePreventMode = state
end)

CreateSelectedDropdown(SecPrevent, "Prevent Sell Fruits", scannedFruits, function(items)
    enabled["Prevent Sell Fruits"] = items
    getgenv().ZedHubConfig.PreventSellFruits = items
end)

CreateSelectedDropdown(SecPrevent, "Prevent Sell Mutation", scannedMutations, function(items)
    enabled["Prevent Sell Mutation"] = items
    getgenv().ZedHubConfig.PreventSellMutation = items
end)

CreateSelectedDropdown(SecPrevent, "Prevent Sell Variant", scannedVariants, function(items)
    enabled["Prevent Sell Variant"] = items
    getgenv().ZedHubConfig.PreventSellVariant = items
end)


local WebhookBody = CreateAccordionSection(TabInfo, "WEBHOOK")
local WebhookBox = Instance.new("TextBox", WebhookBody)
WebhookBox.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
WebhookBox.Size = UDim2.new(1, 0, 0, 32)
WebhookBox.Font = Enum.Font.Gotham
WebhookBox.PlaceholderText = "URL Webhook Discord..."
WebhookBox.Text = ""
WebhookBox.TextColor3 = Color3.fromRGB(240, 240, 255)
WebhookBox.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
WebhookBox.TextSize = 13
Instance.new("UICorner", WebhookBox).CornerRadius = UDim.new(0, 4)

local ServerBody = CreateAccordionSection(TabInfo, "SERVER")
local ServerRow = Instance.new("Frame", ServerBody)
ServerRow.BackgroundTransparency = 1
ServerRow.Size = UDim2.new(1, 0, 0, 32)

local ServerInput = Instance.new("TextBox", ServerRow)
ServerInput.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
ServerInput.Size = UDim2.new(0.68, 0, 1, 0)
ServerInput.Font = Enum.Font.Gotham
ServerInput.PlaceholderText = "2007"
ServerInput.Text = ""
ServerInput.TextColor3 = Color3.fromRGB(240, 240, 255)
ServerInput.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
ServerInput.TextSize = 13
Instance.new("UICorner", ServerInput).CornerRadius = UDim.new(0, 4)

local ClickBtn = Instance.new("TextButton", ServerRow)
ClickBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
ClickBtn.Position = UDim2.new(0.71, 0, 0, 0)
ClickBtn.Size = UDim2.new(0.29, 0, 1, 0)
ClickBtn.Font = Enum.Font.GothamBold
ClickBtn.Text = "Click"
ClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickBtn.TextSize = 13
Instance.new("UICorner", ClickBtn).CornerRadius = UDim.new(0, 4)


-- =========================================================================
-- BACKEND LOOP (AUTO BUY + AUTO SELL LOGIC)
-- =========================================================================
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- Logika Auto Sell + Prevent Filter Sesuai Struktur Anda
            if enabled["Auto Sell"] then
                if not enabled["Allow Sell If Backpack Is Max"] then
                    sellFunction.CallSell("Auto Sell")
                elseif toolFunction.IsMaxInventory() then
                    sellFunction.CallSell("Auto Sell")
                end
                task.wait(tonumber(enabled["Delay To Sell Inventory"]) or 1)
            end

            local getStock = shop.GetStockGeneric or function(container, mode, item) return item end

            if getgenv().ZedHubConfig.FallMarketBuy.Active then
                for _, v_6 in ipairs(getgenv().ZedHubConfig.FallMarketBuy.FallSeed.Items) do
                    gameEvents.BuyEventShopStock:FireServer(v_6, "Fall Market Seed Shop")
                    task.wait(0.5)
                end
                for _, v_6 in ipairs(getgenv().ZedHubConfig.FallMarketBuy.FallGear.Items) do
                    gameEvents.BuyEventShopStock:FireServer(v_6, "Fall Market Gear Shop")
                    task.wait(0.5)
                end
                for _, v_6 in ipairs(getgenv().ZedHubConfig.FallMarketBuy.FallCrate.Items) do
                    gameEvents.BuyEventShopStock:FireServer(v_6, "Fall Market Cosmetic Shop")
                    task.wait(0.5)
                end
                for _, v_6 in ipairs(getgenv().ZedHubConfig.FallMarketBuy.FallPets.Items) do
                    gameEvents.BuyEventShopStock:FireServer(v_6, "Fall Market Pet Shop")
                    task.wait(0.5)
                end
            end

            if getgenv().ZedHubConfig.MainShopBuy.MainSeed.Active then
                for _, seedName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainSeed.Items) do
                    local v_6 = getStock(PlayerGui.Seed_Shop.Frame.ScrollingFrame, "Normal", seedName)
                    if v_6 and gameEvents:FindFirstChild("BuySeedStock") then
                        gameEvents.BuySeedStock:FireServer("Shop", v_6)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainSeed.BuyAll then
                local v_6 = getStock(PlayerGui.Seed_Shop.Frame.ScrollingFrame, "Normal", nil)
                if v_6 and gameEvents:FindFirstChild("BuySeedStock") then
                    gameEvents.BuySeedStock:FireServer("Shop", v_6)
                else
                    local scrollFrame = PlayerGui.Seed_Shop.Frame.ScrollingFrame
                    for _, child in ipairs(scrollFrame:GetChildren()) do
                        if gameEvents:FindFirstChild("BuySeedStock") then
                            gameEvents.BuySeedStock:FireServer("Shop", child.Name)
                        end
                    end
                end
            end

            if getgenv().ZedHubConfig.MainShopBuy.MainEgg.Active then
                for _, eggName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainEgg.Items) do
                    local v_6 = getStock(PlayerGui.PetShop_UI.Frame.ScrollingFrame, "Normal", eggName)
                    if v_6 and gameEvents:FindFirstChild("BuyPetEgg") then
                        gameEvents.BuyPetEgg:FireServer(v_6)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainEgg.BuyAll then
                local v_6 = getStock(PlayerGui.PetShop_UI.Frame.ScrollingFrame, "Normal", nil)
                if v_6 and gameEvents:FindFirstChild("BuyPetEgg") then
                    gameEvents.BuyPetEgg:FireServer(v_6)
                else
                    local scrollFrame = PlayerGui.PetShop_UI.Frame.ScrollingFrame
                    for _, child in ipairs(scrollFrame:GetChildren()) do
                        if gameEvents:FindFirstChild("BuyPetEgg") then
                            gameEvents.BuyPetEgg:FireServer(child.Name)
                        end
                    end
                end
            end

            if getgenv().ZedHubConfig.MainShopBuy.MainGear.Active then
                for _, gearName in ipairs(getgenv().ZedHubConfig.MainShopBuy.MainGear.Items) do
                    local v_6 = getStock(PlayerGui.Gear_Shop.Frame.ScrollingFrame, "Normal", gearName)
                    if v_6 and gameEvents:FindFirstChild("BuyGearStock") then
                        gameEvents.BuyGearStock:FireServer(v_6)
                    end
                end
            elseif getgenv().ZedHubConfig.MainShopBuy.MainGear.BuyAll then
                local v_6 = getStock(PlayerGui.Gear_Shop.Frame.ScrollingFrame, "Normal", nil)
                if v_6 and gameEvents:FindFirstChild("BuyGearStock") then
                    gameEvents.BuyGearStock:FireServer("Shop", v_6)
                else
                    local scrollFrame = PlayerGui.Gear_Shop.Frame.ScrollingFrame
                    for _, child in ipairs(scrollFrame:GetChildren()) do
                        if gameEvents:FindFirstChild("BuyGearStock") then
                            gameEvents.BuyGearStock:FireServer("Shop", child.Name)
                        end
                    end
                end
            end
        end)
    end
end)

-- Window Controls
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

print("ZedHub Final Auto Sell & Prevent Mode Loaded Successfully!")
