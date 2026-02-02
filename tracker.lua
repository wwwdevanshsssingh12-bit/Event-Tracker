-- [[ 🚀 GOD MODE: MULTI-TARGET TELEPORT EDITION 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- 🔴 PASTE YOUR WEBHOOK HERE:
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    -- 🖼️ BOT SETTINGS
    BotName = "Event Tracker",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1466792067199008848/669726ef5242a23882952518_663fc2a1da49d30b9a44e774_image_3cN5ZzSm_1715403464233_raw.jpg?ex=698153d0&is=69800250&hm=8e3fcf8bb9d64f2254fdd63493b084586bf0c6eb7ad373ff5c32f6e7c1016c5d&",

    -- ⚡ SCAN SETTINGS
    PingRole = "@everyone", 
    ScanDelay = {2, 3},     -- Super fast scan
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
StatusLabel.Text = "⚡ GOD SCANNING..."
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

-- 📂 STATS & BLACKLIST SYSTEM
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

-- 🛡️ FRIEND CHECKER (Ejector)
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

-- ⏳ LIVE TIME STATUS
local function getEventStatus()
    local currentTime = Lighting.ClockTime
    local status = "🟢 Unknown"
    local discordTimestamp = "Unknown"
    
    if currentTime >= 18 or currentTime < 5 then
        local hoursLeft = 0
        if currentTime >= 18 then hoursLeft = (24 - currentTime) + 5
        else hoursLeft = 5 - currentTime end
        
        -- Estimate Seconds (50s buffer per game hour)
        local secondsLeft = math.floor(hoursLeft * 50) 
        local futureTime = os.time() + secondsLeft
        -- Magic Timestamp for Discord: Counts down live
        discordTimestamp = "<t:" .. futureTime .. ":R>"
        
        if hoursLeft > 4 then status = "🟢 FRESH (Just Started)"
        elseif hoursLeft > 1.5 then status = "🟢 ACTIVE"
        elseif hoursLeft > 0.5 then status = "🟠 ENDING SOON"
        else status = "🔴 CRITICAL (Expiring!)" end
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

-- 🕵️ EVENT SCANNER
local function scanAllEvents()
    local detectedEvents = {}
    local Sky = Lighting:FindFirstChild("Sky")
    
    -- Check Full Moon
    if Sky and Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then table.insert(detectedEvents, {name = "🌕 FULL MOON", method = "Texture Match"})
    elseif Lighting:GetAttribute("IsFullMoon") then table.insert(detectedEvents, {name = "🌕 FULL MOON", method = "Attribute Check"}) end
    
    -- Check Islands & Gates (These have Locations)
    if Workspace.Map:FindFirstChild("FrozenDimension") then 
        local pos = Workspace.Map.FrozenDimension.Position
        table.insert(detectedEvents, {name = "❄️ LEVIATHAN GATE", method = "Gate Object", pos = pos})
    elseif Workspace.Map:FindFirstChild("Frozen Island") then 
        local pos = Workspace.Map["Frozen Island"].Position 
        table.insert(detectedEvents, {name = "❄️ FROZEN ISLAND", method = "Island Mesh", pos = pos}) 
    end
    
    if Workspace.Map:FindFirstChild("KitsuneShrine") then 
        local pos = Workspace.Map.KitsuneShrine.Position
        table.insert(detectedEvents, {name = "🦊 KITSUNE ISLAND", method = "Physical Island", pos = pos})
    end
    
    if Workspace.Map:FindFirstChild("MysticIsland") then 
        local pos = Workspace.Map.MysticIsland.Position
        table.insert(detectedEvents, {name = "🏝️ MIRAGE ISLAND", method = "Physical Island", pos = pos})
    end

    return detectedEvents
end

-- 📨 PROFESSIONAL WEBHOOK (MULTI-SCRIPT ENGINE)
local function sendStackedNotification(eventsList, isPrediction, aiScore, aiReason)
    UpdateGUI("💎 JACKPOT FOUND!")
    local jobId, placeId = game.JobId, game.PlaceId
    local age = formatAge(getServerAge())
    local status, discordTimestamp, gameHour = getEventStatus()
    
    -- 1. MASTER JOIN SCRIPT (Always First)
    local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..placeId..', "'..jobId..'", game.Players.LocalPlayer)'
    local directLink = "https://www.roblox.com/games/2753915549?jobId=" .. jobId
    
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
        table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = status .. "\n🕐 **Ends:** " .. discordTimestamp .. "\n🕛 **Game Time:** " .. math.floor(gameHour) .. ":00", ["inline"] = false})
    else
        table.insert(fields, {["name"] = "🔮 PREDICTION:", ["value"] = "**" .. aiReason .. "** (Confidence: " .. aiScore .. "%)", ["inline"] = false})
    end

    table.insert(fields, {["name"] = "⏳ Server Age", ["value"] = "`" .. age .. "`", ["inline"] = true})
    
    -- 📜 SCRIPT BLOCK 1: MASTER JOIN
    table.insert(fields, {["name"] = "📜 1. JOIN SERVER (Required)", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})
    
    -- 🏝️ SCRIPT BLOCKS 2+: INDIVIDUAL TELEPORTS
    local tpCount = 1
    for _, ev in pairs(eventsList) do
        if ev.pos then
            tpCount = tpCount + 1
            local x, y, z = math.floor(ev.pos.X), math.floor(ev.pos.Y + 120), math.floor(ev.pos.Z) -- Safe Height
            local tpScript = 'game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new('..x..', '..y..', '..z..')'
            
            table.insert(fields, {["name"] = "🏝️ " .. tpCount .. ". TP TO " .. ev.name, ["value"] = "```lua\n" .. tpScript .. "\n```", ["inline"] = false})
        end
    end

    table.insert(fields, {["name"] = "🔗 Direct Link (PC Only)", ["value"] = "[Click to Join](" .. directLink .. ") *⚠️ Won't work on Mobile*", ["inline"] = false})
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
            ["footer"] = { ["text"] = "Devansh || Event Tracker" },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 FAST HOPPER (ASCENDING ONLY)
local function serverHop()
    UpdateGUI("🔄 HOPPING...", "---", formatAge(getServerAge()))
    Log("⚡ Fast Hop (Ascending)...")
    
    -- FORCE ASCENDING to find smaller/faster servers
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    
    if success and result and result.data then
        local validServers = {}
        for _, server in pairs(result.data) do
            -- 1. Check Blacklist
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
            -- Pick random from the list to avoid always picking #1
            local randomServer = validServers[math.random(1, #validServers)]
            Log("🚀 Joining: " .. randomServer.id)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id)
            return
        end
    end
    
    Log("❌ Retry...")
    task.wait(2)
    serverHop() 
end

-- 🚀 MAIN EXECUTION
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- 1. FRIEND CHECK
    local hasFriend, friendName = checkForFriends()
    if hasFriend then
        Log("🚨 Friend Detected (" .. friendName .. ")! Ejecting...")
        UpdateGUI("🛡️ FRIEND DETECTED! LEAVING...", "---", "---")
        table.insert(currentStats.Blacklist, {id = game.JobId, time = os.time()})
        saveStats(currentStats)
        task.wait(1)
        serverHop() 
        return
    end
    
    local ageFormatted = formatAge(getServerAge())
    UpdateGUI("⚡ FAST SCAN...", "0%", ageFormatted)
    Log("Server Age: " .. ageFormatted)
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))

    -- 2. SCAN EVENTS
    local foundEvents = scanAllEvents()
    if #foundEvents > 0 then
        Log("✅ FOUND EVENTS!")
        sendStackedNotification(foundEvents, false, nil, nil)
        task.wait(2)
        serverHop()
        return 
    end

    -- 3. AI PREDICTION
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
