-- [[ 🚀 Event Tracker: Continuous Scanner Mode 🚀 ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole = "@everyone",    -- Role to ping
    ScanDelay = {4, 6},        -- Wait time before scanning (seconds)
    EmbedColor = 16766720,     -- Gold Color
    SafeSlots = 1,             -- Minimum empty slots needed to join
    ThirdSeaID = 7449423635    -- 3rd Sea ID
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- 🛑 STRICT 3RD SEA CHECK
if game.PlaceId ~= CONFIG.ThirdSeaID then
    warn("❌ Not in Third Sea! Script Stopped.")
    return 
end

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

-- 🕵️ EVENT DETECTION
local function checkFullMoon()
    if Lighting:GetAttribute("IsFullMoon") then return true end
    if Lighting.Sky and Lighting.Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then return true end
    return false
end

local function checkFrozenIsland()
    if Workspace.Map:FindFirstChild("Frozen Island") or Workspace.Map:FindFirstChild("FrozenDimension") then
        return true
    end
    return false
end

-- 📨 NOTIFICATION SENDER
local function sendNotification(eventName)
    local jobId = game.JobId
    local placeId = game.PlaceId
    local joinLink = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId

    local payload = {
        ["username"] = "Blox || Continuous Scanner",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
        ["content"] = (CONFIG.PingRole ~= "None" and CONFIG.PingRole or ""),
        ["embeds"] = {{
            ["title"] = "🚀 Event Passed & Logged",
            ["description"] = "A **" .. eventName .. "** was detected!\nBot is **moving to next server** immediately.",
            ["color"] = CONFIG.EmbedColor,
            ["thumbnail"] = { ["url"] = "https://i.imgur.com/4W8o9gI.png" },
            ["fields"] = {
                {["name"] = "💎 Event", ["value"] = "**" .. eventName .. "**", ["inline"] = true},
                {["name"] = "🚀 Direct Link", ["value"] = "[**Click to Join Fast**](" .. joinLink .. ")", ["inline"] = true},
                {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false}
            },
            ["footer"] = {
                ["text"] = "Blox || Scanner • Auto-Hopping...",
                ["icon_url"] = "https://i.imgur.com/4W8o9gI.png"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 SERVER HOPPER
local function serverHop()
    print("🔄 Hopping to next server...")
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

-- 🚀 MAIN EXECUTION
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    print("✨ Event Tracker Started. Scanning in " .. CONFIG.ScanDelay[2] .. "s...") 
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2])) -- Wait for map load

    -- 1. Check for Moon
    if checkFullMoon() then
        sendNotification("🌕 FULL MOON")
        print("✅ Moon Logged! Moving on...")
        task.wait(2) -- Give Discord 2 seconds to receive msg
    
    -- 2. Check for Frozen Island
    elseif checkFrozenIsland() then
        sendNotification("❄️ FROZEN ISLAND")
        print("✅ Leviathan Logged! Moving on...")
        task.wait(2) -- Give Discord 2 seconds to receive msg
    end

    -- 3. ALWAYS HOP (No matter what was found)
    serverHop()
end

init()
