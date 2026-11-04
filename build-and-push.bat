@echo off
title KrakenHub - Auto Build & Push to GitHub
color 0b
echo ===================================================
echo     KRAKENHUB - AUTO BUILD & PUSH TO GITHUB
echo ===================================================
echo.
echo [1/3] Obfuscating urban-reload.luau...
node build-protected.js
if %errorlevel% neq 0 (
    echo [ERROR] Build failed!
    pause
    exit /b %errorlevel%
)

echo.
echo [2/3] Staging and Committing...
git add urban-reload-protected.luau
git commit -m "release: auto-update urban-reload-protected"

echo.
echo [3/3] Pushing to GitHub (origin/main)...
git push origin main
if %errorlevel% neq 0 (
    echo.
    echo ---------------------------------------------------
    echo [ERROR] Push failed! (GitHub Permission Error 403)
    echo โทเค่นยังไม่ได้เปิดสิทธิ์ 'Contents: Read and write'
    echo หรือใช้ Classic Token ที่ติ๊กถูกช่อง 'repo'
    echo ---------------------------------------------------
    pause
    exit /b %errorlevel%
)

echo.
echo ===================================================
echo   SUCCESS! PUSHED TO GITHUB!
echo   Users run the script via:
echo   loadstring(game:HttpGet("https://tinyurl.com/KrakenHub-Urban"))()
echo ===================================================
echo.
pause
