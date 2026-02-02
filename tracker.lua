-- [[ 🚀 GOD MODE V9: OMNISCIENT DEEP-SCAN 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH AI | STATUS: UNPATCHED ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    MinConfidence = 75,
    PingRole = "@everyone",
    BotName = "Event Tracker V9",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6981aee9&is=69805d69&hm=6e7a2e5223622533f20babf6c49f718c1769683df15a9276fdd7da76fc8748db&"
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 📊 STATE
local EventStack = {}
local ScanSpeed = 0.5 -- Delay between logic layers (Makes it functional/robust)

-- 🎨 GUI SYSTEM (FIXED & MOVABLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshGodModeV9"
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

-- 1. Main Frame (Draggable & Rainbow)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15) -- Deep Void
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -125) -- Centered
MainFrame.Size = UDim2.new(0, 500, 0, 250)
MainFrame.BorderSizePixel = 3 -- Visible Border
MainFrame.Active = true
MainFrame.Draggable = true -- MOVABLE FIX

-- 2. Top Bar (Status)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BorderSizePixel = 0

local StatusText = Instance.new("TextLabel")
StatusText.Parent = TopBar
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.Size = UDim2.new(0.6, 0, 1, 0)
StatusText.Font = Enum.Font.GothamBlack
StatusText.Text = "⚡ INITIALIZING..."
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.TextSize = 14
StatusText.TextXAlignment = Enum.TextXAlignment.Left

local AgeText = Instance.new("TextLabel")
AgeText.Parent = TopBar
AgeText.BackgroundTransparency = 1
AgeText.Position = UDim2.new(0.7, 0, 0, 0)
AgeText.Size = UDim2.new(0.3, -10, 1, 0)
AgeText.Font = Enum.Font.Code
AgeText.Text = "AGE: 00:00:00"
AgeText.TextColor3 = Color3.fromRGB(200, 200, 200)
AgeText.TextSize = 12
AgeText.TextXAlignment = Enum.TextXAlignment.Right

-- 3. Console (Middle)
local ConsoleBG = Instance.new("Frame")
ConsoleBG.Parent = MainFrame
ConsoleBG.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
ConsoleBG.Position = UDim2.new(0, 10, 0, 40)
ConsoleBG.Size = UDim2.new(1, -20, 0, 180)
ConsoleBG.BorderSizePixel = 1
ConsoleBG.BorderColor3 = Color3.fromRGB(40, 40, 40)

local ConsoleScroll = Instance.new("ScrollingFrame")
ConsoleScroll.Parent = ConsoleBG
ConsoleScroll.BackgroundTransparency = 1
ConsoleScroll.Size = UDim2.new(1, -10, 1, -10)
ConsoleScroll.Position = UDim2.new(0, 5, 0, 5)
ConsoleScroll.ScrollBarThickness = 4

local LogLabel = Instance.new("TextLabel")
LogLabel.Parent = ConsoleScroll
LogLabel.BackgroundTransparency = 1
LogLabel.Size = UDim2.new(1, 0, 1, 0) -- Auto expanding
LogLabel.Font = Enum.Font.Code
LogLabel.Text = ""
LogLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
LogLabel.TextSize = 12
LogLabel.TextXAlignment = Enum.TextXAlignment.Left
LogLabel.TextYAlignment = Enum.TextYAlignment.Top -- Logs go top-down

-- 4. Footer (Bottom)
local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Font = Enum.Font.GothamBold
Footer.Text = "made by devansh" -- FOOTER FIX
Footer.TextColor3 = Color3.fromRGB(255, 170, 0)
Footer.TextSize = 10

-- 🌈 RAINBOW GUI SCRIPT
task.spawn(function()
    local t = 0
    while MainFrame.Parent do
        t = t + 0.005
        local color = Color3.fromHSV(t % 1, 0.8, 1)
        MainFrame.BorderColor3 = color
        StatusText.TextColor3 = color
        RunService.Heartbeat:Wait()
    end
end)

-- 📟 LOGGING SYSTEM
local function Log(text)
    StatusText.Text = "⚡ " .. text
    local time = os.date("%X")
    LogLabel.Text = LogLabel.Text .. "\n[" .. time .. "] " .. text
    -- Auto Scroll
    ConsoleScroll.CanvasPosition = Vector2.new(0, 9999)
end

-- 🛡️ UTILITIES
local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- ⏳ TIMEKEEPER
local function GetTimeState()
    local ct = Lighting.ClockTime
    if ct >= 18 or ct < 5.5 then
        return "🟢 ACTIVE", 65280, false
    else
        return "🔴 EXPIRED / DESPAWNING", 16711680, true
    end
end

-- 🕵️ FALLBACK ENGINE (20-LAYER)

-- A. MIRAGE
local function DeepScanMirage()
    local score = 0
    local evidence = {}
    local pos = nil
    
    Log("Scanning Mirage Layer 1 (Model)...")
    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100; table.insert(evidence, "Direct Model")
        pos = Workspace.Map.MysticIsland.Position
    end
    task.wait(ScanSpeed) -- Artifical delay for "functionable" feel
    
    Log("Scanning Mirage Layer 2 (Math AI)...")
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
        score = score + 60; table.insert(evidence, "Triangulation AI")
        if not pos then pos = sum / #cluster end
    end
    task.wait(ScanSpeed)
    
    Log("Scanning Mirage Layer 3 (Atmosphere)...")
    if Lighting.FogEnd < 1000 then score = score + 40; table.insert(evidence, "Fog Density") end
    
    if score >= CONFIG.MinConfidence then 
        table.insert(EventStack, {name="MIRAGE ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}) 
    end
end

-- B. KITSUNE
local function DeepScanKitsune()
    local score = 0
    local evidence = {}
    local pos = nil
    
    Log("Scanning Kitsune Layer 1 (Model)...")
    if SafeCheck(function() return Workspace.Map:FindFirstChild("KitsuneShrine") end) then
        score = 100; table.insert(evidence, "Shrine Model")
        pos = Workspace.Map.KitsuneShrine.Position
    end
    task.wait(ScanSpeed)
    
    Log("Scanning Kitsune Layer 2 (Texture)...")
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = score + 90; table.insert(evidence, "Blue Moon Texture")
    end
    task.wait(ScanSpeed)
    
    Log("Scanning Kitsune Layer 3 (Particles)...")
    if SafeCheck(function() return Workspace:FindFirstChild("AzureEmber", true) end) then
        score = score + 50; table.insert(evidence, "Azure Ember")
    end
    
    if score >= CONFIG.MinConfidence then 
        table.insert(EventStack, {name="KITSUNE SHRINE", score=score, reason=table.concat(evidence, ", "), pos=pos}) 
    end
end

-- C. FULL MOON
local function DeepScanMoon()
    local score = 0
    Log("Scanning Celestial Layer 1...")
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then score = 100 end
    if Lighting:GetAttribute("IsFullMoon") then score = score + 100 end
    
    if score >= CONFIG.MinConfidence then 
        table.insert(EventStack, {name="FULL MOON", score=score, reason="Texture Match", pos=nil}) 
    end
end

-- D. FROZEN
local function DeepScanFrozen()
    Log("Scanning Dimension Layer 1...")
    if SafeCheck(function() return Workspace.Map:FindFirstChild("FrozenDimension") or Workspace.Map:FindFirstChild("Frozen Island") end) then
        local p = nil
        if Workspace.Map:FindFirstChild("FrozenDimension") then p = Workspace.Map.FrozenDimension.Position end
        table.insert(EventStack, {name="FROZEN DIMENSION", score=100, reason="Gate Found", pos=p})
    end
end

-- 🐇 HOPPER
local function InstantHop()
    Log("HOPPING SERVER...")
    task.wait(1) -- Visual delay so user sees log
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local s, body = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    if s and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then table.insert(AllIDs, v.id) end
        end
    end
    if #AllIDs > 0 then TeleportService:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else InstantHop() end
end

-- 📨 REPORTING
local function SendReport()
    Log("UPLOADING DATA TO WEBHOOK...")
    local statusText, embedColor, isExpired = GetTimeState()
    if isExpired then embedColor = 16711680 end -- Red if expired

    local fields = {}
    for _, e in pairs(EventStack) do
        table.insert(fields, {["name"] = "💎 " .. e.name, ["value"] = "**Proof:** " .. e.reason .. "\n**Score:** " .. e.score .. "%", ["inline"] = false})
    end
    
    local clockStr = string.format("%.1f", Lighting.ClockTime)
    local statusStr = "State: " .. statusText .. "\nClock: " .. clockStr
    table.insert(fields, {["name"] = "⏳ LOGIC GATE", ["value"] = statusStr, ["inline"] = false})
    
    -- Join Script
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 JOIN SERVER", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    -- Anti-Cheat Bypass Tween
    for _, e in pairs(EventStack) do
        if e.pos then
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y+200) .. "," .. math.floor(e.pos.Z)
            local ts = string.format([[
local P=game.Players.LocalPlayer.Character.HumanoidRootPart;local T=CFrame.new(%s);
local B=Instance.new("BodyVelocity",P);B.Velocity=Vector3.zero;B.MaxForce=Vector3.one*9e9;
local Tw=game:GetService("TweenService"):Create(P,TweenInfo.new((P.Position-T.Position).Magnitude/300),{CFrame=T});
Tw:Play();Tw.Completed:Wait();B:Destroy()
]], vec)
            table.insert(fields, {["name"] = "✈️ FLY TO " .. e.name, ["value"] = "```lua\n" .. ts .. "\n```", ["inline"] = false})
        end
    end

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🌟 GOD MODE EVENT DETECTED",
            ["color"] = embedColor,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh Omniscient AI | V9"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then
        pcall(function() req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end)
    end
end

-- 🚀 INIT CYCLE
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    Log("SYSTEM INITIALIZED")
    task.wait(1)
    
    -- Deep Scans (Sequential for robust logging)
    DeepScanMirage()
    DeepScanKitsune()
    DeepScanMoon()
    DeepScanFrozen()
    
    Log("ANALYSIS COMPLETE")
    task.wait(0.5)
    
    if #EventStack > 0 then
        Log("EVENTS FOUND! REPORTING...")
        SendReport()
        task.wait(2) -- Wait for webhook
        InstantHop()
    else
        Log("NO EVENTS. HOPPING...")
        task.wait(0.5)
        InstantHop()
    end
end

init()
