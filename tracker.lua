-- [[ 🚀 GOD MODE V15: TERMUX ULTIMATE 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH | STATUS: UNPATCHED ]] --
-- [[ FEATURES: STRICT ACTIVE ONLY | DYNAMIC TIMESTAMPS | HACKER UI ]] --

---------------------------------------------------------------------------------------------------
-- [1] CONFIGURATION
---------------------------------------------------------------------------------------------------
local CONFIG = {
    -- 🔗 WEBHOOK
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    -- 🤖 BOT IDENTITY
    BotName = "Termux Tracker V15",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png",
    PingRole = "@everyone",

    -- ⚙️ THRESHOLDS
    MinConfidence = 90,   -- SCORE >= 90: Instantly send Webhook
    HoldConfidence = 75,  -- SCORE 75-89: Hold and Re-scan
    
    -- ⚡ TIMERS
    ScanDelay = 0.2,      -- Ultra fast ticks
    HoldTime = 5,         
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
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Anti-Idle (Keep script running)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

---------------------------------------------------------------------------------------------------
-- [3] STATE & GUI (HEAVY TERMUX STYLE)
---------------------------------------------------------------------------------------------------
local State = { EventStack = {}, IsHolding = false, StartTime = os.clock() }

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshTermuxV15"
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

-- 1. Main Terminal Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Terminal"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5) -- Pure Black
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Curved Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Neon Border Stroke
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(0, 255, 100) -- Matrix Green

-- 2. Terminal Header (Top Bar)
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

-- Fix bottom corners of header to be square
local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HeaderFix.BorderSizePixel = 0
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)

local TerminalTitle = Instance.new("TextLabel")
TerminalTitle.Parent = Header
TerminalTitle.BackgroundTransparency = 1
TerminalTitle.Position = UDim2.new(0, 10, 0, 0)
TerminalTitle.Size = UDim2.new(1, -20, 1, 0)
TerminalTitle.Font = Enum.Font.Code
TerminalTitle.Text = "root@devansh:~# ./blox_tracker_v15.sh"
TerminalTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
TerminalTitle.TextSize = 11
TerminalTitle.TextXAlignment = Enum.TextXAlignment.Left

-- 3. Console Display
local ConsoleArea = Instance.new("ScrollingFrame")
ConsoleArea.Parent = MainFrame
ConsoleArea.BackgroundTransparency = 1
ConsoleArea.Position = UDim2.new(0, 10, 0, 35)
ConsoleArea.Size = UDim2.new(1, -20, 1, -55)
ConsoleArea.ScrollBarThickness = 2
ConsoleArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)

local LogLabel = Instance.new("TextLabel")
LogLabel.Parent = ConsoleArea
LogLabel.BackgroundTransparency = 1
LogLabel.Size = UDim2.new(1, 0, 0, 0)
LogLabel.AutomaticSize = Enum.AutomaticSize.Y
LogLabel.Font = Enum.Font.Code
LogLabel.Text = "" -- Logs populate here
LogLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Terminal Green
LogLabel.TextSize = 10
LogLabel.TextXAlignment = Enum.TextXAlignment.Left
LogLabel.TextYAlignment = Enum.TextYAlignment.Top
LogLabel.TextWrapped = true
LogLabel.RichText = true -- Allows colored logs

-- 4. Footer Stats
local FooterLine = Instance.new("Frame")
FooterLine.Parent = MainFrame
FooterLine.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FooterLine.Size = UDim2.new(1, 0, 0, 1)
FooterLine.Position = UDim2.new(0, 0, 1, -20)
FooterLine.BorderSizePixel = 0

local FooterText = Instance.new("TextLabel")
FooterText.Parent = MainFrame
FooterText.BackgroundTransparency = 1
FooterText.Position = UDim2.new(0, 10, 1, -20)
FooterText.Size = UDim2.new(1, -20, 0, 20)
FooterText.Font = Enum.Font.Code
FooterText.Text = "CPU: 12% | RAM: 404MB | NET: CONNECTED"
FooterText.TextColor3 = Color3.fromRGB(100, 100, 100)
FooterText.TextSize = 9
FooterText.TextXAlignment = Enum.TextXAlignment.Left

-- 5. Animated Cursor
local Cursor = Instance.new("TextLabel")
Cursor.Parent = ConsoleArea
Cursor.BackgroundTransparency = 1
Cursor.Size = UDim2.new(0, 10, 0, 12)
Cursor.Font = Enum.Font.Code
Cursor.Text = "_"
Cursor.TextColor3 = Color3.fromRGB(0, 255, 0)
Cursor.TextSize = 11
-- Cursor logic would involve complex text bounds math, simplified here by appending to log

-- 🌈 RGB Border Animation
task.spawn(function()
    local t = 0
    while MainFrame.Parent do
        t = t + 0.005
        local color = Color3.fromHSV(t % 1, 1, 1)
        UIStroke.Color = color
        RunService.Heartbeat:Wait()
    end
end)

-- 💻 Fake System Stats Update
task.spawn(function()
    while MainFrame.Parent do
        local ram = math.random(300, 500)
        local cpu = math.random(5, 25)
        FooterText.Text = string.format("CPU: %d%% | RAM: %dMB | NET: ONLINE | TIME: %s", cpu, ram, os.date("%X"))
        task.wait(2)
    end
end)

---------------------------------------------------------------------------------------------------
-- [4] LOGGING ENGINE (RICH TEXT SUPPORT)
---------------------------------------------------------------------------------------------------
local function Log(text, type)
    local prefix = "<font color='#555555'>[INFO]</font>"
    local color = "#00FF00" -- Default Green
    
    if type == "SUCCESS" then 
        prefix = "<font color='#00FF00'>[OKAY]</font>"
        color = "#FFFFFF"
    elseif type == "WARN" then 
        prefix = "<font color='#FFAA00'>[WARN]</font>"
        color = "#FFAA00"
    elseif type == "FAIL" then 
        prefix = "<font color='#FF0000'>[FAIL]</font>"
        color = "#FF5555"
    elseif type == "CMD" then
        prefix = "<font color='#00FFFF'>[root]</font>"
        color = "#00FFFF"
    end
    
    local newLine = string.format("%s <font color='%s'>%s</font>", prefix, color, text)
    print("V15: " .. text)
    
    -- Append to GUI
    LogLabel.Text = LogLabel.Text .. "\n" .. newLine
    ConsoleArea.CanvasPosition = Vector2.new(0, 9999)
end

---------------------------------------------------------------------------------------------------
-- [5] OMNISCIENT ENGINE
---------------------------------------------------------------------------------------------------
local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- 🕒 TIMEKEEPER (STRICT)
local function GetTimeData()
    local t = Lighting.ClockTime
    local isActive = (t >= 18 or t < 5.5)
    
    local status = isActive and "ACTIVE" or "EXPIRED"
    local color = isActive and 65280 or 16711680 -- Green / Red
    
    -- Discord Timestamp Calculation
    -- We need to calculate seconds until the state changes
    local secondsLeft = 0
    if isActive then
        if t >= 18 then secondsLeft = (24 - t + 5.5) * 60 -- Approx real seconds (game hour ~ 1 min)
        else secondsLeft = (5.5 - t) * 60 end
    end
    
    local timestamp = os.time() + math.floor(secondsLeft)
    local discordTime = string.format("<t:%d:R>", timestamp) -- "Ends in 4 minutes"
    
    return status, color, discordTime, t
end

-- 🦖 PREHISTORIC SCANNER
local function ScanPrehistoric()
    Log("Checking Prehistoric_Module...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland") end) then
        score = 100
        local m = Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland")
        pos = m.Position
        table.insert(evidence, "Ancient Model Found")
        Log(" > Target Acquired: Ancient Island", "SUCCESS")
    end

    if Lighting.FogColor == Color3.fromRGB(40, 60, 40) then
        score = score + 40
        table.insert(evidence, "Primordial Atmosphere")
    end

    return {name="💎🦖 PREHISTORIC ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🏝️ MIRAGE SCANNER
local function ScanMirage()
    Log("Checking Mirage_Module...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    -- 100% Model ID Check
    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100
        table.insert(evidence, "Model ID Match")
        pos = Workspace.Map.MysticIsland.Position
        Log(" > Target Acquired: Mystic Island", "SUCCESS")
    end
    
    -- Triangulation Fallback
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
        table.insert(evidence, "Triangulation Vector")
        if not pos then pos = sum / #cluster end
    end

    return {name="💎🏝️ MIRAGE ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🦊 KITSUNE SCANNER
local function ScanKitsune()
    Log("Checking Kitsune_Module...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    -- 100% Texture ID Check
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = 100
        table.insert(evidence, "Texture ID: 15306698696")
        Log(" > Target Acquired: Kitsune Texture", "SUCCESS")
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
    Log("Checking Frozen_Module...", "CMD")
    if SafeCheck(function() return Workspace.Map:FindFirstChild("FrozenDimension") or Workspace.Map:FindFirstChild("Frozen Island") end) then
        local p = nil
        if Workspace.Map:FindFirstChild("FrozenDimension") then p = Workspace.Map.FrozenDimension.Position end
        Log(" > Target Acquired: Dimension Gate", "SUCCESS")
        return {name="💎❄️ FROZEN DIMENSION", score=100, reason="Dimension Gate", pos=p}
    end
    return {score=0}
end

-- 🌕 MOON SCANNER
local function ScanMoon()
    Log("Checking Celestial_Module...", "CMD")
    -- 100% Texture ID Check
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then 
        Log(" > Target Acquired: Full Moon", "SUCCESS")
        return {name="💎🌕 FULL MOON", score=100, reason="Texture ID: 9709149431", pos=nil}
    end
    if Lighting:GetAttribute("IsFullMoon") then 
        return {name="💎🌕 FULL MOON", score=100, reason="Server Attribute", pos=nil}
    end
    return {score=0}
end

---------------------------------------------------------------------------------------------------
-- [6] REPORTING (STRICT ACTIVE ONLY)
---------------------------------------------------------------------------------------------------
local function SendWebhook()
    local status, color, discordTime, clockTime = GetTimeData()

    -- STRICT FILTER: ABORT IF EXPIRED
    if status == "EXPIRED" then
        Log("Event Found but EXPIRED. Aborting Ping.", "FAIL")
        return -- 🛑 STOP HERE
    end

    Log("Event ACTIVE. Sending Webhook...", "SUCCESS")

    local fields = {}
    
    -- 1. Events
    for _, e in pairs(State.EventStack) do
        table.insert(fields, {["name"] = e.name, ["value"] = "**Proof:** " .. e.reason .. "\n**Conf:** " .. e.score .. "%", ["inline"] = false})
    end
    
    -- 2. Dynamic Status
    table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = "🟢 ACTIVE\n**Ends:** " .. discordTime .. "\n**Clock:** " .. string.format("%.1f", clockTime), ["inline"] = false})

    -- 3. Scripts
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 1. JOIN SCRIPT", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    for _, e in pairs(State.EventStack) do
        if e.pos then
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y + 250) .. "," .. math.floor(e.pos.Z)
            local ts = string.format([[
-- [[ %s FLY TWEEN ]] --
local P = game.Players.LocalPlayer.Character.HumanoidRootPart
local T = CFrame.new(%s)
local B = Instance.new("BodyVelocity", P); B.Velocity=Vector3.zero; B.MaxForce=Vector3.one*9e9
local Tw = game:GetService("TweenService"):Create(P, TweenInfo.new((P.Position-T.Position).Magnitude/350), {CFrame=T})
Tw:Play(); Tw.Completed:Wait(); B:Destroy()
]], e.name, vec)
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
            ["footer"] = {["text"] = "Devansh | Termux V15"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then
        pcall(function() req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end)
    end
    Log("Payload Delivered.", "SUCCESS")
end

local function Hop()
    Log("Hopping...", "WARN")
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

---------------------------------------------------------------------------------------------------
-- [7] MAIN THREAD
---------------------------------------------------------------------------------------------------
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    Log("Booting System...", "CMD")
    task.wait(0.5)

    -- Friend Check
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p:IsFriendsWith(LocalPlayer.UserId) then
            Log("Security Alert: Friend Detected.", "FAIL")
            Hop(); return
        end
    end

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

    -- LOGIC GATE
    if highest >= CONFIG.MinConfidence then
        -- 90%+ Confidence
        SendWebhook()
        task.wait(2)
        Hop()
    elseif highest >= CONFIG.HoldConfidence then
        -- 75-89% Confidence (Hold)
        if not State.IsHolding then
            Log("Confidence: "..highest.."% (Hold Mode)", "WARN")
            State.IsHolding = true
            task.wait(CONFIG.HoldTime)
            init() -- Re-scan
        else
            Hop() -- Failed check twice
        end
    else
        Log("No Targets Found.", "CMD")
        Hop()
    end
end

init()
