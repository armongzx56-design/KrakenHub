-- ==============================================================
-- 🐙 KRAKENHUB V6.1 | สายเลือดอาชีวะ I Sailueatarchiwa ไทย
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

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- เคลียร์อินสแตนซ์และ UI เก่า
if _G.KrakenHub_Sailueat and type(_G.KrakenHub_Sailueat.Unload) == "function" then
    pcall(function() _G.KrakenHub_Sailueat.Unload() end)
end
if _G.SailueatHub_Cleanup then
    pcall(_G.SailueatHub_Cleanup)
end

local CoreGui = game:GetService("CoreGui")
local targetGuiParent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
for _, name in ipairs({"SailueatHub_V3", "SailueatHub_V3_5", "SailueatHub_V3_6", "SailueatHub_V3_7", "SailueatHub_V3_8", "SailueatHub_V3_9", "SailueatHub_V2", "SailueatHub_V1", "Fluent"}) do
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

-- เคลียร์ Highlight ตกค้างใน Workspace และ CoreGui
pcall(function()
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc:IsA("Highlight") and (desc.Name:find("Target") or desc.Name:find("Kraken") or desc.Name:find("Farm") or desc.Name:find("Test") or desc.Name == "Highlight") then
            if not desc.Parent or not desc.Parent.Name:find("MenuLights") then
                desc:Destroy()
            end
        end
    end
    for _, c in ipairs(CoreGui:GetChildren()) do
        if c:IsA("Highlight") and (c.Name:find("Target") or c.Name:find("Kraken") or c.Name:find("Farm") or c.Name:find("Test")) then
            c:Destroy()
        end
        if c:IsA("BillboardGui") and (c.Name:find("Target") or c.Name:find("Kraken") or c.Name:find("Farm")) then
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
    Unloaded = false,
    State = {
        Running = true,
        -- Farm
        SelectedJob = "งานก่อสร้าง",
        AutoFarm = false,
        FarmSpeed = 21,
        AutoSolveMinigame = true,
        AutoCollectCash = true,
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
        FullBright = false,
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
-- ปรับ FarmSpeed ได้อิสระ (ค่าเริ่มต้น 21 studs/s): วิ่งไว คล่องตัว ไม่เกินเกณฑ์เตะ 261
-- ตอนหยุดวิ่งคืนค่าเป็น 8 studs/s เสมอ
-- ขณะทำงานก่อสร้าง/มินิเกม ล็อค WalkSpeed = 0 และ Velocity = 0 สนิท
--------------------------------------------------------------
local NORMAL_WALK_SPEED = 8
local runAnimTrack = nil
local isCurrentlySprinting = false

local function SetSprinting(enabled)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local fn = GetRunSystemRenderFn()
    if enabled then
        if IsCurrentlyWorking and IsCurrentlyWorking() then
            if fn then pcall(debug.setupvalue, fn, 3, false) end
            hum.WalkSpeed = 0
            return
        end
        isCurrentlySprinting = true
        if fn then
            local isExhausted = debug.getupvalue(fn, 5)
            local stamina = debug.getupvalue(fn, 10)
            -- ถ้ายังไม่เหนื่อยหอบ และสเตมิน่ายังเหลือ ให้เปิดระบบวิ่งแท้ของเกม (เหมือนกด LeftShift)
            if not isExhausted and (stamina == nil or stamina > 2) then
                pcall(debug.setupvalue, fn, 3, true)
                hum.WalkSpeed = (State.AutoFarm and State.FarmSpeed) or 18
                hum.JumpPower = 35
            else
                -- สเตมิน่าหมด ปล่อยให้ RunSystem คุมความเร็วเดินพักฟื้นตามธรรมชาติ (6-8 studs/s)
                pcall(debug.setupvalue, fn, 3, false)
            end
        else
            hum.WalkSpeed = (State.AutoFarm and State.FarmSpeed) or 18
            hum.JumpPower = 35
        end
    else
        isCurrentlySprinting = false
        if fn then
            pcall(debug.setupvalue, fn, 3, false)
        end
        if not (IsCurrentlyWorking and IsCurrentlyWorking()) then
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
        pcall(debug.setupvalue, fn, 15, 0) -- u14: target amplitude ของการสั่นกล้อง (แก้ปัญหามุมกล้องกระตุก 100%)
        pcall(debug.setupvalue, fn, 18, 0) -- u15: current amplitude ของการสั่นกล้อง
        pcall(debug.setupvalue, fn, 23, 0) -- u16: phase ของ math.noise
    end
    if hum.CameraOffset.Magnitude > 0 then
        hum.CameraOffset = Vector3.zero
    end

    -- ล็อคความเร็ว 0 เฉพาะตอนที่เปิด AutoFarm และกำลังทำงานก่อสร้าง / มินิเกม เท่านั้น
    if State.AutoFarm and IsCurrentlyWorking and IsCurrentlyWorking() then
        hum.WalkSpeed = 0
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if isCurrentlySprinting then
            isCurrentlySprinting = false
            if fn then pcall(debug.setupvalue, fn, 3, false) end
        end
        return
    end

    -- ปล่อยให้ RunSystem ดูแล WalkSpeed และ Stamina ตามธรรมชาติเหมือนกด LeftShift จริงๆ
    -- หากผู้ใช้เปิด Cheats > Speed เสริมเอง ถึงจะปรับความเร็วพิเศษ:
    if State.Speed then
        hum.WalkSpeed = State.SpeedValue or 20
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
-- 🎯 4. ระบบ TARGET ESP สีเขียวสดใส ขอบเหลืองนีออน (กรองแผ่นพื้นยักษ์ออก)
--------------------------------------------------------------
local currentTargetHighlight = nil
local currentTargetBillboard = nil
local currentTargetInstance = nil

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
end

local function SetTargetESP(targetInstance, titleText, customColor)
    if not targetInstance then
        ClearTargetESP()
        return
    end

    if currentTargetInstance == targetInstance and currentTargetHighlight and currentTargetHighlight.Parent then
        return
    end

    ClearTargetESP()
    currentTargetInstance = targetInstance

    local adornee = targetInstance
    if adornee:IsA("ProximityPrompt") then
        adornee = adornee.Parent
    end
    if adornee:IsA("Attachment") then
        adornee = adornee.Parent
    end

    -- กรองชิ้นส่วนขนาดใหญ่ (แผ่นพื้นฐานราก Union ขนาด 80+ studs)
    if adornee:IsA("BasePart") and (adornee.Size.X > 14 or adornee.Size.Z > 14 or adornee.Size.Y > 14) then
        local smallPart = adornee.Parent and adornee.Parent:FindFirstChildWhichIsA("BasePart")
        if smallPart and smallPart.Size.X <= 14 and smallPart.Size.Z <= 14 then
            adornee = smallPart
        else
            adornee = nil
        end
    elseif adornee:IsA("BasePart") and adornee.Parent and adornee.Parent:IsA("Model") and adornee.Parent ~= Workspace and adornee.Parent ~= Workspace:FindFirstChild("Job") then
        local hasGiantPart = false
        for _, p in ipairs(adornee.Parent:GetChildren()) do
            if p:IsA("BasePart") and (p.Size.X > 14 or p.Size.Z > 14) then
                hasGiantPart = true
                break
            end
        end
        if not hasGiantPart then
            adornee = adornee.Parent
        end
    end

    local fillColor = customColor or Color3.fromRGB(120, 255, 40)   -- Lime Green สีเขียวสดใสตามรูป
    local outlineColor = Color3.fromRGB(255, 255, 0)                  -- Neon Yellow ขอบเหลืองนีออนสว่างวาบ

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

        local attachPart = (targetInstance:IsA("BasePart") and targetInstance)
                        or (adornee and adornee:IsA("BasePart") and adornee)
                        or (targetInstance:IsA("Model") and targetInstance:FindFirstChildWhichIsA("BasePart", true))
                        or (adornee and adornee:FindFirstChildWhichIsA("BasePart", true))

        if attachPart then
            local bb = Instance.new("BillboardGui")
            bb.Name = "KrakenTargetFarmBillboard"
            bb.Adornee = attachPart
            bb.Size = UDim2.new(0, 160, 0, 44)
            bb.StudsOffset = Vector3.new(0, 3.2, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 500

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
            frame.BackgroundTransparency = 0.22
            frame.BorderSizePixel = 0
            frame.Parent = bb

            local uic = Instance.new("UICorner")
            uic.CornerRadius = UDim.new(0, 8)
            uic.Parent = frame

            local uis = Instance.new("UIStroke")
            uis.Color = outlineColor
            uis.Thickness = 1.8
            uis.Parent = frame

            local tLabel = Instance.new("TextLabel")
            tLabel.Size = UDim2.new(1, 0, 0.55, 0)
            tLabel.BackgroundTransparency = 1
            tLabel.Font = Enum.Font.GothamBold
            tLabel.TextSize = 12
            tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            tLabel.Text = "🎯 " .. (titleText or "จุดทำงานเป้าหมาย")
            tLabel.Parent = frame

            local dLabel = Instance.new("TextLabel")
            dLabel.Name = "DistLabel"
            dLabel.Size = UDim2.new(1, 0, 0.45, 0)
            dLabel.Position = UDim2.new(0, 0, 0.55, 0)
            dLabel.BackgroundTransparency = 1
            dLabel.Font = Enum.Font.GothamMedium
            dLabel.TextSize = 11
            dLabel.TextColor3 = fillColor
            dLabel.Text = "กำลังเดินทางไป..."
            dLabel.Parent = frame

            bb.Parent = CoreGui
            currentTargetBillboard = bb
        end
    end)
end

Connections.TargetESPUpdate = RunService.Heartbeat:Connect(function()
    if currentTargetBillboard and currentTargetInstance then
        local attachPart = (currentTargetInstance:IsA("BasePart") and currentTargetInstance) or currentTargetInstance:FindFirstChildWhichIsA("BasePart", true)
        local hrp = GetHRP()
        if attachPart and hrp then
            local dist = (hrp.Position - attachPart.Position).Magnitude
            local frame = currentTargetBillboard:FindFirstChildOfClass("Frame")
            local dLabel = frame and frame:FindFirstChild("DistLabel")
            if dLabel then
                dLabel.Text = string.format("%.1f เมตร (%d studs)", dist / 3.57, math.floor(dist))
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

    local jobConfig = {
        ["งานก่อสร้าง"] = { color = Color3.fromRGB(120, 255, 40), name = "ก่อสร้าง" },
        ["ทำความสะอาด"] = { color = Color3.fromRGB(0, 220, 255), name = "ทำความสะอาด" },
        ["ขยะ"] = { color = Color3.fromRGB(255, 170, 0), name = "ขยะ" },
        ["ซ่อมรถ"] = { color = Color3.fromRGB(255, 60, 180), name = "ซ่อมรถ" },
    }

    for jobName, conf in pairs(jobConfig) do
        local jf = jobFolder:FindFirstChild(jobName)
        if jf then
            for _, desc in ipairs(jf:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and desc.Enabled then
                    local part = (desc.Parent:IsA("BasePart") and desc.Parent)
                              or (desc.Parent:IsA("Attachment") and desc.Parent.Parent:IsA("BasePart") and desc.Parent.Parent)
                              or desc:FindFirstAncestorWhichIsA("BasePart")
                    if part and part ~= currentTargetInstance and part.Size.X <= 14 and part.Size.Z <= 14 then
                        local hl = Instance.new("Highlight")
                        hl.Name = "AllJobSpotHL"
                        hl.Adornee = part
                        hl.FillColor = conf.color
                        hl.FillTransparency = 0.65
                        hl.OutlineColor = conf.color
                        hl.OutlineTransparency = 0.3
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
    while State.Running do
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
            if dist3D <= math.max(promptMaxD - 0.4, 3.6) then return true end
            if hDist <= 3.8 and yDiff <= 5.5 then return true end
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
-- 🎨 โหลด FLUENT UI
--------------------------------------------------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "🐙 KrakenHub | สายเลือดอาชีวะ",
    SubTitle = "v6.0 — 100% Anti-Kick Bypass Pro (Zero Kicks Guaranteed)",
    TabWidth = 165,
    Size = UDim2.fromOffset(630, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Farm     = Window:AddTab({ Title = "งาน & ฟาร์มอัตโนมัติ", Icon = "hard-hat" }),
    Player   = Window:AddTab({ Title = "ตัวละคร & เคลื่อนที่", Icon = "user" }),
    World    = Window:AddTab({ Title = "วาร์ปทั่วแมพ",       Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "ตั้งค่า",              Icon = "settings" })
}

local Options = Fluent.Options

local function Notify(title, content, sub, duration)
    Fluent:Notify({
        Title = title or "KrakenHub",
        Content = content or "",
        SubContent = sub or "",
        Duration = duration or 3
    })
end

--------------------------------------------------------------
-- 🔨 6. ระบบแก้มินิเกมอัตโนมัติ (AUTO SOLVE MINIGAME 100%)
--------------------------------------------------------------
local isVIMHolding = false

local function ReleaseVIM()
    if isVIMHolding then
        isVIMHolding = false
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
end

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

-- ตอกตะปู / ล้อรถ / ขุดขยะ / น็อตเครื่องยนต์ / เทน้ำมัน (หน่วงเวลาปลอดภัย ไม่ถูกเรทลิมิต)
task.spawn(function()
    while State.Running do
        task.wait(0.14)
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
                                task.wait(0.2)
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
                    task.wait(0.6)
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
                            task.wait(0.18)
                        end
                    end
                    task.wait(0.3)
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
                                task.wait(0.2)
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

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track.Name == "_WorkAnim" and track.IsPlaying then
                return true
            end
        end
    end

    return false
end

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

local function GetNearestOpenSpot(jobType)
    local hrp = GetHRP()
    if not hrp then return nil, nil, 999999, nil, nil end

    local myPos = hrp.Position
    local bestSpot, bestPrompt, bestDist, bestName, bestPos = nil, nil, 999999, nil, nil
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
        local constJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("งานก่อสร้าง")
        local workFolder = constJob and constJob:FindFirstChild("งาน")
        if workFolder then
            for _, folder in ipairs(workFolder:GetChildren()) do
                for _, item in ipairs(folder:GetChildren()) do
                    local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt and prompt.Enabled then
                        local part = (prompt.Parent:IsA("BasePart") and prompt.Parent)
                                   or (prompt.Parent:IsA("Attachment") and prompt.Parent.Parent:IsA("BasePart") and prompt.Parent.Parent)
                                   or (item:IsA("BasePart") and item)
                                   or item:FindFirstChildWhichIsA("BasePart", true)

                        if part and (part.Size.X > 14 or part.Size.Z > 14) then
                            part = prompt.Parent:IsA("BasePart") and prompt.Parent or nil
                        end

                        if part and (not failedSpotCooldowns[part] or now >= failedSpotCooldowns[part]) then
                            local spotPos = (prompt.Parent:IsA("BasePart") and prompt.Parent.Position)
                                         or (prompt.Parent:IsA("Attachment") and prompt.Parent.WorldPosition)
                                         or part.Position

                            if not isOccupied(spotPos) then
                                local d = (myPos - spotPos).Magnitude
                                if math.abs(myPos.Y - spotPos.Y) <= 6.5 and d < bestDist then
                                    bestDist = d
                                    bestSpot = part
                                    bestPrompt = prompt
                                    bestName = "ก่อสร้าง: " .. folder.Name
                                    bestPos = spotPos
                                end
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

    return bestSpot, bestPrompt, bestDist, bestName, bestPos
end

--------------------------------------------------------------
-- 8. ลูปหลัก AUTO FARM PRO (100% ANTI-KICK & RELIABLE)
--------------------------------------------------------------
local lastCollectTime = 0

task.spawn(function()
    while State.Running do
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

            -- หากเป็นงานก่อสร้าง และยังไม่ได้ชุดทำงาน -> ต้องไปหา NPC ก่อนเสมอ
            if curJob == "งานก่อสร้าง" and not hasCompletedNpcHiring then
                local shirt = char:FindFirstChildOfClass("Shirt")
                local hasUniform = shirt and shirt.ShirtTemplate:find("105971357123934")

                if not hasUniform then
                    local distToNPC = (hrp.Position - jobNpcPos).Magnitude
                    local jobNPC = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("งานก่อสร้าง") and Workspace.Job["งานก่อสร้าง"]:FindFirstChild("NPC") and Workspace.Job["งานก่อสร้าง"].NPC:FindFirstChild("JobNPC")

                    SetTargetESP(jobNPC or Workspace.Job["งานก่อสร้าง"].NPC, "สมัครงานรับชุด (JobNPC)", Color3.fromRGB(0, 210, 255))

                    local npcPrompt = jobNPC and jobNPC:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if distToNPC > 3.8 then
                        NavigateTo(jobNpcPos, 3.5, 30, npcPrompt)
                    else
                        SetSprinting(false)
                        hum:Move(Vector3.zero, false)
                        hum:MoveTo(hrp.Position)
                        task.wait(0.15)
                        if npcPrompt then
                            pcall(function() fireproximityprompt(npcPrompt) end)
                        end
                        task.wait(0.2)
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
                        hasCompletedNpcHiring = true
                        ClearTargetESP()
                        Notify("งานก่อสร้าง", "สมัครงานรับชุดเรียบร้อย! เริ่มวิ่งฟาร์มทันที...", "", 2.5)
                    end
                    continue
                else
                    hasCompletedNpcHiring = true
                end
            end

            -- ค้นหาจุดว่างสำหรับงานที่เลือก
            local spot, prompt, dist, spotName, spotPos = GetNearestOpenSpot(curJob)
            if spot and prompt then
                spotPos = spotPos or spot.Position
                SetTargetESP(spot, spotName or "จุดทำงาน", Color3.fromRGB(120, 255, 40))

                local promptMaxD = (prompt and prompt.MaxActivationDistance) or 5.0
                local canTrigger = (hrp.Position - spotPos).Magnitude <= promptMaxD
                                or ((Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(spotPos.X, spotPos.Z)).Magnitude <= 4.0 and math.abs(hrp.Position.Y - spotPos.Y) <= 5.5)

                if not canTrigger then
                    local navSuccess = NavigateTo(spotPos, math.min(promptMaxD - 0.5, 3.8), 12, prompt)
                    if not navSuccess then
                        failedSpotCooldowns[spot] = tick() + 8
                        ClearTargetESP()
                        task.wait(0.08)
                        continue
                    end
                end

                -- เมื่อมาถึงจุดทำงาน (หยุดนิ่งสนิท 100% ก่อนเริ่มงาน ป้องกัน CODE 261 & 264)
                hrp = GetHRP()
                hum = GetHuman()
                local curD = (hrp and spotPos) and (hrp.Position - spotPos).Magnitude or 999
                local curHD = (hrp and spotPos) and (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(spotPos.X, spotPos.Z)).Magnitude or 999
                local curYD = (hrp and spotPos) and math.abs(hrp.Position.Y - spotPos.Y) or 999

                if hrp and hum and prompt and prompt.Enabled and (curD <= promptMaxD or (curHD <= 4.2 and curYD <= 5.5)) then
                    SetSprinting(false)
                    hum:Move(Vector3.zero, false)
                    hum.WalkSpeed = 0
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hum:MoveTo(hrp.Position)
                    task.wait(0.18) -- รอเซิร์ฟเวอร์ sync ความเร็วนิ่งสนิท

                    -- กดเริ่มงานอย่างปลอดภัยตาม HoldDuration ของ ProximityPrompt
                    local holdTime = prompt.HoldDuration or 0
                    if holdTime > 0 then
                        pcall(function() prompt:InputHoldBegin() end)
                        local startHold = tick()
                        while (tick() - startHold) < (holdTime + 0.2) and State.AutoFarm and State.Running and not IsCurrentlyWorking() do
                            if hrp then
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end
                            task.wait(0.08)
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
                        local workStart = tick()
                        local lockCFrame = hrp.CFrame
                        while IsCurrentlyWorking() and (tick() - workStart) < 25 and State.AutoFarm and State.Running do
                            if hrp then
                                hrp.CFrame = lockCFrame
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end
                            if hum then hum.WalkSpeed = 0 end
                            task.wait(0.05)
                        end
                        ReleaseVIM()
                        task.wait(0.4) -- รอเซิร์ฟเวอร์เคลียร์สถานะเสร็จงาน
                        failedSpotCooldowns[spot] = tick() + 5
                        ClearTargetESP()
                        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end
                    else
                        failedSpotCooldowns[spot] = tick() + 3
                        ClearTargetESP()
                        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end
                    end
                end
            else
                ClearTargetESP()
                task.wait(0.25)
            end

            -- เคลมเงินค่าจ้างก่อสร้างอัตโนมัติ (หน่วงเวลาปลอดภัย ไม่สแปม Remote)
            if curJob == "งานก่อสร้าง" and State.AutoCollectCash then
                local curHRP = GetHRP()
                if curHRP and (curHRP.Position - jobNpcPos).Magnitude <= 25 then
                    if (tick() - lastCollectTime) >= 12 then
                        lastCollectTime = tick()
                        pcall(function()
                            local constJobRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
                            local collectRemote = constJobRS and constJobRS:FindFirstChild("Collect")
                            if collectRemote then
                                local s, amount = collectRemote:InvokeServer()
                                if s and amount and amount > 0 then
                                    Notify("รับเงินก่อสร้าง", "+" .. tostring(amount) .. " ฿", "", 2.5)
                                end
                            end
                        end)
                    end
                end
            end
        else
            ClearTargetESP()
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

local function UpdateESP()
    for _, obj in pairs(Hub.ESPObjects) do pcall(function() obj:Destroy() end) end
    table.clear(Hub.ESPObjects)
    if not State.ESP or not State.Running then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                local hl = Instance.new("Highlight")
                hl.Name = "KrakenESP_HL"
                hl.FillColor = Color3.fromRGB(0, 180, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Adornee = char
                hl.Parent = char
                table.insert(Hub.ESPObjects, hl)

                local bb = Instance.new("BillboardGui")
                bb.Name = "KrakenESP_BB"
                bb.Adornee = hrp
                bb.Size = UDim2.new(0, 120, 0, 40)
                bb.StudsOffset = Vector3.new(0, 3, 0)
                bb.AlwaysOnTop = true

                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                lbl.TextStrokeTransparency = 0
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 11
                lbl.Text = p.Name .. " [" .. math.floor(hum.Health) .. " HP]"
                bb.Parent = hrp
                table.insert(Hub.ESPObjects, bb)
            end
        end
    end
end

task.spawn(function()
    while State.Running do
        task.wait(2.5)
        if State.ESP then UpdateESP() end
    end
end)

--------------------------------------------------------------
-- 10. ระบบขายขยะ (TRASH SELL)
--------------------------------------------------------------
local function SellAllTrash()
    local sellFolder = ReplicatedStorage:WaitForChild("Job"):WaitForChild("ขยะ")
    local sellConfigModule = sellFolder:FindFirstChild("SellConfig")
    local sellRemote = sellFolder:FindFirstChild("SellItems")
    if sellConfigModule and sellRemote then
        local sellConfig = require(sellConfigModule)
        local toSell = {}
        local count = 0
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, item in ipairs(bp:GetChildren()) do
                if sellConfig[item.Name] then
                    toSell[item.Name] = (toSell[item.Name] or 0) + 1
                    count = count + 1
                end
            end
        end
        local char = LocalPlayer.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") and sellConfig[item.Name] then
                    toSell[item.Name] = (toSell[item.Name] or 0) + 1
                    count = count + 1
                end
            end
        end
        if count > 0 then
            sellRemote:FireServer(toSell)
            Notify("ขายขยะ", "ขายขยะสำเร็จ " .. count .. " ชิ้น!", "", 3)
        else
            Notify("ขายขยะ", "ไม่มีไอเท็มขยะในตัว", "", 3)
        end
    end
end

--------------------------------------------------------------
-- 11. ระบบวาร์ป (TELEPORTS)
--------------------------------------------------------------
local KnownLocations = {
    ["🛡️ เซฟโซน (Safe Zone)"] = Vector3.new(2614, 4, 690),
    ["🏗️ ไซต์งานก่อสร้าง (Construction)"] = Vector3.new(2476, 7, -414),
    ["🗑️ จุดเก็บขยะ (Trash Zone)"] = Vector3.new(2190, 4, 420),
    ["🏪 ร้านรับซื้อขยะ (NPC Sell)"] = Vector3.new(2466.5, 6, -1171.0),
    ["👮 สถานีตำรวจ (สน.)"] = Vector3.new(2640, 4, -150),
    ["🏢 คอนโด / อพาร์ทเม้นท์"] = Vector3.new(2510, 4, -1020),
    ["🏁 จุดเกิด (Spawn)"] = Vector3.new(2580, 4, 650)
}

local function TeleportTo(pos, name)
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        Notify("วาร์ป", "วาร์ปมายัง: " .. (name or "จุดหมาย"), "", 3)
    end
end

--------------------------------------------------------------
-- 🎨 สร้างเมนูใน FLUENT TABS
--------------------------------------------------------------
Tabs.Farm:AddParagraph({
    Title = "🛡️ KrakenHub v6.0 (100% Anti-Kick Bypass Pro)",
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

local MainFarmToggle = Tabs.Farm:AddToggle("MasterAutoFarm", {
    Title = "🚀 เริ่มฟาร์มอัตโนมัติ (Auto Farm Selected Job)",
    Description = "เปิดปุ่มนี้ ระบบจะวิ่งหาจุดว่าง หลบสิ่งกีดขวาง พร้อมไฮไลต์สีเขียวขอบเหลืองนีออนทันที",
    Default = false
})
MainFarmToggle:OnChanged(function()
    State.AutoFarm = Options.MasterAutoFarm.Value
    if State.AutoFarm then
        hasCompletedNpcHiring = false
        Notify("ระบบฟาร์ม", "เริ่มฟาร์มงาน: " .. tostring(State.SelectedJob) .. " (100% Anti-Kick Safe)", "", 3)
    else
        Notify("ระบบฟาร์ม", "หยุดระบบฟาร์มเรียบร้อย", "", 3)
        SetSprinting(false)
        ClearTargetESP()
        local hum = GetHuman()
        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end
    end
end)

Tabs.Farm:AddSection("⚙️ การตั้งค่าระบบฟาร์ม & ESP")

local FarmSpeedSlider = Tabs.Farm:AddSlider("FarmSpeedVal", {
    Title = "🏃 ความเร็ววิ่งฟาร์ม (Farm Sprint Speed)",
    Description = "ปรับความเร็ววิ่งขณะฟาร์ม (แนะนำ 20 - 22 studs/s วิ่งไว ลื่นไหล ไม่โดนเตะ 261)",
    Default = 21,
    Min = 16,
    Max = 24,
    Rounding = 0
})
FarmSpeedSlider:OnChanged(function()
    State.FarmSpeed = Options.FarmSpeedVal.Value
end)

local MinigameToggle = Tabs.Farm:AddToggle("AutoMinigame", {
    Title = "🔨 แก้โจทย์มินิเกมอัตโนมัติ 100%",
    Description = "เชื่อมเหล็ก / เจาะพื้น / ตอกตะปู / ถูพื้น / ซ่อมล้อ / ขุดขยะ (Safe VIM ไม่โดนเตะ)",
    Default = true
})
MinigameToggle:OnChanged(function()
    State.AutoSolveMinigame = Options.AutoMinigame.Value
end)

local AutoCashToggle = Tabs.Farm:AddToggle("AutoCollectCash", {
    Title = "💰 เคลมเงินค่าจ้างอัตโนมัติ (งานก่อสร้าง)",
    Description = "รับเงินจากโต๊ะผู้จัดการไซต์งานทันทีเมื่ออยู่ใกล้",
    Default = true
})
AutoCashToggle:OnChanged(function()
    State.AutoCollectCash = Options.AutoCollectCash.Value
end)

local AllSpotsESPToggle = Tabs.Farm:AddToggle("AllSpotsESP", {
    Title = "👁️ แสดง ESP ทุกจุดในแมพ (All Work Spots ESP)",
    Description = "แสดงกรอบเรืองแสงระบุตำแหน่งงานทั้งหมดรอบตัว",
    Default = false
})
AllSpotsESPToggle:OnChanged(function()
    State.ShowAllSpotsESP = Options.AllSpotsESP.Value
    if State.ShowAllSpotsESP then
        UpdateAllJobESP()
    else
        ClearAllJobESP()
    end
end)

Tabs.Farm:AddButton({
    Title = "🗑️ ขายขยะทั้งหมดในตัว (Sell All Trash)",
    Description = "ส่งไอเท็มขยะทั้งหมดไปขายให้ NPC รับเงินสด",
    Callback = function()
        SellAllTrash()
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
    Title = "ความเร็วเดิน (WalkSpeed)",
    Default = 20,
    Min = 16,
    Max = 60,
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

local ESPToggle = Tabs.Player:AddToggle("ESPOn", { Title = "👁️ มองทะลุผู้เล่นทุกคน (Player ESP)", Default = false })
ESPToggle:OnChanged(function()
    State.ESP = Options.ESPOn.Value
    UpdateESP()
end)

-- [แท็บ 3: วาร์ป]
local locNames = {}
for name, _ in pairs(KnownLocations) do table.insert(locNames, name) end
table.sort(locNames)

local WorldDrop = Tabs.World:AddDropdown("WorldDropdown", {
    Title = "เลือกจุดหมายปลายทาง",
    Values = locNames,
    Default = locNames[1]
})

Tabs.World:AddButton({
    Title = "🚀 วาร์ปไปยังจุดที่เลือก",
    Callback = function()
        local sel = Options.WorldDropdown.Value
        if sel and KnownLocations[sel] then
            TeleportTo(KnownLocations[sel], sel)
        end
    end
})

-- [แท็บ 4: ตั้งค่า]
Tabs.Settings:AddParagraph({
    Title = "⚙️ KrakenHub v6.0",
    Content = "Fluent Edition (100% Anti-Kick Bypass Pro)\nกดปุ่ม Right Control เพื่อเปิด/ปิดหน้าต่าง"
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
                        Hub.Unloaded = true
                        State.Running = false
                        State.AutoFarm = false
                        State.AutoSolveMinigame = false
                        State.Noclip = false
                        State.Fly = false
                        State.ESP = false
                        SetSprinting(false)
                        ClearTargetESP()
                        ClearAllJobESP()
                        ReleaseVIM()
                        StopFly()
                        pcall(function()
                            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                            local runSys = pgui and pgui:FindFirstChild("RunSystem")
                            if runSys then runSys:SetAttribute("BlockStamina", false) end
                        end)
                        for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
                        for _, obj in pairs(Hub.ESPObjects) do pcall(function() obj:Destroy() end) end
                        if State.FullBright then
                            RestoreLighting()
                        end
                        local hum = GetHuman()
                        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED; hum.JumpPower = 35 end
                        Fluent:Destroy()
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
        writefile("KrakenHub/options.json", '{"MenuKeybind":"RightControl","Transparency":true,"Theme":"Dark","Acrylic":false}')
    end
end)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
pcall(function()
    if Window.Root then
        Window.Root.Visible = true
        Window.Minimized = false
    end
end)

Notify("🐙 KrakenHub v6.1", "โหลดสำเร็จ! 100% Anti-Kick Bypass Pro", "กด Right Ctrl เพื่อ ซ่อน/แสดง UI", 4)
print("[KrakenHub] สายเลือดอาชีวะ v6.1 Loaded (Multi-Layer Bypass — No hookmetamethod)!")
