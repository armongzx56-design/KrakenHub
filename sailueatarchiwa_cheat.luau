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
local VirtualInputManager = (function()
    local ok, vim = pcall(function() return game:GetService("VirtualInputManager") end)
    if ok and vim then return vim end
    return nil
end)()
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

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

local CoreGui = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or nil
local targetGuiParent = (function()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    if CoreGui then
        local canCore = pcall(function()
            local test = Instance.new("Folder")
            test.Parent = CoreGui
            test:Destroy()
        end)
        if canCore then return CoreGui end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end)()
for _, name in ipairs({"KrakenHub_ToggleButton", "KrakenHub_UI", "Fluent"}) do
    local old = targetGuiParent:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
    if targetGuiParent ~= LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer:FindFirstChild("PlayerGui") then
        local pOld = LocalPlayer.PlayerGui:FindFirstChild(name)
        if pOld then pcall(function() pOld:Destroy() end) end
    end
end
pcall(function()
    if CoreGui and pcall(function() return CoreGui.Name end) then
        for _, c in ipairs(CoreGui:GetChildren()) do
            if c:IsA("ScreenGui") and (c.Name == "KrakenHub_UI" or c.Name == "KrakenHub_ToggleButton" or c.Name:find("Fluent")) then
                c:Destroy()
            end
        end
    end
end)

-- เคลียร์ Highlight และ Billboard ตกค้างใน Workspace และ CoreGui ทุกชนิดแบบเร็ว ไม่ค้างเฟรม
pcall(function()
    for _, desc in ipairs(Workspace:GetChildren()) do
        if desc:IsA("Highlight") or desc:IsA("BillboardGui") then
            if desc.Name:find("Target") or desc.Name:find("Kraken") or desc.Name:find("Farm") or desc.Name:find("Merchant") or desc.Name:find("ESP") then
                desc:Destroy()
            end
        end
    end
    for _, c in ipairs(CoreGui:GetChildren()) do
        if c:IsA("Highlight") and not c.Name:find("Roblox") then
            c:Destroy()
        end
        if c:IsA("BillboardGui") and not c.Name:find("Roblox") and not c.Name:find("Chat") and not c.Name:find("Purchase") and not c.Name:find("InGameMenu") then
            c:Destroy()
        end
    end
    if targetGuiParent ~= CoreGui then
        for _, c in ipairs(targetGuiParent:GetChildren()) do
            if (c:IsA("Highlight") or c:IsA("BillboardGui")) and (c.Name:find("Kraken") or c.Name:find("Target") or c.Name:find("ESP")) then
                c:Destroy()
            end
        end
    end
end)

--------------------------------------------------------------
-- 🛡️ ระบบความปลอดภัย (100% STEALTH ANTI-CHEAT BYPASS)
-- ปิดการทำงานสคริปต์ตรวจจับฝั่งไคลเอนต์แบบเงียบสนิท ไม่แตะต้อง Metatable หรือ Adonis Engine ป้องกัน Error 267 & CODE 59 100%
--------------------------------------------------------------
pcall(function()
    local pscripts = LocalPlayer:FindFirstChild("PlayerScripts")
    if pscripts then
        local ahc = pscripts:FindFirstChild("AntiHitboxClient", true)
        if ahc and ahc:IsA("LocalScript") then
            ahc.Disabled = true
        end
        local camModule = pscripts:FindFirstChild("PlayerModule") and pscripts.PlayerModule:FindFirstChild("CameraModule")
        if camModule then
            local fakeCam = camModule:FindFirstChild("Camera")
            if fakeCam and fakeCam:IsA("LocalScript") then
                fakeCam.Disabled = true
            end
        end
    end
end)

-- 2. คืนค่า CanCollide ของตัวละครให้เป็นปกติสมบูรณ์
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
local lastRunSystemSearch = 0
local runSystemSearchFailed = false
local function GetRunSystemRenderFn()
    if cachedRunSystemFn then return cachedRunSystemFn end
    if runSystemSearchFailed and (os.clock() - lastRunSystemSearch < 5.0) then
        return nil
    end
    lastRunSystemSearch = os.clock()

    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local rs = pgui and pgui:FindFirstChild("RunSystem")
    if not rs or typeof(getconnections) ~= "function" then
        runSystemSearchFailed = true
        return nil
    end

    local s, conns = pcall(getconnections, RunService.RenderStepped)
    if s and type(conns) == "table" then
        for _, c in ipairs(conns) do
            local fn = c.Function
            if fn then
                local sInfo, src = pcall(debug.info, fn, "s")
                if sInfo and tostring(src):find("RunSystem") then
                    cachedRunSystemFn = fn
                    runSystemSearchFailed = false
                    return fn
                end
            end
        end
    end
    runSystemSearchFailed = true
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
        AutoSolveMinigame = true,
        AutoHire = true,
        AutoClaimConstruction = false, -- เคลมเงินค่าจ้างงานก่อสร้างอัตโนมัติ
        ConstructionFilter = "กำแพง & เหล็ก", -- "ทั้งหมด", "กำแพง & เหล็ก", "เฉพาะกำแพง", "เฉพาะเหล็ก"
        ShowAllSpotsESP = false,
        -- Cheats
        Speed = false,
        SpeedValue = 17,
        InfiniteStamina = false,
        Godmode = false,
        Jump = false,
        JumpValue = 35,
        Noclip = false,
        Fly = false,
        FlySpeed = 50,
        InfJump = false,
        ESP = false,
        ESPMaxDistance = 500,
        ESPShowBox = true,
        ESPShowHeadDot = true,
        ESPShowChams = true,
        ESPTacticalStyle = false,
        ESPShowWeapon = true,
        ESPShowDistance = true,
        ESPShowHealthBar = true,
        FullBright = false,
        BoostFPS = false,
        TargetFPS = 60,
        HideToggleButton = false,
        -- ปืน & Combat
        NoSpread = false,
        NoRecoil = true,
        FastBullet = false,
        FullAuto = true,
        GlockSwitchFireRate = 0.125,
        FastReload = false,
        FastReloadRatio = 0.8,
        MinReloadClamp = 1.35,
        AutoReload = true,
        SilentAim = false,
        SilentPart = "Head",
        SilentHitChance = 100,
        SilentWallCheck = false,
        SilentVelocity = false,
        CombatFOV = 150,
        DrawFOV = false,
        -- Head Hitbox Expander
        HitboxExpander = false,
        HitboxSize = 6,
        HitboxShow = true,
        -- ระบบปฏิสัมพันธ์ & ProximityPrompt (แยก Instant กับ Safe Delay)
        InstantPrompt = true,
        SmartPrompt = true,
        AutoZeroPrompt = true,
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
local lastCameraShakeClear = 0
local lastStaminaCheck = 0
Connections.SpeedEnforcer = RunService.RenderStepped:Connect(function()
    if not State.Running then return end
    local hum = GetHuman()
    local hrp = GetHRP()
    if not hum or hum.Health <= 0 or not hrp then return end

    -- 🛑 ล้างค่าสั่นมุมกล้อง math.noise ของ RunSystem ให้เป็น 0 (หน่วงเวลา 0.5s เพื่อลดภาระ CPU)
    local now = os.clock()
    if now - lastCameraShakeClear >= 0.5 then
        lastCameraShakeClear = now
        local fn = GetRunSystemRenderFn()
        if fn then
            pcall(debug.setupvalue, fn, 15, 0) -- u14: target amplitude ของการสั่นกล้อง
            pcall(debug.setupvalue, fn, 18, 0) -- u15: current amplitude ของการสั่นกล้อง
            pcall(debug.setupvalue, fn, 23, 0) -- u16: phase ของ math.noise
        end
    end

    -- ล็อคความเร็ว 0 เฉพาะตอนที่เปิด AutoFarm และกำลังทำงานก่อสร้าง / มินิเกม เท่านั้น
    if State.AutoFarm and IsCurrentlyWorking and IsCurrentlyWorking() then
        hum.WalkSpeed = 0
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if isCurrentlySprinting then
            isCurrentlySprinting = false
            local fn = GetRunSystemRenderFn()
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

    -- หากผู้ใช้เปิด Cheats > Speed เสริมเอง ปรับความเร็วตามหลอด (สูงสุด 20 studs/s)
    if State.Speed then
        hum.WalkSpeed = math.min(State.SpeedValue or 20, 20)
    end

    -- ⚡ วิ่งไม่เหนื่อย (Infinite Stamina): เติม Stamina เต็มหลอด (เช็คทุก 0.15s เพื่อไม่ให้แย่ง Render Frame)
    if State.InfiniteStamina and (now - lastStaminaCheck >= 0.15) then
        lastStaminaCheck = now
        local fn = GetRunSystemRenderFn()
        if fn then
            pcall(debug.setupvalue, fn, 5, false) -- isExhausted = false
            pcall(debug.setupvalue, fn, 10, 100)  -- stamina = 100
        end
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local rs = pgui and pgui:FindFirstChild("RunSystem")
        if rs and rs:GetAttribute("BlockStamina") == true then
            pcall(function() rs:SetAttribute("BlockStamina", false) end)
        end
    end

    -- 🛡️ Godmode (อมตะ): รักษาระดับเลือดเต็มตลอดเวลา ป้องกันสถานะล้มตาย/ดาเมจ
    if State.Godmode then
        if hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
        if hum:GetState() == Enum.HumanoidStateType.Dead then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
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

local _lightLockConn = nil

local function EnableFullBright()
    -- ปิด DayNightLighting script ฝั่ง game ก่อน
    pcall(function()
        local dayNightScript = LocalPlayer.PlayerScripts:FindFirstChild("DayNightLighting")
        if dayNightScript then dayNightScript.Disabled = true end
    end)

    -- ตั้งค่าแสงกลางวัน
    local function applyDay()
        pcall(function()
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(88, 88, 90)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 236, 200)
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmo then
                atmo.Density = 0.28
                atmo.Offset = 0.6
                atmo.Glare = 0.15
                atmo.Haze = 0.8
                atmo.Color = Color3.fromRGB(190, 190, 200)
                atmo.Decay = Color3.fromRGB(175, 180, 195)
            end
            local grade = Lighting:FindFirstChild("DayNightGrade")
            if grade then
                grade.Saturation = 0.03
                grade.Contrast = 0
                grade.Brightness = 0.02
                grade.TintColor = Color3.fromRGB(255, 252, 248)
            end
        end)
    end

    applyDay()

    -- ล็อคด้วย Changed event — ครอบคลุมทุก prop ที่ game พยายามเปลี่ยน
    if _lightLockConn then _lightLockConn:Disconnect() end
    _lightLockConn = Lighting.Changed:Connect(function(prop)
        if not State.FullBright then return end
        local lockProps = {
            ClockTime = true, TimeOfDay = true,
            Brightness = true, Ambient = true,
            OutdoorAmbient = true, GlobalShadows = true,
        }
        if lockProps[prop] then
            task.defer(applyDay)
        end
    end)
end

local function RestoreLighting()
    -- ตัด lock ก่อนคืนค่า ป้องกัน event loop
    if _lightLockConn then
        _lightLockConn:Disconnect()
        _lightLockConn = nil
    end
    pcall(function()
        local dayNightScript = LocalPlayer.PlayerScripts:FindFirstChild("DayNightLighting")
        if dayNightScript then dayNightScript.Disabled = false end
    end)
    pcall(function()
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
        Lighting.Ambient = defaultLighting.Ambient
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    end)
end

--------------------------------------------------------------
-- ⚡ ระบบ ULTRA BOOST FPS (เน้นลื่นไหลสูงสุด ปลดล็อค FPS + คลีนกราฟิก)
--------------------------------------------------------------
local _boostFPSConn = nil
local _origTerrainProps = nil
local _disabledEffects = {}

local function OptimizeInstance(v)
    pcall(function()
        if not v or not v.Parent then return end
        if v.Name and (v.Name:find("Kraken") or v.Name:find("ESP") or v.Name:find("MacLib")) then
            return
        end
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
            v.Enabled = false
        elseif v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
            if v.Enabled then
                table.insert(_disabledEffects, v)
                v.Enabled = false
            end
        end
    end)
end

local function ApplyFPSCap(fps)
    pcall(function()
        if setfpscap then
            setfpscap(fps)
        elseif set_fps_cap then
            set_fps_cap(fps)
        end
    end)
end

local function EnableBoostFPS()
    -- 1. ปลดล็อค FPS Cap
    local cap = State.TargetFPS or 999
    ApplyFPSCap(cap)

    -- 2. ปรับ Rendering Settings ให้ต่ำสุด
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    -- 3. ปรับ Lighting
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
                pcall(function()
                    if effect:IsA("PostEffect") or effect:IsA("Atmosphere") then
                        if effect.Enabled then
                            table.insert(_disabledEffects, effect)
                            effect.Enabled = false
                        end
                    end
                end)
            end
        end
    end)

    -- 4. ปรับ Terrain
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            if not _origTerrainProps then
                _origTerrainProps = {
                    Decoration = terrain.Decoration,
                    WaterWaveSize = terrain.WaterWaveSize,
                    WaterWaveSpeed = terrain.WaterWaveSpeed,
                    WaterReflectance = terrain.WaterReflectance,
                    WaterTransparency = terrain.WaterTransparency,
                }
            end
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
        end
    end)

    -- 5. สแกนและลดภาระโมเดล/พาร์ททั้งหมดใน workspace แบบแบ่งแบทช์ (ไม่ทำให้เกิด Frame Drop/Stutter)
    task.spawn(function()
        local descendants = workspace:GetDescendants()
        for i, v in ipairs(descendants) do
            if not State.BoostFPS then break end
            OptimizeInstance(v)
            if i % 150 == 0 then
                task.wait()
            end
        end
    end)

    -- 6. Hook DescendantAdded เพื่อจัดการ object ที่สตรีมเข้ามาใหม่ทันที
    if _boostFPSConn then
        _boostFPSConn:Disconnect()
        _boostFPSConn = nil
    end
    _boostFPSConn = workspace.DescendantAdded:Connect(function(v)
        if State.BoostFPS then
            OptimizeInstance(v)
        end
    end)
    Connections.BoostFPSDescendant = _boostFPSConn
end

local function DisableBoostFPS()
    if _boostFPSConn then
        _boostFPSConn:Disconnect()
        _boostFPSConn = nil
        Connections.BoostFPSDescendant = nil
    end

    -- คืนค่า Effects
    for _, effect in ipairs(_disabledEffects) do
        pcall(function()
            if effect and effect.Parent then
                effect.Enabled = true
            end
        end)
    end
    _disabledEffects = {}

    -- คืนค่า Terrain
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain and _origTerrainProps then
            terrain.Decoration = _origTerrainProps.Decoration
            terrain.WaterWaveSize = _origTerrainProps.WaterWaveSize
            terrain.WaterWaveSpeed = _origTerrainProps.WaterWaveSpeed
            terrain.WaterReflectance = _origTerrainProps.WaterReflectance
            terrain.WaterTransparency = _origTerrainProps.WaterTransparency
        end
    end)

    -- คืนค่า Lighting หากไม่ได้เปิด FullBright
    if not State.FullBright then
        pcall(function()
            Lighting.GlobalShadows = defaultLighting.GlobalShadows
            Lighting.FogEnd = defaultLighting.FogEnd
        end)
    end
end

--------------------------------------------------------------
-- 🎯 4. ระบบ TARGET ESP สีชัดเจน แยกประเภท เหล็ก (ส้มทอง) / กำแพง (เขียวนีออน)
-- Re-use Highlight & Billboard แทนการ Destroy/Create ซ้ำๆ (แก้ปัญหา GPU Stutter 100%)
--------------------------------------------------------------
local currentTargetHighlight = nil
local currentTargetBillboard = nil
local currentTargetAttachPart = nil
local currentTargetInstance = nil
local currentTargetStatus = nil

local function EnsureTargetESP()
    if not currentTargetHighlight or not currentTargetHighlight.Parent then
        pcall(function() if currentTargetHighlight then currentTargetHighlight:Destroy() end end)
        local hl = Instance.new("Highlight")
        hl.Name = "KrakenTargetFarmHighlight"
        hl.FillTransparency = 0.28
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = CoreGui
        currentTargetHighlight = hl
    end

    if not currentTargetBillboard or not currentTargetBillboard.Parent then
        pcall(function() if currentTargetBillboard then currentTargetBillboard:Destroy() end end)
        local bb = Instance.new("BillboardGui")
        bb.Name = "KrakenTargetFarmBillboard"
        bb.Size = UDim2.new(0, 180, 0, 48)
        bb.StudsOffset = Vector3.new(0, 3.4, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 45
        bb.Enabled = false

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
        uis.Name = "BorderStroke"
        uis.Color = Color3.fromRGB(160, 255, 255)
        uis.Thickness = 2.0
        uis.Parent = frame

        local tLabel = Instance.new("TextLabel")
        tLabel.Name = "TitleLabel"
        tLabel.Size = UDim2.new(1, 0, 0.52, 0)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.TextSize = 12
        tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        tLabel.Text = "🎯 จุดทำงานเป้าหมาย"
        tLabel.Parent = frame

        local dLabel = Instance.new("TextLabel")
        dLabel.Name = "DistLabel"
        dLabel.Size = UDim2.new(1, 0, 0.48, 0)
        dLabel.Position = UDim2.new(0, 0, 0.52, 0)
        dLabel.BackgroundTransparency = 1
        dLabel.Font = Enum.Font.GothamMedium
        dLabel.TextSize = 11
        dLabel.TextColor3 = Color3.fromRGB(0, 240, 160)
        dLabel.Text = "เป้าหมาย • กำลังคำนวณ..."
        dLabel.Parent = frame

        bb.Parent = CoreGui
        currentTargetBillboard = bb
    end
end

local function ClearTargetESP()
    if currentTargetHighlight then
        currentTargetHighlight.Enabled = false
        currentTargetHighlight.Adornee = nil
    end
    if currentTargetBillboard then
        currentTargetBillboard.Enabled = false
        currentTargetBillboard.Adornee = nil
    end
    currentTargetAttachPart = nil
    currentTargetInstance = nil
    currentTargetStatus = nil
end

local function SetTargetESP(targetInstance, titleText, customColor, statusText)
    if not targetInstance then
        ClearTargetESP()
        return
    end

    EnsureTargetESP()
    currentTargetStatus = statusText or "เป้าหมาย"

    -- ถ้าเป็นเป้าหมายเดิม แค่อัปเดตข้อความหัวเรื่อง
    if currentTargetInstance == targetInstance then
        if currentTargetBillboard then
            currentTargetBillboard.Enabled = true
            local frame = currentTargetBillboard:FindFirstChildOfClass("Frame")
            local tLabel = frame and frame:FindFirstChild("TitleLabel")
            if tLabel and titleText then
                tLabel.Text = "🎯 " .. titleText
            end
        end
        if currentTargetHighlight then
            currentTargetHighlight.Enabled = true
        end
        return
    end

    currentTargetInstance = targetInstance

    local adornee = targetInstance
    if adornee:IsA("ProximityPrompt") then
        adornee = adornee.Parent
    end
    if adornee:IsA("Attachment") then
        adornee = adornee.Parent
    end

    if adornee:IsA("BasePart") and adornee.Parent and adornee.Parent:IsA("Model") and adornee.Parent ~= Workspace and adornee.Parent ~= Workspace:FindFirstChild("Job") and adornee.Parent.Name ~= "งาน" then
        adornee = adornee.Parent
    end

    if adornee:IsA("BasePart") and (adornee.Size.X > 30 or adornee.Size.Z > 30 or adornee.Size.Y > 30) then
        adornee = nil
    end

    local textLower = string.lower(titleText or "")
    local fillColor = customColor or Color3.fromRGB(0, 240, 160)
    local outlineColor = Color3.fromRGB(160, 255, 255)

    if titleText and (titleText:find("เหล็ก") or textLower:find("steel") or textLower:find("weld")) then
        fillColor = Color3.fromRGB(255, 145, 0)
        outlineColor = Color3.fromRGB(255, 235, 70)
    elseif titleText and (titleText:find("กำแพง") or titleText:find("ตะปู") or textLower:find("nail") or textLower:find("wall")) then
        fillColor = Color3.fromRGB(0, 240, 160)
        outlineColor = Color3.fromRGB(160, 255, 255)
    elseif titleText and (titleText:find("หิน") or textLower:find("drill") or textLower:find("rock")) then
        fillColor = Color3.fromRGB(190, 110, 255)
        outlineColor = Color3.fromRGB(255, 200, 255)
    elseif titleText and titleText:find("NPC") then
        fillColor = Color3.fromRGB(0, 210, 255)
        outlineColor = Color3.fromRGB(255, 255, 255)
    end

    pcall(function()
        if adornee and currentTargetHighlight then
            currentTargetHighlight.Adornee = adornee
            currentTargetHighlight.FillColor = fillColor
            currentTargetHighlight.OutlineColor = outlineColor
            currentTargetHighlight.Enabled = true
        elseif currentTargetHighlight then
            currentTargetHighlight.Enabled = false
            currentTargetHighlight.Adornee = nil
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
                      or targetInstance:FindFirstChildWhichIsA("BasePart")
        end
        if not attachPart and adornee and adornee:IsA("Model") then
            attachPart = adornee:FindFirstChild("WoodPlank")
                      or adornee:FindFirstChild("Steel")
                      or adornee:FindFirstChild("Mountain")
                      or adornee:FindFirstChild("Prompt")
                      or adornee.PrimaryPart
                      or adornee:FindFirstChildWhichIsA("BasePart")
        end
        if not attachPart and adornee and adornee:IsA("BasePart") then
            attachPart = adornee
        end

        currentTargetAttachPart = attachPart

        if attachPart and currentTargetBillboard then
            currentTargetBillboard.Adornee = attachPart
            currentTargetBillboard.Enabled = true

            local frame = currentTargetBillboard:FindFirstChildOfClass("Frame")
            if frame then
                local uis = frame:FindFirstChild("BorderStroke")
                if uis then uis.Color = outlineColor end
                local tLabel = frame:FindFirstChild("TitleLabel")
                if tLabel then tLabel.Text = "🎯 " .. (titleText or "จุดทำงานเป้าหมาย") end
                local dLabel = frame:FindFirstChild("DistLabel")
                if dLabel then
                    dLabel.TextColor3 = fillColor
                    dLabel.Text = (currentTargetStatus or "เป้าหมาย") .. " • กำลังคำนวณ..."
                end
            end
        elseif currentTargetBillboard then
            currentTargetBillboard.Enabled = false
            currentTargetBillboard.Adornee = nil
        end
    end)
end

local lastTargetESPUpdate = 0
Connections.TargetESPUpdate = RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now - lastTargetESPUpdate < 0.1 then return end
    lastTargetESPUpdate = now

    if currentTargetBillboard and currentTargetBillboard.Enabled and currentTargetAttachPart then
        local hrp = GetHRP()
        if hrp and currentTargetAttachPart.Parent then
            local dist = (hrp.Position - currentTargetAttachPart.Position).Magnitude
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
-- 👁️ ระบบ ESP แสดงจุดทำงานทั้งหมดในแมพ (Optimized Highlight Reuse)
--------------------------------------------------------------
local function ClearAllJobESP()
    for _, obj in pairs(Hub.AllJobESPObjects) do
        pcall(function() obj:Destroy() end)
    end
    table.clear(Hub.AllJobESPObjects)
end

local function UpdateAllJobESP()
    if not State.ShowAllSpotsESP or not State.Running then
        ClearAllJobESP()
        return
    end

    local jobFolder = Workspace:FindFirstChild("Job")
    if not jobFolder then
        ClearAllJobESP()
        return
    end

    local constJob = jobFolder:FindFirstChild("งานก่อสร้าง")
    if not (constJob and constJob:FindFirstChild("งาน")) then
        ClearAllJobESP()
        return
    end

    local catColors = {
        ["ตะปู"] = Color3.fromRGB(0, 240, 160),  -- กำแพง (Cyan-Green)
        ["เหล็ก"] = Color3.fromRGB(255, 145, 0), -- เหล็ก (Orange-Gold)
        ["หิน"] = Color3.fromRGB(190, 110, 255), -- หิน (Purple)
    }

    local targetList = {}
    for _, cat in ipairs(constJob["งาน"]:GetChildren()) do
        local color = catColors[cat.Name] or Color3.fromRGB(120, 255, 40)
        for _, item in ipairs(cat:GetChildren()) do
            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled then
                local targetAdornee = item
                if targetAdornee ~= currentTargetInstance and targetAdornee ~= (currentTargetBillboard and currentTargetBillboard.Adornee) then
                    table.insert(targetList, { Item = targetAdornee, Color = color })
                    if #targetList >= 25 then break end
                end
            end
        end
        if #targetList >= 25 then break end
    end

    -- Re-use Highlights แทนการ Destroy แล้วสร้างใหม่ ช่วยลดอาการกระตุกของ GPU
    local maxCount = math.max(#targetList, #Hub.AllJobESPObjects)
    for i = 1, maxCount do
        local data = targetList[i]
        local hl = Hub.AllJobESPObjects[i]
        if data then
            if not hl or not hl.Parent then
                hl = Instance.new("Highlight")
                hl.Name = "AllJobSpotHL"
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = CoreGui
                Hub.AllJobESPObjects[i] = hl
            end
            hl.Adornee = data.Item
            hl.FillColor = data.Color
            hl.FillTransparency = 0.72
            hl.OutlineColor = data.Color
            hl.OutlineTransparency = 0.4
            hl.Enabled = true
        elseif hl then
            hl.Enabled = false
            hl.Adornee = nil
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
    task.spawn(function()
        if typeof(isfile) == "function" and typeof(writefile) == "function" and typeof(getcustomasset) == "function" then
            if not isfile("k_community_logo.png") then
                pcall(function()
                    local url = "https://raw.githubusercontent.com/armongzx56-design/KrakenHub/main/k_community_logo.png"
                    local data = game:HttpGet(url)
                    if type(data) == "string" and #data > 1000 and data:sub(1, 4) == "\137PNG" then
                        writefile("k_community_logo.png", data)
                    end
                end)
            end
        end
    end)
    if typeof(isfile) == "function" and typeof(getcustomasset) == "function" and isfile("k_community_logo.png") then
        local s, asset = pcall(getcustomasset, "k_community_logo.png")
        if s and asset then return asset end
    end
    return "rbxasset://5059d143b75fc7c70a58a871660c4f16/k_community_logo.png"
end


-- ==============================================================
-- 🎨 UI LIBRARY (EMBEDDED NATIVE MACOS UI)
-- ==============================================================
local MacLib = (function()
local MacLib = { 
	Options = {}, 
	Folder = "Maclib", 
	GetService = function(service)
		return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
	end
}

--// Services
local TweenService = MacLib.GetService("TweenService")
local RunService = MacLib.GetService("RunService")
local HttpService = MacLib.GetService("HttpService")
local ContentProvider = MacLib.GetService("ContentProvider")
local UserInputService = MacLib.GetService("UserInputService")
local Lighting = MacLib.GetService("Lighting")
local Players = MacLib.GetService("Players")

--// Variables
local isStudio = RunService:IsStudio()
local LocalPlayer = Players.LocalPlayer

local windowState
local acrylicBlur
local hasGlobalSetting

local tabs = {}
local currentTabInstance = nil
local tabIndex = 0
local unloaded = false

local assets = {
	interFont = "rbxassetid://12187365364",
	userInfoBlurred = "rbxassetid://18824089198",
	toggleBackground = "rbxassetid://18772190202",
	togglerHead = "rbxassetid://18772309008",
	buttonImage = "rbxassetid://10709791437",
	searchIcon = "rbxassetid://86737463322606",
	colorWheel = "rbxassetid://2849458409",
	colorTarget = "rbxassetid://73265255323268",
	grid = "rbxassetid://10709790948",
	globe = "rbxassetid://108952102602834",
	transform = "rbxassetid://90336395745819",
	dropdown = "rbxassetid://10709790948",
	sliderbar = "rbxassetid://18772615246",
	sliderhead = "rbxassetid://18772834246",
}

--// Functions
local function GetGui()
	local newGui = Instance.new("ScreenGui")
	newGui.Name = "KrakenHub_UI"
	pcall(function()
		if Enum and Enum.ScreenInsets and Enum.ScreenInsets.None then
			newGui.ScreenInsets = Enum.ScreenInsets.None
		end
	end)
	newGui.ResetOnSpawn = false
	newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	newGui.DisplayOrder = 2147483647

	local parent = nil
	if RunService:IsStudio() then
		parent = LocalPlayer:FindFirstChild("PlayerGui")
	else
		pcall(function()
			if gethui then parent = gethui() end
		end)
		if not parent then
			local ok = pcall(function()
				local t = Instance.new("Folder")
				local cg = (cloneref and cloneref(MacLib.GetService("CoreGui"))) or MacLib.GetService("CoreGui")
				t.Parent = cg
				t:Destroy()
				parent = cg
			end)
		end
	end
	if not parent then
		parent = LocalPlayer:WaitForChild("PlayerGui")
	end
	local setOk = pcall(function()
		newGui.Parent = parent
	end)
	if not setOk or not newGui.Parent then
		pcall(function()
			newGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end)
	end
	return newGui
end

local function Tween(instance, tweeninfo, propertytable)
	return TweenService:Create(instance, tweeninfo, propertytable)
end

--// Library Functions
function MacLib:Window(Settings)
	local WindowFunctions = {Settings = Settings}
	if Settings.AcrylicBlur ~= nil then
		acrylicBlur = Settings.AcrylicBlur
	else
		acrylicBlur = true
	end

	local macLib = GetGui()

	local notifications = Instance.new("Frame")
	notifications.Name = "Notifications"
	notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notifications.BackgroundTransparency = 1
	notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notifications.BorderSizePixel = 0
	notifications.Size = UDim2.fromScale(1, 1)
	notifications.Parent = macLib
	notifications.ZIndex = 2

	local notificationsUIListLayout = Instance.new("UIListLayout")
	notificationsUIListLayout.Name = "NotificationsUIListLayout"
	notificationsUIListLayout.Padding = UDim.new(0, 10)
	notificationsUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notificationsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notificationsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationsUIListLayout.Parent = notifications

	local notificationsUIPadding = Instance.new("UIPadding")
	notificationsUIPadding.Name = "NotificationsUIPadding"
	notificationsUIPadding.PaddingBottom = UDim.new(0, 10)
	notificationsUIPadding.PaddingLeft = UDim.new(0, 10)
	notificationsUIPadding.PaddingRight = UDim.new(0, 10)
	notificationsUIPadding.PaddingTop = UDim.new(0, 10)
	notificationsUIPadding.Parent = notifications

	local base = Instance.new("Frame")
	base.Name = "Base"
	base.AnchorPoint = Vector2.new(0.5, 0.5)
	base.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
	base.BackgroundTransparency = 0
	base.BorderColor3 = Color3.fromRGB(0, 0, 0)
	base.BorderSizePixel = 0
	base.ClipsDescendants = true
	base.Active = true
	base.Position = UDim2.fromScale(0.5, 0.5)
	base.Size = Settings.Size or UDim2.fromOffset(868, 650)

	local baseUIScale = Instance.new("UIScale")
	baseUIScale.Name = "BaseUIScale"
	baseUIScale.Parent = base

	local baseUICorner = Instance.new("UICorner")
	baseUICorner.Name = "BaseUICorner"
	baseUICorner.CornerRadius = UDim.new(0, 10)
	baseUICorner.Parent = base

	local baseUIStroke = Instance.new("UIStroke")
	baseUIStroke.Name = "BaseUIStroke"
	baseUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke.Transparency = 0.9
	baseUIStroke.Parent = base

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
	sidebar.BackgroundTransparency = 0
	sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.fromScale(-3.52e-08, 4.69e-08)
	sidebar.Size = UDim2.fromScale(0.325, 1)

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.AnchorPoint = Vector2.new(1, 0)
	divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider.BackgroundTransparency = 0.9
	divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider.BorderSizePixel = 0
	divider.Position = UDim2.fromScale(1, 0)
	divider.Size = UDim2.new(0, 1, 1, 0)
	divider.Parent = sidebar

	local dividerInteract = Instance.new("TextButton")
	dividerInteract.Name = "DividerInteract"
	dividerInteract.AnchorPoint = Vector2.new(0.5, 0)
	dividerInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dividerInteract.BackgroundTransparency = 1
	dividerInteract.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.BorderSizePixel = 0
	dividerInteract.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	dividerInteract.Position = UDim2.fromScale(0.5, 0)
	dividerInteract.Size = UDim2.new(1, 6, 1, 0)
	dividerInteract.Text = ""
	dividerInteract.TextColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.TextSize = 14
	dividerInteract.Parent = divider

	local windowControls = Instance.new("Frame")
	windowControls.Name = "WindowControls"
	windowControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	windowControls.BackgroundTransparency = 1
	windowControls.BorderColor3 = Color3.fromRGB(0, 0, 0)
	windowControls.BorderSizePixel = 0
	windowControls.Size = UDim2.new(1, 0, 0, 31)

	local controls = Instance.new("Frame")
	controls.Name = "Controls"
	controls.BackgroundColor3 = Color3.fromRGB(119, 174, 94)
	controls.BackgroundTransparency = 1
	controls.BorderColor3 = Color3.fromRGB(0, 0, 0)
	controls.BorderSizePixel = 0
	controls.Size = UDim2.fromScale(1, 1)

	local uIListLayout = Instance.new("UIListLayout")
	uIListLayout.Name = "UIListLayout"
	uIListLayout.Padding = UDim.new(0, 5)
	uIListLayout.FillDirection = Enum.FillDirection.Horizontal
	uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uIListLayout.Parent = controls

	local uIPadding = Instance.new("UIPadding")
	uIPadding.Name = "UIPadding"
	uIPadding.PaddingLeft = UDim.new(0, 11)
	uIPadding.Parent = controls

	local windowControlSettings = {
		sizes = { enabled = UDim2.fromOffset(8, 8), disabled = UDim2.fromOffset(7, 7) },
		transparencies = { enabled = 0, disabled = 1 },
		strokeTransparency = 0.9,
	}

	local stroke = Instance.new("UIStroke")
	stroke.Name = "BaseUIStroke"
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = windowControlSettings.strokeTransparency

	local exit = Instance.new("TextButton")
	exit.Name = "Exit"
	exit.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	exit.Text = ""
	exit.TextColor3 = Color3.fromRGB(0, 0, 0)
	exit.TextSize = 14
	exit.AutoButtonColor = false
	exit.BackgroundColor3 = Color3.fromRGB(250, 93, 86)
	exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
	exit.BorderSizePixel = 0

	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.CornerRadius = UDim.new(1, 0)
	uICorner.Parent = exit

	exit.Parent = controls

	local minimize = Instance.new("TextButton")
	minimize.Name = "Minimize"
	minimize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	minimize.Text = ""
	minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
	minimize.TextSize = 14
	minimize.AutoButtonColor = false
	minimize.BackgroundColor3 = Color3.fromRGB(252, 190, 57)
	minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	minimize.BorderSizePixel = 0
	minimize.LayoutOrder = 1

	local uICorner1 = Instance.new("UICorner")
	uICorner1.Name = "UICorner"
	uICorner1.CornerRadius = UDim.new(1, 0)
	uICorner1.Parent = minimize

	minimize.Parent = controls

	local maximize = Instance.new("TextButton")
	maximize.Name = "Maximize"
	maximize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	maximize.Text = ""
	maximize.TextColor3 = Color3.fromRGB(0, 0, 0)
	maximize.TextSize = 14
	maximize.AutoButtonColor = false
	maximize.BackgroundColor3 = Color3.fromRGB(119, 174, 94)
	maximize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	maximize.BorderSizePixel = 0
	maximize.LayoutOrder = 1

	local uICorner2 = Instance.new("UICorner")
	uICorner2.Name = "UICorner"
	uICorner2.CornerRadius = UDim.new(1, 0)
	uICorner2.Parent = maximize

	maximize.Parent = controls

	local function applyState(button, enabled)
		local size = enabled and windowControlSettings.sizes.enabled or windowControlSettings.sizes.disabled
		local transparency = enabled and windowControlSettings.transparencies.enabled or windowControlSettings.transparencies.disabled

		button.Size = size
		button.BackgroundTransparency = transparency
		button.Active = enabled
		button.Interactable = enabled

		for _, child in ipairs(button:GetChildren()) do
			if child:IsA("UIStroke") then
				child.Transparency = transparency
			end
		end
		if not enabled then
			stroke:Clone().Parent = button
		end
	end

	applyState(maximize, false)

	local controlsList = {exit, minimize}
	for _, button in pairs(controlsList) do
		local buttonName = button.Name
		local isEnabled = true

		if Settings.DisabledWindowControls and table.find(Settings.DisabledWindowControls, buttonName) then
			isEnabled = false
		end

		applyState(button, isEnabled)
	end

	controls.Parent = windowControls

	local divider1 = Instance.new("Frame")
	divider1.Name = "Divider"
	divider1.AnchorPoint = Vector2.new(0, 1)
	divider1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider1.BackgroundTransparency = 0.9
	divider1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider1.BorderSizePixel = 0
	divider1.Position = UDim2.fromScale(0, 1)
	divider1.Size = UDim2.new(1, 0, 0, 1)
	divider1.Parent = windowControls

	windowControls.Parent = sidebar

	local information = Instance.new("Frame")
	information.Name = "Information"
	information.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	information.BackgroundTransparency = 1
	information.BorderColor3 = Color3.fromRGB(0, 0, 0)
	information.BorderSizePixel = 0
	information.Position = UDim2.fromOffset(0, 31)
	information.Size = UDim2.new(1, 0, 0, 60)

	local divider2 = Instance.new("Frame")
	divider2.Name = "Divider"
	divider2.AnchorPoint = Vector2.new(0, 1)
	divider2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider2.BackgroundTransparency = 0.9
	divider2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider2.BorderSizePixel = 0
	divider2.Position = UDim2.fromScale(0, 1)
	divider2.Size = UDim2.new(1, 0, 0, 1)
	divider2.Parent = information

	local informationHolder = Instance.new("Frame")
	informationHolder.Name = "InformationHolder"
	informationHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationHolder.BackgroundTransparency = 1
	informationHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationHolder.BorderSizePixel = 0
	informationHolder.Size = UDim2.fromScale(1, 1)

	local informationHolderUIPadding = Instance.new("UIPadding")
	informationHolderUIPadding.Name = "InformationHolderUIPadding"
	informationHolderUIPadding.PaddingBottom = UDim.new(0, 10)
	informationHolderUIPadding.PaddingLeft = UDim.new(0, 23)
	informationHolderUIPadding.PaddingRight = UDim.new(0, 22)
	informationHolderUIPadding.PaddingTop = UDim.new(0, 10)
	informationHolderUIPadding.Parent = informationHolder

	local globalSettingsButton = Instance.new("ImageButton")
	globalSettingsButton.Name = "GlobalSettingsButton"
	globalSettingsButton.Image = assets.globe
	globalSettingsButton.ImageTransparency = 0.5
	globalSettingsButton.AnchorPoint = Vector2.new(1, 0.5)
	globalSettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	globalSettingsButton.BackgroundTransparency = 1
	globalSettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettingsButton.BorderSizePixel = 0
	globalSettingsButton.Position = UDim2.fromScale(1, 0.5)
	globalSettingsButton.Size = UDim2.fromOffset(16,16)
	globalSettingsButton.Parent = informationHolder

	local function ChangeGlobalSettingsButtonState(State)
		if State == "Default" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.5
			}):Play()
		elseif State == "Hover" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.3
			}):Play()
		end
	end

	globalSettingsButton.MouseEnter:Connect(function()
		ChangeGlobalSettingsButtonState("Hover")
	end)
	globalSettingsButton.MouseLeave:Connect(function()
		ChangeGlobalSettingsButtonState("Default")
	end)

	local titleFrame = Instance.new("Frame")
	titleFrame.Name = "TitleFrame"
	titleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleFrame.BackgroundTransparency = 1
	titleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	titleFrame.BorderSizePixel = 0
	titleFrame.Size = UDim2.fromScale(1, 1)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	title.Text = Settings.Title
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.RichText = true
	title.TextSize = 18
	title.TextTransparency = 0.1
	title.TextTruncate = Enum.TextTruncate.SplitWord
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	title.BorderSizePixel = 0
	title.Size = UDim2.new(1, -20, 0, 0)
	title.Parent = titleFrame

	-- ✨ แสงปาดวน Loop บนหัวข้อชื่อ (Title Shimmer Sheen Effect)
	local titleShimmer = Instance.new("UIGradient")
	titleShimmer.Name = "ShimmerGradient"
	titleShimmer.Rotation = 25
	titleShimmer.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 190, 210)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(190, 200, 220)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.65, Color3.fromRGB(120, 220, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 190, 210))
	})
	titleShimmer.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.35),
		NumberSequenceKeypoint.new(0.35, 0.35),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.65, 0.35),
		NumberSequenceKeypoint.new(1, 0.35)
	})
	titleShimmer.Offset = Vector2.new(-1, 0)
	titleShimmer.Parent = title

	task.spawn(function()
		while title and title.Parent and titleShimmer.Parent == title do
			titleShimmer.Offset = Vector2.new(-1, 0)
			local t = TweenService:Create(titleShimmer, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Offset = Vector2.new(1, 0)
			})
			t:Play()
			t.Completed:Wait()
			task.wait(1.0)
		end
	end)

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	subtitle.RichText = true
	subtitle.Text = Settings.Subtitle
	subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.TextSize = 12
	subtitle.TextTransparency = 0.7
	subtitle.TextTruncate = Enum.TextTruncate.SplitWord
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextYAlignment = Enum.TextYAlignment.Top
	subtitle.AutomaticSize = Enum.AutomaticSize.Y
	subtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.BackgroundTransparency = 1
	subtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	subtitle.BorderSizePixel = 0
	subtitle.LayoutOrder = 1
	subtitle.Size = UDim2.new(1, -20, 0, 0)
	subtitle.Parent = titleFrame

	local titleFrameUIListLayout = Instance.new("UIListLayout")
	titleFrameUIListLayout.Name = "TitleFrameUIListLayout"
	titleFrameUIListLayout.Padding = UDim.new(0, 3)
	titleFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	titleFrameUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	titleFrameUIListLayout.Parent = titleFrame

	titleFrame.Parent = informationHolder

	informationHolder.Parent = information

	information.Parent = sidebar

	local sidebarGroup = Instance.new("Frame")
	sidebarGroup.Name = "SidebarGroup"
	sidebarGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebarGroup.BackgroundTransparency = 1
	sidebarGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebarGroup.BorderSizePixel = 0
	sidebarGroup.Position = UDim2.fromOffset(0, 91)
	sidebarGroup.Size = UDim2.new(1, 0, 1, -91)

	local userInfo = Instance.new("Frame")
	userInfo.Name = "UserInfo"
	userInfo.AnchorPoint = Vector2.new(0, 1)
	userInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userInfo.BackgroundTransparency = 1
	userInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userInfo.BorderSizePixel = 0
	userInfo.Position = UDim2.fromScale(0, 1)
	userInfo.Size = UDim2.new(1, 0, 0, 107)

	local informationGroup = Instance.new("Frame")
	informationGroup.Name = "InformationGroup"
	informationGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationGroup.BackgroundTransparency = 1
	informationGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationGroup.BorderSizePixel = 0
	informationGroup.Size = UDim2.fromScale(1, 1)

	local informationGroupUIPadding = Instance.new("UIPadding")
	informationGroupUIPadding.Name = "InformationGroupUIPadding"
	informationGroupUIPadding.PaddingBottom = UDim.new(0, 17)
	informationGroupUIPadding.PaddingLeft = UDim.new(0, 25)
	informationGroupUIPadding.Parent = informationGroup

	local informationGroupUIListLayout = Instance.new("UIListLayout")
	informationGroupUIListLayout.Name = "InformationGroupUIListLayout"
	informationGroupUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	informationGroupUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	informationGroupUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	informationGroupUIListLayout.Parent = informationGroup

	local userId = LocalPlayer.UserId
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size48x48
	local headshotImage, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

	local headshot = Instance.new("ImageLabel")
	headshot.Name = "Headshot"
	headshot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	headshot.BackgroundTransparency = 1
	headshot.BorderColor3 = Color3.fromRGB(0, 0, 0)
	headshot.BorderSizePixel = 0
	headshot.Size = UDim2.fromOffset(32, 32)
	headshot.Image = (isReady and headshotImage) or "rbxassetid://0"

	local uICorner3 = Instance.new("UICorner")
	uICorner3.Name = "UICorner"
	uICorner3.CornerRadius = UDim.new(1, 0)
	uICorner3.Parent = headshot

	local baseUIStroke2 = Instance.new("UIStroke")
	baseUIStroke2.Name = "BaseUIStroke"
	baseUIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke2.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke2.Transparency = 0.9
	baseUIStroke2.Parent = headshot

	-- 🟢 จุดสถานะออนไลน์ (Online Status Indicator) สีเขียวนีออน
	local onlineDot = Instance.new("Frame")
	onlineDot.Name = "OnlineBadge"
	onlineDot.Size = UDim2.fromOffset(9, 9)
	onlineDot.Position = UDim2.new(1, -2, 1, -2)
	onlineDot.AnchorPoint = Vector2.new(0.5, 0.5)
	onlineDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
	onlineDot.BorderSizePixel = 0
	onlineDot.ZIndex = 5

	local onlineCorner = Instance.new("UICorner")
	onlineCorner.CornerRadius = UDim.new(1, 0)
	onlineCorner.Parent = onlineDot

	local onlineStroke = Instance.new("UIStroke")
	onlineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	onlineStroke.Color = Color3.fromRGB(15, 15, 20)
	onlineStroke.Thickness = 1.5
	onlineStroke.Parent = onlineDot

	onlineDot.Parent = headshot

	headshot.Parent = informationGroup

	local userAndDisplayFrame = Instance.new("Frame")
	userAndDisplayFrame.Name = "UserAndDisplayFrame"
	userAndDisplayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userAndDisplayFrame.BackgroundTransparency = 1
	userAndDisplayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userAndDisplayFrame.BorderSizePixel = 0
	userAndDisplayFrame.LayoutOrder = 1
	userAndDisplayFrame.Size = UDim2.new(1, -42, 0, 32)

	local displayName = Instance.new("TextLabel")
	displayName.Name = "DisplayName"
	displayName.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	displayName.Text = LocalPlayer.DisplayName
	displayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	displayName.TextSize = 13
	displayName.TextTransparency = 0.1
	displayName.TextTruncate = Enum.TextTruncate.SplitWord
	displayName.TextXAlignment = Enum.TextXAlignment.Left
	displayName.TextYAlignment = Enum.TextYAlignment.Top
	displayName.AutomaticSize = Enum.AutomaticSize.XY
	displayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	displayName.BackgroundTransparency = 1
	displayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	displayName.BorderSizePixel = 0
	displayName.Parent = userAndDisplayFrame
	displayName.Size = UDim2.fromScale(1,0)

	local userAndDisplayFrameUIPadding = Instance.new("UIPadding")
	userAndDisplayFrameUIPadding.Name = "UserAndDisplayFrameUIPadding"
	userAndDisplayFrameUIPadding.PaddingLeft = UDim.new(0, 8)
	userAndDisplayFrameUIPadding.PaddingTop = UDim.new(0, 3)
	userAndDisplayFrameUIPadding.Parent = userAndDisplayFrame

	local userAndDisplayFrameUIListLayout = Instance.new("UIListLayout")
	userAndDisplayFrameUIListLayout.Name = "UserAndDisplayFrameUIListLayout"
	userAndDisplayFrameUIListLayout.Padding = UDim.new(0, 1)
	userAndDisplayFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	userAndDisplayFrameUIListLayout.Parent = userAndDisplayFrame

	local username = Instance.new("TextLabel")
	username.Name = "Username"
	username.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	username.Text = "@" .. LocalPlayer.Name
	username.TextColor3 = Color3.fromRGB(255, 255, 255)
	username.TextSize = 12
	username.TextTransparency = 0.7
	username.TextTruncate = Enum.TextTruncate.SplitWord
	username.TextXAlignment = Enum.TextXAlignment.Left
	username.TextYAlignment = Enum.TextYAlignment.Top
	username.AutomaticSize = Enum.AutomaticSize.XY
	username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	username.BackgroundTransparency = 1
	username.BorderColor3 = Color3.fromRGB(0, 0, 0)
	username.BorderSizePixel = 0
	username.LayoutOrder = 1
	username.Parent = userAndDisplayFrame
	username.Size = UDim2.fromScale(1,0)

	userAndDisplayFrame.Parent = informationGroup

	informationGroup.Parent = userInfo

	local userInfoUIPadding = Instance.new("UIPadding")
	userInfoUIPadding.Name = "UserInfoUIPadding"
	userInfoUIPadding.PaddingLeft = UDim.new(0, 10)
	userInfoUIPadding.PaddingRight = UDim.new(0, 10)
	userInfoUIPadding.Parent = userInfo

	userInfo.Parent = sidebarGroup

	local sidebarGroupUIPadding = Instance.new("UIPadding")
	sidebarGroupUIPadding.Name = "SidebarGroupUIPadding"
	sidebarGroupUIPadding.PaddingLeft = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingRight = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingTop = UDim.new(0, 31)
	sidebarGroupUIPadding.Parent = sidebarGroup

	local tabSwitchers = Instance.new("Frame")
	tabSwitchers.Name = "TabSwitchers"
	tabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchers.BackgroundTransparency = 1
	tabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchers.BorderSizePixel = 0
	tabSwitchers.Size = UDim2.new(1, 0, 1, -107)

	local tabSwitchersScrollingFrame = Instance.new("ScrollingFrame")
	tabSwitchersScrollingFrame.Name = "TabSwitchersScrollingFrame"
	tabSwitchersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabSwitchersScrollingFrame.BottomImage = ""
	tabSwitchersScrollingFrame.CanvasSize = UDim2.new()
	tabSwitchersScrollingFrame.ScrollBarImageTransparency = 0.8
	tabSwitchersScrollingFrame.ScrollBarThickness = 1
	tabSwitchersScrollingFrame.TopImage = ""
	tabSwitchersScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchersScrollingFrame.BackgroundTransparency = 1
	tabSwitchersScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchersScrollingFrame.BorderSizePixel = 0
	tabSwitchersScrollingFrame.Size = UDim2.fromScale(1, 1)

	local tabSwitchersScrollingFrameUIListLayout = Instance.new("UIListLayout")
	tabSwitchersScrollingFrameUIListLayout.Name = "TabSwitchersScrollingFrameUIListLayout"
	tabSwitchersScrollingFrameUIListLayout.Padding = UDim.new(0, 17)
	tabSwitchersScrollingFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabSwitchersScrollingFrameUIListLayout.Parent = tabSwitchersScrollingFrame

	local tabSwitchersScrollingFrameUIPadding = Instance.new("UIPadding")
	tabSwitchersScrollingFrameUIPadding.Name = "TabSwitchersScrollingFrameUIPadding"
	tabSwitchersScrollingFrameUIPadding.PaddingTop = UDim.new(0, 2)
	tabSwitchersScrollingFrameUIPadding.Parent = tabSwitchersScrollingFrame

	tabSwitchersScrollingFrame.Parent = tabSwitchers

	tabSwitchers.Parent = sidebarGroup

	sidebarGroup.Parent = sidebar

	sidebar.Parent = base

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.AnchorPoint = Vector2.new(1, 0)
	content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	content.BackgroundTransparency = 1
	content.BorderColor3 = Color3.fromRGB(0, 0, 0)
	content.BorderSizePixel = 0
	content.Position = UDim2.fromScale(1, 4.69e-08)
	content.Size = UDim2.new(0, (base.AbsoluteSize.X - sidebar.AbsoluteSize.X), 1, 0)

	local resizingContent = false
	local defaultSidebarWidth = sidebar.AbsoluteSize.X
	local initialMouseX, initialSidebarWidth
	local snapRange = 20
	local minSidebarWidth = 107
	local maxSidebarWidth = base.AbsoluteSize.X - minSidebarWidth

	local TweenSettings = {
		DefaultTransparency = 0.9,
		HoverTransparency = 0.85,

		EasingStyle = Enum.EasingStyle.Sine
	}

	local function ChangeState(State)
		Tween(divider, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
			BackgroundTransparency = State == "Idle" and TweenSettings.DefaultTransparency or TweenSettings.HoverTransparency
		}):Play()  
	end

	dividerInteract.MouseEnter:Connect(function()
		ChangeState("Hover")
	end)
	dividerInteract.MouseLeave:Connect(function()
		ChangeState("Idle")
	end)

	dividerInteract.MouseButton1Down:Connect(function()
		resizingContent = true
		initialMouseX = UserInputService:GetMouseLocation().X
		initialSidebarWidth = sidebar.AbsoluteSize.X
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizingContent = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizingContent and input.UserInputType == Enum.UserInputType.MouseMovement then
			local deltaX = UserInputService:GetMouseLocation().X - initialMouseX
			local newSidebarWidth = initialSidebarWidth + deltaX

			if math.abs(newSidebarWidth - defaultSidebarWidth) < snapRange then
				newSidebarWidth = defaultSidebarWidth
			else
				newSidebarWidth = math.clamp(newSidebarWidth, minSidebarWidth, maxSidebarWidth)
			end

			sidebar.Size = UDim2.new(0, newSidebarWidth, 1, 0)
			content.Size = UDim2.new(0, base.AbsoluteSize.X - newSidebarWidth, 1, 0)
		end
	end)

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	topbar.BackgroundTransparency = 1
	topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	topbar.BorderSizePixel = 0
	topbar.Size = UDim2.new(1, 0, 0, 63)

	local divider4 = Instance.new("Frame")
	divider4.Name = "Divider"
	divider4.AnchorPoint = Vector2.new(0, 1)
	divider4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider4.BackgroundTransparency = 0.9
	divider4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider4.BorderSizePixel = 0
	divider4.Position = UDim2.fromScale(0, 1)
	divider4.Size = UDim2.new(1, 0, 0, 1)
	divider4.Parent = topbar

	local elements = Instance.new("Frame")
	elements.Name = "Elements"
	elements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	elements.BackgroundTransparency = 1
	elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
	elements.BorderSizePixel = 0
	elements.Size = UDim2.fromScale(1, 1)

	local uIPadding2 = Instance.new("UIPadding")
	uIPadding2.Name = "UIPadding"
	uIPadding2.PaddingLeft = UDim.new(0, 20)
	uIPadding2.PaddingRight = UDim.new(0, 20)
	uIPadding2.Parent = elements

	local moveIcon = Instance.new("ImageButton")
	moveIcon.Name = "MoveIcon"
	moveIcon.Image = assets.transform
	moveIcon.ImageTransparency = 0.7
	moveIcon.AnchorPoint = Vector2.new(1, 0.5)
	moveIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	moveIcon.BackgroundTransparency = 1
	moveIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	moveIcon.BorderSizePixel = 0
	moveIcon.Position = UDim2.fromScale(1, 0.5)
	moveIcon.Size = UDim2.fromOffset(15, 15)
	moveIcon.Parent = elements
	moveIcon.Visible = not Settings.DragStyle or Settings.DragStyle == 1

	local interact = Instance.new("TextButton")
	interact.Name = "Interact"
	interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	interact.Text = ""
	interact.TextColor3 = Color3.fromRGB(0, 0, 0)
	interact.TextSize = 14
	interact.AnchorPoint = Vector2.new(0.5, 0.5)
	interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	interact.BackgroundTransparency = 1
	interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
	interact.BorderSizePixel = 0
	interact.Position = UDim2.fromScale(0.5, 0.5)
	interact.Size = UDim2.fromOffset(40, 40)
	interact.Parent = moveIcon

	local function ChangemoveIconState(State)
		if State == "Default" then
			Tween(moveIcon, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.7
			}):Play()
		elseif State == "Hover" then
			Tween(moveIcon, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.4
			}):Play()
		end
	end

	interact.MouseEnter:Connect(function()
		ChangemoveIconState("Hover")
	end)
	interact.MouseLeave:Connect(function()
		ChangemoveIconState("Default")
	end)

	local dragging_ = false
	local dragInput
	local dragStart
	local startPos

	-- // 📱 MOBILE OPTIMIZATION & ZERO-LATENCY DIRECT UPDATE //
	local isResizing_ = false
	local resizeInput_
	local resizeStart_
	local startSize_

	local camera_ = workspace.CurrentCamera
	local GuiService = MacLib.GetService("GuiService")

	local function clampBasePosition(targetX, targetY, w, h)
		local vp = camera_ and camera_.ViewportSize or Vector2.new(1920, 1080)
		local inset = GuiService:GetGuiInset()
		local halfW = w * 0.5
		local halfH = h * 0.5
		local minX = halfW
		local maxX = math.max(halfW, vp.X - halfW)
		local minY = halfH + inset.Y
		local maxY = math.max(minY, vp.Y - halfH)

		local clampedX = math.clamp(targetX, minX, maxX)
		local clampedY = math.clamp(targetY, minY, maxY)
		return UDim2.fromOffset(clampedX, clampedY)
	end

	local function update(input)
		local delta = input.Position - dragStart
		local absSize = base.AbsoluteSize
		local targetX = startPos.X + delta.X
		local targetY = startPos.Y + delta.Y
		base.Position = clampBasePosition(targetX, targetY, absSize.X, absSize.Y)
	end

	local function onDragStart(input)
		if isResizing_ then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging_ = true
			dragInput = input
			dragStart = input.Position
			startPos = Vector2.new(base.AbsolutePosition.X + (base.AbsoluteSize.X * 0.5), base.AbsolutePosition.Y + (base.AbsoluteSize.Y * 0.5))

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging_ = false
					dragInput = nil
				end
			end)
		end
	end

	local function onDragUpdate(input)
		if dragging_ and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input
		end
	end

	-- แตะส่วนว่างบน Base เพื่อลากย้ายได้เสมอ
	base.InputBegan:Connect(function(input)
		if isResizing_ then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			onDragStart(input)
		end
	end)

	base.InputChanged:Connect(onDragUpdate)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging_ then
			update(input)
		elseif input == resizeInput_ and isResizing_ then
			local delta = input.Position - resizeStart_
			local minW, minH = 320, 220
			local maxW = camera_ and camera_.ViewportSize.X or 1200
			local maxH = camera_ and camera_.ViewportSize.Y or 900
			local newW = math.clamp(startSize_.X + delta.X, minW, maxW)
			local newH = math.clamp(startSize_.Y + delta.Y, minH, maxH)
			base.Size = UDim2.fromOffset(newW, newH)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging_ = false
			dragInput = nil
		end
		if input == resizeInput_ or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isResizing_ = false
			resizeInput_ = nil
		end
	end)

	if moveIcon and interact then
		interact.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				onDragStart(input)
			end
		end)
		interact.InputChanged:Connect(onDragUpdate)
	end

	-- // 📐 RESIZE HANDLE AT BOTTOM-RIGHT CORNER (MOBILE FRIENDLY) //
	local resizeHandle = Instance.new("ImageButton")
	resizeHandle.Name = "ResizeHandle"
	resizeHandle.Size = UDim2.fromOffset(40, 40)
	resizeHandle.AnchorPoint = Vector2.new(1, 1)
	resizeHandle.Position = UDim2.new(1, 0, 1, 0)
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.ZIndex = 50
	resizeHandle.Active = true
	resizeHandle.Parent = base

	local resizeIcon = Instance.new("TextLabel")
	resizeIcon.Name = "ResizeIcon"
	resizeIcon.Size = UDim2.fromScale(1, 1)
	resizeIcon.BackgroundTransparency = 1
	resizeIcon.Text = "◢"
	resizeIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
	resizeIcon.TextTransparency = 0.5
	resizeIcon.TextSize = 16
	resizeIcon.TextXAlignment = Enum.TextXAlignment.Right
	resizeIcon.TextYAlignment = Enum.TextYAlignment.Bottom
	resizeIcon.ZIndex = resizeHandle.ZIndex + 1
	resizeIcon.Parent = resizeHandle

	local resizePadding = Instance.new("UIPadding")
	resizePadding.PaddingRight = UDim.new(0, 4)
	resizePadding.PaddingBottom = UDim.new(0, 4)
	resizePadding.Parent = resizeHandle

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isResizing_ = true
			resizeInput_ = input
			resizeStart_ = input.Position
			startSize_ = base.AbsoluteSize

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					isResizing_ = false
					resizeInput_ = nil
				end
			end)
		end
	end)

	local currentTab = Instance.new("TextLabel")
	currentTab.Name = "CurrentTab"
	currentTab.FontFace = Font.new(assets.interFont)
	currentTab.RichText = true
	currentTab.Text = ""
	currentTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.TextSize = 15
	currentTab.TextTransparency = 0.5
	currentTab.TextTruncate = Enum.TextTruncate.SplitWord
	currentTab.TextXAlignment = Enum.TextXAlignment.Left
	currentTab.TextYAlignment = Enum.TextYAlignment.Top
	currentTab.AnchorPoint = Vector2.new(0, 0.5)
	currentTab.AutomaticSize = Enum.AutomaticSize.Y
	currentTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.BackgroundTransparency = 1
	currentTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	currentTab.BorderSizePixel = 0
	currentTab.Position = UDim2.fromScale(0, 0.5)
	currentTab.Size = UDim2.fromScale(0.9, 0)
	currentTab.Parent = elements

	elements.Parent = topbar

	topbar.Parent = content

	content.Parent = base

	local globalSettings = Instance.new("Frame")
	globalSettings.Name = "GlobalSettings"
	globalSettings.AutomaticSize = Enum.AutomaticSize.XY
	globalSettings.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	globalSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettings.BorderSizePixel = 0
	globalSettings.Position = UDim2.fromScale(0.298, 0.104)

	local globalSettingsUIStroke = Instance.new("UIStroke")
	globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
	globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
	globalSettingsUIStroke.Transparency = 0.9
	globalSettingsUIStroke.Parent = globalSettings

	local globalSettingsUICorner = Instance.new("UICorner")
	globalSettingsUICorner.Name = "GlobalSettingsUICorner"
	globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
	globalSettingsUICorner.Parent = globalSettings

	local globalSettingsUIPadding = Instance.new("UIPadding")
	globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
	globalSettingsUIPadding.PaddingBottom = UDim.new(0, 10)
	globalSettingsUIPadding.PaddingTop = UDim.new(0, 10)
	globalSettingsUIPadding.Parent = globalSettings

	local globalSettingsUIListLayout = Instance.new("UIListLayout")
	globalSettingsUIListLayout.Name = "GlobalSettingsUIListLayout"
	globalSettingsUIListLayout.Padding = UDim.new(0, 5)
	globalSettingsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	globalSettingsUIListLayout.Parent = globalSettings

	local globalSettingsUIScale = Instance.new("UIScale")
	globalSettingsUIScale.Name = "GlobalSettingsUIScale"
	globalSettingsUIScale.Scale = 1e-07
	globalSettingsUIScale.Parent = globalSettings
	globalSettings.Parent = base
	base.Parent = macLib

	function WindowFunctions:UpdateTitle(NewTitle)
		title.Text = NewTitle
	end

	function WindowFunctions:UpdateSubtitle(NewSubtitle)
		subtitle.Text = NewSubtitle
	end

	local hovering
	local toggled = globalSettingsUIScale.Scale == 1 and true or false
	local function toggle()
		if not toggled then
			local intween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 1
			})
			intween:Play()
			intween.Completed:Wait()
			toggled = true
		elseif toggled then
			local outtween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 0
			})
			outtween:Play()
			outtween.Completed:Wait()
			toggled = false
		end
	end
	globalSettingsButton.MouseButton1Click:Connect(function()
		if not hasGlobalSetting then return end
		toggle()
	end)
	globalSettings.MouseEnter:Connect(function()
		hovering = true
	end)
	globalSettings.MouseLeave:Connect(function()
		hovering = false
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 and toggled and not hovering then
			toggle()
		end
	end)

	function WindowFunctions:GlobalSetting(Settings)
		hasGlobalSetting = true
		local GlobalSettingFunctions = {}
		local globalSetting = Instance.new("TextButton")
		globalSetting.Name = "GlobalSetting"
		globalSetting.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
		globalSetting.Text = ""
		globalSetting.TextColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.TextSize = 14
		globalSetting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		globalSetting.BackgroundTransparency = 1
		globalSetting.BorderColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.BorderSizePixel = 0
		globalSetting.Size = UDim2.fromOffset(200, 30)

		local globalSettingToggleUIPadding = Instance.new("UIPadding")
		globalSettingToggleUIPadding.Name = "GlobalSettingToggleUIPadding"
		globalSettingToggleUIPadding.PaddingLeft = UDim.new(0, 15)
		globalSettingToggleUIPadding.Parent = globalSetting

		local settingName = Instance.new("TextLabel")
		settingName.Name = "SettingName"
		settingName.FontFace = Font.new(assets.interFont)
		settingName.Text = Settings.Name
		settingName.RichText = true
		settingName.TextColor3 = Color3.fromRGB(255, 255, 255)
		settingName.TextSize = 13
		settingName.TextTransparency = 0.5
		settingName.TextTruncate = Enum.TextTruncate.SplitWord
		settingName.TextXAlignment = Enum.TextXAlignment.Left
		settingName.TextYAlignment = Enum.TextYAlignment.Top
		settingName.AnchorPoint = Vector2.new(0, 0.5)
		settingName.AutomaticSize = Enum.AutomaticSize.Y
		settingName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		settingName.BackgroundTransparency = 1
		settingName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		settingName.BorderSizePixel = 0
		settingName.Position = UDim2.fromScale(1.3e-07, 0.5)
		settingName.Size = UDim2.new(1,-40,0,0)
		settingName.Parent = globalSetting

		local globalSettingToggleUIListLayout = Instance.new("UIListLayout")
		globalSettingToggleUIListLayout.Name = "GlobalSettingToggleUIListLayout"
		globalSettingToggleUIListLayout.Padding = UDim.new(0, 10)
		globalSettingToggleUIListLayout.FillDirection = Enum.FillDirection.Horizontal
		globalSettingToggleUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		globalSettingToggleUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		globalSettingToggleUIListLayout.Parent = globalSetting

		local checkmark = Instance.new("TextLabel")
		checkmark.Name = "Checkmark"
		checkmark.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		checkmark.Text = "✓"
		checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.TextSize = 13
		checkmark.TextTransparency = 1
		checkmark.TextXAlignment = Enum.TextXAlignment.Left
		checkmark.TextYAlignment = Enum.TextYAlignment.Top
		checkmark.AnchorPoint = Vector2.new(0, 0.5)
		checkmark.AutomaticSize = Enum.AutomaticSize.Y
		checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.BackgroundTransparency = 1
		checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		checkmark.BorderSizePixel = 0
		checkmark.LayoutOrder = -1
		checkmark.Position = UDim2.fromScale(1.3e-07, 0.5)
		checkmark.Size = UDim2.fromOffset(-10, 0)
		checkmark.Parent = globalSetting

		globalSetting.Parent = globalSettings

		local tweensettings = {
			duration = 0.2,
			easingStyle = Enum.EasingStyle.Quint,
			transparencyIn = 0.2,
			transparencyOut = 0.5,
			checkSizeIncrease = 12,
			checkSizeDecrease = -globalSettingToggleUIListLayout.Padding.Offset,
			waitTime = 1
		}

		local tweens = {
			checkIn = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			checkOut = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			nameIn = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyIn
			}),
			nameOut = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyOut
			})
		}

		local function Toggle(State)
			if not State then
				tweens.checkOut:Play()
				tweens.nameOut:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X <= 0 then
						checkmark.TextTransparency = 1
					end
				end)
			else
				tweens.checkIn:Play()
				tweens.nameIn:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X > 0 then
						checkmark.TextTransparency = 0
					end
				end)
			end
		end

		local toggled = Settings.Default
		Toggle(toggled)

		globalSetting.MouseButton1Click:Connect(function()
			toggled = not toggled
			Toggle(toggled)

			task.spawn(function()
				if Settings.Callback then
					Settings.Callback(toggled)
				end
			end)
		end)

		function GlobalSettingFunctions:UpdateName(NewName)
			settingName.Text = NewName
		end

		function GlobalSettingFunctions:UpdateState(NewState)
			Toggle(NewState)
			toggled = NewState
		end

		return GlobalSettingFunctions
	end

	function WindowFunctions:TabGroup()
		local SectionFunctions = {}

		local tabGroup = Instance.new("Frame")
		tabGroup.Name = "Section"
		tabGroup.AutomaticSize = Enum.AutomaticSize.Y
		tabGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabGroup.BackgroundTransparency = 1
		tabGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabGroup.BorderSizePixel = 0
		tabGroup.Size = UDim2.fromScale(1, 0)

		local divider3 = Instance.new("Frame")
		divider3.Name = "Divider"
		divider3.AnchorPoint = Vector2.new(0.5, 1)
		divider3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		divider3.BackgroundTransparency = 0.9
		divider3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		divider3.BorderSizePixel = 0
		divider3.Position = UDim2.fromScale(0.5, 1)
		divider3.Size = UDim2.new(1, -21, 0, 1)
		divider3.Parent = tabGroup

		local sectionTabSwitchers = Instance.new("Frame")
		sectionTabSwitchers.Name = "SectionTabSwitchers"
		sectionTabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sectionTabSwitchers.BackgroundTransparency = 1
		sectionTabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		sectionTabSwitchers.BorderSizePixel = 0
		sectionTabSwitchers.Size = UDim2.fromScale(1, 1)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 15)
		uIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = sectionTabSwitchers

		local uIPadding1 = Instance.new("UIPadding")
		uIPadding1.Name = "UIPadding"
		uIPadding1.PaddingBottom = UDim.new(0, 15)
		uIPadding1.Parent = sectionTabSwitchers

		sectionTabSwitchers.Parent = tabGroup
		tabGroup.Parent = tabSwitchersScrollingFrame

		function SectionFunctions:Tab(Settings)
			local TabFunctions = {Settings = Settings}
			local tabSwitcher = Instance.new("TextButton")
			tabSwitcher.Name = "TabSwitcher"
			tabSwitcher.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			tabSwitcher.Text = ""
			tabSwitcher.TextColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.TextSize = 14
			tabSwitcher.AutoButtonColor = false
			tabSwitcher.AnchorPoint = Vector2.new(0.5, 0)
			tabSwitcher.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcher.BackgroundTransparency = 1
			tabSwitcher.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.BorderSizePixel = 0
			tabSwitcher.Position = UDim2.fromScale(0.5, 0)
			tabSwitcher.Size = UDim2.new(1, -21, 0, 40)

			tabIndex += 1
			tabSwitcher.LayoutOrder = tabIndex

			local tabSwitcherUICorner = Instance.new("UICorner")
			tabSwitcherUICorner.Name = "TabSwitcherUICorner"
			tabSwitcherUICorner.Parent = tabSwitcher

			local tabSwitcherUIStroke = Instance.new("UIStroke")
			tabSwitcherUIStroke.Name = "TabSwitcherUIStroke"
			tabSwitcherUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			tabSwitcherUIStroke.Color = Color3.fromRGB(255, 255, 255)
			tabSwitcherUIStroke.Transparency = 1
			tabSwitcherUIStroke.Parent = tabSwitcher

			local tabSwitcherUIListLayout = Instance.new("UIListLayout")
			tabSwitcherUIListLayout.Name = "TabSwitcherUIListLayout"
			tabSwitcherUIListLayout.Padding = UDim.new(0, 9)
			tabSwitcherUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			tabSwitcherUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabSwitcherUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			tabSwitcherUIListLayout.Parent = tabSwitcher

			local tabImage

			if Settings.Image then
				tabImage = Instance.new("ImageLabel")
				tabImage.Name = "TabImage"
				tabImage.Image = Settings.Image
				tabImage.ImageTransparency = 0.5
				tabImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				tabImage.BackgroundTransparency = 1
				tabImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				tabImage.BorderSizePixel = 0
				tabImage.Size = UDim2.fromOffset(18, 18)
				tabImage.Parent = tabSwitcher
			end

			local tabSwitcherName = Instance.new("TextLabel")
			tabSwitcherName.Name = "TabSwitcherName"
			tabSwitcherName.FontFace = Font.new(
				assets.interFont,
				Enum.FontWeight.Medium,
				Enum.FontStyle.Normal
			)
			tabSwitcherName.Text = Settings.Name
			tabSwitcherName.RichText = true
			tabSwitcherName.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.TextSize = 16
			tabSwitcherName.TextTransparency = 0.5
			tabSwitcherName.TextTruncate = Enum.TextTruncate.SplitWord
			tabSwitcherName.TextXAlignment = Enum.TextXAlignment.Left
			tabSwitcherName.TextYAlignment = Enum.TextYAlignment.Top
			tabSwitcherName.AutomaticSize = Enum.AutomaticSize.Y
			tabSwitcherName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.BackgroundTransparency = 1
			tabSwitcherName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcherName.BorderSizePixel = 0
			tabSwitcherName.Size = UDim2.fromScale(1, 0)
			tabSwitcherName.Parent = tabSwitcher
			tabSwitcherName.LayoutOrder = 1

			local tabSwitcherUIPadding = Instance.new("UIPadding")
			tabSwitcherUIPadding.Name = "TabSwitcherUIPadding"
			tabSwitcherUIPadding.PaddingLeft = UDim.new(0, 24)
			tabSwitcherUIPadding.PaddingRight = UDim.new(0, 35)
			tabSwitcherUIPadding.PaddingTop = UDim.new(0, 1)
			tabSwitcherUIPadding.Parent = tabSwitcher

			tabSwitcher.Parent = sectionTabSwitchers

			local elements1 = Instance.new("Frame")
			elements1.Name = "Elements"
			elements1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elements1.BackgroundTransparency = 1
			elements1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elements1.BorderSizePixel = 0
			elements1.Position = UDim2.fromOffset(0, 63)
			elements1.Size = UDim2.new(1, 0, 1, -63)
			elements1.ClipsDescendants = true

			local elementsUIPadding = Instance.new("UIPadding")
			elementsUIPadding.Name = "ElementsUIPadding"
			elementsUIPadding.PaddingRight = UDim.new(0, 5)
			elementsUIPadding.PaddingTop = UDim.new(0, 10)
			elementsUIPadding.PaddingBottom = UDim.new(0, 10)
			elementsUIPadding.Parent = elements1

			local elementsScrolling = Instance.new("ScrollingFrame")
			elementsScrolling.Name = "ElementsScrolling"
			elementsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
			elementsScrolling.BottomImage = ""
			elementsScrolling.CanvasSize = UDim2.new()
			elementsScrolling.ScrollBarImageTransparency = 0.5
			elementsScrolling.ScrollBarThickness = 1
			elementsScrolling.TopImage = ""
			elementsScrolling.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elementsScrolling.BackgroundTransparency = 1
			elementsScrolling.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elementsScrolling.BorderSizePixel = 0
			elementsScrolling.Size = UDim2.fromScale(1, 1)
			elementsScrolling.ClipsDescendants = false

			local elementsScrollingUIPadding = Instance.new("UIPadding")
			elementsScrollingUIPadding.Name = "ElementsScrollingUIPadding"
			elementsScrollingUIPadding.PaddingBottom = UDim.new(0, 5)
			elementsScrollingUIPadding.PaddingLeft = UDim.new(0, 11)
			elementsScrollingUIPadding.PaddingRight = UDim.new(0, 3)
			elementsScrollingUIPadding.PaddingTop = UDim.new(0, 5)
			elementsScrollingUIPadding.Parent = elementsScrolling

			local elementsScrollingUIListLayout = Instance.new("UIListLayout")
			elementsScrollingUIListLayout.Name = "ElementsScrollingUIListLayout"
			elementsScrollingUIListLayout.Padding = UDim.new(0, 15)
			elementsScrollingUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			elementsScrollingUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			elementsScrollingUIListLayout.Parent = elementsScrolling

			local left = Instance.new("Frame")
			left.Name = "Left"
			left.AutomaticSize = Enum.AutomaticSize.Y
			left.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			left.BackgroundTransparency = 1
			left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			left.BorderSizePixel = 0
			left.Position = UDim2.fromScale(0.512, 0)
			left.Size = UDim2.new(0.5, -10, 0, 0)

			local leftUIListLayout = Instance.new("UIListLayout")
			leftUIListLayout.Name = "LeftUIListLayout"
			leftUIListLayout.Padding = UDim.new(0, 15)
			leftUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			leftUIListLayout.Parent = left

			left.Parent = elementsScrolling

			local right = Instance.new("Frame")
			right.Name = "Right"
			right.AutomaticSize = Enum.AutomaticSize.Y
			right.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			right.BackgroundTransparency = 1
			right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			right.BorderSizePixel = 0
			right.LayoutOrder = 1
			right.Position = UDim2.fromScale(0.512, 0)
			right.Size = UDim2.new(0.5, -10, 0, 0)

			local rightUIListLayout = Instance.new("UIListLayout")
			rightUIListLayout.Name = "RightUIListLayout"
			rightUIListLayout.Padding = UDim.new(0, 15)
			rightUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			rightUIListLayout.Parent = right

			right.Parent = elementsScrolling

			elementsScrolling.Parent = elements1

			function TabFunctions:Section(Settings)
				local SectionFunctions = {}
				local section = Instance.new("Frame")
				section.Name = "Section"
				section.AutomaticSize = Enum.AutomaticSize.Y
				section.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
				section.BackgroundTransparency = 0
				section.BorderColor3 = Color3.fromRGB(0, 0, 0)
				section.BorderSizePixel = 0
				section.Position = UDim2.fromScale(0, 6.78e-08)
				section.Size = UDim2.fromScale(1, 0)
				section.ClipsDescendants = true
				section.Parent = Settings.Side == "Left" and left or right

				local sectionUICorner = Instance.new("UICorner")
				sectionUICorner.Name = "SectionUICorner"
				sectionUICorner.CornerRadius = UDim.new(0, 10)
				sectionUICorner.Parent = section

				local sectionUIStroke = Instance.new("UIStroke")
				sectionUIStroke.Name = "SectionUIStroke"
				sectionUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				sectionUIStroke.Color = Color3.fromRGB(255, 255, 255)
				sectionUIStroke.Transparency = 0.93
				sectionUIStroke.Thickness = 1
				sectionUIStroke.Parent = section

				local sectionUIListLayout = Instance.new("UIListLayout")
				sectionUIListLayout.Name = "SectionUIListLayout"
				sectionUIListLayout.Padding = UDim.new(0, 10)
				sectionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				sectionUIListLayout.Parent = section

				local sectionUIPadding = Instance.new("UIPadding")
				sectionUIPadding.Name = "SectionUIPadding"
				sectionUIPadding.PaddingBottom = UDim.new(0, 15)
				sectionUIPadding.PaddingLeft = UDim.new(0, 15)
				sectionUIPadding.PaddingRight = UDim.new(0, 15)
				sectionUIPadding.PaddingTop = UDim.new(0, 15)
				sectionUIPadding.Parent = section

				function SectionFunctions:Button(Settings, Flag)
					local ButtonFunctions = {Settings = Settings}
					local button = Instance.new("Frame")
					button.Name = "Button"
					button.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
					button.BackgroundTransparency = 0
					button.BorderColor3 = Color3.fromRGB(0, 0, 0)
					button.BorderSizePixel = 0
					button.Size = UDim2.new(1, 0, 0, 34)
					button.Parent = section

					local buttonCorner = Instance.new("UICorner")
					buttonCorner.CornerRadius = UDim.new(0, 6)
					buttonCorner.Parent = button

					local buttonStroke = Instance.new("UIStroke")
					buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					buttonStroke.Color = Color3.fromRGB(255, 255, 255)
					buttonStroke.Transparency = 0.92
					buttonStroke.Parent = button

					local buttonInteract = Instance.new("TextButton")
					buttonInteract.Name = "ButtonInteract"
					buttonInteract.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					buttonInteract.RichText = true
					buttonInteract.TextColor3 = Color3.fromRGB(225, 225, 230)
					buttonInteract.TextSize = 13
					buttonInteract.TextTransparency = 0
					buttonInteract.TextTruncate = Enum.TextTruncate.AtEnd
					buttonInteract.TextXAlignment = Enum.TextXAlignment.Center
					buttonInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.BackgroundTransparency = 1
					buttonInteract.BorderSizePixel = 0
					buttonInteract.Size = UDim2.fromScale(1, 1)
					buttonInteract.Parent = button
					buttonInteract.Text = ButtonFunctions.Settings.Name

					local function Callback()
						if ButtonFunctions.Settings.Callback then
							ButtonFunctions.Settings.Callback()
						end
					end

					buttonInteract.MouseEnter:Connect(function()
						Tween(button, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							BackgroundColor3 = Color3.fromRGB(38, 38, 44)
						}):Play()
						Tween(buttonStroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							Transparency = 0.85
						}):Play()
					end)
					buttonInteract.MouseLeave:Connect(function()
						Tween(button, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							BackgroundColor3 = Color3.fromRGB(30, 30, 34)
						}):Play()
						Tween(buttonStroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							Transparency = 0.92
						}):Play()
					end)

					buttonInteract.MouseButton1Click:Connect(Callback)
					function ButtonFunctions:UpdateName(Name)
						buttonInteract.Text = Name
					end
					function ButtonFunctions:SetVisibility(State)
						button.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ButtonFunctions
					end
					return ButtonFunctions
				end

				function SectionFunctions:Toggle(Settings, Flag)
					local ToggleFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Toggle" }
					local toggle = Instance.new("Frame")
					toggle.Name = "Toggle"
					toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					toggle.BackgroundTransparency = 1
					toggle.BorderSizePixel = 0
					toggle.Size = UDim2.new(1, 0, 0, 34)
					toggle.Parent = section

					local toggleName = Instance.new("TextLabel")
					toggleName.Name = "ToggleName"
					toggleName.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					toggleName.Text = ToggleFunctions.Settings.Name
					toggleName.RichText = true
					toggleName.TextColor3 = Color3.fromRGB(220, 220, 225)
					toggleName.TextSize = 13
					toggleName.TextTransparency = 0
					toggleName.TextTruncate = Enum.TextTruncate.AtEnd
					toggleName.TextXAlignment = Enum.TextXAlignment.Left
					toggleName.TextYAlignment = Enum.TextYAlignment.Center
					toggleName.AnchorPoint = Vector2.new(0, 0.5)
					toggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					toggleName.BackgroundTransparency = 1
					toggleName.BorderSizePixel = 0
					toggleName.Position = UDim2.new(0, 0, 0.5, 0)
					toggleName.Size = UDim2.new(1, -48, 1, 0)
					toggleName.Parent = toggle

					local toggle1 = Instance.new("TextButton")
					toggle1.Name = "Toggle"
					toggle1.Text = ""
					toggle1.AutoButtonColor = false
					toggle1.AnchorPoint = Vector2.new(1, 0.5)
					toggle1.BackgroundColor3 = Color3.fromRGB(42, 42, 46)
					toggle1.BorderSizePixel = 0
					toggle1.Position = UDim2.new(1, 0, 0.5, 0)
					toggle1.Size = UDim2.fromOffset(36, 20)
					toggle1.Parent = toggle

					local toggle1Corner = Instance.new("UICorner")
					toggle1Corner.CornerRadius = UDim.new(1, 0)
					toggle1Corner.Parent = toggle1

					local toggle1Stroke = Instance.new("UIStroke")
					toggle1Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					toggle1Stroke.Color = Color3.fromRGB(255, 255, 255)
					toggle1Stroke.Transparency = 0.94
					toggle1Stroke.Parent = toggle1

					local togglerHead = Instance.new("Frame")
					togglerHead.Name = "TogglerHead"
					togglerHead.AnchorPoint = Vector2.new(0.5, 0.5)
					togglerHead.BackgroundColor3 = Color3.fromRGB(75, 75, 80)
					togglerHead.BorderSizePixel = 0
					togglerHead.Position = UDim2.new(0, 10, 0.5, 0)
					togglerHead.Size = UDim2.fromOffset(14, 14)
					togglerHead.Parent = toggle1

					local togglerHeadCorner = Instance.new("UICorner")
					togglerHeadCorner.CornerRadius = UDim.new(1, 0)
					togglerHeadCorner.Parent = togglerHead

					local togglebool = ToggleFunctions.Settings.Default or false
					ToggleFunctions.Value = togglebool
					ToggleFunctions.State = togglebool
					ToggleFunctions.OnChangedCallbacks = {}

					function ToggleFunctions:OnChanged(fn)
						table.insert(self.OnChangedCallbacks, fn)
						return fn
					end

					function ToggleFunctions:SetValue(State)
						self:UpdateState(State)
					end

					local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					local function NewState(State, callback)
						local targetPos = State and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
						local targetBg = State and Color3.fromRGB(220, 38, 38) or Color3.fromRGB(42, 42, 46)
						local targetHeadColor = State and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(75, 75, 80)

						Tween(togglerHead, tweenInfo, {
							Position = targetPos,
							BackgroundColor3 = targetHeadColor
						}):Play()
						Tween(toggle1, tweenInfo, {
							BackgroundColor3 = targetBg
						}):Play()

						ToggleFunctions.State = State
						ToggleFunctions.Value = State
						if callback then
							callback(togglebool)
						end
						for _, fn in ipairs(ToggleFunctions.OnChangedCallbacks or {}) do
							task.spawn(fn, togglebool)
						end
					end

					NewState(togglebool)

					local function Toggle()
						togglebool = not togglebool
						NewState(togglebool, ToggleFunctions.Settings.Callback)
					end

					toggle1.MouseButton1Click:Connect(Toggle)

					local toggleHitbox = Instance.new("TextButton")
					toggleHitbox.Name = "Hitbox"
					toggleHitbox.Text = ""
					toggleHitbox.BackgroundTransparency = 1
					toggleHitbox.Size = UDim2.new(1, -42, 1, 0)
					toggleHitbox.Position = UDim2.new(0, 0, 0, 0)
					toggleHitbox.Parent = toggle
					toggleHitbox.MouseButton1Click:Connect(Toggle)

					function ToggleFunctions:Toggle()
						Toggle()
					end
					function ToggleFunctions:UpdateState(State)
						togglebool = State
						NewState(togglebool, ToggleFunctions.Settings.Callback)
					end
					function ToggleFunctions:GetState()
						return togglebool
					end
					function ToggleFunctions:UpdateName(Name)
						toggleName.Text = Name
					end
					function ToggleFunctions:SetVisibility(State)
						toggle.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ToggleFunctions
					end
					return ToggleFunctions
				end

				function SectionFunctions:Slider(Settings, Flag)
					local SliderFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Slider" }
					local slider = Instance.new("Frame")
					slider.Name = "Slider"
					slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					slider.BackgroundTransparency = 1
					slider.BorderSizePixel = 0
					slider.Size = UDim2.new(1, 0, 0, 34)
					slider.Parent = section

					local sliderName = Instance.new("TextLabel")
					sliderName.Name = "SliderName"
					sliderName.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					sliderName.Text = SliderFunctions.Settings.Name
					sliderName.RichText = true
					sliderName.TextColor3 = Color3.fromRGB(220, 220, 225)
					sliderName.TextSize = 12.5
					sliderName.TextTransparency = 0
					sliderName.TextTruncate = Enum.TextTruncate.AtEnd
					sliderName.TextXAlignment = Enum.TextXAlignment.Left
					sliderName.TextYAlignment = Enum.TextYAlignment.Center
					sliderName.AnchorPoint = Vector2.new(0, 0.5)
					sliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderName.BackgroundTransparency = 1
					sliderName.BorderSizePixel = 0
					sliderName.Position = UDim2.new(0, 0, 0.5, 0)
					sliderName.Size = UDim2.new(1, -118, 1, 0)
					sliderName.Parent = slider

					local sliderElements = Instance.new("Frame")
					sliderElements.Name = "SliderElements"
					sliderElements.AnchorPoint = Vector2.new(1, 0.5)
					sliderElements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderElements.BackgroundTransparency = 1
					sliderElements.BorderSizePixel = 0
					sliderElements.Position = UDim2.new(1, 0, 0.5, 0)
					sliderElements.Size = UDim2.fromOffset(112, 24)
					sliderElements.Parent = slider

					local sliderValue = Instance.new("TextBox")
					sliderValue.Name = "SliderValue"
					sliderValue.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					sliderValue.TextColor3 = Color3.fromRGB(225, 225, 230)
					sliderValue.TextSize = 11.5
					sliderValue.TextTransparency = 0
					sliderValue.AnchorPoint = Vector2.new(1, 0.5)
					sliderValue.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
					sliderValue.BackgroundTransparency = 0
					sliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderValue.BorderSizePixel = 0
					sliderValue.Position = UDim2.new(1, 0, 0.5, 0)
					sliderValue.Size = UDim2.fromOffset(38, 22)
					sliderValue.ClipsDescendants = true
					sliderValue.TextXAlignment = Enum.TextXAlignment.Center

					local sliderValueUICorner = Instance.new("UICorner")
					sliderValueUICorner.Name = "SliderValueUICorner"
					sliderValueUICorner.CornerRadius = UDim.new(0, 5)
					sliderValueUICorner.Parent = sliderValue

					local sliderValueUIStroke = Instance.new("UIStroke")
					sliderValueUIStroke.Name = "SliderValueUIStroke"
					sliderValueUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					sliderValueUIStroke.Color = Color3.fromRGB(255, 255, 255)
					sliderValueUIStroke.Transparency = 0.92
					sliderValueUIStroke.Parent = sliderValue

					sliderValue.Parent = sliderElements

					local sliderBar = Instance.new("Frame")
					sliderBar.Name = "SliderBar"
					sliderBar.AnchorPoint = Vector2.new(0, 0.5)
					sliderBar.BackgroundColor3 = Color3.fromRGB(44, 44, 48)
					sliderBar.BackgroundTransparency = 0
					sliderBar.BorderSizePixel = 0
					sliderBar.Position = UDim2.new(0, 0, 0.5, 0)
					sliderBar.Size = UDim2.new(1, -44, 0, 4)
					sliderBar.Parent = sliderElements

					local sliderBarCorner = Instance.new("UICorner")
					sliderBarCorner.CornerRadius = UDim.new(1, 0)
					sliderBarCorner.Parent = sliderBar

					local sliderHead = Instance.new("ImageButton")
					sliderHead.Name = "SliderHead"
					sliderHead.AnchorPoint = Vector2.new(0.5, 0.5)
					sliderHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderHead.BackgroundTransparency = 0
					sliderHead.BorderSizePixel = 0
					sliderHead.Position = UDim2.fromScale(1, 0.5)
					sliderHead.Size = UDim2.fromOffset(12, 12)
					sliderHead.AutoButtonColor = false
					sliderHead.Parent = sliderBar

					local sliderHeadCorner = Instance.new("UICorner")
					sliderHeadCorner.CornerRadius = UDim.new(1, 0)
					sliderHeadCorner.Parent = sliderHead

					local dragging = false

					local DisplayMethods = {
						Round = function(val, precision)
							if precision and precision > 0 then
								return string.format("%." .. precision .. "f", val)
							else
								return tostring(math.round(val))
							end
						end,
						Degrees = function(val, precision)
							local formatted = (precision and precision > 0) and string.format("%." .. precision .. "f", val) or tostring(math.round(val))
							return formatted .. "°"
						end,
						Percent = function(val, precision)
							local pct = (val - SliderFunctions.Settings.Minimum) / (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum) * 100
							return (precision and precision > 0) and string.format("%." .. precision .. "f", pct) .. "%" or tostring(math.round(pct)) .. "%"
						end,
						Value = function(val, precision)
							return (precision and precision > 0) and string.format("%." .. precision .. "f", val) or tostring(math.round(val))
						end
					}

					local ValueDisplayMethod = DisplayMethods[SliderFunctions.Settings.DisplayMethod] or DisplayMethods.Value
					local finalValue = SliderFunctions.Settings.Default or SliderFunctions.Settings.Minimum or 0
					SliderFunctions.Value = finalValue
					SliderFunctions.OnChangedCallbacks = {}

					function SliderFunctions:OnChanged(fn)
						table.insert(self.OnChangedCallbacks, fn)
						return fn
					end

					function SliderFunctions:SetValue(val)
						self:UpdateValue(val)
					end

					local function SetValue(val, ignorecallback)
						local posXScale
						if typeof(val) == "Instance" then
							local input = val
							posXScale = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
						else
							local num = tonumber(val) or SliderFunctions.Settings.Minimum
							posXScale = math.clamp((num - SliderFunctions.Settings.Minimum) / (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum), 0, 1)
						end

						sliderHead.Position = UDim2.new(posXScale, 0, 0.5, 0)
						finalValue = posXScale * (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum) + SliderFunctions.Settings.Minimum
						sliderValue.Text = (Settings.Prefix or "") .. ValueDisplayMethod(finalValue, SliderFunctions.Settings.Precision) .. (Settings.Suffix or "")
						SliderFunctions.Value = finalValue

						if not ignorecallback then
							task.spawn(function()
								if SliderFunctions.Settings.Callback then
									SliderFunctions.Settings.Callback(finalValue)
								end
							end)
							for _, fn in ipairs(SliderFunctions.OnChangedCallbacks or {}) do
								task.spawn(fn, finalValue)
							end
						end
					end

					SetValue(finalValue, true)

					sliderHead.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							SetValue(input)
						end
					end)

					sliderHead.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = false
							if SliderFunctions.Settings.onInputComplete then
								SliderFunctions.Settings.onInputComplete(finalValue)
							end
						end
					end)

					sliderBar.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							SetValue(input)
						end
					end)

					sliderBar.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = false
						end
					end)

					sliderValue.FocusLost:Connect(function(enterPressed)
						local inputText = sliderValue.Text
						local numVal = tonumber(inputText:match("^(%-?%d+%.?%d*)"))
						if numVal then
							local newValue = math.clamp(numVal, SliderFunctions.Settings.Minimum, SliderFunctions.Settings.Maximum)
							SetValue(newValue)
						else
							sliderValue.Text = ValueDisplayMethod(finalValue, SliderFunctions.Settings.Precision)
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							SetValue(input)
						end
					end)

					function SliderFunctions:UpdateName(Name)
						sliderName.Text = Name
					end
					function SliderFunctions:SetVisibility(State)
						slider.Visible = State
					end
					function SliderFunctions:UpdateValue(Value)
						SetValue(tonumber(Value), false)
					end
					function SliderFunctions:GetValue()
						return finalValue
					end

					if Flag then
						MacLib.Options[Flag] = SliderFunctions
					end
					return SliderFunctions
				end

				function SectionFunctions:Input(Settings, Flag)
					local InputFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Input" }
					local input = Instance.new("Frame")
					input.Name = "Input"
					input.AutomaticSize = Enum.AutomaticSize.Y
					input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					input.BackgroundTransparency = 1
					input.BorderColor3 = Color3.fromRGB(0, 0, 0)
					input.BorderSizePixel = 0
					input.Size = UDim2.new(1, 0, 0, 38)
					input.Parent = section

					local inputName = Instance.new("TextLabel")
					inputName.Name = "InputName"
					inputName.FontFace = Font.new(assets.interFont)
					inputName.Text = InputFunctions.Settings.Name
					inputName.RichText = true
					inputName.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName.TextSize = 13
					inputName.TextTransparency = 0.5
					inputName.TextTruncate = Enum.TextTruncate.AtEnd
					inputName.TextXAlignment = Enum.TextXAlignment.Left
					inputName.TextYAlignment = Enum.TextYAlignment.Top
					inputName.AnchorPoint = Vector2.new(0, 0.5)
					inputName.AutomaticSize = Enum.AutomaticSize.XY
					inputName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName.BackgroundTransparency = 1
					inputName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName.BorderSizePixel = 0
					inputName.Position = UDim2.fromScale(0, 0.5)
					inputName.Parent = input

					local inputBox = Instance.new("TextBox")
					inputBox.Name = "InputBox"
					inputBox.FontFace = Font.new(assets.interFont)
					inputBox.Text = "Hello world!"
					inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.TextSize = 12
					inputBox.TextTransparency = 0.1
					inputBox.AnchorPoint = Vector2.new(1, 0.5)
					inputBox.AutomaticSize = Enum.AutomaticSize.X
					inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.BackgroundTransparency = 0.95
					inputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox.BorderSizePixel = 0
					inputBox.ClipsDescendants = true
					inputBox.LayoutOrder = 1
					inputBox.Position = UDim2.fromScale(1, 0.5)
					inputBox.Size = UDim2.fromOffset(21, 21)
					inputBox.TextXAlignment = Enum.TextXAlignment.Right

					local inputBoxUICorner = Instance.new("UICorner")
					inputBoxUICorner.Name = "InputBoxUICorner"
					inputBoxUICorner.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner.Parent = inputBox

					local inputBoxUIStroke = Instance.new("UIStroke")
					inputBoxUIStroke.Name = "InputBoxUIStroke"
					inputBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke.Transparency = 0.9
					inputBoxUIStroke.Parent = inputBox

					local inputBoxUIPadding = Instance.new("UIPadding")
					inputBoxUIPadding.Name = "InputBoxUIPadding"
					inputBoxUIPadding.PaddingLeft = UDim.new(0, 5)
					inputBoxUIPadding.PaddingRight = UDim.new(0, 5)
					inputBoxUIPadding.Parent = inputBox

					local inputBoxUISizeConstraint = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint.Parent = inputBox

					inputBox.Parent = input

					local Input = input
					local InputBox = inputBox
					local InputName = inputName
					local Constraint = inputBoxUISizeConstraint

					local function applyCharacterLimit(value)
						if InputFunctions.Settings.CharacterLimit then
							return value:sub(1, InputFunctions.Settings.CharacterLimit)
						end
						return value
					end

					local CharacterSubs = {
						All = function(value)
							return applyCharacterLimit(value)
						end,
						Numeric = function(value)
							local result = value:match("^%-?%d*$") and value or value:gsub("[^%d-]", ""):gsub("(%-)", function(match, pos)
								return pos == 1 and match or ""
							end)
							return applyCharacterLimit(result)
						end,
						Alphabetic = function(value)
							return applyCharacterLimit(value:gsub("[^a-zA-Z ]", ""))
						end,
						AlphaNumeric = function(value)
							return applyCharacterLimit(value:gsub("[^a-zA-Z0-9]", ""))
						end,
					}

					local AcceptedCharacters

					if type(InputFunctions.Settings.AcceptedCharacters) == "function" then
						AcceptedCharacters = InputFunctions.Settings.AcceptedCharacters
					else
						AcceptedCharacters = CharacterSubs[InputFunctions.Settings.AcceptedCharacters] or CharacterSubs.All
					end

					InputBox.AutomaticSize = Enum.AutomaticSize.X

					local function checkSize()
						local nameWidth = InputName.AbsoluteSize.X
						local totalWidth = Input.AbsoluteSize.X

						local maxWidth = (totalWidth - nameWidth - 20) / baseUIScale.Scale
						Constraint.MaxSize = Vector2.new(maxWidth, 9e9)
					end

					checkSize()
					InputName:GetPropertyChangedSignal("AbsoluteSize"):Connect(checkSize)

					InputBox.FocusLost:Connect(function()
						local inputText = InputBox.Text
						local filteredText = AcceptedCharacters(inputText)
						InputBox.Text = filteredText
						task.spawn(function()
							if InputFunctions.Settings.Callback then
								InputFunctions.Settings.Callback(filteredText)
							end
						end)
					end)
					InputBox.Text = InputFunctions.Settings.Default or ""
					InputBox.PlaceholderText = InputFunctions.Settings.Placeholder or ""

					InputBox:GetPropertyChangedSignal("Text"):Connect(function()
						InputBox.Text = AcceptedCharacters(InputBox.Text)
						if InputFunctions.Settings.onChanged then
							InputFunctions.Settings.onChanged(InputBox.Text)
						end
						InputFunctions.Text = InputBox.Text
					end)

					function InputFunctions:UpdateName(Name)
						inputName.Text = Name
					end
					function InputFunctions:SetVisibility(State)
						input.Visible = State
					end
					function InputFunctions:GetInput()
						return InputBox.Text
					end
					function InputFunctions:UpdatePlaceholder(Placeholder)
						inputBox.PlaceholderText = Placeholder
					end
					function InputFunctions:UpdateText(Text)
						local filteredText = AcceptedCharacters(Text)
						InputBox.Text = filteredText
						InputFunctions.Text = filteredText
						task.spawn(function()
							if InputFunctions.Settings.Callback then
								InputFunctions.Settings.Callback(filteredText)
							end
						end)
					end

					if Flag then
						MacLib.Options[Flag] = InputFunctions
					end
					return InputFunctions
				end

				function SectionFunctions:Keybind(Settings, Flag)
					local KeybindFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Keybind" }
					local keybind = Instance.new("Frame")
					keybind.Name = "Keybind"
					keybind.AutomaticSize = Enum.AutomaticSize.Y
					keybind.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					keybind.BackgroundTransparency = 1
					keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
					keybind.BorderSizePixel = 0
					keybind.Size = UDim2.new(1, 0, 0, 38)
					keybind.Parent = section

					local keybindName = Instance.new("TextLabel")
					keybindName.Name = "KeybindName"
					keybindName.FontFace = Font.new(assets.interFont)
					keybindName.Text = KeybindFunctions.Settings.Name
					keybindName.RichText = true
					keybindName.TextColor3 = Color3.fromRGB(255, 255, 255)
					keybindName.TextSize = 13
					keybindName.TextTransparency = 0.5
					keybindName.TextTruncate = Enum.TextTruncate.AtEnd
					keybindName.TextXAlignment = Enum.TextXAlignment.Left
					keybindName.TextYAlignment = Enum.TextYAlignment.Top
					keybindName.AnchorPoint = Vector2.new(0, 0.5)
					keybindName.AutomaticSize = Enum.AutomaticSize.XY
					keybindName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					keybindName.BackgroundTransparency = 1
					keybindName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					keybindName.BorderSizePixel = 0
					keybindName.Position = UDim2.fromScale(0, 0.5)
					keybindName.Parent = keybind

					local binderBox = Instance.new("TextBox")
					binderBox.Name = "BinderBox"
					binderBox.CursorPosition = -1
					binderBox.FontFace = Font.new(assets.interFont)
					binderBox.PlaceholderText = "..."
					binderBox.Text = ""
					binderBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					binderBox.TextSize = 12
					binderBox.TextTransparency = 0.1
					binderBox.AnchorPoint = Vector2.new(1, 0.5)
					binderBox.AutomaticSize = Enum.AutomaticSize.X
					binderBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					binderBox.BackgroundTransparency = 0.95
					binderBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					binderBox.BorderSizePixel = 0
					binderBox.ClipsDescendants = true
					binderBox.LayoutOrder = 1
					binderBox.Position = UDim2.fromScale(1, 0.5)
					binderBox.Size = UDim2.fromOffset(21, 21)

					local binderBoxUICorner = Instance.new("UICorner")
					binderBoxUICorner.Name = "BinderBoxUICorner"
					binderBoxUICorner.CornerRadius = UDim.new(0, 4)
					binderBoxUICorner.Parent = binderBox

					local binderBoxUIStroke = Instance.new("UIStroke")
					binderBoxUIStroke.Name = "BinderBoxUIStroke"
					binderBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					binderBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					binderBoxUIStroke.Transparency = 0.9
					binderBoxUIStroke.Parent = binderBox

					local binderBoxUIPadding = Instance.new("UIPadding")
					binderBoxUIPadding.Name = "BinderBoxUIPadding"
					binderBoxUIPadding.PaddingLeft = UDim.new(0, 5)
					binderBoxUIPadding.PaddingRight = UDim.new(0, 5)
					binderBoxUIPadding.Parent = binderBox

					local binderBoxUISizeConstraint = Instance.new("UISizeConstraint")
					binderBoxUISizeConstraint.Name = "BinderBoxUISizeConstraint"
					binderBoxUISizeConstraint.Parent = binderBox

					binderBox.Parent = keybind

					local focused
					local isBinding = false
					local reset = false
					local binded = KeybindFunctions.Settings.Default

					local function resetFocusState()
						focused = false
						isBinding = false
						binderBox:ReleaseFocus()
					end

					if binded then
						binderBox.Text = binded.Name
					end

					binderBox.Focused:Connect(function()
						focused = true
					end)

					binderBox.FocusLost:Connect(function()
						focused = false
					end)

					UserInputService.InputBegan:Connect(function(inp)
						if focused and not isBinding then
							isBinding = true

							local Event
							Event = UserInputService.InputBegan:Connect(function(input)
								if KeybindFunctions.Settings.Blacklist and (table.find(KeybindFunctions.Settings.Blacklist, input.KeyCode) or table.find(KeybindFunctions.Settings.Blacklist, input.UserInputType)) then
									binderBox:ReleaseFocus()
									resetFocusState()
									Event:Disconnect()
									return
								end

								if input.UserInputType == Enum.UserInputType.Keyboard then
									binded = input.KeyCode
									binderBox.Text = input.KeyCode.Name
								elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
									binded = input.UserInputType
									binderBox.Text = input.UserInputType.Name
								end

								if KeybindFunctions.Settings.onBinded then
									KeybindFunctions.Settings.onBinded(binded)
								end
								reset = true
								resetFocusState()
								Event:Disconnect()
							end)
						else
							if not reset and (inp.KeyCode == binded or inp.UserInputType == binded) then
								if KeybindFunctions.Settings.Callback then
									KeybindFunctions.Settings.Callback(binded)
								end
								if KeybindFunctions.Settings.onBindHeld then
									KeybindFunctions.Settings.onBindHeld(true, binded)
								end
							else
								reset = false
							end
						end
					end)

					UserInputService.InputEnded:Connect(function(inp)
						if not focused and not isBinding then
							if inp.KeyCode == binded or inp.UserInputType == binded then
								if Settings.onBindHeld then
									Settings.onBindHeld(false, binded)
								end
							end
						end
					end)

					function KeybindFunctions:Bind(Key)
						binded = Key
						binderBox.Text = Key.Name
					end

					function KeybindFunctions:Unbind()
						binded = nil
						binderBox.Text = ""
					end

					function KeybindFunctions:GetBind()
						return binded
					end

					function KeybindFunctions:UpdateName(Name)
						keybindName = Name
					end

					function KeybindFunctions:SetVisibility(State)
						keybind.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = KeybindFunctions
					end

					return KeybindFunctions
				end

				function SectionFunctions:Dropdown(Settings, Flag)
					local DropdownFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Dropdown" }
					local Selected = {}
					local OptionObjs = {}

					local dropdown = Instance.new("Frame")
					dropdown.Name = "Dropdown"
					dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
					dropdown.BackgroundTransparency = 0
					dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdown.BorderSizePixel = 0
					dropdown.Size = UDim2.new(1, 0, 0, 38)
					dropdown.Parent = section
					dropdown.ClipsDescendants = true

					local dropdownUIPadding = Instance.new("UIPadding")
					dropdownUIPadding.Name = "DropdownUIPadding"
					dropdownUIPadding.PaddingLeft = UDim.new(0, 15)
					dropdownUIPadding.PaddingRight = UDim.new(0, 15)
					dropdownUIPadding.Parent = dropdown

					local interact = Instance.new("TextButton")
					interact.Name = "Interact"
					interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					interact.Text = ""
					interact.TextColor3 = Color3.fromRGB(0, 0, 0)
					interact.TextSize = 14
					interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					interact.BackgroundTransparency = 1
					interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
					interact.BorderSizePixel = 0
					interact.Size = UDim2.new(1, 0, 0, 38)
					interact.Parent = dropdown

					local dropdownName = Instance.new("TextLabel")
					dropdownName.Name = "DropdownName"
					dropdownName.FontFace = Font.new(assets.interFont)
					dropdownName.Text = Settings.Default and (DropdownFunctions.Settings.Name .. " • " .. table.concat(Selected, ", ")) or (DropdownFunctions.Settings.Name .. "...")
					dropdownName.RichText = true
					dropdownName.TextColor3 = Color3.fromRGB(210, 210, 215)
					dropdownName.TextSize = 13
					dropdownName.TextTransparency = 0
					dropdownName.TextTruncate = Enum.TextTruncate.SplitWord
					dropdownName.TextXAlignment = Enum.TextXAlignment.Left
					dropdownName.AutomaticSize = Enum.AutomaticSize.Y
					dropdownName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownName.BackgroundTransparency = 1
					dropdownName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownName.BorderSizePixel = 0
					dropdownName.Size = UDim2.new(1, -20, 0, 38)
					dropdownName.Parent = dropdown

					local dropdownUIStroke = Instance.new("UIStroke")
					dropdownUIStroke.Name = "DropdownUIStroke"
					dropdownUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					dropdownUIStroke.Color = Color3.fromRGB(255, 255, 255)
					dropdownUIStroke.Transparency = 0.92
					dropdownUIStroke.Parent = dropdown

					local dropdownUICorner = Instance.new("UICorner")
					dropdownUICorner.Name = "DropdownUICorner"
					dropdownUICorner.CornerRadius = UDim.new(0, 6)
					dropdownUICorner.Parent = dropdown

					local dropdownImage = Instance.new("ImageLabel")
					dropdownImage.Name = "DropdownImage"
					dropdownImage.Image = Settings.Image or assets.dropdown
					dropdownImage.ImageColor3 = Color3.fromRGB(190, 195, 205)
					dropdownImage.ImageTransparency = 0
					dropdownImage.AnchorPoint = Vector2.new(1, 0)
					dropdownImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownImage.BackgroundTransparency = 1
					dropdownImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownImage.BorderSizePixel = 0
					dropdownImage.Position = UDim2.new(1, 0, 0, 12)
					dropdownImage.Size = UDim2.fromOffset(14, 14)
					dropdownImage.Parent = dropdown

					local dropdownFrame = Instance.new("Frame")
					dropdownFrame.Name = "DropdownFrame"
					dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownFrame.BackgroundTransparency = 1
					dropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownFrame.BorderSizePixel = 0
					dropdownFrame.ClipsDescendants = true
					dropdownFrame.Size = UDim2.fromScale(1, 1)
					dropdownFrame.Visible = false
					dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y

					local dropdownFrameUIPadding = Instance.new("UIPadding")
					dropdownFrameUIPadding.Name = "DropdownFrameUIPadding"
					dropdownFrameUIPadding.PaddingTop = UDim.new(0, 38)
					dropdownFrameUIPadding.PaddingBottom = UDim.new(0, 10)
					dropdownFrameUIPadding.Parent = dropdownFrame

					local dropdownFrameUIListLayout = Instance.new("UIListLayout")
					dropdownFrameUIListLayout.Name = "DropdownFrameUIListLayout"
					dropdownFrameUIListLayout.Padding = UDim.new(0, 5)
					dropdownFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					dropdownFrameUIListLayout.Parent = dropdownFrame

					local search = Instance.new("Frame")
					search.Name = "Search"
					search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					search.BackgroundTransparency = 0.95
					search.BorderColor3 = Color3.fromRGB(0, 0, 0)
					search.BorderSizePixel = 0
					search.LayoutOrder = -1
					search.Size = UDim2.new(1, 0, 0, 30)
					search.Parent = dropdownFrame
					search.Visible = DropdownFunctions.Settings.Search

					local sectionUICorner = Instance.new("UICorner")
					sectionUICorner.Name = "SectionUICorner"
					sectionUICorner.Parent = search

					local searchIcon = Instance.new("ImageLabel")
					searchIcon.Name = "SearchIcon"
					searchIcon.Image = assets.searchIcon
					searchIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
					searchIcon.AnchorPoint = Vector2.new(0, 0.5)
					searchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					searchIcon.BackgroundTransparency = 1
					searchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					searchIcon.BorderSizePixel = 0
					searchIcon.Position = UDim2.fromScale(0, 0.5)
					searchIcon.Size = UDim2.fromOffset(12, 12)
					searchIcon.Parent = search

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingLeft = UDim.new(0, 15)
					uIPadding.Parent = search

					local searchBox = Instance.new("TextBox")
					searchBox.Name = "SearchBox"
					searchBox.CursorPosition = -1
					searchBox.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
					searchBox.PlaceholderText = "Search..."
					searchBox.Text = ""
					searchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
					searchBox.TextSize = 14
					searchBox.TextXAlignment = Enum.TextXAlignment.Left
					searchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					searchBox.BackgroundTransparency = 1
					searchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					searchBox.BorderSizePixel = 0
					searchBox.Size = UDim2.fromScale(1, 1)

					local function CalculateDropdownSize()
						local totalHeight = 0
						local visibleChildrenCount = 0
						local padding = dropdownFrameUIPadding.PaddingTop.Offset + dropdownFrameUIPadding.PaddingBottom.Offset

						for _, v in pairs(dropdownFrame:GetChildren()) do
							if not v:IsA("UIComponent") and v.Visible then
								totalHeight += v.AbsoluteSize.Y
								visibleChildrenCount += 1
							end
						end

						local spacing = dropdownFrameUIListLayout.Padding.Offset * (visibleChildrenCount - 1)

						return totalHeight + spacing + padding
					end

					local function findOption()
						local searchTerm = searchBox.Text:lower()

						for _, v in pairs(OptionObjs) do
							local optionText = v.NameLabel.Text:lower()
							local isVisible = string.find(optionText, searchTerm) ~= nil

							if v.Button.Visible ~= isVisible then
								v.Button.Visible = isVisible
							end
						end

						dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
					end

					searchBox:GetPropertyChangedSignal("Text"):Connect(findOption)

					local uIPadding1 = Instance.new("UIPadding")
					uIPadding1.Name = "UIPadding"
					uIPadding1.PaddingLeft = UDim.new(0, 23)
					uIPadding1.Parent = searchBox

					searchBox.Parent = search

					local tweensettings = {
						duration = 0.2,
						easingStyle = Enum.EasingStyle.Quint,
						transparencyIn = 0.2,
						transparencyOut = 0.5,
						checkSizeIncrease = 12,
						checkSizeDecrease = -13,
						waitTime = 1
					}

					local function Toggle(optionName, State)
						local option = OptionObjs[optionName]

						if not option then return end

						local checkmark = option.Checkmark
						local optionNameLabel = option.NameLabel

						if State then
							if DropdownFunctions.Settings.Multi then
								if not table.find(Selected, optionName) then
									table.insert(Selected, optionName)
									DropdownFunctions.Value = Selected
								end
							else
								for name, opt in pairs(OptionObjs) do
									if name ~= optionName then
										Tween(opt.Checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
											Size = UDim2.new(opt.Checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, opt.Checkmark.Size.Y.Scale, opt.Checkmark.Size.Y.Offset)
										}):Play()
										Tween(opt.NameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
											TextTransparency = tweensettings.transparencyOut
										}):Play()
										opt.Checkmark.TextTransparency = 1
									end
								end
								Selected = {optionName}
								DropdownFunctions.Value = Selected[1]
							end
							Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}):Play()
							Tween(optionNameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								TextTransparency = tweensettings.transparencyIn
							}):Play()
							checkmark.TextTransparency = 0
						else
							if DropdownFunctions.Settings.Multi then
								local idx = table.find(Selected, optionName)
								if idx then
									table.remove(Selected, idx)
								end
							else
								Selected = {}
							end
							Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}):Play()
							Tween(optionNameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								TextTransparency = tweensettings.transparencyOut
							}):Play()
							checkmark.TextTransparency = 1
						end

						if Settings.Required and #Selected == 0 and not State then
							return
						end

						if #Selected > 0 then
							dropdownName.Text = DropdownFunctions.Settings.Name .. " • " .. table.concat(Selected, ", ")
						else
							dropdownName.Text = DropdownFunctions.Settings.Name .. "..."
						end
					end

					local dropped = false
					local db = false

					local function ToggleDropdown()
						if db then return end
						db = true
						local defaultDropdownSize = 38
						local isDropdownOpen = not dropped
						local targetSize = isDropdownOpen and UDim2.new(1, 0, 0, CalculateDropdownSize()) or UDim2.new(1, 0, 0, defaultDropdownSize)

						local dropTween = Tween(dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
							Size = targetSize
						})
						local iconTween = Tween(dropdownImage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Rotation = isDropdownOpen and 180 or 0
						})

						dropTween:Play()
						iconTween:Play()

						if isDropdownOpen then
							dropdownFrame.Visible = true
							dropTween.Completed:Connect(function()
								db = false
							end)
						else
							dropTween.Completed:Connect(function()
								dropdownFrame.Visible = false
								db = false
							end)
						end

						dropped = isDropdownOpen
					end

					interact.MouseButton1Click:Connect(ToggleDropdown)

					local function addOption(i, v)
						local option = Instance.new("TextButton")
						option.Name = "Option"
						option.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
						option.Text = ""
						option.TextColor3 = Color3.fromRGB(0, 0, 0)
						option.TextSize = 14
						option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						option.BackgroundTransparency = 1
						option.BorderColor3 = Color3.fromRGB(0, 0, 0)
						option.BorderSizePixel = 0
						option.Size = UDim2.new(1, 0, 0, 30)

						local optionUIPadding = Instance.new("UIPadding")
						optionUIPadding.Name = "OptionUIPadding"
						optionUIPadding.PaddingLeft = UDim.new(0, 15)
						optionUIPadding.Parent = option

						local optionName = Instance.new("TextLabel")
						optionName.Name = "OptionName"
						optionName.FontFace = Font.new(assets.interFont)
						optionName.Text = v
						optionName.RichText = true
						optionName.TextColor3 = Color3.fromRGB(255, 255, 255)
						optionName.TextSize = 13
						optionName.TextTransparency = 0.5
						optionName.TextTruncate = Enum.TextTruncate.AtEnd
						optionName.TextXAlignment = Enum.TextXAlignment.Left
						optionName.TextYAlignment = Enum.TextYAlignment.Top
						optionName.AnchorPoint = Vector2.new(0, 0.5)
						optionName.AutomaticSize = Enum.AutomaticSize.XY
						optionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						optionName.BackgroundTransparency = 1
						optionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
						optionName.BorderSizePixel = 0
						optionName.Position = UDim2.fromScale(1.3e-07, 0.5)
						optionName.Parent = option

						local optionUIListLayout = Instance.new("UIListLayout")
						optionUIListLayout.Name = "OptionUIListLayout"
						optionUIListLayout.Padding = UDim.new(0, 10)
						optionUIListLayout.FillDirection = Enum.FillDirection.Horizontal
						optionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
						optionUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
						optionUIListLayout.Parent = option

						local checkmark = Instance.new("TextLabel")
						checkmark.Name = "Checkmark"
						checkmark.FontFace = Font.new(assets.interFont)
						checkmark.Text = "✓"
						checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
						checkmark.TextSize = 13
						checkmark.TextTransparency = 1
						checkmark.TextXAlignment = Enum.TextXAlignment.Left
						checkmark.TextYAlignment = Enum.TextYAlignment.Top
						checkmark.AnchorPoint = Vector2.new(0, 0.5)
						checkmark.AutomaticSize = Enum.AutomaticSize.Y
						checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						checkmark.BackgroundTransparency = 1
						checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
						checkmark.BorderSizePixel = 0
						checkmark.LayoutOrder = -1
						checkmark.Position = UDim2.fromScale(1.3e-07, 0.5)
						checkmark.Size = UDim2.fromOffset(-10, 0)
						checkmark.Parent = option

						option.Parent = dropdownFrame

						dropdownFrame.Parent = dropdown
						OptionObjs[v] = {
							Index = i,
							Button = option,
							NameLabel = optionName,
							Checkmark = checkmark
						}

						local tweensettings = {
							duration = 0.2,
							easingStyle = Enum.EasingStyle.Quint,
							transparencyIn = 0.2,
							transparencyOut = 0.5,
							checkSizeIncrease = 12,
							checkSizeDecrease = -optionUIListLayout.Padding.Offset,
							waitTime = 1
						}
						local tweens = {
							checkIn = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}),
							checkOut = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}),
							nameIn = Tween(optionName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								TextTransparency = tweensettings.transparencyIn
							}),
							nameOut = Tween(optionName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								TextTransparency = tweensettings.transparencyOut
							})
						}

						local isSelected = false
						if DropdownFunctions.Settings.Default then
							if DropdownFunctions.Settings.Multi then
								if type(DropdownFunctions.Settings.Default) == "table" then
									isSelected = (DropdownFunctions.Settings.Default[v] == true) or (table.find(DropdownFunctions.Settings.Default, v) ~= nil)
								end
							else
								isSelected = (DropdownFunctions.Settings.Default == v or DropdownFunctions.Settings.Default == i)
							end
						end
						Toggle(v, isSelected)

						local optBtn = OptionObjs[v].Button

						optBtn.MouseButton1Click:Connect(function()
							local isSel = table.find(Selected, v) and true or false
							local newSelected = not isSel

							if DropdownFunctions.Settings.Required and not newSelected and #Selected <= 1 then
								return
							end

							Toggle(v, newSelected)

							task.spawn(function()
								local currentVal
								if DropdownFunctions.Settings.Multi then
									local Return = {}
									for _, opt in ipairs(Selected) do
										Return[opt] = true
									end
									currentVal = Return
									DropdownFunctions.Value = Return
									if DropdownFunctions.Settings.Callback then
										DropdownFunctions.Settings.Callback(Return)
									end
								else
									currentVal = Selected[1] or nil
									DropdownFunctions.Value = currentVal
									if newSelected and DropdownFunctions.Settings.Callback then
										DropdownFunctions.Settings.Callback(currentVal)
									end
								end
								for _, fn in ipairs(DropdownFunctions.OnChangedCallbacks or {}) do
									task.spawn(fn, currentVal)
								end
							end)
						end)

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end

					if DropdownFunctions.Settings.Options then
						for i, v in pairs(DropdownFunctions.Settings.Options) do
							addOption(i, v)
						end
					end

					DropdownFunctions.OnChangedCallbacks = {}
					function DropdownFunctions:OnChanged(fn)
						table.insert(self.OnChangedCallbacks, fn)
						return fn
					end
					function DropdownFunctions:SetValue(val)
						self:UpdateSelection(val)
					end
					function DropdownFunctions:SetValues(newVals)
						self:ClearOptions()
						self:InsertOptions(newVals)
					end
					function DropdownFunctions:UpdateName(New)
						dropdownName.Text = New
					end
					function DropdownFunctions:SetVisibility(State)
						dropdown.Visible = State
					end
					function DropdownFunctions:UpdateSelection(newSelection)
						if not newSelection then return end

						for option, _ in pairs(OptionObjs) do
							Toggle(option, false)
						end

						local selectedOptions = {}
						if type(newSelection) == "number" then
							for option, data in pairs(OptionObjs) do
								local isSelected = data.Index == newSelection
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						elseif type(newSelection) == "string" then
							for option, data in pairs(OptionObjs) do
								local isSelected = option == newSelection
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						elseif type(newSelection) == "table" then
							for option, _ in pairs(OptionObjs) do
								local isSelected = (newSelection[option] == true) or (table.find(newSelection, option) ~= nil)
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						end

						if DropdownFunctions.Settings.Callback then
							if DropdownFunctions.Settings.Multi then
								local Return = {}
								for _, opt in ipairs(selectedOptions) do
									Return[opt] = true
								end
								DropdownFunctions.Settings.Callback(Return)
							else
								DropdownFunctions.Settings.Callback(selectedOptions[1] or nil)
							end
						end
					end
					function DropdownFunctions:InsertOptions(newOptions)
						if not newOptions then return end
						DropdownFunctions.Settings.Options = newOptions
						for i, v in pairs(newOptions) do
							addOption(i, v)
						end
					end
					function DropdownFunctions:ClearOptions()
						for _, optionData in pairs(OptionObjs) do
							optionData.Button:Destroy()
						end
						OptionObjs = {}
						Selected = {}

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end
					function DropdownFunctions:GetOptions()
						local optionsStatus = {}

						for option, data in pairs(OptionObjs) do
							local isSelected = table.find(Selected, option) and true or false
							optionsStatus[option] = isSelected
						end

						return optionsStatus
					end

					function DropdownFunctions:RemoveOptions(remove)
						if not remove then return end
						for _, optionName in ipairs(remove) do
							local optionData = OptionObjs[optionName]

							if optionData then
								for i = #Selected, 1, -1 do
									if Selected[i] == optionName then
										table.remove(Selected, i)
									end
								end

								optionData.Button:Destroy()

								OptionObjs[optionName] = nil
							end
						end

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end
					function DropdownFunctions:IsOption(optionName)
						if not optionName then return end
						return OptionObjs[optionName] ~= nil
					end

					if Flag then
						MacLib.Options[Flag] = DropdownFunctions
					end

					return DropdownFunctions
				end

				function SectionFunctions:Header(Settings, Flag)
					local HeaderFunctions = {Settings = Settings}

					local header = Instance.new("Frame")
					header.Name = "Header"
					header.AutomaticSize = Enum.AutomaticSize.Y
					header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					header.BackgroundTransparency = 1
					header.BorderColor3 = Color3.fromRGB(0, 0, 0)
					header.BorderSizePixel = 0
					header.LayoutOrder = 0
					header.Size = UDim2.fromScale(1, 0)
					header.Parent = section

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 5)
					uIPadding.Parent = header

					local headerText = Instance.new("TextLabel")
					headerText.Name = "HeaderText"
					headerText.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					headerText.RichText = true
					headerText.Text = HeaderFunctions.Settings.Text or HeaderFunctions.Settings.Name
					headerText.TextColor3 = Color3.fromRGB(255, 255, 255)
					headerText.TextSize = 16
					headerText.TextTransparency = 0.3
					headerText.TextWrapped = true
					headerText.TextXAlignment = Enum.TextXAlignment.Left
					headerText.AutomaticSize = Enum.AutomaticSize.Y
					headerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					headerText.BackgroundTransparency = 1
					headerText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					headerText.BorderSizePixel = 0
					headerText.Size = UDim2.fromScale(1, 0)
					headerText.Parent = header

					function HeaderFunctions:UpdateName(New)
						headerText.Text = New
					end
					function HeaderFunctions:SetVisibility(State)
						header.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = HeaderFunctions
					end
					return HeaderFunctions
				end

				function SectionFunctions:Paragraph(Settings, Flag)
					local ParagraphFunctions = {Settings = Settings}

					local paragraph = Instance.new("Frame")
					paragraph.Name = "Paragraph"
					paragraph.AutomaticSize = Enum.AutomaticSize.Y
					paragraph.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
					paragraph.BackgroundTransparency = 0
					paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BorderSizePixel = 0
					paragraph.Size = UDim2.new(1, 0, 0, 0)
					paragraph.Parent = section

					local paraCorner = Instance.new("UICorner")
					paraCorner.CornerRadius = UDim.new(0, 6)
					paraCorner.Parent = paragraph

					local paraStroke = Instance.new("UIStroke")
					paraStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					paraStroke.Color = Color3.fromRGB(255, 255, 255)
					paraStroke.Transparency = 0.94
					paraStroke.Parent = paragraph

					local paraPadding = Instance.new("UIPadding")
					paraPadding.PaddingTop = UDim.new(0, 10)
					paraPadding.PaddingBottom = UDim.new(0, 10)
					paraPadding.PaddingLeft = UDim.new(0, 12)
					paraPadding.PaddingRight = UDim.new(0, 12)
					paraPadding.Parent = paragraph

					local paragraphHeader = Instance.new("TextLabel")
					paragraphHeader.Name = "ParagraphHeader"
					paragraphHeader.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
					paragraphHeader.RichText = true
					paragraphHeader.Text = ParagraphFunctions.Settings.Header
					paragraphHeader.TextColor3 = Color3.fromRGB(235, 235, 240)
					paragraphHeader.TextSize = 13
					paragraphHeader.TextTransparency = 0
					paragraphHeader.TextWrapped = true
					paragraphHeader.TextXAlignment = Enum.TextXAlignment.Left
					paragraphHeader.AutomaticSize = Enum.AutomaticSize.Y
					paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.BackgroundTransparency = 1
					paragraphHeader.BorderSizePixel = 0
					paragraphHeader.Size = UDim2.fromScale(1, 0)
					paragraphHeader.Parent = paragraph

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.Padding = UDim.new(0, 4)
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = paragraph

					local paragraphBody = Instance.new("TextLabel")
					paragraphBody.Name = "ParagraphBody"
					paragraphBody.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					paragraphBody.RichText = true
					paragraphBody.Text = ParagraphFunctions.Settings.Body
					paragraphBody.TextColor3 = Color3.fromRGB(155, 155, 165)
					paragraphBody.TextSize = 11.5
					paragraphBody.TextTransparency = 0
					paragraphBody.TextWrapped = true
					paragraphBody.TextXAlignment = Enum.TextXAlignment.Left
					paragraphBody.AutomaticSize = Enum.AutomaticSize.Y
					paragraphBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphBody.BackgroundTransparency = 1
					paragraphBody.BorderSizePixel = 0
					paragraphBody.LayoutOrder = 1
					paragraphBody.Size = UDim2.fromScale(1, 0)
					paragraphBody.Parent = paragraph

					function ParagraphFunctions:UpdateHeader(New)
						paragraphHeader.Text = New
					end
					function ParagraphFunctions:UpdateBody(New)
						paragraphBody.Text = New
					end
					function ParagraphFunctions:SetVisibility(State)
						paragraph.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ParagraphFunctions
					end
					return ParagraphFunctions
				end

				function SectionFunctions:Divider()
					local divider = Instance.new("Frame")
					divider.Name = "Divider"
					divider.AnchorPoint = Vector2.new(0, 1)
					divider.AutomaticSize = Enum.AutomaticSize.Y
					divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					divider.BackgroundTransparency = 1
					divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
					divider.BorderSizePixel = 0
					divider.Position = UDim2.fromScale(0, 1)
					divider.Size = UDim2.new(1, 0, 0, 1)
					divider.Parent = section

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 8)
					uIPadding.PaddingTop = UDim.new(0, 8)
					uIPadding.Parent = divider

					local line = Instance.new("Frame")
					line.Name = "Line"
					line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					line.BackgroundTransparency = 0.9
					line.BorderColor3 = Color3.fromRGB(0, 0, 0)
					line.BorderSizePixel = 0
					line.Size = UDim2.new(1, 0, 0, 1)
					line.Parent = divider
				end

				return SectionFunctions
			end

			local function SelectCurrentTab()
				local easetime = 0.15

				if currentTabInstance then
					currentTabInstance.Parent = nil
				end

				for i, tabInfo in pairs(tabs) do
					local isCurrent = (i == tabSwitcher)
					Tween(i, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
						BackgroundColor3 = isCurrent and Color3.fromRGB(28, 28, 32) or Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = isCurrent and 0 or 1
					}):Play()

					if tabInfo.tabStroke then
						Tween(tabInfo.tabStroke, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							Color = Color3.fromRGB(255, 255, 255),
							Transparency = isCurrent and 0.92 or 1
						}):Play()
					end
					if tabInfo.switcherImage then
						Tween(tabInfo.switcherImage, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							ImageTransparency = isCurrent and 0 or 0.5
						}):Play()
					end
					if tabInfo.switcherName then
						Tween(tabInfo.switcherName, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							TextTransparency = isCurrent and 0 or 0.5
						}):Play()
					end
				end

				tabs[tabSwitcher].tabContent.Parent = content
				currentTabInstance = tabs[tabSwitcher].tabContent
				currentTab.Text = Settings.Name
			end

			tabSwitcher.MouseButton1Click:Connect(function()
				SelectCurrentTab()
			end)

			function TabFunctions:Select()
				SelectCurrentTab()
			end

			function TabFunctions:InsertConfigSection(Side)
				local configSection = TabFunctions:Section({ Side = Side or "Left" })

				if isStudio then
					configSection:Paragraph({ Header = "Config System", Body = "Config system unavailable in Studio." })
					return
				end

				local inputPath = nil
				local selectedConfig = nil

				configSection:Input({
					Name = "Config Name",
					Placeholder = "Name",
					AcceptedCharacters = "All",
					Callback = function(input)
						inputPath = input
					end,
				})

				local configSelection = configSection:Dropdown({
					Name = "Select Config",
					Multi = false,
					Required = false,
					Options = MacLib:RefreshConfigList(),
					Callback = function(Value)
						selectedConfig = Value
					end,
				})

				configSection:Button({
					Name = "Create Config",
					Callback = function()
						if not inputPath or string.gsub(inputPath, " ", "") == "" then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Config name cannot be empty."
							})
							return
						end

						local success, returned = MacLib:SaveConfig(inputPath)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to save config: " .. tostring(returned)
							})
							return
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Created config %q", inputPath),
						})

						configSelection:ClearOptions()
						configSelection:InsertOptions(MacLib:RefreshConfigList())
					end,
				})

				configSection:Button({
					Name = "Load Config",
					Callback = function()
						local success, returned = MacLib:LoadConfig(configSelection.Value)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to load config: " .. tostring(returned)
							})
							return
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Loaded config %q", tostring(configSelection.Value)),
						})
					end,
				})

				configSection:Button({
					Name = "Overwrite Config",
					Callback = function()
						local success, returned = MacLib:SaveConfig(configSelection.Value)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to overwrite config: " .. tostring(returned)
							})
							return
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Overwrote config %q", tostring(configSelection.Value)),
						})
					end,
				})

				configSection:Button({
					Name = "Refresh Config List",
					Callback = function()
						configSelection:ClearOptions()
						configSelection:InsertOptions(MacLib:RefreshConfigList())
					end,
				})
			end

			tabs[tabSwitcher] = {
				tabContent = elements1,
				tabStroke = tabSwitcherUIStroke,
				switcherImage = tabImage,
				switcherName = tabSwitcherName,
			}

			return TabFunctions
		end

		return SectionFunctions
	end

	function WindowFunctions:Notify(Settings)
		local NotificationFunctions = {}

		local notification = Instance.new("Frame")
		notification.Name = "Notification"
		notification.AnchorPoint = Vector2.new(0.5, 0.5)
		notification.AutomaticSize = Enum.AutomaticSize.Y
		notification.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notification.BorderSizePixel = 0
		notification.Position = UDim2.fromScale(0.5, 0.5)
		notification.Size = UDim2.fromOffset(Settings.SizeX or 260, 0)
		notification.Parent = notifications

		local notificationUIStroke = Instance.new("UIStroke")
		notificationUIStroke.Name = "NotificationUIStroke"
		notificationUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		notificationUIStroke.Color = Color3.fromRGB(255, 255, 255)
		notificationUIStroke.Transparency = 0.9
		notificationUIStroke.Parent = notification

		local notificationUICorner = Instance.new("UICorner")
		notificationUICorner.Name = "NotificationUICorner"
		notificationUICorner.CornerRadius = UDim.new(0, 10)
		notificationUICorner.Parent = notification

		local notificationUIScale = Instance.new("UIScale")
		notificationUIScale.Name = "NotificationUIScale"
		notificationUIScale.Parent = notification
		notificationUIScale.Scale = 0

		local notificationInformation = Instance.new("Frame")
		notificationInformation.Name = "NotificationInformation"
		notificationInformation.AutomaticSize = Enum.AutomaticSize.Y
		notificationInformation.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationInformation.BackgroundTransparency = 1
		notificationInformation.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationInformation.BorderSizePixel = 0
		notificationInformation.Size = UDim2.fromScale(1, 1)

		local notificationTitle = Instance.new("TextLabel")
		notificationTitle.Name = "NotificationTitle"
		notificationTitle.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.SemiBold,
			Enum.FontStyle.Normal
		)
		notificationTitle.RichText = true
		notificationTitle.Text = Settings.Title or "Notice"
		notificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationTitle.TextSize = 13
		notificationTitle.TextTransparency = 0.2
		notificationTitle.TextTruncate = Enum.TextTruncate.SplitWord
		notificationTitle.TextXAlignment = Enum.TextXAlignment.Left
		notificationTitle.TextYAlignment = Enum.TextYAlignment.Top
		notificationTitle.AutomaticSize = Enum.AutomaticSize.XY
		notificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationTitle.BackgroundTransparency = 1
		notificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationTitle.BorderSizePixel = 0
		notificationTitle.Size = UDim2.new(1, -12, 0, 0)

		local notificationTitleUIPadding = Instance.new("UIPadding")
		notificationTitleUIPadding.Name = "NotificationTitleUIPadding"
		notificationTitleUIPadding.PaddingRight = UDim.new(0, 25)
		notificationTitleUIPadding.Parent = notificationTitle

		notificationTitle.Parent = notificationInformation

		local notificationDescription = Instance.new("TextLabel")
		notificationDescription.Name = "NotificationDescription"
		notificationDescription.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		notificationDescription.Text = Settings.Description or ""
		notificationDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationDescription.TextSize = 11
		notificationDescription.TextTransparency = 0.5
		notificationDescription.TextWrapped = true
		notificationDescription.RichText = true
		notificationDescription.TextXAlignment = Enum.TextXAlignment.Left
		notificationDescription.TextYAlignment = Enum.TextYAlignment.Top
		notificationDescription.AutomaticSize = Enum.AutomaticSize.XY
		notificationDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationDescription.BackgroundTransparency = 1
		notificationDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationDescription.BorderSizePixel = 0
		notificationDescription.Size = UDim2.new(1, -12, 0, 0)

		local notificationDescriptionUIPadding = Instance.new("UIPadding")
		notificationDescriptionUIPadding.Name = "NotificationDescriptionUIPadding"
		notificationDescriptionUIPadding.PaddingRight = UDim.new(0, 25)
		notificationDescriptionUIPadding.PaddingTop = UDim.new(0, 17)
		notificationDescriptionUIPadding.Parent = notificationDescription

		notificationDescription.Parent = notificationInformation

		local notificationUIPadding = Instance.new("UIPadding")
		notificationUIPadding.Name = "NotificationUIPadding"
		notificationUIPadding.PaddingBottom = UDim.new(0, 12)
		notificationUIPadding.PaddingLeft = UDim.new(0, 10)
		notificationUIPadding.PaddingRight = UDim.new(0, 10)
		notificationUIPadding.PaddingTop = UDim.new(0, 10)
		notificationUIPadding.Parent = notificationInformation

		notificationInformation.Parent = notification

		local tweens = {
			In = Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = Settings.Scale or 1
			}),
			Out = Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 0
			}),
		}

		local AnimateNotification = task.spawn(function()
			tweens.In:Play()
			local lifetime = Settings.Lifetime or 3
			if lifetime ~= 0 then
				task.wait(lifetime)
				local out = tweens.Out
				out:Play()
				out.Completed:Wait()
				notification:Destroy()
			end
		end)

		function NotificationFunctions:Cancel()
			task.cancel(AnimateNotification)
			local out = tweens.Out
			out:Play()
			out.Completed:Wait()
			notification:Destroy()
		end

		return NotificationFunctions
	end

	function WindowFunctions:Dialog(Settings)
		local DialogFunctions = {}

		local dialogCanvas = Instance.new("CanvasGroup")
		dialogCanvas.Name = "DialogCanvas"
		dialogCanvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		dialogCanvas.BackgroundTransparency = 1
		dialogCanvas.BorderColor3 = Color3.fromRGB(0, 0, 0)
		dialogCanvas.BorderSizePixel = 0
		dialogCanvas.Size = UDim2.fromScale(1, 1)
		dialogCanvas.GroupTransparency = 1
		dialogCanvas.Parent = base

		local dialog = Instance.new("Frame")
		dialog.Name = "Dialog"
		dialog.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		dialog.BackgroundTransparency = 0.5
		dialog.BorderColor3 = Color3.fromRGB(0, 0, 0)
		dialog.BorderSizePixel = 0
		dialog.Size = UDim2.fromScale(1, 1)

		local dialogUICorner = Instance.new("UICorner")
		dialogUICorner.Name = "BaseUICorner"
		dialogUICorner.CornerRadius = UDim.new(0, 10)
		dialogUICorner.Parent = dialog

		local prompt = Instance.new("Frame")
		prompt.Name = "Prompt"
		prompt.AnchorPoint = Vector2.new(0.5, 0.5)
		prompt.AutomaticSize = Enum.AutomaticSize.Y
		prompt.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		prompt.BorderColor3 = Color3.fromRGB(0, 0, 0)
		prompt.BorderSizePixel = 0
		prompt.Position = UDim2.fromScale(0.5, 0.5)
		prompt.Size = UDim2.fromOffset(300, 0)

		local promptUIScale = Instance.new("UIScale")
		promptUIScale.Name = "BaseUIScale"
		promptUIScale.Parent = prompt
		promptUIScale.Scale = 0.95

		local globalSettingsUIStroke = Instance.new("UIStroke")
		globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
		globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
		globalSettingsUIStroke.Transparency = 0.9
		globalSettingsUIStroke.Parent = prompt

		local globalSettingsUICorner = Instance.new("UICorner")
		globalSettingsUICorner.Name = "GlobalSettingsUICorner"
		globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
		globalSettingsUICorner.Parent = prompt

		local globalSettingsUIPadding = Instance.new("UIPadding")
		globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
		globalSettingsUIPadding.PaddingBottom = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingLeft = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingRight = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingTop = UDim.new(0, 20)
		globalSettingsUIPadding.Parent = prompt

		local paragraph = Instance.new("Frame")
		paragraph.Name = "Paragraph"
		paragraph.AutomaticSize = Enum.AutomaticSize.Y
		paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		paragraph.BackgroundTransparency = 1
		paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraph.BorderSizePixel = 0
		paragraph.Size = UDim2.new(1, 0, 0, 38)

		local paragraphHeader = Instance.new("TextLabel")
		paragraphHeader.Name = "ParagraphHeader"
		paragraphHeader.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		paragraphHeader.RichText = true
		paragraphHeader.Text = Settings.Title or "Notice"
		paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
		paragraphHeader.TextSize = 18
		paragraphHeader.TextTransparency = 0.4
		paragraphHeader.TextWrapped = true
		paragraphHeader.AutomaticSize = Enum.AutomaticSize.Y
		paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		paragraphHeader.BackgroundTransparency = 1
		paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraphHeader.BorderSizePixel = 0
		paragraphHeader.Size = UDim2.fromScale(1, 0)
		paragraphHeader.Parent = paragraph

		local uIListLayout = Instance.new("UIListLayout")
		uIListLayout.Name = "UIListLayout"
		uIListLayout.Padding = UDim.new(0, 15)
		uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout.Parent = paragraph

		local paragraphBody = Instance.new("TextLabel")
		paragraphBody.Name = "ParagraphBody"
		paragraphBody.FontFace = Font.new(assets.interFont)
		paragraphBody.RichText = true
		paragraphBody.Text = Settings.Description or ""
		paragraphBody.TextColor3 = Color3.fromRGB(255, 255, 255)
		paragraphBody.TextSize = 14
		paragraphBody.TextTransparency = 0.5
		paragraphBody.TextWrapped = true
		paragraphBody.AutomaticSize = Enum.AutomaticSize.Y
		paragraphBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		paragraphBody.BackgroundTransparency = 1
		paragraphBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraphBody.BorderSizePixel = 0
		paragraphBody.LayoutOrder = 1
		paragraphBody.Size = UDim2.fromScale(1, 0)
		paragraphBody.Parent = paragraph

		paragraph.Parent = prompt

		local interactions = Instance.new("Frame")
		interactions.Name = "Interactions"
		interactions.AutomaticSize = Enum.AutomaticSize.Y
		interactions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		interactions.BackgroundTransparency = 1
		interactions.BorderColor3 = Color3.fromRGB(0, 0, 0)
		interactions.BorderSizePixel = 0
		interactions.LayoutOrder = 1
		interactions.Size = UDim2.fromScale(1, 0)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 10)
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = interactions

		local uIPadding = Instance.new("UIPadding")
		uIPadding.Name = "UIPadding"
		uIPadding.PaddingTop = UDim.new(0, 20)
		uIPadding.Parent = interactions

		interactions.Parent = prompt

		prompt.Parent = dialog
		dialog.Parent = dialogCanvas

		local canvasIn = Tween(dialogCanvas, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { GroupTransparency = 0 })
		local canvasOut = Tween(dialogCanvas, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { GroupTransparency = 1 })
		local scaleIn = Tween(promptUIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { Scale = 1 })
		local scaleOut = Tween(promptUIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { Scale = 0.95 })

		local function dialogIn()
			canvasIn:Play()
			scaleIn:Play()
			canvasIn.Completed:Wait()
			dialog.Parent = base
		end

		local function dialogOut()
			if not dialog.Parent then return end
			dialog.Parent = dialogCanvas
			canvasOut:Play()
			scaleOut:Play()
			canvasOut.Completed:Wait()
			dialogCanvas:Destroy()
		end

		if Settings.Buttons then
			for _, v in pairs(Settings.Buttons) do
				local button = Instance.new("TextButton")
				button.Name = "Button"
				button.FontFace = Font.new(assets.interFont)
				button.Text = v.Name or v.Title or "Button"
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.TextSize = 15
				button.TextTransparency = 0.5
				button.TextTruncate = Enum.TextTruncate.AtEnd
				button.AutoButtonColor = false
				button.AutomaticSize = Enum.AutomaticSize.Y
				button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				button.BorderSizePixel = 0
				button.Size = UDim2.fromScale(1, 0)

				local uIPadding1 = Instance.new("UIPadding")
				uIPadding1.Name = "UIPadding"
				uIPadding1.PaddingBottom = UDim.new(0, 9)
				uIPadding1.PaddingLeft = UDim.new(0, 10)
				uIPadding1.PaddingRight = UDim.new(0, 10)
				uIPadding1.PaddingTop = UDim.new(0, 9)
				uIPadding1.Parent = button

				local baseUICorner1 = Instance.new("UICorner")
				baseUICorner1.Name = "BaseUICorner"
				baseUICorner1.CornerRadius = UDim.new(0, 10)
				baseUICorner1.Parent = button

				button.Parent = interactions

				button.MouseButton1Click:Connect(function()
					if dialogCanvas.GroupTransparency ~= 0 then return end
					if v.Callback then v.Callback() end
					dialogOut()
				end)
			end
		end

		dialogIn()

		function DialogFunctions:Cancel()
			dialogOut()
		end

		return DialogFunctions
	end

	function WindowFunctions:SetState(State)
		windowState = State
		base.Visible = State
	end

	function WindowFunctions:GetState()
		return windowState
	end

	function WindowFunctions:Unload()
		macLib:Destroy()
		unloaded = true
	end

	local MenuKeybind = Settings.Keybind or Enum.KeyCode.RightControl

	function WindowFunctions:SetKeybind(newKey)
		MenuKeybind = newKey
	end

	function WindowFunctions:GetKeybind()
		return MenuKeybind
	end

	local function ToggleMenu()
		local state = not WindowFunctions:GetState()
		WindowFunctions:SetState(state)
	end

	UserInputService.InputEnded:Connect(function(inp, gpe)
		if gpe then return end
		if MenuKeybind and inp.KeyCode == MenuKeybind then
			ToggleMenu()
		end
	end)

	minimize.MouseButton1Click:Connect(ToggleMenu)
	exit.MouseButton1Click:Connect(function()
		WindowFunctions:Dialog({
			Title = Settings.Title,
			Description = "Are you sure you want to exit the menu?",
			Buttons = {
				{
					Name = "Confirm",
					Callback = function()
						WindowFunctions:Unload()
					end,
				},
				{
					Name = "Cancel"
				}
			}
		})
	end)

	function WindowFunctions:SetFolder(Folder)
		MacLib.Folder = Folder
	end

	function MacLib:SetFolder(Folder)
		MacLib.Folder = Folder
	end

	function MacLib:SaveConfig(Path)
		if isStudio or not writefile then return false, "writefile unavailable" end
		if not Path or Path == "" then return false, "Empty path" end
		local fullPath = MacLib.Folder .. "/settings/" .. Path .. ".json"
		if not isfolder(MacLib.Folder) then makefolder(MacLib.Folder) end
		if not isfolder(MacLib.Folder .. "/settings") then makefolder(MacLib.Folder .. "/settings") end

		local data = { objects = {} }
		for flag, option in pairs(MacLib.Options) do
			if option.Value ~= nil then
				table.insert(data.objects, { flag = flag, value = option.Value })
			end
		end

		local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
		if not success then return false, "Encode error" end
		writefile(fullPath, encoded)
		return true
	end

	function MacLib:LoadConfig(Path)
		if isStudio or not (isfile and readfile) then return false, "readfile unavailable" end
		if not Path then return false, "Empty path" end
		local file = MacLib.Folder .. "/settings/" .. Path .. ".json"
		if not isfile(file) then return false, "Invalid file" end
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
		if not success then return false, "Decode error" end

		for _, item in ipairs(decoded.objects or {}) do
			local opt = MacLib.Options[item.flag]
			if opt and opt.SetValue then
				pcall(function() opt:SetValue(item.value) end)
			end
		end
		return true
	end

	function MacLib:RefreshConfigList()
		if isStudio or not (isfolder and listfiles) then return {} end
		local dir = MacLib.Folder .. "/settings"
		if not isfolder(dir) then return {} end
		local list = listfiles(dir) or {}
		local out = {}
		for _, file in ipairs(list) do
			if file:sub(-5) == ".json" then
				local filename = file:match("([^/\\]+)%.json$")
				if filename and filename ~= "options" then
					table.insert(out, filename)
				end
			end
		end
		return out
	end

	macLib.Enabled = true
	base.Visible = true
	windowState = true

	return WindowFunctions
end

return MacLib

end)()

local function GetOptimalWindowSize()
    local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
    -- ตรวจสอบหากเป็นหน้าจอมือถือ (ViewportSize กว้างน้อยกว่า 900 หรือ TouchEnabled)
    if vp.X < 900 or UserInputService.TouchEnabled then
        local w = math.clamp(math.floor(vp.X * 0.88), 340, 720)
        local h = math.clamp(math.floor(vp.Y * 0.82), 260, 480)
        return UDim2.fromOffset(w, h)
    end
    return UDim2.fromOffset(860, 600)
end

local Window = MacLib:Window({
    Title = "KrakenHub",
    Subtitle = "สายเลือดอาชีวะ | v1.0",
    Size = GetOptimalWindowSize(),
    DragStyle = 2,
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = false,
})

function Window:Minimize()
    local cur = Window:GetState()
    Window:SetState(not cur)
end

local originalDialog = Window.Dialog
function Window:Dialog(cfg)
    local buttons = {}
    if cfg.Buttons then
        for _, b in ipairs(cfg.Buttons) do
            table.insert(buttons, {
                Name = b.Title or b.Name or "Button",
                Callback = b.Callback
            })
        end
    end
    return originalDialog(Window, {
        Title = cfg.Title or "Notice",
        Description = cfg.Content or cfg.Description or "",
        Buttons = buttons
    })
end

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
        stroke.Color = Color3.fromHSV(0, 1, 1)
        stroke.Thickness = 1.2
        stroke.Transparency = 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = mainBtn

        -- 🌈 RGB loop — หมุน hue ต่อเนื่อง (throttle 10 FPS เพื่อไม่ให้กินเฟรมเรนเดอร์)
        local _btnHue = 0
        local _lastBtnHue = 0
        if Connections.ToggleBtnRGB then
            pcall(function() Connections.ToggleBtnRGB:Disconnect() end)
        end
        Connections.ToggleBtnRGB = RunService.Heartbeat:Connect(function(dt)
            if not State.Running or not screenGui.Parent then return end
            if State.HideToggleButton then
                if screenGui.Enabled then screenGui.Enabled = false end
                return
            else
                if not screenGui.Enabled then screenGui.Enabled = true end
            end
            local now = os.clock()
            if now - _lastBtnHue >= 0.1 then
                local delta = now - _lastBtnHue
                _lastBtnHue = now
                _btnHue = (_btnHue + delta * 0.18) % 1
                stroke.Color = Color3.fromHSV(_btnHue, 1, 1)
            end
        end)

        local logoImg = Instance.new("ImageLabel")
        logoImg.Name = "Logo"
        logoImg.Size = UDim2.fromScale(0.82, 0.82)
        logoImg.Position = UDim2.fromScale(0.5, 0.5)
        logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
        logoImg.BackgroundTransparency = 1
        logoImg.Image = GetLogoAsset()
        logoImg.ScaleType = Enum.ScaleType.Fit
        logoImg.Parent = mainBtn

        local dragging = false
        local dragStartPos = nil
        local startFramePos = nil
        local movedEnough = false
        local dragThreshold = 8

        mainBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                movedEnough = false
                dragThreshold = (input.UserInputType == Enum.UserInputType.Touch) and 18 or 8
                dragStartPos = input.Position
                startFramePos = mainBtn.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartPos
                if delta.Magnitude > dragThreshold then
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

        mainBtn.Activated:Connect(function()
            if not movedEnough then
                task.spawn(function()
                    TweenService:Create(mainBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(42, 42)
                    }):Play()
                    task.wait(0.08)
                    TweenService:Create(mainBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(48, 48)
                    }):Play()
                end)

                if windowObj and windowObj.Minimize then
                    windowObj:Minimize()
                end
            end
        end)

        mainBtn.MouseEnter:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Thickness = 1.8 }):Play()
        end)
        mainBtn.MouseLeave:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Thickness = 1.2 }):Play()
        end)

        local okP = pcall(function() screenGui.Parent = targetGuiParent end)
        if not okP or not screenGui.Parent then
            pcall(function() screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
        end
        Hub.ToggleButtonGui = screenGui
    end)
end
CreateFloatingToggleButton(Window)

local tabGroup = Window:TabGroup()
local Options = {}
MacLib.Options = Options

local function CreateTabAdapter(rawTab, tabName)
    local leftSection = rawTab:Section({ Side = "Left" })
    local rightSection = rawTab:Section({ Side = "Right" })
    local currentSection = leftSection
    local side = "Left"

    local adapter = {
        RawTab = rawTab,
        Select = function(self)
            rawTab:Select()
        end,
        AddSection = function(self, title)
            if side == "Left" then
                side = "Right"
                currentSection = rightSection
            else
                side = "Left"
                currentSection = rawTab:Section({ Side = "Left" })
            end
            currentSection:Header({ Text = title })
            return currentSection
        end,
        AddParagraph = function(self, cfg)
            if tabName == "Player" and (cfg.Title and cfg.Title:find("ESP")) then
                side = "Right"
                currentSection = rightSection
            end

            local para = currentSection:Paragraph({
                Header = cfg.Title or cfg.Header or "Paragraph",
                Body = cfg.Content or cfg.Body or ""
            })
            return {
                SetTitle = function(self, t) if para.UpdateHeader then para:UpdateHeader(t) end end,
                SetDesc = function(self, d) if para.UpdateBody then para:UpdateBody(d) end end
            }
        end,
        AddToggle = function(self, flag, cfg)
            local macToggle = currentSection:Toggle({
                Name = cfg.Title or flag,
                Default = cfg.Default or false,
                Callback = cfg.Callback
            }, flag)
            macToggle.Value = cfg.Default or false
            macToggle.State = macToggle.Value
            Options[flag] = macToggle
            return macToggle
        end,
        AddSlider = function(self, flag, cfg)
            local macSlider = currentSection:Slider({
                Name = cfg.Title or flag,
                Minimum = cfg.Min or 0,
                Maximum = cfg.Max or 100,
                Default = cfg.Default or cfg.Min or 0,
                Precision = cfg.Rounding or 0,
                Callback = cfg.Callback
            }, flag)
            macSlider.Min = cfg.Min or 0
            macSlider.Max = cfg.Max or 100
            macSlider.Value = cfg.Default or cfg.Min or 0
            Options[flag] = macSlider
            return macSlider
        end,
        AddDropdown = function(self, flag, cfg)
            local macDropdown = currentSection:Dropdown({
                Name = cfg.Title or flag,
                Options = cfg.Values or {},
                Default = cfg.Default,
                Multi = cfg.Multi or false,
                Required = cfg.Required ~= false,
                Image = cfg.Image or cfg.Icon,
                Callback = cfg.Callback
            }, flag)
            macDropdown.Value = cfg.Default or (cfg.Values and cfg.Values[1]) or ""
            Options[flag] = macDropdown
            return macDropdown
        end,
        AddButton = function(self, cfg)
            return currentSection:Button({
                Name = cfg.Title or cfg.Name or "Button",
                Callback = cfg.Callback
            })
        end,
        AddKeybind = function(self, flag, cfg)
            local macKeybind = currentSection:Keybind({
                Name = cfg.Title or flag,
                Default = cfg.Default,
                Callback = cfg.Callback
            }, flag)
            macKeybind.Value = cfg.Default
            Options[flag] = macKeybind
            return macKeybind
        end,
        AddInput = function(self, flag, cfg)
            local macInput = currentSection:Input({
                Name = cfg.Title or flag,
                Default = cfg.Default or "",
                Placeholder = cfg.Placeholder or "",
                Callback = cfg.Callback
            }, flag)
            macInput.Value = cfg.Default or ""
            Options[flag] = macInput
            return macInput
        end
    }

    return adapter
end

local Tabs = {
    Farm      = CreateTabAdapter(tabGroup:Tab({ Name = "งาน & ฟาร์ม", Image = "rbxassetid://10723405360" }), "Farm"),
    Merchant  = CreateTabAdapter(tabGroup:Tab({ Name = "พ่อค้าพเนจร", Image = "rbxassetid://10734952479" }), "Merchant"),
    Combat    = CreateTabAdapter(tabGroup:Tab({ Name = "ระบบต่อสู้",   Image = "rbxassetid://10709818534" }), "Combat"),
    Player    = CreateTabAdapter(tabGroup:Tab({ Name = "ตัวละคร",     Image = "rbxassetid://10747373176" }), "Player"),
    Settings  = CreateTabAdapter(tabGroup:Tab({ Name = "ตั้งค่า",       Image = "rbxassetid://10734950309" }), "Settings")
}

function Window:SelectTab(idx)
    if idx == 1 and Tabs.Farm then Tabs.Farm:Select()
    elseif idx == 2 and Tabs.Merchant then Tabs.Merchant:Select()
    elseif idx == 3 and Tabs.Combat then Tabs.Combat:Select()
    elseif idx == 4 and Tabs.Player then Tabs.Player:Select()
    elseif idx == 5 and Tabs.Settings then Tabs.Settings:Select()
    end
end

local Fluent = {
    Options = Options,
    Notify = function(self, cfg)
        Window:Notify({
            Title = cfg.Title or "KrakenHub",
            Description = cfg.Content or cfg.Description or cfg.SubContent or "",
            Lifetime = cfg.Duration or 4
        })
    end,
    Destroy = function(self)
        pcall(function() Window:Unload() end)
    end
}

local SaveManager = {
    SetLibrary = function() end,
    IgnoreThemeSettings = function() end,
    SetIgnoreIndexes = function() end,
    SetFolder = function(self, f) MacLib:SetFolder(f) end,
    BuildConfigSection = function(self, tab)
        pcall(function()
            if tab and tab.RawTab then
                tab.RawTab:InsertConfigSection("Right")
            end
        end)
    end,
    LoadAutoloadConfig = function() end
}

local InterfaceManager = {
    SetLibrary = function() end,
    SetFolder = function() end,
    BuildInterfaceSection = function() end
}

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
                if not State.AutoSolveMinigame then return end

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
                    while State.AutoSolveMinigame and not session.completed do
                        task.wait(0.12)
                        if session.key and inputRemote then
                            pcall(function() inputRemote:FireServer(session.key) end)
                        end

                        local elapsed = tick() - session.startTime
                        if elapsed >= session.minWait then
                            session.completed = true
                            pcall(function()
                                if session.siteType ~= "TrashDigSite" then
                                    if doneRemote then
                                        doneRemote:FireServer(session.siteType, session.siteInstance)
                                    end
                                    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                                    local mgUI = pgui and pgui:FindFirstChild("MiniGameUI")
                                    if mgUI then mgUI.Enabled = false end
                                end
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
    if not State.AutoSolveMinigame then
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
        local tf = mg:FindFirstChild("TrashFrame")

        local needsHold = (wf and wf.Visible) or (df and df.Visible) or (sf and sf.Visible) or (sw and sw.Visible) or (efOil and efOil.Visible) or (tf and tf.Visible)
        if needsHold then
            local hrp = GetHRP()
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end

            if tf and tf.Visible then
                local darkBox = tf:FindFirstChild("DarkBox")
                local inputCatcher = darkBox and darkBox:FindFirstChild("InputCatcher")
                local targetObj = nil
                if darkBox then
                    for _, ch in ipairs(darkBox:GetChildren()) do
                        if ch.Name == "Target" and ch:IsA("GuiObject") and ch.Visible then
                            local icon = ch:FindFirstChild("Icon")
                            local isDone = false
                            if icon and icon:IsA("ImageLabel") then
                                local c = icon.ImageColor3
                                if c.R < 0.6 and c.G > 0.7 and c.B < 0.65 then
                                    isDone = true
                                end
                            end
                            if not isDone then
                                targetObj = ch
                                break
                            end
                        end
                    end
                end

                if targetObj then
                    local cx = targetObj.AbsolutePosition.X + targetObj.AbsoluteSize.X / 2
                    local cy = targetObj.AbsolutePosition.Y + targetObj.AbsoluteSize.Y / 2

                    if VirtualInputManager then
                        pcall(function() VirtualInputManager:SendMouseMoveEvent(cx, cy, game) end)
                    end

                    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        if VirtualInputManager then
                            pcall(function() VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 0) end)
                        end
                        isVIMHolding = true
                    end

                    pcall(function()
                        if inputCatcher then
                            local conns = getconnections(inputCatcher.MouseButton1Down)
                            if #conns > 0 and conns[1].Function then
                                local startHoldFn = getupvalues(conns[1].Function)[1]
                                if startHoldFn then
                                    local updateLightFn = getupvalues(startHoldFn)[9]
                                    if updateLightFn then
                                        updateLightFn(Vector2.new(cx, cy))
                                    end
                                end
                            end
                        end
                    end)
                else
                    ReleaseVIM()
                end
            else
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

                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    if VirtualInputManager then
                        pcall(function() VirtualInputManager:SendMouseButtonEvent(posX, posY, 0, true, game, 0) end)
                    end
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
                        if VirtualInputManager then
                            pcall(function() VirtualInputManager:SendMouseMoveEvent(moveX, moveY, game) end)
                        end
                    end
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
    while _G._KrakenScriptId == MY_SCRIPT_ID do
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

                -- จัดการขยะ (TrashFrame) ปล่อยให้ MinigameHoldLoop ล็อคไฟฉายทีละจุดตามธรรมชาติ 15 วินาที เพื่อให้เซิร์ฟเวอร์ดรอปไอเทมลงกระเป๋า 100%

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
                        local testAngles = {0, 90, 180, 270}

                        for _, deg in ipairs(testAngles) do
                            local rad = math.rad(deg)
                            local offset = Vector3.new(math.cos(rad) * 2.5, 0, math.sin(rad) * 2.5)
                            local testP = spotPos + offset
                            local rayDown = Workspace:Raycast(testP + Vector3.new(0, 4, 0), Vector3.new(0, -12, 0), rayParams)
                            if rayDown then
                                standPos = Vector3.new(testP.X, rayDown.Position.Y + 3.0, testP.Z)
                                break
                            end
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
                        local d = (myPos - standPos).Magnitude
                        if d < bestDist and math.abs(myPos.Y - standPos.Y) <= 6.5 then
                            if not isOccupied(standPos) and not isOccupied(spotInfo.spotPos) then
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
local function ClaimConstructionWage(isAuto)
    local now = tick()
    if now - lastCollectTime < 2.5 then return false end
    lastCollectTime = now

    local successResult = false
    pcall(function()
        local const = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
        local collect = const and const:FindFirstChild("Collect")
        local hire = const and const:FindFirstChild("Hire")
        if not collect then return end

        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local cUI = pgui and pgui:FindFirstChild("ConstructionUI")
        local mf = cUI and cUI:FindFirstChild("MainFrame")
        local hp = mf and mf:FindFirstChild("HirePage")
        if hp and hp.Visible and hire then
            pcall(function() hire:InvokeServer() end)
            task.wait(0.2)
        end

        local success, amount = collect:InvokeServer()
        if success and typeof(amount) == "number" and amount > 0 then
            successResult = true
            Notify("งานก่อสร้าง", "💰 เคลมเงินสำเร็จ! ได้รับ " .. tostring(amount) .. " Cash เข้ากระเป๋า", "", 3.5)
            if cUI and cUI:FindFirstChild("MainFrame") then
                local wp = cUI.MainFrame:FindFirstChild("WorkPage")
                local eb = wp and wp:FindFirstChild("EarningsBox")
                local ea = eb and eb:FindFirstChild("EarningsAmount")
                if ea then ea.Text = "0 Cash" end
            end
            if UpdateWageDisplay then UpdateWageDisplay("0 Cash") end
        elseif not isAuto then
            Notify("งานก่อสร้าง", "ยังไม่มียอดเงินสะสมให้เคลม หรือทำงานก่อนนะ", "", 2.5)
        end
    end)
    return successResult
end

local WageEarningsParagraph = nil

local function GetCurrentAccumulatedWage()
    local text = "0 Cash"
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local cUI = pgui and pgui:FindFirstChild("ConstructionUI")
        local mf = cUI and cUI:FindFirstChild("MainFrame")
        local wp = mf and mf:FindFirstChild("WorkPage")
        local eb = wp and wp:FindFirstChild("EarningsBox")
        local ea = eb and eb:FindFirstChild("EarningsAmount")
        if ea and ea.Text ~= "" then
            text = ea.Text
        end
    end)
    return text
end

local function UpdateWageDisplay(customAmountText)
    if not WageEarningsParagraph then return end
    local earnStr = customAmountText or GetCurrentAccumulatedWage()
    pcall(function()
        if type(WageEarningsParagraph.SetTitle) == "function" then
            WageEarningsParagraph:SetTitle("💵 ยอดเงินสะสม: " .. earnStr)
        end
        if type(WageEarningsParagraph.SetDesc) == "function" then
            WageEarningsParagraph:SetDesc("")
        end
    end)
end

-- 🔔 ดักจับ Event UpdateEarnings สำหรับระบบ Auto Claim และ Realtime UI
pcall(function()
    local const = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
    local updateEarnings = const and const:FindFirstChild("UpdateEarnings")
    if updateEarnings then
        if Connections.AutoClaimUpdateConn then Connections.AutoClaimUpdateConn:Disconnect() end
        Connections.AutoClaimUpdateConn = updateEarnings.OnClientEvent:Connect(function(newEarnings)
            if typeof(newEarnings) == "number" then
                UpdateWageDisplay(tostring(newEarnings) .. " Cash")
            else
                UpdateWageDisplay()
            end

            if State.Running and State.AutoClaimConstruction and typeof(newEarnings) == "number" and newEarnings >= 300 then
                task.delay(0.6, function()
                    if State.Running and State.AutoClaimConstruction then
                        ClaimConstructionWage(true)
                    end
                end)
            end
        end)
    end
end)

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(0.08)
        if State.AutoClaimConstruction and (tick() - lastCollectTime) >= 15.0 then
            ClaimConstructionWage(true)
        end
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

                        -- กด ProximityPrompt ที่โต๊ะ/ตัว NPC (ปลอดภัย 100% ไม่โดนเตะ 267 / CODE: 49 / CODE: 59)
                        if npcPrompt and npcPrompt.Enabled then
                            local origH = npcPrompt:GetAttribute("_OrigHoldDuration")
                            local holdTime = (origH and origH > 0 and origH) or npcPrompt.HoldDuration or 0
                            if holdTime > 0 then
                                local vim = game:GetService("VirtualInputManager")
                                if vim and typeof(vim.SendKeyEvent) == "function" then
                                    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                    local startH = os.clock()
                                    while (os.clock() - startH) < (holdTime + 0.12) and State.AutoFarm and State.Running do
                                        task.wait(0.03)
                                    end
                                    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                    task.wait(0.08)
                                else
                                    pcall(function() npcPrompt:InputHoldBegin() end)
                                    local startH = os.clock()
                                    while (os.clock() - startH) < holdTime and State.AutoFarm and State.Running do
                                        task.wait(0.03)
                                    end
                                    pcall(function() npcPrompt:InputHoldEnd() end)
                                    task.wait(0.05)
                                    pcall(function() fireproximityprompt(npcPrompt) end)
                                end
                            else
                                task.wait(0.08)
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

                    -- กดเริ่มงานอย่างรวดเร็วและปลอดภัย (Safe Hold Duration ป้องกัน CODE: 49 และ CODE: 59)
                    local origHold = prompt:GetAttribute("_OrigHoldDuration")
                    local holdTime = (origHold and origHold > 0 and origHold) or prompt.HoldDuration or 0
                    if holdTime > 0 then
                        local vim = game:GetService("VirtualInputManager")
                        if vim and typeof(vim.SendKeyEvent) == "function" then
                            vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            local startHold = os.clock()
                            while (os.clock() - startHold) < (holdTime + 0.12) and State.AutoFarm and State.Running and not IsCurrentlyWorking() do
                                if hrp then
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero
                                end
                                task.wait(0.03)
                            end
                            vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                            task.wait(0.08)
                        else
                            pcall(function() prompt:InputHoldBegin() end)
                            local startHold = os.clock()
                            while (os.clock() - startHold) < holdTime and State.AutoFarm and State.Running and not IsCurrentlyWorking() do
                                if hrp then
                                    hrp.AssemblyLinearVelocity = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero
                                end
                                task.wait(0.03)
                            end
                            pcall(function() prompt:InputHoldEnd() end)
                            task.wait(0.05)
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                    else
                        task.wait(0.08)
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
            task.wait(0.8)
        end
    end
end)



--------------------------------------------------------------
-- 9. ระบบตัวละคร (CHEATS: SPEED, JUMP, NOCLIP, FLY, INFJUMP, ESP)
--------------------------------------------------------------
local _noclipPiercedParts = {}
local _noclipRayParams = RaycastParams.new()
_noclipRayParams.FilterType = Enum.RaycastFilterType.Exclude
_noclipRayParams.IgnoreWater = true

local function RestoreCharacterCollisions()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local pName = part.Name
                    if pName == "Torso" or pName == "Head" or pName == "UpperTorso" or pName == "LowerTorso" then
                        part.CanCollide = true
                    elseif pName == "HumanoidRootPart" then
                        part.CanCollide = false
                    else
                        part.CanCollide = false
                    end
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end

        -- คืนค่า CanCollide ให้กำแพง/ประตูที่เคยถูกเปิดทะลุ
        for part, origState in pairs(_noclipPiercedParts) do
            if part and part.Parent and typeof(origState) == "boolean" then
                pcall(function() part.CanCollide = origState end)
            end
        end
        table.clear(_noclipPiercedParts)
    end)
end

local function ApplySmoothNoclip(dt)
    dt = dt or 0.016
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    -- 1. ปลดล็อค CanCollide ทุก BasePart ในตัวละคร (รวมถึง Accessory, หมวก, เสื้อเกราะ, อาวุธในมือ ป้องกันเด้งกลับ 100%)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end

    -- 2. ป้องกัน Humanoid ติดสถานะปีนป่ายหรือติดขัดในกำแพงจนเกิดอาการเด้งกลับ (Anti-Bounce)
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Climbing or st == Enum.HumanoidStateType.StrafingNoPhysics then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    -- 3. ตรวจจับการเดินและการตัดแรงสะท้อนกลับ (Anti-Impulse & Wall Pierce)
    local moveDir = hum.MoveDirection
    if moveDir.Magnitude > 0.05 then
        local horizDir = Vector3.new(moveDir.X, 0, moveDir.Z).Unit

        -- ล้างแรงสะท้อนกลับ (หากความเร็วของตัวละครกำลังพุ่งสวนทางกับทิศทางที่ผู้เล่นกดเดิน ป้องกัน Rubberband เด้งกลับ)
        local forwardDot = hrp.AssemblyLinearVelocity:Dot(horizDir)
        if forwardDot < -0.5 then
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
        end

        -- 4. ยิงเรย์ตรวจจับกำแพง/ประตู/สิ่งกีดขวางตรงหน้า แล้วปลด CanCollide ฝั่งกำแพงแบบเจาะจง (Bypass Anti-Noclip & Physics Wall)
        _noclipRayParams.FilterDescendantsInstances = {char}
        local forwardRay = workspace:Raycast(hrp.Position, horizDir * 3.5, _noclipRayParams)
        if forwardRay and forwardRay.Instance and forwardRay.Instance:IsA("BasePart") then
            local hitPart = forwardRay.Instance
            -- ตรวจสอบว่าไม่ใช่พื้นใต้ฝ่าเท้า (Y ต้องสูงกว่าระดับเท้าของผู้เล่น) เพื่อไม่ให้ตกแมพ
            if hitPart.Position.Y > (hrp.Position.Y - 2.2) and hitPart.CanCollide then
                if _noclipPiercedParts[hitPart] == nil then
                    _noclipPiercedParts[hitPart] = hitPart.CanCollide
                end
                hitPart.CanCollide = false
            end
        end

        -- 5. CFrame Phase Glide: ผลัก CFrame ก้าวผ่านกำแพงไปข้างหน้าอย่างนิ่มนวล ไม่ติดมุมเหลี่ยม
        local speed = (State.Speed and State.SpeedValue) or hum.WalkSpeed
        local stepDistance = speed * dt * 0.75
        hrp.CFrame = hrp.CFrame + Vector3.new(horizDir.X * stepDistance, 0, horizDir.Z * stepDistance)
    end

    -- 6. คืนค่ากำแพงที่อยู่ห่างออกไปแล้ว เพื่อไม่ให้แมพพัง
    for part, origState in pairs(_noclipPiercedParts) do
        if part and part.Parent then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist > 10 then
                pcall(function() part.CanCollide = origState end)
                _noclipPiercedParts[part] = nil
            end
        else
            _noclipPiercedParts[part] = nil
        end
    end
end

if Connections.Noclip then
    pcall(function() Connections.Noclip:Disconnect() end)
    Connections.Noclip = nil
end
if Connections.NoclipRender then
    pcall(function() Connections.NoclipRender:Disconnect() end)
    Connections.NoclipRender = nil
end

Connections.Noclip = RunService.Stepped:Connect(function(time, stepDt)
    if not State.Running or not State.Noclip then return end
    ApplySmoothNoclip(stepDt)
end)

Connections.NoclipRender = RunService.RenderStepped:Connect(function()
    if not State.Running or not State.Noclip then return end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
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
--------------------------------------------------------------
-- 👁️ ระบบ ESP ผู้เล่นรวมศูนย์สมบูรณ์แบบ (UNIFIED FLICKER-FREE PLAYER ESP)
-- • รวมทุกระบบไว้ในฟังก์ชันเดียว: แยกสีสถาบัน, ตรวจอาวุธ, คำนวณระยะ, หลอดเลือด
-- • แก้บัคชื่อซ้อน 100%: ปิด OverheadNameBill เดิมของเกมขณะเปิด ESP อัตโนมัติ และคืนค่าเมื่อปิด
-- • แก้บัคกระพริบ 100%: ใช้ Instance Registry อัปเดตคุณสมบัติเดิมแบบ In-Place ไม่สร้าง/ทำลายซ้ำซ้อน
-- • ดีไซน์ Minimalist: ปราศจากไอคอน/อิโมจิรบกวนสายตา ตัวหนังสือคมชัด ไม่บดบังตัวละคร
--------------------------------------------------------------
local SchoolConfigs = {
    { Key = "ปทุมคงคา", Short = "ปทุม", Color = Color3.fromRGB(0, 195, 255) },
    { Key = "กรุงเทพช่างกล", Short = "ช่างกล", Color = Color3.fromRGB(255, 225, 60) },
    { Key = "พระ", Short = "พระ", Color = Color3.fromRGB(255, 135, 30) },
    { Key = "เด็กบ้าน", Short = "เด็กบ้าน", Color = Color3.fromRGB(245, 245, 245) },
    { Key = "ตำรวจ", Short = "ตำรวจ", Color = Color3.fromRGB(255, 45, 45) },
    { Key = "วัดสุธิวราราม", Short = "วัดสุทธิ", Color = Color3.fromRGB(50, 230, 130) },
    { Key = "วัดสุ", Short = "วัดสุทธิ", Color = Color3.fromRGB(50, 230, 130) },
    { Key = "สุธิ", Short = "วัดสุทธิ", Color = Color3.fromRGB(50, 230, 130) },
    { Key = "สุทธิ", Short = "วัดสุทธิ", Color = Color3.fromRGB(50, 230, 130) },
    { Key = "กนก", Short = "กนก", Color = Color3.fromRGB(175, 95, 240) },
    { Key = "lobby", Short = "Lobby", Color = Color3.fromRGB(190, 190, 195) },
}

local function CleanupSinglePlayerESP(p, entry)
    if not entry then return end
    if entry.Billboard then pcall(function() entry.Billboard:Destroy() end) end
    if entry.BoxBB then pcall(function() entry.BoxBB:Destroy() end) end
    if entry.HeadDotBB then pcall(function() entry.HeadDotBB:Destroy() end) end
    if entry.HealthBB then pcall(function() entry.HealthBB:Destroy() end) end
    if entry.Highlight then pcall(function() entry.Highlight:Destroy() end) end
    if entry.NativeTag and entry.NativeTag.Parent then
        pcall(function() entry.NativeTag.Enabled = true end)
    end
    Hub.PlayerESPRegistry[p] = nil
end

local function ClearAllPlayerESP()
    for p, entry in pairs(Hub.PlayerESPRegistry) do
        CleanupSinglePlayerESP(p, entry)
    end
    table.clear(Hub.PlayerESPRegistry)
    pcall(function()
        for _, c in ipairs(targetGuiParent:GetChildren()) do
            if c:IsA("BillboardGui") and (c.Name:find("KrakenESP_BB_") or c.Name:find("KrakenESP_Box_") or c.Name:find("KrakenESP_Dot_") or c.Name:find("KrakenESP_Health_")) then
                c:Destroy()
            end
            if c:IsA("Highlight") and c.Name:find("KrakenESP_HL_") then
                c:Destroy()
            end
        end
    end)
end

local function UnifiedPlayerESPUpdate()
    if not State.ESP or not State.Running then
        if next(Hub.PlayerESPRegistry) then ClearAllPlayerESP() end
        return
    end

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    local currentActive = {}

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            currentActive[p] = true
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            local isValid = char and hrp and head and hum and hum.Health > 0
            local dist = isValid and (hrp.Position - myHrp.Position).Magnitude or 999999
            local inRange = isValid and dist <= (State.ESPMaxDistance or 500)

            local entry = Hub.PlayerESPRegistry[p]

            if not inRange then
                if entry then
                    if entry.Billboard then entry.Billboard.Enabled = false end
                    if entry.BoxBB then entry.BoxBB.Enabled = false end
                    if entry.HeadDotBB then entry.HeadDotBB.Enabled = false end
                    if entry.Highlight then entry.Highlight.Enabled = false end
                    if entry.NativeTag and entry.NativeTag.Parent then
                        entry.NativeTag.Enabled = true
                    end
                end
            else
                -- 1. ซ่อน OverheadNameBill เดิมของเกมเพื่อแก้ปัญหาชื่อซ้อน 100%
                local nativeTag = head:FindFirstChild("OverheadNameBill")
                if nativeTag and nativeTag.Enabled then
                    nativeTag.Enabled = false
                end

                -- 2. สร้าง GUI ใหม่เฉพาะกรณีที่ยังไม่มี หรือตัวละคร respawn ใหม่
                if not entry or entry.Character ~= char or not entry.Billboard or not entry.Billboard.Parent or not entry.BoxBB or not entry.BoxBB.Parent or not entry.HeadDotBB or not entry.HeadDotBB.Parent or not entry.Highlight or not entry.Highlight.Parent then
                    if entry then
                        CleanupSinglePlayerESP(p, entry)
                    end

                    -- 1. Highlight (Chams ตัวแดง ขอบขาว ตามรูปภาพตัวอย่าง)
                    local hl = Instance.new("Highlight")
                    hl.Name = "KrakenESP_HL_" .. p.Name
                    hl.Adornee = char
                    hl.FillColor = Color3.fromRGB(235, 35, 35)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = targetGuiParent

                    -- 2. กรอบมุม 4 ทิศสีแดง (Corner Brackets Box)
                    local boxBB = Instance.new("BillboardGui")
                    boxBB.Name = "KrakenESP_Box_" .. p.Name
                    boxBB.Adornee = hrp
                    boxBB.Size = UDim2.new(4.5, 0, 5.7, 0)
                    boxBB.StudsOffset = Vector3.new(0, -0.1, 0)
                    boxBB.AlwaysOnTop = true
                    boxBB.ResetOnSpawn = false
                    boxBB.ClipsDescendants = false
                    boxBB.Parent = targetGuiParent

                    local boxContainer = Instance.new("Frame", boxBB)
                    boxContainer.Size = UDim2.new(1, 0, 1, 0)
                    boxContainer.BackgroundTransparency = 1
                    boxContainer.BorderSizePixel = 0

                    local boxLines = {}
                    local function addBoxLine(pX, oX, pY, oY, sX, soX, sY, soY)
                        local line = Instance.new("Frame", boxContainer)
                        line.Position = UDim2.new(pX, oX, pY, oY)
                        line.Size = UDim2.new(sX, soX, sY, soY)
                        line.BackgroundColor3 = Color3.fromRGB(240, 40, 40)
                        line.BorderSizePixel = 0
                        table.insert(boxLines, line)
                        return line
                    end

                    -- Top-Left
                    addBoxLine(0, 0, 0, 0, 0.28, 0, 0, 2)
                    addBoxLine(0, 0, 0, 0, 0, 2, 0.22, 0)
                    -- Top-Right
                    addBoxLine(0.72, 0, 0, 0, 0.28, 0, 0, 2)
                    addBoxLine(1, -2, 0, 0, 0, 2, 0.22, 0)
                    -- Bottom-Left
                    addBoxLine(0, 0, 1, -2, 0.28, 0, 0, 2)
                    addBoxLine(0, 0, 0.78, 0, 0, 2, 0.22, 0)
                    -- Bottom-Right
                    addBoxLine(0.72, 0, 1, -2, 0.28, 0, 0, 2)
                    addBoxLine(1, -2, 0.78, 0, 0, 2, 0.22, 0)

                    -- 3. จุดเล็งศีรษะสีแดง (Head Dot)
                    local dotBB = Instance.new("BillboardGui")
                    dotBB.Name = "KrakenESP_Dot_" .. p.Name
                    dotBB.Adornee = head
                    dotBB.Size = UDim2.new(0, 8, 0, 8)
                    dotBB.StudsOffset = Vector3.new(0, 0.1, 0)
                    dotBB.AlwaysOnTop = true
                    dotBB.ResetOnSpawn = false
                    dotBB.Parent = targetGuiParent

                    local dotFrame = Instance.new("Frame", dotBB)
                    dotFrame.Size = UDim2.new(1, 0, 1, 0)
                    dotFrame.BackgroundColor3 = Color3.fromRGB(240, 40, 40)
                    dotFrame.BorderSizePixel = 0
                    Instance.new("UICorner", dotFrame).CornerRadius = UDim.new(1, 0)

                    local dotStroke = Instance.new("UIStroke", dotFrame)
                    dotStroke.Color = Color3.fromRGB(20, 20, 20)
                    dotStroke.Thickness = 1

                    -- 4. ป้ายข้อมูลเหนือศีรษะ (ชื่อ, ตัวเลขเลือด, หลอดเลือดแนวนอน, ระยะ/อาวุธ)
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "KrakenESP_BB_" .. p.Name
                    bb.Adornee = head
                    bb.Size = UDim2.new(0, 130, 0, 28)
                    bb.StudsOffset = Vector3.new(0, 1.5, 0)
                    bb.AlwaysOnTop = true
                    bb.ResetOnSpawn = false
                    bb.ClipsDescendants = false
                    bb.Parent = targetGuiParent

                    local bbMain = Instance.new("Frame", bb)
                    bbMain.Size = UDim2.new(1, 0, 1, 0)
                    bbMain.BackgroundTransparency = 1
                    bbMain.BorderSizePixel = 0

                    local nameLbl = Instance.new("TextLabel", bbMain)
                    nameLbl.Size = UDim2.new(0, 86, 0, 13)
                    nameLbl.Position = UDim2.new(0, 0, 0, 0)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.TextSize = 10
                    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                    nameLbl.TextStrokeTransparency = 0.2
                    nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

                    local hpValLbl = Instance.new("TextLabel", bbMain)
                    hpValLbl.Size = UDim2.new(0, 40, 0, 13)
                    hpValLbl.Position = UDim2.new(1, -40, 0, 0)
                    hpValLbl.BackgroundTransparency = 1
                    hpValLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    hpValLbl.Font = Enum.Font.GothamBold
                    hpValLbl.TextSize = 10
                    hpValLbl.TextXAlignment = Enum.TextXAlignment.Right
                    hpValLbl.TextStrokeTransparency = 0.2
                    hpValLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

                    local hpBarBg = Instance.new("Frame", bbMain)
                    hpBarBg.Size = UDim2.new(0, 40, 0, 4)
                    hpBarBg.Position = UDim2.new(1, -40, 0, 14)
                    hpBarBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                    hpBarBg.BackgroundTransparency = 0.3
                    hpBarBg.BorderSizePixel = 0
                    Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(0, 2)

                    local hpBarFill = Instance.new("Frame", hpBarBg)
                    hpBarFill.Size = UDim2.new(1, 0, 1, 0)
                    hpBarFill.Position = UDim2.new(0, 0, 0, 0)
                    hpBarFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                    hpBarFill.BorderSizePixel = 0
                    Instance.new("UICorner", hpBarFill).CornerRadius = UDim.new(0, 2)

                    local infoLbl = Instance.new("TextLabel", bbMain)
                    infoLbl.Size = UDim2.new(0, 86, 0, 11)
                    infoLbl.Position = UDim2.new(0, 0, 0, 13)
                    infoLbl.BackgroundTransparency = 1
                    infoLbl.TextColor3 = Color3.fromRGB(210, 210, 210)
                    infoLbl.Font = Enum.Font.GothamMedium
                    infoLbl.TextSize = 9
                    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
                    infoLbl.TextStrokeTransparency = 0.3
                    infoLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    infoLbl.TextTruncate = Enum.TextTruncate.AtEnd

                    entry = {
                        Highlight = hl,
                        BoxBB = boxBB,
                        BoxLines = boxLines,
                        HeadDotBB = dotBB,
                        HeadDotFrame = dotFrame,
                        Billboard = bb,
                        NameLabel = nameLbl,
                        HpValueLabel = hpValLbl,
                        HpBarBg = hpBarBg,
                        HpBarFill = hpBarFill,
                        InfoLabel = infoLbl,
                        Player = p,
                        Character = char,
                        NativeTag = nativeTag
                    }
                    Hub.PlayerESPRegistry[p] = entry
                else
                    entry.NativeTag = nativeTag
                end

                -- 3. ตรวจจับข้อมูลสถาบันและสีประจำสถาบันตามที่แมพแบ่งไว้
                local rawTeamName = p.Team and tostring(p.Team.Name) or ""
                local teamColorObj = p.Team and p.Team.TeamColor and p.Team.TeamColor.Color or nil

                local schoolCol = teamColorObj or Color3.fromRGB(245, 245, 245)
                local schoolShort = rawTeamName ~= "" and rawTeamName or "ประชาชน"

                local matchedConfig = false
                for _, sc in ipairs(SchoolConfigs) do
                    if string.find(rawTeamName, sc.Key, 1, true) then
                        schoolCol = sc.Color
                        schoolShort = sc.Short
                        matchedConfig = true
                        break
                    end
                end

                if not matchedConfig and rawTeamName == "" then
                    if entry.CachedSchool then
                        rawTeamName = entry.CachedSchool
                        for _, sc in ipairs(SchoolConfigs) do
                            if string.find(rawTeamName, sc.Key, 1, true) then
                                schoolCol = sc.Color
                                schoolShort = sc.Short
                                matchedConfig = true
                                break
                            end
                        end
                    else
                        local ovTag = head:FindFirstChild("OverheadNameBill") or head:FindFirstChildWhichIsA("BillboardGui")
                        if ovTag then
                            for _, d in ipairs(ovTag:GetChildren()) do
                                if d:IsA("TextLabel") and d.Text and d.Text ~= "" then
                                    for _, sc in ipairs(SchoolConfigs) do
                                        if string.find(d.Text, sc.Key, 1, true) then
                                            rawTeamName = sc.Key
                                            schoolCol = sc.Color
                                            schoolShort = sc.Short
                                            matchedConfig = true
                                            break
                                        end
                                    end
                                end
                                if matchedConfig then break end
                            end
                        end
                        if not matchedConfig then
                            for _, d in ipairs(char:GetChildren()) do
                                if d:IsA("BillboardGui") then
                                    for _, lbl in ipairs(d:GetChildren()) do
                                        if lbl:IsA("TextLabel") and lbl.Text and lbl.Text ~= "" then
                                            for _, sc in ipairs(SchoolConfigs) do
                                                if string.find(lbl.Text, sc.Key, 1, true) then
                                                    rawTeamName = sc.Key
                                                    schoolCol = sc.Color
                                                    schoolShort = sc.Short
                                                    matchedConfig = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                                if matchedConfig then break end
                            end
                        end
                    end
                    if rawTeamName ~= "" then
                        entry.CachedSchool = rawTeamName
                    else
                        entry.CachedSchool = "ประชาชน"
                    end
                end

                -- 4. ตรวจจับอาวุธ
                local wepText = "มือเปล่า"
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool.Name then
                    local tName = tool.Name
                    local lower = string.lower(tName)
                    if lower ~= "fists" and lower ~= "fist" and tName ~= "หมัด" and tName ~= "มือเปล่า" then
                        wepText = tName
                    end
                end

                -- 5. คำนวณหลอดเลือด
                local curHp = math.max(0, hum.Health)
                local maxHp = math.max(1, hum.MaxHealth)
                local hpRatio = math.clamp(curHp / maxHp, 0, 1)
                local hpCol = hpRatio > 0.7 and Color3.fromRGB(46, 204, 113) or (hpRatio > 0.35 and Color3.fromRGB(243, 156, 18) or Color3.fromRGB(231, 76, 60))

                -- 6. อัปเดตข้อมูลบน GUI เดิมแบบ In-Place (ไม่กระพริบ 100%)
                local forceRed = State.ESPTacticalStyle == true
                local themeColor = forceRed and Color3.fromRGB(240, 40, 40) or schoolCol

                -- อัปเดต Highlight (Chams ตัวตามสีสถาบัน + ขอบขาวคมชัด)
                if State.ESPShowChams ~= false then
                    entry.Highlight.Enabled = true
                    entry.Highlight.FillColor = themeColor
                    entry.Highlight.FillTransparency = 0.5
                    entry.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    entry.Highlight.OutlineTransparency = 0
                else
                    entry.Highlight.Enabled = false
                end

                -- อัปเดต Corner Box ตามสีสถาบัน
                if State.ESPShowBox ~= false then
                    entry.BoxBB.Enabled = true
                    entry.BoxBB.MaxDistance = State.ESPMaxDistance or 500
                    for _, line in ipairs(entry.BoxLines) do
                        line.BackgroundColor3 = themeColor
                    end
                else
                    entry.BoxBB.Enabled = false
                end

                -- อัปเดต Head Dot ตามสีสถาบัน
                if State.ESPShowHeadDot ~= false then
                    entry.HeadDotBB.Enabled = true
                    entry.HeadDotBB.MaxDistance = State.ESPMaxDistance or 500
                    entry.HeadDotFrame.BackgroundColor3 = themeColor
                else
                    entry.HeadDotBB.Enabled = false
                end

                -- อัปเดต Billboard ข้อมูล
                entry.Billboard.Enabled = true
                entry.Billboard.MaxDistance = State.ESPMaxDistance or 500

                -- ชื่อผู้เล่น (สีตามสถาบันที่แมพแบ่งไว้)
                entry.NameLabel.TextColor3 = themeColor
                entry.NameLabel.Text = (schoolShort ~= "" and schoolShort ~= "ประชาชน") and string.format("[%s] %s", schoolShort, p.DisplayName) or p.DisplayName

                -- ตัวเลขเลือด + หลอดเลือดแนวนอน
                if State.ESPShowHealthBar ~= false then
                    entry.HpValueLabel.Visible = true
                    entry.HpValueLabel.Text = string.format("%d", math.floor(curHp))
                    entry.HpBarBg.Visible = true
                    entry.HpBarFill.Size = UDim2.new(hpRatio, 0, 1, 0)
                    entry.HpBarFill.BackgroundColor3 = hpCol
                else
                    entry.HpValueLabel.Visible = false
                    entry.HpBarBg.Visible = false
                end

                -- ข้อมูลระยะทาง & อาวุธ
                local parts = {}
                if State.ESPShowDistance then
                    table.insert(parts, string.format("%.0fm", dist * 0.28))
                end
                if State.ESPShowWeapon and wepText ~= "" and wepText ~= "มือเปล่า" then
                    table.insert(parts, wepText)
                end
                if #parts > 0 then
                    entry.InfoLabel.Text = table.concat(parts, " • ")
                    entry.InfoLabel.Visible = true
                else
                    entry.InfoLabel.Visible = false
                end
            end
        end
    end

    -- ล้างข้อมูลผู้เล่นที่ออกจากเซิร์ฟเวอร์
    for p, entry in pairs(Hub.PlayerESPRegistry) do
        if not currentActive[p] or not p.Parent then
            CleanupSinglePlayerESP(p, entry)
        end
    end
end

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        if State.ESP then
            pcall(UnifiedPlayerESPUpdate)
            task.wait(0.12)
        else
            if next(Hub.PlayerESPRegistry) then
                ClearAllPlayerESP()
            end
            task.wait(0.35)
        end
    end
end)



--------------------------------------------------------------
-- 10. ระบบความแม่นยำของปืน, ไร้แรงดีด & ปืนยิงรัวฟูลออโต้ (SAFE CLIENT-SIDE GUN MODS)
--------------------------------------------------------------
local OriginalGunSettings = {}

-- ฟังก์ชันกำจัดสคริปต์ Shake / Recoil และตัดการเชื่อมต่อ RenderStepped ของ Shake 100%
local function KillShakeConnections()
    if typeof(getconnections) ~= "function" then return end
    pcall(function()
        for _, rsEvent in ipairs({RunService.RenderStepped, RunService.Heartbeat, RunService.Stepped}) do
            for _, conn in ipairs(getconnections(rsEvent)) do
                local fn = conn.Function
                if fn then
                    local ok, src = pcall(debug.info, fn, "s")
                    if ok and src then
                        local srcLower = tostring(src):lower()
                        if srcLower:find("shake") or srcLower:find("recoil") or srcLower:find("kick") or srcLower:find("sway") or srcLower:find("fallsystem") or srcLower:find("bobbing") then
                            pcall(function() conn:Disable() end)
                            pcall(function() conn:Disconnect() end)
                        end
                    end
                end
            end
        end
    end)
end

local function KillShakeScript(tool)
    if not tool or not tool:IsA("Tool") then return end
    -- ปลอดภัย 100%: ไม่ทำลาย (:Destroy) และไม่ปิด (.Enabled = false) สคริปต์ในปืนเด็ดขาด
    -- ป้องกันเซิร์ฟเวอร์ตรวจจับความเสียหายของโมเดลปืนแล้วเตะด้วยรหัส Anti System CODE: 601
    KillShakeConnections()
end

-- ฟังก์ชันปลดล็อค Frozen / Readonly Table สำหรับ ModuleScript ของปืนทุกระบบใน Luau
local function makeWritable(tbl, seen)
    if type(tbl) ~= "table" then return end
    seen = seen or {}
    if seen[tbl] then return end
    seen[tbl] = true

    if typeof(setreadonly) == "function" then
        pcall(setreadonly, tbl, false)
    end
    if typeof(make_writeable) == "function" then
        pcall(make_writeable, tbl)
    end

    for k, v in pairs(tbl) do
        if type(v) == "table" then
            makeWritable(v, seen)
        end
    end
end

local _cachedFireInterval = 0.09

local function EnhanceGun(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        tool:SetAttribute("KrakenEnhanced", true)
        -- 1. ตัดการทำงานของ Shake LocalScript ทั้งหมดในปืน (ป้องกันการสั่นกล้องทั้งตอนถือและตอนยิง 100%)
        if State.NoRecoil and State.Running then
            KillShakeScript(tool)
        end

        -- 2. ปรับแต่งโมดูล Setting (รองรับทั้ง FE Gun Kit, ACS, CE Engine และ Custom Gun Kit)
        local settingMod = tool:FindFirstChild("Setting") 
                        or tool:FindFirstChild("Settings") 
                        or tool:FindFirstChild("Config")
                        or tool:FindFirstChild("GunSettings")
                        or tool:FindFirstChildWhichIsA("ModuleScript")
        
        if settingMod and settingMod:IsA("ModuleScript") and (settingMod.Name == "Setting" or settingMod.Name == "Settings" or settingMod.Name == "Config" or settingMod.Name == "GunSettings") then
            local s = require(settingMod)
            if type(s) == "table" then
                -- 🔓 ปลดล็อคความปลอดภัย Luau Frozen Table ป้องกันข้อผิดพลาด attempt to modify a readonly table
                makeWritable(s)

                if not OriginalGunSettings[s] then
                    OriginalGunSettings[s] = {
                        Spread = s.Spread,
                        MinSpread = s.MinSpread,
                        MaxSpread = s.MaxSpread,
                        Recoil = s.Recoil,
                        CameraRecoilingEnabled = s.CameraRecoilingEnabled,
                        ViewmodelRecoilInfluence = s.ViewmodelRecoilInfluence,
                        RecoilDamper = s.RecoilDamper,
                        RecoilSpeed = s.RecoilSpeed,
                        AngleX_Min = s.AngleX_Min,
                        AngleX_Max = s.AngleX_Max,
                        AngleY_Min = s.AngleY_Min,
                        AngleY_Max = s.AngleY_Max,
                        AngleZ_Min = s.AngleZ_Min,
                        AngleZ_Max = s.AngleZ_Max,
                        RecoilMin = s.RecoilMin,
                        RecoilMax = s.RecoilMax,
                        RecoilUp = s.RecoilUp,
                        RecoilLeft = s.RecoilLeft,
                        RecoilRight = s.RecoilRight,
                        ScopeSwaySpeed = s.ScopeSwaySpeed,
                        ScopeSwayDamper = s.ScopeSwayDamper,
                        ScopeKnockbackSpeed = s.ScopeKnockbackSpeed,
                        DropXMin = s.DropXMin,
                        DropYMax = s.DropYMax,
                        XMax = s.XMax,
                        YMax = s.YMax,
                        BulletAcceleration = s.BulletAcceleration,
                        BulletSpeed = s.BulletSpeed,
                        Auto = s.Auto,
                        Automatic = s.Automatic,
                        BurstFireEnabled = s.BurstFireEnabled,
                        HoldAndReleaseEnabled = s.HoldAndReleaseEnabled,
                        FireRate = s.FireRate,
                        RPM = s.RPM,
                        ReloadTime = s.ReloadTime,
                        TacticalReloadTime = s.TacticalReloadTime,
                        ReloadAnimationSpeed = s.ReloadAnimationSpeed,
                        DelayBeforeFiring = s.DelayBeforeFiring,
                        DelayAfterFiring = s.DelayAfterFiring,
                        CooldownTime = s.CooldownTime,
                        MaximumRate = s.MaximumRate,
                        TimeBeforeCooldown = s.TimeBeforeCooldown,
                        SelectiveFireEnabled = s.SelectiveFireEnabled,
                        FireModes = s.FireModes,
                        FireMode = s.FireMode,
                    }
                end
                local orig = OriginalGunSettings[s]

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
                        makeWritable(s.SpreadPattern)
                        for _, pt in ipairs(s.SpreadPattern) do
                            if type(pt) == "table" then
                                pt[1] = 0
                                pt[2] = 0
                            end
                        end
                    end
                    if type(s.ChargeAlterTable) == "table" and type(s.ChargeAlterTable.Spread) == "table" then
                        makeWritable(s.ChargeAlterTable)
                        s.ChargeAlterTable.Spread.Level1 = 0
                        s.ChargeAlterTable.Spread.Level2 = 0
                        s.ChargeAlterTable.Spread.Level3 = 0
                    end
                elseif orig then
                    s.Spread = orig.Spread
                    s.MinSpread = orig.MinSpread
                    s.MaxSpread = orig.MaxSpread
                end

                -- 🛑 ปืนนิ่งสนิท ไร้แรงถีบ และไร้การสั่นกล้อง 100% (Zero Recoil, Zero Sway & Zero Camera Shake)
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
                    s.RecoilMin = 0
                    s.RecoilMax = 0
                    s.RecoilUp = 0
                    s.RecoilLeft = 0
                    s.RecoilRight = 0
                    s.ScopeSwaySpeed = 0
                    s.ScopeSwayDamper = 0
                    s.ScopeKnockbackSpeed = 0
                    s.DropXMin = 0
                    s.DropYMax = 0
                    s.XMax = 0
                    s.YMax = 0
                    -- 🛑 ปิดการสั่นกล้องทุกฟิลด์ของ Gun Engine
                    s.CameraShake = false
                    s.RecoilCameraShake = false
                    s.Shake = false
                    s.ShakeFactor = 0
                    s.CameraShakeFactor = 0
                    s.ShakeIntensity = 0
                    s.CameraShakeIntensity = 0
                    s.GunRecoil = 0
                    s.CamShake = false
                    s.RecoilX = 0
                    s.RecoilY = 0
                    s.RecoilZ = 0
                    s.Kickback = 0
                    s.KickbackSpeed = 0
                    s.CameraRecoil = 0
                    s.RecoilStrength = 0
                    s.Sway = 0
                    s.AimSway = 0
                    s.Bob = 0
                    s.CameraShakePreset = nil
                    s.RecoilShake = nil
                    if type(s.ChargeAlterTable) == "table" and type(s.ChargeAlterTable.Recoil) == "table" then
                        makeWritable(s.ChargeAlterTable)
                        s.ChargeAlterTable.Recoil.Level1 = 0
                        s.ChargeAlterTable.Recoil.Level2 = 0
                        s.ChargeAlterTable.Recoil.Level3 = 0
                    end
                elseif orig then
                    s.Recoil = orig.Recoil
                    s.CameraRecoilingEnabled = orig.CameraRecoilingEnabled
                    s.ViewmodelRecoilInfluence = orig.ViewmodelRecoilInfluence
                    s.RecoilDamper = orig.RecoilDamper
                    s.RecoilSpeed = orig.RecoilSpeed
                    s.AngleX_Min = orig.AngleX_Min
                    s.AngleX_Max = orig.AngleX_Max
                    s.AngleY_Min = orig.AngleY_Min
                    s.AngleY_Max = orig.AngleY_Max
                    s.AngleZ_Min = orig.AngleZ_Min
                    s.AngleZ_Max = orig.AngleZ_Max
                    s.RecoilMin = orig.RecoilMin
                    s.RecoilMax = orig.RecoilMax
                    s.RecoilUp = orig.RecoilUp
                    s.RecoilLeft = orig.RecoilLeft
                    s.RecoilRight = orig.RecoilRight
                    s.ScopeSwaySpeed = orig.ScopeSwaySpeed
                    s.ScopeSwayDamper = orig.ScopeSwayDamper
                    s.ScopeKnockbackSpeed = orig.ScopeKnockbackSpeed
                    s.DropXMin = orig.DropXMin
                    s.DropYMax = orig.DropYMax
                    s.XMax = orig.XMax
                    s.YMax = orig.YMax
                end

                -- ⚡ กระสุนพุ่งตรง ไม่ย้อยตามแรงโน้มถ่วง (No Bullet Drop)
                if (State.FastBullet or State.SilentAim) and State.Running then
                    s.BulletAcceleration = Vector3.zero
                    if type(s.ChargeAlterTable) == "table" and type(s.ChargeAlterTable.BulletAcceleration) == "table" then
                        makeWritable(s.ChargeAlterTable)
                        s.ChargeAlterTable.BulletAcceleration.Level1 = Vector3.zero
                        s.ChargeAlterTable.BulletAcceleration.Level2 = Vector3.zero
                        s.ChargeAlterTable.BulletAcceleration.Level3 = Vector3.zero
                    end
                    if (s.BulletSpeed or 0) < 4000 then
                        s.BulletSpeed = 5000
                    end
                elseif orig then
                    s.BulletAcceleration = orig.BulletAcceleration
                    s.BulletSpeed = orig.BulletSpeed
                end

                -- 🔥 ปืนทุกชนิดยิงรัวออโต้ระดับ Glock Switch ของเซิร์ฟเวอร์ (ป้องกัน CODE: 46)
                if State.FullAuto and State.Running then
                    s.Auto = true
                    s.Automatic = true
                    s.BurstFireEnabled = false
                    s.HoldAndReleaseEnabled = false
                    s.SelectiveFireEnabled = false
                    s.ShotgunPump = false
                    s.ChargedShotAdvanceEnabled = false
                    s.MinigunEnabled = false
                    s.FireMode = "Auto"
                    if type(s.FireModes) == "table" then
                        makeWritable(s.FireModes)
                        for i = 1, #s.FireModes do
                            s.FireModes[i] = true
                        end
                    else
                        s.FireModes = {true, true, true}
                    end

                    -- ปรับ FireRate ให้ตรงกับสเปก Glock Switch ของเซิร์ฟเวอร์ (0.125s = ~480 RPM)
                    -- ล็อคขั้นต่ำ 0.120s ไม่เร่งจนเซิร์ฟเวอร์ตรวจจับ Rapid Fire (Bypass CODE: 46)
                    local safeSwitchRate = math.clamp(State.GlockSwitchFireRate or 0.125, 0.120, 0.200)
                    s.FireRate = safeSwitchRate
                    s.RPM = math.floor(60 / safeSwitchRate)
                    _cachedFireInterval = safeSwitchRate

                    if orig then
                        s.CooldownTime = (type(orig.CooldownTime) == "number" and orig.CooldownTime > 0 and orig.CooldownTime) or 0.04
                        s.DelayBeforeFiring = orig.DelayBeforeFiring or 0
                        s.DelayAfterFiring = orig.DelayAfterFiring or 0
                        s.MaximumRate = math.floor(60 / safeSwitchRate)
                    else
                        s.CooldownTime = 0.04
                        s.DelayBeforeFiring = 0
                        s.DelayAfterFiring = 0
                        s.MaximumRate = 480
                    end
                elseif orig then
                    s.Auto = orig.Auto
                    s.Automatic = orig.Automatic
                    s.BurstFireEnabled = orig.BurstFireEnabled
                    s.HoldAndReleaseEnabled = orig.HoldAndReleaseEnabled
                    s.FireRate = orig.FireRate
                    s.RPM = orig.RPM
                    s.DelayBeforeFiring = orig.DelayBeforeFiring
                    s.DelayAfterFiring = orig.DelayAfterFiring
                    s.CooldownTime = orig.CooldownTime
                    s.SelectiveFireEnabled = orig.SelectiveFireEnabled
                    s.FireModes = orig.FireModes
                    s.FireMode = orig.FireMode
                    _cachedFireInterval = (type(s.FireRate) == "number" and s.FireRate) or 0.125
                end

                -- ⚡ จัดการการรีโหลดกระสุนอย่างปลอดภัย (ป้องกันการโดนแบน CODE: 59)
                -- เร่งความเร็วการรีโหลดอย่างปลอดภัย 20-25% พร้อมล็อคเวลาขั้นต่ำ 1.35s ป้องกันแอนตี้ชีตตรวจจับ
                if orig then
                    if State.FastReload and State.Running then
                        local ratio = math.clamp(State.FastReloadRatio or 0.8, 0.70, 0.95)
                        local minClamp = State.MinReloadClamp or 1.35
                        if orig.ReloadTime then
                            s.ReloadTime = math.max(minClamp, orig.ReloadTime * ratio)
                        end
                        if orig.TacticalReloadTime then
                            s.TacticalReloadTime = math.max(minClamp * 0.85, orig.TacticalReloadTime * ratio)
                        end
                        s.ReloadAnimationSpeed = (orig.ReloadAnimationSpeed or 1) * (1 / ratio)
                        if orig.TacticalReloadAnimationSpeed then
                            s.TacticalReloadAnimationSpeed = (orig.TacticalReloadAnimationSpeed or 1) * (1 / ratio)
                        end
                    else
                        s.ReloadTime = orig.ReloadTime
                        s.TacticalReloadTime = orig.TacticalReloadTime
                        s.ReloadAnimationSpeed = orig.ReloadAnimationSpeed
                        if orig.TacticalReloadAnimationSpeed then
                            s.TacticalReloadAnimationSpeed = orig.TacticalReloadAnimationSpeed
                        end
                    end
                end
            end
        end

        -- ปรับแต่งสภาพแวดล้อม GunScript_Local โดยตรง (ป้องกันกรณีที่สคริปต์ก็อปปี้ค่า Setting ไปไว้ใน local environment แล้ว)
        local gunScript = tool:FindFirstChild("GunScript_Local") or tool:FindFirstChildWhichIsA("LocalScript")
        if gunScript and typeof(getsenv) == "function" then
            pcall(function()
                local env = getsenv(gunScript)
                if env then
                    for _, v in pairs(env) do
                        if type(v) == "table" then
                            makeWritable(v)
                            if State.NoRecoil and State.Running then
                                if rawget(v, "CameraRecoilingEnabled") ~= nil then v.CameraRecoilingEnabled = false end
                                if rawget(v, "Recoil") ~= nil then v.Recoil = 0 end
                                if rawget(v, "ViewmodelRecoilInfluence") ~= nil then v.ViewmodelRecoilInfluence = 0 end
                            end
                            if State.FullAuto and State.Running then
                                local safeSwitchRate = math.clamp(State.GlockSwitchFireRate or 0.125, 0.120, 0.200)
                                if rawget(v, "Auto") ~= nil then v.Auto = true end
                                if rawget(v, "Automatic") ~= nil then v.Automatic = true end
                                if rawget(v, "SelectiveFireEnabled") ~= nil then v.SelectiveFireEnabled = false end
                                if rawget(v, "BurstFireEnabled") ~= nil then v.BurstFireEnabled = false end
                                if rawget(v, "FireRate") ~= nil then v.FireRate = safeSwitchRate end
                                if rawget(v, "RPM") ~= nil then v.RPM = math.floor(60 / safeSwitchRate) end
                            else
                                if orig then
                                    if rawget(v, "Auto") ~= nil then v.Auto = orig.Auto end
                                    if rawget(v, "Automatic") ~= nil then v.Automatic = orig.Automatic end
                                    if rawget(v, "FireRate") ~= nil then v.FireRate = orig.FireRate end
                                    if rawget(v, "RPM") ~= nil then v.RPM = orig.RPM end
                                end
                            end
                            -- รีโหลดกระสุนไวปลอดภัยในระดับ Script Environment (ล็อคความปลอดภัยขั้นต่ำ 1.35 วิ ป้องกัน CODE: 59)
                            if State.FastReload and State.Running then
                                local ratio = math.clamp(State.FastReloadRatio or 0.8, 0.70, 0.95)
                                local minClamp = State.MinReloadClamp or 1.35
                                if orig and orig.ReloadTime and rawget(v, "ReloadTime") ~= nil then
                                    v.ReloadTime = math.max(minClamp, orig.ReloadTime * ratio)
                                end
                                if orig and orig.TacticalReloadTime and rawget(v, "TacticalReloadTime") ~= nil then
                                    v.TacticalReloadTime = math.max(minClamp * 0.85, orig.TacticalReloadTime * ratio)
                                end
                            else
                                if orig then
                                    if rawget(v, "ReloadTime") ~= nil then v.ReloadTime = orig.ReloadTime end
                                    if rawget(v, "TacticalReloadTime") ~= nil then v.TacticalReloadTime = orig.TacticalReloadTime end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- ==============================================================
-- 🛡️ ระบบกำจัดแรงสั่นกล้องระดับแกนเกม (CAMERA SHAKE & RECOIL ELIMINATOR 100%)
-- ป้องกันจอเขย่า จอสั่น มุมกล้องโยก ทั้งตอนถือปืน ยิงปืน วิ่ง กระโดด และตกจากที่สูง
-- ==============================================================

-- 1. ฟังก์ชันกำจัด FakeCamera ในโมเดลปืนและ Viewmodel (ป้องกันแอนิเมชันปืนโยกกล้อง)
local function NeutralizeFakeCamera()
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            local arms = cam:FindFirstChild("Arms")
            if arms then
                for _, desc in ipairs(arms:GetDescendants()) do
                    if desc.Name == "FakeCamera" and desc:IsA("Motor6D") then
                        desc.Transform = CFrame.identity
                    end
                end
            end
        end
    end)
end

local _hasPatchedModules = false
local _hasNeutralizedGC = false

-- แพทช์โมดูล CameraShaker / EZCameraShake ใน ReplicatedStorage (รันเพียง 1 ครั้ง ไม่กิน CPU)
local function NeutralizeGlobalModules()
    if _hasPatchedModules then return end
    _hasPatchedModules = true
    pcall(function()
        local function patchShakerModule(mod)
            local ok, s = pcall(require, mod)
            if ok and type(s) == "table" then
                makeWritable(s)
                if s.Shake then s.Shake = function() end end
                if s.ShakeOnce then s.ShakeOnce = function() end end
                if s.ShakeAll then s.ShakeAll = function() end end
                if s.Start then s.Start = function() end end
                if s.Update then s.Update = function() return CFrame.identity end end
                if s.Presets then
                    makeWritable(s.Presets)
                    for _, p in pairs(s.Presets) do
                        if type(p) == "table" then
                            makeWritable(p)
                            p.Magnitude = 0; p.Roughness = 0
                            p.FadeInTime = 0; p.FadeOutTime = 0
                        end
                    end
                end
                if s.new then
                    local oldNew = s.new
                    s.new = function(...)
                        local inst = oldNew(...)
                        if type(inst) == "table" then
                            makeWritable(inst)
                            inst.Shake = function() end
                            inst.ShakeOnce = function() end
                            inst.Start = function() end
                            inst.Update = function() return CFrame.identity end
                            inst._shakeInstances = {}
                        end
                        return inst
                    end
                end
            end
        end

        for _, m in ipairs(ReplicatedStorage:GetDescendants()) do
            if m:IsA("ModuleScript") then
                local mName = m.Name:lower()
                if mName:find("shake") or mName:find("recoil") or mName:find("spring") then
                    patchShakerModule(m)
                end
            end
        end
    end)
end

-- สแกน GC ล้างและบล็อกอ็อบเจกต์ Spring และ CameraShaker (รันเพียง 1 ครั้ง ไม่วนซ้ำ ป้องกันเฟรมกระชาก)
local function NeutralizeGCSprings()
    if _hasNeutralizedGC then return end
    _hasNeutralizedGC = true
    pcall(function()
        if typeof(getgc) == "function" then
            for _, obj in ipairs(getgc(true)) do
                if type(obj) == "table" then
                    if rawget(obj, "Shake") and rawget(obj, "ShakeOnce") then
                        makeWritable(obj)
                        obj.Shake = function() end
                        obj.ShakeOnce = function() end
                        if rawget(obj, "_shakeInstances") then obj._shakeInstances = {} end
                    end
                    if rawget(obj, "shove") then
                        makeWritable(obj)
                        obj.shove = function() end
                        if rawget(obj, "pos") then obj.pos = Vector3.zero end
                        if rawget(obj, "vel") then obj.vel = Vector3.zero end
                        if rawget(obj, "target") then obj.target = Vector3.zero end
                    end
                    -- Spring object (FE Gun Kit and ViewmodelScript: p, v, d, s fields)
                    if rawget(obj, "p") and rawget(obj, "v") and rawget(obj, "d") and rawget(obj, "s") then
                        makeWritable(obj)
                        if typeof(obj.p) == "Vector3" then
                            obj.p = Vector3.zero; obj.v = Vector3.zero; obj.t = Vector3.zero
                        elseif typeof(obj.p) == "number" then
                            obj.p = 0; obj.v = 0; obj.t = 0
                        end
                        if rawget(obj, "accelerate") then obj.accelerate = function() end end
                        if rawget(obj, "shove") then obj.shove = function() end end
                    end
                end
            end
        end
    end)
end

local function NeutralizeAllShakeAndSprings()
    if not State.Running or not State.NoRecoil then return end

    -- 1. ถอด RenderStep Shaker & Recoil ทุกตัว (one-shot เมื่อถือปืน/เปิดฟังชั่น)
    pcall(function() RunService:UnbindFromRenderStep("CameraShaker") end)
    pcall(function() RunService:UnbindFromRenderStep("CameraShake") end)
    pcall(function() RunService:UnbindFromRenderStep("Recoil") end)
    pcall(function() RunService:UnbindFromRenderStep("GunRecoil") end)
    pcall(function() RunService:UnbindFromRenderStep("WeaponRecoil") end)
    pcall(function() RunService:UnbindFromRenderStep("RecoilCam") end)
    pcall(function() RunService:UnbindFromRenderStep("RecoilCamera") end)
    pcall(function() RunService:UnbindFromRenderStep("MeleeRecoil") end)

    -- 2. ตัดการเชื่อมต่อของ Shake script ใน RenderStepped / Heartbeat
    KillShakeConnections()
    NeutralizeFakeCamera()

    -- 3. แพทช์โมดูล ReplicatedStorage ครั้งเดียว
    NeutralizeGlobalModules()

    -- 4. สแกน GC ครั้งเดียว
    NeutralizeGCSprings()

    -- 5. ตัด recoilViewmodel event และ Melee ScreenshakeEvent
    pcall(function()
        if typeof(getconnections) ~= "function" then return end
        local rs = game:GetService("ReplicatedStorage")
        local evFolder = rs:FindFirstChild("Events")
        if evFolder then
            local recoilEv = evFolder:FindFirstChild("recoilViewmodel")
                or evFolder:FindFirstChild("RecoilViewmodel")
                or evFolder:FindFirstChild("recoil")
            if recoilEv and recoilEv:IsA("BindableEvent") then
                for _, c in ipairs(getconnections(recoilEv.Event)) do
                    pcall(function() c:Disable() end)
                    pcall(function() c:Disconnect() end)
                end
            end
        end

        local feMelee = rs:FindFirstChild("FEMeleeKitVisualiseEvents")
        local ssEv = feMelee and feMelee:FindFirstChild("ScreenshakeEvent")
        if ssEv and ssEv:IsA("RemoteEvent") then
            for _, c in ipairs(getconnections(ssEv.OnClientEvent)) do
                pcall(function() c:Disable() end)
                pcall(function() c:Disconnect() end)
            end
        end

        -- ล้าง RenderStepped ของ ViewmodelScript เพื่อ zero spring p/v
        for _, conn in ipairs(getconnections(RunService.RenderStepped)) do
            local fn = conn.Function
            if fn then
                local ok2, src = pcall(debug.info, fn, "s")
                if ok2 and tostring(src):lower():find("viewmodel") then
                    for uvIdx = 1, 35 do
                        local ok3, uvName, uvVal = pcall(debug.getupvalue, fn, uvIdx)
                        if not ok3 or not uvName then break end
                        if type(uvVal) == "table" then
                            makeWritable(uvVal)
                            if rawget(uvVal, "p") and typeof(uvVal.p) == "Vector3" then
                                uvVal.p = Vector3.zero
                                uvVal.v = Vector3.zero
                                if rawget(uvVal, "t") then uvVal.t = Vector3.zero end
                                if rawget(uvVal, "accelerate") then uvVal.accelerate = function() end end
                                if rawget(uvVal, "shove") then uvVal.shove = function() end end
                            end
                        elseif type(uvVal) == "number" and uvName == "v23" then
                            pcall(debug.setupvalue, fn, uvIdx, 0)
                        end
                    end
                end
            end
        end
    end)
end

-- ล้างการสั่นมุมกล้องใน RenderStepped ทุกเฟรม (แบบเบาเครื่อง 0% Overhead ไม่มี getgc / ไม่มี loop getconnections)
if Connections.NoRecoilCameraHook then
    pcall(function() Connections.NoRecoilCameraHook:Disconnect() end)
end
Connections.NoRecoilCameraHook = RunService.RenderStepped:Connect(function()
    if not State.Running or not State.NoRecoil then return end

    local char = LocalPlayer.Character
    if not char then return end

    -- รีเซ็ต CameraOffset ให้เป็น 0 ตลอดเวลา ป้องกันการโยกหัวของ RunSystem / FallSystem
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.CameraOffset ~= Vector3.zero then
        hum.CameraOffset = Vector3.zero
    end

    local cam = Workspace.CurrentCamera
    if cam then
        -- ล้าง Roll (Z rotation) ป้องกันการเอียง/ส่ายกล้องเวลาถือปืนและยิง
        local rx, ry, rz = cam.CFrame:ToEulerAnglesYXZ()
        if math.abs(rz) > 0.0001 then
            cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.fromEulerAnglesYXZ(rx, ry, 0)
        end
    end
end)

-- ==============================================================
-- 🔥 ระบบยิงฟูลออโต้ระดับแกนลึก (CROSS-PLATFORM SAFE FULL AUTO: PC & MOBILE)
-- คอม: กดคลิกซ้ายค้าง ยิงต่อเนื่อง ปล่อยคลิก หยุดทันที
-- มือถือ: กดแตะปุ่มยิง (FireButton / Att) ค้าง ยิงต่อเนื่อง ยกนิ้ว หยุดทันที
-- ==============================================================
local _isHoldingFire = false
local _lastAutoFireTime = 0
local _fireTargetTool = nil

-- ฟังก์ชันกระตุ้นการยิงระดับ Native (ป้องกันการยิงเบิ้ล 2 นัดซ้อน สาเหตุของ CODE: 46)
local function TriggerGunShot(tool)
    -- ป้องกันการยิงปืนที่ไม่ได้ถืออยู่ในมือเด็ดขาด (ป้องกัน CODE: 601 เมื่อเก็บปืนหรือถอดปืนเข้ากระเป๋า/ตู้เซฟ)
    local char = LocalPlayer.Character
    if not char or not tool or not tool:IsA("Tool") or tool.Parent ~= char then
        _isHoldingFire = false
        _fireTargetTool = nil
        return
    end

    local fired = false
    -- 1. ยิงผ่าน mouse.Button1Down สำหรับปืนระบบ FE Gun Kit บนคอม
    local mouse = LocalPlayer:GetMouse()
    if mouse and typeof(getconnections) == "function" then
        local b1Conns = getconnections(mouse.Button1Down)
        if #b1Conns > 0 then
            for _, conn in ipairs(b1Conns) do
                pcall(function()
                    if typeof(firesignal) == "function" then
                        firesignal(conn)
                        fired = true
                    elseif conn.Fire then
                        conn:Fire()
                        fired = true
                    end
                end)
            end
        end
    end

    -- 2. ยิงผ่านปุ่ม FireButton ใน GunGUI สำหรับมือถือ
    if not fired then
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        if pgui then
            local gunGui = pgui:FindFirstChild("GunGUI")
            local fireBtn = gunGui and gunGui:FindFirstChild("MobileButtons") and gunGui.MobileButtons:FindFirstChild("FireButton")
            if fireBtn and typeof(getconnections) == "function" then
                for _, conn in ipairs(getconnections(fireBtn.MouseButton1Down)) do
                    pcall(function()
                        if typeof(firesignal) == "function" then
                            firesignal(conn)
                            fired = true
                        elseif conn.Fire then
                            conn:Fire()
                            fired = true
                        end
                    end)
                end
            end
        end
    end

    -- 3. Fallback เฉพาะ Tool ทั่วไปที่ไม่ได้เชื่อมโยงกับ Button1Down (เช่น หมัด/มีด)
    -- ห้ามเรียกคู่กับ Button1Down เด็ดขาดเพื่อป้องกันการยิงเบิ้ล 2 นัดในเวลาเดียวกัน (ป้องกัน CODE: 46)
    if not fired and tool.Parent == char then
        pcall(function() tool:Activate() end)
    end
end

-- ==============================================================
-- ⚡ ระบบรีโหลดกระสุนอัตโนมัติและรีโหลดไว (FAST RELOAD & AUTO RELOAD)
-- ==============================================================
local _lastAutoReloadTick = 0

local function TriggerGunReload(tool)
    local now = os.clock()
    local reloadCooldown = 1.5
    if State.FastReload then
        reloadCooldown = math.max(State.MinReloadClamp or 1.35, 1.5 * (State.FastReloadRatio or 0.8))
    end
    if now - _lastAutoReloadTick < reloadCooldown then return end
    _lastAutoReloadTick = now

    -- กดปุ่ม R อย่างสมจริงและปลอดภัยผ่าน VirtualInputManager (พฤติกรรมเหมือนคนกดมือ 100%)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if vim and typeof(vim.SendKeyEvent) == "function" then
            vim:SendKeyEvent(true, Enum.KeyCode.R, false, game)
            task.wait(0.04)
            vim:SendKeyEvent(false, Enum.KeyCode.R, false, game)
        else
            -- ทางเลือกสำหรับ Mobile / GunGUI Button
            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
            local gunGui = pgui and pgui:FindFirstChild("GunGUI")
            local mBtns = gunGui and gunGui:FindFirstChild("MobileButtons")
            local relBtn = mBtns and (mBtns:FindFirstChild("ReloadButton") or mBtns:FindFirstChild("Reload"))
            if relBtn and typeof(firesignal) == "function" then
                firesignal(relBtn.MouseButton1Click)
            end
        end
    end)
end

local function CheckGunAmmoAndAutoReload(tool)
    if not State.Running or not State.AutoReload then return end
    local char = LocalPlayer.Character
    if not char then return end
    tool = tool or char:FindFirstChildOfClass("Tool")
    if not tool or tool.Parent ~= char then return end

    local isGun = tool:FindFirstChild("Setting") 
               or tool:FindFirstChild("Settings") 
               or tool:FindFirstChild("Config") 
               or tool:FindFirstChild("GunSettings")
               or tool:FindFirstChild("GunScript_Local")
    if not isGun then return end

    local needsReload = false

    -- วิธีที่ 1: ตรวจสอบจาก GunGUI Current Label โดยตรง (O(1) Direct Lookup ไม่สแกนลูกหลาน)
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local curLabel = pgui and pgui:FindFirstChild("GunGUI") and pgui.GunGUI:FindFirstChild("Frame") and pgui.GunGUI.Frame:FindFirstChild("Mag") and pgui.GunGUI.Frame.Mag:FindFirstChild("Current")
    if curLabel and curLabel:IsA("TextLabel") then
        local txt = curLabel.Text
        if txt == "0" or txt:match("^0%s*/") or txt:match("^0%s*|") then
            needsReload = true
        end
    end

    -- วิธีที่ 2: ตรวจสอบจาก IntValue ในโมเดลปืน (Ammo <= 0)
    if not needsReload then
        local ammoObj = tool:FindFirstChild("Ammo") or tool:FindFirstChild("CurrentAmmo") or tool:FindFirstChild("Clip")
        if ammoObj and (ammoObj:IsA("IntValue") or ammoObj:IsA("NumberValue")) then
            if ammoObj.Value <= 0 then
                needsReload = true
            end
        end
    end

    -- วิธีที่ 3: ตรวจสอบจาก getsenv ของ GunScript_Local
    if not needsReload then
        local gunScript = tool:FindFirstChild("GunScript_Local") or tool:FindFirstChildWhichIsA("LocalScript")
        if gunScript and typeof(getsenv) == "function" then
            local ok, env = pcall(getsenv, gunScript)
            if ok and type(env) == "table" and type(env.Ammo) == "number" then
                if env.Ammo <= 0 then
                    needsReload = true
                end
            end
        end
    end

    if needsReload then
        TriggerGunReload(tool)
    end
end

-- ฟังก์ชันเชื่อมต่อปุ่มยิงบนจอมือถือ (GunGUI Mobile Buttons & MobileGUI Att Button)
local function HookMobileFireButton()
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        if not pgui then return end

        local function attachToFireBtn(btn, isAttFallback)
            if not btn or not (btn:IsA("ImageButton") or btn:IsA("TextButton")) then return end
            if btn:GetAttribute("KrakenFullAutoHooked") then return end
            btn:SetAttribute("KrakenFullAutoHooked", true)

            btn.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    local char = LocalPlayer.Character
                    local tool = char and char:FindFirstChildOfClass("Tool")
                    if tool then
                        _isHoldingFire = true
                        _fireTargetTool = tool
                        _lastAutoFireTime = os.clock()

                        -- นัดแรกยิงออกทันทีเมื่อแตะปุ่ม (Instant 0ms First Shot)
                        TriggerGunShot(tool)
                    end
                end
            end)

            btn.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    _isHoldingFire = false
                    _fireTargetTool = nil

                    pcall(function()
                        if typeof(firesignal) == "function" then
                            firesignal(btn.MouseButton1Up)
                        end
                    end)

                    if isAttFallback then
                        local gGui = pgui:FindFirstChild("GunGUI")
                        local fBtn = gGui and gGui:FindFirstChild("MobileButtons") and gGui.MobileButtons:FindFirstChild("FireButton")
                        if fBtn and typeof(firesignal) == "function" then
                            pcall(function() firesignal(fBtn.MouseButton1Up) end)
                        end
                    end
                end
            end)
        end

        -- 1. เชื่อมต่อปุ่ม FireButton ใน GunGUI (ปุ่มยิงมาตรฐานของปืน FE Gun Kit บนมือถือ)
        local gunGui = pgui:FindFirstChild("GunGUI")
        if gunGui then
            local mobileBtns = gunGui:FindFirstChild("MobileButtons")
            if mobileBtns then
                local fireBtn = mobileBtns:FindFirstChild("FireButton")
                if fireBtn then
                    attachToFireBtn(fireBtn, false)
                end
            end
        end

        -- 2. เชื่อมต่อปุ่ม Att ใน MobileGUI (ปุ่มโจมตีของเกมบนมือถือ)
        local mobileGui = pgui:FindFirstChild("MobileGUI")
        if mobileGui then
            local mBtns = mobileGui:FindFirstChild("MobileButtons")
            if mBtns then
                local attBtn = mBtns:FindFirstChild("Att")
                if attBtn then
                    attachToFireBtn(attBtn, true)
                end
            end
        end

        -- 3. สแกนหาปุ่มยิงอื่นๆ ใน ScreenGui อื่นๆ
        for _, gui in ipairs(pgui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                local gName = gui.Name:lower()
                if gName:find("gun") or gName:find("weapon") or gName:find("touch") or gName:find("fist") then
                    for _, btn in ipairs(gui:GetDescendants()) do
                        if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and btn.Visible then
                            local bName = btn.Name:lower()
                            if bName == "firebutton" or bName == "shootbutton" or bName == "mobilefire" then
                                attachToFireBtn(btn, false)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ดักจับการคลิกซ้ายบนคอม (PC: Left Click Hold to Shoot)
if Connections.FullAutoInputBegan then
    pcall(function() Connections.FullAutoInputBegan:Disconnect() end)
end
if Connections.FullAutoInputEnded then
    pcall(function() Connections.FullAutoInputEnded:Disconnect() end)
end
if Connections.FullAutoLoop then
    pcall(function() Connections.FullAutoLoop:Disconnect() end)
end

Connections.FullAutoInputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not State.Running or not State.FullAuto then return end
    -- ไม่ยิงเฉพาะเมื่อกำลังพิมพ์ข้อความในช่องแชทหรือพิมพ์ใน TextBox เท่านั้น
    if UserInputService:GetFocusedTextBox() then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            _isHoldingFire = true
            _fireTargetTool = tool
            _lastAutoFireTime = os.clock()

            -- ตรวจสอบและรีโหลดอัตโนมัติหากกระสุนหมด
            if State.AutoReload then
                CheckGunAmmoAndAutoReload(tool)
            end

            -- สำหรับอาวุธที่ไม่มี GunScript_Local (เช่น มีด/หมัด/Tool ทั่วไป) ให้กระตุ้นการยิงนัดแรก
            local hasFEGun = tool:FindFirstChild("GunScript_Local") or tool:FindFirstChildWhichIsA("LocalScript")
            if not hasFEGun then
                TriggerGunShot(tool)
            end
            -- สำหรับปืน FE Gun Kit บนคอม: Roblox ส่งคลิกซ้ายให้ GunScript_Local อัตโนมัติอยู่แล้ว
            -- และ GunScript_Local จะยิงออโต้ตาม FireRate (0.125s) ของ Glock Switch อย่างสมบูรณ์ ไม่ยิงซ้อน
        end
    end
end)

Connections.FullAutoInputEnded = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _isHoldingFire = false
        _fireTargetTool = nil

        -- ส่งสัญญาณ Button1Up เพื่อให้ GunScript_Local รู้ว่าหยุดคลิกแล้ว
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            if mouse and typeof(getconnections) == "function" then
                for _, conn in ipairs(getconnections(mouse.Button1Up)) do
                    pcall(function()
                        if typeof(firesignal) == "function" then
                            firesignal(conn)
                        elseif conn.Fire then
                            conn:Fire()
                        end
                    end)
                end
            end
        end)
    end
end)

-- ลูป Heartbeat ยิงต่อเนื่องขณะกดค้าง (จัดการ AutoReload และยิงต่อเนื่องแบบไม่ยิงซ้ำซ้อน)
Connections.FullAutoLoop = RunService.Heartbeat:Connect(function()
    if not State.Running or not State.FullAuto or not _isHoldingFire then return end
    local char = LocalPlayer.Character
    if not char then
        _isHoldingFire = false
        _fireTargetTool = nil
        return
    end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or tool ~= _fireTargetTool or tool.Parent ~= char then
        _isHoldingFire = false
        _fireTargetTool = nil
        return
    end

    -- ตรวจสอบและรีโหลดอัตโนมัติขณะยิงค้าง
    if State.AutoReload then
        CheckGunAmmoAndAutoReload(tool)
    end

    -- ปืน FE Gun Kit จะยิงออโต้ระดับ Glock Switch (0.125s) ผ่าน GunScript_Local เองอย่างเสถียร
    -- รันลูปกระตุ้นเฉพาะกรณีที่ Tool ไม่มี GunScript_Local เท่านั้น เพื่อป้องกัน CODE: 46
    local hasFEGun = tool:FindFirstChild("GunScript_Local") or tool:FindFirstChildWhichIsA("LocalScript")
    if not hasFEGun then
        local now = os.clock()
        local interval = math.clamp(State.GlockSwitchFireRate or 0.125, 0.120, 0.200)
        if now - _lastAutoFireTime >= interval then
            _lastAutoFireTime = now
            TriggerGunShot(tool)
        end
    end
end)

local function ApplyGunMods()
    if not State.Running then return end
    pcall(function()
        if State.NoRecoil then
            NeutralizeAllShakeAndSprings()
        end
        HookMobileFireButton()

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
        if Connections.CharGunRemovedHook then Connections.CharGunRemovedHook:Disconnect() end

        local char = LocalPlayer.Character
        if char then
            local function bindToolUnequip(tool)
                if not tool or not tool:IsA("Tool") then return end
                tool.Unequipped:Connect(function()
                    _isHoldingFire = false
                    _fireTargetTool = nil
                end)
            end

            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") then
                    bindToolUnequip(item)
                end
            end

            Connections.CharGunHook = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    bindToolUnequip(child)
                    EnhanceGun(child)
                    task.wait(0.05)
                    ApplyGunMods()
                end
            end)

            -- ดักจับเมื่อเก็บปืนออกจากตัว (ถอดเข้า Backpack หรือฝากเข้า SafeUI) หยุดยิงทันที
            Connections.CharGunRemovedHook = char.ChildRemoved:Connect(function(child)
                if child:IsA("Tool") then
                    _isHoldingFire = false
                    _fireTargetTool = nil
                end
            end)
        end

        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            Connections.BpGunHook = bp.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    EnhanceGun(child)
                end
            end)
        end
    end)
end

-- ดักจับเมื่อ GunGUI ปรากฏขึ้นใน PlayerGui (เมื่อผู้เล่นมือถือหยิบปืน)
if Connections.GunGuiAddedHook then
    pcall(function() Connections.GunGuiAddedHook:Disconnect() end)
end
pcall(function()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        Connections.GunGuiAddedHook = pgui.ChildAdded:Connect(function(child)
            if child.Name == "GunGUI" or child.Name:find("Gun") or child.Name:find("Mobile") then
                task.wait(0.05)
                HookMobileFireButton()
            end
        end)
    end
end)

HookInventoryForGuns()
Connections.CharAddedGunHook = LocalPlayer.CharacterAdded:Connect(function()
    _hasNeutralizedGC = false
    task.wait(1)
    HookInventoryForGuns()
    ApplyGunMods()
end)

-- เฝ้าดูปืนที่ถืออยู่ (ความถี่ 1.5s ตรวจสอบเฉพาะปืนใหม่ที่ยังไม่ถูก Enhance เพื่อรักษา 60+ FPS)
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(1.5)
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool and not tool:GetAttribute("KrakenEnhanced") then
            pcall(EnhanceGun, tool)
        end
    end
end)

--------------------------------------------------------------
-- 10.1 HEAD HITBOX EXPANDER (ขยายเป้าหัวศัตรู / AUTO HEADSHOT)
--------------------------------------------------------------
local OriginalHeadSizes = {}

local function ApplyHitboxToCharacter(char)
    if not char or char == LocalPlayer.Character then return end
    pcall(function()
        local head = char:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            if not OriginalHeadSizes[head] then
                OriginalHeadSizes[head] = {
                    Size = head.Size,
                    Transparency = head.Transparency,
                    CanCollide = head.CanCollide,
                    Massless = head.Massless,
                    Material = head.Material
                }
            end
            local orig = OriginalHeadSizes[head]
            if State.HitboxExpander and State.Running then
                local sz = tonumber(State.HitboxSize) or 6
                head.Size = Vector3.new(sz, sz, sz)
                head.CanCollide = false
                head.Massless = true
                if State.HitboxShow then
                    head.Transparency = 0.5
                    head.Material = Enum.Material.Neon
                    head.BrickColor = BrickColor.new("Bright red")
                else
                    head.Transparency = orig.Transparency
                end
            else
                if orig then
                    head.Size = orig.Size
                    head.Transparency = orig.Transparency
                    head.CanCollide = orig.CanCollide
                    head.Massless = orig.Massless
                    head.Material = orig.Material
                end
            end
        end
    end)
end

local function UpdateAllHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            ApplyHitboxToCharacter(plr.Character)
        end
    end
end

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        if State.HitboxExpander then
            pcall(UpdateAllHitboxes)
        end
        task.wait(1)
    end
end)

--------------------------------------------------------------
-- 10.2 SMART CATEGORIZED PROXIMITY PROMPT (INSTANT E vs SAFE DELAY)
--------------------------------------------------------------
local function ClassifyPrompt(prompt)
    local act = prompt.ActionText or ""
    local obj = prompt.ObjectText or ""
    local pName = prompt.Parent and prompt.Parent.Name or ""
    local fullName = ""
    pcall(function() fullName = prompt:GetFullName() end)

    local actLower = string.lower(act)
    local objLower = string.lower(obj)
    local pNameLower = string.lower(pName)
    local fullLower = string.lower(fullName)

    -- 1. หมวดตู้เซฟ (Safe): กดติดทันที 0ms ตามที่ dj ต้องการ
    local isSafe = act:find("ตู้เซฟ") or obj:find("ตู้เซฟ") or pName:find("Safe") or obj:find("Safe")
                or act:find("Safe") or pName:find("เซฟ") or fullLower:find("safe") or fullLower:find("ตู้เซฟ")

    -- 2. หมวดพ่อค้า & คุย NPC (Merchant / Shop): กดติดทันที 0ms ตามที่ dj ต้องการ
    local isMerchant = act:find("พ่อค้า") or obj:find("พ่อค้า") or pName:find("Merchant") or obj:find("Merchant")
                    or act:find("คุย") or act:find("สนทนา") or actLower:find("talk")
                    or act:find("ซื้อ") or act:find("ขาย") or actLower:find("shop") or actLower:find("store")
                    or actLower:find("dealer") or act:find("เปิดร้าน") or pNameLower:find("merchant") or fullLower:find("merchant")

    -- 3. หมวดประตู, รถยนต์, เก้าอี้, เพลง: กดติดทันที 0ms ปลอดภัย 100%
    local isGeneralInstant = act:find("ประตู") or actLower:find("door") or obj:find("ประตู") or objLower:find("door")
                          or act:find("เพลง") or actLower:find("music") or actLower:find("radio") or obj:find("วิทยุ")
                          or act:find("ขับ") or actLower:find("drive") or act:find("ขึ้นรถ") or pNameLower:find("vehicle") or pNameLower:find("car")
                          or act:find("นั่ง") or actLower:find("sit") or pNameLower:find("seat") or pNameLower:find("chair")

    -- 4. หมวดจุดทำงาน / ฟาร์มงาน (Job Work Sites): ต้องมีดีเลย์ค้างตามเซิร์ฟเวอร์ ป้องกัน CODE: 49
    local isJob = false
    local jobMinDelay = 3.5

    if fullLower:find("job") or pNameLower:find("job") then
        isJob = true
    end
    if actLower:find("hammer") or actLower:find("weld") or actLower:find("construct") or act:find("ก่อสร้าง") or act:find("เชื่อม") or act:find("ตอก") then
        isJob = true
        jobMinDelay = 3.5
    elseif act:find("ถู") or act:find("นวด") or actLower:find("clean") or actLower:find("mop") or pNameLower:find("dirty") or objLower:find("dirty") then
        isJob = true
        jobMinDelay = 5.0
    elseif act:find("ขยะ") or act:find("คุ้ย") or actLower:find("trash") or actLower:find("waste") or pNameLower:find("trash") or pNameLower:find("dumpster") then
        isJob = true
        jobMinDelay = 3.0
    elseif act:find("ซ่อม") or actLower:find("repair") or actLower:find("fix") or act:find("แบก") or actLower:find("carry") then
        isJob = true
        jobMinDelay = 3.5
    end

    -- 5. หมวดเก็บของ / ปืนตก / กระเป๋าตก / หลุมศพ (Item Looting): ต้องมีดีเลย์ ป้องกันแบนถาวร CODE: 59
    local isLoot = false
    local lootMinDelay = 1.2

    if not isSafe and not isMerchant then
        if pNameLower:find("dropbag") or pNameLower:find("drop_bag") or fullLower:find("dropbag") or pName:find("ถุงเงิน") or pNameLower:find("cashdrop") then
            isLoot = true
            lootMinDelay = 1.2
        elseif pNameLower:find("grave") or objLower:find("grave") or act:find("หลุม") or fullLower:find("grave") then
            isLoot = true
            lootMinDelay = 3.0
        elseif act:find("หยิบ") or act:find("เก็บของ") or act:find("เก็บไอเทม") or actLower:find("loot") or actLower:find("take") or actLower:find("pick") or act:find("ขโมย") or actLower:find("steal") then
            isLoot = true
            lootMinDelay = 1.2
        elseif (act:find("เก็บ") or act:find("หยิบ")) and (obj:find("ปืน") or objLower:find("gun") or obj:find("กระเป๋า") or objLower:find("bag") or obj:find("ถุง") or obj:find("เงิน") or pNameLower:find("gun") or pNameLower:find("bag") or pNameLower:find("tool")) then
            isLoot = true
            lootMinDelay = 1.2
        end
    end

    return {
        isSafe = isSafe,
        isMerchant = isMerchant,
        isGeneralInstant = isGeneralInstant,
        isJob = isJob,
        jobMinDelay = jobMinDelay,
        isLoot = isLoot,
        lootMinDelay = lootMinDelay
    }
end

local function ProcessPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        local class = ClassifyPrompt(prompt)

        -- บันทึกค่า HoldDuration ดั้งเดิมจากเซิร์ฟเวอร์
        local orig = prompt:GetAttribute("_OrigHoldDuration")
        if orig == nil then
            orig = prompt.HoldDuration
            if orig == 0 then
                if class.isJob then
                    orig = class.jobMinDelay
                elseif class.isLoot then
                    orig = class.lootMinDelay
                end
            end
            prompt:SetAttribute("_OrigHoldDuration", orig)
        end

        -- ป้องกันระยะกดเกินจริงจนโดนตรวจจับ CODE: 264 (Distance Check)
        if prompt.MaxActivationDistance > 8.5 then
            prompt.MaxActivationDistance = 8.5
        end

        -- แยกประเภทตามที่ dj กำหนดอย่างชัดเจน:
        if class.isJob then
            -- 🛡️ หมวดฟาร์มงาน: มีดีเลย์การกดค้างตามเซิร์ฟเวอร์ (3.0s - 5.0s) ห้าม 0s ป้องกันโดนเตะ CODE: 49
            local safeDuration = math.max(class.jobMinDelay, orig or 0)
            prompt.HoldDuration = safeDuration
        elseif class.isLoot then
            -- 🛡️ หมวดเก็บของ / ปืนตก / กระเป๋าตก: มีดีเลย์การกด (1.2s - 3.0s) ห้าม 0s ป้องกันโดนแบน CODE: 59
            local safeDuration = math.max(class.lootMinDelay, orig or 0)
            prompt.HoldDuration = safeDuration
        elseif class.isSafe or class.isMerchant or class.isGeneralInstant then
            -- ⚡ หมวดตู้เซฟ, พ่อค้าพเนจร, คุย NPC, ประตู, รถยนต์, เก้าอี้: กดติดทันที 0ms!
            if State.InstantPrompt or State.AutoZeroPrompt then
                prompt.HoldDuration = 0
            else
                prompt.HoldDuration = orig
            end
        else
            -- หมวดทั่วไปอื่นๆ
            if (orig or 0) <= 0 and (State.InstantPrompt or State.AutoZeroPrompt) then
                prompt.HoldDuration = 0
            else
                prompt.HoldDuration = orig or 0
            end
        end
    end)
end

-- ดักจับเมื่อ ProximityPrompt แสดงผล (0% CPU impact ไม่สแกนทั้ง Workspace ป้องกันเกมกระตุก)
pcall(function()
    Connections.PromptShownHook = game:GetService("ProximityPromptService").PromptShown:Connect(ProcessPrompt)
end)

Connections.PromptAddedHook = workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("ProximityPrompt") then
        ProcessPrompt(desc)
    end
end)

--------------------------------------------------------------
-- 🎯 ปรับแต่งทิศทางกระสุน & SILENT AIM SYSTEM
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
    local inset = GuiService:GetGuiInset()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")

    -- 1. ตรวจสอบเป้าปืน (GunGUI Crosshair)
    local gunGui = pgui and pgui:FindFirstChild("GunGUI")
    if gunGui and gunGui:IsA("ScreenGui") and gunGui.Enabled then
        local crosshair = gunGui:FindFirstChild("Crosshair")
        if crosshair and crosshair.AbsolutePosition.X > 0 then
            local addInset = gunGui.IgnoreGuiInset and Vector2.zero or inset
            return crosshair.AbsolutePosition + (crosshair.AbsoluteSize / 2) + addInset
        end
    end

    -- 2. ตรวจสอบเป้ามือเปล่า/หมัด (fistgui crosshair)
    local fistgui = pgui and pgui:FindFirstChild("fistgui")
    if fistgui and fistgui:IsA("ScreenGui") and fistgui.Enabled then
        local crosshair = fistgui:FindFirstChild("crosshair")
        if crosshair and crosshair.Visible and crosshair.AbsolutePosition.X > 0 then
            local addInset = fistgui.IgnoreGuiInset and Vector2.zero or inset
            return crosshair.AbsolutePosition + (crosshair.AbsoluteSize / 2) + addInset
        end
    end

    -- 3. ตรวจสอบ Crosshair อื่นๆ ใน PlayerGui (กรณีอาวุธชนิดอื่นๆ)
    if pgui then
        for _, gui in ipairs(pgui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled then
                local ch = gui:FindFirstChild("Crosshair", true) or gui:FindFirstChild("crosshair", true)
                if ch and ch:IsA("GuiObject") and ch.Visible and ch.AbsolutePosition.X > 0 then
                    local addInset = gui.IgnoreGuiInset and Vector2.zero or inset
                    return ch.AbsolutePosition + (ch.AbsoluteSize / 2) + addInset
                end
            end
        end
    end

    -- 4. กรณีล็อกเป้ากึ่งกลางจอ (LockCenter / ShiftLock / First-Person)
    local uis = UserInputService
    if uis.MouseBehavior == Enum.MouseBehavior.LockCenter or (cam.Focus.p - cam.CFrame.p).Magnitude <= 1 then
        return Vector2.new(cam.ViewportSize.X / 2, (cam.ViewportSize.Y / 2) + inset.Y)
    end

    -- 5. กรณีเมาส์อิสระ (Free Mouse): UserInputService:GetMouseLocation() ตรงกับ Drawing Space 1:1
    return uis:GetMouseLocation()
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
                    local sPos, onScreen = cam:WorldToScreenPoint(targetPart.Position)
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
                            local screenRay = cam:ScreenPointToRay(center.X, center.Y)
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
    DespawnTimestamp = 0,
    ShopName = "พ่อค้าพเนจร",
    LocationName = "จุดลับ",
    Model = nil,
    RootPart = nil,
    Distance = 0,
    NextSpawnTime = 0,
    ServerAnchor = 493,
}
local MerchantESPObjects = {}
local FindMerchantNPC = nil
local UpdateMerchantESPSubInfo = nil

local MERCHANT_ANCHOR_FILE = "KrakenHub/merchant_anchor.json"

local function SaveMerchantAnchor(serverNextSpawn, anchorMod)
    pcall(function()
        local data = {
            jobId = game.JobId,
            nextSpawn = serverNextSpawn,
            anchorMod = anchorMod or 493,
            updatedAt = workspace:GetServerTimeNow()
        }
        _G._KrakenMerchantAnchor = data
        if writefile then
            local HttpService = game:GetService("HttpService")
            writefile(MERCHANT_ANCHOR_FILE, HttpService:JSONEncode(data))
        end
    end)
end

local function LoadMerchantAnchor()
    local anchor = _G._KrakenMerchantAnchor
    if not anchor and isfile and isfile(MERCHANT_ANCHOR_FILE) and readfile then
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local raw = readfile(MERCHANT_ANCHOR_FILE)
            local parsed = HttpService:JSONDecode(raw)
            if parsed and parsed.jobId == game.JobId then
                anchor = parsed
                _G._KrakenMerchantAnchor = parsed
            end
        end)
    end
    return anchor
end

local function GetEstimatedNextMerchantSpawnSec()
    local sNow = workspace:GetServerTimeNow()
    local anchor = LoadMerchantAnchor()
    if anchor and anchor.nextSpawn then
        local diff = anchor.nextSpawn - sNow
        while diff < 0 do
            diff = diff + 1800
        end
        return math.max(1, math.floor(diff))
    end

    local anchorMod = (anchor and anchor.anchorMod) or 493
    local cyclePos = (sNow - anchorMod) % 1800
    local diff = (1800 - cyclePos) % 1800
    if diff <= 0 then
        diff = 1800
    end
    return math.max(1, math.floor(diff))
end

local function SyncMerchantServerCycle(remainingSec)
    local sNow = workspace:GetServerTimeNow()
    if remainingSec and remainingSec > 0 then
        local despawnServer = sNow + remainingSec
        local nextSpawnServer = despawnServer + 1200
        local anchorMod = math.floor((despawnServer - 600) % 1800)
        MerchantData.DespawnTimestamp = os.clock() + remainingSec
        MerchantData.NextSpawnTime = os.clock() + remainingSec + 1200
        SaveMerchantAnchor(nextSpawnServer, anchorMod)
    else
        local estSec = GetEstimatedNextMerchantSpawnSec()
        MerchantData.NextSpawnTime = os.clock() + estSec
    end
end

local function GetRealtimeMerchantTimeString()
    -- 1. ดึงตรงจาก TimerLabel ของเกม (หากเปิดร้านอยู่และนับถอยหลัง)
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local gunShop = pgui and pgui:FindFirstChild("GunShopGui")
    local tf = gunShop and gunShop:FindFirstChild("TimerFrame")
    if tf and tf.Visible then
        local tl = tf:FindFirstChild("TimerLabel")
        if tl and tl.Text ~= "" then
            local timeMatch = string.match(tl.Text, "(%d+:%d+)")
            if timeMatch and timeMatch ~= "0:00" then
                local m, s = string.match(timeMatch, "(%d+):(%d+)")
                if m and s then
                    local totalSec = tonumber(m) * 60 + tonumber(s)
                    if totalSec > 0 then
                        MerchantData.DespawnTimestamp = os.clock() + totalSec
                    end
                end
                return " | ⏱️ " .. timeMatch
            end
        end
    end

    -- 2. ดึงจากการ์ดแจ้งเตือน SecretShopNotice ด้านบน
    local ssn = pgui and pgui:FindFirstChild("SecretShopNotice")
    local card = ssn and ssn:FindFirstChild("Card")
    if card and card.Visible then
        local timeLbl = card:FindFirstChild("Time")
        if timeLbl and timeLbl.Text ~= "" then
            local timeMatch = string.match(timeLbl.Text, "(%d+:%d+)")
            if timeMatch and timeMatch ~= "0:00" then
                return " | ⏱️ " .. timeMatch
            end
        end
    end

    -- 3. คำนวณจาก Timestamp ตามเวลาจริงระดับ Real-time (แม่นยำระดับเสี้ยววินาที)
    if MerchantData.DespawnTimestamp and MerchantData.DespawnTimestamp > os.clock() then
        local rem = math.max(0, math.floor(MerchantData.DespawnTimestamp - os.clock()))
        local m = math.floor(rem / 60)
        local s = math.floor(rem % 60)
        return string.format(" | ⏱️ %d:%02d", m, s)
    end

    -- 4. หากพ่อค้าปรากฏในแมพแต่ยังไม่มีข้อมูลเวลา เริ่มต้นนับ 10 นาที (600 วินาที)
    if cachedMerchantModel and cachedMerchantHRP then
        if not MerchantData.DespawnTimestamp or MerchantData.DespawnTimestamp <= os.clock() then
            MerchantData.DespawnTimestamp = os.clock() + 600
        end
        local rem = math.max(0, math.floor(MerchantData.DespawnTimestamp - os.clock()))
        local m = math.floor(rem / 60)
        local s = math.floor(rem % 60)
        return string.format(" | ⏱️ %d:%02d", m, s)
    end

    return ""
end

local cachedMerchantModel = nil
local cachedMerchantHRP = nil
local lastMerchantSearchTime = 0

FindMerchantNPC = function()
    -- ตรวจสอบโมเดลที่บันทึกไว้ว่ายังอยู่ใน Workspace หรือไม่
    if cachedMerchantModel and cachedMerchantModel.Parent and cachedMerchantModel:IsDescendantOf(Workspace) then
        local liveHRP = cachedMerchantModel:FindFirstChild("HumanoidRootPart")
                     or cachedMerchantModel:FindFirstChild("Torso")
                     or cachedMerchantModel:FindFirstChild("Head")
                     or cachedMerchantModel.PrimaryPart
                     or cachedMerchantModel:FindFirstChildWhichIsA("BasePart")
        if liveHRP then
            cachedMerchantHRP = liveHRP
            return cachedMerchantModel, cachedMerchantHRP
        end
    end

    local now = os.clock()
    if now - lastMerchantSearchTime < 3.0 then
        return cachedMerchantModel, cachedMerchantHRP
    end
    lastMerchantSearchTime = now

    -- 1. ค้นหาโมเดล SecretShopNPC ใน Workspace:GetChildren() (เร็วมาก ไม่กินเฟรม)
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and (string.find(obj.Name, "SecretShopNPC") or string.find(obj.Name, "พ่อค้าพเนจร")) then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
                     or obj:FindFirstChild("Torso")
                     or obj:FindFirstChild("Head")
                     or obj:FindFirstChild("UpperTorso")
                     or obj.PrimaryPart
                     or obj:FindFirstChildWhichIsA("BasePart")

            if hrp then
                cachedMerchantModel = obj
                cachedMerchantHRP = hrp
                return obj, hrp
            end
        end
    end

    -- 2. ค้นหาในโฟลเดอร์เป้าหมายยอดนิยม
    local targetFolders = {"NPC", "NPCs", "Map", "Spawns", "Shop", "Shops", "SecretShop"}
    for _, fName in ipairs(targetFolders) do
        local f = Workspace:FindFirstChild(fName)
        if f then
            for _, obj in ipairs(f:GetChildren()) do
                if obj:IsA("Model") and (string.find(obj.Name, "SecretShopNPC") or string.find(obj.Name, "พ่อค้าพเนจร")) then
                    local hrp = obj:FindFirstChild("HumanoidRootPart")
                             or obj:FindFirstChild("Torso")
                             or obj:FindFirstChild("Head")
                             or obj.PrimaryPart
                             or obj:FindFirstChildWhichIsA("BasePart")
                    if hrp then
                        cachedMerchantModel = obj
                        cachedMerchantHRP = hrp
                        return obj, hrp
                    end
                end
            end
        end
    end

    cachedMerchantModel = nil
    cachedMerchantHRP = nil
    return nil, nil
end

local function ClearMerchantESP()
    for _, obj in ipairs(MerchantESPObjects) do
        pcall(function() obj:Destroy() end)
    end
    table.clear(MerchantESPObjects)
    if Hub.LocalMerchantAnchor then
        pcall(function() Hub.LocalMerchantAnchor:Destroy() end)
        Hub.LocalMerchantAnchor = nil
    end
    pcall(function()
        for _, c in ipairs(targetGuiParent:GetChildren()) do
            if c:IsA("BillboardGui") and c.Name == "MerchantBillboard" then
                c:Destroy()
            end
            if c:IsA("Highlight") and c.Name == "MerchantHighlight" then
                c:Destroy()
            end
        end
    end)
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

    local existingBB = nil
    for _, obj in ipairs(MerchantESPObjects) do
        if obj:IsA("BillboardGui") and obj.Name == "MerchantBillboard" then
            existingBB = obj
            break
        end
    end

    local existingHL = nil
    for _, obj in ipairs(MerchantESPObjects) do
        if obj:IsA("Highlight") and obj.Name == "MerchantHighlight" then
            existingHL = obj
            break
        end
    end

    if not existingHL and model:IsA("Model") then
        local hl = Instance.new("Highlight")
        hl.Name = "MerchantHighlight"
        hl.FillColor = Color3.fromRGB(255, 215, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.35
        hl.OutlineTransparency = 0
        hl.Adornee = model
        hl.Parent = targetGuiParent
        table.insert(MerchantESPObjects, hl)
    end

    if not existingBB then
        local bb = Instance.new("BillboardGui")
        bb.Name = "MerchantBillboard"
        bb.Adornee = hrp
        bb.Size = UDim2.new(0, 200, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3.8, 0)
        bb.AlwaysOnTop = true

        local titleLbl = Instance.new("TextLabel", bb)
        titleLbl.Name = "Title"
        titleLbl.Size = UDim2.new(1, 0, 0, 18)
        titleLbl.Position = UDim2.new(0, 0, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 12
        titleLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
        titleLbl.TextStrokeTransparency = 0.2
        titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        titleLbl.Text = "🛒 พ่อค้าพเนจร (Secret Shop)"

        local subLbl = Instance.new("TextLabel", bb)
        subLbl.Name = "SubInfo"
        subLbl.Size = UDim2.new(1, 0, 0, 16)
        subLbl.Position = UDim2.new(0, 0, 0, 18)
        subLbl.BackgroundTransparency = 1
        subLbl.Font = Enum.Font.GothamMedium
        subLbl.TextSize = 11
        subLbl.TextColor3 = Color3.fromRGB(255, 230, 120)
        subLbl.TextStrokeTransparency = 0.2
        subLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        subLbl.Text = "กำลังคำนวณระยะห่าง..."

        bb.Parent = targetGuiParent
        table.insert(MerchantESPObjects, bb)
        existingBB = bb
    else
        existingBB.Adornee = hrp
    end

    if existingBB then
        UpdateMerchantESPSubInfo()
    end
end

UpdateMerchantESPSubInfo = function()
    if not State.MerchantESP or not State.Running then return end
    local bb = nil
    for _, obj in ipairs(MerchantESPObjects) do
        if obj:IsA("BillboardGui") and obj.Name == "MerchantBillboard" then
            bb = obj
            break
        end
    end
    if not bb or not bb.Parent then return end
    local subLbl = bb:FindFirstChild("SubInfo")
    if not subLbl then return end

    local myHRP = GetHRP()
    local hrp = bb.Adornee
    if not hrp or not hrp.Parent then return end

    local dist = (myHRP and hrp:IsA("BasePart")) and (myHRP.Position - hrp.Position).Magnitude or 0
    local meters = math.floor(dist * 0.28)
    local timeStr = GetRealtimeMerchantTimeString()
    subLbl.Text = string.format("อีก %d เมตร%s", meters, timeStr)
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
                local sec = tonumber(remainingSec) or 600
                MerchantData.IsOpen = true
                MerchantData.RemainingTime = sec
                MerchantData.ShopName = shopName or "พ่อค้าพเนจร"
                SyncMerchantServerCycle(sec)
                if State.AutoNotifyMerchant then
                    Notify("🛒 พ่อค้าพเนจรเปิดร้าน!", string.format("เหลือเวลาอีก %d นาที %02d วินาที", math.floor(sec / 60), math.floor(sec % 60)), "เปิดเมนูเพื่อวาร์ปหรือเปิดร้าน", 5)
                end
                UpdateMerchantESP()
                UpdateMerchantESPSubInfo()
            end)
        end

        local SecretShopAnnounce = Black:FindFirstChild("SecretShopAnnounce")
        if SecretShopAnnounce then
            Connections.SecretShopAnnounce = SecretShopAnnounce.OnClientEvent:Connect(function(state, locName, duration)
                if state == "open" then
                    local dur = tonumber(duration) or 600
                    MerchantData.IsOpen = true
                    MerchantData.LocationName = locName or "จุดลับ"
                    MerchantData.RemainingTime = dur
                    SyncMerchantServerCycle(dur)
                    if State.AutoNotifyMerchant then
                        Notify("🛒 พ่อค้าพเนจรมาถึงแล้ว!", "อยู่ที่: " .. tostring(locName), "เปิดเมนูเพื่อตรวจสอบตำแหน่ง", 5)
                    end
                    UpdateMerchantESP()
                    UpdateMerchantESPSubInfo()
                elseif state == "close" then
                    local dur = tonumber(duration) or 1200
                    MerchantData.IsOpen = false
                    MerchantData.RemainingTime = 0
                    MerchantData.DespawnTimestamp = 0
                    MerchantData.NextSpawnTime = os.clock() + dur
                    SaveMerchantAnchor(workspace:GetServerTimeNow() + dur)
                    ClearMerchantESP()
                    if State.AutoNotifyMerchant then
                        Notify("🛒 พ่อค้าพเนจรปิดร้านแล้ว", string.format("จะกลับมาใหม่ในอีกประมาณ %d นาที", math.floor(dur / 60)), "", 4)
                    end
                end
            end)
        end
    end
end)

-- เชื่อมต่อตัวตรวจจับการเปลี่ยนข้อความของ TimerLabel ของเกม (Real-time 0ms drift)
pcall(function()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local gunShop = pgui and pgui:FindFirstChild("GunShopGui")
    local tf = gunShop and gunShop:FindFirstChild("TimerFrame")
    local tl = tf and tf:FindFirstChild("TimerLabel")
    if tl then
        if Connections.MerchantTimerLabelChanged then
            pcall(function() Connections.MerchantTimerLabelChanged:Disconnect() end)
        end
        Connections.MerchantTimerLabelChanged = tl:GetPropertyChangedSignal("Text"):Connect(function()
            if State.MerchantESP and State.Running then
                UpdateMerchantESPSubInfo()
            end
        end)
    end
end)

-- ลูป Heartbeat เพื่ออัปเดตระยะทางและเวลาแบบเรียลไทม์ลื่นไหล (10 Hz)
local lastMerchantTick = 0
if Connections.MerchantHeartbeat then
    pcall(function() Connections.MerchantHeartbeat:Disconnect() end)
end
Connections.MerchantHeartbeat = RunService.Heartbeat:Connect(function()
    if not State.MerchantESP or not State.Running then return end
    local now = os.clock()
    if now - lastMerchantTick >= 0.2 then
        lastMerchantTick = now
        UpdateMerchantESPSubInfo()
    end
end)

local function GetMerchantStatusDisplay()
    local model, hrp = FindMerchantNPC()
    MerchantData.Model = model
    MerchantData.RootPart = hrp

    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local gunShop = pgui and pgui:FindFirstChild("GunShopGui")
    local tf = gunShop and gunShop:FindFirstChild("TimerFrame")
    local tl = tf and tf:FindFirstChild("TimerLabel")

    local isActuallyOpen = false
    local remainingSec = 0

    if tf and tf.Visible and tl and tl.Text ~= "" then
        local m, s = string.match(tl.Text, "(%d+):(%d+)")
        if m and s then
            remainingSec = tonumber(m) * 60 + tonumber(s)
            if remainingSec > 0 then
                isActuallyOpen = true
                SyncMerchantServerCycle(remainingSec)
            end
        end
    end

    if not isActuallyOpen and MerchantData.DespawnTimestamp and MerchantData.DespawnTimestamp > os.clock() then
        remainingSec = math.max(0, math.floor(MerchantData.DespawnTimestamp - os.clock()))
        isActuallyOpen = true
    end

    if not isActuallyOpen and model ~= nil then
        isActuallyOpen = true
        if not MerchantData.DespawnTimestamp or MerchantData.DespawnTimestamp <= os.clock() then
            MerchantData.DespawnTimestamp = os.clock() + 600
            SyncMerchantServerCycle(600)
        end
        remainingSec = math.max(0, math.floor(MerchantData.DespawnTimestamp - os.clock()))
    end

    MerchantData.IsOpen = isActuallyOpen
    MerchantData.RemainingTime = remainingSec

    local title = ""
    local timeDesc = ""

    if isActuallyOpen then
        local m = math.floor(remainingSec / 60)
        local s = math.floor(remainingSec % 60)
        title = string.format("🛒 พ่อค้าพเนจร: เปิดร้านอยู่ (%d:%02d)", m, s)
        timeDesc = string.format("• ⏱️ เวลาที่เหลือ: %d นาที %02d วินาที (กำลังเปิดร้าน)", m, s)
    else
        local diff = 0
        if MerchantData.NextSpawnTime and MerchantData.NextSpawnTime > os.clock() then
            diff = math.max(1, math.floor(MerchantData.NextSpawnTime - os.clock()))
        else
            diff = GetEstimatedNextMerchantSpawnSec()
            MerchantData.NextSpawnTime = os.clock() + diff
        end

        local m = math.floor(diff / 60)
        local s = math.floor(diff % 60)
        title = string.format("⏳ พ่อค้าพเนจร: ปิดร้านอยู่ (จะมาในอีก %d:%02d)", m, s)
        timeDesc = string.format("• ⏱️ จะมาถึงในอีกประมาณ: %d นาที %02d วินาที (นับถอยหลัง Real-time)", m, s)
    end

    local myHRP = GetHRP()
    if myHRP and hrp then
        MerchantData.Distance = math.floor((myHRP.Position - hrp.Position).Magnitude)
    else
        MerchantData.Distance = 0
    end

    local locDesc = ""
    if isActuallyOpen and hrp then
        local p = hrp.Position
        locDesc = string.format("• 📍 ตำแหน่ง: (%.0f, %.0f, %.0f)\n• 📏 ระยะห่าง: อีก %d เมตร", p.X, p.Y, p.Z, math.floor(MerchantData.Distance * 0.28))
    else
        locDesc = "• 📍 ตำแหน่ง: กำลังเดินทาง (จะแสดงจุดเกิดและป้ายลอย ESP ทันทีที่เปิดร้าน)\n• ℹ️ เมื่อเปิดร้าน ระบบจะแจ้งเตือนและสามารถกดวาร์ปได้ทันที"
    end

    return title, timeDesc .. "\n" .. locDesc
end

local MerchantStatusParagraph = nil
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(2.0)
        pcall(function()
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
    Title = "🛡️ KrakenHub v1.0 ",
    Content = "• 100% Stealth Anti-Cheat Bypass ปลอดภัย ไม่แตะต้อง Metatable\n• ล็อกสปีด 20 studs/s แท้จริง วิ่งไวกว่าคนทั่วไป แต่ต่ำกว่าเกณฑ์เตะ 261\n• ป้องกันหลุดระยะ ProximityPrompt และ Remote Rate-Limit ถาวร"
})

local JobSelector = Tabs.Farm:AddDropdown("JobSelect", {
    Title = "🎯 เลือกสายงานฟาร์ม",
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
    Title = "🧱 ตัวกรองจุดก่อสร้าง",
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
    Title = "🚀 เริ่มฟาร์มอัตโนมัติ",
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
    Title = "🔨 แก้มินิเกมอัตโนมัติ",
    Description = "ตอกตะปู, ซ่อมเครื่องยนต์, ขันน็อตล้อ, ถูพื้น, ส่องไฟคุ้ยขยะ อัตโนมัติ 100%",
    Default = true
})
MinigameToggle:OnChanged(function()
    State.AutoSolveMinigame = Options.AutoSolveMinigameOn.Value
end)

local AllSpotsToggle = Tabs.Farm:AddToggle("ShowAllJobSpotsToggle", {
    Title = "👁️ แสดงจุดงานทั้งหมด (ESP)",
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

Tabs.Farm:AddSection("💰 ระบบเงินค่าจ้าง")

local AutoClaimToggle = Tabs.Farm:AddToggle("AutoClaimConstructionOn", {
    Title = "💰 เคลมเงินอัตโนมัติ",
    Description = "เคลมเงินค่าจ้างงานก่อสร้างเข้าตัวให้อัตโนมัติทันทีที่มีเงินสะสม",
    Default = false
})
AutoClaimToggle:OnChanged(function()
    State.AutoClaimConstruction = Options.AutoClaimConstructionOn.Value
    if State.AutoClaimConstruction then
        Notify("เคลมเงินอัตโนมัติ", "เปิดใช้งานเคลมเงินงานก่อสร้างอัตโนมัติแล้ว", "", 2.5)
        ClaimConstructionWage(true)
    end
end)

-- 💵 กล่องแสดงยอดเงินสะสม Real-time ตรงกลาง
WageEarningsParagraph = Tabs.Farm:AddParagraph({
    Title = "💵 ยอดเงินสะสม: " .. GetCurrentAccumulatedWage(),
    Content = ""
})

-- ลูปอัปเดตยอดเงินสะสม Real-time ทุก 1 วินาที
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(1.0)
        UpdateWageDisplay()
    end
end)

Tabs.Farm:AddButton({
    Title = "💵 กดรับเงินทันที",
    Description = "รับเงินค่าจ้างงานก่อสร้างที่สะสมอยู่ทั้งหมดเข้ากระเป๋าทันที 1 คลิก",
    Callback = function()
        ClaimConstructionWage(false)
    end
})


--------------------------------------------------------------
-- 🛒 สร้างเมนูใน TABS.MERCHANT (พ่อค้าพเนจร)
--------------------------------------------------------------
local initMerchantTitle, initMerchantDesc = GetMerchantStatusDisplay()
MerchantStatusParagraph = Tabs.Merchant:AddParagraph({
    Title = initMerchantTitle,
    Content = initMerchantDesc
})

local MerchantESPToggle = Tabs.Merchant:AddToggle("MerchantESPOn", {
    Title = "👁️ ESP พ่อค้าพเนจร",
    Description = "แสดงกล่องข้อความสีทอง + ข้อมูลระยะห่าง + เวลาที่เหลือทะลุกำแพง",
    Default = true
})
MerchantESPToggle:OnChanged(function()
    State.MerchantESP = Options.MerchantESPOn.Value
    if not State.MerchantESP then
        ClearMerchantESP()
        Notify("พ่อค้าพเนจร", "ปิดการแสดงผล ESP พ่อค้าพเนจรแล้ว", "", 2.5)
    else
        UpdateMerchantESP()
        local model, hrp = FindMerchantNPC()
        if model and hrp then
            Notify("พ่อค้าพเนจร", "พบพ่อค้าพเนจรในแมพ! แสดงตำแหน่ง ESP เรียบร้อย", "", 3)
        else
            Notify("พ่อค้าพเนจร", "เปิดระบบ ESP พ่อค้าแล้ว (ขณะนี้พ่อค้าปิดร้านอยู่ ระบบจะแสดง ESP ทันทีที่มาถึง)", "", 4)
        end
    end
end)

local MerchantNotifyToggle = Tabs.Merchant:AddToggle("MerchantNotifyOn", {
    Title = "🔔 แจ้งเตือนพ่อค้ามา",
    Description = "เด้งหน้าต่างแจ้งเตือนทันทีเมื่อพ่อค้าพเนจรเปิดร้านในเซิร์ฟเวอร์",
    Default = true
})
MerchantNotifyToggle:OnChanged(function()
    State.AutoNotifyMerchant = Options.MerchantNotifyOn.Value
end)

Tabs.Merchant:AddButton({
    Title = "⚡ วาร์ปไปหาพ่อค้า",
    Description = "วาร์ปตัวละครไปยืนอยู่ตรงหน้าพ่อค้าทันที",
    Callback = function()
        TeleportToMerchant()
    end
})

-- [แท็บ 2: ตัวละคร]
Tabs.Player:AddParagraph({
    Title = "🏃 ระบบปรับแต่งตัวละคร & ความอยู่รอด",
    Content = "Speed, วิ่งไม่เหนื่อย, Godmode (อมตะ), Noclip, Fly, InfJump และ ESP"
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
    Title = "⚡ ความเร็วเดิน (Speed)",
    Default = 17,
    Min = 8,
    Max = 20,
    Rounding = 0
})
SpeedSlider:OnChanged(function()
    State.SpeedValue = Options.SpeedVal.Value
end)

local StaminaToggle = Tabs.Player:AddToggle("InfiniteStaminaOn", {
    Title = "🏃 วิ่งไม่เหนื่อย (Infinite Stamina)",
    Description = "ล็อคสเตมิน่าเต็ม 100% ตลอดเวลา วิ่งได้ไม่มีสะดุด ไม่ติดสถานะหอบเหนื่อย",
    Default = false
})
StaminaToggle:OnChanged(function()
    State.InfiniteStamina = Options.InfiniteStaminaOn.Value
end)

local GodmodeToggle = Tabs.Player:AddToggle("GodmodeOn", {
    Title = "🛡️ อมตะ (Godmode)",
    Description = "ฟื้นฟูเลือดเต็มตลอดเวลา ป้องกันดาเมจและป้องกันสถานะล้มตาย",
    Default = false
})
GodmodeToggle:OnChanged(function()
    State.Godmode = Options.GodmodeOn.Value
    if State.Godmode then
        local hum = GetHuman()
        if hum then hum.Health = hum.MaxHealth end
    end
end)

local NoclipToggle = Tabs.Player:AddToggle("NoclipOn", {
    Title = "👻 เดินทะลุกำแพงสมูท (Smooth Noclip)",
    Description = "เดินทะลุกำแพง/สิ่งกีดขวางได้ลื่นไหล 100% ปลดล็อคทุกชิ้นส่วนและ Accessories ไม่มีอาการเด้งกลับหรือสะดุด",
    Default = false
})
NoclipToggle:OnChanged(function()
    State.Noclip = Options.NoclipOn.Value
    if not State.Noclip then
        RestoreCharacterCollisions()
    else
        ApplySmoothNoclip()
    end
end)

local FlyToggle = Tabs.Player:AddToggle("FlyOn", { Title = "🚀 บินอิสระ (Fly Hack)", Default = false })
FlyToggle:OnChanged(function()
    State.Fly = Options.FlyOn.Value
    if State.Fly then StartFly() else StopFly() end
end)

local InfJumpToggle = Tabs.Player:AddToggle("InfJumpOn", { Title = "♾️ กระโดดไม่จำกัด", Default = false })
InfJumpToggle:OnChanged(function()
    State.InfJump = Options.InfJumpOn.Value
end)

Tabs.Player:AddSection("🖐️ ระบบกดปุ่ม E อัจฉริยะ (Smart Categorized E - กันเตะ 49 & กันแบน 59)")

local InstantPromptToggle = Tabs.Player:AddToggle("InstantPromptOn", {
    Title = "⚡ กด E ทันที 0ms (พ่อค้า, ตู้เซฟ, ประตู, รถยนต์)",
    Description = "กด E ติดทันที 0 วินาที สำหรับพ่อค้าพเนจร, ตู้เซฟ, คุย NPC, ประตู, รถยนต์ และเก้าอี้ สะดวกและรวดเร็วสุดๆ",
    Default = true
})
InstantPromptToggle:OnChanged(function()
    State.InstantPrompt = Options.InstantPromptOn.Value
end)

local SmartPromptToggle = Tabs.Player:AddToggle("SmartPromptOn", {
    Title = "🛡️ ล็อคดีเลย์ปลอดภัย (เก็บของ, ปืนตก, ฟาร์มงาน)",
    Description = "ป้องกันโดนเตะ CODE: 49 และโดนแบนถาวร CODE: 59: รักษาเวลากดค้างสำหรับจุดฟาร์มงาน (3.5-5.0 วิ) และเก็บปืน/กระเป๋าตก (1.2 วิ)",
    Default = true
})
SmartPromptToggle:OnChanged(function()
    State.SmartPrompt = Options.SmartPromptOn.Value
end)

Tabs.Player:AddParagraph({
    Title = "👁️ ระบบ Tactical ESP แยกสีตามสถาบัน (School ESP)",
    Content = "ปทุมคงคา (ฟ้า) | กรุงเทพช่างกล (เหลือง) | พระ (ส้ม) | เด็กบ้าน (ขาว) | ตำรวจ (แดง) | วัดสุทธิ (เขียว) |"
})

local ESPToggle = Tabs.Player:AddToggle("ESPOn", {
    Title = "👁️ เปิดใช้งาน Player ESP",
    Description = "เรนเดอร์ Flicker-Free: กรอบมุม 4 ทิศ, จุดเล็งศีรษะ, Chams ขอบขาว และหลอดเลือด (แยกสีตามที่แมพแบ่งไว้)",
    Default = false
})
ESPToggle:OnChanged(function()
    State.ESP = Options.ESPOn.Value
    if not State.ESP then
        ClearAllPlayerESP()
    end
end)

local ESPTacticalToggle = Tabs.Player:AddToggle("ESPTacticalStyle", {
    Title = "🔴 Espแดงทั้งหมด",
    Description = "เปิด = บังคับสีแดงล้วนเหมือนรูปตัวอย่าง | ปิด = แยกสีตามสถาบันที่แมพแบ่งไว้ (ค่าเริ่มต้น)",
    Default = false
})
ESPTacticalToggle:OnChanged(function()
    State.ESPTacticalStyle = Options.ESPTacticalStyle.Value
end)

local ESPBoxToggle = Tabs.Player:AddToggle("ESPShowBox", {
    Title = "🔲 กรอบมุมตัวละคร (Box)",
    Description = "แสดงกรอบเล็งเป้า 4 มุมล้อมรอบตัวละคร",
    Default = true
})
ESPBoxToggle:OnChanged(function()
    State.ESPShowBox = Options.ESPShowBox.Value
end)

local ESPHeadDotToggle = Tabs.Player:AddToggle("ESPShowHeadDot", {
    Title = "🔴 จุดเล็งศีรษะ (Dot)",
    Description = "จุดวงกลมสีแดงตรงตำแหน่งศีรษะของผู้เล่น",
    Default = true
})
ESPHeadDotToggle:OnChanged(function()
    State.ESPShowHeadDot = Options.ESPShowHeadDot.Value
end)

local ESPChamsToggle = Tabs.Player:AddToggle("ESPShowChams", {
    Title = "✨ ไฮไลท์ตัวละคร (Chams)",
    Description = "ลำตัวสีแดงขอบขาวคมชัด ทะลุสิ่งกีดขวาง",
    Default = true
})
ESPChamsToggle:OnChanged(function()
    State.ESPShowChams = Options.ESPShowChams.Value
end)

local ESPHealthToggle = Tabs.Player:AddToggle("ESPShowHealthBar", {
    Title = "❤️ หลอดเลือด (Health Bar)",
    Description = "หลอดเลือดและตัวเลขพลังชีวิตด้านบนศีรษะแบบคมชัด",
    Default = true
})
ESPHealthToggle:OnChanged(function()
    State.ESPShowHealthBar = Options.ESPShowHealthBar.Value
end)

local ESPDistToggle = Tabs.Player:AddToggle("ESPShowDistance", {
    Title = "📐 แสดงระยะห่าง (Distance)",
    Description = "คำนวณระยะห่างระหว่างตัวละครเป็นเมตร (m)",
    Default = true
})
ESPDistToggle:OnChanged(function()
    State.ESPShowDistance = Options.ESPShowDistance.Value
end)

local ESPWeaponToggle = Tabs.Player:AddToggle("ESPShowWeapon", {
    Title = "🔫 แสดงชื่ออาวุธ (Weapon)",
    Description = "ตรวจจับปืน, มีด, อาวุธระยะประชิด หรือมือเปล่าแบบ Realtime",
    Default = true
})
ESPWeaponToggle:OnChanged(function()
    State.ESPShowWeapon = Options.ESPShowWeapon.Value
end)

local ESPMaxDistSlider = Tabs.Player:AddSlider("ESPMaxDistVal", {
    Title = "📏 ระยะ ESP สูงสุด",
    Description = "จำกัดระยะตรวจจับผู้เล่นเพื่อลดแลคและไม่รกสายตา (Studs)",
    Default = 500,
    Min = 50,
    Max = 1500,
    Rounding = 0
})
ESPMaxDistSlider:OnChanged(function()
    State.ESPMaxDistance = Options.ESPMaxDistVal.Value
end)

--------------------------------------------------------------
-- 🎯 แท็บ: ระบบต่อสู้ (COMBAT & SILENT AIM)
--------------------------------------------------------------
Tabs.Combat:AddParagraph({
    Title = "🎯 Silent Aim & Gun System",
    Content = "ระบบล็อคกระสุนอัตโนมัติ คำนวณวิถีกระสุนเข้าเป้าหมาย พร้อมระบบชดเชยความเร็วเป้าหมาย และตรวจสอบสิ่งกีดขวาง"
})

local SilentAimToggle = Tabs.Combat:AddToggle("SilentAimOn", {
    Title = "🎯 เปิดใช้ Silent Aim",
    Description = "วิถีกระสุนจะเล็งเข้าหาเป้าหมายในวงกลม FOV โดยไม่ต้องหันหน้าจอ",
    Default = false
})
SilentAimToggle:OnChanged(function()
    State.SilentAim = Options.SilentAimOn.Value
    ApplyGunMods()
end)

local PartDropdown = Tabs.Combat:AddDropdown("SilentPartChoice", {
    Title = "🎯 ตำแหน่งล็อค (Part)",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head"
})
PartDropdown:OnChanged(function()
    State.SilentPart = Options.SilentPartChoice.Value
end)

local HitChanceSlider = Tabs.Combat:AddSlider("HitChanceVal", {
    Title = "🎲 ความแม่นยำ (Hit %)",
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
    Title = "🧱 เช็คกำแพง (Wall Check)",
    Description = "ไม่ยิงล็อคเป้าหมายที่อยู่หลังกำแพงหรือสิ่งกีดขวาง",
    Default = false
})
WallCheckToggle:OnChanged(function()
    State.SilentWallCheck = Options.WallCheckOn.Value
end)

local VelocityToggle = Tabs.Combat:AddToggle("VelocityPredictOn", {
    Title = "⚡ นำวิถีความเร็ว (Predict)",
    Description = "ดักหน้าทิศทางการเคลื่อนที่ของศัตรู ยิงโดนแม้ศัตรูกำลังวิ่ง",
    Default = false
})
VelocityToggle:OnChanged(function()
    State.SilentVelocity = Options.VelocityPredictOn.Value
end)

local FOVSlider = Tabs.Combat:AddSlider("CombatFOVVal", {
    Title = "⭕ รัศมีวงกลม FOV",
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
    Title = "👁️ แสดงวงกลม FOV",
    Default = false
})
DrawFOVToggle:OnChanged(function()
    State.DrawFOV = Options.DrawFOVOn.Value
end)

Tabs.Combat:AddSection("🔧 ปรับแต่งปืน & กระสุน")

local NoSpreadToggle = Tabs.Combat:AddToggle("NoSpreadOn", {
    Title = "🎯 ยิงตรงจุด (No Spread)",
    Default = false
})
NoSpreadToggle:OnChanged(function()
    State.NoSpread = Options.NoSpreadOn.Value
    ApplyGunMods()
end)

local NoRecoilToggle = Tabs.Combat:AddToggle("NoRecoilOn", {
    Title = "🛑 ปืนนิ่งสนิท (No Recoil)",
    Default = true
})
NoRecoilToggle:OnChanged(function()
    State.NoRecoil = Options.NoRecoilOn.Value
    ApplyGunMods()
end)

local FastBulletToggle = Tabs.Combat:AddToggle("FastBulletOn", {
    Title = "⚡ กระสุนเร็วสูง (Fast Bullet)",
    Default = false
})
FastBulletToggle:OnChanged(function()
    State.FastBullet = Options.FastBulletOn.Value
    ApplyGunMods()
end)

local FullAutoToggle = Tabs.Combat:AddToggle("FullAutoOn", {
    Title = "🔥 สวิตช์ยิงรัวออโต้ (Glock Switch Mode)",
    Description = "เปลี่ยนปืนทุกกระบอกให้ยิงรัวอัตโนมัติเท่ากับสเปก 'Glock Switch' ของเซิร์ฟเวอร์ (0.125 วิ / ~480 RPM) ปลอดภัย 100% ไม่โดนเตะ CODE: 46",
    Default = true
})
FullAutoToggle:OnChanged(function()
    State.FullAuto = Options.FullAutoOn.Value
    ApplyGunMods()
    if State.FullAuto then
        Notify("Glock Switch", "เปิดใช้งานสวิตช์ยิงรัวสเปก Glock Switch เซิร์ฟเวอร์ (~480 RPM)", "", 2.5)
    else
        Notify("Full Auto", "ปิดใช้งานสวิตช์ยิงรัว คืนค่าเดิมของปืน", "", 2)
    end
end)

local GlockSwitchSpeedSlider = Tabs.Combat:AddSlider("GlockSwitchSpeedVal", {
    Title = "⚡ ความเร็วสวิตช์ยิงรัว (Glock Switch FireRate)",
    Description = "ปรับความเร็วการยิง (0.125 วิ = Glock Switch มาตรฐานเซิร์ฟเวอร์, 0.135 วิ = ปลอดภัยพิเศษ, ล็อคขั้นต่ำ 0.120 วิ ป้องกันเตะ 46)",
    Default = 0.125,
    Min = 0.120,
    Max = 0.180,
    Rounding = 3
})
GlockSwitchSpeedSlider:OnChanged(function()
    State.GlockSwitchFireRate = Options.GlockSwitchSpeedVal.Value
    if State.FullAuto then
        ApplyGunMods()
    end
end)

local FastReloadToggle = Tabs.Combat:AddToggle("FastReloadOn", {
    Title = "⚡ รีโหลดกระสุนไว (Safe Fast Reload)",
    Description = "รีโหลดกระสุนไวขึ้นอย่างปลอดภัย โดยเร่งความเร็วแอนิเมชันและลดเวลาลง 20-25% พร้อมล็อคเวลาขั้นต่ำ 1.35 วิ ป้องกันโดนแบน CODE: 59",
    Default = false
})
FastReloadToggle:OnChanged(function()
    State.FastReload = Options.FastReloadOn.Value
    ApplyGunMods()
    if State.FastReload then
        local pct = math.floor((1 - (State.FastReloadRatio or 0.8)) * 100)
        Notify("Fast Reload", "เปิดใช้งานรีโหลดไวปลอดภัยแล้ว (เร็วขึ้น " .. pct .. "%)", "", 2.5)
    else
        Notify("Fast Reload", "คืนค่าระยะเวลารีโหลดตามปกติของปืน", "", 2)
    end
end)

local FastReloadSlider = Tabs.Combat:AddSlider("FastReloadSpeedVal", {
    Title = "⚡ ตัวคูณความเร็วรีโหลด (Reload Speed)",
    Description = "ปรับความเร็วรีโหลด (0.75x = ไวขึ้น 25%, 0.80x = ไวขึ้น 20%, 0.90x = ไวขึ้น 10%) ล็อคความปลอดภัยขั้นต่ำ 1.35 วิ",
    Default = 0.8,
    Min = 0.70,
    Max = 0.95,
    Rounding = 2
})
FastReloadSlider:OnChanged(function()
    State.FastReloadRatio = Options.FastReloadSpeedVal.Value
    if State.FastReload then
        ApplyGunMods()
    end
end)

local AutoReloadToggle = Tabs.Combat:AddToggle("AutoReloadOn", {
    Title = "🔄 รีโหลดอัตโนมัติ (Auto Reload - ปลอดภัย 100%)",
    Description = "เมื่อกระสุนในแม็กกาซีนหมด (เหลือ 0) สคริปต์จะกดปุ่ม R ให้ทันทีอย่างเป็นธรรมชาติ ปลอดภัย ไม่เสี่ยงโดนแบน",
    Default = true
})
AutoReloadToggle:OnChanged(function()
    State.AutoReload = Options.AutoReloadOn.Value
    if State.AutoReload then
        Notify("Auto Reload", "เปิดใช้งานรีโหลดกระสุนอัตโนมัติแล้ว", "", 2.5)
    else
        Notify("Auto Reload", "ปิดใช้งานรีโหลดอัตโนมัติ", "", 2)
    end
end)

Tabs.Combat:AddSection("🎯 ขยายขนาดเป้าหัว (Head Hitbox Expander)")

local HitboxToggle = Tabs.Combat:AddToggle("HitboxExpanderOn", {
    Title = "🎯 เปิดใช้งาน Hitbox หัว (Auto Headshot)",
    Description = "ขยายขนาดพาร์ต Head ของศัตรูให้ใหญ่ขึ้น กระสุน Raycast จะพุ่งชนหัว 100% ยิงตรงไหนก็ติด Headshot",
    Default = false
})
HitboxToggle:OnChanged(function()
    State.HitboxExpander = Options.HitboxExpanderOn.Value
    UpdateAllHitboxes()
    if State.HitboxExpander then
        Notify("Hitbox Expander", "เปิดขยายขนาดหัวศัตรูสำเร็จ!", "", 2.5)
    else
        Notify("Hitbox Expander", "คืนค่าขนาดหัวศัตรูปกติ", "", 2)
    end
end)

local HitboxSlider = Tabs.Combat:AddSlider("HitboxSizeVal", {
    Title = "📏 ขนาดเป้าหัวศัตรู (Hitbox Size)",
    Description = "ปรับขนาดหัวศัตรู ยิ่งใหญ่ยิ่งยิงโดนง่าย (ค่าเริ่มต้น: 6)",
    Default = 6,
    Min = 2,
    Max = 12,
    Rounding = 1
})
HitboxSlider:OnChanged(function()
    State.HitboxSize = Options.HitboxSizeVal.Value
    if State.HitboxExpander then
        UpdateAllHitboxes()
    end
end)

local HitboxShowToggle = Tabs.Combat:AddToggle("HitboxShowOn", {
    Title = "👁️ แสดงกล่องเป้าหมายสีแดง (Show Hitbox Box)",
    Description = "แสดงกล่องสีแดงนีออนโปร่งใสรอบหัวศัตรู",
    Default = true
})
HitboxShowToggle:OnChanged(function()
    State.HitboxShow = Options.HitboxShowOn.Value
    if State.HitboxExpander then
        UpdateAllHitboxes()
    end
end)




-- [แท็บ 4: ตั้งค่า]
Tabs.Settings:AddParagraph({
    Title = "⚙️ KrakenHub v1.0",
    Content = "Fluent Edition (100% Anti-Kick Bypass Pro)\nกดปุ่ม K หรือ Right Control เพื่อเปิด/ปิดหน้าต่าง"
})

Tabs.Settings:AddSection("💡 การแสดงผล & แสงสว่าง (Visuals & Lighting)")

local BoostFPSToggle = Tabs.Settings:AddToggle("BoostFPSOn", {
    Title = "⚡ เพิ่มความลื่นไหล (Ultra Boost FPS)",
    Description = "ปลดล็อค FPS, ปรับพื้นผิว Smooth Plastic, ปิดเงา/หมอก/เอฟเฟกต์ และอนุภาคทั้งหมด ให้เกมลื่นที่สุด",
    Default = false
})
BoostFPSToggle:OnChanged(function()
    State.BoostFPS = Options.BoostFPSOn.Value
    if State.BoostFPS then
        EnableBoostFPS()
        Notify("Boost FPS", "เปิดใช้งาน Ultra Boost FPS สำเร็จ (เน้นลื่นสูงสุด)", "", 3)
    else
        DisableBoostFPS()
        Notify("Boost FPS", "คืนค่ากราฟิกและปิดการทำงาน Boost FPS แล้ว", "", 2.5)
    end
end)

local FPSCapSlider = Tabs.Settings:AddSlider("FPSCapVal", {
    Title = "🎯 ล็อค FPS (FPS Cap)",
    Min = 30,
    Max = 240,
    Default = 60,
    Rounding = 0
})
FPSCapSlider:OnChanged(function()
    local targetFPS = math.clamp(math.round(Options.FPSCapVal.Value), 30, 240)
    State.TargetFPS = targetFPS
    ApplyFPSCap(targetFPS)
end)

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

Tabs.Settings:AddSection("⚙️ ปุ่มลัด & การแสดงผลเมนู (Menu Controls)")

local MenuKeybindObj = Tabs.Settings:AddKeybind("MenuToggleKeybind", {
    Title = "⌨️ ปุ่มลัดเปิด/ปิดเมนู",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        if Window and Window.SetKeybind then
            Window:SetKeybind(key)
            local keyName = (typeof(key) == "EnumItem" and key.Name) or tostring(key)
            Notify("ตั้งค่าปุ่มลัด", "เปลี่ยนปุ่มเปิด/ปิดเมนูเป็น: " .. keyName, "", 2.5)
        end
    end
})

local HideLogoToggle = Tabs.Settings:AddToggle("HideLogoOn", {
    Title = "👁️ ซ่อนโลโก้เปิดปิดสคริปต์ (Hide Toggle Logo)",
    Description = "ซ่อนปุ่มโลโก้ KrakenHub ลอยบนหน้าจอ (สามารถใช้ปุ่มลัดคีย์บอร์ดเปิด/ปิดเมนูแทน)",
    Default = false
})
HideLogoToggle:OnChanged(function()
    State.HideToggleButton = Options.HideLogoOn.Value
    if Hub.ToggleButtonGui then
        Hub.ToggleButtonGui.Enabled = not State.HideToggleButton
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
    pcall(RestoreCharacterCollisions)
    State.Fly = false
    State.ESP = false
    State.NoSpread = false
    State.NoRecoil = false
    State.FastBullet = false
    State.FastReload = false
    State.AutoReload = false
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
    ClearAllPlayerESP()
    ClearMerchantESP()
    if State.FullBright then
        RestoreLighting()
    end
    if State.BoostFPS then
        DisableBoostFPS()
    end
    ApplyFPSCap(60)
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

pcall(function()
    if Tabs.Settings and Tabs.Settings.RawTab then
        Tabs.Settings.RawTab:InsertConfigSection("Right")
    end
end)

Window:SelectTab(1)

Notify("KrakenHub v1.0", "โหลดสำเร็จ!", "กดปุ่ม K หรือ Right Ctrl เพื่อเปิด/ปิดหน้าต่าง", 4)
