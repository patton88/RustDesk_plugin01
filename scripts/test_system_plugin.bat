@echo off
echo ========================================
echo RustDesk System Plugin Test
echo ========================================

echo.
echo === Current Plugin Status ===
echo System Plugin: C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\rd_ui_plugin\
dir "C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\rd_ui_plugin\"

echo.
echo ProgramData Plugin: C:\ProgramData\RustDesk\plugins\rd_ui_plugin\
dir "C:\ProgramData\RustDesk\plugins\rd_ui_plugin\"

echo.
echo === Starting RustDesk (Installed Version) ===
echo This will start the installed RustDesk from Start Menu
echo.

REM Check if RustDesk is already running
tasklist /FI "IMAGENAME eq rustdesk.exe" 2>NUL | find /I /N "rustdesk.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ⚠️  RustDesk is already running
    echo Please close it first, then press any key to continue...
    pause
    taskkill /F /IM rustdesk.exe 2>NUL
    timeout /t 2 /nobreak >NUL
)

echo Starting RustDesk...
echo.

REM Start RustDesk from Start Menu (installed version)
start "" "C:\Program Files (x86)\RustDesk\rustdesk.exe"

if %ERRORLEVEL% EQU 0 (
    echo ✅ RustDesk started successfully
) else (
    echo ❌ Failed to start RustDesk
    echo Trying alternative method...
    start "" "rustdesk.exe"
)

echo.
echo === Plugin Test Instructions ===
echo 1. Wait for RustDesk to fully start
echo 2. Connect to a remote desktop (10.2.10.216)
echo 3. Check if it automatically goes fullscreen
echo 4. If not, check the system log for plugin messages
echo.

echo === Monitoring System Log ===
echo Press Ctrl+C to stop monitoring
echo.

REM Monitor the system log for plugin-related messages
:monitor_loop
timeout /t 5 /nobreak >NUL
echo [%TIME%] Checking for plugin messages...
findstr /i "plugin" "C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log" 2>NUL | findstr /v "clipboard"
if %ERRORLEVEL% EQU 0 (
    echo ✅ Found plugin-related messages!
) else (
    echo ❌ No plugin messages found
)
goto :monitor_loop
