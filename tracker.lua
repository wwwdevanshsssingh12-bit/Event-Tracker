--[[
    DEVANSH EVENT TRACKER | GOD MODE EDITION [v14.0]
    > ARCHITECT: Gem (AI)
    > MODULES: ESP + ELITES + BOSSES + EVENTS
    > STATUS: UNDETECTED | OP
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD ]]
    WebhookURL   = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    PingRole     = "@everyone", -- Leave empty "" to disable ping
    
    -- [[ AUTOMATION ]]
    AutoScript   = "", -- Paste RAW link here to auto-execute after hopping
    
    -- [[ VISUALS ]]
    BotName      = "Devansh God-Tracker",
    BotAvatar    = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401452994632/ezgif-68d035637d1d997c.gif",
    ThumbnailUrl = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401037754389/ezgif-2381261b040e0649.gif",

    -- [[ SETTINGS ]]
    ScanDelay    = 0.5,
    ESP_Enabled  = true,  -- Wallhacks for events
    MinPlayers   = 1,
    MaxPlayers   = 11     -- Strict limit to avoid full servers
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
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or request
local QueueTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport

--------------------------------------------------------------------------------
-- // [3] ESP ENGINE (WALLHACKS) //
--------------------------------------------------------------------------------
local ESP_Storage = {}

local function CreateESP(target, name, color)
    if not getgenv().DevanshConfig.ESP_Enabled then return end
    if not target then return end

    -- Cleanup old ESP for same object
    if ESP_Storage[target] then 
        ESP_Storage[target].Line:Remove()
        ESP_Storage[target].Text:Remove()
        ESP_Storage[target] = nil
    end

    local Line = Drawing.new("Line")
    Line.Visible = false
    Line.Color = color
    Line.Thickness = 2
    Line.Transparency = 1

    local Text = Drawing.new("Text")
    Text.Visible = false
    Text.Center = true
    Text.Outline = true
    Text.Font = 2
    Text.Color = color
    Text.Size = 14
    Text.Text = name

    ESP_Storage[target] = {Line = Line, Text = Text}

    -- Render Loop
    local Connection
    Connection = Services.RunService.RenderStepped:Connect(function()
        if not target or not target.Parent then 
            Line:Remove()
            Text:Remove()
            Connection:Disconnect()
            ESP_Storage[target] = nil
            return 
        end

        local Pos, OnScreen = Services.Workspace.CurrentCamera:WorldToViewportPoint(target.Position)
        local Char = LocalPlayer.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")

        if Root then
            if OnScreen then
                Line.From = Vector2.new(Services.Workspace.CurrentCamera.ViewportSize.X / 2, Services.Workspace.CurrentCamera.ViewportSize.Y)
                Line.To = Vector2.new(Pos.X, Pos.Y)
                Line.Visible = true

                Text.Position = Vector2.new(Pos.X, Pos.Y - 20)
                Text.Visible = true
            else
                Line.Visible = false
                Text.Visible = false
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- // [4] SCANNERS (HYBRID ENGINES) //
--------------------------------------------------------------------------------

-- Helper: Find Object safely
local function Find(path, name)
    if not path then return nil end
    return path:FindFirstChild(name)
end

-- [ENGINE 1] WORLD EVENTS (Mirage, Kitsune, Frozen)
local function ScanWorld()
    local detected = {}
    
    -- Mirage (Name Check)
    local mirage = Find(Services.Workspace._WorldOrigin.Locations, "Mirage Island") or Find(Services.Workspace.Map, "Mirage Island")
    if mirage and mirage.PrimaryPart then
        table.insert(detected, {name="Mirage Island", pos=mirage.PrimaryPart.Position, color=Color3.fromRGB(0, 255, 255)})
        CreateESP(mirage.PrimaryPart, "Mirage Island", Color3.fromRGB(0, 255, 255))
    end

    -- Frozen Dimension
    local frozen = Find(Services.Workspace.Map, "FrozenDimension")
    if frozen and frozen.PrimaryPart then
        table.insert(detected, {name="Frozen Dimension", pos=frozen.PrimaryPart.Position, color=Color3.fromRGB(200, 200, 255)})
        CreateESP(frozen.PrimaryPart, "Frozen Dimension", Color3.fromRGB(200, 200, 255))
    end
    
    -- Prehistoric
    local ancient = Find(Services.Workspace.Map, "PrehistoricIsland") or Find(Services.Workspace.Map, "AncientIsland")
    if ancient and ancient.PrimaryPart then
         table.insert(detected, {name="Prehistoric Island", pos=ancient.PrimaryPart.Position, color=Color3.fromRGB(100, 255, 100)})
    end

    return detected
end

-- [ENGINE 2] LIGHTING (Texture ID Check)
local function ScanLighting()
    local detected = {}
    local MoonID = tostring(Services.Lighting.Sky.MoonTextureId)

    -- Full Moon
    if string.find(MoonID, "9709149431") then
        table.insert(detected, {name="Full Moon (100%)", pos=nil})
    elseif string.find(MoonID, "9709149052") then
        table.insert(detected, {name="Full Moon (75%)", pos=nil})
    end

    -- Kitsune Moon
    if string.find(MoonID, "15306698696") then
        -- Verify with Island
        local shrine = Find(Services.Workspace.Map, "Kitsune Island") or Find(Services.Workspace._WorldOrigin.Locations, "Kitsune Island")
        if shrine and shrine.PrimaryPart then
             table.insert(detected, {name="Kitsune Shrine", pos=shrine.PrimaryPart.Position, color=Color3.fromRGB(80, 80, 255)})
             CreateESP(shrine.PrimaryPart, "Kitsune Shrine", Color3.fromRGB(80, 80, 255))
        else
             table.insert(detected, {name="Kitsune Moon (No Island Yet)", pos=nil})
        end
    end

    return detected
end

-- [ENGINE 3] ENTITY RADAR (Elites, Bosses)
local function ScanEntities()
    local detected = {}
    local Enemies = Services.Workspace:FindFirstChild("Enemies") or Services.Workspace:FindFirstChild("Characters")
    if not Enemies then return {} end

    for _, v in pairs(Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            -- Elites
            if table.find({"Diablo", "Deandre", "Urban"}, v.Name) then
                table.insert(detected, {name="Elite Hunter: "..v.Name, pos=v.HumanoidRootPart.Position, color=Color3.fromRGB(255, 50, 50)})
                CreateESP(v.HumanoidRootPart, "Elite: "..v.Name, Color3.fromRGB(255, 50, 50))
            end
            
            -- Raid Bosses
            if v.Name == "Dough King" or v.Name == "Cake Prince" then
                table.insert(detected, {name="RAID BOSS: "..v.Name, pos=v.HumanoidRootPart.Position, color=Color3.fromRGB(255, 0, 0)})
                CreateESP(v.HumanoidRootPart, v.Name, Color3.fromRGB(255, 0, 0))
            elseif v.Name == "rip_indra True Form" then
                table.insert(detected, {name="RAID BOSS: Rip Indra", pos=v.HumanoidRootPart.Position, color=Color3.fromRGB(255, 255, 255)})
                CreateESP(v.HumanoidRootPart, "Rip Indra", Color3.fromRGB(255, 255, 255))
            elseif v.Name == "Soul Reaper" then
                table.insert(detected, {name="RAID BOSS: Soul Reaper", pos=v.HumanoidRootPart.Position, color=Color3.fromRGB(100, 0, 100)})
                CreateESP(v.HumanoidRootPart, "Soul Reaper", Color3.fromRGB(100, 0, 100))
            end
        end
    end
    return detected
end

--------------------------------------------------------------------------------
-- // [5] PROFESSIONAL GUI //
--------------------------------------------------------------------------------
local StatusLabel

local function UpdateStatus(text, color)
    if StatusLabel then
        StatusLabel.Text = text
        if color then StatusLabel.TextColor3 = color end
    end
end

local function BuildGUI()
    local Core = (gethui and gethui()) or Services.CoreGui or LocalPlayer.PlayerGui
    if Core:FindFirstChild("DevanshGodMode") then Core.DevanshGodMode:Destroy() end

    local Screen = Instance.new("ScreenGui")
    Screen.Name = "DevanshGodMode"
    Screen.ResetOnSpawn = false
    Screen.Parent = Core

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 110)
    Frame.Position = UDim2.new(0.5, -160, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Frame.BorderSizePixel = 0
    Frame.Parent = Screen

    -- Top Bar (Event Tracker)
    local TopBar = Instance.new("TextLabel")
    TopBar.Size = UDim2.new(1, 0, 0, 25)
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    TopBar.Text = "Event Tracker [GOD MODE]"
    TopBar.Font = Enum.Font.GothamBlack
    TopBar.TextColor3 = Color3.fromRGB(0, 0, 0)
    TopBar.TextSize = 14
    TopBar.Parent = Frame

    -- Status
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 1, -50)
    StatusLabel.Position = UDim2.new(0, 0, 0, 25)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "INITIALIZING..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 16
    StatusLabel.Parent = Frame

    -- Bottom Bar (Credit)
    local Bottom = Instance.new("TextLabel")
    Bottom.Size = UDim2.new(1, 0, 0, 20)
    Bottom.Position = UDim2.new(0, 0, 1, -20)
    Bottom.BackgroundTransparency = 1
    Bottom.Text = "Made by Devansh"
    Bottom.Font = Enum.Font.Code
    Bottom.TextColor3 = Color3.fromRGB(150, 150, 150)
    Bottom.TextSize = 12
    Bottom.Parent = Frame
    
    -- Dragging
    local Drag = Instance.new("UIDragDetector")
    Drag.Parent = Frame
end

--------------------------------------------------------------------------------
-- // [6] WEBHOOK & TWEEN AI //
--------------------------------------------------------------------------------
local function SendWebhook(events)
    local Config = getgenv().DevanshConfig
    local fields = {}
    local eventNames = {}
    local tweenCode = ""

    for _, e in ipairs(events) do
        table.insert(eventNames, e.name)
        if e.pos then
            -- Smart Tween AI Generator
            local X, Y, Z = math.floor(e.pos.X), math.floor(e.pos.Y), math.floor(e.pos.Z)
            tweenCode = tweenCode .. string.format("\n-- FLY TO %s\nloadstring([[local T=Vector3.new(%d,%d,%d);local P=game.Players.LocalPlayer.Character.HumanoidRootPart;local TS=game:GetService('TweenService');TS:Create(P,TweenInfo.new(2),{CFrame=CFrame.new(P.Position.X,400,P.Position.Z)}):Play();task.wait(2.1);TS:Create(P,TweenInfo.new((P.Position-T).Magnitude/300),{CFrame=CFrame.new(T.X,400,T.Z)}):Play()]])()", e.name, X, Y, Z)
        end
    end

    table.insert(fields, {name="🚨 TARGETS ACQUIRED", value=table.concat(eventNames, "\n"), inline=false})
    
    -- Robust Join Script
    local JoinScript = string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", game.PlaceId, game.JobId)
    table.insert(fields, {name="📜 Join Code", value="```lua\n" .. JoinScript .. "\n```", inline=false})
    
    if tweenCode ~= "" then
        table.insert(fields, {name="✈️ Tween Script", value="```lua" .. tweenCode .. "\n```", inline=false})
    end
    
    local Payload = {
        username = Config.BotName,
        avatar_url = Config.BotAvatar,
        content = Config.PingRole .. " **GOD MODE DETECTED EVENTS!**",
        embeds = {{
            title = "Server Scan Complete",
            color = 16766720,
            fields = fields,
            thumbnail = {url = Config.ThumbnailUrl},
            footer = {text = "Devansh Tracker | God Mode v14"},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    HttpRequest({
        Url = Config.WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = Services.Http:JSONEncode(Payload)
    })
end

--------------------------------------------------------------------------------
-- // [7] SERVER HOP (FAIL-SAFE) //
--------------------------------------------------------------------------------
local function Hop()
    UpdateStatus("HOPPING SERVERS...", Color3.fromRGB(255, 100, 100))
    
    if QueueTeleport and getgenv().DevanshConfig.AutoScript ~= "" then
        QueueTeleport('task.wait(3); loadstring(game:HttpGet("'..getgenv().DevanshConfig.AutoScript..'"))()')
    end

    task.spawn(function()
        local Cursor = ""
        while true do
            local URL = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
            if Cursor ~= "" then URL = URL.."&cursor="..Cursor end
            
            local Success, Body = pcall(function() 
                return Services.Http:JSONDecode(HttpRequest({Url=URL, Method="GET"}).Body) 
            end)

            if Success and Body and Body.data then
                for _, s in ipairs(Body.data) do
                    if s.playing and s.playing >= getgenv().DevanshConfig.MinPlayers and s.playing <= getgenv().DevanshConfig.MaxPlayers and s.id ~= game.JobId then
                        UpdateStatus("JOINING: " .. s.playing .. " PLRS", Color3.fromRGB(0, 255, 0))
                        Services.Teleport:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                        task.wait(5) -- Wait for TP
                    end
                end
                if Body.nextPageCursor then Cursor = Body.nextPageCursor else Cursor = "" end
            end
            task.wait(0.5)
        end
    end)
end

--------------------------------------------------------------------------------
-- // [8] MAIN STACK LOGIC //
--------------------------------------------------------------------------------
task.spawn(function()
    BuildGUI()
    if not game:IsLoaded() then game.Loaded:Wait() end
    UpdateStatus("SCANNING (GOD MODE)...", Color3.fromRGB(255, 255, 255))
    task.wait(2) -- Allow replication

    local Stack = {}

    -- Run All Engines
    local World = ScanWorld()
    local Lighting = ScanLighting()
    local Entities = ScanEntities()

    -- Merge Results
    for _, v in pairs(World) do table.insert(Stack, v) end
    for _, v in pairs(Lighting) do table.insert(Stack, v) end
    for _, v in pairs(Entities) do table.insert(Stack, v) end

    if #Stack > 0 then
        UpdateStatus("EVENTS FOUND: " .. #Stack, Color3.fromRGB(0, 255, 0))
        SendWebhook(Stack)
        task.wait(8) -- Wait to show ESP
        UpdateStatus("RESUMING SEARCH...", Color3.fromRGB(255, 150, 0))
        Hop()
    else
        UpdateStatus("NO EVENTS - HOPPING", Color3.fromRGB(150, 150, 150))
        task.wait(1)
        Hop()
    end
end)
