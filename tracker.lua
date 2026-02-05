--[[
    DEVANSH EVENT TRACKER | GOLDY OP EDITION [v6.1]
    > CONFIG: Custom Webhook & Avatar Updated
    > ENGINE: V19 Architecture + Prehistoric
    > VISUALS: Hyper-Gold Professional GUI
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD ]]
    WebhookURL  = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    -- [[ IDENTITY ]]
    BotName     = "Event tracker",
    BotAvatar   = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6985a369&is=698451e9&hm=af1360b72e9d331403c17f46f80135f7b160fa37890c1b6c31d3535f3fe1f6ea&",
    PingRole    = "@everyone",
    
    -- [[ TUNING ]]
    ScanDelay   = 0.3,    -- Speed of scanning
    MinPlayers  = 1,      -- For Hopping
    MaxPlayers  = 12      -- For Hopping
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
    Run = game:GetService("RunService"),
    UserInput = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

--------------------------------------------------------------------------------
-- // [3] PROFESSIONAL GOLD GUI (DRAGGABLE) //
--------------------------------------------------------------------------------
local ConsoleArea, StatusLabel

local function CreateGoldGUI()
    if Services.CoreGui:FindFirstChild("DevanshGoldy") then Services.CoreGui.DevanshGoldy:Destroy() end

    local Screen = Instance.new("ScreenGui")
    Screen.Name = "DevanshGoldy"
    Screen.Parent = Services.CoreGui
    Screen.ResetOnSpawn = false

    -- Main Container
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 320, 0, 200)
    Main.Position = UDim2.new(0.5, -160, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Parent = Screen

    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    Services.UserInput.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Gold Glow Border (Animated)
    local Stroke = Instance.new("UIStroke"); Stroke.Parent = Main; Stroke.Thickness = 3
    local Gradient = Instance.new("UIGradient"); Gradient.Parent = Stroke
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),   -- Gold
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 165, 0)), -- Orange Gold
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))    -- Gold
    })
    
    task.spawn(function()
        while Screen.Parent do Gradient.Rotation = Gradient.Rotation + 2; task.wait(0.02) end
    end)

    -- Rounded Corners
    local UC = Instance.new("UICorner"); UC.CornerRadius = UDim.new(0, 10); UC.Parent = Main

    -- Header
    local Header = Instance.new("Frame"); Header.Parent = Main; Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Header.Size = UDim2.new(1, 0, 0, 30)
    local HC = Instance.new("UICorner"); HC.CornerRadius = UDim.new(0, 10); HC.Parent = Header
    local Fix = Instance.new("Frame"); Fix.Parent = Header; Fix.BackgroundColor3 = Color3.fromRGB(20,20,20); Fix.Size = UDim2.new(1,0,0,10); Fix.Position = UDim2.new(0,0,1,-10); Fix.BorderSizePixel=0

    local Title = Instance.new("TextLabel"); Title.Parent = Header; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0,10,0,0); Title.Size = UDim2.new(1,-20,1,0)
    Title.Text = getgenv().DevanshConfig.BotName:upper(); Title.Font = Enum.Font.GothamBold; Title.TextColor3 = Color3.fromRGB(255, 215, 0); Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left

    StatusLabel = Instance.new("TextLabel"); StatusLabel.Parent = Header; StatusLabel.BackgroundTransparency = 1; StatusLabel.Size = UDim2.new(1,-10,1,0); StatusLabel.Position = UDim2.new(0,0,0,0)
    StatusLabel.Text = "[LOADING]"; StatusLabel.Font = Enum.Font.Code; StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255); StatusLabel.TextSize = 11; StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Console
    local CBG = Instance.new("Frame"); CBG.Parent = Main; CBG.BackgroundColor3 = Color3.fromRGB(5,5,5); CBG.Position = UDim2.new(0,10,0,40); CBG.Size = UDim2.new(1,-20,1,-50)
    local CC = Instance.new("UICorner"); CC.CornerRadius = UDim.new(0, 8); CC.Parent = CBG
    
    ConsoleArea = Instance.new("ScrollingFrame"); ConsoleArea.Parent = CBG; ConsoleArea.Size = UDim2.new(1,-10,1,-10); ConsoleArea.Position = UDim2.new(0,5,0,5); ConsoleArea.BackgroundTransparency = 1; ConsoleArea.ScrollBarThickness = 2
    local UIList = Instance.new("UIListLayout"); UIList.Parent = ConsoleArea; UIList.SortOrder = Enum.SortOrder.LayoutOrder

    return ConsoleArea
end

CreateGoldGUI()

-- GUI Logging System
local LogIndex = 0
local function Log(text, type)
    if not ConsoleArea then return end
    LogIndex = LogIndex + 1
    
    local color = Color3.fromRGB(255, 255, 255)
    local prefix = "[*]"
    
    if type == "SUCCESS" then color = Color3.fromRGB(0, 255, 100); prefix = "[+]"
    elseif type == "WARN" then color = Color3.fromRGB(255, 200, 0); prefix = "[!]"
    elseif type == "FAIL" then color = Color3.fromRGB(255, 50, 50); prefix = "[-]"
    elseif type == "CMD" then color = Color3.fromRGB(0, 200, 255); prefix = "[$]" end

    local L = Instance.new("TextLabel"); L.Parent = ConsoleArea; L.BackgroundTransparency = 1; L.Size = UDim2.new(1,0,0,15); L.Font = Enum.Font.Code; L.TextSize = 11; L.TextColor3 = color; L.TextXAlignment = Enum.TextXAlignment.Left
    L.Text = prefix .. " " .. text; L.LayoutOrder = LogIndex

    if #ConsoleArea:GetChildren() > 15 then ConsoleArea:GetChildren()[1]:Destroy() end
    ConsoleArea.CanvasPosition = Vector2.new(0, 99999)
end

local function UpdateStatus(text) if StatusLabel then StatusLabel.Text = text end end

--------------------------------------------------------------------------------
-- // [4] SCANNING ENGINES (EXACT COPY V19 + EXTRA ENGINE) //
--------------------------------------------------------------------------------

local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- [ENGINE 1] PREHISTORIC ISLAND (The "Extra" Engine)
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

    return {name="PREHISTORIC ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [ENGINE 2] MIRAGE ISLAND (Cut-to-Cut V19)
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

    return {name="MIRAGE ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [ENGINE 3] KITSUNE SHRINE (Cut-to-Cut V19)
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

    return {name="KITSUNE SHRINE", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- [ENGINE 4] FROZEN DIMENSION (Cut-to-Cut V19)
local function ScanFrozen()
    Log("Scanning Frozen...", "CMD")
    if SafeCheck(function() return Services.Workspace.Map:FindFirstChild("FrozenDimension") or Services.Workspace.Map:FindFirstChild("Frozen Island") end) then
        local p = nil
        if Services.Workspace.Map:FindFirstChild("FrozenDimension") then p = Services.Workspace.Map.FrozenDimension.Position end
        Log("Target: Dimension Gate", "SUCCESS")
        return {name="FROZEN DIMENSION", score=100, reason="Dimension Gate", pos=p}
    end
    return {score=0}
end

-- [ENGINE 5] FULL MOON (Cut-to-Cut V19)
local function ScanMoon()
    Log("Scanning Celestial...", "CMD")
    if SafeCheck(function() return string.find(Services.Lighting.Sky.MoonTextureId, "9709149431") end) then 
        Log("Target: Full Moon", "SUCCESS")
        return {name="FULL MOON", score=100, reason="Texture ID: 9709149431", pos=nil}
    end
    return {score=0}
end

--------------------------------------------------------------------------------
-- // [5] PROFESSIONAL GOLD EMBED SYSTEM //
--------------------------------------------------------------------------------

local function SendGoldWebhook(events)
    UpdateStatus("[REPORTING]")
    local fields = {}
    local desc = ""
    
    for _, e in pairs(events) do
        desc = desc .. "► **" .. e.name .. "** (" .. e.score .. "%)\n"
        if e.pos then
            local tweenCode = string.format("game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(15), {CFrame = CFrame.new(%d,%d,%d)}):Play()", e.pos.X, e.pos.Y, e.pos.Z)
            table.insert(fields, {name = "✈️ TWEEN TO " .. e.name, value = "```lua\n"..tweenCode.."\n```", inline = false})
        end
    end

    table.insert(fields, {name = "📄 SERVER JOB ID", value = "```"..game.JobId.."```", inline = false})
    table.insert(fields, {name = "🔗 QUICK JOIN SCRIPT", value = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance("..game.PlaceId..", '"..game.JobId.."', game.Players.LocalPlayer)\n```", inline = false})

    local embed = {
        title = "👑 LEGENDARY EVENT SECURED",
        description = desc,
        color = 16766720, -- HYPER GOLD COLOR
        fields = fields,
        thumbnail = {url = getgenv().DevanshConfig.BotAvatar},
        footer = {text = "Devansh Tracker | Goldy OP Edition | v6.1"}
    }

    local payload = Services.Http:JSONEncode({
        username = getgenv().DevanshConfig.BotName,
        avatar_url = getgenv().DevanshConfig.BotAvatar,
        content = getgenv().DevanshConfig.PingRole,
        embeds = {embed}
    })

    HttpRequest({
        Url = getgenv().DevanshConfig.WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = payload
    })
    Log("Gold Webhook Sent!", "SUCCESS")
end

--------------------------------------------------------------------------------
-- // [6] SERVER HOPPING (EXACT COPY V19) //
--------------------------------------------------------------------------------

local function Hop()
    UpdateStatus("[HOPPING]")
    Log("Initiating Hop Protocol...", "WARN")
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local s, body = pcall(function() return Services.Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) end)
    if s and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then table.insert(AllIDs, v.id) end
        end
    end
    if #AllIDs > 0 then Services.Teleport:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else task.wait(1); Hop() end
end

--------------------------------------------------------------------------------
-- // [7] MAIN LOGIC LOOP //
--------------------------------------------------------------------------------
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(1)
    
    UpdateStatus("[SCANNING]")
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
        UpdateStatus("[FOUND!]")
        Log("!!! EVENT DETECTED !!!", "SUCCESS")
        SendGoldWebhook(FoundEvents)
        -- STOP: Do not hop if found.
    else
        Log("No events. Hopping...", "FAIL")
        task.wait(2)
        Hop()
    end
end)
