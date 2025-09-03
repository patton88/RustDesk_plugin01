@echo off
echo ========================================
echo RustDesk Configuration Modifier
echo ========================================

echo.
echo === Alternative to Plugin Approach ===
echo Since RustDesk doesn't support our plugin format,
echo we'll try to modify configuration files directly.
echo.

set "CONFIG_DIR=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\config"
set "PORTABLE_CONFIG_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\config"

echo === Configuration Locations ===
echo System Config: %CONFIG_DIR%
echo Portable Config: %PORTABLE_CONFIG_DIR%
echo.

REM Check system config
if exist "%CONFIG_DIR%" (
    echo ✅ System config directory exists
    echo Contents:
    dir "%CONFIG_DIR%"
    echo.
    
    REM Look for config files
    if exist "%CONFIG_DIR%\config.json" (
        echo ✅ Found system config.json
        echo Current content:
        type "%CONFIG_DIR%\config.json"
        echo.
        
        echo === Modifying System Config ===
        echo Adding fullscreen and UI settings...
        
        REM Create backup
        copy "%CONFIG_DIR%\config.json" "%CONFIG_DIR%\config.json.backup" >nul
        
        REM Try to modify config
        echo Attempting to modify system config...
        powershell -Command "try { $config = Get-Content '%CONFIG_DIR%\config.json' | ConvertFrom-Json; if (-not $config.PSObject.Properties.Name -contains 'ui') { $config | Add-Member -Type NoteProperty -Name 'ui' -Value @{} }; $config.ui.fullscreen = $true; $config.ui.scale = 'fit'; $config.ui.toolbar = 'hide'; $config | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_DIR%\config.json'; Write-Host '✅ System config modified successfully' } catch { Write-Host '❌ Error modifying system config:' $_.Exception.Message }"
        
    ) else (
        echo ❌ System config.json not found
    )
) else (
    echo ❌ System config directory not found
)

echo.
echo === Portable Config Check ===
if exist "%PORTABLE_CONFIG_DIR%" (
    echo ✅ Portable config directory exists
    echo Contents:
    dir "%PORTABLE_CONFIG_DIR%"
    echo.
    
    if exist "%PORTABLE_CONFIG_DIR%\config.json" (
        echo ✅ Found portable config.json
        echo Current content:
        type "%PORTABLE_CONFIG_DIR%\config.json"
        echo.
        
        echo === Modifying Portable Config ===
        echo Adding fullscreen and UI settings...
        
        REM Create backup
        copy "%PORTABLE_CONFIG_DIR%\config.json" "%PORTABLE_CONFIG_DIR%\config.json.backup" >nul
        
        REM Try to modify config
        echo Attempting to modify portable config...
        powershell -Command "try { $config = Get-Content '%PORTABLE_CONFIG_DIR%\config.json' | ConvertFrom-Json; if (-not $config.PSObject.Properties.Name -contains 'ui') { $config | Add-Member -Type NoteProperty -Name 'ui' -Value @{} }; $config.ui.fullscreen = $true; $config.ui.scale = 'fit'; $config.ui.toolbar = 'hide'; $config | ConvertTo-Json -Depth 10 | Set-Content '%PORTABLE_CONFIG_DIR%\config.json'; Write-Host '✅ Portable config modified successfully' } catch { Write-Host '❌ Error modifying portable config:' $_.Exception.Message }"
        
    ) else (
        echo ❌ Portable config.json not found
    )
) else (
    echo ❌ Portable config directory not found
)

echo.
echo === Environment Variables ===
echo Setting environment variables for RustDesk...
echo.

REM Set environment variables
set RUSTDESK_FULLSCREEN=true
set RUSTDESK_SCALE=fit
set RUSTDESK_TOOLBAR=hide

echo Environment variables set:
echo RUSTDESK_FULLSCREEN=%RUSTDESK_FULLSCREEN%
echo RUSTDESK_SCALE=%RUSTDESK_SCALE%
echo RUSTDESK_TOOLBAR=%RUSTDESK_TOOLBAR%
echo.

echo === Test Instructions ===
echo 1. Restart RustDesk
echo 2. Connect to remote desktop: 10.2.10.216
echo 3. Check if fullscreen is applied automatically
echo.

echo === Alternative Methods ===
echo If config modification doesn't work:
echo 1. Use command-line arguments: rustdesk.exe --fullscreen
echo 2. Use registry modification
echo 3. Use UI automation tools
echo.

pause

