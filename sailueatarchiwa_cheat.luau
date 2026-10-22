-- ==============================================================
-- 🔥 KRAKENHUB V1.0 | สายเลือดอาชีวะ I Sailueatarchiwa ไทย
-- ออกแบบด้วย Fluent UI (BYPASS CODE: 261 & ALL ANTI-SYSTEM KICKS 100%)
-- • HOOKMETAMETHOD BYPASS: บล็อก Remote รายงานการแบนและตรวจจับทั้งหมด (ReportClientViolation, Report, BanPlayer)
-- • BYPASS CODE 261 (SPEED/MOVEMENT CHECK): คุมความเร็ววิ่งฟาร์มที่ 17 studs/s (ไม่เกินเพดาน 18 ของคนทั่วไป) + ล็อค Velocity เป็น 0 สนิทขณะทำงาน/มินิเกม
-- • BYPASS CODE 264 (DISTANCE & HOLD CHECK): หยุดนิ่ง 0.35s ก่อนกด ProximityPrompt + รอ HoldDuration เต็มเวลา 3.5s
-- • BYPASS CODE 265 (REMOTE SPAM): หน่วงเวลาการส่ง Remote ไม่สแปม ไม่ถูกเรทลิมิต
-- • ปรับปรุงระบบ Stamina: เติม Stamina เต็มอัตโนมัติ โดยไม่ไปตั้ง BlockStamina = true ให้ผิดปกติ
-- • ระบบเดินหลบสิ่งกีดขวางอัจฉริยะ (Pathfinding + Stuck Evasion) ไม่เอาหน้าชนตู้/กำแพง
-- • ระบบ Target ESP สีเขียวสดใส ขอบเหลืองนีออนตรงเป้าหมาย (กรองแผ่นพื้นยักษ์ออก 100%)
-- • รองรับทุกสายงาน: งานก่อสร้าง (สมัครงานรับชุดอัตโนมัติ) / ทำความสะอาด / ขยะ / ซ่อมรถ
-- ==============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local CS = CollectionService
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

_G._KrakenScriptId = (_G._KrakenScriptId or 0) + 1
local MY_SCRIPT_ID = _G._KrakenScriptId

print(">>> KRAKENHUB INITIALIZING (ID: " .. MY_SCRIPT_ID .. ") <<<")
-- เคลียร์อินสแตนซ์และ UI เก่า
if _G.KrakenHub_Sailueat and type(_G.KrakenHub_Sailueat.Unload) == "function" then
    pcall(function() _G.KrakenHub_Sailueat.Unload() end)
end
if _G.SailueatHub_Cleanup then
    pcall(_G.SailueatHub_Cleanup)
end

local CoreGui = game:GetService("CoreGui")
local targetGuiParent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
for _, name in ipairs({"KrakenHub_ToggleButton", "SailueatHub_V3", "SailueatHub_V3_5", "SailueatHub_V3_6", "SailueatHub_V3_7", "SailueatHub_V3_8", "SailueatHub_V3_9", "SailueatHub_V2", "SailueatHub_V1", "Fluent"}) do
    local old = targetGuiParent:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
end
pcall(function()
    for _, c in ipairs(CoreGui:GetChildren()) do
        if c:IsA("ScreenGui") and (c.Name == "ScreenGui" or c.Name:find("Fluent")) then
            c:Destroy()
        end
    end
end)

-- เคลียร์ Highlight และ Billboard ตกค้างใน Workspace และ CoreGui
pcall(function()
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc:IsA("Highlight") and (desc.Name:find("Target") or desc.Name:find("Kraken") or desc.Name:find("Farm") or desc.Name:find("Test") or desc.Name:find("Merchant") or desc.Name == "Highlight") then
            if not desc.Parent or not desc.Parent.Name:find("MenuLights") then
                desc:Destroy()
            end
        end
        if desc:IsA("BillboardGui") and (desc.Name:find("Merchant") or desc.Name:find("Kraken")) then
            desc:Destroy()
        end
    end
    for _, c in ipairs(CoreGui:GetChildren()) do
        if c:IsA("Highlight") and (c.Name:find("Target") or c.Name:find("Kraken") or c.Name:find("Farm") or c.Name:find("Test") or c.Name:find("Merchant")) then
            c:Destroy()
        end
        if c:IsA("BillboardGui") and (c.Name:find("Target") or c.Name:find("Kraken") or c.Name:find("Farm") or c.Name:find("Merchant")) then
            c:Destroy()
        end
    end
end)

--------------------------------------------------------------
-- 🛡️ ระบบปลอดภัย 100% (ไม่แตะต้องระบบการยิง / ปืน / Combat / Hitbox ใดๆ ทั้งสิ้น)
-- ไม่ทำลาย Remote, ไม่ hookfunction, ไม่ปิด Script เกม, ไม่ตัด Heartbeat
-- คืนค่า CanCollide ของตัวละครให้เป็นปกติสมบูรณ์
--------------------------------------------------------------
pcall(function()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                if part.Name == "Torso" or part.Name == "Head" then
                    part.CanCollide = true
                else
                    part.CanCollide = false
                end
            end
        end
    end
end)

--------------------------------------------------------------
-- ⚡ 2. ระบบเชื่อมต่อ RUNSYSTEM ของเกม (วิ่ง Shift แท้ สเตมิน่าลดตามธรรมชาติ)
--------------------------------------------------------------
local cachedRunSystemFn = nil
local function GetRunSystemRenderFn()
    if cachedRunSystemFn then return cachedRunSystemFn end
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local rs = pgui and pgui:FindFirstChild("RunSystem")
    if not rs or typeof(getconnections) ~= "function" then return nil end
    for _, c in ipairs(getconnections(RunService.RenderStepped)) do
        local fn = c.Function
        if fn then
            local s, src = pcall(debug.info, fn, "s")
            if s and tostring(src):find("RunSystem") then
                cachedRunSystemFn = fn
                return fn
            end
        end
    end
    return nil
end

--------------------------------------------------------------
-- ตัวแปรสถานะ
--------------------------------------------------------------
local Hub = {
    Connections = {},
    ESPObjects = {},
    AllJobESPObjects = {},
    PlayerESPRegistry = {},
    Unloaded = false,
    State = {
        Running = true,
        -- Farm
        SelectedJob = "งานก่อสร้าง",
        AutoFarm = false,
        FarmSpeed = 17.5,
        AutoSolveMinigame = false,
        AutoHire = true,
        ConstructionFilter = "กำแพง & เหล็ก", -- "ทั้งหมด", "กำแพง & เหล็ก", "เฉพาะกำแพง", "เฉพาะเหล็ก"
        ShowAllSpotsESP = false,
        -- Cheats
        Speed = false,
        SpeedValue = 17,
        Jump = false,
        JumpValue = 35,
        Noclip = false,
        Fly = false,
        FlySpeed = 50,
        InfJump = false,
        ESP = false,
        ESPMaxDistance = 500,
        ESPShowWeapon = true,
        ESPShowDistance = true,
        ESPShowHealthBar = true,
        FullBright = false,
        -- ปืน & Combat
        NoSpread = false,
        NoRecoil = false,
        FastBullet = false,
        SilentAim = false,
        SilentPart = "Head",
        SilentHitChance = 100,
        SilentWallCheck = false,
        SilentVelocity = false,
        CombatFOV = 150,
        DrawFOV = false,
        -- พ่อค้าพเนจร (Wandering Merchant)
        MerchantESP = true,
        AutoNotifyMerchant = true,
    }
}
_G.KrakenHub_Sailueat = Hub
local State = Hub.State
local Connections = Hub.Connections

local function GetChar(plr)
    plr = plr or LocalPlayer
    return plr and plr.Character
end

local function GetHRP(plr)
    local char = GetChar(plr)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHuman(plr)
    local char = GetChar(plr)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local IsCurrentlyWorking


--------------------------------------------------------------
-- 🏃 3. ระบบสปรินต์ความเร็วปลอดภัยสูงสุด (BYPASS CODE: 261)
-- ความเร็วปกติของคนในแมพนี้: เดิน 8 studs/s, วิ่ง (Shift) 18 studs/s, VIP 22 studs/s
-- ปรับ FarmSpeed ได้ปลอดภัย (ค่าเริ่มต้น 17.5 studs/s): วิ่งไว คล่องตัว ไม่เกินเกณฑ์เตะ 261 (ห้ามเกิน 18 เด็ดขาด)
-- ตอนหยุดวิ่งคืนค่าเป็น 8 studs/s เสมอ
-- ขณะทำงานก่อสร้าง/มินิเกม ล็อค WalkSpeed = 0 และ Velocity = 0 สนิท
--------------------------------------------------------------
local NORMAL_WALK_SPEED = 8
local runAnimTrack = nil
local isCurrentlySprinting = false

local function GetRunButton()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    return pgui and pgui:FindFirstChild("MobileGUI") and pgui.MobileGUI:FindFirstChild("MobileButtons") and pgui.MobileGUI.MobileButtons:FindFirstChild("RunButton")
end

local function SetSprinting(enabled)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local fn = GetRunSystemRenderFn()
    local runBtn = GetRunButton()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local rs = pgui and pgui:FindFirstChild("RunSystem")
    local isBlocked = rs and rs:GetAttribute("BlockStamina") == true

    if enabled then
        if (IsCurrentlyWorking and IsCurrentlyWorking()) or isBlocked then
            if fn and debug.getupvalue(fn, 3) == true then
                if runBtn and typeof(firesignal) == "function" then
                    firesignal(runBtn.MouseButton1Click)
                else
                    pcall(debug.setupvalue, fn, 3, false)
                end
            end
            hum.WalkSpeed = 0
            return
        end

        isCurrentlySprinting = true
        if fn then
            local isRunning = debug.getupvalue(fn, 3)
            local isExhausted = debug.getupvalue(fn, 5)
            local stamina = debug.getupvalue(fn, 10)

            -- ถ้ายังไม่เหนื่อยหอบ และสเตมิน่ายังเหลือ
            if not isExhausted and (stamina == nil or stamina > 2) then
                if not isRunning then
                    -- 🏃 กดปุ่ม Shift แท้ของเกมผ่าน RunButton (100% Native Game Sprint)
                    if runBtn and typeof(firesignal) == "function" then
                        firesignal(runBtn.MouseButton1Click)
                    else
                        pcall(debug.setupvalue, fn, 3, true)
                        hum.WalkSpeed = 18
                    end
                end
                hum.WalkSpeed = 18
                hum.JumpPower = 35
            else
                -- สเตมิน่าหมด ปิดวิ่งให้เดินฟื้นตามธรรมชาติ (เหมือนปล่อย Shift)
                if isRunning then
                    if runBtn and typeof(firesignal) == "function" then
                        firesignal(runBtn.MouseButton1Click)
                    else
                        pcall(debug.setupvalue, fn, 3, false)
                        hum.WalkSpeed = 8
                    end
                end
            end
        else
            hum.WalkSpeed = 18
            hum.JumpPower = 35
        end
    else
        isCurrentlySprinting = false
        if fn then
            local isRunning = debug.getupvalue(fn, 3)
            if isRunning then
                -- 🛑 ปล่อยปุ่ม Shift แท้ คืนความเร็วเดิน 8 studs/s
                if runBtn and typeof(firesignal) == "function" then
                    firesignal(runBtn.MouseButton1Click)
                else
                    pcall(debug.setupvalue, fn, 3, false)
                    hum.WalkSpeed = 8
                end
            end
        end
        if not (IsCurrentlyWorking and IsCurrentlyWorking()) and not isBlocked then
            hum.WalkSpeed = NORMAL_WALK_SPEED
            hum.JumpPower = 35
        end
    end
end



-- ควบคุมความเร็วใน RenderStepped: ล็อคตัว 0 ขณะทำงาน, คืนการควบคุมให้ RunSystem ขณะเดินทาง, และรักษามุมกล้องให้นิ่งสนิท
Connections.SpeedEnforcer = RunService.RenderStepped:Connect(function()
    if not State.Running then return end
    local hum = GetHuman()
    local hrp = GetHRP()
    if not hum or hum.Health <= 0 or not hrp then return end

    -- 🛑 ล้างค่าสั่นมุมกล้อง math.noise ของ RunSystem ให้เป็น 0 (ป้องกันมุมกล้องกระตุก/สั่นขณะวิ่ง 100%)
    local fn = GetRunSystemRenderFn()
    if fn then
        pcall(debug.setupvalue, fn, 15, 0) -- u14: target amplitude ของการสั่นกล้อง
        pcall(debug.setupvalue, fn, 18, 0) -- u15: current amplitude ของการสั่นกล้อง
        pcall(debug.setupvalue, fn, 23, 0) -- u16: phase ของ math.noise
    end

    -- ล็อคความเร็ว 0 เฉพาะตอนที่เปิด AutoFarm และกำลังทำงานก่อสร้าง / มินิเกม เท่านั้น
    if State.AutoFarm and IsCurrentlyWorking and IsCurrentlyWorking() then
        hum.WalkSpeed = 0
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if isCurrentlySprinting then
            isCurrentlySprinting = false
            if fn and debug.getupvalue(fn, 3) == true then
                local runBtn = GetRunButton()
                if runBtn and typeof(firesignal) == "function" then
                    firesignal(runBtn.MouseButton1Click)
                else
                    pcall(debug.setupvalue, fn, 3, false)
                end
            end
        end
        return
    end

    -- หากผู้ใช้เปิด Cheats > Speed เสริมเอง ล็อคเพดานปลอดภัยไม่เกิน 18 studs/s
    if State.Speed then
        hum.WalkSpeed = math.min(State.SpeedValue or 18, 18)
    end
end)

--------------------------------------------------------------
-- ☀️ ระบบสว่างทั้งแมพ (FULL BRIGHT)
--------------------------------------------------------------
local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
}

local function EnableFullBright()
    pcall(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
    end)
end

local function RestoreLighting()
    pcall(function()
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
        Lighting.Ambient = defaultLighting.Ambient
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
    end)
end

Connections.FullBrightLoop = RunService.RenderStepped:Connect(function()
    if State.FullBright and State.Running then
        pcall(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        end)
    end
end)

--------------------------------------------------------------
-- 🎯 4. ระบบ TARGET ESP สีชัดเจน แยกประเภท เหล็ก (ส้มทอง) / กำแพง (เขียวนีออน)
--------------------------------------------------------------
local currentTargetHighlight = nil
local currentTargetBillboard = nil
local currentTargetInstance = nil
local currentTargetStatus = nil

local function ClearTargetESP()
    if currentTargetHighlight then
        pcall(function() currentTargetHighlight:Destroy() end)
        currentTargetHighlight = nil
    end
    if currentTargetBillboard then
        pcall(function() currentTargetBillboard:Destroy() end)
        currentTargetBillboard = nil
    end
    currentTargetInstance = nil
    currentTargetStatus = nil
end

local function SetTargetESP(targetInstance, titleText, customColor, statusText)
    if not targetInstance then
        ClearTargetESP()
        return
    end

    currentTargetStatus = statusText or "เป้าหมาย"

    -- ถ้าเป็นเป้าหมายเดิม แค่อัปเดตข้อความหัวเรื่อง/สถานะ
    if currentTargetInstance == targetInstance and currentTargetHighlight and currentTargetHighlight.Parent and currentTargetBillboard and currentTargetBillboard.Parent then
        local frame = currentTargetBillboard:FindFirstChildOfClass("Frame")
        if frame then
            local tLabel = frame:FindFirstChild("TitleLabel")
            if tLabel and titleText then
                tLabel.Text = "🎯 " .. titleText
            end
        end
        return
    end

    ClearTargetESP()
    currentTargetInstance = targetInstance
    currentTargetStatus = statusText or "เป้าหมาย"

    local adornee = targetInstance
    if adornee:IsA("ProximityPrompt") then
        adornee = adornee.Parent
    end
    if adornee:IsA("Attachment") then
        adornee = adornee.Parent
    end

    -- หากชิ้นส่วนอยู่ใต้ Model ประจำจุด (NailSite, WeldSite, DrillSite) ให้นำ Model นั้นมาทำ Highlight
    if adornee:IsA("BasePart") and adornee.Parent and adornee.Parent:IsA("Model") and adornee.Parent ~= Workspace and adornee.Parent ~= Workspace:FindFirstChild("Job") and adornee.Parent.Name ~= "งาน" then
        adornee = adornee.Parent
    end

    -- กรองชิ้นส่วนขนาดใหญ่ของแมพ (Union ฐานราก, ZoneBound ขนาดเกิน 30 studs)
    if adornee:IsA("BasePart") and (adornee.Size.X > 30 or adornee.Size.Z > 30 or adornee.Size.Y > 30) then
        adornee = nil
    end

    -- กำหนดสีแยกประเภทอย่างชัดเจน
    local textLower = string.lower(titleText or "")
    local fillColor = customColor or Color3.fromRGB(0, 240, 160)
    local outlineColor = Color3.fromRGB(160, 255, 255)

    if titleText and (titleText:find("เหล็ก") or textLower:find("steel") or textLower:find("weld")) then
        fillColor = Color3.fromRGB(255, 145, 0)      -- Neon Orange-Gold
        outlineColor = Color3.fromRGB(255, 235, 70)   -- Neon Gold-Yellow Glow
    elseif titleText and (titleText:find("กำแพง") or titleText:find("ตะปู") or textLower:find("nail") or textLower:find("wall")) then
        fillColor = Color3.fromRGB(0, 240, 160)      -- Neon Cyan-Green
        outlineColor = Color3.fromRGB(160, 255, 255)  -- Ice Cyan Glow
    elseif titleText and (titleText:find("หิน") or textLower:find("drill") or textLower:find("rock")) then
        fillColor = Color3.fromRGB(190, 110, 255)    -- Neon Purple
        outlineColor = Color3.fromRGB(255, 200, 255)  -- Pink-White Glow
    elseif titleText and titleText:find("NPC") then
        fillColor = Color3.fromRGB(0, 210, 255)      -- Sky Blue
        outlineColor = Color3.fromRGB(255, 255, 255)
    end

    pcall(function()
        if adornee then
            local hl = Instance.new("Highlight")
            hl.Name = "KrakenTargetFarmHighlight"
            hl.Adornee = adornee
            hl.FillColor = fillColor
            hl.FillTransparency = 0.28
            hl.OutlineColor = outlineColor
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = CoreGui
            currentTargetHighlight = hl
        end

        local attachPart = nil
        if targetInstance:IsA("BasePart") then
            attachPart = targetInstance
        elseif targetInstance:IsA("Model") then
            attachPart = targetInstance:FindFirstChild("WoodPlank")
                      or targetInstance:FindFirstChild("Steel")
                      or targetInstance:FindFirstChild("Mountain")
                      or targetInstance:FindFirstChild("Prompt")
                      or targetInstance.PrimaryPart
                      or targetInstance:FindFirstChildWhichIsA("BasePart", true)
        end
        if not attachPart and adornee and adornee:IsA("Model") then
            attachPart = adornee:FindFirstChild("WoodPlank")
                      or adornee:FindFirstChild("Steel")
                      or adornee:FindFirstChild("Mountain")
                      or adornee:FindFirstChild("Prompt")
                      or adornee.PrimaryPart
                      or adornee:FindFirstChildWhichIsA("BasePart", true)
        end
        if not attachPart and adornee and adornee:IsA("BasePart") then
            attachPart = adornee
        end

        if attachPart then
            local bb = Instance.new("BillboardGui")
            bb.Name = "KrakenTargetFarmBillboard"
            bb.Adornee = attachPart
            bb.Size = UDim2.new(0, 180, 0, 48)
            bb.StudsOffset = Vector3.new(0, 3.4, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 45

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
            frame.BackgroundTransparency = 0.18
            frame.BorderSizePixel = 0
            frame.Parent = bb

            local uic = Instance.new("UICorner")
            uic.CornerRadius = UDim.new(0, 8)
            uic.Parent = frame

            local uis = Instance.new("UIStroke")
            uis.Color = outlineColor
            uis.Thickness = 2.0
            uis.Parent = frame

            local tLabel = Instance.new("TextLabel")
            tLabel.Name = "TitleLabel"
            tLabel.Size = UDim2.new(1, 0, 0.52, 0)
            tLabel.BackgroundTransparency = 1
            tLabel.Font = Enum.Font.GothamBold
            tLabel.TextSize = 12
            tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            tLabel.Text = "🎯 " .. (titleText or "จุดทำงานเป้าหมาย")
            tLabel.Parent = frame

            local dLabel = Instance.new("TextLabel")
            dLabel.Name = "DistLabel"
            dLabel.Size = UDim2.new(1, 0, 0.48, 0)
            dLabel.Position = UDim2.new(0, 0, 0.52, 0)
            dLabel.BackgroundTransparency = 1
            dLabel.Font = Enum.Font.GothamMedium
            dLabel.TextSize = 11
            dLabel.TextColor3 = fillColor
            dLabel.Text = (currentTargetStatus or "เป้าหมาย") .. " • กำลังคำนวณ..."
            dLabel.Parent = frame

            bb.Parent = CoreGui
            currentTargetBillboard = bb
        end
    end)
end

Connections.TargetESPUpdate = RunService.Heartbeat:Connect(function()
    if currentTargetBillboard and currentTargetInstance then
        local attachPart = (currentTargetInstance:IsA("BasePart") and currentTargetInstance)
                        or (currentTargetBillboard.Adornee and currentTargetBillboard.Adornee:IsA("BasePart") and currentTargetBillboard.Adornee)
                        or currentTargetInstance:FindFirstChildWhichIsA("BasePart", true)
        local hrp = GetHRP()
        if attachPart and hrp then
            local dist = (hrp.Position - attachPart.Position).Magnitude
            local frame = currentTargetBillboard:FindFirstChildOfClass("Frame")
            local dLabel = frame and frame:FindFirstChild("DistLabel")
            if dLabel then
                local st = currentTargetStatus or "เป้าหมาย"
                dLabel.Text = string.format("%s • %.1f ม. (%d studs)", st, dist / 3.57, math.floor(dist))
            end
        end
    end
end)

--------------------------------------------------------------
-- 👁️ ระบบ ESP แสดงจุดทำงานทั้งหมดในแมพ
--------------------------------------------------------------
local function ClearAllJobESP()
    for _, obj in pairs(Hub.AllJobESPObjects) do
        pcall(function() obj:Destroy() end)
    end
    table.clear(Hub.AllJobESPObjects)
end

local function UpdateAllJobESP()
    ClearAllJobESP()
    if not State.ShowAllSpotsESP or not State.Running then return end

    local jobFolder = Workspace:FindFirstChild("Job")
    if not jobFolder then return end

    local constJob = jobFolder:FindFirstChild("งานก่อสร้าง")
    if constJob and constJob:FindFirstChild("งาน") then
        local catColors = {
            ["ตะปู"] = Color3.fromRGB(0, 240, 160),  -- กำแพง (Cyan-Green)
            ["เหล็ก"] = Color3.fromRGB(255, 145, 0), -- เหล็ก (Orange-Gold)
            ["หิน"] = Color3.fromRGB(190, 110, 255), -- หิน (Purple)
        }
        for _, cat in ipairs(constJob["งาน"]:GetChildren()) do
            local color = catColors[cat.Name] or Color3.fromRGB(120, 255, 40)
            for _, item in ipairs(cat:GetChildren()) do
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    local targetAdornee = item
                    if targetAdornee ~= currentTargetInstance and targetAdornee ~= (currentTargetBillboard and currentTargetBillboard.Adornee) then
                        local hl = Instance.new("Highlight")
                        hl.Name = "AllJobSpotHL"
                        hl.Adornee = targetAdornee
                        hl.FillColor = color
                        hl.FillTransparency = 0.72
                        hl.OutlineColor = color
                        hl.OutlineTransparency = 0.4
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = CoreGui
                        table.insert(Hub.AllJobESPObjects, hl)
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(3.5)
        if State.ShowAllSpotsESP then
            UpdateAllJobESP()
        end
    end
end)

--------------------------------------------------------------
-- 🧭 5. ระบบเดินทางอัจฉริยะ หลบสิ่งกีดขวาง (SMART NAVIGATION 2.0)
--------------------------------------------------------------
local function RaycastCollidable(origin, dir, maxPierces)
    maxPierces = maxPierces or 5
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local filter = { LocalPlayer.Character }
    if Workspace:FindFirstChild("Terrain") then table.insert(filter, Workspace.Terrain) end
    rayParams.FilterDescendantsInstances = filter

    local curOrigin = origin
    local remainingDir = dir

    for _ = 1, maxPierces do
        local hit = Workspace:Raycast(curOrigin, remainingDir, rayParams)
        if not hit then
            return nil
        end
        if hit.Instance and hit.Instance.CanCollide then
            return hit
        else
            -- ชิ้นส่วนไร้ Collision (Zone trigger, หมอก, แสง): บันทึกลง Filter แล้วยิงต่อทะลุผ่าน
            table.insert(filter, hit.Instance)
            rayParams.FilterDescendantsInstances = filter
            local hitDist = (hit.Position - curOrigin).Magnitude
            if hitDist >= remainingDir.Magnitude - 0.1 then
                return nil
            end
            curOrigin = hit.Position + (remainingDir.Unit * 0.15)
            remainingDir = dir - (curOrigin - origin)
        end
    end
    return nil
end

local function IsPathClear(fromPos, toPos, checkRadius)
    checkRadius = checkRadius or 1.2
    local dir = toPos - fromPos
    local dist = dir.Magnitude
    if dist > 35 then return false end
    local rayDir = dir

    -- ตรวจสอบระดับหัวเข่า และระดับอก เพื่อความแม่นยำ ไม่มองข้ามสิ่งกีดขวางเตี้ยหรือสูง
    local kneeHit = RaycastCollidable(fromPos + Vector3.new(0, -1.0, 0), rayDir)
    if kneeHit and (kneeHit.Position - fromPos).Magnitude < (dist - 0.5) then
        return false
    end
    local chestHit = RaycastCollidable(fromPos + Vector3.new(0, 1.2, 0), rayDir)
    if chestHit and (chestHit.Position - fromPos).Magnitude < (dist - 0.5) then
        return false
    end

    -- ตรวจสอบด้านข้างซ้าย-ขวาเล็กน้อย ป้องกันการเฉี่ยวชนขอบเสา/กำแพง
    local rightVec = Vector3.new(-dir.Z, 0, dir.X).Unit
    local leftKnee = RaycastCollidable(fromPos + (rightVec * -checkRadius) + Vector3.new(0, 0.5, 0), rayDir)
    if leftKnee and (leftKnee.Position - fromPos).Magnitude < (dist - 0.5) then
        return false
    end
    local rightKnee = RaycastCollidable(fromPos + (rightVec * checkRadius) + Vector3.new(0, 0.5, 0), rayDir)
    if rightKnee and (rightKnee.Position - fromPos).Magnitude < (dist - 0.5) then
        return false
    end

    return true
end

-- ระบบหนวดเรย์แคสต์ตรวจจับสิ่งกีดขวาง WASD แบบเรียลไทม์ (ห้ามฝืนเดินชนเข้ากำแพงเด็ดขาด)
local function CheckObstacleAndDodge(hrp, hum, targetPos)
    local toTarget = targetPos - hrp.Position
    local hDir = Vector3.new(toTarget.X, 0, toTarget.Z)
    if hDir.Magnitude < 0.2 then return targetPos, Vector3.zero, false end
    local forward = hDir.Unit
    local rightVec = Vector3.new(-forward.Z, 0, forward.X).Unit

    local origin = hrp.Position
    local lowOrigin = origin + Vector3.new(0, -1.1, 0)   -- ระดับพาเลท / ขอบปูน / กองอิฐ
    local chestOrigin = origin + Vector3.new(0, 1.0, 0)  -- ระดับอก / เสานั่งร้าน / กำแพง

    local checkDist = 4.2
    local lowHit = RaycastCollidable(lowOrigin, forward * checkDist)
    local chestHit = RaycastCollidable(chestOrigin, forward * checkDist)

    -- กฎที่ 1 (Auto-Vault): สิ่งกีดขวางเตี้ยอย่างเดียว (พาเลท, ปูน) แต่ระดับอกโล่ง -> กระโดดข้ามทันที
    if lowHit and not chestHit then
        hum.Jump = true
        return targetPos, forward, false
    end

    -- กฎที่ 2 (WASD Strafe Evasion): หากมีกำแพง เสา หรือสิ่งกีดขวางข้างหน้า ห้ามฝืนเดินหน้า W เข้ากำแพงเด็ดขาด!
    if chestHit or lowHit then
        local hitObj = chestHit or lowHit
        local hitDist = (hitObj.Position - chestOrigin).Magnitude
        local norm = hitObj.Normal and Vector3.new(hitObj.Normal.X, 0, hitObj.Normal.Z)
        if norm and norm.Magnitude > 0.1 then
            norm = norm.Unit
        else
            norm = -forward
        end

        -- ทิศทางเดินข้างซ้าย A และขวา D
        local leftA = -rightVec
        local rightD = rightVec

        -- ตรวจสอบช่องว่างด้านซ้าย (A) และขวา (D)
        local leftHit = RaycastCollidable(chestOrigin, leftA * 3.8)
        local rightHit = RaycastCollidable(chestOrigin, rightD * 3.8)

        -- ตรวจสอบทแยงหน้าซ้าย (W+A) และทแยงหน้าขวา (W+D)
        local diagLeft = (forward * 0.35 + leftA * 0.9).Unit
        local diagRight = (forward * 0.35 + rightD * 0.9).Unit
        local diagLeftHit = RaycastCollidable(chestOrigin, diagLeft * 3.8)
        local diagRightHit = RaycastCollidable(chestOrigin, diagRight * 3.8)

        local leftClear = (leftHit == nil and diagLeftHit == nil)
        local rightClear = (rightHit == nil and diagRightHit == nil)

        -- แรงดันถอยห่างจากระนาบกำแพง (Repulsion) ป้องกันตัวละครเสียดสีติดขอบ
        local pushAway = Vector3.zero
        if hitDist < 2.6 then
            pushAway = norm * 1.0
        end

        local chosenStrafe = nil

        if leftClear and not rightClear then
            -- เลี้ยวซ้าย สเตรฟ A
            chosenStrafe = (leftA + pushAway).Unit
        elseif rightClear and not leftClear then
            -- เลี้ยวขวา สเตรฟ D
            chosenStrafe = (rightD + pushAway).Unit
        elseif leftClear and rightClear then
            -- โล่งทั้งคู่: ตรวจว่าฝั่งไหนเข้าใกล้ targetPos มากกว่า
            local leftTarget = origin + leftA * 4.0
            local rightTarget = origin + rightD * 4.0
            if (leftTarget - targetPos).Magnitude < (rightTarget - targetPos).Magnitude then
                chosenStrafe = (leftA + pushAway).Unit
            else
                chosenStrafe = (rightD + pushAway).Unit
            end
        else
            -- ทั้งซ้ายและขวาตัน (เข้ามุมอับ): ถอยหลัง S ก้าวออก 2.8 studs + กระโดด
            hum.Jump = true
            local backS = (-forward + norm * 0.8).Unit
            return origin + (backS * 3.0), backS, true
        end

        -- เคลื่อนที่ไปในทิศทางสเตรฟ A หรือ D (ไม่เดินตรงเข้าหากำแพง)
        return origin + (chosenStrafe * 4.5), chosenStrafe, true
    end

    return targetPos, forward, false
end


local function NavigateTo(targetPos, stopDist, maxTime, targetPrompt)
    stopDist = stopDist or 3.8
    maxTime = maxTime or 14
    local startTime = tick()

    local hrp = GetHRP()
    local hum = GetHuman()
    if not hrp or not hum then return false end

    -- ปิด Noclip อย่างเด็ดขาดในโหมดฟาร์ม ใช้ระบบฟิสิกส์และการหลบหลีกแท้ 100%
    State.Noclip = false

    local promptMaxD = targetPrompt and (targetPrompt.MaxActivationDistance or 5.0) or 5.0
    local function IsArrived()
        if not hrp then return false end
        local dist3D = (hrp.Position - targetPos).Magnitude
        local hDist = (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(targetPos.X, targetPos.Z)).Magnitude
        local yDiff = math.abs(hrp.Position.Y - targetPos.Y)

        if targetPrompt then
            local pPart = (targetPrompt.Parent:IsA("BasePart") and targetPrompt.Parent)
                       or (targetPrompt.Parent:IsA("Attachment") and targetPrompt.Parent.Parent:IsA("BasePart") and targetPrompt.Parent.Parent)
            local pDist3D = pPart and (hrp.Position - pPart.Position).Magnitude or dist3D

            -- เมื่อเข้าใกล้จุดยืนนำทาง (standPos) หรืออยู่ในระยะกด ProximityPrompt ได้ 100%
            if (dist3D <= stopDist or (hDist <= stopDist and yDiff <= 3.5)) and pDist3D <= math.min(promptMaxD - 0.5, 4.3) then
                return true
            end
            if pDist3D <= math.min(promptMaxD - 0.7, 4.0) then
                return true
            end
        else
            if dist3D <= stopDist then return true end
            if hDist <= stopDist and yDiff <= 4.0 then return true end
        end
        return false
    end

    if IsArrived() then
        hum:Move(Vector3.zero, false)
        return true
    end

    SetSprinting(true)

    -- วางเป้าหมาย Pathfinding บนระดับพื้นของผู้เล่น ป้องกันการคำนวณเส้นทางลอยในอากาศ
    local floorTarget = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)

    -- ตั้งค่า Pathfinding ให้เว้นระยะห่างจากขอบเสาและนั่งร้านอย่างแม่นยำ (รัศมีกว้างขึ้น ป้องกันการเดินเบียดกำแพง)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2.8,      -- รัศมีปลอดภัย 2.8 studs กว้างพอที่จะไม่ติดขอบเสาหรือนั่งร้าน
        AgentHeight = 5.0,
        AgentCanJump = true,
        WaypointSpacing = 2.5,  -- ระยะห่างจุดนำทางถี่พอดีสำหรับเลี้ยวโค้งคมชัด
    })

    local success = pcall(function()
        path:ComputeAsync(hrp.Position, floorTarget)
    end)

    local waypoints = {}
    if success and path.Status == Enum.PathStatus.Success then
        waypoints = path:GetWaypoints()
    else
        waypoints = {
            { Position = floorTarget, Action = Enum.PathWaypointAction.Move }
        }
    end

    local wpIndex = 1
    if #waypoints > 1 and (hrp.Position - waypoints[1].Position).Magnitude < 3.5 then
        wpIndex = 2
    end

    local lastPos = hrp.Position
    local stuckTimer = 0
    local totalStuckEvents = 0
    local lastProgressTime = tick()

    while (tick() - startTime) < maxTime and State.Running and State.AutoFarm do
        hrp = GetHRP()
        hum = GetHuman()
        if not hrp or not hum or hum.Health <= 0 then return false end

        -- หากจุดทำงานนี้ถูกคนอื่นทำไปแล้ว หรือถูกปิด ให้ยกเลิกทันที ไม่ต้องเสียเวลาเดินต่อ
        if targetPrompt and not targetPrompt.Enabled then
            return false
        end

        -- รักษาการวิ่ง Shift แท้
        SetSprinting(true)

        if IsArrived() then
            hum:Move(Vector3.zero, false)
            hum:MoveTo(hrp.Position)
            return true
        end

        local currentAimPos = floorTarget
        local curDist = (hrp.Position - floorTarget).Magnitude

        -- พุ่งตรงเฉพาะเมื่ออยู่ใกล้เป้าหมายมาก (<= 5.0 studs) และทางโล่งสนิทเท่านั้น
        if curDist <= 5.0 and IsPathClear(hrp.Position, floorTarget, 1.0) then
            currentAimPos = floorTarget
        else
            -- เดินตาม Waypoints ของ Pathfinding
            if wpIndex <= #waypoints then
                local wp = waypoints[wpIndex]
                local hDist = (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(wp.Position.X, wp.Position.Z)).Magnitude

                -- ขยับไปยัง Waypoint ถัดไปเมื่อเข้าใกล้ 2.2 studs
                if hDist <= 2.2 then
                    wpIndex = wpIndex + 1
                    if wpIndex <= #waypoints then
                        wp = waypoints[wpIndex]
                    end
                elseif wpIndex + 1 <= #waypoints then
                    -- มองล่วงหน้า 1 จุด: ถ้ามุมเลี้ยวแล้วทางตรงโล่ง ขยับไปเพื่อความลื่นไหล
                    local nextWp = waypoints[wpIndex + 1]
                    local nextDist = (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(nextWp.Position.X, nextWp.Position.Z)).Magnitude
                    if nextDist <= 4.2 and IsPathClear(hrp.Position, nextWp.Position, 1.2) then
                        wpIndex = wpIndex + 1
                        wp = nextWp
                    end
                end

                if wp then
                    if wp.Action == Enum.PathWaypointAction.Jump then
                        hum.Jump = true
                    end
                    currentAimPos = wp.Position
                end
            end
        end

        -- ใช้ระบบตรวจจับหนวดเรดาร์ WASD หลบสิ่งกีดขวางแบบเรียลไทม์ (ห้ามฝืนเดินชนกำแพงเด็ดขาด)
        local steerTarget, steerDir, isDodge = CheckObstacleAndDodge(hrp, hum, currentAimPos)

        -- ขับเคลื่อนตัวละคร: หากหลบหลีกให้ใช้ steerDir สเตรฟ แต่ถ้าเดินปกติให้ใช้ MoveTo (ไม่เรียกชนกันเพื่อป้องกันมุมกล้องกระตุก)
        if isDodge and steerDir and steerDir.Magnitude > 0.1 then
            hum:Move(steerDir.Unit, false)
        else
            hum:MoveTo(steerTarget)
        end

        task.wait(0.03)

        -- ตรวจสอบการติดขัด (Stuck Detection & Smooth Unstuck ด้วยท่า WASD สเตรฟถอย ไม่ฝืนเดินชน)
        local moved = (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(lastPos.X, lastPos.Z)).Magnitude
        lastPos = hrp.Position

        if moved < 0.22 then
            stuckTimer = stuckTimer + 0.03
        else
            stuckTimer = 0
            lastProgressTime = tick()
        end

        if stuckTimer >= 0.28 then
            stuckTimer = 0
            totalStuckEvents = totalStuckEvents + 1

            -- หากติดซ้ำ 3 ครั้ง (เกิน 1 วินาที) จุดนี้มีสิ่งกีดขวางขวางทาง ยกเลิกแล้วเปลี่ยนจุดทันที!
            if totalStuckEvents >= 3 then
                return false
            end

            hum.Jump = true

            local forward = (floorTarget - hrp.Position).Unit
            local leftSide = Vector3.new(forward.Z, 0, -forward.X)
            local rightSide = -leftSide

            -- ตรวจสอบช่องว่างซ้าย-ขวาเพื่อเลือกฝั่งสเตรฟหลบที่ดีที่สุด
            local testL = RaycastCollidable(hrp.Position + Vector3.new(0, 1.0, 0), leftSide * 3.5)
            local testR = RaycastCollidable(hrp.Position + Vector3.new(0, 1.0, 0), rightSide * 3.5)
            local side = leftSide
            if testL and not testR then
                side = rightSide
            elseif not testL and not testR then
                side = (math.random() > 0.5) and rightSide or leftSide
            end

            -- ถอยหลัง (S) 2.5 studs + สเตรฟข้าง (A/D) 4.0 studs + กระโดด (หลุดจากกำแพงทันที ไม่ฝืนชน)
            local escapeTarget = hrp.Position - (forward * 2.5) + (side * 4.0)
            local escapeDir = (escapeTarget - hrp.Position).Unit
            hum:Move(escapeDir, false)
            hum:MoveTo(escapeTarget)
            task.wait(0.18)

            pcall(function()
                path:ComputeAsync(hrp.Position, floorTarget)
                if path.Status == Enum.PathStatus.Success then
                    waypoints = path:GetWaypoints()
                    wpIndex = 1
                end
            end)
        end

        if (tick() - lastProgressTime) > 8 then
            break
        end
    end

    local arrived = IsArrived()
    SetSprinting(false)
    if hum then
        hum:Move(Vector3.zero, false)
    end
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    return arrived
end

--------------------------------------------------------------
--------------------------------------------------------------
-- 🎨 โหลด FLUENT UI & โลโก้ KRAKENHUB (K COMMUNITY)
--------------------------------------------------------------
local function GetLogoAsset()
    if typeof(isfile) == "function" and typeof(writefile) == "function" and typeof(getcustomasset) == "function" then
        if not isfile("k_community_logo.png") then
            pcall(function()
                writefile("k_community_logo.png", game:HttpGet("https://raw.githubusercontent.com/armongzx56-design/KrakenHub/main/k_community_logo.png"))
            end)
        end
        if isfile("k_community_logo.png") then
            local s, asset = pcall(getcustomasset, "k_community_logo.png")
            if s and asset then return asset end
        end
        if isfile("k_logo.png") then
            local s, asset = pcall(getcustomasset, "k_logo.png")
            if s and asset then return asset end
        end
    end
    return "rbxasset://5059d143b75fc7c70a58a871660c4f16/k_community_logo.png"
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "KrakenHub | สายเลือดอาชีวะ",
    SubTitle = "v1.0",
    TabWidth = 165,
    Size = UDim2.fromOffset(630, 480),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- ใส่โลโก้ K Community ใน TitleBar ของ Window (จัดกึ่งกลางให้ตรงกับข้อความเป๊ะๆ)
pcall(function()
    local tbFrame = Window and Window.TitleBar and Window.TitleBar.Frame
    local titleContainer = tbFrame and tbFrame:FindFirstChildOfClass("Frame")
    if titleContainer then
        local layout = titleContainer:FindFirstChildOfClass("UIListLayout")
        if layout then
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
        end

        local old = titleContainer:FindFirstChild("KrakenLogoIcon")
        if old then old:Destroy() end

        local logo = Instance.new("ImageLabel")
        logo.Name = "KrakenLogoIcon"
        logo.Size = UDim2.fromOffset(22, 22)
        logo.BackgroundTransparency = 1
        logo.Image = GetLogoAsset()
        logo.ScaleType = Enum.ScaleType.Fit
        logo.LayoutOrder = -1
        logo.Parent = titleContainer
    end
end)

-- สร้างปุ่มลอยสำหรับเปิด/ปิดเมนูสคริปต์ (Floating Toggle Button)
local function CreateFloatingToggleButton(windowObj)
    pcall(function()
        local old = targetGuiParent:FindFirstChild("KrakenHub_ToggleButton")
        if old then old:Destroy() end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KrakenHub_ToggleButton"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 999
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local mainBtn = Instance.new("ImageButton")
        mainBtn.Name = "OpenCloseBtn"
        mainBtn.Size = UDim2.fromOffset(48, 48)
        mainBtn.Position = UDim2.new(0, 15, 0.5, -24)
        mainBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        mainBtn.BackgroundTransparency = 0.15
        mainBtn.AutoButtonColor = false
        mainBtn.BorderSizePixel = 0
        mainBtn.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 13)
        corner.Parent = mainBtn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 45, 45)
        stroke.Thickness = 1.6
        stroke.Transparency = 0.25
        stroke.Parent = mainBtn

        local logoImg = Instance.new("ImageLabel")
        logoImg.Name = "Logo"
        logoImg.Size = UDim2.fromScale(0.82, 0.82)
        logoImg.Position = UDim2.fromScale(0.5, 0.5)
        logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
        logoImg.BackgroundTransparency = 1
        logoImg.Image = GetLogoAsset()
        logoImg.ScaleType = Enum.ScaleType.Fit
        logoImg.Parent = mainBtn

        -- ลอจิกการลากปุ่ม (Smooth Draggable - รองรับทั้ง PC เมาส์ และมือถือ Touch)
        local dragging = false
        local dragStartPos = nil
        local startFramePos = nil
        local movedEnough = false

        mainBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                movedEnough = false
                dragStartPos = input.Position
                startFramePos = mainBtn.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartPos
                if delta.Magnitude > 6 then
                    movedEnough = true
                end
                mainBtn.Position = UDim2.new(
                    startFramePos.X.Scale,
                    startFramePos.X.Offset + delta.X,
                    startFramePos.Y.Scale,
                    startFramePos.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        -- กดปุ่มเพื่อเปิด/ปิดหน้าต่างเมนูสคริปต์
        mainBtn.Activated:Connect(function()
            if not movedEnough then
                TweenService:Create(mainBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(42, 42)
                }):Play()
                task.wait(0.08)
                TweenService:Create(mainBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(48, 48)
                }):Play()

                if windowObj then
                    if windowObj.Minimize then
                        windowObj:Minimize()
                    elseif windowObj.Root then
                        windowObj.Root.Visible = not windowObj.Root.Visible
                    end
                end
            end
        end)

        -- เอฟเฟกต์เมื่อวางเมาส์เหนือปุ่ม
        mainBtn.MouseEnter:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Transparency = 0, Thickness = 2.2 }):Play()
        end)
        mainBtn.MouseLeave:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Transparency = 0.25, Thickness = 1.6 }):Play()
        end)

        screenGui.Parent = targetGuiParent
        Hub.ToggleButtonGui = screenGui
    end)
end
CreateFloatingToggleButton(Window)

local Tabs = {
    Farm      = Window:AddTab({ Title = "งาน & ฟาร์มอัตโนมัติ", Icon = "hard-hat" }),
    Merchant  = Window:AddTab({ Title = "พ่อค้าพเนจร",         Icon = "shopping-cart" }),
    Combat    = Window:AddTab({ Title = "ระบบต่อสู้ (Combat)", Icon = "crosshair" }),
    Player    = Window:AddTab({ Title = "ตัวละคร & เคลื่อนที่", Icon = "user" }),
    Settings  = Window:AddTab({ Title = "ตั้งค่า",              Icon = "settings" })
}

local Options = Fluent.Options
Hub.Fluent = Fluent
Hub.Options = Options
Hub.Tabs = Tabs
Hub.Window = Window

local function Notify(title, content, sub, duration)
    Fluent:Notify({
        Title = title or "KrakenHub",
        Content = content or "",
        SubContent = sub or "",
        Duration = duration or 3
    })
end

--------------------------------------------------------------
-- 🔨 6. ระบบแก้มินิเกมอัตโนมัติ (ULTRA AUTO SOLVE MINIGAME 100%)
--------------------------------------------------------------
local isVIMHolding = false
local activeMiniGame = nil

local function ReleaseVIM()
    if isVIMHolding then
        isVIMHolding = false
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
end

-- เชื่อมต่อระบบ Event ของเซิร์ฟเวอร์โดยตรง (แก้โจทย์ทันที ป้องกันการค้าง 100% ทุกกรณี)
pcall(function()
    local constJobRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
    if constJobRS then
        local mgRemote = constJobRS:FindFirstChild("MiniGame")
        local keyRemote = constJobRS:FindFirstChild("ChallengeKeyUpdate")
        local doneRemote = constJobRS:FindFirstChild("MiniGameDone")
        local inputRemote = constJobRS:FindFirstChild("MiniGameInput")

        local siteUpdate = constJobRS:FindFirstChild("SiteUpdate")
        if siteUpdate then
            Connections.SiteUpdateConn = siteUpdate.OnClientEvent:Connect(function() end)
        end

        if keyRemote then
            Connections.ChallengeKeyConn = keyRemote.OnClientEvent:Connect(function(newKey)
                if activeMiniGame then
                    activeMiniGame.key = newKey
                end
                if State.AutoSolveMinigame and inputRemote and newKey then
                    task.delay(0.06, function()
                        pcall(function() inputRemote:FireServer(newKey) end)
                    end)
                end
            end)
        end



        if mgRemote then
            Connections.MiniGameConn = mgRemote.OnClientEvent:Connect(function(siteType, siteInstance, challengeKey)
                if not State.AutoSolveMinigame or not State.Running then return end

                local minWaitTimes = {
                    NailSite = 3.5,
                    WeldSite = 7.4,
                    DrillSite = 7.4,
                    SweepSite = 1.2,
                    WheelSite = 8.2,
                    OilSite = 5.2,
                    EngineSite = 5.2,
                    Sweep1Site = 1.2,
                    TrashDigSite = 15.2,
                }

                local session = {
                    siteType = siteType,
                    siteInstance = siteInstance,
                    key = challengeKey,
                    startTime = tick(),
                    minWait = minWaitTimes[siteType] or 3.5,
                    completed = false
                }
                activeMiniGame = session

                task.spawn(function()
                    while State.Running and State.AutoSolveMinigame and not session.completed do
                        task.wait(0.12)
                        if session.key and inputRemote then
                            pcall(function() inputRemote:FireServer(session.key) end)
                        end

                        local elapsed = tick() - session.startTime
                        if elapsed >= session.minWait then
                            session.completed = true
                            pcall(function()
                                if doneRemote then
                                    doneRemote:FireServer(session.siteType, session.siteInstance)
                                end
                                local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                                local mgUI = pgui and pgui:FindFirstChild("MiniGameUI")
                                if mgUI then mgUI.Enabled = false end
                            end)
                            ReleaseVIM()
                            break
                        end
                    end
                end)
            end)
        end
    end
end)

-- ควบคุมเมาส์จำลอง VIM & UI Visuals ให้เป็นธรรมชาติ 100%
Connections.MinigameHoldLoop = RunService.Heartbeat:Connect(function()
    if not State.AutoSolveMinigame or not State.Running then
        ReleaseVIM()
        return
    end

    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local mg = pgui and pgui:FindFirstChild("MiniGameUI")
    if mg and mg.Enabled then
        local wf = mg:FindFirstChild("WeldFrame")
        local df = mg:FindFirstChild("DrillFrame")
        local sf = mg:FindFirstChild("SweepFrame")
        local sw = mg:FindFirstChild("Sweep")
        local ef = mg:FindFirstChild("EngineFrame")
        local efOil = ef and ef:FindFirstChild("OilFrame")

        local needsHold = (wf and wf.Visible) or (df and df.Visible) or (sf and sf.Visible) or (sw and sw.Visible) or (efOil and efOil.Visible)
        if needsHold then
            local targetBtn = (wf and wf.Visible and wf:FindFirstChild("WeldBtn"))
                           or (df and df.Visible and (df:FindFirstChild("DrillBtn") or df:FindFirstChild("WeldBtn")))
                           or (sf and sf.Visible and sf:FindFirstChild("FloorBg"))
                           or (sw and sw.Visible and sw:FindFirstChild("FloorBg"))
                           or (efOil and efOil.Visible and efOil:FindFirstChild("OilBtn"))
            local posX, posY = 960, 450
            if targetBtn and targetBtn:IsA("GuiObject") then
                posX = targetBtn.AbsolutePosition.X + targetBtn.AbsoluteSize.X / 2
                posY = targetBtn.AbsolutePosition.Y + targetBtn.AbsoluteSize.Y / 2
            end

            local hrp = GetHRP()
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end

            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                VirtualInputManager:SendMouseButtonEvent(posX, posY, 0, true, game, 0)
                isVIMHolding = true
            end

            if (sf and sf.Visible) or (sw and sw.Visible) then
                local floor = (sf and sf.Visible and sf:FindFirstChild("FloorBg")) or (sw and sw.Visible and sw:FindFirstChild("FloorBg"))
                if floor then
                    local absPos = floor.AbsolutePosition
                    local absSize = floor.AbsoluteSize
                    local sweepT = tick() * 14
                    local moveX = absPos.X + absSize.X * (0.5 + 0.42 * math.sin(sweepT))
                    local moveY = absPos.Y + absSize.Y * (0.5 + 0.35 * math.cos(sweepT * 1.5))
                    VirtualInputManager:SendMouseMoveEvent(moveX, moveY, game)
                end
            end
        else
            ReleaseVIM()
        end
    else
        ReleaseVIM()
    end
end)

-- ตอกตะปู / ล้อรถ / ขุดขยะ / น็อตเครื่องยนต์ / เทน้ำมัน
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(0.12)
        if State.AutoSolveMinigame then
            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
            local mg = pgui and pgui:FindFirstChild("MiniGameUI")
            if mg and mg.Enabled then
                local nf = mg:FindFirstChild("NailFrame")
                if nf and nf.Visible then
                    for i = 1, 4 do
                        local btn = nf:FindFirstChild("NailBtn" .. i)
                        if btn and btn:IsA("GuiButton") then
                            local c = btn.BackgroundColor3
                            local isTarget = (c.R > 0.8 and c.G > 0.6 and c.B < 0.4) or (btn.Size.X.Offset > 88)
                            if isTarget then
                                pcall(function()
                                    if typeof(firesignal) == "function" then
                                        firesignal(btn.MouseButton1Click)
                                    else
                                        local bx = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                                        local by = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2
                                        VirtualInputManager:SendMouseButtonEvent(bx, by, 0, true, game, 0)
                                        task.wait(0.04)
                                        VirtualInputManager:SendMouseButtonEvent(bx, by, 0, false, game, 0)
                                    end
                                end)
                                task.wait(0.18)
                                break
                            end
                        end
                    end
                end

                local tf = mg:FindFirstChild("TrashFrame")
                if tf and tf.Visible then
                    pcall(function()
                        local digResult = ReplicatedStorage.Job:FindFirstChild("ขยะ") and ReplicatedStorage.Job["ขยะ"]:FindFirstChild("DigResult")
                        if digResult then digResult:FireServer(true) end
                    end)
                    task.wait(0.5)
                end

                local wf = mg:FindFirstChild("WheelFrame")
                if wf and wf.Visible then
                    for i = 1, 4 do
                        local btn = wf:FindFirstChild("BoltBtn" .. i)
                        if btn and btn:IsA("GuiButton") and btn.Visible then
                            pcall(function()
                                if typeof(firesignal) == "function" then
                                    firesignal(btn.MouseButton1Click)
                                else
                                    local bx = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                                    local by = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2
                                    VirtualInputManager:SendMouseButtonEvent(bx, by, 0, true, game, 0)
                                    task.wait(0.04)
                                    VirtualInputManager:SendMouseButtonEvent(bx, by, 0, false, game, 0)
                                end
                            end)
                            task.wait(0.15)
                        end
                    end
                    task.wait(0.25)
                end

                local ef = mg:FindFirstChild("EngineFrame")
                local bf2 = ef and ef:FindFirstChild("BoltFrame2")
                if bf2 and bf2.Visible then
                    for i = 1, 3 do
                        local btn = bf2:FindFirstChild("BoltBtn" .. i)
                        if btn and btn:IsA("GuiButton") then
                            local c = btn.BackgroundColor3
                            if c.R > 0.65 and c.G > 0.45 and c.B < 0.35 then
                                pcall(function()
                                    if typeof(firesignal) == "function" then
                                        firesignal(btn.MouseButton1Click)
                                    else
                                        local bx = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                                        local by = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2
                                        VirtualInputManager:SendMouseButtonEvent(bx, by, 0, true, game, 0)
                                        task.wait(0.04)
                                        VirtualInputManager:SendMouseButtonEvent(bx, by, 0, false, game, 0)
                                    end
                                end)
                                task.wait(0.18)
                                break
                            end
                        end
                    end
                end

                local of = mg:FindFirstChild("OilFrame")
                if of and of.Visible then
                    local can = of:FindFirstChild("CanLabel")
                    local spout = of:FindFirstChild("SpoutLabel")
                    if can and spout then
                        can.Position = spout.Position
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------
-- 7. ฟังก์ชันตรวจสอบการทำงาน & หางานทุกสายงาน
--------------------------------------------------------------
local failedSpotCooldowns = {}
local hasCompletedNpcHiring = false

LocalPlayer.CharacterAdded:Connect(function(newChar)
    hasCompletedNpcHiring = false
    SetSprinting(false)
    ClearTargetESP()
    runAnimTrack = nil
    isCurrentlySprinting = false
    cachedRunSystemFn = nil
    task.wait(0.3)
    pcall(function()
        local char = newChar or LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    if part.Name == "Torso" or part.Name == "Head" then
                        part.CanCollide = true
                    else
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    SetSprinting(false)
end)

local function StopWorkAnimations()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                if track.Name == "_WorkAnim" then
                    pcall(function() track:Stop() end)
                end
            end
        end
    end)
end

IsCurrentlyWorking = function()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        local mg = pgui:FindFirstChild("MiniGameUI")
        if mg and mg.Enabled then return true end

        local jlb = pgui:FindFirstChild("JobLoadBar")
        if jlb and jlb.Enabled then return true end

        local clb = pgui:FindFirstChild("CleanLoadBar")
        if clb and clb.Enabled then return true end

        local notif = pgui:FindFirstChild("ConstructNotif")
        local lbl = notif and notif:FindFirstChildOfClass("TextLabel")
        if lbl and lbl.Text:find("กำลังทำงาน") then return true end
    end

    return false
end
Hub.IsCurrentlyWorking = IsCurrentlyWorking
Hub.StopWorkAnimations = StopWorkAnimations

local function GetOtherPlayerPositions()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local oHRP = p.Character:FindFirstChild("HumanoidRootPart")
            if oHRP then
                table.insert(list, oHRP.Position)
            end
        end
    end
    return list
end

local ScannedConstructionSpots = {}

local function IsInConstructionZone(pos)
    if not pos then return false end
    local constJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("งานก่อสร้าง")
    local zb = constJob and constJob:FindFirstChild("Zone") and constJob.Zone:FindFirstChild("ZoneBound")
    if zb and zb:IsA("BasePart") then
        local lp = zb.CFrame:PointToObjectSpace(pos)
        local hs = zb.Size / 2
        return math.abs(lp.X) <= (hs.X + 4) and math.abs(lp.Y) <= (hs.Y + 8) and math.abs(lp.Z) <= (hs.Z + 4)
    end
    local center = Vector3.new(2450.8, 14.2, -357.8)
    local distH = (Vector2.new(pos.X, pos.Z) - Vector2.new(center.X, center.Z)).Magnitude
    return distH <= 75 and math.abs(pos.Y - center.Y) <= 20
end

local function ScanConstructionWorkSpots()
    local constJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("งานก่อสร้าง")
    local workFolder = constJob and constJob:FindFirstChild("งาน")
    local spots = {}
    local counts = { ["กำแพง"] = 0, ["เหล็ก"] = 0, ["หิน"] = 0 }

    if workFolder then
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        if LocalPlayer.Character then
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        end

        for _, cat in ipairs(workFolder:GetChildren()) do
            local catRaw = cat.Name -- "ตะปู", "เหล็ก", "หิน"
            local catName = catRaw
            if catRaw == "ตะปู" then
                catName = "กำแพง"
            end
            if counts[catName] == nil then counts[catName] = 0 end

            for _, item in ipairs(cat:GetChildren()) do
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    local pPart = (prompt.Parent:IsA("BasePart") and prompt.Parent)
                               or (prompt.Parent:IsA("Attachment") and prompt.Parent.Parent:IsA("BasePart") and prompt.Parent.Parent)
                               or (item:IsA("BasePart") and item)
                               or item:FindFirstChildWhichIsA("BasePart", true)

                    if pPart then
                        local spotPos = pPart.Position
                        local standPos = nil
                        local bestStandDist = 999
                        local testAngles = {0, 45, 90, 135, 180, 225, 270, 315}

                        for _, offsetDist in ipairs({2.0, 2.5, 3.0, 3.4}) do
                            for _, deg in ipairs(testAngles) do
                                local rad = math.rad(deg)
                                local offset = Vector3.new(math.cos(rad) * offsetDist, 0, math.sin(rad) * offsetDist)
                                local testP = spotPos + offset
                                local rayDown = Workspace:Raycast(testP + Vector3.new(0, 5, 0), Vector3.new(0, -20, 0), rayParams)
                                if rayDown then
                                    local floorY = rayDown.Position.Y
                                    local hrpY = floorY + 3.0
                                    local candidateHRP = Vector3.new(testP.X, hrpY, testP.Z)
                                    local dist3D = (candidateHRP - spotPos).Magnitude

                                    if dist3D <= 4.4 and dist3D < bestStandDist then
                                        local partsInBox = Workspace:GetPartBoundsInBox(CFrame.new(candidateHRP), Vector3.new(1.8, 3.0, 1.8))
                                        local collides = false
                                        for _, pt in ipairs(partsInBox) do
                                            if pt.CanCollide and pt ~= rayDown.Instance and pt.Size.Y > 1.0 and pt.Name ~= "Ground" and pt.Name ~= "Union" and pt.Name ~= "ZoneBound" then
                                                collides = true
                                                break
                                            end
                                        end

                                        if not collides then
                                            standPos = candidateHRP
                                            bestStandDist = dist3D
                                        end
                                    end
                                end
                            end
                            if standPos then break end
                        end

                        if not standPos then
                            standPos = Vector3.new(spotPos.X, spotPos.Y, spotPos.Z)
                        end

                        counts[catName] = (counts[catName] or 0) + 1
                        table.insert(spots, {
                            category = catName,
                            rawCategory = catRaw,
                            name = item.Name,
                            item = item,
                            part = pPart,
                            spotPos = spotPos,
                            standPos = standPos,
                            prompt = prompt
                        })
                    end
                end
            end
        end
    end

    ScannedConstructionSpots = spots
    return spots, counts
end

local function GetNearestOpenSpot(jobType)
    local hrp = GetHRP()
    if not hrp then return nil, nil, 999999, nil, nil, nil end

    local myPos = hrp.Position
    local bestSpot, bestPrompt, bestDist, bestName, bestPos, bestCategory = nil, nil, 999999, nil, nil, nil
    local now = tick()
    local otherPositions = GetOtherPlayerPositions()

    local function isOccupied(pos)
        for _, oPos in ipairs(otherPositions) do
            if (Vector2.new(oPos.X, oPos.Z) - Vector2.new(pos.X, pos.Z)).Magnitude <= 4.0 then
                return true
            end
        end
        return false
    end

    if jobType == "งานก่อสร้าง" then
        if #ScannedConstructionSpots == 0 then
            ScanConstructionWorkSpots()
        end
        local filter = State.ConstructionFilter or "กำแพง & เหล็ก"

        for _, spotInfo in ipairs(ScannedConstructionSpots) do
            local prompt = spotInfo.prompt
            local part = spotInfo.part
            local cat = spotInfo.category
            local item = spotInfo.item

            -- คัดกรองตามหมวดหมู่ก่อสร้างที่เลือก
            if filter == "เฉพาะกำแพง" and cat ~= "กำแพง" then continue end
            if filter == "เฉพาะเหล็ก" and cat ~= "เหล็ก" then continue end
            if filter == "กำแพง & เหล็ก" and cat ~= "กำแพง" and cat ~= "เหล็ก" then continue end

            local targetObj = item or part
            if prompt and prompt.Enabled and targetObj and targetObj.Parent then
                if not failedSpotCooldowns[targetObj] or now >= failedSpotCooldowns[targetObj] then
                    if not failedSpotCooldowns[part] or now >= failedSpotCooldowns[part] then
                        local standPos = spotInfo.standPos or spotInfo.spotPos
                        if not isOccupied(standPos) and not isOccupied(spotInfo.spotPos) then
                            local d = (myPos - standPos).Magnitude
                            if math.abs(myPos.Y - standPos.Y) <= 6.5 and d < bestDist then
                                bestDist = d
                                bestSpot = targetObj
                                bestPrompt = prompt
                                local icon = (cat == "กำแพง" and "🧱") or (cat == "เหล็ก" and "🔩") or "🪨"
                                bestName = string.format("ก่อสร้าง: %s %s", icon, cat)
                                bestPos = standPos
                                bestCategory = cat
                            end
                        end
                    end
                end
            end
        end

    elseif jobType == "ทำความสะอาด" then
        local cleanJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("ทำความสะอาด")
        if cleanJob then
            for _, spot in ipairs(cleanJob:GetChildren()) do
                local prompt = spot:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    local part = (prompt.Parent:IsA("BasePart") and prompt.Parent) or spot:FindFirstChildWhichIsA("BasePart", true)
                    if part and (not failedSpotCooldowns[part] or now >= failedSpotCooldowns[part]) then
                        local spotPos = (prompt.Parent:IsA("BasePart") and prompt.Parent.Position) or part.Position
                        if not isOccupied(spotPos) then
                            local d = (myPos - spotPos).Magnitude
                            if d < bestDist then
                                bestDist = d
                                bestSpot = part
                                bestPrompt = prompt
                                bestName = "ทำความสะอาด (ถูพื้น)"
                                bestPos = spotPos
                            end
                        end
                    end
                end
            end
        end

    elseif jobType == "ขยะ" then
        local trashJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("ขยะ")
        if trashJob then
            for _, dirty in ipairs(trashJob:GetChildren()) do
                if dirty.Name == "Dirty" or dirty:FindFirstChildWhichIsA("ProximityPrompt", true) then
                    local prompt = dirty:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt and prompt.Enabled then
                        local part = (prompt.Parent:IsA("BasePart") and prompt.Parent) or dirty:FindFirstChildWhichIsA("BasePart", true)
                        if part and (not failedSpotCooldowns[part] or now >= failedSpotCooldowns[part]) then
                            local spotPos = (prompt.Parent:IsA("BasePart") and prompt.Parent.Position) or part.Position
                            if not isOccupied(spotPos) then
                                local d = (myPos - spotPos).Magnitude
                                if d < bestDist then
                                    bestDist = d
                                    bestSpot = part
                                    bestPrompt = prompt
                                    bestName = "เก็บขยะ"
                                    bestPos = spotPos
                                end
                            end
                        end
                    end
                end
            end
        end

    elseif jobType == "ซ่อมรถ" then
        local mechJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("ซ่อมรถ")
        local workFolder = mechJob and mechJob:FindFirstChild("งาน")
        if workFolder then
            for _, car in ipairs(workFolder:GetChildren()) do
                local prompt = car:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    local part = (prompt.Parent:IsA("BasePart") and prompt.Parent) or car:FindFirstChildWhichIsA("BasePart", true)
                    if part and (not failedSpotCooldowns[part] or now >= failedSpotCooldowns[part]) then
                        local spotPos = (prompt.Parent:IsA("BasePart") and prompt.Parent.Position) or part.Position
                        if not isOccupied(spotPos) then
                            local d = (myPos - spotPos).Magnitude
                            if d < bestDist then
                                bestDist = d
                                bestSpot = part
                                bestPrompt = prompt
                                bestName = "ซ่อมรถ: " .. car.Name
                                bestPos = spotPos
                            end
                        end
                    end
                end
            end
        end
    end

    return bestSpot, bestPrompt, bestDist, bestName, bestPos, bestCategory
end

--------------------------------------------------------------
-- 8. ลูปหลัก AUTO FARM PRO (100% ANTI-KICK & RELIABLE)
--------------------------------------------------------------
local lastCollectTime = 0

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(0.08)
        if State.AutoFarm then
            local hrp = GetHRP()
            local hum = GetHuman()
            local char = LocalPlayer.Character
            if not hrp or not hum or not char or hum.Health <= 0 then
                SetSprinting(false)
                ClearTargetESP()
                task.wait(0.5)
                continue
            end

            local curJob = State.SelectedJob or "งานก่อสร้าง"
            local jobNpcPos = Vector3.new(2400.86, 3.16, -372.0)

            -- หากเป็นงานก่อสร้าง และยังไม่ได้ชุดทำงาน -> วิ่งไปที่ไซต์ก่อสร้าง หา NPC ที่นั่งอยู่ แสดง ESP วิ่งไปกดสมัครงาน แล้วรับเสื้อ
            if curJob == "งานก่อสร้าง" and not hasCompletedNpcHiring then
                local shirt = char:FindFirstChildOfClass("Shirt")
                local hasUniform = shirt and shirt.ShirtTemplate:find("105971357123934")

                if not hasUniform then
                    local jobNPC = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("งานก่อสร้าง") and Workspace.Job["งานก่อสร้าง"]:FindFirstChild("NPC") and Workspace.Job["งานก่อสร้าง"].NPC:FindFirstChild("JobNPC")
                    local npcPrompt = jobNPC and jobNPC:FindFirstChildWhichIsA("ProximityPrompt", true)
                    local npcRoot = jobNPC and (jobNPC:FindFirstChild("HumanoidRootPart") or jobNPC:FindFirstChild("Torso") or jobNPC:FindFirstChildWhichIsA("BasePart"))
                    local actualNpcPos = npcRoot and npcRoot.Position or jobNpcPos

                    -- แสดง ESP สีฟ้าสดใสที่ตัว NPC ที่นั่งอยู่
                    SetTargetESP(jobNPC or (Workspace:FindFirstChild("Job") and Workspace.Job["งานก่อสร้าง"].NPC) or Workspace, "สมัครงานรับชุด (JobNPC)", Color3.fromRGB(0, 210, 255))

                    local distToNPC = (hrp.Position - actualNpcPos).Magnitude
                    if distToNPC > 4.2 then
                        -- วิ่งเดินทางไปยังไซต์ก่อสร้างตรงหน้าโต๊ะ NPC
                        NavigateTo(actualNpcPos, 3.2, 40, npcPrompt)
                        continue
                    else
                        -- ถึงหน้าโต๊ะ NPC แล้ว: หยุดนิ่งสนิท 100%
                        SetSprinting(false)
                        hum:Move(Vector3.zero, false)
                        hum:MoveTo(hrp.Position)
                        task.wait(0.25)

                        -- กด ProximityPrompt ที่โต๊ะ/ตัว NPC (เร็วและปลอดภัย ไม่โดนเตะ 267)
                        if npcPrompt and npcPrompt.Enabled then
                            local holdTime = npcPrompt.HoldDuration or 0
                            if holdTime > 0 then
                                pcall(function() npcPrompt:InputHoldBegin() end)
                                local startH = os.clock()
                                while (os.clock() - startH) < holdTime and State.AutoFarm and State.Running do
                                    task.wait(0.03)
                                end
                                pcall(function() fireproximityprompt(npcPrompt) end)
                                pcall(function() npcPrompt:InputHoldEnd() end)
                            else
                                pcall(function() fireproximityprompt(npcPrompt) end)
                            end
                        end
                        task.wait(0.3)

                        -- รอ UI ขึ้นมา แล้วกดปุ่มรับงาน (Hire)
                        pcall(function()
                            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                            local cUI = pgui and pgui:FindFirstChild("ConstructionUI")
                            local mf = cUI and cUI:FindFirstChild("MainFrame")
                            local hp = mf and mf:FindFirstChild("HirePage")
                            local hireBtn = hp and hp:FindFirstChild("HireBtn")
                            if hireBtn and typeof(firesignal) == "function" then
                                firesignal(hireBtn.MouseButton1Click)
                            end
                            local constJobRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
                            if constJobRS and constJobRS:FindFirstChild("Hire") then
                                constJobRS.Hire:InvokeServer()
                            end
                            task.wait(0.3)
                            local closeBtn = mf and mf:FindFirstChild("Header") and mf.Header:FindFirstChild("CloseBtn")
                            if closeBtn and typeof(firesignal) == "function" then
                                firesignal(closeBtn.MouseButton1Click)
                            end
                            if cUI then cUI.Enabled = false end
                        end)

                        -- รอให้ระบบส่งเสื้อและใส่สำเร็จ
                        local waitUniformStart = tick()
                        while (tick() - waitUniformStart) < 3.0 and State.AutoFarm and State.Running do
                            local s = char:FindFirstChildOfClass("Shirt")
                            if s and s.ShirtTemplate:find("105971357123934") then
                                break
                            end
                            task.wait(0.2)
                        end

                        hasCompletedNpcHiring = true
                        ClearTargetESP()
                        Notify("งานก่อสร้าง", "สมัครงานรับชุดเรียบร้อย! เริ่มวิ่งฟาร์มจุดงาน...", "", 2.5)
                        task.wait(0.3)
                        continue
                    end
                else
                    hasCompletedNpcHiring = true
                end
            end

            -- ค้นหาจุดว่างสำหรับงานที่เลือก
            local spot, prompt, dist, spotName, spotPos, spotCategory = GetNearestOpenSpot(curJob)
            if spot and prompt then
                local promptPart = prompt.Parent:IsA("BasePart") and prompt.Parent
                                or (prompt.Parent:IsA("Attachment") and prompt.Parent.Parent:IsA("BasePart") and prompt.Parent.Parent)
                                or spot
                local actualPromptPos = promptPart and promptPart.Position or spotPos

                local promptMaxD = (prompt and prompt.MaxActivationDistance) or 5.0
                local current3DDist = (hrp.Position - actualPromptPos).Magnitude

                if current3DDist > math.min(promptMaxD - 0.5, 4.3) then
                    SetTargetESP(spot, spotName or "จุดทำงาน", nil, "🏃 กำลังไป")
                    local navSuccess = NavigateTo(spotPos, 1.8, 12, prompt)
                    if not navSuccess then
                        failedSpotCooldowns[spot] = tick() + 4.0
                        if promptPart then failedSpotCooldowns[promptPart] = tick() + 4.0 end
                        ClearTargetESP()
                        task.wait(0.08)
                        continue
                    end
                end

                -- เมื่อมาถึงจุดทำงาน (หยุดนิ่งสนิท 100% ก่อนเริ่มงาน ป้องกัน CODE 261 & 264)
                hrp = GetHRP()
                hum = GetHuman()
                local finalDist = (hrp and actualPromptPos) and (hrp.Position - actualPromptPos).Magnitude or 999

                if hrp and hum and prompt and prompt.Enabled and finalDist <= promptMaxD then
                    SetTargetESP(spot, spotName or "จุดทำงาน", nil, "📍 ถึงจุดงาน")
                    SetSprinting(false)
                    hum:Move(Vector3.zero, false)
                    hum.WalkSpeed = 0
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hum:MoveTo(hrp.Position)
                    task.wait(0.05) -- หยุดนิ่งสนิท พร้อมกดทันที

                    -- กดเริ่มงานอย่างรวดเร็วและปลอดภัย (Fast Hold Duration ไม่โดนเตะ 267)
                    local holdTime = prompt.HoldDuration or 0
                    if holdTime > 0 then
                        pcall(function() prompt:InputHoldBegin() end)
                        local startHold = os.clock()
                        while (os.clock() - startHold) < holdTime and State.AutoFarm and State.Running and not IsCurrentlyWorking() do
                            if hrp then
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end
                            task.wait(0.03)
                        end
                        pcall(function() fireproximityprompt(prompt) end)
                        pcall(function() prompt:InputHoldEnd() end)
                    else
                        pcall(function() fireproximityprompt(prompt) end)
                    end

                    -- รอระบบตอบรับการเริ่มงาน
                    local startCheck = tick()
                    while (tick() - startCheck) < 1.8 and State.AutoFarm and State.Running do
                        if IsCurrentlyWorking() then break end
                        task.wait(0.08)
                    end

                    -- ยืนทำงานจนเสร็จสมบูรณ์ 100% โดยล็อคตำแหน่งตัวละครนิ่งสนิท ไม่ให้แรงเฉื่อยหรือฟิสิกส์ขยับ
                    if IsCurrentlyWorking() then
                        SetTargetESP(spot, spotName or "จุดทำงาน", nil, "🔨 กำลังทำงาน")
                        local workStart = tick()
                        local lockCFrame = hrp.CFrame
                        while IsCurrentlyWorking() and (tick() - workStart) < 16 and State.AutoFarm and State.Running do
                            if hrp then
                                hrp.CFrame = lockCFrame
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end
                            if hum then hum.WalkSpeed = 0 end
                            task.wait(0.05)
                        end
                        ReleaseVIM()
                        task.wait(0.3) -- รอเซิร์ฟเวอร์เคลียร์สถานะเสร็จงาน

                        if spotName then
                            if spotName:find("หิน") then
                                Hub.LastCompletedCategory = "หิน"
                            elseif spotName:find("เหล็ก") then
                                Hub.LastCompletedCategory = "เหล็ก"
                            elseif spotName:find("กำแพง") then
                                Hub.LastCompletedCategory = "กำแพง"
                            end
                        end
                        failedSpotCooldowns[spot] = tick() + 4.0
                        if promptPart then failedSpotCooldowns[promptPart] = tick() + 4.0 end
                        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end

                        -- ชี้ ESP ไปยังเป้าหมายถัดไปทันที (ไม่ปล่อยให้หน้าจอว่าง)
                        local nextSpot, nextPrompt, _, nextName, _, nextCat = GetNearestOpenSpot(curJob)
                        if nextSpot then
                            SetTargetESP(nextSpot, nextName or ("ก่อสร้าง: " .. (nextCat or "")), nil, "🎯 เป้าหมายถัดไป")
                        else
                            ClearTargetESP()
                        end
                    else
                        failedSpotCooldowns[spot] = tick() + 4.0
                        if promptPart then failedSpotCooldowns[promptPart] = tick() + 4.0 end
                        ClearTargetESP()
                        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end
                    end
                else
                    failedSpotCooldowns[spot] = tick() + 3.5
                    if promptPart then failedSpotCooldowns[promptPart] = tick() + 3.5 end
                    ClearTargetESP()
                    task.wait(0.08)
                end
            else
                ClearTargetESP()
                task.wait(0.25)
            end

        else
            -- Preview Mode: แสดง ESP นำทางเฉพาะเมื่ออยู่ใน "ขอบเขตฟาร์มใกล้ๆ" เท่านั้น (ไม่แสดงลอยข้ามถนนหรือนอกรั้ว)
            local hrp = GetHRP()
            if State.SelectedJob == "งานก่อสร้าง" then
                local inZone = hrp and IsInConstructionZone(hrp.Position)
                if inZone then
                    local prevSpot, prevPrompt, prevDist, prevName, prevPos, prevCat = GetNearestOpenSpot("งานก่อสร้าง")
                    if prevSpot and prevDist and prevDist <= 45 then
                        local color = (prevCat == "เหล็ก" and Color3.fromRGB(255, 145, 0))
                                   or (prevCat == "กำแพง" and Color3.fromRGB(0, 240, 160))
                                   or Color3.fromRGB(190, 110, 255)
                        local icon = (prevCat == "กำแพง" and "🧱") or (prevCat == "เหล็ก" and "🔩") or "🪨"
                        SetTargetESP(prevSpot, string.format("จุดเริ่มฟาร์ม: %s %s", icon, (prevCat or "ก่อสร้าง")), color, "[พร้อมเริ่มฟาร์ม]")
                    else
                        ClearTargetESP()
                    end
                else
                    ClearTargetESP()
                end
            else
                local prevSpot, prevPrompt, prevDist, prevName = GetNearestOpenSpot(State.SelectedJob)
                if prevSpot and prevDist and prevDist <= 25 then
                    SetTargetESP(prevSpot, string.format("จุดเริ่มฟาร์ม: %s", (prevName or State.SelectedJob)), nil, "[พร้อมเริ่มฟาร์ม]")
                else
                    ClearTargetESP()
                end
            end
            task.wait(0.25)
        end
    end
end)



--------------------------------------------------------------
-- 9. ระบบตัวละคร (CHEATS: SPEED, JUMP, NOCLIP, FLY, INFJUMP, ESP)
--------------------------------------------------------------
RunService.Stepped:Connect(function()
    if State.Running and State.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

Connections.InfJump = UserInputService.JumpRequest:Connect(function()
    if State.Running and State.InfJump then
        local hum = GetHuman()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local flyBV, flyBG = nil, nil
local function StartFly()
    local hrp = GetHRP()
    if not hrp then return end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp

    task.spawn(function()
        while State.Fly and State.Running and hrp and flyBV and flyBG do
            local camCF = Camera.CFrame
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            flyBV.Velocity = moveDir.Magnitude > 0 and (moveDir.Unit * (State.FlySpeed or 50)) or Vector3.zero
            flyBG.CFrame = camCF
            task.wait(0.03)
        end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
    end)
end

local function StopFly()
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

--------------------------------------------------------------
-- 👁️ ระบบมองทะลุผู้เล่น & แยกสีสถาบัน (FLICKER-FREE PLAYER ESP)
-- 1. ปทุมคงคา: ฟ้า (Color3.fromRGB(0, 195, 255))
-- 2. กรุงเทพช่างกล: สีเหลืองอ่อน (Color3.fromRGB(255, 240, 130))
-- 3. พระ: สีส้ม (Color3.fromRGB(255, 135, 30))
-- 4. เด็กบ้าน: สีขาว (Color3.fromRGB(245, 245, 245))
-- 5. ตำรวจ: สีแดง (Color3.fromRGB(255, 45, 45))
--------------------------------------------------------------
local SchoolConfigs = {
    { Key = "ปทุมคงคา", Short = "ปทุมคงคา", Color = Color3.fromRGB(0, 195, 255), Icon = "⚡" },
    { Key = "กรุงเทพช่างกล", Short = "ช่างกล", Color = Color3.fromRGB(255, 240, 130), Icon = "🔧" },
    { Key = "พระ", Short = "พระ", Color = Color3.fromRGB(255, 135, 30), Icon = "🙏" },
    { Key = "เด็กบ้าน", Short = "เด็กบ้าน", Color = Color3.fromRGB(245, 245, 245), Icon = "🏠" },
    { Key = "ตำรวจ", Short = "ตำรวจ", Color = Color3.fromRGB(255, 45, 45), Icon = "👮" },
    { Key = "วัดสุ", Short = "วัดสุทธิ", Color = Color3.fromRGB(80, 230, 180), Icon = "📚" },
    { Key = "สุธิ", Short = "วัดสุทธิ", Color = Color3.fromRGB(80, 230, 180), Icon = "📚" },
    { Key = "สุทธิ", Short = "วัดสุทธิ", Color = Color3.fromRGB(80, 230, 180), Icon = "📚" },
}

local function GetPlayerSchoolInfo(plr)
    local rawTeamName = ""
    if plr.Team then
        rawTeamName = tostring(plr.Team.Name)
    end
    if rawTeamName == "" and plr.Character then
        for _, d in ipairs(plr.Character:GetDescendants()) do
            if d:IsA("TextLabel") and d.Visible and d.Text and d.Text ~= "" then
                for _, sc in ipairs(SchoolConfigs) do
                    if string.find(d.Text, sc.Key, 1, true) then
                        rawTeamName = sc.Key
                        break
                    end
                end
                if rawTeamName ~= "" then break end
            end
        end
    end
    for _, sc in ipairs(SchoolConfigs) do
        if string.find(rawTeamName, sc.Key, 1, true) then
            return sc.Color, sc.Short, sc.Icon
        end
    end
    return Color3.fromRGB(46, 204, 113), rawTeamName ~= "" and rawTeamName or "ประชาชน", "👤"
end

local function GetEquippedWeaponInfo(char)
    if not char then return "👊 มือเปล่า", Color3.fromRGB(180, 180, 180) end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        return "👊 มือเปล่า", Color3.fromRGB(180, 180, 180)
    end
    local name = tool.Name or ""
    local lower = string.lower(name)
    if lower == "fists" or lower == "fist" or name == "หมัด" or name == "มือเปล่า" then
        return "👊 มือเปล่า", Color3.fromRGB(180, 180, 180)
    end
    if lower:find("glock") or lower:find("beretta") or lower:find("m9") or lower:find("deagle") 
        or lower:find("remington") or lower:find("shotgun") or lower:find("pistol") or lower:find("rifle") 
        or lower:find("smg") or lower:find("gun") or name:find("ปืน") or lower:find("uzi") or lower:find("colt")
        or lower:find("ak") or lower:find("m4") or lower:find("revolver") or lower:find("ลูกซอง") then
        return "🔫 " .. name, Color3.fromRGB(255, 85, 85)
    end
    if name:find("มีด") or name:find("ดาบ") or name:find("ขวาน") or lower:find("knife") or lower:find("blade") 
        or lower:find("katana") or lower:find("axe") or lower:find("machete") or lower:find("sword") then
        return "🔪 " .. name, Color3.fromRGB(255, 145, 50)
    end
    if name:find("กระบอง") or name:find("ไม้") or lower:find("bat") or lower:find("baton") or lower:find("club") then
        return "🏏 " .. name, Color3.fromRGB(255, 215, 0)
    end
    if name:find("โล่") or lower:find("shield") then
        return "🛡️ " .. name, Color3.fromRGB(100, 200, 255)
    end
    return "📦 " .. name, Color3.fromRGB(220, 220, 220)
end

local function GetHealthVisuals(hum)
    local hp = math.max(0, hum and hum.Health or 0)
    local maxHp = math.max(1, hum and hum.MaxHealth or 100)
    local ratio = math.clamp(hp / maxHp, 0, 1)
    local col
    if ratio > 0.70 then
        col = Color3.fromRGB(46, 204, 113)
    elseif ratio > 0.35 then
        col = Color3.fromRGB(243, 156, 18)
    else
        col = Color3.fromRGB(231, 76, 60)
    end
    return hp, maxHp, ratio, col
end

local function ClearPlayerESP()
    for p, entry in pairs(Hub.PlayerESPRegistry) do
        if entry.Billboard then pcall(function() entry.Billboard:Destroy() end) end
        if entry.Highlight then pcall(function() entry.Highlight:Destroy() end) end
    end
    table.clear(Hub.PlayerESPRegistry)
end

local function UpdateESP()
    if not State.ESP or not State.Running then
        if next(Hub.PlayerESPRegistry) then ClearPlayerESP() end
        return
    end

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    local currentPlayers = {}

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            currentPlayers[p] = true
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            local isValid = char and hrp and hum and hum.Health > 0
            local dist = isValid and (hrp.Position - myHrp.Position).Magnitude or 999999
            local inRange = isValid and dist <= (State.ESPMaxDistance or 500)

            local entry = Hub.PlayerESPRegistry[p]

            if not inRange then
                if entry then
                    if entry.Billboard then entry.Billboard.Enabled = false end
                    if entry.Highlight then entry.Highlight.Enabled = false end
                end
            else
                if not entry or entry.Character ~= char or not entry.Billboard or not entry.Billboard.Parent or not entry.Highlight or not entry.Highlight.Parent then
                    if entry then
                        if entry.Billboard then pcall(function() entry.Billboard:Destroy() end) end
                        if entry.Highlight then pcall(function() entry.Highlight:Destroy() end) end
                    end

                    local hl = Instance.new("Highlight")
                    hl.Name = "KrakenESP_HL_" .. p.Name
                    hl.Adornee = char
                    hl.FillTransparency = 0.55
                    hl.OutlineTransparency = 0.2
                    hl.Parent = targetGuiParent

                    local bb = Instance.new("BillboardGui")
                    bb.Name = "KrakenESP_BB_" .. p.Name
                    bb.Adornee = hrp
                    bb.Size = UDim2.new(0, 160, 0, 58)
                    bb.StudsOffset = Vector3.new(0, 3.4, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = targetGuiParent

                    local frame = Instance.new("Frame", bb)
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundTransparency = 0.35
                    frame.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
                    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
                    local stroke = Instance.new("UIStroke", frame)
                    stroke.Thickness = 1.2
                    stroke.Transparency = 0.3

                    local nameLbl = Instance.new("TextLabel", frame)
                    nameLbl.Size = UDim2.new(1, -10, 0, 16)
                    nameLbl.Position = UDim2.new(0, 5, 0, 2)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.TextSize = 11
                    nameLbl.TextStrokeTransparency = 0.5

                    local infoLbl = Instance.new("TextLabel", frame)
                    infoLbl.Size = UDim2.new(1, -10, 0, 13)
                    infoLbl.Position = UDim2.new(0, 5, 0, 18)
                    infoLbl.BackgroundTransparency = 1
                    infoLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
                    infoLbl.Font = Enum.Font.GothamMedium
                    infoLbl.TextSize = 10
                    infoLbl.TextStrokeTransparency = 0.5

                    local wepLbl = Instance.new("TextLabel", frame)
                    wepLbl.Size = UDim2.new(1, -10, 0, 13)
                    wepLbl.Position = UDim2.new(0, 5, 0, 31)
                    wepLbl.BackgroundTransparency = 1
                    wepLbl.Font = Enum.Font.GothamBold
                    wepLbl.TextSize = 10
                    wepLbl.TextStrokeTransparency = 0.5

                    local hpBg = Instance.new("Frame", frame)
                    hpBg.Size = UDim2.new(1, -12, 0, 4)
                    hpBg.Position = UDim2.new(0, 6, 0, 48)
                    hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                    hpBg.BorderSizePixel = 0
                    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

                    local hpFill = Instance.new("Frame", hpBg)
                    hpFill.BorderSizePixel = 0
                    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

                    entry = {
                        Highlight = hl,
                        Billboard = bb,
                        Stroke = stroke,
                        NameLabel = nameLbl,
                        InfoLabel = infoLbl,
                        WeaponLabel = wepLbl,
                        HealthBg = hpBg,
                        HealthFill = hpFill,
                        Player = p,
                        Character = char,
                    }
                    Hub.PlayerESPRegistry[p] = entry
                end

                local schoolCol, schoolShort, schoolIcon = GetPlayerSchoolInfo(p)
                local wepText, wepCol = GetEquippedWeaponInfo(char)
                local hp, maxHp, hpRatio, hpCol = GetHealthVisuals(hum)

                entry.Highlight.Enabled = true
                entry.Billboard.Enabled = true
                entry.Billboard.MaxDistance = State.ESPMaxDistance or 500

                entry.Highlight.FillColor = schoolCol
                entry.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                entry.Stroke.Color = schoolCol

                entry.NameLabel.TextColor3 = schoolCol
                entry.NameLabel.Text = string.format("[%s %s] %s", schoolIcon, schoolShort, p.DisplayName)

                if State.ESPShowDistance then
                    entry.InfoLabel.Text = string.format("%d HP • %d studs (%.0fm)", math.floor(hp), math.floor(dist), dist * 0.28)
                    entry.InfoLabel.Visible = true
                else
                    entry.InfoLabel.Text = string.format("%d / %d HP", math.floor(hp), math.floor(maxHp))
                    entry.InfoLabel.Visible = true
                end

                if State.ESPShowWeapon then
                    entry.WeaponLabel.Text = string.format("[%s]", wepText)
                    entry.WeaponLabel.TextColor3 = wepCol
                    entry.WeaponLabel.Visible = true
                else
                    entry.WeaponLabel.Visible = false
                end

                if State.ESPShowHealthBar then
                    entry.HealthBg.Visible = true
                    entry.HealthFill.Size = UDim2.new(hpRatio, 0, 1, 0)
                    entry.HealthFill.BackgroundColor3 = hpCol
                else
                    entry.HealthBg.Visible = false
                end
            end
        end
    end

    for p, entry in pairs(Hub.PlayerESPRegistry) do
        if not currentPlayers[p] or not p.Parent then
            if entry.Billboard then pcall(function() entry.Billboard:Destroy() end) end
            if entry.Highlight then pcall(function() entry.Highlight:Destroy() end) end
            Hub.PlayerESPRegistry[p] = nil
        end
    end
end

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        if State.ESP then
            pcall(UpdateESP)
            task.wait(0.05)
        else
            if next(Hub.PlayerESPRegistry) then
                ClearPlayerESP()
            end
            task.wait(0.3)
        end
    end
end)



--------------------------------------------------------------
-- 10. ระบบความแม่นยำของปืน & ไร้แรงดีด (GUN ACCURACY / NO SPREAD / NO RECOIL / NO BULLET DROP)
--------------------------------------------------------------
local function EnhanceGun(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        -- 1. ปิด Shake ของปืน (กล้องสั่นไหวเวลาเล็ง/ยิง)
        local shake = tool:FindFirstChild("Shake")
        if shake and shake:IsA("LocalScript") then
            shake.Enabled = not (State.NoRecoil and State.Running)
        end

        -- 2. ปรับแต่งโมดูล Setting ของ FE Gun Kit
        local settingMod = tool:FindFirstChild("Setting")
        if settingMod and settingMod:IsA("ModuleScript") then
            local s = require(settingMod)
            if type(s) == "table" then
                -- 🎯 ยิงตรงจุด 100% (No Spread & Shotgun Spread = 0)
                if (State.NoSpread or State.SilentAim) and State.Running then
                    s.Spread = 0
                    s.MinSpread = 0
                    s.MaxSpread = 0
                    s.SpreadRedutionS = 0
                    s.SpreadRedutionIS = 0
                    s.BulletBloom = 0
                    s.CrossExpansion = 0
                    s.ShotgunPattern = false
                    if type(s.SpreadPattern) == "table" then
                        for _, pt in ipairs(s.SpreadPattern) do
                            if type(pt) == "table" then
                                pt[1] = 0
                                pt[2] = 0
                            end
                        end
                    end
                    if type(s.ChargeAlterTable) == "table" and type(s.ChargeAlterTable.Spread) == "table" then
                        s.ChargeAlterTable.Spread.Level1 = 0
                        s.ChargeAlterTable.Spread.Level2 = 0
                        s.ChargeAlterTable.Spread.Level3 = 0
                    end
                end

                -- 🛑 ปืนนิ่งสนิท ไร้แรงถีบ (No Recoil & No Camera Recoiling)
                if State.NoRecoil and State.Running then
                    s.Recoil = 0
                    s.CameraRecoilingEnabled = false
                    s.ViewmodelRecoilInfluence = 0
                    s.RecoilDamper = 0
                    s.RecoilSpeed = 0
                    s.AngleX_Min = 0
                    s.AngleX_Max = 0
                    s.AngleY_Min = 0
                    s.AngleY_Max = 0
                    s.AngleZ_Min = 0
                    s.AngleZ_Max = 0
                    s.ScopeSwaySpeed = 0
                    s.ScopeSwayDamper = 0
                    s.ScopeKnockbackSpeed = 0
                    s.DropXMin = 0
                    s.DropYMax = 0
                    s.XMax = 0
                    s.YMax = 0
                end

                -- ⚡ กระสุนพุ่งตรง ไม่ย้อยตามแรงโน้มถ่วง (No Bullet Drop)
                if (State.FastBullet or State.SilentAim) and State.Running then
                    s.BulletAcceleration = Vector3.zero
                    if type(s.ChargeAlterTable) == "table" and type(s.ChargeAlterTable.BulletAcceleration) == "table" then
                        s.ChargeAlterTable.BulletAcceleration.Level1 = Vector3.zero
                        s.ChargeAlterTable.BulletAcceleration.Level2 = Vector3.zero
                        s.ChargeAlterTable.BulletAcceleration.Level3 = Vector3.zero
                    end
                    if (s.BulletSpeed or 0) < 4000 then
                        s.BulletSpeed = 5000
                    end
                end
            end
        end
    end)
end

local function ApplyGunMods()
    if not State.Running then return end
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") then
                    EnhanceGun(item)
                end
            end
        end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, item in ipairs(bp:GetChildren()) do
                if item:IsA("Tool") then
                    EnhanceGun(item)
                end
            end
        end
    end)
end

-- ดักจับเมื่อถือปืนใหม่หรือเก็บปืนเข้ากระเป๋า
local function HookInventoryForGuns()
    pcall(function()
        if Connections.CharGunHook then Connections.CharGunHook:Disconnect() end
        if Connections.BpGunHook then Connections.BpGunHook:Disconnect() end

        local char = LocalPlayer.Character
        if char then
            Connections.CharGunHook = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.05)
                    EnhanceGun(child)
                end
            end)
        end

        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            Connections.BpGunHook = bp.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.05)
                    EnhanceGun(child)
                end
            end)
        end
    end)
end

HookInventoryForGuns()
Connections.CharAddedGunHook = LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    HookInventoryForGuns()
    ApplyGunMods()
end)

-- เฝ้าดูและปรับแต่งปืนที่ถืออยู่ทุก 1.5 วินาที
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        pcall(ApplyGunMods)
        task.wait(1.5)
    end
end)

--------------------------------------------------------------
-- 🎯 ปรับแต่งทิศทางกระสุน & B3 SILENT AIM SYSTEM
--------------------------------------------------------------
local fovCircle = nil
pcall(function()
    if typeof(Drawing) == "table" and typeof(Drawing.new) == "function" then
        fovCircle = Drawing.new("Circle")
        fovCircle.Thickness = 1.5
        fovCircle.NumSides = 48
        fovCircle.Radius = State.CombatFOV or 150
        fovCircle.Filled = false
        fovCircle.Color = Color3.fromRGB(255, 60, 60)
        fovCircle.Transparency = 0.8
        fovCircle.Visible = false
    end
end)

local function GetAimCenter()
    local cam = Workspace.CurrentCamera
    if not cam then return Vector2.new(0, 0) end
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local gunGui = pgui and pgui:FindFirstChild("GunGUI")
    local crosshair = gunGui and gunGui:FindFirstChild("Crosshair")
    if crosshair and crosshair.Visible and crosshair.AbsolutePosition.X > 0 then
        return crosshair.AbsolutePosition + (crosshair.AbsoluteSize / 2)
    end
    local uis = UserInputService
    if uis.MouseBehavior == Enum.MouseBehavior.LockCenter or (cam.Focus.p - cam.CFrame.p).Magnitude <= 1 then
        return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    end
    local mouse = LocalPlayer:GetMouse()
    return Vector2.new(mouse.X, mouse.Y)
end

Connections.FOVCircleLoop = RunService.RenderStepped:Connect(function()
    if fovCircle then
        local cam = Workspace.CurrentCamera
        local shouldShow = State.Running and State.SilentAim and State.DrawFOV and cam ~= nil
        fovCircle.Visible = shouldShow
        if shouldShow then
            fovCircle.Radius = State.CombatFOV or 150
            fovCircle.Position = GetAimCenter()
        end
    end
end)

local function IsWallClear(origin, targetPart, targetChar)
    local diff = (targetPart.Position - origin)
    local dist = diff.Magnitude
    if dist <= 0.1 then return true end
    local dir = diff.Unit

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    local ignore = {LocalPlayer.Character, Workspace.CurrentCamera}
    rayParams.FilterDescendantsInstances = ignore

    local curOrigin = origin
    local remainingDist = dist

    for _ = 1, 8 do
        local result = Workspace:Raycast(curOrigin, dir * remainingDist, rayParams)
        if not result then
            return true
        end

        local hitPart = result.Instance
        if hitPart:IsDescendantOf(targetChar) then
            return true
        end

        -- ตรวจสอบวัตถุโปร่งแสง เอฟเฟกต์ หรือโซนที่ไม่มี collision
        if (not hitPart.CanCollide) or hitPart.Transparency > 0.75 or hitPart.Name == "BloodWound" or hitPart.Name == "ExplosionCrater" then
            table.insert(ignore, hitPart)
            rayParams.FilterDescendantsInstances = ignore
            curOrigin = result.Position + (dir * 0.1)
            remainingDist = (targetPart.Position - curOrigin).Magnitude
            if remainingDist <= 0.5 then return true end
        else
            return false
        end
    end

    return false
end

local function GetAimTarget(firePos)
    if not State.SilentAim then return nil end

    -- อัตราความแม่นยำ (Hit Chance %)
    local hitChance = State.SilentHitChance or 100
    if hitChance < 100 and math.random(1, 100) > hitChance then
        return nil
    end

    local cam = Workspace.CurrentCamera
    if not cam then return nil end

    local centerPos = GetAimCenter()
    local maxFOV = State.CombatFOV or 150
    local partChoice = State.SilentPart or "Head"

    local bestTargetPos = nil
    local bestScreenDist = maxFOV + 1

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrp then
                local targetPart = (partChoice == "Head" and char:FindFirstChild("Head"))
                                or (partChoice == "Torso" and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")))
                                or (partChoice == "HumanoidRootPart" and hrp)
                                or char:FindFirstChild("Head")
                                or hrp

                if targetPart then
                    local sPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                    if onScreen and sPos.Z > 0 then
                        local sDist = (Vector2.new(sPos.X, sPos.Y) - centerPos).Magnitude
                        if sDist <= maxFOV and sDist < bestScreenDist then
                            local clear = true
                            if State.SilentWallCheck then
                                clear = IsWallClear(firePos, targetPart, char)
                            end

                            if clear then
                                bestScreenDist = sDist
                                local finalPos = targetPart.Position
                                if State.SilentVelocity then
                                    local targetHRP = char:FindFirstChild("HumanoidRootPart")
                                    if targetHRP and targetHRP.AssemblyLinearVelocity.Magnitude > 0.5 then
                                        local dist3D = (finalPos - firePos).Magnitude
                                        local leadTime = math.clamp(dist3D / 6000, 0, 0.12)
                                        finalPos = finalPos + (targetHRP.AssemblyLinearVelocity * leadTime)
                                    end
                                end
                                bestTargetPos = finalPos
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTargetPos
end

local originalSimulateProjectile = _G._KrakenOriginalSimulateProjectile
pcall(function()
    local phMod = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("ProjectileHandler")
    if phMod then
        local ph = require(phMod)
        if ph and ph.SimulateProjectile then
            if not originalSimulateProjectile then
                originalSimulateProjectile = ph.SimulateProjectile
                _G._KrakenOriginalSimulateProjectile = originalSimulateProjectile
            end
            ph.SimulateProjectile = function(self, p128, p129, p130, p131, p132, p133, p134, p135, p136, p137, p138, p139, p140, p141)
                -- 🛑 กรองความปลอดภัย: แก้ไขเฉพาะกระสุนที่ยิงจากปืนของตัวเรา (LocalPlayer) เท่านั้น
                -- ป้องกันไม่ให้วิถีกระสุนของคนอื่นในเซิร์ฟเวอร์ถูกดึงหรือเลี้ยวมาหาเราโดยเด็ดขาด 100%
                local char = LocalPlayer.Character
                local isLocalShooter = false
                if char then
                    for _, obj in ipairs({p129, p130, p131, p134}) do
                        if obj and typeof(obj) == "Instance" and obj:IsDescendantOf(char) then
                            isLocalShooter = true
                            break
                        end
                    end
                    if not isLocalShooter then
                        local currentTool = char:FindFirstChildOfClass("Tool")
                        if currentTool and (
                            (p129 and typeof(p129) == "Instance" and (p129 == currentTool or p129:IsDescendantOf(currentTool))) or
                            (p131 and typeof(p131) == "Instance" and (p131 == currentTool or p131:IsDescendantOf(currentTool))) or
                            (p134 and typeof(p134) == "Instance" and (p134 == currentTool or p134:IsDescendantOf(currentTool)))
                        ) then
                            isLocalShooter = true
                        end
                    end
                end

                if State.Running and isLocalShooter and p134 then
                    local firePos = (p131 and p131:FindFirstChild("GunFirePoint") and p131:FindFirstChild("GunFirePoint").WorldPosition)
                                 or (p134 and p134.WorldPosition)
                                 or (char and char:FindFirstChild("Head") and char.Head.Position)

                    if firePos then
                        local targetPos = nil
                        if State.SilentAim then
                            targetPos = GetAimTarget(firePos)
                        end

                        if targetPos then
                            local trueDir = (targetPos - firePos).Unit
                            if type(p132) == "table" then
                                for i = 1, #p132 do p132[i] = trueDir end
                            end
                            if type(p133) == "table" then
                                for i = 1, #p133 do p133[i] = trueDir end
                            end
                            -- กำจัดแรงโน้มถ่วงกระสุนย้อย & เร่งความเร็วสูง เพื่อให้พุ่งเข้าเป้าหมายแบบเลเซอร์บีม 100%
                            if type(p139) == "table" then
                                p139[2] = Vector3.zero
                                if (p139[1] or 0) < 5000 then p139[1] = 6000 end
                            end
                        elseif State.NoSpread then
                            local cam = Workspace.CurrentCamera
                            local center = GetAimCenter()
                            local screenRay = cam:ViewportPointToRay(center.X, center.Y)
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {char, cam}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local hit = Workspace:Raycast(screenRay.Origin, screenRay.Direction * 3000, rayParams)
                            local hitPos = hit and hit.Position or (screenRay.Origin + screenRay.Direction * 2000)
                            local straightDir = (hitPos - firePos).Unit
                            if type(p132) == "table" then
                                for i = 1, #p132 do p132[i] = straightDir end
                            end
                            if type(p133) == "table" then
                                for i = 1, #p133 do p133[i] = straightDir end
                            end
                        end

                        if State.FastBullet and type(p139) == "table" then
                            p139[2] = Vector3.zero
                            if (p139[1] or 0) < 5000 then p139[1] = 6000 end
                        end
                    end
                end
                return originalSimulateProjectile(self, p128, p129, p130, p131, p132, p133, p134, p135, p136, p137, p138, p139, p140, p141)
            end
        end
    end
end)



--------------------------------------------------------------
-- 🛒 11. ระบบติดตาม & จัดการพ่อค้าพเนจร (WANDERING MERCHANT TRACKER & ESP)
--------------------------------------------------------------
local MerchantData = {
    IsOpen = false,
    RemainingTime = 0,
    ShopName = "พ่อค้าพเนจร",
    LocationName = "จุดลับ",
    Model = nil,
    RootPart = nil,
    Distance = 0,
    NextSpawnTime = 0,
}
local MerchantESPObjects = {}

local function GetMerchantCycleTime()
    local uptime = workspace.DistributedGameTime or 0
    local cyclePos = uptime % 1800
    if cyclePos < 1200 then
        -- ช่วงร้านปิด: เหลือเวลาอีกกี่วินาทีก่อนจะเกิดรอบถัดไป
        return false, math.max(0, math.floor(1200 - cyclePos))
    else
        -- ช่วงร้านเปิด: เหลือเวลาอีกกี่วินาทีก่อนจะปิดร้าน
        return true, math.max(0, math.floor(1800 - cyclePos))
    end
end

local function FindMerchantNPC()
    -- 1. ค้นหาโมเดลที่มีชื่อ SecretShopNPC ใน Workspace
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.find(obj.Name, "SecretShopNPC") then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
            if hrp then
                return obj, hrp
            end
        end
    end

    -- 2. ค้นหาจาก ProximityPrompt ที่มีข้อความ "พ่อค้าพเนจร"
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.ObjectText == "พ่อค้าพเนจร" then
            local part = desc.Parent:IsA("BasePart") and desc.Parent
                      or (desc.Parent:IsA("Attachment") and desc.Parent.Parent:IsA("BasePart") and desc.Parent.Parent)
                      or (desc.Parent and desc.Parent:FindFirstChild("HumanoidRootPart"))
            if part then
                local model = part:FindFirstAncestorOfClass("Model") or part
                return model, part
            end
        end
    end

    return nil, nil
end

local function ClearMerchantESP()
    for _, obj in ipairs(MerchantESPObjects) do
        pcall(function() obj:Destroy() end)
    end
    table.clear(MerchantESPObjects)
end

local function UpdateMerchantESP()
    if not State.MerchantESP or not State.Running then
        ClearMerchantESP()
        return
    end

    local model, hrp = FindMerchantNPC()
    if not model or not hrp then
        ClearMerchantESP()
        return
    end

    local existingBB = hrp:FindFirstChild("MerchantBillboard")
    local existingHL = model:FindFirstChild("MerchantHighlight")

    if not existingHL then
        local hl = Instance.new("Highlight")
        hl.Name = "MerchantHighlight"
        hl.FillColor = Color3.fromRGB(255, 215, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.35
        hl.OutlineTransparency = 0
        hl.Adornee = model
        hl.Parent = model
        table.insert(MerchantESPObjects, hl)
    end

    if not existingBB then
        local bb = Instance.new("BillboardGui")
        bb.Name = "MerchantBillboard"
        bb.Adornee = hrp
        bb.Size = UDim2.new(0, 210, 0, 54)
        bb.StudsOffset = Vector3.new(0, 3.8, 0)
        bb.AlwaysOnTop = true

        local frame = Instance.new("Frame", bb)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.BackgroundTransparency = 0.25
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(255, 215, 0)
        stroke.Thickness = 1.5
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 6)

        local titleLbl = Instance.new("TextLabel", frame)
        titleLbl.Size = UDim2.new(1, 0, 0, 24)
        titleLbl.Position = UDim2.new(0, 0, 0, 2)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 12
        titleLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
        titleLbl.Text = "🛒 พ่อค้าพเนจร (Secret Shop)"

        local subLbl = Instance.new("TextLabel", frame)
        subLbl.Name = "SubInfo"
        subLbl.Size = UDim2.new(1, 0, 0, 22)
        subLbl.Position = UDim2.new(0, 0, 0, 26)
        subLbl.BackgroundTransparency = 1
        subLbl.Font = Enum.Font.GothamMedium
        subLbl.TextSize = 11
        subLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
        subLbl.Text = "กำลังคำนวณระยะห่าง..."

        bb.Parent = hrp
        table.insert(MerchantESPObjects, bb)
        existingBB = bb
    end

    if existingBB then
        local subLbl = existingBB:FindFirstChild("Frame") and existingBB.Frame:FindFirstChild("SubInfo")
        if subLbl then
            local myHRP = GetHRP()
            local dist = myHRP and math.floor((myHRP.Position - hrp.Position).Magnitude) or 0
            local timeStr = ""
            if MerchantData.RemainingTime > 0 then
                timeStr = string.format(" | ⏱️ %d:%02d", math.floor(MerchantData.RemainingTime / 60), math.floor(MerchantData.RemainingTime % 60))
            end
            subLbl.Text = string.format("📍 %d studs%s", dist, timeStr)
        end
    end
end

local function TeleportToMerchant()
    local model, hrp = FindMerchantNPC()
    if not model or not hrp then
        Notify("พ่อค้าพเนจร", "ไม่พบพ่อค้าพเนจรในเซิร์ฟเวอร์ (ร้านอาจยังไม่เปิด)", "", 3)
        return false
    end

    local myHRP = GetHRP()
    local myHum = GetHuman()
    if not myHRP or not myHum then
        Notify("ข้อผิดพลาด", "ไม่พบตัวละครของคุณ", "", 3)
        return false
    end

    local targetPos = hrp.Position + (hrp.CFrame.LookVector * 3.5)
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    myHRP.CFrame = CFrame.lookAt(targetPos, hrp.Position)
    task.wait(0.05)
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero

    Notify("พ่อค้าพเนจร", "วาร์ปมาถึงพ่อค้าพเนจรเรียบร้อย!", "", 3)
    return true
end



-- เชื่อมต่อระบบ Event ของพ่อค้าพเนจร
pcall(function()
    local Black = ReplicatedStorage:WaitForChild("Shop", 5):WaitForChild("Black", 5)
    if Black then
        local SecretShopTimer = Black:FindFirstChild("SecretShopTimer")
        if SecretShopTimer then
            Connections.SecretShopTimer = SecretShopTimer.OnClientEvent:Connect(function(remainingSec, shopName)
                MerchantData.IsOpen = true
                MerchantData.RemainingTime = remainingSec
                MerchantData.ShopName = shopName or "พ่อค้าพเนจร"
                if State.AutoNotifyMerchant then
                    Notify("🛒 พ่อค้าพเนจรเปิดร้าน!", string.format("เหลือเวลาอีก %d นาที %02d วินาที", math.floor(remainingSec / 60), math.floor(remainingSec % 60)), "เปิดเมนูเพื่อวาร์ปหรือเปิดร้าน", 5)
                end
            end)
        end

        local SecretShopAnnounce = Black:FindFirstChild("SecretShopAnnounce")
        if SecretShopAnnounce then
            Connections.SecretShopAnnounce = SecretShopAnnounce.OnClientEvent:Connect(function(state, locName, duration)
                if state == "open" then
                    MerchantData.IsOpen = true
                    MerchantData.LocationName = locName or "จุดลับ"
                    MerchantData.RemainingTime = duration or 600
                    if State.AutoNotifyMerchant then
                        Notify("🛒 พ่อค้าพเนจรมาถึงแล้ว!", "อยู่ที่: " .. tostring(locName), "เปิดเมนูเพื่อตรวจสอบตำแหน่ง", 5)
                    end
                elseif state == "close" then
                    MerchantData.IsOpen = false
                    MerchantData.RemainingTime = 0
                    MerchantData.NextSpawnTime = os.clock() + (duration or 1200)
                    ClearMerchantESP()
                    if State.AutoNotifyMerchant then
                        Notify("🛒 พ่อค้าพเนจรปิดร้านแล้ว", string.format("จะกลับมาใหม่ในอีกประมาณ %d นาที", math.floor((duration or 1200) / 60)), "", 4)
                    end
                end
            end)
        end
    end
end)

local function GetMerchantStatusDisplay()
    local model, hrp = FindMerchantNPC()
    MerchantData.Model = model
    MerchantData.RootPart = hrp

    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local gunShop = pgui and pgui:FindFirstChild("GunShopGui")
    local tf = gunShop and gunShop:FindFirstChild("TimerFrame")
    if tf and tf.Visible then
        MerchantData.IsOpen = true
        local tl = tf:FindFirstChild("TimerLabel")
        if tl and tl.Text ~= "" then
            local m, s = string.match(tl.Text, "(%d+):(%d+)")
            if m and s then
                MerchantData.RemainingTime = tonumber(m) * 60 + tonumber(s)
            end
        end
    elseif model then
        MerchantData.IsOpen = true
    else
        MerchantData.IsOpen = false
    end

    local myHRP = GetHRP()
    if myHRP and hrp then
        MerchantData.Distance = math.floor((myHRP.Position - hrp.Position).Magnitude)
    else
        MerchantData.Distance = 0
    end

    local isCycleOpen, cycleSec = GetMerchantCycleTime()
    local isActuallyOpen = MerchantData.IsOpen or (model ~= nil) or (tf and tf.Visible) or isCycleOpen

    local title = isActuallyOpen and "🛒 พ่อค้าพเนจร: เปิดร้านอยู่ (OPEN)" or "⏳ พ่อค้าพเนจร: ปิดร้านแล้ว (CLOSED)"
    local timeDesc = ""

    if isActuallyOpen then
        local rem = (MerchantData.RemainingTime > 0) and MerchantData.RemainingTime or cycleSec
        local m = math.floor(rem / 60)
        local s = math.floor(rem % 60)
        timeDesc = string.format("• ⏱️ เวลาที่เหลือ: %d นาที %02d วินาที", m, s)
    else
        if MerchantData.NextSpawnTime > os.clock() then
            local diff = math.floor(MerchantData.NextSpawnTime - os.clock())
            timeDesc = string.format("• ⏱️ จะมาถึงในอีกประมาณ: %d นาที %02d วินาที (รอบเซิร์ฟเวอร์)", math.floor(diff / 60), math.floor(diff % 60))
        else
            local m = math.floor(cycleSec / 60)
            local s = math.floor(cycleSec % 60)
            timeDesc = string.format("• ⏱️ จะมาถึงในอีกประมาณ: %d นาที %02d วินาที (คำนวณจากเวลาเซิร์ฟเวอร์)", m, s)
        end
    end

    local locDesc = ""
    if hrp then
        local p = hrp.Position
        locDesc = string.format("• 📍 ตำแหน่ง: (%.0f, %.0f, %.0f)\n• 📏 ระยะห่าง: %d studs", p.X, p.Y, p.Z, MerchantData.Distance)
    else
        locDesc = "• 📍 ตำแหน่ง: กำลังเดินทาง (จะสแกนพิกัดทันทีเมื่อมาถึง)\n• 📏 ระยะห่าง: --"
    end

    return title, timeDesc .. "\n" .. locDesc
end

local MerchantStatusParagraph = nil
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(1.0)
        pcall(function()
            if MerchantData.RemainingTime > 0 and not MerchantData.IsOpen then
                MerchantData.RemainingTime = math.max(0, MerchantData.RemainingTime - 1)
            end

            UpdateMerchantESP()

            if MerchantStatusParagraph and type(MerchantStatusParagraph.SetTitle) == "function" then
                local title, desc = GetMerchantStatusDisplay()
                MerchantStatusParagraph:SetTitle(title)
                MerchantStatusParagraph:SetDesc(desc)
            end
        end)
    end
end)

--------------------------------------------------------------
-- 🎨 สร้างเมนูใน FLUENT TABS
--------------------------------------------------------------
Tabs.Farm:AddParagraph({
    Title = "🛡️ KrakenHub v1.0 (100% Anti-Kick Bypass Pro)",
    Content = "• HookMetamethod บล็อกรีโมทแบน & ตรวจจับทุกประเภท\n• ล็อกสปีด 20 studs/s แท้จริง วิ่งไวกว่าคนทั่วไป แต่ต่ำกว่าเกณฑ์เตะ 261\n• ป้องกันหลุดระยะ ProximityPrompt และ Remote Rate-Limit ถาวร"
})

local JobSelector = Tabs.Farm:AddDropdown("JobSelect", {
    Title = "🎯 เลือกสายงานที่ต้องการฟาร์ม",
    Values = {"🏗️ งานก่อสร้าง", "🧹 ทำความสะอาด", "🗑️ เก็บขยะ", "🔧 ซ่อมรถ"},
    Default = "🏗️ งานก่อสร้าง"
})
JobSelector:OnChanged(function()
    local val = Options.JobSelect.Value
    if val:find("ก่อสร้าง") then
        State.SelectedJob = "งานก่อสร้าง"
    elseif val:find("ทำความสะอาด") then
        State.SelectedJob = "ทำความสะอาด"
    elseif val:find("ขยะ") then
        State.SelectedJob = "ขยะ"
    elseif val:find("ซ่อมรถ") then
        State.SelectedJob = "ซ่อมรถ"
    end
    ClearTargetESP()
    Notify("เลือกงาน", "เปลี่ยนเป้าหมายเป็น: " .. State.SelectedJob, "", 2.5)
end)

local ConstFilterDropdown = Tabs.Farm:AddDropdown("ConstructionFilterSelect", {
    Title = "🧱 ตัวกรองจุดก่อสร้าง (Wall / Steel Filter)",
    Values = {"🧱+🔩 กำแพง & เหล็ก (ยอดนิยม)", "🧱 เฉพาะกำแพง (Wall)", "🔩 เฉพาะเหล็ก (Steel)", "🌐 ทั้งหมด (กำแพง + เหล็ก + หิน)"},
    Default = "🧱+🔩 กำแพง & เหล็ก (ยอดนิยม)"
})
ConstFilterDropdown:OnChanged(function()
    local val = Options.ConstructionFilterSelect.Value
    if val:find("เฉพาะกำแพง") then
        State.ConstructionFilter = "เฉพาะกำแพง"
    elseif val:find("เฉพาะเหล็ก") then
        State.ConstructionFilter = "เฉพาะเหล็ก"
    elseif val:find("ทั้งหมด") then
        State.ConstructionFilter = "ทั้งหมด"
    else
        State.ConstructionFilter = "กำแพง & เหล็ก"
    end
    ScannedConstructionSpots = {}
    ClearTargetESP()
    Notify("ตัวกรองก่อสร้าง", "ตั้งค่าเป้าหมาย: " .. State.ConstructionFilter, "", 2.5)
end)

local MainFarmToggle = Tabs.Farm:AddToggle("MasterAutoFarm", {
    Title = "🚀 เริ่มฟาร์มอัตโนมัติ (Auto Farm Selected Job)",
    Description = "วิ่ง Shift แท้ 18 studs/s + หลบสิ่งกีดขวาง + ไฮไลต์ชัดเจน + เริ่มงานไว ปลอดภัย 100%",
    Default = false
})
MainFarmToggle:OnChanged(function()
    State.AutoFarm = Options.MasterAutoFarm.Value
    if State.AutoFarm then
        hasCompletedNpcHiring = false
        table.clear(failedSpotCooldowns)
        StopWorkAnimations()
        ReleaseVIM()
        local hum = GetHuman()
        if hum then
            hum:Move(Vector3.zero, false)
        end
        Notify("ระบบฟาร์ม", "เริ่มฟาร์มงาน: " .. tostring(State.SelectedJob) .. " (" .. tostring(State.ConstructionFilter) .. ")", "", 3)
    else
        Notify("ระบบฟาร์ม", "หยุดระบบฟาร์มเรียบร้อย", "", 3)
        SetSprinting(false)
        ClearTargetESP()
        table.clear(failedSpotCooldowns)
        StopWorkAnimations()
        ReleaseVIM()
        local hum = GetHuman()
        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end
    end
end)

local MinigameToggle = Tabs.Farm:AddToggle("AutoSolveMinigameOn", {
    Title = "🔨 แก้โจทย์มินิเกมอัตโนมัติ (Auto Solve Minigames)",
    Description = "ตอกตะปู, ซ่อมเครื่องยนต์, ขันน็อตล้อ, ถูพื้น อัตโนมัติ",
    Default = false
})
MinigameToggle:OnChanged(function()
    State.AutoSolveMinigame = Options.AutoSolveMinigameOn.Value
end)

local AllSpotsToggle = Tabs.Farm:AddToggle("ShowAllJobSpotsToggle", {
    Title = "👁️ แสดงจุดทำงานทั้งหมดในแมพ (Show All Spots ESP)",
    Description = "แสดงไฮไลต์จุดงานทั้งหมดรอบตัวแยกสีชัดเจน (กำแพง/เหล็ก/หิน)",
    Default = false
})
AllSpotsToggle:OnChanged(function()
    State.ShowAllSpotsESP = Options.ShowAllJobSpotsToggle.Value
    if not State.ShowAllSpotsESP then
        ClearAllJobESP()
    else
        UpdateAllJobESP()
    end
end)

--------------------------------------------------------------
-- 🛒 สร้างเมนูใน TABS.MERCHANT (พ่อค้าพเนจร)
--------------------------------------------------------------
local initMerchantTitle, initMerchantDesc = GetMerchantStatusDisplay()
MerchantStatusParagraph = Tabs.Merchant:AddParagraph({
    Title = initMerchantTitle,
    Content = initMerchantDesc
})

local MerchantESPToggle = Tabs.Merchant:AddToggle("MerchantESPOn", {
    Title = "👁️ เปิด ESP พ่อค้าพเนจร (Merchant ESP)",
    Description = "แสดงกล่องข้อความสีทอง + ข้อมูลระยะห่าง + เวลาที่เหลือทะลุกำแพง",
    Default = true
})
MerchantESPToggle:OnChanged(function()
    State.MerchantESP = Options.MerchantESPOn.Value
    if not State.MerchantESP then
        ClearMerchantESP()
    else
        UpdateMerchantESP()
    end
end)

local MerchantNotifyToggle = Tabs.Merchant:AddToggle("MerchantNotifyOn", {
    Title = "🔔 แจ้งเตือนเมื่อพ่อค้ามาถึง (Auto Notification)",
    Description = "เด้งหน้าต่างแจ้งเตือนทันทีเมื่อพ่อค้าพเนจรเปิดร้านในเซิร์ฟเวอร์",
    Default = true
})
MerchantNotifyToggle:OnChanged(function()
    State.AutoNotifyMerchant = Options.MerchantNotifyOn.Value
end)

Tabs.Merchant:AddButton({
    Title = "⚡ วาร์ปไปหาพ่อค้าพเนจร (Teleport to Merchant)",
    Description = "วาร์ปตัวละครไปยืนอยู่ตรงหน้าพ่อค้าทันที",
    Callback = function()
        TeleportToMerchant()
    end
})

-- [แท็บ 2: ตัวละคร]
Tabs.Player:AddParagraph({
    Title = "🏃 ระบบปรับแต่งตัวละคร & Visuals",
    Content = "Speed, Jump, Noclip, Fly, InfJump และมองทะลุ (ESP)"
})

local SpeedToggle = Tabs.Player:AddToggle("SpeedOn", { Title = "⚡ วิ่งไว (Speed Hack)", Default = false })
SpeedToggle:OnChanged(function()
    State.Speed = Options.SpeedOn.Value
    if not State.Speed then
        local hum = GetHuman()
        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end
    end
end)

local SpeedSlider = Tabs.Player:AddSlider("SpeedVal", {
    Title = "ความเร็วเดิน (WalkSpeed) [ปลอดภัย: <= 17.5 studs/s]",
    Default = 17,
    Min = 8,
    Max = 18,
    Rounding = 0
})
SpeedSlider:OnChanged(function()
    State.SpeedValue = Options.SpeedVal.Value
end)

local NoclipToggle = Tabs.Player:AddToggle("NoclipOn", { Title = "👻 เดินทะลุกำแพง (Noclip)", Default = false })
NoclipToggle:OnChanged(function()
    State.Noclip = Options.NoclipOn.Value
    if not State.Noclip then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        if part.Name == "Torso" or part.Name == "Head" then
                            part.CanCollide = true
                        else
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end)

local FlyToggle = Tabs.Player:AddToggle("FlyOn", { Title = "🚀 บินอิสระ (Fly Hack — WASD + Space/Shift)", Default = false })
FlyToggle:OnChanged(function()
    State.Fly = Options.FlyOn.Value
    if State.Fly then StartFly() else StopFly() end
end)

local InfJumpToggle = Tabs.Player:AddToggle("InfJumpOn", { Title = "♾️ กระโดดไม่จำกัด (Infinite Jump)", Default = false })
InfJumpToggle:OnChanged(function()
    State.InfJump = Options.InfJumpOn.Value
end)

Tabs.Player:AddParagraph({
    Title = "👁️ ระบบมองทะลุผู้เล่น & แยกสีสถาบัน (Player ESP)",
    Content = "ปทุมคงคา (ฟ้า) | กรุงเทพช่างกล (เหลืองอ่อน) | พระ (ส้ม) | เด็กบ้าน (ขาว) | ตำรวจ (แดง)"
})

local ESPToggle = Tabs.Player:AddToggle("ESPOn", {
    Title = "👁️ เปิด ESP ผู้เล่นแยกสีสถาบัน (School Player ESP)",
    Description = "เรนเดอร์ Flicker-Free แสดงกรอบเรืองแสง, ข้อมูลสถาบัน, อาวุธ และหลอดเลือด",
    Default = false
})
ESPToggle:OnChanged(function()
    State.ESP = Options.ESPOn.Value
    if not State.ESP then
        ClearPlayerESP()
    end
end)

local ESPMaxDistSlider = Tabs.Player:AddSlider("ESPMaxDistVal", {
    Title = "📏 ระยะแสดงผล ESP สูงสุด (Max Distance)",
    Description = "จำกัดระยะตรวจจับผู้เล่นเพื่อลดแลคและไม่รกสายตา (Studs)",
    Default = 500,
    Min = 50,
    Max = 1500,
    Rounding = 0
})
ESPMaxDistSlider:OnChanged(function()
    State.ESPMaxDistance = Options.ESPMaxDistVal.Value
end)

local ESPWeaponToggle = Tabs.Player:AddToggle("ESPShowWeapon", {
    Title = "🔫 แสดงชื่ออาวุธที่ถือ (Equipped Weapon Display)",
    Description = "ตรวจจับปืน, มีด, อาวุธระยะประชิด หรือมือเปล่าแบบ Realtime",
    Default = true
})
ESPWeaponToggle:OnChanged(function()
    State.ESPShowWeapon = Options.ESPShowWeapon.Value
end)

local ESPDistToggle = Tabs.Player:AddToggle("ESPShowDistance", {
    Title = "📐 แสดงระยะห่าง (Distance Display)",
    Description = "คำนวณระยะห่างระหว่างตัวละครเป็นเมตร (m) และ studs",
    Default = true
})
ESPDistToggle:OnChanged(function()
    State.ESPShowDistance = Options.ESPShowDistance.Value
end)

local ESPHealthToggle = Tabs.Player:AddToggle("ESPShowHealthBar", {
    Title = "❤️ แสดงหลอดเลือดสี (Visual Health Bar)",
    Description = "หลอดเลือดเปลี่ยนสีตามเลือด (เขียว >70% | ส้ม 35-70% | แดง <35%)",
    Default = true
})
ESPHealthToggle:OnChanged(function()
    State.ESPShowHealthBar = Options.ESPShowHealthBar.Value
end)

--------------------------------------------------------------
-- 🎯 แท็บ: ระบบต่อสู้ (COMBAT & SILENT AIM)
--------------------------------------------------------------
Tabs.Combat:AddParagraph({
    Title = "🎯 B3 Silent Aim & Gun System",
    Content = "ระบบล็อคกระสุนอัตโนมัติ คำนวณวิถีกระสุนเข้าเป้าหมาย พร้อมระบบชดเชยความเร็วเป้าหมาย และตรวจสอบสิ่งกีดขวาง"
})

local SilentAimToggle = Tabs.Combat:AddToggle("SilentAimOn", {
    Title = "🎯 เปิดใช้งาน Silent Aim",
    Description = "วิถีกระสุนจะเล็งเข้าหาเป้าหมายในวงกลม FOV โดยไม่ต้องหันหน้าจอ",
    Default = false
})
SilentAimToggle:OnChanged(function()
    State.SilentAim = Options.SilentAimOn.Value
    ApplyGunMods()
end)

local PartDropdown = Tabs.Combat:AddDropdown("SilentPartChoice", {
    Title = "🎯 ส่วนของร่างกายที่ล็อค (Target Part)",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head"
})
PartDropdown:OnChanged(function()
    State.SilentPart = Options.SilentPartChoice.Value
end)

local HitChanceSlider = Tabs.Combat:AddSlider("HitChanceVal", {
    Title = "🎲 อัตราความแม่นยำ (Hit Chance %)",
    Description = "โอกาสที่กระสุนจะเข้าเป้า (แนะนำ 100% หรือปรับเพื่อความแนบเนียน)",
    Default = 100,
    Min = 10,
    Max = 100,
    Rounding = 0
})
HitChanceSlider:OnChanged(function()
    State.SilentHitChance = Options.HitChanceVal.Value
end)

local WallCheckToggle = Tabs.Combat:AddToggle("WallCheckOn", {
    Title = "🧱 ตรวจสอบกำแพง (Wall Check)",
    Description = "ไม่ยิงล็อคเป้าหมายที่อยู่หลังกำแพงหรือสิ่งกีดขวาง",
    Default = false
})
WallCheckToggle:OnChanged(function()
    State.SilentWallCheck = Options.WallCheckOn.Value
end)

local VelocityToggle = Tabs.Combat:AddToggle("VelocityPredictOn", {
    Title = "⚡ คำนวณนำวิถีความเร็วเป้าหมาย (Velocity Prediction)",
    Description = "ดักหน้าทิศทางการเคลื่อนที่ของศัตรู ยิงโดนแม้ศัตรูกำลังวิ่ง",
    Default = false
})
VelocityToggle:OnChanged(function()
    State.SilentVelocity = Options.VelocityPredictOn.Value
end)

local FOVSlider = Tabs.Combat:AddSlider("CombatFOVVal", {
    Title = "⭕ รัศมี FOV (FOV Radius)",
    Description = "ขนาดวงกลมระยะการล็อคเป้าหมาย (Pixels)",
    Default = 150,
    Min = 40,
    Max = 400,
    Rounding = 0
})
FOVSlider:OnChanged(function()
    State.CombatFOV = Options.CombatFOVVal.Value
end)

local DrawFOVToggle = Tabs.Combat:AddToggle("DrawFOVOn", {
    Title = "👁️ แสดงวงกลม FOV บนหน้าจอ (Draw FOV Circle)",
    Default = false
})
DrawFOVToggle:OnChanged(function()
    State.DrawFOV = Options.DrawFOVOn.Value
end)

Tabs.Combat:AddSection("🔧 ปรับแต่งปืน & ความเสถียร (Gun Modifiers)")

local NoSpreadToggle = Tabs.Combat:AddToggle("NoSpreadOn", {
    Title = "🎯 ยิงตรงจุด ไร้แรงกระจาย (No Spread)",
    Default = false
})
NoSpreadToggle:OnChanged(function()
    State.NoSpread = Options.NoSpreadOn.Value
    ApplyGunMods()
end)

local NoRecoilToggle = Tabs.Combat:AddToggle("NoRecoilOn", {
    Title = "🛑 ปืนนิ่งสนิท ไร้แรงถีบ (No Recoil & No Shake)",
    Default = false
})
NoRecoilToggle:OnChanged(function()
    State.NoRecoil = Options.NoRecoilOn.Value
    ApplyGunMods()
end)

local FastBulletToggle = Tabs.Combat:AddToggle("FastBulletOn", {
    Title = "⚡ กระสุนความเร็วสูง ไม่ย้อย (No Bullet Drop)",
    Default = false
})
FastBulletToggle:OnChanged(function()
    State.FastBullet = Options.FastBulletOn.Value
    ApplyGunMods()
end)

-- [แท็บ 4: ตั้งค่า]
Tabs.Settings:AddParagraph({
    Title = "⚙️ KrakenHub v1.0",
    Content = "Fluent Edition (100% Anti-Kick Bypass Pro)\nกดปุ่ม K หรือ Right Control เพื่อเปิด/ปิดหน้าต่าง"
})

Tabs.Settings:AddSection("💡 การแสดงผล & แสงสว่าง (Visuals & Lighting)")

local FullBrightToggle = Tabs.Settings:AddToggle("FullBrightOn", {
    Title = "☀️ สว่างทั้งแมพ (Full Bright)",
    Description = "ปรับแสงสว่างทั้งแมพ ปิดเงามืด และปรับเป็นเวลากลางวันตลอดเวลา",
    Default = false
})
FullBrightToggle:OnChanged(function()
    State.FullBright = Options.FullBrightOn.Value
    if State.FullBright then
        EnableFullBright()
        Notify("การแสดงผล", "เปิดใช้งานสว่างทั้งแมพ (Full Bright) เรียบร้อย", "", 2.5)
    else
        RestoreLighting()
        Notify("การแสดงผล", "คืนค่าแสงสว่างเริ่มต้นของเกมแล้ว", "", 2.5)
    end
end)

Tabs.Settings:AddSection("⚠️ ควบคุมสคริปต์")

function Hub.Unload()
    if Hub.Unloaded then return end
    Hub.Unloaded = true
    State.Running = false
    State.AutoFarm = false
    State.AutoSolveMinigame = false
    State.Noclip = false
    State.Fly = false
    State.ESP = false
    State.NoSpread = false
    State.NoRecoil = false
    State.FastBullet = false
    State.SilentAim = false
    pcall(function()
        if originalSimulateProjectile then
            local phMod = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("ProjectileHandler")
            if phMod then
                local ph = require(phMod)
                ph.SimulateProjectile = originalSimulateProjectile
            end
        end
    end)
    SetSprinting(false)
    ClearTargetESP()
    ClearAllJobESP()
    ReleaseVIM()
    StopFly()
    if fovCircle then
        pcall(function() fovCircle:Remove() end)
    end
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local runSys = pgui and pgui:FindFirstChild("RunSystem")
        if runSys then runSys:SetAttribute("BlockStamina", false) end
    end)
    for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
    for _, obj in pairs(Hub.ESPObjects) do pcall(function() obj:Destroy() end) end
    ClearPlayerESP()
    ClearMerchantESP()
    if State.FullBright then
        RestoreLighting()
    end
    local hum = GetHuman()
    if hum then hum.WalkSpeed = NORMAL_WALK_SPEED; hum.JumpPower = 35 end
    if Hub.ToggleButtonGui then
        pcall(function() Hub.ToggleButtonGui:Destroy() end)
    end
    pcall(function() Fluent:Destroy() end)
end

Tabs.Settings:AddButton({
    Title = "⚠️ ปิด Hub (Unload)",
    Description = "หยุดการทำงานของสคริปต์ ลูปทั้งหมด และคืนค่าตัวละคร",
    Callback = function()
        Window:Dialog({
            Title = "ต้องการปิดสคริปต์หรือไม่?",
            Content = "ระบบจะหยุดการทำงานทั้งหมด ลบ UI และคืนค่าเดิม",
            Buttons = {
                {
                    Title = "ยืนยัน (Unload)",
                    Callback = function()
                        Hub.Unload()
                    end
                },
                { Title = "ยกเลิก", Callback = function() end }
            }
        })
    end
})

InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("KrakenHub")
SaveManager:SetFolder("KrakenHub/Sailueat")
pcall(function()
    if writefile then
        writefile("KrakenHub/options.json", '{"MenuKeybind":"RightControl","Transparency":true,"Theme":"Darker","Acrylic":false}')
    end
    if isfile and delfile then
        for _, p in ipairs({
            "KrakenHub/Sailueat/settings/autoload.txt",
            "KrakenHub/autoload.txt",
            "Fluent/autoload.txt",
            "Fluent/settings/autoload.txt"
        }) do
            if isfile(p) then pcall(delfile, p) end
        end
    end
end)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
-- SaveManager:LoadAutoloadConfig() -- ปิดการโหลดอัตโนมัติ เพื่อให้เริ่มใหม่ต้องติ๊กเองทุกครั้ง นอกจากจะกด Load Config เองในแท็บตั้งค่า
pcall(function()
    if Window.Root then
        Window.Root.Visible = true
        Window.Minimized = false
    end
end)

Notify("KrakenHub v1.0", "โหลดสำเร็จ! 100% Anti-Kick Bypass Pro", "กดปุ่ม K หรือ Right Ctrl เพื่อเปิด/ปิดหน้าต่าง", 4)
print("[KrakenHub] สายเลือดอาชีวะ v1.0 Loaded (Multi-Layer Bypass — No hookmetamethod)!")
