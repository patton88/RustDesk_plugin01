@echo off
echo ========================================
echo Check RustDesk Compilation Features
echo ========================================

echo.
echo === Problem Analysis ===
echo Portable RustDesk shows no plugin loading in logs.
echo This suggests plugin_framework feature is not enabled.
echo.

set "PORTABLE_DIR=%~dp0..\target\Soft\rustdesk-1.4.1-x86-sciter"

echo === RustDesk Binary Analysis ===
echo Directory: %PORTABLE_DIR%
echo.

if exist "%PORTABLE_DIR%\rustdesk.exe" (
    echo ✅ RustDesk found
    echo.
    echo === Binary Analysis ===
    echo Checking if binary contains plugin-related symbols...
    echo.
    
    echo === Method 1: String Search ===
    echo Searching for plugin-related strings in binary...
    powershell -Command "try { $content = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes('%PORTABLE_DIR%\rustdesk.exe')); $pluginStrings = @('plugin', 'Plugin', 'PLUGIN', 'load_plugin', 'init_plugin', 'plugin_framework'); foreach ($str in $pluginStrings) { if ($content -match $str) { Write-Host '✅ Found:' $str } else { Write-Host '❌ Missing:' $str } } } catch { Write-Host '❌ Error reading binary:' $_.Exception.Message }"
    
    echo.
    echo === Method 2: Function Symbol Search ===
    echo Searching for plugin function symbols...
    powershell -Command "try { $content = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes('%PORTABLE_DIR%\rustdesk.exe')); $funcStrings = @('load_plugins', 'handle_ui_event', 'on_conn_client'); foreach ($str in $funcStrings) { if ($content -match $str) { Write-Host '✅ Found function:' $str } else { Write-Host '❌ Missing function:' $str } } } catch { Write-Host '❌ Error reading binary:' $_.Exception.Message }"
    
    echo.
    echo === Method 3: Version Check ===
    echo Checking RustDesk version and build info...
    echo.
    echo Trying --version...
    "%PORTABLE_DIR%\rustdesk.exe" --version 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ --version supported
    ) else (
        echo ❌ --version not supported
    )
    
    echo.
    echo Trying --help...
    "%PORTABLE_DIR%\rustdesk.exe" --help 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ --help supported
    ) else (
        echo ❌ --help not supported
    )
    
) else (
    echo ❌ RustDesk not found
    pause
    exit /b 1
)

echo.
echo === Analysis Results ===
echo.
echo If plugin-related strings are missing:
echo ❌ Plugin system is NOT compiled into this binary
echo ❌ plugin_framework feature is NOT enabled
echo ❌ This portable version does NOT support plugins
echo.
echo If plugin-related strings are found:
echo ✅ Plugin system IS compiled into this binary
echo ✅ plugin_framework feature IS enabled
echo ✅ Plugin loading issue is elsewhere
echo.

echo === Solution Options ===
echo.
echo Option 1: **Use Different RustDesk Version**
echo - Download official RustDesk with plugin support
echo - Use installed version instead of portable
echo.
echo Option 2: **Compile RustDesk with Plugin Support**
echo - Enable plugin_framework feature
echo - Rebuild RustDesk from source
echo.
echo Option 3: **Use Alternative Methods**
echo - Windows automation (F11, SendKeys)
echo - Configuration file modification
echo - Registry modification
echo.

echo === Immediate Action ===
echo Based on the analysis:
echo 1. If no plugin strings found: Use alternative methods
echo 2. If plugin strings found: Debug plugin loading
echo 3. Consider using official RustDesk version
echo.

pause
