-- [[ 🚀 GOD MODE V17: STABLE GUI EDITION 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH | STATUS: FIXED & POLISHED ]] --
-- [[ FEATURES: ANTI-LAG CONSOLE | LIVE STATUS | DUAL SCRIPTS ]] --

print(">> INJECTING V17... CHECK YOUR SCREEN <<")

---------------------------------------------------------------------------------------------------
-- [1] CONFIGURATION
---------------------------------------------------------------------------------------------------
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    BotName = "Termux Tracker V17",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png",
    PingRole = "@everyone",
    MinConfidence = 90, 
    HoldConfidence = 75,
    ScanDelay = 0.3, -- Slightly slower for visual clarity
    HoldTime = 5,         
}

---------------------------------------------------------------------------------------------------
-- [2] SERVICES
---------------------------------------------------------------------------------------------------
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------------------------------------------------
-- [3] GUI SYSTEM (REBUILT FOR STABILITY)
---------------------------------------------------------------------------------------------------
local State = { EventStack = {}, IsHolding = false, StartTime = os.clock() }

-- Safe GUI Parenting
local function GetGuiParent()
    local s, p = pcall(function() return gethui() end)
    if s and p then return p end
    local s2, p2 = pcall(function() return game:GetService("CoreGui") end)
    if s2 and p2 then return p2 end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshV17_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GetGuiParent()

-- Main Terminal Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Terminal"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- Soft Dark
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 100) -- Initial Green

-- Top Bar (Header)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BorderSizePixel = 0
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Fix Bottom Corners of TopBar
local FixBar = Instance.new("Frame")
FixBar.Parent = TopBar
FixBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BorderSizePixel = 0

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "root@devansh:~/v17"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- STATUS INDICATOR (The "Running" Text)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = TopBar
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
StatusLabel.Size = UDim2.new(0.4, -10, 1, 0)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "[LOADING]"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Console Area (Scrolling)
local ConsoleArea = Instance.new("ScrollingFrame")
ConsoleArea.Parent = MainFrame
ConsoleArea.BackgroundTransparency = 1
ConsoleArea.Position = UDim2.new(0, 10, 0, 40)
ConsoleArea.Size = UDim2.new(1, -20, 1, -60)
ConsoleArea.ScrollBarThickness = 4
ConsoleArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
ConsoleArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ConsoleArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Font = Enum.Font.Code
Footer.Text = "made by devansh"
Footer.TextColor3 = Color3.fromRGB(80, 80, 80)
Footer.TextSize = 10

-- Layout for Console Lines
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ConsoleArea
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

-- 🌈 Rainbow Border Animation
task.spawn(function()
    local t = 0
    while MainFrame.Parent do
        t = t + 0.005
        local color = Color3.fromHSV(t % 1, 0.9, 1)
        UIStroke.Color = color
        RunService.Heartbeat:Wait()
    end
end)

---------------------------------------------------------------------------------------------------
-- [4] ROBUST LOGGING ENGINE
---------------------------------------------------------------------------------------------------
local LogCount = 0

local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
end

local function Log(text, type)
    LogCount = LogCount + 1
    
    local color = Color3.fromRGB(200, 200, 200) -- Default Grey
    local prefix = "[*]"
    
    if type == "SUCCESS" then 
        color = Color3.fromRGB(0, 255, 100) -- Green
        prefix = "[+]"
    elseif type == "WARN" then 
        color = Color3.fromRGB(255, 180, 0) -- Orange
        prefix = "[!]"
    elseif type == "FAIL" then 
        color = Color3.fromRGB(255, 50, 50) -- Red
        prefix = "[-]"
    elseif type == "CMD" then
        color = Color3.fromRGB(0, 200, 255) -- Blue
        prefix = "[$]"
    end
    
    -- Create a new text line (Prevents the "Giant Text" glitch)
    local Line = Instance.new("TextLabel")
    Line.Parent = ConsoleArea
    Line.BackgroundTransparency = 1
    Line.Size = UDim2.new(1, 0, 0, 14) -- Fixed height per line
    Line.Font = Enum.Font.Code
    Line.Text = string.format("%s %s", prefix, text)
    Line.TextColor3 = color
    Line.TextSize = 11
    Line.TextXAlignment = Enum.TextXAlignment.Left
    Line.LayoutOrder = LogCount
    
    -- Cleanup old logs if too many (Anti-Lag)
    if LogCount > 50 then
        for _, child in pairs(ConsoleArea:GetChildren()) do
            if child:IsA("TextLabel") and child.LayoutOrder < (LogCount - 50) then
                child:Destroy()
            end
        end
    end
    
    -- Auto Scroll
    ConsoleArea.CanvasPosition = Vector2.new(0, 99999)
    print("V17: " .. text)
end

local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

local function GetTimeData()
    local t = Lighting.ClockTime
    local isActive = (t >= 18 or t < 5.5)
    local status = isActive and "ACTIVE" or "EXPIRED"
    local color = isActive and 65280 or 16711680
    
    local secondsLeft = 0
    if isActive then
        if t >= 18 then secondsLeft = (24 - t + 5.5) * 60 
        else secondsLeft = (5.5 - t) * 60 end
    end
    
    local timestamp = os.time() + math.floor(secondsLeft)
    local discordTime = string.format("<t:%d:R>", timestamp)
    
    return status, color, discordTime, t
end

---------------------------------------------------------------------------------------------------
-- [5] SCANNERS (THE BRAIN)
---------------------------------------------------------------------------------------------------

-- 🦖 PREHISTORIC SCANNER
local function ScanPrehistoric()
    Log("Scanning Prehistoric...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland") end) then
        score = 100
        local m = Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland")
        pos = m.Position
        table.insert(evidence, "Ancient Model Found")
        Log("Target: Ancient Island ✅", "SUCCESS")
    end

    if Lighting.FogColor == Color3.fromRGB(40, 60, 40) then
        score = score + 40
        table.insert(evidence, "Primordial Fog")
    end

    return {name="💎🦖 PREHISTORIC ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🏝️ MIRAGE SCANNER
local function ScanMirage()
    Log("Scanning Mirage...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100
        table.insert(evidence, "Model ID Match")
        pos = Workspace.Map.MysticIsland.Position
        Log("Target: Mystic Island ✅", "SUCCESS")
    end
    
    local cluster = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pp = p.Character.HumanoidRootPart.Position
            if pp.Magnitude > 8000 and pp.Y > 200 then table.insert(cluster, pp) end
        end
    end
    if #cluster >= 3 then
        local sum = Vector3.zero
        for _, v in pairs(cluster) do sum = sum + v end
        score = score + 60
        table.insert(evidence, "Triangulation")
        if not pos then pos = sum / #cluster end
        Log("Player Cluster Detected", "WARN")
    end

    return {name="💎🏝️ MIRAGE ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🦊 KITSUNE SCANNER
local function ScanKitsune()
    Log("Scanning Kitsune...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = 100
        table.insert(evidence, "Texture ID: 15306698696")
        Log("Target: Kitsune Texture ✅", "SUCCESS")
    end
    
    if SafeCheck(function() return Workspace.Map:FindFirstChild("KitsuneShrine") end) then
        score = 100
        table.insert(evidence, "Shrine Model")
        pos = Workspace.Map.KitsuneShrine.Position
    end

    return {name="💎🦊 KITSUNE SHRINE", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- ❄️ FROZEN SCANNER
local function ScanFrozen()
    Log("Scanning Frozen...", "CMD")
    if SafeCheck(function() return Workspace.Map:FindFirstChild("FrozenDimension") or Workspace.Map:FindFirstChild("Frozen Island") end) then
        local p = nil
        if Workspace.Map:FindFirstChild("FrozenDimension") then p = Workspace.Map.FrozenDimension.Position end
        Log("Target: Dimension Gate ✅", "SUCCESS")
        return {name="💎❄️ FROZEN DIMENSION", score=100, reason="Dimension Gate", pos=p}
    end
    return {score=0}
end

-- 🌕 MOON SCANNER
local function ScanMoon()
    Log("Scanning Celestial...", "CMD")
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then 
        Log("Target: Full Moon ✅", "SUCCESS")
        return {name="💎🌕 FULL MOON", score=100, reason="Texture ID: 9709149431", pos=nil}
    end
    return {score=0}
end

---------------------------------------------------------------------------------------------------
-- [6] REPORTING (DUAL SCRIPTS)
---------------------------------------------------------------------------------------------------
local function SendWebhook()
    UpdateStatus("[REPORTING]", Color3.fromRGB(0, 255, 255))
    local status, color, discordTime, clockTime = GetTimeData()

    if status == "EXPIRED" then
        Log("Event EXPIRED. Aborting.", "FAIL")
        return 
    end

    local fields = {}
    for _, e in pairs(State.EventStack) do
        table.insert(fields, {["name"] = e.name, ["value"] = "**Proof:** " .. e.reason .. "\n**Conf:** " .. e.score .. "%", ["inline"] = false})
    end
    table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = "🟢 ACTIVE\n**Ends:** " .. discordTime .. "\n**Clock:** " .. string.format("%.1f", clockTime), ["inline"] = false})

    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 1. JOIN SCRIPT", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    for _, e in pairs(State.EventStack) do
        if e.pos then
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y + 250) .. "," .. math.floor(e.pos.Z)
            local ts = string.format([[
local P = game.Players.LocalPlayer.Character.HumanoidRootPart
local T = CFrame.new(%s)
local B = Instance.new("BodyVelocity", P); B.Velocity=Vector3.zero; B.MaxForce=Vector3.one*9e9
local Tw = game:GetService("TweenService"):Create(P, TweenInfo.new((P.Position-T.Position).Magnitude/350), {CFrame=T})
Tw:Play(); Tw.Completed:Wait(); B:Destroy()
]], vec)
            table.insert(fields, {["name"] = "✈️ 2. TP TO " .. e.name, ["value"] = "```lua\n" .. ts .. "\n```", ["inline"] = false})
        end
    end

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🌟 Event Detected",
            ["color"] = color,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh | Termux V17 Fixed"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    SafeCheck(function()
        local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
        if req then req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end
    end)
    Log("Payload Delivered.", "SUCCESS")
end

local function Hop()
    UpdateStatus("[HOPPING]", Color3.fromRGB(255, 50, 50))
    Log("Initiating Hop Protocol...", "WARN")
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local s, body = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) end)
    if s and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then table.insert(AllIDs, v.id) end
        end
    end
    if #AllIDs > 0 then TeleportService:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else task.wait(1); Hop() end
end

-- MAIN THREAD
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    UpdateStatus("[SCANNING]", Color3.fromRGB(255, 200, 0))
    Log("Kernel Loaded. Analyzing...", "CMD")
    task.wait(0.5)

    local results = {}
    table.insert(results, ScanMirage())
    task.wait(CONFIG.ScanDelay)
    table.insert(results, ScanKitsune())
    task.wait(CONFIG.ScanDelay)
    table.insert(results, ScanMoon())
    task.wait(CONFIG.ScanDelay)
    table.insert(results, ScanFrozen())
    task.wait(CONFIG.ScanDelay)
    table.insert(results, ScanPrehistoric())

    local highest = 0
    State.EventStack = {} 

    for _, res in pairs(results) do
        if res.score > highest then highest = res.score end
        if res.score >= CONFIG.HoldConfidence then table.insert(State.EventStack, res) end
    end

    if highest >= CONFIG.MinConfidence then
        UpdateStatus("[FOUND!]", Color3.fromRGB(0, 255, 0))
        Log("Targets Acquired. Reporting...", "SUCCESS")
        SendWebhook()
        task.wait(2)
        Hop()
    elseif highest >= CONFIG.HoldConfidence then
        if not State.IsHolding then
            UpdateStatus("[HOLDING]", Color3.fromRGB(255, 150, 0))
            Log("Unsure ("..highest.."%). Holding...", "WARN")
            State.IsHolding = true
            task.wait(CONFIG.HoldTime)
            init()
        else
            Hop()
        end
    else
        Log("No Targets. Hopping.", "CMD")
        Hop()
    end
end

-- Safe Launch
task.spawn(init)
