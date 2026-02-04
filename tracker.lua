-- [[ 🚀 GOD MODE V16: STABILITY EDITION 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH | STATUS: DEBUG MODE ]] --
print(">> INJECTING GOD MODE V16... <<")

---------------------------------------------------------------------------------------------------
-- [1] CONFIGURATION
---------------------------------------------------------------------------------------------------
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    BotName = "Termux Tracker V16",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png",
    PingRole = "@everyone",
    MinConfidence = 90, 
    HoldConfidence = 75,
    ScanDelay = 0.2,
    HoldTime = 5,         
}

---------------------------------------------------------------------------------------------------
-- [2] SERVICES & SAFETY
---------------------------------------------------------------------------------------------------
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Safe GUI Parenting (Fixes "Doesn't Load" on Mobile/Synapse/KRNL)
local function GetGuiParent()
    local success, parent = pcall(function()
        if gethui then return gethui() end
        return game:GetService("CoreGui")
    end)
    if success and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui") -- Fallback for reliability
end

---------------------------------------------------------------------------------------------------
-- [3] GUI SYSTEM (TERMUX STYLE)
---------------------------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshV16_Debug"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GetGuiParent()

print(">> GUI PARENTED TO: " .. tostring(ScreenGui.Parent))

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Terminal"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BorderSizePixel = 0
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TerminalTitle = Instance.new("TextLabel")
TerminalTitle.Parent = Header
TerminalTitle.BackgroundTransparency = 1
TerminalTitle.Position = UDim2.new(0, 10, 0, 0)
TerminalTitle.Size = UDim2.new(1, -20, 1, 0)
TerminalTitle.Font = Enum.Font.Code
TerminalTitle.Text = "root@devansh:~# ./v16_stable.sh"
TerminalTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
TerminalTitle.TextSize = 11
TerminalTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Console
local ConsoleArea = Instance.new("ScrollingFrame")
ConsoleArea.Parent = MainFrame
ConsoleArea.BackgroundTransparency = 1
ConsoleArea.Position = UDim2.new(0, 10, 0, 35)
ConsoleArea.Size = UDim2.new(1, -20, 1, -55)
ConsoleArea.ScrollBarThickness = 2

local LogLabel = Instance.new("TextLabel")
LogLabel.Parent = ConsoleArea
LogLabel.BackgroundTransparency = 1
LogLabel.Size = UDim2.new(1, 0, 0, 0)
LogLabel.AutomaticSize = Enum.AutomaticSize.Y
LogLabel.Font = Enum.Font.Code
LogLabel.Text = "" 
LogLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
LogLabel.TextSize = 10
LogLabel.TextXAlignment = Enum.TextXAlignment.Left
LogLabel.TextYAlignment = Enum.TextYAlignment.Top
LogLabel.TextWrapped = true
LogLabel.RichText = true

-- Footer
local FooterText = Instance.new("TextLabel")
FooterText.Parent = MainFrame
FooterText.BackgroundTransparency = 1
FooterText.Position = UDim2.new(0, 10, 1, -20)
FooterText.Size = UDim2.new(1, -20, 0, 20)
FooterText.Font = Enum.Font.Code
FooterText.Text = "SYSTEM: ONLINE | WAITING FOR TARGETS..."
FooterText.TextColor3 = Color3.fromRGB(100, 100, 100)
FooterText.TextSize = 9
FooterText.TextXAlignment = Enum.TextXAlignment.Left

-- UI Stroke (Wrapped in pcall for mobile safety)
pcall(function()
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Thickness = 1.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(0, 255, 100)
    
    task.spawn(function()
        local t = 0
        while MainFrame.Parent do
            t = t + 0.005
            UIStroke.Color = Color3.fromHSV(t % 1, 1, 1)
            RunService.Heartbeat:Wait()
        end
    end)
end)

---------------------------------------------------------------------------------------------------
-- [4] LOGIC ENGINE
---------------------------------------------------------------------------------------------------
local State = { EventStack = {}, IsHolding = false, StartTime = os.clock() }

local function Log(text, type)
    local prefix = "<font color='#555555'>[INFO]</font>"
    local color = "#00FF00"
    
    if type == "SUCCESS" then prefix = "<font color='#00FF00'>[OKAY]</font>"; color = "#FFFFFF"
    elseif type == "WARN" then prefix = "<font color='#FFAA00'>[WARN]</font>"; color = "#FFAA00"
    elseif type == "FAIL" then prefix = "<font color='#FF0000'>[FAIL]</font>"; color = "#FF5555"
    elseif type == "CMD" then prefix = "<font color='#00FFFF'>[root]</font>"; color = "#00FFFF" end
    
    local newLine = string.format("%s <font color='%s'>%s</font>", prefix, color, text)
    if LogLabel then 
        LogLabel.Text = LogLabel.Text .. "\n" .. newLine 
        ConsoleArea.CanvasPosition = Vector2.new(0, 9999)
    end
end

local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

local function GetTimeData()
    local t = Lighting.ClockTime
    local isActive = (t >= 18 or t < 5.5)
    local status = isActive and "ACTIVE" or "EXPIRED"
    local color = isActive and 65280 or 16711680
    
    local secondsLeft = 0
    if isActive then
        if t >= 18 then secondsLeft = (24 - t + 5.5) * 60 
        else secondsLeft = (5.5 - t) * 60 end
    end
    
    local timestamp = os.time() + math.floor(secondsLeft)
    local discordTime = string.format("<t:%d:R>", timestamp)
    
    return status, color, discordTime, t
end

-- 🦖 PREHISTORIC SCANNER (Model Name 100%)
local function ScanPrehistoric()
    Log("Checking Prehistoric...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland") end) then
        score = 100
        local m = Workspace.Map:FindFirstChild("PrehistoricIsland") or Workspace.Map:FindFirstChild("AncientIsland")
        pos = m.Position
        table.insert(evidence, "Ancient Model Found")
        Log(" > Target: Ancient Island", "SUCCESS")
    end

    if Lighting.FogColor == Color3.fromRGB(40, 60, 40) then
        score = score + 40
        table.insert(evidence, "Primordial Atmosphere")
    end

    return {name="💎🦖 PREHISTORIC ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🏝️ MIRAGE SCANNER (Model Name 100%)
local function ScanMirage()
    Log("Checking Mirage...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100
        table.insert(evidence, "Model ID Match")
        pos = Workspace.Map.MysticIsland.Position
        Log(" > Target: Mystic Island", "SUCCESS")
    end
    
    -- Triangulation
    local cluster = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pp = p.Character.HumanoidRootPart.Position
            if pp.Magnitude > 8000 and pp.Y > 200 then table.insert(cluster, pp) end
        end
    end
    if #cluster >= 3 then
        local sum = Vector3.zero
        for _, v in pairs(cluster) do sum = sum + v end
        score = score + 60
        table.insert(evidence, "Triangulation Vector")
        if not pos then pos = sum / #cluster end
    end

    return {name="💎🏝️ MIRAGE ISLAND", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- 🦊 KITSUNE SCANNER (Texture ID 100%)
local function ScanKitsune()
    Log("Checking Kitsune...", "CMD")
    local score = 0
    local evidence = {}
    local pos = nil

    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then
        score = 100
        table.insert(evidence, "Texture ID: 15306698696")
        Log(" > Target: Kitsune Texture", "SUCCESS")
    end
    
    if SafeCheck(function() return Workspace.Map:FindFirstChild("KitsuneShrine") end) then
        score = 100
        table.insert(evidence, "Shrine Model")
        pos = Workspace.Map.KitsuneShrine.Position
    end

    return {name="💎🦊 KITSUNE SHRINE", score=score, reason=table.concat(evidence, ", "), pos=pos}
end

-- ❄️ FROZEN SCANNER (Model Name 100%)
local function ScanFrozen()
    Log("Checking Frozen...", "CMD")
    if SafeCheck(function() return Workspace.Map:FindFirstChild("FrozenDimension") or Workspace.Map:FindFirstChild("Frozen Island") end) then
        local p = nil
        if Workspace.Map:FindFirstChild("FrozenDimension") then p = Workspace.Map.FrozenDimension.Position end
        Log(" > Target: Dimension Gate", "SUCCESS")
        return {name="💎❄️ FROZEN DIMENSION", score=100, reason="Dimension Gate", pos=p}
    end
    return {score=0}
end

-- 🌕 MOON SCANNER (Texture ID 100%)
local function ScanMoon()
    Log("Checking Celestial...", "CMD")
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then 
        Log(" > Target: Full Moon", "SUCCESS")
        return {name="💎🌕 FULL MOON", score=100, reason="Texture ID: 9709149431", pos=nil}
    end
    if Lighting:GetAttribute("IsFullMoon") then 
        return {name="💎🌕 FULL MOON", score=100, reason="Server Attribute", pos=nil}
    end
    return {score=0}
end

local function SendWebhook()
    local status, color, discordTime, clockTime = GetTimeData()

    if status == "EXPIRED" then
        Log("Event EXPIRED. Aborting.", "FAIL")
        return 
    end

    Log("Sending Webhook...", "SUCCESS")
    local fields = {}
    for _, e in pairs(State.EventStack) do
        table.insert(fields, {["name"] = e.name, ["value"] = "**Proof:** " .. e.reason .. "\n**Conf:** " .. e.score .. "%", ["inline"] = false})
    end
    table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = "🟢 ACTIVE\n**Ends:** " .. discordTime .. "\n**Clock:** " .. string.format("%.1f", clockTime), ["inline"] = false})

    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 1. JOIN SCRIPT", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    for _, e in pairs(State.EventStack) do
        if e.pos then
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y + 250) .. "," .. math.floor(e.pos.Z)
            local ts = string.format([[
local P = game.Players.LocalPlayer.Character.HumanoidRootPart
local T = CFrame.new(%s)
local B = Instance.new("BodyVelocity", P); B.Velocity=Vector3.zero; B.MaxForce=Vector3.one*9e9
local Tw = game:GetService("TweenService"):Create(P, TweenInfo.new((P.Position-T.Position).Magnitude/350), {CFrame=T})
Tw:Play(); Tw.Completed:Wait(); B:Destroy()
]], vec)
            table.insert(fields, {["name"] = "✈️ 2. TP TO " .. e.name, ["value"] = "```lua\n" .. ts .. "\n```", ["inline"] = false})
        end
    end

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🌟 Event Detected",
            ["color"] = color,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh | Termux V16 Stable"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    SafeCheck(function()
        local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
        if req then req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end
    end)
    Log("Payload Sent.", "SUCCESS")
end

local function Hop()
    Log("Hopping...", "WARN")
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local s, body = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) end)
    if s and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then table.insert(AllIDs, v.id) end
        end
    end
    if #AllIDs > 0 then TeleportService:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else task.wait(1); Hop() end
end

-- MAIN ORCHESTRATOR
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    Log("Kernel Loaded. Scanning...", "CMD")
    task.wait(0.2)

    local results = {}
    table.insert(results, ScanMirage())
    table.insert(results, ScanKitsune())
    table.insert(results, ScanMoon())
    table.insert(results, ScanFrozen())
    table.insert(results, ScanPrehistoric())

    local highest = 0
    State.EventStack = {} 

    for _, res in pairs(results) do
        if res.score > highest then highest = res.score end
        if res.score >= CONFIG.HoldConfidence then table.insert(State.EventStack, res) end
    end

    if highest >= CONFIG.MinConfidence then
        SendWebhook()
        task.wait(2)
        Hop()
    elseif highest >= CONFIG.HoldConfidence then
        if not State.IsHolding then
            Log("Unsure ("..highest.."%). Holding...", "WARN")
            State.IsHolding = true
            task.wait(CONFIG.HoldTime)
            init()
        else
            Hop()
        end
    else
        Log("No Targets. Hopping.", "CMD")
        Hop()
    end
end

-- SAFE LAUNCH
task.spawn(init)
