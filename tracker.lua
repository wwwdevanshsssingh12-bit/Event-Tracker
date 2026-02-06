--[[
    DEVANSH EVENT TRACKER | FIXED EDITION [v8.0]
    > GUI: Universal Parent (Fixes "Not Showing" Glitch)
    > HOP: Strict 10-Player Limit (Never Full)
    > VISUALS: New Animated GIFs Updated
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD SETTINGS ]]
    WebhookURL   = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole     = "@everyone",
    
    -- [[ VISUAL IDENTITY ]]
    BotName      = "Event Tracker",
    -- [NEW] Animated Avatar:
    BotAvatar    = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401452994632/ezgif-68d035637d1d997c.gif?ex=6986f040&is=69859ec0&hm=eec50204236c3ae0806639370e7aff9f98a2b8cd7893f33fa08a4bb848473e2f&",
    -- [NEW] Thumbnail Image:
    ThumbnailUrl = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401037754389/ezgif-2381261b040e0649.gif?ex=6986f040&is=69859ec0&hm=e52e71a394271a1b77de5a061f4a935bd03327bcc01bf3e8a816281ad673bb29&",

    -- [[ HOPPING TUNING ]]
    ScanDelay    = 0.3,    
    MinPlayers   = 1,      -- Targets empty servers
    MaxPlayers   = 10      -- STRICT LIMIT: Ignores servers with >10 people
}

--------------------------------------------------------------------------------
-- // [2] CORE SERVICES //
--------------------------------------------------------------------------------
local Services = {
    Players = game:GetService("Players"),
    Http = game:GetService("HttpService"),
    Teleport = game:GetService("TeleportService"),
    CoreGui = game:GetService("CoreGui"),
    Lighting = game:GetService("Lighting"),
    Workspace = game:GetService("Workspace"),
    Tween = game:GetService("TweenService"),
    RunService = game:GetService("RunService")
}

local LocalPlayer = Services.Players.LocalPlayer
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

--------------------------------------------------------------------------------
-- // [3] TIMEKEEPER ENGINE //
--------------------------------------------------------------------------------
local function GetTimeData()
    local Clock = Services.Lighting.ClockTime
    local IsNight = (Clock >= 18 or Clock < 5.5)
    
    local Hours = math.floor(Clock)
    local Mins = math.floor((Clock - Hours) * 60)
    local AM_PM = (Hours >= 12) and "PM" or "AM"
    if Hours > 12 then Hours = Hours - 12 end
    if Hours == 0 then Hours = 12 end
    local FormattedTime = string.format("%02d:%02d %s", Hours, Mins, AM_PM)

    local HoursLeft = 0
    if IsNight then
        if Clock >= 18 then HoursLeft = (24 - Clock) + 5.5 else HoursLeft = 5.5 - Clock end
    else
        if Clock < 18 then HoursLeft = 18 - Clock end
    end
    
    local RealSecondsLeft = HoursLeft * 50 
    local DiscordTimestamp = os.time() + math.floor(RealSecondsLeft)
    return FormattedTime, string.format("<t:%d:R>", DiscordTimestamp)
end

--------------------------------------------------------------------------------
-- // [4] UNIVERSAL GUI SYSTEM (FIXED) //
--------------------------------------------------------------------------------
-- Fix: Try multiple parents to ensure GUI shows up on all executors
local function GetGuiParent()
    if gethui then return gethui() end
    if pcall(function() return Services.CoreGui end) then return Services.CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshTracker_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GetGuiParent() -- Uses the fixer function

-- Main Terminal Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Terminal"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 100 -- Force on top

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 100)

-- Header
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BorderSizePixel = 0
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local FixBar = Instance.new("Frame")
FixBar.Parent = TopBar
FixBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BorderSizePixel = 0

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "EVENT TRACKER"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = TopBar
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
StatusLabel.Size = UDim2.new(0.4, -10, 1, 0)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "[LOADING]"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Console (Fixed Layout)
local ConsoleArea = Instance.new("ScrollingFrame")
ConsoleArea.Parent = MainFrame
ConsoleArea.BackgroundTransparency = 1
ConsoleArea.Position = UDim2.new(0, 10, 0, 40)
ConsoleArea.Size = UDim2.new(1, -20, 1, -60)
ConsoleArea.ScrollBarThickness = 0 
ConsoleArea.ScrollingEnabled = false
ConsoleArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ConsoleArea.ClipsDescendants = true -- Ensures text doesn't overflow

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Font = Enum.Font.Code
Footer.Text = "made by devansh"
Footer.TextColor3 = Color3.fromRGB(80, 80, 80)
Footer.TextSize = 10

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ConsoleArea
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

-- Rainbow Animation
task.spawn(function()
    local t = 0
    while MainFrame.Parent do
        t = t + 0.005
        local color = Color3.fromHSV(t % 1, 0.9, 1)
        UIStroke.Color = color
        Services.RunService.Heartbeat:Wait()
    end
end)

-- Logging (Auto-Fit Fixed)
local LogCount = 0
local function UpdateStatus(text, color)
    StatusLabel.Text = text
    if color then StatusLabel.TextColor3 = color end
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
    
    -- Auto-Fit: Only keep last 10 lines to ensure visibility
    local maxLines = 10
    local children = ConsoleArea:GetChildren()
    local textLabels = {}
    for _, c in pairs(children) do if c:IsA("TextLabel") then table.insert(textLabels, c) end end
    
    if #textLabels > maxLines then
        table.sort(textLabels, function(a,b) return a.LayoutOrder < b.LayoutOrder end)
        for i = 1, (#textLabels - maxLines) do
            textLabels[i]:Destroy()
        end
    end
end

--------------------------------------------------------------------------------
-- // [5] SCANNING ENGINES //
--------------------------------------------------------------------------------
local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- [1] PREHISTORIC ISLAND
local function ScanPrehistoric()
    Log("Scanning Prehistoric...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("PrehistoricIsland") or Services.Workspace.Map:FindFirstChild("AncientIsland") end) then
        score = 100
        local m = Services.Workspace.Map:FindFirstChild("PrehistoricIsland") or Services.Workspace.Map:FindFirstChild("AncientIsland")
        pos = m.Position
        table.insert(evidence, "Ancient Model Found")
        Log("Target: Ancient Island", "SUCCESS")
    end

    if Services.Lighting.FogColor == Color3.fromRGB(40, 60, 40) then
        score = score + 40
        table.insert(evidence, "Primordial Fog")
    end

    return {name="Prehistoric Island", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [2] MIRAGE ISLAND
local function ScanMirage()
    Log("Scanning Mirage...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100
        table.insert(evidence, "Model ID Match")
        pos = Services.Workspace.Map.MysticIsland.Position
        Log("Target: Mystic Island", "SUCCESS")
    end
    
    local cluster = {}
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pp = p.Character.HumanoidRootPart.Position
            if pp.Magnitude > 8000 and pp.Y > 200 then table.insert(cluster, pp) end
        end
    end
    if #cluster >= 3 then
        local sum = Vector3.zero
        for _, v in pairs(cluster) do sum = sum + v end
        score = score + 60
        table.insert(evidence, "Triangulation")
        if not pos then pos = sum / #cluster end
        Log("Player Cluster Detected", "WARN")
    end

    return {name="Mirage Island", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [3] KITSUNE SHRINE
local function ScanKitsune()
    Log("Scanning Kitsune...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return string.find(Services.Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = 100
        table.insert(evidence, "Texture ID: 15306698696")
        Log("Target: Kitsune Texture", "SUCCESS")
    end
    
    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("KitsuneShrine") end) then
        score = 100
        table.insert(evidence, "Shrine Model")
        pos = Services.Workspace.Map.KitsuneShrine.Position
    end

    return {name="Kitsune Shrine", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [4] FROZEN DIMENSION
local function ScanFrozen()
    Log("Scanning Frozen...", "CMD")
    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("FrozenDimension") or Services.Workspace.Map:FindFirstChild("Frozen Island") end) then
        local p = nil
        if Services.Workspace.Map:FindFirstChild("FrozenDimension") then p = Services.Workspace.Map.FrozenDimension.Position end
        Log("Target: Dimension Gate", "SUCCESS")
        return {name="Frozen Dimension", score=100, reason="Dimension Gate", pos=p}
    end
    return {score=0}
end

-- [5] FULL MOON
local function ScanMoon()
    Log("Scanning Celestial...", "CMD")
    if SafeCheck(function() return string.find(Services.Lighting.Sky.MoonTextureId, "9709149431") end) then 
        Log("Target: Full Moon", "SUCCESS")
        return {name="Full Moon", score=100, reason="Texture ID: 9709149431", pos=nil}
    end
    return {score=0}
end

--------------------------------------------------------------------------------
-- // [6] PROFESSIONAL WEBHOOK HANDLER //
--------------------------------------------------------------------------------
local function SendProfessionalWebhook(events)
    UpdateStatus("[REPORTING]", Color3.fromRGB(0, 255, 255))
    local Config = getgenv().DevanshConfig
    
    local fields = {}
    local eventNames = {}
    local tweenCode = ""
    local GameTime, EndsIn = GetTimeData()

    for _, e in pairs(events) do
        table.insert(eventNames, e.name)
        if e.pos then
            tweenCode = string.format("game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(%d,%d,%d)).Magnitude/350), {CFrame = CFrame.new(%d,%d,%d)}):Play()", e.pos.X, e.pos.Y, e.pos.Z, e.pos.X, e.pos.Y, e.pos.Z)
        end
    end
    
    table.insert(fields, { name = "🏝️ Event Found", value = table.concat(eventNames, ", "), inline = false })
    table.insert(fields, { name = "⏳ Ends in", value = EndsIn, inline = true })
    table.insert(fields, { name = "⏰ Game Time", value = GameTime, inline = true })
    
    local JoinScript = string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", game.PlaceId, game.JobId)
    table.insert(fields, { name = "📜 Join Script", value = "```lua\n" .. JoinScript .. "\n```", inline = false })

    if tweenCode ~= "" then
        table.insert(fields, { name = "✈️ Tween Script", value = "```lua\n" .. tweenCode .. "\n```", inline = false })
    else
        table.insert(fields, { name = "✈️ Tween Script", value = "*No coordinates available*", inline = false })
    end

    table.insert(fields, { name = "🆔 Job ID", value = "```" .. game.JobId .. "```", inline = false })
    local DirectLink = string.format("roblox://experiences/start?placeId=%d&gameInstanceId=%s", game.PlaceId, game.JobId)
    table.insert(fields, { name = "🔗 Direct Join Link", value = "[Click to Join](" .. DirectLink .. ")", inline = false })

    local embed = {
        title = "🚨 RARE EVENT DETECTED",
        color = 16766720,
        fields = fields,
        thumbnail = { url = Config.ThumbnailUrl },
        footer = { text = "Devansh Tracker | v8.0 Fixed" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload = Services.Http:JSONEncode({
        username = Config.BotName,
        avatar_url = Config.BotAvatar,
        content = Config.PingRole,
        embeds = {embed}
    })

    HttpRequest({
        Url = Config.WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })
    Log("Webhook Sent!", "SUCCESS")
end

--------------------------------------------------------------------------------
-- // [7] SERVER HOPPING (STRICT NO-FULL SERVERS) //
--------------------------------------------------------------------------------
local function Hop()
    UpdateStatus("[HOPPING]", Color3.fromRGB(255, 50, 50))
    Log("Finding Empty Server (<10)...", "WARN")
    local PlaceID = game.PlaceId
    
    -- API Query: SortAscending (Lowest players first)
    local function TryHop()
        local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        local s, response = pcall(function() return Services.Http:JSONDecode(HttpRequest({Url=url, Method="GET"}).Body) end)
        
        local FoundServer = false
        if s and response and response.data then
            for _, srv in pairs(response.data) do
                -- STRICT FILTER: Must be between 1 and 10 players.
                -- srv.playing < 11 ensures we NEVER join a 12/12 server.
                if srv.playing and srv.playing >= getgenv().DevanshConfig.MinPlayers and srv.playing <= getgenv().DevanshConfig.MaxPlayers and srv.id ~= game.JobId then
                    Log("Joining: " .. srv.playing .. " Players", "SUCCESS")
                    Services.Teleport:TeleportToPlaceInstance(PlaceID, srv.id, LocalPlayer)
                    FoundServer = true
                    break
                end
            end
        end
        
        if not FoundServer then
            Log("No low-pop servers. Retrying...", "FAIL")
            task.wait(1.5)
            TryHop()
        end
    end
    
    TryHop()
end

--------------------------------------------------------------------------------
-- // [8] MAIN LOGIC //
--------------------------------------------------------------------------------
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(1)
    
    UpdateStatus("[SCANNING]", Color3.fromRGB(255, 200, 0))
    local Config = getgenv().DevanshConfig
    local FoundEvents = {}

    -- Run All Engines
    local engines = {ScanMirage, ScanKitsune, ScanMoon, ScanFrozen, ScanPrehistoric}
    
    for _, scanFunc in pairs(engines) do
        local result = scanFunc()
        if result.score >= 90 then
            table.insert(FoundEvents, result)
        end
        task.wait(Config.ScanDelay)
    end

    if #FoundEvents > 0 then
        UpdateStatus("[FOUND!]", Color3.fromRGB(0, 255, 0))
        Log("!!! EVENT DETECTED !!!", "SUCCESS")
        
        -- 1. SEND WEBHOOK
        SendProfessionalWebhook(FoundEvents)
        
        -- 2. FORCE HOP (INFINITE MODE)
        Log("Continuing to Hop...", "WARN")
        task.wait(2)
        Hop()
    else
        Log("No events. Hopping...", "FAIL")
        task.wait(2)
        Hop()
    end
end)
