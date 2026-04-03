--[[
    DEVANSH EVENT TRACKER | GOD MODE EDITION [v15.1 - FULL PRODUCTION]
    > ARCHITECT: Gem (AI)
    > MODULES: ESP, HYBRID DETECTION, HEURISTIC HOPPING, MODERN UI, ADVANCED WEBHOOK
    > STATUS: UNDETECTED | ROBUST
]]

--------------------------------------------------------------------------------
-- // [1] USER CONFIGURATION //
--------------------------------------------------------------------------------
getgenv().DevanshConfig = {
    -- [[ DISCORD ]]
    WebhookURL   = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    -- [[ AUTOMATION ]]
    AutoScript   = "", 
    
    -- [[ SETTINGS ]]
    ScanDelay    = 0.5,
    ESP_Enabled  = true,  
    MinPlayers   = 1,
    MaxPlayers   = 10     
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
    CoreGui      = game:GetService("CoreGui"),
    GuiService   = game:GetService("GuiService")
}

local LocalPlayer = Services.Players.LocalPlayer
local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or request
local QueueTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport

--------------------------------------------------------------------------------
-- // [3] ESP ENGINE //
--------------------------------------------------------------------------------
local ESP_Storage = {}

local function CreateESP(target, name, color)
    if not getgenv().DevanshConfig.ESP_Enabled or not target then return end

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
-- // [4] ADVANCED HYBRID DETECTION //
--------------------------------------------------------------------------------
local function SafeFind(parent, name)
    if typeof(parent) ~= "Instance" then return nil end
    return parent:FindFirstChild(name)
end

local function ScanWorld()
    local detected = {}
    local MapFolder = Services.Workspace:FindFirstChild("Map")
    local WorldOrigin = Services.Workspace:FindFirstChild("_WorldOrigin")
    local Locations = WorldOrigin and WorldOrigin:FindFirstChild("Locations")
    
    local mirage = SafeFind(Locations, "Mirage Island") or SafeFind(MapFolder, "Mirage Island")
    if mirage and mirage.PrimaryPart then
        table.insert(detected, {name="Mirage Island", pos=mirage.PrimaryPart.Position, color=Color3.fromRGB(0, 255, 255)})
        CreateESP(mirage.PrimaryPart, "Mirage Island", Color3.fromRGB(0, 255, 255))
    end

    local frozen = SafeFind(MapFolder, "FrozenDimension")
    if frozen and frozen.PrimaryPart then
        table.insert(detected, {name="Frozen Dimension", pos=frozen.PrimaryPart.Position, color=Color3.fromRGB(200, 200, 255)})
        CreateESP(frozen.PrimaryPart, "Frozen Dimension", Color3.fromRGB(200, 200, 255))
    end
    
    local ancient = SafeFind(MapFolder, "PrehistoricIsland") or SafeFind(MapFolder, "AncientIsland")
    if ancient and ancient.PrimaryPart then
         table.insert(detected, {name="Prehistoric Island", pos=ancient.PrimaryPart.Position, color=Color3.fromRGB(100, 255, 100)})
    end

    return detected
end

local function ScanLighting()
    local detected = {}
    local Sky = Services.Lighting:FindFirstChildOfClass("Sky")
    local MoonID = Sky and tostring(Sky.MoonTextureId) or ""

    if string.find(MoonID, "9709149431") then
        table.insert(detected, {name="Full Moon (100%)", pos=nil})
    elseif string.find(MoonID, "9709149052") then
        table.insert(detected, {name="Full Moon (75%)", pos=nil})
    end

    if string.find(MoonID, "15306698696") then
        local MapFolder = Services.Workspace:FindFirstChild("Map")
        local WorldOrigin = Services.Workspace:FindFirstChild("_WorldOrigin")
        local Locations = WorldOrigin and WorldOrigin:FindFirstChild("Locations")

        local shrine = SafeFind(MapFolder, "Kitsune Island") or SafeFind(Locations, "Kitsune Island")
        if shrine and shrine.PrimaryPart then
             table.insert(detected, {name="Kitsune Shrine", pos=shrine.PrimaryPart.Position, color=Color3.fromRGB(80, 80, 255)})
             CreateESP(shrine.PrimaryPart, "Kitsune Shrine", Color3.fromRGB(80, 80, 255))
        else
             table.insert(detected, {name="Kitsune Moon (Phase Active)", pos=nil})
        end
    end

    return detected
end

local function ScanEntities()
    local detected = {}
    local Enemies = Services.Workspace:FindFirstChild("Enemies") or Services.Workspace:FindFirstChild("Characters")
    if not Enemies then return {} end

    for _, v in pairs(Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if table.find({"Diablo", "Deandre", "Urban"}, v.Name) then
                table.insert(detected, {name="Elite Hunter: "..v.Name, pos=v.HumanoidRootPart.Position, color=Color3.fromRGB(255, 50, 50)})
                CreateESP(v.HumanoidRootPart, "Elite: "..v.Name, Color3.fromRGB(255, 50, 50))
            end
            
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
-- // [5] MODERNIZED GUI //
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
    Frame.Size = UDim2.new(0, 320, 0, 120)
    Frame.Position = UDim2.new(0.5, -160, 0, 20)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Frame.BorderSizePixel = 0
    Frame.Parent = Screen
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = Frame
    
    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Color3.fromRGB(255, 215, 0)
    FrameStroke.Thickness = 1.5
    FrameStroke.Parent = Frame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    TopBar.Parent = Frame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 8)
    TopBarCover.Position = UDim2.new(0, 0, 1, -8)
    TopBarCover.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Event Tracker [GOD MODE]"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(0, 0, 0)
    Title.TextSize = 14
    Title.Parent = TopBar

    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 1, -60)
    StatusLabel.Position = UDim2.new(0, 0, 0, 30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "INITIALIZING..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 15
    StatusLabel.Parent = Frame

    local Bottom = Instance.new("TextLabel")
    Bottom.Size = UDim2.new(1, 0, 0, 20)
    Bottom.Position = UDim2.new(0, 0, 1, -25)
    Bottom.BackgroundTransparency = 1
    Bottom.Text = "MADE BY DEVANSH"
    Bottom.Font = Enum.Font.Code
    Bottom.TextColor3 = Color3.fromRGB(150, 150, 150)
    Bottom.TextSize = 12
    Bottom.Parent = Frame
    
    local Drag = Instance.new("UIDragDetector")
    Drag.Parent = Frame
end

--------------------------------------------------------------------------------
-- // [6] ADVANCED WEBHOOK COMPILER //
--------------------------------------------------------------------------------
local function SendWebhook(events)
    local Config = getgenv().DevanshConfig
    
    local eventNames = {}
    local tweenCode = ""

    for _, e in ipairs(events) do
        table.insert(eventNames, e.name)
        if e.pos then
            local X, Y, Z = math.floor(e.pos.X), math.floor(e.pos.Y), math.floor(e.pos.Z)
            tweenCode = tweenCode .. string.format("\n-- TARGET: %s\nloadstring([[local T=Vector3.new(%d,%d,%d);local P=game.Players.LocalPlayer.Character.HumanoidRootPart;local TS=game:GetService('TweenService');TS:Create(P,TweenInfo.new(2),{CFrame=CFrame.new(P.Position.X,400,P.Position.Z)}):Play();task.wait(2.1);TS:Create(P,TweenInfo.new((P.Position-T).Magnitude/300),{CFrame=CFrame.new(T.X,400,T.Z)}):Play()]])()", e.name, X, Y, Z)
        end
    end
    
    if #tweenCode > 1000 then
        tweenCode = string.sub(tweenCode, 1, 950) .. "\n-- [CODE TRUNCATED DUE TO DISCORD LIMITS]"
    end
    
    local EventsString = table.concat(eventNames, ", ")

    local clockTime = Services.Lighting.ClockTime
    local hours = math.floor(clockTime)
    local minutes = math.floor((clockTime - hours) * 60)
    local ampm = hours >= 12 and "PM" or "AM"
    hours = hours % 12
    if hours == 0 then hours = 12 end
    local GameTime = string.format("%02d:%02d %s", hours, minutes, ampm)

    local TimestampVariable = os.time() + (15 * 60)
    local JoinLink = string.format("[Direct Join 🚀](https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s)", game.PlaceId, game.JobId)
    local JoinScript = string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", game.PlaceId, game.JobId)

    local fields = {
        {
            name = "🏝️ Event Found",
            value = EventsString ~= "" and EventsString or "Unknown Event",
            inline = false
        },
        {
            name = "⏰ Game Time",
            value = GameTime,
            inline = true
        },
        {
            name = "⏳ Ends In",
            value = "<t:" .. tostring(TimestampVariable) .. ":R>",
            inline = true
        },
        {
            name = "🔗 Direct Join Link",
            value = JoinLink,
            inline = false
        },
        {
            name = "📜 Server Join Script",
            value = "```lua\n" .. JoinScript .. "\n```",
            inline = false
        }
    }
    
    if tweenCode ~= "" then
        table.insert(fields, {
            name = "✈️ Auto-Fly Tween Script",
            value = "```lua" .. tweenCode .. "\n```",
            inline = false
        })
    end

    local Payload = {
        username = "Devansh Event-Tracker",
        avatar_url = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401452994632/ezgif-68d035637d1d997c.gif",
        content = "@everyone EVENT DETECTED IN SERVER",
        embeds = {{
            title = "🚨 TARGETS ACQUIRED",
            color = 16771584,
            thumbnail = {url = "https://cdn.discordapp.com/attachments/1347568075146268763/1469240401037754389/ezgif-2381261b040e0649.gif"},
            fields = fields,
            footer = {text = "Made by Devansh | God Mode v15.1"},
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
-- // [7] HEURISTIC SERVER HOP //
--------------------------------------------------------------------------------
local isTeleporting = false

Services.Teleport.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player == LocalPlayer then
        task.wait(1) 
        isTeleporting = false
        Services.GuiService:ClearError()
        UpdateStatus("RESTRICTED (773) - COOLDOWN", Color3.fromRGB(255, 50, 50))
    end
end)

local function ShuffleArray(array)
    for i = #array, 2, -1 do
        local j = math.random(1, i)
        array[i], array[j] = array[j], array[i]
    end
    return array
end

local function Hop()
    UpdateStatus("HOPPING SERVERS...", Color3.fromRGB(255, 100, 100))
    
    if QueueTeleport and getgenv().DevanshConfig.AutoScript ~= "" then
        QueueTeleport('task.wait(3); loadstring(game:HttpGet("'..getgenv().DevanshConfig.AutoScript..'"))()')
    end

    task.spawn(function()
        local Cursor = ""
        while true do
            local URL = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"
            if Cursor ~= "" then URL = URL.."&cursor="..Cursor end
            
            local Success, Body = pcall(function() 
                return Services.Http:JSONDecode(game:HttpGet(URL)) 
            end)

            if Success and Body and Body.data then
                local servers = ShuffleArray(Body.data)
                
                for _, s in ipairs(servers) do
                    if s.playing and s.playing >= getgenv().DevanshConfig.MinPlayers and s.playing <= getgenv().DevanshConfig.MaxPlayers and s.id ~= game.JobId then
                        
                        if type(s.ping) == "number" and s.ping < 400 then
                            UpdateStatus("JOINING: " .. s.playing .. " PLRS", Color3.fromRGB(0, 255, 0))
                            
                            isTeleporting = true
                            pcall(function()
                                Services.Teleport:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                            end)
                            
                            local timeout = 0
                            while isTeleporting and timeout < 8 do
                                task.wait(1)
                                timeout = timeout + 1
                            end
                            
                            if isTeleporting then
                                isTeleporting = false 
                            end
                            
                            task.wait(1.5)
                        end
                    end
                end
                if Body.nextPageCursor then Cursor = Body.nextPageCursor else Cursor = "" end
            end
            task.wait(0.5) 
        end
    end)
end

--------------------------------------------------------------------------------
-- // [8] INITIALIZATION LOGIC //
--------------------------------------------------------------------------------
task.spawn(function()
    BuildGUI()
    if not game:IsLoaded() then game.Loaded:Wait() end
    UpdateStatus("SCANNING (GOD MODE)...", Color3.fromRGB(255, 255, 255))
    task.wait(2)

    local Stack = {}

    local World = ScanWorld()
    local Lighting = ScanLighting()
    local Entities = ScanEntities()

    for _, v in pairs(World) do table.insert(Stack, v) end
    for _, v in pairs(Lighting) do table.insert(Stack, v) end
    for _, v in pairs(Entities) do table.insert(Stack, v) end

    if #Stack > 0 then
        UpdateStatus("EVENTS FOUND: " .. #Stack, Color3.fromRGB(0, 255, 0))
        SendWebhook(Stack)
        task.wait(8)
        UpdateStatus("RESUMING SEARCH...", Color3.fromRGB(255, 150, 0))
        Hop()
    else
        UpdateStatus("NO EVENTS - HOPPING", Color3.fromRGB(150, 150, 150))
        task.wait(1)
        Hop()
    end
end)
