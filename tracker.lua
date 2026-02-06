--[[
    DEVANSH EVENT TRACKER | INTEGRATOR EDITION [v12.0]
    > EMBED: Professional 'loadstring' Output (No Pastebin Key Needed)
    > GUI: Bulletproof Center Status (Fixed)
    > LOGIC: Infinite Hop + 10 Player Limit + Heuristic Scan
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

    -- [[ TUNING ]]
    ScanDelay    = 0.2,    -- Ultra Fast
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
-- // [4] GUI SYSTEM (BULLETPROOF & FIXED) //
--------------------------------------------------------------------------------
local StatusText 

local function CreateGUI()
    local ParentGroup = gethui and gethui() or Services.CoreGui
    if not pcall(function() local x = ParentGroup.Name end) then ParentGroup = LocalPlayer:WaitForChild("PlayerGui") end
    
    if ParentGroup:FindFirstChild("DevanshIntegrator") then ParentGroup.DevanshIntegrator:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DevanshIntegrator"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = ParentGroup

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 160)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true 
    MainFrame.Parent = ScreenGui

    -- Rainbow Glow
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Thickness = 3
    task.spawn(function()
        local t = 0
        while MainFrame.Parent do
            t = t + 0.01
            UIStroke.Color = Color3.fromHSV(t % 1, 0.9, 1)
            Services.RunService.Heartbeat:Wait()
        end
    end)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Header
    local Title = Instance.new("TextLabel")
    Title.Text = "EVENT TRACKER // PROFESSIONAL"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    Title.TextSize = 14
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- Status Text (Big Center)
    StatusText = Instance.new("TextLabel")
    StatusText.Text = "SYSTEM INITIALIZING..."
    StatusText.Font = Enum.Font.GothamBold
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.TextSize = 18
    StatusText.Size = UDim2.new(1, 0, 1, -50)
    StatusText.Position = UDim2.new(0, 0, 0, 25)
    StatusText.BackgroundTransparency = 1
    StatusText.TextWrapped = true
    StatusText.Parent = MainFrame

    -- Footer
    local Footer = Instance.new("TextLabel")
    Footer.Text = "Made by Devansh"
    Footer.Font = Enum.Font.Code
    Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
    Footer.TextSize = 11
    Footer.Size = UDim2.new(1, 0, 0, 20)
    Footer.Position = UDim2.new(0, 0, 1, -20)
    Footer.BackgroundTransparency = 1
    Footer.Parent = MainFrame
end

CreateGUI()

local function SetStatus(text, color)
    if StatusText then
        StatusText.Text = text
        if color then StatusText.TextColor3 = color end
    end
end

--------------------------------------------------------------------------------
-- // [5] HEURISTIC DETECTION ENGINES //
--------------------------------------------------------------------------------
local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- [1] DEEP MIRAGE SCAN
local function ScanMirage()
    local score = 0
    local pos = nil
    local m = Services.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
    if m then
        score = 100
        pos = m.PrimaryPart.Position
    end
    if score > 0 then return {name="Mirage Island", score=score, pos=pos} end
    return nil
end

-- [2] KITSUNE SHRINE
local function ScanKitsune()
    local score = 0
    local pos = nil
    if string.find(tostring(Services.Lighting.Sky.MoonTextureId), "15306698696") then score = 50 end
    local k = Services.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
    if k then score = 100; pos = k.PrimaryPart.Position end
    if score >= 100 then return {name="Kitsune Shrine", score=score, pos=pos} end
    return nil
end

-- [3] PREHISTORIC
local function ScanPrehistoric()
    local p = Services.Workspace.Map:FindFirstChild("PrehistoricIsland") or Services.Workspace.Map:FindFirstChild("AncientIsland")
    if p then return {name="Prehistoric Island", score=100, pos=p.PrimaryPart.Position} end
    return nil
end

-- [4] FROZEN DIMENSION
local function ScanFrozen()
    local f = Services.Workspace.Map:FindFirstChild("FrozenDimension")
    if f then return {name="Frozen Dimension", score=100, pos=f.PrimaryPart.Position} end
    return nil
end

-- [5] FULL MOON
local function ScanMoon()
    if string.find(tostring(Services.Lighting.Sky.MoonTextureId), "9709149431") then 
        return {name="Full Moon", score=100, pos=nil}
    end
    return nil
end

--------------------------------------------------------------------------------
-- // [6] PROFESSIONAL WEBHOOK (LOADSTRING FORMAT) //
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
            -- Minified Safe-Tween Script
            tweenCode = string.format("loadstring([[local P=game.Players.LocalPlayer.Character.HumanoidRootPart;local T=Vector3.new(%d,%d,%d);game:GetService('TweenService'):Create(P,TweenInfo.new(1.5),{CFrame=CFrame.new(P.Position.X,300,P.Position.Z)}):Play();task.wait(1.5);game:GetService('TweenService'):Create(P,TweenInfo.new((P.Position-T).Magnitude/350),{CFrame=CFrame.new(T.X,300,T.Z)}):Play()]])()", e.pos.X, e.pos.Y, e.pos.Z)
        end
    end
    
    table.insert(fields, { name = "🏝️ Event Found", value = table.concat(eventNames, ", "), inline = false })
    table.insert(fields, { name = "⏳ Ends in", value = EndsIn, inline = true })
    table.insert(fields, { name = "⏰ Game Time", value = GameTime, inline = true })
    
    -- Minified Join Script
    local JoinScript = string.format("loadstring([[game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)]])()", game.PlaceId, game.JobId)
    table.insert(fields, { name = "📜 Join Script (Copy & Execute)", value = "```lua\n" .. JoinScript .. "\n```", inline = false })

    if tweenCode ~= "" then
        table.insert(fields, { name = "✈️ Tween Script (Copy & Execute)", value = "```lua\n" .. tweenCode .. "\n```", inline = false })
    else
        table.insert(fields, { name = "✈️ Tween Script", value = "*No coordinates available*", inline = false })
    end

    table.insert(fields, { name = "🆔 Job ID", value = "```" .. game.JobId .. "```", inline = false })
    
    -- HTTPS Direct Link (Fixed)
    local DirectLink = string.format("https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s", game.PlaceId, game.JobId)
    table.insert(fields, { name = "🔗 Direct Join Link", value = "[Direct Join 🚀](" .. DirectLink .. ")", inline = false })

    local embed = {
        title = "🚨 RARE EVENT DETECTED",
        color = 16766720,
        fields = fields,
        thumbnail = { url = Config.ThumbnailUrl },
        footer = { text = "Devansh Tracker | v12.0 Integrator" },
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
-- // [7] STRICT ASCENDING HOP //
--------------------------------------------------------------------------------
local function Hop()
    SetStatus("HOPPING (SEARCHING LOW POP)...", Color3.fromRGB(255, 100, 100))
    local PlaceID = game.PlaceId
    
    local function TryHop()
        local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        local s, response = pcall(function() return Services.Http:JSONDecode(HttpRequest({Url=url, Method="GET"}).Body) end)
        
        local Found = false
        if s and response and response.data then
            for _, srv in pairs(response.data) do
                if srv.playing and srv.playing >= getgenv().DevanshConfig.MinPlayers and srv.playing <= getgenv().DevanshConfig.MaxPlayers and srv.id ~= game.JobId then
                    SetStatus("JOINING: " .. srv.playing .. " PLRS", Color3.fromRGB(0, 255, 0))
                    if (syn and syn.queue_on_teleport) then syn.queue_on_teleport('loadstring(game:HttpGet("YOUR_SCRIPT_URL"))()') end
                    Services.Teleport:TeleportToPlaceInstance(PlaceID, srv.id, LocalPlayer)
                    Found = true
                    break
                end
            end
        end
        
        if not Found then
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
    task.wait(1.5)
    
    SetStatus("SCANNING ASSETS...", Color3.fromRGB(255, 255, 255))
    
    local FoundEvents = {}
    local engines = {ScanMirage, ScanKitsune, ScanMoon, ScanFrozen, ScanPrehistoric}
    
    for _, scan in pairs(engines) do
        local result = scan()
        if result then table.insert(FoundEvents, result) end
        task.wait(getgenv().DevanshConfig.ScanDelay)
    end

    if #FoundEvents > 0 then
        SetStatus("EVENT FOUND! SENDING...", Color3.fromRGB(0, 255, 0))
        SendWebhook(FoundEvents)
        
        task.wait(2)
        SetStatus("RESUMING HOP...", Color3.fromRGB(255, 150, 0))
        Hop()
    else
        SetStatus("NO EVENT FOUND", Color3.fromRGB(200, 200, 200))
        task.wait(1)
        Hop()
    end
end)
