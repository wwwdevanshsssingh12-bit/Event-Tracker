-- [[ 🚀 GOD MODE V18: NUCLEAR FIX 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH | STATUS: STABLE MOBILE/PC ]] --
-- [[ REMOVED: VirtualUser (Crasher) | ADDED: Safe GUI ]] --

print(">> ATTEMPTING INJECTION V18... <<")

---------------------------------------------------------------------------------------------------
-- [1] CONFIGURATION
---------------------------------------------------------------------------------------------------
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    BotName = "Event Tracker",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png",
    PingRole = "@everyone",
    MinConfidence = 90, 
    HoldConfidence = 75,
    ScanDelay = 0.5, -- Safe speed
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

-- Simple Anti-AFK (Mobile Safe)
LocalPlayer.Idled:Connect(function()
    print("Anti-Idle: Pulse") -- Just print, don't simulate input (Crashes mobile)
end)

---------------------------------------------------------------------------------------------------
-- [3] GUI SYSTEM (FAIL-SAFE PARENTING)
---------------------------------------------------------------------------------------------------
local State = { EventStack = {}, IsHolding = false, StartTime = os.clock() }

-- 1. Try gethui (Best)
-- 2. Try CoreGui (Standard)
-- 3. Try PlayerGui (Fallback)
local function GetGuiParent()
    local success, parent = pcall(function() return gethui() end)
    if success and parent then return parent end
    
    success, parent = pcall(function() return game:GetService("CoreGui") end)
    if success and parent then return parent end
    
    return LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshV18_Nuclear"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GetGuiParent()

print(">> GUI PARENTED TO: " .. tostring(ScreenGui.Parent) .. " <<")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Terminal"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 100)

-- Header
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BorderSizePixel = 0
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "root@devansh:~/v18"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = TopBar
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
StatusLabel.Size = UDim2.new(0.4, -10, 1, 0)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "[BOOTING]"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Console
local ConsoleArea = Instance.new("ScrollingFrame")
ConsoleArea.Parent = MainFrame
ConsoleArea.BackgroundTransparency = 1
ConsoleArea.Position = UDim2.new(0, 10, 0, 35)
ConsoleArea.Size = UDim2.new(1, -20, 1, -55)
ConsoleArea.ScrollBarThickness = 3
ConsoleArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
ConsoleArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ConsoleArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ConsoleArea
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

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

-- Rainbow Border (Safe)
task.spawn(function()
    local t = 0
    while MainFrame.Parent do
        t = t + 0.01
        local color = Color3.fromHSV(t % 1, 0.9, 1)
        UIStroke.Color = color
        RunService.Heartbeat:Wait()
    end
end)

---------------------------------------------------------------------------------------------------
-- [4] LOGGING
---------------------------------------------------------------------------------------------------
local LogCount = 0

local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
end

local function Log(text, type)
    LogCount = LogCount + 1
    local color = Color3.fromRGB(200, 200, 200)
    local prefix = "[*]"
    
    if type == "SUCCESS" then color = Color3.fromRGB(0, 255, 100); prefix = "[+]"
    elseif type == "WARN" then color = Color3.fromRGB(255, 180, 0); prefix = "[!]"
    elseif type == "FAIL" then color = Color3.fromRGB(255, 50, 50); prefix = "[-]"
    elseif type == "CMD" then color = Color3.fromRGB(0, 200, 255); prefix = "[$]" end
    
    local Line = Instance.new("TextLabel")
    Line.Parent = ConsoleArea
    Line.BackgroundTransparency = 1
    Line.Size = UDim2.new(1, 0, 0, 14)
    Line.Font = Enum.Font.Code
    Line.Text = string.format("%s %s", prefix, text)
    Line.TextColor3 = color
    Line.TextSize = 11
    Line.TextXAlignment = Enum.TextXAlignment.Left
    Line.LayoutOrder = LogCount
    
    if LogCount > 40 then
        for _, child in pairs(ConsoleArea:GetChildren()) do
            if child:IsA("TextLabel") and child.LayoutOrder < (LogCount - 40) then child:Destroy() end
        end
    end
    ConsoleArea.CanvasPosition = Vector2.new(0, 99999)
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
    return status, color, string.format("<t:%d:R>", timestamp), t
end

---------------------------------------------------------------------------------------------------
-- [5] SCANNERS
---------------------------------------------------------------------------------------------------

-- 🦖 PREHISTORIC
local function ScanPrehistoric()
    Log("Scanning Prehistoric...", "CMD")
    local score = 0; local evidence = {}; local pos = nil
    if SafeCheck(function() return Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland") end) then
        score = 100
        local m = Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland")
        pos = m.Position
        table.insert(evidence, "Ancient Model")
        Log("Target: Prehistoric Island ✅", "SUCCESS")
    end
    if Lighting.FogColor == Color3.fromRGB(40, 60, 40) then score = score + 40; table.insert(evidence, "Primordial Fog") end
    return {name="💎🦖 PREHISTORIC ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🏝️ MIRAGE
local function ScanMirage()
    Log("Scanning Mirage...", "CMD")
    local score = 0; local evidence = {}; local pos = nil
    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100; table.insert(evidence, "Model ID")
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
        score = score + 60; table.insert(evidence, "Triangulation")
        if not pos then pos = sum / #cluster end
    end
    return {name="💎🏝️ MIRAGE ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🦊 KITSUNE
local function ScanKitsune()
    Log("Scanning Kitsune...", "CMD")
    local score = 0; local evidence = {}; local pos = nil
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = 100; table.insert(evidence, "Texture ID")
        Log("Target: Kitsune Texture ✅", "SUCCESS")
    end
    if SafeCheck(function() return Workspace.Map:FindFirstChild("KitsuneShrine") end) then
        score = 100; table.insert(evidence, "Shrine Model")
        pos = Workspace.Map.KitsuneShrine.Position
    end
    return {name="💎🦊 KITSUNE SHRINE", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- ❄️ FROZEN
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

-- 🌕 MOON
local function ScanMoon()
    Log("Scanning Celestial...", "CMD")
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then 
        Log("Target: Full Moon ✅", "SUCCESS")
        return {name="💎🌕 FULL MOON", score=100, reason="Texture Match", pos=nil}
    end
    return {score=0}
end

---------------------------------------------------------------------------------------------------
-- [6] REPORTING
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
        table.insert(fields, {["name"] = e.name, ["value"] = "**Engine:** " .. e.reason .. "\n**Conf:** " .. e.score .. "%", ["inline"] = false})
    end
    table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = "🟢 ACTIVE\n**Ends:** " .. discordTime .. "\n**Clock:** " .. string.format("%.1f", clockTime), ["inline"] = false})

    local directLink = "https://www.roblox.com/games/"..game.PlaceId.."?jobId="..game.JobId
    table.insert(fields, {["name"] = "🌍 SERVER INFO", ["value"] = "**Job ID:** `" .. game.JobId .. "`\n**[Click to Direct Join](" .. directLink .. ")**", ["inline"] = false})

    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 1. JOIN SCRIPT", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    for _, e in pairs(State.EventStack) do
        if e.pos then
            local islandName = string.gsub(e.name, "💎", "")
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y + 200) .. "," .. math.floor(e.pos.Z)
            local tpScript = string.format([[
-- [[ TELEPORT TO %s ]] --
local P = game.Players.LocalPlayer.Character.HumanoidRootPart
local T = CFrame.new(%s)
local B = Instance.new("BodyVelocity", P); B.Velocity=Vector3.zero; B.MaxForce=Vector3.one*9e9
local Tw = game:GetService("TweenService"):Create(P, TweenInfo.new((P.Position-T.Position).Magnitude/350), {CFrame=T})
Tw:Play(); Tw.Completed:Wait(); B:Destroy()
]], islandName, vec)
            table.insert(fields, {["name"] = "✈️ 2. TP TO " .. islandName, ["value"] = "```lua\n" .. tpScript .. "\n```", ["inline"] = false})
        end
    end

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🌟 EVENT DETECTED",
            ["color"] = color,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh | Termux V18 Stable"},
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

-- MAIN LOOP (Safe Recursive)
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    UpdateStatus("[SCANNING]", Color3.fromRGB(255, 200, 0))
    Log("Analyzing Game State...", "CMD")
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
        Log("Targets Acquired.", "SUCCESS")
        SendWebhook()
        task.wait(2)
        Hop()
    elseif highest >= CONFIG.HoldConfidence then
        if not State.IsHolding then
            UpdateStatus("[HOLDING]", Color3.fromRGB(255, 150, 0))
            Log("Unsure ("..highest.."%). Holding...", "WARN")
            State.IsHolding = true
            task.delay(CONFIG.HoldTime, init) -- Safe Delay
        else
            Hop()
        end
    else
        Log("No Targets. Hopping.", "CMD")
        Hop()
    end
end

-- LAUNCH
task.spawn(init)
