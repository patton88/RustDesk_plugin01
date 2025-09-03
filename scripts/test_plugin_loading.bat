@echo off
echo ========================================
echo RustDesk Plugin Loading Test
echo ========================================

REM Set working directory
set "RUSTDESK_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"
set "PLUGIN_DIR=%RUSTDESK_DIR%\plugins\rd_ui_plugin"

echo RustDesk Directory: %RUSTDESK_DIR%
echo Plugin Directory: %PLUGIN_DIR%

echo.
echo === Checking Plugin Files ===
dir "%PLUGIN_DIR%"

echo.
echo === Plugin Config ===
type "%PLUGIN_DIR%\config.json"

echo.
echo === Plugin Registration ===
type "%PLUGIN_DIR%\plugin.json"

echo.
echo === Flutter Plugin Manifest ===
type "%PLUGIN_DIR%\pubspec.yaml"

echo.
echo === Testing Plugin DLL ===
echo Checking if DLL can be loaded...

REM Try to check DLL exports using PowerShell
powershell -Command "try { Add-Type -Path '%PLUGIN_DIR%\plugin_rd_ui_plugin.dll' -ErrorAction Stop; Write-Host '✅ DLL can be loaded successfully' } catch { Write-Host '❌ DLL loading failed:' $_.Exception.Message }"

echo.
echo === Starting RustDesk with Plugin Debug ===
cd /d "%RUSTDESK_DIR%"

REM Set environment variables for maximum debug output
set RUST_LOG=debug
set RUSTDESK_PLUGIN_DEBUG=1
set RUSTDESK_LOG_LEVEL=debug

echo Environment Variables:
echo RUST_LOG=%RUST_LOG%
echo RUSTDESK_PLUGIN_DEBUG=%RUSTDESK_PLUGIN_DEBUG%
echo RUSTDESK_LOG_LEVEL=%RUSTDESK_LOG_LEVEL%

echo.
echo Starting RustDesk...
start "" "rustdesk.exe"

echo.
echo RustDesk started with debug logging!
echo Please check the log file for plugin loading information:
echo %RUSTDESK_DIR%-log\RustDesk\log\rustdesk_rCURRENT.log
echo.
echo Look for these keywords in the log:
echo - "plugin"
echo - "rd_ui_plugin"
echo - "Plugin initialized"
echo - "Plugin loaded"
pause
