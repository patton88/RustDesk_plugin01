@echo off
echo ========================================
echo Plugin Compatibility Check
echo ========================================

echo.
echo === RustDesk Version Check ===
set "RUSTDESK_EXE=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\rustdesk.exe"

if exist "%RUSTDESK_EXE%" (
    echo ✅ RustDesk executable found
    echo File size:
    dir "%RUSTDESK_EXE%"
    echo.
    
    echo === Version Information ===
    echo Expected: RustDesk 1.4.1
    echo File: rustdesk-1.4.1-x86-sciter.exe
    echo.
    
    REM Check if it's the expected version
    echo "%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter" | findstr "1.4.1" >nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Version matches: 1.4.1
    ) else (
        echo ⚠️  Version mismatch detected
    )
) else (
    echo ❌ RustDesk executable not found
    pause
    exit /b 1
)

echo.
echo === Plugin ABI Check ===
set "PLUGIN_DLL=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\plugins\rd_ui_plugin\plugin_rd_ui_plugin.dll"

echo Plugin DLL: %PLUGIN_DLL%
echo.

if exist "%PLUGIN_DLL%" (
    echo ✅ Plugin DLL exists
    
    REM Check DLL architecture
    echo === DLL Architecture ===
    powershell -Command "try { $bytes = [System.IO.File]::ReadAllBytes('%PLUGIN_DLL%'); $machine = [System.BitConverter]::ToUInt16($bytes, 0x3C); $peOffset = [System.BitConverter]::ToUInt32($bytes, $machine + 4); $machineType = [System.BitConverter]::ToUInt16($bytes, $peOffset + 4); if ($machineType -eq 0x14C) { Write-Host '✅ x86 (32-bit) DLL' } elseif ($machineType -eq 0x8664) { Write-Host '✅ x64 (64-bit) DLL' } else { Write-Host '⚠️  Unknown architecture:' $machineType } } catch { Write-Host '❌ Error reading DLL:' $_.Exception.Message }"
    
    echo.
    echo === Export Functions ===
    echo Required functions: init, desc, reset, clear, call
    
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" (
        echo Checking exports...
        "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" /exports "%PLUGIN_DLL%" | findstr /i "init\|desc\|reset\|clear\|call"
    ) else (
        echo ⚠️  dumpbin not available, using alternative check
        powershell -Command "try { $content = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes('%PLUGIN_DLL%')); $functions = @('init', 'desc', 'reset', 'clear', 'call'); foreach ($func in $functions) { if ($content -match $func) { Write-Host '✅ Found:' $func } else { Write-Host '❌ Missing:' $func } } } catch { Write-Host '❌ Error:' $_.Exception.Message }"
    )
) else (
    echo ❌ Plugin DLL not found
)

echo.
echo === RustDesk Plugin Support ===
echo Checking if RustDesk supports plugins...

REM Check if there are other plugins in the directory
set "PLUGIN_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\plugins"
if exist "%PLUGIN_DIR%" (
    echo ✅ Plugins directory exists
    echo.
    echo === Existing Plugins ===
    dir "%PLUGIN_DIR%"
    echo.
    
    REM Count plugin DLLs
    set "PLUGIN_COUNT=0"
    for %%f in ("%PLUGIN_DIR%\*.dll") do set /a PLUGIN_COUNT+=1
    
    if %PLUGIN_COUNT% GTR 0 (
        echo ✅ Found %PLUGIN_COUNT% plugin(s) in directory
        echo This suggests RustDesk supports plugins
    ) else (
        echo ⚠️  No plugins found in directory
        echo This might indicate plugin support is disabled
    )
) else (
    echo ❌ Plugins directory not found
    echo This suggests RustDesk doesn't support plugins
)

echo.
echo === Compatibility Analysis ===
echo.
echo === If Plugin Not Loading ===
echo 1. Check if RustDesk version supports plugins
echo 2. Verify plugin ABI matches RustDesk expectations
echo 3. Check if plugin loading is enabled
echo 4. Verify plugin directory structure
echo.

echo === If Plugin Loading But Not Working ===
echo 1. Check plugin initialization logs
echo 2. Verify event handling (on_conn_client)
echo 3. Check UI control message format
echo 4. Verify callback function implementation
echo.

echo === Next Steps ===
echo 1. Run deep debug script
echo 2. Check logs for plugin messages
echo 3. Verify plugin is actually loaded
echo 4. Test plugin functionality step by step
echo.

pause

