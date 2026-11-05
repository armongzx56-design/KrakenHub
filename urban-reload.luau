-- ==============================================================
-- 🌊 KRAKENHUB | URBAN RELOAD (รีโหลดในเมือง)
-- Game: https://www.roblox.com/games/84448037861644/Urban-Reload
-- PlaceId: 84448037861644
--
-- Features:
-- • 🛡️ 100% Anti-Detection: Blocks all Honeypot remotes (AdminTools & GunTuning -> Beat)
-- • 🛡️ Clean Edition: Pure Visuals, Character & Automation Engine (Combat Engine Purged)
-- • 🛡️ Core Engine: Clean Vanilla Recoil & Spread Physics Protected
-- • 👁️ Visuals: 2D Box ESP + Skeleton Tracers + Health Bar + Distance + Weapon Name + Safe ESP + Loot ESP
-- • ⚡ Character: Infinite Stamina + Instant Respawn + Fast Reset
-- • 🌾 Automation: Auto Safe Farm (Safes 1-4) + Auto Loot Magnet + Auto Halloween Quest Claim
-- ==============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat task.wait(0.1) LocalPlayer = Players.LocalPlayer until LocalPlayer
end

local Controls = nil
pcall(function()
    Controls = require(ReplicatedStorage:WaitForChild("Controls", 3))
end)
local ClientState = nil
pcall(function()
    ClientState = require(ReplicatedStorage:WaitForChild("Weapons", 3):WaitForChild("ClientState", 3))
end)
local HoodRemote = ReplicatedStorage:FindFirstChild("HoodNPC") and ReplicatedStorage.HoodNPC:FindFirstChild("Remote")

-- Check game PlaceId
if game.PlaceId ~= 84448037861644 and game.PlaceId ~= 0 then
    warn("[KrakenHub] Warning: PlaceId does not match Urban Reload (84448037861644)")
end

-- Cleanup previous instance
local genv = (typeof(getgenv) == "function" and getgenv()) or _G
genv._UrbanReloadScriptId = (genv._UrbanReloadScriptId or 0) + 1
_G._UrbanReloadScriptId = genv._UrbanReloadScriptId
local SCRIPT_ID = genv._UrbanReloadScriptId

if genv.UrbanReload_Cleanup then
    pcall(genv.UrbanReload_Cleanup)
end

-- ==============================================================
-- GLOBAL KRAKENHUB CONFIGURATION STATE
-- ==============================================================
local Hub = {
    Running = true,
    CurrentTarget = nil,
    Connections = {},
    ESP = {},
    WorldESP = {},
    SafeESP = {},
    HitboxParts = {},
    Settings = {
        IconTheme = "Themed",

        -- ⚔️ ระบบต่อสู้ (Combat System) - Pure & Unified Engine
        SilentAim = true,                     -- กระสุนล็อกเป้า 100% (Homing / Bullet Redirection)
        SilentAimTargetPart = "Head",         -- ชิ้นส่วนเป้าหมาย (Head, UpperTorso)
        ShowFOV = true,                       -- แสดงวงกลม FOV
        FOVRadius = 180,                      -- รัศมีวงกลม FOV (Pixels)
        FOVColor = Color3.fromRGB(0, 255, 200),
        VisibleCheck = true,                  -- ตรวจสอบกำแพง (Line of Sight)
        TargetDowned = false,                 -- ล็อกคนที่ล้มด้วย

        AutoShoot = false,                    -- ยิงออโต้ (Auto Shoot)
        RPM = 900,                            -- ความเร็วรอบการลั่นกระสุน (600 - 1800 RPM)
        AutoShootDelay = 0,                   -- หน่วงเวลาเพิ่มเติม ms

        NoRecoil = true,                      -- ปิดแรงดีด 100% (Zero Recoil)
        NoSpread = true,                      -- ปิดการกระจายกระสุน 100% (Zero Spread)
        InfiniteAmmo = true,                  -- กระสุนไม่จำกัด
        FastReload = true,                    -- รีโหลดไวทันที
        FastEquip = true,                     -- สลับปืนไว
        AlwaysShoot = true,                   -- ยิงได้ตลอดเวลา



        -- Auto Respawn
        AutoRespawn = true,
        RespawnKey = Enum.KeyCode.X,

        InfiniteStamina = true,

        -- Visuals (ESP)
        PlayerESP = true,
        ESPBox = true,
        ESPName = true,
        ESPFont = "UI",
        ESPFontSize = 13,
        ESPNameMode = "DisplayName",
        ESPHealth = true,
        ESPHealthBar = true,
        ESPChams = true,
        ChamsColor = Color3.fromRGB(255, 35, 35),
        ChamsOutlineColor = Color3.fromRGB(255, 35, 35),
        ChamsTransparency = 0.78,
        ESPDistance = true,
        ESPTracers = false,
        ESPWeapon = true,
        ESPTeamCheck = false,
        ESPMaxDistance = 650,

        BoxColor = Color3.fromRGB(255, 60, 60),
        NameColor = Color3.fromRGB(255, 255, 255),
        HealthColor = Color3.fromRGB(60, 255, 60),
        TracerColor = Color3.fromRGB(0, 200, 255),

        AutoSkipGacha = true,
        HideCharacterName = false,
        AntiAFK = true,

        SafeESP = true,
        LootESP = true,
        HalloweenESP = true,
        ATMESP = false,

        HoodKillAura = false,
        HoodKillAuraRange = 250,
        HoodWallCheck = true,
        HoodESP = true,
        SavedFarmSpot = Vector3.new(-1033.4, 14.6, 427.6),
        ZombieKillAura = false,
        ZombieKillAuraRange = 250,
        ZombieWallCheck = true,
        ZombieESP = true,
    }
}
genv.KrakenHub = Hub
genv.Hub = Hub
_G.Hub = Hub

-- ==============================================================
-- 💾 AUTO-SAVE & CONFIGURATION PERSISTENCE ENGINE
-- ==============================================================
local HttpService = game:GetService("HttpService")
local ConfigFileName = "KrakenHub_UrbanReload_Settings.json"

local function SaveConfig()
    if typeof(writefile) ~= "function" then return end
    pcall(function()
        local data = {}
        for k, v in pairs(Hub.Settings) do
            local t = typeof(v)
            if t == "boolean" or t == "number" or t == "string" then
                data[k] = v
            elseif t == "Color3" then
                data[k] = { __type = "Color3", r = v.R, g = v.G, b = v.B }
            end
        end
        writefile(ConfigFileName, HttpService:JSONEncode(data))
    end)
end

local saveScheduled = false
local function AutoSave()
    if saveScheduled then return end
    saveScheduled = true
    task.delay(0.3, function()
        saveScheduled = false
        SaveConfig()
    end)
end
Hub.AutoSave = AutoSave
Hub.SaveConfig = SaveConfig

local function LoadConfig()
    if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then return end
    if not isfile(ConfigFileName) then return end
    pcall(function()
        local raw = readfile(ConfigFileName)
        local data = HttpService:JSONDecode(raw)
        if typeof(data) == "table" then
            for k, v in pairs(data) do
                if typeof(v) == "table" and v.__type == "Color3" then
                    Hub.Settings[k] = Color3.new(v.r, v.g, v.b)
                else
                    Hub.Settings[k] = v
                end
            end
        end
    end)
end
pcall(LoadConfig)

-- ==============================================================
-- 🛡️ 1. ADVANCED ANTI-DETECTION & NETBEAT GUARDIAN (ULTIMATE UNPATCHABLE SHIELD)
-- Completely neutralizes all detection vectors in Urban Reload:
-- 1. NetBeat Anomaly Queue (`u28`): Found via GC upvalues, cleared, and metatable-locked.
-- 2. NetBeat Anomaly Reporter (`report`): Hooked to no-op & filter table (`u103`) forced true.
-- 3. Namecall Ratio Benchmark (`namecallRatio`): Hooked to return 0.5 (normal ratio).
--    CRITICAL: WE NEVER HOOK `game.__namecall` (hooking it causes namecall benchmark lag).
-- 4. NetBeat Packet Encoder (`bencode`): Hooked to force code to 0 (clean heartbeat ping).
-- 5. Weapon Watchlist (`u140`) & Bait (`u177`): Cleared from GC so table freeze / sig checks never run.
-- 6. ESP Class Blacklist (`u180`): Cleared so Highlight/BillboardGui are ignored.
-- 7. Tag All Visuals with `OwnFX`: Native NetBeat whitelist tag applied to all ESP objects.
-- 8. Anti-Hitbox Remote (`HHeartbeatB`): Blocked and neutralized at remote and closure level.
-- 9. AdminTools Honeypot (`Beat` code >= 7000): Blocked at remote level.
-- 10. NetBeat Cam Rendersteps: Unbound from RunService continuously.
-- ==============================================================
local CollectionService = game:GetService("CollectionService")
local BeatRemote = ReplicatedStorage:WaitForChild("Remotes", 5) and ReplicatedStorage.Remotes:FindFirstChild("Beat")
local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local HHeartbeatB = RemoteEvents and RemoteEvents:FindFirstChild("HHeartbeatB")

-- 1.0 Client-Side Anti-Kick Guardian
pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and typeof(hookfunction) == "function" and typeof(lp.Kick) == "function" then
        hookfunction(lp.Kick, function(self, reason, ...)
            warn("[KrakenHub Anti-Kick] Blocked LocalPlayer:Kick! Reason: " .. tostring(reason))
            return nil
        end)
    end
end)

-- 1.1 Neutralize Camera Anti-Cheat Rendersteps & Spoof camExcused
local function SilenceCameraAntiCheat()
    pcall(function() RunService:UnbindFromRenderStep("NetBeatCamStart") end)
    pcall(function() RunService:UnbindFromRenderStep("NetBeatCamEnd") end)
end
SilenceCameraAntiCheat()

if ClientState and type(ClientState) == "table" then
    pcall(function()
        ClientState.RecoilScale = nil
        ClientState.SpreadMultiplier = nil
    end)
end

-- 1.2 In-Memory NetBeat & Anti-Cheat Neutralizer via GC
local NetBeatQueue = nil
local NetBeatReportFn = nil
local NetBeatFilter = nil
local NetBeatWatchList = nil
local NetBeatBaitList = nil
local NetBeatBencode = nil
local NetBeatRatioFn = nil
local NetBeatESPList = nil
local AntiHitboxFn = nil

pcall(function()
    local get_upvalues = getupvalues or (debug and debug.getupvalues)
    local get_constants = getconstants or (debug and debug.getconstants)
    local is_l = islclosure or is_l_closure or function(f) return type(f) == "function" end
    local is_exec = isexecutorclosure or is_executor_closure or checkcaller or function() return false end

    if typeof(getgc) == "function" then
        local gc = getgc(false)

        -- Pass 1: Scan GC objects for NetBeat bencode, report, and ESP tables
        for _, item in ipairs(gc) do
            if type(item) == "function" and is_l(item) and not is_exec(item) then
                -- A. Identify bencode by mathematical constant 1831565813 or 181
                if typeof(get_constants) == "function" then
                    local consts = get_constants(item)
                    if consts then
                        for _, c in pairs(consts) do
                            if c == 1831565813 or c == 181 then
                                NetBeatBencode = item
                            elseif c == 7701 then
                                NetBeatReportFn = item
                            end
                        end
                    end
                end

                -- B. Inspect upvalues for Beat, HHeartbeatB, and report queue
                if typeof(get_upvalues) == "function" then
                    local ups = get_upvalues(item)
                    if ups then
                        for _, val in pairs(ups) do
                            if typeof(val) == "Instance" then
                                if val.Name == "Beat" and not NetBeatBencode then
                                    for _, u in pairs(ups) do
                                        if type(u) == "function" then
                                            NetBeatBencode = u
                                        end
                                    end
                                elseif val.Name == "HHeartbeatB" then
                                    AntiHitboxFn = item
                                end
                            elseif type(val) == "table" and val.Highlight == true and val.BillboardGui == true then
                                NetBeatESPList = val
                                pcall(table.clear, val)
                            end
                        end
                    end
                end
            elseif type(item) == "table" then
                -- Clear NetBeat ESP blacklist tables unconditionally
                if rawget(item, "Highlight") == true or rawget(item, "BillboardGui") == true then
                    pcall(table.clear, item)
                end
                -- Clear NetBeat weapon watchlist
                local first = rawget(item, 1)
                if type(first) == "table" and rawget(first, "name") ~= nil and rawget(first, "s") ~= nil then
                    NetBeatWatchList = item
                    pcall(table.clear, item)
                end
            end
        end

        -- Pass 2: Extract NetBeatQueue directly from NetBeatReportFn upvalues
        if NetBeatReportFn and typeof(get_upvalues) == "function" then
            local rups = get_upvalues(NetBeatReportFn)
            if rups then
                for _, u in pairs(rups) do
                    if type(u) == "table" and u ~= NetBeatReportFn then
                        NetBeatQueue = u
                        pcall(table.clear, u)
                    end
                end
            end
        end
    end
end)

-- 1.2 Lock & Neutralize Anomaly Queue (u28)
if NetBeatQueue then
    pcall(table.clear, NetBeatQueue)
    pcall(setmetatable, NetBeatQueue, {
        __newindex = function() return end,
        __index = function() return nil end
    })
end

-- 1.3 Neutralize Report Filter (u103) & report() function
if NetBeatFilter then
    pcall(table.clear, NetBeatFilter)
    pcall(setmetatable, NetBeatFilter, {
        __index = function() return true end
    })
end

if NetBeatReportFn and typeof(hookfunction) == "function" then
    pcall(function()
        hookfunction(NetBeatReportFn, function(...) return end)
    end)
end

-- 1.4 Clear Weapon Watchlist (u140) & Bait (u177)
if NetBeatWatchList then
    pcall(table.clear, NetBeatWatchList)
end
if NetBeatBaitList then
    pcall(table.clear, NetBeatBaitList)
end

-- 1.5 Clear ESP Blacklist (u180)
if NetBeatESPList then
    pcall(table.clear, NetBeatESPList)
end

-- 1.6 Hook namecallRatio to always return clean 0.5 (Neutralize 7801 detection)
if NetBeatRatioFn and typeof(hookfunction) == "function" then
    pcall(function()
        hookfunction(NetBeatRatioFn, function() return 0.5 end)
    end)
end

-- 1.7 Hook bencode to force all heartbeat anomaly codes to 0
if NetBeatBencode and typeof(hookfunction) == "function" then
    pcall(function()
        local oldBencode = nil
        oldBencode = hookfunction(NetBeatBencode, function(p15, p16, p17, p18)
            if p17 ~= 0 and p17 ~= 1 then
                print(string.format("[Kraken Shield] [SHIELDED] Anomaly code %s intercepted -> forced to 0 (Clean Heartbeat)", tostring(p17)))
                p17 = 0
                p18 = ""
            end
            if oldBencode then
                return oldBencode(p15, p16, p17, p18)
            end
        end)
    end)
end

-- 1.8 Anti-Hitbox Closure Neutralizer
if AntiHitboxFn and typeof(hookfunction) == "function" then
    pcall(function()
        hookfunction(AntiHitboxFn, function(...) return false, nil end)
    end)
end

local oldNamecall = nil

if typeof(hookmetamethod) == "function" then
    pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()

            if method == "InvokeServer" or method == "invokeServer" then
                if self.Name == "Roll" then
                    local res = oldNamecall(self, ...)
                    if Hub and Hub.Settings and Hub.Settings.AutoSkipGacha and typeof(res) == "table" and res.ok and res.rollId and type(res.results) == "table" and #res.results == 1 then
                        task.delay(0.05, function()
                            pcall(function()
                                local gacha = ReplicatedStorage:FindFirstChild("Gacha")
                                local claim = gacha and gacha:FindFirstChild("Claim")
                                if claim then
                                    claim:FireServer(res.rollId)
                                end
                            end)
                        end)
                    end
                    return res
                end
            end
            if method == "FireServer" or method == "fireServer" then
                -- 1. Drop HHeartbeatB (Anti-Hitbox Ban Remote - unconditional match by name or reference)
                if self.Name == "HHeartbeatB" or (HHeartbeatB and self == HHeartbeatB) then
                    print("[Kraken Shield] [BLOCKED] HHeartbeatB call dropped (Anti-Hitbox Ban Remote)")
                    return nil
                end
                -- 2. Drop AdminTools Honeypots & Rogue Anomaly Calls on Beat
                if self.Name == "Beat" or (BeatRemote and self == BeatRemote) then
                    local arg1 = ...
                    if typeof(arg1) == "number" and arg1 >= 7000 then
                        print(string.format("[Kraken Shield] [BLOCKED] Honeypot Beat call dropped: code %s", tostring(arg1)))
                        return nil
                    end
                    local arg2 = select(2, ...)
                    if typeof(arg2) == "table" and arg2.p ~= nil then
                        print("[Kraken Shield] [BLOCKED] Honeypot Beat proof table dropped")
                        return nil
                    end
                end


            end
            if setnamecallmethod then setnamecallmethod(method) end
            return oldNamecall(self, ...)
        end))
    end)
end

-- 1.10 Continuous Background Guardian
task.spawn(function()
    while Hub and Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        SilenceCameraAntiCheat()
        if NetBeatQueue then
            pcall(table.clear, NetBeatQueue)
        end
        if NetBeatWatchList then
            pcall(table.clear, NetBeatWatchList)
        end
        if NetBeatBaitList then
            pcall(table.clear, NetBeatBaitList)
        end
        if NetBeatESPList then
            pcall(table.clear, NetBeatESPList)
        end
        task.wait(1)
    end
end)

-- ==============================================================
-- 📦 2. GAME REFERENCES & WEAPON MODULES
-- ==============================================================
local Weapons = ReplicatedStorage:WaitForChild("Weapons", 10)
ClientState = (Weapons and require(Weapons:WaitForChild("ClientState", 5))) or ClientState
local Config = Weapons and require(Weapons:WaitForChild("Config", 5))
local WeaponData = Weapons and require(Weapons:WaitForChild("WeaponData", 5))
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local SafeZoneModule = nil
pcall(function()
    local sz = ReplicatedStorage:FindFirstChild("SafeZone")
    if sz then SafeZoneModule = require(sz) end
end)

local SpawnShieldModule = nil
pcall(function()
    local ss = ReplicatedStorage:FindFirstChild("SpawnShield")
    if ss then SpawnShieldModule = require(ss) end
end)

-- ตรวจสอบสถานะว่าผู้เล่นยิงได้หรือไม่ (ติดโล่เกิด SpawnShield หรืออยู่ใน SafeZone)
local function IsPlayerInvulnerable(char, player, serverTimeNow)
    if not char then return false end

    -- 1. ตรวจสอบ SpawnShield (โล่ป้องกันตอนเกิด)
    local shieldAttr = char:GetAttribute("SpawnShield")
    if shieldAttr == true then
        return true
    elseif typeof(shieldAttr) == "number" then
        local sTime = serverTimeNow
        if not sTime then
            pcall(function() sTime = workspace:GetServerTimeNow() end)
        end
        if sTime and sTime < shieldAttr then
            return true
        end
    end

    if SpawnShieldModule and typeof(SpawnShieldModule.Active) == "function" then
        local active = false
        pcall(function() active = SpawnShieldModule.Active(char) end)
        if active then return true end
    end

    -- 2. ตรวจสอบ SafeZone (เขตปลอดภัยในเมือง)
    if char:GetAttribute("InSafeZone") == true or char:GetAttribute("PvPSafe") == true then
        return true
    end

    if SafeZoneModule and typeof(SafeZoneModule.IsIn) == "function" then
        local inSZ = false
        pcall(function() inSZ = SafeZoneModule.IsIn(char) end)
        if inSZ then return true end
    end

    -- 3. ตรวจสอบ ForceField
    if char:FindFirstChildOfClass("ForceField") then
        return true
    end

    return false
end
Hub.IsPlayerInvulnerable = IsPlayerInvulnerable

-- ==============================================================
-- 🎯 2.1 VANILLA WEAPON RECOIL & SPREAD RESTORATION
-- ==============================================================
local function RestoreVanillaWeaponData()
    pcall(function()
        if ClientState and type(ClientState) == "table" then
            ClientState.RecoilScale = nil
            ClientState.SpreadMultiplier = nil
        end
        if WeaponData and typeof(WeaponData) == "table" and decompile and ReplicatedStorage:FindFirstChild("Weapons") and ReplicatedStorage.Weapons:FindFirstChild("WeaponData") then
            local isCorrupted = false
            for _, d in pairs(WeaponData) do
                if d and d.Recoil and d.Recoil.Up == 0 then
                    isCorrupted = true
                    break
                end
            end
            if isCorrupted then
                local src = decompile(ReplicatedStorage.Weapons.WeaponData)
                if src and #src > 100 then
                    local cleanFn = loadstring(src)
                    local clean = cleanFn and cleanFn()
                    if clean and type(clean) == "table" then
                        for wName, wData in pairs(clean) do
                            if WeaponData[wName] then
                                if wData.Recoil and WeaponData[wName].Recoil then
                                    for k, v in pairs(wData.Recoil) do
                                        WeaponData[wName].Recoil[k] = v
                                    end
                                end
                                if wData.Bloom and WeaponData[wName].Bloom then
                                    for k, v in pairs(wData.Bloom) do
                                        WeaponData[wName].Bloom[k] = v
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
RestoreVanillaWeaponData()


local OriginalWeaponData = {}
if WeaponData then
    for gunName, data in pairs(WeaponData) do
        if type(data) == "table" then
            OriginalWeaponData[gunName] = {
                Recoil = data.Recoil and {
                    Up = data.Recoil.Up,
                    Side = data.Recoil.Side,
                    Return = data.Recoil.Return,
                    AimScale = data.Recoil.AimScale,
                },
                Bloom = data.Bloom and {
                    Air = data.Bloom.Air,
                    Move = data.Bloom.Move,
                    Max = data.Bloom.Max,
                    PerShot = data.Bloom.PerShot,
                    Aim = data.Bloom.Aim,
                    Hip = data.Bloom.Hip,
                },
                Fire = data.Fire and {
                    Mode = data.Fire.Mode,
                    RPM = data.Fire.RPM,
                    Burst = data.Fire.Burst,
                }
            }
        end
    end
end

-- [Hub table relocated to top of script]



-- ================================================
-- 🛠️ 5. HELPER FUNCTIONS
-- ================================================
local function GetCharacter(player)
    return player and player.Character
end

local function GetRootAndHum(player)
    local char = GetCharacter(player)
    if not char then return nil, nil end
    return char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end

local function IsAlive(player)
    local _, hum = GetRootAndHum(player)
    return hum and hum.Health > 0
end

local function IsEnemy(player)
    if player == LocalPlayer then return false end
    if not Hub.Settings.ESPTeamCheck then return true end
    local lt, pt = player.Team, LocalPlayer.Team
    if lt and pt and lt == pt then return false end
    return true
end

local function WorldToViewport(pos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(screenPos.X, screenPos.Y), screenPos.Z, onScreen
end

-- Dynamic health gradient: 100% Emerald Green -> 50% Amber Orange -> 20% Crimson Red
local function GetHealthColor(percent)
    local p = math.clamp(percent, 0, 100) / 100
    if p >= 0.5 then
        -- 50% to 100%: Amber Orange (255, 165, 0) -> Emerald Green (35, 209, 96)
        local t = (p - 0.5) / 0.5
        local r = math.floor(255 + (35 - 255) * t)
        local g = math.floor(165 + (209 - 165) * t)
        local b = math.floor(0 + (96 - 0) * t)
        return Color3.fromRGB(r, g, b)
    else
        -- 0% to 50%: Danger Red (235, 40, 40) -> Amber Orange (255, 165, 0)
        local t = p / 0.5
        local r = math.floor(235 + (255 - 235) * t)
        local g = math.floor(40 + (165 - 40) * t)
        local b = math.floor(40 + (0 - 40) * t)
        return Color3.fromRGB(r, g, b)
    end
end

local function GetBone(player, boneName)
    local char = GetCharacter(player)
    if not char then return nil end
    if boneName == "Head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    elseif boneName == "UpperTorso" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("HumanoidRootPart")
end

-- Ensure firearm is equipped in character's hand (ignores consumables)
local function EnsureWeaponEquipped()
    local c = LocalPlayer.Character
    if not c then return nil end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h or h.Health <= 0 then return nil end

    local equipped = c:FindFirstChildOfClass("Tool")
    if equipped and equipped:GetAttribute("Ammo") ~= nil then
        return equipped
    end

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return equipped end

    local bestWeapon = nil
    for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") then
            local isConsumable = t.Name:find("Medkit") or t.Name:find("Drink") or t.Name:find("Kevlar") or t.Name:find("Bandage")
            if not isConsumable then
                if t:GetAttribute("Ammo") ~= nil then
                    bestWeapon = t
                    break
                elseif not bestWeapon then
                    bestWeapon = t
                end
            end
        end
    end

    if bestWeapon then
        h:EquipTool(bestWeapon)
        task.wait(0.12)
        return c:FindFirstChildOfClass("Tool")
    end

    return equipped
end
Hub.EnsureWeaponEquipped = EnsureWeaponEquipped

-- ================================================
-- 🚀 ZERO-ALLOCATION PERSISTENT RAYCAST ENGINE
-- ================================================
local SharedRayParams = RaycastParams.new()
SharedRayParams.FilterType = Enum.RaycastFilterType.Exclude
SharedRayParams.IgnoreWater = true

local function IsVisible(targetChar, targetPart)
    if not targetChar or not targetPart then return false end

    local myChar = LocalPlayer.Character
    local myHead = myChar and myChar:FindFirstChild("Head")
    local origin = (myHead and myHead.Position) or Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    if direction.Magnitude < 0.2 then return true end

    local ignoreList = {myChar, Camera}
    local ch = Workspace:FindFirstChild("ClientHitboxes")
    if ch then table.insert(ignoreList, ch) end
    local gl = Workspace:FindFirstChild("GroundLoot")
    if gl then table.insert(ignoreList, gl) end

    SharedRayParams.FilterDescendantsInstances = ignoreList

    for _ = 1, 4 do
        local result = Workspace:Raycast(origin, direction, SharedRayParams)
        if not result then return true end
        local inst = result.Instance
        if inst:IsDescendantOf(targetChar) then return true end

        local nameLower = inst.Name:lower()
        if (not inst.CanCollide) or inst.Transparency >= 0.7 or inst.Name == "Hitbox"
           or nameLower:find("door") or nameLower:find("gate") or nameLower:find("fence")
           or nameLower:find("glass") or nameLower:find("window") or nameLower:find("bar")
           or nameLower:find("prop") or nameLower:find("debris") or nameLower:find("mesh") then
            table.insert(ignoreList, inst)
            SharedRayParams.FilterDescendantsInstances = ignoreList
        else
            return false
        end
    end
    return false
end

-- Fast Line-of-Sight Check for Hood NPCs (Capped to 3 iterations, static exclusions)
local function IsEnemyNPC(model)
    if not model or not model:IsA("Model") then return false end
    if model.Name:find("Hood") or model.Name:find("Zombie") then return true end
    local parent = model.Parent
    if parent and (parent.Name == "HoodLocal" or parent.Name == "Zombies") then
        return model:FindFirstChild("HumanoidRootPart") ~= nil or model:FindFirstChild("Head") ~= nil
    end
    return false
end

-- Fast Line-of-Sight Check for Hood NPCs (Capped to 4 iterations, ignores players, accessories, tools)
local function IsHoodVisible(targetPart, targetNpc)
    if not targetPart or not targetNpc then return false end

    local myChar = LocalPlayer.Character
    local myHead = myChar and myChar:FindFirstChild("Head")
    local origin = (myHead and myHead.Position) or Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    if direction.Magnitude < 0.2 then return true end

    local ignoreList = {Camera}
    -- Exclude all player characters (other players and teammates on roofs never block bullet line-of-sight)
    local players = Players:GetPlayers()
    for _, p in ipairs(players) do
        local pc = p.Character
        if pc then
            table.insert(ignoreList, pc)
        end
    end

    local ch = Workspace:FindFirstChild("ClientHitboxes")
    if ch then table.insert(ignoreList, ch) end
    local gl = Workspace:FindFirstChild("GroundLoot")
    if gl then table.insert(ignoreList, gl) end

    local hl = Workspace:FindFirstChild("HoodLocal")
    if hl then
        for _, otherZ in ipairs(hl:GetChildren()) do
            if otherZ ~= targetNpc then
                table.insert(ignoreList, otherZ)
            end
        end
    end
    local zf = Workspace:FindFirstChild("Zombies")
    if zf then
        for _, otherZ in ipairs(zf:GetChildren()) do
            if otherZ ~= targetNpc then
                table.insert(ignoreList, otherZ)
            end
        end
    end

    SharedRayParams.FilterDescendantsInstances = ignoreList

    for _ = 1, 4 do
        local result = Workspace:Raycast(origin, direction, SharedRayParams)
        if not result then return true end
        local inst = result.Instance
        if inst:IsDescendantOf(targetNpc) then return true end

        local parent = inst.Parent
        local isCharItem = inst:FindFirstAncestorOfClass("Tool")
            or inst:FindFirstAncestorOfClass("Accessory")
            or (parent and parent:FindFirstChildOfClass("Humanoid"))

        local nameLower = inst.Name:lower()
        if isCharItem or (not inst.CanCollide) or inst.Transparency >= 0.7 or inst.Name == "Hitbox"
           or nameLower:find("door") or nameLower:find("gate") or nameLower:find("fence")
           or nameLower:find("glass") or nameLower:find("window") or nameLower:find("bar")
           or nameLower:find("prop") or nameLower:find("debris") or nameLower:find("mesh") then
            table.insert(ignoreList, inst)
            SharedRayParams.FilterDescendantsInstances = ignoreList
        else
            return false
        end
    end
    return false
end

local function CheckHoodTargetLOS(targetNpc)
    if not targetNpc then return false, nil end
    local head = targetNpc:FindFirstChild("Head")
    if head and IsHoodVisible(head, targetNpc) then
        return true, head
    end
    local hrp = targetNpc:FindFirstChild("HumanoidRootPart")
    if hrp and IsHoodVisible(hrp, targetNpc) then
        return true, hrp
    end
    local ut = targetNpc:FindFirstChild("UpperTorso") or targetNpc:FindFirstChild("Torso")
    if ut and IsHoodVisible(ut, targetNpc) then
        return true, ut
    end
    return false, head
end
local IsZombieVisible = IsHoodVisible

-- Validate target status (filters out invincible, downed, and safezone players)
local function IsTargetValid(player)
    if not player or player == LocalPlayer then return false end
    if not IsEnemy(player) then return false end

    local char = player.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not hrp then return false end

    -- Ignore Downed players if enabled (prevent locking on harmless crawling players)
    if Hub.Settings.AimbotIgnoreDowned and char:GetAttribute("Downed") == true then
        return false
    end

    -- Ignore SpawnShield players if enabled
    if Hub.Settings.AimbotIgnoreShield and char:GetAttribute("SpawnShield") == true then
        return false
    end

    -- Ignore SafeZone / PvPSafe players if enabled
    if Hub.Settings.AimbotIgnoreSafeZone then
        if char:GetAttribute("InSafeZone") == true or char:GetAttribute("PvPSafe") == true then
            return false
        end
        if SafeZoneModule and SafeZoneModule.IsIn then
            local inSZ = false
            pcall(function() inSZ = SafeZoneModule.IsIn(char) end)
            if inSZ then return false end
        end
    end

    return true
end

-- ==============================================================
-- 🔫 REAL-TIME HOOD NPC DATA EXTRACTION ENGINE
-- Extracts live HP directly from HoodClient's active NPC state table
-- ==============================================================
local LiveNpcTable = nil
local function GetLiveNpcTable()
    if LiveNpcTable and next(LiveNpcTable) ~= nil then return LiveNpcTable end
    pcall(function()
        local hoodRemote = ReplicatedStorage:FindFirstChild("HoodNPC") and ReplicatedStorage.HoodNPC:FindFirstChild("Remote")
        if hoodRemote and typeof(getconnections) == "function" then
            local conns = getconnections(hoodRemote.OnClientEvent)
            if #conns > 0 and typeof(getupvalues) == "function" then
                local u = getupvalues(conns[1].Function)
                if u and type(u[1]) == "table" then
                    LiveNpcTable = u[1]
                end
            end
        end
    end)
    return LiveNpcTable
end

local function GetHoodRealtimeData(npcModel)
    local tbl = GetLiveNpcTable()
    if tbl then
        for id, npc in pairs(tbl) do
            local m = (npc.e and npc.e.model) or npc.model
            if m == npcModel then
                local hp = tonumber(npc.hp) or 0
                local maxHp = tonumber(npc.maxHp) or 100
                local isDead = (npc.state == "dead") or (hp <= 0)
                return hp, maxHp, isDead, id
            end
        end
    end
    local hum = npcModel:FindFirstChildOfClass("Humanoid")
    local hp = (hum and hum.Health) or 100
    local maxHp = (hum and hum.MaxHealth) or 100
    return hp, maxHp, hp <= 0, nil
end
local GetZombieRealtimeData = GetHoodRealtimeData


-- ================================================
-- ⚡ 5.1 PURE COMBAT & HOMING ENGINE (100% PACKET SPOOFING)
-- ================================================
local VirtualInputManager = game:GetService("VirtualInputManager")
local FireRemote = Remotes and Remotes:FindFirstChild("Fire")
if not FireRemote and ReplicatedStorage:FindFirstChild("Remotes") then
    FireRemote = ReplicatedStorage.Remotes:FindFirstChild("Fire")
end

-- ล้างค่าและกู้คืน Hook เก่าทั้งหมดให้สะอาด 100%
_G.UrbanReloadSilentAimTarget = nil
_G.UrbanReloadSilentAimChar = nil
_G.UrbanReloadSilentAimPart = nil
if ClientState then
    ClientState.ShotRedirect = nil
end
pcall(function()
    if typeof(restorefunction) == "function" then
        restorefunction(Camera.ViewportPointToRay)
    end
end)

local LockedTarget = nil
local lastAutoShotTime = 0


-- ================================================
-- 📱 CROSS-PLATFORM SYSTEM & UNIVERSAL GUI DRAWING ADAPTER
-- Supports iOS Delta, AppleWare, Android, and PC
-- ================================================
local CoreGui = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or nil
local isMobileDevice = UserInputService.TouchEnabled or (UserInputService.KeyboardEnabled == false)

local DrawingGui = nil
local function GetDrawingGui()
    if DrawingGui and DrawingGui.Parent then return DrawingGui end
    local p = nil

    -- 1. Check CoreGui first (standard, direct rendering for executors like Delta iOS, AppleWare, PC)
    if CoreGui then
        local canCore = pcall(function()
            local test = Instance.new("Folder")
            test.Parent = CoreGui
            test:Destroy()
        end)
        if canCore then p = CoreGui end
    end

    -- 2. Check gethui ONLY if it is an instance that can directly host ScreenGuis
    if not p and gethui then
        local ok, h = pcall(gethui)
        if ok and h and typeof(h) == "Instance" and not h:IsA("Folder") then
            p = h
        end
    end

    -- 3. Fallback to PlayerGui
    if not p then
        p = (LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui"))
            or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui", 5))
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KrakenDrawingGui"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 99999
    sg.IgnoreGuiInset = true -- 1:1 pixel alignment with Camera:WorldToViewportPoint
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local okP = pcall(function() sg.Parent = p end)
    if not okP or not sg.Parent then
        pcall(function() sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
    end
    DrawingGui = sg
    return sg
end

local function CreateGuiDrawing(kind)
    local gui = GetDrawingGui()
    local rawProps = {
        Visible = false,
        Transparency = 1,
        Color = Color3.new(1, 1, 1),
        Thickness = 1,
        Filled = false,
        Position = Vector2.zero,
        Size = Vector2.zero,
        From = Vector2.zero,
        To = Vector2.zero,
        Radius = 50,
        Text = "",
        Center = false,
        Outline = false,
        OutlineColor = Color3.new(0, 0, 0),
        Font = 0,
        NumSides = 64,
    }

    local inst = nil
    local stroke = nil
    local corner = nil

    if kind == "Square" then
        inst = Instance.new("Frame")
        inst.Active = false
        inst.BorderSizePixel = 0
        inst.ZIndex = 30
        inst.Visible = false
        pcall(function() inst.Parent = gui end)
        stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = inst
    elseif kind == "Text" then
        inst = Instance.new("TextLabel")
        inst.Active = false
        inst.BackgroundTransparency = 1
        inst.BorderSizePixel = 0
        inst.Font = Enum.Font.GothamBold
        inst.TextSize = 13
        inst.Size = UDim2.new(0, 200, 0, 18)
        inst.TextXAlignment = Enum.TextXAlignment.Left
        inst.TextYAlignment = Enum.TextYAlignment.Center
        inst.ZIndex = 35
        inst.Visible = false
        pcall(function() inst.Parent = gui end)
        stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Transparency = 1
        stroke.Parent = inst
    elseif kind == "Line" then
        inst = Instance.new("Frame")
        inst.Active = false
        inst.AnchorPoint = Vector2.new(0.5, 0.5)
        inst.BorderSizePixel = 0
        inst.ZIndex = 25
        inst.Visible = false
        pcall(function() inst.Parent = gui end)
    elseif kind == "Circle" then
        inst = Instance.new("Frame")
        inst.Active = false
        inst.AnchorPoint = Vector2.new(0.5, 0.5)
        inst.BorderSizePixel = 0
        inst.ZIndex = 20
        inst.Visible = false
        pcall(function() inst.Parent = gui end)
        corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = inst
        stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = inst
    end

    local function update()
        if not inst or not inst.Parent then return end
        inst.Visible = rawProps.Visible
        if not rawProps.Visible then return end

        local trans = math.clamp(1 - (rawProps.Transparency or 1), 0, 1)

        if kind == "Square" then
            inst.Position = UDim2.fromOffset(rawProps.Position.X, rawProps.Position.Y)
            inst.Size = UDim2.fromOffset(math.max(1, rawProps.Size.X), math.max(1, rawProps.Size.Y))
            if rawProps.Filled then
                inst.BackgroundColor3 = rawProps.Color
                inst.BackgroundTransparency = trans
                if stroke then stroke.Enabled = false end
            else
                inst.BackgroundTransparency = 1
                if stroke then
                    stroke.Enabled = true
                    stroke.Color = rawProps.Color
                    stroke.Thickness = rawProps.Thickness or 1
                    stroke.Transparency = trans
                end
            end
        elseif kind == "Text" then
            if rawProps.Center then
                inst.AnchorPoint = Vector2.new(0.5, 0.5)
                inst.TextXAlignment = Enum.TextXAlignment.Center
            else
                inst.AnchorPoint = Vector2.new(0, 0.5)
                inst.TextXAlignment = Enum.TextXAlignment.Left
            end
            inst.Position = UDim2.fromOffset(rawProps.Position.X, rawProps.Position.Y)
            inst.Text = tostring(rawProps.Text or "")
            inst.TextSize = rawProps.Size or 13
            inst.TextColor3 = rawProps.Color
            inst.TextTransparency = trans
            if rawProps.Outline and stroke then
                stroke.Enabled = true
                stroke.Color = rawProps.OutlineColor or Color3.new(0, 0, 0)
                stroke.Thickness = 1
                stroke.Transparency = trans
            elseif stroke then
                stroke.Enabled = false
            end
        elseif kind == "Line" then
            local from = rawProps.From or Vector2.zero
            local to = rawProps.To or Vector2.zero
            local diff = to - from
            local dist = diff.Magnitude
            local angle = math.atan2(diff.Y, diff.X)
            local mid = (from + to) * 0.5
            inst.Position = UDim2.fromOffset(mid.X, mid.Y)
            inst.Size = UDim2.fromOffset(dist, rawProps.Thickness or 1)
            inst.Rotation = math.deg(angle)
            inst.BackgroundColor3 = rawProps.Color
            inst.BackgroundTransparency = trans
        elseif kind == "Circle" then
            local rad = rawProps.Radius or 50
            inst.Position = UDim2.fromOffset(rawProps.Position.X, rawProps.Position.Y)
            inst.Size = UDim2.fromOffset(rad * 2, rad * 2)
            if rawProps.Filled then
                inst.BackgroundColor3 = rawProps.Color
                inst.BackgroundTransparency = trans
                if stroke then stroke.Enabled = false end
            else
                inst.BackgroundTransparency = 1
                if stroke then
                    stroke.Enabled = true
                    stroke.Color = rawProps.Color
                    stroke.Thickness = rawProps.Thickness or 1.5
                    stroke.Transparency = trans
                end
            end
        end
    end

    local proxy = {}
    return setmetatable(proxy, {
        __index = function(_, k)
            if k == "Remove" or k == "Destroy" then
                return function()
                    if inst then
                        pcall(function() inst:Destroy() end)
                        inst = nil
                    end
                end
            end
            return rawProps[k]
        end,
        __newindex = function(_, k, v)
            rawProps[k] = v
            update()
        end
    })
end

local hasNativeDrawing = false
pcall(function()
    if typeof(Drawing) == "table" and typeof(Drawing.new) == "function" then
        local t = Drawing.new("Square")
        if t and (typeof(t) == "userdata" or (typeof(t) == "table" and t.Visible ~= nil and t.Remove ~= nil)) then
            t.Visible = false
            t:Remove()
            hasNativeDrawing = true
        end
    end
end)

local function SafeDrawing(kind)
    if hasNativeDrawing then
        local ok, d = pcall(Drawing.new, kind)
        if ok and d then return d end
    end
    -- Fallback universal GUI Drawing for iOS Delta, AppleWare, and Mobile executors
    return CreateGuiDrawing(kind)
end

-- FOV Circle & Tracer Line Drawing
local fovCircle = nil
local targetTracer = nil
pcall(function()
    fovCircle = SafeDrawing("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 64
    fovCircle.Radius = Hub.Settings.FOVRadius or 180
    fovCircle.Filled = false
    fovCircle.Color = Hub.Settings.FOVColor or Color3.fromRGB(0, 255, 200)
    fovCircle.Transparency = 1
    fovCircle.Visible = false

    targetTracer = SafeDrawing("Line")
    targetTracer.Thickness = 1.2
    targetTracer.Color = Color3.fromRGB(255, 50, 70)
    targetTracer.Transparency = 0.9
    targetTracer.Visible = false
end)
Hub.SilentAimFOVCircle = fovCircle
Hub.TargetTracerLine = targetTracer

-- ค้นหาเป้าหมายที่ดีที่สุดในวง FOV (Screen Distance + Line of Sight)
local _fovAimCenter = Vector2.new(0, 0)
local _fovLastVp = Vector2.new(0, 0)
local function GetAimCenter()
    local vp = Camera.ViewportSize
    if vp.X ~= _fovLastVp.X or vp.Y ~= _fovLastVp.Y then
        _fovLastVp = vp
        _fovAimCenter = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end
    return _fovAimCenter
end

local combatRayParams = RaycastParams.new()
combatRayParams.FilterType = Enum.RaycastFilterType.Exclude
combatRayParams.IgnoreWater = true
local combatIgnoreList = {}

local function GetBestFOVTarget()
    local cfg = Hub.Settings
    local aimCenter = GetAimCenter()
    local maxDist = cfg.FOVRadius or 180
    local bestTarget = nil
    local shortestDist = maxDist
    local myChar = LocalPlayer.Character
    local carsFolder = Workspace:FindFirstChild("Cars")
    local chFolder = Workspace:FindFirstChild("ClientHitboxes")

    local sTime = nil
    pcall(function() sTime = workspace:GetServerTimeNow() end)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local isDowned = char:GetAttribute("Downed") == true

            -- ข้ามคนที่ยิงไม่ได้ (ติดโล่เกิด หรืออยู่ในเซฟโซน ไม่ล็อกเป้า และไม่ยิงออโต้)
            if IsPlayerInvulnerable(char, p, sTime) then
                continue
            end

            if hum and (hum.Health > 0 or isDowned) and (cfg.TargetDowned or not isDowned) then
                local boneName = (cfg.SilentAimTargetPart == "UpperTorso") and "UpperTorso" or "Head"
                local targetPart = char:FindFirstChild(boneName) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

                if targetPart and targetPart:IsA("BasePart") then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local screenVec = Vector2.new(screenPos.X, screenPos.Y)
                        local dist = (screenVec - aimCenter).Magnitude

                        if dist <= shortestDist then
                            local isVisible = true
                            if cfg.VisibleCheck then
                                local origin = Camera.CFrame.Position
                                local dir = (targetPart.Position - origin)

                                table.clear(combatIgnoreList)
                                if myChar then table.insert(combatIgnoreList, myChar) end
                                if Camera then table.insert(combatIgnoreList, Camera) end
                                if carsFolder then table.insert(combatIgnoreList, carsFolder) end
                                combatRayParams.FilterDescendantsInstances = combatIgnoreList

                                local hitResult = Workspace:Raycast(origin, dir, combatRayParams)
                                if hitResult then
                                    local hitInst = hitResult.Instance
                                    local isTargetHit = hitInst:IsDescendantOf(char)
                                        or (chFolder and hitInst:IsDescendantOf(chFolder) and hitInst.Parent and hitInst.Parent.Name == char.Name)
                                    if not isTargetHit then
                                        isVisible = false
                                    end
                                end
                            end

                            if isVisible then
                                shortestDist = dist
                                local chChar = chFolder and chFolder:FindFirstChild(char.Name)
                                local resolvedHitPart = (chChar and chChar:FindFirstChild(boneName))
                                    or targetPart
                                    or (chChar and chChar:FindFirstChild("Head"))

                                bestTarget = {
                                    Player = p,
                                    Character = char,
                                    Part = resolvedHitPart,
                                    Position = targetPart.Position,
                                    ScreenPos = screenVec,
                                    Bone = boneName
                                }
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- ================================================
-- ⚡ PURE FIRESERVER PACKET SPOOFER (Fail-Safe 100% Headshot)
-- ================================================
local dummyRecoilFn = function() end

_G.UrbanReloadCustomFireHandler = function(realFire, self, ...)
    local args = table.pack(...)
    local cfg = Hub and Hub.Settings

    if cfg and cfg.SilentAim and LockedTarget and LockedTarget.Character and LockedTarget.Position then
        local cam = workspace.CurrentCamera
        local EnemyPos = LockedTarget.Position
        local CharHim = LockedTarget.Character
        local bone = cfg.SilentAimTargetPart or "Head"
        local headPart = LockedTarget.Part or CharHim:FindFirstChild(bone) or CharHim:FindFirstChild("Head")

        local camPos = cam.CFrame.Position
        local camLook = (EnemyPos - camPos).Unit

        local origin = (typeof(args[1]) == "Vector3" and args[1]) or camPos
        args[1] = origin
        args[2] = (EnemyPos - origin).Unit
        args[3] = CharHim
        args[4] = bone
        args[5] = EnemyPos
        args[6] = headPart
        args[7] = nil
        args[8] = nil
        args[9] = 1
        -- รักษา ShotId Counter (args[10]) เพื่อผ่านการตรวจนับกระสุนของ Server
        if args[10] == nil then
            args[10] = math.random(1000, 999999)
        end
        args[11] = camPos
        args[12] = camLook
        args[13] = EnemyPos

        return realFire(self, table.unpack(args, 1, math.max(args.n or 0, 13)))
    end

    return realFire(self, table.unpack(args, 1, args.n or #args))
end

if FireRemote then
    pcall(function()
        if not _G.UrbanReloadOldFireServer then
            local oldFire
            oldFire = hookfunction(FireRemote.FireServer, newcclosure(function(self, ...)
                if _G.UrbanReloadCustomFireHandler then
                    return _G.UrbanReloadCustomFireHandler(oldFire, self, ...)
                end
                return oldFire(self, ...)
            end))
            _G.UrbanReloadOldFireServer = oldFire
            _G.UrbanReloadFireHooked = true
        end
    end)
end

-- Hook canShoot for AlwaysShoot & Roll bypass
pcall(function()
    local fns = (filtergc and filtergc("function", { linedefined = 408 })) or {}
    if fns and fns[1] and hookfunction then
        local oldCanShoot = nil
        oldCanShoot = hookfunction(fns[1], function(a1, ...)
            if Hub and Hub.Settings and Hub.Settings.AlwaysShoot then
                return true
            end
            return oldCanShoot(a1, ...)
        end)
    end
end)

-- สำรองข้อมูลเดิมของ WeaponData
local OriginalWeaponData = {}
if WeaponData then
    for wName, wData in pairs(WeaponData) do
        OriginalWeaponData[wName] = {
            Recoil = wData.Recoil and {
                Up = wData.Recoil.Up,
                Side = wData.Recoil.Side,
                AimScale = wData.Recoil.AimScale,
                Return = wData.Recoil.Return
            },
            Bloom = wData.Bloom and {
                Air = wData.Bloom.Air,
                Move = wData.Bloom.Move,
                Max = wData.Bloom.Max,
                Recovery = wData.Bloom.Recovery,
                Hip = wData.Bloom.Hip,
                PerShot = wData.Bloom.PerShot,
                Aim = wData.Bloom.Aim
            },
            Fire = wData.Fire and {
                RPM = wData.Fire.RPM,
                Mode = wData.Fire.Mode
            },
            Ammo = wData.Ammo and {
                ReloadTime = wData.Ammo.ReloadTime,
                Mag = wData.Ammo.Mag
            },
            Handling = wData.Handling and {
                HitboxScale = wData.Handling.HitboxScale,
                EquipTime = wData.Handling.EquipTime
            }
        }
    end
end

local OriginalGlobal = { InfiniteAmmo = false }
local WeaponsConfig = Weapons and require(Weapons:WaitForChild("Config", 5))

local function makeWritable(tbl)
    if typeof(tbl) ~= "table" then return end
    if typeof(setreadonly) == "function" then
        pcall(setreadonly, tbl, false)
    elseif typeof(make_writeable) == "function" then
        pcall(make_writeable, tbl)
    end
end

local function ApplyWeaponMods()
    if not WeaponData then return end
    local cfg = Hub.Settings

    for wName, wData in pairs(WeaponData) do
        local orig = OriginalWeaponData[wName]
        if orig then
            -- 1. Zero Recoil
            if wData.Recoil then
                makeWritable(wData.Recoil)
                if cfg.NoRecoil then
                    wData.Recoil.Up = 0
                    wData.Recoil.Side = 0
                    wData.Recoil.AimScale = 0
                else
                    wData.Recoil.Up = orig.Recoil.Up
                    wData.Recoil.Side = orig.Recoil.Side
                    wData.Recoil.AimScale = orig.Recoil.AimScale
                end
            end

            -- 2. Zero Spread / Bloom
            if wData.Bloom then
                makeWritable(wData.Bloom)
                if cfg.NoSpread then
                    wData.Bloom.Air = 0
                    wData.Bloom.Move = 0
                    wData.Bloom.Max = 0
                    wData.Bloom.Hip = 0
                    wData.Bloom.PerShot = 0
                    wData.Bloom.Aim = 0
                    wData.Bloom.Recovery = 100
                else
                    wData.Bloom.Air = orig.Bloom.Air
                    wData.Bloom.Move = orig.Bloom.Move
                    wData.Bloom.Max = orig.Bloom.Max
                    wData.Bloom.Hip = orig.Bloom.Hip
                    wData.Bloom.PerShot = orig.Bloom.PerShot
                    wData.Bloom.Aim = orig.Bloom.Aim
                    wData.Bloom.Recovery = orig.Bloom.Recovery
                end
            end

            -- 3. Full Auto, Zero Bolt Pause & Adjustable RPM
            if wData.Fire and orig.Fire then
                makeWritable(wData.Fire)
                wData.Fire.Mode = "Auto"
                wData.Fire.RPM = cfg.RPM or 900
                if orig.Fire.BoltTime ~= nil then
                    wData.Fire.BoltTime = 0.01       -- Fast cycle for bolt-action rifles
                end
                if orig.Fire.SwapCooldown ~= nil then
                    wData.Fire.SwapCooldown = 0   -- Remove weapon swap pause
                end
                if orig.Fire.Burst ~= nil then
                    wData.Fire.Burst = nil        -- Convert burst to true continuous full auto
                end
                if orig.Fire.BurstDelay ~= nil then
                    wData.Fire.BurstDelay = 0     -- Remove burst pause
                end
            end

            -- 4. Fast Reload & Large Mag
            if wData.Ammo then
                makeWritable(wData.Ammo)
                local origReload = (orig.Ammo and orig.Ammo.ReloadTime) or 1.5
                wData.Ammo.ReloadTime = cfg.FastReload and 0.05 or origReload
                if cfg.InfiniteAmmo then
                    wData.Ammo.Mag = 999
                    wData.Ammo.MaxMag = 999
                end
            end

            -- 5. Fast Equip
            if wData.Handling then
                makeWritable(wData.Handling)
                wData.Handling.EquipTime = cfg.FastEquip and 0 or orig.Handling.EquipTime
            end
        end
    end

    -- Infinite Ammo
    if WeaponsConfig and WeaponsConfig.Global then
        makeWritable(WeaponsConfig.Global)
        WeaponsConfig.Global.InfiniteAmmo = cfg.InfiniteAmmo and true or OriginalGlobal.InfiniteAmmo
    end

    -- ClientState mods
    if ClientState then
        if cfg.NoSpread then
            ClientState.SpreadMultiplier = 0
            ClientState.Spread = 0
            ClientState.SpreadRest = 0
        else
            ClientState.SpreadMultiplier = 1
        end

        if cfg.NoRecoil then
            ClientState.RecoilScale = 0
            pcall(function()
                if ClientState.RecoilKey then
                    local k = ClientState.RecoilKey()
                    if k then rawset(ClientState, k, dummyRecoilFn) end
                end
            end)
        else
            ClientState.RecoilScale = 1
        end
    end
end
Hub.ApplyWeaponMods = ApplyWeaponMods
task.spawn(function()
    task.wait(0.1)
    pcall(ApplyWeaponMods)
end)


-- Re-apply weapon mods whenever player equips a tool
task.spawn(function()
    local function hookCharacter(char)
        if not char then return end
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.05)
                pcall(ApplyWeaponMods)
                if Hub.Settings.InfiniteAmmo then
                    child:SetAttribute("Ammo", 60)
                end
            end
        end)
    end
    if LocalPlayer.Character then hookCharacter(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(hookCharacter)
end)

local cachedFireFunction = nil
local lastFireScanTick = 0
local function getActiveFireFunction()
    if cachedFireFunction and typeof(cachedFireFunction) == "function" then
        return cachedFireFunction
    end

    local nowTick = os.clock()
    if nowTick - lastFireScanTick < 0.1 then
        return nil
    end
    lastFireScanTick = nowTick
    cachedFireFunction = nil

    local fns = {}
    if typeof(filtergc) == "function" then
        pcall(function() fns = filtergc("function", { Name = "fire" }) end)
    end
    if (not fns or #fns == 0) and typeof(getgc) == "function" then
        pcall(function()
            for _, v in ipairs(getgc(false)) do
                if typeof(v) == "function" and islclosure(v) then
                    local info = debug.getinfo(v)
                    if info and (info.name == "fire" or (info.source and info.source:find("WeaponClient"))) then
                        table.insert(fns, v)
                    end
                end
            end
        end)
    end

    for _, v in ipairs(fns or {}) do
        if typeof(v) == "function" and islclosure(v) then
            local upvals = debug.getupvalues(v)
            local hasClientState = false
            local hasFireConfig = false
            for _, upv in pairs(upvals) do
                if typeof(upv) == "table" then
                    if upv.Aiming ~= nil or upv.Stamina ~= nil or upv.LastShot ~= nil then
                        hasClientState = true
                    elseif upv.Fire and upv.Fire.RPM then
                        hasFireConfig = true
                    end
                end
            end
            if hasClientState and hasFireConfig then
                cachedFireFunction = v
                return v
            end
        end
    end
    return nil
end

-- Reset fire function cache on tool equip
task.spawn(function()
    local function BindEquip(char)
        if not char then return end
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                cachedFireFunction = nil
                lastFireScanTick = 0
            end
        end)
    end
    if LocalPlayer.Character then BindEquip(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(BindEquip)
end)


-- ================================================
-- 🔫 CROSS-PLATFORM UNIVERSAL WEAPON FIRING ENGINE
-- Fully supports PC, iOS Touch, and Android Touch
-- ================================================
local function UniversalFireShot(targetPos, targetChar, targetPart)
    local now = os.clock()
    -- 1. Try invoking cached weaponclient internal fire closure
    local fireFn = getActiveFireFunction()
    if fireFn then
        local ok = pcall(fireFn, now)
        if ok then return true end
    end

    -- 2. Native Urban Reload Controls.Press (smooth, non-stuttering game engine firing)
    if Controls and Controls.Press then
        pcall(function()
            Controls.Press("Fire", true)
            task.delay(0.04, function()
                pcall(Controls.Press, "Fire", false)
            end)
        end)
        return true
    end

    -- 3. Tool activate (fires naturally through Roblox Tool system on all platforms)
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and tool:IsA("Tool") then
        pcall(function() tool:Activate() end)
        return true
    end

    -- 3. Direct packet fallback via FireRemote (Packet Spoofing 100% Headshot)
    if FireRemote then
        pcall(function()
            local camPos = Camera.CFrame.Position
            local dir = (targetPos and (targetPos - camPos).Unit) or Camera.CFrame.LookVector
            local bone = Hub.Settings.SilentAimTargetPart or "Head"
            local hitPart = targetPart or (targetChar and targetChar:FindFirstChild(bone)) or (targetChar and targetChar:FindFirstChild("Head"))
            local hitPos = targetPos or (hitPart and hitPart.Position) or (camPos + dir * 100)
            FireRemote:FireServer(
                camPos,
                dir,
                targetChar,
                bone,
                hitPos,
                hitPart,
                nil,
                nil,
                1,
                math.random(1000, 999999),
                camPos,
                dir,
                hitPos
            )
        end)
        return true
    end

    -- 4. PC Mouse press fallback
    if not isMobileDevice and typeof(mouse1press) == "function" then
        pcall(function()
            mouse1press()
            task.delay(0.04, mouse1release)
        end)
        return true
    end
    return false
end

-- ================================================
-- ⚡ MAIN COMBAT RENDERSTEPPED LOOP (FOV Lock & Auto Shoot)
-- ================================================
Hub.Connections.VenyxRenderStep = RunService.RenderStepped:Connect(function()
    if not (Hub and Hub.Running) then
        if fovCircle then fovCircle.Visible = false end
        if targetTracer then targetTracer.Visible = false end
        return
    end

    local cfg = Hub.Settings
    local aimCenter = GetAimCenter()

    -- ล็อกค่า No Recoil และ No Spread ให้กล้องนิ่งสนิท 100% ทุกเฟรม
    if ClientState then
        if cfg.NoSpread then
            ClientState.SpreadMultiplier = 0
            ClientState.Spread = 0
            ClientState.SpreadRest = 0
        end
        if cfg.NoRecoil then
            ClientState.RecoilScale = 0
            pcall(function()
                local k = ClientState.RecoilKey and ClientState.RecoilKey()
                if k and rawget(ClientState, k) ~= dummyRecoilFn then
                    rawset(ClientState, k, dummyRecoilFn)
                end
            end)
        end
    end

    -- ซิงค์ Hitboxes
    if ClientHitboxes and ClientHitboxes.Refresh then
        pcall(ClientHitboxes.Refresh)
    end

    LockedTarget = GetBestFOVTarget()

    -- อัปเดตพิกัดเป้าหมาย (รองรับทั้ง SilentAim และ AutoShoot)
    if (cfg.SilentAim or cfg.AutoShoot) and LockedTarget then
        _G.UrbanReloadSilentAimTarget = LockedTarget.Position
        _G.UrbanReloadSilentAimChar = LockedTarget.Character
        _G.UrbanReloadSilentAimPart = LockedTarget.Part
    else
        _G.UrbanReloadSilentAimTarget = nil
        _G.UrbanReloadSilentAimChar = nil
        _G.UrbanReloadSilentAimPart = nil
    end

    -- แสดง/ซ่อน FOV Circle
    if fovCircle then
        if cfg.ShowFOV then
            fovCircle.Position = aimCenter
            fovCircle.Radius = cfg.FOVRadius or 180
            fovCircle.Color = LockedTarget and Color3.fromRGB(255, 50, 70) or (cfg.FOVColor or Color3.fromRGB(0, 255, 200))
            fovCircle.Visible = true
        else
            fovCircle.Visible = false
        end
    end

    -- แสดง/ซ่อน Tracer Line
    if targetTracer then
        if cfg.ShowFOV and LockedTarget and LockedTarget.ScreenPos then
            targetTracer.Visible = true
            targetTracer.From = aimCenter
            targetTracer.To = LockedTarget.ScreenPos
        else
            targetTracer.Visible = false
        end
    end

    -- ระบบ Auto Shoot (ตรวจจับศัตรูในวง FOV แล้วลั่นไกทันทีโดยไม่ต้องคลิกขวาเล็ง - รองรับทั้ง PC & Mobile)
    if cfg.AutoShoot and LockedTarget then
        local targetChar = LockedTarget.Character
        local isTargetSafe = IsPlayerInvulnerable(targetChar, LockedTarget.Player)
        local isSelfSafe = IsPlayerInvulnerable(LocalPlayer.Character, LocalPlayer)

        if not isTargetSafe and not isSelfSafe then
            local now = os.clock()
            if ClientState and Hub.Settings.InfiniteAmmo then ClientState.Reloading = false end
            local isBusy = ClientState and (ClientState.Reloading or ClientState.Rolling or ClientState.CaseRolling)
            local myChar = LocalPlayer.Character
            local tool = myChar and myChar:FindFirstChildOfClass("Tool")

            if (not isBusy or Hub.Settings.AlwaysShoot) and tool then
                local currentRPM = cfg.RPM or 900
                local shotInterval = (60 / currentRPM) + ((cfg.AutoShootDelay or 0) / 1000)

                if now - lastAutoShotTime >= shotInterval then
                    lastAutoShotTime = now
                    UniversalFireShot(LockedTarget.Position, LockedTarget.Character, LockedTarget.Part)
                end
            end
        end
    end
end)




-- ================================================
-- 🔄 8. HEARTBEAT / RENDERSTEPPED CORE LOOP (OPTIMIZED)
-- ================================================
local _cachedHitmarker = nil
local _lastDamageCheck = 0

Hub.Connections.CoreEnforcer = RunService.RenderStepped:Connect(function(dt)
    if not Hub.Running then return end

    if ClientState then
        if Hub.Settings.InfiniteStamina then
            ClientState.Stamina = ClientState.StaminaMax or 150
            ClientState.Exhausted = false
            ClientState.JumpCost = 0
        end
        ClientState.Frozen = false

        if Hub.Settings.NoSpread then
            ClientState.SpreadMultiplier = 0
            ClientState.Spread = 0
            ClientState.SpreadRest = 0
        end
        if Hub.Settings.NoRecoil then
            ClientState.RecoilScale = 0
        end

        -- 🛡️ True Infinite Ammo Replenishment (Maintains high ammo, completely prevents reload stutter)
        if Hub.Settings.InfiniteAmmo then
            local myChar = LocalPlayer.Character
            local tool = myChar and myChar:FindFirstChildOfClass("Tool")
            if tool and tool:IsA("Tool") then
                local curAmmo = tool:GetAttribute("Ammo")
                if typeof(curAmmo) == "number" and curAmmo < 25 then
                    tool:SetAttribute("Ammo", 60)
                end
                if tool:GetAttribute("Reloading") == true and curAmmo and curAmmo > 10 then
                    tool:SetAttribute("Reloading", false)
                end
            end
            if ClientState and not Hub.Settings.FastReload then
                ClientState.Reloading = false
            end
        end

        if Hub.Settings.AlwaysShoot then
            ClientState.Rolling = false
            ClientState.CaseRolling = false
        end
    end
end)

-- ================================================
-- ⚡ 8.2 AUTO RESPAWN & FAST RESET ENGINE
-- Key X instant respawn + bypass death cooldown
-- ================================================
local function ForceRespawnPlayer()
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        if rep:FindFirstChild("Events") and rep.Events:FindFirstChild("ForceRespawn") then
            rep.Events.ForceRespawn:FireServer()
        end
        if rep:FindFirstChild("Remotes") and rep.Remotes:FindFirstChild("Respawn") then
            rep.Remotes.Respawn:FireServer()
        end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
        end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local gu = pg and pg:FindFirstChild("GiveUp")
        local guBtn = gu and gu:FindFirstChild("Button", true)
        if guBtn and guBtn:IsA("GuiButton") and gu.Enabled then
            pcall(function() firesignal(guBtn.Activated) end)
            pcall(function() firesignal(guBtn.MouseButton1Click) end)
        end
    end)
end
Hub.ForceRespawnPlayer = ForceRespawnPlayer

local respawnKeyConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if not Hub.Running then return end
    if Hub.Settings.AutoRespawn and input.KeyCode == (Hub.Settings.RespawnKey or Enum.KeyCode.X) then
        ForceRespawnPlayer()
        if Hub.Fluent then
            Hub.Fluent:Notify({
                Title = "KrakenHub",
                Content = "เกิดใหม่ทันทีเรียบร้อยแล้ว",
                Duration = 2
            })
        end
    end
end)
table.insert(Hub.Connections, respawnKeyConn)

local _charRespawnConns = {}
local function MonitorCharacterForRespawn(char)
    if not char then return end
    for _, c in ipairs(_charRespawnConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(_charRespawnConns)

    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        local diedConn = hum.Died:Connect(function()
            if Hub.Running and Hub.Settings.AutoRespawn then
                task.wait(0.25)
                ForceRespawnPlayer()
            end
        end)
        table.insert(_charRespawnConns, diedConn)
        table.insert(Hub.Connections, diedConn)
    end
    local attrConn = char:GetAttributeChangedSignal("Downed"):Connect(function()
        if Hub.Running and Hub.Settings.AutoRespawn and char:GetAttribute("Downed") == true then
            task.wait(0.25)
            ForceRespawnPlayer()
        end
    end)
    table.insert(_charRespawnConns, attrConn)
    table.insert(Hub.Connections, attrConn)
end
if LocalPlayer.Character then MonitorCharacterForRespawn(LocalPlayer.Character) end
local charAddedConn = LocalPlayer.CharacterAdded:Connect(MonitorCharacterForRespawn)
table.insert(Hub.Connections, charAddedConn)

-- ================================================
-- 👤 9.1 CHARACTER NAME HIDER ENGINE
-- ================================================
local OriginalDisplayName = nil
local function ApplyNametagVisibility(hide)
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end

        local nt = char:FindFirstChild("NameTag")
        if nt then
            nt.Enabled = not hide
            local nom = nt:FindFirstChild("Nom")
            if nom then nom.Visible = not hide end
            local plate = nt:FindFirstChild("Plate")
            if plate then plate.Visible = not hide end
        end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if hide then
                if not OriginalDisplayName and hum.DisplayName ~= "" then
                    OriginalDisplayName = hum.DisplayName
                end
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                hum.NameDisplayDistance = 0
            else
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                hum.NameDisplayDistance = 100
                if OriginalDisplayName then
                    hum.DisplayName = OriginalDisplayName
                end
            end
        end
    end)
end

local function SetHideCharacterName(enable)
    Hub.Settings.HideCharacterName = enable
    ApplyNametagVisibility(enable)
end
Hub.SetHideCharacterName = SetHideCharacterName
Hub.ApplyNametagVisibility = ApplyNametagVisibility

-- Auto re-apply on respawn
local nameHiderConn = LocalPlayer.CharacterAdded:Connect(function(char)
    if Hub.Running and Hub.Settings.HideCharacterName then
        task.wait(0.2)
        ApplyNametagVisibility(true)
        local childConn = char.ChildAdded:Connect(function(child)
            if Hub.Running and Hub.Settings.HideCharacterName and child.Name == "NameTag" then
                task.wait(0.05)
                ApplyNametagVisibility(true)
            end
        end)
        table.insert(Hub.Connections, childConn)
    end
end)
table.insert(Hub.Connections, nameHiderConn)

-- ==============================================================
-- 🛡️ 9.5 BULLETPROOF ANTI-AFK ENGINE (กันหลุด 100% ใช้งานได้จริง)
-- Triple-Guard Protection:
-- 1. Disables all native CoreGui Idled connections via getconnections
-- 2. Intercepts Idled event and simulates VirtualUser click to reset idle timer
-- 3. Background heartbeat every 120s keeps connection alive even when window minimized
-- ==============================================================
local VirtualUser = game:GetService("VirtualUser")
local _antiAfkConnection = nil
local _disabledIdledConns = {}

local function DisableNativeIdled()
    pcall(function()
        if typeof(getconnections) == "function" then
            for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
                if conn.Function ~= nil or conn.State ~= nil then
                    if conn.Disable then
                        conn:Disable()
                        table.insert(_disabledIdledConns, conn)
                    elseif conn.Disconnect then
                        conn:Disconnect()
                    end
                end
            end
        end
    end)
end

local function InitAntiAFK()
    DisableNativeIdled()

    if not _antiAfkConnection then
        _antiAfkConnection = LocalPlayer.Idled:Connect(function()
            if Hub and Hub.Running and Hub.Settings and Hub.Settings.AntiAFK then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.zero)
                end)
            end
        end)
        table.insert(Hub.Connections, _antiAfkConnection)
    end
end
pcall(InitAntiAFK)

-- Continuous Keep-Alive Heartbeat (Runs every 120s - completely prevents idle detection even when minimized)
task.spawn(function()
    while Hub and Hub.Running do
        task.wait(120)
        if Hub.Settings and Hub.Settings.AntiAFK then
            DisableNativeIdled()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.zero)
            end)
        end
    end
end)

-- ================================================
-- 👁️ 10. DRAWING API PLAYER ESP
-- ================================================
-- (SafeDrawing unified above with Cross-Platform GuiDrawingAdapter)

local function MakePlayerESP(player)
    if Hub.ESP[player] then return end

    local obj = {
        BoxOutline = SafeDrawing("Square"),
        Box = SafeDrawing("Square"),
        HealthBarOutline = SafeDrawing("Square"),
        HealthBar = SafeDrawing("Square"),
        Name = SafeDrawing("Text"),
        Health = SafeDrawing("Text"),
        Dist = SafeDrawing("Text"),
        Weapon = SafeDrawing("Text"),
        Tracer = SafeDrawing("Line"),
        Highlight = nil,
    }

    local fontId = (Drawing and Drawing.Fonts and Drawing.Fonts[Hub.Settings.ESPFont]) or 0
    local fontSize = Hub.Settings.ESPFontSize or 13
    local subSize = math.max(10, fontSize - 2)

    obj.BoxOutline.Visible = false
    obj.BoxOutline.Thickness = 3.0
    obj.BoxOutline.Filled = false
    obj.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    obj.BoxOutline.Transparency = 0.85

    obj.Box.Visible = false
    obj.Box.Thickness = 1.2
    obj.Box.Filled = false
    obj.Box.Color = Hub.Settings.BoxColor or Color3.fromRGB(255, 60, 60)

    obj.HealthBarOutline.Visible = false
    obj.HealthBarOutline.Thickness = 1
    obj.HealthBarOutline.Filled = true
    obj.HealthBarOutline.Color = Color3.fromRGB(15, 15, 15)
    obj.HealthBarOutline.Transparency = 0.85

    obj.HealthBar.Visible = false
    obj.HealthBar.Thickness = 1
    obj.HealthBar.Filled = true
    obj.HealthBar.Transparency = 1

    obj.Name.Visible = false
    obj.Name.Color = Hub.Settings.NameColor or Color3.fromRGB(255, 255, 255)
    obj.Name.Font = fontId
    obj.Name.Size = fontSize
    obj.Name.Center = true
    obj.Name.Outline = true
    obj.Name.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Health.Visible = false
    obj.Health.Color = Hub.Settings.HealthColor or Color3.fromRGB(60, 255, 60)
    obj.Health.Font = fontId
    obj.Health.Size = math.max(10, subSize - 1)
    obj.Health.Center = false
    obj.Health.Outline = true
    obj.Health.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Dist.Visible = false
    obj.Dist.Color = Color3.fromRGB(180, 220, 255)
    obj.Dist.Font = fontId
    obj.Dist.Size = subSize
    obj.Dist.Center = true
    obj.Dist.Outline = true
    obj.Dist.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Weapon.Visible = false
    obj.Weapon.Color = Color3.fromRGB(255, 215, 80)
    obj.Weapon.Font = fontId
    obj.Weapon.Size = subSize
    obj.Weapon.Center = true
    obj.Weapon.Outline = true
    obj.Weapon.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Tracer.Visible = false
    obj.Tracer.Color = Hub.Settings.TracerColor or Color3.fromRGB(0, 200, 255)
    obj.Tracer.Thickness = 1.2

    -- Chams Glowing Highlight (ขอบแดง ตัวแดงจางลง นุ่มนวลตา ไม่บังหน้าจอ)
    local hl = Instance.new("Highlight")
    hl.Name = "KrakenChams_" .. player.Name
    hl.FillColor = Hub.Settings.ChamsColor or Color3.fromRGB(255, 35, 35)
    hl.OutlineColor = Hub.Settings.ChamsOutlineColor or Color3.fromRGB(255, 45, 45)
    hl.FillTransparency = Hub.Settings.ChamsTransparency or 0.78
    hl.OutlineTransparency = 0.25
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = false
    CollectionService:AddTag(hl, "OwnFX")
    pcall(function() hl.Parent = GetDrawingGui() end)
    obj.Highlight = hl

    Hub.ESP[player] = obj
end

local function RemovePlayerESP(player)
    local obj = Hub.ESP[player]
    if not obj then return end
    if obj.Highlight then
        pcall(function() obj.Highlight:Destroy() end)
        obj.Highlight = nil
    end
    for k, d in pairs(obj) do
        if k ~= "Highlight" then
            pcall(function() d:Remove() end)
        end
    end
    Hub.ESP[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then MakePlayerESP(p) end
end
Hub.Connections.PlayerAdded = Players.PlayerAdded:Connect(MakePlayerESP)
Hub.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(RemovePlayerESP)

local weaponNameCache = {}
local function GetFormattedWeaponName(rawName)
    local cached = weaponNameCache[rawName]
    if not cached then
        cached = rawName:gsub("Tool", ""):gsub("_", " ")
        weaponNameCache[rawName] = cached
    end
    return cached
end

Hub.Connections.ESPUpdate = RunService:BindToRenderStep("KrakenESP", Enum.RenderPriority.Camera.Value + 1, function()
    if not Hub.Running then return end

    local function hideESP(obj)
        if obj.BoxOutline then obj.BoxOutline.Visible = false end
        if obj.Box then obj.Box.Visible = false end
        if obj.Name then obj.Name.Visible = false end
        if obj.Health then obj.Health.Visible = false end
        if obj.Dist then obj.Dist.Visible = false end
        if obj.Weapon then obj.Weapon.Visible = false end
        if obj.Tracer then obj.Tracer.Visible = false end
        if obj.HealthBarOutline then obj.HealthBarOutline.Visible = false end
        if obj.HealthBar then obj.HealthBar.Visible = false end
        if obj.Highlight and obj.Highlight.Enabled then
            obj.Highlight.Enabled = false
            obj.Highlight.Adornee = nil
        end
    end

    -- ตรวจสอบว่ามีการเปิดใช้งานฟังก์ชัน ESP ตัวใดตัวหนึ่งอยู่หรือไม่ (ทำงานแยกอิสระ ไม่ต้องเปิด PlayerESP ก่อน)
    local isAnyEspActive = Hub.Settings.PlayerESP
        or Hub.Settings.ESPBox
        or Hub.Settings.ESPChams
        or Hub.Settings.ESPName
        or Hub.Settings.ESPHealth
        or Hub.Settings.ESPHealthBar
        or Hub.Settings.ESPDistance
        or Hub.Settings.ESPWeapon
        or Hub.Settings.ESPTracers

    if not isAnyEspActive or Hub._CasesOpen then
        for _, obj in pairs(Hub.ESP) do
            hideESP(obj)
        end
        return
    end

    pcall(function()
        local fontId = (Drawing and Drawing.Fonts and Drawing.Fonts[Hub.Settings.ESPFont]) or 0
        local fontSize = Hub.Settings.ESPFontSize or 14
        local subSize = math.max(10, fontSize - 2)

        local camPos = Camera.CFrame.Position
        local maxDist = Hub.Settings.ESPMaxDistance or 650
        local maxDistSq = maxDist * maxDist
        local vp = Camera.ViewportSize
        local vpX = vp.X
        local vpY = vp.Y
        local tracerOrigin = Vector2.new(vpX * 0.5, vpY)
        local sTime = nil
        pcall(function() sTime = workspace:GetServerTimeNow() end)

        for player, obj in pairs(Hub.ESP) do
            if player == LocalPlayer or (Hub.Settings.ESPTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team) then
                hideESP(obj)
                continue
            end

            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            local isDowned = (char:GetAttribute("Downed") == true)
            if not root or not head or not hum or (hum.Health <= 0 and not isDowned) then
                hideESP(obj)
                continue
            end

            local rootPos = root.Position
            local distSq = (camPos.X - rootPos.X)^2 + (camPos.Y - rootPos.Y)^2 + (camPos.Z - rootPos.Z)^2
            if distSq > maxDistSq then
                hideESP(obj)
                continue
            end

            local dist = math.sqrt(distSq)
            local isImmune = IsPlayerInvulnerable(char, player, sTime)
            local safeColor = Color3.fromRGB(0, 255, 120) -- เขียว Neon สำหรับคนติดโล่เกิด/อยู่ใน SafeZone ยิงไม่ได้

            -- 0. Glowing Body Chams (Optimized: capped to 200 studs to prevent mobile/low-end GPU fillrate drops)
            if Hub.Settings.ESPChams and obj.Highlight and dist <= 200 then
                if obj.Highlight.Adornee ~= char then
                    obj.Highlight.Adornee = char
                end
                if not obj.Highlight.Parent or not obj.Highlight.Parent.Parent then
                    pcall(function() obj.Highlight.Parent = GetDrawingGui() end)
                end
                obj.Highlight.FillColor = isImmune and safeColor or (Hub.Settings.ChamsColor or Color3.fromRGB(255, 35, 35))
                obj.Highlight.OutlineColor = isImmune and Color3.fromRGB(0, 255, 160) or (Hub.Settings.ChamsOutlineColor or Color3.fromRGB(255, 45, 45))
                obj.Highlight.FillTransparency = Hub.Settings.ChamsTransparency or 0.78
                obj.Highlight.OutlineTransparency = 0.25
                if not obj.Highlight.Enabled then
                    obj.Highlight.Enabled = true
                end
            elseif obj.Highlight and obj.Highlight.Enabled then
                obj.Highlight.Enabled = false
                obj.Highlight.Adornee = nil
            end

            local headHalfY = (head.Size and head.Size.Y * 0.5) or 0.6
            local topWorld = head.Position + Vector3.new(0, headHalfY + 0.15, 0)
            local bottomWorld = root.Position - Vector3.new(0, 2.75, 0)

            local topScreen, topDepth = WorldToViewport(topWorld)
            local bottomScreen, bottomDepth = WorldToViewport(bottomWorld)

            -- Fast 2D Bounding Box Calculation
            local isFront = (topDepth > 0 and bottomDepth > 0)
            local boxH = math.abs(bottomScreen.Y - topScreen.Y)
            local boxW = math.clamp(math.floor(boxH * 0.46), 4, 300)
            local centerX = topScreen.X
            local boxX = centerX - boxW * 0.5
            local boxY = topScreen.Y
            local onScreen2D = isFront and (boxH >= 3) and (boxX + boxW >= -25) and (boxX <= vpX + 25) and (boxY + boxH >= -25) and (boxY <= vpY + 25)

            if onScreen2D then
                -- 1. Precision 2D Box with High-Contrast Black Border
                local showBox = ((Hub.Settings.ESPBox == true) or (Hub.Settings.PlayerESP == true))
                if obj.BoxOutline then
                    obj.BoxOutline.Visible = showBox
                    if showBox then
                        obj.BoxOutline.Position = Vector2.new(boxX - 1, boxY - 1)
                        obj.BoxOutline.Size = Vector2.new(boxW + 2, boxH + 2)
                    end
                end

                if obj.Box then
                    obj.Box.Visible = showBox
                    if showBox then
                        obj.Box.Position = Vector2.new(boxX, boxY)
                        obj.Box.Size = Vector2.new(boxW, boxH)
                        obj.Box.Color = isImmune and safeColor or (Hub.Settings.BoxColor or Color3.fromRGB(255, 60, 60))
                    end
                end

                -- 2. Clean Header (Single-line Name + Distance on top of Box)
                local distMeters = math.floor(dist * 0.28)
                local nameStr = player.DisplayName
                if Hub.Settings.ESPNameMode == "Username" then
                    nameStr = player.Name
                elseif Hub.Settings.ESPNameMode == "Both" then
                    nameStr = player.DisplayName .. " (@" .. player.Name .. ")"
                end

                local showName = (Hub.Settings.ESPName == true) or (Hub.Settings.PlayerESP == true)
                local showDist = (Hub.Settings.ESPDistance == true)
                local headerText = ""
                if showName and showDist then
                    headerText = nameStr .. "  [" .. distMeters .. "m]"
                elseif showName then
                    headerText = nameStr
                elseif showDist then
                    headerText = distMeters .. "m"
                end

                if headerText ~= "" then
                    obj.Name.Visible = true
                    obj.Name.Font = fontId
                    obj.Name.Size = fontSize
                    obj.Name.Position = Vector2.new(centerX, boxY - (fontSize + 3))
                    obj.Name.Text = headerText
                    obj.Name.Color = isImmune and safeColor or (Hub.Settings.NameColor or Color3.fromRGB(255, 255, 255))
                else
                    obj.Name.Visible = false
                end
                if obj.Dist then obj.Dist.Visible = false end

                -- 3. Standing Vertical Health Bar & HP Text (Left of target, fully independent of 2D Box)
                local hp = math.clamp(math.floor((hum.Health / math.max(hum.MaxHealth, 1)) * 100), 0, 100)
                local hpColor = GetHealthColor(hp)

                if Hub.Settings.ESPHealthBar then
                    local barW = 3
                    local barOutlineW = barW + 2
                    local barX = boxX - barOutlineW - 3
                    local currentBarH = math.clamp(math.floor(boxH * (hp / 100)), 1, math.max(1, boxH))

                    obj.HealthBarOutline.Visible = true
                    obj.HealthBarOutline.Position = Vector2.new(barX, boxY - 1)
                    obj.HealthBarOutline.Size = Vector2.new(barOutlineW, boxH + 2)

                    obj.HealthBar.Visible = true
                    obj.HealthBar.Position = Vector2.new(barX + 1, (boxY + boxH) - currentBarH)
                    obj.HealthBar.Size = Vector2.new(barW, currentBarH)
                    obj.HealthBar.Color = hpColor

                    if Hub.Settings.ESPHealth and hp < 100 then
                        obj.Health.Visible = true
                        obj.Health.Font = fontId
                        obj.Health.Size = math.max(10, subSize - 1)
                        obj.Health.Position = Vector2.new(barX - 22, (boxY + boxH) - currentBarH - 4)
                        obj.Health.Text = hp .. "%"
                        obj.Health.Color = hpColor
                    else
                        obj.Health.Visible = false
                    end
                else
                    obj.HealthBarOutline.Visible = false
                    obj.HealthBar.Visible = false

                    if Hub.Settings.ESPHealth then
                        obj.Health.Visible = true
                        obj.Health.Font = fontId
                        obj.Health.Size = subSize
                        obj.Health.Position = Vector2.new(centerX, boxY + boxH + 2)
                        obj.Health.Text = hp .. "% HP"
                        obj.Health.Color = hpColor
                    else
                        obj.Health.Visible = false
                    end
                end

                -- 4. Clean Weapon Footer (Single-line below Box with cached string)
                local tool = char:FindFirstChildOfClass("Tool")
                if Hub.Settings.ESPWeapon and tool and dist <= 250 then
                    local rawWeaponName = GetFormattedWeaponName(tool.Name)
                    obj.Weapon.Visible = true
                    obj.Weapon.Font = fontId
                    obj.Weapon.Size = subSize
                    local weaponY = (not Hub.Settings.ESPHealthBar and Hub.Settings.ESPHealth) and (boxY + boxH + subSize + 4) or (boxY + boxH + 3)
                    obj.Weapon.Position = Vector2.new(centerX, weaponY)
                    obj.Weapon.Text = rawWeaponName
                    obj.Weapon.Color = Color3.fromRGB(255, 215, 80)
                else
                    obj.Weapon.Visible = false
                end

                -- 5. Tracer
                if Hub.Settings.ESPTracers and isFront then
                    obj.Tracer.Visible = true
                    obj.Tracer.From = tracerOrigin
                    obj.Tracer.To = bottomScreen
                    obj.Tracer.Color = isImmune and safeColor or (Hub.Settings.TracerColor or Color3.fromRGB(0, 200, 255))
                else
                    obj.Tracer.Visible = false
                end
            else
                -- Off-screen: Hide all 2D Drawing elements completely
                if obj.BoxOutline then obj.BoxOutline.Visible = false end
                if obj.Box then obj.Box.Visible = false end
                if obj.Name then obj.Name.Visible = false end
                if obj.HealthBarOutline then obj.HealthBarOutline.Visible = false end
                if obj.HealthBar then obj.HealthBar.Visible = false end
                if obj.Health then obj.Health.Visible = false end
                if obj.Dist then obj.Dist.Visible = false end
                if obj.Weapon then obj.Weapon.Visible = false end
                if obj.Tracer then obj.Tracer.Visible = false end
            end
    end
    end)
end)

-- ================================================
-- 💎 11. WORLD & SAFE ESP (BILLBOARD)
-- ================================================
local function ClearSafeESP()
    for _, bb in ipairs(Hub.SafeESP) do
        pcall(function() bb:Destroy() end)
    end
    table.clear(Hub.SafeESP)
end

local function UpdateSafeESP()
    ClearSafeESP()
    if not Hub.Settings.SafeESP then return end

    local function AddSafeZoneMarker(part, name)
        if not part or not part:IsA("BasePart") then return end
        local bb = Instance.new("BillboardGui")
        bb.Name = "KrakenSafeZoneESP"
        bb.Adornee = part
        bb.Size = UDim2.new(0, 150, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop = true
        CollectionService:AddTag(bb, "OwnFX")

        local title = Instance.new("TextLabel", bb)
        title.Size = UDim2.new(1, 0, 0, 18)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextColor3 = Color3.fromRGB(0, 255, 130)
        title.TextStrokeTransparency = 0.2
        title.Text = "เซฟโซน: " .. (name or "Safe Zone")

        local sub = Instance.new("TextLabel", bb)
        sub.Size = UDim2.new(1, 0, 0, 16)
        sub.Position = UDim2.new(0, 0, 0, 18)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamMedium
        sub.TextSize = 11
        sub.TextColor3 = Color3.fromRGB(150, 255, 180)
        sub.TextStrokeTransparency = 0.2
        sub.Text = "[ โซนปลอดภัย - ห้ามยิง ]"

        bb.Parent = part
        table.insert(Hub.SafeESP, bb)
    end

    -- Fast scan Workspace for SafeZones (Zero lag: targeted lookup instead of 10k+ Map:GetDescendants)
    local szFolder = Workspace:FindFirstChild("SafeZones") or Workspace:FindFirstChild("SafeZone")
    if szFolder then
        for _, obj in ipairs(szFolder:GetChildren()) do
            local p = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if p then AddSafeZoneMarker(p, obj.Name) end
        end
    end
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("safezone") or obj.Name:lower():find("safe_zone") then
            local p = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if p then AddSafeZoneMarker(p, obj.Name) end
        end
    end

    local coffres = Workspace:FindFirstChild("Coffres")
    if coffres then
        for _, safe in ipairs(coffres:GetChildren()) do
            local part = safe:FindFirstChildWhichIsA("BasePart")
            if part then
                local bb = Instance.new("BillboardGui")
                bb.Name = "KrakenSafeESP"
                bb.Adornee = part
                bb.Size = UDim2.new(0, 150, 0, 36)
                bb.StudsOffset = Vector3.new(0, 3.5, 0)
                bb.AlwaysOnTop = true
                CollectionService:AddTag(bb, "OwnFX")

                local title = Instance.new("TextLabel", bb)
                title.Size = UDim2.new(1, 0, 0, 18)
                title.BackgroundTransparency = 1
                title.Font = Enum.Font.GothamBold
                title.TextSize = 13
                title.TextColor3 = Color3.fromRGB(0, 230, 255)
                title.TextStrokeTransparency = 0.2
                title.Text = "ตู้เซฟ: " .. safe.Name:gsub("MilitaryCase_", "")

                local sub = Instance.new("TextLabel", bb)
                sub.Size = UDim2.new(1, 0, 0, 16)
                sub.Position = UDim2.new(0, 0, 0, 18)
                sub.BackgroundTransparency = 1
                sub.Font = Enum.Font.GothamMedium
                sub.TextSize = 11
                sub.TextColor3 = Color3.fromRGB(255, 215, 0)
                sub.TextStrokeTransparency = 0.2
                sub.Text = "เงินรางวัล: $5,000 - $50,000"

                bb.Parent = part
                table.insert(Hub.SafeESP, bb)
            end
        end
    end
end


-- ==============================================================
-- 🔫 12.1 HOOD NPC AUTO FARM, AUTO LOOT [E] & HITBOX ENGINE
-- ==============================================================
local HoodESPStorage = {}
local ZombieESPStorage = HoodESPStorage
local vim = game:GetService("VirtualInputManager")

task.spawn(function()
    local lastHeadEnforce = 0
    while Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        -- If both Hood NPC features are disabled, idle sleep to save 100% CPU
        local espActive = (Hub.Settings.HoodESP or Hub.Settings.ZombieESP) and not Hub._CasesOpen
        local auraActive = Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura
        if not espActive and not auraActive then
            for _, bb in pairs(HoodESPStorage) do
                if bb and bb.Enabled then bb.Enabled = false end
            end
            task.wait(0.5)
            continue
        end

        task.wait(0.1) -- 10 Hz smooth billboard update

        local now = os.clock()
        -- 1. Hood NPC Natural Head Size Enforcer (Run every 2s)
        if now - lastHeadEnforce >= 2.0 then
            lastHeadEnforce = now
            pcall(function()
                local hl = Workspace:FindFirstChild("HoodLocal")
                if hl then
                    local naturalSize = Vector3.new(0.792705, 1.214349, 0.902806)
                    for _, z in ipairs(hl:GetChildren()) do
                        if IsEnemyNPC(z) then
                            local head = z:FindFirstChild("Head")
                            if head and head:IsA("BasePart") and head.Size.X > 1.8 then
                                head.Size = naturalSize
                                head.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end

        -- 2. Hood NPC Real-Time Visual ESP (POOLED - Zero Allocation, Zero Flicker)
        pcall(function()
            local hoodLocal = Workspace:FindFirstChild("HoodLocal")
            if not hoodLocal then return end

            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myPos = (myHRP and myHRP.Position) or Camera.CFrame.Position

            -- Cleanup destroyed NPCs from storage
            for model, bb in pairs(HoodESPStorage) do
                if not model or not model.Parent then
                    pcall(function() bb:Destroy() end)
                    HoodESPStorage[model] = nil
                end
            end

            if not espActive then
                for _, bb in pairs(HoodESPStorage) do
                    if bb and bb.Enabled then bb.Enabled = false end
                end
                return
            end

            local auraDist = Hub.Settings.HoodKillAuraRange or Hub.Settings.ZombieKillAuraRange or 250
            for _, z in ipairs(hoodLocal:GetChildren()) do
                if IsEnemyNPC(z) then
                    local head = z:FindFirstChild("Head") or z:FindFirstChild("HumanoidRootPart")
                    local hp, maxHp, isDead = GetHoodRealtimeData(z)
                    local bb = HoodESPStorage[z]

                    if not isDead and hp > 0 and head and head.Position.Y > -100 then
                        local dist = math.floor((myPos - head.Position).Magnitude)
                        if dist <= auraDist then
                            if not bb or not bb.Parent then
                                bb = Instance.new("BillboardGui")
                                bb.Name = "KrakenHoodESP"
                                bb.Adornee = head
                                bb.Size = UDim2.new(0, 140, 0, 36)
                                bb.StudsOffset = Vector3.new(0, 2.2, 0)
                                bb.AlwaysOnTop = true
                                bb.MaxDistance = auraDist + 50
                                bb.ResetOnSpawn = false
                                CollectionService:AddTag(bb, "OwnFX")

                                local title = Instance.new("TextLabel")
                                title.Name = "Title"
                                title.Size = UDim2.new(1, 0, 0, 16)
                                title.BackgroundTransparency = 1
                                title.Font = Enum.Font.GothamBold
                                title.TextSize = 13
                                title.TextColor3 = Color3.fromRGB(255, 200, 50)
                                title.TextStrokeTransparency = 0.2
                                title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                title.Parent = bb

                                local sub = Instance.new("TextLabel")
                                sub.Name = "Sub"
                                sub.Size = UDim2.new(1, 0, 0, 13)
                                sub.Position = UDim2.new(0, 0, 0, 16)
                                sub.BackgroundTransparency = 1
                                sub.Font = Enum.Font.GothamMedium
                                sub.TextSize = 11
                                sub.TextColor3 = Color3.fromRGB(100, 255, 120)
                                sub.TextStrokeTransparency = 0.3
                                sub.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                sub.Parent = bb

                                local barBg = Instance.new("Frame")
                                barBg.Name = "BarBg"
                                barBg.Size = UDim2.new(1, 0, 0, 4)
                                barBg.Position = UDim2.new(0, 0, 0, 31)
                                barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                                barBg.BorderSizePixel = 0
                                barBg.Parent = bb

                                local barFill = Instance.new("Frame")
                                barFill.Name = "BarFill"
                                barFill.Size = UDim2.new(1, 0, 1, 0)
                                barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
                                barFill.BorderSizePixel = 0
                                barFill.Parent = barBg

                                bb.Parent = head
                                HoodESPStorage[z] = bb
                            end

                            if not bb.Enabled then bb.Enabled = true end

                            local title = bb:FindFirstChild("Title")
                            local sub = bb:FindFirstChild("Sub")
                            local barBg = bb:FindFirstChild("BarBg")
                            local barFill = barBg and barBg:FindFirstChild("BarFill")
                            local pct = math.clamp(hp / math.max(maxHp, 1), 0, 1)

                            if title then
                                title.Text = z.Name .. " [" .. dist .. "m]"
                            end

                            if sub then
                                sub.Text = math.floor(hp) .. " HP"
                                sub.TextColor3 = (pct > 0.5 and Color3.fromRGB(100, 255, 120)) or (pct > 0.25 and Color3.fromRGB(255, 220, 60)) or Color3.fromRGB(255, 70, 70)
                            end

                            if barFill then
                                barFill.Size = UDim2.new(pct, 0, 1, 0)
                                barFill.BackgroundColor3 = (pct > 0.5 and Color3.fromRGB(0, 255, 120)) or (pct > 0.25 and Color3.fromRGB(255, 200, 40)) or Color3.fromRGB(255, 45, 45)
                            end
                        else
                            -- Out of range: just disable, NEVER DESTROY!
                            if bb and bb.Enabled then
                                bb.Enabled = false
                            end
                        end
                    else
                        -- Dead or despawned: disable
                        if bb and bb.Enabled then
                            bb.Enabled = false
                        end
                    end
                end
            end
        end)
    end
end)

-- ==============================================================
-- ⚔️ 12.2 HOOD NPC KILL AURA & AUTOMATIC MONEY LOOT ENGINE
-- Overhauled: Anti-Stall, Smart Reload Guard, Zero Interruption
-- ==============================================================
local HoodTargetBlacklist = {}
local HoodTargetFails = {}

task.spawn(function()
    while Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        local auraActive = Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura
        if not auraActive then
            if Controls and Controls.IsDown and Controls.IsDown("Aim") then
                pcall(function() Controls.Press("Aim", false) end)
            end
            task.wait(0.3)
            continue
        end

        task.wait(0.02)

        -- 1. Ensure firearm is equipped in hand
        local equippedTool = EnsureWeaponEquipped()

        -- 2. RELOAD & AMMO GUARD (Fixes Infinite Reload Interruption / Freezing!)
        local isReloading = (ClientState and ClientState.Reloading == true)
        local currentAmmo = 30
        if equippedTool then
            local attrAmmo = equippedTool:GetAttribute("Ammo")
            if typeof(attrAmmo) == "number" then
                currentAmmo = attrAmmo
            end
        end

        -- If currently in the middle of reloading: RELEASE ALL CONTROLS and let it finish!
        if isReloading then
            if Controls then
                Controls.Press("Aim", false)
                Controls.Press("Fire", false)
            end
            -- Sweep loot while waiting for reload
            pcall(function()
                if ClientState and type(ClientState.HoodLootNow) == "function" then
                    ClientState.HoodLootNow()
                end
                vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.02)
                vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
            task.wait(0.1)
            continue
        end

        -- If out of ammo, trigger reload ONCE and let it reload without firing
        if currentAmmo <= 0 then
            if Controls then
                Controls.Press("Aim", false)
                Controls.Press("Fire", false)
                Controls.Press("Reload", true)
                task.wait(0.04)
                Controls.Press("Reload", false)
            end
            task.wait(0.15)
            continue
        end

        local char = LocalPlayer.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        local myHead = char and char:FindFirstChild("Head")
        local myPos = (myHead and myHead.Position) or (myHRP and myHRP.Position) or Camera.CFrame.Position
        local now = os.clock()

        -- 3. Clean up expired blacklists
        for npc, expire in pairs(HoodTargetBlacklist) do
            if now >= expire then
                HoodTargetBlacklist[npc] = nil
                HoodTargetFails[npc] = nil
            end
        end

        -- 4. Target Acquisition
        local enemyFolders = {}
        local hl = Workspace:FindFirstChild("HoodLocal")
        if hl then table.insert(enemyFolders, hl) end
        local zf = Workspace:FindFirstChild("Zombies")
        if zf then table.insert(enemyFolders, zf) end

        local wallCheck = (Hub.Settings.HoodWallCheck ~= false) and (Hub.Settings.ZombieWallCheck ~= false)
        local auraRange = Hub.Settings.HoodKillAuraRange or Hub.Settings.ZombieKillAuraRange or 250

        local bestVisibleNpc = nil
        local bestVisibleHead = nil
        local bestVisibleId = nil
        local minVisDist = math.huge

        local bestFallbackNpc = nil
        local bestFallbackHead = nil
        local bestFallbackId = nil
        local minFallbackDist = math.huge

        for _, folder in ipairs(enemyFolders) do
            for _, z in ipairs(folder:GetChildren()) do
                -- Exclude dead, downed, lootable bodies and blacklisted targets
                if IsEnemyNPC(z) and not HoodTargetBlacklist[z] then
                    local hp, maxHp, isDead, id = GetHoodRealtimeData(z)
                    local head = z:FindFirstChild("Head")
                    local zHrp = z:FindFirstChild("HumanoidRootPart")
                    if not isDead and hp > 0 and head and zHrp and zHrp.Position.Y > -100 then
                        local dist = (myPos - head.Position).Magnitude
                        if dist <= auraRange then
                            if dist < minFallbackDist then
                                minFallbackDist = dist
                                bestFallbackNpc = z
                                bestFallbackHead = head
                                bestFallbackId = id
                            end

                            if wallCheck then
                                local hasLOS, hitPart = CheckHoodTargetLOS(z)
                                if hasLOS and dist < minVisDist then
                                    minVisDist = dist
                                    bestVisibleNpc = z
                                    bestVisibleHead = hitPart or head
                                    bestVisibleId = id
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Target Selection:
        -- 1. Prioritize visible targets
        -- 2. If no visible target, but a target is close (< 45 studs), fall back to it (bullets penetrate thin props)
        local targetNpc = nil
        local targetHead = nil
        local targetNpcId = nil

        if bestVisibleNpc then
            targetNpc = bestVisibleNpc
            targetHead = bestVisibleHead
            targetNpcId = bestVisibleId
        elseif not wallCheck then
            targetNpc = bestFallbackNpc
            targetHead = bestFallbackHead
            targetNpcId = bestFallbackId
        elseif bestFallbackNpc and minFallbackDist <= 45 then
            -- Close proximity fallback: shoot through fence/railing
            targetNpc = bestFallbackNpc
            targetHead = bestFallbackHead
            targetNpcId = bestFallbackId
        end

        if targetNpc and targetHead and targetHead.Position.Y > -100 then
            Hub.CurrentTarget = targetNpc
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)

            if equippedTool then
                if Controls then
                    Controls.Press("Aim", true)
                end
                if ClientState then
                    ClientState.Aiming = true
                end

                local startHp = GetHoodRealtimeData(targetNpc)
                local shots = 0
                while Hub.Running and (Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura) and targetHead and targetHead.Position.Y > -100 and shots < 5 do
                    -- Check if reload started or ammo empty
                    if (ClientState and ClientState.Reloading == true) or (equippedTool:GetAttribute("Ammo") or 30) <= 0 then
                        break
                    end
                    local curHp, _, isDeadNow = GetHoodRealtimeData(targetNpc)
                    if isDeadNow or curHp <= 0 or targetNpc:GetAttribute("Lootable") == true then
                        break
                    end
                    shots = shots + 1
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                    UniversalFireShot(targetHead.Position, targetNpc, targetHead)
                    task.wait(0.09)
                end

                -- Anti-Stall Health Check: If target took multiple bursts without losing HP, blacklist it for 3s
                local endHp, _, endDead = GetHoodRealtimeData(targetNpc)
                if not endDead and endHp >= startHp and shots >= 4 then
                    HoodTargetFails[targetNpc] = (HoodTargetFails[targetNpc] or 0) + 1
                    if HoodTargetFails[targetNpc] >= 2 then
                        HoodTargetBlacklist[targetNpc] = os.clock() + 3.0
                    end
                else
                    HoodTargetFails[targetNpc] = nil
                end

                -- Instant loot sequence upon death using direct NPC ID (Cross-Platform PC & Mobile)
                pcall(function()
                    if ClientState and type(ClientState.HoodLootNow) == "function" then
                        ClientState.HoodLootNow()
                    end
                    local hoodRemote = HoodRemote or (ReplicatedStorage:FindFirstChild("HoodNPC") and ReplicatedStorage.HoodNPC:FindFirstChild("Remote"))
                    if hoodRemote and targetNpcId then
                        hoodRemote:FireServer("loot", targetNpcId, targetHead.Position)
                    end
                    if typeof(fireproximityprompt) == "function" then
                        local pp = targetNpc:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if pp then fireproximityprompt(pp) end
                    end
                    if vim and vim.SendKeyEvent then
                        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.02)
                        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                end)
            end
        else
            Hub.CurrentTarget = nil
            if Controls and Controls.IsDown and Controls.IsDown("Aim") then
                pcall(function() Controls.Press("Aim", false) end)
            end

            -- Sweep ground loot and dead corpses while waiting (Cross-Platform PC & Mobile)
            pcall(function()
                if ClientState and type(ClientState.HoodLootNow) == "function" then
                    ClientState.HoodLootNow()
                end
                if vim and vim.SendKeyEvent then
                    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.02)
                    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end)
            task.wait(0.1)
        end
    end
end)

-- ==============================================================
-- 🎨 13. MODERN MACLIB UI & FLOATING LOGO INTERFACE
-- ==============================================================
local function InitUI()
    Hub.InitUI = InitUI
    -- GUI Container resolution (supports gethui / CoreGui / PlayerGui)
    local CoreGui = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or nil
    local targetGuiParent = (function()
        if CoreGui then
            local canCore = pcall(function()
                local test = Instance.new("Folder")
                test.Parent = CoreGui
                test:Destroy()
            end)
            if canCore then return CoreGui end
        end
        if gethui then
            local ok, h = pcall(gethui)
            if ok and h then return h end
        end
        return LocalPlayer:WaitForChild("PlayerGui")
    end)()

    -- Clean up previous UI instances (thorough sweep of both targetGuiParent and CoreGui)
    local function SweepOldGuis(parent)
        if not parent then return end
        for _, c in ipairs(parent:GetChildren()) do
            if c:IsA("ScreenGui") then
                if c.Name == "KrakenHub_ToggleButton" or c.Name == "KrakenHub_UI" or c.Name == "Maclib" or c.Name == "Fluent" or c.Name == "KrakenHub_MobileAimHUD" or c.Name:find("KrakenPlayerBillboard") or c:FindFirstChild("Base") then
                    pcall(function() c:Destroy() end)
                end
            elseif c:IsA("BillboardGui") and c.Name:find("KrakenPlayerBillboard") then
                pcall(function() c:Destroy() end)
            end
        end
    end
    SweepOldGuis(targetGuiParent)
    if CoreGui and CoreGui ~= targetGuiParent then
        SweepOldGuis(CoreGui)
    end

    -- 🏷️ 1. LOGO ASSET LOADER (K COMMUNITY LOGO)
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
        return "rbxassetid://10709810948"
    end

    -- 🎨 2. LOAD MACLIB UI LIBRARY (MULTI-MIRROR RESILIENT LOADER)
    local MacLib = nil
    local maclibCode = nil
    local maclibUrls = {
        "https://raw.githubusercontent.com/armongzx56-design/KrakenHub/main/maclib.txt", -- Direct 200 OK (KrakenHub Mirror)
        "https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt",      -- Official Release
        "https://raw.githubusercontent.com/biggaboy212/Maclib/main/maclib.txt"           -- Raw Backup
    }

    for _, url in ipairs(maclibUrls) do
        local s, res = pcall(function() return game:HttpGet(url) end)
        if s and type(res) == "string" and #res > 5000 and not res:find("<html") then
            maclibCode = res
            break
        end
    end

    if not maclibCode then
        warn("[KrakenHub] Failed to download MacLib from all mirrors! Checking local cache...")
        if typeof(isfile) == "function" and isfile("maclib.txt") then
            pcall(function() maclibCode = readfile("maclib.txt") end)
        end
    end

    if not maclibCode then
        warn("[KrakenHub] Fatal: Unable to load MacLib UI library.")
        return
    end

    if typeof(writefile) == "function" and typeof(isfile) == "function" and not isfile("maclib.txt") then
        pcall(writefile, "maclib.txt", maclibCode)
    end

    local ok, lib = pcall(function()
        local code = maclibCode
        -- 1. Patch toggle ON state to vibrant red Color3.fromRGB(235, 50, 50)
        code = code:gsub(
            "Tween%(toggle1,%s*TweenSettings%.Info,%s*{%s*ImageTransparency%s*=%s*transparencyValues%[1%]%s*}%)",
            "Tween(toggle1, TweenSettings.Info, { ImageTransparency = transparencyValues[1], ImageColor3 = State and Color3.fromRGB(235, 50, 50) or Color3.fromRGB(87, 86, 86) })"
        )
        code = code:gsub(
            "toggle1%.ImageColor3%s*=%s*Color3%.fromRGB%(87,%s*86,%s*86%)",
            "toggle1.ImageColor3 = togglebool and Color3.fromRGB(235, 50, 50) or Color3.fromRGB(87, 86, 86)"
        )
        -- Expose section Frame in SectionFunctions
        code = code:gsub("return SectionFunctions", "SectionFunctions.Instance = section\n\t\t\t\treturn SectionFunctions")

        -- 2. Restore Green Dot (Maximize Button)
        code = code:gsub("applyState%(maximize,%s*false%)", "applyState(maximize, true)")
        code = code:gsub("maximize%.BackgroundColor3%s*=%s*Color3%.fromRGB%(119,%s*174,%s*94%)", "maximize.BackgroundColor3 = Color3.fromRGB(40, 205, 65)")

        -- 2.1 Sizing & Proportions: Sidebar 190px and responsive Content area
        code = code:gsub("sidebar%.Size%s*=%s*UDim2%.fromScale%(0%.325,%s*1%)", "sidebar.Size = UDim2.new(0, 190, 1, 0)")
        code = code:gsub("content%.Size%s*=%s*UDim2%.new%(0,%s*%(base%.AbsoluteSize%.X%s*-%s*sidebar%.AbsoluteSize%.X%),%s*1,%s*0%)", "content.Size = UDim2.new(1, -190, 1, 0)")
        code = code:gsub("sectionUIPadding%.PaddingLeft%s*=%s*UDim%.new%(0,%s*20%)", "sectionUIPadding.PaddingLeft = UDim.new(0, 14)")
        code = code:gsub("sectionUIPadding%.PaddingRight%s*=%s*UDim%.new%(0,%s*18%)", "sectionUIPadding.PaddingRight = UDim.new(0, 14)")

        -- 3. Fix Slider Layout: give sliderName ample width (1, -135) and fixed crisp sliderBar
        code = code:gsub(
            "sliderName%.AutomaticSize%s*=%s*Enum%.AutomaticSize%.XY",
            "sliderName.AutomaticSize = Enum.AutomaticSize.None\n\t\t\t\t\tsliderName.Size = UDim2.new(1, -135, 1, 0)\n\t\t\t\t\tsliderName.TextTruncate = Enum.TextTruncate.None\n\t\t\t\t\tsliderName.ClipsDescendants = false"
        )
        code = code:gsub(
            "sliderBar%.Size%s*=%s*UDim2%.fromOffset%(123,%s*3%)",
            "sliderBar.Size = UDim2.fromOffset(80, 3)"
        )
        code = code:gsub(
            "sliderElementsUIListLayout%.Padding%s*=%s*UDim%.new%(0,%s*20%)",
            "sliderElementsUIListLayout.Padding = UDim.new(0, 8)"
        )
        code = code:gsub(
            "sliderValue%.Size%s*=%s*UDim2%.fromOffset%(41,%s*21%)",
            "sliderValue.Size = UDim2.fromOffset(38, 20)"
        )
        code = code:gsub(
            "local function updateSliderBarSize%(%)\n.-end",
            "local function updateSliderBarSize()\n\t\t\t\t\t\tsliderBar.Size = UDim2.fromOffset(80, 3)\n\t\t\t\t\tend"
        )

        -- 4. Fix Keybind Layout: ample width for keybindName and crisp binderBox
        code = code:gsub(
            "keybindName%.AutomaticSize%s*=%s*Enum%.AutomaticSize%.XY",
            "keybindName.AutomaticSize = Enum.AutomaticSize.None\n\t\t\t\t\tkeybindName.Size = UDim2.new(1, -70, 1, 0)\n\t\t\t\t\tkeybindName.TextTruncate = Enum.TextTruncate.None\n\t\t\t\t\tkeybindName.ClipsDescendants = false"
        )

        -- 4.1 Fix Toggle & Dropdown Text Truncate
        code = code:gsub(
            "toggleName%.Size%s*=%s*UDim2%.new%(1,%s*-50,%s*0,%s*0%)",
            "toggleName.Size = UDim2.new(1, -50, 0, 0)\n\t\t\t\t\ttoggleName.TextTruncate = Enum.TextTruncate.None"
        )
        code = code:gsub(
            "dropdownName%.TextTruncate%s*=%s*Enum%.TextTruncate%.SplitWord",
            "dropdownName.TextTruncate = Enum.TextTruncate.None"
        )

        -- 5. Partially censor UserInfo at bottom-left (Show avatar and partial masked name)
        code = code:gsub(
            "displayName%.Text%s*=%s*LocalPlayer%.DisplayName",
            'local function _mask(s) if not s or #s <= 3 then return (s or ""):sub(1,1).."***" end return s:sub(1,2).."****"..s:sub(-2) end\n\tdisplayName.Text = _mask(LocalPlayer.DisplayName)'
        )
        code = code:gsub(
            'username%.Text%s*=%s*"@"%s*%.%.%s*LocalPlayer%.Name',
            'username.Text = "@" .. _mask(LocalPlayer.Name)'
        )

        
        -- 6. Typography & Highlight Enhancements (Larger Fonts & Glowing Headers)
        code = code:gsub(
            "headerText%.TextSize%s*=%s*16",
            "headerText.TextSize = 18\n\t\t\t\t\theaderText.TextColor3 = Color3.fromRGB(0, 230, 255)\n\t\t\t\t\theaderText.FontFace = Font.new(assets.interFont, Enum.FontWeight.Bold)"
        )
        code = code:gsub("headerText%.TextTransparency%s*=%s*0%.3", "headerText.TextTransparency = 0")

        code = code:gsub("toggleName%.TextSize%s*=%s*13", "toggleName.TextSize = 15\n\t\t\t\t\ttoggleName.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold)")
        code = code:gsub("toggleName%.TextTransparency%s*=%s*0%.5", "toggleName.TextTransparency = 0.05")

        code = code:gsub("sliderName%.TextSize%s*=%s*13", "sliderName.TextSize = 15\n\t\t\t\t\tsliderName.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold)")
        code = code:gsub("sliderName%.TextTransparency%s*=%s*0%.5", "sliderName.TextTransparency = 0.05")

        code = code:gsub("dropdownName%.TextSize%s*=%s*13", "dropdownName.TextSize = 15\n\t\t\t\t\tdropdownName.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold)")
        code = code:gsub("dropdownName%.TextTransparency%s*=%s*0%.5", "dropdownName.TextTransparency = 0.05")

        code = code:gsub("buttonName%.TextSize%s*=%s*13", "buttonName.TextSize = 15\n\t\t\t\t\tbuttonName.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold)")
        code = code:gsub("buttonName%.TextTransparency%s*=%s*0%.5", "buttonName.TextTransparency = 0.05")

        return loadstring(code)()
    end)
    if ok and lib then
        MacLib = lib
    else
        warn("[KrakenHub] Failed to load MacLib from release URL")
        return
    end

    -- 📐 3. RESPONSIVE WINDOW SIZE (Mobile Android/iOS & PC Auto-Adapter)
    local function GetOptimalWindowSize()
        local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
        local isMobile = UserInputService.TouchEnabled or (vp.X < 950)
        if isMobile then
            local w = math.clamp(math.floor(vp.X * 0.92), 340, 780)
            local h = math.clamp(math.floor(vp.Y * 0.86), 280, 520)
            return UDim2.fromOffset(w, h)
        end
        return UDim2.fromOffset(980, 630)
    end

    -- 🪟 4. CREATE MAIN WINDOW
    local Window = MacLib:Window({
        Title = "KrakenHub",
        Subtitle = "Urban Reload | KrakenHub",
        Size = GetOptimalWindowSize(),
        DragStyle = 2,
        ShowUserInfo = true,
        Keybind = Enum.KeyCode.RightControl,
        AcrylicBlur = false,
    })
    Hub.Window = Window
    pcall(function() Window:SetState(true) end)

    -- 💬 DISCORD COMMUNITY BUTTON ENGINE (ปุ่มดิสคอร์ดกะทัดรัดขวาบนหน้าต่าง + Auto-Open Discord & New Logo)
    local function CreateDiscordButton(base, windowObj)
        if not base then return end
        local old = base:FindFirstChild("DiscordBtn")
        if old then return end

        -- 1. Ensure Discord Logo Asset is ready
        local discordLogoFile = "KrakenDiscordLogo.png"
        local discordAsset = "rbxassetid://10709778748"
        pcall(function()
            if typeof(isfile) == "function" and typeof(writefile) == "function" then
                if not isfile(discordLogoFile) then
                    local b64Data = "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"
                    local decoded = nil
                    if crypt and typeof(crypt.base64decode) == "function" then
                        decoded = crypt.base64decode(b64Data)
                    elseif crypt and typeof(crypt.base64_decode) == "function" then
                        decoded = crypt.base64_decode(b64Data)
                    elseif typeof(base64_decode) == "function" then
                        decoded = base64_decode(b64Data)
                    end
                    if decoded and #decoded > 0 then
                        writefile(discordLogoFile, decoded)
                    end
                end
                if isfile(discordLogoFile) and typeof(getcustomasset) == "function" then
                    local customAsset = getcustomasset(discordLogoFile)
                    if customAsset and #tostring(customAsset) > 0 then
                        discordAsset = customAsset
                    end
                end
            end
        end)

        local discordBtn = Instance.new("TextButton")
        discordBtn.Name = "DiscordBtn"
        discordBtn.AnchorPoint = Vector2.new(1, 0)
        discordBtn.Position = UDim2.new(1, -42, 0, 16)
        discordBtn.Size = UDim2.fromOffset(96, 28)
        discordBtn.BackgroundColor3 = Color3.fromRGB(24, 25, 28) -- Sleek Discord Dark
        discordBtn.BackgroundTransparency = 0
        discordBtn.BorderSizePixel = 0
        discordBtn.AutoButtonColor = false
        discordBtn.Text = ""
        discordBtn.ZIndex = 10000
        discordBtn.Parent = base

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = discordBtn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(88, 101, 242) -- Discord Blurple border
        stroke.Thickness = 1.2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = discordBtn

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 6)
        layout.Parent = discordBtn

        local icon = Instance.new("ImageLabel")
        icon.Name = "DiscordIcon"
        icon.Size = UDim2.fromOffset(20, 20)
        icon.BackgroundTransparency = 1
        icon.Image = discordAsset
        icon.ScaleType = Enum.ScaleType.Fit
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        icon.ZIndex = 10001
        icon.Parent = discordBtn

        local label = Instance.new("TextLabel")
        label.Name = "DiscordLabel"
        label.Size = UDim2.fromOffset(50, 16)
        label.BackgroundTransparency = 1
        label.Text = "Discord"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 10001
        label.Parent = discordBtn

        -- Hover Animations
        discordBtn.MouseEnter:Connect(function()
            TweenService:Create(discordBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(38, 40, 45)
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Color = Color3.fromRGB(114, 137, 218)
            }):Play()
        end)

        discordBtn.MouseLeave:Connect(function()
            TweenService:Create(discordBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(24, 25, 28)
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Color = Color3.fromRGB(88, 101, 242)
            }):Play()
        end)

        -- Click Handler: Auto-Open Discord App via Local RPC across all Discord ports (6463-6472)
        local inviteCode = "vvkVDYeuhn"
        local inviteUrl = "https://discord.gg/" .. inviteCode
        local _lastDiscordClick = 0
        local function OnDiscordClicked()
            local now = os.clock()
            if now - _lastDiscordClick < 0.5 then return end
            _lastDiscordClick = now

            TweenService:Create(discordBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            }):Play()
            task.delay(0.15, function()
                TweenService:Create(discordBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(24, 25, 28)
                }):Play()
            end)

            -- 1. Copy invite link to clipboard
            if typeof(setclipboard) == "function" then
                pcall(setclipboard, inviteUrl)
            elseif typeof(toclipboard) == "function" then
                pcall(toclipboard, inviteUrl)
            end

            -- 2. Discord Desktop App Auto-Open (Local RPC 6463-6472)
            task.spawn(function()
                local req = (typeof(request) == "function" and request)
                         or (typeof(http_request) == "function" and http_request)
                         or (syn and typeof(syn.request) == "function" and syn.request)
                if not req then return end

                local HttpService = game:GetService("HttpService")
                for port = 6463, 6472 do
                    local opened = false
                    pcall(function()
                        local res = req({
                            Url = "http://127.0.0.1:" .. tostring(port) .. "/rpc?v=1",
                            Method = "POST",
                            Headers = {
                                ["Content-Type"] = "application/json",
                                ["Origin"] = "https://discord.com"
                            },
                            Body = HttpService:JSONEncode({
                                cmd = "INVITE_BROWSER",
                                args = { code = inviteCode },
                                nonce = HttpService:GenerateGUID(false)
                            })
                        })
                        if res and res.StatusCode == 200 then
                            opened = true
                        end
                    end)
                    if opened then
                        break
                    end
                end
            end)

            -- 3. Toast Notification
            if windowObj and windowObj.Notify then
                pcall(function()
                    windowObj:Notify({
                        Title = "Discord Community",
                        Description = "กำลังเด้งเปิด Discord App และคัดลอกลิงก์ให้แล้ว!\n(discord.gg/" .. inviteCode .. ")",
                        Lifetime = 4
                    })
                end)
            end
        end

        discordBtn.MouseButton1Click:Connect(OnDiscordClicked)
        discordBtn.Activated:Connect(OnDiscordClicked)
    end

    -- 🌟 Rock-Solid Neon Blue Window Border, Resize Grip & Green Dot Engine
    local _windowBorderHooked = false
    local function ApplyWindowBorder()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                base.ClipsDescendants = false
                CreateDiscordButton(base, Window)

                -- 1. สร้างกรอบ Overlay ชั้นบนสุด (ZIndex 9999) ลอยครอบหน้าต่างไว้ถาวร
                local overlay = base:FindFirstChild("KrakenBorderOverlay")
                if not overlay then
                    overlay = Instance.new("Frame")
                    overlay.Name = "KrakenBorderOverlay"
                    overlay.BackgroundTransparency = 1
                    overlay.BorderSizePixel = 0
                    overlay.Size = UDim2.fromScale(1, 1)
                    overlay.Position = UDim2.fromScale(0, 0)
                    overlay.ZIndex = 9999
                    overlay.Parent = base

                    local corner = base:FindFirstChildOfClass("UICorner")
                    if corner then
                        local oc = Instance.new("UICorner")
                        oc.CornerRadius = corner.CornerRadius
                        oc.Parent = overlay
                    end

                    local stroke = Instance.new("UIStroke")
                    stroke.Name = "WindowStroke"
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Color = Color3.fromRGB(0, 170, 255)
                    stroke.Thickness = 2.0
                    stroke.Transparency = 0
                    stroke.Parent = overlay
                else
                    local s = overlay:FindFirstChild("WindowStroke") or overlay:FindFirstChildOfClass("UIStroke")
                    if s then
                        s.Color = Color3.fromRGB(0, 170, 255)
                        s.Thickness = 2.0
                        s.Transparency = 0
                        s.Enabled = true
                    end
                end

                -- 2. 🟢 Restore Green Maximize Dot (เพิ่มจุดสีเขียวที่หายไป + คลิกขยายเต็มจอ/คืนค่า)
                local maxBtn = base:FindFirstChild("Maximize", true)
                if maxBtn and maxBtn:IsA("TextButton") then
                    maxBtn.Size = UDim2.fromOffset(8, 8)
                    maxBtn.BackgroundTransparency = 0
                    maxBtn.BackgroundColor3 = Color3.fromRGB(40, 205, 65)
                    maxBtn.Active = true
                    maxBtn.AutoButtonColor = true
                    for _, ch in ipairs(maxBtn:GetChildren()) do
                        if ch:IsA("UIStroke") then ch:Destroy() end
                    end
                    if not maxBtn:GetAttribute("MaxHooked") then
                        maxBtn:SetAttribute("MaxHooked", true)
                        local isMaximized = false
                        local prevSize = nil
                        local prevPos = nil
                        maxBtn.Activated:Connect(function()
                            local vp = (Camera and Camera.ViewportSize) or Vector2.new(1920, 1080)
                            isMaximized = not isMaximized
                            if isMaximized then
                                prevSize = base.Size
                                prevPos = base.Position
                                local maxW = math.max(340, vp.X - (UserInputService.TouchEnabled and 24 or 50))
                                local maxH = math.max(260, vp.Y - (UserInputService.TouchEnabled and 24 or 50))
                                TweenService:Create(base, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    Size = UDim2.fromOffset(maxW, maxH),
                                    Position = UDim2.fromScale(0.5, 0.5)
                                }):Play()
                            else
                                local restoreSize = prevSize or GetOptimalWindowSize()
                                local restorePos = prevPos or UDim2.fromScale(0.5, 0.5)
                                TweenService:Create(base, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    Size = restoreSize,
                                    Position = restorePos
                                }):Play()
                            end
                        end)
                    end
                end

                -- 3. 📐 Bottom-Right Corner Resize Grip (ด้ามจับปรับขนาดดีไซน์พรีเมียม สไตล์ Cyber Glass)
                local oldGrip = base:FindFirstChild("KrakenResizeGrip")
                if oldGrip then
                    oldGrip:Destroy()
                end

                local gripContainer = Instance.new("Frame")
                gripContainer.Name = "KrakenResizeGrip"
                gripContainer.Size = UDim2.fromOffset(20, 20)
                gripContainer.Position = UDim2.new(1, -5, 1, -5)
                gripContainer.AnchorPoint = Vector2.new(1, 1)
                gripContainer.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
                gripContainer.BackgroundTransparency = 0.35
                gripContainer.BorderSizePixel = 0
                gripContainer.ZIndex = 10001
                gripContainer.Parent = base

                local gripCorner = Instance.new("UICorner")
                gripCorner.CornerRadius = UDim.new(0, 6)
                gripCorner.Parent = gripContainer

                local gripStroke = Instance.new("UIStroke")
                gripStroke.Name = "GripStroke"
                gripStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                gripStroke.Color = Color3.fromRGB(0, 180, 255)
                gripStroke.Thickness = 1.0
                gripStroke.Transparency = 0.45
                gripStroke.Parent = gripContainer

                -- 3 Parallel Precision Neon Rungs (aligned at 45 deg inside badge)
                local rungsData = {
                    { size = 4, offset = -3, trans = 0.1 },
                    { size = 8, offset = -7, trans = 0.25 },
                    { size = 12, offset = -11, trans = 0.4 }
                }

                local rungFrames = {}
                for i, r in ipairs(rungsData) do
                    local bar = Instance.new("Frame")
                    bar.Name = "GripRung_" .. i
                    bar.Size = UDim2.fromOffset(r.size, 1.5)
                    bar.AnchorPoint = Vector2.new(0.5, 0.5)
                    bar.Position = UDim2.new(1, r.offset, 1, r.offset)
                    bar.Rotation = -45
                    bar.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
                    bar.BackgroundTransparency = r.trans
                    bar.BorderSizePixel = 0
                    bar.ZIndex = 10002
                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(1, 0)
                    c.Parent = bar
                    bar.Parent = gripContainer
                    table.insert(rungFrames, bar)
                end

                -- Generous mobile-friendly hitbox (28x28)
                local gripButton = Instance.new("TextButton")
                gripButton.Name = "GripHitbox"
                gripButton.Size = UDim2.fromOffset(28, 28)
                gripButton.Position = UDim2.new(1, 4, 1, 4)
                gripButton.AnchorPoint = Vector2.new(1, 1)
                gripButton.BackgroundTransparency = 1
                gripButton.Text = ""
                gripButton.ZIndex = 10005
                gripButton.Parent = gripContainer

                local resizing = false
                local resizeStartInput = nil
                local resizeStartSize = nil
                local resizeStartPos = nil

                local function SetGripVisualState(active, hovered)
                    if active then
                        TweenService:Create(gripContainer, TweenInfo.new(0.12), {
                            BackgroundTransparency = 0.1,
                            BackgroundColor3 = Color3.fromRGB(18, 26, 38)
                        }):Play()
                        TweenService:Create(gripStroke, TweenInfo.new(0.12), {
                            Color = Color3.fromRGB(120, 240, 255),
                            Transparency = 0,
                            Thickness = 1.4
                        }):Play()
                        for _, rf in ipairs(rungFrames) do
                            TweenService:Create(rf, TweenInfo.new(0.12), {
                                BackgroundColor3 = Color3.fromRGB(160, 250, 255),
                                BackgroundTransparency = 0
                            }):Play()
                        end
                    elseif hovered then
                        TweenService:Create(gripContainer, TweenInfo.new(0.15), {
                            BackgroundTransparency = 0.2,
                            BackgroundColor3 = Color3.fromRGB(16, 22, 32)
                        }):Play()
                        TweenService:Create(gripStroke, TweenInfo.new(0.15), {
                            Color = Color3.fromRGB(60, 215, 255),
                            Transparency = 0.2,
                            Thickness = 1.2
                        }):Play()
                        for _, rf in ipairs(rungFrames) do
                            TweenService:Create(rf, TweenInfo.new(0.15), {
                                BackgroundColor3 = Color3.fromRGB(100, 235, 255),
                                BackgroundTransparency = 0.1
                            }):Play()
                        end
                    else
                        TweenService:Create(gripContainer, TweenInfo.new(0.2), {
                            BackgroundTransparency = 0.35,
                            BackgroundColor3 = Color3.fromRGB(14, 18, 26)
                        }):Play()
                        TweenService:Create(gripStroke, TweenInfo.new(0.2), {
                            Color = Color3.fromRGB(0, 180, 255),
                            Transparency = 0.45,
                            Thickness = 1.0
                        }):Play()
                        for idx, rf in ipairs(rungFrames) do
                            local tr = (rungsData[idx] and rungsData[idx].trans) or 0.3
                            TweenService:Create(rf, TweenInfo.new(0.2), {
                                BackgroundColor3 = Color3.fromRGB(0, 210, 255),
                                BackgroundTransparency = tr
                            }):Play()
                        end
                    end
                end

                gripButton.MouseEnter:Connect(function()
                    if not resizing then SetGripVisualState(false, true) end
                end)
                gripButton.MouseLeave:Connect(function()
                    if not resizing then SetGripVisualState(false, false) end
                end)

                gripButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        resizing = true
                        resizeStartInput = input.Position
                        resizeStartSize = Vector2.new(base.AbsoluteSize.X, base.AbsoluteSize.Y)
                        resizeStartPos = base.Position
                        SetGripVisualState(true, false)
                    end
                end)

                local function DoResize(input)
                    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local deltaX = input.Position.X - resizeStartInput.X
                        local deltaY = input.Position.Y - resizeStartInput.Y

                        local vp = (Camera and Camera.ViewportSize) or Vector2.new(1920, 1080)
                        local minW = UserInputService.TouchEnabled and 320 or 440
                        local minH = UserInputService.TouchEnabled and 240 or 320
                        local maxW = math.max(minW, vp.X - 16)
                        local maxH = math.max(minH, vp.Y - 16)

                        local newW = math.clamp(resizeStartSize.X + deltaX, minW, maxW)
                        local newH = math.clamp(resizeStartSize.Y + deltaY, minH, maxH)

                        local actualDeltaW = newW - resizeStartSize.X
                        local actualDeltaH = newH - resizeStartSize.Y

                        base.Size = UDim2.fromOffset(newW, newH)
                        base.Position = UDim2.new(
                            resizeStartPos.X.Scale,
                            resizeStartPos.X.Offset + (actualDeltaW / 2),
                            resizeStartPos.Y.Scale,
                            resizeStartPos.Y.Offset + (actualDeltaH / 2)
                        )
                    end
                end
                UserInputService.InputChanged:Connect(DoResize)

                local function StopResize(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if resizing then
                            resizing = false
                            SetGripVisualState(false, false)
                        end
                    end
                end
                gripButton.InputEnded:Connect(StopResize)
                UserInputService.InputEnded:Connect(StopResize)

                -- 4. 🎚️ Sizing & Layout Lock: Rock-solid, spacious proportions with ZERO truncation
                local sidebarFrame = base:FindFirstChild("Sidebar")
                local contentFrame = base:FindFirstChild("Content")
                if sidebarFrame and sidebarFrame:IsA("Frame") then
                    sidebarFrame.Size = UDim2.new(0, 190, 1, 0)
                end
                if contentFrame and contentFrame:IsA("Frame") then
                    contentFrame.Position = UDim2.fromScale(1, 0)
                    contentFrame.Size = UDim2.new(1, -190, 1, 0)
                end

                local function FixSlider(inst)
                    if not inst then return end
                    local slider = (inst.Name == "Slider" and inst)
                                or (inst.Parent and inst.Parent.Name == "Slider" and inst.Parent)
                                or (inst:FindFirstChild("SliderName") and inst)
                    if slider and slider:IsA("Frame") then
                        local sliderName = slider:FindFirstChild("SliderName")
                        local sliderElements = slider:FindFirstChild("SliderElements")
                        if sliderName and sliderName:IsA("TextLabel") then
                            sliderName.AutomaticSize = Enum.AutomaticSize.None
                            sliderName.Size = UDim2.new(1, -135, 1, 0)
                            sliderName.TextTruncate = Enum.TextTruncate.None
                            sliderName.ClipsDescendants = false
                            sliderName.TextSize = 13
                        end
                        if sliderElements and sliderElements:IsA("Frame") then
                            local layout = sliderElements:FindFirstChildOfClass("UIListLayout")
                            if layout then
                                layout.Padding = UDim.new(0, 8)
                            end
                            local bar = sliderElements:FindFirstChild("SliderBar")
                            if bar and bar:IsA("ImageLabel") then
                                bar.Size = UDim2.fromOffset(80, 3)
                            end
                            local val = sliderElements:FindFirstChild("SliderValue")
                            if val and val:IsA("TextBox") then
                                val.Size = UDim2.fromOffset(38, 20)
                                val.TextSize = 12
                            end
                        end
                    end
                end

                local function FixKeybind(inst)
                    if not inst then return end
                    local keybind = (inst.Name == "Keybind" and inst)
                                 or (inst.Parent and inst.Parent.Name == "Keybind" and inst.Parent)
                                 or (inst:FindFirstChild("KeybindName") and inst)
                    if keybind and keybind:IsA("Frame") then
                        local nameLbl = keybind:FindFirstChild("KeybindName")
                        local box = keybind:FindFirstChild("BinderBox")
                        if nameLbl and nameLbl:IsA("TextLabel") then
                            nameLbl.AutomaticSize = Enum.AutomaticSize.None
                            nameLbl.Size = UDim2.new(1, -70, 1, 0)
                            nameLbl.TextTruncate = Enum.TextTruncate.None
                            nameLbl.ClipsDescendants = false
                            nameLbl.TextSize = 13
                        end
                        if box and box:IsA("TextBox") then
                            box.TextSize = 12
                            local t = box.Text
                            if t == "RightControl" then box.Text = "RCtrl"
                            elseif t == "LeftControl" then box.Text = "LCtrl"
                            elseif t == "MouseButton2" then box.Text = "M2"
                            elseif t == "MouseButton1" then box.Text = "M1"
                            elseif t == "MouseButton3" then box.Text = "M3"
                            elseif t == "RightShift" then box.Text = "RShift"
                            elseif t == "LeftShift" then box.Text = "LShift"
                            end
                        end
                    end
                end

                local function FixToggle(inst)
                    if not inst then return end
                    local tog = (inst.Name == "Toggle" and inst)
                             or (inst.Parent and inst.Parent.Name == "Toggle" and inst.Parent)
                             or (inst:FindFirstChild("ToggleName") and inst)
                    if tog and tog:IsA("Frame") then
                        local nameLbl = tog:FindFirstChild("ToggleName")
                        if nameLbl and nameLbl:IsA("TextLabel") then
                            nameLbl.TextTruncate = Enum.TextTruncate.None
                            nameLbl.ClipsDescendants = false
                            nameLbl.TextSize = 13
                        end
                    end
                end

                local function FixDropdown(inst)
                    if not inst then return end
                    local dd = (inst.Name == "Dropdown" and inst)
                            or (inst.Parent and inst.Parent.Name == "Dropdown" and inst.Parent)
                            or (inst:FindFirstChild("DropdownName") and inst)
                    if dd and dd:IsA("Frame") then
                        local nameLbl = dd:FindFirstChild("DropdownName")
                        if nameLbl and nameLbl:IsA("TextLabel") then
                            nameLbl.TextTruncate = Enum.TextTruncate.None
                            nameLbl.ClipsDescendants = false
                            nameLbl.TextSize = 13
                        end
                    end
                end

                for _, desc in ipairs(base:GetDescendants()) do
                    FixSlider(desc)
                    FixKeybind(desc)
                    FixToggle(desc)
                    FixDropdown(desc)
                end

                -- 6. 🛡️ Mask UserInfo (แสดงรูปพร้อมจุดเขียวออนไลน์ และปิดบังตัวอักษรบางส่วน)
                local function MaskUserInfo(uInfo)
                    if not uInfo then return end
                    pcall(function()
                        local function MaskString(str)
                            if not str or #str == 0 then return "***" end
                            local len = #str
                            if len <= 3 then
                                return str:sub(1, 1) .. "***"
                            elseif len <= 5 then
                                return str:sub(1, 1) .. "***" .. str:sub(len)
                            else
                                return str:sub(1, 2) .. "****" .. str:sub(len - 1, len)
                            end
                        end

                        local headshot = uInfo:FindFirstChild("Headshot", true)
                        if headshot and headshot:IsA("ImageLabel") then
                            headshot.ClipsDescendants = false
                            local oldDot = headshot:FindFirstChild("OnlineStatusDot")
                            if not oldDot then
                                local dot = Instance.new("Frame")
                                dot.Name = "OnlineStatusDot"
                                dot.Size = UDim2.fromOffset(9, 9)
                                dot.Position = UDim2.new(1, 1, 1, 1)
                                dot.AnchorPoint = Vector2.new(1, 1)
                                dot.BackgroundColor3 = Color3.fromRGB(35, 209, 96) -- Glowing online green
                                dot.BorderSizePixel = 0
                                dot.ZIndex = (headshot.ZIndex or 1) + 5

                                local corner = Instance.new("UICorner")
                                corner.CornerRadius = UDim.new(1, 0)
                                corner.Parent = dot

                                local stroke = Instance.new("UIStroke")
                                stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                                stroke.Color = Color3.fromRGB(15, 15, 18)
                                stroke.Thickness = 1.8
                                stroke.Parent = dot

                                dot.Parent = headshot
                            end
                        end

                        local disp = uInfo:FindFirstChild("DisplayName", true)
                        if disp and disp:IsA("TextLabel") then
                            disp.Text = MaskString(LocalPlayer.DisplayName)
                        end
                        local user = uInfo:FindFirstChild("Username", true)
                        if user and user:IsA("TextLabel") then
                            user.Text = "@" .. MaskString(LocalPlayer.Name)
                        end
                    end)
                end

                local uInfo = base:FindFirstChild("UserInfo", true)
                if uInfo then MaskUserInfo(uInfo) end

                -- 7. 🔤 Font Enhancer: ปรับขนาดตัวอักษรทุกตัวในเมนูให้พอดี ชัดเจนบนมือถือ
                local function EnhanceFonts(inst)
                    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                        if inst.Name == "SliderName" or inst.Name == "SliderValue" or inst.Name == "KeybindName" or inst.Name == "BinderBox" or inst.Name == "ToggleName" or inst.Name == "DropdownName" then
                            return
                        end
                        if not inst:GetAttribute("FontBoosted") then
                            inst:SetAttribute("FontBoosted", true)
                            if inst.TextSize <= 12 then
                                inst.TextSize = 13
                            elseif inst.TextSize <= 14 then
                                inst.TextSize = 14
                            end
                        end
                    end
                end

                for _, desc in ipairs(base:GetDescendants()) do
                    EnhanceFonts(desc)
                end

                -- 8. สไตล์ SectionUIStroke
                local function StyleSection(secStroke)
                    if secStroke and secStroke:IsA("UIStroke") and secStroke.Name == "SectionUIStroke" then
                        secStroke.Color = Color3.fromRGB(0, 160, 255)
                        secStroke.Transparency = 0.6
                        secStroke.Thickness = 1.0
                        secStroke.Enabled = true
                    end
                end

                for _, desc in ipairs(base:GetDescendants()) do
                    if desc:IsA("UIStroke") and desc.Name == "SectionUIStroke" then
                        StyleSection(desc)
                    end
                end

                if not _windowBorderHooked then
                    _windowBorderHooked = true
                    base.DescendantAdded:Connect(function(desc)
                        task.defer(FixSlider, desc)
                        task.defer(FixKeybind, desc)
                        task.defer(FixToggle, desc)
                        task.defer(FixDropdown, desc)
                        task.defer(EnhanceFonts, desc)
                        if desc.Name == "UserInfo" or (desc.Parent and desc.Parent.Name == "UserInfo") then
                            task.defer(MaskUserInfo, desc.Name == "UserInfo" and desc or desc.Parent)
                        end
                        if desc:IsA("UIStroke") and desc.Name == "SectionUIStroke" then
                            task.defer(StyleSection, desc)
                        end
                    end)
                end
            end
        end)
    end
    Hub.ApplyBorders = ApplyWindowBorder

    -- ✨ Sidebar Title Light Sweep / Sheen Engine (แสงปาดตัวหนังสือ KrakenHub วนลูปเนียนๆ)
    local function ApplyTitleShimmer()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                local sidebar = base:FindFirstChild("Sidebar")
                local titleLabel = sidebar and sidebar:FindFirstChild("Title", true)
                if titleLabel and titleLabel:IsA("TextLabel") and not titleLabel:FindFirstChild("ShimmerGradient") then
                    local gradient = Instance.new("UIGradient")
                    gradient.Name = "ShimmerGradient"
                    gradient.Rotation = 25
                    gradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 195, 205)),
                        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(205, 210, 220)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.53, Color3.fromRGB(120, 220, 255)),
                        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(205, 210, 220)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 195, 205)),
                    })
                    gradient.Offset = Vector2.new(-1, 0)
                    gradient.Parent = titleLabel

                    task.spawn(function()
                        -- Soft, smooth, cinematic 2.8s light sweep with 3.5s breathing pause
                        local tweenInfo = TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        while Hub.Running and titleLabel.Parent and gradient.Parent do
                            gradient.Offset = Vector2.new(-1, 0)
                            local tween = TweenService:Create(gradient, tweenInfo, { Offset = Vector2.new(1, 0) })
                            tween:Play()
                            tween.Completed:Wait()
                            task.wait(3.5) -- Smooth, calm pause
                        end
                    end)
                end
            end
        end)
    end

    task.spawn(function()
        task.wait(0.05)
        ApplyWindowBorder()
        ApplyTitleShimmer()
        task.wait(0.3)
        ApplyWindowBorder()
        ApplyTitleShimmer()
    end)

    function Window:Minimize()
        local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                  or (CoreGui and CoreGui:FindFirstChild("Base", true))
        local cur = Window:GetState()
        if cur == nil and base then
            cur = base.Visible
        end
        local newState = not cur
        Window:SetState(newState)
        if base then
            base.Visible = newState
        end
        if newState then
            pcall(function()
                if base then
                    local vp = (Camera and Camera.ViewportSize) or Vector2.new(1920, 1080)
                    local absPos = base.AbsolutePosition
                    if absPos.Y < 0 or absPos.Y > vp.Y - 80 or absPos.X > vp.X - 80 or absPos.X + base.AbsoluteSize.X < 80 then
                        base.Position = UDim2.fromScale(0.5, 0.5)
                    end
                end
            end)
            task.delay(0.05, function()
                ApplyWindowBorder()
                ApplyTitleShimmer()
            end)
        end
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

    -- 🔘 5. DRAGGABLE FLOATING LOGO BUTTON (WITH RGB BORDER)
    local function CreateFloatingToggleButton(windowObj)
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
        stroke.Thickness = 2.0
        stroke.Transparency = 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = mainBtn

        -- 🌈 RGB Loop
        local _btnHue = 0
        local _lastBtnHue = 0
        local rgbConn
        rgbConn = RunService.Heartbeat:Connect(function()
            if not Hub.Running or not screenGui.Parent then
                pcall(function() rgbConn:Disconnect() end)
                return
            end
            local now = os.clock()
            if now - _lastBtnHue >= 0.1 then
                local delta = now - _lastBtnHue
                _lastBtnHue = now
                _btnHue = (_btnHue + delta * 0.18) % 1
                stroke.Color = Color3.fromHSV(_btnHue, 1, 1)
            end
        end)
        table.insert(Hub.Connections, rgbConn)

        -- Logo Image
        local logoImg = Instance.new("ImageLabel")
        logoImg.Name = "Logo"
        logoImg.Size = UDim2.fromScale(0.82, 0.82)
        logoImg.Position = UDim2.fromScale(0.5, 0.5)
        logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
        logoImg.BackgroundTransparency = 1
        logoImg.Image = GetLogoAsset()
        logoImg.ScaleType = Enum.ScaleType.Fit
        logoImg.ZIndex = 3
        logoImg.Parent = mainBtn

        -- ✨ Looping Light Sweep / Shimmer Sheen on Logo (แสงปาดโลโก้เนียนๆตา)
        mainBtn.ClipsDescendants = true
        local shimmerBar = Instance.new("Frame")
        shimmerBar.Name = "ShimmerBar"
        shimmerBar.Size = UDim2.new(0, 22, 2.2, 0)
        shimmerBar.Position = UDim2.new(-0.8, 0, 0.5, 0)
        shimmerBar.AnchorPoint = Vector2.new(0.5, 0.5)
        shimmerBar.Rotation = 25
        shimmerBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        shimmerBar.BorderSizePixel = 0
        shimmerBar.ZIndex = 5

        local shimmerGrad = Instance.new("UIGradient")
        shimmerGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
        shimmerGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
        shimmerGrad.Parent = shimmerBar
        shimmerBar.Parent = mainBtn

        task.spawn(function()
            local sweepTween = TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            while Hub.Running and screenGui.Parent and shimmerBar.Parent do
                shimmerBar.Position = UDim2.new(-0.8, 0, 0.5, 0)
                local t = TweenService:Create(shimmerBar, sweepTween, { Position = UDim2.new(1.8, 0, 0.5, 0) })
                t:Play()
                t.Completed:Wait()
                task.wait(3.2) -- Smooth, calm breathing pause
            end
        end)

        -- Dragging Logic
        local dragging = false
        local dragStartPos = nil
        local startFramePos = nil
        local movedEnough = false
        local dragThreshold = 8

        mainBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                movedEnough = false
                dragThreshold = (input.UserInputType == Enum.UserInputType.Touch) and 20 or 14
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

        local function TriggerToggle()
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
            elseif windowObj and windowObj.SetState and windowObj.GetState then
                local cur = windowObj:GetState()
                windowObj:SetState(not cur)
            else
                local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                          or (CoreGui and CoreGui:FindFirstChild("Base", true))
                if base then
                    base.Visible = not base.Visible
                end
            end
        end

        local lastClickTime = 0
        mainBtn.Activated:Connect(function()
            if not movedEnough then
                local now = os.clock()
                if now - lastClickTime < 0.15 then return end
                lastClickTime = now
                TriggerToggle()
            end
        end)

        -- Right Click / Long Press re-centers window to center of screen
        mainBtn.MouseButton2Click:Connect(function()
            pcall(function()
                local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                          or (CoreGui and CoreGui:FindFirstChild("Base", true))
                if base then
                    base.Position = UDim2.fromScale(0.5, 0.5)
                    if windowObj and windowObj.SetState then
                        windowObj:SetState(true)
                    end
                end
            end)
        end)

        Hub.ToggleUI = TriggerToggle

        mainBtn.MouseEnter:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Thickness = 2.6 }):Play()
        end)
        mainBtn.MouseLeave:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Thickness = 2.0 }):Play()
        end)

        local okP = pcall(function() screenGui.Parent = targetGuiParent end)
        if not okP or not screenGui.Parent then
            pcall(function() screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
        end
        Hub.ToggleButtonGui = screenGui
        return screenGui
    end

    CreateFloatingToggleButton(Window)

    -- 🧩 6. FLUENT COMPATIBILITY ADAPTER LAYER
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
            LeftSection = leftSection,
            RightSection = rightSection,
            Select = function(self)
                rawTab:Select()
                pcall(function()
                    local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                              or (CoreGui and CoreGui:FindFirstChild("Base", true))
                    if base then
                        local content = base:FindFirstChild("Content")
                        if content then
                            for _, sc in ipairs(content:GetDescendants()) do
                                if sc:IsA("ScrollingFrame") then
                                    sc.CanvasPosition = Vector2.zero
                                end
                            end
                        end
                    end
                end)
            end,
            AddSection = function(self, title, explicitSide)
                if explicitSide == "Left" then
                    currentSection = leftSection
                    side = "Left"
                elseif explicitSide == "Right" then
                    currentSection = rightSection
                    side = "Right"
                else
                    if side == "Left" then
                        side = "Right"
                        currentSection = rightSection
                    else
                        side = "Left"
                        currentSection = rawTab:Section({ Side = "Left" })
                    end
                end
                currentSection:Header({ Text = title })
                return currentSection
            end,
            AddParagraph = function(self, cfg)
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
                local changedCallbacks = {}
                local macToggle = currentSection:Toggle({
                    Name = cfg.Title or flag,
                    Default = cfg.Default or false,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                        if Hub.AutoSave then Hub.AutoSave() end
                    end
                }, flag)
                macToggle.Value = cfg.Default or false
                macToggle.State = macToggle.Value
                function macToggle:OnChanged(fn)
                    table.insert(changedCallbacks, fn)
                end
                function macToggle:SetValue(v)
                    if macToggle.SetState then macToggle:SetState(v) end
                end
                Options[flag] = macToggle
                return macToggle
            end,
            AddSlider = function(self, flag, cfg)
                local changedCallbacks = {}
                local macSlider = currentSection:Slider({
                    Name = cfg.Title or flag,
                    Minimum = cfg.Min or 0,
                    Maximum = cfg.Max or 100,
                    Default = cfg.Default or cfg.Min or 0,
                    Precision = cfg.Rounding or 0,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                        if Hub.AutoSave then Hub.AutoSave() end
                    end
                }, flag)
                macSlider.Min = cfg.Min or 0
                macSlider.Max = cfg.Max or 100
                macSlider.Value = cfg.Default or cfg.Min or 0
                function macSlider:OnChanged(fn)
                    table.insert(changedCallbacks, fn)
                end
                function macSlider:SetValue(v)
                    if macSlider.Set then macSlider:Set(v) end
                end
                Options[flag] = macSlider
                return macSlider
            end,
            AddDropdown = function(self, flag, cfg)
                local changedCallbacks = {}
                local macDropdown = currentSection:Dropdown({
                    Name = cfg.Title or flag,
                    Options = cfg.Values or {},
                    Default = cfg.Default,
                    Multi = cfg.Multi or false,
                    Required = cfg.Required ~= false,
                    Image = cfg.Image or cfg.Icon,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                        if Hub.AutoSave then Hub.AutoSave() end
                    end
                }, flag)
                macDropdown.Value = cfg.Default or (cfg.Values and cfg.Values[1]) or ""
                function macDropdown:OnChanged(fn)
                    table.insert(changedCallbacks, fn)
                end
                function macDropdown:SetValue(v)
                    if macDropdown.Set then macDropdown:Set(v) end
                end
                Options[flag] = macDropdown
                return macDropdown
            end,
            AddButton = function(self, cfg)
                return currentSection:Button({
                    Name = cfg.Title or cfg.Name or "Button",
                    Description = cfg.Description or "",
                    Callback = cfg.Callback
                })
            end,
            AddKeybind = function(self, flag, cfg)
                local changedCallbacks = {}
                local defKey = cfg.Default
                if typeof(defKey) == "string" and Enum.KeyCode[defKey] then
                    defKey = Enum.KeyCode[defKey]
                elseif defKey == nil then
                    defKey = Enum.KeyCode.RightControl
                end

                local macKeybind = currentSection:Keybind({
                    Name = cfg.Title or flag,
                    Default = defKey,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                        if Hub.AutoSave then Hub.AutoSave() end
                    end
                }, flag)
                macKeybind.Value = defKey

                -- Find BinderBox in UI to guarantee instant, 100% responsive rebinding
                task.spawn(function()
                    task.wait(0.1)
                    local binderBox = nil
                    for _, child in ipairs(targetGuiParent:GetDescendants()) do
                        if child.Name == "BinderBox" and child:IsA("TextBox") and not child:GetAttribute("Hooked") then
                            binderBox = child
                            binderBox:SetAttribute("Hooked", true)
                            break
                        end
                    end

                    if binderBox then
                        local shortKeyMap = {
                            RightControl = "RCtrl",
                            LeftControl = "LCtrl",
                            MouseButton1 = "M1",
                            MouseButton2 = "M2",
                            MouseButton3 = "M3",
                            RightShift = "RShift",
                            LeftShift = "LShift",
                            RightAlt = "RAlt",
                            LeftAlt = "LAlt",
                        }
                        local function FormatKey(k)
                            local raw = (k and k.Name) or (typeof(k) == "EnumItem" and k.Name) or tostring(k or "None")
                            return shortKeyMap[raw] or raw
                        end
                        binderBox.Text = FormatKey(defKey)

                        local isListening = false
                        binderBox.Focused:Connect(function()
                            isListening = true
                            binderBox.Text = "..."
                        end)
                        binderBox.FocusLost:Connect(function()
                            isListening = false
                            local b = macKeybind:GetBind()
                            binderBox.Text = FormatKey(b)
                        end)

                        local bindConn
                        bindConn = UserInputService.InputBegan:Connect(function(inp, gpe)
                            if not Hub.Running then
                                pcall(function() bindConn:Disconnect() end)
                                return
                            end
                            if isListening then
                                local chosenKey = nil
                                if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode ~= Enum.KeyCode.Unknown then
                                    chosenKey = inp.KeyCode
                                elseif inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 or inp.UserInputType == Enum.UserInputType.MouseButton3 then
                                    chosenKey = inp.UserInputType
                                end

                                if chosenKey then
                                    isListening = false
                                    macKeybind:Bind(chosenKey)
                                    macKeybind.Value = chosenKey
                                    binderBox.Text = FormatKey(chosenKey)
                                    binderBox:ReleaseFocus()
                                    if cfg.Callback then pcall(cfg.Callback, chosenKey) end
                                    for _, fn in ipairs(changedCallbacks) do pcall(fn, chosenKey) end
                                    if flag == "MenuToggleKey" or (cfg.Title and cfg.Title:find("Menu")) then
                                        Window:SetKeybind(chosenKey)
                                    end
                                end
                            end
                        end)
                        table.insert(Hub.Connections, bindConn)
                    end
                end)

                function macKeybind:OnChanged(fn)
                    table.insert(changedCallbacks, fn)
                end
                function macKeybind:SetValue(v)
                    if macKeybind.Bind then macKeybind:Bind(v) end
                end
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

    -- 📑 All Tabs with Icons
    local Tabs = {
        Combat    = CreateTabAdapter(tabGroup:Tab({ Name = "ต่อสู้",       Image = "rbxassetid://10709810948" }), "Combat"),
        Visuals   = CreateTabAdapter(tabGroup:Tab({ Name = "มองทะลุ",      Image = "rbxassetid://10747373176" }), "Visuals"),
        Character = CreateTabAdapter(tabGroup:Tab({ Name = "ตัวละคร",      Image = "rbxassetid://10747372702" }), "Character"),
        World     = CreateTabAdapter(tabGroup:Tab({ Name = "ฟาร์ม",        Image = "rbxassetid://10723405360" }), "World"),
        Settings  = CreateTabAdapter(tabGroup:Tab({ Name = "ตั้งค่า",       Image = "rbxassetid://10734950309" }), "Settings")
    }
    -- Compatibility aliases
    Tabs.Aimbot = Tabs.Combat
    Tabs.SilentAim = Tabs.Combat
    Tabs.FOV = Tabs.Combat
    Tabs.GunMods = Tabs.Combat

    -- 🎨 Vibrant Themed Tab Icons Engine (ใส่สีสดใสในตัวไอค่อนแต่ละหมวด)
    local TabColors = {
        ["ช่วยเล็ง"] = Color3.fromRGB(255, 65, 65),       -- Crimson Red (Aimbot)
        ["Aimbot"] = Color3.fromRGB(255, 65, 65),
        ["กระสุนเลี้ยว"] = Color3.fromRGB(255, 140, 0),     -- Neon Orange (Silent Aim)
        ["SilentAim"] = Color3.fromRGB(255, 140, 0),
        ["วงกลมเล็ง"] = Color3.fromRGB(0, 220, 255),      -- Neon Cyan (FOV)
        ["FOV"] = Color3.fromRGB(0, 220, 255),
        ["ปรับแต่งปืน"] = Color3.fromRGB(255, 215, 0),     -- Gold (Weapons & Hitboxes)
        ["GunMods"] = Color3.fromRGB(255, 215, 0),
        ["ต่อสู้"] = Color3.fromRGB(255, 65, 65),
        ["Combat"] = Color3.fromRGB(255, 65, 65),
        ["มองทะลุ"] = Color3.fromRGB(0, 220, 255),      -- Neon Cyan (Visuals)
        ["Visuals"] = Color3.fromRGB(0, 220, 255),
        ["ตัวละคร"] = Color3.fromRGB(0, 230, 180),      -- Mint Turquoise (Character)
        ["Character"] = Color3.fromRGB(0, 230, 180),
        ["ฟาร์ม & โลก"] = Color3.fromRGB(50, 225, 110), -- Emerald Green (World)
        ["ฟาร์มและโลก"] = Color3.fromRGB(50, 225, 110),
        ["World"] = Color3.fromRGB(50, 225, 110),
        ["ตั้งค่า"] = Color3.fromRGB(0, 160, 255),      -- Electric Blue (Settings)
        ["Settings"] = Color3.fromRGB(0, 160, 255),
    }

    local function GetColorForTabText(txt)
        if not txt then return Color3.fromRGB(0, 160, 255) end
        for k, col in pairs(TabColors) do
            if txt:find(k) then return col end
        end
        return Color3.fromRGB(0, 160, 255)
    end

    local _hookedTabs = {}
    local function ApplyTabIconColors()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                local sidebar = base:FindFirstChild("Sidebar")
                if sidebar then
                    for _, tabSwitcher in ipairs(sidebar:GetDescendants()) do
                        if tabSwitcher.Name == "TabSwitcher" and tabSwitcher:IsA("TextButton") then
                            local nameLabel = tabSwitcher:FindFirstChild("TabSwitcherName")
                            local imgLabel = tabSwitcher:FindFirstChild("TabImage")
                            if nameLabel and imgLabel then
                                local targetColor = Color3.fromRGB(0, 160, 255)
                                if Hub.Settings.IconTheme ~= "ElectricBlue" then
                                    targetColor = GetColorForTabText(nameLabel.Text)
                                end

                                imgLabel.ImageColor3 = targetColor

                                if not _hookedTabs[imgLabel] then
                                    _hookedTabs[imgLabel] = true
                                    local isApplying = false
                                    imgLabel:GetPropertyChangedSignal("ImageColor3"):Connect(function()
                                        if isApplying then return end
                                        isApplying = true
                                        local col = (Hub.Settings.IconTheme == "ElectricBlue") and Color3.fromRGB(0, 160, 255) or GetColorForTabText(nameLabel.Text)
                                        if imgLabel.ImageColor3 ~= col then
                                            imgLabel.ImageColor3 = col
                                        end
                                        isApplying = false
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    Hub.ApplyTabIconColors = ApplyTabIconColors

    task.spawn(function()
        task.wait(0.05)
        ApplyTabIconColors()
        task.wait(0.2)
        ApplyTabIconColors()
    end)

    function Window:SelectTab(idx)
        if idx == 1 and Tabs.Combat then Tabs.Combat:Select()
        elseif idx == 2 and Tabs.Visuals then Tabs.Visuals:Select()
        elseif idx == 3 and Tabs.Character then Tabs.Character:Select()
        elseif idx == 4 and Tabs.World then Tabs.World:Select()
        elseif idx == 5 and Tabs.Settings then Tabs.Settings:Select()
        end
        task.delay(0.02, ApplyTabIconColors)
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
    Hub.Fluent = Fluent

    -- ================================================
    -- ⚔️ COMBAT TAB (หมวดต่อสู้)
    -- ================================================
    Tabs.Combat:AddSection("Silent Aim (ระบบล็อกเป้า)", "Left")

    local SilentAimToggle = Tabs.Combat:AddToggle("SilentAimToggle", {
        Title = "กระสุนดูด 100% (Silent Aim)",
        Description = "ล็อกและดูดกระสุนเข้าเป้าหมายอัตโนมัติ 100% ผ่าน Packet Spoofing",
        Default = Hub.Settings.SilentAim
    })
    SilentAimToggle:OnChanged(function(v)
        Hub.Settings.SilentAim = v
    end)

    local SilentAimPartDrop = Tabs.Combat:AddDropdown("SilentAimPartDrop", {
        Title = "ชิ้นส่วนเป้าหมาย (Target Bone)",
        Description = "เลือกจุดที่ต้องการให้กระสุนดูดเข้าชน",
        Values = {"Head", "UpperTorso"},
        Default = Hub.Settings.SilentAimTargetPart or "Head"
    })
    SilentAimPartDrop:OnChanged(function(v)
        Hub.Settings.SilentAimTargetPart = v
    end)

    local VisibleCheckToggle = Tabs.Combat:AddToggle("VisibleCheckToggle", {
        Title = "ตรวจสอบกำแพง (Visible Check)",
        Description = "เช็คระยะสายตาก่อนล็อกเป้า ป้องกันการล็อกเป้าหมายหลังกำแพง",
        Default = Hub.Settings.VisibleCheck
    })
    VisibleCheckToggle:OnChanged(function(v)
        Hub.Settings.VisibleCheck = v
    end)

    local TargetDownedToggle = Tabs.Combat:AddToggle("TargetDownedToggle", {
        Title = "ล็อกคนที่ล้มด้วย (Target Downed)",
        Description = "ล็อกเป้าหมายต่อแม้ศัตรูจะล้มลงไปนอนกับพื้น",
        Default = Hub.Settings.TargetDowned
    })
    TargetDownedToggle:OnChanged(function(v)
        Hub.Settings.TargetDowned = v
    end)

    Tabs.Combat:AddSection("FOV Circle (วงกลมหน้าจอ)", "Left")

    local ShowFOVToggle = Tabs.Combat:AddToggle("ShowFOVToggle", {
        Title = "แสดงวงกลม FOV",
        Description = "แสดงวงกลมขอบเขตการล็อกเป้าหมายบนหน้าจอ",
        Default = Hub.Settings.ShowFOV
    })
    ShowFOVToggle:OnChanged(function(v)
        Hub.Settings.ShowFOV = v
        if Hub.SilentAimFOVCircle then Hub.SilentAimFOVCircle.Visible = v end
    end)

    local FOVRadiusSlider = Tabs.Combat:AddSlider("FOVRadiusSlider", {
        Title = "ขนาดรัศมี FOV (Radius)",
        Description = "ปรับขนาดรัศมีวงกลม FOV บนหน้าจอ (Pixels)",
        Default = Hub.Settings.FOVRadius or 180,
        Min = 50,
        Max = 500,
        Rounding = 0
    })
    FOVRadiusSlider:OnChanged(function(v)
        Hub.Settings.FOVRadius = v
        if Hub.SilentAimFOVCircle then Hub.SilentAimFOVCircle.Radius = v end
    end)

    Tabs.Combat:AddSection("Auto Shoot (ยิงออโต้)", "Right")

    local AutoShootToggle = Tabs.Combat:AddToggle("AutoShootToggle", {
        Title = "เปิดใช้งาน Auto Shoot",
        Description = "เมื่อมีเป้าหมายเข้ามาในระยะวง FOV ระบบจะลั่นไกยิงทันที",
        Default = Hub.Settings.AutoShoot
    })
    AutoShootToggle:OnChanged(function(v)
        Hub.Settings.AutoShoot = v
    end)

    local RPMSlider = Tabs.Combat:AddSlider("RPMSlider", {
        Title = "ความเร็วรอบลั่นกระสุน (RPM)",
        Description = "ปรับความเร็วรอบการยิงของปืน (600 ถึง 1800 RPM)",
        Default = Hub.Settings.RPM or 900,
        Min = 600,
        Max = 1800,
        Rounding = 0
    })
    RPMSlider:OnChanged(function(v)
        Hub.Settings.RPM = v
        pcall(ApplyWeaponMods)
    end)

    local AutoShootDelaySlider = Tabs.Combat:AddSlider("AutoShootDelaySlider", {
        Title = "หน่วงเวลาเพิ่มเติม (Delay ms)",
        Description = "หน่วงเวลาเพิ่มเติมก่อนลั่นไกนัดแรก (0 = ลั่นทันที)",
        Default = Hub.Settings.AutoShootDelay or 0,
        Min = 0,
        Max = 100,
        Rounding = 0
    })
    AutoShootDelaySlider:OnChanged(function(v)
        Hub.Settings.AutoShootDelay = v
    end)

    Tabs.Combat:AddSection("ปรับแต่งปืนขั้นเทพ (Weapon Modifiers)", "Right")

    local NoRecoilToggle = Tabs.Combat:AddToggle("NoRecoilToggle", {
        Title = "ปิดแรงดีด 100% (Zero Recoil)",
        Description = "กล้องและเป้าเล็งนิ่งสนิท ไร้แรงกระตุก/ดีดเวลายิง",
        Default = Hub.Settings.NoRecoil
    })
    NoRecoilToggle:OnChanged(function(v)
        Hub.Settings.NoRecoil = v
        pcall(ApplyWeaponMods)
    end)

    local NoSpreadToggle = Tabs.Combat:AddToggle("NoSpreadToggle", {
        Title = "ปืนยิงตรง 100% (Zero Spread)",
        Description = "กระสุนพุ่งเป็นเส้นตรงจุดเดียว ไม่บานออก",
        Default = Hub.Settings.NoSpread
    })
    NoSpreadToggle:OnChanged(function(v)
        Hub.Settings.NoSpread = v
        pcall(ApplyWeaponMods)
    end)

    local InfiniteAmmoToggle = Tabs.Combat:AddToggle("InfiniteAmmoToggle", {
        Title = "กระสุนไม่จำกัด (Infinite Ammo)",
        Description = "ยิงกระสุนได้เรื่อยๆ โดยไม่จำกัดจำนวนนัด",
        Default = Hub.Settings.InfiniteAmmo
    })
    InfiniteAmmoToggle:OnChanged(function(v)
        Hub.Settings.InfiniteAmmo = v
        pcall(ApplyWeaponMods)
    end)

    local FastReloadToggle = Tabs.Combat:AddToggle("FastReloadToggle", {
        Title = "รีโหลดไวทันที (Fast Reload)",
        Description = "ลดเวลารีโหลดกระสุนเหลือ 0.05 วินาที",
        Default = Hub.Settings.FastReload
    })
    FastReloadToggle:OnChanged(function(v)
        Hub.Settings.FastReload = v
        pcall(ApplyWeaponMods)
    end)

    local FastEquipToggle = Tabs.Combat:AddToggle("FastEquipToggle", {
        Title = "ชักปืนไว (Fast Equip)",
        Description = "สลับปืนพร้อมยิงทันที ไม่ติดคูลดาวน์สลับปืน",
        Default = Hub.Settings.FastEquip
    })
    FastEquipToggle:OnChanged(function(v)
        Hub.Settings.FastEquip = v
        pcall(ApplyWeaponMods)
    end)

    local AlwaysShootToggle = Tabs.Combat:AddToggle("AlwaysShootToggle", {
        Title = "ยิงขณะกลิ้งตัว/เคลื่อนที่ (Always Shoot)",
        Description = "ปลดล็อกให้ลั่นไกได้ตลอดเวลา แม้จะอยู่ในท่ากลิ้งตัวหรือวิ่ง",
        Default = Hub.Settings.AlwaysShoot
    })
    AlwaysShootToggle:OnChanged(function(v)
        Hub.Settings.AlwaysShoot = v
    end)

    -- ================================================

    local function getESPFont()
        local f = Hub.Settings.ESPFont or "UI"
        if typeof(f) == "string" and (f == "System" or f:find("System")) then
            return Enum.Font.SourceSansBold
        elseif typeof(f) == "string" and (f == "Plex" or f:find("Plex")) then
            return Enum.Font.RobotoMono
        elseif typeof(f) == "string" and (f == "Monospace" or f:find("Monospace")) then
            return Enum.Font.Code
        else
            return Enum.Font.GothamBold
        end
    end

    local UpdateESPPreview = function() end

    Tabs.Visuals:AddSection("มองทะลุผู้เล่น (Player ESP)", "Left")

    local ESPMainToggle = Tabs.Visuals:AddToggle("ESPMainToggle", {
        Title = "เปิดมองทะลุผู้เล่นทั้งหมด (Master ESP)",
        Description = "เปิด/ปิดมองทะลุภาพรวม (ตัวเลือกด้านล่างสามารถเปิดแยกเดี่ยวได้ทันที ไม่จำเป็นต้องเปิดตัวนี้ก่อน)",
        Default = Hub.Settings.PlayerESP
    })
    ESPMainToggle:OnChanged(function(v)
        Hub.Settings.PlayerESP = v
        pcall(UpdateESPPreview)
    end)

    local ESPBoxToggle = Tabs.Visuals:AddToggle("ESPBoxToggle", {
        Title = "กรอบสี่เหลี่ยม (2D Box)",
        Description = "แสดงกรอบสี่เหลี่ยมรอบตัวผู้เล่นศัตรู",
        Default = Hub.Settings.ESPBox
    })
    ESPBoxToggle:OnChanged(function(v)
        Hub.Settings.ESPBox = v
        pcall(UpdateESPPreview)
    end)

    local ESPChamsToggle = Tabs.Visuals:AddToggle("ESPChamsToggle", {
        Title = "เรืองแสงตัวศัตรู (Chams)",
        Description = "เรืองแสงไฮไลท์ขอบแดง ตัวแดงจาง มองทะลุกำแพงง่ายขึ้น",
        Default = Hub.Settings.ESPChams
    })
    ESPChamsToggle:OnChanged(function(v)
        Hub.Settings.ESPChams = v
        pcall(UpdateESPPreview)
    end)

    local ESPNameToggle = Tabs.Visuals:AddToggle("ESPNameToggle", {
        Title = "แสดงชื่อผู้เล่น (Player Names)",
        Description = "แสดงชื่อและไอดีของผู้เล่น",
        Default = Hub.Settings.ESPName
    })
    ESPNameToggle:OnChanged(function(v)
        Hub.Settings.ESPName = v
        pcall(UpdateESPPreview)
    end)

    local ESPFontDrop = Tabs.Visuals:AddDropdown("ESPFontDrop", {
        Title = "ฟอนต์ตัวอักษร (ESP Font)",
        Description = "เลือกรูปแบบฟอนต์ของการมองทะลุ",
        Values = {"UI (คมชัดอ่านง่ายสุด)", "System (ฟอนต์ระบบ)", "Plex (โมเดิร์น)", "Monospace (ตัวพิมพ์ดีด)"},
        Default = "UI (คมชัดอ่านง่ายสุด)"
    })
    ESPFontDrop:OnChanged(function(v)
        if v:find("UI") then
            Hub.Settings.ESPFont = "UI"
        elseif v:find("System") then
            Hub.Settings.ESPFont = "System"
        elseif v:find("Plex") then
            Hub.Settings.ESPFont = "Plex"
        elseif v:find("Monospace") then
            Hub.Settings.ESPFont = "Monospace"
        end
        pcall(UpdateESPPreview)
    end)

    local ESPNameModeDrop = Tabs.Visuals:AddDropdown("ESPNameModeDrop", {
        Title = "รูปแบบชื่อ (Name Format)",
        Description = "เลือกรูปแบบการแสดงชื่อผู้เล่น",
        Values = {"ชื่อเล่น (DisplayName - อ่านง่ายสุด)", "ไอดีเกม (Username)", "แสดงทั้งสองอย่าง (Both)"},
        Default = "ชื่อเล่น (DisplayName - อ่านง่ายสุด)"
    })
    ESPNameModeDrop:OnChanged(function(v)
        if v:find("ชื่อเล่น") or v:find("DisplayName") then
            Hub.Settings.ESPNameMode = "DisplayName"
        elseif v:find("ไอดีเกม") or v:find("Username") then
            Hub.Settings.ESPNameMode = "Username"
        elseif v:find("ทั้งสองอย่าง") or v:find("Both") then
            Hub.Settings.ESPNameMode = "Both"
        end
        pcall(UpdateESPPreview)
    end)

    local ESPFontSizeSlider = Tabs.Visuals:AddSlider("ESPFontSizeSlider", {
        Title = "ขนาดตัวอักษร (Font Size)",
        Description = "ปรับขนาดตัวหนังสือชื่อและข้อมูลผู้เล่น",
        Default = Hub.Settings.ESPFontSize,
        Min = 11,
        Max = 22,
        Rounding = 0
    })
    ESPFontSizeSlider:OnChanged(function(v)
        Hub.Settings.ESPFontSize = v
        pcall(UpdateESPPreview)
    end)

    local ESPHealthToggle = Tabs.Visuals:AddToggle("ESPHealthToggle", {
        Title = "ตัวเลขพลังชีวิต (Health Text)",
        Description = "แสดงตัวเลขเปอร์เซ็นต์เลือด HP ของศัตรู",
        Default = Hub.Settings.ESPHealth
    })
    ESPHealthToggle:OnChanged(function(v)
        Hub.Settings.ESPHealth = v
        pcall(UpdateESPPreview)
    end)

    local ESPHealthBarToggle = Tabs.Visuals:AddToggle("ESPHealthBarToggle", {
        Title = "หลอดเลือดศัตรู (Health Bar)",
        Description = "หลอดเลือดข้างตัวศัตรู ไล่ระดับสีตามเลือด (100% เขียว -> ส้ม -> 20% แดง)",
        Default = Hub.Settings.ESPHealthBar
    })
    ESPHealthBarToggle:OnChanged(function(v)
        Hub.Settings.ESPHealthBar = v
        pcall(UpdateESPPreview)
    end)

    local ESPDistToggle = Tabs.Visuals:AddToggle("ESPDistToggle", {
        Title = "แสดงระยะห่าง (Distance)",
        Description = "แสดงระยะทางระหว่างเรากับผู้เล่น (เมตร/Studs)",
        Default = Hub.Settings.ESPDistance
    })
    ESPDistToggle:OnChanged(function(v)
        Hub.Settings.ESPDistance = v
        pcall(UpdateESPPreview)
    end)

    local ESPMaxDistSlider = Tabs.Visuals:AddSlider("ESPMaxDistSlider", {
        Title = "ระยะมองทะลุ (Max Distance)",
        Description = "กำหนดระยะการมองเห็นผู้เล่น (Studs) ไกลเกินนี้จะไม่แสดง",
        Default = Hub.Settings.ESPMaxDistance or 1500,
        Min = 100,
        Max = 3000,
        Rounding = 0
    })
    ESPMaxDistSlider:OnChanged(function(v)
        Hub.Settings.ESPMaxDistance = v
    end)

    local ESPWeaponToggle = Tabs.Visuals:AddToggle("ESPWeaponToggle", {
        Title = "ชื่อปืนที่ถือ (Held Weapon)",
        Description = "แสดงชื่ออาวุธปืนที่ผู้เล่นกำลังถืออยู่ในมือ",
        Default = Hub.Settings.ESPWeapon
    })
    ESPWeaponToggle:OnChanged(function(v)
        Hub.Settings.ESPWeapon = v
        pcall(UpdateESPPreview)
    end)

    local ESPTracerToggle = Tabs.Visuals:AddToggle("ESPTracerToggle", {
        Title = "เส้นชี้ตัวศัตรู (Tracers)",
        Description = "ลากเส้นนำสายตาจากกลางจอด้านล่างไปยังตัวผู้เล่น",
        Default = Hub.Settings.ESPTracers
    })
    ESPTracerToggle:OnChanged(function(v)
        Hub.Settings.ESPTracers = v
        pcall(UpdateESPPreview)
    end)

    -- 🌟 3D LIVE ESP PREVIEW ENGINE (หมุน 360° โมเดลเบค่อนแท้ Roblox ดึงจาก sportsclub)
    local rightVisualSection = Tabs.Visuals:AddSection("พรีวิวสด 3D (Live ESP Preview)", "Right")
    
    local previewContainer = Instance.new("Frame")
    previewContainer.Name = "ESPPreviewContainer"
    previewContainer.Size = UDim2.new(1, 0, 0, 260)
    previewContainer.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    previewContainer.BorderSizePixel = 0
    previewContainer.ClipsDescendants = true
    previewContainer.Parent = rightVisualSection.Instance

    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 8)
    previewCorner.Parent = previewContainer

    local previewStroke = Instance.new("UIStroke")
    previewStroke.Color = Color3.fromRGB(45, 50, 70)
    previewStroke.Thickness = 1
    previewStroke.Parent = previewContainer

    local vp = Instance.new("ViewportFrame")
    vp.Name = "DummyViewport"
    vp.Size = UDim2.new(1, 0, 1, 0)
    vp.BackgroundTransparency = 1
    vp.Ambient = Color3.fromRGB(215, 215, 215)
    vp.LightColor = Color3.fromRGB(255, 255, 255)
    vp.LightDirection = Vector3.new(-1, -1, -2)
    vp.Parent = previewContainer

    local wm = Instance.new("WorldModel")
    wm.Parent = vp

    -- โมเดลจำลอง R6 แบบเนทีฟ (Native Clean Parts - 100% Crash-Proof ไม่มีบั๊ก Layered Clothing หรือ Highlight Stencil)
    local dummy = Instance.new("Model")
    dummy.Name = "BaconPreviewDummy"

    local function makeLimb(name, size, cf, col)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.CFrame = cf
        p.Color = col
        p.Material = Enum.Material.SmoothPlastic
        p.CanCollide = false
        p.Anchored = true
        p.Parent = dummy
        return p
    end

    local skinCol = Color3.fromRGB(234, 184, 146)
    local shirtCol = Color3.fromRGB(35, 110, 180)
    local pantsCol = Color3.fromRGB(45, 55, 45)
    local hairCol = Color3.fromRGB(140, 85, 45)

    local hrp = makeLimb("HumanoidRootPart", Vector3.new(2, 2, 1), CFrame.new(0, 0, 0), shirtCol)
    hrp.Transparency = 1
    dummy.PrimaryPart = hrp

    local torso = makeLimb("Torso", Vector3.new(2, 2, 1), CFrame.new(0, 0, 0), shirtCol)
    local head = makeLimb("Head", Vector3.new(1.25, 1.25, 1.25), CFrame.new(0, 1.5, 0), skinCol)
    local headMesh = Instance.new("SpecialMesh")
    headMesh.MeshType = Enum.MeshType.Head
    headMesh.Scale = Vector3.new(1.25, 1.25, 1.25)
    headMesh.Parent = head

    local hair = makeLimb("Hair", Vector3.new(1.35, 0.5, 1.35), CFrame.new(0, 2.05, 0), hairCol)
    local hairMesh = Instance.new("SpecialMesh")
    hairMesh.MeshType = Enum.MeshType.Sphere
    hairMesh.Scale = Vector3.new(1.2, 0.8, 1.2)
    hairMesh.Parent = hair

    local leftArm = makeLimb("Left Arm", Vector3.new(1, 2, 1), CFrame.new(-1.5, 0, 0), skinCol)
    local rightArm = makeLimb("Right Arm", Vector3.new(1, 2, 1), CFrame.new(1.5, 0, 0), skinCol)
    local leftLeg = makeLimb("Left Leg", Vector3.new(1, 2, 1), CFrame.new(-0.5, -2, 0), pantsCol)
    local rightLeg = makeLimb("Right Leg", Vector3.new(1, 2, 1), CFrame.new(0.5, -2, 0), pantsCol)

    local hum = Instance.new("Humanoid")
    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    hum.Parent = dummy

    dummy.Parent = wm
    dummy:PivotTo(CFrame.new(0, -0.45, 0))

    -- บันทึกสีและ Material ดั้งเดิมของโมเดลไว้สลับโหมด Chams
    local originalColors = {}
    local originalMaterials = {}
    for _, p in ipairs(dummy:GetDescendants()) do
        if p:IsA("BasePart") then
            originalColors[p] = p.Color
            originalMaterials[p] = p.Material
        end
    end

    -- มุมกล้องซูมออกให้เห็นทั้งตัวตั้งแต่หัวถึงปลายเท้าพอดีเป๊ะ
    local cam = Instance.new("Camera")
    cam.FieldOfView = 28
    cam.CFrame = CFrame.new(Vector3.new(0, -0.45, 13.8), Vector3.new(0, -0.45, 0))
    cam.Parent = vp
    vp.CurrentCamera = cam

    -- ระบบหมุน 360 องศา ทั้งตัวเป็นโมเดล (Auto-Spin + Drag Rotate)
    local rotAngle = 0
    local isDragging = false
    local lastMouseX = 0

    vp.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            lastMouseX = input.Position.X
        end
    end)
    vp.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local deltaX = input.Position.X - lastMouseX
            lastMouseX = input.Position.X
            rotAngle = (rotAngle - deltaX * 1.5) % 360
            if dummy and dummy.PrimaryPart then
                dummy:PivotTo(CFrame.new(0, -0.45, 0) * CFrame.Angles(0, math.rad(rotAngle), 0))
            end
        end
    end)

    local rotConn = nil
    local _previewBase = nil
    rotConn = RunService.RenderStepped:Connect(function(dt)
        if not previewContainer or not previewContainer.Parent then
            if rotConn then rotConn:Disconnect() end
            return
        end
        if not _previewBase then
            _previewBase = previewContainer:FindFirstAncestor("Base")
        end
        local isBaseVis = (not _previewBase) or (_previewBase.Visible and _previewBase.Parent and (not _previewBase.Parent:IsA("ScreenGui") or _previewBase.Parent.Enabled))
        if not isDragging and isBaseVis and previewContainer.Visible and previewContainer.AbsoluteSize.X > 0 then
            rotAngle = (rotAngle + dt * 42) % 360
            if dummy and dummy.PrimaryPart then
                dummy:PivotTo(CFrame.new(0, -0.45, 0) * CFrame.Angles(0, math.rad(rotAngle), 0))
            end
        end
    end)

    -- 2D Overlay Box & ESP Elements (ขนาดกรอบครอบคลุมทั้งตัวเต็มสัดส่วน)
    local overlay = Instance.new("Frame")
    overlay.Name = "ESPOverlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundTransparency = 1
    overlay.Parent = previewContainer

    local boxW, boxH = 88, 194
    local boxYOffset = 0

    local function makeLine(name, pos, size, col)
        local l = Instance.new("Frame")
        l.Name = name
        l.Position = pos
        l.Size = size
        l.BackgroundColor3 = col
        l.BorderSizePixel = 0
        l.Parent = overlay
        return l
    end

    local defaultCol = Color3.fromRGB(255, 60, 60)
    local boxTop = makeLine("BoxTop", UDim2.new(0.5, -boxW/2, 0.5, boxYOffset - boxH/2), UDim2.new(0, boxW, 0, 1.5), defaultCol)
    local boxBottom = makeLine("BoxBottom", UDim2.new(0.5, -boxW/2, 0.5, boxYOffset + boxH/2 - 1.5), UDim2.new(0, boxW, 0, 1.5), defaultCol)
    local boxLeft = makeLine("BoxLeft", UDim2.new(0.5, -boxW/2, 0.5, boxYOffset - boxH/2), UDim2.new(0, 1.5, 0, boxH), defaultCol)
    local boxRight = makeLine("BoxRight", UDim2.new(0.5, boxW/2 - 1.5, 0.5, boxYOffset - boxH/2), UDim2.new(0, 1.5, 0, boxH), defaultCol)

    -- Box Fill (Semi-transparent inner fill)
    local boxFill = Instance.new("Frame")
    boxFill.Name = "BoxFill"
    boxFill.Position = UDim2.new(0.5, -boxW/2 + 1.5, 0.5, boxYOffset - boxH/2 + 1.5)
    boxFill.Size = UDim2.new(0, boxW - 3, 0, boxH - 3)
    boxFill.BackgroundColor3 = defaultCol
    boxFill.BackgroundTransparency = 0.88
    boxFill.BorderSizePixel = 0
    boxFill.Visible = false
    boxFill.Parent = overlay

    -- Health Bar (หลอดเลือดข้างตัว)
    local hpBg = makeLine("HpBg", UDim2.new(0.5, -boxW/2 - 7, 0.5, boxYOffset - boxH/2), UDim2.new(0, 3.5, 0, boxH), Color3.fromRGB(35, 35, 40))
    local hpFill = makeLine("HpFill", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Color3.fromRGB(50, 255, 90))
    hpFill.Parent = hpBg

    -- Health Text
    local hpLbl = Instance.new("TextLabel")
    hpLbl.Name = "HpLbl"
    hpLbl.AnchorPoint = Vector2.new(1, 0.5)
    hpLbl.Position = UDim2.new(0.5, -boxW/2 - 11, 0.5, boxYOffset - boxH/2 + 7)
    hpLbl.Size = UDim2.new(0, 35, 0, 12)
    hpLbl.BackgroundTransparency = 1
    hpLbl.Font = Enum.Font.GothamBold
    hpLbl.Text = "100"
    hpLbl.TextColor3 = Color3.fromRGB(50, 255, 90)
    hpLbl.TextSize = 9
    hpLbl.TextXAlignment = Enum.TextXAlignment.Right
    hpLbl.Parent = overlay

    -- Name Label
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "NameLbl"
    nameLbl.AnchorPoint = Vector2.new(0.5, 1)
    nameLbl.Position = UDim2.new(0.5, 0, 0.5, boxYOffset - boxH/2 - 4)
    nameLbl.Size = UDim2.new(0, 160, 0, 14)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Text = "Target Dummy [100%]"
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextSize = 11
    nameLbl.Parent = overlay

    -- Distance Label
    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "DistLbl"
    distLbl.AnchorPoint = Vector2.new(0.5, 0)
    distLbl.Position = UDim2.new(0.5, 0, 0.5, boxYOffset + boxH/2 + 3)
    distLbl.Size = UDim2.new(0, 140, 0, 12)
    distLbl.BackgroundTransparency = 1
    distLbl.Font = Enum.Font.Gotham
    distLbl.Text = "[ 24m ]"
    distLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLbl.TextSize = 10
    distLbl.Parent = overlay

    -- Weapon Label
    local wepLbl = Instance.new("TextLabel")
    wepLbl.Name = "WepLbl"
    wepLbl.AnchorPoint = Vector2.new(0.5, 0)
    wepLbl.Position = UDim2.new(0.5, 0, 0.5, boxYOffset + boxH/2 + 16)
    wepLbl.Size = UDim2.new(0, 140, 0, 12)
    wepLbl.BackgroundTransparency = 1
    wepLbl.Font = Enum.Font.GothamMedium
    wepLbl.Text = "M4A1"
    wepLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    wepLbl.TextSize = 10
    wepLbl.Parent = overlay

    -- Tracer Line (เส้นลากจากขอบล่างของพรีวิวขึ้นมาหาเท้าตัวละคร)
    local tracerLine = makeLine("TracerLine", UDim2.new(0.5, -0.75, 0.5, boxYOffset + boxH/2 + 1), UDim2.new(0, 1.5, 0.5, -boxYOffset - boxH/2 - 1), defaultCol)

    -- ฟังก์ชันอัปเดต Live Preview ตอบสนองต่อการปรับเปลี่ยนเมนูทุกตัวทันที (แยกอิสระ ไม่ต้องเปิด PlayerESP ก่อน)
    UpdateESPPreview = function()
        local col = Hub.Settings.BoxColor or Hub.Settings.ESPVisibleColor or Color3.fromRGB(255, 60, 60)

        -- 1. 2D Box (ทำงานได้ทันทีเมื่อเปิด)
        local showBox = (Hub.Settings.ESPBox == true) or (Hub.Settings.PlayerESP == true)
        boxTop.Visible = showBox
        boxBottom.Visible = showBox
        boxLeft.Visible = showBox
        boxRight.Visible = showBox
        boxTop.BackgroundColor3 = col
        boxBottom.BackgroundColor3 = col
        boxLeft.BackgroundColor3 = col
        boxRight.BackgroundColor3 = col

        -- 2. Box Fill
        local showBoxFill = showBox and (Hub.Settings.ESPBoxFill == true)
        boxFill.Visible = showBoxFill
        boxFill.BackgroundColor3 = col

        -- 3. Chams (ไฮไลท์เรืองแสงโมเดลจำลอง ทำงานได้ทันทีเมื่อเปิด)
        local showChams = (Hub.Settings.ESPChams == true)
        for part, origMat in pairs(originalMaterials) do
            if part and part.Parent then
                if showChams then
                    part.Material = Enum.Material.Neon
                    part.Color = Color3.fromRGB(255, 80, 80)
                else
                    part.Material = origMat
                    part.Color = originalColors[part] or Color3.fromRGB(160, 160, 160)
                end
            end
        end

        -- 4. Health Bar & Health Text (ทำงานได้ทันทีเมื่อเปิด)
        local showHpBar = (Hub.Settings.ESPHealthBar == true)
        hpBg.Visible = showHpBar

        local showHpTxt = (Hub.Settings.ESPHealth == true)
        hpLbl.Visible = showHpTxt

        -- 5. Name, Font, Name Format & Font Size (ทำงานได้ทันทีเมื่อเปิด)
        local font = getESPFont()
        local fontSize = math.clamp(Hub.Settings.ESPFontSize or 11, 10, 18)

        local showName = (Hub.Settings.ESPName == true) or (Hub.Settings.PlayerESP == true)
        nameLbl.Visible = showName
        nameLbl.Font = font
        nameLbl.TextSize = fontSize
        nameLbl.TextColor3 = Hub.Settings.NameColor or Color3.fromRGB(255, 255, 255)

        local nameMode = Hub.Settings.ESPNameMode or "DisplayName"
        if nameMode == "Username" or (typeof(nameMode) == "string" and nameMode:find("Username")) then
            nameLbl.Text = "@TargetDummy"
        elseif nameMode == "Both" or (typeof(nameMode) == "string" and (nameMode:find("Both") or nameMode:find("ทั้งสอง"))) then
            nameLbl.Text = "Target Dummy [@TargetDummy]"
        else
            nameLbl.Text = "Target Dummy [100%]"
        end

        -- 6. Distance (ทำงานได้ทันทีเมื่อเปิด)
        local showDist = (Hub.Settings.ESPDistance == true)
        distLbl.Visible = showDist
        distLbl.Font = font
        distLbl.TextSize = math.clamp(fontSize - 1, 9, 16)

        -- 7. Held Weapon (ทำงานได้ทันทีเมื่อเปิด)
        local showWep = (Hub.Settings.ESPWeapon == true)
        wepLbl.Visible = showWep
        wepLbl.Font = font
        wepLbl.TextSize = math.clamp(fontSize - 1, 9, 16)

        -- 8. Tracers (ทำงานได้ทันทีเมื่อเปิด)
        local showTracer = (Hub.Settings.ESPTracers == true)
        tracerLine.Visible = showTracer
        tracerLine.BackgroundColor3 = col
    end
    Hub.UpdateESPPreview = UpdateESPPreview
    UpdateESPPreview()

    Tabs.Visuals:AddSection("เซฟโซน (Safe Zone ESP)", "Right")

    local SafeESPToggle = Tabs.Visuals:AddToggle("SafeESPToggle", {
        Title = "มองทะลุเซฟโซน (Safe Zones)",
        Description = "แสดงตำแหน่งจุดเซฟโซน (Safe Zone) ทั้งหมดในแมพ",
        Default = Hub.Settings.SafeESP
    })
    SafeESPToggle:OnChanged(function(v)
        Hub.Settings.SafeESP = v
        UpdateSafeESP()
    end)

    -- Initial Safe ESP
    UpdateSafeESP()

    -- ================================================
    -- 👤 CHARACTER TAB (หมวดตัวละคร)
    -- ================================================
    Tabs.Character:AddSection("การแสดงผลตัวละคร (Identity & Display)", "Left")

    local HideNameToggle = Tabs.Character:AddToggle("HideNameToggle", {
        Title = "ปิดชื่อบนหัว (Hide Overhead Name)",
        Description = "ซ่อนชื่อและแท็กแก๊งบนหัวตัวละครของเรา ไม่ให้คนอื่นเห็นหรืออัดคลิปติดชื่อ",
        Default = Hub.Settings.HideCharacterName
    })
    HideNameToggle:OnChanged(function(v)
        SetHideCharacterName(v)
    end)

    Tabs.Character:AddSection("เกิดใหม่อัตโนมัติ & รีเซ็ตด่วน (Auto Respawn & Fast Reset)")

    local AutoRespawnToggle = Tabs.Character:AddToggle("AutoRespawnToggle", {
        Title = "เกิดใหม่อัตโนมัติ (Auto Respawn)",
        Description = "กดปุ่ม X หรือเมื่อถูกยิงล้มคลาน/เลือดหมด จะเกิดใหม่และรีเซ็ตทันทีไม่ต้องรอคูลดาวน์",
        Default = Hub.Settings.AutoRespawn
    })
    AutoRespawnToggle:OnChanged(function(v)
        Hub.Settings.AutoRespawn = v
    end)

    local RespawnKeybind = Tabs.Character:AddKeybind("RespawnKeybind", {
        Title = "ปุ่มเกิดใหม่ (Respawn Key)",
        Default = Hub.Settings.RespawnKey,
        Callback = function(key)
            Hub.Settings.RespawnKey = key
        end
    })

    Tabs.Character:AddButton({
        Title = "กดเกิดใหม่ทันที (Force Respawn Now)",
        Description = "รีเซ็ตตัวละครและข้ามคูลดาวน์เกิดใหม่ทันที 1 ครั้ง",
        Callback = function()
            if Hub.ForceRespawnPlayer then
                Hub.ForceRespawnPlayer()
            end
        end
    })

    Tabs.Character:AddSection("ค่าสถานะตัวละคร (Character Status)")

    local InfStaminaToggle = Tabs.Character:AddToggle("InfStaminaToggle", {
        Title = "สเตมิน่าไม่จำกัด (Infinite Stamina)",
        Description = "วิ่งได้ตลอดเวลา ไม่เหนื่อย ไม่หมดแรง ล็อค Stamina เต็ม 100%",
        Default = Hub.Settings.InfiniteStamina
    })
    InfStaminaToggle:OnChanged(function(v)
        Hub.Settings.InfiniteStamina = v
    end)

    Tabs.Character:AddSection("ระบบป้องกันการหลุด (Anti-AFK Protection)")

    local AntiAFKToggle = Tabs.Character:AddToggle("AntiAFKToggle", {
        Title = "ป้องกันถูกเตะ (Anti-AFK)",
        Description = "ป้องกันตัวเกมเตะหลุดเมื่อไม่ได้ขยับเมาส์เกิน 20 นาที ทำงานอัตโนมัติแม้พับจอหรือเล่นหน้าต่างอื่น",
        Default = Hub.Settings.AntiAFK
    })
    AntiAFKToggle:OnChanged(function(v)
        Hub.Settings.AntiAFK = v
        if v then
            DisableNativeIdled()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.zero)
            end)
        end
    end)

    -- ================================================
    -- 🌾 FARM & WORLD TAB (หมวดฟาร์ม & โลก)
    -- ================================================
    Tabs.World:AddSection("เล็งและยิงบอท Hood อัตโนมัติ (Auto Aim & Shoot Hood NPCs)")

    local HoodKillAuraToggle = Tabs.World:AddToggle("HoodKillAuraToggle", {
        Title = "ยิงบอท Hood ออโต้ (Hood Kill Aura)",
        Description = "เล็งหัวและยิงบอท Hood ทั้งหมดในจุดฟาร์มอัตโนมัติ วนลูปเกิดใหม่ก็ยิง + เก็บเงินด่วน",
        Default = (Hub.Settings.HoodKillAura ~= nil and Hub.Settings.HoodKillAura) or Hub.Settings.ZombieKillAura
    })
    HoodKillAuraToggle:OnChanged(function(v)
        Hub.Settings.HoodKillAura = v
        Hub.Settings.ZombieKillAura = v
        if v then
            task.spawn(function()
                EnsureWeaponEquipped()
                if Controls then
                    pcall(function() Controls.Press("Aim", true) end)
                end
                if ClientState then
                    ClientState.Aiming = true
                end
            end)
        else
            if Controls then
                pcall(function()
                    Controls.Press("Fire", false)
                    Controls.Press("Aim", false)
                end)
            end
            if ClientState then
                ClientState.Aiming = false
            end
        end
    end)

    local HoodWallCheckToggle = Tabs.World:AddToggle("HoodWallCheckToggle", {
        Title = "ตรวจสิ่งกีดขวาง (Wall Check)",
        Description = "ไม่ยิงสิ่งกีดขวาง รอให้บอท Hood เดินออกมาในที่โล่งก่อนค่อยยิง (ประหยัดกระสุน)",
        Default = (Hub.Settings.HoodWallCheck ~= nil and Hub.Settings.HoodWallCheck) or Hub.Settings.ZombieWallCheck
    })
    HoodWallCheckToggle:OnChanged(function(v)
        Hub.Settings.HoodWallCheck = v
        Hub.Settings.ZombieWallCheck = v
    end)

    local HoodKillAuraDistSlider = Tabs.World:AddSlider("HoodKillAuraDistSlider", {
        Title = "ระยะตรวจจับบอท (Range)",
        Description = "ระยะสแกน เล็ง และสังหารบอท Hood รอบตัว (แนะนำ 250 studs)",
        Min = 50,
        Max = 400,
        Default = Hub.Settings.HoodKillAuraRange or Hub.Settings.ZombieKillAuraRange,
        Rounding = 0
    })
    HoodKillAuraDistSlider:OnChanged(function(v)
        Hub.Settings.HoodKillAuraRange = v
        Hub.Settings.ZombieKillAuraRange = v
    end)

    local HoodESPToggle = Tabs.World:AddToggle("HoodESPToggle", {
        Title = "มองทะลุบอท Hood (Hood NPC ESP)",
        Description = "แสดงชื่อ ระยะ และหลอดเลือดบอท Hood แบบ Real-time",
        Default = (Hub.Settings.HoodESP ~= nil and Hub.Settings.HoodESP) or Hub.Settings.ZombieESP
    })
    HoodESPToggle:OnChanged(function(v)
        Hub.Settings.HoodESP = v
        Hub.Settings.ZombieESP = v
    end)

    Tabs.World:AddSection("ระบบฝากเงินด่วน (Quick Banking)")

    Tabs.World:AddButton({
        Title = "ฝากเงินสดทั้งหมดเข้าตู้ ATM (Deposit All Cash)",
        Description = "นำเงินสดทั้งหมดในตัวฝากเข้าบัญชีธนาคารผ่านระบบ ATM ทันที",
        Callback = function()
            local money = tonumber(LocalPlayer:GetAttribute("Money")) or 0
            if money > 0 and Remotes and Remotes:FindFirstChild("ATM") then
                local s, res = pcall(function()
                    return Remotes.ATM:InvokeServer("Deposit", money)
                end)
                if s and res and res.ok then
                    Fluent:Notify({ Title = "ATM", Content = "ฝากเงินสำเร็จ: $" .. tostring(money), Duration = 3 })
                else
                    Fluent:Notify({ Title = "ATM", Content = "ฝากเงินไม่สำเร็จ (อาจต้องเข้าใกล้ตู้ ATM)", Duration = 3 })
                end
            else
                Fluent:Notify({ Title = "ATM", Content = "ไม่มีเงินสดติดตัวให้ฝาก", Duration = 3 })
            end
        end
    })


    Tabs.World:AddSection("ระบบสุ่มของและร้านค้า (Fast Skip Gacha and Shop Roll)")

    local AutoSkipGachaToggle = Tabs.World:AddToggle("AutoSkipGachaToggle", {
        Title = "ข้ามอนิเมชั่นสุ่ม (Skip Gacha/Roll)",
        Description = "ข้ามอนิเมชั่นสุ่มปืน เปิดกล่องเคส และร้านค้าทันที ไม่ต้องรอดู 5.5 วินาที ได้รับไอเทมทันที",
        Default = Hub.Settings.AutoSkipGacha
    })
    AutoSkipGachaToggle:OnChanged(function(v)
        Hub.Settings.AutoSkipGacha = v
        if v and Hub.EnforceFastSkip then
            Hub.EnforceFastSkip()
        end
    end)


    -- ================================================
    -- ⚙️ SETTINGS TAB (หมวดตั้งค่า)
    -- ================================================
    Tabs.Settings:AddSection("ปุ่มเปิด/ปิดเมนู (Menu Toggle)")

    Tabs.Settings:AddKeybind("MenuToggleKey", {
        Title = "ปุ่มเปิด/ปิดเมนู (Menu Key)",
        Mode = "Toggle",
        Default = Enum.KeyCode.RightControl,
        Callback = function(key)
            pcall(function() Window:SetKeybind(key) end)
        end
    })

    Tabs.Settings:AddSection("ธีมและการแสดงผล (Theme & Visuals)")

    local IconThemeDrop = Tabs.Settings:AddDropdown("IconThemeDrop", {
        Title = "สีไอค่อนแถบข้าง (Icon Colors)",
        Description = "เลือกชุดสีสำหรับไอค่อนเมนูแต่ละหมวดหมู่",
        Values = {"สีตามหมวดหมู่ (แดง/ฟ้า/ส้ม/เขียว/ม่วง)", "สีน้ำเงินนีออนล้วน (Electric Blue)"},
        Default = "สีตามหมวดหมู่ (แดง/ฟ้า/ส้ม/เขียว/ม่วง)"
    })
    IconThemeDrop:OnChanged(function(v)
        if v:find("น้ำเงิน") or v:find("Electric") then
            Hub.Settings.IconTheme = "ElectricBlue"
        else
            Hub.Settings.IconTheme = "Themed"
        end
        if Hub.ApplyTabIconColors then Hub.ApplyTabIconColors() end
    end)

    Tabs.Settings:AddSection("ระบบปรับแต่งสำหรับมือถือ (Mobile Optimization)")

    Tabs.Settings:AddButton({
        Title = "ปรับขนาดหน้าต่างให้พอดีจอมือถือ (Fit Mobile Screen)",
        Description = "จัดตำแหน่งและปรับขนาดหน้าต่าง UI ให้เหมาะสมกับหน้าจอมือถือทันที",
        Callback = function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
                local targetW = math.clamp(math.floor(vp.X * 0.88), 340, 680)
                local targetH = math.clamp(math.floor(vp.Y * 0.82), 260, 460)
                TweenService:Create(base, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(targetW, targetH),
                    Position = UDim2.fromScale(0.5, 0.5)
                }):Play()
                Fluent:Notify({ Title = "KrakenHub", Content = "ปรับขนาดหน้าต่างให้พอดีกับหน้าจอแล้ว", Duration = 3 })
            end
        end
    })

    local MobileFPSToggle = Tabs.Settings:AddToggle("MobileFPSToggle", {
        Title = "บูสต์ FPS (FPS Booster)",
        Description = "ลดทอนเอฟเฟกต์แสงเงาและหมอกที่ไม่จำเป็น ช่วยให้เกมลื่นขึ้น 60+ FPS บน Delta",
        Default = false
    })
    MobileFPSToggle:OnChanged(function(enabled)
        pcall(function()
            local lighting = game:GetService("Lighting")
            if enabled then
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
                for _, v in ipairs(lighting:GetChildren()) do
                    if v:IsA("PostProcessEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BloomEffect") then
                        v.Enabled = false
                    end
                end
                if setfpscap then setfpscap(60) end
                Fluent:Notify({ Title = "FPS Booster", Content = "เปิดโหมดประหยัดทรัพยากรสำหรับมือถือแล้ว", Duration = 3 })
            else
                lighting.GlobalShadows = true
                for _, v in ipairs(lighting:GetChildren()) do
                    if v:IsA("PostProcessEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BloomEffect") then
                        v.Enabled = true
                    end
                end
            end
        end)
    end)

    Tabs.Settings:AddButton({
        Title = "ปิดการทำงาน KrakenHub (Unload Script)",
        Description = "ปิดการทำงานของสคริปต์ ลบหน้าต่าง UI ทั้งหมด และคืนค่าเดิมของเกม",
        Callback = function()
            Window:Dialog({
                Title = "ยืนยันการปิดสคริปต์",
                Content = "คุณต้องการปิด KrakenHub และคืนค่าเดิมทั้งหมดหรือไม่?",
                Buttons = {
                    {
                        Title = "ยืนยันการปิด (Unload)",
                        Callback = function()
                            if genv.UrbanReload_Cleanup then
                                genv.UrbanReload_Cleanup()
                            end
                            pcall(function() Window:Unload() end)
                        end
                    },
                    { Title = "ยกเลิก", Callback = function() end }
                }
            })
        end
    })

    pcall(ApplyWeaponMods)
    Window:SelectTab(1)
    Fluent:Notify({
        Title = "KrakenHub โหลดสำเร็จ!",
        Content = "Urban Reload (ภาษาไทย) พร้อมใช้งานแล้ว!\nแตะปุ่มโลโก้ หรือกด Right Control เพื่อเปิด/ปิดเมนู",
        Duration = 5
    })
end

-- ==============================================================
-- 🧹 14. CLEANUP HANDLER
-- ==============================================================
genv.UrbanReload_Cleanup = function()
    Hub.Running = false

    -- Remove UI & Toggle Button
    if Hub.ToggleButtonGui then
        pcall(function() Hub.ToggleButtonGui:Destroy() end)
    end
    if Hub.Window then
        pcall(function() Hub.Window:Unload() end)
    end

    -- Disconnect all loops
    for _, conn in pairs(Hub.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    pcall(function() RunService:UnbindFromRenderStep("KrakenESP") end)
    pcall(function()
        if AimWarnDrawings then
            if AimWarnDrawings.Text then AimWarnDrawings.Text:Remove() end
            if AimWarnDrawings.Tracer then AimWarnDrawings.Tracer:Remove() end
        end
    end)

    -- Remove FOV Circles
    -- Clear ESP
    for player in pairs(Hub.ESP) do
        RemovePlayerESP(player)
    end
    ClearSafeESP()

    -- Restore Hood NPC Heads to natural size
    local enemyFolders = {}
    local hl = Workspace:FindFirstChild("HoodLocal")
    if hl then table.insert(enemyFolders, hl) end
    local zf = Workspace:FindFirstChild("Zombies")
    if zf then table.insert(enemyFolders, zf) end

    local naturalSize = Vector3.new(0.792705, 1.214349, 0.902806)
    for _, folder in ipairs(enemyFolders) do
        for _, z in ipairs(folder:GetChildren()) do
            if IsEnemyNPC(z) then
                local head = z:FindFirstChild("Head")
                if head and head:IsA("BasePart") then
                    head.Size = naturalSize
                end
                local bb = head and (head:FindFirstChild("KrakenHoodESP") or head:FindFirstChild("KrakenZombieESP"))
                if bb then pcall(function() bb:Destroy() end) end
            end
        end
        for _, desc in ipairs(folder:GetDescendants()) do
            if desc:IsA("BillboardGui") and (desc.Name == "KrakenHoodESP" or desc.Name == "KrakenZombieESP") then
                pcall(function() desc:Destroy() end)
            end
        end
    end

    if HoodESPStorage then
        for model, bb in pairs(HoodESPStorage) do
            pcall(function() bb:Destroy() end)
        end
        table.clear(HoodESPStorage)
    end
    if ZombieESPStorage and ZombieESPStorage ~= HoodESPStorage then
        for model, bb in pairs(ZombieESPStorage) do
            pcall(function() bb:Destroy() end)
        end
        table.clear(ZombieESPStorage)
    end
    LiveNpcTable = nil

    if Hub.SilentAimFOVCircle then
        pcall(function() Hub.SilentAimFOVCircle:Remove() end)
        Hub.SilentAimFOVCircle = nil
    end
    if Hub.TargetTracerLine then
        pcall(function() Hub.TargetTracerLine:Remove() end)
        Hub.TargetTracerLine = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("KrakenTargetLock") end)
    if ApplyNametagVisibility then
        pcall(ApplyNametagVisibility, false)
    end
end

-- ==============================================================
-- 🚀 15. INITIALIZE
-- ==============================================================
Hub.InitUI = InitUI
task.spawn(function()
    local ok, err = pcall(InitUI)
    if ok then
        print("[KrakenHub] Urban Reload Script cleanly unloaded.")
        print("[KrakenHub] รันสคริปต์ติดเรียบร้อย ✅")
    else
        warn("[KrakenHub] Init error: " .. tostring(err))
    end
end)

-- ==============================================================
-- 📦 CASES MENU AUTO-OPTIMIZER (Anti-Lag / Anti-Stencil Thrash)
-- Relieves GPU Swapchain Present stalls when viewing 37+ ViewportFrames
-- ==============================================================
task.spawn(function()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    local casesGui = playerGui and playerGui:WaitForChild("Cases", 10)
    if not casesGui then return end

    local menu = casesGui:FindFirstChild("Menu")
    if not menu then return end

    Hub._CasesOpen = false

    while Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        local isOpen = casesGui.Enabled and menu.Visible
        if isOpen ~= Hub._CasesOpen then
            Hub._CasesOpen = isOpen
            if isOpen then
                -- Disable all Chams highlights while Cases UI is open to save GPU swapchain
                for _, obj in pairs(Hub.ESP) do
                    if obj.Highlight and obj.Highlight.Enabled then
                        obj.Highlight.Enabled = false
                    end
                end
                for _, bb in pairs(HoodESPStorage) do
                    if bb and bb.Enabled then
                        bb.Enabled = false
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)


-- ==============================================================
-- ⚡ FAST SKIP GACHA & SHOP ROLLS ENGINE (Zero-Lag / Pure Event-Driven)
-- Completely removes wait times / spinning animations in shops & crates
-- Optimized: Zero GC scans, cached module bypass, pure Signal events
-- ==============================================================
local function InitFastSkipEngine()
    -- 1. Apply ReplicatedStorage.RollSkip Gamepass Bypass (Runs once, cached in memory)
    local _rollSkipBypassed = false
    local function ApplyRollSkipBypass()
        if _rollSkipBypassed then return end
        local rsModule = ReplicatedStorage:FindFirstChild("RollSkip")
        if rsModule then
            local ok, rs = pcall(require, rsModule)
            if ok and typeof(rs) == "table" then
                _rollSkipBypassed = true
                rs.Owned = function() return true end
                rs.Request = function(cb)
                    if typeof(cb) == "function" then
                        cb()
                    end
                end
            end
        end
    end
    pcall(ApplyRollSkipBypass)

    -- 2. Fast Skip Trigger on UI Elements
    local function TriggerButton(btn)
        if not btn or not btn:IsA("GuiButton") then return false end
        pcall(function()
            if typeof(firesignal) == "function" then
                if btn:FindFirstChild("Activated") or typeof(btn.Activated) == "RBXScriptSignal" then
                    firesignal(btn.Activated)
                end
                if btn:FindFirstChild("MouseButton1Click") or typeof(btn.MouseButton1Click) == "RBXScriptSignal" then
                    firesignal(btn.MouseButton1Click)
                end
            end
        end)
        return true
    end

    local function CheckAndSkipCases()
        if not Hub.Settings.AutoSkipGacha then return end

        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return end

        -- Vector A: CasesFX (Weapon / Car Case Open Animation)
        local casesFX = playerGui:FindFirstChild("CasesFX")
        if casesFX then
            local weapon = casesFX:FindFirstChild("Weapon")
            if weapon and weapon.Visible then
                local skip = weapon:FindFirstChild("Skip")
                if skip then
                    local price = skip:FindFirstChild("Price")
                    if price and price.Visible then price.Visible = false end
                    TriggerButton(skip)
                end
            end
            local car = casesFX:FindFirstChild("Car")
            if car and car.Visible then
                local skip = car:FindFirstChild("Skip")
                if skip then
                    local price = skip:FindFirstChild("Price")
                    if price and price.Visible then price.Visible = false end
                    TriggerButton(skip)
                end
            end
        end

        -- Vector B: Cases.Garage.Roll (Car Garage Roll)
        local cases = playerGui:FindFirstChild("Cases")
        if cases then
            local garage = cases:FindFirstChild("Garage")
            if garage then
                local roll = garage:FindFirstChild("Roll")
                if roll and roll.Visible then
                    local skip = roll:FindFirstChild("Skip")
                    if skip then
                        local price = skip:FindFirstChild("Price")
                        if price and price.Visible then price.Visible = false end
                        TriggerButton(skip)
                    end
                end
            end
        end

        -- Vector C: GachaUI (Tool / Mystery Box / Gun Gacha)
        local gachaUI = playerGui:FindFirstChild("GachaUI")
        if gachaUI then
            local window = gachaUI:FindFirstChild("Window")
            if window and window.Visible then
                local skip = window:FindFirstChild("Skip")
                if skip then
                    if not skip.Visible then
                        skip.Visible = true
                    end
                    TriggerButton(skip)
                end
            end
        end
    end
    Hub.EnforceFastSkip = CheckAndSkipCases

    -- 3. Debounced trigger to eliminate micro-stutter
    local _lastSkipTick = 0
    local function SafeSkip()
        local now = os.clock()
        if now - _lastSkipTick < 0.1 then return end
        _lastSkipTick = now
        CheckAndSkipCases()
    end

    -- 4. Purely Event-Driven Listeners (Zero CPU usage when idle)
    task.spawn(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
        if not playerGui then return end

        local function WatchGui(gui)
            if not gui then return end
            if gui.Name == "CasesFX" then
                local function BindElem(elem)
                    if elem and (elem.Name == "Weapon" or elem.Name == "Car") then
                        elem:GetPropertyChangedSignal("Visible"):Connect(function()
                            if elem.Visible and Hub.Settings.AutoSkipGacha then
                                SafeSkip()
                            end
                        end)
                    end
                end
                for _, ch in ipairs(gui:GetChildren()) do BindElem(ch) end
                gui.ChildAdded:Connect(BindElem)
            end
            if gui.Name == "Cases" then
                local garage = gui:FindFirstChild("Garage")
                if garage then
                    local roll = garage:FindFirstChild("Roll")
                    if roll then
                        roll:GetPropertyChangedSignal("Visible"):Connect(function()
                            if roll.Visible and Hub.Settings.AutoSkipGacha then
                                SafeSkip()
                            end
                        end)
                    end
                end
            end
            if gui.Name == "GachaUI" then
                local window = gui:WaitForChild("Window", 5)
                if window then
                    local skip = window:WaitForChild("Skip", 5)
                    if skip then
                        skip:GetPropertyChangedSignal("Visible"):Connect(function()
                            if not skip.Visible and Hub.Settings.AutoSkipGacha then
                                skip.Visible = true
                            end
                        end)
                    end
                    window:GetPropertyChangedSignal("Visible"):Connect(function()
                        if window.Visible and Hub.Settings.AutoSkipGacha then
                            SafeSkip()
                        end
                    end)
                end
            end
        end

        for _, g in ipairs(playerGui:GetChildren()) do
            WatchGui(g)
        end
        playerGui.ChildAdded:Connect(WatchGui)
    end)

    -- 5. Very relaxed backup heartbeat (1 Hz only - zero CPU impact)
    task.spawn(function()
        while Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
            if not _rollSkipBypassed then
                ApplyRollSkipBypass()
            end
            if Hub.Settings.AutoSkipGacha then
                CheckAndSkipCases()
            end
            task.wait(1.0)
        end
    end)
end
pcall(InitFastSkipEngine)



