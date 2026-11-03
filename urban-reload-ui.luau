-- ==============================================================
-- 🌊 KRAKENHUB | STANDALONE MODERN MACLIB UI CONTROLLER
-- Urban Reload Edition (Latest Release)
-- Repository: https://github.com/armongzx56-design/KrakenHub
--
-- Features:
-- • 🎨 Patched MacLib Engine (Vibrant Red Active Toggle, Green Maximize Dot, Enhanced Text Sizes)
-- • 🪟 Neon Cyan Window Border Overlay (Persistent ZIndex 9999)
-- • 📐 Cyber Glass Bottom-Right Corner Resize Grip (Touch & Mouse Dragging, 3 Neon Rungs)
-- • 🟢 Restored Green Maximize Dot (Quart Easing Fullscreen & Restore)
-- • 🔘 Draggable Floating RGB Logo Button (Rotating HSV Stroke, Scale Bounce Tween, Boundary Clamping)
-- • 🧩 Fluent Compatibility Adapter Layer (AddSection, AddToggle, AddSlider, AddDropdown, AddButton, AddKeybind, AddInput)
-- • 🌈 Vibrant Tab Icon Theme Engine (Category Colors & Electric Blue)
-- • 🛡️ Safe Execution Mode: Can run standalone in any Roblox game or studio with zero errors
-- ==============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
local LocalPlayer = Players.LocalPlayer

-- Environment & State Resolution
local genv = (typeof(getgenv) == "function" and getgenv()) or _G
genv._KrakenHubUIScriptId = (genv._KrakenHubUIScriptId or 0) + 1
local SCRIPT_ID = genv._KrakenHubUIScriptId

-- Bind to existing Hub or create a clean standalone instance
local Hub = genv.KrakenHub or {
    Running = true,
    CurrentTarget = nil,
    Connections = {},
    ESP = {},
    WorldESP = {},
    SafeESP = {},
    HitboxParts = {},
    Settings = {}
}

-- Default Settings Registry (Complete Urban Reload Configuration)
local DefaultSettings = {
    -- Combat / Silent Aim
    SilentAim = true,
    SilentAimBone = "Head",
    SilentAimFOV = 180,
    SilentAimMaxDist = 400,
    SilentAimHitChance = 100,
    SilentAimWallCheck = true,
    SilentAimIgnoreSafeZone = true,
    SilentAimIgnoreShield = true,
    SilentAimIgnoreDowned = true,
    SilentAimPriority = "Crosshair",
    SilentAimTargetHood = true,
    SilentAimTargetZombies = true,
    SilentAimDrawFOV = false,
    SilentAimFOVColor = Color3.fromRGB(255, 140, 0),
    SilentAimFOVRainbow = false,
    SilentAimFOVR = 255,
    SilentAimFOVG = 140,
    SilentAimFOVB = 0,
    RedDamageNumbers = true,
    IconTheme = "Themed",

    -- FOV Circle Styles
    FOVCircleThickness = 1.5,
    FOVCircleTransparency = 0.85,
    FOVCircleFilled = false,

    -- Hitbox Expander
    HitboxExpander = true,
    HitboxSize = 14,
    HitboxTarget = "Head",
    HitboxVisible = false,
    HitboxTransparency = 0.65,

    -- Auto Respawn
    AutoRespawn = true,
    RespawnKey = Enum.KeyCode.X,

    -- Weapon Mods
    NoRecoil = true,
    NoSpread = true,
    RapidFire = false,
    RapidFireRPM = 1100,
    FullAuto = true,
    InstantReload = false,
    FastReloadRatio = 0.35,

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

    -- Character
    HideCharacterName = false,

    -- World ESP
    SafeESP = true,
    LootESP = true,
    HalloweenESP = true,
    ATMESP = false,

    -- Hood NPC Auto Aim & Kill Aura
    HoodKillAura = false,
    HoodKillAuraRange = 250,
    HoodWallCheck = true,
    HoodESP = true,
    ZombieKillAura = false,
    ZombieKillAuraRange = 250,
    ZombieWallCheck = true,
    ZombieESP = true,
}

for k, v in pairs(DefaultSettings) do
    if Hub.Settings[k] == nil then
        Hub.Settings[k] = v
    end
end
genv.KrakenHub = Hub

-- Safe Fallbacks for Optional Game Dependencies & Modules
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local Controls = nil
pcall(function() Controls = require(ReplicatedStorage:WaitForChild("Controls", 1)) end)
local ClientState = nil
pcall(function() ClientState = require(ReplicatedStorage:WaitForChild("Weapons", 1):WaitForChild("ClientState", 1)) end)

-- Optional Callbacks (Can be overridden by external cheats/backends)
local ApplyWeaponMods = Hub.ApplyWeaponMods or function(...) end
local UpdateSafeESP = Hub.UpdateSafeESP or function(...) end
local SetHideCharacterName = Hub.SetHideCharacterName or function(enable) Hub.Settings.HideCharacterName = enable end
local EnsureWeaponEquipped = Hub.EnsureWeaponEquipped or function(...) return nil end

-- Optional FOV Drawing Circle
local SilentFOVCircle = Hub.SilentFOVCircle
if not SilentFOVCircle and typeof(Drawing) == "table" and typeof(Drawing.new) == "function" then
    pcall(function()
        SilentFOVCircle = Drawing.new("Circle")
        SilentFOVCircle.Visible = false
        SilentFOVCircle.Radius = Hub.Settings.SilentAimFOV or 180
        SilentFOVCircle.Color = Hub.Settings.SilentAimFOVColor or Color3.fromRGB(255, 140, 0)
        SilentFOVCircle.Thickness = Hub.Settings.FOVCircleThickness or 1.5
        SilentFOVCircle.Filled = false
        SilentFOVCircle.Transparency = Hub.Settings.FOVCircleTransparency or 0.85
        Hub.SilentFOVCircle = SilentFOVCircle
    end)
end

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

    -- 🎨 2. LOAD MACLIB UI LIBRARY (WITH RED ACTIVE TOGGLE, GREEN DOT & FONT SIZE PATCH)
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
    -- ⚔️ COMBAT TAB (หมวดต่อสู้ - ระบบกระสุนเลี้ยว & ม็อดปืน)
    -- ================================================
    Tabs.Combat:AddSection("ระบบกระสุนเลี้ยว (Silent Aim Engine)")

    local HeadLock100Toggle = Tabs.Combat:AddToggle("HeadLock100Toggle", {
        Title = "ล็อคหัว 100% & ปืนเทพ (Silent Head Lock 100%)",
        Description = "กระสุนเลี้ยวเข้าหัวทุกนัด 100% (ไร้แรงดีด + ปืนไม่ส่าย + ยิงออโต้ + ขยายหัว 14 studs)",
        Default = true
    })
    HeadLock100Toggle:OnChanged(function(v)
        if v then
            Hub.Settings.SilentAim = true
            Hub.Settings.SilentAimBone = "Head"
            Hub.Settings.SilentAimHitChance = 100
            Hub.Settings.NoRecoil = true
            Hub.Settings.NoSpread = true
            Hub.Settings.FullAuto = true
            Hub.Settings.HitboxExpander = true
            Hub.Settings.HitboxTarget = "Head"
            Hub.Settings.HitboxSize = 14
            ApplyWeaponMods()
            if Options.SilentAimToggle then Options.SilentAimToggle:SetValue(true) end
            if Options.SilentBoneDrop then Options.SilentBoneDrop:SetValue("ส่วนหัว (Head - แนะนำ)") end
            if Options.SilentHitChanceSlider then Options.SilentHitChanceSlider:SetValue(100) end
            if Options.NoRecoilToggle then Options.NoRecoilToggle:SetValue(true) end
            if Options.NoSpreadToggle then Options.NoSpreadToggle:SetValue(true) end
            if Options.FullAutoToggle then Options.FullAutoToggle:SetValue(true) end
            if Options.HitboxToggle then Options.HitboxToggle:SetValue(true) end
            if Options.HitboxTargetDrop then Options.HitboxTargetDrop:SetValue("ส่วนหัว (Head - แนะนำ)") end
            if Options.HitboxSizeSlider then Options.HitboxSizeSlider:SetValue(14) end
        end
    end)

    local SilentAimToggle = Tabs.Combat:AddToggle("SilentAimToggle", {
        Title = "เปิดใช้งานกระสุนเลี้ยว (Silent Aim)",
        Description = "กระสุนเลี้ยวเข้าเป้าหมายอัตโนมัติ โดยที่มุมกล้องไม่ขยับอิสระ 100%",
        Default = Hub.Settings.SilentAim
    })
    SilentAimToggle:OnChanged(function(v)
        Hub.Settings.SilentAim = v
    end)

    local SilentBoneDrop = Tabs.Combat:AddDropdown("SilentBoneDrop", {
        Title = "ตำแหน่งกระสุนเข้า (Target Bone)",
        Description = "เลือกชิ้นส่วนร่างกายที่ต้องการให้กระสุนเลี้ยวพุ่งเข้าชน",
        Values = {"ส่วนหัว (Head - แนะนำ)", "ลำตัวส่วนบน (UpperTorso)", "สุ่มตำแหน่ง (Random)"},
        Default = "ส่วนหัว (Head - แนะนำ)"
    })
    SilentBoneDrop:OnChanged(function(v)
        if v:find("ส่วนหัว") or v:find("Head") then
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
    -- 🌾 FARM & WORLD TAB (หมวดฟาร์ม & โลก)
    -- ================================================
    Tabs.World:AddSection("⚔️ เล็งและยิงบอท Hood อัตโนมัติ (Auto Aim & Shoot Hood NPCs)")

    local HoodKillAuraToggle = Tabs.World:AddToggle("HoodKillAuraToggle", {
        Title = "เริ่มเล็งและยิงบอท Hood อัตโนมัติ (Auto Aim & Shoot Hood NPCs)",
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
    return {
        Window = Window,
        Tabs = Tabs,
        Fluent = Fluent,
        Options = Options,
        Hub = Hub,
        ApplyWindowBorder = ApplyWindowBorder,
        ApplyTabIconColors = ApplyTabIconColors,
    }
end

-- ==============================================================
-- 🚀 INITIALIZE & EXPORT UI
-- ==============================================================
local UIController = nil
local success, result = pcall(InitUI)
if success and result then
    UIController = result
    genv.KrakenHub_UI = UIController
else
    warn("[KrakenHub UI] Initialization error: " .. tostring(result))
end

return UIController
