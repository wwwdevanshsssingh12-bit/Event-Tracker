-- [[ 🚀 GOD MODE V13: CUSTOMIZED EDITION 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH | STATUS: UNPATCHED ]] --
-- [[ LOGIC: 90% CONFIRM | 75% HOLD ]] --

---------------------------------------------------------------------------------------------------
-- [1] CONFIGURATION
---------------------------------------------------------------------------------------------------
local CONFIG = {
    -- 🔗 WEBHOOK
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    -- 🤖 BOT IDENTITY
    BotName = "Event Tracker V13",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6981aee9&is=69805d69&hm=6e7a2e5223622533f20babf6c49f718c1769683df15a9276fdd7da76fc8748db&",
    PingRole = "@everyone",

    -- ⚙️ THRESHOLDS
    MinConfidence = 90,   -- SCORE >= 90: Instantly send Webhook (Confirmed)
    HoldConfidence = 75,  -- SCORE 75-89: Wait 5s and Re-scan (Maybe/Ghost Check)
    
    -- ⚡ TIMERS
    ScanDelay = 0.5,      -- Time between engine ticks
    HoldTime = 5,         -- Duration to hold if "Maybe" is detected
}

---------------------------------------------------------------------------------------------------
-- [2] ROBLOX SERVICES
---------------------------------------------------------------------------------------------------
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Prevent Idle Kick
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

---------------------------------------------------------------------------------------------------
-- [3] STATE MANAGEMENT
---------------------------------------------------------------------------------------------------
local State = {
    EventStack = {},
    IsHolding = false,
    StartTime = os.clock(),
    LogHistory = {}
}

---------------------------------------------------------------------------------------------------
-- [4] GUI SYSTEM (COMPACT, MOVABLE, RAINBOW)
---------------------------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshGodModeV13"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15) -- Professional Dark
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)    -- Centered
MainFrame.Size = UDim2.new(0, 300, 0, 200)              -- Compact Size
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true -- ✅ MOVABLE ENABLED

-- Top Bar (Status)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "⚡ EVENT TRACKER V13"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Parent = TopBar
TimerLabel.BackgroundTransparency = 1
TimerLabel.Position = UDim2.new(0.6, 0, 0, 0)
TimerLabel.Size = UDim2.new(0.4, -8, 1, 0)
TimerLabel.Font = Enum.Font.Code
TimerLabel.Text = "00:00"
TimerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
TimerLabel.TextSize = 10
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Console Area (Working)
local ConsoleBG = Instance.new("Frame")
ConsoleBG.Parent = MainFrame
ConsoleBG.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
ConsoleBG.Position = UDim2.new(0, 5, 0, 30)
ConsoleBG.Size = UDim2.new(1, -10, 1, -50)
ConsoleBG.BorderSizePixel = 1
ConsoleBG.BorderColor3 = Color3.fromRGB(40, 40, 40)

local ConsoleScroll = Instance.new("ScrollingFrame")
ConsoleScroll.Parent = ConsoleBG
ConsoleScroll.BackgroundTransparency = 1
ConsoleScroll.Size = UDim2.new(1, -5, 1, -5)
ConsoleScroll.Position = UDim2.new(0, 5, 0, 2)
ConsoleScroll.ScrollBarThickness = 2
ConsoleScroll.CanvasSize = UDim2.new(0, 0, 0, 0) 
ConsoleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local LogLabel = Instance.new("TextLabel")
LogLabel.Parent = ConsoleScroll
LogLabel.BackgroundTransparency = 1
LogLabel.Size = UDim2.new(1, 0, 0, 0)
LogLabel.AutomaticSize = Enum.AutomaticSize.Y
LogLabel.Font = Enum.Font.Code
LogLabel.Text = "" 
LogLabel.TextColor3 = Color3.fromRGB(0, 255, 120) -- Matrix Green
LogLabel.TextSize = 10
LogLabel.TextXAlignment = Enum.TextXAlignment.Left
LogLabel.TextYAlignment = Enum.TextYAlignment.Top
LogLabel.TextWrapped = true

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -15)
Footer.Size = UDim2.new(1, 0, 0, 15)
Footer.Font = Enum.Font.GothamBold
Footer.Text = "made by devansh" -- YOUR NAME
Footer.TextColor3 = Color3.fromRGB(255, 170, 0) -- Gold
Footer.TextSize = 9

-- 🌈 Rainbow Loop
task.spawn(function()
    local t = 0
    while MainFrame.Parent do
        t = t + 0.01
        local color = Color3.fromHSV(t % 1, 0.8, 1)
        MainFrame.BorderColor3 = color
        TitleLabel.TextColor3 = color
        RunService.Heartbeat:Wait()
    end
end)

-- ⏱️ Timer Loop
task.spawn(function()
    while MainFrame.Parent do
        local elapsed = os.clock() - State.StartTime
        TimerLabel.Text = string.format("%.1fs", elapsed)
        task.wait(0.1)
    end
end)

---------------------------------------------------------------------------------------------------
-- [5] UTILITIES & LOGGING
---------------------------------------------------------------------------------------------------
local function Log(text, color)
    local timestamp = os.date("%X")
    local prefix = "[INFO]"
    local textColor = Color3.fromRGB(200, 200, 200)

    if color == "SUCCESS" then 
        prefix = "[✅]" 
    elseif color == "WARN" then 
        prefix = "[⚠️]"
    elseif color == "FAIL" then 
        prefix = "[❌]" 
    end
    
    local newLine = string.format("%s %s", prefix, text)
    print("V13: " .. newLine)
    
    -- Append to GUI Log
    LogLabel.Text = LogLabel.Text .. "\n" .. newLine
    ConsoleScroll.CanvasPosition = Vector2.new(0, 9999) -- Auto Scroll
end

local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- Time State Logic (Day/Night)
local function GetTimeState()
    local ct = Lighting.ClockTime
    if ct >= 18 or ct < 5.5 then
        return "🟢 ACTIVE", 65280, false
    else
        return "🔴 EXPIRED", 16711680, true
    end
end

---------------------------------------------------------------------------------------------------
-- [6] OMNISCIENT SCANNERS (ALL 4 EVENTS)
---------------------------------------------------------------------------------------------------

-- 🔎 A. MIRAGE ISLAND SCANNER
local function ScanMirage()
    Log("Scanning Mirage Engine...")
    local score = 0
    local evidence = {}
    local pos = nil

    -- Layer 1: Physical Model
    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100
        table.insert(evidence, "Direct Model")
        pos = Workspace.Map.MysticIsland.Position
        Log(" > Found Model ✅", "SUCCESS")
    end

    -- Layer 2: Triangulation
    local cluster = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pp = p.Character.HumanoidRootPart.Position
            if pp.Magnitude > 8000 and pp.Y > 200 then
                table.insert(cluster, pp)
            end
        end
    end
    if #cluster >= 3 then
        local sum = Vector3.zero
        for _, v in pairs(cluster) do sum = sum + v end
        score = score + 60 
        table.insert(evidence, "Triangulation Cluster")
        if not pos then pos = sum / #cluster end
        Log(" > Found Player Cluster ✅", "SUCCESS")
    end

    -- Layer 3: Advanced Dealer
    if SafeCheck(function() return Workspace:FindFirstChild("AdvancedFruitDealer", true) end) then
        score = score + 100
        table.insert(evidence, "Advanced Dealer NPC")
        Log(" > Found Dealer ✅", "SUCCESS")
    end

    return {name="💎🏝️ MIRAGE ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🔎 B. KITSUNE SHRINE SCANNER
local function ScanKitsune()
    Log("Scanning Kitsune Engine...")
    local score = 0
    local evidence = {}
    local pos = nil

    -- Layer 1: Model
    if SafeCheck(function() return Workspace.Map:FindFirstChild("KitsuneShrine") end) then
        score = 100; table.insert(evidence, "Shrine Model")
        pos = Workspace.Map.KitsuneShrine.Position
        Log(" > Found Shrine ✅", "SUCCESS")
    end

    -- Layer 2: Texture
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = score + 90; table.insert(evidence, "Blue Moon Texture")
        Log(" > Found Texture ✅", "SUCCESS")
    end

    -- Layer 3: Particles
    if SafeCheck(function() return Workspace:FindFirstChild("AzureEmber", true) end) then
        score = score + 50; table.insert(evidence, "Azure Embers")
    end

    return {name="💎🦊 KITSUNE SHRINE", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🔎 C. FROZEN DIMENSION SCANNER
local function ScanFrozen()
    Log("Scanning Frozen Engine...")
    local score = 0
    local pos = nil

    if SafeCheck(function() return Workspace.Map:FindFirstChild("FrozenDimension") or Workspace.Map:FindFirstChild("Frozen Island") end) then
        score = 100
        if Workspace.Map:FindFirstChild("FrozenDimension") then pos = Workspace.Map.FrozenDimension.Position end
        Log(" > Found Dimension ✅", "SUCCESS")
        return {name="💎❄️ FROZEN DIMENSION", score=score, reason="Dimension Gate", pos=pos}
    end
    return {score=0}
end

-- 🔎 D. FULL MOON SCANNER
local function ScanMoon()
    Log("Scanning Celestial Engine...")
    local score = 0
    
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then 
        score = 100 
        Log(" > Found Full Moon ✅", "SUCCESS")
    end
    
    if Lighting:GetAttribute("IsFullMoon") then 
        score = score + 100 
    end

    return {name="💎🌕 FULL MOON", score=score, reason="Texture Match", pos=nil}
end

---------------------------------------------------------------------------------------------------
-- [7] HOPPING SYSTEM
---------------------------------------------------------------------------------------------------
local function HopServer()
    Log("Initiating Server Hop...", "WARN")
    local PlaceID = game.PlaceId
    local AllIDs = {}
    
    local success, body = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    
    if success and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then
                table.insert(AllIDs, v.id)
            end
        end
    end
    
    if #AllIDs > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else
        Log("Hop Failed. Retrying...", "FAIL")
        task.wait(2)
        HopServer()
    end
end

---------------------------------------------------------------------------------------------------
-- [8] REPORTING SYSTEM (PROFESSIONAL EMBED)
---------------------------------------------------------------------------------------------------
local function SendWebhook()
    Log("Found Events ✅", "SUCCESS")
    Log("Compiling Data...", "INFO")
    
    local statusText, embedColor, isExpired = GetTimeState()
    if isExpired then embedColor = 16711680 end -- Red

    local fields = {}
    
    -- 1. Events
    for _, e in pairs(State.EventStack) do
        table.insert(fields, {
            ["name"] = e.name, -- Emojis are already in the name
            ["value"] = "**Evidence:** " .. e.reason .. "\n**Confidence:** " .. e.score .. "%",
            ["inline"] = false
        })
    end
    
    -- 2. Status
    local clockStr = string.format("%.1f", Lighting.ClockTime)
    table.insert(fields, {
        ["name"] = "⏳ STATUS",
        ["value"] = "State: " .. statusText .. "\nTime: " .. clockStr,
        ["inline"] = false
    })

    -- 3. Join Script
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 1. JOIN SERVER", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    -- 4. Professional Tween Script
    for _, e in pairs(State.EventStack) do
        if e.pos then
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y + 250) .. "," .. math.floor(e.pos.Z)
            local ts = string.format([[
-- PROFESSIONAL ANTI-FALL TWEEN
local TweenService = game:GetService("TweenService")
local Plr = game.Players.LocalPlayer
local Root = Plr.Character:WaitForChild("HumanoidRootPart")
local Target = CFrame.new(%s)

-- Anti-Gravity Force
local BV = Instance.new("BodyVelocity")
BV.Parent = Root
BV.Velocity = Vector3.zero
BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

-- Smooth Tween (350 speed)
local Dist = (Root.Position - Target.Position).Magnitude
local Info = TweenInfo.new(Dist / 350, Enum.EasingStyle.Linear)
local Tween = TweenService:Create(Root, Info, {CFrame = Target})

Tween:Play()
Tween.Completed:Wait()
BV:Destroy()
print("Arrived at Event!")
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
            ["color"] = embedColor,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh | V13 Precision"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then
        pcall(function() req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end)
    end
    
    Log("Webhook Sent! 📨", "SUCCESS")
end

---------------------------------------------------------------------------------------------------
-- [9] INIT (MAIN ORCHESTRATOR)
---------------------------------------------------------------------------------------------------
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    Log("System Initialized", "INFO")
    
    -- Friend Check
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p:IsFriendsWith(LocalPlayer.UserId) then
            Log("Friend Detected! Leaving...", "WARN")
            HopServer()
            return
        end
    end

    -- Run Scanners
    local results = {}
    table.insert(results, ScanMirage())
    task.wait(CONFIG.ScanDelay)
    table.insert(results, ScanKitsune())
    task.wait(CONFIG.ScanDelay)
    table.insert(results, ScanMoon())
    task.wait(CONFIG.ScanDelay)
    table.insert(results, ScanFrozen())
    
    -- Analyze Results
    local highestScore = 0
    State.EventStack = {} -- Clear previous

    for _, res in pairs(results) do
        if res.score and res.score > highestScore then highestScore = res.score end
        -- Collect anything that passes the "Hold" threshold for the report
        if res.score and res.score >= CONFIG.HoldConfidence then
            table.insert(State.EventStack, res)
        end
    end

    -- [[ DECISION MATRIX: 90/75 LOGIC ]] --
    
    if highestScore >= CONFIG.MinConfidence then
        -- 🟢 Score 90-100: CONFIRMED
        Log("High Confidence ("..highestScore.."%). Reporting.", "SUCCESS")
        SendWebhook()
        task.wait(2)
        HopServer()

    elseif highestScore >= CONFIG.HoldConfidence then
        -- 🟡 Score 75-89: MAYBE / HOLD
        if not State.IsHolding then
            Log("⚠️ Maybe Event ("..highestScore.."%). Holding for "..CONFIG.HoldTime.."s...", "WARN")
            State.IsHolding = true
            task.wait(CONFIG.HoldTime) -- Wait 5 seconds
            init() -- RECURSIVE RE-SCAN
            return
        else
            -- Already held once, if still not 90, assume it's a ghost/fake and Hop
            Log("Hold Expired. Confidence failed to reach 90.", "FAIL")
            HopServer()
        end

    else
        -- 🔴 Score < 75: HOP
        Log("No events found. Hopping...", "INFO")
        HopServer()
    end
end

-- START
init()
