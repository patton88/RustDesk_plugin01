@echo off
echo ========================================
echo RustDesk Reinstallation
echo ========================================

echo.
echo === Current Status ===
echo RustDesk installation appears to be corrupted
echo Error: "此时不应有 \RustDesk"
echo.

echo === Solution Options ===
echo 1. Reinstall RustDesk from official source
echo 2. Use portable version (already working)
echo 3. Repair existing installation
echo.

echo === Option 1: Reinstall RustDesk ===
echo Download from: https://github.com/rustdesk/rustdesk/releases
echo Latest version: 1.4.1
echo.

echo === Option 2: Use Portable Version ===
echo Portable version is already working with plugin
echo Path: %~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\rustdesk.exe
echo.

echo === Option 3: Repair Installation ===
echo Attempting to repair existing installation...
echo.

REM Try to uninstall RustDesk first
echo === Uninstalling Corrupted RustDesk ===
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /f "RustDesk" /k 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Found RustDesk in registry, attempting uninstall...
    echo Please run as Administrator if prompted
    wmic product where "name like '%%RustDesk%%'" call uninstall /nointeractive
) else (
    echo RustDesk not found in registry
)

echo.
echo === Cleaning Up ===
echo Removing corrupted files...

REM Remove corrupted installation
if exist "C:\Program Files (x86)\RustDesk" (
    echo Removing: C:\Program Files (x86)\RustDesk
    rmdir /s /q "C:\Program Files (x86)\RustDesk" 2>nul
)

if exist "C:\Program Files\RustDesk" (
    echo Removing: C:\Program Files\RustDesk
    rmdir /s /q "C:\Program Files\RustDesk" 2>nul
)

echo.
echo === Recommendation ===
echo Since portable version is working with plugin:
echo 1. Use portable version for now
echo 2. Download fresh RustDesk installer
echo 3. Install as Administrator
echo 4. Deploy plugin to new installation
echo.

echo === Quick Test ===
echo Let's test the portable version to confirm plugin works:
echo.
pause

echo.
echo === Testing Portable Version ===
call "%~dp0start_portable_rustdesk.bat"
