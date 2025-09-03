@echo off
echo ========================================
echo Windows Automation Fullscreen Solution
echo ========================================

echo.
echo === Problem Summary ===
echo - RustDesk portable version does NOT support plugins
echo - Plugin system is NOT compiled into this binary
echo - Using Windows automation as the solution
echo.

set "PORTABLE_DIR=%~dp0..\target\Soft\rustdesk-1.4.1-x86-sciter"
set "TARGET_IP=10.2.10.216"
set "TARGET_PASSWORD=Uvwx#1234"

echo === RustDesk Information ===
echo Directory: %PORTABLE_DIR%
echo Target: %TARGET_IP%
echo.

if not exist "%PORTABLE_DIR%\rustdesk.exe" (
    echo ❌ RustDesk not found
    pause
    exit /b 1
)

echo ✅ RustDesk found
echo.

echo === Automation Strategy ===
echo 1. Start RustDesk and connect to remote desktop
echo 2. Wait for connection to establish
echo 3. Use Windows automation to click fullscreen button
echo 4. Monitor and maintain fullscreen state
echo.

echo === Starting RustDesk ===
cd /d "%PORTABLE_DIR%"
echo Starting RustDesk...
start "" "rustdesk.exe"

echo Waiting for RustDesk to start...
timeout /t 5 /nobreak >NUL

echo.
echo === Connection Instructions ===
echo 1. In RustDesk, connect to: %TARGET_IP%
echo 2. Use password: %TARGET_PASSWORD%
echo 3. Wait for remote desktop to appear
echo 4. Make sure remote desktop window is active
echo 5. Press any key when ready for automation
echo.

pause

echo.
echo === Starting Fullscreen Automation ===
echo.

echo Step 1: Activating remote desktop window...
echo Sending Alt+Tab to ensure remote desktop is active...
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{TAB}')"
timeout /t 1 /nobreak >NUL

echo Step 2: Trying F11 fullscreen...
echo Sending F11 key...
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{F11}')"

echo Waiting 2 seconds...
timeout /t 2 /nobreak >NUL

echo Step 3: Trying View menu fullscreen...
echo Sending Alt+V+F (View menu -^> Fullscreen)...
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('%v')"
timeout /t 1 /nobreak >NUL
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('f')"

echo Waiting 2 seconds...
timeout /t 2 /nobreak >NUL

echo Step 4: Trying alternative fullscreen methods...
echo Sending Ctrl+Shift+F...
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
echo 1. Click the fullscreen button manually
echo 2. Press F11 key manually
echo 3. Use View menu -^> Fullscreen
echo 4. Right-click remote desktop -^> Fullscreen
echo.

echo === Maintenance ===
echo To keep fullscreen active:
echo 1. Don't click outside the remote desktop
echo 2. Use Alt+Tab to switch between windows
echo 3. Avoid minimizing/maximizing
echo.

echo === Alternative Solutions ===
echo Since plugins don't work:
echo 1. **AutoHotkey Script**: Create advanced automation
echo 2. **Task Scheduler**: Schedule fullscreen actions
echo 3. **Registry Modification**: Change default behavior
echo 4. **Third-party Tools**: Use automation software
echo.

echo === AutoHotkey Example ===
echo Create a file called "fullscreen.ahk":
echo.
echo #SingleInstance Force
echo SetWorkingDir %A_ScriptDir%
echo.
echo F12::
echo {
echo   WinActivate, "Remote Desktop"
echo   Send, {F11}
echo }
echo.
echo ^F12::
echo {
echo   WinActivate, "Remote Desktop"
echo   Send, !v
echo   Sleep, 100
echo   Send, f
echo }
echo.

pause
