-- [[ 🚀 GOD MODE: CORRELATION AI + TWEEN EDITION 🚀 ]] --
-- [[ Made by Devansh ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    -- 🔴 YOUR WEBHOOK
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    
    BotName = "Event Tracker",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6981aee9&is=69805d69&hm=6e7a2e5223622533f20babf6c49f718c1769683df15a9276fdd7da76fc8748db&",
    
    ScanDelay = {2, 3},     
    SafeSlots = 1,          
    PingThreshold = 90,     -- ONLY Ping if Confidence Score >= 75%
    BlacklistTime = 3600    
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🎨 GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local StatusLabel = Instance.new("TextLabel")
local ConfidenceLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DevanshCorrelationAI"
ScreenGui.Parent = CoreGui
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18) 
MainFrame.Position = UDim2.new(1, -260, 1, -120) 
MainFrame.Size = UDim2.new(0, 240, 0, 70)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- Cyan

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 5)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.Text = "🧠 AI CORRELATING..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 16

ConfidenceLabel.Name = "Conf"
ConfidenceLabel.Parent = MainFrame
ConfidenceLabel.BackgroundTransparency = 1
ConfidenceLabel.Position = UDim2.new(0, 0, 0, 35)
ConfidenceLabel.Size = UDim2.new(1, 0, 0, 20)
ConfidenceLabel.Font = Enum.Font.Code
ConfidenceLabel.Text = "Confidence: 0%"
ConfidenceLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
ConfidenceLabel.TextSize = 12

-- 📂 UTILS
local FileName = "BloxTrackerStats.json"
local currentStats = { Blacklist = {} }
if isfile and isfile(FileName) then pcall(function() currentStats = HttpService:JSONDecode(readfile(FileName)) end) end
local function saveStats() if writefile then writefile(FileName, HttpService:JSONEncode(currentStats)) end end

local function safeRequest(url, method, body)
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then pcall(function() req({Url = url, Method = method, Headers = {["Content-Type"] = "application/json"}, Body = body}) end) end
end

local function getServerAge() return workspace.DistributedGameTime end
local function formatAge(seconds)
    local m = math.floor(seconds / 60)
    return string.format("%dh %02dm", math.floor(m / 60), m % 60)
end

-- 🛡️ FRIEND CHECKER
local function checkForFriends()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p:IsFriendsWith(LocalPlayer.UserId) then return true end
    end
    return false
end

-- 🧠 THE TRIANGULATION ENGINE (Math AI)
local function triangulateIsland()
    local hoverPlayers = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            -- Logic: Players far out (10k studs) and high up (150 studs) are likely on an invisible island
            if pos.Magnitude > 8000 and pos.Y > 150 then table.insert(hoverPlayers, pos) end
        end
    end
    if #hoverPlayers >= 3 then
        local sx, sy, sz = 0, 0, 0
        for _, v in pairs(hoverPlayers) do sx=sx+v.X; sy=sy+v.Y; sz=sz+v.Z end
        return Vector3.new(sx/#hoverPlayers, sy/#hoverPlayers, sz/#hoverPlayers)
    end
    return nil
end

-- 🕵️ THE CORRELATION ENGINES (Scoring System)

-- 🌕 FULL MOON
local function analyzeFullMoon()
    local score = 0
    local evidence = {}
    local sky = Lighting:FindFirstChild("Sky")
    
    -- PRIMARY (100 pts) - Absolute Proof
    if sky and (sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" or sky.MoonTextureId == "rbxassetid://9709149431") then
        score = score + 100; table.insert(evidence, "Texture ID (Primary)")
    end
    
    -- SECONDARY (50 pts) - Strong Indicator
    if Lighting:GetAttribute("IsFullMoon") then
        score = score + 50; table.insert(evidence, "Attribute (Secondary)")
    end
    
    -- TERTIARY (15 pts) - Weak Indicator (Prone to False Positives)
    if Lighting.Brightness > 1.2 and Lighting.ClockTime < 5 then
        score = score + 15; table.insert(evidence, "Light Spike (Tertiary)")
    end
    
    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", ") end
    return false
end

-- 🏝️ MIRAGE ISLAND
local function analyzeMirage()
    local score = 0
    local evidence = {}
    local pos = nil
    
    -- PRIMARY (100 pts)
    if Workspace.Map:FindFirstChild("MysticIsland") then
        score = score + 100; table.insert(evidence, "Model Found (Primary)"); pos = Workspace.Map.MysticIsland.Position
    end
    
    -- SECONDARY (50 pts)
    local triPos = triangulateIsland()
    if triPos then
        score = score + 50; table.insert(evidence, "Triangulation AI (Secondary)"); if not pos then pos = triPos end
    end
    
    -- SECONDARY (40 pts) - Fog is decent but can be weather
    if Lighting.FogEnd < 500 then
        score = score + 40; table.insert(evidence, "Fog Blindness (Secondary)")
    end
    
    -- PRIMARY (100 pts) - Dealer only exists on Mirage
    if Workspace:FindFirstChild("AdvancedFruitDealer", true) then
        score = score + 100; table.insert(evidence, "Dealer NPC (Primary)")
    end

    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", "), pos end
    return false
end

-- 🦊 KITSUNE ISLAND
local function analyzeKitsune()
    local score = 0
    local evidence = {}
    local pos = nil
    
    -- PRIMARY (100 pts)
    if Workspace.Map:FindFirstChild("KitsuneShrine") then
        score = score + 100; table.insert(evidence, "Shrine Found (Primary)"); pos = Workspace.Map.KitsuneShrine.Position
    end
    
    -- SECONDARY (60 pts) - Blue Moon Texture is very rare
    local sky = Lighting:FindFirstChild("Sky")
    if sky and (sky.MoonTextureId == "http://www.roblox.com/asset/?id=15306698696" or sky.MoonTextureId == "rbxassetid://15306698696") then
        score = score + 60; table.insert(evidence, "Blue Moon Texture (Secondary)")
    end
    
    -- SECONDARY (50 pts) - Particles
    if Workspace:FindFirstChild("AzureEmber", true) then
        score = score + 50; table.insert(evidence, "Azure Particle (Secondary)")
    end
    
    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", "), pos end
    return false
end

-- ❄️ FROZEN DIMENSION
local function analyzeFrozen()
    local score = 0
    local evidence = {}
    local pos = nil
    
    -- PRIMARY (100 pts)
    if Workspace.Map:FindFirstChild("FrozenDimension") then
        score = score + 100; table.insert(evidence, "Gate Found (Primary)"); pos = Workspace.Map.FrozenDimension.Position
    end
    if Workspace.Map:FindFirstChild("Frozen Island") then
        score = score + 100; table.insert(evidence, "Island Found (Primary)"); pos = Workspace.Map["Frozen Island"].Position
    end
    
    -- TERTIARY (20 pts) - Blizzard
    if Lighting:FindFirstChild("BlizzardParticles", true) then
        score = score + 20; table.insert(evidence, "Blizzard FX (Tertiary)")
    end

    if score >= CONFIG.PingThreshold then return true, score, table.concat(evidence, ", "), pos end
    return false
end

-- 📨 WEBHOOK + TWEEN GENERATOR
local function sendWebhook(events)
    MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    StatusLabel.Text = "💎 JACKPOT FOUND!"
    
    local jobId = game.JobId
    local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance('..game.PlaceId..', "'..jobId..'", game.Players.LocalPlayer)'
    
    local fields = {}
    for _, e in pairs(events) do
        table.insert(fields, {["name"] = "💎 " .. e.name, ["value"] = "**Confidence:** " .. e.score .. "%\n**Evidence:** " .. e.reason, ["inline"] = false})
    end
    table.insert(fields, {["name"] = "📜 1. JOIN SERVER", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})
    
    local c = 2
    for _, e in pairs(events) do
        if e.pos then
            -- ✈️ TWEEN FLY SCRIPT (Requested Fix)
            local targetY = math.floor(e.pos.Y + 300) -- Fly high
            local tweenScript = [[
local TS = game:GetService("TweenService")
local P = game.Players.LocalPlayer
local R = P.Character:FindFirstChild("HumanoidRootPart")
if R then
    local T = CFrame.new(]]..math.floor(e.pos.X)..[[, ]]..targetY..[[, ]]..math.floor(e.pos.Z)..[[)
    local TI = TweenInfo.new((R.Position-T.Position).Magnitude/350, Enum.EasingStyle.Linear)
    local TW = TS:Create(R, TI, {CFrame=T})
    local BV = Instance.new("BodyVelocity", R); BV.Velocity=Vector3.zero; BV.MaxForce=Vector3.one*9e9
    TW:Play(); TW.Completed:Wait(); BV:Destroy()
end
]]
            table.insert(fields, {["name"] = "✈️ " .. c .. ". TWEEN TO " .. e.name, ["value"] = "```lua\n" .. tweenScript .. "\n```", ["inline"] = false})
            c = c + 1
        end
    end
    table.insert(fields, {["name"] = "🌍 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false})

    local payload = {
        ["username"] = CONFIG.BotName,
        ["avatar_url"] = CONFIG.BotAvatar,
        ["content"] = "@everyone",
        ["embeds"] = {{
            ["title"] = "🌟 CONFIRMED EVENT FOUND",
            ["color"] = 16766720,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Devansh Correlation AI"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    safeRequest(CONFIG.WebhookURL, "POST", HttpService:JSONEncode(payload))
end

-- 🐇 HOPPER
local function hop()
    StatusLabel.Text = "🔄 HOPPING..."
    ConfidenceLabel.Text = "Resetting AI..."
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local s, r = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    if s and r and r.data then
        local valid = {}
        for _, v in pairs(r.data) do
            local bl = false
            for _, b in pairs(currentStats.Blacklist) do if b.id == v.id then bl = true break end end
            if not bl and v.playing < (v.maxPlayers - CONFIG.SafeSlots) and v.id ~= game.JobId then table.insert(valid, v) end
        end
        if #valid > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, valid[math.random(1, #valid)].id)
            return
        end
    end
    task.wait(1.5)
    hop()
end

-- 🚀 INIT
local function init()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    if checkForFriends() then
        table.insert(currentStats.Blacklist, {id = game.JobId, time = os.time()})
        saveStats()
        hop()
        return
    end
    
    task.wait(math.random(CONFIG.ScanDelay[1], CONFIG.ScanDelay[2]))
    
    local events = {}
    
    -- RUNNING THE AI ENGINES
    local fm, fmScore, fmReason = analyzeFullMoon()
    if fm then table.insert(events, {name = "🌕 FULL MOON", score = fmScore, reason = fmReason}) end
    
    local mir, mirScore, mirReason, mirPos = analyzeMirage()
    if mir then table.insert(events, {name = "🏝️ MIRAGE", score = mirScore, reason = mirReason, pos = mirPos}) end
    
    local kit, kitScore, kitReason, kitPos = analyzeKitsune()
    if kit then table.insert(events, {name = "🦊 KITSUNE", score = kitScore, reason = kitReason, pos = kitPos}) end
    
    local fro, froScore, froReason, froPos = analyzeFrozen()
    if fro then table.insert(events, {name = "❄️ LEVIATHAN", score = froScore, reason = froReason, pos = froPos}) end
    
    if #events > 0 then
        sendWebhook(events)
        task.wait(5)
        hop()
        return
    end
    
    hop()
end

init()
