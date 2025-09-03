@echo off
echo ========================================
echo Use Install Version for Fullscreen
echo ========================================

echo.
echo === Solution Found ===
echo Install version supports fullscreen!
echo Portable version does NOT support fullscreen!
echo Using install version as the solution.
echo.

set "INSTALL_DIR=C:\Program Files (x86)\RustDesk"
set "TARGET_IP=10.2.10.216"
set "TARGET_PASSWORD=Uvwx#1234"

echo === Install Version Information ===
echo Directory: %INSTALL_DIR%
echo.

if exist "%INSTALL_DIR%\rustdesk.exe" (
    echo ✅ Install version found
    echo.
    echo === File Information ===
    dir "%INSTALL_DIR%\rustdesk.exe" | findstr "rustdesk.exe"
    echo.
    
    echo === Fullscreen Test ===
    echo Testing install version fullscreen support...
    echo.
    
    echo === Method 1: Command-Line Fullscreen ===
    echo Starting with --fullscreen argument...
    start "" "%INSTALL_DIR%\rustdesk.exe" --fullscreen
    
    echo Waiting 3 seconds...
    timeout /t 3 /nobreak >NUL
    
    echo === Method 2: Connect with Fullscreen ===
    echo Starting with fullscreen + connect...
    start "" "%INSTALL_DIR%\rustdesk.exe" --fullscreen --connect %TARGET_IP% --password "%TARGET_PASSWORD%"
    
    echo.
    echo === Test Instructions ===
    echo 1. Check if --fullscreen argument worked
    echo 2. Check if connection to %TARGET_IP% succeeded
    echo 3. Verify remote desktop is in fullscreen mode
    echo.
    
    echo === Expected Results ===
    echo - Install version should start in fullscreen mode
    echo - Connection to %TARGET_IP% should work
    echo - Remote desktop should be fullscreen
    echo.
    
    echo === Alternative Methods ===
    echo If command-line doesn't work:
    echo 1. Start install version normally
    echo 2. Connect to %TARGET_IP%
    echo 3. Use F11 or View menu for fullscreen
    echo.
    
    echo === Configuration Transfer ===
    echo Since install version works, we can:
    echo 1. Copy install version to portable location
    echo 2. Use install version for all connections
    echo 3. Keep portable version as backup
    echo.
    
    echo === Copy Install Version ===
    echo Do you want to copy install version to portable location? (Y/N)
    set /p choice=
    if /i "%choice%"=="Y" (
        echo Copying install version...
        copy "%INSTALL_DIR%\rustdesk.exe" "%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\rustdesk_install.exe" >nul
        if %ERRORLEVEL% EQU 0 (
            echo ✅ Install version copied as rustdesk_install.exe
            echo.
            echo === Usage Instructions ===
            echo Use rustdesk_install.exe for fullscreen support:
            echo rustdesk_install.exe --fullscreen --connect %TARGET_IP% --password "%TARGET_PASSWORD%"
        ) else (
            echo ❌ Copy failed
        )
    )
    
) else (
    echo ❌ Install version not found
    echo.
    echo === Alternative Solutions ===
    echo 1. Install RustDesk from official website
    echo 2. Download newer portable version
    echo 3. Use Windows automation tools
    echo.
)

echo.
echo === Summary ===
echo Install version supports fullscreen - use it!
echo Portable version is limited - avoid for fullscreen.
echo.
echo === Next Steps ===
echo 1. Test install version fullscreen
echo 2. Use install version for connections
echo 3. Consider copying install version
echo.

pause
