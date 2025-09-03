@echo off
echo ========================================
echo RustDesk TOML Configuration Modifier
echo ========================================

echo.
echo === TOML Configuration Files ===
set "CONFIG_DIR=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\config"

echo System Config Directory: %CONFIG_DIR%
echo.

if exist "%CONFIG_DIR%" (
    echo ✅ Config directory exists
    echo.
    echo === Available Config Files ===
    dir "%CONFIG_DIR%\*.toml"
    echo.
    
    REM Check main config file
    if exist "%CONFIG_DIR%\RustDesk.toml" (
        echo ✅ Found main config: RustDesk.toml
        echo.
        echo === Current Content ===
        type "%CONFIG_DIR%\RustDesk.toml"
        echo.
        
        echo === Modifying Main Config ===
        echo Adding fullscreen and UI settings...
        
        REM Create backup
        copy "%CONFIG_DIR%\RustDesk.toml" "%CONFIG_DIR%\RustDesk.toml.backup" >nul
        echo ✅ Backup created: RustDesk.toml.backup
        
        REM Try to modify TOML config
        echo Attempting to modify TOML config...
        powershell -Command "try { $content = Get-Content '%CONFIG_DIR%\RustDesk.toml' -Raw; if ($content -match '\\[ui\\]') { $content = $content -replace '\\[ui\\]', '[ui]`nfullscreen = true`nscale = \"fit\"`ntoolbar = \"hide\"'; } else { $content += '`n`n[ui]`nfullscreen = true`nscale = \"fit\"`ntoolbar = \"hide\"'; } Set-Content '%CONFIG_DIR%\RustDesk.toml' $content; Write-Host '✅ Main config modified successfully' } catch { Write-Host '❌ Error modifying main config:' $_.Exception.Message }"
        
    ) else (
        echo ❌ Main config not found
    )
    
    echo.
    echo === Checking Other Config Files ===
    
    REM Check RustDesk2.toml
    if exist "%CONFIG_DIR%\RustDesk2.toml" (
        echo ✅ Found secondary config: RustDesk2.toml
        echo Current content:
        type "%CONFIG_DIR%\RustDesk2.toml"
        echo.
        
        echo === Modifying Secondary Config ===
        copy "%CONFIG_DIR%\RustDesk2.toml" "%CONFIG_DIR%\RustDesk2.toml.backup" >nul
        echo ✅ Backup created: RustDesk2.toml.backup
        
        powershell -Command "try { $content = Get-Content '%CONFIG_DIR%\RustDesk2.toml' -Raw; if ($content -match '\\[ui\\]') { $content = $content -replace '\\[ui\\]', '[ui]`nfullscreen = true`nscale = \"fit\"`ntoolbar = \"hide\"'; } else { $content += '`n`n[ui]`nfullscreen = true`nscale = \"fit\"`ntoolbar = \"hide\"'; } Set-Content '%CONFIG_DIR%\RustDesk2.toml' $content; Write-Host '✅ Secondary config modified successfully' } catch { Write-Host '❌ Error modifying secondary config:' $_.Exception.Message }"
    )
    
    REM Check RustDesk_local.toml
    if exist "%CONFIG_DIR%\RustDesk_local.toml" (
        echo ✅ Found local config: RustDesk_local.toml
        echo Current content:
        type "%CONFIG_DIR%\RustDesk_local.toml"
        echo.
        
        echo === Modifying Local Config ===
        copy "%CONFIG_DIR%\RustDesk_local.toml" "%CONFIG_DIR%\RustDesk_local.toml.backup" >nul
        echo ✅ Backup created: RustDesk_local.toml.backup
        
        powershell -Command "try { $content = Get-Content '%CONFIG_DIR%\RustDesk_local.toml' -Raw; if ($content -match '\\[ui\\]') { $content = $content -replace '\\[ui\\]', '[ui]`nfullscreen = true`nscale = \"fit\"`ntoolbar = \"hide\"'; } else { $content += '`n`n[ui]`nfullscreen = true`nscale = \"fit\"`ntoolbar = \"hide\"'; } Set-Content '%CONFIG_DIR%\RustDesk_local.toml' $content; Write-Host '✅ Local config modified successfully' } catch { Write-Host '❌ Error modifying local config:' $_.Exception.Message }"
    )
    
) else (
    echo ❌ Config directory not found
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

echo === Final Config Check ===
echo Modified config files:
if exist "%CONFIG_DIR%\RustDesk.toml" (
    echo.
    echo === Modified RustDesk.toml ===
    type "%CONFIG_DIR%\RustDesk.toml"
)

echo.
echo === Test Instructions ===
echo 1. Restart RustDesk completely
echo 2. Connect to remote desktop: 10.2.10.216
echo 3. Check if fullscreen is applied automatically
echo.

echo === If Still Not Working ===
echo 1. Check if TOML syntax is correct
echo 2. Try command-line arguments: rustdesk.exe --fullscreen
echo 3. Use registry modification
echo 4. Use UI automation tools
echo.

pause

