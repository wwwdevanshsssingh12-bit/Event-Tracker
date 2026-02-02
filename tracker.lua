-- [[ 🚀 GOD MODE V8: VISUAL MATCH EDITION 🚀 ]] --
-- [[ REWRITTEN BY DEVANSH AI | STATUS: UNPATCHED ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    MinConfidence = 75,
    PingRole = "@everyone",
    BotName = "Event Tracker V8",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6981aee9&is=69805d69&hm=6e7a2e5223622533f20babf6c49f718c1769683df15a9276fdd7da76fc8748db&"
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 📊 DATA & STATE
local EventStack = {}
local StartTime = os.clock()

-- 🎨 GUI SETUP (COMPACT VISUAL MATCH)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevanshTrackerV8"
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

local MainContainer = Instance.new("Frame")
MainContainer.Name = "Container"
MainContainer.Parent = ScreenGui
MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Dark Background
MainContainer.BackgroundTransparency = 0.1
MainContainer.Position = UDim2.new(0, 20, 0.7, 0) -- Bottom Left positioning
MainContainer.Size = UDim2.new(0, 220, 0, 100)
MainContainer.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainContainer

-- Status Dot
local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.Parent = MainContainer
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 170, 0) -- Orange (Scanning)
StatusDot.Position = UDim2.new(0, 15, 0, 15)
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.BorderSizePixel = 0
local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

-- Title Text
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainContainer
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 35, 0, 10)
TitleLabel.Size = UDim2.new(1, -40, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Event Tracker"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Action Text
local ActionLabel = Instance.new("TextLabel")
ActionLabel.Parent = MainContainer
ActionLabel.BackgroundTransparency = 1
ActionLabel.Position = UDim2.new(0, 15, 0, 35)
ActionLabel.Size = UDim2.new(1, -30, 0, 20)
ActionLabel.Font = Enum.Font.Gotham
ActionLabel.Text = "Initializing..."
ActionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ActionLabel.TextSize = 12
ActionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Server Age
local AgeLabel = Instance.new("TextLabel")
AgeLabel.Parent = MainContainer
AgeLabel.BackgroundTransparency = 1
AgeLabel.Position = UDim2.new(0, 15, 0, 60)
AgeLabel.Size = UDim2.new(1, -30, 0, 20)
AgeLabel.Font = Enum.Font.Code
AgeLabel.Text = "Age: 00:00:00"
AgeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
AgeLabel.TextSize = 11
AgeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Parent = MainContainer
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0, 15, 1, -15)
Footer.Size = UDim2.new(1, -30, 0, 10)
Footer.Font = Enum.Font.Gotham
Footer.Text = "- made by devansh -"
Footer.TextColor3 = Color3.fromRGB(255, 100, 50) -- Orange accent
Footer.TextSize = 9
Footer.TextXAlignment = Enum.TextXAlignment.Left

-- 🌈 UI UPDATER
local function UpdateUI(status, color)
    ActionLabel.Text = status
    if color then StatusDot.BackgroundColor3 = color end
end

local function FormatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

task.spawn(function()
    while MainContainer.Parent do
        AgeLabel.Text = "Age: " .. FormatTime(Workspace.DistributedGameTime)
        task.wait(1)
    end
end)

-- 🛡️ UTILITIES
local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- ⏳ TIMEKEEPER
local function GetTimeState()
    local ct = Lighting.ClockTime
    if ct >= 18 or ct < 5.5 then
        return "🟢 ACTIVE", 65280, false
    else
        return "🔴 EXPIRED", 16711680, true
    end
end

-- 🕵️ SCANNERS
local function ScanMirage()
    local score = 0
    local evidence = {}
    local pos = nil
    
    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        score = 100; table.insert(evidence, "Direct Model"); pos = Workspace.Map.MysticIsland.Position
    end
    
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
        score = score + 60; table.insert(evidence, "Triangulation AI"); if not pos then pos = sum / #cluster end
    end
    
    if Lighting.FogEnd < 1000 then score = score + 40; table.insert(evidence, "Atmospheric Fog") end
    if SafeCheck(function() return Workspace:FindFirstChild("AdvancedFruitDealer", true) end) then score = score + 100; table.insert(evidence, "Advanced Dealer NPC") end

    if score >= CONFIG.MinConfidence then table.insert(EventStack, {name = "MIRAGE ISLAND", score = score, reason = table.concat(evidence, ", "), pos = pos}) end
end

local function ScanKitsune()
    local score = 0
    local evidence = {}
    local pos = nil
    
    if SafeCheck(function() return Workspace.Map:FindFirstChild("KitsuneShrine") end) then score = 100; table.insert(evidence, "Shrine Model"); pos = Workspace.Map.KitsuneShrine.Position end
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then score = score + 90; table.insert(evidence, "Blue Moon Texture") end
    if SafeCheck(function() return Workspace:FindFirstChild("AzureEmber", true) end) then score = score + 50; table.insert(evidence, "Azure Ember") end
    
    if score >= CONFIG.MinConfidence then table.insert(EventStack, {name = "KITSUNE SHRINE", score = score, reason = table.concat(evidence, ", "), pos = pos}) end
end

local function ScanMoon()
    local score = 0
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then score = 100 end
    if Lighting:GetAttribute("IsFullMoon") then score = score + 100 end
    if score >= CONFIG.MinConfidence then table.insert(EventStack, {name = "FULL MOON", score = score, reason = "Texture Match", pos = nil}) end
end

local function ScanFrozen()
    local score = 0
    local pos = nil
    if SafeCheck(function() return Workspace.Map:FindFirstChild("FrozenDimension") or Workspace.Map:FindFirstChild("Frozen Island") end) then
        score = 100
        if Workspace.Map:FindFirstChild("FrozenDimension") then pos = Workspace.Map.FrozenDimension.Position end
        table.insert(EventStack, {name = "FROZEN DIMENSION", score = score, reason = "Dimension Gate", pos = pos})
    end
end

-- 🐇 HOPPER
local function InstantHop()
    UpdateUI("Hopping...", Color3.fromRGB(255, 50, 50))
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local success, body = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    if success and body and body.data then
        for _, v in pairs(body.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then table.insert(AllIDs, v.id) end
        end
    end
    if #AllIDs > 0 then TeleportService:TeleportToPlaceInstance(PlaceID, AllIDs[math.random(1, #AllIDs)], LocalPlayer)
    else task.wait(1); InstantHop() end
end

-- 📨 REPORTING
local function SendReport()
    UpdateUI("Reporting...", Color3.fromRGB(50, 255, 50))
    local statusText, embedColor, isExpired = GetTimeState()
    if isExpired then embedColor = 16711680; statusText = "EXPIRED" end
    
    local fields = {}
    for _, e in pairs(EventStack) do
        table.insert(fields, {["name"] = "💎 " .. e.name, ["value"] = "**Engine:** " .. e.reason, ["inline"] = false})
    end
    table.insert(fields, {["name"] = "⏳ STATUS", ["value"] = "🔴 " .. statusText .. "\n**Ends:** Daytime", ["inline"] = false})
    
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 1. JOIN SERVER", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})
    
    for _, e in pairs(EventStack) do
        if e.pos then
            local vec = math.floor(e.pos.X) .. "," .. math.floor(e.pos.Y+200) .. "," .. math.floor(e.pos.Z)
            local ts = string.format("game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(%s)", vec)
            table.insert(fields, {["name"] = "🏝️ 2. TP TO " .. e.name, ["value"] = "```lua\n" .. ts .. "\n```", ["inline"] = false})
        end
    end
    table.insert(fields, {["name"] = "🔗 Direct Link", ["value"] = "[Click to Join](https://www.roblox.com/games/"..game.PlaceId.."?jobId="..game.JobId..")", ["inline"] = false})

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "☀️ GOD EVENT DETECTED",
            ["color"] = embedColor,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh Omniscient AI | God Mode | " .. os.date("%I:%M %p")},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then pcall(function() req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)}) end) end
end

-- 🚀 MAIN CYCLE
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    UpdateUI("Scanning...", Color3.fromRGB(255, 255, 0))
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p:IsFriendsWith(LocalPlayer.UserId) then InstantHop(); return end
    end
    
    task.spawn(ScanMirage)
    task.spawn(ScanKitsune)
    task.spawn(ScanMoon)
    task.spawn(ScanFrozen)
    task.wait(0.5)
    
    if #EventStack > 0 then
        SendReport()
        task.wait(1)
        InstantHop()
    else
        InstantHop()
    end
end

init()
