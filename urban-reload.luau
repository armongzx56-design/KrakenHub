-- ==============================================================
-- 🌊 KRAKENHUB | URBAN RELOAD (รีโหลดในเมือง)
-- Game: https://www.roblox.com/games/84448037861644/Urban-Reload
-- PlaceId: 84448037861644
--
-- Features:
-- • 🛡️ 100% Anti-Detection: Blocks all Honeypot remotes (AdminTools & GunTuning -> Beat)
-- • 🎯 Combat Engine: Silent Hitbox Expander + Smooth Camera Aimbot + Bone Targeting
-- • 🔫 Weapon Mods: 100% No Recoil + 100% No Spread + Rapid Fire + Full Auto + Instant Reload
-- • 👁️ Visuals: 2D Box ESP + Skeleton Tracers + Health Bar + Distance + Weapon Name + Safe ESP + Loot ESP
-- • ⚡ Movement: Native Speed Enforcer + Infinite Stamina + High Jump + Inf Jump + Noclip + Fly
-- • 🌾 Automation: Auto Safe Farm (Safes 1-4) + Auto Loot Magnet + Auto Halloween Quest Claim
-- • 📍 Teleports: All 4 Military Safes + 8 Airdrop Spots + All SafeZones + ATMs
-- ==============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Check game PlaceId
if game.PlaceId ~= 84448037861644 and game.PlaceId ~= 0 then
    warn("[KrakenHub] Warning: PlaceId does not match Urban Reload (84448037861644)")
end

-- Cleanup previous instance
local genv = (typeof(getgenv) == "function" and getgenv()) or _G
genv._UrbanReloadScriptId = (genv._UrbanReloadScriptId or 0) + 1
local SCRIPT_ID = genv._UrbanReloadScriptId

if genv.UrbanReload_Cleanup then
    pcall(genv.UrbanReload_Cleanup)
end

-- ==============================================================
-- 🛡️ 1. ADVANCED ANTI-DETECTION & NETBEAT GUARDIAN
-- Urban Reload runs `NetBeatClient` which monitors:
-- 1. `namecallRatio()`: Compares `game:GetService` via __namecall vs direct C call.
--    Hooking `game.__namecall` on mobile executors severely slows it down,
--    failing the benchmark and triggering Kick: "Script executor detected".
--    WE NEVER HOOK `game.__namecall`.
-- 2. `NetBeatCamStart` / `NetBeatCamEnd`: Snapping camera aimbot detector.
--    We unbind both rendersteps cleanly so aimbot angles are never monitored.
-- 3. `u28` Report Queue: All anomaly codes (7501, 7503, 7701, 7704, 7801)
--    are queued into `u28` before being sent via `Beat:FireServer`.
--    We locate `u28` in memory, clear it, and lock it so no anomaly report
--    can ever be sent. The server receives 100% clean heartbeat pings (0/1).
-- 4. Safe No Recoil: We set `ClientState.RecoilScale = 0` (native engine multiplier)
--    instead of writing to protected RecoilPitch/RecoilYaw or unfreezing tables.
-- ==============================================================
local CollectionService = game:GetService("CollectionService")
local BeatRemote = ReplicatedStorage:WaitForChild("Remotes", 5) and ReplicatedStorage.Remotes:FindFirstChild("Beat")

-- 1.1 Neutralize Camera Anti-Cheat Rendersteps
local function SilenceCameraAntiCheat()
    pcall(function() RunService:UnbindFromRenderStep("NetBeatCamStart") end)
    pcall(function() RunService:UnbindFromRenderStep("NetBeatCamEnd") end)
end
SilenceCameraAntiCheat()

-- 1.2 Locate and Lock the Anomaly Queue (u28) in NetBeatClient
local NetBeatQueue = nil
if typeof(getgc) == "function" and typeof(getupvalues) == "function" then
    pcall(function()
        for _, fn in ipairs(getgc()) do
            if type(fn) == "function" and islclosure(fn) and not isexecutorclosure(fn) then
                local inf = getinfo(fn)
                if inf.source and inf.source:find("NetBeatClient") then
                    local ups = getupvalues(fn)
                    local hasBeat = false
                    local cand = nil
                    for _, val in pairs(ups) do
                        if typeof(val) == "Instance" and val.Name == "Beat" then
                            hasBeat = true
                        elseif type(val) == "table" and #val == 0 then
                            cand = val
                        end
                    end
                    if hasBeat and cand then
                        NetBeatQueue = cand
                        break
                    end
                end
            end
        end
    end)
end

if NetBeatQueue then
    table.clear(NetBeatQueue)
    pcall(setmetatable, NetBeatQueue, {
        __newindex = function() return end
    })
end

-- 1.3 Safe Honeypot Blocker via Beat.FireServer (WITHOUT touching game.__namecall)
if BeatRemote and typeof(hookfunction) == "function" then
    local oldBeatFire = nil
    oldBeatFire = hookfunction(BeatRemote.FireServer, function(self, ...)
        local args = {...}
        -- Drop AdminTools / Admin honeypots: Beat:FireServer(code, { p = ..., v = ... })
        if typeof(args[2]) == "table" and args[2].p ~= nil then
            return nil
        end
        if typeof(args[1]) == "number" and args[1] >= 7000 then
            return nil
        end
        return oldBeatFire(self, ...)
    end)
end

-- 1.4 Continuous Background Guardian
task.spawn(function()
    while Hub and Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        SilenceCameraAntiCheat()
        if NetBeatQueue then
            pcall(table.clear, NetBeatQueue)
        end
        task.wait(0.5)
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
        -- Combat / Aimbot
        Aimbot = true,
        AimbotTriggerMode = "Aim OR Shoot", -- "Aim OR Shoot", "Right Click Only", "Left Click Only", "Custom Keybind"
        AimbotKey = Enum.UserInputType.MouseButton2,
        AimbotBone = "Head", -- Always Head for 100% head lock
        AimbotPriority = "Distance", -- "Distance", "Crosshair", "Smart"
        AimbotSmoothing = 0, -- 0 = Instant 100% Lock to Head (ตาม ssss.txt)
        AimbotFOV = 200, -- Default from ssss.txt
        AimbotMaxDist = 350,
        AimbotWallCheck = true,
        AimbotIgnoreSafeZone = true,
        AimbotIgnoreShield = true,
        AimbotIgnoreDowned = true,
        DrawFOV = true,
        FOVColor = Color3.fromRGB(0, 220, 255),
        RedDamageNumbers = true,
        IconTheme = "Themed", -- "Themed", "ElectricBlue"

        -- Hitbox Expander (Bullet Tracking into Head)
        HitboxExpander = true,
        HitboxSize = 14,
        HitboxTarget = "Head", -- Focus directly on Head
        HitboxVisible = false,
        HitboxTransparency = 0.65,

        -- Auto Respawn (Key X / Instant Reset)
        AutoRespawn = true,
        RespawnKey = Enum.KeyCode.X,

        -- Weapon Mods (From ssss.txt + Reversing)
        NoRecoil = true,
        NoSpread = true,
        RapidFire = false,
        RapidFireRPM = 1100,
        FullAuto = true,
        InstantReload = false,
        FastReloadRatio = 0.35,

        -- Movement
        SpeedHack = false,
        SpeedValue = 28,
        InfiniteStamina = true,
        InfJump = false,
        HighJump = false,
        HighJumpPower = 65,
        Noclip = false,
        Fly = false,
        FlySpeed = 50,
        FastRoll = false,

        -- Visuals (ESP)
        PlayerESP = true,
        ESPBox = true,
        ESPName = true,
        ESPFont = "UI", -- "UI", "System", "Plex", "Monospace"
        ESPFontSize = 14,
        ESPNameMode = "DisplayName", -- "DisplayName", "Username", "Both"
        ESPHealth = true,
        ESPDistance = true,
        ESPTracers = false,
        ESPWeapon = true,
        ESPTeamCheck = false,
        ESPMaxDistance = 1500,

        BoxColor = Color3.fromRGB(255, 60, 60),
        NameColor = Color3.fromRGB(255, 255, 255),
        HealthColor = Color3.fromRGB(60, 255, 60),
        TracerColor = Color3.fromRGB(0, 200, 255),

        -- World ESP
        SafeESP = true,
        LootESP = true,
        HalloweenESP = true,
        ATMESP = false,

        -- Automation
        AutoLootMagnet = false,
        AutoClaimHalloween = false,
        AutoSafeCrack = false,
        SelectedSafe = "Safe 1",
    }
}
genv.KrakenHub = Hub

-- ================================================
-- 🎯 4. FOV DRAWING CIRCLE
-- ================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = Hub.Settings.AimbotFOV
FOVCircle.Color = Hub.Settings.FOVColor
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false
FOVCircle.NumSides = 64
FOVCircle.Transparency = 0.85

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

-- Check direct line of sight / wall obstruction
local function IsVisible(targetChar, targetPart)
    if not targetChar or not targetPart then return false end

    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    if direction.Magnitude < 0.2 then return true end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local ignoreList = {LocalPlayer.Character, Camera}
    local ch = Workspace:FindFirstChild("ClientHitboxes")
    if ch then table.insert(ignoreList, ch) end
    local gl = Workspace:FindFirstChild("GroundLoot")
    if gl then table.insert(ignoreList, gl) end

    params.FilterDescendantsInstances = ignoreList
    params.IgnoreWater = true

    for _ = 1, 4 do
        local result = Workspace:Raycast(origin, direction, params)
        if not result then
            return true
        end
        if result.Instance:IsDescendantOf(targetChar) then
            return true
        end
        -- Ignore non-collidable or transparent parts / shields / hitboxes
        if (not result.Instance.CanCollide) or result.Instance.Transparency >= 0.7 or result.Instance.Name == "Hitbox" then
            table.insert(ignoreList, result.Instance)
            params.FilterDescendantsInstances = ignoreList
        else
            return false
        end
    end
    return false
end

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

-- Target Selection in FOV (Prioritizes Physically Close Enemies in 3D Studs)
local function GetClosestEnemyInFOV()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = nil
    local bestScore = math.huge

    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos = (myHRP and myHRP.Position) or Camera.CFrame.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if IsTargetValid(player) then
            local bone = GetBone(player, Hub.Settings.AimbotBone)
            if bone then
                local worldDist = (myPos - bone.Position).Magnitude

                -- Check max 3D distance limit
                if worldDist <= Hub.Settings.AimbotMaxDist then
                    local screenPos, depth, onScreen = WorldToViewport(bone.Position)
                    if onScreen and depth > 0 then
                        local screenDist = (screenPos - center).Magnitude

                        -- Check FOV circle limit
                        if screenDist <= Hub.Settings.AimbotFOV then
                            -- Check Wall Check if enabled
                            local visible = true
                            if Hub.Settings.AimbotWallCheck then
                                visible = IsVisible(player.Character, bone)
                            end

                            if visible then
                                local score = 0
                                if Hub.Settings.AimbotPriority == "Distance" then
                                    -- Distance priority: Closest 3D enemy wins (screenDist is a minor tiebreaker)
                                    score = worldDist + (screenDist * 0.05)
                                elseif Hub.Settings.AimbotPriority == "Crosshair" then
                                    -- Crosshair priority: Closest to screen center
                                    score = screenDist
                                else -- "Smart"
                                    -- Hybrid priority: 70% 3D world distance + 30% screen distance
                                    score = (worldDist * 0.7) + (screenDist * 0.3)
                                end

                                -- Stickiness bonus to prevent erratic target swapping while holding aim
                                if Hub.CurrentTarget == player then
                                    score = score - 15
                                end

                                if score < bestScore then
                                    bestScore = score
                                    bestTarget = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    Hub.CurrentTarget = bestTarget
    return bestTarget
end

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

    for name, weapon in pairs(WeaponData) do
        if type(weapon) == "table" then
            pcall(function()
                -- 1. No Recoil
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

                -- 2. No Spread / Perfect Bloom
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
                        weapon.Bloom.Air = OriginalWeaponData[name].Bloom.Bloom and OriginalWeaponData[name].Bloom.Air or 0
                        weapon.Bloom.Move = OriginalWeaponData[name].Bloom.Move or 0
                        weapon.Bloom.Max = OriginalWeaponData[name].Bloom.Max or 0
                        weapon.Bloom.Hip = OriginalWeaponData[name].Bloom.Hip or 0
                        weapon.Bloom.PerShot = OriginalWeaponData[name].Bloom.PerShot or 0
                        weapon.Bloom.Aim = OriginalWeaponData[name].Bloom.Aim or 0
                    end
                end

                -- 3. Rapid Fire & Full Auto
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

                -- 4. Fast Reload
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
            end)
        end
    end
end

-- ================================================
-- 🎯 7. HITBOX EXPANDER (SILENT AIM ENGINE)
-- Directly scales parts in Workspace.ClientHitboxes
-- ================================================
local function UpdateHitboxes()
    local clientHitboxes = Workspace:FindFirstChild("ClientHitboxes")
    if not clientHitboxes then return end

    local targetSize = Vector3.new(Hub.Settings.HitboxSize, Hub.Settings.HitboxSize, Hub.Settings.HitboxSize)

    for _, folder in ipairs(clientHitboxes:GetChildren()) do
        if folder.Name ~= LocalPlayer.Name then
            local player = Players:FindFirstChild(folder.Name)
            local isTargetValid = player and IsEnemy(player) and IsAlive(player)

            local partsToScale = {}
            if Hub.Settings.HitboxTarget == "Head" then
                table.insert(partsToScale, folder:FindFirstChild("Head"))
            elseif Hub.Settings.HitboxTarget == "UpperTorso" then
                table.insert(partsToScale, folder:FindFirstChild("UpperTorso"))
            else
                for _, part in ipairs(folder:GetChildren()) do
                    if part:IsA("BasePart") then
                        table.insert(partsToScale, part)
                    end
                end
            end

            for _, part in ipairs(partsToScale) do
                if part and part:IsA("BasePart") then
                    if Hub.Settings.HitboxExpander and isTargetValid then
                        part.Size = targetSize
                        part.CanCollide = false
                        if Hub.Settings.HitboxVisible then
                            part.Transparency = Hub.Settings.HitboxTransparency
                            part.Color = Color3.fromRGB(255, 30, 30)
                            part.Material = Enum.Material.ForceField
                        else
                            part.Transparency = 1
                        end
                    else
                        part.Transparency = 1
                    end
                end
            end
        end
    end
end

-- ================================================
-- 🔄 8. HEARTBEAT / RENDERSTEPPED CORE LOOP
-- ================================================
Hub.Connections.CoreEnforcer = RunService.RenderStepped:Connect(function(dt)
    if not Hub.Running then return end

    -- 1. 100% Safe Native Camera Recoil Multiplier (Zero detection)
    if ClientState then
        if Hub.Settings.NoRecoil then
            ClientState.RecoilScale = 0
        else
            ClientState.RecoilScale = 1
        end
        -- Infinite Stamina & No Exhaustion
        if Hub.Settings.InfiniteStamina then
            ClientState.Stamina = ClientState.StaminaMax or 150
            ClientState.Exhausted = false
            ClientState.JumpCost = 0
        end
        -- Anti-Freeze / Downed Prevention
        ClientState.Frozen = false

        -- Enforce Red Damage Numbers in ClientState
        if Hub.Settings.RedDamageNumbers and not ClientState._HookedRedDamage then
            ClientState._HookedRedDamage = true
            local oldShow = ClientState.ShowDamageNumber
            if type(oldShow) == "function" then
                ClientState.ShowDamageNumber = function(hitData)
                    if type(hitData) == "table" and Hub.Settings.RedDamageNumbers then
                        if Hub.Settings.AimbotBone == "Head" or hitData.Headshot == true then
                            hitData.Headshot = true
                        end
                    end
                    return oldShow(hitData)
                end
            end
        end
    end

    -- Enforce Red Headshot Color attributes in StarterGui & PlayerGui
    if Hub.Settings.RedDamageNumbers then
        pcall(function()
            local starterGui = game:GetService("StarterGui")
            local wui = starterGui:FindFirstChild("WorldUI")
            local dn = wui and wui:FindFirstChild("DamageNumber")
            local text = dn and dn:FindFirstChild("Text")
            if text and text:GetAttribute("HeadColor") ~= Color3.fromRGB(255, 30, 30) then
                text:SetAttribute("HeadColor", Color3.fromRGB(255, 30, 30))
            end

            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            local hm = pg and pg:FindFirstChild("Hitmarker", true)
            if hm and hm:GetAttribute("HeadshotColor") ~= Color3.fromRGB(255, 30, 30) then
                hm:SetAttribute("HeadshotColor", Color3.fromRGB(255, 30, 30))
                hm:SetAttribute("KillColor", Color3.fromRGB(255, 30, 30))
            end
        end)
    end

    if Config and Config.Global then
        if Hub.Settings.FastRoll then
            Config.Global.RollCooldown = 0
            Config.Global.RollDistance = 2.2
        end
        -- Native Speed Multiplier
        if Hub.Settings.SpeedHack then
            Config.Global.SprintSpeed = Hub.Settings.SpeedValue
            Config.Global.WalkSpeed = math.min(Hub.Settings.SpeedValue * 0.7, 24)
            Config.Global.MoveSpeedMul = 1.3
        end
    end

    -- Character Speed & Jump
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if myHum and myHRP and myHum.Health > 0 then
        if Hub.Settings.SpeedHack then
            myHum.WalkSpeed = Hub.Settings.SpeedValue
        end
        if Hub.Settings.HighJump then
            myHum.UseJumpPower = true
            myHum.JumpPower = Hub.Settings.HighJumpPower
        end
    end

    -- Hitbox Expander update (Bullet tracking directly to head)
    if Hub.Settings.HitboxExpander then
        UpdateHitboxes()
    end
end)

-- ================================================
-- 🎯 8.1 POST-CAMERA AIMBOT ENGINE (FROM ssss.txt)
-- BindToRenderStep Camera.Value + 1 prevents camera fighting
-- Locks 100% to head on Shoot (Left Click) OR Aim (Right Click)
-- ================================================
pcall(function() RunService:UnbindFromRenderStep("KrakenAimbot") end)
RunService:BindToRenderStep("KrakenAimbot", Enum.RenderPriority.Camera.Value + 1, function()
    if not Hub.Running then return end

    -- Update FOV Circle perfectly in sync with camera viewport
    FOVCircle.Visible = Hub.Settings.Aimbot and Hub.Settings.DrawFOV
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Hub.Settings.AimbotFOV
        FOVCircle.Color = Hub.Settings.FOVColor
    end

    if not Hub.Settings.Aimbot then
        Hub.CurrentTarget = nil
        return
    end

    -- Trigger detection: Left Click (shooting), Right Click (aiming), or configured keybind
    local aimKeyPressed = false
    local trig = Hub.Settings.AimbotTriggerMode or "Aim OR Shoot"
    local isRightClick = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local isLeftClick = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    local isKey = false
    if typeof(Hub.Settings.AimbotKey) == "EnumItem" then
        if Hub.Settings.AimbotKey.EnumType == Enum.UserInputType then
            isKey = UserInputService:IsMouseButtonPressed(Hub.Settings.AimbotKey)
        else
            isKey = UserInputService:IsKeyDown(Hub.Settings.AimbotKey)
        end
    end

    if trig == "Aim OR Shoot" or trig:find("Aim OR Shoot") then
        aimKeyPressed = isRightClick or isLeftClick or isKey
    elseif trig:find("Right Click") then
        aimKeyPressed = isRightClick or isKey
    elseif trig:find("Left Click") then
        aimKeyPressed = isLeftClick
    else
        aimKeyPressed = isKey
    end

    if not aimKeyPressed then
        Hub.CurrentTarget = nil
        return
    end

    local target = GetClosestEnemyInFOV()
    if not target then
        Hub.CurrentTarget = nil
        return
    end

    local bone = GetBone(target, Hub.Settings.AimbotBone or "Head")
    if not bone then return end

    -- When targeting Head, add a slight vertical offset (+0.25 studs) so raycasts
    -- enter directly into the upper crown of the skull, avoiding torso/limb collisions
    local aimPos = bone.Position
    if (Hub.Settings.AimbotBone or "Head") == "Head" then
        aimPos = aimPos + Vector3.new(0, 0.25, 0)
    end

    local currentCF = Camera.CFrame
    local targetCF = CFrame.new(currentCF.Position, aimPos)
    -- Smoothing formula from ssss.txt: 0 = instant 100% lock, > 0 = organic lerp
    local alpha = (Hub.Settings.AimbotSmoothing <= 0) and 1 or math.clamp(Hub.Settings.AimbotSmoothing, 0.01, 1)
    Camera.CFrame = currentCF:Lerp(targetCF, alpha)
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
-- 🚀 9. INFINITE JUMP & FLY ENGINE
-- ================================================
Hub.Connections.InfJump = UserInputService.JumpRequest:Connect(function()
    if Hub.Running and Hub.Settings.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local flyBodyVel, flyBodyGyro = nil, nil
local function StartFly()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.Name = "KrakenFlyVel"
    flyBodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVel.Velocity = Vector3.zero
    CollectionService:AddTag(flyBodyVel, "OwnFX")
    flyBodyVel.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "KrakenFlyGyro"
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.CFrame = hrp.CFrame
    CollectionService:AddTag(flyBodyGyro, "OwnFX")
    flyBodyGyro.Parent = hrp

    Hub.Connections.FlyLoop = RunService.RenderStepped:Connect(function()
        if not Hub.Settings.Fly or not flyBodyVel or not flyBodyVel.Parent then return end
        local camCF = Camera.CFrame
        local dir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        flyBodyVel.Velocity = dir * Hub.Settings.FlySpeed
        flyBodyGyro.CFrame = camCF
    end)
end

local function StopFly()
    if Hub.Connections.FlyLoop then
        pcall(function() Hub.Connections.FlyLoop:Disconnect() end)
    end
    if flyBodyVel then pcall(function() flyBodyVel:Destroy() end) flyBodyVel = nil end
    if flyBodyGyro then pcall(function() flyBodyGyro:Destroy() end) flyBodyGyro = nil end
end

-- Noclip loop
Hub.Connections.NoclipLoop = RunService.Stepped:Connect(function()
    if Hub.Running and Hub.Settings.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ================================================
-- 👁️ 10. DRAWING API PLAYER ESP
-- ================================================
local function MakePlayerESP(player)
    if Hub.ESP[player] then return end

    local obj = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Dist = Drawing.new("Text"),
        Weapon = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }

    local fontId = (Drawing and Drawing.Fonts and Drawing.Fonts[Hub.Settings.ESPFont]) or 0
    local fontSize = Hub.Settings.ESPFontSize or 14
    local subSize = math.max(10, fontSize - 2)

    obj.Box.Visible = false
    obj.Box.Thickness = 1.5
    obj.Box.Filled = false
    obj.Box.Color = Hub.Settings.BoxColor

    obj.Name.Visible = false
    obj.Name.Color = Hub.Settings.NameColor
    obj.Name.Font = fontId
    obj.Name.Size = fontSize
    obj.Name.Center = true
    obj.Name.Outline = true
    obj.Name.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Health.Visible = false
    obj.Health.Color = Hub.Settings.HealthColor
    obj.Health.Font = fontId
    obj.Health.Size = subSize
    obj.Health.Center = true
    obj.Health.Outline = true
    obj.Health.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Dist.Visible = false
    obj.Dist.Color = Hub.Settings.NameColor
    obj.Dist.Font = fontId
    obj.Dist.Size = subSize
    obj.Dist.Center = true
    obj.Dist.Outline = true
    obj.Dist.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Weapon.Visible = false
    obj.Weapon.Color = Color3.fromRGB(255, 215, 0)
    obj.Weapon.Font = fontId
    obj.Weapon.Size = subSize
    obj.Weapon.Center = true
    obj.Weapon.Outline = true
    obj.Weapon.OutlineColor = Color3.fromRGB(0, 0, 0)

    obj.Tracer.Visible = false
    obj.Tracer.Color = Hub.Settings.TracerColor
    obj.Tracer.Thickness = 1.2

    Hub.ESP[player] = obj
end

local function RemovePlayerESP(player)
    local obj = Hub.ESP[player]
    if not obj then return end
    for _, d in pairs(obj) do
        pcall(function() d:Remove() end)
    end
    Hub.ESP[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then MakePlayerESP(p) end
end
Hub.Connections.PlayerAdded = Players.PlayerAdded:Connect(MakePlayerESP)
Hub.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(RemovePlayerESP)

Hub.Connections.ESPUpdate = RunService:BindToRenderStep("KrakenESP", Enum.RenderPriority.Camera.Value - 2, function()
    if not Hub.Running then return end

    local fontId = (Drawing and Drawing.Fonts and Drawing.Fonts[Hub.Settings.ESPFont]) or 0
    local fontSize = Hub.Settings.ESPFontSize or 14
    local subSize = math.max(10, fontSize - 2)

    for player, obj in pairs(Hub.ESP) do
        local visible = Hub.Settings.PlayerESP and IsEnemy(player) and IsAlive(player)

        if not visible then
            for _, d in pairs(obj) do d.Visible = false end
        else
            local char = GetCharacter(player)
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if not root or not head or not hum then
                for _, d in pairs(obj) do d.Visible = false end
                continue
            end

            local dist = (Camera.CFrame.Position - root.Position).Magnitude
            if dist > Hub.Settings.ESPMaxDistance then
                for _, d in pairs(obj) do d.Visible = false end
                continue
            end

            local topScreen, _, topOn = WorldToViewport(head.Position + Vector3.new(0, 2.2, 0))
            local bottomScreen, _, bottomOn = WorldToViewport(root.Position - Vector3.new(0, 3.2, 0))

            if not topOn or not bottomOn then
                for _, d in pairs(obj) do d.Visible = false end
                continue
            end

            local boxH = math.abs(topScreen.Y - bottomScreen.Y)
            local boxW = boxH * 0.55
            local boxX = topScreen.X - boxW / 2

            -- 1. Box
            obj.Box.Visible = Hub.Settings.ESPBox
            obj.Box.Position = Vector2.new(boxX, topScreen.Y)
            obj.Box.Size = Vector2.new(boxW, boxH)
            obj.Box.Color = Hub.Settings.BoxColor

            -- 2. Name (Clean Font & Legible format)
            obj.Name.Visible = Hub.Settings.ESPName
            obj.Name.Font = fontId
            obj.Name.Size = fontSize
            obj.Name.Position = Vector2.new(topScreen.X, topScreen.Y - (fontSize + 3))

            local nameStr = player.DisplayName
            if Hub.Settings.ESPNameMode == "Username" then
                nameStr = player.Name
            elseif Hub.Settings.ESPNameMode == "Both" then
                nameStr = player.DisplayName .. " (@" .. player.Name .. ")"
            end
            obj.Name.Text = nameStr
            obj.Name.Color = Hub.Settings.NameColor

            -- 3. Health
            local hp = math.clamp(math.floor((hum.Health / hum.MaxHealth) * 100), 0, 100)
            obj.Health.Visible = Hub.Settings.ESPHealth
            obj.Health.Font = fontId
            obj.Health.Size = subSize
            obj.Health.Position = Vector2.new(topScreen.X, topScreen.Y + boxH + 2)
            obj.Health.Text = hp .. "% HP"
            obj.Health.Color = Color3.fromRGB(255 - hp * 2.55, hp * 2.55, 30)

            -- 4. Distance
            obj.Dist.Visible = Hub.Settings.ESPDistance
            obj.Dist.Font = fontId
            obj.Dist.Size = subSize
            obj.Dist.Position = Vector2.new(topScreen.X, topScreen.Y + boxH + subSize + 3)
            obj.Dist.Text = math.floor(dist * 0.28) .. "m"

            -- 5. Weapon
            local tool = char:FindFirstChildOfClass("Tool")
            obj.Weapon.Visible = Hub.Settings.ESPWeapon and tool ~= nil
            if obj.Weapon.Visible then
                obj.Weapon.Font = fontId
                obj.Weapon.Size = subSize
                obj.Weapon.Position = Vector2.new(topScreen.X, topScreen.Y + boxH + (subSize * 2) + 5)
                obj.Weapon.Text = "[" .. (tool.Name) .. "]"
            end

            -- 6. Tracer
            obj.Tracer.Visible = Hub.Settings.ESPTracers
            obj.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            obj.Tracer.To = bottomScreen
            obj.Tracer.Color = Hub.Settings.TracerColor
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

-- ================================================
-- 🧲 12. AUTO LOOT MAGNET & HALLOWEEN CLAIM
-- ================================================
task.spawn(function()
    while Hub.Running and _G._UrbanReloadScriptId == SCRIPT_ID do
        task.wait(0.5)

        -- 1. Auto Loot Magnet
        if Hub.Settings.AutoLootMagnet and Remotes and Remotes:FindFirstChild("Loot") then
            local gl = Workspace:FindFirstChild("GroundLoot")
            if gl then
                for _, item in ipairs(gl:GetChildren()) do
                    pcall(function()
                        Remotes.Loot:FireServer("pick", item)
                    end)
                end
            end
        end

        -- 2. Auto Claim Halloween Quests
        if Hub.Settings.AutoClaimHalloween then
            local hq = ReplicatedStorage:FindFirstChild("HalloweenQuest")
            if hq then
                pcall(function()
                    hq:FireServer("claim", 1)
                    hq:FireServer("claim", 2)
                    hq:FireServer("claim", 3)
                end)
            end
        end
    end
end)

-- Safe Locations Coordinates
local SafePositions = {
    ["Safe 1"] = Vector3.new(-70.7, 19.6, 881.6),
    ["Safe 2"] = Vector3.new(-769.5, 6.6, 410.8),
    ["Safe 3"] = Vector3.new(208.9, 12.1, 533.4),
    ["Safe 4"] = Vector3.new(-732.9, 20.5, 729.7),
}

local function TeleportToSafe(safeName)
    local pos = SafePositions[safeName]
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and pos then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

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

    -- 🎨 2. LOAD MACLIB UI LIBRARY (WITH RED ACTIVE TOGGLE SWITCH PATCH)
    local MacLib = nil
    local ok, lib = pcall(function()
        local code = game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt")
        -- Patch toggle ON state to vibrant red Color3.fromRGB(235, 50, 50)
        code = code:gsub(
            "Tween%(toggle1,%s*TweenSettings%.Info,%s*{%s*ImageTransparency%s*=%s*transparencyValues%[1%]%s*}%)",
            "Tween(toggle1, TweenSettings.Info, { ImageTransparency = transparencyValues[1], ImageColor3 = State and Color3.fromRGB(235, 50, 50) or Color3.fromRGB(87, 86, 86) })"
        )
        code = code:gsub(
            "toggle1%.ImageColor3%s*=%s*Color3%.fromRGB%(87,%s*86,%s*86%)",
            "toggle1.ImageColor3 = togglebool and Color3.fromRGB(235, 50, 50) or Color3.fromRGB(87, 86, 86)"
        )
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

    -- 🌟 Rock-Solid Neon Blue Window Border & Section Borders (กรอบสีฟ้านีออนค้างถาวร ไม่กระพริบ)
    local _windowBorderHooked = false
    local function ApplyWindowBorder()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                base.ClipsDescendants = false

                -- 1. สร้างกรอบ Overlay ชั้นบนสุด (ZIndex 9999) ลอยครอบหน้าต่างไว้ถาวร ไม่มีวันกระพริบหรือโดนบดบัง
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

                -- 2. ตั้งค่ากรอบ SectionUIStroke เฉพาะกล่องเนื้อหา ไม่แตะต้อง Tab หรือปุ่มอื่นๆ เพื่อตัดปัญหากระพริบ
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
                        local isListening = false
                        binderBox.Focused:Connect(function()
                            isListening = true
                            binderBox.Text = "..."
                        end)
                        binderBox.FocusLost:Connect(function()
                            isListening = false
                            local b = macKeybind:GetBind()
                            binderBox.Text = (b and b.Name) or (typeof(b) == "EnumItem" and b.Name) or tostring(b or "None")
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

    -- 📑 All Tabs with Icons (เพิ่มไอค่อนแถบข้างทั้งหมด)
    local Tabs = {
        Combat   = CreateTabAdapter(tabGroup:Tab({ Name = "ต่อสู้",       Image = "rbxassetid://10709818534" }), "Combat"),
        Visuals  = CreateTabAdapter(tabGroup:Tab({ Name = "มองทะลุ",      Image = "rbxassetid://10747373176" }), "Visuals"),
        Movement = CreateTabAdapter(tabGroup:Tab({ Name = "เคลื่อนที่",     Image = "rbxassetid://10734950020" }), "Movement"),
        World    = CreateTabAdapter(tabGroup:Tab({ Name = "ฟาร์ม & โลก",  Image = "rbxassetid://10723405360" }), "World"),
        Teleport = CreateTabAdapter(tabGroup:Tab({ Name = "วาร์ป",         Image = "rbxassetid://10734952479" }), "Teleport"),
        Settings = CreateTabAdapter(tabGroup:Tab({ Name = "ตั้งค่า",       Image = "rbxassetid://10734950309" }), "Settings")
    }

    -- 🎨 Vibrant Themed Tab Icons Engine (ใส่สีสดใสในตัวไอค่อนแต่ละหมวด)
    local TabColors = {
        ["ต่อสู้"] = Color3.fromRGB(255, 65, 65),       -- Crimson Red (Combat)
        ["Combat"] = Color3.fromRGB(255, 65, 65),
        ["มองทะลุ"] = Color3.fromRGB(0, 220, 255),      -- Neon Cyan (Visuals)
        ["Visuals"] = Color3.fromRGB(0, 220, 255),
        ["เคลื่อนที่"] = Color3.fromRGB(255, 185, 35),   -- Amber Gold (Movement)
        ["Movement"] = Color3.fromRGB(255, 185, 35),
        ["ฟาร์ม & โลก"] = Color3.fromRGB(50, 225, 110), -- Emerald Green (World)
        ["ฟาร์มและโลก"] = Color3.fromRGB(50, 225, 110),
        ["World"] = Color3.fromRGB(50, 225, 110),
        ["วาร์ป"] = Color3.fromRGB(185, 95, 255),       -- Electric Purple (Teleport)
        ["Teleport"] = Color3.fromRGB(185, 95, 255),
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

                                -- Lock ImageColor3 permanently without fighting MacLib's transparency tween
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
        elseif idx == 3 and Tabs.Movement then Tabs.Movement:Select()
        elseif idx == 4 and Tabs.World then Tabs.World:Select()
        elseif idx == 5 and Tabs.Teleport then Tabs.Teleport:Select()
        elseif idx == 6 and Tabs.Settings then Tabs.Settings:Select()
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
    -- 🎯 COMBAT TAB (หมวดต่อสู้)
    -- ================================================
    Tabs.Combat:AddSection("ระบบช่วยเล็ง (Aimbot)")

    local HeadLock100Toggle = Tabs.Combat:AddToggle("HeadLock100Toggle", {
        Title = "ล็อคหัว 100% & กระสุนตามหัว (Head Lock 100%)",
        Description = "ล็อคเป้าหัวทันที 100% + กระสุนตรงเข้าหัวทุกนัด (ไร้แรงดีด + ปืนไม่ส่าย + ขยายหัว 14 studs)",
        Default = true
    })
    HeadLock100Toggle:OnChanged(function(v)
        if v then
            Hub.Settings.Aimbot = true
            Hub.Settings.AimbotSmoothing = 0
            Hub.Settings.AimbotBone = "Head"
            Hub.Settings.NoRecoil = true
            Hub.Settings.NoSpread = true
            Hub.Settings.HitboxExpander = true
            Hub.Settings.HitboxTarget = "Head"
            Hub.Settings.HitboxSize = 14
            ApplyWeaponMods()
            if Options.AimToggle then Options.AimToggle:SetValue(true) end
            if Options.SmoothSlider then Options.SmoothSlider:SetValue(0) end
            if Options.BoneDrop then Options.BoneDrop:SetValue("ส่วนหัว (Head - แนะนำ)") end
            if Options.NoRecoilToggle then Options.NoRecoilToggle:SetValue(true) end
            if Options.NoSpreadToggle then Options.NoSpreadToggle:SetValue(true) end
            if Options.HitboxToggle then Options.HitboxToggle:SetValue(true) end
            if Options.HitboxTargetDrop then Options.HitboxTargetDrop:SetValue("ส่วนหัว (Head - แนะนำ)") end
            if Options.HitboxSizeSlider then Options.HitboxSizeSlider:SetValue(14) end
        end
    end)

    local AimToggle = Tabs.Combat:AddToggle("AimToggle", {
        Title = "เปิดใช้งานระบบช่วยเล็ง (Aimbot)",
        Description = "ล็อคเป้าหมายที่อยู่ใกล้เคอร์เซอร์อัตโนมัติ (คลิกขวาเล็ง หรือ คลิกซ้ายยิง)",
        Default = Hub.Settings.Aimbot
    })
    AimToggle:OnChanged(function(v)
        Hub.Settings.Aimbot = v
    end)

    local TriggerDrop = Tabs.Combat:AddDropdown("TriggerDrop", {
        Title = "จังหวะการล็อคหัว (Aimbot Trigger)",
        Description = "เลือกว่าจะให้ล็อคหัวตอนไหน (แนะนำ: ทั้งตอนเล็งและตอนยิง)",
        Values = {"ทั้งตอนเล็งและตอนยิง (แนะนำ)", "ตอนคลิกขวาเล็งเท่านั้น", "ตอนคลิกซ้ายยิงเท่านั้น", "ปุ่มคีย์ลัดกำหนดเอง"},
        Default = "ทั้งตอนเล็งและตอนยิง (แนะนำ)"
    })
    TriggerDrop:OnChanged(function(v)
        if v:find("ทั้งตอนเล็ง") or v:find("Aim OR Shoot") then
            Hub.Settings.AimbotTriggerMode = "Aim OR Shoot"
        elseif v:find("เล็งเท่านั้น") or v:find("Right Click") then
            Hub.Settings.AimbotTriggerMode = "Right Click"
        elseif v:find("ยิงเท่านั้น") or v:find("Left Click") then
            Hub.Settings.AimbotTriggerMode = "Left Click"
        else
            Hub.Settings.AimbotTriggerMode = "Keybind"
        end
    end)

    local RedDmgToggle = Tabs.Combat:AddToggle("RedDmgToggle", {
        Title = "บังคับตัวเลขดาเมจสีแดง 100% (Red Damage Numbers)",
        Description = "บังคับให้ตัวเลขดาเมจและเป้าเล็งเป็นสีแดงสดทุกนัดที่ยิงเข้าหัว",
        Default = Hub.Settings.RedDamageNumbers
    })
    RedDmgToggle:OnChanged(function(v)
        Hub.Settings.RedDamageNumbers = v
    end)

    local FOVSlider = Tabs.Combat:AddSlider("FOVSlider", {
        Title = "ขนาดวงกลมช่วยเล็ง (FOV Radius)",
        Description = "รัศมีวงกลมการตรวจจับเป้าหมาย (แนะนำ 200)",
        Default = Hub.Settings.AimbotFOV,
        Min = 50,
        Max = 600,
        Rounding = 0
    })
    FOVSlider:OnChanged(function(v)
        Hub.Settings.AimbotFOV = v
        FOVCircle.Radius = v
    end)

    local SmoothSlider = Tabs.Combat:AddSlider("SmoothSlider", {
        Title = "ความนุ่มนวลการเล็ง (Smoothing)",
        Description = "0 = ล็อคหัวทันที 100% (ล็อคโหด) | 0.05 - 0.25 = นุ่มเนียนเหมือนคนเล่นจริง",
        Default = Hub.Settings.AimbotSmoothing,
        Min = 0,
        Max = 0.95,
        Rounding = 2
    })
    SmoothSlider:OnChanged(function(v)
        Hub.Settings.AimbotSmoothing = v
    end)

    local BoneDrop = Tabs.Combat:AddDropdown("BoneDrop", {
        Title = "ตำแหน่งที่ต้องการเล็ง (Target Bone)",
        Description = "เลือกชิ้นส่วนร่างกายของเป้าหมายที่จะล็อค",
        Values = {"ส่วนหัว (Head - แนะนำ)", "ลำตัวส่วนบน (UpperTorso)", "กลางตัว (HumanoidRootPart)"},
        Default = "ส่วนหัว (Head - แนะนำ)"
    })
    BoneDrop:OnChanged(function(v)
        if v:find("ส่วนหัว") or v:find("Head") then
            Hub.Settings.AimbotBone = "Head"
        elseif v:find("ลำตัว") or v:find("UpperTorso") then
            Hub.Settings.AimbotBone = "UpperTorso"
        else
            Hub.Settings.AimbotBone = "HumanoidRootPart"
        end
    end)

    local PriorityDrop = Tabs.Combat:AddDropdown("PriorityDrop", {
        Title = "ลำดับความสำคัญเป้าหมาย (Target Priority)",
        Description = "เลือกว่าจะล็อคศัตรูที่อยู่ใกล้ตัวเราสุด หรือใกล้กลางเป้าเล็งสุด",
        Values = {"ศัตรูที่ใกล้ตัวเราที่สุด (แนะนำ)", "ผสมผสาน (ใกล้ตัว + กลางจอ)", "ศัตรูที่ใกล้กึ่งกลางเป้าเล็งที่สุด"},
        Default = "ศัตรูที่ใกล้ตัวเราที่สุด (แนะนำ)"
    })
    PriorityDrop:OnChanged(function(v)
        if v:find("ใกล้ตัวเราที่สุด") or v:find("Distance") then
            Hub.Settings.AimbotPriority = "Distance"
        elseif v:find("กึ่งกลาง") or v:find("Crosshair") then
            Hub.Settings.AimbotPriority = "Crosshair"
        elseif v:find("ผสมผสาน") or v:find("Smart") then
            Hub.Settings.AimbotPriority = "Smart"
        end
    end)

    local MaxDistSlider = Tabs.Combat:AddSlider("MaxDistSlider", {
        Title = "ระยะล็อคเป้าหมายสูงสุด (Max Distance)",
        Description = "ไม่ล็อคศัตรูที่อยู่ไกลเกินระยะนี้ (Studs)",
        Default = Hub.Settings.AimbotMaxDist,
        Min = 50,
        Max = 800,
        Rounding = 0
    })
    MaxDistSlider:OnChanged(function(v)
        Hub.Settings.AimbotMaxDist = v
    end)

    local WallCheckToggle = Tabs.Combat:AddToggle("WallCheckToggle", {
        Title = "เช็คสิ่งกีดขวาง (Wall Check)",
        Description = "ไม่ล็อคศัตรูที่แอบอยู่หลังกำแพงหรือสิ่งปลูกสร้าง",
        Default = Hub.Settings.AimbotWallCheck
    })
    WallCheckToggle:OnChanged(function(v)
        Hub.Settings.AimbotWallCheck = v
    end)

    local SafeZoneToggle = Tabs.Combat:AddToggle("SafeZoneToggle", {
        Title = "ข้ามคนในเซฟโซน (Ignore SafeZone)",
        Description = "ไม่ล็อคศัตรูที่อยู่ในพื้นที่ปลอดภัยหรือเปิด PvPSafe",
        Default = Hub.Settings.AimbotIgnoreSafeZone
    })
    SafeZoneToggle:OnChanged(function(v)
        Hub.Settings.AimbotIgnoreSafeZone = v
    end)

    local ShieldToggle = Tabs.Combat:AddToggle("ShieldToggle", {
        Title = "ข้ามคนเกิดใหม่มีเกราะ (Ignore Spawn Shield)",
        Description = "ไม่ล็อคศัตรูที่มีเกราะกันดาเมจตอนเพิ่งเกิดใหม่",
        Default = Hub.Settings.AimbotIgnoreShield
    })
    ShieldToggle:OnChanged(function(v)
        Hub.Settings.AimbotIgnoreShield = v
    end)

    local DownedToggle = Tabs.Combat:AddToggle("DownedToggle", {
        Title = "ข้ามศัตรูที่ล้มคลาน (Ignore Downed)",
        Description = "ไม่ล็อคคนที่ถูกยิงล้มคลาน เพื่อโฟกัสยิงคนที่ยังยืนยิงเรา",
        Default = Hub.Settings.AimbotIgnoreDowned
    })
    DownedToggle:OnChanged(function(v)
        Hub.Settings.AimbotIgnoreDowned = v
    end)

    Tabs.Combat:AddKeybind("AimbotKeybind", {
        Title = "ปุ่มคีย์ลัดช่วยเล็ง (Aimbot Keybind)",
        Mode = "Hold",
        Default = Hub.Settings.AimbotKey or Enum.UserInputType.MouseButton2,
        Callback = function(key)
            Hub.Settings.AimbotKey = key
        end
    })

    Tabs.Combat:AddSection("ขยายฮิตบ็อกซ์ (Hitbox Expander)")

    local HitboxToggle = Tabs.Combat:AddToggle("HitboxToggle", {
        Title = "เปิดขยายฮิตบ็อกซ์ (Hitbox Expander)",
        Description = "ขยายขนาด Hitbox ศัตรู ยิงโดนหัวง่าย 100% แม้ยิงไม่ตรงเป้า",
        Default = Hub.Settings.HitboxExpander
    })
    HitboxToggle:OnChanged(function(v)
        Hub.Settings.HitboxExpander = v
        if not v then
            -- Reset hitboxes
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
        Max = 20,
        Rounding = 1
    })
    HitboxSizeSlider:OnChanged(function(v)
        Hub.Settings.HitboxSize = v
    end)

    local HitboxTargetDrop = Tabs.Combat:AddDropdown("HitboxTargetDrop", {
        Title = "ส่วนที่ต้องการขยาย (Target Part)",
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
        Title = "แสดงกล่องฮิตบ็อกซ์เรืองแสง (Show Hitboxes)",
        Description = "แสดงกล่องเรืองแสงของ Hitbox ศัตรูบนหน้าจอ",
        Default = Hub.Settings.HitboxVisible
    })
    HitboxVisToggle:OnChanged(function(v)
        Hub.Settings.HitboxVisible = v
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

    local InstantReloadToggle = Tabs.Combat:AddToggle("InstantReloadToggle", {
        Title = "รีโหลดกระสุนทันที (Instant Reload)",
        Description = "ลดเวลาบรรจุกระสุนลงเหลือ 0.05 วินาที รีโหลดแทบจะทันที",
        Default = Hub.Settings.InstantReload
    })
    InstantReloadToggle:OnChanged(function(v)
        Hub.Settings.InstantReload = v
        ApplyWeaponMods()
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
        Title = "แสดงหลอดเลือดและพลังชีวิต (Health Bar)",
        Description = "แสดงแถบเลือดและตัวเลข HP ของผู้เล่น",
        Default = Hub.Settings.ESPHealth
    })
    ESPHealthToggle:OnChanged(function(v) Hub.Settings.ESPHealth = v end)

    local ESPDistToggle = Tabs.Visuals:AddToggle("ESPDistToggle", {
        Title = "แสดงระยะห่าง (Distance)",
        Description = "แสดงระยะทางระหว่างเรากับผู้เล่น (เมตร/Studs)",
        Default = Hub.Settings.ESPDistance
    })
    ESPDistToggle:OnChanged(function(v) Hub.Settings.ESPDistance = v end)

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
    -- 🏃 MOVEMENT TAB (หมวดเคลื่อนที่)
    -- ================================================
    Tabs.Movement:AddSection("เกิดใหม่อัตโนมัติ & รีเซ็ตด่วน (Auto Respawn & Fast Reset)")

    local AutoRespawnToggle = Tabs.Movement:AddToggle("AutoRespawnToggle", {
        Title = "เกิดใหม่อัตโนมัติ (Auto Respawn - ปุ่ม X)",
        Description = "กดปุ่ม X หรือเมื่อถูกยิงล้มคลาน/เลือดหมด จะเกิดใหม่และรีเซ็ตทันทีไม่ต้องรอคูลดาวน์",
        Default = Hub.Settings.AutoRespawn
    })
    AutoRespawnToggle:OnChanged(function(v)
        Hub.Settings.AutoRespawn = v
    end)

    local RespawnKeybind = Tabs.Movement:AddKeybind("RespawnKeybind", {
        Title = "ปุ่มคีย์ลัดเกิดใหม่ (Respawn Key)",
        Default = Hub.Settings.RespawnKey,
        Callback = function(key)
            Hub.Settings.RespawnKey = key
        end
    })

    Tabs.Movement:AddButton({
        Title = "กดเกิดใหม่ทันที (Force Respawn Now)",
        Description = "รีเซ็ตตัวละครและข้ามคูลดาวน์เกิดใหม่ทันที 1 ครั้ง",
        Callback = function()
            if Hub.ForceRespawnPlayer then
                Hub.ForceRespawnPlayer()
            end
        end
    })

    Tabs.Movement:AddSection("ความเร็ว & สเตมิน่า (Speed & Stamina)")

    local SpeedToggle = Tabs.Movement:AddToggle("SpeedToggle", {
        Title = "เปิดใช้งานเพิ่มความเร็ววิ่ง (Speed Hack)",
        Description = "ปรับความเร็วการวิ่งผ่านระบบ Native Config & Humanoid",
        Default = Hub.Settings.SpeedHack
    })
    SpeedToggle:OnChanged(function(v)
        Hub.Settings.SpeedHack = v
        if not v then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 18 end
            if Config and Config.Global then
                Config.Global.SprintSpeed = 26
                Config.Global.WalkSpeed = 18
                Config.Global.MoveSpeedMul = 0.95
            end
        end
    end)

    local SpeedSlider = Tabs.Movement:AddSlider("SpeedSlider", {
        Title = "ระดับความเร็ววิ่ง (WalkSpeed Value)",
        Description = "ตั้งค่าความเร็วในการเดินและวิ่ง",
        Default = Hub.Settings.SpeedValue,
        Min = 18,
        Max = 65,
        Rounding = 0
    })
    SpeedSlider:OnChanged(function(v)
        Hub.Settings.SpeedValue = v
    end)

    local InfStaminaToggle = Tabs.Movement:AddToggle("InfStaminaToggle", {
        Title = "สเตมิน่าไม่จำกัด (Infinite Stamina)",
        Description = "วิ่งได้ตลอดเวลา ไม่เหนื่อย ไม่หมดแรง ล็อค Stamina เต็ม 100%",
        Default = Hub.Settings.InfiniteStamina
    })
    InfStaminaToggle:OnChanged(function(v)
        Hub.Settings.InfiniteStamina = v
    end)

    local InfJumpToggle = Tabs.Movement:AddToggle("InfJumpToggle", {
        Title = "กระโดดได้ไม่จำกัด (Infinite Jump)",
        Description = "สามารถกระโดดซ้ำกลางอากาศได้ต่อเนื่องไม่จำกัดครั้ง",
        Default = Hub.Settings.InfJump
    })
    InfJumpToggle:OnChanged(function(v) Hub.Settings.InfJump = v end)

    local NoclipToggle = Tabs.Movement:AddToggle("NoclipToggle", {
        Title = "เดินทะลุกำแพง (Noclip)",
        Description = "ปิดการชนของตัวละคร เดินทะลุสิ่งกีดขวางและกำแพงได้",
        Default = Hub.Settings.Noclip
    })
    NoclipToggle:OnChanged(function(v) Hub.Settings.Noclip = v end)

    local FlyToggle = Tabs.Movement:AddToggle("FlyToggle", {
        Title = "บินอิสระ (Fly - WASD + Space/Shift)",
        Description = "เปิดระบบบินอิสระ บังคับทิศทางด้วย WASD และขึ้นลงด้วย Space/Shift",
        Default = Hub.Settings.Fly
    })
    FlyToggle:OnChanged(function(v)
        Hub.Settings.Fly = v
        if v then StartFly() else StopFly() end
    end)

    local FlySpeedSlider = Tabs.Movement:AddSlider("FlySpeedSlider", {
        Title = "ความเร็วในการบิน (Fly Speed)",
        Description = "ปรับระดับความเร็วขณะเปิดโหมดบิน",
        Default = Hub.Settings.FlySpeed,
        Min = 20,
        Max = 150,
        Rounding = 0
    })
    FlySpeedSlider:OnChanged(function(v)
        Hub.Settings.FlySpeed = v
    end)

    -- ================================================
    -- 🌾 FARM & WORLD TAB (หมวดฟาร์ม & โลก)
    -- ================================================
    Tabs.World:AddSection("ระบบฟาร์มอัตโนมัติ (Auto Farming)")

    local LootMagnetToggle = Tabs.World:AddToggle("LootMagnetToggle", {
        Title = "ดูดเงินและของตกพื้นอัตโนมัติ (Auto Loot Magnet)",
        Description = "ดึงเงินและไอเทมที่ตกอยู่ตามพื้นรอบตัวเข้ากระเป๋าอัตโนมัติ",
        Default = Hub.Settings.AutoLootMagnet
    })
    LootMagnetToggle:OnChanged(function(v)
        Hub.Settings.AutoLootMagnet = v
    end)

    local AutoHalloweenToggle = Tabs.World:AddToggle("AutoHalloweenToggle", {
        Title = "กดรับเควสฮาโลวีนอัตโนมัติ (Auto Claim Halloween Quests)",
        Description = "กดรับเควสอีเวนต์ฮาโลวีนระดับ 1 ถึง 3 อัตโนมัติทันทีที่พร้อมรับ",
        Default = Hub.Settings.AutoClaimHalloween
    })
    AutoHalloweenToggle:OnChanged(function(v)
        Hub.Settings.AutoClaimHalloween = v
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

    -- ================================================
    -- 📍 TELEPORT TAB (หมวดวาร์ป)
    -- ================================================
    Tabs.Teleport:AddSection("จุดตู้เซฟทหาร ($5K - $50K)")

    Tabs.Teleport:AddButton({
        Title = "วาร์ปไปตู้เซฟจุดที่ 1 (Safe 1)",
        Description = "(-71, 20, 882) ตู้เซฟทหารจุดที่ 1",
        Callback = function() TeleportToSafe("Safe 1") end
    })

    Tabs.Teleport:AddButton({
        Title = "วาร์ปไปตู้เซฟจุดที่ 2 (Safe 2)",
        Description = "(-770, 7, 411) ตู้เซฟทหารจุดที่ 2",
        Callback = function() TeleportToSafe("Safe 2") end
    })

    Tabs.Teleport:AddButton({
        Title = "วาร์ปไปตู้เซฟจุดที่ 3 (Safe 3)",
        Description = "(209, 12, 533) ตู้เซฟทหารจุดที่ 3",
        Callback = function() TeleportToSafe("Safe 3") end
    })

    Tabs.Teleport:AddButton({
        Title = "วาร์ปไปตู้เซฟจุดที่ 4 (Safe 4)",
        Description = "(-733, 21, 730) ตู้เซฟทหารจุดที่ 4",
        Callback = function() TeleportToSafe("Safe 4") end
    })

    Tabs.Teleport:AddSection("เซฟโซน & ร้านค้า (Safe Zones & Shops)")

    local function TeleportTo(cf)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = cf
        end
    end

    Tabs.Teleport:AddButton({
        Title = "วาร์ปไปร้านขายปืน (Gun Store)",
        Description = "(-98, 18, 883) ร้านปืนหลักในเมือง",
        Callback = function() TeleportTo(CFrame.new(-98, 18, 883)) end
    })

    Tabs.Teleport:AddButton({
        Title = "วาร์ปไปร้านขายรถ (Car Dealer)",
        Description = "(-721, 18, 694) ร้านซื้อยานพาหนะ",
        Callback = function() TeleportTo(CFrame.new(-721, 18, 694)) end
    })

    Tabs.Teleport:AddButton({
        Title = "วาร์ปไปโซนตู้ ATM (ATM Group)",
        Description = "(-768, 5, 405) โซนตู้ฝาก-ถอนเงินสด",
        Callback = function() TeleportTo(CFrame.new(-768, 5, 405)) end
    })

    -- ================================================
    -- ⚙️ SETTINGS TAB (หมวดตั้งค่า)
    -- ================================================
    Tabs.Settings:AddSection("ปุ่มเปิด/ปิดเมนู (Menu Toggle)")

    Tabs.Settings:AddKeybind("MenuToggleKey", {
        Title = "ปุ่มคีย์ลัดเปิด/ปิดเมนู (Open/Close Menu Keybind)",
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

    Window:SelectTab(1)
    Fluent:Notify({
        Title = "🌊 KrakenHub โหลดสำเร็จ!",
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
    pcall(function() RunService:UnbindFromRenderStep("KrakenAimbot") end)

    -- Remove FOV Circle
    if FOVCircle then
        pcall(function() FOVCircle:Remove() end)
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
        Config.Global.SprintSpeed = 26
        Config.Global.WalkSpeed = 18
        Config.Global.MoveSpeedMul = 0.95
        Config.Global.BloomScale = 0.8
        Config.Global.RollCooldown = 0.5
        Config.Global.RollDistance = 1.2
    end

    StopFly()
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
