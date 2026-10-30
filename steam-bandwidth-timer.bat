@echo off
title Steam Bandwidth Timer
cls

:: --- 1. Check if Steam is running ---
tasklist /FI "IMAGENAME eq steam.exe" 2>nul | find /I "steam.exe" >nul
if errorlevel 1 (
    echo [ERROR] Steam does not appear to be running. Please start the Steam client first.
    pause
    exit /b 1
)

:: --- 2. Get and validate duration ---
:GET_MINUTES
set /p "minutes=Enter throttle duration in minutes: "
echo %minutes%| findstr /R "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo [ERROR] Please enter a valid positive integer.
    goto GET_MINUTES
)
set /a "seconds=%minutes% * 60"

:: --- 3. Get and validate speed (in KB/s) ---
:GET_SPEED
set /p "max_speed_kbs=Enter speed limit in KB/s (e.g., 5000 for 5 MB/s): "
echo %max_speed_kbs%| findstr /R "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo [ERROR] Please enter a valid positive integer.
    goto GET_SPEED
)

:: Convert KB/s to Kbit/s (1 KB = 8 Kbit) for set_download_throttle
set /a "throttle_kbit=%max_speed_kbs% * 8"

echo.
echo ===================================================
echo  Applying limit of %max_speed_kbs% KB/s (%throttle_kbit% Kbit/s) to Steam...
echo ===================================================

:: --- 4. Locate Steam.exe via Registry ---
for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Valve\Steam" /v SteamExe 2^>nul') do set "steam_exe=%%B"

if not defined steam_exe (
    set "steam_exe=C:\Program Files (x86)\Steam\Steam.exe"
    if not exist "!steam_exe!" (
        echo [ERROR] Could not automatically find Steam.exe.
        echo Please edit this script and set the steam_exe variable to your correct path.
        pause
        exit /b 1
    )
)

:: --- 5. Apply the throttle ---
"%steam_exe%" +set_download_throttle %throttle_kbit%

if errorlevel 1 (
    echo [ERROR] Failed to apply the throttle. Please check the Steam path.
    pause
    exit /b 1
)

echo.
echo Throttle active (%max_speed_kbs% KB/s). Counting down %minutes% minutes...
echo Do not close this window. It will auto-restore when finished.
echo ===================================================
timeout /t %seconds% /nobreak

:: --- 6. Restore unlimited speed ---
echo.
echo ===================================================
echo  Time is up! Restoring Steam to unlimited speed...
echo ===================================================
"%steam_exe%" +set_download_throttle 0

if errorlevel 1 (
    echo [ERROR] Failed to restore unlimited speed.
    echo You can manually type "set_download_throttle 0" in the Steam console.
) else (
    echo Success! Steam is back to full speed.
)
timeout /t 5 >nul
exit /b 0
