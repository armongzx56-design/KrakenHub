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

-- ==============================================================
-- 🌊 KRAKENHUB | INTEGRATED KEY SYSTEM (POWERED BY PLATOBOOST)
-- Service ID: 35734
-- ==============================================================
local _KrakenKeyPassed = (_G._KrakenKeyVerified == true) or (typeof(getgenv) == "function" and getgenv()._KrakenKeyVerified == true)

if not _KrakenKeyPassed then
    local KEY_FILE = "KrakenHub_Key.txt"

    -------------------------------------------------------------------------------
-- [ 1. Platoboost Core Cryptography & JSON Engine ]
-------------------------------------------------------------------------------
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;

local service = 35734;
local secret = "98a069b5-e9df-46cd-8d82-2b3186c8d703";
local useNonce = true;

local StatusCallback = function(msg) end
local fSetClipboard = setclipboard or toclipboard or function() end
local fRequest = request or http_request or syn_request
local fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor = string.char, tostring, string.sub, os.time, math.random, math.floor
local fGetHwid = gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
local cachedLink, cachedTime = "", 0;

local host = "https://api.platoboost.net";

local function generateNonce()
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

local function saveExpiryFromData(data)
    if not data then return end
    local exp = data.expires_at or data.expiresAt or data.expiry or data.expire or data.expiration
    if typeof(exp) == "number" then
        _G._KrakenKeyExpiry = exp
        if writefile then pcall(writefile, "KrakenHub_Key_Expiry.txt", tostring(exp)) end
    elseif typeof(exp) == "string" and tonumber(exp) then
        _G._KrakenKeyExpiry = tonumber(exp)
        if writefile then pcall(writefile, "KrakenHub_Key_Expiry.txt", tostring(exp)) end
    elseif data.minutesLeft then
        local expCalc = os.time() + (tonumber(data.minutesLeft) * 60)
        _G._KrakenKeyExpiry = expCalc
        if writefile then pcall(writefile, "KrakenHub_Key_Expiry.txt", tostring(expCalc)) end
    else
        if not (readfile and isfile and isfile("KrakenHub_Key_Expiry.txt")) then
            local defaultExp = os.time() + (30 * 86400)
            _G._KrakenKeyExpiry = defaultExp
            if writefile then pcall(writefile, "KrakenHub_Key_Expiry.txt", tostring(defaultExp)) end
        end
    end
end

local function redeemKey(key)
    local nonce = generateNonce();
    local endpoint = host .. "/public/redeem/" .. fToString(service);
    local body = { identifier = lDigest(fGetHwid()), key = key }
    if useNonce then body.nonce = nonce end

    local response = fRequest({
        Url = endpoint,
        Method = "POST",
        Body = lEncode(body),
        Headers = { ["Content-Type"] = "application/json" }
    });
    if response and response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true and decoded.data.valid == true then
            if useNonce and decoded.data.hash ~= lDigest("true-" .. nonce .. "-" .. secret) then
                StatusCallback("Failed to verify integrity."); return false;
            end
            saveExpiryFromData(decoded.data)
            return true;
        end
    end
    return false;
end

local function verifyKey(key)
    if not key or key == "" then return false end
    key = string.gsub(tostring(key), "%s+", "")
    local upperKey = string.upper(key)

    -- 1. ตรวจสอบคีย์ประเภท KrakenHub License Key จาก Discord Bot (KRAKEN-XXXX-XXXX-XXXX)
    if string.sub(upperKey, 1, 7) == "KRAKEN-" then
        local p1, p2, p3 = string.match(upperKey, "^KRAKEN%-([%w]+)%-([%w]+)%-([%w]+)$")
        if p1 and p2 and p3 and #p1 >= 3 and #p2 >= 3 and #p3 >= 3 then
            -- ตรวจสอบประวัติคีย์ที่เคยหมดอายุแล้ว
            if readfile and isfile and isfile("KrakenHub_Expired_Keys.txt") then
                local hist = readfile("KrakenHub_Expired_Keys.txt")
                if hist and string.find(hist, key, 1, true) then
                    StatusCallback("This key has expired! Please enter a new key.")
                    return false
                end
            end

            local existingExpiry = nil
            if readfile and isfile and isfile("KrakenHub_Key_Expiry.txt") then
                local rawExp = readfile("KrakenHub_Key_Expiry.txt")
                if rawExp and tonumber(rawExp) then
                    local expNum = tonumber(rawExp)
                    if expNum <= os.time() then
                        -- คีย์นี้หมดอายุแล้ว! บันทึกเข้าประวัติและล้างไฟล์
                        if writefile then
                            local hist = (readfile and isfile and isfile("KrakenHub_Expired_Keys.txt") and readfile("KrakenHub_Expired_Keys.txt")) or ""
                            if not string.find(hist, key, 1, true) then
                                pcall(writefile, "KrakenHub_Expired_Keys.txt", hist .. "\n" .. key)
                            end
                            pcall(delfile or writefile, KEY_FILE, "")
                            pcall(delfile or writefile, "KrakenHub_Key_Expiry.txt", "0")
                        end
                        StatusCallback("This key has expired! Please enter a new key.")
                        return false
                    else
                        existingExpiry = expNum
                    end
                end
            end

            local expiry = existingExpiry or (os.time() + (30 * 86400))
            _G._KrakenKeyExpiry = expiry
            if writefile then
                pcall(writefile, "KrakenHub_Key_Expiry.txt", tostring(expiry))
                pcall(writefile, KEY_FILE, key)
            end
            return true
        end
    end

    -- 2. ตรวจสอบคีย์ Platoboost
    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;
    if useNonce then endpoint = endpoint .. "&nonce=" .. nonce end

    local response = fRequest({ Url = endpoint, Method = "GET" });
    if response and response.StatusCode == 200 then
        local decoded = lDecode(response.Body);
        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce and decoded.data.hash ~= lDigest("true-" .. nonce .. "-" .. secret) then
                    StatusCallback("Integrity check failed."); return false;
                end
                saveExpiryFromData(decoded.data)
                return true;
            else
                if fStringSub(key, 1, 4) == "KEY_" then
                    return redeemKey(key);
                end
            end
        end
    end
    return false;
end

-------------------------------------------------------------------------------
-- [ 2. ตรวจสอบคีย์เดิมที่เซฟไว้ในเครื่อง (Auto Login) ]
-------------------------------------------------------------------------------
local function ReadSavedKey()
    if readfile and isfile and isfile(KEY_FILE) then
        return readfile(KEY_FILE)
    end
    return nil
end

local function SaveKeyToFile(key)
    if writefile then
        writefile(KEY_FILE, key)
    end
end

    local savedKey = (_G.KrakenKey and tostring(_G.KrakenKey)) or ReadSavedKey()
    if savedKey and savedKey ~= "" and verifyKey(savedKey) then
        _KrakenKeyPassed = true
        _G._KrakenKeyVerified = true
    end

    if not _KrakenKeyPassed then
        local userClosed = false

        -- [ 3. UI Key System สวยหรู โทน Dark มี Animation เคลื่อนไหว นุ่มนวล ]
-------------------------------------------------------------------------------
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

pcall(function() if CoreGui:FindFirstChild("KrakenKeyUI") then CoreGui.KrakenKeyUI:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KrakenKeyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = CoreGui

local function Tween(obj, props, duration, style, dir)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, dir), props)
    tween:Play()
    return tween
end

-- เงา Glow แสงนีออนพื้นหลัง
local GlowHalo = Instance.new("ImageLabel")
GlowHalo.Name = "GlowHalo"
GlowHalo.Size = UDim2.new(0, 500, 0, 360)
GlowHalo.Position = UDim2.new(0.5, -250, 0.5, -180)
GlowHalo.BackgroundTransparency = 1
GlowHalo.Image = "rbxassetid://5028857084"
GlowHalo.ImageColor3 = Color3.fromRGB(0, 160, 255)
GlowHalo.ImageTransparency = 1
GlowHalo.Parent = ScreenGui

-- กล่องหน้าต่างหลัก (Dark Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 275)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

-- ขอบนีออน Gradient
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(35, 45, 70)
UIStroke.Thickness = 1.3
UIStroke.Transparency = 1

local StrokeGradient = Instance.new("UIGradient", UIStroke)
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 45, 75)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255))
}
StrokeGradient.Rotation = 45

-- ระบบลากหน้าต่าง (Draggable Window)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Tween(MainFrame, {Position = targetPos}, 0.08, Enum.EasingStyle.Linear)
        Tween(GlowHalo, {Position = UDim2.new(targetPos.X.Scale, targetPos.X.Offset - 40, targetPos.Y.Scale, targetPos.Y.Offset - 42)}, 0.08, Enum.EasingStyle.Linear)
    end
end)

-- แถบสีด้านบนสุด
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 3)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BorderSizePixel = 0
TopBar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 3)

local TopGradient = Instance.new("UIGradient", TopBar)
TopGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 160, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 50, 255))
}

-- Control Buttons Holder (Top Right)
local ControlHolder = Instance.new("Frame", MainFrame)
ControlHolder.Name = "ControlHolder"
ControlHolder.Size = UDim2.new(0, 68, 0, 28)
ControlHolder.Position = UDim2.new(1, -78, 0, 14)
ControlHolder.BackgroundTransparency = 1
ControlHolder.ZIndex = 10

local MinimizeBtn = Instance.new("TextButton", ControlHolder)
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 28, 0, 26)
MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(24, 27, 38)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(180, 190, 210)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.ZIndex = 11
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.TextTransparency = 1
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", ControlHolder)
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 26)
CloseBtn.Position = UDim2.new(0, 34, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 27, 38)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "x"
CloseBtn.TextColor3 = Color3.fromRGB(180, 190, 210)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 11
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextTransparency = 1
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
-- Title & Subtitle
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -110, 0, 32)
Title.Position = UDim2.new(0, 24, 0, 16)
Title.Text = "KRAKENHUB  •  KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(245, 247, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.TextTransparency = 1

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Size = UDim2.new(1, -110, 0, 18)
SubTitle.Position = UDim2.new(0, 24, 0, 46)
SubTitle.Text = "Sailueat Archiwa Edition | KrakenHub License & Platoboost"
SubTitle.TextColor3 = Color3.fromRGB(110, 120, 145)
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.BackgroundTransparency = 1
SubTitle.TextTransparency = 1

-- Status Label
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -48, 0, 20)
StatusLabel.Position = UDim2.new(0, 24, 0, 72)
StatusLabel.Text = "Please enter your active key to continue"
StatusLabel.TextColor3 = Color3.fromRGB(140, 150, 175)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextTransparency = 1

StatusCallback = function(msg)
    StatusLabel.Text = msg
    StatusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
    -- เอฟเฟกต์สั่นเตือนเมื่อผิดพลาด (Shake)
    local origPos = MainFrame.Position
    Tween(MainFrame, {Position = UDim2.new(origPos.X.Scale, origPos.X.Offset - 6, origPos.Y.Scale, origPos.Y.Offset)}, 0.05)
    task.wait(0.05)
    Tween(MainFrame, {Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + 6, origPos.Y.Scale, origPos.Y.Offset)}, 0.05)
    task.wait(0.05)
    Tween(MainFrame, {Position = origPos}, 0.05)
end

-- ช่องกรอก Key Box
local InputContainer = Instance.new("Frame", MainFrame)
InputContainer.Size = UDim2.new(1, -48, 0, 44)
InputContainer.Position = UDim2.new(0, 24, 0, 102)
InputContainer.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
InputContainer.BorderSizePixel = 0
InputContainer.BackgroundTransparency = 1
Instance.new("UICorner", InputContainer).CornerRadius = UDim.new(0, 10)

local InputStroke = Instance.new("UIStroke", InputContainer)
InputStroke.Color = Color3.fromRGB(38, 44, 62)
InputStroke.Thickness = 1.2
InputStroke.Transparency = 1

local KeyInput = Instance.new("TextBox", InputContainer)
KeyInput.Size = UDim2.new(1, -24, 1, 0)
KeyInput.Position = UDim2.new(0, 12, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.PlaceholderText = "Paste your license key here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 90, 115)
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(240, 245, 255)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.TextSize = 13
KeyInput.ClearTextOnFocus = false
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.TextTransparency = 1

KeyInput.Focused:Connect(function()
    Tween(InputStroke, {Color = Color3.fromRGB(0, 170, 255)}, 0.25)
    Tween(InputContainer, {BackgroundColor3 = Color3.fromRGB(24, 28, 40)}, 0.25)
end)

KeyInput.FocusLost:Connect(function()
    Tween(InputStroke, {Color = Color3.fromRGB(38, 44, 62)}, 0.25)
    Tween(InputContainer, {BackgroundColor3 = Color3.fromRGB(20, 22, 32)}, 0.25)
end)

-- ปุ่ม Check Key (ปรับขนาดเต็มความกว้าง)
local SubmitBtn = Instance.new("TextButton", MainFrame)
SubmitBtn.Size = UDim2.new(1, -48, 0, 40)
SubmitBtn.Position = UDim2.new(0, 24, 0, 160)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 240)
SubmitBtn.Text = "Verify Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 13
SubmitBtn.BorderSizePixel = 0
SubmitBtn.BackgroundTransparency = 1
SubmitBtn.TextTransparency = 1
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 9)

local SubmitGradient = Instance.new("UIGradient", SubmitBtn)
SubmitGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 190, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 230))
}

-- ปุ่ม Discord / ซื้อkey
local DiscordBtn = Instance.new("TextButton", MainFrame)
DiscordBtn.Size = UDim2.new(1, -48, 0, 34)
DiscordBtn.Position = UDim2.new(0, 24, 0, 214)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(20, 23, 34)
DiscordBtn.Text = "Discord Community / ซื้อ key"
DiscordBtn.TextColor3 = Color3.fromRGB(120, 140, 220)
DiscordBtn.Font = Enum.Font.GothamMedium
DiscordBtn.TextSize = 12
DiscordBtn.BorderSizePixel = 0
DiscordBtn.BackgroundTransparency = 1
DiscordBtn.TextTransparency = 1
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 8)

-- Hover Effects ให้ทุกปุ่ม
local function AddHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = hoverColor}, 0.2)
        Tween(btn, {Size = btn.Size + UDim2.new(0, 0, 0, 2)}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = normalColor}, 0.2)
        Tween(btn, {Size = btn.Size - UDim2.new(0, 0, 0, 2)}, 0.2)
    end)
end

AddHover(SubmitBtn, Color3.fromRGB(0, 150, 240), Color3.fromRGB(0, 180, 255))
AddHover(DiscordBtn, Color3.fromRGB(20, 23, 34), Color3.fromRGB(32, 36, 52))

-- Animation เปิดหน้าต่าง (Entrance Smooth Animation)
task.spawn(function()
    Tween(MainFrame, {
        Position = UDim2.new(0.5, -210, 0.5, -137),
        BackgroundTransparency = 0
    }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    Tween(GlowHalo, {
        Position = UDim2.new(0.5, -250, 0.5, -180),
        ImageTransparency = 0.65
    }, 0.7)

    Tween(UIStroke, {Transparency = 0}, 0.5)
    Tween(Title, {TextTransparency = 0}, 0.4)
    Tween(SubTitle, {TextTransparency = 0}, 0.45)
    Tween(StatusLabel, {TextTransparency = 0}, 0.5)
    Tween(InputContainer, {BackgroundTransparency = 0}, 0.5)
    Tween(InputStroke, {Transparency = 0}, 0.5)
    Tween(KeyInput, {TextTransparency = 0}, 0.5)
    Tween(SubmitBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.55)
    Tween(DiscordBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.6)
    Tween(MinimizeBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.5)
    Tween(CloseBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.5)
end)

-- Button Click Events
local isMinimized = false
local normalSize = UDim2.new(0, 420, 0, 275)
local minimizedSize = UDim2.new(0, 420, 0, 70)

MinimizeBtn.MouseEnter:Connect(function()
    Tween(MinimizeBtn, {BackgroundColor3 = Color3.fromRGB(36, 42, 60), TextColor3 = Color3.fromRGB(0, 200, 255)}, 0.2)
end)
MinimizeBtn.MouseLeave:Connect(function()
    Tween(MinimizeBtn, {BackgroundColor3 = Color3.fromRGB(24, 27, 38), TextColor3 = Color3.fromRGB(180, 190, 210)}, 0.2)
end)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(220, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(24, 27, 38), TextColor3 = Color3.fromRGB(180, 190, 210)}, 0.2)
end)

CloseBtn.MouseButton1Click:Connect(function()
    userClosed = true
    ScreenGui.Enabled = false
    pcall(function() ScreenGui:Destroy() end)
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MinimizeBtn.Text = "+"
        Tween(MainFrame, {Size = minimizedSize}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Tween(GlowHalo, {Size = UDim2.new(0, 480, 0, 130)}, 0.35)
        Tween(StatusLabel, {TextTransparency = 1}, 0.15)
        Tween(InputContainer, {BackgroundTransparency = 1}, 0.15)
        Tween(KeyInput, {TextTransparency = 1}, 0.15)
        Tween(SubmitBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.15)
        Tween(DiscordBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.15)
        task.delay(0.2, function()
            if isMinimized then
                InputContainer.Visible = false
                SubmitBtn.Visible = false
                DiscordBtn.Visible = false
                StatusLabel.Visible = false
            end
        end)
    else
        MinimizeBtn.Text = "-"
        InputContainer.Visible = true
        SubmitBtn.Visible = true
        DiscordBtn.Visible = true
        StatusLabel.Visible = true
        Tween(MainFrame, {Size = normalSize}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Tween(GlowHalo, {Size = UDim2.new(0, 500, 0, 360)}, 0.4)
        Tween(StatusLabel, {TextTransparency = 0}, 0.3)
        Tween(InputContainer, {BackgroundTransparency = 0}, 0.3)
        Tween(KeyInput, {TextTransparency = 0}, 0.3)
        Tween(SubmitBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.35)
        Tween(DiscordBtn, {BackgroundTransparency = 0, TextTransparency = 0}, 0.35)
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    fSetClipboard("https://discord.com/invite/vvkVDYeuhn")
    StatusLabel.Text = "Discord invite link copied to clipboard!"
    StatusLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
end)

SubmitBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text:gsub("%s+", "")
    if enteredKey == "" then
        StatusLabel.Text = "Please enter your key first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    StatusLabel.Text = "Verifying license with server..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    SubmitBtn.Text = "Checking..."
    Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(0, 100, 180)}, 0.2)
    task.wait(0.2)

    local isValid = verifyKey(enteredKey)
    if isValid then
        SaveKeyToFile(enteredKey)
        StatusLabel.Text = "Key Accepted! Welcome to KrakenHub"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 160)
        SubmitBtn.Text = "Success!"
        Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}, 0.3)
        
        -- Animation ปิดหน้าต่าง (Exit Smooth Animation)
        task.wait(0.6)
        Tween(MainFrame, {
            Position = UDim2.new(0.5, -210, 0.5, -165),
            BackgroundTransparency = 1
        }, 0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        Tween(GlowHalo, {ImageTransparency = 1}, 0.4)
        Tween(Title, {TextTransparency = 1}, 0.3)
        Tween(SubTitle, {TextTransparency = 1}, 0.3)
        Tween(StatusLabel, {TextTransparency = 1}, 0.3)
        Tween(InputContainer, {BackgroundTransparency = 1}, 0.3)
        Tween(KeyInput, {TextTransparency = 1}, 0.3)
        Tween(SubmitBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
        Tween(DiscordBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
        Tween(MinimizeBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
        Tween(CloseBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
        task.wait(0.45)
        ScreenGui:Destroy()
        _KrakenKeyPassed = true
        _G._KrakenKeyVerified = true
    else
        SubmitBtn.Text = "Verify Key"
        Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(0, 150, 240)}, 0.2)
        StatusLabel.Text = "Invalid or Expired Key! Please check again."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

        repeat
            task.wait(0.2)
            if userClosed then return end
        until _KrakenKeyPassed
    end
end


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

-- 📱 ระบบตรวจจับอุปกรณ์, สภาพแวดล้อม และตัวรันสคริปต์ (Universal Device & Executor Detector)
local IsMobile, EnvironmentInfo, DeviceName do
    local uis = UserInputService
    local platform = Enum.Platform.None
    pcall(function() platform = uis:GetPlatform() end)

    local isMobilePlatform = (platform == Enum.Platform.Android or platform == Enum.Platform.IOS)
    local isTouchEnabled = uis.TouchEnabled == true
    local isKeyboardEnabled = uis.KeyboardEnabled == true
    local isMouseEnabled = uis.MouseEnabled == true
    local isGamepadEnabled = uis.GamepadEnabled == true

    local isMobile = isMobilePlatform or (isTouchEnabled and not isKeyboardEnabled and not isMouseEnabled) or (isTouchEnabled and not isKeyboardEnabled)
    if not isMobile and isTouchEnabled and not isMouseEnabled then
        isMobile = true
    end

    local platformName = "Unknown"
    if platform == Enum.Platform.Android then
        platformName = "Android"
    elseif platform == Enum.Platform.IOS then
        platformName = "iOS"
    elseif platform == Enum.Platform.Windows then
        platformName = "Windows"
    elseif platform == Enum.Platform.OSX then
        platformName = "macOS"
    elseif platform == Enum.Platform.XBoxOne or platform == Enum.Platform.PS4 then
        platformName = "Console"
    else
        platformName = isMobile and "Mobile OS" or "Desktop OS"
    end

    local deviceType = isMobile and "Mobile" or "PC"
    if platform == Enum.Platform.Android then
        deviceType = "Android (Mobile)"
    elseif platform == Enum.Platform.IOS then
        deviceType = "iOS (Mobile)"
    elseif platform == Enum.Platform.Windows then
        deviceType = "Windows (PC)"
    elseif platform == Enum.Platform.OSX then
        deviceType = "Mac (PC)"
    elseif isMobile then
        deviceType = "Mobile (Touch Device)"
    end

    -- ตรวจจับ Executor / Tooling Environment
    local execName = "Unknown"
    local execVersion = ""
    pcall(function()
        if typeof(identifyexecutor) == "function" then
            local n, v = identifyexecutor()
            if n and tostring(n) ~= "" then
                execName = tostring(n)
                execVersion = (v and tostring(v) ~= "") and tostring(v) or ""
            end
        elseif typeof(getexecutorname) == "function" then
            local n = getexecutorname()
            if n and tostring(n) ~= "" then execName = tostring(n) end
        elseif typeof(whatexecutor) == "function" then
            local n = whatexecutor()
            if n and tostring(n) ~= "" then execName = tostring(n) end
        elseif rawget(_G, "DELTA_LOADED") or rawget(_G, "delta") then
            execName = "Delta"
        elseif rawget(_G, "CODEX") or rawget(_G, "codex") then
            execName = "Codex"
        elseif rawget(_G, "ARCEUS_LOADED") or rawget(_G, "SPDM_LOADED") then
            execName = "Arceus X"
        elseif rawget(_G, "HYDROGEN_LOADED") or rawget(_G, "hydrogen") then
            execName = "Hydrogen"
        elseif rawget(_G, "FLUXUS_LOADED") or rawget(_G, "fluxus") then
            execName = "Fluxus"
        elseif rawget(_G, "KRNL_LOADED") or rawget(_G, "krnl") then
            execName = "Krnl"
        elseif rawget(_G, "syn") or rawget(_G, "synapse") then
            execName = "Synapse"
        elseif rawget(_G, "wave") then
            execName = "Wave"
        elseif rawget(_G, "solara") then
            execName = "Solara"
        elseif rawget(_G, "appleware") then
            execName = "Appleware"
        elseif rawget(_G, "macsploit") then
            execName = "Macsploit"
        end
    end)

    local fullExec = execName
    if execVersion ~= "" then
        fullExec = fullExec .. (execVersion:sub(1, 1):lower() == "v" and (" " .. execVersion) or (" v" .. execVersion))
    end

    local inputDesc = {}
    if isTouchEnabled then table.insert(inputDesc, "Touch") end
    if isMouseEnabled then table.insert(inputDesc, "Mouse") end
    if isKeyboardEnabled then table.insert(inputDesc, "Keyboard") end
    if isGamepadEnabled then table.insert(inputDesc, "Gamepad") end
    local inputStr = #inputDesc > 0 and table.concat(inputDesc, " + ") or "None"

    IsMobile = isMobile
    DeviceName = deviceType
    EnvironmentInfo = {
        IsMobile = isMobile,
        DeviceType = deviceType,
        PlatformName = platformName,
        Executor = fullExec,
        ExecutorName = execName,
        InputMethod = inputStr,
        Summary = string.format("%s | %s", deviceType, fullExec)
    }
end
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local CS = CollectionService
local ProximityPromptService = game:GetService("ProximityPromptService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

_G._KrakenScriptId = (_G._KrakenScriptId or 0) + 1
local MY_SCRIPT_ID = _G._KrakenScriptId

print(string.format(">>> KRAKENHUB INITIALIZING (ID: %s) [DEVICE: %s] [EXECUTOR: %s] [PLATFORM: %s] <<<", tostring(MY_SCRIPT_ID), EnvironmentInfo.DeviceType, EnvironmentInfo.Executor, EnvironmentInfo.PlatformName))
-- เคลียร์อินสแตนซ์และ UI เก่า
if _G.KrakenHub_Sailueat and type(_G.KrakenHub_Sailueat.Unload) == "function" then
    pcall(function() _G.KrakenHub_Sailueat.Unload() end)
end
if _G.SailueatHub_Cleanup then
    pcall(_G.SailueatHub_Cleanup)
end

local CoreGui = game:GetService("CoreGui")
local targetGuiParent = (function()
    if typeof(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, cg = pcall(function()
        local c = game:GetService("CoreGui")
        local _ = c.Name
        return c
    end)
    if ok and cg then
        if typeof(cloneref) == "function" then
            local ok2, cref = pcall(cloneref, cg)
            if ok2 and cref then return cref end
        end
        return cg
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end)()
for _, name in ipairs({"KrakenHub_ToggleButton", "SailueatHub_V3", "SailueatHub_V3_5", "SailueatHub_V3_6", "SailueatHub_V3_7", "SailueatHub_V3_8", "SailueatHub_V3_9", "SailueatHub_V2", "SailueatHub_V1", "Fluent"}) do
    local old = targetGuiParent:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
end


-- เคลียร์เฉพาะ Highlight และ Billboard ของ KrakenHub ตกค้างใน Workspace และ UI ป้องกันการลบ CoreGui ภายในเกมที่ทำให้เกมเด้ง
pcall(function()
    for _, desc in ipairs(Workspace:GetChildren()) do
        if desc:IsA("Highlight") or desc:IsA("BillboardGui") then
            local n = desc.Name
            if n:find("Target") or n:find("Kraken") or n:find("Farm") or n:find("Merchant") or n:find("AllJobSpot") then
                pcall(function() desc:Destroy() end)
            end
        end
    end
    for _, c in ipairs(targetGuiParent:GetChildren()) do
        if c:IsA("Highlight") or c:IsA("BillboardGui") or c:IsA("ScreenGui") then
            local n = c.Name
            if n:find("Kraken") or n:find("Target") or n:find("AllJobSpot") or n:find("Fluent") or n:find("Sailueat") then
                pcall(function() c:Destroy() end)
            end
        end
    end
end)

--------------------------------------------------------------
-- 🛡️ NETBEAT & ANTI-CHEAT GUARDIAN (BYPASS CODE: 6, CODE: 7501, CODE: 7502, CODE: 7503 & ALL ANOMALY KICKS 100%)
--------------------------------------------------------------
local GlobalNetBeatWatchList = nil

local function InitializeAntiCheatGuardian()
    pcall(function()
        RunService:UnbindFromRenderStep("NetBeatCamStart")
        RunService:UnbindFromRenderStep("NetBeatCamEnd")
    end)

    local function ScanAndNeutralizeNetBeat()
        if typeof(getgc) ~= "function" then return end
        pcall(function()
            local allGC = getgc()
            for _, item in ipairs(allGC) do
                -- ตรวจหาตาราง WatchList (u140) โดยตรงจากโครงสร้าง { name = ..., s = ..., t = ... }
                if type(item) == "table" and #item > 0 then
                    local first = item[1]
                    if type(first) == "table" and rawget(first, "name") ~= nil and rawget(first, "s") ~= nil and rawget(first, "t") ~= nil then
                        GlobalNetBeatWatchList = item
                        pcall(table.clear, item)
                        break -- พบตารางแล้วหยุดสแกนทันที เพื่อประหยัด CPU 100%
                    end
                end
            end
        end)
    end

    ScanAndNeutralizeNetBeat()

    -- บล็อก Remote Beat หากมีการส่ง payload ผิดปกติ
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
    local BeatRemote = remotes and remotes:FindFirstChild("Beat")
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
        end)
    end

    -- บล็อก Remote HHeartbeatB (AntiHitbox)
    local hb = remotes and remotes:FindFirstChild("HHeartbeatB")
    if hb and typeof(hookfunction) == "function" then
        pcall(function()
            local oldHbFire = nil
            oldHbFire = hookfunction(hb.FireServer, function(self, ...)
                if self == hb then return nil end
                return oldHbFire(self, ...)
            end)
        end)
    end

    -- บล็อก Remote ABDonate (Aimbot Report)
    local ab = remotes and remotes:FindFirstChild("ABDonate")
    if ab and typeof(hookfunction) == "function" then
        pcall(function()
            local oldAbFire = nil
            oldAbFire = hookfunction(ab.FireServer, function(self, ...)
                if self == ab then return nil end
                return oldAbFire(self, ...)
            end)
        end)
    end

    -- ปิดการทำงาน AntiHitboxClient LocalScript
    pcall(function()
        local pscripts = LocalPlayer:FindFirstChild("PlayerScripts")
        if pscripts then
            local ahc = pscripts:FindFirstChild("AntiHitboxClient", true)
            if ahc and ahc:IsA("LocalScript") then
                ahc.Disabled = true
            end
        end
    end)

    -- วนลูปเคลียร์ WatchList อย่างเบาบาง (ทุก 2.5 วินาที ไร้การสแกน GC ในลูป ไม่ดึงเฟรม 100%)
    task.spawn(function()
        local hasRetried = false
        while _G._KrakenScriptId == MY_SCRIPT_ID do
            task.wait(2.5)
            if GlobalNetBeatWatchList then
                pcall(table.clear, GlobalNetBeatWatchList)
            elseif not hasRetried then
                hasRetried = true
                ScanAndNeutralizeNetBeat()
            end
        end
    end)
end

InitializeAntiCheatGuardian()

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
        FarmSpeed = 16.0,
        AutoSolveMinigame = true,
        AutoHire = true,
        AutoClaimConstruction = false, -- เคลมเงินค่าจ้างงานก่อสร้างอัตโนมัติ
        ConstructionFilter = "กำแพง & เหล็ก", -- "ทั้งหมด", "กำแพง & เหล็ก", "เฉพาะกำแพง", "เฉพาะเหล็ก"
        ShowAllSpotsESP = false,
        AutoSellTrash = true,
        -- ตำรวจ (Police)
        AutoCuffWanted = false,
        AutoEquipCuffs = false,
        AutoConfiscateDrugs = false,
        AutoSendToJail = false,
        PoliceArrestDistance = 8,
        -- โค้ดรับรางวัล (Community Codes)
        AutoRedeemCodes = false,
        -- Cheats
        Speed = false,
        SpeedValue = 17,
        Jump = false,
        JumpValue = 35,
        Noclip = false,
        Fly = false,
        FlySpeed = 50,
        InfJump = false,
        InfStamina = true,
        Godmode = false,
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
        -- ปืน & Combat
        NoSpread = false,
        NoRecoil = true,
        FastBullet = false,
        GlockSwitch = true,
        GlockSwitchRate = 0.11,
        SilentAim = false,
        SilentTeamCheck = true,
        SilentPart = "Head",
        SilentHitChance = 100,
        SilentWallCheck = false,
        SilentVelocity = false,
        CombatFOV = 150,
        DrawFOV = false,
        LockFOVCenter = IsMobile,
        -- 🎃 ฮาโลวีน (Halloween Event)
        AutoTrickOrTreat = false,
        AutoDigGraves = false,
        AutoGraveQTE = true,
        AutoVacuumLoot = true,
        AutoJoinEvent2h = false,
        AutoGetBucket = false,
        AutoDepositCandy = false,
        AutoClaimQuests = false,
        AutoCollectP320 = false,
        HalloweenMonstersESP = false,
        HalloweenGravesESP = false,
        HalloweenHousesESP = false,
        HalloweenP320ESP = false,
        SilentAimHalloween = true,
        -- ระบบ & เมนู
        MenuKeybind = Enum.KeyCode.RightControl,
        ShowFloatingButton = true,
        HideFloatingButton = false,
        UltraBoostFPS = false,
        FPSCap = 60,
        -- พ่อค้าพเนจร (Wandering Merchant)
        MerchantESP = true,
        AutoNotifyMerchant = true,
        -- ป้องกันตกจากที่สูง
        NoFallDamage = true,
        -- ระบบกระเป๋าเก็บของ (Bag System)
        AutoEquipBag = true,
        -- ระบบเกิดใหม่ทันที (Fast Respawn)
        InstantRespawn = true,
        RespawnAtDeathPos = false,
    }
}
_G.KrakenHub_Sailueat = Hub
local State = Hub.State
local Connections = Hub.Connections

Hub.ActiveGrave = {
    token = nil,
    dragsNeeded = 0,
    dragsCompleted = 0,
    active = false,
    inWork = false,
    startTime = 0,
    lastActionTime = 0
}
local ActiveGrave = Hub.ActiveGrave

local localChar = LocalPlayer.Character
local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
local localHumanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
local cachedIsWorking = false

local function UpdateLocalCharRefs(newChar)
    localChar = newChar or LocalPlayer.Character
    localHumanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
    localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
end

local function GetChar(plr)
    if not plr or plr == LocalPlayer then
        if localChar and localChar.Parent then return localChar end
        UpdateLocalCharRefs()
        return localChar
    end
    return plr.Character
end

local function GetHRP(plr)
    if not plr or plr == LocalPlayer then
        if localHRP and localHRP.Parent == localChar then return localHRP end
        UpdateLocalCharRefs()
        return localHRP
    end
    local char = plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHuman(plr)
    if not plr or plr == LocalPlayer then
        if localHumanoid and localHumanoid.Parent == localChar then return localHumanoid end
        UpdateLocalCharRefs()
        return localHumanoid
    end
    local char = plr.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local IsCurrentlyWorking = function()
    return cachedIsWorking
end


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
local lastSprintChangeTime = 0

local function GetRunButton()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    return pgui and pgui:FindFirstChild("MobileGUI") and pgui.MobileGUI:FindFirstChild("MobileButtons") and pgui.MobileGUI.MobileButtons:FindFirstChild("RunButton")
end

local function SetSprinting(enabled)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local targetSpeed = State.FarmSpeed or 16.0

    if isCurrentlySprinting == enabled and (os.clock() - lastSprintChangeTime < 0.5) then
        if enabled and hum.WalkSpeed < targetSpeed then
            hum.WalkSpeed = targetSpeed
        end
        return
    end

    lastSprintChangeTime = os.clock()
    isCurrentlySprinting = enabled

    local fn = GetRunSystemRenderFn()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local rs = pgui and pgui:FindFirstChild("RunSystem")
    local isBlocked = rs and rs:GetAttribute("BlockStamina") == true

    if enabled then
        if (IsCurrentlyWorking and IsCurrentlyWorking()) or isBlocked then
            if fn and debug.getupvalue(fn, 3) == true then
                pcall(debug.setupvalue, fn, 3, false)
            end
            hum.WalkSpeed = 0
            return
        end

        if fn then
            local isRunning = debug.getupvalue(fn, 3)
            local isExhausted = debug.getupvalue(fn, 5)
            local stamina = debug.getupvalue(fn, 10)

            if not isExhausted and (stamina == nil or stamina > 2) then
                if not isRunning then
                    pcall(debug.setupvalue, fn, 3, true)
                end
                hum.WalkSpeed = targetSpeed
                hum.JumpPower = 35
            else
                if isRunning then
                    pcall(debug.setupvalue, fn, 3, false)
                    hum.WalkSpeed = 8
                end
            end
        else
            hum.WalkSpeed = targetSpeed
            hum.JumpPower = 35
        end
    else
        if fn then
            local isRunning = debug.getupvalue(fn, 3)
            if isRunning then
                pcall(debug.setupvalue, fn, 3, false)
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

local function SetInfiniteStaminaState(enabled)
    local fn = GetRunSystemRenderFn()
    if fn then
        if enabled then
            pcall(debug.setupvalue, fn, 10, 100)  -- Stamina 100 เต็มถาวร
            pcall(debug.setupvalue, fn, 5, false)  -- isExhausted false (ไม่เหนื่อยหอบ)
            pcall(debug.setupvalue, fn, 11, 100)  -- Recovery Rate = 100/s (ฟื้นฟูทันที)
            pcall(debug.setupvalue, fn, 12, 0)    -- Drain Rate = 0 (วิ่งไม่ลดสเตมิน่าเด็ดขาด)
            pcall(debug.setupvalue, fn, 15, 0)
            pcall(debug.setupvalue, fn, 18, 0)
            pcall(debug.setupvalue, fn, 20, 0)
            local s2 = debug.getupvalue(fn, 13)
            if s2 and typeof(s2) == "Instance" and s2:IsA("Sound") then
                s2:Stop()
            end
            local s1 = debug.getupvalue(fn, 14)
            if s1 and typeof(s1) == "Instance" and s1:IsA("Sound") then
                s1:Stop()
            end
            local blur = debug.getupvalue(fn, 21)
            if blur and typeof(blur) == "Instance" and blur:IsA("BlurEffect") then
                blur.Size = 0
            end
            local cc = debug.getupvalue(fn, 22)
            if cc and typeof(cc) == "Instance" and cc:IsA("ColorCorrectionEffect") then
                cc.Contrast = 0
                cc.Saturation = 0
            end
        else
            local isVip = debug.getupvalue(fn, 27) == true
            pcall(debug.setupvalue, fn, 11, isVip and 3.5 or 2.5)
            pcall(debug.setupvalue, fn, 12, isVip and 0.9 or 1.5)
        end
    end

    local hum = GetHuman()
    if hum and hum.Health > 0 then
        if hum.WalkSpeed < 8 and not (IsCurrentlyWorking and IsCurrentlyWorking()) then
            hum.WalkSpeed = NORMAL_WALK_SPEED
        end
    end
end

local function RestoreFatigue()
    SetInfiniteStaminaState(State.InfStamina)
end

local lastInfStaminaCheck = 0
Connections.SpeedEnforcer = RunService.RenderStepped:Connect(function()
    if not State.Running then return end
    local hum = GetHuman()
    local hrp = GetHRP()
    if not hum or hum.Health <= 0 or not hrp then return end

    local now = os.clock()

    -- 🏃 ระบบวิ่งไม่เหนื่อย (Infinite Stamina) - ล็อค Stamina 100 และ Drain = 0
    if State.InfStamina and (now - lastInfStaminaCheck >= 0.2) then
        lastInfStaminaCheck = now
        local fn = GetRunSystemRenderFn()
        if fn then
            local stam = debug.getupvalue(fn, 10)
            local drain = debug.getupvalue(fn, 12)
            local isExhausted = debug.getupvalue(fn, 5)
            if (stam and stam < 100) or drain ~= 0 or isExhausted == true then
                SetInfiniteStaminaState(true)
            end
        end
    end

    -- 🛑 ล้างค่าสั่นมุมกล้อง math.noise ของ RunSystem ให้เป็น 0 (หน่วงเวลาเพื่อลดภาระ CPU)
    if now - lastCameraShakeClear >= 0.35 then
        lastCameraShakeClear = now
        local fn = GetRunSystemRenderFn()
        if fn then
            pcall(debug.setupvalue, fn, 15, 0) -- u14: target amplitude ของการสั่นกล้อง
            pcall(debug.setupvalue, fn, 18, 0) -- u15: current amplitude ของการสั่นกล้อง
            pcall(debug.setupvalue, fn, 23, 0) -- u16: phase ของ math.noise
        end
    end

    -- ล็อคความเร็ว 0 เฉพาะตอนที่เปิด AutoFarm และกำลังทำงานก่อสร้าง / มินิเกม เท่านั้น (อ่านจากแคชทันที 0ms ไม่หน่วง FPS)
    if State.AutoFarm and cachedIsWorking then
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

    -- หากผู้ใช้เปิด Cheats > Speed เสริมเอง ล็อคเพดานปลอดภัยไม่เกิน 18 studs/s
    if State.Speed then
        hum.WalkSpeed = math.min(State.SpeedValue or 18, 18)
    end
end)

--------------------------------------------------------------
-- ☀️ ระบบสว่างทั้งแมพ (FULL BRIGHT)
--------------------------------------------------------------
Hub.LightingData = {
    default = nil,
    conns = {},
    effects = {},
}

local function EnableFullBright()
    pcall(function()
        if not Hub.LightingData.default then
            Hub.LightingData.default = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                ColorShift_Top = Lighting.ColorShift_Top,
                ColorShift_Bottom = Lighting.ColorShift_Bottom,
            }
        end
    end)

    if getconnections then
        pcall(function()
            for _, conn in ipairs(getconnections(RunService.Heartbeat)) do
                local s = nil
                pcall(function() s = conn.Script end)
                if s and s.Name == "DayNightLighting" then
                    pcall(function() conn:Disable() end)
                    table.insert(Hub.LightingData.conns, conn)
                end
            end
        end)
    end
    pcall(function()
        local ps = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
        local dnScript = ps and ps:FindFirstChild("DayNightLighting")
        if dnScript and dnScript:IsA("LocalScript") then
            dnScript.Disabled = true
        end
    end)
    pcall(function()
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("ColorCorrectionEffect") or effect:IsA("Atmosphere") or effect:IsA("BloomEffect") then
                if effect.Name == "DayNightGrade" or effect.Name == "Atmosphere" or effect:IsA("ColorCorrectionEffect") then
                    pcall(function()
                        if effect.Enabled then
                            table.insert(Hub.LightingData.effects, effect)
                            effect.Enabled = false
                        end
                    end)
                end
            end
        end
    end)
    pcall(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    end)
end

local function RestoreLighting()
    for _, conn in ipairs(Hub.LightingData.conns) do
        pcall(function() conn:Enable() end)
    end
    table.clear(Hub.LightingData.conns)
    pcall(function()
        local ps = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
        local dnScript = ps and ps:FindFirstChild("DayNightLighting")
        if dnScript and dnScript:IsA("LocalScript") then
            dnScript.Disabled = false
        end
    end)
    for _, effect in ipairs(Hub.LightingData.effects) do
        pcall(function()
            if effect and effect.Parent then
                effect.Enabled = true
            end
        end)
    end
    table.clear(Hub.LightingData.effects)

    pcall(function()
        local def = Hub.LightingData.default
        if def then
            Lighting.Brightness = def.Brightness or 1
            Lighting.ClockTime = def.ClockTime or 14
            Lighting.FogEnd = def.FogEnd or 1000
            Lighting.GlobalShadows = (def.GlobalShadows ~= nil) and def.GlobalShadows or true
            Lighting.Ambient = def.Ambient or Color3.fromRGB(128, 128, 128)
            Lighting.OutdoorAmbient = def.OutdoorAmbient or Color3.fromRGB(128, 128, 128)
            if def.ColorShift_Top then Lighting.ColorShift_Top = def.ColorShift_Top end
            if def.ColorShift_Bottom then Lighting.ColorShift_Bottom = def.ColorShift_Bottom end
        end
    end)
end

Connections.FullBrightLoop = RunService.Heartbeat:Connect(function()
    if State.FullBright and State.Running then
        pcall(function()
            if Lighting.Brightness ~= 2 then Lighting.Brightness = 2 end
            if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end
            if Lighting.FogEnd ~= 100000 then Lighting.FogEnd = 100000 end
            if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end
            local ps = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
            local dnScript = ps and ps:FindFirstChild("DayNightLighting")
            if dnScript and dnScript:IsA("LocalScript") and not dnScript.Disabled then
                dnScript.Disabled = true
            end
            local dng = Lighting:FindFirstChild("DayNightGrade")
            if dng and dng:IsA("ColorCorrectionEffect") and dng.Enabled then
                dng.Enabled = false
            end
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
            hl.Parent = targetGuiParent
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

            bb.Parent = targetGuiParent
            currentTargetBillboard = bb
        end
    end)
end

local lastTargetESPUpdate = 0
local lastTargetDistFloor = -1
local lastTargetSt = ""
Connections.TargetESPUpdate = RunService.Heartbeat:Connect(function()
    if not currentTargetBillboard or not currentTargetInstance then return end
    local now = os.clock()
    if now - lastTargetESPUpdate < 0.15 then return end
    lastTargetESPUpdate = now
        local attachPart = (currentTargetInstance:IsA("BasePart") and currentTargetInstance)
                        or (currentTargetBillboard.Adornee and currentTargetBillboard.Adornee:IsA("BasePart") and currentTargetBillboard.Adornee)
                        or currentTargetInstance:FindFirstChildWhichIsA("BasePart", true)
        local hrp = GetHRP()
        if attachPart and hrp then
            local dist = (hrp.Position - attachPart.Position).Magnitude
            local distFloor = math.floor(dist)
            local st = currentTargetStatus or "เป้าหมาย"
            if distFloor ~= lastTargetDistFloor or st ~= lastTargetSt then
                lastTargetDistFloor = distFloor
                lastTargetSt = st
                local frame = currentTargetBillboard:FindFirstChildOfClass("Frame")
                local dLabel = frame and frame:FindFirstChild("DistLabel")
                if dLabel then
                    dLabel.Text = string.format("%s • %.1f ม. (%d studs)", st, dist / 3.57, distFloor)
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
                hl.Parent = targetGuiParent
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
local sharedNavRayParams = RaycastParams.new()
sharedNavRayParams.FilterType = Enum.RaycastFilterType.Exclude
sharedNavRayParams.IgnoreWater = true

local function RaycastCollidable(origin, dir, maxPierces)
    maxPierces = maxPierces or 4
    local char = GetChar()
    local filter = { char }
    if Workspace:FindFirstChild("Terrain") then table.insert(filter, Workspace.Terrain) end
    sharedNavRayParams.FilterDescendantsInstances = filter

    local curOrigin = origin
    local remainingDir = dir

    for _ = 1, maxPierces do
        local hit = Workspace:Raycast(curOrigin, remainingDir, sharedNavRayParams)
        if not hit then
            return nil
        end
        if hit.Instance and hit.Instance.CanCollide then
            return hit
        else
            -- ชิ้นส่วนไร้ Collision (Zone trigger, หมอก, แสง): บันทึกลง Filter แล้วยิงต่อทะลุผ่าน
            table.insert(filter, hit.Instance)
            sharedNavRayParams.FilterDescendantsInstances = filter
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
            local pPos = nil
            if targetPrompt.Parent then
                if targetPrompt.Parent:IsA("Attachment") then
                    pPos = targetPrompt.Parent.WorldPosition
                elseif targetPrompt.Parent:IsA("BasePart") then
                    pPos = targetPrompt.Parent.Position
                end
            end
            pPos = pPos or targetPos
            local pDist3D = (hrp.Position - pPos).Magnitude

            -- เมื่อเข้าใกล้จุดยืนนำทาง (standPos) หรืออยู่ในระยะกด ProximityPrompt ได้ 100%
            local promptLimit = math.min(promptMaxD - 0.8, 6.5)
            if (dist3D <= stopDist or (hDist <= stopDist and yDiff <= 4.0)) and pDist3D <= promptLimit then
                return true
            end
            if pDist3D <= promptLimit then
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

    while (tick() - startTime) < maxTime and State.Running and (State.AutoFarm or State.AutoTrickOrTreat or State.AutoDigGraves) do
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
        local needDownload = not isfile("k_community_logo.png")
        if isfile("k_community_logo.png") and typeof(readfile) == "function" then
            pcall(function()
                local content = readfile("k_community_logo.png")
                if not content or #content < 1000 or content:sub(1, 4) ~= "\137PNG" then
                    needDownload = true
                end
            end)
        end

        if needDownload then
            local logoUrls = {
                "https://files.catbox.moe/t3q02s.png",
                "https://raw.githubusercontent.com/armongzx56-design/KrakenHub/main/k_community_logo.png"
            }
            for _, url in ipairs(logoUrls) do
                local s, data = pcall(function() return game:HttpGet(url) end)
                if s and type(data) == "string" and #data > 1000 and data:sub(1, 4) == "\137PNG" then
                    pcall(writefile, "k_community_logo.png", data)
                    break
                end
            end
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


-- ==============================================================
-- 🎨 MACLIB UI LIBRARY (EMBEDDED NATIVE MACOS UI)
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
	dropdown = "rbxassetid://18865373378",
	sliderbar = "rbxassetid://18772615246",
	sliderhead = "rbxassetid://18772834246",
}

--// Functions
local function GetGui()
	local newGui = Instance.new("ScreenGui")
	newGui.ScreenInsets = Enum.ScreenInsets.None
	newGui.ResetOnSpawn = false
	newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	newGui.DisplayOrder = 2147483647

	local parent = targetGuiParent
	if not parent or not pcall(function() return parent.Name end) then
		parent = (typeof(gethui) == "function" and gethui())
			or (RunService:IsStudio() and LocalPlayer:FindFirstChild("PlayerGui"))
			or (cloneref and cloneref(MacLib.GetService("CoreGui")) or MacLib.GetService("CoreGui"))
			or LocalPlayer:FindFirstChild("PlayerGui")
	end

	if parent and parent:IsA("ScreenGui") then
		parent = parent.Parent or targetGuiParent
	end

	newGui.Parent = parent
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
	base.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	base.BackgroundTransparency = 0
	base.BorderColor3 = Color3.fromRGB(0, 0, 0)
	base.BorderSizePixel = 0
	base.Position = UDim2.fromScale(0.5, 0.5)

	local Viewport = (Camera and Camera.ViewportSize) or Vector2.new(1280, 720)
	local initSize = Settings.Size or UDim2.fromOffset(868, 650)
	if IsMobile or Viewport.X < 900 or Viewport.Y < 650 then
		local fitW = math.clamp(math.floor(Viewport.X * 0.90), 380, 800)
		local fitH = math.clamp(math.floor(Viewport.Y * 0.88), 280, 560)
		initSize = UDim2.fromOffset(fitW, fitH)
	end
	base.Size = initSize

	local baseGradient = Instance.new("UIGradient")
	baseGradient.Name = "BaseGradient"
	baseGradient.Rotation = 90
	baseGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 29, 32)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(22, 23, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 17, 19))
	})
	baseGradient.Parent = base

	local baseUIScale = Instance.new("UIScale")
	baseUIScale.Name = "BaseUIScale"
	if IsMobile and Viewport.Y < 480 then
		baseUIScale.Scale = math.clamp(Viewport.Y / 490, 0.75, 1.0)
	end
	baseUIScale.Parent = base

	local baseUICorner = Instance.new("UICorner")
	baseUICorner.Name = "BaseUICorner"
	baseUICorner.CornerRadius = UDim.new(0, 12)
	baseUICorner.Parent = base

	local baseUIStroke = Instance.new("UIStroke")
	baseUIStroke.Name = "BaseUIStroke"
	baseUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke.Transparency = 0.85
	baseUIStroke.Thickness = 1.2
	baseUIStroke.Parent = base

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebar.BackgroundTransparency = 0
	sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.fromScale(-3.52e-08, 4.69e-08)
	sidebar.Size = UDim2.fromScale(0.325, 1)

	local sidebarGradient = Instance.new("UIGradient")
	sidebarGradient.Name = "SidebarGradient"
	sidebarGradient.Rotation = 90
	sidebarGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 23, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 16, 18))
	})
	sidebarGradient.Parent = sidebar

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.AnchorPoint = Vector2.new(1, 0)
	divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider.BackgroundTransparency = 0.92
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
	maximize.BackgroundColor3 = Color3.fromRGB(39, 201, 63)
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

	applyState(maximize, true)

	local controlsList = {exit, minimize, maximize}
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

	local statusDot = Instance.new("Frame")
	statusDot.Name = "StatusDot"
	statusDot.Size = UDim2.fromOffset(9, 9)
	statusDot.Position = UDim2.new(1, -3, 1, -3)
	statusDot.AnchorPoint = Vector2.new(0.5, 0.5)
	statusDot.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
	statusDot.BorderSizePixel = 0
	statusDot.ZIndex = 5

	local statusDotCorner = Instance.new("UICorner")
	statusDotCorner.Name = "StatusDotCorner"
	statusDotCorner.CornerRadius = UDim.new(1, 0)
	statusDotCorner.Parent = statusDot

	local statusDotStroke = Instance.new("UIStroke")
	statusDotStroke.Name = "StatusDotStroke"
	statusDotStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	statusDotStroke.Color = Color3.fromRGB(16, 16, 18)
	statusDotStroke.Thickness = 1.6
	statusDotStroke.Parent = statusDot

	statusDot.Parent = headshot

	headshot.Parent = informationGroup

	local function MaskName(str)
		if not str or str == "" then return "Player" end
		local len = #str
		if len <= 3 then
			return string.sub(str, 1, 1) .. string.rep("*", len - 1)
		elseif len <= 6 then
			return string.sub(str, 1, 2) .. string.rep("*", len - 3) .. string.sub(str, -1)
		else
			local prefix = string.sub(str, 1, 3)
			local suffix = string.sub(str, -3)
			local starCount = math.max(3, len - 6)
			return prefix .. string.rep("*", starCount) .. suffix
		end
	end

	local userAndDisplayFrame = Instance.new("Frame")
	userAndDisplayFrame.Name = "UserAndDisplayFrame"
	userAndDisplayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userAndDisplayFrame.BackgroundTransparency = 1
	userAndDisplayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userAndDisplayFrame.BorderSizePixel = 0
	userAndDisplayFrame.LayoutOrder = 1
	userAndDisplayFrame.Size = UDim2.new(1, -42, 0, 48)
	userAndDisplayFrame.AutomaticSize = Enum.AutomaticSize.Y

	local displayName = Instance.new("TextLabel")
	displayName.Name = "DisplayName"
	displayName.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	displayName.Text = MaskName(LocalPlayer.DisplayName)
	displayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	displayName.TextSize = 14
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
	userAndDisplayFrameUIPadding.PaddingTop = UDim.new(0, 1)
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
	username.Text = "@" .. MaskName(LocalPlayer.Name)
	username.TextColor3 = Color3.fromRGB(255, 255, 255)
	username.TextSize = 12
	username.TextTransparency = 0.65
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

	local keyStatus = Instance.new("TextLabel")
	keyStatus.Name = "KeyStatus"
	keyStatus.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	keyStatus.Text = "🔑 คีย์: ตรวจสอบผ่าน"
	keyStatus.TextColor3 = Color3.fromRGB(0, 230, 160)
	keyStatus.TextSize = 11
	keyStatus.TextTransparency = 0.15
	keyStatus.TextTruncate = Enum.TextTruncate.SplitWord
	keyStatus.TextXAlignment = Enum.TextXAlignment.Left
	keyStatus.TextYAlignment = Enum.TextYAlignment.Top
	keyStatus.AutomaticSize = Enum.AutomaticSize.XY
	keyStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	keyStatus.BackgroundTransparency = 1
	keyStatus.BorderSizePixel = 0
	keyStatus.LayoutOrder = 2
	keyStatus.Parent = userAndDisplayFrame
	keyStatus.Size = UDim2.fromScale(1,0)

	userAndDisplayFrame.Parent = informationGroup
	informationGroup.Parent = userInfo

	task.spawn(function()
		while keyStatus and keyStatus.Parent do
			local expiry = _G._KrakenKeyExpiry
			if not expiry and readfile and isfile and isfile("KrakenHub_Key_Expiry.txt") then
				local s = readfile("KrakenHub_Key_Expiry.txt")
				expiry = tonumber(s)
			end

			if expiry and expiry > 0 then
				local diff = expiry - os.time()
				if diff <= 0 then
					keyStatus.Text = "🔑 คีย์: หมดอายุแล้ว (กำลังออกจากระบบ...)"
					keyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)

					-- บันทึกคีย์ที่หมดอายุลงประวัติเพื่อบล็อกการใช้งานซ้ำ
					pcall(function()
						local currentKey = (readfile and isfile and isfile(KEY_FILE) and readfile(KEY_FILE)) or ""
						if currentKey ~= "" and writefile then
							local hist = (readfile and isfile and isfile("KrakenHub_Expired_Keys.txt") and readfile("KrakenHub_Expired_Keys.txt")) or ""
							if not string.find(hist, currentKey, 1, true) then
								writefile("KrakenHub_Expired_Keys.txt", hist .. "\n" .. currentKey)
							end
						end
						if delfile then
							delfile(KEY_FILE)
							delfile("KrakenHub_Key_Expiry.txt")
						elseif writefile then
							writefile(KEY_FILE, "")
							writefile("KrakenHub_Key_Expiry.txt", "0")
						end
					end)

					_G._KrakenKeyExpiry = 0
					_G._KrakenKeyVerified = false
					_G.KrakenKey = nil
					_KrakenKeyPassed = false

					-- ดีดปิดเมนูโกงทันทีและเปิดหน้าต่าง Key System ขึ้นมาใหม่
					task.delay(1.5, function()
						pcall(function()
							local CoreGui = game:GetService("CoreGui")
							if CoreGui:FindFirstChild("ScreenGui") then CoreGui.ScreenGui:Destroy() end
						end)

						pcall(function()
							loadstring(game:HttpGet("https://is.gd/KrakenHubV2"))()
						end)
					end)
					break
				else
					local days = math.floor(diff / 86400)
					local hours = math.floor((diff % 86400) / 3600)
					local mins = math.floor((diff % 3600) / 60)
					local secs = diff % 60
					if days > 0 then
						keyStatus.Text = string.format("🔑 เหลือ %d วัน %d ชม. %02d น.", days, hours, mins)
					elseif hours > 0 then
						keyStatus.Text = string.format("🔑 เหลือ %d ชม. %02d น. %02d วิ", hours, mins, secs)
					else
						keyStatus.Text = string.format("🔑 เหลือ %d น. %02d วิ", mins, secs)
					end
					keyStatus.TextColor3 = Color3.fromRGB(0, 230, 160)
				end
			else
				keyStatus.Text = "🔑 คีย์: เปิดใช้งาน (ตลอดชีพ)"
				keyStatus.TextColor3 = Color3.fromRGB(0, 230, 160)
			end
			task.wait(1)
		end
	end)

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
	content.BackgroundColor3 = Color3.fromRGB(18, 19, 21)
	content.BackgroundTransparency = 0
	content.BorderColor3 = Color3.fromRGB(0, 0, 0)
	content.BorderSizePixel = 0
	content.Position = UDim2.fromScale(1, 4.69e-08)
	content.Size = UDim2.new(0, (base.AbsoluteSize.X - sidebar.AbsoluteSize.X), 1, 0)
	content.ClipsDescendants = true

	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 12)
	contentCorner.Parent = content

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

	-- ==============================================================
	-- 🚀 UNIVERSAL EMPTY-SPACE DRAGGING & CORNER RESIZE ENGINE (PC & MOBILE)
	-- ==============================================================
	local dragging_ = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	local resizingBase = false
	local resizeStart = nil
	local startBaseSize = nil
	local resizeInput = nil

	local function update(input)
		if not dragging_ or not dragStart or not startPos then return end
		local scale = (baseUIScale and baseUIScale.Scale) or 1
		local delta = (input.Position - dragStart) / scale
		base.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	local function ConnectDragZone(btn)
		btn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if resizingBase then return end
				dragging_ = true
				dragStart = input.Position
				startPos = base.Position

				local endConn = nil
				endConn = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging_ = false
						if endConn then endConn:Disconnect() end
					end
				end)
			end
		end)
		btn.InputChanged:Connect(function(input)
			if dragging_ and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				dragInput = input
			end
		end)
	end

	-- 1. Base background drag zone (ZIndex = 0: catches any click/touch on blank areas of Base)
	local baseDrag = Instance.new("TextButton")
	baseDrag.Name = "BaseDragZone"
	baseDrag.Text = ""
	baseDrag.AutoButtonColor = false
	baseDrag.BackgroundTransparency = 1
	baseDrag.Size = UDim2.fromScale(1, 1)
	baseDrag.ZIndex = 0
	baseDrag.Parent = base
	ConnectDragZone(baseDrag)

	-- 2. Topbar drag zone (ZIndex = 1: empty header area above cards)
	local topbarDrag = Instance.new("TextButton")
	topbarDrag.Name = "TopbarDragZone"
	topbarDrag.Text = ""
	topbarDrag.AutoButtonColor = false
	topbarDrag.BackgroundTransparency = 1
	topbarDrag.Size = UDim2.fromScale(1, 1)
	topbarDrag.ZIndex = 1
	topbarDrag.Parent = topbar
	ConnectDragZone(topbarDrag)

	-- 3. Sidebar header drag zone (TitleFrame in Sidebar)
	if informationHolder then
		local sidebarDrag = Instance.new("TextButton")
		sidebarDrag.Name = "SidebarDragZone"
		sidebarDrag.Text = ""
		sidebarDrag.AutoButtonColor = false
		sidebarDrag.BackgroundTransparency = 1
		sidebarDrag.Size = UDim2.fromScale(1, 1)
		sidebarDrag.ZIndex = 1
		sidebarDrag.Parent = informationHolder
		ConnectDragZone(sidebarDrag)
	end

	-- 4. MoveIcon interact button
	ConnectDragZone(interact)

	-- Global input tracking for smooth window drag
	UserInputService.InputChanged:Connect(function(input)
		if dragging_ and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging_ = false
		end
	end)

	-- 📐 CORNER RESIZE HANDLE (มุมขอบล่างขวา - TextButton ZIndex 100 รองรับทั้งเมาส์และทัชสกรีน)
	local resizeHandle = Instance.new("TextButton")
	resizeHandle.Name = "ResizeHandle"
	resizeHandle.Text = ""
	resizeHandle.AutoButtonColor = false
	resizeHandle.AnchorPoint = Vector2.new(1, 1)
	resizeHandle.Position = UDim2.fromScale(1, 1)
	resizeHandle.Size = UDim2.fromOffset(38, 38)
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.ZIndex = 100
	resizeHandle.Parent = base

	local gripLines = Instance.new("Frame")
	gripLines.Name = "GripLines"
	gripLines.AnchorPoint = Vector2.new(1, 1)
	gripLines.Position = UDim2.new(1, -5, 1, -5)
	gripLines.Size = UDim2.fromOffset(18, 18)
	gripLines.BackgroundTransparency = 1
	gripLines.ZIndex = 101
	gripLines.Parent = resizeHandle

	local gripBars = {}
	local barOffsets = { {4, 4}, {8, 8}, {12, 12} }
	for idx, offset in ipairs(barOffsets) do
		local bar = Instance.new("Frame")
		bar.Name = "Bar" .. idx
		bar.AnchorPoint = Vector2.new(1, 1)
		bar.Position = UDim2.new(1, -offset[1] + 3, 1, -offset[2] + 3)
		bar.Size = UDim2.fromOffset(3.2, 3.2)
		bar.BackgroundColor3 = Color3.fromRGB(0, 195, 255)
		bar.BackgroundTransparency = 0.45
		bar.BorderSizePixel = 0
		bar.ZIndex = 102
		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(1, 0)
		bc.Parent = bar
		bar.Parent = gripLines
		table.insert(gripBars, bar)
	end

	local function GetMinMaxBounds()
		local vp = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
		local minW = 460
		local minH = 320
		if IsMobile or vp.X < 850 or vp.Y < 600 then
			minW = 340
			minH = 240
		end
		local maxW = math.max(minW, vp.X - 16)
		local maxH = math.max(minH, vp.Y - 16)
		return minW, minH, maxW, maxH
	end

	local function DoResize(input)
		if not resizingBase or not resizeStart or not startBaseSize then return end
		local scale = (baseUIScale and baseUIScale.Scale) or 1
		local delta = (input.Position - resizeStart) / scale
		local minW, minH, maxW, maxH = GetMinMaxBounds()

		local newW = math.clamp(startBaseSize.X + delta.X, minW, maxW)
		local newH = math.clamp(startBaseSize.Y + delta.Y, minH, maxH)

		base.Size = UDim2.fromOffset(newW, newH)
		content.Size = UDim2.new(0, math.max(80, newW - sidebar.AbsoluteSize.X), 1, 0)
	end

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizingBase = true
			resizeStart = input.Position
			startBaseSize = Vector2.new(base.AbsoluteSize.X, base.AbsoluteSize.Y)

			for _, bar in ipairs(gripBars) do
				Tween(bar, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
					BackgroundTransparency = 0,
					Size = UDim2.fromOffset(4.5, 4.5)
				}):Play()
			end

			local endConn = nil
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizingBase = false
					for _, bar in ipairs(gripBars) do
						Tween(bar, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
							BackgroundTransparency = 0.45,
							Size = UDim2.fromOffset(3.2, 3.2)
						}):Play()
					end
					if endConn then endConn:Disconnect() end
				end
			end)
		end
	end)

	resizeHandle.InputChanged:Connect(function(input)
		if resizingBase and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			resizeInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizingBase and (input == resizeInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			DoResize(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if resizingBase then
				resizingBase = false
				for _, bar in ipairs(gripBars) do
					Tween(bar, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
						BackgroundTransparency = 0.45,
						Size = UDim2.fromOffset(3.2, 3.2)
					}):Play()
				end
			end
		end
	end)

	resizeHandle.MouseEnter:Connect(function()
		for _, bar in ipairs(gripBars) do
			Tween(bar, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
				BackgroundTransparency = 0.15,
				Size = UDim2.fromOffset(4, 4)
			}):Play()
		end
	end)
	resizeHandle.MouseLeave:Connect(function()
		if not resizingBase then
			for _, bar in ipairs(gripBars) do
				Tween(bar, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
					BackgroundTransparency = 0.45,
					Size = UDim2.fromOffset(3.2, 3.2)
				}):Play()
			end
		end
	end)

	local currentTab = Instance.new("TextLabel")
	currentTab.Name = "CurrentTab"
	currentTab.FontFace = Font.new(assets.interFont)
	currentTab.RichText = true
	currentTab.Text = ""
	currentTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.TextSize = 18
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
			tabSwitcherUICorner.CornerRadius = UDim.new(0, 8)
			tabSwitcherUICorner.Parent = tabSwitcher

			local tabSwitcherGradient = Instance.new("UIGradient")
			tabSwitcherGradient.Name = "TabSwitcherGradient"
			tabSwitcherGradient.Rotation = 90
			tabSwitcherGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 42, 50)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 33))
			})
			tabSwitcherGradient.Enabled = false
			tabSwitcherGradient.Parent = tabSwitcher

			local tabSwitcherUIStroke = Instance.new("UIStroke")
			tabSwitcherUIStroke.Name = "TabSwitcherUIStroke"
			tabSwitcherUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			tabSwitcherUIStroke.Color = Color3.fromRGB(255, 255, 255)
			tabSwitcherUIStroke.Transparency = 1
			tabSwitcherUIStroke.Thickness = 1
			tabSwitcherUIStroke.Parent = tabSwitcher

			local tabSwitcherUIListLayout = Instance.new("UIListLayout")
			tabSwitcherUIListLayout.Name = "TabSwitcherUIListLayout"
			tabSwitcherUIListLayout.Padding = UDim.new(0, 9)
			tabSwitcherUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			tabSwitcherUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabSwitcherUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			tabSwitcherUIListLayout.Parent = tabSwitcher

			local tabImage
			local tabEmoji
			local tabLabelText = Settings.Name or ""

			if Settings.Image and Settings.Image ~= "" then
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
			elseif tabLabelText:sub(1, 4) == "🎃" then
				tabLabelText = tabLabelText:sub(5):gsub("^%s+", "")
				tabEmoji = Instance.new("TextLabel")
				tabEmoji.Name = "TabEmoji"
				tabEmoji.Text = "🎃"
				tabEmoji.TextSize = 17
				tabEmoji.TextTransparency = 0.45
				tabEmoji.BackgroundTransparency = 1
				tabEmoji.BorderSizePixel = 0
				tabEmoji.Size = UDim2.fromOffset(18, 18)
				tabEmoji.TextXAlignment = Enum.TextXAlignment.Center
				tabEmoji.TextYAlignment = Enum.TextYAlignment.Center
				tabEmoji.Parent = tabSwitcher
			else
				local tabSpacer = Instance.new("Frame")
				tabSpacer.Name = "TabSpacer"
				tabSpacer.BackgroundTransparency = 1
				tabSpacer.BorderSizePixel = 0
				tabSpacer.Size = UDim2.fromOffset(18, 18)
				tabSpacer.Parent = tabSwitcher
			end

			local tabSwitcherName = Instance.new("TextLabel")
			tabSwitcherName.Name = "TabSwitcherName"
			tabSwitcherName.FontFace = Font.new(
				assets.interFont,
				Enum.FontWeight.Medium,
				Enum.FontStyle.Normal
			)
			tabSwitcherName.Text = tabLabelText
			tabSwitcherName.RichText = true
			tabSwitcherName.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.TextSize = 17
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
				section.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
				section.BackgroundTransparency = 0
				section.BorderColor3 = Color3.fromRGB(0, 0, 0)
				section.BorderSizePixel = 0
				section.Position = UDim2.fromScale(0, 6.78e-08)
				section.Size = UDim2.fromScale(1, 0)
				section.ClipsDescendants = false
				section.Parent = Settings.Side == "Left" and left or right

				local sectionGradient = Instance.new("UIGradient")
				sectionGradient.Name = "SectionGradient"
				sectionGradient.Rotation = 90
				sectionGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 27, 30)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 23, 26))
				})
				sectionGradient.Parent = section

				local sectionUICorner = Instance.new("UICorner")
				sectionUICorner.Name = "SectionUICorner"
				sectionUICorner.CornerRadius = UDim.new(0, 8)
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
				sectionUIPadding.PaddingBottom = UDim.new(0, 14)
				sectionUIPadding.PaddingLeft = UDim.new(0, 16)
				sectionUIPadding.PaddingRight = UDim.new(0, 16)
				sectionUIPadding.PaddingTop = UDim.new(0, 14)
				sectionUIPadding.Parent = section

				function SectionFunctions:Button(Settings, Flag)
					local ButtonFunctions = {Settings = Settings}
					local button = Instance.new("Frame")
					button.Name = "Button"
					button.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
					button.BackgroundTransparency = 0
					button.BorderColor3 = Color3.fromRGB(0, 0, 0)
					button.BorderSizePixel = 0
					button.Size = UDim2.new(1, 0, 0, 32)
					button.Parent = section

					local buttonCorner = Instance.new("UICorner")
					buttonCorner.CornerRadius = UDim.new(0, 6)
					buttonCorner.Parent = button

					local buttonStroke = Instance.new("UIStroke")
					buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					buttonStroke.Color = Color3.fromRGB(255, 255, 255)
					buttonStroke.Transparency = 0.92
					buttonStroke.Thickness = 1
					buttonStroke.Parent = button

					local buttonIcon = Instance.new("ImageLabel")
					buttonIcon.Name = "ButtonIcon"
					buttonIcon.Image = assets.grid
					buttonIcon.ImageColor3 = Color3.fromRGB(115, 117, 126)
					buttonIcon.ImageTransparency = 0.2
					buttonIcon.AnchorPoint = Vector2.new(1, 0.5)
					buttonIcon.Position = UDim2.new(1, -10, 0.5, 0)
					buttonIcon.Size = UDim2.fromOffset(13, 13)
					buttonIcon.BackgroundTransparency = 1
					buttonIcon.BorderSizePixel = 0
					buttonIcon.Parent = button

					local buttonInteract = Instance.new("TextButton")
					buttonInteract.Name = "ButtonInteract"
					buttonInteract.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					buttonInteract.RichText = true
					buttonInteract.TextColor3 = Color3.fromRGB(225, 228, 235)
					buttonInteract.TextSize = 14
					buttonInteract.TextTransparency = 0
					buttonInteract.TextTruncate = Enum.TextTruncate.AtEnd
					buttonInteract.TextXAlignment = Enum.TextXAlignment.Left
					buttonInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.BackgroundTransparency = 1
					buttonInteract.BorderSizePixel = 0
					buttonInteract.Position = UDim2.new(0, 14, 0, 0)
					buttonInteract.Size = UDim2.new(1, -38, 1, 0)
					buttonInteract.Parent = button
					buttonInteract.Text = ButtonFunctions.Settings.Name

					local function Callback()
						if ButtonFunctions.Settings.Callback then
							ButtonFunctions.Settings.Callback()
						end
					end

					buttonInteract.MouseEnter:Connect(function()
						Tween(button, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							BackgroundColor3 = Color3.fromRGB(34, 36, 42)
						}):Play()
						Tween(buttonStroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							Transparency = 0.82
						}):Play()
					end)
					buttonInteract.MouseLeave:Connect(function()
						Tween(button, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							BackgroundColor3 = Color3.fromRGB(24, 25, 28)
						}):Play()
						Tween(buttonStroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
							Transparency = 0.90
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
					toggleName.TextColor3 = Color3.fromRGB(225, 228, 235)
					toggleName.TextSize = 14.5
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
					toggle1.BackgroundColor3 = Color3.fromRGB(53, 54, 61)
					toggle1.BorderSizePixel = 0
					toggle1.Position = UDim2.new(1, 0, 0.5, 0)
					toggle1.Size = UDim2.fromOffset(34, 18)
					toggle1.Parent = toggle

					local toggle1Corner = Instance.new("UICorner")
					toggle1Corner.CornerRadius = UDim.new(1, 0)
					toggle1Corner.Parent = toggle1

					local toggle1Stroke = Instance.new("UIStroke")
					toggle1Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					toggle1Stroke.Color = Color3.fromRGB(255, 255, 255)
					toggle1Stroke.Transparency = 0.95
					toggle1Stroke.Thickness = 1
					toggle1Stroke.Parent = toggle1

					local togglerHead = Instance.new("Frame")
					togglerHead.Name = "TogglerHead"
					togglerHead.AnchorPoint = Vector2.new(0.5, 0.5)
					togglerHead.BackgroundColor3 = Color3.fromRGB(40, 41, 47)
					togglerHead.BorderSizePixel = 0
					togglerHead.Position = UDim2.new(0, 9, 0.5, 0)
					togglerHead.Size = UDim2.fromOffset(12, 12)
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
						local targetPos = State and UDim2.new(1, -9, 0.5, 0) or UDim2.new(0, 9, 0.5, 0)
						local targetBg = State and Color3.fromRGB(225, 42, 45) or Color3.fromRGB(53, 54, 61)
						local targetHeadColor = State and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 41, 47)
						local targetStrokeColor = State and Color3.fromRGB(255, 75, 80) or Color3.fromRGB(255, 255, 255)
						local targetStrokeTrans = State and 0.85 or 0.95

						Tween(togglerHead, tweenInfo, {
							Position = targetPos,
							BackgroundColor3 = targetHeadColor
						}):Play()
						Tween(toggle1, tweenInfo, {
							BackgroundColor3 = targetBg
						}):Play()
						Tween(toggle1Stroke, tweenInfo, {
							Color = targetStrokeColor,
							Transparency = targetStrokeTrans
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
					sliderName.TextColor3 = Color3.fromRGB(225, 228, 235)
					sliderName.TextSize = 14.5
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
					sliderValue.TextColor3 = Color3.fromRGB(215, 218, 225)
					sliderValue.TextSize = 13
					sliderValue.TextTransparency = 0
					sliderValue.AnchorPoint = Vector2.new(1, 0.5)
					sliderValue.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
					sliderValue.BackgroundTransparency = 0
					sliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderValue.BorderSizePixel = 0
					sliderValue.Position = UDim2.new(1, 0, 0.5, 0)
					sliderValue.Size = UDim2.fromOffset(42, 22)
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
					sliderBar.BackgroundColor3 = Color3.fromRGB(56, 57, 64)
					sliderBar.BackgroundTransparency = 0
					sliderBar.BorderSizePixel = 0
					sliderBar.Position = UDim2.new(0, 0, 0.5, 0)
					sliderBar.Size = UDim2.new(1, -44, 0, 3)
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
					sliderHead.Size = UDim2.fromOffset(10, 10)
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
					inputName.TextSize = 14.5
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
					inputBox.TextSize = 13.5
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
					keybindName.TextSize = 14.5
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
					binderBox.TextSize = 13.5
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

					UserInputService.InputBegan:Connect(function(inp, gpe)
						if gpe and not focused then return end
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
					dropdown.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
					dropdown.BackgroundTransparency = 0
					dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdown.BorderSizePixel = 0
					dropdown.Size = UDim2.new(1, 0, 0, 32)
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
					interact.Size = UDim2.new(1, 0, 0, 32)
					interact.Parent = dropdown

					local dropdownName = Instance.new("TextLabel")
					dropdownName.Name = "DropdownName"
					dropdownName.FontFace = Font.new(assets.interFont)
					dropdownName.Text = Settings.Default and (DropdownFunctions.Settings.Name .. " • " .. table.concat(Selected, ", ")) or (DropdownFunctions.Settings.Name .. "...")
					dropdownName.RichText = true
					dropdownName.TextColor3 = Color3.fromRGB(225, 228, 235)
					dropdownName.TextSize = 14
					dropdownName.TextTransparency = 0
					dropdownName.TextTruncate = Enum.TextTruncate.SplitWord
					dropdownName.TextXAlignment = Enum.TextXAlignment.Left
					dropdownName.AutomaticSize = Enum.AutomaticSize.Y
					dropdownName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownName.BackgroundTransparency = 1
					dropdownName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownName.BorderSizePixel = 0
					dropdownName.Size = UDim2.new(1, -20, 0, 32)
					dropdownName.Parent = dropdown

					local dropdownUIStroke = Instance.new("UIStroke")
					dropdownUIStroke.Name = "DropdownUIStroke"
					dropdownUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					dropdownUIStroke.Color = Color3.fromRGB(255, 255, 255)
					dropdownUIStroke.Transparency = 0.92
					dropdownUIStroke.Thickness = 1
					dropdownUIStroke.Parent = dropdown

					local dropdownUICorner = Instance.new("UICorner")
					dropdownUICorner.Name = "DropdownUICorner"
					dropdownUICorner.CornerRadius = UDim.new(0, 6)
					dropdownUICorner.Parent = dropdown

					local dropdownImage = Instance.new("ImageLabel")
					dropdownImage.Name = "DropdownImage"
					dropdownImage.Image = assets.grid
					dropdownImage.ImageColor3 = Color3.fromRGB(115, 117, 126)
					dropdownImage.ImageTransparency = 0.2
					dropdownImage.AnchorPoint = Vector2.new(1, 0.5)
					dropdownImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownImage.BackgroundTransparency = 1
					dropdownImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownImage.BorderSizePixel = 0
					dropdownImage.Position = UDim2.new(1, 0, 0, 16)
					dropdownImage.Size = UDim2.fromOffset(13, 13)
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
					dropdownFrameUIPadding.PaddingTop = UDim.new(0, 34)
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
							Rotation = isDropdownOpen and -90 or 0
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
						optionName.TextSize = 14.5
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

					local txt = HeaderFunctions.Settings.Text or HeaderFunctions.Settings.Name or ""
					if txt == "" or txt:match("^%s*$") then
						header.Visible = false
					end

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 3)
					uIPadding.Parent = header

					local headerText = Instance.new("TextLabel")
					headerText.Name = "HeaderText"
					headerText.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					headerText.RichText = true
					headerText.Text = txt
					headerText.TextColor3 = Color3.fromRGB(200, 203, 215)
					headerText.TextSize = 14.5
					headerText.TextTransparency = 0.2
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
						if New == "" or New:match("^%s*$") then
							header.Visible = false
						else
							header.Visible = true
						end
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
					paragraph.BackgroundColor3 = Color3.fromRGB(20, 21, 24)
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
					paraStroke.Transparency = 0.90
					paraStroke.Thickness = 1
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
					paragraphHeader.TextSize = 15
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
					paragraphBody.TextSize = 13.5
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
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = isCurrent and 0 or 1
					}):Play()

					local grad = i:FindFirstChild("TabSwitcherGradient")
					if grad then grad.Enabled = isCurrent end

					if tabInfo.tabStroke then
						Tween(tabInfo.tabStroke, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							Color = Color3.fromRGB(255, 255, 255),
							Transparency = isCurrent and 0.84 or 1
						}):Play()
					end
					if tabInfo.switcherImage then
						Tween(tabInfo.switcherImage, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							ImageTransparency = isCurrent and 0 or 0.45
						}):Play()
					end
					if tabInfo.switcherEmoji then
						Tween(tabInfo.switcherEmoji, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							TextTransparency = isCurrent and 0 or 0.45
						}):Play()
					end
					if tabInfo.switcherName then
						Tween(tabInfo.switcherName, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							TextTransparency = isCurrent and 0 or 0.45
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
					Placeholder = "ชื่อ",
					AcceptedCharacters = "All",
					Callback = function(input)
						inputPath = input
					end,
				})

				local configSelection = configSection:Dropdown({
					Name = "Select Config...",
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
			end

			tabs[tabSwitcher] = {
				tabContent = elements1,
				tabStroke = tabSwitcherUIStroke,
				switcherImage = tabImage,
				switcherEmoji = tabEmoji,
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
	local AltMenuKeybind = Enum.KeyCode.K

	local function ToggleMenu()
		local state = not WindowFunctions:GetState()
		WindowFunctions:SetState(state)
	end

	function WindowFunctions:SetKeybind(key)
		MenuKeybind = key
	end

	function WindowFunctions:GetKeybind()
		return MenuKeybind
	end

	function WindowFunctions:Toggle()
		ToggleMenu()
	end

	UserInputService.InputEnded:Connect(function(inp, gpe)
		if gpe then return end
		local match = false
		if MenuKeybind then
			if typeof(MenuKeybind) == "EnumItem" then
				if MenuKeybind.EnumType == Enum.KeyCode and inp.KeyCode == MenuKeybind then
					match = true
				elseif MenuKeybind.EnumType == Enum.UserInputType and inp.UserInputType == MenuKeybind then
					match = true
				end
			end
		end
		if not match and AltMenuKeybind and inp.KeyCode == AltMenuKeybind and MenuKeybind ~= Enum.KeyCode.K then
			match = true
		end
		if match then
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

local Window = MacLib:Window({
    Title = "KrakenHub",
    Subtitle = "สายเลือดอาชีวะ | v1.0",
    Size = UDim2.fromOffset(860, 600),
    DragStyle = 1,
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
        stroke.Name = "RainbowStroke"
        stroke.Color = Color3.fromRGB(0, 195, 255)
        stroke.Thickness = 1.9
        stroke.Transparency = 0
        stroke.Parent = mainBtn

        local rainbowConn = nil
        local lastRainbowTick = 0
        rainbowConn = RunService.Heartbeat:Connect(function()
            local now = tick()
            if now - lastRainbowTick < 0.08 then return end
            lastRainbowTick = now
            if not stroke or not stroke.Parent or not screenGui.Parent then
                if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
                return
            end
            local hue = (now * 0.35) % 1
            stroke.Color = Color3.fromHSV(hue, 0.85, 1)
        end)
        table.insert(Connections, rainbowConn)

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

        mainBtn.Activated:Connect(function()
            if not movedEnough then
                TweenService:Create(mainBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(42, 42)
                }):Play()
                task.wait(0.08)
                TweenService:Create(mainBtn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(48, 48)
                }):Play()

                if windowObj and windowObj.Minimize then
                    windowObj:Minimize()
                end
            end
        end)

        mainBtn.MouseEnter:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Thickness = 2.5 }):Play()
        end)
        mainBtn.MouseLeave:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.2), { Thickness = 1.9 }):Play()
        end)

        screenGui.Parent = targetGuiParent
        Hub.ToggleButtonGui = screenGui
    end)
end
CreateFloatingToggleButton(Window)

local tabGroup = Window:TabGroup()
local Options = {}
MacLib.Options = Options

local function CreateTabAdapter(rawTab, tabName)
    local leftSection = nil
    local rightSection = nil
    local currentSection = nil
    local side = "Left"

    local function getLeftSection()
        if not leftSection then
            leftSection = rawTab:Section({ Side = "Left" })
        end
        return leftSection
    end

    local function getRightSection()
        if not rightSection then
            rightSection = rawTab:Section({ Side = "Right" })
        end
        return rightSection
    end

    local function getCurrent()
        if not currentSection then
            currentSection = (side == "Right") and getRightSection() or getLeftSection()
        end
        return currentSection
    end

    local adapter = {
        RawTab = rawTab,
        Select = function(self)
            rawTab:Select()
        end,
        AddSection = function(self, title, preferredSide)
            if preferredSide then
                side = preferredSide
                if preferredSide == "Right" and not rightSection then
                    rightSection = rawTab:Section({ Side = "Right" })
                    currentSection = rightSection
                elseif preferredSide == "Left" and not leftSection then
                    leftSection = rawTab:Section({ Side = "Left" })
                    currentSection = leftSection
                else
                    currentSection = rawTab:Section({ Side = preferredSide })
                end
            elseif side == "Left" then
                side = "Right"
                currentSection = getRightSection()
            else
                side = "Left"
                currentSection = rawTab:Section({ Side = "Left" })
            end
            if title and title ~= "" then
                pcall(function() currentSection:Header({ Text = title }) end)
            end
            return currentSection
        end,
        AddParagraph = function(self, cfg, preferredSide)
            if preferredSide then
                if preferredSide == "Left" then
                    side = "Left"
                    currentSection = getLeftSection()
                else
                    side = "Right"
                    currentSection = getRightSection()
                end
            elseif tabName == "Player" and (cfg.Title and cfg.Title:find("ESP")) then
                side = "Right"
                currentSection = getRightSection()
            else
                currentSection = getCurrent()
            end

            local sec = currentSection or getCurrent()
            local para = sec:Paragraph({
                Header = cfg.Title or cfg.Header or "Paragraph",
                Body = cfg.Content or cfg.Body or ""
            })
            return {
                SetTitle = function(self, t) if para.UpdateHeader then para:UpdateHeader(t) end end,
                SetDesc = function(self, d) if para.UpdateBody then para:UpdateBody(d) end end
            }
        end,
        AddToggle = function(self, flag, cfg)
            local sec = currentSection or getCurrent()
            local macToggle = sec:Toggle({
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
            local sec = currentSection or getCurrent()
            local macSlider = sec:Slider({
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
            local sec = currentSection or getCurrent()
            local changedCb = cfg.Callback
            local macDropdown = sec:Dropdown({
                Name = cfg.Title or flag,
                Options = cfg.Values or {},
                Default = cfg.Default,
                Multi = cfg.Multi or false,
                Required = cfg.Required ~= false,
                Callback = function(v)
                    macDropdown.Value = v
                    if changedCb then pcall(changedCb, v) end
                    if macDropdown._onChanged then pcall(macDropdown._onChanged, v) end
                end
            }, flag)
            macDropdown.Value = cfg.Default or (cfg.Values and cfg.Values[1]) or ""
            local origOnChanged = macDropdown.OnChanged
            macDropdown.OnChanged = function(self, cb)
                self._onChanged = cb
                if origOnChanged then pcall(origOnChanged, self, cb) end
                return cb
            end
            local origSetValue = macDropdown.SetValue
            macDropdown.SetValue = function(self, val)
                if origSetValue then pcall(origSetValue, self, val) end
                self.Value = val
                if changedCb then pcall(changedCb, val) end
                if self._onChanged then pcall(self._onChanged, val) end
            end
            Options[flag] = macDropdown
            return macDropdown
        end,
        AddButton = function(self, cfg)
            local sec = currentSection or getCurrent()
            return sec:Button({
                Name = cfg.Title or cfg.Name or "Button",
                Callback = cfg.Callback
            })
        end,
        AddKeybind = function(self, flag, cfg)
            local sec = currentSection or getCurrent()
            local changedFn = cfg.ChangedCallback or cfg.OnChanged
            local keybindObj = nil
            local defaultKey = cfg.Default
            if typeof(defaultKey) == "string" and Enum.KeyCode[defaultKey] then
                defaultKey = Enum.KeyCode[defaultKey]
            end

            local macKeybind = sec:Keybind({
                Name = cfg.Title or flag,
                Default = defaultKey,
                Callback = cfg.Callback,
                onBinded = function(newKey)
                    if keybindObj then
                        keybindObj.Value = newKey
                        if keybindObj._onChanged then
                            pcall(keybindObj._onChanged, newKey)
                        end
                    end
                    if changedFn then
                        pcall(changedFn, newKey)
                    end
                end
            }, flag)
            macKeybind.Value = defaultKey
            macKeybind.OnChanged = function(self, cb)
                self._onChanged = cb
                return cb
            end
            macKeybind.SetValue = function(self, key)
                if typeof(key) == "string" and Enum.KeyCode[key] then key = Enum.KeyCode[key] end
                macKeybind:Bind(key)
                macKeybind.Value = key
                if self._onChanged then pcall(self._onChanged, key) end
                if changedFn then pcall(changedFn, key) end
            end
            keybindObj = macKeybind
            Options[flag] = macKeybind
            return macKeybind
        end,
        AddInput = function(self, flag, cfg)
            local sec = currentSection or getCurrent()
            local macInput = sec:Input({
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
    Halloween = CreateTabAdapter(tabGroup:Tab({ Name = "🎃 อีเวนต์" }), "Halloween"),
    Merchant  = CreateTabAdapter(tabGroup:Tab({ Name = "พ่อค้าพเนจร", Image = "rbxassetid://10734952479" }), "Merchant"),
    Combat    = CreateTabAdapter(tabGroup:Tab({ Name = "ระบบต่อสู้",   Image = "rbxassetid://10709818534" }), "Combat"),
    Player    = CreateTabAdapter(tabGroup:Tab({ Name = "ตัวละคร",     Image = "rbxassetid://10747373176" }), "Player"),
    Police    = CreateTabAdapter(tabGroup:Tab({ Name = "ตำรวจ",       Image = "rbxassetid://10734951847" }), "Police"),
    Settings  = CreateTabAdapter(tabGroup:Tab({ Name = "ตั้งค่า",       Image = "rbxassetid://10734950309" }), "Settings")
}

function Window:SelectTab(idx)
    if idx == 1 and Tabs.Farm then Tabs.Farm:Select()
    elseif idx == 2 and Tabs.Halloween then Tabs.Halloween:Select()
    elseif idx == 3 and Tabs.Merchant then Tabs.Merchant:Select()
    elseif idx == 4 and Tabs.Combat then Tabs.Combat:Select()
    elseif idx == 5 and Tabs.Player then Tabs.Player:Select()
    elseif idx == 6 and Tabs.Police then Tabs.Police:Select()
    elseif idx == 7 and Tabs.Settings then Tabs.Settings:Select()
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

local function SafeVIMMouseButton(x, y, btn, isDown)
    if VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(x or 0, y or 0, btn or 0, isDown, game, 0)
        end)
    end
end

local function SafeVIMMouseMove(x, y)
    if VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendMouseMoveEvent(x or 0, y or 0, game)
        end)
    end
end

local function SafeVIMKeyEvent(isDown, keyCode)
    if VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendKeyEvent(isDown, keyCode or Enum.KeyCode.E, false, game)
        end)
    end
end

local function ReleaseVIM()
    if isVIMHolding then
        isVIMHolding = false
        SafeVIMMouseButton(0, 0, 0, false)
    end
    pcall(function()
        local char = LocalPlayer.Character
        local crouching = char and char:FindFirstChild("Crouching")
        if crouching then crouching:SetAttribute("BlockCrouch", false) end
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        if pgui and pgui:FindFirstChild("RunSystem") then
            pgui.RunSystem:SetAttribute("BlockStamina", false)
        end
        local mgUI = pgui and pgui:FindFirstChild("MiniGameUI")
        if mgUI then
            local tf = mgUI:FindFirstChild("TrashFrame")
            if tf then tf.Visible = false end
            mgUI.Enabled = false
        end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local anim = hum and hum:FindFirstChildOfClass("Animator")
        if anim then
            for _, t in ipairs(anim:GetPlayingAnimationTracks()) do
                t:Stop()
            end
        end
    end)
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

        if doneRemote then
            Connections.MiniGameDoneConn = doneRemote.OnClientEvent:Connect(function()
                serverWorkingUntil = 0
                if activeMiniGame then
                    activeMiniGame.completed = true
                end
            end)
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



        local cachedTrashHB = nil
        local cachedU80Idx = nil
        local cachedU79Idx = nil

        local function FeedMinigameclientTrash(posX, posY)
            if typeof(getconnections) ~= "function" or typeof(debug.getupvalues) ~= "function" or typeof(debug.setupvalue) ~= "function" then
                return false
            end
            if cachedTrashHB and cachedU80Idx and cachedU79Idx then
                pcall(debug.setupvalue, cachedTrashHB, cachedU80Idx, true)
                pcall(debug.setupvalue, cachedTrashHB, cachedU79Idx, Vector2.new(posX, posY))
                return true
            end
            for _, c in ipairs(getconnections(RunService.Heartbeat)) do
                local fn = c.Function
                if fn then
                    local s, ups = pcall(debug.getupvalues, fn)
                    if s and type(ups) == "table" then
                        local foundTargetsTable = false
                        local u80Candidate = nil
                        local u79Candidate = nil
                        for idx, val in pairs(ups) do
                            if type(val) == "table" and #val == 4 and type(val[1]) == "table" and val[1].inst and val[1].progress ~= nil then
                                foundTargetsTable = true
                            elseif type(val) == "boolean" and u80Candidate == nil then
                                u80Candidate = idx
                            elseif (typeof(val) == "Vector2" or val == nil) and u79Candidate == nil and idx > 8 then
                                u79Candidate = idx
                            end
                        end
                        if foundTargetsTable then
                            cachedTrashHB = fn
                            cachedU80Idx = u80Candidate or 10
                            cachedU79Idx = u79Candidate or 11
                            pcall(debug.setupvalue, fn, cachedU80Idx, true)
                            pcall(debug.setupvalue, fn, cachedU79Idx, Vector2.new(posX, posY))
                            return true
                        end
                    end
                end
            end
            return false
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
                    TrashDigSite = 33.5,
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

                if siteType == "TrashDigSite" then
                    task.spawn(function()
                        local trashRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("ขยะ")
                        local digProgress = trashRS and trashRS:FindFirstChild("TrashDigProgress")
                        local digResult = trashRS and trashRS:FindFirstChild("DigResult")

                        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                        local mgUI = pgui and pgui:FindFirstChild("MiniGameUI")
                        local tf = mgUI and mgUI:FindFirstChild("TrashFrame")
                        local darkBox = tf and tf:FindFirstChild("DarkBox")
                        local counterLabel = darkBox and darkBox:FindFirstChild("CounterBg") and darkBox.CounterBg:FindFirstChild("CounterLabel")
                        local soundFolder = mgUI and mgUI:FindFirstChild("Sound") and mgUI.Sound:FindFirstChild("เก็บขยะ")
                        local seSound = soundFolder and soundFolder:FindFirstChild("Se")
                        local succSound = soundFolder and soundFolder:FindFirstChild("Success")

                        -- ล็อคตัวละครนิ่งสนิทระหว่างคุ้ยขยะ ป้องกันตกหล่นหรือเดินหนีจุด
                        local hrp = GetHRP()
                        local hum = GetHuman()
                        if hum then hum.WalkSpeed = 0 end
                        if hrp then
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end

                        -- รอให้ DarkBox สร้าง Target ครบ 4 จุด
                        local targetList = {}
                        local waitStart = tick()
                        while (tick() - waitStart) < 3.5 and State.Running and State.AutoSolveMinigame do
                            targetList = {}
                            if darkBox then
                                for _, c in ipairs(darkBox:GetChildren()) do
                                    if c.Name == "Target" and c:IsA("GuiObject") then
                                        table.insert(targetList, c)
                                    end
                                end
                            end
                            if #targetList >= 4 then break end
                            task.wait(0.08)
                        end

                        local light = darkBox and darkBox:FindFirstChild("Light")
                        local litPorthole = darkBox and darkBox:FindFirstChild("LitPorthole")
                        if light then light.Visible = true end
                        if litPorthole then litPorthole.Visible = true end

                        -- เริ่มจับเวลาและคุ้ยทีละจุดอย่างแม่นยำ (จุดละ ~8.0 วินาที, รวม ~32.5 วินาที)
                        for itemIdx = 1, math.max(4, #targetList) do
                            if not State.Running or not State.AutoSolveMinigame or session.completed then break end

                            local targetGui = targetList[itemIdx]
                            local itemStart = tick()
                            local itemDuration = 8.0
                            local pBar = targetGui and targetGui:FindFirstChild("ProgressBarBg")
                            local pFill = pBar and pBar:FindFirstChild("BarFill")
                            local icon = targetGui and targetGui:FindFirstChild("Icon")
                            local glow = targetGui and targetGui:FindFirstChild("GlowRing")

                            while (tick() - itemStart) < itemDuration and State.Running and State.AutoSolveMinigame and not session.completed do
                                if targetGui and darkBox then
                                    local tPosX = targetGui.AbsolutePosition.X + targetGui.AbsoluteSize.X / 2
                                    local tPosY = targetGui.AbsolutePosition.Y + targetGui.AbsoluteSize.Y / 2

                                    -- ฟีดพิกัดตรงเข้า Heartbeat ของเกม Minigameclient
                                    FeedMinigameclientTrash(tPosX, tPosY)

                                    -- อัปเดตไฟฉายบนจอให้แสดงผลสมบูรณ์
                                    local absPos = darkBox.AbsolutePosition
                                    local absSize = darkBox.AbsoluteSize
                                    if absSize.X > 0 and absSize.Y > 0 then
                                        local rel = UDim2.fromScale((tPosX - absPos.X) / absSize.X, (tPosY - absPos.Y) / absSize.Y)
                                        if light then light.Position = rel light.Visible = true end
                                        if litPorthole then litPorthole.Position = rel litPorthole.Visible = true end
                                    end

                                    SafeVIMMouseMove(tPosX, tPosY)
                                    if not isVIMHolding then
                                        local catcher = darkBox:FindFirstChild("InputCatcher")
                                        if catcher and typeof(firesignal) == "function" then
                                            pcall(function() firesignal(catcher.MouseButton1Down) end)
                                        end
                                        SafeVIMMouseButton(tPosX, tPosY, 0, true)
                                        isVIMHolding = true
                                    end
                                end

                                local subElapsed = tick() - itemStart
                                if subElapsed >= 2.0 and pBar and pFill then
                                    pBar.Visible = true
                                    local pct = math.clamp((subElapsed - 2.0) / 5.8, 0, 1)
                                    pFill.Size = UDim2.new(pct, 0, 1, 0)
                                end

                                if session.key and inputRemote then
                                    pcall(function() inputRemote:FireServer(session.key) end)
                                end

                                -- ตรวจจับว่าเกมทำจุดนี้เสร็จแล้วหรือไม่ (ไอคอนเปลี่ยนเป็นเขียว)
                                if icon and icon.ImageColor3 == Color3.fromRGB(120, 220, 140) and subElapsed >= 7.0 then
                                    break
                                end

                                task.wait(0.08)
                            end

                            -- ตรวจสอบความสมบูรณ์ของจุดที่ itemIdx
                            if targetGui then
                                if pBar then pBar.Visible = false end
                                if icon then
                                    icon.ImageTransparency = 0
                                    icon.ImageColor3 = Color3.fromRGB(120, 220, 140)
                                end
                                if glow then
                                    glow.BackgroundTransparency = 0.5
                                    glow.BackgroundColor3 = Color3.fromRGB(120, 220, 140)
                                end
                            end

                            if seSound then pcall(function() seSound:Play() end) end
                            if digProgress and session.siteInstance then
                                pcall(function() digProgress:FireServer(session.siteInstance) end)
                            end
                            if counterLabel then
                                counterLabel.Text = itemIdx .. " / 4"
                            end
                            task.wait(0.12)
                        end

                        task.wait(0.2)
                        if succSound then pcall(function() succSound:Play() end) end
                        if digResult then
                            pcall(function() digResult:FireServer(true) end)
                        end

                        -- หน่วงเวลาให้รอบทั้งหมดครบเกณฑ์เซิร์ฟเวอร์ (~32.5 วินาที)
                        local elapsed = tick() - session.startTime
                        if elapsed < 32.5 then
                            task.wait(32.5 - elapsed)
                        end

                        session.completed = true
                        pcall(function()
                            if doneRemote and session.siteInstance then
                                doneRemote:FireServer("TrashDigSite", session.siteInstance)
                            end
                            local trashDone = trashRS and trashRS:FindFirstChild("MiniGameDone")
                            if trashDone and session.siteInstance then
                                trashDone:FireServer("TrashDigSite", session.siteInstance)
                            end
                            if tf then tf.Visible = false end
                            if mgUI then mgUI.Enabled = false end
                        end)
                        ReleaseVIM()
                    end)
                else
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
                end
            end)
        end
    end
end)

-- ควบคุมเมาส์จำลอง VIM & UI Visuals ให้เป็นธรรมชาติ 100%
local lastMinigameHoldTick = 0
Connections.MinigameHoldLoop = RunService.Heartbeat:Connect(function()
    if not State.AutoSolveMinigame or not State.Running then
        if isVIMHolding then ReleaseVIM() end
        return
    end

    local now = os.clock()
    -- หน่วงเวลา 30 Hz ประหยัด CPU สูงสุด ไม่หน่วงเฟรมเรต
    if now - lastMinigameHoldTick < 0.033 then return end
    lastMinigameHoldTick = now

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
        local darkBox = tf and tf:FindFirstChild("DarkBox")

        -- ค้นหาเป้าหมายคุ้ยขยะที่ยังทำไม่เสร็จ (Target ที่ยังไม่เปลี่ยนเป็นสีเขียว 120, 220, 140)
        local trashTarget = nil
        if darkBox then
            for _, child in ipairs(darkBox:GetChildren()) do
                if child.Name == "Target" and child:IsA("GuiObject") then
                    local icon = child:FindFirstChild("Icon")
                    if icon and icon:IsA("ImageLabel") then
                        if icon.ImageColor3.R > 0.6 or icon.ImageColor3 ~= Color3.fromRGB(120, 220, 140) then
                            trashTarget = child
                            break
                        end
                    end
                end
            end
        end

        local needsHold = (wf and wf.Visible) or (df and df.Visible) or (sf and sf.Visible) or (sw and sw.Visible) or (efOil and efOil.Visible) or (trashTarget ~= nil)
        if needsHold then
            local targetBtn = (wf and wf.Visible and wf:FindFirstChild("WeldBtn"))
                           or (df and df.Visible and (df:FindFirstChild("DrillBtn") or df:FindFirstChild("WeldBtn")))
                           or (sf and sf.Visible and sf:FindFirstChild("FloorBg"))
                           or (sw and sw.Visible and sw:FindFirstChild("FloorBg"))
                           or (efOil and efOil.Visible and efOil:FindFirstChild("OilBtn"))
                           or trashTarget
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

            if trashTarget then
                SafeVIMMouseMove(posX, posY)
                pcall(FeedMinigameclientTrash, posX, posY)
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    local catcher = darkBox:FindFirstChild("InputCatcher")
                    if catcher and typeof(firesignal) == "function" then
                        pcall(function() firesignal(catcher.MouseButton1Down) end)
                    end
                    SafeVIMMouseButton(posX, posY, 0, true)
                    isVIMHolding = true
                end
            else
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    SafeVIMMouseButton(posX, posY, 0, true)
                    isVIMHolding = true
                end
            end

            if (sf and sf.Visible) or (sw and sw.Visible) then
                local floor = (sf and sf.Visible and sf:FindFirstChild("FloorBg")) or (sw and sw.Visible and sw:FindFirstChild("FloorBg"))
                if floor then
                    local absPos = floor.AbsolutePosition
                    local absSize = floor.AbsoluteSize
                    local sweepT = tick() * 14
                    local moveX = absPos.X + absSize.X * (0.5 + 0.42 * math.sin(sweepT))
                    local moveY = absPos.Y + absSize.Y * (0.5 + 0.35 * math.cos(sweepT * 1.5))
                    SafeVIMMouseMove(moveX, moveY)
                end
            end
        else
            if isVIMHolding then ReleaseVIM() end
        end
    else
        if isVIMHolding then ReleaseVIM() end
    end
end)

-- ตอกตะปู / ล้อรถ / น็อตเครื่องยนต์ / เทน้ำมัน
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
                                        SafeVIMMouseButton(bx, by, 0, true)
                                        task.wait(0.04)
                                        SafeVIMMouseButton(bx, by, 0, false)
                                    end
                                end)
                                task.wait(0.18)
                                break
                            end
                        end
                    end
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
                                    SafeVIMMouseButton(bx, by, 0, true)
                                    task.wait(0.04)
                                    SafeVIMMouseButton(bx, by, 0, false)
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
                                        SafeVIMMouseButton(bx, by, 0, true)
                                        task.wait(0.04)
                                        SafeVIMMouseButton(bx, by, 0, false)
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

            -- ⚰️ มินิเกมขุด/ทุบหลุมศพฮาโลวีน (DragUI รางลูกกลม & QTE ผี)
            local graveUI = pgui and pgui:FindFirstChild("GraveUI")
            if graveUI and graveUI.Enabled and not (ActiveGrave and ActiveGrave.active and State.AutoGraveQTE) then
                local dragUI = graveUI:FindFirstChild("DragUI")
                if dragUI and dragUI.Visible then
                    local knob = dragUI:FindFirstChild("DragKnob") or dragUI:FindFirstChildWhichIsA("TextButton")
                    local holder = nil
                    for _, c in ipairs(dragUI:GetChildren()) do
                        if c:IsA("Frame") and c.Visible then
                            holder = c
                            break
                        end
                    end

                    if knob and holder then
                        local startPos = knob.AbsolutePosition + knob.AbsoluteSize / 2
                        local targetPos = nil
                        local maxDist = 0

                        for _, ch in ipairs(holder:GetChildren()) do
                            if ch:IsA("Frame") then
                                local cp = ch.AbsolutePosition + ch.AbsoluteSize / 2
                                local dist = (cp - startPos).Magnitude
                                if dist > maxDist then
                                    maxDist = dist
                                    targetPos = cp
                                end
                            end
                        end

                        if not targetPos or maxDist < 10 then
                            local rad = math.rad(holder.Rotation or 0)
                            local dir = Vector2.new(math.cos(rad), math.sin(rad))
                            targetPos = startPos + dir * (holder.AbsoluteSize.X * 0.8)
                        end

                        if targetPos then
                            pcall(function()
                                SafeVIMMouseButton(startPos.X, startPos.Y, 0, true)
                                local steps = 6
                                for s = 1, steps do
                                    local cur = startPos:Lerp(targetPos, s / steps)
                                    SafeVIMMouseMove(cur.X, cur.Y)
                                    task.wait(0.025)
                                end
                                SafeVIMMouseMove(targetPos.X, targetPos.Y)
                                task.wait(0.02)
                                SafeVIMMouseButton(targetPos.X, targetPos.Y, 0, false)
                            end)
                        end
                    end
                    task.wait(0.16) -- สปีดพอดีๆ (~0.5s ต่อราง) นุ่มนวล ไม่ช้าไม่เร็วเกินไปจนบั๊ก
                end

                local qte = graveUI:FindFirstChild("QTE")
                if qte and qte.Visible then
                    pcall(function()
                        SafeVIMKeyEvent(true, Enum.KeyCode.Space)
                        task.wait(0.02)
                        SafeVIMKeyEvent(false, Enum.KeyCode.Space)
                    end)
                    for _, btn in ipairs(qte:GetDescendants()) do
                        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                            pcall(function()
                                local bx = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                                local by = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2
                                SafeVIMMouseButton(bx, by, 0, true)
                                task.wait(0.02)
                                SafeVIMMouseButton(bx, by, 0, false)
                            end)
                        end
                    end
                    task.wait(0.12)
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
local hasCompletedMechanicHiring = false

local function NeutralizeFallDamage(char)
    char = char or GetChar()
    if not char then return end
    pcall(function()
        local fs = char:FindFirstChild("FallSystem")
        if fs and fs:IsA("LocalScript") and not fs.Disabled then
            fs.Disabled = true
        end
    end)
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            -- เปิด Freefall, Jumping, Landed ให้ครบถ้วน ป้องกันฟิสิกส์หลุดจนตัวจมพื้น 100%
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        end
    end)
end
Hub.NeutralizeFallDamage = NeutralizeFallDamage

--------------------------------------------------------------
-- 🎒 ระบบกระเป๋าเก็บของ (BAG SYSTEM)
--------------------------------------------------------------
local function EquipBag(silent)
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local bs = rep:FindFirstChild("BagSystem")
        local eb = bs and bs:FindFirstChild("EquipBag")
        if eb then
            eb:FireServer()
        end
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local bagBtn = pgui and pgui:FindFirstChild("Mainui") and pgui.Mainui:FindFirstChild("Main") and pgui.Mainui.Main:FindFirstChild("BagBtn")
        if bagBtn then
            bagBtn.Visible = true
            bagBtn.Active = true
        end
        if not silent then
            Notify("🎒 กระเป๋า", "สวมกระเป๋าเรียบร้อยแล้ว (ของในกระเป๋าไม่ตกตอนตาย)", "", 2.5)
        end
    end)
end
Hub.EquipBag = EquipBag

local function UnequipBag(silent)
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local bs = rep:FindFirstChild("BagSystem")
        local ub = bs and bs:FindFirstChild("UnequipBag")
        if ub then
            ub:FireServer()
        end
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local bagBtn = pgui and pgui:FindFirstChild("Mainui") and pgui.Mainui:FindFirstChild("Main") and pgui.Mainui.Main:FindFirstChild("BagBtn")
        if bagBtn then
            bagBtn.Visible = false
            bagBtn.Active = false
        end
        if not silent then
            Notify("🎒 กระเป๋า", "ถอดกระเป๋าออกแล้ว", "", 2)
        end
    end)
end
Hub.UnequipBag = UnequipBag

local function OpenBagUI()
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local bagBtn = pgui and pgui:FindFirstChild("Mainui") and pgui.Mainui:FindFirstChild("Main") and pgui.Mainui.Main:FindFirstChild("BagBtn")
        if bagBtn and typeof(firesignal) == "function" then
            firesignal(bagBtn.MouseButton1Click)
        else
            local rep = game:GetService("ReplicatedStorage")
            local bs = rep:FindFirstChild("BagSystem")
            local ob = bs and bs:FindFirstChild("OpenBag")
            if ob then
                ob:InvokeServer()
            end
        end
    end)
end
Hub.OpenBagUI = OpenBagUI

-- 🛡️ ระบบอมตะ (Godmode)
local godmodeHeartbeatConn = nil
local function SetGodmodeState(enabled, silent)
    State.Godmode = enabled
    if not enabled then
        if godmodeHeartbeatConn then
            godmodeHeartbeatConn:Disconnect()
            godmodeHeartbeatConn = nil
        end
        if not silent then
            Notify("🛡️ อมตะ", "ปิดระบบอมตะ (Godmode) เรียบร้อย", "", 2)
        end
        return
    end

    if not silent then
        Notify("🛡️ อมตะ", "เปิดระบบอมตะ (Godmode) ป้องกันตกจากที่สูง & ลดสตั๊น", "", 2.5)
    end

    local function applyGodmode(char)
        if not char then return end
        pcall(function()
            local stun = char:FindFirstChild("Stun")
            if stun and stun.Value then stun.Value = false end
            NeutralizeFallDamage(char)
        end)
    end

    local char = GetChar()
    applyGodmode(char)

    if godmodeHeartbeatConn then
        godmodeHeartbeatConn:Disconnect()
        godmodeHeartbeatConn = nil
    end

    godmodeHeartbeatConn = RunService.Heartbeat:Connect(function()
        if not State.Running or not State.Godmode then
            if godmodeHeartbeatConn then
                godmodeHeartbeatConn:Disconnect()
                godmodeHeartbeatConn = nil
            end
            return
        end
        local c = GetChar()
        if c then
            local stun = c:FindFirstChild("Stun")
            if stun and stun.Value then stun.Value = false end
        end
    end)
end
Hub.SetGodmodeState = SetGodmodeState

--------------------------------------------------------------
-- ⚡ ระบบเกิดใหม่ทันที (INSTANT RESPAWN SYSTEM)
--------------------------------------------------------------
local isInstantRespawning = false
local lastRecordedDeathCFrame = nil
local charDiedConn = nil

local function TriggerInstantRespawn(force)
    if isInstantRespawning and not force then return end
    if not force and not State.InstantRespawn then return end
    isInstantRespawning = true

    pcall(function()
        local hrp = GetHRP()
        if hrp then
            lastRecordedDeathCFrame = hrp.CFrame
        end
    end)

    task.spawn(function()
        task.wait(0.12)
        pcall(function()
            local rep = game:GetService("ReplicatedStorage")
            local tm = rep:FindFirstChild("TeamMenu")
            local goLobby = tm and tm:FindFirstChild("GoLobby")
            local choose = tm and tm:FindFirstChild("Choose")
            local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name
            if not myTeam or myTeam == "lobby" then
                myTeam = "เด็กบ้าน"
            end

            if goLobby and choose then
                pcall(function() goLobby:InvokeServer() end)
                task.wait(0.08)
                pcall(function() choose:InvokeServer(myTeam) end)
            end
        end)

        -- ปิดหน้าต่างตาย DeathGui ทันที ไม่ให้ติดค้างบนหน้าจอ
        pcall(function()
            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
            local dg = pgui and pgui:FindFirstChild("DeathGui")
            if dg then
                local fr = dg:FindFirstChild("Frame")
                if fr then fr.Visible = false end
                local fo = dg:FindFirstChild("FadeOverlay")
                if fo then fo.Visible = false end
            end
        end)

        -- หากเปิดตัวเลือก วาร์ปกลับจุดตาย ให้วาร์ปกลับตำแหน่งเดิม
        if State.RespawnAtDeathPos and lastRecordedDeathCFrame then
            task.wait(0.4)
            pcall(function()
                local newHrp = GetHRP()
                if newHrp then
                    newHrp.CFrame = lastRecordedDeathCFrame + Vector3.new(0, 2, 0)
                end
            end)
        end

        task.wait(0.8)
        isInstantRespawning = false
    end)
end
Hub.TriggerInstantRespawn = TriggerInstantRespawn

local function HookDeathGui()
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local dg = pgui and (pgui:FindFirstChild("DeathGui") or pgui:WaitForChild("DeathGui", 5))
        local fr = dg and dg:FindFirstChild("Frame")
        if fr and not fr:GetAttribute("KrakenHooked") then
            fr:SetAttribute("KrakenHooked", true)
            fr:GetPropertyChangedSignal("Visible"):Connect(function()
                if fr.Visible and State.InstantRespawn then
                    TriggerInstantRespawn()
                end
            end)
        end
    end)
end
HookDeathGui()

if LocalPlayer.Character then
    local curHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if curHum then
        charDiedConn = curHum.Died:Connect(function()
            if State.InstantRespawn then
                TriggerInstantRespawn()
            end
        end)
    end
end

if Connections.MainCharAdded then
    pcall(function() Connections.MainCharAdded:Disconnect() end)
    Connections.MainCharAdded = nil
end

Connections.MainCharAdded = LocalPlayer.CharacterAdded:Connect(function(newChar)
    hasCompletedNpcHiring = false
    hasCompletedMechanicHiring = false
    SetSprinting(false)
    ClearTargetESP()
    runAnimTrack = nil
    isCurrentlySprinting = false
    cachedRunSystemFn = nil
    isInstantRespawning = false
    HookDeathGui()

    if charDiedConn then
        pcall(function() charDiedConn:Disconnect() end)
        charDiedConn = nil
    end

    local humEarly = newChar:FindFirstChildOfClass("Humanoid") or newChar:WaitForChild("Humanoid", 3)
    if humEarly then
        charDiedConn = humEarly.Died:Connect(function()
            if State.InstantRespawn then
                TriggerInstantRespawn()
            end
        end)
    end

    task.spawn(function()
        task.wait(1.0)
        if not State.Running or not newChar or not newChar.Parent then return end
        local hum = newChar:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        UpdateLocalCharRefs(newChar)

        if State.NoFallDamage or State.Godmode then
            NeutralizeFallDamage(newChar)
        end
        if State.Godmode then
            SetGodmodeState(true, true)
        end
        if State.InfStamina then
            SetInfiniteStaminaState(true)
        end
        if State.AutoEquipBag then
            EquipBag(true)
        end
    end)
end)

-- ลูปตรวจเช็ค FallSystem เป็นระยะ ป้องกันสคริปต์ตกที่สูงเกิดใหม่ และคงสภาพฟิสิกส์
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(1.5)
        if State.NoFallDamage or State.Godmode then
            NeutralizeFallDamage()
        end
    end
end)

local function StopWorkAnimations()
    pcall(function()
        local char = GetChar()
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

local function IsGraveMinigameActive()
    if ActiveGrave and ActiveGrave.active then
        return true
    end

    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    local graveUI = pgui and pgui:FindFirstChild("GraveUI")
    if not graveUI or not graveUI.Enabled then return false end

    local function isVisible(guiObj)
        local cur = guiObj
        while cur and cur ~= graveUI do
            if cur:IsA("GuiObject") and not cur.Visible then
                return false
            end
            cur = cur.Parent
        end
        return true
    end

    local dragUI = graveUI:FindFirstChild("DragUI")
    if dragUI and isVisible(dragUI) then
        return true
    end

    local qte = graveUI:FindFirstChild("QTE")
    if qte and isVisible(qte) then
        return true
    end

    local hasProgress = false
    local isCompleted = false
    for _, d in ipairs(graveUI:GetDescendants()) do
        if d:IsA("TextLabel") and isVisible(d) then
            local txt = d.Text
            if string.find(txt, "100%%") then
                isCompleted = true
            elseif string.find(txt, "กำลัง") or string.find(txt, "ราง") or string.find(txt, "%%") then
                hasProgress = true
            end
        end
    end

    if isCompleted then
        return false -- ถ้าครบ 100% แล้ว ถือว่าจบมินิเกม
    end

    return hasProgress
end

local serverWorkingUntil = 0
pcall(function()
    local allJobs = {
        ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction"),
        ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("mechanic"),
        ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Cleaning"),
        ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("ขยะ")
    }
    for _, jobRS in ipairs(allJobs) do
        if jobRS and jobRS:FindFirstChild("LoadBar") then
            jobRS.LoadBar.OnClientEvent:Connect(function(isActive, duration)
                if isActive then
                    serverWorkingUntil = tick() + (tonumber(duration) or 15)
                else
                    serverWorkingUntil = 0
                end
            end)
        end
    end
end)

IsCurrentlyWorking = function()
    if tick() < serverWorkingUntil then
        cachedIsWorking = true
        return true
    end

    if activeMiniGame and not activeMiniGame.completed then
        cachedIsWorking = true
        return true
    end

    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        local mg = pgui:FindFirstChild("MiniGameUI")
        if mg and mg.Enabled then cachedIsWorking = true return true end

        local jlb = pgui:FindFirstChild("JobLoadBar")
        if jlb and jlb.Enabled then cachedIsWorking = true return true end

        for _, g in ipairs(pgui:GetChildren()) do
            if (g.Name == "CleanLoadBar" or g.Name == "TrashLoadBar") and g:IsA("ScreenGui") and g.Enabled then
                cachedIsWorking = true
                return true
            end
        end

        local notif = pgui:FindFirstChild("ConstructNotif")
        local lbl = notif and notif:FindFirstChildOfClass("TextLabel")
        if lbl and lbl.Text:find("กำลังทำงาน") then cachedIsWorking = true return true end

        if IsGraveMinigameActive() then cachedIsWorking = true return true end
    end

    local char = LocalPlayer.Character
    if char then
        local crouching = char:FindFirstChild("Crouching")
        if crouching and crouching:GetAttribute("BlockCrouch") == true then
            local isLegitActive = (activeMiniGame and not activeMiniGame.completed)
            if not isLegitActive and pgui then
                local mg = pgui:FindFirstChild("MiniGameUI")
                isLegitActive = mg and mg.Enabled
            end
            if isLegitActive then
                cachedIsWorking = true
                return true
            else
                pcall(function() crouching:SetAttribute("BlockCrouch", false) end)
            end
        end
        if char:FindFirstChild("_CleanTool") or char:FindFirstChild("TrashBag") then
            cachedIsWorking = true
            return true
        end
    end

    cachedIsWorking = false
    return false
end
Hub.IsCurrentlyWorking = IsCurrentlyWorking
Hub.StopWorkAnimations = StopWorkAnimations

-- อัปเดตสถานะการทำงานใน Background (12 Hz) เพื่อให้ RenderStepped ตรวจจับได้ทันที 0ms
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        pcall(IsCurrentlyWorking)
        task.wait(0.08)
    end
end)

local lastOtherPlayerPositions = {}
local lastOtherPositionsUpdate = 0
local function GetOtherPlayerPositions()
    local now = os.clock()
    if now - lastOtherPositionsUpdate < 0.25 then
        return lastOtherPlayerPositions
    end
    lastOtherPositionsUpdate = now
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local oHRP = p.Character:FindFirstChild("HumanoidRootPart")
            if oHRP then
                table.insert(list, oHRP.Position)
            end
        end
    end
    lastOtherPlayerPositions = list
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
                for _, prompt in ipairs(car:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local part = (prompt.Parent:IsA("BasePart") and prompt.Parent) or car:FindFirstChildWhichIsA("BasePart", true)
                        if part and (not failedSpotCooldowns[part] or now >= failedSpotCooldowns[part]) then
                            local spotPos = (prompt.Parent:IsA("BasePart") and prompt.Parent.Position) or part.Position
                            if not isOccupied(spotPos) then
                                local d = (myPos - spotPos).Magnitude
                                if d < bestDist then
                                    bestDist = d
                                    bestSpot = part
                                    bestPrompt = prompt
                                    bestName = string.format("ซ่อมรถ: %s (%s)", car.Name, prompt.ActionText or prompt.ObjectText or "ชิ้นส่วน")
                                    bestPos = spotPos
                                end
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
Hub.PendingEarnings = {
    Construction = 0,
    Mechanic = 0
}
Hub.ClaimWageButton = nil

local function ParseEarningsText(str)
    if not str or typeof(str) ~= "string" then return nil end
    local clean = str:gsub(",", ""):match("%d+")
    return tonumber(clean)
end

local function FormatNumber(num)
    local formatted = tostring(math.floor(num or 0))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end

local function GetCurrentPendingWage()
    local curJob = (typeof(GetCurrentSelectedJob) == "function" and GetCurrentSelectedJob()) or State.SelectedJob or "งานก่อสร้าง"
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    
    if pgui then
        local cUI = pgui:FindFirstChild("ConstructionUI")
        local eaC = cUI and cUI:FindFirstChild("MainFrame") and cUI.MainFrame:FindFirstChild("WorkPage") and cUI.MainFrame.WorkPage:FindFirstChild("EarningsBox") and cUI.MainFrame.WorkPage.EarningsBox:FindFirstChild("EarningsAmount")
        if eaC and eaC.Text then
            local val = ParseEarningsText(eaC.Text)
            if val then Hub.PendingEarnings.Construction = val end
        end
        
        local mUI = pgui:FindFirstChild("mechanicUI")
        local eaM = mUI and mUI:FindFirstChild("MainFrame") and mUI.MainFrame:FindFirstChild("WorkPage") and mUI.MainFrame.WorkPage:FindFirstChild("EarningsBox") and mUI.MainFrame.WorkPage.EarningsBox:FindFirstChild("EarningsAmount")
        if eaM and eaM.Text then
            local val = ParseEarningsText(eaM.Text)
            if val then Hub.PendingEarnings.Mechanic = val end
        end
    end
    
    if curJob == "ซ่อมรถ" then
        return Hub.PendingEarnings.Mechanic or 0
    elseif curJob == "งานก่อสร้าง" then
        return Hub.PendingEarnings.Construction or 0
    else
        local cVal = Hub.PendingEarnings.Construction or 0
        local mVal = Hub.PendingEarnings.Mechanic or 0
        return (cVal > 0 and cVal) or mVal or 0
    end
end

local lastWageButtonTitle = ""
local function UpdateClaimButtonText()
    if not Hub.ClaimWageButton then return end
    local pending = GetCurrentPendingWage()
    local newTitle = string.format("💵 รับเงินค่าจ้าง (ค้าง: %s Cash)", FormatNumber(pending))
    if newTitle ~= lastWageButtonTitle then
        lastWageButtonTitle = newTitle
        pcall(function()
            if typeof(Hub.ClaimWageButton.UpdateName) == "function" then
                Hub.ClaimWageButton:UpdateName(newTitle)
            end
        end)
    end
end

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
            Hub.PendingEarnings.Construction = 0
            UpdateClaimButtonText()
            if cUI and cUI:FindFirstChild("MainFrame") then
                local wp = cUI.MainFrame:FindFirstChild("WorkPage")
                local eb = wp and wp:FindFirstChild("EarningsBox")
                local ea = eb and eb:FindFirstChild("EarningsAmount")
                if ea then ea.Text = "0 Cash" end
            end
        elseif not isAuto then
            Notify("งานก่อสร้าง", "ยังไม่มียอดเงินสะสมให้เคลม หรือทำงานก่อนนะ", "", 2.5)
        end
    end)
    return successResult
end

local function ClaimMechanicWage(isAuto)
    local now = tick()
    if now - lastCollectTime < 2.5 then return false end
    lastCollectTime = now

    local successResult = false
    pcall(function()
        local mech = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("mechanic")
        local collect = mech and mech:FindFirstChild("Collect")
        if not collect then return end

        local success, amount = collect:InvokeServer()
        if success and typeof(amount) == "number" and amount > 0 then
            successResult = true
            Hub.PendingEarnings.Mechanic = 0
            UpdateClaimButtonText()
            Notify("งานซ่อมรถ", "💰 เคลมเงินค่าแรงซ่อมรถสำเร็จ! ได้รับ " .. tostring(amount) .. " Cash เข้ากระเป๋า", "", 3.5)
        elseif not isAuto then
            Notify("งานซ่อมรถ", "ยังไม่มียอดเงินสะสมให้เคลม หรือทำงานก่อนนะ", "", 2.5)
        end
    end)
    return successResult
end

-- 🔔 ดักจับ Event UpdateEarnings & PropertyChanged สำหรับระบบ Auto Claim และ Realtime Pending Wages
pcall(function()
    local const = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
    local updateEarningsConst = const and const:FindFirstChild("UpdateEarnings")
    if updateEarningsConst then
        if Connections.AutoClaimUpdateConn then Connections.AutoClaimUpdateConn:Disconnect() end
        Connections.AutoClaimUpdateConn = updateEarningsConst.OnClientEvent:Connect(function(newEarnings)
            if typeof(newEarnings) == "number" then
                Hub.PendingEarnings.Construction = newEarnings
                UpdateClaimButtonText()
            end
            if State.Running and State.AutoClaimConstruction and typeof(newEarnings) == "number" and newEarnings >= 300 then
                task.delay(0.5, function()
                    if State.Running and State.AutoClaimConstruction then
                        ClaimConstructionWage(true)
                    end
                end)
            end
        end)
    end

    local mech = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("mechanic")
    local updateEarningsMech = mech and mech:FindFirstChild("UpdateEarnings")
    if updateEarningsMech then
        if Connections.AutoClaimMechUpdateConn then Connections.AutoClaimMechUpdateConn:Disconnect() end
        Connections.AutoClaimMechUpdateConn = updateEarningsMech.OnClientEvent:Connect(function(newEarnings)
            if typeof(newEarnings) == "number" then
                Hub.PendingEarnings.Mechanic = newEarnings
                UpdateClaimButtonText()
            end
            if State.Running and State.AutoClaimConstruction and typeof(newEarnings) == "number" and newEarnings >= 300 then
                task.delay(0.5, function()
                    if State.Running and State.AutoClaimConstruction then
                        ClaimMechanicWage(true)
                    end
                end)
            end
        end)
    end

    -- Hook GetPropertyChangedSignal on PlayerGui Earnings labels
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        local cUI = pgui:FindFirstChild("ConstructionUI")
        local eaC = cUI and cUI:FindFirstChild("MainFrame") and cUI.MainFrame:FindFirstChild("WorkPage") and cUI.MainFrame.WorkPage:FindFirstChild("EarningsBox") and cUI.MainFrame.WorkPage.EarningsBox:FindFirstChild("EarningsAmount")
        if eaC then
            if Connections.ConstructionEarningsTextConn then Connections.ConstructionEarningsTextConn:Disconnect() end
            Connections.ConstructionEarningsTextConn = eaC:GetPropertyChangedSignal("Text"):Connect(function()
                local val = ParseEarningsText(eaC.Text)
                if val then
                    Hub.PendingEarnings.Construction = val
                    UpdateClaimButtonText()
                end
            end)
        end

        local mUI = pgui:FindFirstChild("mechanicUI")
        local eaM = mUI and mUI:FindFirstChild("MainFrame") and mUI.MainFrame:FindFirstChild("WorkPage") and mUI.MainFrame.WorkPage:FindFirstChild("EarningsBox") and mUI.MainFrame.WorkPage.EarningsBox:FindFirstChild("EarningsAmount")
        if eaM then
            if Connections.MechanicEarningsTextConn then Connections.MechanicEarningsTextConn:Disconnect() end
            Connections.MechanicEarningsTextConn = eaM:GetPropertyChangedSignal("Text"):Connect(function()
                local val = ParseEarningsText(eaM.Text)
                if val then
                    Hub.PendingEarnings.Mechanic = val
                    UpdateClaimButtonText()
                end
            end)
        end
    end
end)

-- ลูปอัปเดตยอดเงินค้างแบบ Real-time ทุก 0.35s
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        pcall(UpdateClaimButtonText)
        task.wait(0.35)
    end
end)

-- ⚡ ระบบเทเลพอร์ตปลอดภัย 100% (BYPASS CODE 261 & ANTI-RUBBERBAND)
-- บินแบบ Cruise Y ข้ามสิ่งกีดขวาง/ตึก/วัด ป้องกัน Fall Damage และวาร์ปได้อย่างเสถียร
local isTeleporting = false
local function SafeTeleport(targetPos, targetName, lookAtPos, silent, preApproachPos)
    if isTeleporting then
        if not silent then
            Notify("ระบบวาร์ป", "กำลังวาร์ปอยู่ กรุณารอสักครู่...", "", 2)
        end
        return false
    end

    local hrp = GetHRP()
    local hum = GetHuman()
    local char = GetChar()
    if not hrp or not hum or not char then
        if not silent then
            Notify("ข้อผิดพลาด", "ไม่พบตัวละครของคุณ", "", 3)
        end
        return false
    end

    isTeleporting = true
    local startPos = hrp.Position
    local totalDist = (targetPos - startPos).Magnitude

    if totalDist <= 12 then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if lookAtPos then
            hrp.CFrame = CFrame.lookAt(targetPos, Vector3.new(lookAtPos.X, targetPos.Y, lookAtPos.Z))
        else
            hrp.CFrame = CFrame.new(targetPos)
        end
        isTeleporting = false
        if not silent and targetName then
            Notify("วาร์ปสำเร็จ", "มาถึง " .. targetName .. " เรียบร้อย!", "", 2.5)
        end
        return true
    end

    if not silent then
        Notify("กำลังวาร์ป", "กำลังเดินทางไป " .. (targetName or "เป้าหมาย") .. " (" .. math.floor(totalDist * 0.28) .. " ม.)...", "", 2)
    end

    -- 🛡️ ป้องกัน Fall Damage ตอนบิน/ลงสู่พื้น 100%
    NeutralizeFallDamage(char)
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    -- บินระดับปลอดภัย ไม่สูงผิดปกติจนระบบเซิร์ฟเวอร์ตรวจจับ (Y = 28-38 Studs พ้นหลังคาบ้านและสายไฟทุกอย่าง)
    local cruiseY = math.clamp(math.max(startPos.Y, targetPos.Y) + 16, 26, 40)
    local wp1 = Vector3.new(startPos.X, cruiseY, startPos.Z)
    local waypoints = {wp1}

    if preApproachPos then
        local wpRoadSky = Vector3.new(preApproachPos.X, cruiseY, preApproachPos.Z)
        local wpRoadGround = preApproachPos
        table.insert(waypoints, wpRoadSky)
        table.insert(waypoints, wpRoadGround)
    else
        local wp2 = Vector3.new(targetPos.X, cruiseY, targetPos.Z)
        table.insert(waypoints, wp2)
    end
    table.insert(waypoints, targetPos)
    local stepDist = 7.5

    local parts = {}
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            table.insert(parts, {part = p, coll = p.CanCollide})
            p.CanCollide = false
        end
    end

    local cur = startPos
    for _, dest in ipairs(waypoints) do
        local dist = (dest - cur).Magnitude
        local steps = math.max(1, math.ceil(dist / stepDist))
        for s = 1, steps do
            if not State.Running or not hrp or not hrp.Parent then break end
            local p = cur:Lerp(dest, s / steps)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(p)
            task.wait(0.055)
        end
        cur = dest
    end

    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if lookAtPos then
            hrp.CFrame = CFrame.lookAt(targetPos, Vector3.new(lookAtPos.X, targetPos.Y, lookAtPos.Z))
        else
            hrp.CFrame = CFrame.new(targetPos)
        end
        task.wait(0.06)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
        NeutralizeFallDamage(char)
    end

    for _, item in ipairs(parts) do
        if item.part and item.part.Parent then
            pcall(function() item.part.CanCollide = item.coll end)
        end
    end

    pcall(function()
        local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        if torso then torso.CanCollide = true end
        local head = char and char:FindFirstChild("Head")
        if head then head.CanCollide = true end
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        end
    end)

    isTeleporting = false
    if not silent and targetName then
        Notify("วาร์ปสำเร็จ", "มาถึง " .. targetName .. " เรียบร้อย!", "", 2.5)
    end
    return true
end

local isSellingTrash = false
local function SellTrashNow(silent)
    if isSellingTrash then return false end
    isSellingTrash = true

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then
        isSellingTrash = false
        return false
    end

    local r = game:GetService("ReplicatedStorage")
    local trashRS = r:FindFirstChild("Job") and r.Job:FindFirstChild("ขยะ")
    local sellConfig = nil
    if trashRS and trashRS:FindFirstChild("SellConfig") then
        pcall(function() sellConfig = require(trashRS.SellConfig) end)
    end
    local itemStackMod = nil
    if r:FindFirstChild("ItemStack") then
        pcall(function() itemStackMod = require(r.ItemStack) end)
    end
    local sellRemote = trashRS and trashRS:FindFirstChild("SellItems")

    if not (trashRS and sellConfig and sellRemote) then
        isSellingTrash = false
        return false
    end

    -- ตรวจสอบรายการขยะใน Backpack
    local toSell = {}
    local totalItems = 0
    for itemName, _ in pairs(sellConfig) do
        local count = 0
        if itemStackMod and typeof(itemStackMod.Count) == "function" then
            pcall(function() count = itemStackMod.Count(LocalPlayer, itemName) end)
        end
        if not count or count == 0 then
            for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                local base = item.Name:gsub("%s*x%d+$", "")
                if base == itemName or item.Name == itemName then
                    count = (count or 0) + (item:GetAttribute("Amount") or 1)
                end
            end
        end
        if count > 0 then
            toSell[itemName] = count
            totalItems = totalItems + count
        end
    end

    if totalItems == 0 then
        if not silent then
            Notify("ขายขยะ", "ไม่มีขยะหรือไอเทมในตัวที่จะขาย", "", 2.5)
        end
        isSellingTrash = false
        return false
    end

    if not silent then
        Notify("ขายขยะ", string.format("กำลังไปขายขยะ %d ชิ้น...", totalItems), "", 2.5)
    end

    local sellNPC = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("ขยะ") and Workspace.Job["ขยะ"]:FindFirstChild("NPC") and Workspace.Job["ขยะ"].NPC:FindFirstChild("Sell")
    local sellHRP = sellNPC and sellNPC:FindFirstChild("HumanoidRootPart")
    local sellPrompt = sellHRP and sellHRP:FindFirstChildWhichIsA("ProximityPrompt", true)

    if not sellHRP or not sellPrompt then
        if not silent then
            Notify("ขายขยะ", "ไม่พบ NPC รับซื้อขยะ", "", 2.5)
        end
        isSellingTrash = false
        return false
    end

    local oldPos = hrp.Position
    local targetSellPos = sellHRP.Position + Vector3.new(0, 1.5, 2)

    SafeTeleport(targetSellPos, "NPC ขายขยะ")
    task.wait(0.35)

    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    local sellKey = sellPrompt.KeyboardKeyCode or Enum.KeyCode.E
    if typeof(fireproximityprompt) == "function" then
        pcall(function() fireproximityprompt(sellPrompt) end)
    end
    SafeVIMKeyEvent(true, sellKey)
    pcall(function() sellPrompt:InputHoldBegin() end)
    task.wait(0.08)
    if typeof(fireproximityprompt) == "function" then
        pcall(function() fireproximityprompt(sellPrompt) end)
    end
    SafeVIMKeyEvent(false, sellKey)
    pcall(function() sellPrompt:InputHoldEnd() end)
    task.wait(0.3)

    local sellConn
    sellConn = trashRS.SellResult.OnClientEvent:Connect(function(succ, cashEarned, msg)
        if succ then
            Notify("ขายขยะสำเร็จ", "ขายขยะสำเร็จ! ได้รับเงินเรียบร้อย", "", 3.0)
        else
            if not silent then
                Notify("ขายขยะ", tostring(msg or "ขายขยะไม่สำเร็จ"), "", 2.5)
            end
        end
    end)

    pcall(function() sellRemote:FireServer(toSell) end)
    task.wait(0.8)
    if sellConn then sellConn:Disconnect() end

    -- ปิดหน้าต่างร้านค้าและปลดล็อคสถานะการเคลื่อนไหว
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local shopsellUI = pgui and pgui:FindFirstChild("Shopsell")
        if shopsellUI then
            shopsellUI.Enabled = false
            local closeBtn = shopsellUI:FindFirstChild("Frame") and shopsellUI.Frame:FindFirstChild("Close")
            if closeBtn and typeof(firesignal) == "function" then
                firesignal(closeBtn.MouseButton1Click)
            end
        end
        local char = LocalPlayer.Character
        local crouching = char and char:FindFirstChild("Crouching")
        if crouching then crouching:SetAttribute("BlockCrouch", false) end
        if pgui and pgui:FindFirstChild("RunSystem") then
            pgui.RunSystem:SetAttribute("BlockStamina", false)
        end
    end)

    if State.AutoFarm and State.SelectedJob == "ขยะ" then
        SafeTeleport(oldPos, "กลับจุดฟาร์มขยะ")
        task.wait(0.35)
    end

    isSellingTrash = false
    return true
end
Hub.SellTrashNow = SellTrashNow

Hub.SetJob = function(jobName)
    State.SelectedJob = jobName
    if Options and Options.JobSelect then
        pcall(function()
            if typeof(Options.JobSelect.SetValue) == "function" then
                for _, opt in ipairs(Options.JobSelect.Values or {}) do
                    if tostring(opt):find(jobName) then
                        Options.JobSelect:SetValue(opt)
                        return
                    end
                end
                Options.JobSelect:SetValue(jobName)
            else
                Options.JobSelect.Value = jobName
            end
        end)
    end
end

local function GetCurrentSelectedJob()
    local val = (Options and Options.JobSelect and Options.JobSelect.Value) or State.SelectedJob or "งานก่อสร้าง"
    if typeof(val) == "table" then
        val = val[1] or ""
    end
    val = tostring(val or "")
    if val:find("ทำความสะอาด") then
        return "ทำความสะอาด"
    elseif val:find("ขยะ") then
        return "ขยะ"
    elseif val:find("ซ่อมรถ") then
        return "ซ่อมรถ"
    elseif val:find("ก่อสร้าง") then
        return "งานก่อสร้าง"
    end
    return "งานก่อสร้าง"
end

local function EnsureHiredConstruction()
    local constRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
    if not constRS then return false end
    local ok, sites = pcall(function() return constRS.GetSites:InvokeServer() end)
    if ok and type(sites) == "table" and #sites > 0 then
        return true
    end
    local okH, r1, r2 = pcall(function() return constRS.Hire:InvokeServer() end)
    if okH and r1 == true then
        return true
    elseif okH and tostring(r2):find("ทำงานอยู่แล้ว") then
        pcall(function() constRS.Quit:InvokeServer() end)
        task.wait(0.2)
        local okH2, r1_2 = pcall(function() return constRS.Hire:InvokeServer() end)
        if okH2 and r1_2 == true then
            return true
        end
    end
    return false
end

local function EnsureHiredMechanic()
    local mechRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("mechanic")
    if not mechRS then return false end
    local ok, sites = pcall(function() return mechRS.GetSites:InvokeServer() end)
    if ok and type(sites) == "table" and #sites > 0 then
        return true
    end
    local okH, r1, r2 = pcall(function() return mechRS.Hire:InvokeServer() end)
    if okH and r1 == true then
        return true
    elseif okH and tostring(r2):find("ทำงานอยู่แล้ว") then
        pcall(function() mechRS.Quit:InvokeServer() end)
        task.wait(0.2)
        local okH2, r1_2 = pcall(function() return mechRS.Hire:InvokeServer() end)
        if okH2 and r1_2 == true then
            return true
        end
    end
    return false
end

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(0.08)
        local curJob = GetCurrentSelectedJob()
        State.SelectedJob = curJob

        if State.AutoClaimConstruction and (tick() - lastCollectTime) >= 15.0 then
            if curJob == "ซ่อมรถ" then
                ClaimMechanicWage(true)
            elseif curJob == "งานก่อสร้าง" then
                ClaimConstructionWage(true)
            end
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

            local jobNpcPos = Vector3.new(2400.86, 3.16, -372.0)

            -- หากเป็นงานก่อสร้าง และยังไม่ได้ลงทะเบียนสมัครงาน -> เดินทางไปสมัครงานรับชุดที่ JobNPC เป็นอันดับแรก
            if curJob == "งานก่อสร้าง" and not hasCompletedNpcHiring then
                local jobNPC = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("งานก่อสร้าง") and Workspace.Job["งานก่อสร้าง"]:FindFirstChild("NPC") and Workspace.Job["งานก่อสร้าง"].NPC:FindFirstChild("JobNPC")
                local npcPrompt = jobNPC and jobNPC:FindFirstChildWhichIsA("ProximityPrompt", true)
                local npcRoot = jobNPC and (jobNPC:FindFirstChild("HumanoidRootPart") or jobNPC:FindFirstChild("Torso") or jobNPC:FindFirstChildWhichIsA("BasePart"))
                local actualNpcPos = npcRoot and npcRoot.Position or jobNpcPos

                SetTargetESP(jobNPC or Workspace, "สมัครงานรับชุด (JobNPC)", Color3.fromRGB(0, 210, 255))

                local distToNPC = (hrp.Position - actualNpcPos).Magnitude
                if distToNPC > 35 then
                    SafeTeleport(actualNpcPos + Vector3.new(0, 0, 3.2), "หน้างานก่อสร้าง (JobNPC)")
                    task.wait(0.35)
                    continue
                elseif distToNPC > 4.2 then
                    NavigateTo(actualNpcPos, 3.2, 40, npcPrompt)
                    continue
                else
                    SetSprinting(false)
                    hum:Move(Vector3.zero, false)
                    hum:MoveTo(hrp.Position)
                    hum.WalkSpeed = 0
                    if hrp then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                    task.wait(0.25)

                    if npcPrompt and npcPrompt.Enabled then
                        if typeof(fireproximityprompt) == "function" then
                            pcall(function() fireproximityprompt(npcPrompt) end)
                        else
                            SafeVIMKeyEvent(true, Enum.KeyCode.E)
                            pcall(function() npcPrompt:InputHoldBegin() end)
                            task.wait(0.2)
                            SafeVIMKeyEvent(false, Enum.KeyCode.E)
                            pcall(function() npcPrompt:InputHoldEnd() end)
                        end
                    end
                    task.wait(0.4)

                    pcall(function()
                        local constRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("Construction")
                        if constRS and constRS:FindFirstChild("Hire") then
                            constRS.Hire:InvokeServer()
                        end
                        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                        local cUI = pgui and pgui:FindFirstChild("ConstructionUI")
                        local mf = cUI and cUI:FindFirstChild("MainFrame")
                        local hp = mf and mf:FindFirstChild("HirePage")
                        local hb = hp and hp:FindFirstChild("HireBtn")
                        if hb and typeof(firesignal) == "function" then
                            firesignal(hb.MouseButton1Click)
                        end
                        task.wait(0.15)
                        local closeBtn = mf and mf:FindFirstChild("Header") and mf.Header:FindFirstChild("CloseBtn")
                        if closeBtn and typeof(firesignal) == "function" then
                            firesignal(closeBtn.MouseButton1Click)
                        end
                        if cUI then cUI.Enabled = false end
                    end)

                    hasCompletedNpcHiring = true
                    ClearTargetESP()
                    Notify("งานก่อสร้าง", "สมัครงานรับชุดที่ NPC เรียบร้อย! เริ่มวิ่งฟาร์มจุดงาน...", "", 2.5)
                    task.wait(0.5)
                    continue
                end
            end

            -- หากเป็นงานซ่อมรถ และยังไม่ได้ลงทะเบียนสมัครงาน -> ยืนยันการสมัครกับเซิร์ฟเวอร์
            if curJob == "ซ่อมรถ" and not hasCompletedMechanicHiring then
                local isAlreadyHired = EnsureHiredMechanic()
                if isAlreadyHired then
                    hasCompletedMechanicHiring = true
                else
                    local mechNPC = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("ซ่อมรถ") and Workspace.Job["ซ่อมรถ"]:FindFirstChild("NPC")
                    local headRepairman = mechNPC and (mechNPC:FindFirstChild("head repairman") or mechNPC:FindFirstChild("JobNPC") or mechNPC:FindFirstChildWhichIsA("Model"))
                    local npcPrompt = headRepairman and headRepairman:FindFirstChildWhichIsA("ProximityPrompt", true)
                    local npcRoot = headRepairman and (headRepairman:FindFirstChild("HumanoidRootPart") or headRepairman:FindFirstChild("Torso") or headRepairman:FindFirstChildWhichIsA("BasePart"))
                    local actualNpcPos = npcRoot and npcRoot.Position or Vector3.new(1920.69, 3.91, -1039.82)

                    SetTargetESP(headRepairman or mechNPC or Workspace, "สมัครงานซ่อมรถ (head repairman)", Color3.fromRGB(255, 170, 0))

                    local distToNPC = (hrp.Position - actualNpcPos).Magnitude
                    if distToNPC > 35 then
                        SafeTeleport(actualNpcPos, "หน้างานซ่อมรถ (head repairman)")
                        task.wait(0.3)
                        continue
                    elseif distToNPC > 4.2 then
                        NavigateTo(actualNpcPos, 3.2, 40, npcPrompt)
                        continue
                    else
                        SetSprinting(false)
                        hum:Move(Vector3.zero, false)
                        hum:MoveTo(hrp.Position)
                        task.wait(0.2)

                        if npcPrompt and npcPrompt.Enabled then
                            if typeof(fireproximityprompt) == "function" then
                                pcall(function() fireproximityprompt(npcPrompt) end)
                            end
                            SafeVIMKeyEvent(true, Enum.KeyCode.E)
                            task.wait(0.08)
                            SafeVIMKeyEvent(false, Enum.KeyCode.E)
                        end
                        task.wait(0.3)

                        pcall(function()
                            local mechRS = ReplicatedStorage:FindFirstChild("Job") and ReplicatedStorage.Job:FindFirstChild("mechanic")
                            if mechRS and mechRS:FindFirstChild("Hire") then
                                mechRS.Hire:InvokeServer()
                            end
                            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                            local mUI = pgui and pgui:FindFirstChild("mechanicUI")
                            local mf = mUI and mUI:FindFirstChild("MainFrame")
                            local closeBtn = mf and mf:FindFirstChild("Header") and mf.Header:FindFirstChild("CloseBtn")
                            if closeBtn and typeof(firesignal) == "function" then
                                firesignal(closeBtn.MouseButton1Click)
                            end
                            if mUI then mUI.Enabled = false end
                        end)

                        hasCompletedMechanicHiring = true
                        ClearTargetESP()
                        Notify("งานซ่อมรถ", "สมัครงานรับชุดเรียบร้อย! เริ่มวิ่งฟาร์มจุดซ่อมรถ...", "", 2.5)
                        task.wait(0.3)
                        continue
                    end
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

                -- ⚡ ระบบวาร์ปไปหน้างาน (ถ้าอยู่นอกพื้นที่หน้างาน หรืออยู่ไกลเกินระยะหน้างาน ให้วาร์ปไปหน้างานก่อน)
                local needTeleportToJob = false
                local teleportDest = nil
                local teleportJobName = nil

                if curJob == "งานก่อสร้าง" then
                    if not IsInConstructionZone(hrp.Position) and current3DDist > 45 then
                        needTeleportToJob = true
                        teleportDest = jobNpcPos
                        teleportJobName = "หน้างานก่อสร้าง"
                    end
                elseif curJob == "ซ่อมรถ" then
                    local mechEntrance = Vector3.new(1920.69, 3.91, -1039.82)
                    local distToMech = (hrp.Position - mechEntrance).Magnitude
                    if distToMech > 45 and current3DDist > 45 then
                        needTeleportToJob = true
                        teleportDest = mechEntrance
                        teleportJobName = "หน้างานซ่อมรถ"
                    end
                elseif curJob == "ขยะ" then
                    if current3DDist > 55 then
                        needTeleportToJob = true
                        teleportDest = Vector3.new(spotPos.X, spotPos.Y + 2.6, spotPos.Z)
                        teleportJobName = "หน้างานเก็บขยะ"
                    end
                elseif curJob == "ทำความสะอาด" then
                    if current3DDist > 55 then
                        needTeleportToJob = true
                        teleportDest = Vector3.new(spotPos.X, spotPos.Y + 2.6, spotPos.Z)
                        teleportJobName = "หน้างานทำความสะอาด"
                    end
                end

                if needTeleportToJob and teleportDest then
                    SetTargetESP(spot, spotName or ("หน้างาน: " .. curJob), nil, "⚡ กำลังวาร์ปไปหน้างาน")
                    SafeTeleport(teleportDest, teleportJobName)
                    task.wait(0.3)
                    continue
                end

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
                    if hrp then
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                    hum:MoveTo(hrp.Position)
                    -- รอฟิสิกส์หยุดสนิทและ Replicate ความเร็ว 0 ไปยังเซิร์ฟเวอร์ก่อนกด Prompt (ป้องกัน CODE 261 Speed Check)
                    task.wait(0.35)

                    -- หันมุมกล้องมองไปที่ตำแหน่งจุดงานเพื่อให้ CoreGui / PPS เล็งเห็น
                    if Camera and actualPromptPos then
                        pcall(function()
                            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, actualPromptPos)
                        end)
                    end
                    task.wait(0.06)

                    -- กด ProximityPrompt เริ่มงานอย่างสะอาด ปราศจาก Input ขัดแย้ง
                    local promptKey = prompt.KeyboardKeyCode or Enum.KeyCode.E
                    local triggered = false
                    if typeof(fireproximityprompt) == "function" then
                        local ok = pcall(function() fireproximityprompt(prompt) end)
                        if ok then triggered = true end
                    end
                    if not triggered then
                        SafeVIMKeyEvent(true, promptKey)
                        pcall(function() prompt:InputHoldBegin() end)
                        task.wait(0.2)
                        SafeVIMKeyEvent(false, promptKey)
                        pcall(function() prompt:InputHoldEnd() end)
                    end

                    -- รอระบบตอบรับการเริ่มงาน (ตรวจจับทั้ง LoadBar, MiniGameUI, หรือ IsCurrentlyWorking)
                    local startCheck = tick()
                    while (tick() - startCheck) < 2.5 and State.AutoFarm and State.Running do
                        if IsCurrentlyWorking() then break end
                        if (tick() - startCheck) >= 0.6 and typeof(fireproximityprompt) == "function" then
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                        task.wait(0.1)
                    end

                    -- ยืนทำงานจนเสร็จสมบูรณ์ 100% โดยล็อคความเร็วเป็น 0 ไม่ให้แรงเฉื่อยหรือฟิสิกส์ขยับ
                    if IsCurrentlyWorking() then
                        SetTargetESP(spot, spotName or "จุดทำงาน", nil, "🔨 กำลังทำงาน")
                        local workStart = tick()
                        local lockCFrame = hrp.CFrame
                        local lastSawWorking = tick()
                        local maxWorkTime = (curJob == "ขยะ" and 55) or 32
                        while (tick() - workStart) < maxWorkTime and State.AutoFarm and State.Running do
                            if IsCurrentlyWorking() then
                                lastSawWorking = tick()
                            elseif (tick() - lastSawWorking) >= ((curJob == "ขยะ" and 1.5) or 0.6) then
                                break
                            end
                            if hum then hum.WalkSpeed = 0 end
                            if hrp then
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                                if (hrp.Position - lockCFrame.Position).Magnitude > 2.0 then
                                    hrp.CFrame = lockCFrame
                                end
                            end
                            task.wait(0.05)
                        end
                        ReleaseVIM()
                        -- คูลดาวน์หลังเสร็จงาน 1.8s ให้เซิร์ฟเวอร์ประมวลผลเงิน/เลเวล/อนิเมชั่น และรีเซ็ตสถานะ ป้องกัน Anti System CODE 261
                        task.wait(1.8)

                        if spotName then
                            if spotName:find("หิน") then
                                Hub.LastCompletedCategory = "หิน"
                            elseif spotName:find("เหล็ก") then
                                Hub.LastCompletedCategory = "เหล็ก"
                            elseif spotName:find("กำแพง") then
                                Hub.LastCompletedCategory = "กำแพง"
                            end
                        end
                        failedSpotCooldowns[spot] = tick() + 6.0
                        if promptPart then failedSpotCooldowns[promptPart] = tick() + 6.0 end
                        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end

                        -- หากเป็นงานขยะ และเปิดขายขยะออโต้ -> ตรวจสอบว่ามีของในตัวไหม ถ้ามีให้วาร์ปไปขายทันที
                        if curJob == "ขยะ" and State.AutoSellTrash then
                            local hasTrash = false
                            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name ~= "Fists" then
                                    hasTrash = true
                                    break
                                end
                            end
                            if hasTrash then
                                task.wait(0.3)
                                pcall(function() SellTrashNow(true) end)
                            end
                        end

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
                -- หากยังไม่เจอจุดงาน แต่ตัวละครอยู่นอกพื้นที่หน้างาน ให้วาร์ปไปรอที่หน้างานเลย
                if curJob == "งานก่อสร้าง" and not IsInConstructionZone(hrp.Position) then
                    SafeTeleport(jobNpcPos, "หน้างานก่อสร้าง")
                    task.wait(0.3)
                elseif curJob == "ซ่อมรถ" and (hrp.Position - Vector3.new(1920.69, 3.91, -1039.82)).Magnitude > 45 then
                    SafeTeleport(Vector3.new(1920.69, 3.91, -1039.82), "หน้างานซ่อมรถ")
                    task.wait(0.3)
                elseif curJob == "ทำความสะอาด" then
                    local cleanJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("ทำความสะอาด")
                    local firstClean = cleanJob and cleanJob:FindFirstChildWhichIsA("BasePart", true)
                    if firstClean and (hrp.Position - firstClean.Position).Magnitude > 45 then
                        SafeTeleport(firstClean.Position + Vector3.new(0, 2.6, 0), "หน้างานทำความสะอาด")
                        task.wait(0.3)
                    end
                elseif curJob == "ขยะ" then
                    local trashJob = Workspace:FindFirstChild("Job") and Workspace.Job:FindFirstChild("ขยะ")
                    local firstTrash = trashJob and trashJob:FindFirstChildWhichIsA("BasePart", true)
                    if firstTrash and (hrp.Position - firstTrash.Position).Magnitude > 45 then
                        SafeTeleport(firstTrash.Position + Vector3.new(0, 2.6, 0), "หน้างานเก็บขยะ")
                        task.wait(0.3)
                    end
                end
                ClearTargetESP()
                task.wait(0.25)
            end

        else
            -- Preview Mode: แสดง ESP นำทางเฉพาะเมื่ออยู่ใน "ขอบเขตฟาร์มใกล้ๆ" เท่านั้น (ไม่แสดงลอยข้ามถนนหรือนอกรั้ว)
            local hrp = GetHRP()
            local curJob = GetCurrentSelectedJob()
            State.SelectedJob = curJob
            if curJob == "งานก่อสร้าง" then
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
                local prevSpot, prevPrompt, prevDist, prevName = GetNearestOpenSpot(curJob)
                if prevSpot and prevDist and prevDist <= 35 then
                    SetTargetESP(prevSpot, string.format("จุดเริ่มฟาร์ม: %s", (prevName or curJob)), nil, "[พร้อมเริ่มฟาร์ม]")
                else
                    ClearTargetESP()
                end
            end
            task.wait(1.0)
        end
    end
end)



--------------------------------------------------------------
-- 9. ระบบตัวละคร (CHEATS: SPEED, JUMP, NOCLIP, FLY, INFJUMP, ESP)
--------------------------------------------------------------
if Connections.Noclip then
    pcall(function() Connections.Noclip:Disconnect() end)
    Connections.Noclip = nil
end
local wasFarmingLastFrame = false
Connections.Noclip = RunService.Stepped:Connect(function()
    if not State.Running then return end
    local isFarming = (
        State.AutoFarm or
        State.AutoTrickOrTreat or
        State.AutoDigGraves or
        State.AutoGetBucket or
        State.AutoDepositCandy or
        State.AutoCollectP320 or
        State.IsGettingBucket or
        State.IsDepositing
    )
    local char = GetChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    if isFarming then
        wasFarmingLastFrame = true
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    elseif wasFarmingLastFrame then
        wasFarmingLastFrame = false
        -- คืนค่า CanCollide ปกติทันทีเมื่อไม่ได้เปิดระบบฟาร์ม
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

Connections.InfJump = UserInputService.JumpRequest:Connect(function()
    if State.Running and State.InfJump then
        local hum = GetHuman()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local flyBV, flyBG = nil, nil

local function StopFly()
    if Connections.FlyLoop then
        pcall(function() Connections.FlyLoop:Disconnect() end)
        Connections.FlyLoop = nil
    end
    if flyBV then
        pcall(function() flyBV:Destroy() end)
        flyBV = nil
    end
    if flyBG then
        pcall(function() flyBG:Destroy() end)
        flyBG = nil
    end
    local hum = GetHuman()
    local hrp = GetHRP()
    if hum then
        hum.PlatformStand = false
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end

local function StartFly()
    StopFly()
    local hrp = GetHRP()
    local hum = GetHuman()
    if not hrp or not hum then return end

    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "StableFlyBV"
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.zero
    flyBV.P = 1250
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.Name = "StableFlyBG"
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.P = 9000
    flyBG.D = 500
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp

    hum.PlatformStand = true

    Connections.FlyLoop = RunService.RenderStepped:Connect(function()
        if not State.Fly or not State.Running then
            StopFly()
            return
        end

        local currentHRP = GetHRP()
        local currentHum = GetHuman()
        if not currentHRP or not currentHum or not flyBV or not flyBG or flyBV.Parent ~= currentHRP then
            return
        end

        currentHum.PlatformStand = true

        local camCF = Camera.CFrame
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude == 0 and currentHum.MoveDirection.Magnitude > 0 then
            local md = currentHum.MoveDirection
            moveDir = moveDir + (camCF.LookVector * md.Z * -1) + (camCF.RightVector * md.X)
        end

        local speed = tonumber(State.FlySpeed) or 50
        if moveDir.Magnitude > 0 then
            flyBV.Velocity = moveDir.Unit * speed
        else
            flyBV.Velocity = Vector3.zero
            currentHRP.AssemblyLinearVelocity = Vector3.zero
            currentHRP.AssemblyAngularVelocity = Vector3.zero
        end

        flyBG.CFrame = camCF
    end)
end

if Connections.FlyCharAdded then
    pcall(function() Connections.FlyCharAdded:Disconnect() end)
end
Connections.FlyCharAdded = LocalPlayer.CharacterAdded:Connect(function()
    if State.Fly and State.Running then
        task.wait(0.5)
        if State.Fly and State.Running then
            StartFly()
        end
    end
end)

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

                -- 3. ตรวจจับข้อมูลสถาบันและสีประจำสถาบันตามที่แมพแบ่งไว้ (แคชถาวรต่อตัวละคร ไม่สแกนซ้ำทุก 40ms)
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
                        schoolCol = entry.CachedColor or schoolCol
                        schoolShort = entry.CachedShort or schoolShort
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
                        entry.CachedSchool = rawTeamName ~= "" and rawTeamName or "ประชาชน"
                        entry.CachedColor = schoolCol
                        entry.CachedShort = schoolShort
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

                -- 6. อัปเดตข้อมูลบน GUI เดิมแบบ In-Place (Dirty Check: อัปเดตเฉพาะเมื่อค่าเปลี่ยนเท่านั้น ไม่สั่ง Render ใหม่ซ้ำๆ)
                local forceRed = State.ESPTacticalStyle == true
                local themeColor = forceRed and Color3.fromRGB(240, 40, 40) or schoolCol

                -- อัปเดต Highlight (Chams ตัวตามสีสถาบัน + ขอบขาวคมชัด)
                if State.ESPShowChams ~= false then
                    if not entry.Highlight.Enabled then entry.Highlight.Enabled = true end
                    if entry.LastFillColor ~= themeColor then
                        entry.LastFillColor = themeColor
                        entry.Highlight.FillColor = themeColor
                    end
                else
                    if entry.Highlight.Enabled then entry.Highlight.Enabled = false end
                end

                -- อัปเดต Corner Box ตามสีสถาบัน
                if State.ESPShowBox ~= false then
                    if not entry.BoxBB.Enabled then entry.BoxBB.Enabled = true end
                    if entry.LastBoxColor ~= themeColor then
                        entry.LastBoxColor = themeColor
                        for _, line in ipairs(entry.BoxLines) do
                            line.BackgroundColor3 = themeColor
                        end
                    end
                else
                    if entry.BoxBB.Enabled then entry.BoxBB.Enabled = false end
                end

                -- อัปเดต Head Dot ตามสีสถาบัน
                if State.ESPShowHeadDot ~= false then
                    if not entry.HeadDotBB.Enabled then entry.HeadDotBB.Enabled = true end
                    if entry.LastDotColor ~= themeColor then
                        entry.LastDotColor = themeColor
                        entry.HeadDotFrame.BackgroundColor3 = themeColor
                    end
                else
                    if entry.HeadDotBB.Enabled then entry.HeadDotBB.Enabled = false end
                end

                -- อัปเดต Billboard ข้อมูล
                if not entry.Billboard.Enabled then entry.Billboard.Enabled = true end

                -- ชื่อผู้เล่น (สีตามสถาบันที่แมพแบ่งไว้)
                if entry.LastNameColor ~= themeColor then
                    entry.LastNameColor = themeColor
                    entry.NameLabel.TextColor3 = themeColor
                end
                local newNameText = (schoolShort ~= "" and schoolShort ~= "ประชาชน") and string.format("[%s] %s", schoolShort, p.DisplayName) or p.DisplayName
                if entry.LastNameText ~= newNameText then
                    entry.LastNameText = newNameText
                    entry.NameLabel.Text = newNameText
                end

                -- ตัวเลขเลือด + หลอดเลือดแนวนอน
                if State.ESPShowHealthBar ~= false then
                    if not entry.HpBarBg.Visible then
                        entry.HpValueLabel.Visible = true
                        entry.HpBarBg.Visible = true
                    end
                    local hpInt = math.floor(curHp)
                    if entry.LastHpInt ~= hpInt then
                        entry.LastHpInt = hpInt
                        entry.HpValueLabel.Text = tostring(hpInt)
                        entry.HpBarFill.Size = UDim2.new(hpRatio, 0, 1, 0)
                        entry.HpBarFill.BackgroundColor3 = hpCol
                    end
                else
                    if entry.HpBarBg.Visible then
                        entry.HpValueLabel.Visible = false
                        entry.HpBarBg.Visible = false
                    end
                end

                -- ข้อมูลระยะทาง & อาวุธ (ลดภาระการสร้าง table ชั่วคราว)
                local distInt = math.floor(dist * 0.28)
                local wepClean = (State.ESPShowWeapon and wepText ~= "" and wepText ~= "มือเปล่า") and wepText or nil
                if State.ESPShowDistance or wepClean then
                    local newInfo = ""
                    if State.ESPShowDistance and wepClean then
                        newInfo = string.format("%dm • %s", distInt, wepClean)
                    elseif State.ESPShowDistance then
                        newInfo = string.format("%dm", distInt)
                    else
                        newInfo = wepClean
                    end
                    if entry.LastInfoText ~= newInfo then
                        entry.LastInfoText = newInfo
                        entry.InfoLabel.Text = newInfo
                        entry.InfoLabel.Visible = true
                    end
                else
                    if entry.InfoLabel.Visible then
                        entry.InfoLabel.Visible = false
                        entry.LastInfoText = nil
                    end
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
            task.wait(0.18)
        else
            if next(Hub.PlayerESPRegistry) then
                ClearAllPlayerESP()
            end
            task.wait(0.3)
        end
    end
end)



--------------------------------------------------------------
-- 10. ระบบความแม่นยำของปืน & ไร้แรงดีด (GUN ACCURACY / NO SPREAD / NO RECOIL / NO BULLET DROP)
--------------------------------------------------------------
local function DeepUnfreeze(tbl, visited)
    if type(tbl) ~= "table" then return end
    visited = visited or {}
    if visited[tbl] then return end
    visited[tbl] = true

    if typeof(setreadonly) == "function" then
        pcall(setreadonly, tbl, false)
    end

    for k, v in pairs(tbl) do
        if type(v) == "table" and not visited[v] then
            DeepUnfreeze(v, visited)
        end
    end
end

local function EnhanceGun(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not tool:IsDescendantOf(game) then return end

    -- 🛡️ ป้องกันเกมเด้ง 100%: หากตัวละครตายหรือกำลังล้มลง ไม่แตะต้องเด็ดขาด
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return end

    -- 🛡️ ป้องกันการแตะต้องปืนที่ตกอยู่ที่พื้นใน Workspace (แก้เฉพาะปืนในตัวเราเท่านั้น)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local isMine = (char and tool:IsDescendantOf(char)) or (bp and tool:IsDescendantOf(bp))
    if not isMine then return end

    pcall(function()
        -- 0. ผูกเหตุการณ์เมื่อถือปืนเข้ามือ เพื่อแปลงค่าแบบเรียลไทม์ (ผูกเพียงครั้งเดียว)
        if not tool:FindFirstChild("_KrakenNoRecoilHooked") then
            local flag = Instance.new("BoolValue")
            flag.Name = "_KrakenNoRecoilHooked"
            flag.Parent = tool
            tool.Equipped:Connect(function()
                task.wait(0.02)
                local currentHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if currentHum and currentHum.Health > 0 then
                    EnhanceGun(tool)
                end
            end)
        end

        -- 1. ปิด Shake และ Recoil LocalScript ของปืนทุกตัว
        local shake = tool:FindFirstChild("Shake")
        if shake and shake:IsA("LocalScript") then
            shake.Enabled = not (State.NoRecoil and State.Running)
        end
        local recoilScript = tool:FindFirstChild("Recoil") or tool:FindFirstChild("CameraRecoil")
        if recoilScript and recoilScript:IsA("LocalScript") then
            recoilScript.Enabled = not (State.NoRecoil and State.Running)
        end

        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        if ps then
            local meleeShake = ps:FindFirstChild("MeleeScreenshakeScript")
            if meleeShake and meleeShake:IsA("LocalScript") and State.NoRecoil and State.Running then
                meleeShake.Enabled = false
            end
        end

        -- 2. ปรับแต่งโมดูล Setting ของ FE Gun Kit
        local settingMod = tool:FindFirstChild("Setting")
        if settingMod and settingMod:IsA("ModuleScript") then
            local okRequire, s = pcall(require, settingMod)
            if okRequire and type(s) == "table" then
                -- เคลียร์ NetBeat WatchList และ Queue ก่อนเสมอ ป้องกันตรวจจับ code 7501
                if GlobalNetBeatWatchList then pcall(table.clear, GlobalNetBeatWatchList) end
                if GlobalNetBeatQueue then pcall(table.clear, GlobalNetBeatQueue) end

                -- ปลดล็อกตารางที่ถูก table.freeze เพียงครั้งเดียว ป้องกัน memory corruption
                if not s._KrakenUnlocked then
                    DeepUnfreeze(s)
                    s._KrakenUnlocked = true
                end

                -- 🎯 ยิงตรงจุด 100% (No Spread & Shotgun Spread = 0)
                pcall(function()
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
                end)

                -- 🛑 ปืนนิ่งสนิท ไร้แรงถีบ & ล็อคเป้านิ่งเวลายิง 100% (No Recoil & Zero Screen Jitter)
                pcall(function()
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
                        s.SelfKnockback = false
                        s.SelfKnockbackPower = 0
                        s.SelfKnockbackMultiplier = 0
                        s.DropXMin = 0
                        s.DropYMax = 0
                        s.XMax = 0
                        s.YMax = 0
                    end
                end)

                -- ⚡ กระสุนพุ่งตรง ไม่ย้อยตามแรงโน้มถ่วง (No Bullet Drop)
                pcall(function()
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
                end)


                -- ⚡ สวิตช์ยิงรัว Glock Switch (Full-Auto Rapid Fire - ป้องกัน CODE 49 และ 51 100%)
                pcall(function()
                    if State.GlockSwitch and State.Running then
                        if s._OriginalFireRate == nil or s._OriginalFireRate < 0.08 then
                            s._OriginalFireRate = (s.FireRate and s.FireRate >= 0.08) and s.FireRate or 0.3
                            s._OriginalAuto = s.Auto == true
                            s._OriginalBurst = s.BurstFireEnabled == true
                            s._OriginalSelective = s.SelectiveFireEnabled == true
                            local lowerName = tool.Name:lower()
                            if lowerName:find("beretta") or lowerName:find("บาเร็ตต้า") or lowerName:find("glock")
                               or lowerName:find("kimber") or lowerName:find("p320") or lowerName:find("magnum")
                               or lowerName:find("คิงครอบบ้า") or lowerName:find("อีโบ๊ะ") or lowerName:find("ลูกซอง")
                               or lowerName:find("ปากกา") or lowerName:find("หักลำ") or lowerName:find("แปลง") then
                                s._OriginalAuto = false
                            end
                        end

                        -- แปลงระบบลั่นไกเป็น Full-Auto 100% คลิกค้างยิงรัวต่อเนื่อง
                        s.Auto = true
                        s.SelectiveFireEnabled = false
                        s.BurstFireEnabled = false
                        s.EquipTime = 0.1

                        if type(s.FireModes) == "table" then
                            for i = 1, #s.FireModes do
                                s.FireModes[i] = true
                            end
                        else
                            s.FireModes = { true }
                        end

                        -- คำนวณ FireRate ให้รัวเร็วสไตล์ Glock Switch แท้
                        local customRate = State.GlockSwitchRate or 0.11
                        local toolNameLower = tool.Name:lower()
                        if toolNameLower:find("beretta") or toolNameLower:find("บาเร็ตต้า") then
                            s.FireRate = customRate -- รัวจัดสไตล์ Glock Switch (0.08 - 0.12 วิ)
                        elseif toolNameLower:find("glock") then
                            s.FireRate = math.min(customRate, 0.12)
                        elseif toolNameLower:find("p320") then
                            s.FireRate = math.min(customRate, 0.13)
                        elseif toolNameLower:find("kimber") then
                            s.FireRate = math.min(customRate, 0.14)
                        elseif toolNameLower:find("magnum") or toolNameLower:find("คิงครอบบ้า") or toolNameLower:find(".44") then
                            s.FireRate = math.min(customRate + 0.08, 0.22)
                        elseif toolNameLower:find("อีโบ๊ะ") or toolNameLower:find("ลูกซอง") or toolNameLower:find("หักลำ") then
                            s.FireRate = math.min(customRate + 0.15, 0.30)
                        elseif toolNameLower:find("ปากกา") then
                            s.FireRate = math.min(customRate + 0.05, 0.18)
                        else
                            s.FireRate = customRate
                        end
                    else
                        if s._OriginalFireRate ~= nil then
                            s.Auto = s._OriginalAuto
                            s.FireRate = s._OriginalFireRate
                            s.BurstFireEnabled = s._OriginalBurst
                            if s._OriginalSelective ~= nil then
                                s.SelectiveFireEnabled = s._OriginalSelective
                            end
                        end
                    end
                end)
            end
        end
    end)
end

local function ApplyGunMods()
    if not State.Running then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end -- ป้องกันการรันขณะผู้เล่นตาย/ล้มลง 100%

    pcall(function()
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                EnhanceGun(item)
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
        if Connections.CharGunHook then Connections.CharGunHook:Disconnect(); Connections.CharGunHook = nil end
        if Connections.CharGunRemoved then Connections.CharGunRemoved:Disconnect(); Connections.CharGunRemoved = nil end
        if Connections.BpGunHook then Connections.BpGunHook:Disconnect(); Connections.BpGunHook = nil end

        local function SafeEnhance(child)
            if not child or not child:IsA("Tool") then return end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then return end
            EnhanceGun(child)
        end

        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                Connections.CharGunHook = char.ChildAdded:Connect(SafeEnhance)
            end
        end

        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            Connections.BpGunHook = bp.ChildAdded:Connect(SafeEnhance)
        end
    end)
end

HookInventoryForGuns()
if Connections.CharAddedGunHook then
    pcall(function() Connections.CharAddedGunHook:Disconnect() end)
    Connections.CharAddedGunHook = nil
end
Connections.CharAddedGunHook = LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(1.5)
    if newChar and newChar:FindFirstChildOfClass("Humanoid") then
        HookInventoryForGuns()
        ApplyGunMods()
    end
end)

-- เฝ้าดูและปรับแต่งปืนที่ถืออยู่ทุก 1.5 วินาที (ปลอดภัย เบา ไม่กระตุก ไม่รบกวนจังหวะตาย)
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(1.5)
        pcall(ApplyGunMods)
    end
end)


-- สิ้นสุดส่วนปรับแต่งปืน


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

local cachedCrosshairObj = nil

local function GetAimCenter()
    local cam = Workspace.CurrentCamera
    if not cam then return Vector2.new(0, 0) end
    local uis = UserInputService

    -- 🎯 1. ระบบล็อคกึ่งกลางจอสำหรับมือถือ (Mobile Center Lock) หรือเมื่อเปิด State.LockFOVCenter
    -- บนมือถือหรือโหมดล็อคจอ มุมกล้องของผู้เล่นจะหมุนตามทิศทางเล็ง วงเล็ง FOV จึงต้องล็อคกลางจอ 100%
    if IsMobile or State.LockFOVCenter or uis.MouseBehavior == Enum.MouseBehavior.LockCenter then
        cachedCrosshairObj = nil
        return Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    end

    -- 2. บน PC: ตรวจสอบว่ากำลังถือ Tool (ปืน/อาวุธ) อยู่ในตัวละครจริงหรือไม่
    local char = LocalPlayer.Character
    local currentTool = char and char:FindFirstChildOfClass("Tool")

    -- ถ้าไม่ได้ถือ Tool หรือเพิ่งกดเก็บปืนเข้ากระเป๋า -> เคลียร์แคช และตามตำแหน่งเมาส์ทันที
    if not currentTool then
        cachedCrosshairObj = nil
        return uis:GetMouseLocation()
    end

    -- 3. หากถือ Tool ให้ตรวจสอบว่ามี Crosshair GUI ที่กำลังเปิดใช้งานอยู่จริง (ScreenGui.Enabled และ Crosshair.Visible)
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        -- ตรวจสอบแคชเดิมว่ายังใช้งานได้อยู่จริงหรือไม่
        if cachedCrosshairObj and cachedCrosshairObj.Parent and cachedCrosshairObj:IsDescendantOf(pgui) then
            local sg = cachedCrosshairObj:FindFirstAncestorOfClass("ScreenGui")
            if sg and sg.Enabled and cachedCrosshairObj.Visible and cachedCrosshairObj.AbsoluteSize.X > 0 and cachedCrosshairObj.AbsolutePosition.X > 0 then
                return cachedCrosshairObj.AbsolutePosition + (cachedCrosshairObj.AbsoluteSize / 2)
            end
        end

        cachedCrosshairObj = nil

        -- ค้นหา GunGUI Crosshair
        local gunGui = pgui:FindFirstChild("GunGUI")
        if gunGui and gunGui:IsA("ScreenGui") and gunGui.Enabled then
            local crosshair = gunGui:FindFirstChild("Crosshair")
            if crosshair and crosshair:IsA("GuiObject") and crosshair.Visible and crosshair.AbsoluteSize.X > 0 and crosshair.AbsolutePosition.X > 0 then
                cachedCrosshairObj = crosshair
                return crosshair.AbsolutePosition + (crosshair.AbsoluteSize / 2)
            end
        end

        -- ค้นหา fistgui crosshair
        local fistgui = pgui:FindFirstChild("fistgui")
        if fistgui and fistgui:IsA("ScreenGui") and fistgui.Enabled then
            local fcross = fistgui:FindFirstChild("crosshair")
            if fcross and fcross:IsA("GuiObject") and fcross.Visible and fcross.AbsoluteSize.X > 0 and fcross.AbsolutePosition.X > 0 then
                cachedCrosshairObj = fcross
                return fcross.AbsolutePosition + (fcross.AbsoluteSize / 2)
            end
        end
    end

    -- 4. ทุกกรณีอื่นๆ บน PC ที่ไม่มี Crosshair ให้ตามตำแหน่งเมาส์สดๆ ทุกเฟรม
    cachedCrosshairObj = nil
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

local sharedWallRayParams = RaycastParams.new()
sharedWallRayParams.FilterType = Enum.RaycastFilterType.Exclude
sharedWallRayParams.IgnoreWater = true

local function IsWallClear(origin, targetPart, targetChar)
    local diff = (targetPart.Position - origin)
    local dist = diff.Magnitude
    if dist <= 0.1 then return true end
    local dir = diff.Unit

    local myChar = GetChar()
    local ignore = {myChar, Workspace.CurrentCamera}
    sharedWallRayParams.FilterDescendantsInstances = ignore
    local rayParams = sharedWallRayParams

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

local cachedPlayerSchools = {}
local function GetPlayerSchoolOrTeam(plr)
    if not plr then return "" end
    -- ตรวจสอบ Team ของ Roblox ก่อนเสมอ หากมีค่าและไม่ใช่ lobby ให้ยึดเป็นหลักทันที (ไม่ล็อกด้วยแคชเก่า)
    if plr.Team and plr.Team.Name ~= "" and plr.Team.Name:lower() ~= "lobby" then
        return plr.Team.Name
    end
    if cachedPlayerSchools[plr] then return cachedPlayerSchools[plr] end
    local char = plr.Character
    if not char then return (plr.Team and plr.Team.Name) or "" end
    local head = char:FindFirstChild("Head")
    local ovTag = head and (head:FindFirstChild("OverheadNameBill") or head:FindFirstChildWhichIsA("BillboardGui"))
    if ovTag then
        for _, d in ipairs(ovTag:GetChildren()) do
            if d:IsA("TextLabel") and d.Text and d.Text ~= "" then
                for _, sc in ipairs(SchoolConfigs) do
                    if string.find(d.Text, sc.Key, 1, true) then
                        cachedPlayerSchools[plr] = sc.Key
                        return sc.Key
                    end
                end
            end
        end
    end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("BillboardGui") then
            for _, lbl in ipairs(d:GetChildren()) do
                if lbl:IsA("TextLabel") and lbl.Text and lbl.Text ~= "" then
                    for _, sc in ipairs(SchoolConfigs) do
                        if string.find(lbl.Text, sc.Key, 1, true) then
                            cachedPlayerSchools[plr] = sc.Key
                            return sc.Key
                        end
                    end
                end
            end
        end
    end
    return (plr.Team and plr.Team.Name) or ""
end

Players.PlayerRemoving:Connect(function(plr)
    cachedPlayerSchools[plr] = nil
end)

local function IsTeammateOrFriendly(plr)
    if not plr or plr == LocalPlayer then return true end

    -- ข้อมูลทีมของเรา
    local myTeam = LocalPlayer.Team
    local myTeamName = (myTeam and myTeam.Name) or ""
    local mySchool = GetPlayerSchoolOrTeam(LocalPlayer)

    -- 🛑 ถ้าเราอยู่ทีม "เด็กบ้าน" หรือประชาชน -> เซ็ทค่าเป็นยิงได้ทุกคนทันที (เด็กบ้านไม่มีพวกเดียวกัน ยิงได้อิสระ)
    local isMyTeamDekBaan = (myTeamName == "เด็กบ้าน" or mySchool == "เด็กบ้าน"
        or myTeamName == "" or myTeamName:lower() == "lobby"
        or myTeamName:find("เด็กบ้าน") or myTeamName:find("ประชาชน"))

    if isMyTeamDekBaan then
        return false
    end

    -- ข้อมูลทีมของเป้าหมาย
    local targetTeam = plr.Team
    local targetTeamName = (targetTeam and targetTeam.Name) or ""
    local targetSchool = GetPlayerSchoolOrTeam(plr)

    -- 🛑 ถ้าเป้าหมายเป็น "เด็กบ้าน" หรือประชาชน -> ยิงได้เสมอ (ไม่ใช่พวกเดียวกัน ไม่ว่าเราจะอยู่สถาบันใด)
    if targetTeamName == "เด็กบ้าน" or targetSchool == "เด็กบ้าน"
        or targetTeamName == "" or targetTeamName:lower() == "lobby"
        or targetTeamName:find("เด็กบ้าน") or targetTeamName:find("ประชาชน") then
        return false
    end

    -- กรณีเราสังกัดสถาบัน (เช่น วัดสุธิวราราม, ปทุมคงคา, กรุงเทพช่างกล, ตำรวจ, พระ)
    -- 1. ตรวจสอบ Roblox Team (ถ้าอยู่ทีมเดียวกัน = ห้ามยิง)
    if myTeam and targetTeam and myTeam == targetTeam then
        return true
    end

    -- 2. ตรวจสอบ TeamColor ของ Roblox (สีประจำทีมเดียวกัน = ห้ามยิง)
    if LocalPlayer.TeamColor and plr.TeamColor and LocalPlayer.TeamColor == plr.TeamColor then
        local myColor = LocalPlayer.TeamColor.Name
        if myColor ~= "Black" and myColor ~= "Quill grey" then
            return true
        end
    end

    -- 3. ตรวจสอบชื่อสถาบันบนหัว (School / Overhead Tag)
    if mySchool ~= "" and targetSchool ~= "" then
        if targetSchool == mySchool or string.find(targetSchool, mySchool, 1, true) or string.find(mySchool, targetSchool, 1, true) then
            return true
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
            if State.SilentTeamCheck and IsTeammateOrFriendly(plr) then
                continue
            end
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

    -- 🎃 Silent Aim ล็อกเป้ามอนสเตอร์ฮาโลวีน
    if State.SilentAimHalloween then
        local hw = Workspace:FindFirstChild("Helloween")
        local monsters = hw and hw:FindFirstChild("Monsters")
        if monsters then
            for _, m in ipairs(monsters:GetChildren()) do
                if m:IsA("Model") then
                    local hum = m:FindFirstChildOfClass("Humanoid")
                    local head = m:FindFirstChild("Head") or m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                    if hum and hum.Health > 0 and head then
                        local sPos, onScreen = cam:WorldToViewportPoint(head.Position)
                        if onScreen and sPos.Z > 0 then
                            local sDist = (Vector2.new(sPos.X, sPos.Y) - centerPos).Magnitude
                            if sDist <= maxFOV and sDist < bestScreenDist then
                                bestScreenDist = sDist
                                bestTargetPos = head.Position
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

    -- 4. หากพ่อค้าปรากฏในแมพแต่ยังไม่มีข้อมูลเวลา เริ่มต้นนับ 10 นาที (600 ��ินาที)
    if FindMerchantNPC then
        local model, hrp = FindMerchantNPC()
        if model and hrp then
            if not MerchantData.DespawnTimestamp or MerchantData.DespawnTimestamp <= os.clock() then
                MerchantData.DespawnTimestamp = os.clock() + 600
            end
            local rem = math.max(0, math.floor(MerchantData.DespawnTimestamp - os.clock()))
            local m = math.floor(rem / 60)
            local s = math.floor(rem % 60)
            return string.format(" | ⏱️ %d:%02d", m, s)
        end
    end

    return ""
end

local cachedMerchantModel = nil
local cachedMerchantHRP = nil
local lastMerchantSearchTime = 0

FindMerchantNPC = function()
    -- ตรวจสอบแคชก่อน หากยังมีอยู่ในเกมให้คืนค่าทันที ไม่ต้องค้นหาซ้ำ
    if cachedMerchantModel and cachedMerchantModel.Parent and cachedMerchantHRP and cachedMerchantHRP.Parent then
        return cachedMerchantModel, cachedMerchantHRP
    end

    local now = os.clock()
    -- หน่วงเวลาการค้นหาใหม่ ไม่สแกนบ่อยเกินไป (อย่างน้อย 3 วินาที)
    if now - lastMerchantSearchTime < 3.0 then
        return cachedMerchantModel, cachedMerchantHRP
    end
    lastMerchantSearchTime = now

    -- 1. ค้นหาโมเดล SecretShopNPC ใน Workspace:GetChildren() (เร็วมาก ไม่กิน CPU)
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.find(obj.Name, "SecretShopNPC") then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
                     or obj:FindFirstChild("Torso")
                     or obj:FindFirstChild("Head")
                     or obj:FindFirstChild("UpperTorso")
                     or obj.PrimaryPart
                     or obj:FindFirstChildWhichIsA("BasePart", true)

            if not hrp then
                local pivot = obj:GetPivot()
                if pivot and pivot.Position ~= Vector3.zero then
                    if not Hub.LocalMerchantAnchor or not Hub.LocalMerchantAnchor.Parent then
                        local anchor = Instance.new("Part")
                        anchor.Name = "KrakenMerchantAnchor"
                        anchor.Size = Vector3.new(2, 5, 2)
                        anchor.Transparency = 1
                        anchor.CanCollide = false
                        anchor.Anchored = true
                        anchor.Parent = Workspace
                        Hub.LocalMerchantAnchor = anchor
                    end
                    Hub.LocalMerchantAnchor.CFrame = pivot
                    pcall(function()
                        LocalPlayer:RequestStreamAroundAsync(pivot.Position)
                    end)
                    hrp = Hub.LocalMerchantAnchor
                end
            end

            if hrp then
                cachedMerchantModel = obj
                cachedMerchantHRP = hrp
                return obj, hrp
            end
        end
    end

    -- 2. ค้นหาในโฟลเดอร์เป้าหมายเฉพาะ (ไม่สแกนทั้ง Workspace:GetDescendants)
    local targetFolders = {"NPC", "NPCs", "Map", "Spawns", "Shop"}
    for _, fName in ipairs(targetFolders) do
        local f = Workspace:FindFirstChild(fName)
        if f then
            for _, obj in ipairs(f:GetChildren()) do
                if obj:IsA("Model") and (string.find(obj.Name, "SecretShopNPC") or string.find(obj.Name, "พ่อค้าพเนจร")) then
                    local hrp = obj:FindFirstChild("HumanoidRootPart")
                             or obj:FindFirstChild("Torso")
                             or obj:FindFirstChild("Head")
                             or obj.PrimaryPart
                             or obj:FindFirstChildWhichIsA("BasePart", true)
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
    ClearHalloweenESP()
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
    if not hrp or not hrp.Parent then
        if FindMerchantNPC then
            local _, newHrp = FindMerchantNPC()
            if newHrp then
                bb.Adornee = newHrp
                hrp = newHrp
            end
        end
    end

    local dist = (myHRP and hrp and hrp:IsA("BasePart")) and (myHRP.Position - hrp.Position).Magnitude or 0
    local meters = math.floor(dist * 0.28)
    local timeStr = GetRealtimeMerchantTimeString()
    subLbl.Text = string.format("อีก %d เมตร%s", meters, timeStr)
end

-- Note: SafeTeleport is defined above before AutoFarm loop

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
    task.spawn(function()
        SafeTeleport(targetPos, "พ่อค้าพเนจร", hrp.Position)
    end)
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
    if now - lastMerchantTick >= 0.1 then
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
        task.wait(1.0)
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
-- 👮 ระบบตำรวจ & จับกุมผู้ต้องหาอัตโนมัติ (POLICE ENGINE)
--------------------------------------------------------------
do
    local function GetHandcuffsTool()
        local myChar = LocalPlayer.Character
        if myChar then
            for _, t in ipairs(myChar:GetChildren()) do
                if t:IsA("Tool") and (t:GetAttribute("PoliceCuffs") == true or t.Name:find("กุญแจมือ") or t.Name:lower():find("cuff")) then
                    return t, true
                end
            end
        end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and (t:GetAttribute("PoliceCuffs") == true or t.Name:find("กุญแจมือ") or t.Name:lower():find("cuff")) then
                    return t, false
                end
            end
        end
        return nil, false
    end

    local function FindNearestWantedSuspect()
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return nil, math.huge end

        local bestSuspect = nil
        local bestDist = math.huge

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local wanted = p:GetAttribute("WantedLevel") or 0
                    local inJail = p:GetAttribute("JailEnds") ~= nil
                    local hidden = p:GetAttribute("WantedHidden") == true
                    if wanted > 0 and not inJail and not hidden then
                        local d = (hrp.Position - myHRP.Position).Magnitude
                        if d < bestDist then
                            bestDist = d
                            bestSuspect = p
                        end
                    end
                end
            end
        end
        return bestSuspect, bestDist
    end

    -- Listener to CuffState สำหรับออโต้ยึดยาและออโต้ส่งเข้าคุก
    pcall(function()
        local policeRS = ReplicatedStorage:FindFirstChild("Police")
        local cuffState = policeRS and policeRS:FindFirstChild("CuffState")
        if cuffState then
            cuffState.OnClientEvent:Connect(function(role, data)
                if role == "cop" and (State.AutoConfiscateDrugs or State.AutoSendToJail) then
                    task.delay(0.2, function()
                        local ca = policeRS:FindFirstChild("CuffAction")
                        if ca then
                            if State.AutoConfiscateDrugs then
                                pcall(function() ca:InvokeServer("confiscate") end)
                                task.wait(0.3)
                            end
                            if State.AutoSendToJail then
                                pcall(function() ca:InvokeServer("jail") end)
                            end
                        end
                    end)
                end
            end)
        end
    end)

    -- Loop ตรวจจับคนร้าย หยิบกุญแจมือ และล็อคกุญแจมืออัตโนมัติ
    task.spawn(function()
        while _G._KrakenScriptId == MY_SCRIPT_ID do
            task.wait(0.25)
            if State.Running and (State.AutoCuffWanted or State.AutoEquipCuffs) then
                local suspect, dist = FindNearestWantedSuspect()
                if suspect and suspect.Character then
                    local cuffTool, isHolding = GetHandcuffsTool()

                    -- 1. ออโต้หยิบกุญแจมือเมื่อเจอคนร้าย (เมื่อมีคนร้ายในระยะใกล้)
                    if State.AutoEquipCuffs and cuffTool and not isHolding and dist <= 45 then
                        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:EquipTool(cuffTool)
                            isHolding = true
                        end
                    end

                    -- 2. ออโต้ล็อคกุญแจมือเมื่อเข้าใกล้คนร้าย (ระยะตามสไลเดอร์)
                    local maxArrestDist = State.PoliceArrestDistance or 8
                    if State.AutoCuffWanted and dist <= maxArrestDist then
                        if cuffTool and not isHolding then
                            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if hum then hum:EquipTool(cuffTool) end
                        end

                        local hrp = suspect.Character:FindFirstChild("HumanoidRootPart")
                        local prompt = hrp and hrp:FindFirstChild("CuffPrompt")
                        if prompt and prompt:IsA("ProximityPrompt") then
                            pcall(function()
                                if typeof(fireproximityprompt) == "function" then
                                    fireproximityprompt(prompt, 0)
                                else
                                    prompt:InputHoldBegin()
                                    task.wait(0.05)
                                    prompt:InputHoldEnd()
                                end
                            end)
                        end
                    end
                end
            end
        end
    end)
end

--------------------------------------------------------------
-- 🎁 ระบบใส่โค้ดรับรางวัลชุมชน ROBLOX (CODE REDEEM ENGINE)
--------------------------------------------------------------
do
    local AUTO_COMMUNITY_CODES = {
        "sorryforroblox!",
        "sorryforlate!",
        "Tkall!",
        "GoodMorning"
    }

    local isRedeemingAll = false

    function Hub.RedeemSingleCode(code)
        local rep = game:GetService("ReplicatedStorage")
        local codeEvent = rep:FindFirstChild("RemoteEvents") and rep.RemoteEvents:FindFirstChild("codeEvent")
        if not codeEvent then
            Notify("ระบบโค้ด", "⚠️ ไม่พบ Remote codeEvent ในเกม", "", 3)
            return
        end
        codeEvent:FireServer(code)
        Notify("ระบบโค้ด", "🚀 ส่งโค้ด: " .. tostring(code), "", 2.5)
    end

    function Hub.RedeemAllGameCodes()
        if isRedeemingAll then return end
        isRedeemingAll = true

        local rep = game:GetService("ReplicatedStorage")
        local codeEvent = rep:FindFirstChild("RemoteEvents") and rep.RemoteEvents:FindFirstChild("codeEvent")
        if not codeEvent then
            isRedeemingAll = false
            Notify("ระบบโค้ด", "⚠️ ไม่พบ Remote codeEvent ในเกม", "", 3)
            return
        end

        Notify("ระบบโค้ด", "🎁 เริ่มกรอกโค้ดแจกฟรีทั้งหมด (ต้องเข้ากลุ่ม Roblox ก่อน)...", "", 3.5)
        task.spawn(function()
            for idx, code in ipairs(AUTO_COMMUNITY_CODES) do
                pcall(function()
                    codeEvent:FireServer(code)
                end)
                Notify("ระบบโค้ด", string.format("ส่งโค้ด [%d/%d]: %s", idx, #AUTO_COMMUNITY_CODES, code), "", 2)
                task.wait(1.5)
            end
            isRedeemingAll = false
            Notify("ระบบโค้ด", "✅ กรอกโค้ดครบทั้งหมด 4 โค้ดเรียบร้อย!", "", 3.5)
        end)
    end

    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local codeEvent = rep:FindFirstChild("RemoteEvents") and rep.RemoteEvents:FindFirstChild("codeEvent")
        if codeEvent then
            codeEvent.OnClientEvent:Connect(function(status, msg)
                local statusStr = tostring(status or msg or "")
                if statusStr:find("Already") or statusStr:find("ใช้แล้ว") then
                    Notify("ระบบโค้ด", "ℹ️ โค้ดนี้ถูกใช้งานไปแล้ว", "", 2.5)
                elseif statusStr:find("Group") or statusStr:find("กลุ่ม") then
                    Notify("ระบบโค้ด", "❌ ต้องเข้าร่วมกลุ่มชุมชน Roblox ก่อนจึงจะรับได้!", "", 3.5)
                elseif statusStr:find("Redeemed") or statusStr:find("Success") or statusStr:find("Boost") then
                    Notify("ระบบโค้ด", "🎉 รับรางวัลสำเร็จ! (" .. statusStr .. ")", "", 3.5)
                else
                    Notify("ระบบโค้ด", statusStr, "", 2.5)
                end
            end)
        end
    end)
end

--------------------------------------------------------------
-- 🎨 สร้างเมนูใน FLUENT TABS
--------------------------------------------------------------
do
-- Card 1 (Left): ระบบฟาร์มอัตโนมัติ (Farm Automation)
Tabs.Farm:AddSection("", "Left")
local MainFarmToggle = Tabs.Farm:AddToggle("MasterAutoFarm", {
    Title = "🌾 เริ่มฟาร์มออโต้",
    Default = false
})
MainFarmToggle:OnChanged(function()
    State.AutoFarm = Options.MasterAutoFarm.Value
    if typeof(GetCurrentSelectedJob) == "function" then
        State.SelectedJob = GetCurrentSelectedJob()
    end
    if State.AutoFarm then
        hasCompletedNpcHiring = false
        hasCompletedMechanicHiring = false
        table.clear(failedSpotCooldowns)
        StopWorkAnimations()
        ReleaseVIM()
        local hum = GetHuman()
        if hum then
            hum:Move(Vector3.zero, false)
        end
        local extraInfo = (State.SelectedJob == "งานก่อสร้าง") and (" (" .. tostring(State.ConstructionFilter) .. ")") or ""
        Notify("ระบบฟาร์ม", "เริ่มฟาร์มงาน: " .. tostring(State.SelectedJob) .. extraInfo, "", 3)
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
    Title = "🎮 แก้มินิเกม",
    Default = true
})
MinigameToggle:OnChanged(function()
    State.AutoSolveMinigame = Options.AutoSolveMinigameOn.Value
end)

local InstantWarpToggle = Tabs.Farm:AddToggle("FastJobWarpOn", {
    Title = "🚀 วาร์ปไปหน้างาน",
    Default = true
})

local FarmSpeedSlider = Tabs.Farm:AddSlider("FarmSpeedSlider", {
    Title = "👟 ความเร็วเดิน",
    Min = 14,
    Max = 18,
    Default = 16.0,
    Rounding = 1
})
FarmSpeedSlider:OnChanged(function(v)
    State.FarmSpeed = tonumber(v) or 16.0
end)

-- Card 2 (Right Top): ตัวเลือกสายงาน (Job Settings)
Tabs.Farm:AddSection("", "Right")
local JobSelector = Tabs.Farm:AddDropdown("JobSelect", {
    Title = "🎯 เลือกสายงาน",
    Values = {"🏗️ งานก่อสร้าง", "🧹 ทำความสะอาด", "🗑️ เก็บขยะ", "🔧 ซ่อมรถ"},
    Default = "🏗️ งานก่อสร้าง"
})
JobSelector:OnChanged(function(v)
    if typeof(GetCurrentSelectedJob) == "function" then
        State.SelectedJob = GetCurrentSelectedJob()
    else
        local val = (typeof(v) == "string" and v) or (Options.JobSelect and Options.JobSelect.Value) or ""
        if typeof(val) == "table" then val = val[1] or "" end
        val = tostring(val)
        if val:find("ทำความสะอาด") then
            State.SelectedJob = "ทำความสะอาด"
        elseif val:find("ขยะ") then
            State.SelectedJob = "ขยะ"
        elseif val:find("ซ่อมรถ") then
            State.SelectedJob = "ซ่อมรถ"
        elseif val:find("ก่อสร้าง") then
            State.SelectedJob = "งานก่อสร้าง"
        end
    end
    hasCompletedNpcHiring = false
    hasCompletedMechanicHiring = false
    ClearTargetESP()
    Notify("เลือกงาน", "เปลี่ยนเป้าหมายเป็น: " .. State.SelectedJob, "", 2.5)
    pcall(UpdateClaimButtonText)
end)

local ConstFilterDropdown = Tabs.Farm:AddDropdown("ConstructionFilterSelect", {
    Title = "🧱 กรองจุดก่อสร้าง",
    Values = {"🧱+🔩 กำแพง & เหล็ก", "🧱 เฉพาะกำแพง", "🔩 เฉพาะเหล็ก", "🌐 ทั้งหมด"},
    Default = "🧱+🔩 กำแพง & เหล็ก"
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

local AllSpotsToggle = Tabs.Farm:AddToggle("ShowAllJobSpotsToggle", {
    Title = "✨ แสดงจุดงาน (ESP)",
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

-- Card 3 (Right Bottom): รับเงินค่าจ้าง (Wages Economy)
Tabs.Farm:AddSection("", "Right")
local AutoClaimToggle = Tabs.Farm:AddToggle("AutoClaimConstructionOn", {
    Title = "💰 เคลมเงินออโต้",
    Default = false
})
AutoClaimToggle:OnChanged(function()
    State.AutoClaimConstruction = Options.AutoClaimConstructionOn.Value
    if State.AutoClaimConstruction then
        Notify("เคลมเงินอัตโนมัติ", "เปิดใช้งานเคลมเงินงานก่อสร้างอัตโนมัติแล้ว", "", 2.5)
        ClaimConstructionWage(true)
    end
end)

Hub.ClaimWageButton = Tabs.Farm:AddButton({
    Title = "💵 รับเงินค่าจ้าง (ค้าง: 0 Cash)",
    Callback = function()
        local activeJob = (typeof(GetCurrentSelectedJob) == "function" and GetCurrentSelectedJob()) or State.SelectedJob
        if activeJob == "ซ่อมรถ" then
            ClaimMechanicWage(false)
        elseif activeJob == "งานก่อสร้าง" then
            ClaimConstructionWage(false)
        else
            if (Hub.PendingEarnings.Construction or 0) > 0 then
                ClaimConstructionWage(false)
            elseif (Hub.PendingEarnings.Mechanic or 0) > 0 then
                ClaimMechanicWage(false)
            else
                Notify("เคลมเงิน", "งาน " .. tostring(activeJob) .. " ได้รับเงินเข้าตัวทันทีเมื่อทำงานเสร็จ", "", 2.5)
            end
        end
        task.wait(0.35)
        UpdateClaimButtonText()
    end
})
pcall(UpdateClaimButtonText)

local AutoSellTrashToggle = Tabs.Farm:AddToggle("AutoSellTrashOn", {
    Title = "🗑️ ขายขยะอัตโนมัติ (NPC)",
    Default = true
})
AutoSellTrashToggle:OnChanged(function()
    State.AutoSellTrash = Options.AutoSellTrashOn.Value
end)

Tabs.Farm:AddButton({
    Title = "💰 ไปขายขยะทั้งหมดทันที",
    Callback = function()
        SellTrashNow(false)
    end
})
end


--------------------------------------------------------------
-- 🎃 12. ระบบอีเวนต์ฮาโลวีน (HALLOWEEN EVENT SUITE)
--------------------------------------------------------------
local HalloweenData = {
    Bank = 0,
    Held = 0,
    Cap = 0,
    Tier = 0,
    Quests = {},
    P320 = {},
    LastUpdate = 0
}
Hub.HalloweenESPObjects = {}

local function ClearHalloweenESP()
    for _, item in pairs(Hub.HalloweenESPObjects) do
        if type(item) == "table" then
            for _, sub in ipairs(item) do
                pcall(function() sub:Destroy() end)
            end
        elseif typeof(item) == "Instance" then
            pcall(function() item:Destroy() end)
        end
    end
    table.clear(Hub.HalloweenESPObjects)
end

local function FetchHalloweenState()
    local hf = ReplicatedStorage:FindFirstChild("Halloween") and ReplicatedStorage.Halloween:FindFirstChild("HalloweenFunc")
    if not hf then return nil end
    local s, res = pcall(function() return hf:InvokeServer("State") end)
    if s and type(res) == "table" and res.state then
        HalloweenData.Bank = res.state.bank or 0
        HalloweenData.Held = res.state.held or 0
        HalloweenData.Cap = res.state.cap or 0
        HalloweenData.Tier = res.state.tier or 0
        HalloweenData.Quests = res.state.quests or {}
        HalloweenData.P320 = res.state.p320 or {}
        HalloweenData.LastUpdate = os.clock()
        return res.state
    end
    return nil
end

local function GetHalloweenStatusString()
    local phase = workspace:GetAttribute("HHPhase") or "ปกติ"
    local mode = workspace:GetAttribute("HHMode") or "ไม่มี"
    return string.format(
        "🍬 แคนดี้ในคลัง: %s | ถืออยู่: %d/%d (ถังระดับ %d)\n🎃 อีเวนต์ 2 ชม.: %s (โหมด: %s)",
        tostring(HalloweenData.Bank),
        HalloweenData.Held,
        HalloweenData.Cap,
        HalloweenData.Tier,
        tostring(phase),
        tostring(mode)
    )
end

-- 🧲 ระบบ Auto QTE ชนะผี & Auto Drag & Auto Vacuum ของดรอปจากหลุมศพ (ทำงานได้ 100% แม้พับจอ)
local GraveEvent = ReplicatedStorage:FindFirstChild("Halloween") and ReplicatedStorage.Halloween:FindFirstChild("GraveEvent")
if GraveEvent then
    Connections.HalloweenGraveListener = GraveEvent.OnClientEvent:Connect(function(action, data)
        if not State.Running then return end

        if action == "Start" and type(data) == "table" and data.token then
            ActiveGrave.token = data.token
            ActiveGrave.dragsNeeded = data.drags or 3
            ActiveGrave.dragsCompleted = 0
            ActiveGrave.active = true
            ActiveGrave.inWork = false
            ActiveGrave.startTime = os.clock()
            ActiveGrave.lastActionTime = os.clock()

            if State.AutoGraveQTE then
                task.delay(0.42, function()
                    if ActiveGrave.active and not ActiveGrave.inWork and ActiveGrave.token == data.token then
                        if ActiveGrave.dragsCompleted < ActiveGrave.dragsNeeded then
                            ActiveGrave.lastActionTime = os.clock()
                            pcall(function() GraveEvent:FireServer("Drag", ActiveGrave.token) end)
                        end
                    end
                end)
            end
        elseif action == "DragOk" and type(data) == "table" then
            ActiveGrave.dragsCompleted = data.n or (ActiveGrave.dragsCompleted + 1)
            ActiveGrave.dragsNeeded = data.need or ActiveGrave.dragsNeeded
            ActiveGrave.lastActionTime = os.clock()

            if State.AutoGraveQTE and ActiveGrave.active and not ActiveGrave.inWork then
                if ActiveGrave.dragsCompleted < ActiveGrave.dragsNeeded then
                    task.delay(0.50, function()
                        if ActiveGrave.active and not ActiveGrave.inWork and (ActiveGrave.dragsCompleted < ActiveGrave.dragsNeeded) then
                            ActiveGrave.lastActionTime = os.clock()
                            pcall(function() GraveEvent:FireServer("Drag", ActiveGrave.token) end)
                        end
                    end)
                end
            end
        elseif action == "Work" then
            ActiveGrave.inWork = true
            ActiveGrave.lastActionTime = os.clock()
        elseif action == "Ghost" then
            if type(data) == "table" and data.token then
                ActiveGrave.token = data.token
            end
            ActiveGrave.lastActionTime = os.clock()

            if State.AutoGraveQTE and ActiveGrave.token then
                task.delay(0.10, function()
                    if ActiveGrave.active and ActiveGrave.token then
                        ActiveGrave.lastActionTime = os.clock()
                        pcall(function() GraveEvent:FireServer("QTE", ActiveGrave.token, true) end)
                    end
                end)
            end
        elseif action == "GhostEnd" then
            ActiveGrave.lastActionTime = os.clock()
            if State.AutoGraveQTE and ActiveGrave.active and not ActiveGrave.inWork then
                if ActiveGrave.dragsCompleted < ActiveGrave.dragsNeeded then
                    task.delay(0.35, function()
                        if ActiveGrave.active and not ActiveGrave.inWork and (ActiveGrave.dragsCompleted < ActiveGrave.dragsNeeded) then
                            ActiveGrave.lastActionTime = os.clock()
                            pcall(function() GraveEvent:FireServer("Drag", ActiveGrave.token) end)
                        end
                    end)
                end
            end
        elseif action == "Done" or action == "End" then
            ActiveGrave.active = false
            ActiveGrave.token = nil
            ActiveGrave.inWork = false
        end

        if State.AutoVacuumLoot and action == "Loot" and type(data) == "table" and data.id then
            task.delay(0.05, function()
                pcall(function() GraveEvent:FireServer("Collect", data.id) end)
            end)
        end
    end)

    -- Watchdog ลูปสำหรับกรณีเน็ตแล็ก หรือหน้าต่างเกมถูกพับ (Minimized/Folded)
    task.spawn(function()
        while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
            task.wait(0.35)
            if State.AutoGraveQTE and ActiveGrave.active and ActiveGrave.token and not ActiveGrave.inWork then
                local now = os.clock()
                if (now - ActiveGrave.startTime) > 35 then
                    ActiveGrave.active = false
                    ActiveGrave.token = nil
                elseif (now - ActiveGrave.lastActionTime) > 0.95 and (ActiveGrave.dragsCompleted < ActiveGrave.dragsNeeded) then
                    ActiveGrave.lastActionTime = now
                    pcall(function() GraveEvent:FireServer("Drag", ActiveGrave.token) end)
                end
            end
        end
    end)
end

-- ⚔️ ระบบเข้าร่วมอีเวนต์ 2 ชั่วโมงอัตโนมัติ
local Event2h = ReplicatedStorage:FindFirstChild("Halloween") and ReplicatedStorage.Halloween:FindFirstChild("Event2h")
Connections.AutoJoinEvent2hLoop = RunService.Heartbeat:Connect(function()
    if not (State.Running and State.AutoJoinEvent2h and Event2h) then return end
    local phase = workspace:GetAttribute("HHPhase")
    if (phase == "lobby" or phase == "countdown") and not Hub.Joined2hEvent then
        Hub.Joined2hEvent = true
        Event2h:FireServer("hhJoin")
        Notify("🎃 อีเวนต์ 2 ชั่วโมง", "เข้าร่วมอีเวนต์ฮาโลวีนเรียบร้อยแล้ว!", "", 3)
    elseif phase == "idle" or phase == nil then
        Hub.Joined2hEvent = false
    end
end)

State.IsDepositing = false
State.IsGettingBucket = false

-- 🎃 ตรวจจับผลการเคาะประตูบ้านและฝากแคนดี้จาก HalloweenEvent แบบ Real-time
Hub.LastKnockEvent = nil
Hub.LastKnockTime = 0
Hub.LastKnockPos = nil
local rs = game:GetService("ReplicatedStorage")
local hwFolder = rs:FindFirstChild("Halloween")
local hwEvent = hwFolder and hwFolder:FindFirstChild("HalloweenEvent")
if hwEvent and hwEvent:IsA("RemoteEvent") then
    hwEvent.OnClientEvent:Connect(function(action, p1, p2, p3, p4)
        if action == "Reward" then
            Hub.LastKnockEvent = {
                kind = "Reward",
                amount = tonumber(p1) or 0,
                held = tonumber(p2) or 0,
                cap = tonumber(p3) or 0,
                time = os.clock()
            }
        elseif action == "Scare" then
            Hub.LastKnockEvent = {
                kind = "Scare",
                time = os.clock()
            }
        elseif action == "Notify" then
            local text = tostring(p1 or "")
            if text:find("เดินทางมาเร็วผิดปกติ") then
                local sec = tonumber(text:match("รออีก%s*(%d+)")) or tonumber(text:match("(%d+)%s*วิ")) or 2
                Hub.LastKnockEvent = {
                    kind = "SpeedWarning",
                    seconds = sec,
                    message = text,
                    time = os.clock()
                }
            end
        end
    end)
end

-- 🚪 ถือถังแคนดี้อัตโนมัติ (ตรวจสอบทั้ง Attribute และชื่อ Tool) ให้แน่ใจว่าอยู่ในมือ 100%
local function EquipCandyContainerTool()
    local char = GetChar()
    if not char then return false, nil end

    -- ตรวจสอบว่าถือถังแคนดี้ในมือเรียบร้อยแล้วหรือไม่
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and (t:GetAttribute("CandyContainer") or t.Name:find("Candy") or t.Name:find("Bag") or t.Name:find("Pot")) then
            return true, t
        end
    end

    local hum = GetHuman()
    -- ปลดอาวุธอื่น เช่น หมัด (Fists) ออกจากมือก่อน เพื่อไม่ให้บล็อกการถือถัง
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and not (t:GetAttribute("CandyContainer") or t.Name:find("Candy") or t.Name:find("Bag") or t.Name:find("Pot")) then
            if hum then pcall(function() hum:UnequipTools() end) end
            task.wait(0.08)
            break
        end
    end

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp and hum then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t:GetAttribute("CandyContainer") or t.Name:find("Candy") or t.Name:find("Bag") or t.Name:find("Pot")) then
                hum:EquipTool(t)
                -- รอจนกว่า Tool จะย้ายเข้าสู่ Character จริงๆ
                local st = os.clock()
                while (os.clock() - st) < 0.8 do
                    if t.Parent == char then
                        task.wait(0.12) -- รอให้สคริปต์เกม HalloweenClient เปิด Enabled ให้ Prompt ทุกหลัง
                        return true, t
                    end
                    task.wait(0.04)
                end
                return true, t
            end
        end
    end
    return false, nil
end

-- 🚪 ฟังก์ชันกด ProximityPrompt ประตูบ้าน (ปลอดภัย 100% ไม่โดนแบน Code 85)
local function RobustFirePrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    if prompt:GetAttribute("Busy") == true then return false end
    pcall(function() prompt.Enabled = true end)

    local hrp = GetHRP()
    if hrp and prompt.Parent then
        local pPos = prompt.Parent:IsA("Attachment") and prompt.Parent.WorldPosition or prompt.Parent.Position
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(pPos.X, hrp.Position.Y, pPos.Z))
    end

    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
    end)
    return true
end

-- 🚪 ดึงพิกัด WorldPosition แท้ของ ProximityPrompt (รองรับ Attachment และ BasePart)
local function GetPromptWorldPosition(prompt, fallback)
    if not prompt then return nil end
    local p = prompt.Parent
    if p then
        if p:IsA("Attachment") then
            return p.WorldPosition
        elseif p:IsA("BasePart") then
            return p.Position
        end
    end
    if fallback then
        if fallback:IsA("BasePart") then return fallback.Position end
        local bp = fallback:FindFirstChildWhichIsA("BasePart", true)
        if bp then return bp.Position end
    end
    return nil
end

-- 🚪 ค้นหาบ้าน Trick or Treat ที่พร้อมเคาะ (เรียงตามระยะใกล้สุด)
local function GetNearestReadyHouse(ignoreList)
    local hw = Workspace:FindFirstChild("Helloween")
    local housesFolder = hw and hw:FindFirstChild("บ้าน")
    if not housesFolder then return nil end
    local nowServer = workspace:GetServerTimeNow()
    local hrp = GetHRP()
    local myPos = hrp and hrp.Position or Vector3.zero
    local bestHouse, bestPrompt, bestDist, bestPos = nil, nil, 999999, nil
    local nextSoonestHouse, minCooldownRemaining = nil, 999999

    for _, house in ipairs(housesFolder:GetChildren()) do
        if not (ignoreList and ignoreList[house]) then
            local prompt = house:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                local readyAt = prompt:GetAttribute("ReadyAt") or 0
                local busy = prompt:GetAttribute("Busy") == true
                local wPos = GetPromptWorldPosition(prompt, house)
                if wPos then
                    if nowServer >= readyAt and not busy then
                        local d = (myPos - wPos).Magnitude
                        if d < bestDist then
                            bestDist = d
                            bestHouse = house
                            bestPrompt = prompt
                            bestPos = wPos
                        end
                    else
                        local remaining = readyAt - nowServer
                        if remaining > 0 and remaining < minCooldownRemaining then
                            minCooldownRemaining = remaining
                            nextSoonestHouse = house
                        end
                    end
                end
            end
        end
    end
    return bestHouse, bestPrompt, bestDist, bestPos, nextSoonestHouse, minCooldownRemaining
end

-- ⚰️ ค้นหาหลุมศพที่ขุด/ทุบได้
local function GetNearestHalloweenGrave()
    local hw = Workspace:FindFirstChild("Helloween")
    if not hw then return nil end
    local graveFolder = nil
    for _, c in ipairs(hw:GetChildren()) do
        if c.Name:find("หลุมศพ") or c.Name:find("ศพ") then
            graveFolder = c
            break
        end
    end
    if not graveFolder then return nil end

    local hrp = GetHRP()
    local myPos = hrp and hrp.Position or Vector3.zero
    local bestGrave, bestPrompt, bestDist, bestPos = nil, nil, 999999, nil

    for _, sub in ipairs(graveFolder:GetChildren()) do
        if sub.Name == "ขุด" or sub.Name == "ทุบ" then
            for _, spot in ipairs(sub:GetChildren()) do
                local pr = spot:FindFirstChildWhichIsA("ProximityPrompt", true)
                local wPos = GetPromptWorldPosition(pr, spot)
                if pr and pr.Enabled and wPos then
                    local d = (myPos - wPos).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestGrave = spot
                        bestPrompt = pr
                        bestPos = wPos
                    end
                end
            end
        end
    end
    return bestGrave, bestPrompt, bestDist, bestPos
end

-- ⚡ วาร์ปไปยังเป้าหมายฮาโลวีน (Trick or Treat / หลุมศพ / ผีจอมขนม / บ่อแคนดี้) รวดเร็ว ปลอดภัย ไร้ Fall Damage 100%
local function RunToHalloweenTarget(targetPos, targetPrompt, stopDist, targetName, customActiveCheck)
    local effectiveStopDist = stopDist or 5.0
    if targetPrompt and targetPrompt.MaxActivationDistance and targetPrompt.MaxActivationDistance > 5 then
        effectiveStopDist = math.clamp(targetPrompt.MaxActivationDistance - 2.0, 4.0, 6.0)
    end

    local hrp = GetHRP()
    local hum = GetHuman()
    local char = GetChar()
    if not hrp or not hum or hum.Health <= 0 then return false end

    local totalDist = (hrp.Position - targetPos).Magnitude
    if totalDist <= effectiveStopDist then
        hum:Move(Vector3.zero, false)
        SetSprinting(false)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if targetPrompt and targetPrompt.Parent then
            local pPos = GetPromptWorldPosition(targetPrompt, targetPos)
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(pPos.X, hrp.Position.Y, pPos.Z))
        end
        return true
    end

    -- 1. คำนวณทิศด้านหน้าของเป้าหมาย (หันออกจากประตูบ้าน/จุดกด เพื่อไม่ให้ทับโมเดลหรือเข้าผิดด้าน)
    local frontDir = nil
    if targetPrompt and targetPrompt.Parent then
        local pPart = targetPrompt.Parent:IsA("Attachment") and targetPrompt.Parent.Parent or targetPrompt.Parent
        if pPart and pPart:IsA("BasePart") then
            local lv = pPart.CFrame.LookVector
            local hDir = Vector3.new(lv.X, 0, lv.Z)
            if hDir.Magnitude > 0.1 then
                frontDir = hDir.Unit
            end
        end
    end

    local finalStandPos = targetPos
    local roadApproachPos = nil

    if frontDir then
        -- ยืนตรงหน้าประตู 3.8 studs ตามทิศหันออกของประตูพอดี
        finalStandPos = Vector3.new(targetPos.X + frontDir.X * 3.8, targetPos.Y, targetPos.Z + frontDir.Z * 3.8)
        -- จุดลงจากฟ้าบนถนนโล่งนอกชายคาบ้าน (8.5 studs หน้าบ้าน ฟ้าเปิด 100% ไม่มีหลังคาหรือกันสาดบัง)
        roadApproachPos = Vector3.new(targetPos.X + frontDir.X * 8.5, targetPos.Y, targetPos.Z + frontDir.Z * 8.5)
    else
        local approachDir = (hrp.Position - targetPos)
        local hDist = Vector2.new(approachDir.X, approachDir.Z).Magnitude
        local standOffset = 3.8
        if hDist > 1 then
            local unitH = Vector3.new(approachDir.X, 0, approachDir.Z).Unit
            finalStandPos = targetPos + unitH * math.min(standOffset, effectiveStopDist - 1.0)
        else
            finalStandPos = targetPos + Vector3.new(0, 0, 3.5)
        end
    end

    -- 2. หาความสูงพื้นดินจริง (ยิงเรย์จากระดับต่ำ targetPos.Y + 1.2 ลงมา ไม่ยิงจากบนฟ้า เพื่อไม่ให้โดนหลังคาบ้านเด็ดขาด)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = {char}
    local safeFolder = Workspace:FindFirstChild("Safe")
    if safeFolder then table.insert(filterList, safeFolder) end
    local live = Workspace:FindFirstChild("Live") or Workspace:FindFirstChild("Characters")
    if live then table.insert(filterList, live) end
    rayParams.FilterDescendantsInstances = filterList

    -- คำนวณความสูงพื้นดินของจุดยืนหน้าประตู
    local doorRay = Workspace:Raycast(Vector3.new(finalStandPos.X, targetPos.Y + 1.2, finalStandPos.Z), Vector3.new(0, -12, 0), rayParams)
    local groundY = doorRay and (doorRay.Position.Y + 3.0) or (targetPos.Y - 0.5)
    -- ล็อกความสูงเด็ดขาด: ต้องไม่สูงกว่า targetPos.Y + 0.2 (ไม่ให้ขึ้นหลังคาแน่นอน) และไม่ต่ำกว่า 2.5
    groundY = math.clamp(groundY, 2.5, targetPos.Y + 0.2)
    finalStandPos = Vector3.new(finalStandPos.X, groundY, finalStandPos.Z)

    -- คำนวณความสูงพื้นถนนของจุดดรอปจากฟ้า
    if roadApproachPos then
        local roadRay = Workspace:Raycast(Vector3.new(roadApproachPos.X, targetPos.Y + 2.0, roadApproachPos.Z), Vector3.new(0, -15, 0), rayParams)
        local roadY = roadRay and (roadRay.Position.Y + 3.0) or groundY
        roadApproachPos = Vector3.new(roadApproachPos.X, roadY, roadApproachPos.Z)
    end

    -- ⚡ วาร์ปด้วย SafeTeleport ทันที (ตกบนถนนหน้าบ้าน แล้วก้าวเข้ามาชานหน้าประตูพอดี ไร้หลังคา ไร้ Fall Damage 100%)
    SafeTeleport(finalStandPos, targetName, targetPos, true, roadApproachPos)

    hrp = GetHRP()
    hum = GetHuman()
    if hrp and hum and hum.Health > 0 then
        hum:Move(Vector3.zero, false)
        SetSprinting(false)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if targetPrompt and targetPrompt.Parent then
            local pPos = GetPromptWorldPosition(targetPrompt, targetPos)
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(pPos.X, hrp.Position.Y, pPos.Z))
        end
        return (hrp.Position - targetPos).Magnitude <= (effectiveStopDist + 4.5)
    end
    return false
end

-- 🎒 วาร์ปไปเอาถังแคนดี้อัตโนมัติ (Auto Get Candy Bucket)
local function AutoGetCandyBucket(force)
    local hasTool, tool = EquipCandyContainerTool()
    if not force and hasTool and tool then
        Notify("🎃 ถังแคนดี้", "มีถังแคนดี้อยู่ในตัวแล้ว (" .. tool.Name .. ")", "", 3)
        return true
    end

    local mainPos = Vector3.new(2121.23, 5.12, -348.75)
    local hrp = GetHRP()
    if not hrp then return false end

    local cash = 0
    pcall(function()
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local c = leaderstats and leaderstats:FindFirstChild("Cash")
        cash = c and c.Value or 0
    end)

    local rs = game:GetService("ReplicatedStorage")
    local func = rs.Halloween:FindFirstChild("HalloweenFunc")
    local state = nil
    if func then
        pcall(function() state = func:InvokeServer("State") end)
    end
    local curTier = state and state.state and state.state.tier or 0

    if curTier == 0 and cash < 15000 then
        Notify("❌ เงินไม่พอ", string.format("ต้องใช้เงิน $15,000 Cash ในการซื้อถุงแคนดี้ (ปัจจุบันมี: $%d)", cash), "", 5)
        return false
    end

    Notify("🎃 กำลังไปเอาถังแคนดี้", "กำลังวิ่งไปหาผีจอมขนม (Main)...", "", 4)
    local hw = Workspace:FindFirstChild("Helloween")
    local mainNpc = hw and hw:FindFirstChild("NPC") and hw.NPC:FindFirstChild("Main")
    local talkPrompt = mainNpc and mainNpc:FindFirstChild("TalkPrompt", true)
    local mainPos = Vector3.new(2122.74, 4.16, -348.75)
    if talkPrompt and talkPrompt.Parent then
        if talkPrompt.Parent:IsA("Attachment") then
            mainPos = talkPrompt.Parent.WorldPosition
        elseif talkPrompt.Parent:IsA("BasePart") then
            mainPos = talkPrompt.Parent.Position
        end
    elseif mainNpc and mainNpc.PrimaryPart then
        mainPos = mainNpc.PrimaryPart.Position
    end

    SetTargetESP(mainNpc or mainPos, "ผีจอมขนม (Main) [ซื้อ/รับถังแคนดี้]", Color3.fromRGB(255, 140, 0), "⚡ กำลังวาร์ปไปเอาถัง...")

    State.IsGettingBucket = true
    local arrived = RunToHalloweenTarget(mainPos, talkPrompt, 6.0, "ผีจอมขนม (Main)", function()
        return State.Running and (State.AutoGetBucket or State.IsGettingBucket)
    end)
    State.IsGettingBucket = false

    hrp = GetHRP()
    if hrp and (hrp.Position - mainPos).Magnitude <= 18 then
        SetTargetESP(mainNpc, "ผีจอมขนม (Main)", Color3.fromRGB(255, 140, 0), "🛒 กำลังซื้อ/รับถังแคนดี้...")
        task.wait(0.2)

        if func then
            local res = func:InvokeServer("Buy", 1)
            if res and res.ok then
                Notify("🎉 สำเร็จ!", "ซื้อถุงแคนดี้เรียบร้อยแล้ว! (ความจุ 50 เม็ด)", "", 4)
            elseif res and res.msg then
                Notify("🎃 ผีจอมขนม", tostring(res.msg), "", 3)
            end
        end

        task.wait(0.6)
        local equipped = EquipCandyContainerTool()
        if equipped then
            Notify("🎉 พร้อมฟาร์ม!", "ถือถุงแคนดี้ลงมือเรียบร้อย", "", 3)
        end
        ClearTargetESP()
        return true
    else
        Notify("⚠️ ข้อผิดพลาด", "ไม่สามารถเข้าถึงจุดผีจอมขนมได้", "", 3)
        ClearTargetESP()
        return false
    end
end

-- 🔄 ลูป Auto Trick or Treat (วิ่งไปฟาร์มเคาะประตูบ้านตามจุดแบบลื่นไหล)
task.spawn(function()
    local recentKnocked = {}
    local lastKnockTime = 0
    local lastKnockPos = nil

    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(0.2)
        if State.AutoTrickOrTreat then
            -- ถ้ากำลังไปฝากแคนดี้หรือไปเอาถัง ให้หยุดรอ ไม่แย่งการเดิน
            if State.IsDepositing or State.IsGettingBucket then
                task.wait(0.6)
            else
                -- ตรวจสอบว่าแคนดี้เต็มถังหรือไม่ ถ้าเปิด AutoDeposit ให้แวะไปฝากทันที
                local held = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
                local cap = tonumber(LocalPlayer:GetAttribute("CandyCap")) or 50
                if held <= 0 and Hub.HalloweenState and Hub.HalloweenState.held then
                    held = Hub.HalloweenState.held
                    cap = Hub.HalloweenState.cap or 50
                end

                if State.AutoDepositCandy and held > 0 and (held >= cap or held >= (cap - 1)) then
                    Notify("🎃 แคนดี้เต็มถัง!", string.format("แคนดี้เต็มถัง (%d/%d) กำลังแวะไปฝากที่ผีจอมขนมอัตโนมัติ...", held, cap), "", 3.5)
                    DepositAllCandy(false)
                    task.wait(1.0)
                else
                    EquipCandyContainerTool()

                    local nowClock = os.clock()
                    for h, t in pairs(recentKnocked) do
                        if nowClock - t > 115 then
                            recentKnocked[h] = nil
                        end
                    end

                    local house, prompt, dist, pos, nextHouse, nextCooldown = GetNearestReadyHouse(recentKnocked)
                    if house and prompt and pos then
                        local houseTitle = "บ้านหลังที่ " .. house.Name
                        SetTargetESP(house, houseTitle .. " (Trick or Treat)", Color3.fromRGB(255, 130, 0), string.format("⚡ กำลังวาร์ปไปเคาะประตู (~%d ม.)", math.floor(dist * 0.28)))

                        -- วิ่ง/วาร์ปไปยังจุดหน้าบ้าน
                        local arrived = RunToHalloweenTarget(pos, prompt, 7.0, houseTitle, function()
                            return State.Running and State.AutoTrickOrTreat and not State.IsDepositing and not State.IsGettingBucket
                        end)

                        local hrp = GetHRP()
                        local hum = GetHuman()
                        if hrp and hum and prompt and prompt.Parent then
                            local curDist = (hrp.Position - pos).Magnitude
                            if curDist <= 9.2 then
                                SetTargetESP(house, houseTitle, Color3.fromRGB(255, 130, 0), "🚪 เตรียมเคาะประตู...")
                                
                                -- 🛑 หยุดสนิท 100% ป้องกัน Code 261 และ Code 264
                                hum:Move(Vector3.zero, false)
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                                SetSprinting(false)
                                task.wait(0.2)

                                -- 🛡️ ป้องกันระบบตรวจจับ "เดินทางมาเร็วผิดปกติ" ระหว่างหลัง
                                if Hub.LastKnockPos and Hub.LastKnockTime > 0 then
                                    local distFromLast = (pos - Hub.LastKnockPos).Magnitude
                                    local elapsed = os.clock() - Hub.LastKnockTime
                                    local minSafeTime = math.min(10, math.floor(distFromLast / 32))
                                    local waitSafe = minSafeTime - elapsed
                                    if waitSafe > 0.5 then
                                        local wSt = os.clock()
                                        while (os.clock() - wSt) < waitSafe and State.Running and State.AutoTrickOrTreat and not State.IsDepositing do
                                            local rem = math.ceil(waitSafe - (os.clock() - wSt))
                                            SetTargetESP(house, houseTitle, Color3.fromRGB(255, 180, 50), string.format("⏳ ป้องกันตรวจจับความเร็ว รออีก %d วิ...", rem))
                                            task.wait(0.5)
                                        end
                                    end
                                end

                                EquipCandyContainerTool()
                                task.wait(0.15)

                                local initialHeld = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
                                local knockStart = os.clock()
                                Hub.LastKnockEvent = nil

                                -- ตรวจสอบให้แน่ใจว่าบ้านไม่ติด Busy ก่อนเคาะ
                                if prompt:GetAttribute("Busy") == true then
                                    local bWait = os.clock()
                                    while (os.clock() - bWait) < 3.0 and prompt:GetAttribute("Busy") == true do
                                        task.wait(0.2)
                                    end
                                end

                                RobustFirePrompt(prompt)
                                SetTargetESP(house, houseTitle, Color3.fromRGB(255, 140, 0), "🚪 เคาะประตูแล้ว... กำลังรอรับแคนดี้")

                                -- ⏳ รอรับแคนดี้ หรือตรวจสอบว่าโดนผีหลอก / แจ้งเตือนความเร็ว (รอแอนิเมชันเปิดประตู 3-5 วินาที)
                                local knockResult = nil
                                local waitResultStart = os.clock()
                                local hasRetried = false

                                while (os.clock() - waitResultStart) < 7.0 and State.Running and State.AutoTrickOrTreat and not State.IsDepositing do
                                    task.wait(0.1)

                                    if Hub.LastKnockEvent and Hub.LastKnockEvent.time >= knockStart then
                                        local ev = Hub.LastKnockEvent
                                        if ev.kind == "Reward" then
                                            knockResult = "reward"
                                            break
                                        elseif ev.kind == "Scare" then
                                            knockResult = "scare"
                                            break
                                        elseif ev.kind == "SpeedWarning" then
                                            knockResult = "speed_warning"
                                            break
                                        end
                                    end

                                    local curHeld = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
                                    if curHeld > initialHeld then
                                        knockResult = "reward"
                                        break
                                    end

                                    -- หากผ่านไป 4.5 วินาทีแล้วไม่มีผลลัพธ์และไม่ติด Busy ให้ลองเคาะซ้ำ 1 ครั้งอย่างปลอดภัย
                                    if not hasRetried and (os.clock() - waitResultStart) >= 4.5 and prompt:GetAttribute("Busy") ~= true then
                                        hasRetried = true
                                        EquipCandyContainerTool()
                                        task.wait(0.1)
                                        RobustFirePrompt(prompt)
                                    end
                                end

                                -- จัดการตามผลลัพธ์:
                                if knockResult == "speed_warning" then
                                    -- เซิร์ฟเวอร์แจ้ง "เดินทางมาเร็วผิดปกติ รออีก X วิ เเล้วค่อยเคาะ"
                                    local waitSec = (Hub.LastKnockEvent and Hub.LastKnockEvent.seconds) or 12
                                    Notify("⏳ มาเร็วเกินไป", string.format("เซิร์ฟเวอร์ให้รออีก %d วิ กำลังนับถอยหลัง...", waitSec), "", 3.5)
                                    local endCd = os.clock() + waitSec + 0.5
                                    while os.clock() < endCd and State.Running and State.AutoTrickOrTreat and not State.IsDepositing do
                                        local rem = math.ceil(endCd - os.clock())
                                        SetTargetESP(house, houseTitle, Color3.fromRGB(255, 120, 50), string.format("⏳ รอนับถอยหลังอีก %d วิ ก่อนเคาะซ้ำ...", rem))
                                        task.wait(1.0)
                                    end
                                    -- เคาะซ้ำอีกรอบหลังจากหมดเวลา
                                    if State.Running and State.AutoTrickOrTreat and not State.IsDepositing and prompt and prompt.Parent then
                                        SetTargetESP(house, houseTitle, Color3.fromRGB(255, 130, 0), "🚪 เคาะประตูซ้ำ...")
                                        EquipCandyContainerTool()
                                        task.wait(0.15)
                                        initialHeld = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
                                        knockStart = os.clock()
                                        lastFireTime = os.clock()
                                        Hub.LastKnockEvent = nil
                                        RobustFirePrompt(prompt, pos)
                                        local st2 = os.clock()
                                        while (os.clock() - st2) < 6.0 and State.Running and State.AutoTrickOrTreat and not State.IsDepositing do
                                            task.wait(0.1)
                                            if Hub.LastKnockEvent and Hub.LastKnockEvent.time >= knockStart then
                                                if Hub.LastKnockEvent.kind == "Reward" or Hub.LastKnockEvent.kind == "Scare" then 
                                                    knockResult = (Hub.LastKnockEvent.kind == "Reward" and "reward" or "scare")
                                                    break 
                                                end
                                            end
                                            if (tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0) > initialHeld then 
                                                knockResult = "reward"
                                                break 
                                            end
                                            if (os.clock() - lastFireTime) >= 2.5 and not knockResult and prompt:GetAttribute("Busy") ~= true then
                                                lastFireTime = os.clock()
                                                RobustFirePrompt(prompt, pos)
                                            end
                                        end
                                    end
                                    recentKnocked[house] = os.clock()
                                    Hub.LastKnockTime = os.clock()
                                    Hub.LastKnockPos = pos
                                elseif knockResult == "scare" then
                                    -- 👻 โดนผีหลอก (ไม่ได้แคนดี้) -> วาร์ปเปลี่ยนหลังทันที
                                    recentKnocked[house] = os.clock()
                                    Hub.LastKnockTime = os.clock()
                                    Hub.LastKnockPos = pos
                                    Notify("👻 ผีหลอก!", "บ้านนี้ไม่ได้แคนดี้ วาร์ปไปบ้านหลังถัดไปทันที...", "", 2.5)
                                    SetTargetESP(house, houseTitle, Color3.fromRGB(255, 60, 60), "👻 โดนผีหลอก! ย้ายหลังทันที...")
                                    task.wait(0.2)
                                elseif knockResult == "reward" then
                                    -- 🎃 ได้รับแคนดี้เรียบร้อย
                                    recentKnocked[house] = os.clock()
                                    Hub.LastKnockTime = os.clock()
                                    Hub.LastKnockPos = pos
                                    local newHeld = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
                                    local capHeld = tonumber(LocalPlayer:GetAttribute("CandyCap")) or 50
                                    Notify("🎃 ได้รับแคนดี้!", string.format("เก็บแคนดี้สำเร็จ (%d/%d) เตรียมไปหลังถัดไป", newHeld, capHeld), "", 2.5)
                                    SetTargetESP(house, houseTitle, Color3.fromRGB(100, 255, 100), "✅ ได้รับแคนดี้แล้ว!")
                                    task.wait(0.8)
                                else
                                    -- ไม่มีการตอบสนอง (Timeout) หน่วงคูลดาวน์สั้น 5 วิ แล้วลองใหม่
                                    recentKnocked[house] = os.clock() - 110
                                    Hub.LastKnockTime = os.clock()
                                    Hub.LastKnockPos = pos
                                    task.wait(0.4)
                                end
                            end
                        end
                    else
                        if nextCooldown and nextCooldown > 0 and nextCooldown < 9999 then
                            local waitSec = math.ceil(nextCooldown)
                            SetTargetESP(nextHouse, "บ้าน: " .. (nextHouse and nextHouse.Name or ""), Color3.fromRGB(255, 180, 50), string.format("⏳ รอคูลดาวน์อีก %d วินาที...", waitSec))
                            task.wait(1.0)
                        else
                            ClearTargetESP()
                            task.wait(1.0)
                        end
                    end
                end
            end
        else
            table.clear(recentKnocked)
            lastKnockTime = 0
            lastKnockPos = nil
        end
    end
end)

-- 🔄 ลูป Auto Dig Graves (ขุด/ทุบหลุมศพ)
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(0.2)
        if State.AutoDigGraves and not State.AutoTrickOrTreat then
            local grave, prompt, dist, pos = GetNearestHalloweenGrave()
            if grave and prompt and pos then
                SetTargetESP(grave, "หลุมศพ (" .. (prompt.ActionText or "ขุด/ทุบ") .. ")", Color3.fromRGB(180, 80, 255), "⚡ กำลังวาร์ปไป")
                local arrived = RunToHalloweenTarget(pos, prompt, 5.0, "หลุมศพ")

                local hrp = GetHRP()
                local hum = GetHuman()
                if hrp and prompt and prompt.Parent and (hrp.Position - pos).Magnitude <= 6.5 then
                    SetTargetESP(grave, "หลุมศพ", Color3.fromRGB(180, 80, 255), "⛏️ กำลังขุด/ทุบ")
                    local holdTime = prompt.HoldDuration or 0.5
                    pcall(function() prompt:InputHoldBegin() end)
                    local stH = os.clock()
                    while (os.clock() - stH) < holdTime and State.AutoDigGraves and State.Running do
                        task.wait(0.04)
                    end
                    pcall(function() fireproximityprompt(prompt) end)
                    pcall(function() prompt:InputHoldEnd() end)

                    -- ⏳ รอมินิเกมหรือแถบความคืบหน้าการขุดปรากฏขึ้น (รอสูงสุด 2.5 วินาที)
                    local startCheck = os.clock()
                    while (os.clock() - startCheck) < 2.5 and State.AutoDigGraves and State.Running do
                        if IsGraveMinigameActive() then break end
                        task.wait(0.05)
                    end

                    -- 🛑 ล็อกตำแหน่งตัวละครให้อยู่นิ่งกับที่ 100% จนกว่าจะเล่นมินิเกมเสร็จ และขุดครบ 100%
                    if IsGraveMinigameActive() or (prompt and prompt.Parent == nil) then
                        local lockCF = hrp.CFrame
                        local digStartTime = os.clock()
                        while State.AutoDigGraves and State.Running and (os.clock() - digStartTime) < 40 do
                            -- ตรวจสอบว่ามินิเกมหรือการขุดยังดำเนินอยู่หรือไม่
                            if not IsGraveMinigameActive() then
                                task.wait(0.3)
                                if not IsGraveMinigameActive() then
                                    break -- ขุดเสร็จครบ 100% และปิดตัวลงแล้ว
                                end
                            end

                            if hrp then
                                hrp.CFrame = lockCF
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                            end
                            if hum then
                                hum.WalkSpeed = 0
                            end
                            SetTargetESP(grave, "หลุมศพ", Color3.fromRGB(180, 80, 255), "⛏️ กำลังขุด/เล่นมินิเกม (รอครบ 100%)...")
                            task.wait(0.05)
                        end

                        -- รอเก็บของดรอป / ลูกกวาด ให้เรียบร้อย
                        task.wait(0.8)
                    else
                        task.wait(1.0)
                    end
                end
            else
                ClearTargetESP()
                task.wait(1.0)
            end
        end
    end
end)

-- 👁️ Halloween ESP Loop (มอนสเตอร์, หลุมศพ, บ้าน, ชิ้นส่วน P320)
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(1.0)
        if State.HalloweenMonstersESP or State.HalloweenP320ESP then
            pcall(function()
                local hw = Workspace:FindFirstChild("Helloween")
                if not hw then return end

                -- มอนสเตอร์ & บอส ESP
                if State.HalloweenMonstersESP and hw:FindFirstChild("Monsters") then
                    for _, m in ipairs(hw.Monsters:GetChildren()) do
                        if m:IsA("Model") and not Hub.HalloweenESPObjects[m] then
                            local p = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                            local hum = m:FindFirstChildOfClass("Humanoid")
                            if p and hum and hum.Health > 0 then
                                local isBoss = m.Name:find("Boss") or m.Name:find("Pad") or m.Name:find("กระสือ")
                                local col = isBoss and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 220, 255)
                                local hl = Instance.new("Highlight")
                                hl.Name = "HwMonsterHL"
                                hl.Adornee = m
                                hl.FillColor = col
                                hl.FillTransparency = 0.5
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = targetGuiParent

                                local bb = Instance.new("BillboardGui")
                                bb.Name = "HwMonsterBB"
                                bb.Adornee = p
                                bb.Size = UDim2.new(0, 140, 0, 32)
                                bb.StudsOffset = Vector3.new(0, 3.2, 0)
                                bb.AlwaysOnTop = true
                                bb.MaxDistance = 400

                                local lbl = Instance.new("TextLabel", bb)
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextSize = 11
                                lbl.TextColor3 = col
                                lbl.TextStrokeTransparency = 0.2
                                lbl.Text = string.format("%s [%d HP]", m.Name, math.floor(hum.Health))
                                bb.Parent = targetGuiParent

                                Hub.HalloweenESPObjects[m] = {hl, bb}
                            end
                        end
                    end
                end

                -- ชิ้นส่วน P320 ESP (แก้บัคแม็กกระสุน Mag ไม่ขึ้น และรองรับทั้ง Model/BasePart)
                if State.HalloweenP320ESP then
                    -- เคลียร์ออบเจกต์ ESP ที่ถูกเก็บไปแล้วหรือถูกทำลายทิ้ง
                    for obj, guiPair in pairs(Hub.HalloweenESPObjects) do
                        if not obj or not obj.Parent or not obj:IsDescendantOf(Workspace) then
                            pcall(function() guiPair[1]:Destroy() end)
                            pcall(function() guiPair[2]:Destroy() end)
                            Hub.HalloweenESPObjects[obj] = nil
                        end
                    end

                    local p320Folder = Workspace:FindFirstChild("Quest") and Workspace.Quest:FindFirstChild("Quest Option") and Workspace.Quest["Quest Option"]:FindFirstChild("P320")
                    if p320Folder then
                        local candidates = {}
                        for _, item in ipairs(p320Folder:GetChildren()) do
                            table.insert(candidates, item)
                        end
                        for _, item in ipairs(p320Folder:GetDescendants()) do
                            if not table.find(candidates, item) then
                                local lName = item.Name:lower()
                                if lName:find("mag") or lName:find("barrel") or lName:find("slide") or item.Name == "H" or lName:find("handle") or lName:find("frame") or lName:find("แม็ก") then
                                    table.insert(candidates, item)
                                end
                            end
                        end

                        for _, part in ipairs(candidates) do
                            local adorneePart = (part:IsA("BasePart") and part)
                                             or part:FindFirstChildWhichIsA("BasePart", true)
                                             or (part:IsA("Model") and part.PrimaryPart)

                            if adorneePart and adorneePart.Parent and not Hub.HalloweenESPObjects[part] then
                                local pName = part.Name
                                local lName = pName:lower()
                                local partThaiName = "ชิ้นส่วน P320"
                                if lName:find("mag") or lName:find("แม็ก") then
                                    partThaiName = "แม็กกระสุน P320 (Mag)"
                                elseif lName:find("barrel") or lName:find("ลำกล้อง") then
                                    partThaiName = "ลำกล้อง P320 (Barrel)"
                                elseif lName:find("slide") or lName:find("สไลด์") then
                                    partThaiName = "สไลด์ P320 (Slide)"
                                elseif pName == "H" or lName:find("handle") or lName:find("frame") or lName:find("ด้าม") then
                                    partThaiName = "โครงปืน/ด้ามจับ P320 (H)"
                                else
                                    partThaiName = "ชิ้นส่วน: " .. pName
                                end

                                local hl = Instance.new("Highlight")
                                hl.Name = "HwP320HL"
                                hl.Adornee = (part:IsA("Model") and part) or adorneePart
                                hl.FillColor = Color3.fromRGB(255, 215, 0)
                                hl.FillTransparency = 0.2
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = targetGuiParent

                                local bb = Instance.new("BillboardGui")
                                bb.Name = "HwP320BB"
                                bb.Adornee = adorneePart
                                bb.Size = UDim2.new(0, 160, 0, 30)
                                bb.StudsOffset = Vector3.new(0, 2.2, 0)
                                bb.AlwaysOnTop = true
                                bb.MaxDistance = 800

                                local lbl = Instance.new("TextLabel", bb)
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextSize = 12
                                lbl.TextColor3 = Color3.fromRGB(255, 225, 0)
                                lbl.TextStrokeTransparency = 0.15
                                lbl.Text = "🔫 " .. partThaiName
                                bb.Parent = targetGuiParent

                                Hub.HalloweenESPObjects[part] = {hl, bb}
                            end
                        end
                    end
                end
            end)
        else
            ClearHalloweenESP()
        end
    end
end)

-- ฟังก์ชันเก็บชิ้นส่วน P320 อัตโนมัติ (รองรับแม็กกระสุนและชิ้นส่วนทุกรูปแบบ)
local function CollectAllP320Parts(silent)
    local p320Folder = Workspace:FindFirstChild("Quest") and Workspace.Quest:FindFirstChild("Quest Option") and Workspace.Quest["Quest Option"]:FindFirstChild("P320")
    if not p320Folder then
        if not silent then Notify("เควส P320", "ไม่พบโฟลเดอร์เควสต์ P320 ใน Workspace", "", 3) end
        return 0
    end

    local hrp = GetHRP()
    if not hrp then return 0 end

    local parts = {"Barrel", "Slide", "Mag", "H"}
    local collectedCount = 0
    if not silent then
        Notify("เควส P320", "เริ่มเทเลพอร์ตเก็บชิ้นส่วน P320 ทั้ง 4 ชิ้น...", "", 3)
    end
    for _, partName in ipairs(parts) do
        local pObj = p320Folder:FindFirstChild(partName)
        if not pObj then
            for _, d in ipairs(p320Folder:GetDescendants()) do
                if d.Name:lower() == partName:lower() or d.Name:lower():find(partName:lower()) then
                    pObj = d
                    break
                end
            end
        end

        if pObj then
            local adorneePart = (pObj:IsA("BasePart") and pObj)
                             or pObj:FindFirstChildWhichIsA("BasePart", true)
                             or (pObj:IsA("Model") and pObj.PrimaryPart)

            local prompt = pObj:FindFirstChildWhichIsA("ProximityPrompt", true) 
                        or (adorneePart and adorneePart:FindFirstChildWhichIsA("ProximityPrompt", true))

            if prompt and prompt.Enabled and adorneePart then
                local partStandPos = adorneePart.Position + Vector3.new(0, 2.5, 0)
                SafeTeleport(partStandPos, "ชิ้นส่วน P320 (" .. partName .. ")", adorneePart.Position, true)
                task.wait(0.25)
                pcall(function() fireproximityprompt(prompt) end)
                task.wait(0.3)
                collectedCount = collectedCount + 1
            end
        end
    end
    if collectedCount > 0 and not silent then
        Notify("เควส P320", "เก็บชิ้นส่วน P320 เรียบร้อย! สามารถวาร์ปไปส่งเควสต์กับผีช่างปืนได้เลย", "", 4)
    end
    return collectedCount
end

-- ฟังก์ชันเคลมรางวัลเควสต์ฮาโลวีนทั้งหมด
local function ClaimAllHalloweenQuests(silent)
    local hf = ReplicatedStorage:FindFirstChild("Halloween") and ReplicatedStorage.Halloween:FindFirstChild("HalloweenFunc")
    if not hf then return end
    local s, res = pcall(function() return hf:InvokeServer("State") end)
    if s and type(res) == "table" and res.state and res.state.quests then
        local claimedCount = 0
        for qId, qData in pairs(res.state.quests) do
            if qData.claimed == false then
                local s2, r2 = pcall(function() return hf:InvokeServer("Claim", qId) end)
                if s2 and r2 and r2.ok then
                    claimedCount = claimedCount + 1
                end
            end
        end
        if claimedCount > 0 then
            Notify("เควสต์ฮาโลวีน", string.format("กดรับรางวัลเควสต์สำเร็จ %d เควสต์!", claimedCount), "", 3.5)
            FetchHalloweenState()
        elseif not silent then
            Notify("เควสต์ฮาโลวีน", "ไม่มีเควสต์ที่พร้อมรับรางวัลในขณะนี้", "", 2.5)
        end
    elseif not silent then
        Notify("เควสต์ฮาโลวีน", "ไม่สามารถดึงข้อมูลเควสต์ได้", "", 3)
    end
end

-- ค้นหาจุดและ ProximityPrompt ของหม้อ/บ่อแคนดี้ (Cauldron)
local function GetCauldronDepositTarget()
    local hw = Workspace:FindFirstChild("Helloween")
    local candySpot = hw and hw:FindFirstChild("จุดสำคัญ") and hw["จุดสำคัญ"]:FindFirstChild("จุดใส่แคนดี้")
    local cauldron = candySpot and candySpot:FindFirstChild("FBX_Cauldron", true)
    local prompt = cauldron and cauldron:FindFirstChildWhichIsA("ProximityPrompt", true)
    local promptPos = Vector3.new(2117.26, 5.15, -346.63)
    if prompt and prompt.Parent then
        if prompt.Parent:IsA("Attachment") then
            promptPos = prompt.Parent.WorldPosition
        elseif prompt.Parent:IsA("BasePart") then
            promptPos = prompt.Parent.Position
        end
    end
    -- จุดยืนเปิดโล่งหน้าบ่อ/หม้อแคนดี้ (ระยะห่างพอดี ไม่ชนตัวหม้อและฟักทองรอบข้าง)
    local standPos = Vector3.new(2119.5, 3.5, -342.7)
    return cauldron, prompt, promptPos, standPos
end

-- ฟังก์ชันนำแคนดี้ไปวาง/เทลงบ่อแคนดี้ (Cauldron) อย่างเสถียรและปลอดภัย 100%
local function DepositAllCandy(silent)
    if State.IsDepositing then return false end
    State.IsDepositing = true

    local success = false
    local function cleanup()
        State.IsDepositing = false
        ClearTargetESP()
        SetSprinting(false)
        local hum = GetHuman()
        if hum then hum:Move(Vector3.zero, false) end
        local h = GetHRP()
        if h then
            h.AssemblyLinearVelocity = Vector3.zero
            h.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local hrp = GetHRP()
    local hum = GetHuman()
    if not hrp or not hum then
        cleanup()
        return false
    end

    local held = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
    if held <= 0 and Hub.HalloweenState and Hub.HalloweenState.held then
        held = Hub.HalloweenState.held
    end
    if held <= 0 then
        cleanup()
        return true
    end

    local cauldron, prompt, promptPos, standPos = GetCauldronDepositTarget()
    local curDist = (hrp.Position - standPos).Magnitude
    if curDist > 6.0 then
        if not silent then
            Notify("🥣 ฝากแคนดี้", string.format("กำลังวาร์ปไปเทแคนดี้ลงบ่อ... (~%d ม.)", math.floor(curDist * 0.28)), "", 2.5)
        end
        SetTargetESP(cauldron or standPos, "หม้อแคนดี้ (บ่อใส่แคนดี้)", Color3.fromRGB(255, 140, 0), "⚡ กำลังวาร์ปไปบ่อแคนดี้...")
        SafeTeleport(standPos, "บ่อแคนดี้", promptPos, true, nil)
        ClearTargetESP()
    end

    hrp = GetHRP()
    hum = GetHuman()
    if not hrp or not hum or hum.Health <= 0 then
        cleanup()
        return false
    end

    -- หยุดตัวละครสนิทและหันหน้าเข้าหาบ่อแคนดี้
    hum:Move(Vector3.zero, false)
    SetSprinting(false)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(promptPos.X, hrp.Position.Y, promptPos.Z))
    task.wait(0.2)

    -- 🛡️ ป้องกันระบบตรวจจับ "เดินทางมาเร็วผิดปกติ รออีก X วิ เเล้วค่อยเท"
    if Hub.LastKnockPos and Hub.LastKnockTime > 0 then
        local distFromLast = (standPos - Hub.LastKnockPos).Magnitude
        local elapsed = os.clock() - Hub.LastKnockTime
        local minSafeTime = math.min(12, math.floor(distFromLast / 32))
        local waitSafe = minSafeTime - elapsed
        if waitSafe > 0.4 then
            local wSt = os.clock()
            while (os.clock() - wSt) < waitSafe and State.Running and State.IsDepositing do
                local rem = math.ceil(waitSafe - (os.clock() - wSt))
                SetTargetESP(cauldron or promptPos, "หม้อแคนดี้", Color3.fromRGB(255, 180, 50), string.format("⏳ ป้องกันตรวจจับความเร็ว รออีก %d วิ...", rem))
                task.wait(0.5)
            end
        end
    end

    -- 🎒 ถือถังแคนดี้ในมือเสมอ เพื่อให้ ProximityPrompt บ่อแคนดี้เปิดทำงาน (Enabled = true)
    EquipCandyContainerTool()
    task.wait(0.25)

    -- รีเฟรช Prompt และตรวจสอบ
    cauldron, prompt, promptPos, standPos = GetCauldronDepositTarget()
    if prompt and prompt.Parent then
        pcall(function() prompt.Enabled = true end)
        SetTargetESP(cauldron or promptPos, "หม้อแคนดี้", Color3.fromRGB(255, 140, 0), "🥣 กำลังเทแคนดี้ลงบ่อ...")

        local function doTriggerPrompt()
            EquipCandyContainerTool()
            pcall(function() prompt.Enabled = true end)
            if fireproximityprompt then
                pcall(function() fireproximityprompt(prompt) end)
            else
                pcall(function()
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration > 0 and prompt.HoldDuration or 0.5)
                    prompt:InputHoldEnd()
                end)
            end
        end

        local depositStart = os.clock()
        Hub.LastKnockEvent = nil
        doTriggerPrompt()

        -- รอจนกว่าแคนดี้ในตัวจะกลายเป็น 0 หรือมีสัญญาณแจ้งเตือนความเร็ว
        local waitDep = os.clock()
        while (os.clock() - waitDep) < 8.0 and State.Running and State.IsDepositing do
            task.wait(0.2)

            -- ตรวจสอบว่าแคนดี้หมดตัวแล้ว (ฝากสำเร็จ)
            local heldNow = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
            if heldNow == 0 then
                success = true
                break
            end

            -- ตรวจสอบสัญญาณแจ้งเตือนจากเซิร์ฟเวอร์
            if Hub.LastKnockEvent and Hub.LastKnockEvent.time >= depositStart then
                local ev = Hub.LastKnockEvent
                if ev.kind == "SpeedWarning" then
                    local sec = ev.seconds or 2
                    Notify("⏳ เดินทางมาเร็ว", string.format("รออีก %d วิ ตามที่เซิร์ฟเวอร์แจ้ง แล้วจะเทซ้ำ...", sec), "", 3)
                    local endCd = os.clock() + sec + 0.6
                    while os.clock() < endCd and State.Running and State.IsDepositing do
                        local rem = math.ceil(endCd - os.clock())
                        SetTargetESP(cauldron or promptPos, "หม้อแคนดี้", Color3.fromRGB(255, 120, 50), string.format("⏳ รอนับถอยหลังอีก %d วิ ก่อนเทซ้ำ...", rem))
                        task.wait(0.5)
                    end
                    depositStart = os.clock()
                    waitDep = os.clock()
                    Hub.LastKnockEvent = nil
                    doTriggerPrompt()
                end
            end
        end

        Hub.LastKnockTime = os.clock()
        Hub.LastKnockPos = standPos
    end

    local finalHeld = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
    if finalHeld == 0 or success then
        success = true
        Notify("🎉 สำเร็จ!", "เทแคนดี้ลงบ่อเข้าคลังเรียบร้อย!", "", 3.5)
        FetchHalloweenState()
    else
        Notify("⚠️ เทแคนดี้ไม่สำเร็จ", "กำลังลองใหม่ในรอบถัดไป...", "", 3)
    end

    cleanup()
    return success
end

-- วาร์ปไปหาบอสฮาโลวีนที่เกิดอยู่
local function TeleportToActiveHalloweenBoss()
    local hw = Workspace:FindFirstChild("Helloween")
    local monsters = hw and hw:FindFirstChild("Monsters")
    if not monsters then
        Notify("บอสฮาโลวีน", "ไม่พบโฟลเดอร์มอนสเตอร์ใน Workspace", "", 3)
        return false
    end

    local hrp = GetHRP()
    if not hrp then return false end

    for _, m in ipairs(monsters:GetChildren()) do
        if m:IsA("Model") and (m.Name:find("Boss") or m.Name:find("Pad") or m.Name:find("กระสือ") or m.Name:find("เปรต")) then
            local part = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
            local hum = m:FindFirstChildOfClass("Humanoid")
            if part and hum and hum.Health > 0 then
                local targetPos = part.Position + Vector3.new(0, 3.5, 6)
                task.spawn(function()
                    SafeTeleport(targetPos, "บอส: " .. m.Name, part.Position)
                end)
                return true
            end
        end
    end
    Notify("บอสฮาโลวีน", "ขณะนี้ยังไม่มีบอสฮาโลวีนเกิดในเซิร์ฟเวอร์", "", 3)
    return false
end

--------------------------------------------------------------
-- 🎃 สร้างเมนูใน TABS.HALLOWEEN (อีเวนต์ฮาโลวีน)
--------------------------------------------------------------
do
FetchHalloweenState()
local initHwTitle = "🎃 อีเวนต์ฮาโลวีน (Halloween Event)"
local initHwDesc = GetHalloweenStatusString()

local HalloweenStatusParagraph = Tabs.Halloween:AddParagraph({
    Title = initHwTitle,
    Content = initHwDesc
})

task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(3.0)
        pcall(function()
            FetchHalloweenState()
            if HalloweenStatusParagraph and type(HalloweenStatusParagraph.SetDesc) == "function" then
                HalloweenStatusParagraph:SetDesc(GetHalloweenStatusString())
            end
        end)
    end
end)

Tabs.Halloween:AddSection("👻 ฟาร์มฮาโลวีนอัตโนมัติ (Auto Farm)")

Tabs.Halloween:AddToggle("AutoTrickOrTreatOn", {
    Title = "🚪 เคาะประตูบ้านอัตโนมัติ (Auto Trick or Treat)",
    Description = "เดินไปเคาะประตูบ้านที่พร้อมอัตโนมัติ สลับถือถังแคนดี้และรับรางวัล",
    Default = false
}):OnChanged(function()
    State.AutoTrickOrTreat = Options.AutoTrickOrTreatOn.Value
    if not State.AutoTrickOrTreat then
        ClearTargetESP()
        Notify("ฮาโลวีน", "ปิดระบบเคาะประตูอัตโนมัติแล้ว", "", 2.5)
    else
        Notify("ฮาโลวีน", "เริ่มระบบเคาะประตู Trick or Treat อัตโนมัติ!", "", 3)
    end
end)

Tabs.Halloween:AddToggle("AutoDigGravesOn", {
    Title = "⚰️ ขุด/ทุบหลุมศพอัตโนมัติ (Auto Dig Graveyard)",
    Description = "เดินไปจุดหลุมศพในสุสานแล้วกดขุดหรือทุบอัตโนมัติ",
    Default = false
}):OnChanged(function()
    State.AutoDigGraves = Options.AutoDigGravesOn.Value
    if not State.AutoDigGraves then
        ClearTargetESP()
        Notify("ฮาโลวีน", "ปิดระบบขุดหลุมศพอัตโนมัติแล้ว", "", 2.5)
    else
        Notify("ฮาโลวีน", "เริ่มระบบขุด/ทุบหลุมศพอัตโนมัติ!", "", 3)
    end
end)

Tabs.Halloween:AddToggle("AutoGraveQTEOn", {
    Title = "⚡ ชนะผีหลุมศพทันที (Auto QTE Win & Fast Drag)",
    Description = "ส่งสัญญาณชนะ QTE ผีทันที และลากหลุมศพอย่างรวดเร็วไม่ต้องกดเอง",
    Default = true
}):OnChanged(function()
    State.AutoGraveQTE = Options.AutoGraveQTEOn.Value
end)

Tabs.Halloween:AddToggle("AutoVacuumLootOn", {
    Title = "🧲 ดูดเก็บของดรอปหลุมศพอัตโนมัติ (Auto Vacuum Loot)",
    Description = "ส่งคำสั่งเก็บของและแคนดี้ที่หล่นจากหลุมศพเข้าตัวทันที",
    Default = true
}):OnChanged(function()
    State.AutoVacuumLoot = Options.AutoVacuumLootOn.Value
end)

Tabs.Halloween:AddToggle("AutoJoinEvent2hOn", {
    Title = "⚔️ เข้าร่วมอีเวนต์ 2 ชม. อัตโนมัติ (Auto Join Event)",
    Description = "เมื่อมีอีเวนต์ทุกๆ 2 ชั่วโมงเปิดรับสมัคร จะกดเข้าร่วมให้อัตโนมัติ",
    Default = true
}):OnChanged(function()
    State.AutoJoinEvent2h = Options.AutoJoinEvent2hOn.Value
end)

Tabs.Halloween:AddSection("🎁 ระบบเควสต์ & คลังแคนดี้")

Tabs.Halloween:AddToggle("AutoGetBucketOn", {
    Title = "🎒 วิ่งไปเอาถังแคนดี้อัตโนมัติ (Auto Get Candy Bucket)",
    Description = "ตรวจสอบถังแคนดี้ในตัว หากยังไม่มีหรือถังหลุดมือ จะวิ่งไปซื้อ/รับที่ผีจอมขนมอัตโนมัติ",
    Default = false
}):OnChanged(function()
    State.AutoGetBucket = Options.AutoGetBucketOn.Value
    if State.AutoGetBucket then
        Notify("🎃 ถังแคนดี้", "เปิดระบบวาร์ปไปเอาถังแคนดี้แล้ว", "", 2.5)
        task.spawn(function() AutoGetCandyBucket(true) end)
    else
        Notify("🎃 ถังแคนดี้", "ปิดระบบวาร์ปไปเอาถังแคนดี้แล้ว", "", 2.5)
    end
end)

Tabs.Halloween:AddToggle("AutoDepositCandyOn", {
    Title = "📥 ฝากแคนดี้ทั้งหมดเข้าคลังอัตโนมัติ (Auto Deposit Candy)",
    Description = "เมื่อแคนดี้ในถังเต็ม (หรือกดเปิด) จะเดินทางไปฝากเข้าคลังที่ผีจอมขนมอัตโนมัติ",
    Default = false
}):OnChanged(function()
    State.AutoDepositCandy = Options.AutoDepositCandyOn.Value
    if State.AutoDepositCandy then
        local held = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
        if held <= 0 and Hub.HalloweenState and Hub.HalloweenState.held then
            held = Hub.HalloweenState.held
        end
        if held > 0 then
            Notify("🎃 ฝากแคนดี้", string.format("เปิดระบบออโต้แล้ว! (มีแคนดี้ %d เม็ด) กำลังนำไปเทลงบ่อ...", held), "", 3)
            task.spawn(function()
                DepositAllCandy(false)
            end)
        else
            Notify("🎃 ฝากแคนดี้", "เปิดระบบออโต้แล้ว! เมื่อแคนดี้เต็มถัง ระบบจะวิ่งไปเทลงบ่อให้อัตโนมัติ", "", 3.5)
        end
    else
        Notify("🎃 ฝากแคนดี้", "ปิดระบบออโต้ฝากแคนดี้แล้ว", "", 2.5)
    end
end)

Tabs.Halloween:AddToggle("AutoClaimQuestsOn", {
    Title = "🎁 กดรับรางวัลเควสต์ทั้งหมดอัตโนมัติ (Auto Claim Quests)",
    Description = "สแกนเควสต์และกดเคลมของรางวัลเควสต์ฮาโลวีนที่ทำเสร็จแล้วให้อัตโนมัติ",
    Default = false
}):OnChanged(function()
    State.AutoClaimQuests = Options.AutoClaimQuestsOn.Value
    if State.AutoClaimQuests then
        Notify("🎃 เควสต์ฮาโลวีน", "เปิดระบบออโต้รับรางวัลเควสต์ฮาโลวีนแล้ว", "", 2.5)
        task.spawn(function() ClaimAllHalloweenQuests(false) end)
    else
        Notify("🎃 เควสต์ฮาโลวีน", "ปิดระบบออโต้รับรางวัลเควสต์ฮาโลวีนแล้ว", "", 2.5)
    end
end)

Tabs.Halloween:AddToggle("AutoCollectP320On", {
    Title = "🔫 วาร์ปเก็บชิ้นส่วน P320 ทั้ง 4 ชิ้นอัตโนมัติ (Auto Collect P320)",
    Description = "วนลูปเก็บชิ้นส่วนปืนอาถรรพ์ P320 (Barrel, Slide, Mag, H) ให้ครบทั้ง 4 ชิ้นอัตโนมัติ",
    Default = false
}):OnChanged(function()
    State.AutoCollectP320 = Options.AutoCollectP320On.Value
    if State.AutoCollectP320 then
        Notify("🎃 เควสต์ P320", "เปิดระบบออโต้เก็บชิ้นส่วน P320 แล้ว", "", 2.5)
        task.spawn(function() CollectAllP320Parts(false) end)
    else
        Notify("🎃 เควสต์ P320", "ปิดระบบออโต้เก็บชิ้นส่วน P320 แล้ว", "", 2.5)
    end
end)

-- 🔄 ลูปออโต้ไปเอาถังแคนดี้
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(3.0)
        if State.AutoGetBucket and not State.IsGettingBucket and not State.IsDepositing then
            local hasTool, tool = EquipCandyContainerTool()
            if not hasTool then
                AutoGetCandyBucket()
                task.wait(2.5)
            end
        end
    end
end)

-- 🔄 ลูปออโต้ฝากแคนดี้เข้าคลัง
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(2.5)
        if State.AutoDepositCandy and not State.IsDepositing and not State.IsGettingBucket then
            local held = tonumber(LocalPlayer:GetAttribute("CandyHeld")) or 0
            local cap = tonumber(LocalPlayer:GetAttribute("CandyCap")) or 50
            if held <= 0 and Hub.HalloweenState and Hub.HalloweenState.held then
                held = Hub.HalloweenState.held
                cap = Hub.HalloweenState.cap or 50
            end
            if held > 0 and (held >= cap or held >= (cap - 2)) then
                Notify("🎃 ออโต้ฝากแคนดี้", string.format("แคนดี้เต็มถัง (%d/%d)! กำลังไปฝากที่ผีจอมขนม...", held, cap), "", 3.5)
                DepositAllCandy(false)
                task.wait(2.5)
            end
        end
    end
end)

-- 🔄 ลูปออโต้รับรางวัลเควสต์ฮาโลวีน
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(4.0)
        if State.AutoClaimQuests then
            ClaimAllHalloweenQuests(true)
        end
    end
end)

-- 🔄 ลูปออโต้เก็บชิ้นส่วน P320
task.spawn(function()
    while State.Running and _G._KrakenScriptId == MY_SCRIPT_ID do
        task.wait(3.5)
        if State.AutoCollectP320 then
            local pCount = CollectAllP320Parts(true)
            if pCount == 0 then
                local p320Folder = Workspace:FindFirstChild("Quest") and Workspace.Quest:FindFirstChild("Quest Option") and Workspace.Quest["Quest Option"]:FindFirstChild("P320")
                local hasUncollected = false
                if p320Folder then
                    for _, pName in ipairs({"Barrel", "Slide", "Mag", "H"}) do
                        local obj = p320Folder:FindFirstChild(pName)
                        local pr = obj and obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if pr and pr.Enabled then hasUncollected = true break end
                    end
                end
                if not hasUncollected then
                    State.AutoCollectP320 = false
                    if Options.AutoCollectP320On then Options.AutoCollectP320On:SetValue(false) end
                    Notify("🔫 เควสต์ P320", "เก็บชิ้นส่วน P320 ครบแล้ว! ปิดระบบออโต้", "", 4)
                end
            end
            task.wait(4.0)
        end
    end
end)

end

do
Tabs.Halloween:AddSection("👁️ มองทะลุฮาโลวีน (Halloween ESP)")

Tabs.Halloween:AddToggle("HalloweenMonstersESPOn", {
    Title = "👾 ESP มอนสเตอร์ & บอสฮาโลวีน",
    Description = "แสดงชื่อ, หลอดเลือด และตำแหน่งมอนสเตอร์ฮาโลวีนทะลุกำแพง",
    Default = false
}):OnChanged(function()
    State.HalloweenMonstersESP = Options.HalloweenMonstersESPOn.Value
    if not State.HalloweenMonstersESP then
        ClearHalloweenESP()
    end
end)

Tabs.Halloween:AddToggle("HalloweenP320ESPOn", {
    Title = "🔫 ESP ชิ้นส่วนปืนอาถรรพ์ P320",
    Description = "แสดงกล่องสีทองทะลุกำแพงตรงจุดซ่อนชิ้นส่วน P320 ทั้ง 4 ชิ้น",
    Default = false
}):OnChanged(function()
    State.HalloweenP320ESP = Options.HalloweenP320ESPOn.Value
    if not State.HalloweenP320ESP then
        ClearHalloweenESP()
    end
end)
end

do
Tabs.Halloween:AddSection("⚡ เทเลพอร์ตฮาโลวีน (Halloween Teleports)")

Tabs.Halloween:AddButton({
    Title = "🍬 วาร์ปไป ผีจอมขนม (Main / ฝากแคนดี้)",
    Callback = function()
        task.spawn(function()
            local hw = Workspace:FindFirstChild("Helloween")
            local npc = hw and hw:FindFirstChild("NPC") and hw.NPC:FindFirstChild("Main")
            local npcPos = npc and (npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart"))
            local targetPos = Vector3.new(2122.7, 3.2, -343.5)
            local lookPos = npcPos and npcPos.Position or Vector3.new(2122.7, 3.8, -348.7)
            SafeTeleport(targetPos, "ผีจอมขนม (Main)", lookPos)
        end)
    end
})

Tabs.Halloween:AddButton({
    Title = "🔫 วาร์ปไป ผีช่างปืน (GhostTopHat / เควสต์ P320)",
    Callback = function()
        task.spawn(function()
            local hw = Workspace:FindFirstChild("Helloween")
            local npc = hw and hw:FindFirstChild("NPC") and hw.NPC:FindFirstChild("GhostTopHat")
            local npcPos = npc and (npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart"))
            local targetPos = Vector3.new(2451.75, 4.0, 35.5)
            local lookPos = npcPos and npcPos.Position or Vector3.new(2451.75, 6.45, 31.0)
            SafeTeleport(targetPos, "ผีช่างปืน (GhostTopHat)", lookPos)
        end)
    end
})

Tabs.Halloween:AddButton({
    Title = "👹 วาร์ปไป ผีล่าอสูร (Ghost2 / เควสต์ล่ามอน)",
    Callback = function()
        task.spawn(function()
            local hw = Workspace:FindFirstChild("Helloween")
            local npc = hw and hw:FindFirstChild("NPC") and hw.NPC:FindFirstChild("Ghost2")
            local npcPos = npc and (npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart"))
            local targetPos = Vector3.new(2226.0, 3.8, -223.5)
            local lookPos = npcPos and npcPos.Position or Vector3.new(2226.0, 4.4, -228.3)
            SafeTeleport(targetPos, "ผีล่าอสูร (Ghost2)", lookPos)
        end)
    end
})

Tabs.Halloween:AddButton({
    Title = "📜 วาร์ปไป ผีเฝ้ายันต์ (Ghost1 / เควสต์ผ้ายันต์)",
    Callback = function()
        task.spawn(function()
            local hw = Workspace:FindFirstChild("Helloween")
            local npc = hw and hw:FindFirstChild("NPC") and hw.NPC:FindFirstChild("Ghost1")
            local npcPos = npc and (npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart"))
            local targetPos = Vector3.new(2493.1, 5.0, -1371.5)
            local lookPos = npcPos and npcPos.Position or Vector3.new(2493.1, 7.6, -1375.5)
            SafeTeleport(targetPos, "ผีเฝ้ายันต์ (Ghost1)", lookPos)
        end)
    end
})

Tabs.Halloween:AddButton({
    Title = "⚰️ วาร์ปไป โซนหลุมศพ (Graveyard)",
    Callback = function()
        task.spawn(function()
            SafeTeleport(Vector3.new(2145.0, 3.5, -425.0), "โซนสุสานหลุมศพ")
        end)
    end
})

Tabs.Halloween:AddButton({
    Title = "👹 วาร์ปไป หาบอสฮาโลวีนที่เกิดอยู่",
    Description = "ค้นหาบอสฮาโลวีน (ผีเปรต/กระสือ/หุ่นไล่กา) บนแมพและวาร์ปไปหาทันที",
    Callback = function()
        TeleportToActiveHalloweenBoss()
    end
})
end

do
Tabs.Halloween:AddSection("🎯 ระบบต่อสู้ฮาโลวีน")

Tabs.Halloween:AddToggle("SilentAimHalloweenOn", {
    Title = "🎯 Silent Aim ล็อกเป้ามอนสเตอร์ฮาโลวีน",
    Description = "วิถีกระสุนปืนจะเลี้ยวไปล็อกหัวมอนสเตอร์และบอสฮาโลวีนอัตโนมัติ",
    Default = true
}):OnChanged(function()
    State.SilentAimHalloween = Options.SilentAimHalloweenOn.Value
end)
end

--------------------------------------------------------------
-- 🛒 สร้างเมนูใน TABS.MERCHANT (พ่อค้าพเนจร)
--------------------------------------------------------------
do
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

Tabs.Merchant:AddButton({
    Title = "🔄 ซิงค์เวลาเซิร์ฟเวอร์",
    Description = "ดึงข้อมูลและซิงค์รอบเวลาพ่อค้าพเนจรจากเซิร์ฟเวอร์ใหม่ทันที",
    Callback = function()
        pcall(function()
            SyncMerchantServerCycle()
            local title, desc = GetMerchantStatusDisplay()
            if MerchantStatusParagraph and type(MerchantStatusParagraph.SetTitle) == "function" then
                MerchantStatusParagraph:SetTitle(title)
                MerchantStatusParagraph:SetDesc(desc)
            end
        end)
        Notify("พ่อค้าพเนจร", "ซิงค์เวลาเซิร์ฟเวอร์สำเร็จ!", "", 2.5)
    end
})
end

-- [แท็บ 2: ตัวละคร]
do
Tabs.Player:AddParagraph({
    Title = "🏃 ระบบปรับแต่งตัวละคร & Visuals",
    Content = "Speed, InfStamina, Jump, Fly, InfJump และมองทะลุ (ESP)"
})

Tabs.Player:AddToggle("InfStaminaOn", {
    Title = "🫁 วิ่งไม่เหนื่อย (Infinite Stamina)",
    Description = "สเตมิน่าเต็ม 100 ตลอดเวลา วิ่งและกระโดดได้ต่อเนื่องไม่เหนื่อยหอบ (Drain Rate = 0)",
    Default = true
}):OnChanged(function()
    State.InfStamina = Options.InfStaminaOn.Value
    SetInfiniteStaminaState(State.InfStamina)
end)
if State.InfStamina then
    task.spawn(function()
        task.wait(0.5)
        SetInfiniteStaminaState(true)
    end)
end

Tabs.Player:AddToggle("SpeedOn", { Title = "วิ่งไว (Speed)", Default = false }):OnChanged(function()
    State.Speed = Options.SpeedOn.Value
    if not State.Speed then
        local hum = GetHuman()
        if hum then hum.WalkSpeed = NORMAL_WALK_SPEED end
    end
end)

Tabs.Player:AddSlider("SpeedVal", {
    Title = "ความเร็วเดิน",
    Default = 17,
    Min = 8,
    Max = 18,
    Rounding = 0
}):OnChanged(function()
    State.SpeedValue = Options.SpeedVal.Value
end)

Tabs.Player:AddToggle("FlyOn", { Title = "บินอิสระ (Fly)", Default = false }):OnChanged(function()
    State.Fly = Options.FlyOn.Value
    if State.Fly then StartFly() else StopFly() end
end)

Tabs.Player:AddSlider("FlySpeedVal", {
    Title = "ความเร็วบิน",
    Default = State.FlySpeed or 50,
    Min = 10,
    Max = 250,
    Rounding = 0
}):OnChanged(function()
    State.FlySpeed = Options.FlySpeedVal.Value
end)

Tabs.Player:AddToggle("InfJumpOn", { Title = "กระโดดไม่จำกัด", Default = false }):OnChanged(function()
    State.InfJump = Options.InfJumpOn.Value
end)

Tabs.Player:AddToggle("GodmodeOn", {
    Title = "อมตะ (Godmode)",
    Default = false
}):OnChanged(function()
    SetGodmodeState(Options.GodmodeOn.Value)
end)

Tabs.Player:AddToggle("NoFallDamageOn", {
    Title = "กันตกตาย (No Fall)",
    Default = true
}):OnChanged(function()
    State.NoFallDamage = Options.NoFallDamageOn.Value
    if State.NoFallDamage then
        NeutralizeFallDamage()
    end
end)

do
    Tabs.Player:AddSection("⚡ ระบบเกิดใหม่ทันที (Fast Respawn)", "Left")

    Tabs.Player:AddToggle("InstantRespawnOn", {
        Title = "⚡ เกิดทันทีเมื่อตาย (Instant Respawn)",
        Description = "เมื่อตายจะข้ามเวลานับถอยหลัง 10 วินาที และเกิดใหม่ทันทีใน 0.2 วินาที ไม่ต้องรอเวลา",
        Default = true
    }):OnChanged(function()
        State.InstantRespawn = Options.InstantRespawnOn.Value
    end)

    Tabs.Player:AddToggle("RespawnAtDeathPosOn", {
        Title = "📍 เกิดกลับจุดที่ตาย (Respawn At Death Pos)",
        Description = "เมื่อเกิดใหม่แล้ว จะวาร์ปกลับมายังพิกัดล่าสุดที่ตายทันที",
        Default = false
    }):OnChanged(function()
        State.RespawnAtDeathPos = Options.RespawnAtDeathPosOn.Value
    end)

    Tabs.Player:AddButton({
        Title = "⚡ กดเกิดใหม่ทันที (Force Respawn)",
        Description = "บังคับเกิดใหม่ทันทีโดยไม่ต้องรอตายหรือรอเวลา",
        Callback = function()
            Hub.TriggerInstantRespawn(true)
        end
    })
end

do
    Tabs.Player:AddSection("🎒 ระบบกระเป๋าเก็บของ (Bag System)", "Left")

    Tabs.Player:AddToggle("AutoEquipBagOn", {
        Title = "🔄 สวมกระเป๋าอัตโนมัติ (Auto-Equip)",
        Description = "สวมกระเป๋าให้อัตโนมัติทันทีที่เข้าเกมและทุกครั้งที่เกิดใหม่ (ของในกระเป๋าไม่ตกตอนตาย)",
        Default = true
    }):OnChanged(function()
        State.AutoEquipBag = Options.AutoEquipBagOn.Value
        if State.AutoEquipBag then
            EquipBag(false)
        end
    end)

    Tabs.Player:AddButton({
        Title = "🎒 สวมกระเป๋า (Equip Bag)",
        Description = "ส่งคำสั่งสวมกระเป๋าทันที และเปิดปุ่มกระเป๋าบนหน้าจอ",
        Callback = function()
            EquipBag(false)
        end
    })

    Tabs.Player:AddButton({
        Title = "📂 เปิดหน้าต่างกระเป๋า (Open Bag UI)",
        Description = "เปิดหน้าต่างจัดการไอเทมในกระเป๋า (BagUIV2)",
        Callback = function()
            OpenBagUI()
        end
    })

    Tabs.Player:AddButton({
        Title = "🗑️ ถอดกระเป๋าออก (Unequip Bag)",
        Description = "ถอดกระเป๋าออกจากตัวละคร",
        Callback = function()
            UnequipBag(false)
        end
    })
end

do
    Tabs.Player:AddSection("👁️ มองทะลุผู้เล่น & แยกสถาบัน (Player ESP)", "Right")
    Tabs.Player:AddParagraph({
        Title = "Tactical ESP แยกสีสถาบัน",
        Content = "ปทุมคงคา (ฟ้า) | กนก (ม่วง) | ช่างกล (เหลือง) | พระ (ส้ม) | ตำรวจ (แดง) | เด็กบ้าน (ขาว)"
    }, "Right")

    Tabs.Player:AddToggle("ESPOn", {
        Title = "เปิด Player ESP",
        Default = false
    }):OnChanged(function()
        State.ESP = Options.ESPOn.Value
        if not State.ESP then
            ClearAllPlayerESP()
        end
    end)

    Tabs.Player:AddToggle("ESPTacticalStyle", {
        Title = "โหมดสีแดงล้วน",
        Default = false
    }):OnChanged(function()
        State.ESPTacticalStyle = Options.ESPTacticalStyle.Value
    end)

    Tabs.Player:AddToggle("ESPShowBox", {
        Title = "กรอบตัว (Box)",
        Default = true
    }):OnChanged(function()
        State.ESPShowBox = Options.ESPShowBox.Value
    end)

    Tabs.Player:AddToggle("ESPShowHeadDot", {
        Title = "จุดศีรษะ (Head Dot)",
        Default = true
    }):OnChanged(function()
        State.ESPShowHeadDot = Options.ESPShowHeadDot.Value
    end)

    Tabs.Player:AddToggle("ESPShowChams", {
        Title = "ไฮไลต์ตัว (Chams)",
        Default = true
    }):OnChanged(function()
        State.ESPShowChams = Options.ESPShowChams.Value
    end)

    Tabs.Player:AddToggle("ESPShowHealthBar", {
        Title = "หลอดเลือด (HP)",
        Default = true
    }):OnChanged(function()
        State.ESPShowHealthBar = Options.ESPShowHealthBar.Value
    end)

    Tabs.Player:AddToggle("ESPShowDistance", {
        Title = "ระยะห่าง (Distance)",
        Default = true
    }):OnChanged(function()
        State.ESPShowDistance = Options.ESPShowDistance.Value
    end)

    Tabs.Player:AddToggle("ESPShowWeapon", {
        Title = "ชื่ออาวุธ (Weapon)",
        Default = true
    }):OnChanged(function()
        State.ESPShowWeapon = Options.ESPShowWeapon.Value
    end)

    Tabs.Player:AddSlider("ESPMaxDistVal", {
        Title = "ระยะ ESP สูงสุด",
        Default = 500,
        Min = 50,
        Max = 1500,
        Rounding = 0
    }):OnChanged(function()
        State.ESPMaxDistance = Options.ESPMaxDistVal.Value
    end)
end

end

--------------------------------------------------------------
-- 🎯 แท็บ: ระบบต่อสู้ (COMBAT & SILENT AIM)
--------------------------------------------------------------
do
Tabs.Combat:AddParagraph({
    Title = "Silent Aim & Combat",
    Content = "ระบบล็อคกระสุนอัตโนมัติ คำนวณวิถีกระสุนเข้าเป้าหมาย ดักการเคลื่อนที่ และทะลุกำแพง"
})

Tabs.Combat:AddToggle("SilentAimOn", {
    Title = "เปิด Silent Aim",
    Default = false
}):OnChanged(function()
    State.SilentAim = Options.SilentAimOn.Value
    ApplyGunMods()
end)

Tabs.Combat:AddDropdown("SilentPartChoice", {
    Title = "ตำแหน่งล็อค",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head"
}):OnChanged(function()
    State.SilentPart = Options.SilentPartChoice.Value
end)

Tabs.Combat:AddSlider("HitChanceVal", {
    Title = "โอกาสโดน (Hit %)",
    Default = 100,
    Min = 10,
    Max = 100,
    Rounding = 0
}):OnChanged(function()
    State.SilentHitChance = Options.HitChanceVal.Value
end)

Tabs.Combat:AddToggle("SilentTeamCheckOn", {
    Title = "ไม่ยิงพวกเดียวกัน",
    Default = true
}):OnChanged(function()
    State.SilentTeamCheck = Options.SilentTeamCheckOn.Value
end)

Tabs.Combat:AddToggle("WallCheckOn", {
    Title = "ตรวจกำแพง (Wall Check)",
    Default = false
}):OnChanged(function()
    State.SilentWallCheck = Options.WallCheckOn.Value
end)

Tabs.Combat:AddToggle("VelocityPredictOn", {
    Title = "ดักหน้า (Predict)",
    Default = false
}):OnChanged(function()
    State.SilentVelocity = Options.VelocityPredictOn.Value
end)

Tabs.Combat:AddSlider("CombatFOVVal", {
    Title = "ขนาดวงเล็ง (FOV)",
    Default = 150,
    Min = 40,
    Max = 400,
    Rounding = 0
}):OnChanged(function()
    State.CombatFOV = Options.CombatFOVVal.Value
end)

Tabs.Combat:AddToggle("DrawFOVOn", {
    Title = "แสดงวงเล็ง (FOV)",
    Default = false
}):OnChanged(function()
    State.DrawFOV = Options.DrawFOVOn.Value
end)

Tabs.Combat:AddToggle("LockFOVCenterOn", {
    Title = "🎯 ล็อค FOV กลางจอ (Lock Center FOV)",
    Description = "ล็อควงเล็ง FOV ให้อยู่กึ่งกลางหน้าจอตลอดเวลา เหมาะสำหรับมือถือหรือโหมดล็อกเป้า (เปิดอัตโนมัติบนมือถือ)",
    Default = IsMobile
}):OnChanged(function()
    State.LockFOVCenter = Options.LockFOVCenterOn.Value
end)
end

do
Tabs.Combat:AddSection("ปรับแต่งปืน & กระสุน")

Tabs.Combat:AddToggle("NoSpreadOn", {
    Title = "ยิงตรงจุด (No Spread)",
    Default = false
}):OnChanged(function()
    State.NoSpread = Options.NoSpreadOn.Value
    ApplyGunMods()
end)

Tabs.Combat:AddToggle("NoRecoilOn", {
    Title = "🛑 ไร้แรงดีด & ล็อคเป้านิ่ง (No Recoil)",
    Description = "ล็อคเป้านิ่งสนิท ปิดแรงดีดปืนและอาการกล้องสั่นไหวเวลายิง 100% ปลอดภัยไม่โดนเตะ",
    Default = true
}):OnChanged(function()
    State.NoRecoil = Options.NoRecoilOn.Value
    ApplyGunMods()
end)

Tabs.Combat:AddToggle("FastBulletOn", {
    Title = "กระสุนไว (Fast Bullet)",
    Default = false
}):OnChanged(function()
    State.FastBullet = Options.FastBulletOn.Value
    ApplyGunMods()
end)


Tabs.Combat:AddSection("⚡ ยิงรัวอัตโนมัติ (Glock Switch)", "Right")

Tabs.Combat:AddToggle("GlockSwitchOn", {
    Title = "⚡ ยิงรัว (Glock Switch)",
    Description = "คลิกค้างเพื่อยิงรัวอัตโนมัติสำหรับปืนทุกกระบอก ปรับสปีดลั่นไกเซฟอัตโนมัติ 100% กันเตะและแบน CODE 49 / 51",
    Default = true
}):OnChanged(function()
    State.GlockSwitch = Options.GlockSwitchOn.Value
    ApplyGunMods()
    if State.GlockSwitch then
        Notify("Glock Switch", "เปิดใช้งานยิงรัวอัตโนมัติ (Safe Anti-Kick 49/51)", "", 3)
    else
        Notify("Glock Switch", "ปิดระบบยิงรัว คืนค่าปืนตามเดิม", "", 2)
    end
end)

Tabs.Combat:AddSlider("GlockSwitchSpeed", {
    Title = "ความเร็วลั่นไก (Fire Rate Delay)",
    Description = "ค่ายิ่งน้อยยิ่งรัวเร็ว (0.08 - 0.14 วิ) มาตรฐาน 0.11 วิ รัวจัดสไตล์ Beretta Glock Switch",
    Default = 0.11,
    Min = 0.08,
    Max = 0.20,
    Rounding = 2
}):OnChanged(function()
    State.GlockSwitchRate = Options.GlockSwitchSpeed.Value
    ApplyGunMods()
end)

Tabs.Combat:AddButton({
    Title = "🔧 ซ่อมปืน / ล้างปืนทันที (Instant Gun Repair)",
    Description = "ส่งคำสั่งล้างปืนเพื่อคืนค่าความทนทานปืนที่ถืออยู่เต็ม 100% บนเซิร์ฟเวอร์ทันที",
    Callback = function()
        pcall(function()
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if not tool then
                Notify("ระบบซ่อมปืน", "กรุณาถือปืนในมือก่อนกดซ่อม", "", 3)
                return
            end
            local cleaningChoice = ReplicatedStorage:FindFirstChild("CleaningKitChoice")
            local buyKit = ReplicatedStorage:FindFirstChild("BuyCleaningKit")
            if cleaningChoice then
                cleaningChoice:FireServer(tool.Name)
            end
            if buyKit then
                buyKit:FireServer()
            end
            local cg = tool:FindFirstChild("CurrentGrade")
            if cg and cg:IsA("NumberValue") then
                cg.Value = 320
            end
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _, g in ipairs(pg:GetChildren()) do
                    if g.Name:find("GradeGui") then
                        local fill = g:FindFirstChild("Fill", true)
                        local pct = g:FindFirstChild("PctLabel", true)
                        if fill and fill:IsA("Frame") then fill.Size = UDim2.new(1, 0, 1, 0) end
                        if pct and pct:IsA("TextLabel") then pct.Text = "100%" end
                    end
                end
            end
            Notify("ระบบซ่อมปืน", "ซ่อมและคืนค่าความทนทาน " .. tool.Name .. " สำเร็จ!", "", 3)
        end)
    end
})

Hub.FPSData = {
    active = false,
    conn = nil,
    parts = {},
    decals = {},
    particles = {},
    effects = {},
    terrain = nil,
}

local function ApplyUltraBoostFPS(enable)
    local d = Hub.FPSData
    d.active = enable
    if enable then
        pcall(function()
            local cap = State.FPSCap or 240
            if setfpscap then
                setfpscap(cap)
            elseif set_fps_cap then
                set_fps_cap(cap)
            end
        end)

        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)

        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, eff in ipairs(Lighting:GetChildren()) do
                if eff:IsA("PostEffect") or eff:IsA("BloomEffect") or eff:IsA("BlurEffect") or eff:IsA("SunRaysEffect") or eff:IsA("DepthOfFieldEffect") then
                    pcall(function()
                        if not d.effects[eff] then
                            d.effects[eff] = eff.Enabled
                        end
                        eff.Enabled = false
                    end)
                end
            end
        end)

        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                if not d.terrain then
                    d.terrain = {
                        WaterWaveSize = terrain.WaterWaveSize,
                        WaterWaveSpeed = terrain.WaterWaveSpeed,
                        WaterReflectance = terrain.WaterReflectance,
                        WaterTransparency = terrain.WaterTransparency,
                    }
                end
                pcall(function() terrain.WaterWaveSize = 0 end)
                pcall(function() terrain.WaterWaveSpeed = 0 end)
                pcall(function() terrain.WaterReflectance = 0 end)
                pcall(function() terrain.WaterTransparency = 0 end)
            end
        end)

        local function optimizeObj(v)
            if not v or not v.Parent then return end
            local char = LocalPlayer and LocalPlayer.Character
            if char and v:IsDescendantOf(char) then return end
            if v:IsA("GuiObject") or v:IsA("LayerCollector") then return end
            local name = v.Name or ""
            if name:find("Kraken") or name:find("ESP") or name:find("MacLib") or name:find("Fluent") or name:find("Highlight") or name:find("Billboard") then
                return
            end
            pcall(function()
                if v:IsA("BasePart") then
                    if not d.parts[v] then
                        d.parts[v] = {
                            mat = v.Material,
                            shadow = v.CastShadow,
                            refl = v.Reflectance
                        }
                    end
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    if not d.decals[v] then
                        d.decals[v] = v.Transparency
                    end
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
                    if not d.particles[v] then
                        d.particles[v] = v.Enabled
                    end
                    v.Enabled = false
                elseif v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                    if not d.effects[v] then
                        d.effects[v] = v.Enabled
                    end
                    v.Enabled = false
                end
            end)
        end

        task.spawn(function()
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                if not d.active then break end
                optimizeObj(descendants[i])
                if i % 350 == 0 then
                    task.wait()
                end
            end
        end)

        if d.conn then
            d.conn:Disconnect()
            d.conn = nil
        end
        d.conn = workspace.DescendantAdded:Connect(function(v)
            if d.active then
                optimizeObj(v)
            end
        end)
        Connections.BoostFPSDescendant = d.conn
    else
        local d = Hub.FPSData
        if d.conn then
            d.conn:Disconnect()
            d.conn = nil
            Connections.BoostFPSDescendant = nil
        end

        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            if not State.FullBright then
                local def = Hub.LightingData and Hub.LightingData.default
                Lighting.GlobalShadows = def and def.GlobalShadows or true
                Lighting.FogEnd = def and def.FogEnd or 1000
            end
        end)

        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain and d.terrain then
                pcall(function() terrain.WaterWaveSize = d.terrain.WaterWaveSize end)
                pcall(function() terrain.WaterWaveSpeed = d.terrain.WaterWaveSpeed end)
                pcall(function() terrain.WaterReflectance = d.terrain.WaterReflectance end)
                pcall(function() terrain.WaterTransparency = d.terrain.WaterTransparency end)
                d.terrain = nil
            end
        end)

        for eff, origEn in pairs(d.effects) do
            pcall(function()
                if eff and eff.Parent then
                    eff.Enabled = origEn
                end
            end)
        end
        table.clear(d.effects)

        for p, origEn in pairs(d.particles) do
            pcall(function()
                if p and p.Parent then
                    p.Enabled = origEn
                end
            end)
        end
        table.clear(d.particles)

        for dec, origTrans in pairs(d.decals) do
            pcall(function()
                if dec and dec.Parent then
                    dec.Transparency = origTrans
                end
            end)
        end
        table.clear(d.decals)

        local partsToRestore = d.parts
        d.parts = {}
        task.spawn(function()
            local count = 0
            for part, data in pairs(partsToRestore) do
                pcall(function()
                    if part and part.Parent then
                        part.Material = data.mat
                        part.CastShadow = data.shadow
                        part.Reflectance = data.refl
                    end
                end)
                count = count + 1
                if count % 500 == 0 then
                    task.wait()
                end
            end
        end)
    end
end

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
    State.GlockSwitch = false
    pcall(ApplyGunMods)
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
    SetInfiniteStaminaState(false)
    if State.FullBright then
        RestoreLighting()
    end
    if State.UltraBoostFPS then
        ApplyUltraBoostFPS(false)
    end
    pcall(function()
        if setfpscap then setfpscap(0) end
    end)
    local hum = GetHuman()
    if hum then hum.WalkSpeed = NORMAL_WALK_SPEED; hum.JumpPower = 35 end
    if Hub.ToggleButtonGui then
        pcall(function() Hub.ToggleButtonGui:Destroy() end)
    end
    pcall(function() Fluent:Destroy() end)
end

end

-- --------------------------------------------------------------
-- 👮 แท็บตำรวจ (POLICE TAB)
-- --------------------------------------------------------------
do
Tabs.Police:AddSection("🔒 ระบบจับกุมผู้ต้องหาอัตโนมัติ")

Tabs.Police:AddToggle("AutoCuffWantedOn", {
    Title = "ออโต้ล็อคกุญแจมือเมื่อเข้าใกล้คนร้าย",
    Default = false
}):OnChanged(function()
    State.AutoCuffWanted = Options.AutoCuffWantedOn.Value
end)

Tabs.Police:AddToggle("AutoEquipCuffsOn", {
    Title = "ออโต้หยิบกุญแจมือเมื่อเจอคนร้าย",
    Default = false
}):OnChanged(function()
    State.AutoEquipCuffs = Options.AutoEquipCuffsOn.Value
end)

Tabs.Police:AddToggle("AutoConfiscateDrugsOn", {
    Title = "ออโต้ยึดยาเสพติดเป็นของกลาง",
    Default = false
}):OnChanged(function()
    State.AutoConfiscateDrugs = Options.AutoConfiscateDrugsOn.Value
end)

Tabs.Police:AddToggle("AutoSendToJailOn", {
    Title = "ออโต้ส่งตัวเข้าคุกทันที",
    Default = false
}):OnChanged(function()
    State.AutoSendToJail = Options.AutoSendToJailOn.Value
end)

Tabs.Police:AddSlider("PoliceArrestDistanceVal", {
    Title = "ระยะจับกุมอัตโนมัติ",
    Min = 5,
    Max = 30,
    Default = 8,
    Rounding = 0,
    Suffix = " studs"
}):OnChanged(function(v)
    State.PoliceArrestDistance = tonumber(v) or 8
end)
end

-- [แท็บ 4: ตั้งค่า]
do
Tabs.Settings:AddParagraph({
    Title = "⚙️ KrakenHub v1.0",
    Content = "Fluent Edition (100% Anti-Kick Bypass Pro)\nกดปุ่ม K หรือ Right Control เพื่อเปิด/ปิดหน้าต่าง"
}, "Left")

Tabs.Settings:AddSection("📱 ตรวจจับสภาพแวดล้อม (Environment Detector)", "Left")

Tabs.Settings:AddParagraph({
    Title = "🔍 ข้อมูลอุปกรณ์และสภาพแวดล้อมที่กำลังรัน",
    Content = string.format("• อุปกรณ์: %s\n• ระบบปฏิบัติการ: %s\n• ตัวรัน (Executor): %s\n• การควบคุม: %s\n• โหมด FOV ปัจจุบัน: %s",
        EnvironmentInfo.DeviceType,
        EnvironmentInfo.PlatformName,
        EnvironmentInfo.Executor,
        EnvironmentInfo.InputMethod,
        (IsMobile or State.LockFOVCenter) and "ล็อคกึ่งกลางจอ (Center Locked)" or "ตาม Crosshair / Mouse (PC Dynamic)")
}, "Left")

Tabs.Settings:AddSection("⚙️ ปุ่มลัด & การแสดงผลเมนู (Menu Controls)", "Left")

local MenuKeybindElement = Tabs.Settings:AddKeybind("MenuToggleKey", {
    Title = "⌨️ ปุ่มลัดเปิด/ปิดเมนู",
    Description = "คลิกที่ช่องเพื่อกดปุ่มคีย์ลัดใหม่บนคีย์บอร์ดที่ต้องการใช้ (ค่าเริ่มต้น: Right Control หรือ K)",
    Default = Enum.KeyCode.RightControl,
    ChangedCallback = function(newKey)
        Window:SetKeybind(newKey)
        State.MenuKeybind = newKey
        local kName = (typeof(newKey) == "EnumItem" and newKey.Name) or tostring(newKey)
        Notify("ตั้งค่าคีย์ลัด", "เปลี่ยนปุ่มเปิด/ปิดเมนูเป็น: [" .. kName .. "]", "", 3)
    end
})

local HideToggleLogo = Tabs.Settings:AddToggle("HideFloatingButtonOn", {
    Title = "👁️ ซ่อนโลโก้เปิดปิดสคริปต์ (Hide Toggle...)",
    Description = "เปิดเพื่อซ่อนปุ่มลอยสำหรับเปิด/ปิดหน้าต่างเมนู",
    Default = false
})
HideToggleLogo:OnChanged(function()
    State.HideFloatingButton = Options.HideFloatingButtonOn.Value
    if Hub.ToggleButtonGui then
        Hub.ToggleButtonGui.Enabled = not State.HideFloatingButton
    end
end)

Tabs.Settings:AddSection("💡 การแสดงผล & แสงสว่าง (Visuals & Lighting)", "Right")

local BoostToggle = Tabs.Settings:AddToggle("UltraBoostFPSOn", {
    Title = "⚡ เพิ่มความลื่นไหล (Ultra Boost FPS)",
    Description = "ลดกราฟิกลงต่ำสุดเพื่อเพิ่ม FPS และความลื่นไหลสูงสุด",
    Default = false
})
BoostToggle:OnChanged(function()
    State.UltraBoostFPS = Options.UltraBoostFPSOn.Value
    ApplyUltraBoostFPS(State.UltraBoostFPS)
    if State.UltraBoostFPS then
        Notify("เพิ่มความลื่นไหล", "เปิดใช้งาน Ultra Boost FPS เรียบร้อย", "", 2.5)
    else
        Notify("เพิ่มความลื่นไหล", "ปิดการใช้งาน Ultra Boost FPS", "", 2.5)
    end
end)

local FPSSlider = Tabs.Settings:AddSlider("FPSCapVal", {
    Title = "🎯 ล็อค FPS (FPS Cap)",
    Description = "จำกัดหรือปลดล็อคจำนวนเฟรมเรตต่อวินาที (FPS)",
    Default = 60,
    Min = 30,
    Max = 240,
    Rounding = 0,
    Callback = function(Value)
        State.FPSCap = math.floor(Value)
        pcall(function()
            if setfpscap then
                setfpscap(State.FPSCap)
            end
        end)
    end
})

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

Tabs.Settings:AddSection("🎁 โค้ดรับของขวัญ (Roblox Community Code)", "Right")

Tabs.Settings:AddParagraph({
    Title = "📢 เงื่อนไขการรับโค้ด",
    Content = "⚠️ ต้องเข้าร่วมกลุ่มชุมชน Roblox ของแมพก่อน จึงจะรับรางวัลได้\nโค้ดแจกฟรี: sorryforroblox! | sorryforlate! | Tkall! | GoodMorning"
}, "Right")

Tabs.Settings:AddToggle("AutoRedeemCodesOn", {
    Title = "ออโต้ใส่โค้ดทั้งหมด (เมื่อเข้าเกม)",
    Description = "เปิดเพื่อให้สคริปต์ส่งโค้ดทั้งหมดทั้ง 4 โค้ดให้อัตโนมัติ",
    Default = false
}):OnChanged(function()
    State.AutoRedeemCodes = Options.AutoRedeemCodesOn.Value
    if State.AutoRedeemCodes then
        Hub.RedeemAllGameCodes()
    end
end)

Tabs.Settings:AddInput("CustomCodeBox", {
    Title = "ใส่โค้ดเอง (Enter Code)",
    Default = "",
    Placeholder = "พิมพ์โค้ดที่ต้องการรับ...",
    Callback = function() end
})

Tabs.Settings:AddButton({
    Title = "📨 กดส่งโค้ดที่พิมพ์",
    Callback = function()
        local code = (Options.CustomCodeBox and Options.CustomCodeBox.Value) or ""
        code = tostring(code):gsub("^%s+", ""):gsub("%s+$", "")
        if #code > 0 then
            Hub.RedeemSingleCode(code)
        else
            Notify("ระบบโค้ด", "กรุณาพิมพ์โค้ดลงในช่องก่อนกดส่ง", "", 2.5)
        end
    end
})

Tabs.Settings:AddButton({
    Title = "🎁 กดรับโค้ดชุมชนทั้งหมดทันที (4 โค้ด)",
    Description = "กดเพื่อส่งโค้ด sorryforroblox! sorryforlate! Tkall! GoodMorning ทั้งหมด",
    Callback = function()
        Hub.RedeemAllGameCodes()
    end
})

Tabs.Settings:AddSection("⚠️ ควบคุมสคริปต์", "Right")

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

Notify("KrakenHub v1.0", string.format("โหลดสำเร็จ! [%s | %s]", EnvironmentInfo.DeviceType, EnvironmentInfo.Executor), IsMobile and "ระบบล็อค FOV กลางจอสำหรับมือถือเปิดใช้งานอัตโนมัติ" or "กดปุ่ม K หรือ Right Ctrl เพื่อเปิด/ปิดหน้าต่าง", 4)
if State.AutoRedeemCodes then
    task.delay(1.5, function()
        Hub.RedeemAllGameCodes()
    end)
end
if State.AutoEquipBag then
    task.delay(0.8, function()
        EquipBag(true)
    end)
end
end
