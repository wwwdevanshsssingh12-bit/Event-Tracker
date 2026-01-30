-- [[ 🚀 ULTRA GOD MODE: OMNISCIENT ORACLE EDITION 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole = "@everyone", 
    ScanDelay = {2, 4},       
    SafeSlots = 1,
    MinAIConfidence = 75,     -- AI must be 75% sure to report a "Prediction"
    HoldConfidence = 90,      -- If AI is 90% sure, it WAITS to confirm (instead of hopping)
    ReportInterval = 10800    -- 3 Hours
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
local ConfidenceLabel = Instance.new("TextLabel")
local AgeLabel = Instance.new("TextLabel") 
local ConsoleFrame = Instance.new("ScrollingFrame")
local ConsoleText = Instance.new("TextLabel")
local Footer = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "EventTrackerOmni"
ScreenGui.Parent = CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(1, -280, 1, -200)
MainFrame.Size = UDim2.new(0, 260, 0, 190)
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
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.Text = "🔮 OMNISCIENT SCAN..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 18

-- AI STATS
ConfidenceLabel.Name = "AIStatus"
ConfidenceLabel.Parent = MainFrame
ConfidenceLabel.BackgroundTransparency = 1
ConfidenceLabel.Position = UDim2.new(0, 10, 0, 30)
ConfidenceLabel.Size = UDim2.new(0.5, 0, 0, 20)
ConfidenceLabel.Font = Enum.Font.Code
ConfidenceLabel.Text = "Prob: 0%"
ConfidenceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
ConfidenceLabel.TextSize = 12
ConfidenceLabel.TextXAlignment = Enum.TextXAlignment.Left

AgeLabel.Name = "AgeStatus"
AgeLabel.Parent = MainFrame
AgeLabel.BackgroundTransparency = 1
AgeLabel.Position = UDim2.new(0.5, -10, 0, 30)
AgeLabel.Size = UDim2.new(0.5, 0, 0, 20)
AgeLabel.Font = Enum.Font.Code
AgeLabel.Text = "Age: 00m"
AgeLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
AgeLabel.TextSize = 12
AgeLabel.TextXAlignment = Enum.TextXAlignment.Right

ConsoleFrame.Name = "Console"
ConsoleFrame.Parent = MainFrame
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Position = UDim2.new(0, 10, 0, 60)
ConsoleFrame.Size = UDim2.new(1, -20, 0, 105)
ConsoleFrame.ScrollBarThickness = 2

ConsoleText.Name = "Log"
ConsoleText.Parent = ConsoleFrame
ConsoleText.BackgroundTransparency = 1
ConsoleText.Size = UDim2.new(1, 0, 1, 0)
ConsoleText.Font = Enum.Font.Code
ConsoleText.Text = "Oracle Engine Initialized..."
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
Footer.Text = "- God AI by Devansh -"
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

local function UpdateGUI(status, prob, age) 
    if status then StatusLabel.Text = status end
    if prob then ConfidenceLabel.Text = "Prob: " .. prob .. "%" end
    if age then AgeLabel.Text = "Age: " .. age end
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

-- 🕒 SERVER AGE UTILS
local function getServerAge()
    return workspace.DistributedGameTime
end

local function formatAge(seconds)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    minutes = minutes % 60
    return string.format("%dh %02dm", hours, minutes)
end

-- 🧠 GOD AI: PROBABILITY ENGINE
local function calculateAI()
    local score = 0
    local reasons = {}
    local ageSeconds = getServerAge()
    
    -- 1. SERVER AGE (Temporal Math)
    -- Full moon window: Approx 60-80 mins.
    if ageSeconds > 3200 and ageSeconds < 5000 then -- 53m to 83m (GOLD ZONE)
        score = score + 40
        table.insert(reasons, "Prime Time")
    elseif ageSeconds > 2500 and ageSeconds <= 3200 then -- 41m to 53m (COMING SOON)
        score = score + 15
        table.insert(reasons, "Moon in ~15m")
    end

    -- 2. LIGHTING (Visuals)
    if Lighting.ClockTime > 20 or Lighting.ClockTime < 5 then
        score = score + 10
        if Lighting.Brightness > 0.6 then
            score = score + 20
            table.insert(reasons, "High Brightness")
        end
    end

    -- 3. THE SPY (Behavior Analysis)
    local seaCluster = 0
    local templeCluster = 0 -- Race V4 Watcher
    
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            
            -- CHECK A: Hunting in Deep Sea (Kitsune/Mirage/Leviathan)
            if pos.Magnitude > 12000 then
                seaCluster = seaCluster + 1
            end
            
            -- CHECK B: Temple of Time (Great Tree Top)
            -- Great Tree is roughly at X: 28200, Z: -12000. 
            -- The top (V4 lever) is very high Y (Height).
            local distToTree = (Vector3.new(28200, 0, -12000) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
            if distToTree < 1000 and pos.Y > 500 then -- High up at Tree
                templeCluster = templeCluster + 1
            end
        end
    end
    
    if seaCluster >= 3 then
        score = score + 15
        table.insert(reasons, "Players in Deep Sea")
    end
    
    if templeCluster >= 1 then -- Even 1 player waiting at temple is suspicious
        score = score + 30 
        table.insert(reasons, "Player at V4 Temple")
    end

    return score, table.concat(reasons, ", ")
end

-- 🕵️ HARD EVENT CHECKER (100% Certainty)
local function checkHardEvents()
    -- MOON
    local Sky = Lighting:FindFirstChild("Sky")
    if Sky and Sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then 
        return "🌕 FULL MOON", "Texture Match", 100 
    end
    if Lighting:GetAttribute("IsFullMoon") then 
        return "🌕 FULL MOON", "Attribute Check", 100
    end
    
    -- LEVIATHAN
    if Workspace.Map:FindFirstChild("FrozenDimension") then
        return "❄️ LEVIATHAN GATE", "Gate Object", 100
    end
    
    -- KITSUNE
    if Workspace.Map:FindFirstChild("KitsuneShrine") or Workspace.Map:FindFirstChild("KitsuneIsland") then
        return "🦊 KITSUNE ISLAND", "Physical Island", 100
    end

    -- MIRAGE
    if Workspace.Map:FindFirstChild("MysticIsland") or Workspace.Map:FindFirstChild("Mystic Island") then
        return "🏝️ MIRAGE ISLAND", "Physical Island", 100
    end

    return nil, nil, 0
end

-- 📨 NOTIFY
local function sendNotification(eventName, method, confidence, extraInfo)
    UpdateGUI("🎯 REPORTING...")
    local jobId, placeId = game.JobId, game.PlaceId
    local age = formatAge(getServerAge())
    
    local color = 16766720 -- Gold
    if confidence < 90 then color = 3447003 end -- Blue for Prediction

    local payload = {
        ["username"] = "Blox || Oracle AI",
        ["avatar_url"] = "https://i.imgur.com/4W8o9gI.png",
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🔮 " .. eventName .. " DETECTED",
            ["description"] = "Confidence: **" .. confidence .. "%**",
            ["color"] = color,
            ["thumbnail"] = { ["url"] = "https://i.imgur.com/4W8o9gI.png" },
            ["fields"] = {
                {["name"] = "💎 Status", ["value"] = "**" .. eventName .. "**", ["inline"] = true},
                {["name"] = "🛡️ Method", ["value"] = "`" .. method .. "`", ["inline"] = true},
                {["name"] = "⏳ Server Age", ["value"] = "**" .. age .. "**", ["inline"] = true},
                {["name"] = "🧠 AI Analysis", ["value"] = "```" .. (extraInfo or "N/A") .. "```", ["inline"] = false},
                {["name"] = "🚀 Direct Link", ["value"] = "[Join Server](https://www.roblox.com/games/"..placeId.."?jobId="..jobId..")", ["inline"] = false},
                {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false}
            },
            ["footer"] = { ["text"] = "God AI by Devansh" },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 HOPPER
local function serverHop()
    UpdateGUI("🔄 HOPPING...", "---", formatAge(getServerAge()))
    Log("Hopping to next server...")
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
    
    local ageFormatted = formatAge(getServerAge())
    UpdateGUI("🔍 ORACLE SCANNING...", "0%", ageFormatted)
    Log("Server Age: " .. ageFormatted)
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))

    -- 1. HARD CHECK (The 100% Method)
    local event, method, conf = checkHardEvents()
    if event then
        sendNotification(event, method, conf, "Hard Confirmation")
        task.wait(2)
        serverHop()
        return -- Exit
    end

    -- 2. AI PREDICTION (The God Mode Method)
    local aiScore, aiReasons = calculateAI()
    UpdateGUI("🧠 ANALYZING DATA...", aiScore, ageFormatted)
    Log("AI Score: " .. aiScore .. "% -> " .. aiReasons)

    -- 3. DECISION MAKING
    if aiScore >= CONFIG.HoldConfidence then
        -- SCENARIO A: It is almost certainly happening. HOLD.
        Log("🛑 AI is 90%+ sure! Holding server for visual confirm...")
        UpdateGUI("🛑 HOLDING FOR EVENT...", aiScore, ageFormatted)
        task.wait(5) -- Wait to see if moon spawns in next few seconds
        
        -- Re-check
        event, method, conf = checkHardEvents()
        if event then
            sendNotification(event, method, conf, "Confirmed after Hold")
            task.wait(2)
        else
            -- If still nothing, report HIGH prediction then hop
            sendNotification("⚠️ HIGH PROBABILITY MOON", "AI Algorithm", aiScore, aiReasons)
            task.wait(2)
        end

    elseif aiScore >= CONFIG.MinAIConfidence then
        -- SCENARIO B: Moon is coming soon (e.g. 15 mins away). REPORT & HOP.
        -- User asked: "Send data like when it's coming... then server hops"
        Log("⚠️ Future Prediction found. Reporting then hopping.")
        sendNotification("🔮 PREDICTION: " .. aiReasons, "AI Forecasting", aiScore, "Server Age: " .. ageFormatted)
        task.wait(2)
    end
    
    -- Always hop at the end
    serverHop()
end

init()
