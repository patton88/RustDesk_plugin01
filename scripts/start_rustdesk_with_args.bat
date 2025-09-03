@echo off
echo ========================================
echo RustDesk Command-Line Launcher
echo ========================================

echo.
echo === Command-Line Approach ===
echo Since plugin and config methods didn't work,
echo we'll try using command-line arguments.
echo.

set "PORTABLE_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"

echo RustDesk Directory: %PORTABLE_DIR%
echo.

if not exist "%PORTABLE_DIR%\rustdesk.exe" (
    echo ❌ RustDesk not found
    pause
    exit /b 1
)

echo ✅ RustDesk found
echo.

REM Check if RustDesk is already running
tasklist /FI "IMAGENAME eq rustdesk.exe" 2>NUL | find /I /N "rustdesk.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ⚠️  RustDesk is already running
    echo Current processes:
    tasklist /FI "IMAGENAME eq rustdesk.exe"
    echo.
    echo Do you want to close existing RustDesk? (Y/N)
    set /p choice=
    if /i "%choice%"=="Y" (
        echo Closing existing RustDesk...
        taskkill /F /IM rustdesk.exe 2>NUL
        timeout /t 2 /nobreak >NUL
    )
)

echo.
echo === Starting RustDesk with Arguments ===
cd /d "%PORTABLE_DIR%"

REM Set environment variables
set RUSTDESK_FULLSCREEN=true
set RUSTDESK_SCALE=fit
set RUSTDESK_TOOLBAR=hide

echo Environment Variables:
echo RUSTDESK_FULLSCREEN=%RUSTDESK_FULLSCREEN%
echo RUSTDESK_SCALE=%RUSTDESK_SCALE%
echo RUSTDESK_TOOLBAR=%RUSTDESK_TOOLBAR%
echo.

echo === Launch Options ===
echo 1. Basic launch: rustdesk.exe
echo 2. With fullscreen: rustdesk.exe --fullscreen
echo 3. With connect: rustdesk.exe --connect 10.2.10.216 --password "Uvwx#1234"
echo 4. With fullscreen + connect: rustdesk.exe --fullscreen --connect 10.2.10.216 --password "Uvwx#1234"
echo.

echo === Testing Option 2 (Fullscreen) ===
echo Starting RustDesk with --fullscreen argument...
start "" "rustdesk.exe" --fullscreen

if %ERRORLEVEL% EQU 0 (
    echo ✅ RustDesk started with --fullscreen
) else (
    echo ❌ Failed to start with --fullscreen
    echo Trying basic launch...
    start "" "rustdesk.exe"
)

echo.
echo === Test Instructions ===
echo 1. Wait for RustDesk to start
echo 2. If started with --fullscreen, check if it's in fullscreen mode
echo 3. Connect to remote desktop: 10.2.10.216
echo 4. Check if fullscreen persists
echo.

echo === Alternative Commands to Try ===
echo If --fullscreen doesn't work, try these:
echo.
echo rustdesk.exe --help
echo (Check available command-line options)
echo.
echo rustdesk.exe --version
echo (Check RustDesk version and build info)
echo.
echo rustdesk.exe --config
echo (Check configuration options)
echo.

echo === Manual Fullscreen ===
echo If command-line doesn't work:
echo 1. Start RustDesk normally
echo 2. Connect to remote desktop
echo 3. Press F11 or use View menu to go fullscreen
echo 4. Use Windows automation tools for automation
echo.

pause

