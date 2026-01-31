-- [[ 🚀 GOD MODE: SMART HOPPER EDITION 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole = "@everyone", 
    ScanDelay = {2, 4},       
    SafeSlots = 1,
    MinAIConfidence = 75,     
    HoldConfidence = 90,      
    ReportInterval = 10800,
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

-- 🎨 GUI SETUP
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
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Gold
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
StatusLabel.Text = "⚡ SMART HOP SCAN..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 18

ConfidenceLabel.Name = "AIStatus"
ConfidenceLabel.Parent = MainFrame
ConfidenceLabel.BackgroundTransparency = 1
ConfidenceLabel.Position = UDim2.new(0, 10, 0, 30)
ConfidenceLabel.Size = UDim2.new(0.5, 0, 0, 20)
ConfidenceLabel.Font = Enum.Font.Code
ConfidenceLabel.Text = "Prob: 0%"
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
ConsoleText.Text = "Script Loaded..."
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
    if prob then ConfidenceLabel.Text = "Prob: " .. prob .. "%" end
    if age then AgeLabel.Text = "Age: " .. age end
end

-- 📂 STATS & BLACKLIST SYSTEM (Cleaned)
local FileName = "BloxTrackerStats.json"

local function cleanBlacklist(data)
    local now = os.time()
    local newBlacklist = {}
    if data.Blacklist then
        for _, entry in pairs(data.Blacklist) do
            if (now - entry.time) < CONFIG.BlacklistTime then
                table.insert(newBlacklist, entry)
            end
        end
    end
    data.Blacklist = newBlacklist
    return data
end

local function loadStats()
    if isfile and isfile(FileName) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if success and data then 
            if not data.Blacklist then data.Blacklist = {} end
            return cleanBlacklist(data)
        end
    end
    return { TotalScanned = 0, LastReport = os.time(), StartTime = os.time(), Blacklist = {} }
end

local function saveStats(data)
    if writefile then pcall(function() writefile(FileName, HttpService:JSONEncode(data)) end) end
end

local currentStats = loadStats()
currentStats.TotalScanned = currentStats.TotalScanned + 1
saveStats(currentStats)

-- 🛡️ FRIEND CHECKER
local function checkForFriends()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player:IsFriendsWith(LocalPlayer.UserId) then
                return true, player.Name
            end
        end
    end
    return false, nil
end

local function safeRequest(url, method, body)
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if not requestFunc then return end
    
    local success, err = pcall(function()
        requestFunc({Url = url, Method = method, Headers = {["Content-Type"] = "application/json"}, Body = body})
    end)
    
    if not success then
        warn("⚠️ Webhook Failed: " .. tostring(err))
        Log("⚠️ Webhook Failed! Check Console.")
    end
end

local function getServerAge() return workspace.DistributedGameTime end
local function formatAge(seconds)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    minutes = minutes % 60
    return string.format("%dh %02dm", hours, minutes)
end

-- 📊 3-HOUR REPORT FUNCTION
local function checkStatusReport()
    local timeDiff = os.time() - currentStats.LastReport
    if timeDiff >= CONFIG.ReportInterval then
        Log("Sending 3-Hour Report...")
        local uptimeHours = string.format("%.1f", (os.time() - currentStats.StartTime) / 3600)

        local payload = {
            ["username"] = "Tracker Stats",
            ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
            ["embeds"] = {{
                ["title"] = "📈 System Status Report",
                ["description"] = "The tracking system is active.",
                ["color"] = 3447003,
                ["fields"] = {
                    {["name"] = "📡 Servers Scanned (3h)", ["value"] = "```" .. currentStats.TotalScanned .. " Servers```", ["inline"] = true},
                    {["name"] = "⏱️ Total Uptime", ["value"] = "```" .. uptimeHours .. " Hours```", ["inline"] = true}
                },
                ["footer"] = { ["text"] = "Devansh || Event Tracker" },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }}
        }
        
        safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
        
        -- Reset Cycle
        currentStats.TotalScanned = 0
        currentStats.LastReport = os.time()
        saveStats(currentStats)
    end
end

-- ⏳ EXPIRATION CALCULATOR
local function getEventStatus()
    local currentTime = Lighting.ClockTime
    local status = "🟢 Unknown"
    local discordTimestamp = "Unknown"
    
    if currentTime >= 18 or currentTime < 5 then
        local hoursLeft = 0
        if currentTime >= 18 then
            hoursLeft = (24 - currentTime) + 5
        else
            hoursLeft = 5 - currentTime
        end
        
        local secondsLeft = math.floor(hoursLeft * 50) 
        local futureTime = os.time() + secondsLeft
        discordTimestamp = "<t:" .. futureTime .. ":R>"
        
        if hoursLeft > 4 then
            status = "🟢 FRESH (Just Started)"
        elseif hoursLeft > 1.5 then
            status = "🟢 ACTIVE"
        elseif hoursLeft > 0.5 then
            status = "🟠 ENDING SOON"
        else
            status = "🔴 CRITICAL (Expiring!)"
        end
    else
        status = "🔴 EXPIRED (Day Time)"
        discordTimestamp = "Ended"
    end
    
    return status, discordTimestamp, currentTime
end

-- 🧠 GOD AI ENGINE
local function calculateAI()
    local score = 0
    local reasons = {}
    local ageSeconds = getServerAge()
    
    if ageSeconds > 3200 and ageSeconds < 5000 then 
        score = score + 40
        table.insert(reasons, "Prime Time")
    elseif ageSeconds > 2500 and ageSeconds <= 3200 then
        score = score + 15
        table.insert(reasons, "Moon in ~15m")
    end

    if Lighting.ClockTime > 20 or Lighting.ClockTime < 5 then
        score = score + 10
        if Lighting.Brightness > 0.6 then
            score = score + 20
            table.insert(reasons, "High Brightness")
        end
    end

    local seaCluster = 0
    local templeCluster = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            if pos.Magnitude > 12000 then seaCluster = seaCluster + 1 end
            local distToTree = (Vector3.new(28200, 0, -12000) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
            if distToTree < 1000 and pos.Y > 500 then templeCluster = templeCluster + 1 end
        end
    end
    if seaCluster >= 3 then score = score + 15; table.insert(reasons, "Deep Sea Squad") end
    if templeCluster >= 1 then score = score + 30; table.insert(reasons, "V4 Temple Campers") end

    return score, table.concat(reasons, ", ")
end

-- 🕵️ STACKED CHECKER
local function scanAllEvents()
    local detectedEvents = {}

    local Sky = Lighting:FindFirstChild("Sky")
    if Sky and Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then 
        table.insert(detectedEvents, {name = "🌕 FULL MOON", method = "Texture Match"})
    elseif Lighting:GetAttribute("IsFullMoon") then 
        table.insert(detectedEvents, {name = "🌕 FULL MOON", method = "Attribute Check"})
    end
    
    if Workspace.Map:FindFirstChild("FrozenDimension") then 
        table.insert(detectedEvents, {name = "❄️ LEVIATHAN GATE", method = "Gate Object"})
    elseif Workspace.Map:FindFirstChild("Frozen Island") then
        table.insert(detectedEvents, {name = "❄️ FROZEN ISLAND", method = "Island Mesh"})
    end
    
    if Workspace.Map:FindFirstChild("KitsuneShrine") or Workspace.Map:FindFirstChild("KitsuneIsland") then 
        table.insert(detectedEvents, {name = "🦊 KITSUNE ISLAND", method = "Physical Island"})
    end

    if Workspace.Map:FindFirstChild("MysticIsland") or Workspace.Map:FindFirstChild("Mystic Island") then 
        table.insert(detectedEvents, {name = "🏝️ MIRAGE ISLAND", method = "Physical Island"})
    end

    return detectedEvents
end

-- 📨 PROFESSIONAL WEBHOOK (Fixed Copy Block)
local function sendStackedNotification(eventsList, isPrediction, aiScore, aiReason)
    UpdateGUI("💎 JACKPOT FOUND!")
    local jobId, placeId = game.JobId, game.PlaceId
    local age = formatAge(getServerAge())
    local status, discordTimestamp, gameHour = getEventStatus()
    
    local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..placeId..', "'..jobId..'", game.Players.LocalPlayer)'
    local titleText = "🌟 EVENT DETECTED"
    local color = 16766720 -- Gold
    
    if isPrediction then
        titleText = "🔮 AI PREDICTION"
        color = 3447003 -- Blue
    elseif #eventsList > 1 then
        titleText = "🔥 DOUBLE/TRIPLE EVENT! 🔥"
        color = 16711680 -- Red Hype
    end

    if string.find(status, "CRITICAL") or string.find(status, "EXPIRED") then
        color = 10038562 -- Dark Red
        titleText = "⚠️ EXPIRING EVENT FOUND"
    end

    local fields = {}
    
    if not isPrediction then
        for _, ev in pairs(eventsList) do
            table.insert(fields, {["name"] = "💎 FOUND:", ["value"] = "**" .. ev.name .. "** (" .. ev.method .. ")", ["inline"] = false})
        end
        table.insert(fields, {["name"] = "⏳ STATUS / TIMER", ["value"] = status .. "\n🕐 **Ends:** " .. discordTimestamp .. "\n🕛 **Game Time:** " .. math.floor(gameHour) .. ":00", ["inline"] = false})
    else
        table.insert(fields, {["name"] = "🔮 PREDICTION:", ["value"] = "**" .. aiReason .. "** (Confidence: " .. aiScore .. "%)", ["inline"] = false})
    end

    table.insert(fields, {["name"] = "⏳ Server Age", ["value"] = "`" .. age .. "`", ["inline"] = true})
    -- SPECIAL SEPARATE FIELD FOR COPYING
    table.insert(fields, {["name"] = "👇 JOIN SCRIPT (Copy Below)", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})
    table.insert(fields, {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false})

    local payload = {
        ["username"] = "Event Tracker",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
        ["content"] = CONFIG.PingRole, 
        ["embeds"] = {{
            ["title"] = titleText,
            ["color"] = color,
            ["thumbnail"] = { ["url"] = "https://i.imgur.com/4W8o9gI.png" },
            ["fields"] = fields,
            ["footer"] = { ["text"] = "Devansh || Event Tracker" },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 HOPPER (FIXED: SMART RANDOM + NO FRIENDS)
local function serverHop()
    UpdateGUI("🔄 HOPPING...", "---", formatAge(getServerAge()))
    
    -- Randomly toggle between Ascending (Empty) and Descending (Full) to avoid "Same 100 Servers" loop
    local sortOrders = {"Desc", "Asc"}
    local chosenSort = sortOrders[math.random(1, 2)]
    
    Log("🎲 Searching Public Servers (" .. chosenSort .. ")...")
    
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. chosenSort .. "&excludeFullGames=true&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    
    if success and result and result.data then
        local validServers = {}
        for _, server in pairs(result.data) do
            -- 1. Check Blacklist (Friend Zone)
            local isBlacklisted = false
            for _, entry in pairs(currentStats.Blacklist) do
                if entry.id == server.id then isBlacklisted = true break end
            end
            
            -- 2. Add if Safe, Not Current, Not Blacklisted
            if not isBlacklisted and server.playing < (server.maxPlayers - CONFIG.SafeSlots) and server.id ~= game.JobId then
                table.insert(validServers, server)
            end
        end
        
        if #validServers > 0 then
            local randomServer = validServers[math.random(1, #validServers)]
            Log("🚀 Joining: " .. randomServer.id)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id)
            return
        end
    end
    
    -- Fallback: Just try again
    Log("❌ API Error/No Servers. Retrying...")
    task.wait(2)
    serverHop() 
end

-- 🚀 MAIN EXECUTION
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    checkStatusReport()

    -- 🛡️ 1. CHECK FOR FRIENDS (THE EJECTOR)
    local hasFriend, friendName = checkForFriends()
    if hasFriend then
        Log("🚨 FRIEND DETECTED: " .. friendName)
        UpdateGUI("🛡️ FRIEND DETECTED! EJECTING...", "---", "---")
        
        -- Add to Blacklist (1 Hour)
        table.insert(currentStats.Blacklist, {id = game.JobId, time = os.time()})
        saveStats(currentStats)
        
        task.wait(1)
        serverHop() 
        return
    end
    
    -- 2. NORMAL SCAN
    local ageFormatted = formatAge(getServerAge())
    UpdateGUI("🔍 SCANNING...", "0%", ageFormatted)
    Log("Server Age: " .. ageFormatted)
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))

    local foundEvents = scanAllEvents()
    
    if #foundEvents > 0 then
        Log("✅ FOUND EVENTS!")
        sendStackedNotification(foundEvents, false, nil, nil)
        task.wait(2)
        serverHop()
        return 
    end

    local aiScore, aiReasons = calculateAI()
    UpdateGUI("🧠 ANALYZING DATA...", aiScore, ageFormatted)
    Log("AI Score: " .. aiScore .. "%")

    if aiScore >= CONFIG.HoldConfidence then
        Log("🛑 AI High Confidence! Holding...")
        UpdateGUI("🛑 HOLDING...", aiScore, ageFormatted)
        task.wait(5) 
        
        foundEvents = scanAllEvents()
        if #foundEvents > 0 then
            sendStackedNotification(foundEvents, false, nil, nil)
            task.wait(2)
        else
            sendStackedNotification({}, true, aiScore, aiReasons)
            task.wait(2)
        end

    elseif aiScore >= CONFIG.MinAIConfidence then
        Log("⚠️ Reporting Prediction...")
        sendStackedNotification({}, true, aiScore, aiReasons)
        task.wait(2)
    end
    
    serverHop()
end

init()
