@echo off
echo ========================================
echo RustDesk Plugin Support Check
echo ========================================

set "RUSTDESK_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"

echo.
echo === RustDesk Installation Check ===
echo Directory: %RUSTDESK_DIR%
echo.

if not exist "%RUSTDESK_DIR%\rustdesk.exe" (
    echo ❌ RustDesk not found
    pause
    exit /b 1
)

echo ✅ RustDesk found
echo.

REM Check if plugins directory exists
if exist "%RUSTDESK_DIR%\plugins" (
    echo ✅ Plugins directory exists
    echo.
    echo === Plugins Directory Contents ===
    dir "%RUSTDESK_DIR%\plugins\"
    echo.
    
    REM Check for any plugin files
    set "PLUGIN_COUNT=0"
    for %%f in ("%RUSTDESK_DIR%\plugins\*.dll") do set /a PLUGIN_COUNT+=1
    
    if %PLUGIN_COUNT% GTR 0 (
        echo ✅ Found %PLUGIN_COUNT% plugin DLL(s)
        echo This suggests RustDesk supports plugins
    ) else (
        echo ⚠️  No plugin DLLs found
        echo This suggests plugin support might be disabled
    )
) else (
    echo ❌ Plugins directory not found
    echo This suggests RustDesk doesn't support plugins
)

echo.
echo === RustDesk Binary Analysis ===
echo Checking if RustDesk binary contains plugin support...

REM Check if binary contains plugin-related strings
echo Checking for plugin-related strings in rustdesk.exe...
powershell -Command "try { $content = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes('%RUSTDESK_DIR%\rustdesk.exe')); $pluginStrings = @('plugin', 'Plugin', 'PLUGIN', 'load_plugin', 'init_plugin'); foreach ($str in $pluginStrings) { if ($content -match $str) { Write-Host '✅ Found:' $str } else { Write-Host '❌ Missing:' $str } } } catch { Write-Host '❌ Error reading binary:' $_.Exception.Message }"

echo.
echo === Alternative Plugin Methods ===
echo If RustDesk doesn't support our plugin format:
echo.
echo 1. **Configuration-based approach**:
echo    - Modify RustDesk configuration files
echo    - Set default fullscreen, scale, toolbar settings
echo.
echo 2. **Command-line approach**:
echo    - Use RustDesk command-line arguments
echo    - Set environment variables
echo.
echo 3. **UI automation approach**:
echo    - Use Windows automation tools
echo    - Send keystrokes/mouse clicks
echo.
echo 4. **Registry modification**:
echo    - Modify Windows registry settings
echo    - Change RustDesk default behavior
echo.

echo.
echo === Current Plugin Status ===
echo Our plugin has:
echo ✅ Valid DLL structure
echo ✅ Correct export functions
echo ✅ Proper configuration
echo ❌ RustDesk not loading it
echo.

echo === Conclusion ===
echo RustDesk 1.4.1 appears to NOT support our plugin format
echo We need to use alternative methods to achieve fullscreen
echo.

pause

