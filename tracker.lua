-- [[ 🏴‍☠️ Event Tracker: Gold Edition (Strict 3rd Sea) 🏴‍☠️ ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://hooks.hyra.io/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",   -- ⚠️ PASTE WEBHOOK HERE
    StopOnMoon = true,
    StopOnFrozen = true,
    PingRole = "@everyone",
    ScanDelay = {4, 7},         -- Random scan delay
    EmbedColor = 16766720,      -- Gold Color
    SafeSlots = 2,              -- Keep 2 slots open
    ThirdSeaID = 7449423635     -- 🔒 STRICT ID for Third Sea
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

-- 🛑 STRICT 3RD SEA CHECK
if game.PlaceId ~= CONFIG.ThirdSeaID then
    warn("❌ ERROR: Script stopped. You are NOT in the Third Sea!")
    -- Optional: Kick player or show alert
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Wrong Sea Detected";
        Text = "This script only works in the Third Sea.";
        Duration = 10;
    })
    return -- 🛑 STOPS THE SCRIPT HERE
end

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

-- 📨 PROFESSIONAL WEBHOOK (LINK + ID + SCRIPT)
local function sendNotification(eventName)
    local jobId = game.JobId
    local placeId = game.PlaceId
    local joinLink = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId

    local payload = {
        ["username"] = "Blox || Event Scanner",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
        ["content"] = (CONFIG.PingRole ~= "None" and CONFIG.PingRole or ""),
        ["embeds"] = {{
            ["title"] = "🌟 Legendary Event Secured",
            ["description"] = "The automation system has successfully intercepted a **Rare Event** in the Third Sea.\n\n**Status:** 🟢 Account Holding Server (Anti-AFK Active)",
            ["color"] = CONFIG.EmbedColor,
            ["thumbnail"] = { ["url"] = "https://i.imgur.com/4W8o9gI.png" },
            ["fields"] = {
                {["name"] = "💎 Detected Event", ["value"] = "**" .. eventName .. "**", ["inline"] = true},
                {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = true},
                {["name"] = "🚀 Direct Join Link", ["value"] = "[**Click Here to Join**](" .. joinLink .. ")", ["inline"] = false},
                {["name"] = "📜 Executor Script", ["value"] = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance("..placeId..", '"..jobId.."')\n```", ["inline"] = false}
            },
            ["footer"] = {
                ["text"] = "Blox || Utils • 3rd Sea Only",
                ["icon_url"] = "https://i.imgur.com/4W8o9gI.png"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 ROBUST SERVER HOP (WITH ERROR HANDLING)
local function serverHop()
    print("🔄 Scanning... No events found. Hopping...")
    task.wait(math.random(1, 2))
    
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < (server.maxPlayers - CONFIG.SafeSlots) and server.id ~= game.JobId then
                print("🚀 Teleporting to: " .. server.id)
                
                local tpSuccess, tpErr = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                end)
                
                if not tpSuccess then
                    warn("⚠️ Teleport Failed: " .. tostring(tpErr) .. " - Retrying next server...")
                    task.wait(1)
                else
                    return -- Success!
                end
            end
        end
    end
    
    print("⚠️ No valid server found or API failed. Random Refresh...")
    TeleportService:Teleport(game.PlaceId)
end

-- 🛡️ ANTI-AFK
local function startAntiAFK()
    print("🛡️ Anti-AFK Enabled. Holding Server...")
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- 🚀 MAIN EXECUTION
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- Delay for map load
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))

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
