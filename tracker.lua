--[[
    DEVANSH EVENT TRACKER | GOD MODE EDITION [v5.0]
    > GUI: Termux Style / Rainbow Border / Draggable
    > ENGINE: Instant Asset Detection (Delta Optimized)
    > STATUS: FIXED & POLISHED
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION MATRIX //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD INTEGRATION ]]
    WebhookURL  = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y", -- <--- PASTE WEBHOOK HERE
    
    -- [[ BOT IDENTITY ]]
    BotName     = "Event Tracker",
    BotAvatar   = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6985a369&is=698451e9&hm=af1360b72e9d331403c17f46f80135f7b160fa37890c1b6c31d3535f3fe1f6ea&",
    PingRole    = "@everyone",              -- Pings everyone
    EmbedColor  = 16766720,                 -- Hyper Gold (#FFD700)
    
    -- [[ SYSTEM SETTINGS ]]
    HopEnabled  = true,
    HopDelay    = 5.0,     -- Seconds before hopping
    MinPlayers  = 1,       -- Minimum players
    MaxPlayers  = 12       -- Max players (Avoids full servers)
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

-- Session State
local State = {
    EventsDetected = {},
    TargetFound = false,
    LogCount = 0
}

--------------------------------------------------------------------------------
-- // [3] ROBUST GUI ENGINE (GOD MODE STYLE) //
--------------------------------------------------------------------------------
local ConsoleArea -- Reference for logging
local StatusLabel -- Reference for status text

local function CreateGUI()
    -- Safety Check: Remove old GUI
    if Services.CoreGui:FindFirstChild("DevanshGodMode") then
        Services.CoreGui.DevanshGodMode:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DevanshGodMode"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Services.CoreGui

    -- 1. Main Terminal Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Terminal"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- Deep Console Dark
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110) -- Centered
    MainFrame.Size = UDim2.new(0, 320, 0, 220) -- Compact Size
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true -- Native Dragging (Smooth)

    -- Curved Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- 2. Rainbow Border (UIStroke)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Thickness = 2.5
    UIStroke.Color = Color3.fromRGB(0, 255, 100) -- Start Green

    -- Rainbow Loop
    task.spawn(function()
        local t = 0
        while MainFrame.Parent do
            t = t + 0.005
            UIStroke.Color = Color3.fromHSV(t % 1, 0.9, 1) -- Smooth Rainbow
            Services.RunService.Heartbeat:Wait()
        end
    end)

    -- 3. Header Bar
    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BorderSizePixel = 0
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar
    
    -- Fix Bottom Corners of Header
    local FixBar = Instance.new("Frame")
    FixBar.Parent = TopBar
    FixBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    FixBar.Size = UDim2.new(1, 0, 0, 10)
    FixBar.Position = UDim2.new(0, 0, 1, -10)
    FixBar.BorderSizePixel = 0

    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Font = Enum.Font.Code
    Title.Text = "EVENT TRACKER"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Status Text (Running/Found)
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = TopBar
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
    StatusLabel.Size = UDim2.new(0.4, -10, 1, 0)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "[IDLE]"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    StatusLabel.TextSize = 11
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- 4. Console Area (The Glitch-Free Part)
    ConsoleArea = Instance.new("ScrollingFrame")
    ConsoleArea.Parent = MainFrame
    ConsoleArea.BackgroundTransparency = 1
    ConsoleArea.Position = UDim2.new(0, 10, 0, 40)
    ConsoleArea.Size = UDim2.new(1, -20, 1, -60)
    ConsoleArea.ScrollBarThickness = 2
    ConsoleArea.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    ConsoleArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ConsoleArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ConsoleArea
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)

    -- 5. Footer
    local Footer = Instance.new("TextLabel")
    Footer.Parent = MainFrame
    Footer.BackgroundTransparency = 1
    Footer.Position = UDim2.new(0, 0, 1, -20)
    Footer.Size = UDim2.new(1, 0, 0, 20)
    Footer.Font = Enum.Font.Code
    Footer.Text = "Made by Devansh"
    Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
    Footer.TextSize = 10
end

CreateGUI()

-- Smart Log Function
local function Log(text, colorType)
    if not ConsoleArea then return end
    State.LogCount = State.LogCount + 1

    local color = Color3.fromRGB(200, 200, 200) -- Default White
    local prefix = "[*]"

    if colorType == "SUCCESS" then 
        color = Color3.fromRGB(0, 255, 100) -- Green
        prefix = "[+]"
    elseif colorType == "WARN" then
        color = Color3.fromRGB(255, 180, 0) -- Orange
        prefix = "[!]"
    elseif colorType == "FAIL" then
        color = Color3.fromRGB(255, 50, 50) -- Red
        prefix = "[-]"
    end

    local Line = Instance.new("TextLabel")
    Line.Parent = ConsoleArea
    Line.BackgroundTransparency = 1
    Line.Size = UDim2.new(1, 0, 0, 14)
    Line.Font = Enum.Font.Code
    Line.Text = string.format("%s %s", prefix, text)
    Line.TextColor3 = color
    Line.TextSize = 11
    Line.TextXAlignment = Enum.TextXAlignment.Left
    Line.LayoutOrder = State.LogCount

    -- Anti-Lag: Keep only last 20 lines
    local children = ConsoleArea:GetChildren()
    if #children > 25 then
        for _, child in pairs(children) do
            if child:IsA("TextLabel") and child.LayoutOrder < (State.LogCount - 20) then
                child:Destroy()
            end
        end
    end

    ConsoleArea.CanvasPosition = Vector2.new(0, 99999)
end

local function UpdateStatus(text, color)
    if StatusLabel then
        StatusLabel.Text = text
        StatusLabel.TextColor3 = color
    end
end

Log("Interface Loaded.", "SUCCESS")
Log("Config: Delta AutoExec", "WARN")

--------------------------------------------------------------------------------
-- // [4] ASSET DETECTION ENGINE //
--------------------------------------------------------------------------------
local function GetPos(model)
    if model and model.PrimaryPart then return model.PrimaryPart.Position end
    return Vector3.new(0,0,0)
end

local function ScanWorld()
    State.EventsDetected = {}
    State.TargetFound = false
    UpdateStatus("[SCANNING]", Color3.fromRGB(255, 255, 0))
    Log("Scanning Workspace Assets...")

    local Locations = Services.Workspace._WorldOrigin.Locations

    -- [1] MIRAGE ISLAND
    if Locations:FindFirstChild("Mirage Island") then
        local pos = GetPos(Locations["Mirage Island"])
        table.insert(State.EventsDetected, {Name = "Mirage Island", Pos = pos})
        Log("TARGET: Mirage Island", "SUCCESS")
        State.TargetFound = true
    end

    -- [2] KITSUNE ISLAND
    if Locations:FindFirstChild("Kitsune Island") then
        local pos = GetPos(Locations["Kitsune Island"])
        table.insert(State.EventsDetected, {Name = "Kitsune Island", Pos = pos})
        Log("TARGET: Kitsune Island", "SUCCESS")
        State.TargetFound = true
    end

    -- [3] FULL MOON (Texture Check)
    if Services.Lighting:FindFirstChild("Sky") then
        local moonId = tostring(Services.Lighting.Sky.MoonTextureId)
        if string.find(moonId, "9709149431") then
            table.insert(State.EventsDetected, {Name = "Full Moon", Pos = nil})
            Log("TARGET: Full Moon", "SUCCESS")
            -- We don't set TargetFound=true for just Moon (usually), unless you want to stop for it.
        end
    end

    return State.TargetFound
end

--------------------------------------------------------------------------------
-- // [5] WEBHOOK REPORTER //
--------------------------------------------------------------------------------
local function SendAlert()
    UpdateStatus("[REPORTING]", Color3.fromRGB(0, 255, 255))
    if getgenv().DevanshConfig.WebhookURL:find("YOUR_WEBHOOK") then return end

    local desc = ""
    local tweenCode = ""

    for _, evt in pairs(State.EventsDetected) do
        desc = desc .. "• **" .. evt.Name .. "**\n"
        if evt.Pos then
            tweenCode = string.format("game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(15), {CFrame = CFrame.new(%d,%d,%d)}):Play()", evt.Pos.X, evt.Pos.Y, evt.Pos.Z)
        end
    end

    local embed = {
        title = "👑 EVENT SECURED",
        description = desc,
        color = getgenv().DevanshConfig.EmbedColor,
        fields = {
            {name = "Server Job ID", value = "```"..game.JobId.."```", inline = false},
            {name = "Quick Join", value = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance("..game.PlaceId..", '"..game.JobId.."', game.Players.LocalPlayer)\n```", inline = false}
        },
        footer = {text = "Devansh Tracker | God Mode v5.0"}
    }

    if tweenCode ~= "" then
        table.insert(embed.fields, {name = "✈️ FLY TO ISLAND", value = "```lua\n"..tweenCode.."\n```", inline = false})
    end

    local payload = Services.Http:JSONEncode({
        content = getgenv().DevanshConfig.PingRole,
        username = getgenv().DevanshConfig.BotName,
        avatar_url = getgenv().DevanshConfig.BotAvatar,
        embeds = {embed}
    })

    HttpRequest({
        Url = getgenv().DevanshConfig.WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })
    Log("Webhook Dispatched.", "SUCCESS")
end

--------------------------------------------------------------------------------
-- // [6] ASCENDING SERVER HOPPER //
--------------------------------------------------------------------------------
local function HopServer()
    if not getgenv().DevanshConfig.HopEnabled then return end
    UpdateStatus("[HOPPING]", Color3.fromRGB(255, 50, 50))
    Log("Searching for empty server...", "WARN")

    local function TryHop()
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, response = pcall(function() return Services.Http:JSONDecode(HttpRequest({Url=url, Method="GET"}).Body) end)
        
        if success and response.data then
            for _, srv in pairs(response.data) do
                if srv.playing >= getgenv().DevanshConfig.MinPlayers and srv.playing <= getgenv().DevanshConfig.MaxPlayers and srv.id ~= game.JobId then
                    Log("Found: " .. srv.playing .. " Players", "SUCCESS")
                    Services.Teleport:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    return
                end
            end
        end
        Log("API Busy. Retrying...", "FAIL")
        task.wait(2)
        TryHop()
    end
    TryHop()
end

--------------------------------------------------------------------------------
-- // [7] MAIN EXECUTION LOOP //
--------------------------------------------------------------------------------
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(1) 
    
    if ScanWorld() then
        UpdateStatus("[SECURED]", Color3.fromRGB(0, 255, 0))
        Log("!!! EVENT DETECTED !!!", "SUCCESS")
        SendAlert()
        -- Script Stops to let you play
    else
        Log("No events found.", "FAIL")
        Log("Hopping in " .. getgenv().DevanshConfig.HopDelay .. "s", "WARN")
        task.wait(getgenv().DevanshConfig.HopDelay)
        HopServer()
    end
end)
