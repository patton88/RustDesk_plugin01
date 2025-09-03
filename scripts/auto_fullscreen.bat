@echo off
echo ========================================
echo Windows Automation Fullscreen
echo ========================================

echo.
echo === Alternative Approach ===
echo Since configuration and command-line methods
echo didn't work, we'll use Windows automation.
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

echo === Automation Strategy ===
echo 1. Start RustDesk normally
echo 2. Connect to remote desktop
echo 3. Use Windows automation to press F11
echo 4. Monitor and maintain fullscreen state
echo.

echo === Starting RustDesk ===
cd /d "%PORTABLE_DIR%"
start "" "rustdesk.exe"

echo Waiting for RustDesk to start...
timeout /t 3 /nobreak >NUL

echo.
echo === Connection Instructions ===
echo 1. In RustDesk, connect to: 10.2.10.216
echo 2. Use password: Uvwx#1234
echo 3. Wait for remote desktop to appear
echo 4. Press any key when ready for automation
echo.

pause

echo.
echo === Starting Automation ===
echo Pressing F11 for fullscreen...
echo.

REM Use PowerShell to send F11 key
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{F11}')"

echo ✅ F11 key sent
echo.

echo === Automation Complete ===
echo Fullscreen should now be active.
echo.
echo === Troubleshooting ===
echo If F11 didn't work:
echo 1. Try pressing F11 manually
echo 2. Use View menu -^> Fullscreen
echo 3. Check if remote desktop supports fullscreen
echo.

echo === Monitoring ===
echo To maintain fullscreen:
echo 1. Don't click outside the remote desktop
echo 2. Use Alt+Tab to switch between windows
echo 3. Press F11 again to exit fullscreen
echo.

pause
