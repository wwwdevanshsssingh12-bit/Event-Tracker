-- [[ 🚀 GOD MODE: AI + BOT + FRIEND EJECTOR 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- 🔴 PUT YOUR PRIVATE (HIDDEN) WEBHOOK HERE:
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
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
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 📟 UTILITIES
local function Log(text)
    print("[GOD MODE]: " .. text)
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

local function getServerAge() return workspace.DistributedGameTime end

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

-- 🧠 GOD AI ENGINE (RESTORED)
local function calculateAI()
    local score = 0
    local reasons = {}
    local ageSeconds = getServerAge()
    
    -- 1. SERVER AGE
    if ageSeconds > 3200 and ageSeconds < 5000 then 
        score = score + 40
        table.insert(reasons, "Prime Time")
    elseif ageSeconds > 2500 and ageSeconds <= 3200 then
        score = score + 15
        table.insert(reasons, "Moon in ~15m")
    end

    -- 2. LIGHTING CHECKS
    if Lighting.ClockTime > 20 or Lighting.ClockTime < 5 then
        score = score + 10
        if Lighting.Brightness > 0.6 then
            score = score + 20
            table.insert(reasons, "High Brightness")
        end
    end

    -- 3. PLAYER BEHAVIOR (The "God Mode" Check)
    local seaCluster = 0
    local templeCluster = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            -- Checking Deep Sea (Z > 12000)
            if pos.Magnitude > 12000 then seaCluster = seaCluster + 1 end
            -- Checking Great Tree / Temple
            local distToTree = (Vector3.new(28200, 0, -12000) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
            if distToTree < 1000 and pos.Y > 500 then templeCluster = templeCluster + 1 end
        end
    end
    
    if seaCluster >= 3 then 
        score = score + 15
        table.insert(reasons, "Deep Sea Squad") 
    end
    if templeCluster >= 1 then 
        score = score + 30
        table.insert(reasons, "V4 Temple Campers") 
    end

    return score, table.concat(reasons, ", ")
end

-- 🕵️ EVENT SCANNER
local function scanAllEvents()
    local detectedEvents = {}
    local Sky = Lighting:FindFirstChild("Sky")
    
    -- Moon Checks
    if Sky and Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then table.insert(detectedEvents, {name = "🌕 FULL MOON"})
    elseif Lighting:GetAttribute("IsFullMoon") then table.insert(detectedEvents, {name = "🌕 FULL MOON"}) end
    
    -- Frozen Checks
    if Workspace.Map:FindFirstChild("FrozenDimension") then table.insert(detectedEvents, {name = "❄️ LEVIATHAN GATE"})
    elseif Workspace.Map:FindFirstChild("Frozen Island") then table.insert(detectedEvents, {name = "❄️ FROZEN ISLAND"}) end
    
    -- Island Checks
    if Workspace.Map:FindFirstChild("KitsuneShrine") then table.insert(detectedEvents, {name = "🦊 KITSUNE ISLAND"}) end
    if Workspace.Map:FindFirstChild("MysticIsland") then table.insert(detectedEvents, {name = "🏝️ MIRAGE ISLAND"}) end

    return detectedEvents
end

-- 📨 BOT COMMUNICATOR (Sends Data to Python Bot)
local function sendToBot(eventsList, isPrediction, aiScore, aiReason)
    local jobId, placeId = game.JobId, game.PlaceId
    
    -- Prepare the Script for the Copy Button
    local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..placeId..', "'..jobId..'", game.Players.LocalPlayer)'
    
    -- Format Event Text
    local eventText = ""
    if not isPrediction then
        for _, ev in pairs(eventsList) do
            eventText = eventText .. ev.name .. " | "
        end
    else
        eventText = "🔮 PREDICTION: " .. aiReason .. " (" .. aiScore .. "%)"
    end

    -- Construct Data Packet
    local payload = {
        ["content"] = "DATA_PACKET",
        ["embeds"] = {{
            ["title"] = "RAW_DATA",
            ["description"] = joinScript, -- Stored here for Bot to grab
            ["fields"] = {
                {["name"] = "Events", ["value"] = eventText, ["inline"] = false},
                {["name"] = "ServerAge", ["value"] = tostring(math.floor(workspace.DistributedGameTime)), ["inline"] = false},
                {["name"] = "JobId", ["value"] = jobId, ["inline"] = false}
            }
        }}
    }
    
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if requestFunc then
        requestFunc({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)})
    end
end

-- 🐇 SMART HOPPER
local function serverHop()
    Log("Hopping...")
    local sortOrders = {"Desc", "Asc"}
    -- Randomly flip sort order to find different servers
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

-- 🚀 MAIN EXECUTION
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- 1. FRIEND CHECK (Ejector)
    local hasFriend, friendName = checkForFriends()
    if hasFriend then
        Log("🚨 Friend Detected! Ejecting...")
        table.insert(currentStats.Blacklist, {id = game.JobId, time = os.time()})
        saveStats(currentStats)
        serverHop()
        return
    end
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))
    
    -- 2. HARD EVENT CHECK
    local foundEvents = scanAllEvents()
    if #foundEvents > 0 then
        Log("💎 Jackpot found! Sending to Bot...")
        sendToBot(foundEvents, false, nil, nil)
        task.wait(3) 
        serverHop()
        return
    end

    -- 3. AI PREDICTION CHECK
    local aiScore, aiReasons = calculateAI()
    Log("🧠 AI Score: " .. aiScore .. "% (" .. aiReasons .. ")")

    if aiScore >= CONFIG.HoldConfidence then
        -- High Confidence: WAIT and CHECK AGAIN
        Log("🛑 AI High Confidence! Holding for 5s...")
        task.wait(5)
        
        -- Re-scan after waiting
        foundEvents = scanAllEvents()
        if #foundEvents > 0 then
            sendToBot(foundEvents, false, nil, nil)
            task.wait(3)
        else
            -- If still nothing but score is high, report prediction
            sendToBot({}, true, aiScore, aiReasons)
            task.wait(3)
        end
        
    elseif aiScore >= CONFIG.MinAIConfidence then
        -- Medium Confidence: Report Prediction immediately
        Log("⚠️ Reporting Prediction...")
        sendToBot({}, true, aiScore, aiReasons)
        task.wait(3)
    end
    
    serverHop()
end

init()
