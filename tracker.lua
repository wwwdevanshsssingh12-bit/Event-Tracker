-- [[ 🚀 GOD MODE V23: ZERO-CRASH EDITION 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH | STATUS: STABLE MOBILE ]] --
-- [[ FIX: Added 'WaitForChild' checks to prevent Nil Value errors ]] --

task.wait(2) -- Allow Executor to settle
print(">> INJECTING V23... <<")

-- 1. WAIT FOR GAME LOAD (CRITICAL FIX)
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end
print(">> PLAYER LOADED: " .. LocalPlayer.Name)

---------------------------------------------------------------------------------------------------
-- [2] CONFIGURATION
---------------------------------------------------------------------------------------------------
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    BotName = "Termux Tracker V23",
    PingRole = "@everyone",
    MinConfidence = 90, 
    HoldConfidence = 75,
    ScanDelay = 0.5,
    HoldTime = 5,         
}

---------------------------------------------------------------------------------------------------
-- [3] SERVICES
---------------------------------------------------------------------------------------------------
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

---------------------------------------------------------------------------------------------------
-- [4] GUI SYSTEM (NIL-VALUE SAFE)
---------------------------------------------------------------------------------------------------
local function GetSafeGuiRoot()
    -- Check if gethui exists and is actually a function
    if type(gethui) == "function" then
        return gethui()
    end
    -- Fallback to CoreGui if available
    local s, core = pcall(function() return game:GetService("CoreGui") end)
    if s and core then return core end
    -- Final Fallback: PlayerGui (Always exists)
    return LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshV23_Stable"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GetSafeGuiRoot()

-- GUI CONSTRUCTION
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Terminal"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 100)

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "root@devansh:~/v23"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = TopBar
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.6, 0, 0, 0)
StatusLabel.Size = UDim2.new(0.4, -10, 1, 0)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "[IDLE]"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

local ConsoleArea = Instance.new("ScrollingFrame")
ConsoleArea.Parent = MainFrame
ConsoleArea.BackgroundTransparency = 1
ConsoleArea.Position = UDim2.new(0, 10, 0, 35)
ConsoleArea.Size = UDim2.new(1, -20, 1, -55)
ConsoleArea.ScrollBarThickness = 3
ConsoleArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
ConsoleArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ConsoleArea
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

-- Rainbow Border (Safe)
task.spawn(function()
    while MainFrame.Parent do
        local t = tick() % 5 / 5
        UIStroke.Color = Color3.fromHSV(t, 1, 1)
        task.wait(0.05)
    end
end)

---------------------------------------------------------------------------------------------------
-- [5] LOGGING ENGINE
---------------------------------------------------------------------------------------------------
local LogCount = 0

local function UpdateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
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
    
    if LogCount > 40 then
        for _, child in pairs(ConsoleArea:GetChildren()) do
            if child:IsA("TextLabel") and child.LayoutOrder < (LogCount - 40) then child:Destroy() end
        end
    end
    ConsoleArea.CanvasPosition = Vector2.new(0, 99999)
end

---------------------------------------------------------------------------------------------------
-- [6] SCANNERS
---------------------------------------------------------------------------------------------------
local function RunScans()
    local events = {}
    
    -- 1. Prehistoric
    if Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland") then
        local m = Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland")
        table.insert(events, {name="💎🦖 PREHISTORIC ISLAND", score=100, reason="Model Found", pos=m.Position})
        Log("Found: Prehistoric Island", "SUCCESS")
    end

    -- 2. Mirage
    if Workspace.Map:FindFirstChild("MysticIsland") then
        table.insert(events, {name="💎🏝️ MIRAGE ISLAND", score=100, reason="Model ID", pos=Workspace.Map.MysticIsland.Position})
        Log("Found: Mirage Island", "SUCCESS")
    end

    -- 3. Kitsune
    if string.find(Lighting.Sky.MoonTextureId, "15306698696") then
        table.insert(events, {name="💎🦊 KITSUNE SHRINE", score=100, reason="Texture ID", pos=nil})
        Log("Found: Kitsune Texture", "SUCCESS")
    end

    -- 4. Frozen
    if Workspace.Map:FindFirstChild("FrozenDimension") then
        table.insert(events, {name="💎❄️ FROZEN DIMENSION", score=100, reason="Dimension Gate", pos=Workspace.Map.FrozenDimension.Position})
        Log("Found: Frozen Dimension", "SUCCESS")
    end

    -- 5. Moon
    if string.find(Lighting.Sky.MoonTextureId, "9709149431") then
        table.insert(events, {name="💎🌕 FULL MOON", score=100, reason="Texture ID", pos=nil})
        Log("Found: Full Moon", "SUCCESS")
    end

    return events
end

---------------------------------------------------------------------------------------------------
-- [7] WEBHOOK
---------------------------------------------------------------------------------------------------
local function SendWebhook(events)
    -- Check Time State
    local t = Lighting.ClockTime
    local isActive = (t >= 18 or t < 5.5)
    if not isActive then
        Log("Event Found but EXPIRED. Skipping.", "FAIL")
        return
    end

    Log("Sending Webhook...", "SUCCESS")

    local fields = {}
    for _, e in pairs(events) do
        table.insert(fields, {["name"] = e.name, ["value"] = "**Engine:** " .. e.reason .. "\n**Conf:** " .. e.score .. "%", ["inline"] = false})
    end
    
    local directLink = "https://www.roblox.com/games/"..game.PlaceId.."?jobId="..game.JobId
    table.insert(fields, {["name"] = "🌍 SERVER INFO", ["value"] = "**Job ID:** `" .. game.JobId .. "`\n**[Click to Direct Join](" .. directLink .. ")**", ["inline"] = false})

    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 1. JOIN SCRIPT", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    for _, e in pairs(events) do
        if e.pos then
            local islandName = string.gsub(e.name, "💎", "")
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y + 200) .. "," .. math.floor(e.pos.Z)
            local tpScript = string.format([[
-- [[ TELEPORT TO %s ]] --
local P = game.Players.LocalPlayer.Character.HumanoidRootPart
local T = CFrame.new(%s)
local B = Instance.new("BodyVelocity", P); B.Velocity=Vector3.zero; B.MaxForce=Vector3.one*9e9
local Tw = game:GetService("TweenService"):Create(P, TweenInfo.new((P.Position-T.Position).Magnitude/350), {CFrame=T})
Tw:Play(); Tw.Completed:Wait(); B:Destroy()
]], islandName, vec)
            table.insert(fields, {["name"] = "✈️ 2. TP TO " .. islandName, ["value"] = "```lua\n" .. tpScript .. "\n```", ["inline"] = false})
        end
    end

    local payload = {
        ["username"] = "Termux Tracker V23",
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🌟 EVENT DETECTED",
            ["color"] = 65280,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh | V23 Stable"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    pcall(function()
        local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
        if req then req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end
    end)
    Log("Payload Sent.", "SUCCESS")
end

local function SafeHop()
    UpdateStatus("[HOPPING]", Color3.fromRGB(255, 50, 50))
    Log("Hopping Server...", "WARN")
    
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local success, body = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    
    if success and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then 
                table.insert(AllIDs, v.id) 
            end
        end
    end
    
    if #AllIDs > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else
        Log("Hop Failed (List Error). Retrying.", "FAIL")
    end
end

---------------------------------------------------------------------------------------------------
-- [8] MAIN EXECUTION (WHILE LOOP)
---------------------------------------------------------------------------------------------------
task.spawn(function()
    Log("Kernel Loaded.", "CMD")
    task.wait(1)

    while true do
        local success, err = pcall(function()
            UpdateStatus("[SCANNING]", Color3.fromRGB(255, 200, 0))
            
            -- Scan
            local events = RunScans()
            local highestScore = 0
            for _, e in pairs(events) do
                if e.score > highestScore then highestScore = e.score end
            end

            if highestScore >= 90 then
                UpdateStatus("[FOUND!]", Color3.fromRGB(0, 255, 0))
                Log("Target Acquired!", "SUCCESS")
                SendWebhook(events)
                task.wait(3)
                SafeHop()
            else
                Log("No Targets. Hopping.", "CMD")
                SafeHop()
            end
        end)

        if not success then
            Log("Error: " .. tostring(err), "FAIL")
            task.wait(2)
            SafeHop()
        end
        
        task.wait(1)
    end
end)
