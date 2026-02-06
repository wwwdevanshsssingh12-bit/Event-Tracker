--[[
    DEVANSH EVENT TRACKER | PERFECTED EDITION [v10.0]
    > FIX: Direct Join Link now fully clickable (HTTPS Protocol)
    > GUI: Bulletproof Simple Status (No Glitches)
    > LOGIC: Infinite Hop + Strict 10-Player Limit
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD ]]
    WebhookURL   = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole     = "@everyone",
    
    -- [[ VISUALS ]]
    BotName      = "Event Tracker",
    BotAvatar    = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401452994632/ezgif-68d035637d1d997c.gif?ex=6986f040&is=69859ec0&hm=eec50204236c3ae0806639370e7aff9f98a2b8cd7893f33fa08a4bb848473e2f&",
    ThumbnailUrl = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401037754389/ezgif-2381261b040e0649.gif?ex=6986f040&is=69859ec0&hm=e52e71a394271a1b77de5a061f4a935bd03327bcc01bf3e8a816281ad673bb29&",

    -- [[ HOPPING ]]
    ScanDelay    = 0.3,    
    MinPlayers   = 1,      
    MaxPlayers   = 10      -- Strict Limit (<11 Players)
}

--------------------------------------------------------------------------------
-- // [2] CORE SERVICES //
--------------------------------------------------------------------------------
local Services = {
    Players = game:GetService("Players"),
    Http = game:GetService("HttpService"),
    Teleport = game:GetService("TeleportService"),
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
-- // [4] SIMPLE GUI SYSTEM (BULLETPROOF) //
--------------------------------------------------------------------------------
local StatusText -- Global reference

local function CreateSimpleGUI()
    -- 1. Universal Parent Check
    local ParentGroup = gethui and gethui() or Services.CoreGui
    if not pcall(function() local x = ParentGroup.Name end) then ParentGroup = LocalPlayer:WaitForChild("PlayerGui") end
    
    -- Cleanup Old
    if ParentGroup:FindFirstChild("DevanshTrackerSimple") then
        ParentGroup.DevanshTrackerSimple:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DevanshTrackerSimple"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = ParentGroup

    -- 2. Main Window (Centered)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true 
    MainFrame.Parent = ScreenGui

    -- 3. Rainbow Border
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Thickness = 3
    UIStroke.Color = Color3.fromRGB(0, 255, 100)
    
    task.spawn(function()
        local t = 0
        while MainFrame.Parent do
            t = t + 0.01
            UIStroke.Color = Color3.fromHSV(t % 1, 0.8, 1)
            Services.RunService.Heartbeat:Wait()
        end
    end)

    -- 4. Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- 5. Title Header
    local Title = Instance.new("TextLabel")
    Title.Text = "EVENT TRACKER"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    Title.TextSize = 14
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- 6. BIG STATUS TEXT
    StatusText = Instance.new("TextLabel")
    StatusText.Name = "Status"
    StatusText.Text = "INITIALIZING..."
    StatusText.Font = Enum.Font.GothamBold
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.TextSize = 20
    StatusText.Size = UDim2.new(1, 0, 1, -30)
    StatusText.Position = UDim2.new(0, 0, 0, 30)
    StatusText.BackgroundTransparency = 1
    StatusText.TextWrapped = true
    StatusText.Parent = MainFrame

    -- 7. Footer
    local Footer = Instance.new("TextLabel")
    Footer.Text = "Made by Devansh"
    Footer.Font = Enum.Font.Code
    Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
    Footer.TextSize = 10
    Footer.Size = UDim2.new(1, 0, 0, 15)
    Footer.Position = UDim2.new(0, 0, 1, -15)
    Footer.BackgroundTransparency = 1
    Footer.Parent = MainFrame
end

CreateSimpleGUI()

local function SetStatus(text, color)
    if StatusText then
        StatusText.Text = text
        if color then StatusText.TextColor3 = color end
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
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("PrehistoricIsland") or Services.Workspace.Map:FindFirstChild("AncientIsland") end) then
        score = 100
        local m = Services.Workspace.Map:FindFirstChild("PrehistoricIsland") or Services.Workspace.Map:FindFirstChild("AncientIsland")
        pos = m.Position
        table.insert(evidence, "Ancient Model Found")
    end

    if Services.Lighting.FogColor == Color3.fromRGB(40, 60, 40) then
        score = score + 40
        table.insert(evidence, "Primordial Fog")
    end

    return {name="Prehistoric Island", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [2] MIRAGE ISLAND
local function ScanMirage()
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100
        table.insert(evidence, "Model ID Match")
        pos = Services.Workspace.Map.MysticIsland.Position
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
    end

    return {name="Mirage Island", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [3] KITSUNE SHRINE
local function ScanKitsune()
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return string.find(Services.Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = 100
        table.insert(evidence, "Texture ID: 15306698696")
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
    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("FrozenDimension") or Services.Workspace.Map:FindFirstChild("Frozen Island") end) then
        local p = nil
        if Services.Workspace.Map:FindFirstChild("FrozenDimension") then p = Services.Workspace.Map.FrozenDimension.Position end
        return {name="Frozen Dimension", score=100, reason="Dimension Gate", pos=p}
    end
    return {score=0}
end

-- [5] FULL MOON
local function ScanMoon()
    if SafeCheck(function() return string.find(Services.Lighting.Sky.MoonTextureId, "9709149431") end) then 
        return {name="Full Moon", score=100, reason="Texture ID: 9709149431", pos=nil}
    end
    return {score=0}
end

--------------------------------------------------------------------------------
-- // [6] WEBHOOK HANDLER (FIXED LINK) //
--------------------------------------------------------------------------------
local function SendWebhook(events)
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
    
    -- [[ FIX: UPDATED DIRECT JOIN LINK TO HTTPS ]]
    local DirectLink = string.format("https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s", game.PlaceId, game.JobId)
    table.insert(fields, { name = "🔗 Direct Join Link", value = "[Direct Join 🚀](" .. DirectLink .. ")", inline = false })

    local embed = {
        title = "🚨 RARE EVENT DETECTED",
        color = 16766720,
        fields = fields,
        thumbnail = { url = Config.ThumbnailUrl },
        footer = { text = "Devansh Tracker | v10.0 Perfected" },
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
end

--------------------------------------------------------------------------------
-- // [7] SERVER HOPPING //
--------------------------------------------------------------------------------
local function Hop()
    SetStatus("HOPPING SERVER...", Color3.fromRGB(255, 100, 100))
    
    local PlaceID = game.PlaceId
    local function TryHop()
        local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        local s, response = pcall(function() return Services.Http:JSONDecode(HttpRequest({Url=url, Method="GET"}).Body) end)
        
        local FoundServer = false
        if s and response and response.data then
            for _, srv in pairs(response.data) do
                if srv.playing and srv.playing >= getgenv().DevanshConfig.MinPlayers and srv.playing <= getgenv().DevanshConfig.MaxPlayers and srv.id ~= game.JobId then
                    SetStatus("JOINING: " .. srv.playing .. " PLRS", Color3.fromRGB(0, 255, 0))
                    Services.Teleport:TeleportToPlaceInstance(PlaceID, srv.id, LocalPlayer)
                    FoundServer = true
                    break
                end
            end
        end
        
        if not FoundServer then
            SetStatus("RETRYING API...", Color3.fromRGB(255, 255, 0))
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
    
    SetStatus("SCANNING...", Color3.fromRGB(255, 255, 255))
    
    local Config = getgenv().DevanshConfig
    local FoundEvents = {}

    local engines = {ScanMirage, ScanKitsune, ScanMoon, ScanFrozen, ScanPrehistoric}
    
    for _, scanFunc in pairs(engines) do
        local result = scanFunc()
        if result.score >= 90 then
            table.insert(FoundEvents, result)
        end
        task.wait(Config.ScanDelay)
    end

    if #FoundEvents > 0 then
        SetStatus("EVENT FOUND!", Color3.fromRGB(0, 255, 0))
        SendWebhook(FoundEvents)
        task.wait(2)
        Hop()
    else
        SetStatus("NO EVENT", Color3.fromRGB(200, 200, 200))
        task.wait(1)
        Hop()
    end
end)
