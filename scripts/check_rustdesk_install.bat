@echo off
echo ========================================
echo RustDesk Installation Check
echo ========================================

echo.
echo === Checking RustDesk Installation ===

REM Check common installation paths
set "PATHS_TO_CHECK=C:\Program Files (x86)\RustDesk;C:\Program Files\RustDesk;C:\Users\%USERNAME%\AppData\Local\Programs\RustDesk"

for %%p in (%PATHS_TO_CHECK%) do (
    if exist "%%p\rustdesk.exe" (
        echo ✅ Found RustDesk at: %%p\rustdesk.exe
        echo File size:
        dir "%%p\rustdesk.exe"
        echo.
    ) else (
        echo ❌ Not found at: %%p\rustdesk.exe
    )
)

echo.
echo === Checking Start Menu ===
if exist "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\RustDesk" (
    echo ✅ Start Menu shortcut directory exists
    dir "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\RustDesk"
) else (
    echo ❌ Start Menu shortcut directory not found
)

echo.
echo === Checking Registry ===
echo Checking Windows Registry for RustDesk...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /f "RustDesk" /k 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Found RustDesk in registry
) else (
    echo ❌ RustDesk not found in registry
)

echo.
echo === Checking Running Processes ===
tasklist /FI "IMAGENAME eq rustdesk.exe" 2>NUL | find /I /N "rustdesk.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ RustDesk is currently running
    tasklist /FI "IMAGENAME eq rustdesk.exe"
) else (
    echo ❌ RustDesk is not running
)

echo.
echo === Installation Check Complete ===
pause
