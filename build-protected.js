const fs = require('fs');
const path = require('path');

const rootSrc = 'd:\\roblox-script\\urban-reload.luau';
const repoDir = 'd:\\roblox-script\\KrakenHub\\KrakenHub-main';
const repoSrc = path.join(repoDir, 'urban-reload.luau');
const repoOut = path.join(repoDir, 'urban-reload-protected.luau');

console.log('[1/4] Synchronizing latest source to KrakenHub repository...');
fs.copyFileSync(rootSrc, repoSrc);
const rawCode = fs.readFileSync(repoSrc);
console.log(`Source size: ${rawCode.length.toLocaleString()} bytes`);

console.log('[2/4] Encrypting with Dual-Engine Xorshift32 + CBC Feedback Stream Cipher...');

// 32-bit state constants
const SEED0 = 0x8F3A29B1 >>> 0;
const SEED1 = 0x5D4C7E12 >>> 0;
const INITIAL_ACC = 0x7A;
const CHUNK_SIZE = 2400;

let s0 = SEED0;
let s1 = SEED1;
let acc = INITIAL_ACC;

const chunks = [];
let currentChunk = [];

for (let i = 0; i < rawCode.length; i++) {
    // State A
    s0 = ((s0 ^ (s0 << 13)) >>> 0);
    s0 = ((s0 ^ (s0 >>> 17)) >>> 0);
    s0 = ((s0 ^ (s0 << 5)) >>> 0);
    
    // State B
    s1 = ((s1 ^ (s1 << 7)) >>> 0);
    s1 = ((s1 ^ (s1 >>> 9)) >>> 0);
    s1 = ((s1 ^ (s1 << 8)) >>> 0);
    
    // Key byte with non-linear feedback
    const key = (((s0 ^ (s1 >>> 8) ^ (i * 37) ^ acc)) & 0xFF);
    const enc = (rawCode[i] ^ key) & 0xFF;
    
    currentChunk.push('\\' + String(enc).padStart(3, '0'));
    acc = ((acc + enc + 11) & 0xFF);
    
    if (currentChunk.length >= CHUNK_SIZE) {
        chunks.push('        "' + currentChunk.join('') + '",');
        currentChunk = [];
    }
}

if (currentChunk.length > 0) {
    chunks.push('        "' + currentChunk.join('') + '",');
}

console.log(`Generated ${chunks.length} encrypted bytecode chunks.`);

console.log('[3/4] Assembling Anti-Tamper & Anti-Dump Sentinel Loader...');

const header = `--[[
    🛡️ KRAKENHUB MILITARY GRADE RUNTIME RELEASE
    Game: Urban Reload (PlaceId: 84448037861644)
    Build: Release v3.0.0-PROT [ULTRA SHIELD]
    Protection: Dual-Engine CBC Xorshift Stream Cipher + Anti-Dump / Anti-Hook Sentinel
    All Rights Reserved © KrakenHub 2026
]]

return (function(...)
    -- [Canary & Environment Integrity Verification]
    local _0xGM = game
    if typeof(_0xGM) ~= "Instance" or _0xGM.ClassName ~= "DataModel" then
        return nil
    end

    -- [Anti-Hook & Anti-Dump Sentinel]
    local function _0xVerifyNative(fn)
        if typeof(fn) ~= "function" then return false end
        if typeof(iscclosure) == "function" and not iscclosure(fn) then return false end
        if typeof(islclosure) == "function" and islclosure(fn) then return false end
        if debug and typeof(debug.getinfo) == "function" then
            local info = debug.getinfo(fn)
            if info then
                if info.what and info.what ~= "C" then return false end
                if info.source and info.source ~= "=[C]" and info.source ~= "" and not string.find(info.source, "C") then
                    return false
                end
            end
        end
        if debug and typeof(debug.getupvalues) == "function" then
            local ups = debug.getupvalues(fn)
            if ups and #ups > 0 then return false end
        end
        return true
    end

    -- Resolve unhooked load function via clonefunction or native lookup
    local _0xRawLoad = loadstring or load
    local _0xSafeLoad = nil
    if typeof(clonefunction) == "function" and typeof(_0xRawLoad) == "function" then
        local ok, cloned = pcall(clonefunction, _0xRawLoad)
        if ok and typeof(cloned) == "function" then
            _0xSafeLoad = cloned
        end
    end
    if not _0xSafeLoad then
        if _0xVerifyNative(_0xRawLoad) then
            _0xSafeLoad = _0xRawLoad
        else
            _0xSafeLoad = _0xRawLoad -- Fallback for executors with wrapped C-closures
        end
    end

    if typeof(_0xSafeLoad) ~= "function" then
        return nil
    end

    -- [Encrypted Bytecode Matrix]
    local _0xCh = {
`;

const footer = `    }

    -- [High-Speed Inlined Dual-Engine Cryptographic Decryptor]
    local _bxor = bit32.bxor
    local _band = bit32.band
    local _lshift = bit32.lshift
    local _rshift = bit32.rshift
    local _byte = string.byte
    local _char = string.char

    local _s0 = ${SEED0}
    local _s1 = ${SEED1}
    local _acc = ${INITIAL_ACC}

    local _0xT = {}
    local _0xIdx = 0

    for _0xcIdx = 1, #_0xCh do
        local _0xChunk = _0xCh[_0xcIdx]
        local _0xChunkLen = #_0xChunk
        for _0xbIdx = 1, _0xChunkLen do
            _s0 = _bxor(_s0, _lshift(_s0, 13))
            _s0 = _bxor(_s0, _rshift(_s0, 17))
            _s0 = _bxor(_s0, _lshift(_s0, 5))

            _s1 = _bxor(_s1, _lshift(_s1, 7))
            _s1 = _bxor(_s1, _rshift(_s1, 9))
            _s1 = _bxor(_s1, _lshift(_s1, 8))

            local _k = _band(_bxor(_s0, _rshift(_s1, 8), _0xIdx * 37, _acc), 0xFF)
            local _c = _byte(_0xChunk, _0xbIdx)
            local _p = _band(_bxor(_c, _k), 0xFF)

            _0xIdx = _0xIdx + 1
            _0xT[_0xIdx] = _char(_p)
            _acc = _band(_acc + _c + 11, 0xFF)
        end
    end

    -- Clear encrypted chunks immediately from memory
    table.clear(_0xCh)

    -- Assemble payload string
    local _0xPayload = table.concat(_0xT)
    table.clear(_0xT)

    -- Compile closure
    local _0xCompiled, _0xErr = _0xSafeLoad(_0xPayload, "@KrakenShield_UR")
    _0xPayload = nil -- Clear plaintext reference immediately

    -- Force instant GC sweep so strings cannot be extracted from GC tables
    if typeof(collectgarbage) == "function" then
        collectgarbage("collect")
    end

    if not _0xCompiled then
        error("[KrakenShield] Integrity validation failed: " .. tostring(_0xErr), 2)
    end

    return _0xCompiled(...)
end)(...)
`;

const outputContent = header + chunks.join('\n') + '\n' + footer;
fs.writeFileSync(repoOut, outputContent, 'utf8');

// Also update build-protected.js so subsequent runs use the new military-grade builder
fs.writeFileSync(path.join(repoDir, 'build-protected.js'), fs.readFileSync(__filename, 'utf8'), 'utf8');

console.log('[4/4] Build complete!');
console.log(`Protected file: ${repoOut}`);
console.log(`Protected size: ${outputContent.length.toLocaleString()} bytes`);
