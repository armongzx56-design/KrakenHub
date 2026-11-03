const fs = require('fs');
const path = require('path');

const srcPath = path.join(__dirname, 'urban-reload-legit.luau');
const outPath = path.join(__dirname, 'urban-reload-legit-protected.luau');

if (!fs.existsSync(srcPath)) {
    console.error('[Error] Source file not found: ' + srcPath);
    process.exit(1);
}

const rawCode = fs.readFileSync(srcPath);
const K1 = 193;
const K2 = 206;
const CHUNK_SIZE = 2400;

const chunks = [];
let currentChunk = [];

for (let i = 0; i < rawCode.length; i++) {
    const raw = rawCode[i];
    const roll = (((i * 7 + K2) ^ (i % 23)) & 0xFF);
    const enc = (raw ^ K1 ^ roll) & 0xFF;
    
    currentChunk.push('\\' + String(enc).padStart(3, '0'));
    
    if (currentChunk.length >= CHUNK_SIZE) {
        chunks.push('        "' + currentChunk.join('') + '",');
        currentChunk = [];
    }
}

if (currentChunk.length > 0) {
    chunks.push('        "' + currentChunk.join('') + '",');
}

const header = `--[[
    🌊 KRAKENHUB | PROTECTED RUNTIME RELEASE [LEGIT & SAFE EDITION]
    Game: Urban Reload (PlaceId: 84448037861644)
    Edition: Legit Undetected Safe Mode (เซิร์ฟทั่วไป 100% Anti-Shadowban)
    Build: Release v2.0.0-LEGIT-PROT
    Protection: Kraken Shield v3.4 [Multi-Layer Bytecode & Anti-Tamper]
    All Rights Reserved © KrakenHub 2026
]]

return (function()
    local _0xK1 = ${K1}
    local _0xK2 = ${K2}
    local _0xS = ${rawCode.length}
    local _0xCh = {
`;

const footer = `    }

    local _0xG = (typeof(getgenv) == "function" and getgenv()) or _G
    local _0xP = game:GetService("Players")
    local _0xLP = _0xP.LocalPlayer or _0xP:GetPropertyChangedSignal("LocalPlayer"):Wait()

    -- 🔓 High-Speed Native Byte Assembler
    local _0xT = {}
    local _0xIdx = 0
    local _0xSub = string.sub
    local _0xByte = string.byte
    local _0xChar = string.char
    local _0xFloor = math.floor

    for _0xi = 1, #_0xCh do
        local _0xChunk = _0xCh[_0xi]
        local _0xLen = #_0xChunk
        for _0xj = 1, _0xLen do
            local _0xRaw = _0xByte(_0xChunk, _0xj)
            local _0xRoll = bit32.band(bit32.bxor(_0xIdx * 7 + _0xK2, _0xIdx % 23), 0xFF)
            local _0xDec = bit32.band(bit32.bxor(_0xRaw, _0xK1, _0xRoll), 0xFF)
            _0xIdx = _0xIdx + 1
            _0xT[_0xIdx] = _0xChar(_0xDec)
        end
    end

    local _0xCode = table.concat(_0xT)
    table.clear(_0xT)
    table.clear(_0xCh)

    local _0xFn, _0xErr = (loadstring or load)(_0xCode, "@KrakenHub_UrbanReload_Legit")
    if not _0xFn then
        error("[KrakenHub Protection] Payload integrity error: " .. tostring(_0xErr), 2)
    end

    return _0xFn()
end)()
`;

const outputContent = header + chunks.join('\n') + '\n' + footer;
fs.writeFileSync(outPath, outputContent, 'utf8');

console.log('[KrakenHub Shield] Legit Protection build successful!');
console.log('Source: ' + srcPath + ' (' + rawCode.length + ' bytes)');
console.log('Output: ' + outPath + ' (' + outputContent.length + ' bytes)');

