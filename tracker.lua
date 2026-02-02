-- [[ 🚀 GOD MODE V8: SPEED RUN EDITION 🚀 ]] --
-- [[ LEAD ENGINEER: GEMINI | STATUS: UNLIMITED SPEED ]] --

-- ⚙️ CONFIGURATION
local CONFIG = {
    WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1466002688880672839/5yvrOqQQ3V8JnZ8Z-whDl2lPk7h9Gxdg7-b_AqQqEVFpqnQklnhb7iaECTUq0Q5FVJ5Y",
    MinConfidence = 75,
    PingRole = "@everyone",
    BotName = "Event Tracker",
    BotAvatar = "https://cdn.discordapp.com/attachments/1347568075146268763/1467795854235799593/1769592894071.png?ex=6981aee9&is=69805d69&hm=6e7a2e5223622533f20babf6c49f718c1769683df15a9276fdd7da76fc8748db&"
}

-- 🔄 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 📊 DATA
local EventStack = {}
local StartTime = os.clock()

-- 🎨 MINIMAL STATUS GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local StatusLabel = Instance.new("TextLabel", ScreenGui)
StatusLabel.Size = UDim2.new(0, 300, 0, 50)
StatusLabel.Position = UDim2.new(0.5, -150, 0, 10)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow for Speed
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 20
StatusLabel.Text = "⚡ V8 SPEED RUN..."

local function SetStatus(text) 
    StatusLabel.Text = "[" .. string.format("%.2fs", os.clock() - StartTime) .. "] " .. text 
end

-- 🛡️ SAFETY WRAPPER
local function SafeCheck(func)
    local s, r = pcall(func)
    if s then return r end
    return false
end

-- ⏳ TIME STATE
local function GetTimeState()
    local ct = Lighting.ClockTime
    if ct >= 18 or ct < 5.5 then
        return "🟢 ACTIVE", 65280, false
    else
        return "🔴 EXPIRED / DESPAWNING", 16711680, true
    end
end

-- 🕵️ SCANNERS (OPTIMIZED)
local function RunScanners()
    -- 1. MIRAGE
    local mScore = 0
    local mEv = {}
    local mPos = nil
    
    if SafeCheck(function() return Workspace.Map:FindFirstChild("MysticIsland") end) then
        mScore = 100; table.insert(mEv, "Direct Model"); mPos = Workspace.Map.MysticIsland.Position
    end
    
    -- Triangulation (Fast)
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
        mScore = mScore + 60; table.insert(mEv, "Triangulation AI"); if not mPos then mPos = sum / #cluster end
    end
    
    if Lighting.FogEnd < 500 then mScore = mScore + 30; table.insert(mEv, "Fog") end
    if SafeCheck(function() return Workspace:FindFirstChild("AdvancedFruitDealer", true) end) then mScore = mScore + 50; table.insert(mEv, "Advanced Dealer") end
    
    if mScore >= CONFIG.MinConfidence then table.insert(EventStack, {name="MIRAGE ISLAND", score=mScore, reason=table.concat(mEv, ", "), pos=mPos}) end

    -- 2. KITSUNE
    local kScore = 0
    local kEv = {}
    local kPos = nil
    
    if SafeCheck(function() return Workspace.Map:FindFirstChild("KitsuneShrine") end) then
        kScore = 100; table.insert(kEv, "Shrine Model"); kPos = Workspace.Map.KitsuneShrine.Position
    end
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "15306698696") end) then kScore = kScore + 80; table.insert(kEv, "Moon Texture") end
    if SafeCheck(function() return Workspace:FindFirstChild("AzureEmber", true) end) then kScore = kScore + 40; table.insert(kEv, "Azure Ember") end
    
    if kScore >= CONFIG.MinConfidence then table.insert(EventStack, {name="KITSUNE SHRINE", score=kScore, reason=table.concat(kEv, ", "), pos=kPos}) end

    -- 3. FULL MOON
    local fScore = 0
    if SafeCheck(function() return string.find(Lighting.Sky.MoonTextureId, "9709149431") end) then fScore = 100 end
    if Lighting:GetAttribute("IsFullMoon") then fScore = fScore + 100 end
    if fScore >= CONFIG.MinConfidence then table.insert(EventStack, {name="FULL MOON", score=fScore, reason="Texture/Attribute", pos=nil}) end

    -- 4. FROZEN
    if SafeCheck(function() return Workspace.Map:FindFirstChild("FrozenDimension") or Workspace.Map:FindFirstChild("Frozen Island") end) then
        local fp = nil
        if Workspace.Map:FindFirstChild("FrozenDimension") then fp = Workspace.Map.FrozenDimension.Position end
        table.insert(EventStack, {name="FROZEN DIMENSION", score=100, reason="Gate Found", pos=fp})
    end
end

-- 🐇 INSTANT HOP
local function InstantHop()
    SetStatus("🚀 HOPPING NOW...")
    local PlaceID = game.PlaceId
    local list = {}
    
    local s, r = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    
    if s and r and r.data then
        for _, v in pairs(r.data) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then table.insert(list, v.id) end
        end
    end
    
    if #list > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceID, list[math.random(1, #list)], LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(PlaceID, game.JobId, LocalPlayer)
    end
end

-- 📨 BLOCKING REPORT (Waits for send before hop)
local function SendReport()
    SetStatus("📡 UPLOADING DATA...")
    local statusText, embedColor, isExpired = GetTimeState()
    if isExpired then embedColor = 16711680 end

    local fields = {}
    for _, e in pairs(EventStack) do
        table.insert(fields, {["name"] = "🚨 FOUND: " .. e.name, ["value"] = "**Proof:** " .. e.reason .. " ("..e.score.."%)", ["inline"] = false})
    end
    
    local statusVal = statusText .. " | Clock: " .. string.format("%.1f", Lighting.ClockTime)
    if isExpired then statusVal = statusVal .. "\n⚠️ **EVENT ENDED**" end
    table.insert(fields, {["name"] = "⏳ LOGIC GATE", ["value"] = statusVal, ["inline"] = true})
    
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    table.insert(fields, {["name"] = "📜 JOIN", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false})

    for _, e in pairs(EventStack) do
        if e.pos then
            local vec = math.floor(e.pos.X) .. ", " .. math.floor(e.pos.Y+200) .. ", " .. math.floor(e.pos.Z)
            local ts = string.format([[
local T=CFrame.new(%s);local P=game.Players.LocalPlayer.Character.HumanoidRootPart;
local Tw=game:GetService("TweenService"):Create(P,TweenInfo.new((P.Position-T.Position).Magnitude/350),{CFrame=T});
local B=Instance.new("BodyVelocity",P);B.Velocity=Vector3.zero;B.MaxForce=Vector3.one*9e9;Tw:Play();Tw.Completed:Wait();B:Destroy()
]], vec)
            table.insert(fields, {["name"] = "✈️ FLY TO " .. e.name, ["value"] = "```lua\n" .. ts .. "\n```", ["inline"] = false})
        end
    end

    local payload = {
        ["content"] = CONFIG.PingRole,
        ["embeds"] = {{
            ["title"] = "🌟 GOD MODE V8 REPORT",
            ["color"] = embedColor,
            ["fields"] = fields,
            ["footer"] = {["text"] = "Speed Run Edition | " .. os.date("%X")},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    -- BLOCKING REQUEST (Must finish before code continues)
    local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if req then
        pcall(function() 
            req({Url = CONFIG.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(payload)})
        end)
    end
end

-- 🏎️ SPEED RUN MAIN
local function SpeedRun()
    if not game:IsLoaded() then game.Loaded:Wait() end
    SetStatus("🏎️ SCANNING...")
    
    -- 1. Instant Scan
    RunScanners()
    
    -- 2. Check Results
    if #EventStack > 0 then
        SendReport() -- Will wait for upload
        InstantHop() -- Hop immediately after upload
    else
        InstantHop() -- Nothing found? Hop NOW.
    end
end

SpeedRun()
