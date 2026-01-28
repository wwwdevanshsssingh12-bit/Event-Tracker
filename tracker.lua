-- [[ 🌕 Event Tracker: Gold Edition 🌕 ]] --

-- ⚙️ CONFIGURATION
local SETTINGS = {
    WebhookURL = "https://hooks.hyra.io/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",  -- ⚠️ PASTE YOUR WEBHOOK LINK HERE
    StopOnMoon = true,        -- Stop hopping if Full Moon is found?
    StopOnFrozen = true,      -- Stop hopping if Frozen Island is found?
    PingRole = "@everyone",   -- "@everyone", "@here", or "None"
    ScanDelay = 6,            -- Seconds to wait for map to load
    EmbedColor = 16766720     -- 🎨 GOLD COLOR (Decimal for 0xFFD700)
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- 🛡️ SECURE REQUEST FUNCTION
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

-- 🕵️ DETECTION LOGIC
local function checkFullMoon()
    if Lighting:GetAttribute("IsFullMoon") then return true end
    if Lighting.Sky and Lighting.Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then return true end
    return false
end

local function checkFrozenIsland()
    -- Checks for common Leviathan spawn indicators
    if Workspace.Map:FindFirstChild("Frozen Island") or Workspace.Map:FindFirstChild("FrozenDimension") then
        return true
    end
    return false
end

-- 📨 GOLD WEBHOOK SENDER
local function sendAlert(eventType)
    local job = game.JobId
    local place = game.PlaceId
    
    local payload = {
        ["username"] = "Event Tracker",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png", -- Gold Icon
        ["content"] = (SETTINGS.PingRole ~= "None" and SETTINGS.PingRole or ""),
        ["embeds"] = {{
            ["title"] = "🏆 Legendary Event Detected",
            ["description"] = "The system has secured a server with a **Rare Event**.\n**Status:** 🟢 Bot Holding Server (AFK Mode Active)",
            ["color"] = SETTINGS.EmbedColor,
            ["fields"] = {
                {["name"] = "🌟 Event Type", ["value"] = "**" .. eventType .. "**", ["inline"] = true},
                {["name"] = "⚓ Sea Region", ["value"] = "Third Sea", ["inline"] = true},
                {["name"] = "🚪 Join Command", ["value"] = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(" .. place .. ", '" .. job .. "')\n```", ["inline"] = false}
            },
            ["footer"] = {
                ["text"] = "Event Tracker • Official Automation",
                ["icon_url"] = "https://i.imgur.com/4W8o9gI.png"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    local success, err = safeRequest(SETTINGS.WebhookURL, "POST", HttpService:JSONEncode(payload))
    if not success then warn("⚠️ Webhook Error: " .. tostring(err)) else print("✅ Gold Alert Sent!") end
end

-- 🐇 SERVER HOPPING
local function hop()
    print("⏳ Scanning... No event found. Hopping...")
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId) -- Fallback
end

-- 🚀 MAIN EXECUTION
if not game:IsLoaded() then game.Loaded:Wait() end
print("✨ Event Tracker Started. Waiting " .. SETTINGS.ScanDelay .. "s...")
task.wait(SETTINGS.ScanDelay)

if checkFullMoon() and SETTINGS.StopOnMoon then
    sendAlert("🌕 FULL MOON (100%)")
    print("🛑 MOON FOUND. Engaging Anti-AFK.")
elseif checkFrozenIsland() and SETTINGS.StopOnFrozen then
    sendAlert("❄️ FROZEN ISLAND (Leviathan)")
    print("🛑 LEVIATHAN FOUND. Engaging Anti-AFK.")
else
    hop()
    return
end

-- 🛑 ANTI-AFK (Only runs if event is found)
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)
