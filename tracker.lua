--[[
    DEVANSH EVENT TRACKER | DELTA ELITE EDITION [v3.2.0]
    > SYSTEM: Auto-Exec Compatible / Ascending Sort / Discord RPC
    > AESTHETIC: Hyper-Gold / Everyone Ping
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION MATRIX //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD INTEGRATION ]]
    Discord = {
        WebhookURL  = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",  -- <--- PASTE WEBHOOK HERE
        
        -- Bot Identity
        BotName     = "Devansh Gold Sentinel",  
        BotAvatar   = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6985a369&is=698451e9&hm=af1360b72e9d331403c17f46f80135f7b160fa37890c1b6c31d3535f3fe1f6ea&",
        
        -- Alerts
        PingRole    = "@everyone",              -- Pings everyone on detection
        EmbedColor  = 16766720,                 -- HYPER GOLD (#FFD700)
        FooterText  = "Made by| Devansh"
    },

    -- [[ SERVER HOPPING ]]
    Hopping = {
        Enabled      = true,    -- Master Switch
        HopDelay     = 6.0,     -- Seconds to wait before hopping (Safe for Mobile)
        MinPlayers   = 1,       -- Minimum players
        MaxPlayers   = 12       -- Max players (Avoids full servers)
    }
}

--------------------------------------------------------------------------------
-- // DO NOT EDIT BELOW THIS LINE - CORE ENGINE //
--------------------------------------------------------------------------------

local Config = getgenv().DevanshConfig
local Services = {
    Players = game:GetService("Players"),
    Http = game:GetService("HttpService"),
    Teleport = game:GetService("TeleportService"),
    CoreGui = game:GetService("CoreGui"),
    Run = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    Workspace = game:GetService("Workspace"),
    Tween = game:GetService("TweenService")
}

local LocalPlayer = Services.Players.LocalPlayer
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local SessionData = {
    StartTime = os.time(),
    Events = {},
    TargetFound = false
}

--------------------------------------------------------------------------------
-- // [2] UI ENGINE: CYBER-GOLD CONSOLE //
--------------------------------------------------------------------------------
local function CreateUI()
    -- Safety Check: Remove old GUI if exists
    if Services.CoreGui:FindFirstChild("DevanshGoldInterface") then
        Services.CoreGui.DevanshGoldInterface:Destroy()
    end

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "DevanshGoldInterface"
    GUI.Parent = Services.CoreGui
    GUI.ResetOnSpawn = false

    -- Main Window
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 500, 0, 350) -- Slightly smaller for Mobile screens
    Frame.Position = UDim2.new(0.5, -250, 0.5, -175)
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Frame.BorderSizePixel = 0
    Frame.Parent = GUI

    -- GOLD Pulse Border
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 3
    Stroke.Parent = Frame
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)), 
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 0)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
    })
    Gradient.Parent = Stroke
    
    task.spawn(function()
        while GUI.Parent do
            Gradient.Rotation = Gradient.Rotation + 2
            task.wait(0.02)
        end
    end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Header.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Text = Config.Discord.BotName:upper()
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 14
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Parent = Header

    -- Console Log
    local Console = Instance.new("ScrollingFrame")
    Console.Size = UDim2.new(1, -20, 1, -80)
    Console.Position = UDim2.new(0, 10, 0, 50)
    Console.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Console.ScrollBarThickness = 2
    Console.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Console.Parent = Frame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 4)
    ListLayout.Parent = Console

    return Console
end

local ConsoleOutput = CreateUI()

local function Log(msg)
    local Line = Instance.new("TextLabel")
    Line.Text = string.format("[%s] %s", os.date("%H:%M:%S"), msg)
    Line.TextColor3 = Color3.fromRGB(255, 230, 100)
    Line.Font = Enum.Font.Code
    Line.TextSize = 12
    Line.Size = UDim2.new(1, 0, 0, 16)
    Line.BackgroundTransparency = 1
    Line.TextXAlignment = Enum.TextXAlignment.Left
    Line.Parent = ConsoleOutput
    ConsoleOutput.CanvasPosition = Vector2.new(0, 99999)
end

Log("Delta/AutoExec Mode Loaded.")
Log("Waiting for Asset Load...")

--------------------------------------------------------------------------------
-- // [3] SCANNING ALGORITHMS //
--------------------------------------------------------------------------------
local function GetCoords(model)
    if model:IsA("Model") and model.PrimaryPart then return model.PrimaryPart.Position end
    return Vector3.zero
end

local function Scan()
    table.clear(SessionData.Events)
    SessionData.TargetFound = false
    
    -- Ensure game is loaded
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    Log("Scanning Map Assets...")

    -- [A] Full Moon
    if Services.Lighting:FindFirstChild("Sky") and string.find(tostring(Services.Lighting.Sky.MoonTextureId), "9709149431") then
        table.insert(SessionData.Events, {Name = "Full Moon", Pos = nil})
        Log(">> FOUND: Full Moon")
    end

    -- [B] Mirage
    local mirage = Services.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
    if mirage then
        table.insert(SessionData.Events, {Name = "Mirage Island", Pos = GetCoords(mirage)})
        Log(">> FOUND: Mirage Island")
        SessionData.TargetFound = true
    end

    -- [C] Kitsune
    local kitsune = Services.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
    if kitsune then
        table.insert(SessionData.Events, {Name = "Kitsune Island", Pos = GetCoords(kitsune)})
        Log(">> FOUND: Kitsune Island")
        SessionData.TargetFound = true
    end

    return SessionData.TargetFound
end

--------------------------------------------------------------------------------
-- // [4] DISCORD WEBHOOK HANDLER //
--------------------------------------------------------------------------------
local function GenerateTweenScript(pos)
    if not pos then return "" end
    return string.format([[
-- GOLD TWEEN SCRIPT
local T = game:GetService("TweenService")
local P = game.Players.LocalPlayer.Character.HumanoidRootPart
T:Create(P, TweenInfo.new((P.Position - Vector3.new(%d,%d,%d)).Magnitude/300), {CFrame = CFrame.new(%d,%d,%d)}):Play()
]], pos.X, pos.Y, pos.Z, pos.X, pos.Y, pos.Z)
end

local function PostWebhook()
    if Config.Discord.WebhookURL == "" or Config.Discord.WebhookURL:find("YOUR_WEBHOOK") then return end
    
    local contentStr = Config.Discord.PingRole
    local eventNames = {}
    local tweenBlock = ""

    for _, evt in pairs(SessionData.Events) do
        table.insert(eventNames, evt.Name)
        if (evt.Name == "Mirage Island" or evt.Name == "Kitsune Island") and evt.Pos then
            tweenBlock = GenerateTweenScript(evt.Pos) 
        end
    end

    local embedData = {
        title = "👑 LEGENDARY EVENT FOUND: " .. table.concat(eventNames, " + "),
        color = Config.Discord.EmbedColor,
        fields = {
            {name = "🛠 System", value = "Delta Optimized / Stack Scanner", inline = true},
            {name = "📶 Ping", value = math.floor(LocalPlayer:GetNetworkPing()*1000).."ms", inline = true},
            {name = "🆔 Job ID", value = "```"..game.JobId.."```", inline = false},
            {name = "🔗 Join Script", value = string.format("```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)\n```", game.PlaceId, game.JobId), inline = false}
        },
        footer = { text = Config.Discord.FooterText .. " | " .. os.date("%X") }
    }

    if tweenBlock ~= "" then
        table.insert(embedData.fields, {name = "✈️ FLY TO ISLAND", value = "```lua\n"..tweenBlock.."\n```", inline = false})
    end

    local payload = Services.Http:JSONEncode({
        username = Config.Discord.BotName,
        avatar_url = Config.Discord.BotAvatar,
        content = contentStr,
        embeds = {embedData}
    })

    HttpRequest({
        Url = Config.Discord.WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })
    Log("Notification Sent.")
end

--------------------------------------------------------------------------------
-- // [5] SERVER HOPPER ENGINE //
--------------------------------------------------------------------------------
local function Hop()
    if not Config.Hopping.Enabled then Log("Hopping Disabled."); return end
    
    Log("Searching for Empty Servers...")
    local cursor = ""
    
    local function Find()
        local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100&cursor=%s", game.PlaceId, cursor)
        local success, res = pcall(function() return Services.Http:JSONDecode(HttpRequest({Url=url, Method="GET"}).Body) end)
        
        if success and res.data then
            if res.nextPageCursor then cursor = res.nextPageCursor end
            
            for _, srv in pairs(res.data) do
                -- Check for valid server (Ascending sort finds 1 player servers first)
                if srv.playing >= Config.Hopping.MinPlayers and srv.playing <= Config.Hopping.MaxPlayers and srv.id ~= game.JobId then
                    Log("Target Acquired: " .. srv.playing .. " Players")
                    
                    -- NOTE: We do NOT queue teleport here because Delta AutoExec handles it!
                    Services.Teleport:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    return true
                end
            end
            if cursor then task.wait(0.5); Find() end
        else
            Log("Roblox API Busy. Retrying...")
            task.wait(2)
            Find()
        end
    end
    Find()
end

--------------------------------------------------------------------------------
-- // [6] MAIN THREAD //
--------------------------------------------------------------------------------
task.spawn(function()
    task.wait(2) -- Wait for game to fully initialize
    local found = Scan()
    
    if found then
        Log("!!! TARGET FOUND - STOPPING HOP !!!")
        PostWebhook()
    else
        Log("No Event Detected.")
        Log("Hopping in " .. Config.Hopping.HopDelay .. "s...")
        task.wait(Config.Hopping.HopDelay)
        Hop()
    end
end)
