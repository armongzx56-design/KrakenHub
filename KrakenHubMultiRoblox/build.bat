@echo off
title KrakenHub Multi Roblox - Build

echo ========================================================
echo       KRAKENHUB MULTI ROBLOX
echo       Windows x64 Standalone EXE
echo ========================================================
echo.

if not exist Output mkdir Output

echo [1/3] Restoring...
dotnet restore KrakenHubMultiRoblox.csproj
if errorlevel 1 (
    echo Restore FAILED.
    pause
    exit /b 1
)

echo.
echo [2/3] Publishing...
dotnet publish KrakenHubMultiRoblox.csproj -c Release -r win-x64 --self-contained true -p:Platform=x64 -p:PublishSingleFile=true -p:EnableCompressionInSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:DebugType=None -p:DebugSymbols=false -o ./Output

if errorlevel 1 (
    echo Publish FAILED.
    pause
    exit /b 1
)

echo.
echo [3/3] Finished!
echo Output\KrakenHubMultiRoblox.exe
echo.
pause