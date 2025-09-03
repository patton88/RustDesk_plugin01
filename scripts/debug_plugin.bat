@echo off
echo ========================================
echo RustDesk Plugin Debug
echo ========================================

set "PLUGIN_DLL=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\rd_ui_plugin\plugin_rd_ui_plugin.dll"

echo.
echo === Plugin File Analysis ===
echo Plugin DLL: %PLUGIN_DLL%

if exist "%PLUGIN_DLL%" (
    echo ✅ Plugin DLL exists
    
    echo.
    echo === File Properties ===
    dir "%PLUGIN_DLL%"
    
    echo.
    echo === PE Header Check ===
    powershell -Command "try { $bytes = [System.IO.File]::ReadAllBytes('%PLUGIN_DLL%'); if ($bytes[0] -eq 0x4D -and $bytes[1] -eq 0x5A) { Write-Host '✅ Valid PE file (MZ header found)' } else { Write-Host '❌ Not a valid PE file' } } catch { Write-Host '❌ Error reading file:' $_.Exception.Message }"
    
    echo.
    echo === DLL Export Functions ===
    echo Checking for required functions: init, desc, reset, clear, call
    
    REM Try to check with dumpbin if available
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" (
        echo Using dumpbin to check exports...
        "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" /exports "%PLUGIN_DLL%" | findstr /i "init\|desc\|reset\|clear\|call"
    ) else (
        echo ⚠️  dumpbin not found, using alternative method...
        echo Checking file content for function names...
        powershell -Command "try { $content = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes('%PLUGIN_DLL%')); if ($content -match 'init') { Write-Host '✅ Found: init' } else { Write-Host '❌ Missing: init' }; if ($content -match 'desc') { Write-Host '✅ Found: desc' } else { Write-Host '❌ Missing: desc' }; if ($content -match 'call') { Write-Host '✅ Found: call' } else { Write-Host '❌ Missing: call' } } catch { Write-Host '❌ Error analyzing file:' $_.Exception.Message }"
    )
    
) else (
    echo ❌ Plugin DLL not found!
)

echo.
echo === RustDesk Process Check ===
tasklist /FI "IMAGENAME eq rustdesk.exe" 2>NUL | find /I /N "rustdesk.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ RustDesk is running
    echo.
    echo === Process Details ===
    tasklist /FI "IMAGENAME eq rustdesk.exe" /V
) else (
    echo ❌ RustDesk is not running
)

echo.
echo === System Log Check ===
if exist "C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log" (
    echo ✅ System log exists
    echo.
    echo === Recent Log Entries ===
    echo Last 10 lines of current log:
    powershell -Command "Get-Content 'C:\Users\%USERNAME%\AppData\Roaming\RustDesk\log\rustdesk_rCURRENT.log' | Select-Object -Last 10"
) else (
    echo ❌ System log not found
)

echo.
echo === Plugin Directory Structure ===
echo System Plugin Directory:
dir "C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\" /s

echo.
echo ProgramData Plugin Directory:
dir "C:\ProgramData\RustDesk\plugins\" /s

echo.
echo === Debug Complete ===
echo.
echo If plugin functions are missing, the DLL may be corrupted
echo If plugin functions exist but plugin not loaded, check RustDesk version compatibility
pause
