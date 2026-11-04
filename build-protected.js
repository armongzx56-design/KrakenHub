const fs = require('fs');
const path = require('path');

const rootSrc = 'd:\\roblox-script\\urban-reload.luau';
const repoDir = 'd:\\roblox-script\\KrakenHub\\KrakenHub-main';
const repoSrc = path.join(repoDir, 'urban-reload.luau');
const repoOut = path.join(repoDir, 'urban-reload-protected.luau');

console.log('[1/3] Copying latest urban-reload.luau to repository...');
fs.copyFileSync(rootSrc, repoSrc);
const rawCode = fs.readFileSync(repoSrc);
console.log(`Source size: ${rawCode.length.toLocaleString()} bytes`);

console.log('[2/3] Encrypting with Multi-Key Dynamic CBC Nonce Cipher...');
const K1 = 181;
const K2 = 219;
const CHUNK_SIZE = 2400;

const chunks = [];
let currentChunk = [];
let acc = 0x5C;

for (let i = 0; i < rawCode.length; i++) {
    const raw = rawCode[i];
    const roll = (((i * 11 + K2) ^ (i % 31) ^ acc) & 0xFF);
    const enc = (raw ^ K1 ^ roll) & 0xFF;
    
    currentChunk.push('\\' + String(enc).padStart(3, '0'));
    acc = ((acc + enc + 7) & 0xFF);
    
    if (currentChunk.length >= CHUNK_SIZE) {
        chunks.push('        "' + currentChunk.join('') + '",');
        currentChunk = [];
    }
}

if (currentChunk.length > 0) {
    chunks.push('        "' + currentChunk.join('') + '",');
}

console.log(`Generated ${chunks.length} chunks.`);

console.log('[3/3] Assembling Universal Kraken Shield v3.5...');

const header = `--[[
    🛡️ KRAKENHUB UNIVERSAL RUNTIME RELEASE
    Game: Urban Reload (PlaceId: 84448037861644)
    Build: Release v3.5.0-PROT [UNIVERSAL SHIELD]
    Supported: PC, Mobile (Android/iOS), All Executors (Delta, Codex, Arceus, Wave, Swift, Solara)
    All Rights Reserved © KrakenHub 2026
]]

return (function()
    -- Ensure game environment is fully initialized
    if not game:IsLoaded() then
        pcall(function() game.Loaded:Wait() end)
    end

    local _0xP = game:GetService("Players")
    local _0xLP = _0xP.LocalPlayer
    if not _0xLP then
        pcall(function()
            _0xLP = _0xP:GetPropertyChangedSignal("LocalPlayer"):Wait()
        end)
    end

    local _0xK1 = ${K1}
    local _0xK2 = ${K2}
    local _0xS = ${rawCode.length}
    local _0xCh = {
`;

const footer = `    }

    -- 🛡️ Universal Multi-Layer Decryptor & Memory Guard
    local _0xT = {}
    local _0xIdx = 0
    local _0xAcc = 0x5C
    local _0xByte = string.byte
    local _0xChar = string.char
    local _0xBx = bit32.bxor
    local _0xBand = bit32.band

    for _0xi = 1, #_0xCh do
        local _0xChunk = _0xCh[_0xi]
        local _0xLen = #_0xChunk
        for _0xj = 1, _0xLen do
            local _0xRaw = _0xByte(_0xChunk, _0xj)
            local _0xRoll = _0xBand(_0xBx(_0xIdx * 11 + _0xK2, _0xIdx % 31, _0xAcc), 0xFF)
            local _0xDec = _0xBand(_0xBx(_0xRaw, _0xK1, _0xRoll), 0xFF)
            _0xAcc = _0xBand(_0xAcc + _0xRaw + 7, 0xFF)
            _0xIdx = _0xIdx + 1
            _0xT[_0xIdx] = _0xChar(_0xDec)
        end
    end

    -- Clear encrypted byte tables from memory immediately
    table.clear(_0xCh)

    local _0xCode = table.concat(_0xT)
    table.clear(_0xT)

    -- Universal Loader with Anti-Dump Memory Wipe
    local _0xLoader = loadstring or load
    if typeof(_0xLoader) ~= "function" then
        error("[KrakenHub] No compatible Lua loader (loadstring/load) found on this executor.", 2)
    end

    local _0xFn, _0xErr = _0xLoader(_0xCode, "@KrakenHub_UrbanReload")
    _0xCode = nil -- Clear plaintext source reference from memory
    
    if typeof(collectgarbage) == "function" then
        collectgarbage("collect")
    end

    if not _0xFn then
        error("[KrakenHub Protection] Payload integrity error: " .. tostring(_0xErr), 2)
    end

    return _0xFn()
end)()
`;

const outputContent = header + chunks.join('\n') + '\n' + footer;
fs.writeFileSync(repoOut, outputContent, 'utf8');

// Also update build-protected.js in repo
fs.writeFileSync(path.join(repoDir, 'build-protected.js'), fs.readFileSync(__filename, 'utf8'), 'utf8');

console.log('Build complete!');
console.log(`Protected file: ${repoOut}`);
console.log(`Protected size: ${outputContent.length.toLocaleString()} bytes`);
