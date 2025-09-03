@echo off
echo ========================================
echo RustDesk Deep Diagnosis
echo ========================================

echo.
echo === Problem Analysis ===
echo TOML config fixed but fullscreen still not working.
echo Need to diagnose RustDesk version and config support.
echo.

set "PORTABLE_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"
set "CONFIG_DIR=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\config"

echo === RustDesk Information ===
echo Directory: %PORTABLE_DIR%
echo.

if exist "%PORTABLE_DIR%\rustdesk.exe" (
    echo ✅ RustDesk found
    echo.
    echo === Version Check ===
    echo Checking RustDesk version...
    "%PORTABLE_DIR%\rustdesk.exe" --version 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Version check failed
        echo.
        echo === Help Check ===
        echo Checking available command-line options...
        "%PORTABLE_DIR%\rustdesk.exe" --help 2>nul
        if %ERRORLEVEL% NEQ 0 (
            echo ❌ Help check failed
        )
    )
) else (
    echo ❌ RustDesk not found
    pause
    exit /b 1
)

echo.
echo === Configuration Analysis ===
echo Config Directory: %CONFIG_DIR%
echo.

if exist "%CONFIG_DIR%\RustDesk.toml" (
    echo ✅ Main config found
    echo.
    echo === Current UI Settings ===
    findstr /C:"[ui]" "%CONFIG_DIR%\RustDesk.toml"
    findstr /C:"fullscreen" "%CONFIG_DIR%\RustDesk.toml"
    findstr /C:"scale" "%CONFIG_DIR%\RustDesk.toml"
    findstr /C:"toolbar" "%CONFIG_DIR%\RustDesk.toml"
    echo.
    
    echo === Full Config Content ===
    echo Main config file:
    type "%CONFIG_DIR%\RustDesk.toml"
    echo.
) else (
    echo ❌ Main config not found
)

echo.
echo === Alternative Approaches ===
echo Since TOML config didn't work, trying other methods:
echo.

echo === Method 1: Command-Line Arguments ===
echo Testing command-line fullscreen support...
echo Starting RustDesk with --fullscreen...
start "" "%PORTABLE_DIR%\rustdesk.exe" --fullscreen

echo.
echo === Method 2: Environment Variables ===
echo Setting environment variables...
set RUSTDESK_FULLSCREEN=true
set RUSTDESK_SCALE=fit
set RUSTDESK_TOOLBAR=hide

echo Environment variables set:
echo RUSTDESK_FULLSCREEN=%RUSTDESK_FULLSCREEN%
echo RUSTDESK_SCALE=%RUSTDESK_SCALE%
echo RUSTDESK_TOOLBAR=%RUSTDESK_TOOLBAR%
echo.

echo === Method 3: Manual Fullscreen Test ===
echo Starting RustDesk normally for manual test...
start "" "%PORTABLE_DIR%\rustdesk.exe"

echo.
echo === Test Instructions ===
echo 1. Check if --fullscreen argument worked
echo 2. Connect to 10.2.10.216 manually
echo 3. Try F11 key for fullscreen
echo 4. Use View menu -^> Fullscreen
echo.

echo === Expected Results ===
echo - Command-line --fullscreen should work
echo - Environment variables should be recognized
echo - Manual F11 should work
echo.

echo === If Nothing Works ===
echo This suggests RustDesk 1.4.1 has limited fullscreen support.
echo We may need to use Windows automation tools.
echo.

pause
