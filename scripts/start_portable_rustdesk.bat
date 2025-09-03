@echo off
echo ========================================
echo Start Portable RustDesk with Plugin
echo ========================================

set "PORTABLE_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"
set "PLUGIN_DIR=%PORTABLE_DIR%\plugins\rd_ui_plugin"

echo Portable RustDesk Directory: %PORTABLE_DIR%
echo Plugin Directory: %PLUGIN_DIR%
echo.

REM Check if portable RustDesk exists
if not exist "%PORTABLE_DIR%\rustdesk.exe" (
    echo ❌ Portable RustDesk not found at: %PORTABLE_DIR%\rustdesk.exe
    echo Please compile RustDesk project first
    pause
    exit /b 1
)

REM Check if plugin exists
if not exist "%PLUGIN_DIR%\plugin_rd_ui_plugin.dll" (
    echo ❌ Plugin DLL not found at: %PLUGIN_DIR%\plugin_rd_ui_plugin.dll
    echo Please compile plugin first
    pause
    exit /b 1
)

echo ✅ All files found
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
echo === Starting Portable RustDesk ===
cd /d "%PORTABLE_DIR%"

REM Set environment variables for plugin debug
set RUST_LOG=info
set RUSTDESK_PLUGIN_DEBUG=1

echo Environment Variables:
echo RUST_LOG=%RUST_LOG%
echo RUSTDESK_PLUGIN_DEBUG=%RUSTDESK_PLUGIN_DEBUG%
echo.

echo Starting RustDesk...
start "" "rustdesk.exe"

if %ERRORLEVEL% EQU 0 (
    echo ✅ RustDesk started successfully
) else (
    echo ❌ Failed to start RustDesk
    echo Error code: %ERRORLEVEL%
)

echo.
echo === Test Instructions ===
echo 1. Wait for RustDesk to fully start
echo 2. Connect to remote desktop: 10.2.10.216
echo 3. Check if it automatically goes fullscreen
echo 4. If working, plugin is functioning correctly
echo.
echo === Log Location ===
echo Portable log: %PORTABLE_DIR%-log\RustDesk\log\rustdesk_rCURRENT.log
echo System log: C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log
echo.
echo === Plugin Status ===
echo Plugin should auto-load and apply fullscreen settings
echo Look for plugin messages in the log files
echo.
pause
