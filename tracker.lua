-- [[ 📊 Event Tracker: Gold Edition (With 3-Hour Stats) 📊 ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- ⚠️ PASTE YOUR LEWISAKURA LINK HERE:
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole = "@everyone", 
    ScanDelay = {4, 6},
    EmbedColor = 16766720, -- Gold
    SafeSlots = 1,
    ReportInterval = 10800 -- 3 Hours (in seconds)
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- 📂 FILE SYSTEM (PERSISTENT STATS)
local FileName = "BloxTrackerStats.json"

local function loadStats()
    if isfile and isfile(FileName) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if success and data then return data end
    end
    -- Default Data if file doesn't exist
    return { TotalScanned = 0, LastReport = os.time(), StartTime = os.time() }
end

local function saveStats(data)
    if writefile then
        pcall(function() writefile(FileName, HttpService:JSONEncode(data)) end)
    end
end

-- Update Stats immediately upon load
local currentStats = loadStats()
currentStats.TotalScanned = currentStats.TotalScanned + 1
saveStats(currentStats)

-- 🛡️ ERROR-PROOF REQUESTS
local function safeRequest(url, method, body)
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if not requestFunc then return end
    pcall(function()
        requestFunc({
            Url = url,
            Method = method,
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        })
    end)
end

-- 📊 SEND STATUS REPORT (Every 3 Hours)
local function checkStatusReport()
    local timeDiff = os.time() - currentStats.LastReport
    
    if timeDiff >= CONFIG.ReportInterval then
        local uptimeSeconds = os.time() - currentStats.StartTime
        local uptimeHours = string.format("%.1f", uptimeSeconds / 3600)

        local payload = {
            ["username"] = "Tracker Status",
            ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
            ["embeds"] = {{
                ["title"] = "📈 Periodic System Report",
                ["description"] = "The automation system is active and running efficiently.",
                ["color"] = 3447003, -- Blue for Status
                ["fields"] = {
                    {["name"] = "📡 Servers Scanned (Last 3h)", ["value"] = "```" .. currentStats.TotalScanned .. " Servers```", ["inline"] = true},
                    {["name"] = "⏱️ Total Uptime", ["value"] = "```" .. uptimeHours .. " Hours```", ["inline"] = true},
                    {["name"] = "🟢 Current Status", ["value"] = "Scanning Third Sea...", ["inline"] = false}
                },
                ["footer"] = { ["text"] = "Auto-Report • " .. os.date("%X") },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }}
        }
        
        safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
        
        -- Reset Counter but keep StartTime
        currentStats.TotalScanned = 0
        currentStats.LastReport = os.time()
        saveStats(currentStats)
    end
end

-- 🕵️ EVENT DETECTION
local function checkFullMoon()
    if Lighting:GetAttribute("IsFullMoon") then return true end
    if Lighting.Sky and Lighting.Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then return true end
    return false
end

local function checkFrozenIsland()
    return Workspace.Map:FindFirstChild("Frozen Island") or Workspace.Map:FindFirstChild("FrozenDimension")
end

-- 📨 FOUND EVENT NOTIFICATION
local function sendNotification(eventName)
    local jobId = game.JobId
    local placeId = game.PlaceId
    local joinLink = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId

    local payload = {
        ["username"] = "Blox || Event Scanner",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
        ["content"] = (CONFIG.PingRole ~= "None" and CONFIG.PingRole or ""),
        ["embeds"] = {{
            ["title"] = "🚀 Event Passed & Logged",
            ["description"] = "A **" .. eventName .. "** was detected!\nBot is **moving to next server** immediately.",
            ["color"] = CONFIG.EmbedColor,
            ["thumbnail"] = { ["url"] = "https://i.imgur.com/4W8o9gI.png" },
            ["fields"] = {
                {["name"] = "💎 Event", ["value"] = "**" .. eventName .. "**", ["inline"] = true},
                {["name"] = "🚀 Link", ["value"] = "[Join Server](" .. joinLink .. ")", ["inline"] = true},
                {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false}
            },
            ["footer"] = { ["text"] = "Scanner • Auto-Hopping..." },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 SERVER HOPPER
local function serverHop()
    print("🔄 Hopping...")
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < (server.maxPlayers - CONFIG.SafeSlots) and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId)
end

-- 🚀 MAIN
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- Check if we need to send the 3-hour report
    checkStatusReport()

    print("✨ Event Tracker Started.") 
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))

    if checkFullMoon() then
        sendNotification("🌕 FULL MOON")
    elseif checkFrozenIsland() then
        sendNotification("❄️ FROZEN ISLAND")
    end

    serverHop()
end

init()
