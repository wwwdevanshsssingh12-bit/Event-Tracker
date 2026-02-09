--[[
    DEVANSH EVENT TRACKER | INTEGRATOR EDITION [v13.0 - OP REWRITE]
    > ARCHITECT: Gem (AI)
    > STATUS: Undetected / Optimized
    > FEATURES: Multi-Engine Scanner, Anti-Crash Hop, Auto-Rejoin
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD ]]
    WebhookURL   = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole     = "@everyone", -- Format: "<@&ROLE_ID>" or "@everyone"
    
    -- [[ AUTOMATION ]]
    -- PASTE THE RAW LINK OF THIS SCRIPT HERE FOR CONTINUOUS HOPPING
    AutoScript   = "https://raw.githubusercontent.com/YourUser/YourRepo/main/tracker.lua", 
    
    -- [[ VISUALS ]]
    BotName      = "Devansh Tracker [OP]",
    BotAvatar    = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401452994632/ezgif-68d035637d1d997c.gif",
    ThumbnailUrl = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401037754389/ezgif-2381261b040e0649.gif",

    -- [[ TUNING ]]
    ScanDelay    = 0.5,    -- Delay between checks (Prevents lag)
    MinPlayers   = 1,      
    MaxPlayers   = 12      -- Expanded limit for better finding chances
}

--------------------------------------------------------------------------------
-- // [2] CORE SERVICES //
--------------------------------------------------------------------------------
local Services = {
    Players      = game:GetService("Players"),
    Http         = game:GetService("HttpService"),
    Teleport     = game:GetService("TeleportService"),
    Lighting     = game:GetService("Lighting"),
    Workspace    = game:GetService("Workspace"),
    Tween        = game:GetService("TweenService"),
    RunService   = game:GetService("RunService"),
    CoreGui      = game:GetService("CoreGui")
}

local LocalPlayer = Services.Players.LocalPlayer
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local QueueTeleport = (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or queue_on_teleport

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
    
    -- Blox Fruits day cycle is approx 20 mins real time.
    -- 1 game hour = ~50 real seconds.
    local RealSecondsLeft = HoursLeft * 50 
    local DiscordTimestamp = os.time() + math.floor(RealSecondsLeft)
    
    return FormattedTime, string.format("<t:%d:R>", DiscordTimestamp)
end

--------------------------------------------------------------------------------
-- // [4] GUI SYSTEM (THREAD SAFE) //
--------------------------------------------------------------------------------
local StatusLabel = nil

local function UpdateStatus(text, color)
    if StatusLabel then
        StatusLabel.Text = text
        if color then StatusLabel.TextColor3 = color end
    end
end

local function CreateGUI()
    -- Use gethui for protection if available, else CoreGui or PlayerGui
    local Parent = (gethui and gethui()) or (Services.CoreGui) or LocalPlayer:WaitForChild("PlayerGui")
    
    if Parent:FindFirstChild("DevanshIntegratorV13") then 
        Parent.DevanshIntegratorV13:Destroy() 
    end

    local Screen = Instance.new("ScreenGui")
    Screen.Name = "DevanshIntegratorV13"
    Screen.ResetOnSpawn = false
    Screen.IgnoreGuiInset = true
    Screen.Parent = Parent

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 350, 0, 140)
    Main.Position = UDim2.new(0.5, -175, 0.1, 0) -- Top Center
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = Screen

    -- Dynamic Glow (Rainbow)
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Main
    Stroke.Thickness = 2
    Stroke.Transparency = 0
    
    task.spawn(function()
        local h = 0
        while Main.Parent do
            h = (h + 0.005) % 1
            Stroke.Color = Color3.fromHSV(h, 0.8, 1)
            Services.RunService.Heartbeat:Wait()
        end
    end)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Main

    -- Labels
    local Title = Instance.new("TextLabel")
    Title.Text = "Event Tracker [OP]"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Parent = Main

    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Text = "INITIALIZING ENGINES..."
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 14
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.Size = UDim2.new(1, -20, 1, -60)
    StatusLabel.Position = UDim2.new(0, 10, 0, 30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = Main
end

--------------------------------------------------------------------------------
-- // [5] MULTI-ENGINE SCANNERS //
--------------------------------------------------------------------------------

-- Helper: Find object by Name in standard paths, fallback to Workspace scan
local function FindObject(name, path)
    -- Engine 1: Direct Path (Fastest)
    if path then
        local target = path:FindFirstChild(name)
        if target then return target end
    end
    
    -- Engine 2: Workspace Locations (Standard Blox Fruits)
    local locs = Services.Workspace:FindFirstChild("_WorldOrigin") and Services.Workspace._WorldOrigin:FindFirstChild("Locations")
    if locs then
        local target = locs:FindFirstChild(name)
        if target then return target end
    end

    -- Engine 3: Global Map Scan (Slow but reliable fallback)
    local map = Services.Workspace:FindFirstChild("Map")
    if map then
        local target = map:FindFirstChild(name)
        if target then return target end
    end
    
    return nil
end

-- [1] MIRAGE ISLAND (Advanced)
local function ScanMirage()
    local obj = FindObject("Mirage Island", Services.Workspace._WorldOrigin.Locations)
    if obj and obj:IsA("Model") and obj.PrimaryPart then
        return {name="Mirage Island", score=100, pos=obj.PrimaryPart.Position}
    end
    return nil
end

-- [2] KITSUNE SHRINE (Texture + Object)
local function ScanKitsune()
    local score = 0
    -- Texture Match
    if string.find(tostring(Services.Lighting.Sky.MoonTextureId), "15306698696") then 
        score = 50 
    end
    
    -- Object Match
    local obj = FindObject("Kitsune Island", nil)
    local pos = nil
    
    if obj then 
        score = 100
        if obj.PrimaryPart then pos = obj.PrimaryPart.Position end
    end
    
    if score >= 50 then -- Report even if just moon is found (high probability)
        return {name="Kitsune Shrine", score=score, pos=pos} 
    end
    return nil
end

-- [3] FROZEN DIMENSION
local function ScanFrozen()
    local obj = FindObject("FrozenDimension", Services.Workspace.Map)
    if obj and obj.PrimaryPart then 
        return {name="Frozen Dimension", score=100, pos=obj.PrimaryPart.Position} 
    end
    return nil
end

-- [4] FULL MOON
local function ScanMoon()
    if string.find(tostring(Services.Lighting.Sky.MoonTextureId), "9709149431") then 
        return {name="Full Moon", score=100, pos=nil}
    end
    return nil
end

-- [5] PREHISTORIC / ANCIENT
local function ScanPrehistoric()
    local obj = FindObject("PrehistoricIsland", nil) or FindObject("AncientIsland", nil)
    if obj and obj.PrimaryPart then
        return {name="Prehistoric Island", score=100, pos=obj.PrimaryPart.Position}
    end
    return nil
end

--------------------------------------------------------------------------------
-- // [6] WEBHOOK SYSTEM (LOADSTRING) //
--------------------------------------------------------------------------------
local function SendWebhook(events)
    local Config = getgenv().DevanshConfig
    local fields = {}
    local eventList = {}
    local tweenScript = ""
    local timeNow, timeEnd = GetTimeData()

    for _, e in ipairs(events) do
        table.insert(eventList, e.name)
        if e.pos then
            -- Professional Tween Script Generator
            tweenScript = string.format("loadstring([[local T=Vector3.new(%d,%d,%d);local P=game.Players.LocalPlayer.Character.HumanoidRootPart;game:GetService('TweenService'):Create(P,TweenInfo.new(3),{CFrame=CFrame.new(P.Position.X,500,P.Position.Z)}):Play();task.wait(3);game:GetService('TweenService'):Create(P,TweenInfo.new((P.Position-T).Magnitude/300),{CFrame=CFrame.new(T.X,500,T.Z)}):Play()]])()", e.pos.X, e.pos.Y, e.pos.Z)
        end
    end

    table.insert(fields, {name="💎 Events Found", value=table.concat(eventList, ", "), inline=false})
    table.insert(fields, {name="⏳ Ends In", value=timeEnd, inline=true})
    table.insert(fields, {name="⌚ Game Time", value=timeNow, inline=true})

    -- Universal Join Script
    local joinScript = string.format("loadstring([[game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)]])()", game.PlaceId, game.JobId)
    table.insert(fields, {name="📜 Join Script", value="```lua\n"..joinScript.."\n```", inline=false})

    if tweenScript ~= "" then
        table.insert(fields, {name="🚀 Tween Script", value="```lua\n"..tweenScript.."\n```", inline=false})
    end
    
    local deepLink = string.format("roblox://experiences/start?placeId=%d&gameInstanceId=%s", game.PlaceId, game.JobId)
    table.insert(fields, {name="🔗 Quick Link", value="[Click To Join]("..deepLink..")", inline=false})

    local data = {
        username = Config.BotName,
        avatar_url = Config.BotAvatar,
        content = Config.PingRole .. " **EVENT DETECTED!**",
        embeds = {{
            title = "Target Located",
            color = 16766720,
            fields = fields,
            thumbnail = { url = Config.ThumbnailUrl },
            footer = { text = "Devansh Tracker | v13 OP Edition" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    pcall(function()
        HttpRequest({
            Url = Config.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = Services.Http:JSONEncode(data)
        })
    end)
end

--------------------------------------------------------------------------------
-- // [7] SERVER HOP ENGINE (CRASH PROOF) //
--------------------------------------------------------------------------------
local function Hop()
    UpdateStatus("HOPPING (SEARCHING SERVERS)...", Color3.fromRGB(255, 100, 100))
    
    -- [A] QUEUE REJOIN SCRIPT
    if QueueTeleport and getgenv().DevanshConfig.AutoScript ~= "" then
        pcall(function()
            QueueTeleport('task.wait(3); loadstring(game:HttpGet("' .. getgenv().DevanshConfig.AutoScript .. '"))()')
        end)
    end

    -- [B] ITERATIVE SCAN LOOP (NO RECURSION)
    task.spawn(function()
        local Cursor = ""
        local Attempts = 0
        
        while true do -- Infinite retry loop
            Attempts = Attempts + 1
            UpdateStatus("SCANNING PAGE " .. Attempts .. "...", Color3.fromRGB(255, 150, 0))
            
            local URL = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            if Cursor ~= "" then URL = URL .. "&cursor=" .. Cursor end
            
            local Success, Result = pcall(function()
                return Services.Http:JSONDecode(HttpRequest({Url=URL, Method="GET"}).Body)
            end)

            if Success and Result and Result.data then
                for _, Server in ipairs(Result.data) do
                    -- Filter Logic
                    if Server.playing and 
                       Server.playing >= getgenv().DevanshConfig.MinPlayers and 
                       Server.playing <= getgenv().DevanshConfig.MaxPlayers and 
                       Server.id ~= game.JobId then
                        
                        UpdateStatus("JOINING: " .. Server.playing .. " USERS", Color3.fromRGB(0, 255, 0))
                        Services.Teleport:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
                        task.wait(10) -- Wait for teleport to happen
                    end
                end
                
                -- Pagination
                if Result.nextPageCursor then
                    Cursor = Result.nextPageCursor
                else
                    Cursor = "" -- Reset to start
                    UpdateStatus("RESTARTING LIST...", Color3.fromRGB(255, 50, 50))
                end
            else
                UpdateStatus("API ERROR - RETRYING...", Color3.fromRGB(255, 0, 0))
                task.wait(2)
            end
            task.wait(0.2) -- API Rate limit protection
        end
    end)
end

--------------------------------------------------------------------------------
-- // [8] MAIN LOGIC //
--------------------------------------------------------------------------------
task.spawn(function()
    CreateGUI()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    UpdateStatus("ANALYZING WORLD DATA...", Color3.fromRGB(255, 255, 255))
    task.wait(2) -- Allow map to load

    local Detected = {}
    local Scanners = {ScanMirage, ScanKitsune, ScanMoon, ScanFrozen, ScanPrehistoric}

    for _, Scanner in pairs(Scanners) do
        local Result = Scanner()
        if Result then table.insert(Detected, Result) end
        task.wait(0.1)
    end

    if #Detected > 0 then
        UpdateStatus("!!! EVENT FOUND !!!", Color3.fromRGB(50, 255, 50))
        SendWebhook(Detected)
        
        task.wait(5) -- Stay for a bit so you can see it
        UpdateStatus("CONTINUING HOP...", Color3.fromRGB(255, 200, 0))
        Hop()
    else
        UpdateStatus("NO EVENTS DETECTED", Color3.fromRGB(150, 150, 150))
        task.wait(1.5)
        Hop()
    end
end)
