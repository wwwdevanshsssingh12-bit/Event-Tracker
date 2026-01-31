-- [[ 🚀 GOD MODE: RAW DATA CLIENT 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- 🔴 YOUR PRIVATE (HIDDEN) WEBHOOK
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    ScanDelay = {2, 4},       
    SafeSlots = 1,
    MinAIConfidence = 75,     
    HoldConfidence = 90,      
    BlacklistTime = 3600
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

-- 🛡️ FRIEND CHECKER (The Ejector)
local function checkForFriends()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player:IsFriendsWith(LocalPlayer.UserId) then
                return true
            end
        end
    end
    return false
end

-- ⏳ TIMEKEEPER (Returns Seconds Remaining)
local function getTimeRemaining()
    local currentTime = Lighting.ClockTime
    if currentTime >= 18 or currentTime < 5 then
        local hoursLeft = 0
        if currentTime >= 18 then hoursLeft = (24 - currentTime) + 5
        else hoursLeft = 5 - currentTime end
        
        -- Game Hour to Real Seconds (Approx 50s per hour buffer)
        return math.floor(hoursLeft * 50)
    end
    return 0
end

-- 🧠 GOD AI ENGINE
local function calculateAI()
    local score = 0
    local reasons = {}
    local age = workspace.DistributedGameTime
    
    -- Time Logic
    if age > 3200 and age < 5000 then score = score + 40; table.insert(reasons, "Prime Time")
    elseif age > 2500 and age <= 3200 then score = score + 15; table.insert(reasons, "Moon Soon") end

    -- Player Logic
    local seaCluster, templeCluster = 0, 0
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            if pos.Magnitude > 12000 then seaCluster = seaCluster + 1 end
            local distToTree = (Vector3.new(28200, 0, -12000) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
            if distToTree < 1000 and pos.Y > 500 then templeCluster = templeCluster + 1 end
        end
    end
    if seaCluster >= 3 then score = score + 15; table.insert(reasons, "Deep Sea Squad") end
    if templeCluster >= 1 then score = score + 30; table.insert(reasons, "Temple Campers") end

    return score, table.concat(reasons, ", ")
end

-- 🕵️ EVENT SCANNER
local function scanAllEvents()
    local events = {}
    local Sky = Lighting:FindFirstChild("Sky")
    
    if (Sky and Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431") or Lighting:GetAttribute("IsFullMoon") then table.insert(events, "🌕 FULL MOON") end
    if Workspace.Map:FindFirstChild("FrozenDimension") then table.insert(events, "❄️ LEVIATHAN GATE") end
    if Workspace.Map:FindFirstChild("Frozen Island") then table.insert(events, "❄️ FROZEN ISLAND") end
    if Workspace.Map:FindFirstChild("KitsuneShrine") then table.insert(events, "🦊 KITSUNE ISLAND") end
    if Workspace.Map:FindFirstChild("MysticIsland") then table.insert(events, "🏝️ MIRAGE ISLAND") end

    return events
end

-- 📨 RAW DATA SENDER (No Embeds Here!)
local function sendDataPacket(statusType, eventsList, aiScore, aiReason)
    local jobId = game.JobId
    local placeId = game.PlaceId
    local secondsLeft = getTimeRemaining()
    local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..placeId..', "'..jobId..'", game.Players.LocalPlayer)'
    
    -- Construct Pure JSON Payload
    local data = {
        ["type"] = "DATA_PACKET",
        ["payload"] = {
            ["status"] = statusType, -- "CONFIRMED" or "PREDICTION"
            ["events"] = eventsList,
            ["ai_score"] = aiScore,
            ["ai_reason"] = aiReason,
            ["seconds_left"] = secondsLeft,
            ["job_id"] = jobId,
            ["join_script"] = joinScript,
            ["server_age"] = math.floor(workspace.DistributedGameTime)
        }
    }

    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if requestFunc then
        requestFunc({
            Url = CONFIG.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({["content"] = HttpService:JSONEncode(data)}) -- Nested JSON for Bot to parse content string
        })
    end
end

-- 🐇 DEEP SCROLL HOPPER
local function serverHop()
    local sortOrders = {"Desc", "Asc"}
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrders[math.random(1, 2)] .. "&excludeFullGames=true&limit=100"
    
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    
    if success and result and result.data then
        local validServers = {}
        for _, server in pairs(result.data) do
            local isBlacklisted = false
            for _, entry in pairs(currentStats.Blacklist) do
                if entry.id == server.id then isBlacklisted = true break end
            end
            if not isBlacklisted and server.playing < (server.maxPlayers - CONFIG.SafeSlots) and server.id ~= game.JobId then
                table.insert(validServers, server)
            end
        end
        
        if #validServers > 0 then
            local randomServer = validServers[math.random(1, #validServers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id)
            return
        end
    end
    task.wait(2)
    serverHop()
end

-- 🚀 MAIN INIT
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- 1. Friend Ejector
    if checkForFriends() then
        table.insert(currentStats.Blacklist, {id = game.JobId, time = os.time()})
        saveStats(currentStats)
        serverHop()
        return
    end
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))
    
    -- 2. Scan
    local foundEvents = scanAllEvents()
    if #foundEvents > 0 then
        -- FOUND! Send Data
        sendDataPacket("CONFIRMED", foundEvents, 100, "Hard Detect")
        task.wait(3)
        serverHop()
        return
    end
    
    -- 3. AI Prediction
    local score, reason = calculateAI()
    if score >= CONFIG.HoldConfidence then
        task.wait(5) -- Hold for visual check
        foundEvents = scanAllEvents()
        if #foundEvents > 0 then
            sendDataPacket("CONFIRMED", foundEvents, 100, "Visual Confirm")
        else
            sendDataPacket("PREDICTION", {}, score, reason)
        end
        task.wait(3)
    elseif score >= CONFIG.MinAIConfidence then
        sendDataPacket("PREDICTION", {}, score, reason)
        task.wait(3)
    end
    
    serverHop()
end

init()
