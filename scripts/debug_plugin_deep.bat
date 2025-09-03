@echo off
echo ========================================
echo Deep Plugin Debug
echo ========================================

echo.
echo === Plugin Status Check ===
set "PLUGIN_DLL=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\plugins\rd_ui_plugin\plugin_rd_ui_plugin.dll"
set "PORTABLE_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"

echo Plugin DLL: %PLUGIN_DLL%
echo Portable Dir: %PORTABLE_DIR%
echo.

REM Check plugin files
if exist "%PLUGIN_DLL%" (
    echo ✅ Plugin DLL exists
    dir "%PLUGIN_DLL%"
) else (
    echo ❌ Plugin DLL not found!
    pause
    exit /b 1
)

echo.
echo === Plugin Directory Check ===
dir "%PORTABLE_DIR%\plugins\rd_ui_plugin\"

echo.
echo === RustDesk Process Check ===
tasklist /FI "IMAGENAME eq rustdesk.exe" 2>NUL | find /I /N "rustdesk.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ RustDesk is running
    echo Process details:
    tasklist /FI "IMAGENAME eq rustdesk.exe" /V
) else (
    echo ❌ RustDesk is not running
)

echo.
echo === Plugin Loading Test ===
echo Starting RustDesk with plugin debug...
echo.

REM Start RustDesk with maximum debug output
cd /d "%PORTABLE_DIR%"

REM Set environment variables for maximum debug
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
echo === Debug Instructions ===
echo 1. Wait for RustDesk to start
echo 2. Connect to remote desktop: 10.2.10.216
echo 3. Check if fullscreen is applied
echo 4. Look for plugin messages in logs
echo.

echo === Log Locations ===
echo Portable log: %PORTABLE_DIR%-log\RustDesk\log\rustdesk_rCURRENT.log
echo System log: C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log
echo.

echo === Expected Plugin Messages ===
echo Look for these in the logs:
echo - "Loading plugin: rd_ui_plugin"
echo - "Plugin initialized successfully"
echo - "[rd_ui_plugin] Plugin initialized successfully"
echo - "[rd_ui_plugin] Applying UI settings"
echo.

echo === If No Plugin Messages ===
echo The plugin is not being loaded. Possible reasons:
echo 1. Plugin ABI mismatch
echo 2. RustDesk version incompatibility
echo 3. Plugin loading mechanism different
echo 4. Missing plugin registration
echo.

echo === Next Steps ===
echo 1. Check logs for plugin messages
echo 2. If no messages, plugin loading failed
echo 3. If messages but no fullscreen, plugin logic issue
echo.

pause

echo.
echo === Checking Logs ===
echo Checking for plugin messages...

REM Wait a bit for logs to be written
timeout /t 5 /nobreak >NUL

REM Check portable log
if exist "%PORTABLE_DIR%-log\RustDesk\log\rustdesk_rCURRENT.log" (
    echo === Portable Log Plugin Messages ===
    findstr /i "plugin" "%PORTABLE_DIR%-log\RustDesk\log\rustdesk_rCURRENT.log" | findstr /v "clipboard"
) else (
    echo ❌ Portable log not found
)

REM Check system log
if exist "C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log" (
    echo === System Log Plugin Messages ===
    findstr /i "plugin" "C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log" | findstr /v "clipboard"
) else (
    echo ❌ System log not found
)

echo.
echo === Debug Complete ===
pause

