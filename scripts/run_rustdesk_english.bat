@echo off
echo ========================================
echo RustDesk Plugin Debug Launcher
echo ========================================

REM Set working directory
set "RUSTDESK_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"
set "PLUGIN_DIR=%RUSTDESK_DIR%\plugins\rd_ui_plugin"

echo RustDesk Directory: %RUSTDESK_DIR%
echo Plugin Directory: %PLUGIN_DIR%

REM Check RustDesk executable
if not exist "%RUSTDESK_DIR%\rustdesk.exe" (
    echo ERROR: rustdesk.exe not found
    echo Please compile RustDesk project first
    pause
    exit /b 1
)

REM Check plugin files
if not exist "%PLUGIN_DIR%\plugin_rd_ui_plugin.dll" (
    echo ERROR: Plugin DLL not found
    echo Please compile plugin first
    pause
    exit /b 1
)

if not exist "%PLUGIN_DIR%\config.json" (
    echo ERROR: Plugin config not found
    pause
    exit /b 1
)

echo ✅ All files check passed
echo.

REM Show plugin file info
echo === Plugin File Info ===
dir "%PLUGIN_DIR%"
echo.

REM Show plugin config
echo === Plugin Config Content ===
type "%PLUGIN_DIR%\config.json"
echo.

REM Switch to RustDesk directory
cd /d "%RUSTDESK_DIR%"

echo Starting RustDesk (Debug Mode)...
echo Plugin will auto-load and apply config:
echo - Fullscreen Mode: Enabled
echo - Scale Mode: Fit Window
echo - Toolbar: Hidden
echo.

REM Set environment variables for plugin debug
set RUST_LOG=info
set RUSTDESK_PLUGIN_DEBUG=1

echo Environment Variables:
echo RUST_LOG=%RUST_LOG%
echo RUSTDESK_PLUGIN_DEBUG=%RUSTDESK_PLUGIN_DEBUG%
echo.

REM Start RustDesk
start "" "rustdesk.exe"

echo RustDesk started!
echo Plugin function will auto-activate when connecting to remote desktop
echo Please check log file for debug information
echo.
echo Log Path: %RUSTDESK_DIR%-log\RustDesk\log\rustdesk_rCURRENT.log
pause
