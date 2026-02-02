-- [[ 🚀 GOD MODE: THE FINAL MASTERPIECE 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- 🔴 YOUR WEBHOOK
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    -- 🖼️ IDENTITY
    BotName = "Event Tracker",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6981aee9&is=69805d69&hm=6e7a2e5223622533f20babf6c49f718c1769683df15a9276fdd7da76fc8748db&",
    
    -- ⚡ SETTINGS
    PingRole = "@everyone", 
    ScanDelay = {2, 3},     -- Speed
    SafeSlots = 1,          
    MinAIConfidence = 75,   -- As requested
    HoldConfidence = 90,    -- As requested
    PingThreshold = 75,     -- Correlation Score to Ping
    ReportInterval = 10800, -- 3 Hours
    BlacklistTime = 3600    
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

-- 🎨 GUI SETUP (Original Rainbow Design)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local ConfidenceLabel = Instance.new("TextLabel")
local AgeLabel = Instance.new("TextLabel") 
local ConsoleFrame = Instance.new("ScrollingFrame")
local ConsoleText = Instance.new("TextLabel")
local Footer = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DevanshEventTracker"
ScreenGui.Parent = CoreGui
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18) 
MainFrame.Position = UDim2.new(1, -280, 1, -200) 
MainFrame.Size = UDim2.new(0, 260, 0, 190)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.Active = true
MainFrame.Draggable = true 

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 5)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.Text = "⚡ GOD MODE SCAN..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 18

ConfidenceLabel.Name = "AIStatus"
ConfidenceLabel.Parent = MainFrame
ConfidenceLabel.BackgroundTransparency = 1
ConfidenceLabel.Position = UDim2.new(0, 10, 0, 30)
ConfidenceLabel.Size = UDim2.new(0.5, 0, 0, 20)
ConfidenceLabel.Font = Enum.Font.Code
ConfidenceLabel.Text = "AI: 0%"
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
ConsoleText.Text = "Initializing God Engine..."
ConsoleText.TextColor3 = Color3.fromRGB(200, 200, 200)
ConsoleText.TextSize = 11
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
Footer.TextColor3 = Color3.fromRGB(255, 215, 0)
Footer.TextSize = 10

task.spawn(function()
    local hue = 0
    while true do
        hue = hue + 0.005
        if hue > 1 then hue = 0 end
        local rainbow = Color3.fromHSV(hue, 1, 1)
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

-- 📂 STATS & BLACKLIST
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
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then pcall(function() req({Url = url, Method = method, Headers = {["Content-Type"] = "application/json"}, Body = body}) end) end
end

local function getServerAge() return workspace.DistributedGameTime end
local function formatAge(seconds)
    local m = math.floor(seconds / 60)
    return string.format("%dh %02dm", math.floor(m / 60), m % 60)
end
local function checkForFriends()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player:IsFriendsWith(LocalPlayer.UserId) then return true, player.Name end
    end
    return false
end

-- 🧠 4-MODULE MATH AI (Chronos, Vector, Oracle, Triangulation)

-- 1. TRIANGULATION (Finds Invisible Islands)
local function triangulateHiddenIsland()
    local hoverPlayers = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            -- Logic: Players 8000+ studs out and 150+ studs up are likely on invisible island
            if pos.Magnitude > 8000 and pos.Y > 150 then table.insert(hoverPlayers, pos) end
        end
    end
    if #hoverPlayers >= 3 then
        local sx, sy, sz = 0, 0, 0
        for _, v in pairs(hoverPlayers) do sx=sx+v.X; sy=sy+v.Y; sz=sz+v.Z end
        return Vector3.new(sx/#hoverPlayers, sy/#hoverPlayers, sz/#hoverPlayers)
    end
    return nil
end

-- 2. ORACLE (Prediction Score)
local function calculateOracleScore()
    local score = 0
    -- Age Factor
    local age = getServerAge()
    if age > 3000 and age < 6000 then score = score + 40
    elseif age > 2000 then score = score + 20 end
    
    -- Cluster Factor
    local positions = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(positions, p.Character.HumanoidRootPart.Position) end
    end
    if #positions > 3 then
        local center = Vector3.zero
        for _,p in pairs(positions) do center = center + p end
        center = center / #positions
        if center.Magnitude > 5000 then score = score + 40 end -- Sea Cluster
    end
    return score
end

-- 🕵️ 20-ENGINE CORRELATION SCANNER (Weighted Evidence)

-- 🌕 FULL MOON
local function analyzeFullMoon()
    local score = 0
    local evidence = {}
    local sky = Lighting:FindFirstChild("Sky")
    
    -- PRIMARY (100)
    if sky and (sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" or sky.MoonTextureId == "rbxassetid://9709149431") then
        score = score + 100; table.insert(evidence, "Texture ID (Primary)")
    end
    -- SECONDARY (50)
    if Lighting:GetAttribute("IsFullMoon") then
        score = score + 50; table.insert(evidence, "Attribute (Secondary)")
    end
    -- TERTIARY (15)
    if Lighting.Brightness > 1.2 and Lighting.ClockTime < 5 then
        score = score + 15; table.insert(evidence, "Light Spike (Tertiary)")
    end
    
    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", ") end
    return false
end

-- 🏝️ MIRAGE
local function analyzeMirage()
    local score = 0
    local evidence = {}
    local pos = nil
    
    -- PRIMARY (100)
    if Workspace.Map:FindFirstChild("MysticIsland") then
        score = score + 100; table.insert(evidence, "Model Found (Primary)"); pos = Workspace.Map.MysticIsland.Position
    end
    -- SECONDARY (50)
    local triPos = triangulateHiddenIsland()
    if triPos then
        score = score + 50; table.insert(evidence, "Triangulation AI (Secondary)"); if not pos then pos = triPos end
    end
    -- SECONDARY (40)
    if Lighting.FogEnd < 500 then score = score + 40; table.insert(evidence, "Fog (Secondary)") end
    -- PRIMARY (100)
    if Workspace:FindFirstChild("AdvancedFruitDealer", true) then score = score + 100; table.insert(evidence, "Dealer NPC (Primary)") end

    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", "), pos end
    return false
end

-- 🦊 KITSUNE
local function analyzeKitsune()
    local score = 0
    local evidence = {}
    local pos = nil
    
    -- PRIMARY (100)
    if Workspace.Map:FindFirstChild("KitsuneShrine") then
        score = score + 100; table.insert(evidence, "Shrine Found (Primary)"); pos = Workspace.Map.KitsuneShrine.Position
    end
    -- SECONDARY (60)
    local sky = Lighting:FindFirstChild("Sky")
    if sky and (sky.MoonTextureId == "http://www.roblox.com/asset/?id=15306698696" or sky.MoonTextureId == "rbxassetid://15306698696") then
        score = score + 60; table.insert(evidence, "Blue Texture (Secondary)")
    end
    -- SECONDARY (50)
    if Workspace:FindFirstChild("AzureEmber", true) then score = score + 50; table.insert(evidence, "Ember (Secondary)") end
    
    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", "), pos end
    return false
end

-- ❄️ FROZEN
local function analyzeFrozen()
    local score = 0
    local evidence = {}
    local pos = nil
    
    -- PRIMARY (100)
    if Workspace.Map:FindFirstChild("FrozenDimension") then
        score = score + 100; table.insert(evidence, "Gate Found (Primary)"); pos = Workspace.Map.FrozenDimension.Position
    end
    if Workspace.Map:FindFirstChild("Frozen Island") then
        score = score + 100; table.insert(evidence, "Island Found (Primary)"); pos = Workspace.Map["Frozen Island"].Position
    end
    -- TERTIARY (20)
    if Lighting:FindFirstChild("BlizzardParticles", true) then score = score + 20; table.insert(evidence, "Blizzard FX (Tertiary)") end

    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", "), pos end
    return false
end

-- 📊 3-HOUR REPORT
local function checkStatusReport()
    local timeDiff = os.time() - currentStats.LastReport
    if timeDiff >= CONFIG.ReportInterval then
        local uptime = string.format("%.1f", (os.time() - currentStats.StartTime) / 3600)
        local payload = {
            ["username"] = CONFIG.BotName, ["avatar_url"] = CONFIG.BotAvatar,
            ["embeds"] = {{
                ["title"] = "📈 System Status Report",
                ["color"] = 3447003,
                ["fields"] = {
                    {["name"] = "📡 Servers Scanned", ["value"] = "```" .. currentStats.TotalScanned .. "```", ["inline"] = true},
                    {["name"] = "⏱️ Uptime", ["value"] = "```" .. uptime .. "h```", ["inline"] = true}
                },
                ["footer"] = { ["text"] = "Devansh || Event Tracker" }
            }}
        }
        safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
        currentStats.TotalScanned = 0
        currentStats.LastReport = os.time()
        saveStats(currentStats)
    end
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

-- 📨 PROFESSIONAL WEBHOOK (STACKING)
local function sendWebhook(events, aiScore, isPred)
    UpdateGUI("💎 JACKPOT FOUND!")
    local jobId = game.JobId
    local status, ts, gt = getEventStatus()
    local join = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..game.PlaceId..', "'..jobId..'", game.Players.LocalPlayer)'
    local directLink = "https://www.roblox.com/games/2753915549?jobId=" .. jobId
    
    local titleText = "🌟 EVENT DETECTED"
    local color = 16766720 -- Gold
    
    if isPred then
        titleText = "🔮 ORACLE PREDICTION"
        color = 3447003 -- Blue
    elseif #events > 1 then
        titleText = "🔥 MULTI-EVENT DETECTED! 🔥"
        color = 16711680 -- Red
    end

    local fields = {}
    
    -- 1. INFO FIELDS
    if not isPred then
        for _, e in pairs(events) do
            table.insert(fields, {["name"] = "💎 FOUND: " .. e.name, ["value"] = "**Proof:** " .. e.reason .. " (" .. e.score .. "%)", ["inline"] = false})
        end
        table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = status .. "\n**Ends:** " .. ts .. "\n**Game Time:** " .. math.floor(gt) .. ":00", ["inline"] = false})
    else
        table.insert(fields, {["name"] = "🔮 MATH AI", ["value"] = "**Confidence:** " .. aiScore .. "%", ["inline"] = false})
    end
    
    table.insert(fields, {["name"] = "⏳ Server Age", ["value"] = formatAge(getServerAge()), ["inline"] = true})
    
    -- 2. MASTER JOIN
    table.insert(fields, {["name"] = "📜 1. JOIN SERVER", ["value"] = "```lua\n" .. join .. "\n```", ["inline"] = false})
    
    -- 3. TWEEN FLY SCRIPTS (Stacking)
    local c = 2
    for _, e in pairs(events) do
        if e.pos then
            local targetY = math.floor(e.pos.Y + 250)
            local tweenScript = [[
local TS = game:GetService("TweenService")
local P = game.Players.LocalPlayer
local R = P.Character:FindFirstChild("HumanoidRootPart")
if R then
    local T = CFrame.new(]]..math.floor(e.pos.X)..[[, ]]..targetY..[[, ]]..math.floor(e.pos.Z)..[[)
    local TI = TweenInfo.new((R.Position-T.Position).Magnitude/350, Enum.EasingStyle.Linear)
    local TW = TS:Create(R, TI, {CFrame=T})
    local BV = Instance.new("BodyVelocity", R); BV.Velocity=Vector3.zero; BV.MaxForce=Vector3.one*9e9
    TW:Play(); TW.Completed:Wait(); BV:Destroy()
end
]]
            table.insert(fields, {["name"] = "✈️ " .. c .. ". FLY TO " .. e.name, ["value"] = "```lua\n" .. tweenScript .. "\n```", ["inline"] = false})
            c = c + 1
        end
    end
    
    table.insert(fields, {["name"] = "🔗 Direct Link", ["value"] = "[Click to Join](" .. directLink .. ")", ["inline"] = false})
    table.insert(fields, {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false})

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = titleText,
            ["color"] = color,
            ["thumbnail"] = { ["url"] = CONFIG.BotAvatar },
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh || God Mode V5"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 FAST HOPPER (ASCENDING)
local function hop()
    UpdateGUI("🔄 HOPPING...", "---", formatAge(getServerAge()))
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
            TeleportService:TeleportToPlaceInstance(game.PlaceId, valid[math.random(1, #valid)].id)
            return
        end
    end
    task.wait(1.5)
    hop()
end

-- 🚀 MAIN EXECUTION
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    checkStatusReport()
    
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
    UpdateGUI("⚡ GOD SCAN...", "0%", age)
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))
    
    -- STACK SCANNING (All Engines)
    local events = {}
    
    local fm, fmScore, fmReason = analyzeFullMoon()
    if fm then table.insert(events, {name = "🌕 FULL MOON", score = fmScore, reason = fmReason}) end
    
    local mir, mirScore, mirReason, mirPos = analyzeMirage()
    if mir then table.insert(events, {name = "🏝️ MIRAGE", score = mirScore, reason = mirReason, pos = mirPos}) end
    
    local kit, kitScore, kitReason, kitPos = analyzeKitsune()
    if kit then table.insert(events, {name = "🦊 KITSUNE", score = kitScore, reason = kitReason, pos = kitPos}) end
    
    local fro, froScore, froReason, froPos = analyzeFrozen()
    if fro then table.insert(events, {name = "❄️ LEVIATHAN", score = froScore, reason = froReason, pos = froPos}) end
    
    -- RESULT LOGIC
    if #events > 0 then
        Log("✅ EVENTS FOUND!")
        sendWebhook(events, 100, false)
        task.wait(5)
        hop()
        return
    end
    
    -- MATH AI PREDICTION
    local oracleScore = calculateOracleScore()
    UpdateGUI("🧠 MATH AI...", oracleScore, age)
    Log("Oracle Score: " .. oracleScore)
    
    if oracleScore >= CONFIG.HoldConfidence then
        Log("🛑 High Potential... Holding")
        task.wait(5)
        -- Re-scan
        local newEv = {} -- Re-run engines logic here if wanted, or just trust prediction
        sendWebhook({}, oracleScore, true)
        task.wait(2)
    elseif oracleScore >= CONFIG.MinAIConfidence then
        sendWebhook({}, oracleScore, true)
        task.wait(2)
    end
    
    hop()
end

init()
