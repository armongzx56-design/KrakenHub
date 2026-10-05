# Multi Roblox Manager

Windows desktop manager for launching, monitoring, and arranging Roblox windows.

## Features
- Launch / Stop / Restart multiple Roblox processes
- Real-time PID and running status
- 2x2, 3x3, 4x4 and custom window layouts
- Focus individual instances
- Windows-native WPF UI
- GitHub Actions builds a self-contained x64 EXE

## Important
This manager launches Roblox normally. It does not bypass Roblox's instance restrictions, inject code, or implement exploit/executor behavior.

## Build locally
Install .NET 8 SDK on Windows, then:

```powershell
dotnet restore
dotnet publish KrakenHubMultiRoblox/KrakenHubMultiRoblox.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true
```

The executable will be under:
`KrakenHubMultiRoblox/bin/Release/net8.0-windows/win-x64/publish/`.
