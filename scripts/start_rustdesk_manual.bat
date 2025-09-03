@echo off
echo ========================================
echo Manual RustDesk Start
echo ========================================

echo.
echo === Plugin Status ===
echo System Plugin: C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\rd_ui_plugin\
dir "C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\rd_ui_plugin\"

echo.
echo === Starting RustDesk ===
echo Path: C:\Program Files (x86)\RustDesk\rustdesk.exe
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
echo Starting RustDesk...
start "" "C:\Program Files (x86)\RustDesk\rustdesk.exe"

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
echo 4. If not, check the system log for plugin messages
echo.
echo === System Log Location ===
echo C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log
echo.
echo === Plugin Log Check ===
echo To check if plugin is loaded, look for these in the log:
echo - "plugin" (any plugin-related messages)
echo - "rd_ui_plugin" (our plugin ID)
echo - "Plugin initialized" (plugin initialization)
echo.
pause
