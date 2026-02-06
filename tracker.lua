-- [[ 🚀 GOD MODE V28: CONFIGURABLE PROFESSIONAL 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH | STATUS: PERFECTED ]] --

-- 1. SAFE LOAD
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)
print(">> V28 INJECTED: LOADING CONFIG... <<")

-- 2. USER CONFIGURATION (EDIT THIS SECTION)
local USER_CONFIG = {
    -- [[ WEBHOOK SETTINGS ]]
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    BotName = "Devansh Tracker V28",
    
    -- [[ VISUALS ]]
    -- Suggested GIF: A clean radar scan or rotating gold coin. 
    -- Current: A high-quality radar scan gif.
    ThumbnailURL = "https://media.tenor.com/On7KVX1uKq8AAAAi/loading-loading-gif.gif", 
    EmbedColor = 65280, -- Bright Green (Decimal)
    PingRole = "@everyone",

    -- [[ TUNING ]]
    MinConfidence = 90, -- % Score required to ping
    ScanDelay = 0.5,    -- Seconds between checks
    HopDelay = 4        -- Seconds to wait before hopping after ping
}

-- 3. SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- 4. GUI SYSTEM (Minimalist Terminal)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshV28_Pro"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = LocalPlayer.PlayerGui end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Terminal"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 120)

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BorderSizePixel = 0
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "DEVANSH TRACKER // V28"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = TopBar
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
StatusLabel.Size = UDim2.new(0.4, -10, 1, 0)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "[IDLE]"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

local ConsoleArea = Instance.new("ScrollingFrame")
ConsoleArea.Parent = MainFrame
ConsoleArea.BackgroundTransparency = 1
ConsoleArea.Position = UDim2.new(0, 10, 0, 35)
ConsoleArea.Size = UDim2.new(1, -20, 1, -55)
ConsoleArea.ScrollBarThickness = 3
ConsoleArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
ConsoleArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ConsoleArea
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Font = Enum.Font.Code
Footer.Text = "made by devansh"
Footer.TextColor3 = Color3.fromRGB(80, 80, 80)
Footer.TextSize = 10

task.spawn(function()
    while MainFrame.Parent do
        local t = tick() % 5 / 5
        UIStroke.Color = Color3.fromHSV(t, 0.8, 1)
        task.wait(0.05)
    end
end)

-- 5. UTILS & LOGGING
local LogCount = 0

local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
end

local function Log(text, type)
    LogCount = LogCount + 1
    local color = Color3.fromRGB(200, 200, 200)
    local prefix = "[*]"
    
    if type == "SUCCESS" then color = Color3.fromRGB(0, 255, 100); prefix = "[+]"
    elseif type == "WARN" then color = Color3.fromRGB(255, 180, 0); prefix = "[!]"
    elseif type == "FAIL" then color = Color3.fromRGB(255, 50, 50); prefix = "[-]"
    elseif type == "CMD" then color = Color3.fromRGB(0, 200, 255); prefix = "[$]" end
    
    local Line = Instance.new("TextLabel")
    Line.Parent = ConsoleArea
    Line.BackgroundTransparency = 1
    Line.Size = UDim2.new(1, 0, 0, 14)
    Line.Font = Enum.Font.Code
    Line.Text = string.format("%s %s", prefix, text)
    Line.TextColor3 = color
    Line.TextSize = 11
    Line.TextXAlignment = Enum.TextXAlignment.Left
    Line.LayoutOrder = LogCount
    
    if LogCount > 40 then
        for _, child in pairs(ConsoleArea:GetChildren()) do
            if child:IsA("TextLabel") and child.LayoutOrder < (LogCount - 40) then child:Destroy() end
        end
    end
    ConsoleArea.CanvasPosition = Vector2.new(0, 99999)
end

-- 6. TIMEKEEPER (Accurate Math)
local function GetTimeData()
    local t = Lighting.ClockTime
    local isActive = (t >= 18 or t < 5.5)
    
    if not isActive then
        return "EXPIRED", 16711680, "N/A", t
    end
    
    -- Calculate Game Hours Remaining until 5:30 AM (Dawn)
    local GameHoursLeft = 0
    if t >= 18 then
        GameHoursLeft = (24 - t) + 5.5
    else
        GameHoursLeft = 5.5 - t
    end
    
    -- Blox Fruits Time Scale: 1 Game Hour ~= 50 Real Seconds
    local RealSecondsLeft = GameHoursLeft * 50
    local UnixTimestamp = os.time() + math.floor(RealSecondsLeft)
    
    -- Discord "Relative" Timer (Ends in X minutes)
    local TimerRelative = string.format("<t:%d:R>", UnixTimestamp)
    
    return "ACTIVE", USER_CONFIG.EmbedColor, TimerRelative, t
end

-- 7. SCANNERS
local function RunScans()
    local events = {}
    local Map = Workspace:FindFirstChild("Map")
    
    if not Map then return events end -- Safety Check

    -- A. PREHISTORIC
    if Map:FindFirstChild("PrehistoricIsland") or Map:FindFirstChild("AncientIsland") then
        local m = Map:FindFirstChild("PrehistoricIsland") or Map:FindFirstChild("AncientIsland")
        table.insert(events, {name="💎🦖 PREHISTORIC", score=100, reason="Model Found", pos=m.Position})
        Log("Found: Prehistoric Island", "SUCCESS")
    end

    -- B. MIRAGE
    if Map:FindFirstChild("MysticIsland") then
        table.insert(events, {name="💎🏝️ MIRAGE", score=100, reason="Model ID", pos=Map.MysticIsland.Position})
        Log("Found: Mirage Island", "SUCCESS")
    end

    -- C. KITSUNE
    if string.find(Lighting.Sky.MoonTextureId, "15306698696") then
        table.insert(events, {name="💎🦊 KITSUNE", score=100, reason="Texture ID", pos=nil})
        Log("Found: Kitsune Texture", "SUCCESS")
    end

    -- D. FROZEN
    if Map:FindFirstChild("FrozenDimension") then
        table.insert(events, {name="💎❄️ FROZEN", score=100, reason="Dimension Gate", pos=Map.FrozenDimension.Position})
        Log("Found: Frozen Dimension", "SUCCESS")
    end

    -- E. MOON
    if string.find(Lighting.Sky.MoonTextureId, "9709149431") then
        table.insert(events, {name="💎🌕 FULL MOON", score=100, reason="Texture ID", pos=nil})
        Log("Found: Full Moon", "SUCCESS")
    end

    return events
end

-- 8. PROFESSIONAL WEBHOOK (Strict Layout)
local function SendWebhook(events)
    UpdateStatus("[REPORTING]", Color3.fromRGB(0, 255, 255))
    local status, color, timerRel, clockTime = GetTimeData()

    if status == "EXPIRED" then
        Log("Event EXPIRED. Aborting.", "FAIL")
        return 
    end

    local fields = {}
    
    -- 1. EVENT FOUND
    for _, e in pairs(events) do
        table.insert(fields, {
            ["name"] = e.name, 
            ["value"] = "**Engine:** " .. e.reason .. "\n**Confidence:** " .. e.score .. "%", 
            ["inline"] = false
        })
    end
    
    -- 2. TIMERS (Ends in / Game Time)
    table.insert(fields, {
        ["name"] = "⏳ ENDS IN:", 
        ["value"] = timerRel, 
        ["inline"] = true
    })
    table.insert(fields, {
        ["name"] = "🕰️ GAME TIME:", 
        ["value"] = string.format("%.1f", clockTime), 
        ["inline"] = true
    })

    -- 3. JOIN SCRIPT
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {
        ["name"] = "📜 JOIN SCRIPT", 
        ["value"] = "```lua\n" .. joinScript .. "\n```", 
        ["inline"] = false
    })

    -- 4. TWEEN SCRIPT (Dynamic)
    for _, e in pairs(events) do
        if e.pos then
            local islandName = string.gsub(e.name, "💎", "")
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y + 200) .. "," .. math.floor(e.pos.Z)
            local tpScript = string.format([[
-- [[ TELEPORT TO %s ]] --
local P = game.Players.LocalPlayer.Character.HumanoidRootPart
local T = CFrame.new(%s)
local B = Instance.new("BodyVelocity", P); B.Velocity=Vector3.zero; B.MaxForce=Vector3.one*9e9
local Tw = game:GetService("TweenService"):Create(P, TweenInfo.new((P.Position-T.Position).Magnitude/350), {CFrame=T})
Tw:Play(); Tw.Completed:Wait(); B:Destroy()
]], islandName, vec)
            table.insert(fields, {
                ["name"] = "✈️ TWEEN SCRIPT (" .. islandName .. ")", 
                ["value"] = "```lua\n" .. tpScript .. "\n```", 
                ["inline"] = false
            })
        end
    end

    -- 5. JOB ID
    table.insert(fields, {
        ["name"] = "🆔 JOB ID", 
        ["value"] = "```" .. game.JobId .. "```", 
        ["inline"] = false
    })

    -- 6. DIRECT LINK
    local directLink = "https://www.roblox.com/games/"..game.PlaceId.."?jobId="..game.JobId
    table.insert(fields, {
        ["name"] = "🔗 DIRECT JOIN LINK", 
        ["value"] = "[CLICK HERE TO JOIN](" .. directLink .. ")", 
        ["inline"] = false
    })

    local payload = {
        ["username"] = USER_CONFIG.BotName,
        ["avatar_url"] = USER_CONFIG.BotAvatar,
        ["content"] = USER_CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🌟 EVENT DETECTED",
            ["color"] = color,
            ["fields"] = fields,
            ["thumbnail"] = {["url"] = USER_CONFIG.ThumbnailURL}, -- GIF GOES HERE
            ["footer"] = {["text"] = "Devansh Tracker | V28 Pro"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    pcall(function()
        local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
        if req then req({Url = USER_CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end
    end)
    Log("Webhook Delivered.", "SUCCESS")
end

local function Hop()
    UpdateStatus("[HOPPING]", Color3.fromRGB(255, 50, 50))
    Log("Hopping...", "WARN")
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local s, body = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) end)
    
    if s and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then table.insert(AllIDs, v.id) end
        end
    end
    
    if #AllIDs > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else
        Log("No Servers found.", "FAIL")
    end
end

-- 9. MAIN LOOP (STACKLESS & SAFE)
task.spawn(function()
    while task.wait(1.5) do
        local success, err = pcall(function()
            UpdateStatus("[SCANNING]", Color3.fromRGB(255, 200, 0))
            
            -- Friend Check
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p:IsFriendsWith(LocalPlayer.UserId) then
                    Log("Friend Detected! Ejecting...", "FAIL")
                    Hop()
                    return
                end
            end

            local events = RunScans()
            
            if #events > 0 then
                UpdateStatus("[FOUND!]", Color3.fromRGB(0, 255, 0))
                Log("Target Acquired!", "SUCCESS")
                SendWebhook(events)
                task.wait(USER_CONFIG.HopDelay)
                Hop()
            else
                Log("No Targets. Hopping.", "CMD")
                Hop()
            end
        end)

        if not success then
            Log("Error: " .. tostring(err), "FAIL")
            task.wait(2)
        end
    end
end)
