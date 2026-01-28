-- [[ 🏆 Event Tracker: Gold Edition (Anti-Ban & Auto-Exec) 🏆 ]] --

-- ⚙️ SYSTEM CONFIGURATION
local CONFIG = {
    WebhookURL = "YOUR_WEBHOOK_URL_HERE",   -- ⚠️ PASTE WEBHOOK HERE
    StopOnMoon = true,         -- Stop for Full Moon?
    StopOnFrozen = true,       -- Stop for Leviathan?
    PingRole = "@everyone",    -- Ping role ("@everyone" or "None")
    ScanDelay = {5, 8},        -- Random delay between 5s and 8s (Anti-Ban)
    EmbedColor = 16766720,     -- 🎨 Gold Color
    SafeSlots = 2              -- Join servers with at least this many empty slots
}

-- 🔄 ROBLOX SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

-- 🛡️ ERROR-PROOF REQUESTS
local function safeRequest(url, method, body)
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if not requestFunc then return false, "Executor not supported" end

    local success, response = pcall(function()
        return requestFunc({
            Url = url,
            Method = method,
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        })
    end)
    return success, response
end

-- 🕵️ LEGENDARY EVENT DETECTION
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

-- 📨 PROFESSIONAL GOLD WEBHOOK
local function sendNotification(eventName)
    local jobId = game.JobId
    local placeId = game.PlaceId
    
    local payload = {
        ["username"] = "Blox || Event Scanner",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png", -- Gold Icon
        ["content"] = (CONFIG.PingRole ~= "None" and CONFIG.PingRole or ""),
        ["embeds"] = {{
            ["title"] = "🌟 Legendary Event Secured",
            ["description"] = "The automation system has successfully intercepted a **Rare Event** in the Third Sea.\n\n**Status:** 🟢 Account Holding Server (Anti-AFK Active)",
            ["color"] = CONFIG.EmbedColor,
            ["thumbnail"] = { ["url"] = "https://i.imgur.com/4W8o9gI.png" },
            ["fields"] = {
                {["name"] = "💎 Detected Event", ["value"] = "```" .. eventName .. "```", ["inline"] = true},
                {["name"] = "⚓ Server Region", ["value"] = "Third Sea (Public)", ["inline"] = true},
                {["name"] = "🚪 Direct Join Script", ["value"] = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance("..placeId..", '"..jobId.."')\n```", ["inline"] = false}
            },
            ["footer"] = {
                ["text"] = "Blox || Utils • Security & Automation",
                ["icon_url"] = "https://i.imgur.com/4W8o9gI.png"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 SMART SERVER HOP (ANTI-BAN)
local function serverHop()
    print("🔄 Scanning... No events found. Initializing Hop...")
    
    -- Random Anti-Ban Delay before requesting API
    task.wait(math.random(1, 3))
    
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            -- SAFETY CHECK: Only join if there are 'SafeSlots' empty
            if server.playing < (server.maxPlayers - CONFIG.SafeSlots) and server.id ~= game.JobId then
                print("🚀 Joining Server: " .. server.id)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end
    end
    
    print("⚠️ No valid server found. Randomizing...")
    TeleportService:Teleport(game.PlaceId)
end

-- 🛡️ ANTI-AFK SYSTEM
local function startAntiAFK()
    print("🛡️ Anti-AFK Enabled. Securing Server...")
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- 🚀 MAIN EXECUTION LOOP
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- Anti-Ban: Random load time to look human
    local waitTime = math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2])
    print("⏳ System Loaded. Verifying Map (" .. waitTime .. "s)...")
    task.wait(waitTime)

    if checkFullMoon() and CONFIG.StopOnMoon then
        sendNotification("🌕 FULL MOON (100%)")
        startAntiAFK()
    elseif checkFrozenIsland() and CONFIG.StopOnFrozen then
        sendNotification("❄️ FROZEN ISLAND (Leviathan)")
        startAntiAFK()
    else
        serverHop()
    end
end

init()
