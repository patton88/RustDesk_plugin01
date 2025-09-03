@echo off
echo ========================================
echo Test Fixed TOML Configuration
echo ========================================

echo.
echo === Configuration Status ===
echo TOML files have been fixed with proper syntax.
echo UI settings have been added to all config files.
echo.

set "CONFIG_DIR=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\config"

echo === Current Configuration ===
echo Config Directory: %CONFIG_DIR%
echo.

if exist "%CONFIG_DIR%\RustDesk.toml" (
    echo === RustDesk.toml ===
    type "%CONFIG_DIR%\RustDesk.toml"
    echo.
)

echo === Test Instructions ===
echo 1. Close RustDesk completely (if running)
echo 2. Start RustDesk from portable directory
echo 3. Connect to: 10.2.10.216
echo 4. Check if fullscreen is applied automatically
echo.

echo === Expected Behavior ===
echo With fixed TOML config:
echo - RustDesk should start with UI settings loaded
echo - Remote desktop should automatically go fullscreen
echo - Scale should be set to "fit"
echo - Toolbar should be hidden
echo.

echo === If Still Not Working ===
echo 1. Check RustDesk logs for errors
echo 2. Verify TOML syntax is correct
echo 3. Try manual F11 fullscreen
echo 4. Use View menu -^> Fullscreen
echo.

echo === Manual Fullscreen Test ===
echo When connected to remote desktop:
echo 1. Press F11 key
echo 2. Use View menu -^> Fullscreen
echo 3. Check if fullscreen works manually
echo.

echo === Configuration Verification ===
echo The following UI settings should be active:
echo - fullscreen = true
echo - scale = "fit"  
echo - toolbar = "hide"
echo.

echo === Next Steps ===
echo 1. Test the fixed configuration
echo 2. Report results (working/not working)
echo 3. If not working, we'll try other methods
echo.

pause
