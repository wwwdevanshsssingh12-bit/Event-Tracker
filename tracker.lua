-- [[ 🚀 GOD MODE: BOT DATA LINK V4 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- 🔴 HIDDEN WEBHOOK (Your Private Admin Channel)
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

-- ⏳ TIME CALCULATOR (Returns Seconds Left)
local function getTimeRemaining()
    local currentTime = Lighting.ClockTime
    if currentTime >= 18 or currentTime < 5 then
        local hoursLeft = 0
        if currentTime >= 18 then hoursLeft = (24 - currentTime) + 5
        else hoursLeft = 5 - currentTime end
        
        -- Convert game hours to real seconds (approx 50s per hour)
        return math.floor(hoursLeft * 50)
    end
    return 0
end

-- 🕵️ EVENT SCANNER
local function scanAllEvents()
    local detectedEvents = {}
    local Sky = Lighting:FindFirstChild("Sky")
    
    if Sky and Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then table.insert(detectedEvents, "🌕 FULL MOON")
    elseif Lighting:GetAttribute("IsFullMoon") then table.insert(detectedEvents, "🌕 FULL MOON") end
    
    if Workspace.Map:FindFirstChild("FrozenDimension") then table.insert(detectedEvents, "❄️ LEVIATHAN GATE")
    elseif Workspace.Map:FindFirstChild("Frozen Island") then table.insert(detectedEvents, "❄️ FROZEN ISLAND") end
    
    if Workspace.Map:FindFirstChild("KitsuneShrine") then table.insert(detectedEvents, "🦊 KITSUNE ISLAND") end
    if Workspace.Map:FindFirstChild("MysticIsland") then table.insert(detectedEvents, "🏝️ MIRAGE ISLAND") end

    return detectedEvents
end

-- 📨 BOT DATA SENDER
local function sendToBot(eventsList)
    local jobId, placeId = game.JobId, game.PlaceId
    local secondsLeft = getTimeRemaining()
    
    -- Prepare the Script string for the button
    local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..placeId..', "'..jobId..'", game.Players.LocalPlayer)'
    
    -- Combine events into one string
    local eventString = table.concat(eventsList, " + ")
    
    -- Construct the Data Packet (JSON)
    local payload = {
        ["content"] = "DATA_PACKET", -- Bot trigger
        ["embeds"] = {{
            ["title"] = "RAW_DATA",
            ["description"] = joinScript, -- Hidden script
            ["fields"] = {
                {["name"] = "Events", ["value"] = eventString, ["inline"] = false},
                {["name"] = "SecondsLeft", ["value"] = tostring(secondsLeft), ["inline"] = false},
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
    local sortOrders = {"Desc", "Asc"}
    -- Random sort + Limit 100
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
    
    -- 1. Friend Check
    local hasFriend, friendName = checkForFriends()
    if hasFriend then
        table.insert(currentStats.Blacklist, {id = game.JobId, time = os.time()})
        saveStats(currentStats)
        serverHop()
        return
    end
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))
    
    -- 2. Event Check
    local foundEvents = scanAllEvents()
    if #foundEvents > 0 then
        sendToBot(foundEvents)
        task.wait(3) 
    end
    
    serverHop()
end

init()
