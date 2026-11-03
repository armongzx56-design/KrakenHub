-- ==============================================================
-- 🌊 KRAKENHUB | URBAN RELOAD (LEGIT & SAFE EDITION - เซิร์ฟทั่วไป 100%)
-- Game: https://www.roblox.com/games/84448037861644/Urban-Reload
-- PlaceId: 84448037861644
--
-- Features:
-- • 🛡️ 100% Anti-Detection: Blocks all Honeypot remotes (AdminTools & GunTuning -> Beat)
-- • 🔒 Anti-Shadowban Engine: Humanized aim, random bone hit, angle clamps, safe hitbox (No Cheater Server)
-- • 🎯 Combat Engine: Legit Silent Aim (82% Hit Chance, 35% Headshot) + Smooth Camera Aimbot
-- • 🔫 Weapon Mods: Legit Recoil Dampener + Full Auto + Safe Handling
-- • 👁️ Visuals: 2D Box ESP + Skeleton Tracers + Health Bar + Distance + Safe/Loot ESP
-- 🌾 Humanized Farm Assist: Legit Bot Aim (Lerp smooth) + Proximity Auto Loot [E] (<=12m) + Safe ESP (No Warps)
-- • ⚡ Character: Infinite Stamina + Instant Respawn (Key X) + Fast Reset
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
genv._UrbanReloadLegitScriptId = (genv._UrbanReloadLegitScriptId or 0) + 1
_G._UrbanReloadLegitScriptId = genv._UrbanReloadLegitScriptId
local SCRIPT_ID = genv._UrbanReloadLegitScriptId

if genv.UrbanReloadLegit_Cleanup then
    pcall(genv.UrbanReloadLegit_Cleanup)
end

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
                ClientState.RecoilScale = 0
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
    local is_l = islclosure or is_l_closure or function(f) return type(f) == "function" end
    local is_exec = isexecutorclosure or is_executor_closure or checkcaller or function() return false end

    if typeof(getgc) == "function" and typeof(get_upvalues) == "function" then
        local gc = getgc()

        -- Pass 1: Find closures containing Beat or HHeartbeatB
        for _, fn in ipairs(gc) do
            if type(fn) == "function" and is_l(fn) and not is_exec(fn) then
                local ups = get_upvalues(fn)
                if ups then
                    local hasBeat = false
                    local candQueue = nil
                    local candBencode = nil

                    for _, val in pairs(ups) do
                        if typeof(val) == "Instance" then
                            if val.Name == "Beat" then
                                hasBeat = true
                            elseif val.Name == "HHeartbeatB" then
                                AntiHitboxFn = fn
                            end
                        elseif type(val) == "table" and #val == 0 then
                            candQueue = val
                        elseif type(val) == "function" then
                            candBencode = val
                        end
                    end

                    if hasBeat and candQueue then
                        NetBeatQueue = candQueue
                        if candBencode then
                            NetBeatBencode = candBencode
                        end
                    end
                end
            end
        end

        -- Pass 2: Using NetBeatQueue, find report(), filter table (u103), and watchlists
        for _, fn in ipairs(gc) do
            if type(fn) == "function" and is_l(fn) and not is_exec(fn) then
                local ups = get_upvalues(fn)
                if ups then
                    local hasQueue = false
                    local candFilter = nil
                    local numCount = 0

                    for _, val in pairs(ups) do
                        if val == NetBeatQueue then
                            hasQueue = true
                        elseif type(val) == "table" and val ~= NetBeatQueue then
                            candFilter = val
                        elseif type(val) == "number" then
                            numCount = numCount + 1
                        end
                    end

                    if hasQueue and candFilter and numCount >= 1 then
                        NetBeatReportFn = fn
                        NetBeatFilter = candFilter
                    end

                    for _, val in pairs(ups) do
                        if type(val) == "table" and #val > 0 then
                            local first = val[1]
                            if type(first) == "table" and first.name ~= nil and first.s ~= nil and first.t ~= nil then
                                NetBeatWatchList = val
                            elseif type(first) == "table" and (first.FireRate ~= nil or first.WalkSpeed ~= nil) then
                                NetBeatBaitList = val
                            end
                        elseif type(val) == "table" and val.Highlight == true and val.BillboardGui == true then
                            NetBeatESPList = val
                        end
                    end
                end
            end
        end

        -- Pass 3: Find the check loop (which has NetBeatReportFn as upvalue) to hook namecallRatio
        if NetBeatReportFn then
            for _, fn in ipairs(gc) do
                if type(fn) == "function" and is_l(fn) and not is_exec(fn) then
                    local ups = get_upvalues(fn)
                    if ups then
                        local hasReport = false
                        local candRatio = nil
                        for _, val in pairs(ups) do
                            if val == NetBeatReportFn then
                                hasReport = true
                            elseif type(val) == "function" and val ~= NetBeatReportFn then
                                candRatio = val
                            end
                        end
                        if hasReport and candRatio then
                            NetBeatRatioFn = candRatio
                        end
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
        local oldBencode = NetBeatBencode
        hookfunction(NetBeatBencode, function(p15, p16, p17, p18)
            if p17 ~= 0 and p17 ~= 1 then
                p17 = 0
                p18 = ""
            end
            return oldBencode(p15, p16, p17, p18)
        end)
    end)
end

-- 1.8 Hook HHeartbeatB (Anti-Hitbox Remote)
if HHeartbeatB and typeof(hookfunction) == "function" then
    pcall(function()
        hookfunction(HHeartbeatB.FireServer, function(...) return nil end)
    end)
end
if AntiHitboxFn and typeof(hookfunction) == "function" then
    pcall(function()
        hookfunction(AntiHitboxFn, function(...) return false, nil end)
    end)
end

-- 1.9 Direct Beat:FireServer Hook (Honeypot & Buffer Scrubbing - ZERO NAMECALL HOOKS)
if BeatRemote and typeof(hookfunction) == "function" then
    pcall(function()
        local oldBeatFire = nil
        oldBeatFire = hookfunction(BeatRemote.FireServer, function(self, ...)
            local args = {...}
            -- 1. Drop number-code honeypots (AdminTools 7312, 7419, 7420, etc.)
            if typeof(args[1]) == "number" and args[1] >= 7000 then
                return nil
            end
            if typeof(args[2]) == "table" and args[2].p ~= nil then
                return nil
            end
            -- 2. Scrub buffer packets (if code at offset 4 is an anomaly report)
            if typeof(args[1]) == "buffer" then
                local buf = args[1]
                if buffer.len(buf) >= 6 then
                    local code = buffer.readu16(buf, 4)
                    if code >= 7000 or (code ~= 0 and code ~= 1) then
                        buffer.writeu16(buf, 4, 0)
                        buffer.writeu8(buf, 6, 0)
                    end
                end
            end
            return oldBeatFire(self, ...)
        end)
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
        if ClientState and type(ClientState) == "table" then
                    end
        task.wait(1)
    end
end)

-- ==============================================================
-- 📦 2. GAME REFERENCES & WEAPON MODULES
-- ==============================================================
local Weapons = ReplicatedStorage:WaitForChild("Weapons", 10)
local ClientState = Weapons and require(Weapons:WaitForChild("ClientState", 5))
local Config = Weapons and require(Weapons:WaitForChild("Config", 5))
local WeaponData = Weapons and require(Weapons:WaitForChild("WeaponData", 5))
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local SafeZoneModule = ReplicatedStorage:FindFirstChild("SafeZone") and require(ReplicatedStorage.SafeZone)

-- Backup original weapon configs for clean restore
local OriginalWeaponData = {}
if WeaponData then
    for name, data in pairs(WeaponData) do
        if type(data) == "table" then
            OriginalWeaponData[name] = {
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
                    Hip = data.Bloom.Hip,
                    PerShot = data.Bloom.PerShot,
                    Aim = data.Bloom.Aim,
                },
                Fire = data.Fire and {
                    RPM = data.Fire.RPM,
                    Mode = data.Fire.Mode,
                },
                Ammo = data.Ammo and {
                    ReloadTime = data.Ammo.ReloadTime,
                },
                Handling = data.Handling and {
                    HitboxScale = data.Handling.HitboxScale,
                }
            }
        end
    end
end

-- ==============================================================
-- ⚙️ 3. HUB CONFIGURATION STATE
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
        -- Mode Selection (Default: Legit / Anti-Shadowban)
        LegitMode = true,

        -- Combat / Silent Aim (Bullet Snapping / Redirection)
        SilentAim = true,
        SilentAimBone = "LegitRandom", -- "LegitRandom", "Head", "UpperTorso", "Random"
        SilentAimFOV = 110,
        SilentAimMaxDist = 320,
        SilentAimHitChance = 82,
        SilentAimMaxAngle = 20,
        SilentAimWallCheck = true,
        SilentAimIgnoreSafeZone = true,
        SilentAimIgnoreShield = true,
        SilentAimIgnoreDowned = true,
        SilentAimPriority = "Crosshair", -- "Crosshair", "Distance"
        SilentAimTargetHood = true,
        SilentAimTargetZombies = true,
        SilentAimDrawFOV = false,
        SilentAimFOVColor = Color3.fromRGB(0, 200, 255),
        SilentAimFOVRainbow = false,
        SilentAimFOVR = 0,
        SilentAimFOVG = 200,
        SilentAimFOVB = 255,
        RedDamageNumbers = true,
        IconTheme = "Themed", -- "Themed", "ElectricBlue"

        -- FOV Circle Styles
        FOVCircleThickness = 1.5,
        FOVCircleTransparency = 0.85,
        FOVCircleFilled = false,

        -- Hitbox Expander (Bullet Tracking into Head - Disabled by default in Legit)
        HitboxExpander = false,
        HitboxSize = 2.5,
        HitboxTarget = "Head",
        HitboxVisible = false,
        HitboxTransparency = 0.65,

        -- Auto Respawn (Key X / Instant Reset)
        AutoRespawn = true,
        RespawnKey = Enum.KeyCode.X,

        -- Weapon Mods (Legit / Undetected)
        NoRecoil = false,
        RecoilScale = 0.35,
        NoSpread = false,
        RapidFire = false,
        RapidFireRPM = 1100,
        FullAuto = true,
        InstantReload = false,
        FastReloadRatio = 1.0,

        InfiniteStamina = true,

        -- Visuals (ESP)
        PlayerESP = true,
        ESPBox = true,
        ESPName = true,
        ESPFont = "UI", -- "UI", "System", "Plex", "Monospace"
        ESPFontSize = 13,
        ESPNameMode = "DisplayName", -- "DisplayName", "Username", "Both"
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

        -- Character
        HideCharacterName = false,

        -- World ESP
        SafeESP = true,
        LootESP = true,
        HalloweenESP = true,
        ATMESP = false,

        -- Hood NPC Auto Aim & Shoot Kill Aura
        HoodKillAura = false,
        HoodKillAuraRange = 50,
        HoodWallCheck = true,
        HoodESP = true,
        AutoLootNear = true,
        SavedFarmSpot = Vector3.new(-1033.4, 14.6, 427.6),
        -- Aliases
        ZombieKillAura = false,
        ZombieKillAuraRange = 250,
        ZombieWallCheck = true,
        ZombieESP = true,
    }
}
genv.KrakenHub = Hub

-- ================================================
-- ⭕ 4. SILENT AIM FOV DRAWING CIRCLE
-- ================================================
local SilentFOVCircle = Drawing.new("Circle")
SilentFOVCircle.Visible = false
SilentFOVCircle.Radius = Hub.Settings.SilentAimFOV or 180
SilentFOVCircle.Color = Hub.Settings.SilentAimFOVColor or Color3.fromRGB(255, 140, 0)
SilentFOVCircle.Thickness = Hub.Settings.FOVCircleThickness or 1.5
SilentFOVCircle.Filled = false
SilentFOVCircle.NumSides = 64
SilentFOVCircle.Transparency = Hub.Settings.FOVCircleTransparency or 0.85

local FOVCircle = SilentFOVCircle -- Compatibility alias

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

    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    if direction.Magnitude < 0.2 then return true end

    local ignoreList = {LocalPlayer.Character, Camera}
    local ch = Workspace:FindFirstChild("ClientHitboxes")
    if ch then table.insert(ignoreList, ch) end
    local gl = Workspace:FindFirstChild("GroundLoot")
    if gl then table.insert(ignoreList, gl) end

    SharedRayParams.FilterDescendantsInstances = ignoreList

    for _ = 1, 3 do
        local result = Workspace:Raycast(origin, direction, SharedRayParams)
        if not result then return true end
        if result.Instance:IsDescendantOf(targetChar) then return true end
        if (not result.Instance.CanCollide) or result.Instance.Transparency >= 0.7 or result.Instance.Name == "Hitbox" then
            table.insert(ignoreList, result.Instance)
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

-- Fast Line-of-Sight Check for Hood NPCs (Capped to 3 iterations)
local function IsHoodVisible(targetHead, targetNpc)
    if not targetHead or not targetNpc then return false end

    local origin = Camera.CFrame.Position
    local destination = targetHead.Position
    local direction = destination - origin
    if direction.Magnitude < 0.2 then return true end

    local ignoreList = {Camera, LocalPlayer.Character}
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

    for _ = 1, 3 do
        local result = Workspace:Raycast(origin, direction, SharedRayParams)
        if not result then return true end
        local inst = result.Instance
        if inst:IsDescendantOf(targetNpc) then return true end

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
-- ⚡ 5.1 SILENT AIM TARGETING & HOOK ENGINE
-- Dedicated standalone bullet redirection
-- ================================================
local function IsSilentAimTargetValid(player)
    if not player or player == LocalPlayer then return false end
    if not IsEnemy(player) then return false end

    local char = player.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not hrp then return false end

    if Hub.Settings.SilentAimIgnoreDowned and char:GetAttribute("Downed") == true then
        return false
    end

    if Hub.Settings.SilentAimIgnoreShield and char:GetAttribute("SpawnShield") == true then
        return false
    end

    if Hub.Settings.SilentAimIgnoreSafeZone then
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

local function GetSilentAimTarget()
    if not Hub.Settings.SilentAim then return nil, nil, false end

    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = nil
    local bestBone = nil
    local bestScore = math.huge
    local isNpcTarget = false

    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos = (myHRP and myHRP.Position) or Camera.CFrame.Position

    -- 1. Check Hood NPCs if enabled
    if Hub.Settings.SilentAimTargetHood or Hub.Settings.SilentAimTargetZombies or Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura then
        local enemyFolders = {}
        local hl = Workspace:FindFirstChild("HoodLocal")
        if hl then table.insert(enemyFolders, hl) end
        local zf = Workspace:FindFirstChild("Zombies")
        if zf then table.insert(enemyFolders, zf) end

        for _, folder in ipairs(enemyFolders) do
            for _, z in ipairs(folder:GetChildren()) do
                if IsEnemyNPC(z) then
                    local hp, maxHp, isDead = GetHoodRealtimeData(z)
                    local head = z:FindFirstChild("Head") or z:FindFirstChild("HumanoidRootPart")
                    local zHrp = z:FindFirstChild("HumanoidRootPart")
                    if not isDead and hp > 0 and head and zHrp and zHrp.Position.Y > -100 then
                        local worldDist = (myPos - head.Position).Magnitude
                        if worldDist <= (Hub.Settings.SilentAimMaxDist or 400) then
                            local screenPos, depth, onScreen = WorldToViewport(head.Position)
                            if onScreen and depth > 0 then
                                local screenDist = (screenPos - center).Magnitude
                                if screenDist <= Hub.Settings.SilentAimFOV then
                                    local visible = true
                                    if Hub.Settings.SilentAimWallCheck then
                                        visible = IsHoodVisible(head, z)
                                    end
                                    if visible then
                                        local score = screenDist
                                        if score < bestScore then
                                            bestScore = score
                                            bestTarget = z
                                            bestBone = head
                                            isNpcTarget = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- 2. Check Players if not locked on NPC
    if not isNpcTarget then
        for _, player in ipairs(Players:GetPlayers()) do
            if IsSilentAimTargetValid(player) then
                local boneName = Hub.Settings.SilentAimBone or "Head"
                if boneName == "LegitRandom" then
                    local roll = math.random(1, 100)
                    if roll <= 35 then
                        boneName = "Head"
                    elseif roll <= 80 then
                        boneName = "UpperTorso"
                    else
                        boneName = "LowerTorso"
                    end
                elseif boneName == "Random" then
                    boneName = (math.random(1, 100) <= 60) and "Head" or "UpperTorso"
                end

                -- Prefer exact hitbox part from ClientHitboxes for 100% collision accuracy
                local targetBone = nil
                local ch = Workspace:FindFirstChild("ClientHitboxes")
                local pFolder = ch and ch:FindFirstChild(player.Name)
                if pFolder then
                    targetBone = pFolder:FindFirstChild(boneName) or pFolder:FindFirstChild("Head") or pFolder:FindFirstChild("UpperTorso")
                end
                if not targetBone then
                    targetBone = GetBone(player, boneName)
                end

                if targetBone then
                    local worldDist = (myPos - targetBone.Position).Magnitude
                    if worldDist <= (Hub.Settings.SilentAimMaxDist or 400) then
                        local screenPos, depth, onScreen = WorldToViewport(targetBone.Position)
                        if onScreen and depth > 0 then
                            local screenDist = (screenPos - center).Magnitude
                            if screenDist <= Hub.Settings.SilentAimFOV then
                                local visible = true
                                if Hub.Settings.SilentAimWallCheck then
                                    visible = IsVisible(player.Character, targetBone)
                                end

                                if visible then
                                    local score = 0
                                    if Hub.Settings.SilentAimPriority == "Crosshair" then
                                        score = screenDist
                                    else
                                        score = worldDist + (screenDist * 0.05)
                                    end

                                    if score < bestScore then
                                        bestScore = score
                                        bestTarget = player
                                        bestBone = targetBone
                                        isNpcTarget = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTarget, bestBone, isNpcTarget
end

-- Hook engine for ViewportPointToRay & ScreenPointToRay redirection (ZERO NAMECALL HOOKS)
local function InitSilentAimHooks()
    if typeof(hookfunction) == "function" then
        if typeof(Camera.ViewportPointToRay) == "function" then
            local oldVPR = nil
            oldVPR = hookfunction(Camera.ViewportPointToRay, function(self, x, y)
                local origRay = oldVPR(self, x, y)
                if not checkcaller() and Hub.Settings.SilentAim and (self == Camera or self == Workspace.CurrentCamera) then
                    if Hub.Settings.SilentAimHitChance >= 100 or math.random(1, 100) <= Hub.Settings.SilentAimHitChance then
                        local _, targetBone = GetSilentAimTarget()
                        if targetBone then
                            local dir = (targetBone.Position - origRay.Origin).Unit
                            -- In Legit Mode: Enforce strict angle validation (<= 20 degrees divergence from crosshair)
                            if Hub.Settings.LegitMode then
                                local cosAngle = origRay.Direction.Unit:Dot(dir)
                                if cosAngle >= 0.94 then
                                    return Ray.new(origRay.Origin, dir)
                                end
                            else
                                return Ray.new(origRay.Origin, dir)
                            end
                        end
                    end
                end
                return origRay
            end)
        end

        if typeof(Camera.ScreenPointToRay) == "function" then
            local oldSPR = nil
            oldSPR = hookfunction(Camera.ScreenPointToRay, function(self, x, y)
                local origRay = oldSPR(self, x, y)
                if not checkcaller() and Hub.Settings.SilentAim and (self == Camera or self == Workspace.CurrentCamera) then
                    if Hub.Settings.SilentAimHitChance >= 100 or math.random(1, 100) <= Hub.Settings.SilentAimHitChance then
                        local _, targetBone = GetSilentAimTarget()
                        if targetBone then
                            local dir = (targetBone.Position - origRay.Origin).Unit
                            -- In Legit Mode: Enforce strict angle validation (<= 20 degrees divergence from crosshair)
                            if Hub.Settings.LegitMode then
                                local cosAngle = origRay.Direction.Unit:Dot(dir)
                                if cosAngle >= 0.94 then
                                    return Ray.new(origRay.Origin, dir)
                                end
                            else
                                return Ray.new(origRay.Origin, dir)
                            end
                        end
                    end
                end
                return origRay
            end)
        end
    end
end
pcall(InitSilentAimHooks)

local function makeWritable(tbl)
    if type(tbl) == "table" and typeof(setreadonly) == "function" then
        pcall(setreadonly, tbl, false)
    end
    return tbl
end

-- ================================================
-- ⚡ 6. WEAPON & COMBAT ENGINE ENFORCER
-- Applies values from ssss.txt and live mod tables
-- ================================================
local function ApplyWeaponMods()
    if not WeaponData then return end

    if ClientState then
        if Hub.Settings.LegitMode then
            ClientState.RecoilScale = Hub.Settings.RecoilScale or 0.35
        else
            ClientState.RecoilScale = Hub.Settings.NoRecoil and 0 or 1
        end
    end

    for name, weapon in pairs(WeaponData) do
        if type(weapon) == "table" then
            pcall(function()
                if Hub.Settings.LegitMode then
                    -- In Legit Mode: Only enable FullAuto, preserve native timings & table freeze
                    if weapon.Fire then
                        makeWritable(weapon.Fire)
                        if Hub.Settings.FullAuto then
                            weapon.Fire.Mode = "Auto"
                        elseif OriginalWeaponData[name] and OriginalWeaponData[name].Fire then
                            weapon.Fire.Mode = OriginalWeaponData[name].Fire.Mode
                        end
                        if OriginalWeaponData[name] and OriginalWeaponData[name].Fire then
                            weapon.Fire.RPM = OriginalWeaponData[name].Fire.RPM
                        end
                    end
                    if weapon.Recoil and OriginalWeaponData[name] and OriginalWeaponData[name].Recoil then
                        makeWritable(weapon.Recoil)
                        weapon.Recoil.Up = OriginalWeaponData[name].Recoil.Up
                        weapon.Recoil.Side = OriginalWeaponData[name].Recoil.Side
                        weapon.Recoil.AimScale = OriginalWeaponData[name].Recoil.AimScale
                        weapon.Recoil.Return = OriginalWeaponData[name].Recoil.Return
                    end
                    if weapon.Bloom and OriginalWeaponData[name] and OriginalWeaponData[name].Bloom then
                        makeWritable(weapon.Bloom)
                        weapon.Bloom.Air = OriginalWeaponData[name].Bloom.Air or 0
                        weapon.Bloom.Move = OriginalWeaponData[name].Bloom.Move or 0
                        weapon.Bloom.Max = OriginalWeaponData[name].Bloom.Max or 0
                        weapon.Bloom.Hip = OriginalWeaponData[name].Bloom.Hip or 0
                        weapon.Bloom.PerShot = OriginalWeaponData[name].Bloom.PerShot or 0
                        weapon.Bloom.Aim = OriginalWeaponData[name].Bloom.Aim or 0
                    end
                    if weapon.Ammo and OriginalWeaponData[name] and OriginalWeaponData[name].Ammo then
                        makeWritable(weapon.Ammo)
                        weapon.Ammo.ReloadTime = OriginalWeaponData[name].Ammo.ReloadTime
                    end
                else
                    -- In Rage Mode: Apply full mods
                    if weapon.Recoil then
                        makeWritable(weapon.Recoil)
                        if Hub.Settings.NoRecoil then
                            weapon.Recoil.Up = 0
                            weapon.Recoil.Side = 0
                            weapon.Recoil.AimScale = 0
                            weapon.Recoil.Return = 100
                        elseif OriginalWeaponData[name] and OriginalWeaponData[name].Recoil then
                            weapon.Recoil.Up = OriginalWeaponData[name].Recoil.Up
                            weapon.Recoil.Side = OriginalWeaponData[name].Recoil.Side
                            weapon.Recoil.AimScale = OriginalWeaponData[name].Recoil.AimScale
                            weapon.Recoil.Return = OriginalWeaponData[name].Recoil.Return
                        end
                    end

                    if weapon.Bloom then
                        makeWritable(weapon.Bloom)
                        if Hub.Settings.NoSpread then
                            weapon.Bloom.Air = 0
                            weapon.Bloom.Move = 0
                            weapon.Bloom.Max = 0
                            weapon.Bloom.Hip = 0
                            weapon.Bloom.PerShot = 0
                            weapon.Bloom.Aim = 0
                        elseif OriginalWeaponData[name] and OriginalWeaponData[name].Bloom then
                            weapon.Bloom.Air = OriginalWeaponData[name].Bloom.Air or 0
                            weapon.Bloom.Move = OriginalWeaponData[name].Bloom.Move or 0
                            weapon.Bloom.Max = OriginalWeaponData[name].Bloom.Max or 0
                            weapon.Bloom.Hip = OriginalWeaponData[name].Bloom.Hip or 0
                            weapon.Bloom.PerShot = OriginalWeaponData[name].Bloom.PerShot or 0
                            weapon.Bloom.Aim = OriginalWeaponData[name].Bloom.Aim or 0
                        end
                    end

                    if weapon.Fire then
                        makeWritable(weapon.Fire)
                        if Hub.Settings.FullAuto then
                            weapon.Fire.Mode = "Auto"
                        elseif OriginalWeaponData[name] and OriginalWeaponData[name].Fire then
                            weapon.Fire.Mode = OriginalWeaponData[name].Fire.Mode
                        end
                        if Hub.Settings.RapidFire then
                            weapon.Fire.RPM = Hub.Settings.RapidFireRPM
                        elseif OriginalWeaponData[name] and OriginalWeaponData[name].Fire then
                            weapon.Fire.RPM = OriginalWeaponData[name].Fire.RPM
                        end
                    end

                    if weapon.Ammo then
                        makeWritable(weapon.Ammo)
                        if Hub.Settings.InstantReload then
                            weapon.Ammo.ReloadTime = 0.05
                        elseif Hub.Settings.FastReloadRatio < 1 and OriginalWeaponData[name] and OriginalWeaponData[name].Ammo then
                            weapon.Ammo.ReloadTime = OriginalWeaponData[name].Ammo.ReloadTime * Hub.Settings.FastReloadRatio
                        elseif OriginalWeaponData[name] and OriginalWeaponData[name].Ammo then
                            weapon.Ammo.ReloadTime = OriginalWeaponData[name].Ammo.ReloadTime
                        end
                    end
                end
            end)
        end
    end
end

-- ================================================
-- 🎯 7. HITBOX EXPANDER (ZERO-COST CONDITIONAL UPDATE)
-- ================================================
local _lastHitboxUpdate = 0
local function UpdateHitboxes()
    local clientHitboxes = Workspace:FindFirstChild("ClientHitboxes")
    if not clientHitboxes then return end

    local hSize = Hub.Settings.HitboxSize or 10
    local targetSize = Vector3.new(hSize, hSize, hSize)
    local isVisible = Hub.Settings.HitboxVisible == true
    local targetTrans = isVisible and (Hub.Settings.HitboxTransparency or 0.65) or 1
    local targetBone = Hub.Settings.HitboxTarget or "Head"

    for _, folder in ipairs(clientHitboxes:GetChildren()) do
        if folder.Name ~= LocalPlayer.Name then
            local player = Players:FindFirstChild(folder.Name)
            local char = player and player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local isTargetValid = char and hum and hum.Health > 0 and IsEnemy(player)

            local part = folder:FindFirstChild(targetBone) or folder:FindFirstChild("Head")
            if part and part:IsA("BasePart") then
                if Hub.Settings.HitboxExpander and isTargetValid then
                    if part.Size ~= targetSize then
                        part.Size = targetSize
                    end
                    if part.CanCollide then
                        part.CanCollide = false
                    end
                    if part.Transparency ~= targetTrans then
                        part.Transparency = targetTrans
                    end
                    if isVisible and part.Material ~= Enum.Material.ForceField then
                        part.Color = Color3.fromRGB(255, 30, 30)
                        part.Material = Enum.Material.ForceField
                    end
                else
                    if part.Transparency ~= 1 then
                        part.Transparency = 1
                    end
                end
            end
        end
    end
end

-- ================================================
-- 🔄 8. HEARTBEAT / RENDERSTEPPED CORE LOOP (OPTIMIZED)
-- ================================================
local _cachedHitmarker = nil
local _lastDamageCheck = 0

Hub.Connections.CoreEnforcer = RunService.RenderStepped:Connect(function(dt)
    if not Hub.Running then return end

    -- 1. Native Camera Recoil & Stamina (Direct table writes - Zero Overhead)
    if ClientState then
        ClientState.RecoilScale = Hub.Settings.NoRecoil and 0 or 1
        if Hub.Settings.InfiniteStamina then
            ClientState.Stamina = ClientState.StaminaMax or 150
            ClientState.Exhausted = false
            ClientState.JumpCost = 0
        end
        ClientState.Frozen = false

        if Hub.Settings.RedDamageNumbers and not ClientState._HookedRedDamage then
            ClientState._HookedRedDamage = true
            local oldShow = ClientState.ShowDamageNumber
            if type(oldShow) == "function" then
                ClientState.ShowDamageNumber = function(hitData)
                    if type(hitData) == "table" and Hub.Settings.RedDamageNumbers then
                        if Hub.Settings.SilentAimBone == "Head" or hitData.Headshot == true then
                            hitData.Headshot = true
                        end
                    end
                    return oldShow(hitData)
                end
            end
        end
    end

    local now = os.clock()

    -- 2. Damage Numbers UI Check (Throttled to once every 2 seconds, no per-frame DOM search)
    if Hub.Settings.RedDamageNumbers and (now - _lastDamageCheck >= 2.0) then
        _lastDamageCheck = now
        pcall(function()
            local starterGui = game:GetService("StarterGui")
            local wui = starterGui:FindFirstChild("WorldUI")
            local dn = wui and wui:FindFirstChild("DamageNumber")
            local text = dn and dn:FindFirstChild("Text")
            if text and text:GetAttribute("HeadColor") ~= Color3.fromRGB(255, 30, 30) then
                text:SetAttribute("HeadColor", Color3.fromRGB(255, 30, 30))
            end

            if not _cachedHitmarker or not _cachedHitmarker.Parent then
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                _cachedHitmarker = pg and pg:FindFirstChild("Hitmarker", true)
            end
            if _cachedHitmarker then
                if _cachedHitmarker:GetAttribute("HeadshotColor") ~= Color3.fromRGB(255, 30, 30) then
                    _cachedHitmarker:SetAttribute("HeadshotColor", Color3.fromRGB(255, 30, 30))
                    _cachedHitmarker:SetAttribute("KillColor", Color3.fromRGB(255, 30, 30))
                end
            end
        end)
    end

    -- Hitbox Expander update (Throttled to 10 Hz to prevent physics stutter)
    if Hub.Settings.HitboxExpander and (now - _lastHitboxUpdate >= 0.1) then
        _lastHitboxUpdate = now
        UpdateHitboxes()
    end
end)

-- ================================================
-- ⭕ 8.1 SILENT AIM FOV RENDER LOOP
-- Keeps FOV Circle position, size & rainbow cycle in sync
-- ================================================
pcall(function() RunService:UnbindFromRenderStep("KrakenSilentFOV") end)
    pcall(function() RunService:UnbindFromRenderStep("KrakenAimbot") end)
pcall(function() RunService:UnbindFromRenderStep("KrakenSilentFOV") end)
RunService:BindToRenderStep("KrakenSilentFOV", Enum.RenderPriority.Camera.Value + 1, function()
    if not Hub.Running then return end

    if SilentFOVCircle then
        local shouldDraw = Hub.Settings.SilentAimDrawFOV == true
        if SilentFOVCircle.Visible ~= shouldDraw then
            SilentFOVCircle.Visible = shouldDraw
        end
        if shouldDraw then
            local vp = Camera.ViewportSize
            local cx = vp.X * 0.5
            local cy = vp.Y * 0.5
            if SilentFOVCircle.Position.X ~= cx or SilentFOVCircle.Position.Y ~= cy then
                SilentFOVCircle.Position = Vector2.new(cx, cy)
            end
            local r = Hub.Settings.SilentAimFOV or 180
            if SilentFOVCircle.Radius ~= r then
                SilentFOVCircle.Radius = r
            end
            if Hub.Settings.SilentAimFOVRainbow then
                SilentFOVCircle.Color = Color3.fromHSV((tick() * 0.35) % 1, 1, 1)
            else
                local col = Hub.Settings.SilentAimFOVColor or Color3.fromRGB(255, 140, 0)
                if SilentFOVCircle.Color ~= col then
                    SilentFOVCircle.Color = col
                end
            end
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

local function MonitorCharacterForRespawn(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        local diedConn = hum.Died:Connect(function()
            if Hub.Running and Hub.Settings.AutoRespawn then
                task.wait(0.25)
                ForceRespawnPlayer()
            end
        end)
        table.insert(Hub.Connections, diedConn)
    end
    local attrConn = char:GetAttributeChangedSignal("Downed"):Connect(function()
        if Hub.Running and Hub.Settings.AutoRespawn and char:GetAttribute("Downed") == true then
            task.wait(0.25)
            ForceRespawnPlayer()
        end
    end)
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

-- ================================================
-- 👁️ 10. DRAWING API PLAYER ESP
-- ================================================
local function SafeDrawing(kind)
    if typeof(Drawing) == "table" and typeof(Drawing.new) == "function" then
        local ok, d = pcall(Drawing.new, kind)
        if ok and d then return d end
    end
    -- Fallback dummy object for Delta iOS where Drawing API is not supported
    local dummy = {}
    return setmetatable(dummy, {
        __index = function(_, k) return (k == "Visible" and false) or 0 end,
        __newindex = function() end
    })
end

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
        Billboard = nil,
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

Hub.Connections.ESPUpdate = RunService:BindToRenderStep("KrakenESP", Enum.RenderPriority.Camera.Value - 2, function()
    if not Hub.Running then return end

    local function hideESP(obj)
        if obj.BoxOutline then obj.BoxOutline.Visible = false end
        obj.Box.Visible = false
        obj.Name.Visible = false
        obj.Health.Visible = false
        obj.Dist.Visible = false
        obj.Weapon.Visible = false
        obj.Tracer.Visible = false
        obj.HealthBarOutline.Visible = false
        obj.HealthBar.Visible = false
        if obj.Highlight and obj.Highlight.Enabled then
            obj.Highlight.Enabled = false
            obj.Highlight.Adornee = nil
        end
    end

    -- Pause drawing and hide if PlayerESP is off or Cases UI is open
    if not Hub.Settings.PlayerESP or Hub._CasesOpen then
        for _, obj in pairs(Hub.ESP) do
            hideESP(obj)
        end
        return
    end

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

    for player, obj in pairs(Hub.ESP) do
        if player == LocalPlayer or (Hub.Settings.ESPTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team) then
            hideESP(obj)
            continue
        end

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not root or not head or not hum or hum.Health <= 0 then
            hideESP(obj)
            continue
        end

        local rootPos = root.Position
        local distSq = (camPos.X - rootPos.X)^2 + (camPos.Y - rootPos.Y)^2 + (camPos.Z - rootPos.Z)^2
        if distSq > maxDistSq then
            hideESP(obj)
            continue
        end

        local headHalfY = (head.Size and head.Size.Y * 0.5) or 0.6
        local topWorld = head.Position + Vector3.new(0, headHalfY + 0.15, 0)
        local bottomWorld = root.Position - Vector3.new(0, 2.75, 0)

        local topScreen, topDepth = WorldToViewport(topWorld)
        local bottomScreen, bottomDepth = WorldToViewport(bottomWorld)

        -- Target behind camera frustum: hide
        if topDepth <= 0 and bottomDepth <= 0 then
            hideESP(obj)
            continue
        end

        local boxH = math.abs(bottomScreen.Y - topScreen.Y)
        if boxH < 3 then
            hideESP(obj)
            continue
        end

        -- Fast 2D Bounding Box Calculation
        local boxW = math.clamp(math.floor(boxH * 0.46), 4, 300)
        local centerX = topScreen.X
        local boxX = centerX - boxW * 0.5
        local boxY = topScreen.Y

        -- Frustum visibility check: intersects screen borders (with 25px leeway to stop flickering)
        if (boxX + boxW < -25) or (boxX > vpX + 25) or (boxY + boxH < -25) or (boxY > vpY + 25) then
            hideESP(obj)
            continue
        end

        local dist = math.sqrt(distSq)

        -- 0. Glowing Body Chams (Optimized: capped to 200 studs to prevent mobile/low-end GPU fillrate drops)
        if Hub.Settings.ESPChams and obj.Highlight and dist <= 200 then
            if obj.Highlight.Adornee ~= char then
                obj.Highlight.Adornee = char
                obj.Highlight.Parent = char
                obj.Highlight.FillColor = Hub.Settings.ChamsColor or Color3.fromRGB(255, 35, 35)
                obj.Highlight.OutlineColor = Hub.Settings.ChamsOutlineColor or Color3.fromRGB(255, 45, 45)
                obj.Highlight.FillTransparency = Hub.Settings.ChamsTransparency or 0.78
                obj.Highlight.OutlineTransparency = 0.25
            end
            if not obj.Highlight.Enabled then
                obj.Highlight.Enabled = true
            end
        elseif obj.Highlight and obj.Highlight.Enabled then
            obj.Highlight.Enabled = false
            obj.Highlight.Adornee = nil
        end

        -- 1. Precision 2D Box with High-Contrast Black Border
        if obj.BoxOutline then
            obj.BoxOutline.Visible = Hub.Settings.ESPBox
            if Hub.Settings.ESPBox then
                obj.BoxOutline.Position = Vector2.new(boxX - 1, boxY - 1)
                obj.BoxOutline.Size = Vector2.new(boxW + 2, boxH + 2)
            end
        end

        obj.Box.Visible = Hub.Settings.ESPBox
        if Hub.Settings.ESPBox then
            obj.Box.Position = Vector2.new(boxX, boxY)
            obj.Box.Size = Vector2.new(boxW, boxH)
            obj.Box.Color = Hub.Settings.BoxColor or Color3.fromRGB(255, 60, 60)
        end

        -- 2. Clean Header (Single-line Name + Distance on top of Box)
        local distMeters = math.floor(dist * 0.28)
        local nameStr = player.DisplayName
        if Hub.Settings.ESPNameMode == "Username" then
            nameStr = player.Name
        elseif Hub.Settings.ESPNameMode == "Both" then
            nameStr = player.DisplayName .. " (@" .. player.Name .. ")"
        end

        local headerText = ""
        if Hub.Settings.ESPName and Hub.Settings.ESPDistance then
            headerText = nameStr .. "  [" .. distMeters .. "m]"
        elseif Hub.Settings.ESPName then
            headerText = nameStr
        elseif Hub.Settings.ESPDistance then
            headerText = distMeters .. "m"
        end

        if headerText ~= "" then
            obj.Name.Visible = true
            obj.Name.Font = fontId
            obj.Name.Size = fontSize
            obj.Name.Position = Vector2.new(centerX, boxY - (fontSize + 3))
            obj.Name.Text = headerText
            obj.Name.Color = Hub.Settings.NameColor
        else
            obj.Name.Visible = false
        end
        obj.Dist.Visible = false

        -- 3. Dynamic Health & Health Bar (Left of Box)
        local hp = math.clamp(math.floor((hum.Health / math.max(hum.MaxHealth, 1)) * 100), 0, 100)
        local hpColor = GetHealthColor(hp)

        if Hub.Settings.ESPHealthBar and Hub.Settings.ESPBox then
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
        if Hub.Settings.ESPTracers then
            obj.Tracer.Visible = true
            obj.Tracer.From = tracerOrigin
            obj.Tracer.To = bottomScreen
            obj.Tracer.Color = Hub.Settings.TracerColor
        else
            obj.Tracer.Visible = false
        end
    end
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

    local coffres = Workspace:FindFirstChild("Coffres")
    if not coffres then return end

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
            title.Text = "💎 ตู้เซฟทหาร: " .. safe.Name:gsub("MilitaryCase_", "")

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
                                title.Text = "🔫 " .. z.Name .. " [" .. dist .. "m]"
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
-- 📦 12.2 100% LEGIT PROXIMITY LOOT ENGINE [E]
-- Strictly checks player distance <= 12 studs before interacting.
-- Emulates human ProximityPrompt interaction timing & keypresses.
-- ZERO packets sent across map (Completely eliminates Cheater Server flags).
-- ==============================================================
local lastLootTick = 0
local function AttemptLegitLoot(targetPos, targetId)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetPos then return false end

    -- STRICT SAFETY CLAMP: Distance must be <= 12 studs (normal ProximityPrompt reach)
    local dist = (hrp.Position - targetPos).Magnitude
    if dist > 12 then return false end

    local now = tick()
    if now - lastLootTick < 0.25 then return false end
    lastLootTick = now

    pcall(function()
        -- 1. Try local ClientState loot function
        if ClientState and type(ClientState.HoodLootNow) == "function" then
            ClientState.HoodLootNow()
        end

        -- 2. Trigger ProximityPrompt directly if one exists near targetPos
        if typeof(fireproximityprompt) == "function" then
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local pPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart")
                    if pPart and (hrp.Position - pPart.Position).Magnitude <= (prompt.MaxActivationDistance or 12) then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end

        -- 3. Only send HoodRemote if distance is strictly confirmed <= 12 studs
        local hoodRemote = HoodRemote or (ReplicatedStorage:FindFirstChild("HoodNPC") and ReplicatedStorage.HoodNPC:FindFirstChild("Remote"))
        if hoodRemote and targetId and dist <= 12 then
            hoodRemote:FireServer("loot", targetId, targetPos)
        end

        -- 4. Emulate realistic E keypress
        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.04)
        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)

    return true
end

-- ==============================================================
-- 🎯 12.3 HUMANIZED LEGIT BOT COMBAT ENGINE
-- Smooth camera interpolation (Lerp), safe engagement distance (<= 60 studs),
-- FOV angle check, LOS wall check, human firing intervals. Never snaps camera 180° instantly!
-- ==============================================================
task.spawn(function()
    while Hub.Running and genv._UrbanReloadLegitScriptId == SCRIPT_ID do
        local farmActive = Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura
        local lootActive = Hub.Settings.AutoLootNear ~= false

        if not farmActive and not lootActive then
            task.wait(0.4)
            continue
        end

        task.wait(0.03)

        local char = LocalPlayer.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not myHRP then
            task.wait(0.2)
            continue
        end

        local myPos = myHRP.Position
        local camPos = Camera.CFrame.Position
        local camLook = Camera.CFrame.LookVector

        -- 1. Bot Combat Assist (Smooth human-like tracking & shooting)
        if farmActive then
            local maxRange = math.clamp(Hub.Settings.HoodKillAuraRange or 50, 15, 80)
            local targetNpc, targetHead, targetNpcId = nil, nil, nil
            local minDist = math.huge

            local enemyFolders = {}
            local hl = Workspace:FindFirstChild("HoodLocal")
            if hl then table.insert(enemyFolders, hl) end
            local zf = Workspace:FindFirstChild("Zombies")
            if zf then table.insert(enemyFolders, zf) end

            for _, folder in ipairs(enemyFolders) do
                for _, z in ipairs(folder:GetChildren()) do
                    if IsEnemyNPC(z) then
                        local hp, maxHp, isDead, id = GetHoodRealtimeData(z)
                        local head = z:FindFirstChild("Head") or z:FindFirstChild("HumanoidRootPart")
                        local zHrp = z:FindFirstChild("HumanoidRootPart")
                        if not isDead and hp > 0 and head and zHrp and zHrp.Position.Y > -100 then
                            local toTarget = head.Position - camPos
                            local dist = toTarget.Magnitude
                            if dist <= maxRange and dist < minDist then
                                -- Angle check: Only target if within player's view (FOV <= 70 degrees)
                                local dot = camLook:Dot(toTarget.Unit)
                                if dot > 0.35 then
                                    local hasLOS = true
                                    if Hub.Settings.HoodWallCheck ~= false then
                                        hasLOS = IsHoodVisible(head, z)
                                    end
                                    if hasLOS then
                                        minDist = dist
                                        targetNpc = z
                                        targetHead = head
                                        targetNpcId = id
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if targetNpc and targetHead then
                Hub.CurrentTarget = targetNpc
                local equippedTool = EnsureWeaponEquipped()

                -- Smooth natural camera tracking (Lerp with 0.16 alpha - human mouse feel)
                local currentCF = Camera.CFrame
                local desiredCF = CFrame.new(currentCF.Position, targetHead.Position)
                Camera.CFrame = currentCF:Lerp(desiredCF, 0.16)

                if equippedTool then
                    local currentAmmo = equippedTool:GetAttribute("Ammo") or 30
                    local isReloading = equippedTool:GetAttribute("Reloading") == true

                    if currentAmmo <= 0 or isReloading then
                        if not isReloading and Controls then
                            Controls.Press("Reload", true)
                            task.wait(0.04)
                            Controls.Press("Reload", false)
                        end
                        task.wait(0.25)
                    else
                        if Controls then Controls.Press("Aim", true) end
                        if ClientState then
                            ClientState.Aiming = true
                            ClientState.RecoilScale = 0.3
                        end

                        -- Controlled human tap firing
                        if Controls then
                            Controls.Press("Fire", true)
                            task.wait(0.09)
                            Controls.Press("Fire", false)
                            task.wait(0.08)
                        elseif typeof(mouse1press) == "function" then
                            mouse1press()
                            task.wait(0.08)
                            mouse1release()
                            task.wait(0.07)
                        end
                    end
                end
            else
                Hub.CurrentTarget = nil
                if Controls and Controls.IsDown and Controls.IsDown("Aim") then
                    pcall(function() Controls.Press("Aim", false) end)
                end
            end
        end

        -- 2. Legit Auto Loot [E] (Only runs when player is within 12 studs of dead corpses or safes)
        if lootActive then
            local hl = Workspace:FindFirstChild("HoodLocal")
            if hl then
                for _, z in ipairs(hl:GetChildren()) do
                    local hp, _, isDead, id = GetHoodRealtimeData(z)
                    local head = z:FindFirstChild("Head") or z:FindFirstChild("HumanoidRootPart")
                    if (isDead or hp <= 0) and head then
                        if (myPos - head.Position).Magnitude <= 12 then
                            AttemptLegitLoot(head.Position, id)
                        end
                    end
                end
            end

            -- Also scan for Military Safes (Coffres) if player is standing near one
            local coffres = Workspace:FindFirstChild("Coffres")
            if coffres then
                for _, safe in ipairs(coffres:GetChildren()) do
                    local part = safe:FindFirstChildWhichIsA("BasePart")
                    if part and (myPos - part.Position).Magnitude <= 12 then
                        AttemptLegitLoot(part.Position, nil)
                    end
                end
            end
        end
    end
end)

-- ==============================================================
-- 🎨 13. MODERN MACLIB UI & FLOATING LOGO INTERFACE
-- ==============================================================
local function InitUI()
    -- GUI Container resolution (supports gethui / CoreGui / PlayerGui)
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

    -- Clean up previous UI instances
    for _, name in ipairs({"KrakenHub_ToggleButton", "KrakenHub_UI", "Maclib", "Fluent"}) do
        local old = targetGuiParent:FindFirstChild(name)
        if old then pcall(function() old:Destroy() end) end
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
        return "rbxasset://5059d143b75fc7c70a58a871660c4f16/k_community_logo.png"
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
        -- 2. Restore Green Dot (Maximize Button)
        code = code:gsub("applyState%(maximize,%s*false%)", "applyState(maximize, true)")
        code = code:gsub("maximize%.BackgroundColor3%s*=%s*Color3%.fromRGB%(119,%s*174,%s*94%)", "maximize.BackgroundColor3 = Color3.fromRGB(40, 205, 65)")

        -- 3. Fix Slider Overlap: limit sliderName width and compact sliderElements
        code = code:gsub(
            "sliderName%.AutomaticSize%s*=%s*Enum%.AutomaticSize%.XY",
            "sliderName.AutomaticSize = Enum.AutomaticSize.None\n\t\t\t\t\tsliderName.Size = UDim2.new(1, -145, 1, 0)\n\t\t\t\t\tsliderName.ClipsDescendants = true"
        )
        code = code:gsub(
            "sliderBar%.Size%s*=%s*UDim2%.fromOffset%(123,%s*3%)",
            "sliderBar.Size = UDim2.fromOffset(88, 3)"
        )
        code = code:gsub(
            "sliderElementsUIListLayout%.Padding%s*=%s*UDim%.new%(0,%s*20%)",
            "sliderElementsUIListLayout.Padding = UDim.new(0, 8)"
        )
        code = code:gsub(
            "sliderValue%.Size%s*=%s*UDim2%.fromOffset%(41,%s*21%)",
            "sliderValue.Size = UDim2.fromOffset(38, 20)"
        )

        -- 4. Fix Keybind Overlap: limit keybindName width and prevent text overlapping binderBox
        code = code:gsub(
            "keybindName%.AutomaticSize%s*=%s*Enum%.AutomaticSize%.XY",
            "keybindName.AutomaticSize = Enum.AutomaticSize.None\n\t\t\t\t\tkeybindName.Size = UDim2.new(1, -100, 1, 0)\n\t\t\t\t\tkeybindName.ClipsDescendants = true"
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

        -- 6. Increase font sizes across MacLib components for mobile readability
        code = code:gsub("TextSize%s*=%s*11", "TextSize = 12")
        code = code:gsub("TextSize%s*=%s*12", "TextSize = 13")
        code = code:gsub("TextSize%s*=%s*13", "TextSize = 14")
        code = code:gsub("TextSize%s*=%s*14", "TextSize = 15")
        code = code:gsub("TextSize%s*=%s*15", "TextSize = 16")
        code = code:gsub("TextSize%s*=%s*16", "TextSize = 17")

        return loadstring(code)()
    end)
    if ok and lib then
        MacLib = lib
    else
        warn("[KrakenHub] Failed to load MacLib from release URL")
        return
    end

    -- 📐 3. RESPONSIVE WINDOW SIZE
    local function GetOptimalWindowSize()
        local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
        if vp.X < 900 or UserInputService.TouchEnabled then
            local w = math.clamp(math.floor(vp.X * 0.88), 340, 720)
            local h = math.clamp(math.floor(vp.Y * 0.82), 260, 480)
            return UDim2.fromOffset(w, h)
        end
        return UDim2.fromOffset(860, 600)
    end

    -- 🪟 4. CREATE MAIN WINDOW
    local Window = MacLib:Window({
        Title = "KrakenHub",
        Subtitle = "รีโหลดในเมือง (Urban Reload) | ภาษาไทย",
        Size = GetOptimalWindowSize(),
        DragStyle = 2,
        ShowUserInfo = true,
        Keybind = Enum.KeyCode.RightControl,
        AcrylicBlur = false,
    })
    Hub.Window = Window

    -- 🌟 Rock-Solid Neon Blue Window Border, Resize Grip & Green Dot Engine
    local _windowBorderHooked = false
    local function ApplyWindowBorder()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                base.ClipsDescendants = false

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

                -- 4. 🎚️ Fix Slider Overlap: จัดสัดส่วนตัวหนังสือและแถบเลื่อนไม่ให้ทับกันเด็ดขาด
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
                            sliderName.Size = UDim2.new(1, -145, 1, 0)
                            sliderName.TextTruncate = Enum.TextTruncate.AtEnd
                            sliderName.ClipsDescendants = true
                            sliderName.TextSize = 13
                        end
                        if sliderElements and sliderElements:IsA("Frame") then
                            local layout = sliderElements:FindFirstChildOfClass("UIListLayout")
                            if layout then
                                layout.Padding = UDim.new(0, 8)
                            end
                            local bar = sliderElements:FindFirstChild("SliderBar")
                            if bar and bar:IsA("ImageLabel") then
                                bar.Size = UDim2.fromOffset(88, 3)
                            end
                            local val = sliderElements:FindFirstChild("SliderValue")
                            if val and val:IsA("TextBox") then
                                val.Size = UDim2.fromOffset(38, 20)
                                val.TextSize = 12
                            end
                        end
                    end
                end

                for _, desc in ipairs(base:GetDescendants()) do
                    FixSlider(desc)
                end

                -- 5. ⌨️ Fix Keybind Overlap: ป้องกันปุ่มคีย์ลัดทับกับชื่อหัวข้อ
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
                            nameLbl.Size = UDim2.new(1, -95, 1, 0)
                            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                            nameLbl.ClipsDescendants = true
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

                for _, desc in ipairs(base:GetDescendants()) do
                    FixKeybind(desc)
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
                        if inst.Name == "SliderName" or inst.Name == "SliderValue" or inst.Name == "KeybindName" or inst.Name == "BinderBox" then
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
        local cur = Window:GetState()
        Window:SetState(not cur)
        task.delay(0.05, function()
            ApplyWindowBorder()
            ApplyTitleShimmer()
        end)
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

        -- Click & Bounce Animation
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

    -- 📑 All Tabs with Icons (หมวดต่อสู้แบบเดิมที่มี Silent Aim ครบครัน)
    local Tabs = {
        Combat    = CreateTabAdapter(tabGroup:Tab({ Name = "ต่อสู้",       Image = "rbxassetid://10709810948" }), "Combat"),
        Visuals   = CreateTabAdapter(tabGroup:Tab({ Name = "มองทะลุ",      Image = "rbxassetid://10747373176" }), "Visuals"),
        Character = CreateTabAdapter(tabGroup:Tab({ Name = "ตัวละคร",      Image = "rbxassetid://10747372702" }), "Character"),
        World     = CreateTabAdapter(tabGroup:Tab({ Name = "ฟาร์ม & โลก",  Image = "rbxassetid://10723405360" }), "World"),
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
    -- ⚔️ COMBAT TAB (หมวดต่อสู้ - โหมดเนียน & โหมดเรจ)
    -- ================================================
    Tabs.Combat:AddSection("พรีเซ็ตโหมดการเล่น (Playstyle Mode)")

    local LegitModeToggle = Tabs.Combat:AddToggle("LegitModeToggle", {
        Title = "🛡️ โหมดเนียน เล่นเซิร์ฟทั่วไป (Legit Safe 100%)",
        Description = "ยิงเนียนเหมือนโปรเพลเยอร์: สุ่มยิง หัว 35% / ตัว 45% โอกาสโดน 82% ลิมิตมุมยิง ไม่โดนย้ายไปเซิร์ฟโปร",
        Default = true
    })
    LegitModeToggle:OnChanged(function(v)
        if v then
            Hub.Settings.LegitMode = true
            Hub.Settings.SilentAim = true
            Hub.Settings.SilentAimBone = "LegitRandom"
            Hub.Settings.SilentAimHitChance = 82
            Hub.Settings.SilentAimFOV = 110
            Hub.Settings.SilentAimMaxDist = 320
            Hub.Settings.HitboxExpander = false
            Hub.Settings.HitboxSize = 2.5
            Hub.Settings.NoRecoil = false
            Hub.Settings.RecoilScale = 0.35
            Hub.Settings.NoSpread = false
            Hub.Settings.RapidFire = false
            Hub.Settings.InstantReload = false
            Hub.Settings.FullAuto = true
            ApplyWeaponMods()

            if Options.RageModeToggle then Options.RageModeToggle:SetValue(false) end
            if Options.SilentAimToggle then Options.SilentAimToggle:SetValue(true) end
            if Options.SilentBoneDrop then Options.SilentBoneDrop:SetValue("สุ่มตำแหน่งแบบเนียน (Legit Random - แนะนำ)") end
            if Options.SilentHitChanceSlider then Options.SilentHitChanceSlider:SetValue(82) end
            if Options.SilentFOVRadiusSlider then Options.SilentFOVRadiusSlider:SetValue(110) end
            if Options.HitboxToggle then Options.HitboxToggle:SetValue(false) end
            if Options.NoRecoilToggle then Options.NoRecoilToggle:SetValue(false) end
            if Options.NoSpreadToggle then Options.NoSpreadToggle:SetValue(false) end
        end
    end)

    local RageModeToggle = Tabs.Combat:AddToggle("RageModeToggle", {
        Title = "⚡ โหมดเรจ ล็อคหัว 100% (Rage Server Mode)",
        Description = "กระสุนเข้าหัวทุกนัด 100% (ไร้แรงดีด + ขยายหัว 10 studs) สำหรับเล่นเซิร์ฟโปรหรือยิงบอท",
        Default = false
    })
    RageModeToggle:OnChanged(function(v)
        if v then
            Hub.Settings.LegitMode = false
            Hub.Settings.SilentAim = true
            Hub.Settings.SilentAimBone = "Head"
            Hub.Settings.SilentAimHitChance = 100
            Hub.Settings.SilentAimFOV = 350
            Hub.Settings.SilentAimMaxDist = 600
            Hub.Settings.HitboxExpander = true
            Hub.Settings.HitboxTarget = "Head"
            Hub.Settings.HitboxSize = 10
            Hub.Settings.NoRecoil = true
            Hub.Settings.NoSpread = true
            Hub.Settings.FullAuto = true
            ApplyWeaponMods()

            if Options.LegitModeToggle then Options.LegitModeToggle:SetValue(false) end
            if Options.SilentAimToggle then Options.SilentAimToggle:SetValue(true) end
            if Options.SilentBoneDrop then Options.SilentBoneDrop:SetValue("ส่วนหัว (Head - แนะนำ)") end
            if Options.SilentHitChanceSlider then Options.SilentHitChanceSlider:SetValue(100) end
            if Options.SilentFOVRadiusSlider then Options.SilentFOVRadiusSlider:SetValue(350) end
            if Options.HitboxToggle then Options.HitboxToggle:SetValue(true) end
            if Options.NoRecoilToggle then Options.NoRecoilToggle:SetValue(true) end
            if Options.NoSpreadToggle then Options.NoSpreadToggle:SetValue(true) end
        end
    end)

    Tabs.Combat:AddSection("ระบบกระสุนเลี้ยว (Silent Aim Engine)")

    local SilentAimToggle = Tabs.Combat:AddToggle("SilentAimToggle", {
        Title = "เปิดใช้งานกระสุนเลี้ยว (Silent Aim)",
        Description = "กระสุนเลี้ยวเข้าเป้าหมายอัตโนมัติ โดยที่มุมกล้องไม่ขยับอิสระ",
        Default = Hub.Settings.SilentAim
    })
    SilentAimToggle:OnChanged(function(v)
        Hub.Settings.SilentAim = v
    end)

    local SilentBoneDrop = Tabs.Combat:AddDropdown("SilentBoneDrop", {
        Title = "ตำแหน่งกระสุนเข้า (Target Bone)",
        Description = "เลือกชิ้นส่วนร่างกายที่ต้องการให้กระสุนเลี้ยวพุ่งเข้าชน",
        Values = {"สุ่มตำแหน่งแบบเนียน (Legit Random - แนะนำ)", "ส่วนหัว (Head - แนะนำ)", "ลำตัวส่วนบน (UpperTorso)", "สุ่มหัว/ตัว (Random)"},
        Default = "สุ่มตำแหน่งแบบเนียน (Legit Random - แนะนำ)"
    })
    SilentBoneDrop:OnChanged(function(v)
        if v:find("สุ่มตำแหน่งแบบเนียน") or v:find("Legit") then
            Hub.Settings.SilentAimBone = "LegitRandom"
        elseif v:find("ส่วนหัว") or v:find("Head") then
            Hub.Settings.SilentAimBone = "Head"
        elseif v:find("ลำตัว") or v:find("UpperTorso") then
            Hub.Settings.SilentAimBone = "UpperTorso"
        else
            Hub.Settings.SilentAimBone = "Random"
        end
    end)

    local SilentHitChanceSlider = Tabs.Combat:AddSlider("SilentHitChanceSlider", {
        Title = "โอกาสโดน (Hit Chance %)",
        Description = "100% = โดนทุกลูก | ปรับลดลงถ้าต้องการให้ดูเนียนเหมือนคนเล่นจริง",
        Default = Hub.Settings.SilentAimHitChance,
        Min = 10,
        Max = 100,
        Rounding = 0
    })
    SilentHitChanceSlider:OnChanged(function(v)
        Hub.Settings.SilentAimHitChance = v
    end)

    local SilentMaxDistSlider = Tabs.Combat:AddSlider("SilentMaxDistSlider", {
        Title = "ระยะยิงสูงสุด (Max Distance)",
        Description = "ไม่เลี้ยวกระสุนใส่ศัตรูที่อยู่ไกลเกินระยะนี้ (Studs)",
        Default = Hub.Settings.SilentAimMaxDist,
        Min = 50,
        Max = 800,
        Rounding = 0
    })
    SilentMaxDistSlider:OnChanged(function(v)
        Hub.Settings.SilentAimMaxDist = v
    end)

    local SilentPriorityDrop = Tabs.Combat:AddDropdown("SilentPriorityDrop", {
        Title = "ลำดับเป้าหมาย (Priority)",
        Description = "เลือกว่าจะเลี้ยวยิงศัตรูที่ใกล้กึ่งกลางเป้าเล็งสุด หรือใกล้ตัวเราที่สุด",
        Values = {"ใกล้กึ่งกลางเป้าเล็งสุด (แนะนำ)", "ศัตรูที่ใกล้ตัวเราที่สุด"},
        Default = "ใกล้กึ่งกลางเป้าเล็งสุด (แนะนำ)"
    })
    SilentPriorityDrop:OnChanged(function(v)
        if v:find("กึ่งกลาง") or v:find("Crosshair") then
            Hub.Settings.SilentAimPriority = "Crosshair"
        else
            Hub.Settings.SilentAimPriority = "Distance"
        end
    end)

    Tabs.Combat:AddSection("การคัดกรองเป้าหมาย (Target Filters)")

    local SilentWallCheckToggle = Tabs.Combat:AddToggle("SilentWallCheckToggle", {
        Title = "เช็คสิ่งกีดขวาง (Wall Check)",
        Description = "ไม่เลี้ยวกระสุนหากศัตรูแอบอยู่หลังกำแพงหรือสิ่งปลูกสร้าง",
        Default = Hub.Settings.SilentAimWallCheck
    })
    SilentWallCheckToggle:OnChanged(function(v)
        Hub.Settings.SilentAimWallCheck = v
    end)

    local SilentHoodToggle = Tabs.Combat:AddToggle("SilentHoodToggle", {
        Title = "เลี้ยวยิงบอท Hood ด้วย (Target Hood NPCs)",
        Description = "กระสุนเลี้ยวเข้าหัวบอท Hood ในโหมดฟาร์ม/อีเวนต์ด้วย",
        Default = (Hub.Settings.SilentAimTargetHood ~= nil and Hub.Settings.SilentAimTargetHood) or Hub.Settings.SilentAimTargetZombies
    })
    SilentHoodToggle:OnChanged(function(v)
        Hub.Settings.SilentAimTargetHood = v
        Hub.Settings.SilentAimTargetZombies = v
    end)

    local SilentSafeZoneToggle = Tabs.Combat:AddToggle("SilentSafeZoneToggle", {
        Title = "ข้ามคนในเซฟโซน (Ignore SafeZone)",
        Description = "ไม่เลี้ยวกระสุนใส่คนในพื้นที่ปลอดภัยหรือเปิด PvPSafe",
        Default = Hub.Settings.SilentAimIgnoreSafeZone
    })
    SilentSafeZoneToggle:OnChanged(function(v)
        Hub.Settings.SilentAimIgnoreSafeZone = v
    end)

    local SilentShieldToggle = Tabs.Combat:AddToggle("SilentShieldToggle", {
        Title = "ข้ามคนเกิดใหม่มีเกราะ (Ignore Spawn Shield)",
        Description = "ไม่เลี้ยวกระสุนใส่คนที่มีเกราะกันดาเมจตอนเพิ่งเกิดใหม่",
        Default = Hub.Settings.SilentAimIgnoreShield
    })
    SilentShieldToggle:OnChanged(function(v)
        Hub.Settings.SilentAimIgnoreShield = v
    end)

    local SilentDownedToggle = Tabs.Combat:AddToggle("SilentDownedToggle", {
        Title = "ข้ามศัตรูที่ล้มคลาน (Ignore Downed)",
        Description = "ไม่เลี้ยวกระสุนใส่คนที่ล้มคลาน เพื่อโฟกัสคนที่ยังยืนยิงเรา",
        Default = Hub.Settings.SilentAimIgnoreDowned
    })
    SilentDownedToggle:OnChanged(function(v)
        Hub.Settings.SilentAimIgnoreDowned = v
    end)

    Tabs.Combat:AddSection("วงกลมระยะเล็ง (Silent Aim FOV Circle)")

    local SilentDrawFOVToggle = Tabs.Combat:AddToggle("SilentDrawFOVToggle", {
        Title = "แสดงวงกลมกระสุนเลี้ยว (Draw Silent FOV)",
        Description = "เปิด/ปิด การแสดงวงกลมระยะเลี้ยวของ Silent Aim บนหน้าจอ",
        Default = Hub.Settings.SilentAimDrawFOV
    })
    SilentDrawFOVToggle:OnChanged(function(v)
        Hub.Settings.SilentAimDrawFOV = v
        if SilentFOVCircle then
            SilentFOVCircle.Visible = v
        end
    end)

    local SilentFOVSlider = Tabs.Combat:AddSlider("SilentFOVSlider", {
        Title = "ขนาดวงกลมกระสุนเลี้ยว (Silent FOV Radius)",
        Description = "รัศมีตรวจจับเป้าหมายที่จะเลี้ยวกระสุนเข้าใส่ (แนะนำ 180 - 250)",
        Default = Hub.Settings.SilentAimFOV,
        Min = 50,
        Max = 800,
        Rounding = 0
    })
    SilentFOVSlider:OnChanged(function(v)
        Hub.Settings.SilentAimFOV = v
        if SilentFOVCircle then
            SilentFOVCircle.Radius = v
        end
    end)

    local SilentColorDrop = Tabs.Combat:AddDropdown("SilentColorDrop", {
        Title = "สีวงกลม Silent Aim (Preset Color)",
        Description = "เลือกชุดสีมาตรฐานหรือเลือกปรับแต่งแม่สี RGB แยกเอง",
        Values = {
            "ส้มนีออน (Neon Orange - ค่าเริ่มต้น)",
            "ฟ้าคราม (Cyan Blue)",
            "แดงสด (Crimson Red)",
            "เขียวนีออน (Neon Green)",
            "ม่วงนีออน (Electric Purple)",
            "เหลืองทอง (Gold)",
            "ชมพูนีออน (Hot Pink)",
            "ขาวสว่าง (Pure White)",
            "กำหนดค่าสี RGB เอง"
        },
        Default = "ส้มนีออน (Neon Orange - ค่าเริ่มต้น)"
    })

    local SilentRainbowToggle = Tabs.Combat:AddToggle("SilentRainbowToggle", {
        Title = "วงกลม Silent Aim สีรุ้ง (Rainbow RGB Cycle)",
        Description = "ให้วงกลม Silent Aim สลับสีรุ้งเคลื่อนไหวอย่างสมูท",
        Default = Hub.Settings.SilentAimFOVRainbow
    })
    SilentRainbowToggle:OnChanged(function(v)
        Hub.Settings.SilentAimFOVRainbow = v
    end)

    local SilentRSlider = Tabs.Combat:AddSlider("SilentRSlider", {
        Title = "สีแดง Silent Aim (Red)",
        Description = "ปรับค่าแม่สีแดง (0 - 255)",
        Default = Hub.Settings.SilentAimFOVR,
        Min = 0,
        Max = 255,
        Rounding = 0
    })

    local SilentGSlider = Tabs.Combat:AddSlider("SilentGSlider", {
        Title = "สีเขียว Silent Aim (Green)",
        Description = "ปรับค่าแม่สีเขียว (0 - 255)",
        Default = Hub.Settings.SilentAimFOVG,
        Min = 0,
        Max = 255,
        Rounding = 0
    })

    local SilentBSlider = Tabs.Combat:AddSlider("SilentBSlider", {
        Title = "สีน้ำเงิน Silent Aim (Blue)",
        Description = "ปรับค่าแม่สีน้ำเงิน (0 - 255)",
        Default = Hub.Settings.SilentAimFOVB,
        Min = 0,
        Max = 255,
        Rounding = 0
    })

    local function UpdateSilentColorFromRGB()
        Hub.Settings.SilentAimFOVColor = Color3.fromRGB(Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB)
        if SilentFOVCircle then
            SilentFOVCircle.Color = Hub.Settings.SilentAimFOVColor
        end
    end

    SilentRSlider:OnChanged(function(v)
        Hub.Settings.SilentAimFOVR = v
        UpdateSilentColorFromRGB()
    end)
    SilentGSlider:OnChanged(function(v)
        Hub.Settings.SilentAimFOVG = v
        UpdateSilentColorFromRGB()
    end)
    SilentBSlider:OnChanged(function(v)
        Hub.Settings.SilentAimFOVB = v
        UpdateSilentColorFromRGB()
    end)

    SilentColorDrop:OnChanged(function(v)
        if v:find("ส้มนีออน") or v:find("Orange") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 255, 140, 0
        elseif v:find("ฟ้าคราม") or v:find("Cyan") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 0, 220, 255
        elseif v:find("แดงสด") or v:find("Red") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 255, 45, 45
        elseif v:find("เขียว") or v:find("Green") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 50, 255, 80
        elseif v:find("ม่วง") or v:find("Purple") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 180, 50, 255
        elseif v:find("เหลือง") or v:find("Gold") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 255, 215, 0
        elseif v:find("ชมพู") or v:find("Pink") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 255, 60, 180
        elseif v:find("ขาว") or v:find("White") then
            Hub.Settings.SilentAimFOVR, Hub.Settings.SilentAimFOVG, Hub.Settings.SilentAimFOVB = 255, 255, 255
        end
        UpdateSilentColorFromRGB()
        if Options.SilentRSlider then Options.SilentRSlider:SetValue(Hub.Settings.SilentAimFOVR) end
        if Options.SilentGSlider then Options.SilentGSlider:SetValue(Hub.Settings.SilentAimFOVG) end
        if Options.SilentBSlider then Options.SilentBSlider:SetValue(Hub.Settings.SilentAimFOVB) end
    end)

    local FOVThicknessSlider = Tabs.Combat:AddSlider("FOVThicknessSlider", {
        Title = "ความหนาเส้นวงกลม (Circle Thickness)",
        Description = "ปรับความหนาของเส้นขอบวงกลม",
        Default = Hub.Settings.FOVCircleThickness,
        Min = 1,
        Max = 6,
        Rounding = 1
    })
    FOVThicknessSlider:OnChanged(function(v)
        Hub.Settings.FOVCircleThickness = v
        if SilentFOVCircle then SilentFOVCircle.Thickness = v end
    end)

    local FOVTransparencySlider = Tabs.Combat:AddSlider("FOVTransparencySlider", {
        Title = "ความโปร่งใสของเส้นวงกลม (Circle Transparency)",
        Description = "ปรับความเข้มชัดหรือโปร่งใสของเส้นวงกลม (0.1 - 1.0)",
        Default = Hub.Settings.FOVCircleTransparency,
        Min = 0.1,
        Max = 1.0,
        Rounding = 2
    })
    FOVTransparencySlider:OnChanged(function(v)
        Hub.Settings.FOVCircleTransparency = v
        if SilentFOVCircle then SilentFOVCircle.Transparency = v end
    end)

    local FOVFilledToggle = Tabs.Combat:AddToggle("FOVFilledToggle", {
        Title = "เติมสีเต็มวงกลม (Filled Circle)",
        Description = "ระบายสีทึบภายในวงกลม",
        Default = Hub.Settings.FOVCircleFilled
    })
    FOVFilledToggle:OnChanged(function(v)
        Hub.Settings.FOVCircleFilled = v
        if SilentFOVCircle then SilentFOVCircle.Filled = v end
    end)

    Tabs.Combat:AddSection("ปรับแต่งปืน (Weapon Modifications)")

    local NoRecoilToggle = Tabs.Combat:AddToggle("NoRecoilToggle", {
        Title = "ปืนไร้แรงดีด 100% (No Recoil)",
        Description = "ปิดแรงดีดปืนทุกทิศทาง ยิงนิ่งสนิท 100% ปืนไม่กระดก",
        Default = Hub.Settings.NoRecoil
    })
    NoRecoilToggle:OnChanged(function(v)
        Hub.Settings.NoRecoil = v
        ApplyWeaponMods()
    end)

    local NoSpreadToggle = Tabs.Combat:AddToggle("NoSpreadToggle", {
        Title = "กระสุนตรงเป้า 100% (No Spread)",
        Description = "ปิดการกระจายของกระสุน กระสุนเกาะกลุ่มจุดเดียวทุกนัด",
        Default = Hub.Settings.NoSpread
    })
    NoSpreadToggle:OnChanged(function(v)
        Hub.Settings.NoSpread = v
        ApplyWeaponMods()
    end)

    local FullAutoToggle = Tabs.Combat:AddToggle("FullAutoToggle", {
        Title = "ยิงออโต้ทุกปืน (Full Auto)",
        Description = "เปลี่ยนโหมดยิงของปืนทุกชนิด (M9/ลูกซอง) ให้กดยิงค้างรัวได้",
        Default = Hub.Settings.FullAuto
    })
    FullAutoToggle:OnChanged(function(v)
        Hub.Settings.FullAuto = v
        ApplyWeaponMods()
    end)

    local RapidToggle = Tabs.Combat:AddToggle("RapidToggle", {
        Title = "เพิ่มความเร็วลั่นกระสุน (Rapid Fire)",
        Description = "เพิ่มอัตราลั่นกระสุน (RPM) ยิงกระสุนออกไวกว่าปกติ",
        Default = Hub.Settings.RapidFire
    })
    RapidToggle:OnChanged(function(v)
        Hub.Settings.RapidFire = v
        ApplyWeaponMods()
    end)

    local RapidFireRPMSlider = Tabs.Combat:AddSlider("RapidFireRPMSlider", {
        Title = "ความเร็วรอบลั่นกระสุน (RPM Rate)",
        Description = "ปรับความเร็วการลั่นกระสุนต่อนาที (RPM)",
        Default = Hub.Settings.RapidFireRPM or 1100,
        Min = 600,
        Max = 1800,
        Rounding = 0
    })
    RapidFireRPMSlider:OnChanged(function(v)
        Hub.Settings.RapidFireRPM = v
        ApplyWeaponMods()
    end)

    local InstantReloadToggle = Tabs.Combat:AddToggle("InstantReloadToggle", {
        Title = "รีโหลดกระสุนทันที (Instant Reload)",
        Description = "ลดเวลาบรรจุกระสุนลงเหลือ 0.05 วินาที รีโหลดแทบจะทันที",
        Default = Hub.Settings.InstantReload
    })
    InstantReloadToggle:OnChanged(function(v)
        Hub.Settings.InstantReload = v
        ApplyWeaponMods()
    end)

    local RedDmgToggle = Tabs.Combat:AddToggle("RedDmgToggle", {
        Title = "บังคับตัวเลขดาเมจสีแดง 100% (Red Damage Numbers)",
        Description = "บังคับให้ตัวเลขดาเมจและเป้าเล็งเป็นสีแดงสดทุกนัดที่ยิงเข้าหัว",
        Default = Hub.Settings.RedDamageNumbers
    })
    RedDmgToggle:OnChanged(function(v)
        Hub.Settings.RedDamageNumbers = v
    end)

    Tabs.Combat:AddSection("ขยายฮิตบ็อกซ์ (Hitbox Expander)")

    local HitboxToggle = Tabs.Combat:AddToggle("HitboxToggle", {
        Title = "เปิดขยายฮิตบ็อกซ์ (Hitbox Expander)",
        Description = "ขยายขนาด Hitbox ศัตรู ยิงโดนหัวง่าย 100% แม้ยิงไม่ตรงเป้า",
        Default = Hub.Settings.HitboxExpander
    })
    HitboxToggle:OnChanged(function(v)
        Hub.Settings.HitboxExpander = v
        if not v then
            local ch = Workspace:FindFirstChild("ClientHitboxes")
            if ch then
                for _, f in ipairs(ch:GetChildren()) do
                    for _, p in ipairs(f:GetChildren()) do
                        if p:IsA("BasePart") then p.Transparency = 1 end
                    end
                end
            end
        end
    end)

    local HitboxSizeSlider = Tabs.Combat:AddSlider("HitboxSizeSlider", {
        Title = "ขนาดฮิตบ็อกซ์ (Hitbox Size)",
        Description = "ขนาดของกล่องเป้าหมายที่ต้องการขยาย (Studs)",
        Default = Hub.Settings.HitboxSize,
        Min = 2,
        Max = 25,
        Rounding = 1
    })
    HitboxSizeSlider:OnChanged(function(v)
        Hub.Settings.HitboxSize = v
    end)

    local HitboxTargetDrop = Tabs.Combat:AddDropdown("HitboxTargetDrop", {
        Title = "ชิ้นส่วนเป้าหมาย (Target Part)",
        Description = "เลือกส่วนของร่างกายศัตรูที่ต้องการขยายขนาด",
        Values = {"ส่วนหัว (Head - แนะนำ)", "ลำตัวส่วนบน (UpperTorso)", "ทุกส่วน (All Parts)"},
        Default = "ส่วนหัว (Head - แนะนำ)"
    })
    HitboxTargetDrop:OnChanged(function(v)
        if v:find("ส่วนหัว") or v:find("Head") then
            Hub.Settings.HitboxTarget = "Head"
        elseif v:find("ลำตัว") or v:find("UpperTorso") then
            Hub.Settings.HitboxTarget = "UpperTorso"
        else
            Hub.Settings.HitboxTarget = "All"
        end
    end)

    local HitboxVisToggle = Tabs.Combat:AddToggle("HitboxVisToggle", {
        Title = "แสดงกล่องฮิตบ็อกซ์เรืองแสง (Show Hitbox Visualizer)",
        Description = "แสดงกล่องเรืองแสงของ Hitbox ศัตรูบนหน้าจอ",
        Default = Hub.Settings.HitboxVisible
    })
    HitboxVisToggle:OnChanged(function(v)
        Hub.Settings.HitboxVisible = v
    end)

    -- Apply initial weapon mods
    ApplyWeaponMods()
    -- ================================================
    -- 👁️ VISUALS TAB (หมวดมองทะลุ)
    -- ================================================
    Tabs.Visuals:AddSection("มองทะลุผู้เล่น (Player ESP)")

    local ESPMainToggle = Tabs.Visuals:AddToggle("ESPMainToggle", {
        Title = "เปิดระบบมองทะลุผู้เล่น (Enable Player ESP)",
        Description = "เปิด/ปิดระบบมองทะลุผู้เล่นทั้งหมดในเซิร์ฟเวอร์",
        Default = Hub.Settings.PlayerESP
    })
    ESPMainToggle:OnChanged(function(v)
        Hub.Settings.PlayerESP = v
    end)

    local ESPBoxToggle = Tabs.Visuals:AddToggle("ESPBoxToggle", {
        Title = "กรอบสี่เหลี่ยมตัวละคร (2D Box)",
        Description = "แสดงกรอบสี่เหลี่ยมรอบตัวผู้เล่นศัตรู",
        Default = Hub.Settings.ESPBox
    })
    ESPBoxToggle:OnChanged(function(v) Hub.Settings.ESPBox = v end)

    local ESPChamsToggle = Tabs.Visuals:AddToggle("ESPChamsToggle", {
        Title = "เรืองแสงตัวศัตรู (Chams)",
        Description = "เรืองแสงไฮไลท์ขอบแดง ตัวแดงจาง มองทะลุกำแพงง่ายขึ้น",
        Default = Hub.Settings.ESPChams
    })
    ESPChamsToggle:OnChanged(function(v) Hub.Settings.ESPChams = v end)

    local ESPNameToggle = Tabs.Visuals:AddToggle("ESPNameToggle", {
        Title = "แสดงชื่อผู้เล่น (Player Names)",
        Description = "แสดงชื่อและไอดีของผู้เล่น",
        Default = Hub.Settings.ESPName
    })
    ESPNameToggle:OnChanged(function(v) Hub.Settings.ESPName = v end)

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
    end)

    local ESPNameModeDrop = Tabs.Visuals:AddDropdown("ESPNameModeDrop", {
        Title = "รูปแบบแสดงชื่อ (Name Format)",
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
    end)

    local ESPHealthToggle = Tabs.Visuals:AddToggle("ESPHealthToggle", {
        Title = "แสดงตัวเลขพลังชีวิต (Health Text)",
        Description = "แสดงตัวเลขเปอร์เซ็นต์เลือด HP ของศัตรู",
        Default = Hub.Settings.ESPHealth
    })
    ESPHealthToggle:OnChanged(function(v) Hub.Settings.ESPHealth = v end)

    local ESPHealthBarToggle = Tabs.Visuals:AddToggle("ESPHealthBarToggle", {
        Title = "หลอดเลือดข้างตัวศัตรู (Dynamic Health Bar)",
        Description = "หลอดเลือดข้างตัวศัตรู ไล่ระดับสีตามเลือด (100% เขียว -> ส้ม -> 20% แดง)",
        Default = Hub.Settings.ESPHealthBar
    })
    ESPHealthBarToggle:OnChanged(function(v) Hub.Settings.ESPHealthBar = v end)

    local ESPDistToggle = Tabs.Visuals:AddToggle("ESPDistToggle", {
        Title = "แสดงระยะห่าง (Distance)",
        Description = "แสดงระยะทางระหว่างเรากับผู้เล่น (เมตร/Studs)",
        Default = Hub.Settings.ESPDistance
    })
    ESPDistToggle:OnChanged(function(v) Hub.Settings.ESPDistance = v end)

    local ESPMaxDistSlider = Tabs.Visuals:AddSlider("ESPMaxDistSlider", {
        Title = "ระยะแสดงผล ESP (Max Distance)",
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
        Title = "แสดงชื่อปืนที่ถือ (Equipped Weapon)",
        Description = "แสดงชื่ออาวุธปืนที่ผู้เล่นกำลังถืออยู่ในมือ",
        Default = Hub.Settings.ESPWeapon
    })
    ESPWeaponToggle:OnChanged(function(v) Hub.Settings.ESPWeapon = v end)

    local ESPTracerToggle = Tabs.Visuals:AddToggle("ESPTracerToggle", {
        Title = "เส้นนำสายตา (Tracers)",
        Description = "ลากเส้นนำสายตาจากกลางจอด้านล่างไปยังตัวผู้เล่น",
        Default = Hub.Settings.ESPTracers
    })
    ESPTracerToggle:OnChanged(function(v) Hub.Settings.ESPTracers = v end)

    Tabs.Visuals:AddSection("มองทะลุตู้เซฟและสิ่งของ (World Objects ESP)")

    local SafeESPToggle = Tabs.Visuals:AddToggle("SafeESPToggle", {
        Title = "มองทะลุตู้เซฟทหาร (Military Safe ESP)",
        Description = "แสดงตู้เซฟเงิน $5,000 - $50,000 ทั้ง 4 จุดในแมพ",
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
    Tabs.Character:AddSection("การแสดงผลตัวละคร (Identity & Display)")

    local HideNameToggle = Tabs.Character:AddToggle("HideNameToggle", {
        Title = "ปิดชื่อตัวละครบนหัว (Hide Overhead Name)",
        Description = "ซ่อนชื่อและแท็กแก๊งบนหัวตัวละครของเรา ไม่ให้คนอื่นเห็นหรืออัดคลิปติดชื่อ",
        Default = Hub.Settings.HideCharacterName
    })
    HideNameToggle:OnChanged(function(v)
        SetHideCharacterName(v)
    end)

    Tabs.Character:AddSection("เกิดใหม่อัตโนมัติ & รีเซ็ตด่วน (Auto Respawn & Fast Reset)")

    local AutoRespawnToggle = Tabs.Character:AddToggle("AutoRespawnToggle", {
        Title = "เกิดใหม่อัตโนมัติ (Auto Respawn - ปุ่ม X)",
        Description = "กดปุ่ม X หรือเมื่อถูกยิงล้มคลาน/เลือดหมด จะเกิดใหม่และรีเซ็ตทันทีไม่ต้องรอคูลดาวน์",
        Default = Hub.Settings.AutoRespawn
    })
    AutoRespawnToggle:OnChanged(function(v)
        Hub.Settings.AutoRespawn = v
    end)

    local RespawnKeybind = Tabs.Character:AddKeybind("RespawnKeybind", {
        Title = "ปุ่มคีย์ลัดเกิดใหม่ (Respawn Key)",
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

    -- ================================================
    -- 🌾 FARM & WORLD TAB (ระบบฟาร์มเนียน & โลก)
    -- ================================================
    Tabs.World:AddSection("🛡️ ระบบฟาร์มเนียน (Humanized Legit Farm - ปลอดภัย 100%)")

    local LegitFarmToggle = Tabs.World:AddToggle("LegitFarmToggle", {
        Title = "ฟาร์มบอทเนียน (Legit Bot Assist)",
        Description = "เล็งและยิงบอท Hood/Zombie อย่างเป็นธรรมชาติ กล้องหมุนสมูท ไม่กระตุก ไม่หักคอ 0ms ปลอดภัยไม่โดนย้ายเซิร์ฟ",
        Default = Hub.Settings.HoodKillAura
    })
    LegitFarmToggle:OnChanged(function(v)
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
                    ClientState.RecoilScale = 0.3
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

    local AutoLootToggle = Tabs.World:AddToggle("AutoLootToggle", {
        Title = "เก็บของ/ดูดเงินระยะประชิด (Legit Auto Loot [E])",
        Description = "กด E เก็บเงินและไอเทมรอบตัวในระยะ 12 studs อัตโนมัติ (ไม่ส่งคำสั่งทะลุแมพ ป้องกันเซิร์ฟโปร 100%)",
        Default = (Hub.Settings.AutoLootNear ~= false)
    })
    AutoLootToggle:OnChanged(function(v)
        Hub.Settings.AutoLootNear = v
    end)

    local HoodWallCheckToggle = Tabs.World:AddToggle("HoodWallCheckToggle", {
        Title = "เช็กกำแพง/สิ่งกีดขวาง (LOS Wall Check)",
        Description = "ไม่ยิงบอท Hood ที่อยู่หลังกำแพงหรือสิ่งกีดขวาง (ป้องกันการรายงานดาเมจทะลุกำแพง)",
        Default = (Hub.Settings.HoodWallCheck ~= false)
    })
    HoodWallCheckToggle:OnChanged(function(v)
        Hub.Settings.HoodWallCheck = v
        Hub.Settings.ZombieWallCheck = v
    end)

    local HoodKillAuraDistSlider = Tabs.World:AddSlider("HoodKillAuraDistSlider", {
        Title = "ระยะฟาร์มบอท (Safe Farm Range)",
        Description = "ระยะในการเล็งยิงบอทอย่างปลอดภัย (แนะนำ 40 - 60 studs ป้องกันผิดปกติ)",
        Min = 20,
        Max = 80,
        Default = math.clamp(Hub.Settings.HoodKillAuraRange or 50, 20, 80),
        Rounding = 0
    })
    HoodKillAuraDistSlider:OnChanged(function(v)
        Hub.Settings.HoodKillAuraRange = v
        Hub.Settings.ZombieKillAuraRange = v
    end)

    local HoodESPToggle = Tabs.World:AddToggle("HoodESPToggle", {
        Title = "เปิด/ปิด ESP บอท Hood (Hood NPC ESP)",
        Description = "แสดงชื่อ ระยะ และหลอดเลือดบอท Hood แบบ Real-time",
        Default = (Hub.Settings.HoodESP ~= false)
    })
    HoodESPToggle:OnChanged(function(v)
        Hub.Settings.HoodESP = v
        Hub.Settings.ZombieESP = v
    end)

    Tabs.World:AddSection("📦 ตู้เซฟทหาร (Military Safes - ปลอดภัยไม่มีวาป)")

    local SafeESPToggle = Tabs.World:AddToggle("SafeESPToggle_World", {
        Title = "เปิด/ปิด ESP ตู้เซฟทหาร (Safe 1 - 4)",
        Description = "แสดงตำแหน่งตู้เซฟ $5,000 - $50,000 พร้อมระยะทาง วิ่งไปเก็บได้อย่างปลอดภัย",
        Default = (Hub.Settings.SafeESP ~= false)
    })
    SafeESPToggle:OnChanged(function(v)
        Hub.Settings.SafeESP = v
        UpdateSafeESP()
    end)

    Tabs.World:AddSection("🏧 ฝากเงินด่วน (Quick Banking)")

    Tabs.World:AddButton({
        Title = "ฝากเงินสดทั้งหมดเข้าตู้ ATM (Deposit All Cash)",
        Description = "นำเงินสดในตัวทั้งหมดฝากเข้าตู้ ATM ทันทีเพื่อป้องกันเงินตกตอนตาย",
        Callback = function()
            local money = tonumber(LocalPlayer:GetAttribute("Money")) or 0
            if money > 0 and Remotes and Remotes:FindFirstChild("ATM") then
                local s, res = pcall(function()
                    return Remotes.ATM:InvokeServer("Deposit", money)
                end)
                if s and res and res.ok then
                    Fluent:Notify({ Title = "ATM", Content = "ฝากเงินสดสำเร็จ: $" .. tostring(money), Duration = 3 })
                else
                    Fluent:Notify({ Title = "ATM", Content = "ฝากเงินไม่สำเร็จ (อาจอยู่ไกลตู้ ATM)", Duration = 3 })
                end
            else
                Fluent:Notify({ Title = "ATM", Content = "ไม่มีเงินสดติดตัว", Duration = 3 })
            end
        end
    })

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
        Title = "สีไอค่อนแถบข้าง (Tab Icon Colors)",
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
        Title = "บูสต์ FPS มือถือ (Mobile FPS Booster)",
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
                            if genv.UrbanReloadLegit_Cleanup then
                                genv.UrbanReloadLegit_Cleanup()
                            end
                            pcall(function() Window:Unload() end)
                        end
                    },
                    { Title = "ยกเลิก", Callback = function() end }
                }
            })
        end
    })

    Window:SelectTab(1)
    Fluent:Notify({
        Title = "🌊 KrakenHub [โหมดเนียน] โหลดสำเร็จ!",
        Content = "Urban Reload (Legit Safe Edition)\nเปิดใช้งานโหมดเนียน 100% เล่นเซิร์ฟทั่วไปปลอดภัย ไร้แบน/ไม่โดนโยนเซิร์ฟโปร",
        Duration = 6
    })
end

-- ==============================================================
-- 🧹 14. CLEANUP HANDLER
-- ==============================================================
genv.UrbanReloadLegit_Cleanup = function()
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
    pcall(function() RunService:UnbindFromRenderStep("KrakenAimbot") end)

    -- Remove FOV Circles
    if FOVCircle then
        pcall(function() FOVCircle:Remove() end)
    end
    if SilentFOVCircle then
        pcall(function() SilentFOVCircle:Remove() end)
    end

    -- Clear ESP
    for player in pairs(Hub.ESP) do
        RemovePlayerESP(player)
    end
    ClearSafeESP()

    -- Restore Hitboxes
    local ch = Workspace:FindFirstChild("ClientHitboxes")
    if ch then
        for _, f in ipairs(ch:GetChildren()) do
            for _, p in ipairs(f:GetChildren()) do
                if p:IsA("BasePart") then
                    p.Transparency = 1
                end
            end
        end
    end

    -- Restore Weapon Configs
    if WeaponData and OriginalWeaponData then
        for name, orig in pairs(OriginalWeaponData) do
            local w = WeaponData[name]
            if w then
                pcall(function()
                    if orig.Recoil and w.Recoil then
                        makeWritable(w.Recoil)
                        w.Recoil.Up = orig.Recoil.Up
                        w.Recoil.Side = orig.Recoil.Side
                        w.Recoil.Return = orig.Recoil.Return
                        w.Recoil.AimScale = orig.Recoil.AimScale
                    end
                    if orig.Bloom and w.Bloom then
                        makeWritable(w.Bloom)
                        w.Bloom.Air = orig.Bloom.Air or 0
                        w.Bloom.Move = orig.Bloom.Move or 0
                        w.Bloom.Max = orig.Bloom.Max or 0
                        w.Bloom.Hip = orig.Bloom.Hip or 0
                        w.Bloom.PerShot = orig.Bloom.PerShot or 0
                        w.Bloom.Aim = orig.Bloom.Aim or 0
                    end
                    if orig.Fire and w.Fire then
                        makeWritable(w.Fire)
                        w.Fire.RPM = orig.Fire.RPM
                        w.Fire.Mode = orig.Fire.Mode
                    end
                    if orig.Ammo and w.Ammo then
                        makeWritable(w.Ammo)
                        w.Ammo.ReloadTime = orig.Ammo.ReloadTime
                    end
                end)
            end
        end
    end

    -- Restore Global Configs
    if Config and Config.Global then
        Config.Global.BloomScale = 0.8
    end

    if Controls and Controls.Press then
        pcall(function()
            Controls.Press("Fire", false)
            Controls.Press("Aim", false)
        end)
    end

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

    if ApplyNametagVisibility then
        pcall(ApplyNametagVisibility, false)
    end
    print("[KrakenHub] Urban Reload Script cleanly unloaded.")
end

-- ==============================================================
-- 🚀 15. INITIALIZE
-- ==============================================================
task.spawn(function()
    local ok, err = pcall(InitUI)
    if not ok then
        warn("[KrakenHub] InitUI Error: " .. tostring(err))
    else
        print("[KrakenHub] Urban Reload UI & Combat Engine successfully initialized!")
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
