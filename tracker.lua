--[[
    DEVANSH EVENT TRACKER | MOVABLE ELITE [v4.5]
    > MODE: Delta AutoExec (No Loader Needed)
    > GUI: Draggable / Compact / Curved
    > ENGINE: Instant Asset Detection
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD ]]
    WebhookURL  = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",  -- <--- PASTE WEBHOOK HERE
    
    -- [[ SETTINGS ]]
    BotName     = "Evet Tracker",
    PingRole    = "@everyone",              -- Pings everyone
    EmbedColor  = 16766720,                 -- Hyper Gold (#FFD700)
    
    -- [[ HOPPING ]]
    HopEnabled  = true,
    HopDelay    = 5.0,     -- Seconds before hopping
    MinPlayers  = 1,
    MaxPlayers  = 12
}

--------------------------------------------------------------------------------
-- // CORE SERVICES //
--------------------------------------------------------------------------------
local Services = {
    Players = game:GetService("Players"),
    Http = game:GetService("HttpService"),
    Teleport = game:GetService("TeleportService"),
    CoreGui = game:GetService("CoreGui"),
    Lighting = game:GetService("Lighting"),
    Workspace = game:GetService("Workspace"),
    Tween = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Session State
local EventsDetected = {}
local TargetFound = false

--------------------------------------------------------------------------------
-- // [2] DRAGGABLE UI ENGINE //
--------------------------------------------------------------------------------
local ConsoleOutput -- Reference for logging function

-- Mobile/PC Drag Logic
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function CreateMiniUI()
    if Services.CoreGui:FindFirstChild("DevanshMiniTracker") then
        Services.CoreGui.DevanshMiniTracker:Destroy()
    end

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "DevanshMiniTracker"
    GUI.Parent = Services.CoreGui
    GUI.ResetOnSpawn = false

    -- 1. Main Compact Container (Small & Curved)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 280, 0, 160) -- Very small size
    MainFrame.Position = UDim2.new(0.5, -140, 0.2, 0) -- Starts Top-Center
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true -- Important for dragging
    MainFrame.Parent = GUI

    -- Make it Movable
    MakeDraggable(MainFrame)

    -- Curved Corners
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    -- RGB/Gold Glow Border (Curved)
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2.5
    Stroke.Transparency = 0
    Stroke.Parent = MainFrame
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)), -- Gold
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 0)), -- Orange
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0)) -- Gold
    })
    Gradient.Parent = Stroke

    -- Animate Border
    task.spawn(function()
        while GUI.Parent do
            Gradient.Rotation = Gradient.Rotation + 3
            task.wait(0.02)
        end
    end)

    -- 2. Compact Header
    local Title = Instance.new("TextLabel")
    Title.Text = getgenv().DevanshConfig.BotName:upper()
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 12
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Parent = MainFrame

    -- 3. The "Smart" Console
    local ConsoleFrame = Instance.new("Frame")
    ConsoleFrame.Size = UDim2.new(1, -16, 1, -35)
    ConsoleFrame.Position = UDim2.new(0, 8, 0, 25)
    ConsoleFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    ConsoleFrame.Parent = MainFrame
    
    local ConsoleCorner = Instance.new("UICorner")
    ConsoleCorner.CornerRadius = UDim.new(0, 8)
    ConsoleCorner.Parent = ConsoleFrame

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -10, 1, -10)
    Scroll.Position = UDim2.new(0, 5, 0, 5)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 0 -- Hidden scrollbar
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.Parent = ConsoleFrame

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 2)
    List.Parent = Scroll

    return Scroll
end

ConsoleOutput = CreateMiniUI()

-- Smart Log Function: Prevents scrolling issues by deleting old logs
local function Log(text)
    if not ConsoleOutput then return end
    
    -- Add new log
    local Label = Instance.new("TextLabel")
    Label.Text = "> " .. text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.Size = UDim2.new(1, 0, 0, 14)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ConsoleOutput

    -- Auto-Cleanup: Keep only last 7 lines
    local children = ConsoleOutput:GetChildren()
    if #children > 8 then
        for i = 1, (#children - 8) do
            if children[i]:IsA("TextLabel") then children[i]:Destroy() end
        end
    end
    
    -- Auto-Scroll to bottom
    ConsoleOutput.CanvasPosition = Vector2.new(0, 99999)
end

Log("Draggable Sentinel Loaded.")
Log("Config: Delta AutoExec")

--------------------------------------------------------------------------------
-- // [3] OPTIMIZED ASSET DETECTION ENGINE //
--------------------------------------------------------------------------------
local function GetPos(model)
    if model and model.PrimaryPart then return model.PrimaryPart.Position end
    return Vector3.new(0,100,0)
end

local function ScanWorld()
    EventsDetected = {}
    TargetFound = false
    Log("Scanning Map Assets...")

    -- LOCATIONS FOLDER (Fastest Check)
    local Locations = Services.Workspace._WorldOrigin.Locations

    -- [1] MIRAGE ISLAND (Model Name Check)
    if Locations:FindFirstChild("Mirage Island") then
        table.insert(EventsDetected, {Name = "Mirage Island", Pos = GetPos(Locations["Mirage Island"])})
        Log(">> FOUND: MIRAGE")
        TargetFound = true
    end

    -- [2] KITSUNE ISLAND (Model Name Check)
    if Locations:FindFirstChild("Kitsune Island") then
        table.insert(EventsDetected, {Name = "Kitsune Island", Pos = GetPos(Locations["Kitsune Island"])})
        Log(">> FOUND: KITSUNE")
        TargetFound = true
    end

    -- [3] FULL MOON (Texture ID Check)
    if Services.Lighting:FindFirstChild("Sky") then
        local moonId = tostring(Services.Lighting.Sky.MoonTextureId)
        if string.find(moonId, "9709149431") then
            table.insert(EventsDetected, {Name = "Full Moon", Pos = nil})
            Log(">> FOUND: FULL MOON")
        end
    end
    
    return TargetFound
end

--------------------------------------------------------------------------------
-- // [4] DISCORD WEBHOOK //
--------------------------------------------------------------------------------
local function SendAlert()
    if getgenv().DevanshConfig.WebhookURL == "YOUR_WEBHOOK_URL_HERE" then return end
    
    local Config = getgenv().DevanshConfig
    local desc = ""
    local tweenCode = ""

    for _, evt in pairs(EventsDetected) do
        desc = desc .. "• **" .. evt.Name .. "**\n"
        if evt.Pos then
            -- Auto-Generate Tween Script
            tweenCode = string.format("game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(15), {CFrame = CFrame.new(%d,%d,%d)}):Play()", evt.Pos.X, evt.Pos.Y, evt.Pos.Z)
        end
    end

    local embed = {
        title = "👑 RARE EVENT DETECTED!",
        description = desc,
        color = Config.EmbedColor,
        fields = {
            {name = "Server Job ID", value = "```"..game.JobId.."```", inline = false},
            {name = "Direct Join", value = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance("..game.PlaceId..", '"..game.JobId.."', game.Players.LocalPlayer)\n```", inline = false}
        },
        footer = {text = "Devansh Mini Sentinel | Delta Exec"}
    }

    if tweenCode ~= "" then
        table.insert(embed.fields, {name = "✈️ FLY TO ISLAND", value = "```lua\n"..tweenCode.."\n```", inline = false})
    end

    local payload = Services.Http:JSONEncode({
        content = Config.PingRole,
        username = Config.BotName,
        embeds = {embed}
    })

    HttpRequest({
        Url = Config.WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })
    Log("Webhook Sent!")
end

--------------------------------------------------------------------------------
-- // [5] SERVER HOPPER //
--------------------------------------------------------------------------------
local function HopServer()
    if not getgenv().DevanshConfig.HopEnabled then return end
    Log("Finding Empty Server...")

    local function TryHop()
        -- Ascending Sort = Finds servers with 1-2 players first
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local success, response = pcall(function() return Services.Http:JSONDecode(HttpRequest({Url=url, Method="GET"}).Body) end)
        
        if success and response.data then
            for _, srv in pairs(response.data) do
                if srv.playing >= 1 and srv.playing <= 12 and srv.id ~= game.JobId then
                    Log("Target: " .. srv.playing .. " Players")
                    Services.Teleport:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    return
                end
            end
        end
        Log("Retrying API...")
        task.wait(2)
        TryHop()
    end
    TryHop()
end

--------------------------------------------------------------------------------
-- // MAIN LOOP //
--------------------------------------------------------------------------------
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(1.5) -- Small buffer for map load
    
    if ScanWorld() then
        Log("!!! TARGET SECURED !!!")
        SendAlert()
        -- Script stops here to let you play
    else
        Log("Nothing found.")
        Log("Hopping in " .. getgenv().DevanshConfig.HopDelay .. "s")
        task.wait(getgenv().DevanshConfig.HopDelay)
        HopServer()
    end
end)
