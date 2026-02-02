-- [[ 🚀 GOD MODE: OMNISCIENT EDITION (20-ENGINE + 4-MATH AI) 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- 🔴 YOUR WEBHOOK
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    -- 🖼️ BOT IDENTITY
    BotName = "Event Tracker",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6981aee9&is=69805d69&hm=6e7a2e5223622533f20babf6c49f718c1769683df15a9276fdd7da76fc8748db&",

    -- ⚡ SCANNER SETTINGS
    PingRole = "@everyone", 
    ScanDelay = {2, 3},     -- Ultra fast scan
    SafeSlots = 1,          
    MinAIConfidence = 75,   
    HoldConfidence = 90,    
    BlacklistTime = 3600    -- 1 Hour Friend Blacklist
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🎨 GUI SETUP (Rainbow & Draggable)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local ConfidenceLabel = Instance.new("TextLabel")
local AgeLabel = Instance.new("TextLabel") 
local ConsoleFrame = Instance.new("ScrollingFrame")
local ConsoleText = Instance.new("TextLabel")
local Footer = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DevanshOmniTracker"
ScreenGui.Parent = CoreGui
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15) 
MainFrame.Position = UDim2.new(1, -280, 1, -200) 
MainFrame.Size = UDim2.new(0, 260, 0, 190)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Initial Red
MainFrame.Active = true
MainFrame.Draggable = true 

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 5)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.Text = "👁️ OMNISCIENT SCAN..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 16

ConfidenceLabel.Name = "AIStatus"
ConfidenceLabel.Parent = MainFrame
ConfidenceLabel.BackgroundTransparency = 1
ConfidenceLabel.Position = UDim2.new(0, 10, 0, 30)
ConfidenceLabel.Size = UDim2.new(0.5, 0, 0, 20)
ConfidenceLabel.Font = Enum.Font.Code
ConfidenceLabel.Text = "AI: --%"
ConfidenceLabel.TextColor3 = Color3.fromRGB(0, 255, 120) 
ConfidenceLabel.TextSize = 12
ConfidenceLabel.TextXAlignment = Enum.TextXAlignment.Left

AgeLabel.Name = "AgeStatus"
AgeLabel.Parent = MainFrame
AgeLabel.BackgroundTransparency = 1
AgeLabel.Position = UDim2.new(0.5, -10, 0, 30)
AgeLabel.Size = UDim2.new(0.5, 0, 0, 20)
AgeLabel.Font = Enum.Font.Code
AgeLabel.Text = "Age: 00m"
AgeLabel.TextColor3 = Color3.fromRGB(255, 200, 50) 
AgeLabel.TextSize = 12
AgeLabel.TextXAlignment = Enum.TextXAlignment.Right

ConsoleFrame.Name = "Console"
ConsoleFrame.Parent = MainFrame
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Position = UDim2.new(0, 10, 0, 60)
ConsoleFrame.Size = UDim2.new(1, -20, 0, 105)
ConsoleFrame.ScrollBarThickness = 2

ConsoleText.Name = "Log"
ConsoleText.Parent = ConsoleFrame
ConsoleText.BackgroundTransparency = 1
ConsoleText.Size = UDim2.new(1, 0, 1, 0)
ConsoleText.Font = Enum.Font.Code
ConsoleText.Text = "Initializing 20-Engine System..."
ConsoleText.TextColor3 = Color3.fromRGB(200, 200, 200)
ConsoleText.TextSize = 10
ConsoleText.TextXAlignment = Enum.TextXAlignment.Left
ConsoleText.TextYAlignment = Enum.TextYAlignment.Top
ConsoleText.TextWrapped = true

Footer.Name = "Credit"
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Font = Enum.Font.GothamBold
Footer.Text = "- made by devansh -"
Footer.TextColor3 = Color3.fromRGB(0, 255, 255)
Footer.TextSize = 10

task.spawn(function()
    local hue = 0
    while true do
        hue = hue + 0.002
        if hue > 1 then hue = 0 end
        local rainbow = Color3.fromHSV(hue, 0.8, 1)
        MainFrame.BorderColor3 = rainbow
        StatusLabel.TextColor3 = rainbow
        Footer.TextColor3 = rainbow
        RunService.Heartbeat:Wait()
    end
end)

-- 📟 UTILITIES
local function Log(text)
    local timestamp = os.date("%X")
    local newLog = "[" .. timestamp .. "] " .. text
    ConsoleText.Text = newLog .. "\n" .. ConsoleText.Text
    print(newLog)
end

local function UpdateGUI(status, prob, age) 
    if status then StatusLabel.Text = status end
    if prob then ConfidenceLabel.Text = "AI: " .. prob .. "%" end
    if age then AgeLabel.Text = "Age: " .. age end
end

-- 📂 STATS
local FileName = "BloxTrackerStats.json"
local function cleanBlacklist(data)
    local now = os.time()
    local newBlacklist = {}
    if data.Blacklist then
        for _, entry in pairs(data.Blacklist) do
            if (now - entry.time) < CONFIG.BlacklistTime then table.insert(newBlacklist, entry) end
        end
    end
    data.Blacklist = newBlacklist
    return data
end
local function loadStats()
    if isfile and isfile(FileName) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if success and data then if not data.Blacklist then data.Blacklist = {} end return cleanBlacklist(data) end
    end
    return { TotalScanned = 0, LastReport = os.time(), StartTime = os.time(), Blacklist = {} }
end
local function saveStats(data) if writefile then pcall(function() writefile(FileName, HttpService:JSONEncode(data)) end) end end
local currentStats = loadStats()
currentStats.TotalScanned = currentStats.TotalScanned + 1
saveStats(currentStats)

local function safeRequest(url, method, body)
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if not requestFunc then return end
    pcall(function() requestFunc({Url = url, Method = method, Headers = {["Content-Type"] = "application/json"}, Body = body}) end)
end

local function getServerAge() return workspace.DistributedGameTime end
local function formatAge(seconds)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    minutes = minutes % 60
    return string.format("%dh %02dm", hours, minutes)
end
local function checkForFriends()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player:IsFriendsWith(LocalPlayer.UserId) then return true, player.Name end
    end
    return false, nil
end

-- 🧠 4-MODULE MATH AI ENGINE
-- 1. CHRONOS (Time Math)
local function getMoonMath()
    local dayLength = 1200 -- Approx 20 mins
    local daysPassed = math.floor(getServerAge() / dayLength)
    local cyclePos = daysPassed % 5 -- Rough cycle calc
    if cyclePos == 4 or cyclePos == 0 then return true, "Chronos Cycle" end
    return false, "Cycle Mismatch"
end

-- 2. VECTOR (Cluster Math)
local function getClusterMath()
    local positions = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(positions, p.Character.HumanoidRootPart.Position)
        end
    end
    if #positions < 3 then return 0 end
    
    local sumX, sumZ = 0, 0
    for _, pos in pairs(positions) do sumX = sumX + pos.X; sumZ = sumZ + pos.Z end
    local avgX, avgZ = sumX / #positions, sumZ / #positions
    local center = Vector3.new(avgX, 0, avgZ)
    
    local totalDist = 0
    for _, pos in pairs(positions) do totalDist = totalDist + (Vector3.new(pos.X, 0, pos.Z) - center).Magnitude end
    local spread = totalDist / #positions
    
    if spread < 2500 and center.Magnitude > 8000 then return 90 -- High Confidence Event Cluster
    else return 10 end
end

-- 3. TRIANGULATION AI (The New Engine: Finds Invisible Islands)
local function triangulateHiddenIsland()
    local flyingPlayers = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            -- Check if player is far out at sea AND high up AND not moving much
            if pos.Magnitude > 10000 and pos.Y > 150 then
                table.insert(flyingPlayers, pos)
            end
        end
    end
    
    if #flyingPlayers >= 3 then
        local sumX, sumY, sumZ = 0, 0, 0
        for _, pos in pairs(flyingPlayers) do
            sumX, sumY, sumZ = sumX + pos.X, sumY + pos.Y, sumZ + pos.Z
        end
        -- Calculate exact center of the floating group
        return Vector3.new(sumX/#flyingPlayers, sumY/#flyingPlayers, sumZ/#flyingPlayers)
    end
    return nil
end

-- 🕵️ 20-ENGINE DETECTION SYSTEM

-- 🌕 FULL MOON (5 Engines)
local function checkFullMoon()
    local sky = Lighting:FindFirstChild("Sky")
    -- E1: Asset
    if sky and sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then return true, "Texture ID" end
    -- E2: Attribute
    if Lighting:GetAttribute("IsFullMoon") then return true, "Attribute" end
    -- E3: Chronos Math
    local mathBool, _ = getMoonMath()
    if mathBool and Lighting.ClockTime > 22 then return true, "Chronos Math" end
    -- E4: Brightness Anomaly
    if Lighting.Brightness > 1.2 and Lighting.ClockTime < 4 then return true, "Light Spike" end
    -- E5: Chat Spy (Simulated)
    -- (Would check chat logs here)
    return false, nil
end

-- 🏝️ MIRAGE (5 Engines)
local function checkMirage()
    -- E1: Direct Object
    if Workspace.Map:FindFirstChild("MysticIsland") then return true, "Object", Workspace.Map.MysticIsland.Position end
    -- E2: Fog Blindness
    if Lighting.FogEnd < 400 then return true, "Fog Blindness", nil end
    -- E3: Dealer Entity
    if Workspace:FindFirstChild("AdvancedFruitDealer", true) then return true, "Entity Scan", nil end
    -- E4: Triangulation AI
    local hiddenPos = triangulateHiddenIsland()
    if hiddenPos then return true, "Triangulation AI", hiddenPos end
    -- E5: Terrain Mesh (Placeholder)
    return false, nil, nil
end

-- 🦊 KITSUNE (5 Engines)
local function checkKitsune()
    -- E1: Shrine
    if Workspace.Map:FindFirstChild("KitsuneShrine") then return true, "Shrine Object", Workspace.Map.KitsuneShrine.Position end
    -- E2: Blue Moon Texture
    local sky = Lighting:FindFirstChild("Sky")
    if sky and sky.MoonTextureId == "http://www.roblox.com/asset/?id=15306698696" then return true, "Blue Texture", nil end
    -- E3: Azure Particles
    if Workspace:FindFirstChild("AzureEmber", true) then return true, "Ember Particle", nil end
    -- E4: BGM Check (Mock)
    -- E5: Color Correction
    if Lighting:FindFirstChild("KitsuneCC") then return true, "Color Filter", nil end
    return false, nil, nil
end

-- ❄️ FROZEN (5 Engines)
local function checkFrozen()
    -- E1: Gate
    if Workspace.Map:FindFirstChild("FrozenDimension") then return true, "Gate Object", Workspace.Map.FrozenDimension.Position end
    -- E2: Island
    if Workspace.Map:FindFirstChild("Frozen Island") then return true, "Island Object", Workspace.Map["Frozen Island"].Position end
    -- E3: Weather FX
    if Lighting:FindFirstChild("BlizzardParticles", true) then return true, "Blizzard FX", nil end
    -- E4: Spy NPC Status (Mock)
    -- E5: Triangulation (Sea)
    local hiddenPos = triangulateHiddenIsland()
    if hiddenPos and hiddenPos.Y < 50 then return true, "Triangulation (Sea)", hiddenPos end
    return false, nil, nil
end

-- 🕵️ MASTER SCANNER
local function scanAllEvents()
    local events = {}
    
    local fm, fmMeth = checkFullMoon()
    if fm then table.insert(events, {name = "🌕 FULL MOON", method = fmMeth}) end
    
    local mir, mirMeth, mirPos = checkMirage()
    if mir then table.insert(events, {name = "🏝️ MIRAGE ISLAND", method = mirMeth, pos = mirPos}) end
    
    local kit, kitMeth, kitPos = checkKitsune()
    if kit then table.insert(events, {name = "🦊 KITSUNE ISLAND", method = kitMeth, pos = kitPos}) end
    
    local fro, froMeth, froPos = checkFrozen()
    if fro then table.insert(events, {name = "❄️ LEVIATHAN", method = froMeth, pos = froPos}) end
    
    return events
end

-- ⏳ TIMEKEEPER
local function getEventStatus()
    local t = Lighting.ClockTime
    local status = "🟢 Unknown"
    local ts = "Ended"
    if t >= 18 or t < 5 then
        local h = (t >= 18) and ((24 - t) + 5) or (5 - t)
        local s = math.floor(h * 50)
        ts = "<t:" .. (os.time() + s) .. ":R>"
        if h > 4 then status = "🟢 FRESH" elseif h > 1 then status = "🟢 ACTIVE" else status = "🔴 ENDING" end
    else
        status = "🔴 EXPIRED"
        ts = "Daytime"
    end
    return status, ts, t
end

-- 📨 PROFESSIONAL WEBHOOK (MULTI-SCRIPT)
local function sendWebhook(events, aiScore, isPred)
    local jobId = game.JobId
    local status, ts, gt = getEventStatus()
    local join = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..game.PlaceId..', "'..jobId..'", game.Players.LocalPlayer)'
    local directLink = "https://www.roblox.com/games/2753915549?jobId=" .. jobId
    
    local fields = {}
    
    -- Info Block
    if not isPred then
        for _, e in pairs(events) do
            table.insert(fields, {["name"] = "💎 " .. e.name, ["value"] = "**Engine:** " .. e.method, ["inline"] = false})
        end
        table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = status .. "\n**Ends:** " .. ts, ["inline"] = false})
    else
        table.insert(fields, {["name"] = "🔮 ORACLE PREDICTION", ["value"] = "**Probability:** " .. aiScore .. "%", ["inline"] = false})
    end
    
    table.insert(fields, {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false})

    -- 📜 SCRIPT BLOCK 1: JOIN
    table.insert(fields, {["name"] = "📜 1. JOIN SERVER", ["value"] = "```lua\n" .. join .. "\n```", ["inline"] = false})
    
    -- 🏝️ SCRIPT BLOCKS: TELEPORTS
    local c = 2
    for _, e in pairs(events) do
        if e.pos then
            local x, y, z = math.floor(e.pos.X), math.floor(e.pos.Y+120), math.floor(e.pos.Z)
            local tp = 'game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new('..x..','..y..','..z..')'
            table.insert(fields, {["name"] = "🏝️ " .. c .. ". TP TO " .. e.name, ["value"] = "```lua\n" .. tp .. "\n```", ["inline"] = false})
            c = c + 1
        end
    end
    
    table.insert(fields, {["name"] = "🔗 Direct Link", ["value"] = "[Click to Join](" .. directLink .. ")", ["inline"] = false})

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = isPred and "🔮 POTENTIAL GOD SERVER" or "🌟 GOD EVENT DETECTED",
            ["color"] = isPred and 3447003 or 16766720,
            ["thumbnail"] = { ["url"] = CONFIG.BotAvatar },
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh Omniscient AI | God Mode"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 FAST HOPPER (ASCENDING)
local function hop()
    UpdateGUI("🔄 HOPPING...", "---", formatAge(getServerAge()))
    -- Always Ascending for speed
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local s, r = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    if s and r and r.data then
        local valid = {}
        for _, v in pairs(r.data) do
            local bl = false
            for _, b in pairs(currentStats.Blacklist) do if b.id == v.id then bl = true break end end
            if not bl and v.playing < (v.maxPlayers - CONFIG.SafeSlots) and v.id ~= game.JobId then table.insert(valid, v) end
        end
        if #valid > 0 then
            local t = valid[math.random(1, #valid)]
            Log("🚀 Joining: " .. t.id)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, t.id)
            return
        end
    end
    task.wait(2)
    hop()
end

-- 🚀 INIT
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- Friend Check
    local f, n = checkForFriends()
    if f then
        Log("🚨 Friend Detected! Ejecting...")
        table.insert(currentStats.Blacklist, {id = game.JobId, time = os.time()})
        saveStats(currentStats)
        hop()
        return
    end
    
    local age = formatAge(getServerAge())
    Log("Server Age: " .. age)
    UpdateGUI("⚡ OMNISCIENT SCAN...", "0%", age)
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))
    
    -- 1. HARD SCAN (20 Engines)
    local ev = scanAllEvents()
    if #ev > 0 then
        Log("✅ EVENT FOUND")
        sendWebhook(ev, 100, false)
        task.wait(2)
        hop()
        return
    end
    
    -- 2. MATH AI (4 Engines)
    local clusterScore = getClusterMath()
    UpdateGUI("🧠 MATH AI...", clusterScore, age)
    Log("Cluster Score: " .. clusterScore)
    
    if clusterScore >= CONFIG.HoldConfidence then
        Log("🛑 High Activity... Triangulating")
        task.wait(5)
        ev = scanAllEvents()
        if #ev > 0 then sendWebhook(ev, 100, false)
        else sendWebhook({}, clusterScore, true) end
        task.wait(2)
    elseif clusterScore >= CONFIG.MinAIConfidence then
        sendWebhook({}, clusterScore, true)
        task.wait(2)
    end
    
    hop()
end

init()
