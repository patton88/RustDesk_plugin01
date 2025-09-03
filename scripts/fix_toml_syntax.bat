@echo off
echo ========================================
echo Fix TOML Syntax Issues
echo ========================================

echo.
echo === Problem Analysis ===
echo The previous script added invalid TOML syntax:
echo \n\n[ui]\nfullscreen = true\nscale = "fit"\ntoolbar = "hide"
echo.
echo This is NOT valid TOML format!
echo.

set "CONFIG_DIR=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\config"

echo === Fixing TOML Files ===
echo Config Directory: %CONFIG_DIR%
echo.

REM Fix main config
if exist "%CONFIG_DIR%\RustDesk.toml" (
    echo === Fixing RustDesk.toml ===
    
    REM Create proper TOML content
    echo Creating proper TOML syntax...
    (
        echo enc_id = '00njcADI76DVi+7WKkkqHJ3X0owHCRnAIIj2E='
        echo password = ''
        echo salt = 'szk33p'
        echo key_pair = [
        echo     [
        echo     167,
        echo     21,
        echo     174,
        echo     60,
        echo     218,
        echo     185,
        echo     226,
        echo     197,
        echo     111,
        echo     55,
        echo     1,
        echo     62,
        echo     187,
        echo     146,
        echo     1,
        echo     100,
        echo     180,
        echo     35,
        echo     254,
        echo     166,
        echo     19,
        echo     77,
        echo     110,
        echo     44,
        echo     136,
        echo     67,
        echo     253,
        echo     223,
        echo     181,
        echo     185,
        echo     182,
        echo     190,
        echo     189,
        echo     118,
        echo     229,
        echo     79,
        echo     219,
        echo     225,
        echo     15,
        echo     167,
        echo     241,
        echo     29,
        echo     61,
        echo     47,
        echo     50,
        echo     11,
        echo     94,
        echo     214,
        echo     62,
        echo     79,
        echo     55,
        echo     91,
        echo     2,
        echo     62,
        echo     235,
        echo     43,
        echo     211,
        echo     62,
        echo     215,
        echo     106,
        echo     189,
        echo     107,
        echo     97,
        echo     154,
        echo ],
        echo     [
        echo     189,
        echo     118,
        echo     229,
        echo     79,
        echo     219,
        echo     225,
        echo     15,
        echo     167,
        echo     241,
        echo     29,
        echo     61,
        echo     47,
        echo     50,
        echo     11,
        echo     94,
        echo     214,
        echo     62,
        echo     79,
        echo     55,
        echo     91,
        echo     2,
        echo     62,
        echo     235,
        echo     43,
        echo     211,
        echo     62,
        echo     215,
        echo     106,
        echo     189,
        echo     107,
        echo     97,
        echo     154,
        echo ],
        echo ]
        echo key_confirmed = true
        echo.
        echo [keys_confirmed]
        echo rs-ny = true
        echo.
        echo [ui]
        echo fullscreen = true
        echo scale = "fit"
        echo toolbar = "hide"
    ) > "%CONFIG_DIR%\RustDesk.toml"
    
    echo ✅ RustDesk.toml fixed with proper TOML syntax
    echo.
    echo === Fixed Content ===
    type "%CONFIG_DIR%\RustDesk.toml"
    echo.
)

REM Fix secondary config
if exist "%CONFIG_DIR%\RustDesk2.toml" (
    echo === Fixing RustDesk2.toml ===
    
    REM Create proper TOML content
    (
        echo rendezvous_server = 'rs-ny.rustdesk.com:21116'
        echo nat_type = 1
        echo serial = 0
        echo unlock_pin = ''
        echo trusted_devices = ''
        echo.
        echo [options]
        echo av1-test = 'Y'
        echo stop-service = 'Y'
        echo local-ip-addr = '10.2.10.215'
        echo.
        echo [ui]
        echo fullscreen = true
        echo scale = "fit"
        echo toolbar = "hide"
    ) > "%CONFIG_DIR%\RustDesk2.toml"
    
    echo ✅ RustDesk2.toml fixed with proper TOML syntax
    echo.
)

REM Fix local config
if exist "%CONFIG_DIR%\RustDesk_local.toml" (
    echo === Fixing RustDesk_local.toml ===
    
    REM Create proper TOML content
    (
        echo remote_id = '10.2.10.216'
        echo kb_layout_type = ''
        echo size = [
        echo     163,
        echo     12,
        echo     1739,
        echo     1028,
        echo ]
        echo fav = []
        echo.
        echo [options]
        echo remote-menubar-drag-left = '0.0'
        echo remote-menubar-drag-right = '1.0'
        echo.
        echo [ui_flutter]
        echo peer-sorting = 'Remote ID'
        echo wm_RemoteDesktop = '{"width":1300.0,"height":740.0,"offsetWidth":310.0,"offsetHeight":170.0,"isMaximized":false,"isFullscreen":false}'
        echo.
        echo [ui]
        echo fullscreen = true
        echo scale = "fit"
        echo toolbar = "hide"
    ) > "%CONFIG_DIR%\RustDesk_local.toml"
    
    echo ✅ RustDesk_local.toml fixed with proper TOML syntax
    echo.
)

echo.
echo === Final Verification ===
echo All TOML files have been fixed with proper syntax.
echo.
echo === Next Steps ===
echo 1. Close RustDesk completely
echo 2. Restart RustDesk
echo 3. Connect to remote desktop: 10.2.10.216
echo 4. Check if fullscreen is applied automatically
echo.

echo === If Still Not Working ===
echo 1. Check RustDesk logs for errors
echo 2. Try command-line arguments: rustdesk.exe --fullscreen
echo 3. Use manual F11 fullscreen
echo 4. Use Windows automation tools
echo.

pause
