-- ==============================================================
-- 🌊 KRAKENHUB | CLEAN UI CHASSIS & WINDOW FRAME
-- หน้าต่าง, ขอบนีออน, ด้ามจับปรับขนาด, จุดเขียวขยายจอ, โลโก้ลอยตัว, และการแสดงผลข้อมูลชื่อ
-- Repository: https://github.com/armongzx56-design/KrakenHub
-- ==============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or nil

local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
local LocalPlayer = Players.LocalPlayer

-- Environment & State Resolution
local genv = (typeof(getgenv) == "function" and getgenv()) or _G
genv._KrakenChassisId = (genv._KrakenChassisId or 0) + 1
local SCRIPT_ID = genv._KrakenChassisId

local Hub = {
    Running = true,
    Connections = {},
    Window = nil,
    ToggleButtonGui = nil,
    Settings = {
        MaskNames = false, -- ตั้งเป็น true ถ้าต้องการปิดบังตัวอักษรบางส่วน (เช่น Kr****68)
        IconTheme = "Themed",
    }
}
genv.KrakenHub = Hub

-- GUI Container resolution (supports gethui / CoreGui / PlayerGui)
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
for _, name in ipairs({"KrakenHub_ToggleButton", "KrakenHub_UI", "Maclib", "Fluent", "KrakenChassis_UI"}) do
    local old = targetGuiParent:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
end

-- ==============================================================
-- 🏷️ 1. LOGO ASSET LOADER (K COMMUNITY LOGO)
-- ==============================================================
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
-- 🎨 2. LOAD MACLIB UI LIBRARY (WITH BORDER & FONT SIZE PATCH)
-- ==============================================================
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

    -- 5. Increase font sizes across MacLib components for mobile readability
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

-- ==============================================================
-- 📐 3. RESPONSIVE WINDOW SIZE CALCULATION
-- ==============================================================
local function GetOptimalWindowSize()
    local vp = (Camera and Camera.ViewportSize) or Vector2.new(1920, 1080)
    if vp.X < 900 or UserInputService.TouchEnabled then
        local w = math.clamp(math.floor(vp.X * 0.88), 340, 720)
        local h = math.clamp(math.floor(vp.Y * 0.82), 260, 480)
        return UDim2.fromOffset(w, h)
    end
    return UDim2.fromOffset(800, 520)
end

-- ==============================================================
-- 🪟 4. CREATE MAIN CHASSIS WINDOW
-- ==============================================================
local Window = MacLib:Window({
    Title = "KrakenHub",
    Subtitle = "UI Chassis & Visuals Frame",
    Size = GetOptimalWindowSize(),
    DragStyle = 2,
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = false,
})
Hub.Window = Window

-- ==============================================================
-- 🌟 5. NEON BORDER, GREEN MAXIMIZE DOT, RESIZE GRIP & USER INFO
-- ==============================================================
local _windowBorderHooked = false

local function MaskString(str)
    if not Hub.Settings.MaskNames then return str end
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

local function ApplyWindowBorder()
    pcall(function()
        local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                  or (CoreGui and CoreGui:FindFirstChild("Base", true))
        if base then
            base.ClipsDescendants = false

            -- 1. 🛡️ กรอบ Overlay นีออนชั้นบนสุด (ZIndex 9999) ลอยครอบหน้าต่างไว้ถาวร
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

            -- 2. 🟢 Restore Green Maximize Dot (จุดสีเขียวมุมซ้ายบน + คลิกขยายเต็มจอ/คืนค่า)
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

            -- 3. 📐 Bottom-Right Corner Resize Grip (ด้ามจับปรับขนาด Cyber Glass มุมขวาล่าง 3 ขีด)
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

            -- 3 Parallel Precision Neon Rungs (45 องศา)
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

            -- 4. 👤 การแสดงผลข้อมูลชื่อผู้ใช้ (UserInfo Display at Bottom Left)
            local function FormatUserInfo(uInfo)
                if not uInfo then return end
                pcall(function()
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
                        disp.TextColor3 = Color3.fromRGB(240, 245, 255)
                    end
                    local user = uInfo:FindFirstChild("Username", true)
                    if user and user:IsA("TextLabel") then
                        user.Text = "@" .. MaskString(LocalPlayer.Name)
                        user.TextColor3 = Color3.fromRGB(130, 140, 160)
                    end
                end)
            end

            local uInfo = base:FindFirstChild("UserInfo", true)
            if uInfo then FormatUserInfo(uInfo) end

            -- 5. สไตล์ SectionUIStroke
            for _, desc in ipairs(base:GetDescendants()) do
                if desc:IsA("UIStroke") and desc.Name == "SectionUIStroke" then
                    desc.Color = Color3.fromRGB(0, 160, 255)
                    desc.Transparency = 0.6
                    desc.Thickness = 1.0
                    desc.Enabled = true
                end
            end

            if not _windowBorderHooked then
                _windowBorderHooked = true
                base.DescendantAdded:Connect(function(desc)
                    if desc.Name == "UserInfo" or (desc.Parent and desc.Parent.Name == "UserInfo") then
                        task.defer(FormatUserInfo, desc.Name == "UserInfo" and desc or desc.Parent)
                    end
                    if desc:IsA("UIStroke") and desc.Name == "SectionUIStroke" then
                        desc.Color = Color3.fromRGB(0, 160, 255)
                        desc.Transparency = 0.6
                        desc.Thickness = 1.0
                    end
                end)
            end
        end
    end)
end
Hub.ApplyBorders = ApplyWindowBorder

-- ==============================================================
-- ✨ 6. SIDEBAR TITLE LIGHT SWEEP (แสงปาดตัวหนังสือ KRAKENHUB)
-- ==============================================================
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

-- ==============================================================
-- 🔘 7. DRAGGABLE FLOATING LOGO BUTTON (WITH ROTATING RGB BORDER)
-- ==============================================================
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

    -- ✨ Looping Light Sweep Sheen on Logo
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

-- ==============================================================
-- 🧩 8. FLUENT ADAPTER & ข้อมูลการแสดงผลชื่อ (USER PROFILE DISPLAY)
-- ==============================================================
local tabGroup = Window:TabGroup()
local Options = {}

local function CreateTabAdapter(rawTab)
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
        AddButton = function(self, cfg)
            return currentSection:Button({
                Name = cfg.Title or cfg.Name or "Button",
                Description = cfg.Description or "",
                Callback = cfg.Callback
            })
        end,
        AddToggle = function(self, flag, cfg)
            local t = currentSection:Toggle({
                Name = cfg.Title or flag,
                Default = cfg.Default or false,
                Callback = cfg.Callback
            }, flag)
            Options[flag] = t
            return t
        end,
        AddSlider = function(self, flag, cfg)
            local s = currentSection:Slider({
                Name = cfg.Title or flag,
                Minimum = cfg.Min or 0,
                Maximum = cfg.Max or 100,
                Default = cfg.Default or cfg.Min or 0,
                Precision = cfg.Rounding or 0,
                Callback = cfg.Callback
            }, flag)
            Options[flag] = s
            return s
        end,
        AddDropdown = function(self, flag, cfg)
            local d = currentSection:Dropdown({
                Name = cfg.Title or flag,
                Options = cfg.Values or {},
                Default = cfg.Default,
                Callback = cfg.Callback
            }, flag)
            Options[flag] = d
            return d
        end
    }
end

-- สร้างแท็บแสดงข้อมูลตัวตนของผู้ใช้ (User Info / Profile Card)
local ProfileTab = CreateTabAdapter(tabGroup:Tab({
    Name = "ข้อมูลผู้ใช้",
    Image = "rbxassetid://10747372702"
}))

ProfileTab:AddSection("ข้อมูลตัวละคร & บัญชี (Identity & Profile)")

ProfileTab:AddParagraph({
    Title = "ชื่อตัวละคร (Display Name)",
    Content = "📌 " .. tostring(LocalPlayer.DisplayName)
})

ProfileTab:AddParagraph({
    Title = "ชื่อผู้ใช้ (Username)",
    Content = "🏷️ @" .. tostring(LocalPlayer.Name)
})

ProfileTab:AddParagraph({
    Title = "รหัสผู้ใช้ (User ID)",
    Content = "🔢 " .. tostring(LocalPlayer.UserId)
})

ProfileTab:AddParagraph({
    Title = "อายุบัญชี (Account Age)",
    Content = "📅 " .. tostring(LocalPlayer.AccountAge) .. " วัน"
})

local execName = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown Executor"
ProfileTab:AddParagraph({
    Title = "โปรแกรมรัน (Executor Engine)",
    Content = "⚡ " .. tostring(execName)
})

ProfileTab:AddSection("การตั้งค่าหน้าต่าง (Window Controller)")

ProfileTab:AddButton({
    Title = "ย่อ / ขยายหน้าต่าง (Toggle Window)",
    Description = "คลิกเพื่อพับเก็บหรือกางหน้าต่างออก (หรือกดปุ่ม Right Control)",
    Callback = function()
        Window:Minimize()
    end
})

ProfileTab:AddButton({
    Title = "ปรับขนาดให้พอดีหน้าจอมือถือ (Fit Mobile)",
    Description = "จัดตำแหน่งกึ่งกลางและปรับขนาดให้พอดีกับหน้าจอมือถือทันที",
    Callback = function()
        local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                  or (CoreGui and CoreGui:FindFirstChild("Base", true))
        if base then
            local vp = (Camera and Camera.ViewportSize) or Vector2.new(1920, 1080)
            local targetW = math.clamp(math.floor(vp.X * 0.88), 340, 680)
            local targetH = math.clamp(math.floor(vp.Y * 0.82), 260, 460)
            TweenService:Create(base, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(targetW, targetH),
                Position = UDim2.fromScale(0.5, 0.5)
            }):Play()
        end
    end
})

-- ==============================================================
-- 🎨 9. VIBRANT TAB ICON COLOR
-- ==============================================================
local function ApplyTabIconColors()
    pcall(function()
        local base = (targetGuiParent and targetGuiParent:FindFirstChild("Base", true))
                  or (CoreGui and CoreGui:FindFirstChild("Base", true))
        if base then
            local sidebar = base:FindFirstChild("Sidebar")
            if sidebar then
                for _, tabSwitcher in ipairs(sidebar:GetDescendants()) do
                    if tabSwitcher.Name == "TabSwitcher" and tabSwitcher:IsA("TextButton") then
                        local imgLabel = tabSwitcher:FindFirstChild("TabImage")
                        if imgLabel then
                            imgLabel.ImageColor3 = Color3.fromRGB(0, 210, 255)
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

ProfileTab:Select()

Window:Notify({
    Title = "🌊 KrakenHub UI Frame",
    Description = "โหลดโครงหน้าต่าง, ขอบนีออน และข้อมูลตัวละครสำเร็จแล้ว!",
    Lifetime = 4
})

-- ==============================================================
-- 🚀 EXPORT CONTROLLER
-- ==============================================================
local UIController = {
    Window = Window,
    ProfileTab = ProfileTab,
    TabGroup = tabGroup,
    CreateTabAdapter = CreateTabAdapter,
    ApplyWindowBorder = ApplyWindowBorder,
    ApplyTitleShimmer = ApplyTitleShimmer,
    ApplyTabIconColors = ApplyTabIconColors,
    Hub = Hub,
}

genv.KrakenHub_UI = UIController
return UIController
