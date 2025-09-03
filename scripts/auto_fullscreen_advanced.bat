@echo off
echo ========================================
echo Advanced Windows Automation Fullscreen
echo ========================================

echo.
echo === Problem Summary ===
echo - TOML config fixed but not working
echo - Command-line arguments may not be supported
echo - Using Windows automation as final solution
echo.

set "PORTABLE_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"

echo === RustDesk Directory ===
echo %PORTABLE_DIR%
echo.

if not exist "%PORTABLE_DIR%\rustdesk.exe" (
    echo ❌ RustDesk not found
    pause
    exit /b 1
)

echo ✅ RustDesk found
echo.

echo === Automation Strategy ===
echo 1. Start RustDesk with specific parameters
echo 2. Wait for it to fully load
echo 3. Connect to remote desktop
echo 4. Use multiple automation methods
echo 5. Monitor and maintain fullscreen
echo.

echo === Starting RustDesk ===
cd /d "%PORTABLE_DIR%"

REM Try different startup methods
echo Method 1: Starting with --fullscreen...
start "" "rustdesk.exe" --fullscreen

echo Waiting 5 seconds...
timeout /t 5 /nobreak >NUL

echo Method 2: Starting with --connect...
start "" "rustdesk.exe" --connect 10.2.10.216 --password "Uvwx#1234"

echo.
echo === Connection Status ===
echo RustDesk should now be running.
echo.
echo === Automation Sequence ===
echo When remote desktop appears:
echo 1. Wait for connection to stabilize
echo 2. Press any key to start automation
echo 3. Multiple automation methods will be tried
echo.

pause

echo.
echo === Starting Advanced Automation ===
echo.

echo Step 1: Sending F11 key...
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{F11}')"

echo Waiting 2 seconds...
timeout /t 2 /nobreak >NUL

echo Step 2: Sending Alt+V+F (View menu -^> Fullscreen)...
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('%v')"
timeout /t 1 /nobreak >NUL
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('f')"

echo Waiting 2 seconds...
timeout /t 2 /nobreak >NUL

echo Step 3: Sending Ctrl+Shift+F (alternative fullscreen)...
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('^+f')"

echo.
echo === Automation Complete ===
echo Multiple fullscreen methods have been attempted.
echo.

echo === Verification ===
echo Check if remote desktop is now in fullscreen mode.
echo.

echo === Manual Override ===
echo If automation didn't work:
echo 1. Press F11 manually
echo 2. Use View menu -^> Fullscreen
echo 3. Right-click remote desktop -^> Fullscreen
echo.

echo === Maintenance ===
echo To keep fullscreen active:
echo 1. Don't click outside remote desktop
echo 2. Use Alt+Tab to switch windows
echo 3. Avoid minimizing/maximizing
echo.

echo === Alternative Tools ===
echo If this still doesn't work:
echo 1. Use AutoHotkey for advanced automation
echo 2. Use Windows Task Scheduler
echo 3. Use third-party remote desktop tools
echo.

pause
