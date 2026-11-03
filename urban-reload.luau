-- ==============================================================
-- 🌊 KRAKENHUB | URBAN RELOAD (รีโหลดในเมือง) - DELTA iOS & AUTO FARM EDITION
-- Game: https://www.roblox.com/games/84448037861644/Urban-Reload
-- PlaceId: 84448037861644
--
-- Features:
-- • 📱 Delta iOS 100% Compatible: Native C++ Highlights & Billboards (No broken Drawing API)
-- • 🛡️ 100% Anti-Detection: NetBeat Anomaly Queue locked + OwnFX Tagging (Bypasses 7701)
-- • ⚔️ Hood NPC Auto Farm: Auto Aim & Shoot Head + Auto Weapon Equip + Smart LOS Wall Check
-- • 💰 Instant Loot Magnet: Direct remote fire + VirtualInputManager [E] upon NPC death
-- • 👁️ Delta iOS Player ESP: Glowing Chams Highlight + Overhead Name & Real-time Health Bar
-- • 🧟 Hood NPC ESP: Neon Orange Chams + Real-time HP Bar & Distance
-- • 💎 Military Safe ESP: Neon Cyan Chams + Safes 1-4 ($5,000 - $50,000)
-- • 🏧 Quick Banking: One-click deposit all cash into ATM
-- ==============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Controls = nil
pcall(function()
    Controls = require(ReplicatedStorage:WaitForChild("Controls", 3))
end)
local ClientState = nil
pcall(function()
    ClientState = require(ReplicatedStorage:WaitForChild("Weapons", 3):WaitForChild("ClientState", 3))
end)
local HoodRemote = ReplicatedStorage:FindFirstChild("HoodNPC") and ReplicatedStorage.HoodNPC:FindFirstChild("Remote")
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)

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
-- 🛡️ 1. ADVANCED ANTI-DETECTION & NETBEAT GUARDIAN
-- ==============================================================
local BeatRemote = Remotes and Remotes:FindFirstChild("Beat")

-- 1.0 Client-Side Anti-Kick Guardian
pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and typeof(hookfunction) == "function" and typeof(lp.Kick) == "function" then
        local oldKick = nil
        oldKick = hookfunction(lp.Kick, function(self, reason, ...)
            warn("[KrakenHub Anti-Kick] Blocked LocalPlayer:Kick! Reason: " .. tostring(reason))
            return nil
        end)
    end
end)

-- 1.1 Neutralize Camera Anti-Cheat Rendersteps
local function SilenceCameraAntiCheat()
    pcall(function() RunService:UnbindFromRenderStep("NetBeatCamStart") end)
    pcall(function() RunService:UnbindFromRenderStep("NetBeatCamEnd") end)
end
SilenceCameraAntiCheat()

-- 1.2 Locate and Lock the Anomaly Queue (u28) in NetBeatClient
local NetBeatQueue = nil
pcall(function()
    local get_info = getinfo or (debug and debug.getinfo)
    local get_upvalues = getupvalues or (debug and debug.getupvalues)
    local is_l = islclosure or is_l_closure or function(f) return type(f) == "function" end
    local is_exec = isexecutorclosure or is_executor_closure or checkcaller or function() return false end

    if typeof(getgc) == "function" and typeof(get_upvalues) == "function" then
        for _, fn in ipairs(getgc()) do
            if type(fn) == "function" and is_l(fn) and not is_exec(fn) then
                local inf = get_info and get_info(fn)
                if inf and inf.source and inf.source:find("NetBeatClient") then
                    local ups = get_upvalues(fn)
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
    end
end)

if NetBeatQueue then
    pcall(table.clear, NetBeatQueue)
    pcall(setmetatable, NetBeatQueue, {
        __newindex = function() return end
    })
end

-- 1.3 Safe Honeypot Blocker via Beat.FireServer
local BeatBlocked = false
if BeatRemote and typeof(hookfunction) == "function" then
    pcall(function()
        local oldBeatFire = nil
        oldBeatFire = hookfunction(BeatRemote.FireServer, function(self, ...)
            local args = {...}
            if typeof(args[2]) == "table" and args[2].p ~= nil then
                return nil
            end
            if typeof(args[1]) == "number" and args[1] >= 7000 then
                return nil
            end
            return oldBeatFire(self, ...)
        end)
        BeatBlocked = true
    end)
end

if not BeatBlocked and BeatRemote and typeof(hookmetamethod) == "function" then
    pcall(function()
        local oldNamecall = nil
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if self == BeatRemote then
                local method = getnamecallmethod()
                if method == "FireServer" or method == "fireServer" then
                    local args = {...}
                    if typeof(args[2]) == "table" and args[2].p ~= nil then return nil end
                    if typeof(args[1]) == "number" and args[1] >= 7000 then return nil end
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
end

-- ==============================================================
-- 📦 2. GAME REFERENCES & WEAPON CONFIG
-- ==============================================================
local Weapons = ReplicatedStorage:WaitForChild("Weapons", 10)
local WeaponData = Weapons and require(Weapons:WaitForChild("WeaponData", 5))

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
    SafeESP = {},
    PlayerESP = {},
    Settings = {
        -- Hood NPC Auto Farm & Kill Aura
        HoodKillAura = false,
        HoodKillAuraRange = 250,
        HoodWallCheck = true,
        HoodESP = true,
        SavedFarmSpot = Vector3.new(-1033.4, 14.6, 427.6),

        -- Compatibility aliases
        ZombieKillAura = false,
        ZombieKillAuraRange = 250,
        ZombieWallCheck = true,
        ZombieESP = true,

        -- Delta iOS Universal Player ESP
        PlayerESP = true,
        ESPChams = true,
        ESPName = true,
        ESPHealth = true,
        ESPDistance = true,
        ESPMaxDistance = 2500,

        -- World Safes
        SafeESP = true,
        IconTheme = "Themed",
    }
}
genv.KrakenHub = Hub

-- Continuous Background Guardian
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
-- 🛠️ 4. HELPER FUNCTIONS & WEAPON CONTROLLER
-- ==============================================================
local function makeWritable(tbl)
    if typeof(setreadonly) == "function" then
        pcall(setreadonly, tbl, false)
    elseif typeof(makewriteable) == "function" then
        pcall(makewriteable, tbl)
    end
end

-- Laser Precision Mod for Farm (0 Recoil + 0 Bloom)
local function ApplyWeaponMods()
    if not WeaponData then return end
    for name, weapon in pairs(WeaponData) do
        if type(weapon) == "table" then
            pcall(function()
                if weapon.Recoil then
                    makeWritable(weapon.Recoil)
                    weapon.Recoil.Up = 0
                    weapon.Recoil.Side = 0
                    weapon.Recoil.AimScale = 0
                    weapon.Recoil.Return = 100
                end
                if weapon.Bloom then
                    makeWritable(weapon.Bloom)
                    weapon.Bloom.Air = 0
                    weapon.Bloom.Move = 0
                    weapon.Bloom.Max = 0
                    weapon.Bloom.Hip = 0
                    weapon.Bloom.PerShot = 0
                    weapon.Bloom.Aim = 0
                end
            end)
        end
    end
end
Hub.ApplyWeaponMods = ApplyWeaponMods

-- Auto equip firearm in character's hand
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

-- ==============================================================
-- 🚀 5. RAYCAST LINE-OF-SIGHT & HOOD NPC DATA EXTRACTION
-- ==============================================================
local SharedRayParams = RaycastParams.new()
SharedRayParams.FilterType = Enum.RaycastFilterType.Exclude
SharedRayParams.IgnoreWater = true
SharedRayParams.RespectCanCollide = true

local function IsEnemyNPC(model)
    if not model or not model:IsA("Model") then return false end
    if model.Name:find("Hood") or model.Name:find("Zombie") then return true end
    local parent = model.Parent
    if parent and (parent.Name == "HoodLocal" or parent.Name == "Zombies") then
        return model:FindFirstChild("HumanoidRootPart") ~= nil or model:FindFirstChild("Head") ~= nil
    end
    return false
end

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

-- ==============================================================
-- 📱 6. DELTA iOS & MOBILE UNIVERSAL PLAYER ESP (NATIVE C++ ENGINE)
-- 100% Guaranteed to work on Delta iOS without Drawing.new
-- Tagged with OwnFX to completely bypass NetBeat 7701 checks
-- ==============================================================
local PlayerESPData = {}

local function RemovePlayerESP(player)
    local d = PlayerESPData[player]
    if d then
        if d.Highlight then pcall(function() d.Highlight:Destroy() end) end
        if d.Billboard then pcall(function() d.Billboard:Destroy() end) end
        PlayerESPData[player] = nil
    end
end

local function SetupPlayerESP(player)
    if player == LocalPlayer then return end
    RemovePlayerESP(player)

    local function HookChar(char)
        if not Hub.Running then return end
        local head = char:WaitForChild("Head", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        if not head or not hum then return end

        local data = {}

        -- 1. Native Highlight (Chams - 100% visible through walls on iOS Delta)
        local hl = Instance.new("Highlight")
        hl.Name = "KrakenPlayerHighlight"
        hl.FillColor = Color3.fromRGB(255, 45, 45)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.55
        hl.OutlineTransparency = 0.1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = Hub.Settings.PlayerESP and Hub.Settings.ESPChams
        CollectionService:AddTag(hl, "OwnFX")
        hl.Adornee = char
        hl.Parent = char
        data.Highlight = hl

        -- 2. Native BillboardGui (Name & Health Bar)
        local bb = Instance.new("BillboardGui")
        bb.Name = "KrakenPlayerBillboard"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 140, 0, 42)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = Hub.Settings.ESPMaxDistance or 2500
        bb.ResetOnSpawn = false
        bb.ClipsDescendants = false
        bb.Enabled = Hub.Settings.PlayerESP
        CollectionService:AddTag(bb, "OwnFX")

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "NameLbl"
        nameLbl.Size = UDim2.new(1, 0, 0, 16)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 12
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.TextStrokeTransparency = 0.2
        nameLbl.Text = player.DisplayName .. " (@" .. player.Name .. ")"
        nameLbl.Parent = bb

        local hpBg = Instance.new("Frame")
        hpBg.Name = "HpBg"
        hpBg.Size = UDim2.new(1, 0, 0, 5)
        hpBg.Position = UDim2.new(0, 0, 0, 18)
        hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        hpBg.BorderSizePixel = 0
        local c1 = Instance.new("UICorner")
        c1.CornerRadius = UDim.new(0, 3)
        c1.Parent = hpBg

        local hpBar = Instance.new("Frame")
        hpBar.Name = "HpBar"
        hpBar.Size = UDim2.new(1, 0, 1, 0)
        hpBar.BackgroundColor3 = Color3.fromRGB(50, 230, 90)
        hpBar.BorderSizePixel = 0
        local c2 = Instance.new("UICorner")
        c2.CornerRadius = UDim.new(0, 3)
        c2.Parent = hpBar
        hpBar.Parent = hpBg
        hpBg.Parent = bb

        local subLbl = Instance.new("TextLabel")
        subLbl.Name = "SubLbl"
        subLbl.Size = UDim2.new(1, 0, 0, 12)
        subLbl.Position = UDim2.new(0, 0, 0, 24)
        subLbl.BackgroundTransparency = 1
        subLbl.Font = Enum.Font.GothamMedium
        subLbl.TextSize = 10
        subLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        subLbl.TextStrokeTransparency = 0.3
        subLbl.Text = "0 studs"
        subLbl.Parent = bb

        -- Parent directly to Head part in Workspace for 100% Delta iOS projection
        bb.Parent = head
        data.Billboard = bb

        PlayerESPData[player] = data
    end

    if player.Character then
        task.spawn(HookChar, player.Character)
    end
    player.CharacterAdded:Connect(HookChar)
end

-- Hook all current and future players
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        SetupPlayerESP(p)
    end
end
Players.PlayerAdded:Connect(SetupPlayerESP)
Players.PlayerRemoving:Connect(RemovePlayerESP)

-- 6.1 Fast Real-Time Player ESP Update Loop
task.spawn(function()
    while Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        task.wait(0.08)

        if not Hub.Settings.PlayerESP then
            for _, d in pairs(PlayerESPData) do
                if d.Highlight and d.Highlight.Enabled then d.Highlight.Enabled = false end
                if d.Billboard and d.Billboard.Enabled then d.Billboard.Enabled = false end
            end
            task.wait(0.3)
            continue
        end

        local myPos = (Camera and Camera.CFrame.Position) or Vector3.zero
        for p, d in pairs(PlayerESPData) do
            local c = p.Character
            local head = c and c:FindFirstChild("Head")
            local hum = c and c:FindFirstChildOfClass("Humanoid")

            if c and head and hum and hum.Health > 0 then
                local dist = math.floor((head.Position - myPos).Magnitude)
                local inRange = dist <= (Hub.Settings.ESPMaxDistance or 2500)

                if d.Highlight then
                    d.Highlight.Enabled = Hub.Settings.ESPChams and inRange
                end

                if d.Billboard then
                    d.Billboard.Enabled = inRange
                    if inRange then
                        local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                        local hpBar = d.Billboard:FindFirstChild("HpBg") and d.Billboard.HpBg:FindFirstChild("HpBar")
                        if hpBar then
                            hpBar.Size = UDim2.new(pct, 0, 1, 0)
                            hpBar.BackgroundColor3 = Color3.fromRGB(math.floor(255 * (1 - pct)), math.floor(220 * pct), 60)
                        end

                        local subLbl = d.Billboard:FindFirstChild("SubLbl")
                        if subLbl then
                            local tool = c:FindFirstChildOfClass("Tool")
                            local weaponName = (tool and tool.Name) or "Fists"
                            subLbl.Text = dist .. " studs | " .. weaponName
                        end
                    end
                end
            else
                if d.Highlight then d.Highlight.Enabled = false end
                if d.Billboard then d.Billboard.Enabled = false end
            end
        end
    end
end)

-- ==============================================================
-- 💎 7. SAFE ESP (MILITARY SAFES 1-4) - DELTA iOS FIXED
-- ==============================================================
local function ClearSafeESP()
    for _, item in ipairs(Hub.SafeESP) do
        if typeof(item) == "Instance" then
            pcall(function() item:Destroy() end)
        elseif type(item) == "table" then
            if item.Billboard then pcall(function() item.Billboard:Destroy() end) end
            if item.Highlight then pcall(function() item.Highlight:Destroy() end) end
        end
    end
    table.clear(Hub.SafeESP)
end
Hub.ClearSafeESP = ClearSafeESP

local function UpdateSafeESP()
    ClearSafeESP()
    if not Hub.Settings.SafeESP then return end

    local coffres = Workspace:FindFirstChild("Coffres")
    if not coffres then return end

    for _, safe in ipairs(coffres:GetChildren()) do
        local part = safe:FindFirstChildWhichIsA("BasePart")
        if part then
            -- 1. Native Highlight Chams on Safe Model
            local safeHl = safe:FindFirstChild("KrakenSafeHighlight")
            if not safeHl then
                safeHl = Instance.new("Highlight")
                safeHl.Name = "KrakenSafeHighlight"
                safeHl.FillColor = Color3.fromRGB(0, 210, 255)
                safeHl.OutlineColor = Color3.fromRGB(255, 255, 255)
                safeHl.FillTransparency = 0.55
                safeHl.OutlineTransparency = 0.1
                safeHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                CollectionService:AddTag(safeHl, "OwnFX")
                safeHl.Adornee = safe
                safeHl.Parent = safe
            end

            -- 2. Native BillboardGui on Safe Part
            local bb = Instance.new("BillboardGui")
            bb.Name = "KrakenSafeESP"
            bb.Adornee = part
            bb.Size = UDim2.new(0, 150, 0, 36)
            bb.StudsOffset = Vector3.new(0, 3.5, 0)
            bb.AlwaysOnTop = true
            bb.LightInfluence = 0
            bb.MaxDistance = 5000
            bb.ResetOnSpawn = false
            bb.ClipsDescendants = false
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
            table.insert(Hub.SafeESP, { Billboard = bb, Highlight = safeHl })
        end
    end
end
Hub.UpdateSafeESP = UpdateSafeESP

-- ==============================================================
-- 🔫 8. HOOD NPC AUTO FARM & DELTA iOS HOOD ESP
-- ==============================================================
local HoodESPStorage = {}
local vim = game:GetService("VirtualInputManager")

-- 8.1 Real-Time Hood NPC ESP Loop (Delta iOS & Mobile Optimized)
task.spawn(function()
    local lastHeadEnforce = 0
    while Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        local espActive = (Hub.Settings.HoodESP or Hub.Settings.ZombieESP) and not Hub._CasesOpen
        local auraActive = Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura

        if not espActive and not auraActive then
            for _, item in pairs(HoodESPStorage) do
                if item.Billboard and item.Billboard.Enabled then item.Billboard.Enabled = false end
                if item.Highlight and item.Highlight.Enabled then item.Highlight.Enabled = false end
            end
            task.wait(0.5)
            continue
        end

        task.wait(0.1)

        local now = os.clock()
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

        pcall(function()
            local hoodLocal = Workspace:FindFirstChild("HoodLocal") or Workspace:FindFirstChild("Zombies")
            if not hoodLocal then return end

            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myPos = (myHRP and myHRP.Position) or Camera.CFrame.Position

            for model, item in pairs(HoodESPStorage) do
                if not model or not model.Parent then
                    if item.Billboard then pcall(function() item.Billboard:Destroy() end) end
                    if item.Highlight then pcall(function() item.Highlight:Destroy() end) end
                    HoodESPStorage[model] = nil
                end
            end

            if not espActive then
                for _, item in pairs(HoodESPStorage) do
                    if item.Billboard and item.Billboard.Enabled then item.Billboard.Enabled = false end
                    if item.Highlight and item.Highlight.Enabled then item.Highlight.Enabled = false end
                end
                return
            end

            local auraDist = Hub.Settings.HoodKillAuraRange or Hub.Settings.ZombieKillAuraRange or 250
            for _, z in ipairs(hoodLocal:GetChildren()) do
                if IsEnemyNPC(z) then
                    local head = z:FindFirstChild("Head") or z:FindFirstChild("HumanoidRootPart")
                    local hp, maxHp, isDead = GetHoodRealtimeData(z)
                    local item = HoodESPStorage[z]

                    if not isDead and hp > 0 and head and head.Position.Y > -100 then
                        local dist = math.floor((myPos - head.Position).Magnitude)
                        if dist <= auraDist + 150 then
                            if not item or not item.Billboard or not item.Billboard.Parent then
                                -- 1. Native Highlight on Hood NPC
                                local hl = Instance.new("Highlight")
                                hl.Name = "KrakenHoodHighlight"
                                hl.FillColor = Color3.fromRGB(255, 120, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.FillTransparency = 0.55
                                hl.OutlineTransparency = 0.1
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                CollectionService:AddTag(hl, "OwnFX")
                                hl.Adornee = z
                                hl.Parent = z

                                -- 2. Native BillboardGui directly on Head Part
                                local bb = Instance.new("BillboardGui")
                                bb.Name = "KrakenHoodESP"
                                bb.Adornee = head
                                bb.Size = UDim2.new(0, 140, 0, 36)
                                bb.StudsOffset = Vector3.new(0, 2.2, 0)
                                bb.AlwaysOnTop = true
                                bb.LightInfluence = 0
                                bb.MaxDistance = auraDist + 200
                                bb.ResetOnSpawn = false
                                bb.ClipsDescendants = false
                                CollectionService:AddTag(bb, "OwnFX")

                                local title = Instance.new("TextLabel")
                                title.Name = "Title"
                                title.Size = UDim2.new(1, 0, 0, 16)
                                title.BackgroundTransparency = 1
                                title.Font = Enum.Font.GothamBold
                                title.TextSize = 12
                                title.TextColor3 = Color3.fromRGB(255, 80, 80)
                                title.TextStrokeTransparency = 0.2
                                title.Text = "Hood NPC"
                                title.Parent = bb

                                local hpBg = Instance.new("Frame")
                                hpBg.Name = "HpBg"
                                hpBg.Size = UDim2.new(1, 0, 0, 6)
                                hpBg.Position = UDim2.new(0, 0, 0, 18)
                                hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                hpBg.BorderSizePixel = 0
                                local hpBgCorner = Instance.new("UICorner")
                                hpBgCorner.CornerRadius = UDim.new(0, 3)
                                hpBgCorner.Parent = hpBg

                                local hpBar = Instance.new("Frame")
                                hpBar.Name = "HpBar"
                                hpBar.Size = UDim2.new(1, 0, 1, 0)
                                hpBar.BackgroundColor3 = Color3.fromRGB(40, 220, 90)
                                hpBar.BorderSizePixel = 0
                                local hpCorner = Instance.new("UICorner")
                                hpCorner.CornerRadius = UDim.new(0, 3)
                                hpCorner.Parent = hpBar
                                hpBar.Parent = hpBg
                                hpBg.Parent = bb

                                local distLbl = Instance.new("TextLabel")
                                distLbl.Name = "DistLbl"
                                distLbl.Size = UDim2.new(1, 0, 0, 12)
                                distLbl.Position = UDim2.new(0, 0, 0, 24)
                                distLbl.BackgroundTransparency = 1
                                distLbl.Font = Enum.Font.GothamMedium
                                distLbl.TextSize = 10
                                distLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
                                distLbl.TextStrokeTransparency = 0.3
                                distLbl.Text = dist .. " studs"
                                distLbl.Parent = bb

                                -- Parent directly to Head part! 100% visible on Delta iOS!
                                bb.Parent = head
                                HoodESPStorage[z] = { Billboard = bb, Highlight = hl }
                            else
                                item.Billboard.Enabled = true
                                if item.Highlight then item.Highlight.Enabled = true end

                                local pct = math.clamp(hp / math.max(maxHp, 1), 0, 1)
                                local hpBar = item.Billboard:FindFirstChild("HpBg") and item.Billboard.HpBg:FindFirstChild("HpBar")
                                if hpBar then
                                    hpBar.Size = UDim2.new(pct, 0, 1, 0)
                                    hpBar.BackgroundColor3 = Color3.fromRGB(math.floor(255 * (1 - pct)), math.floor(220 * pct), 60)
                                end
                                local distLbl = item.Billboard:FindFirstChild("DistLbl")
                                if distLbl then
                                    distLbl.Text = dist .. " studs | " .. math.floor(hp) .. " HP"
                                end
                            end
                        else
                            if item and item.Billboard and item.Billboard.Enabled then item.Billboard.Enabled = false end
                            if item and item.Highlight and item.Highlight.Enabled then item.Highlight.Enabled = false end
                        end
                    else
                        if item and item.Billboard and item.Billboard.Enabled then item.Billboard.Enabled = false end
                        if item and item.Highlight and item.Highlight.Enabled then item.Highlight.Enabled = false end
                    end
                end
            end
        end)
    end
end)

-- 8.2 Automatic Shoot & Money Loot Engine
task.spawn(function()
    while Hub.Running and genv._UrbanReloadScriptId == SCRIPT_ID do
        task.wait(0.05)

        if not (Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura) then
            task.wait(0.3)
            continue
        end

        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if not myHRP or not myHum or myHum.Health <= 0 then
            task.wait(0.5)
            continue
        end

        local equippedGun = EnsureWeaponEquipped()
        if not equippedGun then
            task.wait(0.3)
            continue
        end

        local hoodLocal = Workspace:FindFirstChild("HoodLocal") or Workspace:FindFirstChild("Zombies")
        if not hoodLocal then
            task.wait(0.3)
            continue
        end

        local myPos = myHRP.Position
        local auraDist = Hub.Settings.HoodKillAuraRange or Hub.Settings.ZombieKillAuraRange or 250
        local targetHead = nil
        local targetNpc = nil
        local targetNpcId = nil
        local shortestDist = auraDist

        for _, z in ipairs(hoodLocal:GetChildren()) do
            if IsEnemyNPC(z) then
                local head = z:FindFirstChild("Head") or z:FindFirstChild("HumanoidRootPart")
                if head and head.Position.Y > -100 then
                    local hp, _, isDead, npcId = GetHoodRealtimeData(z)
                    if not isDead and hp > 0 then
                        local dist = (myPos - head.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            targetHead = head
                            targetNpc = z
                            targetNpcId = npcId
                        end
                    end
                end
            end
        end

        if targetHead and targetNpc then
            Hub.CurrentTarget = targetNpc

            local isClearLOS = true
            local wallCheck = (Hub.Settings.HoodWallCheck ~= false) and (Hub.Settings.ZombieWallCheck ~= false)
            if wallCheck then
                isClearLOS = IsHoodVisible(targetHead, targetNpc)
            end

            if not isClearLOS then
                task.wait(0.03)
            else
                if Controls then
                    Controls.Press("Aim", true)
                end
                if ClientState then
                    ClientState.Aiming = true
                    ClientState.RecoilScale = 0
                end

                local shots = 0
                while Hub.Running and (Hub.Settings.HoodKillAura or Hub.Settings.ZombieKillAura) and targetHead and targetHead.Position.Y > -100 and shots < 6 do
                    local curHp, _, isDeadNow = GetHoodRealtimeData(targetNpc)
                    if isDeadNow or curHp <= 0 then
                        break
                    end
                    if wallCheck and not IsHoodVisible(targetHead, targetNpc) then
                        break
                    end
                    shots = shots + 1
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                    if Controls then
                        Controls.Press("Fire", true)
                        task.wait(0.08)
                        Controls.Press("Fire", false)
                        task.wait(0.04)
                    else
                        if typeof(mouse1press) == "function" then
                            mouse1press()
                            task.wait(0.07)
                            mouse1release()
                            task.wait(0.03)
                        end
                    end
                end

                pcall(function()
                    if ClientState and type(ClientState.HoodLootNow) == "function" then
                        ClientState.HoodLootNow()
                    end
                    local hoodRemote = HoodRemote or (ReplicatedStorage:FindFirstChild("HoodNPC") and ReplicatedStorage.HoodNPC:FindFirstChild("Remote"))
                    if hoodRemote and targetNpcId then
                        hoodRemote:FireServer("loot", targetNpcId, targetHead.Position)
                    end
                    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.02)
                    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end)
            end
        else
            Hub.CurrentTarget = nil
            if Controls and Controls.IsDown and Controls.IsDown("Aim") then
                pcall(function() Controls.Press("Aim", false) end)
            end

            pcall(function()
                if ClientState and type(ClientState.HoodLootNow) == "function" then
                    ClientState.HoodLootNow()
                end
                vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.02)
                vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
            task.wait(0.15)
        end
    end
end)

-- ==============================================================
-- 🎨 9. MODERN MACLIB UI & FLOATING LOGO INTERFACE
-- ==============================================================
local function InitUI()
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

    -- 🏷️ Logo Asset Loader
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

    -- 🎨 Load MacLib UI Library
    local MacLib = nil
    local ok, lib = pcall(function()
        local code = game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt")

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

        -- 3. Fix Slider Overlap
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

        -- 4. Fix Keybind Overlap
        code = code:gsub(
            "keybindName%.AutomaticSize%s*=%s*Enum%.AutomaticSize%.XY",
            "keybindName.AutomaticSize = Enum.AutomaticSize.None\n\t\t\t\t\tkeybindName.Size = UDim2.new(1, -100, 1, 0)\n\t\t\t\t\tkeybindName.ClipsDescendants = true"
        )

        -- 5. Mobile font sizes boost
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

    -- 📐 Responsive Window Size
    local function GetOptimalWindowSize()
        local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
        if vp.X < 900 or UserInputService.TouchEnabled then
            local w = math.clamp(math.floor(vp.X * 0.88), 340, 720)
            local h = math.clamp(math.floor(vp.Y * 0.82), 260, 480)
            return UDim2.fromOffset(w, h)
        end
        return UDim2.fromOffset(780, 520)
    end

    -- 🪟 Create Main Window
    local Window = MacLib:Window({
        Title = "KrakenHub",
        Subtitle = "ฟาร์ม & มองทะลุ (Delta iOS Edition)",
        Size = GetOptimalWindowSize(),
        DragStyle = 2,
        ShowUserInfo = true,
        Keybind = Enum.KeyCode.RightControl,
        AcrylicBlur = false,
    })
    Hub.Window = Window

    -- 🌟 Neon Border, Green Dot & Cyber Glass Grip
    local _windowBorderHooked = false
    local function ApplyWindowBorder()
        pcall(function()
            local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                      or (CoreGui and CoreGui:FindFirstChild("Base", true))
            if base then
                base.ClipsDescendants = false

                -- 1. Neon Border Overlay (ZIndex 9999)
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
                end

                -- 2. Restore Green Maximize Dot
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

                -- 3. Cyber Glass Corner Resize Grip (3 Neon Rungs)
                local oldGrip = base:FindFirstChild("KrakenResizeGrip")
                if oldGrip then oldGrip:Destroy() end

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
                        TweenService:Create(gripContainer, TweenInfo.new(0.12), { BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(18, 26, 38) }):Play()
                        TweenService:Create(gripStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(120, 240, 255), Transparency = 0, Thickness = 1.4 }):Play()
                        for _, rf in ipairs(rungFrames) do
                            TweenService:Create(rf, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(160, 250, 255), BackgroundTransparency = 0 }):Play()
                        end
                    elseif hovered then
                        TweenService:Create(gripContainer, TweenInfo.new(0.15), { BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(16, 22, 32) }):Play()
                        TweenService:Create(gripStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(60, 215, 255), Transparency = 0.2, Thickness = 1.2 }):Play()
                        for _, rf in ipairs(rungFrames) do
                            TweenService:Create(rf, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(100, 235, 255), BackgroundTransparency = 0.1 }):Play()
                        end
                    else
                        TweenService:Create(gripContainer, TweenInfo.new(0.2), { BackgroundTransparency = 0.35, BackgroundColor3 = Color3.fromRGB(14, 18, 26) }):Play()
                        TweenService:Create(gripStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(0, 180, 255), Transparency = 0.45, Thickness = 1.0 }):Play()
                        for idx, rf in ipairs(rungFrames) do
                            local tr = (rungsData[idx] and rungsData[idx].trans) or 0.3
                            TweenService:Create(rf, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0, 210, 255), BackgroundTransparency = tr }):Play()
                        end
                    end
                end

                gripButton.MouseEnter:Connect(function() if not resizing then SetGripVisualState(false, true) end end)
                gripButton.MouseLeave:Connect(function() if not resizing then SetGripVisualState(false, false) end end)

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
                        local newW = math.clamp(resizeStartSize.X + deltaX, minW, math.max(minW, vp.X - 16))
                        local newH = math.clamp(resizeStartSize.Y + deltaY, minH, math.max(minH, vp.Y - 16))
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

                -- 4. UserInfo Masking & Green Online Dot
                local uInfo = base:FindFirstChild("UserInfo", true)
                if uInfo then
                    pcall(function()
                        local headshot = uInfo:FindFirstChild("Headshot", true)
                        if headshot and headshot:IsA("ImageLabel") and not headshot:FindFirstChild("OnlineStatusDot") then
                            local dot = Instance.new("Frame")
                            dot.Name = "OnlineStatusDot"
                            dot.Size = UDim2.fromOffset(9, 9)
                            dot.Position = UDim2.new(1, 1, 1, 1)
                            dot.AnchorPoint = Vector2.new(1, 1)
                            dot.BackgroundColor3 = Color3.fromRGB(35, 209, 96)
                            dot.BorderSizePixel = 0
                            dot.ZIndex = (headshot.ZIndex or 1) + 5
                            local c = Instance.new("UICorner")
                            c.CornerRadius = UDim.new(1, 0)
                            c.Parent = dot
                            dot.Parent = headshot
                        end
                    end)
                end

                if not _windowBorderHooked then
                    _windowBorderHooked = true
                end
            end
        end)
    end
    Hub.ApplyBorders = ApplyWindowBorder

    -- ✨ Title Light Sweep Sheen Engine
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
                        local tweenInfo = TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        while Hub.Running and titleLabel.Parent and gradient.Parent do
                            gradient.Offset = Vector2.new(-1, 0)
                            local tween = TweenService:Create(gradient, tweenInfo, { Offset = Vector2.new(1, 0) })
                            tween:Play()
                            tween.Completed:Wait()
                            task.wait(3.5)
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

    -- 🔘 Draggable Floating Logo Button
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

        local logoImg = Instance.new("ImageLabel")
        logoImg.Name = "Logo"
        logoImg.Size = UDim2.fromScale(0.82, 0.82)
        logoImg.Position = UDim2.fromScale(0.5, 0.5)
        logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
        logoImg.BackgroundTransparency = 1
        logoImg.Image = GetLogoAsset()
        logoImg.ScaleType = Enum.ScaleType.Fit
        logoImg.Parent = mainBtn

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
                task.wait(3.2)
            end
        end)

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

        local okP = pcall(function() screenGui.Parent = targetGuiParent end)
        if not okP or not screenGui.Parent then
            pcall(function() screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
        end
        Hub.ToggleButtonGui = screenGui
        return screenGui
    end

    CreateFloatingToggleButton(Window)

    -- 🧩 Fluent Compatibility Adapter Layer
    local tabGroup = Window:TabGroup()
    local Options = {}
    MacLib.Options = Options

    local function CreateTabAdapter(rawTab, tabName)
        local leftSection = rawTab:Section({ Side = "Left" })
        local rightSection = rawTab:Section({ Side = "Right" })
        local currentSection = leftSection
        local side = "Left"

        return {
            RawTab = rawTab,
            Select = function(self) rawTab:Select() end,
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
                return currentSection:Paragraph({
                    Header = cfg.Title or cfg.Header or "Paragraph",
                    Body = cfg.Content or cfg.Body or ""
                })
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
                function macToggle:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function macToggle:SetValue(v) if macToggle.SetState then macToggle:SetState(v) end end
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
                function macSlider:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function macSlider:SetValue(v) if macSlider.Set then macSlider:Set(v) end end
                Options[flag] = macSlider
                return macSlider
            end,
            AddDropdown = function(self, flag, cfg)
                local changedCallbacks = {}
                local macDropdown = currentSection:Dropdown({
                    Name = cfg.Title or flag,
                    Options = cfg.Values or {},
                    Default = cfg.Default,
                    Callback = function(v)
                        if cfg.Callback then pcall(cfg.Callback, v) end
                        for _, fn in ipairs(changedCallbacks) do pcall(fn, v) end
                    end
                }, flag)
                macDropdown.Value = cfg.Default or (cfg.Values and cfg.Values[1]) or ""
                function macDropdown:OnChanged(fn) table.insert(changedCallbacks, fn) end
                function macDropdown:SetValue(v) if macDropdown.Set then macDropdown:Set(v) end end
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
                local defKey = cfg.Default or Enum.KeyCode.RightControl
                local macKeybind = currentSection:Keybind({
                    Name = cfg.Title or flag,
                    Default = defKey,
                    Callback = cfg.Callback
                }, flag)
                Options[flag] = macKeybind
                return macKeybind
            end
        }
    end

    -- 📑 TABS: FARM, VISUALS & SETTINGS
    local Tabs = {
        World    = CreateTabAdapter(tabGroup:Tab({ Name = "ฟาร์ม",   Image = "rbxassetid://10723405360" }), "World"),
        Visuals  = CreateTabAdapter(tabGroup:Tab({ Name = "มองทะลุ", Image = "rbxassetid://10747373176" }), "Visuals"),
        Settings = CreateTabAdapter(tabGroup:Tab({ Name = "ตั้งค่า", Image = "rbxassetid://10734950309" }), "Settings")
    }

    local Fluent = {
        Options = Options,
        Notify = function(self, cfg)
            Window:Notify({
                Title = cfg.Title or "KrakenHub",
                Description = cfg.Content or cfg.Description or "",
                Lifetime = cfg.Duration or 4
            })
        end,
        Destroy = function(self)
            pcall(function() Window:Unload() end)
        end
    }
    Hub.Fluent = Fluent

    -- ================================================
    -- 🌾 FARM TAB (หมวดฟาร์มเงิน & บอทอัตโนมัติ)
    -- ================================================
    Tabs.World:AddSection("⚔️ เล็งและยิงบอท Hood อัตโนมัติ (Auto Aim & Shoot Hood NPCs)")

    local HoodKillAuraToggle = Tabs.World:AddToggle("HoodKillAuraToggle", {
        Title = "เริ่มเล็งและยิงบอท Hood อัตโนมัติ (Auto Aim & Shoot Hood NPCs)",
        Description = "เล็งหัวและยิงบอท Hood ทั้งหมดในจุดฟาร์มอัตโนมัติ วนลูปเกิดใหม่ก็ยิง + เก็บเงินด่วน",
        Default = Hub.Settings.HoodKillAura
    })
    HoodKillAuraToggle:OnChanged(function(v)
        Hub.Settings.HoodKillAura = v
        Hub.Settings.ZombieKillAura = v
        if v then
            task.spawn(function()
                ApplyWeaponMods()
                EnsureWeaponEquipped()
                if Controls then
                    pcall(function() Controls.Press("Aim", true) end)
                end
                if ClientState then
                    ClientState.Aiming = true
                    ClientState.RecoilScale = 0
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
        Title = "ตรวจจับสิ่งกีดขวาง (Hood Wall Check / LOS)",
        Description = "ไม่ยิงสิ่งกีดขวาง รอให้บอท Hood เดินออกมาในที่โล่งก่อนค่อยยิง (ประหยัดกระสุน)",
        Default = Hub.Settings.HoodWallCheck
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
        Default = Hub.Settings.HoodKillAuraRange,
        Rounding = 0
    })
    HoodKillAuraDistSlider:OnChanged(function(v)
        Hub.Settings.HoodKillAuraRange = v
        Hub.Settings.ZombieKillAuraRange = v
    end)

    local HoodESPToggle = Tabs.World:AddToggle("HoodESPToggle", {
        Title = "มองทะลุบอท Hood (Hood NPC ESP - Delta iOS)",
        Description = "แสดงชื่อ ระยะ และหลอดเลือดบอท Hood แบบ Real-time (ติด 100% บน Delta iOS)",
        Default = Hub.Settings.HoodESP
    })
    HoodESPToggle:OnChanged(function(v)
        Hub.Settings.HoodESP = v
        Hub.Settings.ZombieESP = v
    end)

    Tabs.World:AddButton({
        Title = "วาร์ปไปจุดฟาร์มบอท Hood (Teleport to Farm Spot)",
        Description = "วาร์ปตัวละครไปยังจุดฟาร์มบอทที่ปลอดภัยและมุมยิงดีที่สุดทันที",
        Callback = function()
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP and Hub.Settings.SavedFarmSpot then
                myHRP.CFrame = CFrame.new(Hub.Settings.SavedFarmSpot + Vector3.new(0, 3, 0))
                Fluent:Notify({ Title = "Farm Spot", Content = "วาร์ปไปยังจุดฟาร์มบอทแล้ว", Duration = 3 })
            end
        end
    })

    Tabs.World:AddSection("💎 ตู้เซฟ & การเงิน (Safes & Banking)")

    local SafeESPToggle = Tabs.World:AddToggle("SafeESPToggle", {
        Title = "มองทะลุตู้เซฟ (Military Safe ESP - Delta iOS)",
        Description = "แสดงตำแหน่งตู้เซฟทหาร (เซฟ 1, 2, 3, 4) พร้อมรางวัล $5,000 - $50,000",
        Default = Hub.Settings.SafeESP
    })
    SafeESPToggle:OnChanged(function(v)
        Hub.Settings.SafeESP = v
        UpdateSafeESP()
    end)
    UpdateSafeESP()

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
    -- 👁️ VISUALS TAB (หมวดมองทะลุผู้เล่น - DELTA iOS EDITION)
    -- ================================================
    Tabs.Visuals:AddSection("มองทะลุผู้เล่น (Player ESP - Delta iOS 100%)")

    local PlayerESPToggle = Tabs.Visuals:AddToggle("PlayerESPToggle", {
        Title = "เปิดระบบมองทะลุผู้เล่น (Enable Player ESP)",
        Description = "มองทะลุผู้เล่นทุกคนในเซิร์ฟเวอร์ด้วย C++ Highlight & Billboard (ติด 100% บน Delta iOS)",
        Default = Hub.Settings.PlayerESP
    })
    PlayerESPToggle:OnChanged(function(v)
        Hub.Settings.PlayerESP = v
    end)

    local ChamsToggle = Tabs.Visuals:AddToggle("ChamsToggle", {
        Title = "ตัวละครเรืองแสงมองทะลุกำแพง (Chams Glow)",
        Description = "ไฮไลท์ตัวละครผู้เล่นด้วยแสงสีแดง มองเห็นทะลุกำแพงได้จากทุกระยะ",
        Default = Hub.Settings.ESPChams
    })
    ChamsToggle:OnChanged(function(v)
        Hub.Settings.ESPChams = v
    end)

    local PlayerESPMaxDistSlider = Tabs.Visuals:AddSlider("PlayerESPMaxDistSlider", {
        Title = "ระยะแสดงผลผู้เล่น (Max Distance)",
        Description = "ระยะทางสูงสุดที่จะแสดงชื่อและหลอดเลือดของผู้เล่น",
        Min = 200,
        Max = 5000,
        Default = Hub.Settings.ESPMaxDistance or 2500,
        Rounding = 0
    })
    PlayerESPMaxDistSlider:OnChanged(function(v)
        Hub.Settings.ESPMaxDistance = v
    end)

    -- ================================================
    -- ⚙️ SETTINGS TAB (หมวดตั้งค่า)
    -- ================================================
    Tabs.Settings:AddSection("ปุ่มเปิด/ปิดเมนู (Menu Toggle)")

    Tabs.Settings:AddKeybind("MenuToggleKey", {
        Title = "ปุ่มเปิด/ปิดเมนู (Menu Key)",
        Default = Enum.KeyCode.RightControl,
        Callback = function(key)
            pcall(function() Window:SetKeybind(key) end)
        end
    })

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
                Fluent:Notify({ Title = "FPS Booster", Content = "เปิดโหมดประหยัดทรัพยากรแล้ว", Duration = 3 })
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

    Tabs.Settings:AddSection("จัดการสคริปต์ (Script Management)")

    Tabs.Settings:AddButton({
        Title = "ปิดการทำงาน KrakenHub (Unload Script)",
        Description = "ปิดการทำงานของสคริปต์ ลบหน้าต่าง UI ทั้งหมด และคืนค่าเดิมของเกม",
        Callback = function()
            Window:Dialog({
                Title = "ยืนยันการปิดสคริปต์",
                Content = "คุณต้องการปิด KrakenHub หรือไม่?",
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

    -- Vibrant Icon Styling for Tabs
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
                                if nameLabel.Text:find("ฟาร์ม") then
                                    imgLabel.ImageColor3 = Color3.fromRGB(50, 225, 110) -- Emerald Green
                                elseif nameLabel.Text:find("มองทะลุ") then
                                    imgLabel.ImageColor3 = Color3.fromRGB(0, 210, 255) -- Neon Cyan
                                elseif nameLabel.Text:find("ตั้งค่า") then
                                    imgLabel.ImageColor3 = Color3.fromRGB(0, 160, 255) -- Electric Blue
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

    Tabs.World:Select()
    Fluent:Notify({
        Title = "🌊 KrakenHub Delta iOS Edition!",
        Content = "โหลดระบบฟาร์มและ ESP เวอร์ชั่นรองรับ Delta iOS 100% สำเร็จ!\nแตะปุ่มโลโก้ หรือกด Right Control เพื่อเปิด/ปิดเมนู",
        Duration = 5
    })
end

-- ==============================================================
-- 🧹 10. CLEANUP HANDLER
-- ==============================================================
genv.UrbanReload_Cleanup = function()
    Hub.Running = false

    if Hub.ToggleButtonGui then
        pcall(function() Hub.ToggleButtonGui:Destroy() end)
    end
    if Hub.Window then
        pcall(function() Hub.Window:Unload() end)
    end

    for _, conn in pairs(Hub.Connections) do
        pcall(function() conn:Disconnect() end)
    end

    ClearSafeESP()

    for p in pairs(PlayerESPData) do
        RemovePlayerESP(p)
    end

    for _, item in pairs(HoodESPStorage) do
        if item.Billboard then pcall(function() item.Billboard:Destroy() end) end
        if item.Highlight then pcall(function() item.Highlight:Destroy() end) end
    end
    table.clear(HoodESPStorage)

    if WeaponData and OriginalWeaponData then
        for name, orig in pairs(OriginalWeaponData) do
            local w = WeaponData[name]
            if w and type(w) == "table" then
                pcall(function()
                    if w.Recoil and orig.Recoil then
                        makeWritable(w.Recoil)
                        w.Recoil.Up = orig.Recoil.Up
                        w.Recoil.Side = orig.Recoil.Side
                        w.Recoil.AimScale = orig.Recoil.AimScale
                        w.Recoil.Return = orig.Recoil.Return
                    end
                    if w.Bloom and orig.Bloom then
                        makeWritable(w.Bloom)
                        w.Bloom.Air = orig.Bloom.Air
                        w.Bloom.Move = orig.Bloom.Move
                        w.Bloom.Max = orig.Bloom.Max
                        w.Bloom.Hip = orig.Bloom.Hip
                        w.Bloom.PerShot = orig.Bloom.PerShot
                        w.Bloom.Aim = orig.Bloom.Aim
                    end
                end)
            end
        end
    end
end

-- ==============================================================
-- 🚀 11. INITIALIZE
-- ==============================================================
task.spawn(function()
    pcall(InitUI)
end)

-- 📦 Cases Menu Auto-Optimizer
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
                for _, item in pairs(HoodESPStorage) do
                    if item.Billboard and item.Billboard.Enabled then item.Billboard.Enabled = false end
                    if item.Highlight and item.Highlight.Enabled then item.Highlight.Enabled = false end
                end
            end
        end
        task.wait(0.2)
    end
end)
