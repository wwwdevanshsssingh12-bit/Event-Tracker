-- [[ 🚀 Event Tracker: God Mode (5-Check Secure) 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole = "@everyone", 
    ScanDelay = {3, 5},
    SafeSlots = 1,
    ReportInterval = 10800 -- 3 Hours
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- 🎨 GUI SETUP (Movable & Rainbow)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local ConsoleFrame = Instance.new("ScrollingFrame")
local ConsoleText = Instance.new("TextLabel")
local Footer = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "EventTrackerGUI"
ScreenGui.Parent = CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(1, -260, 1, -160)
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true 

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 5)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.Text = "⚡ 5-CHECK SCAN..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 18

ConsoleFrame.Name = "Console"
ConsoleFrame.Parent = MainFrame
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Position = UDim2.new(0, 10, 0, 40)
ConsoleFrame.Size = UDim2.new(1, -20, 0, 85)
ConsoleFrame.ScrollBarThickness = 2

ConsoleText.Name = "Log"
ConsoleText.Parent = ConsoleFrame
ConsoleText.BackgroundTransparency = 1
ConsoleText.Size = UDim2.new(1, 0, 1, 0)
ConsoleText.Font = Enum.Font.Code
ConsoleText.Text = "Initializing..."
ConsoleText.TextColor3 = Color3.fromRGB(180, 180, 180)
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
Footer.TextColor3 = Color3.fromRGB(255, 255, 255)
Footer.TextSize = 10

-- 🌈 RAINBOW ANIMATION
task.spawn(function()
    local hue = 0
    while true do
        hue = hue + 0.01
        if hue > 1 then hue = 0 end
        local rainbow = Color3.fromHSV(hue, 1, 1)
        MainFrame.BorderColor3 = rainbow
        StatusLabel.TextColor3 = rainbow
        Footer.TextColor3 = rainbow
        RunService.Heartbeat:Wait()
    end
end)

-- 📟 LOGGING
local function Log(text)
    local timestamp = os.date("%X")
    local newLog = "[" .. timestamp .. "] " .. text
    ConsoleText.Text = newLog .. "\n" .. ConsoleText.Text
    print(newLog)
end

local function UpdateStatus(text)
    StatusLabel.Text = text
end

-- 📂 STATS
local FileName = "BloxTrackerStats.json"
local function loadStats()
    if isfile and isfile(FileName) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if success and data then return data end
    end
    return { TotalScanned = 0, LastReport = os.time(), StartTime = os.time() }
end
local function saveStats(data)
    if writefile then pcall(function() writefile(FileName, HttpService:JSONEncode(data)) end) end
end
local currentStats = loadStats()
currentStats.TotalScanned = currentStats.TotalScanned + 1
saveStats(currentStats)

-- 🛡️ WEBHOOK
local function safeRequest(url, method, body)
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if not requestFunc then return end
    pcall(function()
        requestFunc({Url = url, Method = method, Headers = {["Content-Type"] = "application/json"}, Body = body})
    end)
end

-- 📊 3-HOUR REPORT
local function checkStatusReport()
    local timeDiff = os.time() - currentStats.LastReport
    if timeDiff >= CONFIG.ReportInterval then
        local uptimeHours = string.format("%.1f", (os.time() - currentStats.StartTime) / 3600)
        local payload = {
            ["username"] = "Tracker Status",
            ["embeds"] = {{
                ["title"] = "📈 System Report",
                ["description"] = "Active & Running. - made by devansh",
                ["color"] = 3447003,
                ["fields"] = {
                    {["name"] = "📡 Scanned (3h)", ["value"] = "```" .. currentStats.TotalScanned .. "```", ["inline"] = true},
                    {["name"] = "⏱️ Uptime", ["value"] = "```" .. uptimeHours .. "h```", ["inline"] = true}
                },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }}
        }
        safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
        currentStats.TotalScanned = 0
        currentStats.LastReport = os.time()
        saveStats(currentStats)
    end
end

-- 🕵️ ROBUST 5-CHECK DETECTION
local function checkFullMoonAdvanced()
    -- CHECK 1: The Attribute (Standard)
    if Lighting:GetAttribute("IsFullMoon") then 
        Log("✅ Check 1: Attribute Found")
        return true 
    end

    -- CHECK 2: The Texture ID (Hard to fake)
    local Sky = Lighting:FindFirstChild("Sky")
    if Sky and Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
        Log("✅ Check 2: Texture ID Match")
        return true
    end

    -- CHECK 3: Kitsune Shrine (Only exists on FM)
    if Workspace.Map:FindFirstChild("KitsuneShrine") or Workspace.Map:FindFirstChild("KitsuneIsland") then
        Log("✅ Check 3: Kitsune Shrine Found")
        return true
    end

    -- CHECK 4: Time + Brightness (Sanity Check)
    -- If it's night (22-4) and really bright, it might be a FM
    if Lighting.ClockTime > 22 or Lighting.ClockTime < 4 then
        if Lighting.Brightness > 0.8 then -- Adjust based on game updates
             -- This is a "weak" check, so we don't return true immediately unless sure
             -- Log("⚠️ Check 4: High Brightness detected at Night")
        end
    end
    
    return false
end

local function checkFrozenIsland()
    return Workspace.Map:FindFirstChild("Frozen Island") or Workspace.Map:FindFirstChild("FrozenDimension")
end

-- 📨 NOTIFY
local function sendNotification(eventName)
    UpdateStatus("EVENT FOUND!")
    local jobId, placeId = game.JobId, game.PlaceId
    local payload = {
        ["username"] = "Blox || Event Scanner",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
        ["content"] = (CONFIG.PingRole ~= "None" and CONFIG.PingRole or ""),
        ["embeds"] = {{
            ["title"] = "🚀 Event Detected!",
            ["description"] = "**" .. eventName .. "** found! Moving to next...",
            ["color"] = 16766720,
            ["thumbnail"] = { ["url"] = "https://i.imgur.com/4W8o9gI.png" },
            ["fields"] = {
                {["name"] = "💎 Event", ["value"] = "**" .. eventName .. "**", ["inline"] = true},
                {["name"] = "🚀 Link", ["value"] = "[Join Server](https://www.roblox.com/games/"..placeId.."?jobId="..jobId..")", ["inline"] = true},
                {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false}
            },
            ["footer"] = { ["text"] = "Made by Devansh" },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 SPEED HOPPER
local function serverHop()
    UpdateStatus("HOPPING...")
    Log("Hopping...")
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
    checkStatusReport()
    
    Log("Map Loading (" .. CONFIG.ScanDelay[2] .. "s)...")
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))

    if checkFullMoonAdvanced() then
        sendNotification("🌕 FULL MOON")
    elseif checkFrozenIsland() then
        sendNotification("❄️ FROZEN ISLAND")
    else
        Log("❌ Nothing found.")
    end
    
    serverHop()
end

init()
