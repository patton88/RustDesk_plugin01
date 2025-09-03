@echo off
echo ========================================
echo Complete DLL Export Function Check
echo ========================================

set "PLUGIN_DLL=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\rd_ui_plugin\plugin_rd_ui_plugin.dll"

echo Plugin DLL: %PLUGIN_DLL%
echo.

if not exist "%PLUGIN_DLL%" (
    echo ❌ Plugin DLL not found!
    pause
    exit /b 1
)

echo ✅ Plugin DLL exists
echo.

REM Check file size
echo === File Properties ===
dir "%PLUGIN_DLL%"
echo.

REM Check PE header
echo === PE Header Check ===
powershell -Command "try { $bytes = [System.IO.File]::ReadAllBytes('%PLUGIN_DLL%'); if ($bytes[0] -eq 0x4D -and $bytes[1] -eq 0x5A) { Write-Host '✅ Valid PE file (MZ header found)' } else { Write-Host '❌ Not a valid PE file' } } catch { Write-Host '❌ Error reading file:' $_.Exception.Message }"
echo.

REM Check DLL exports with dumpbin
echo === DLL Export Functions (Full Output) ===
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" (
    echo Using dumpbin to check exports...
    echo.
    echo Full dumpbin output:
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" /exports "%PLUGIN_DLL%"
    echo.
    
    echo === Required Functions Check ===
    echo Checking for required functions: init, desc, reset, clear, call
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" /exports "%PLUGIN_DLL%" | findstr /i "init\|desc\|reset\|clear\|call"
    
) else (
    echo ⚠️  dumpbin not found, using alternative method...
    echo.
    echo === Alternative Function Check ===
    echo Checking file content for function names...
    powershell -Command "try { $content = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes('%PLUGIN_DLL%')); Write-Host 'File size:' $content.Length 'bytes'; if ($content -match 'init') { Write-Host '✅ Found: init' } else { Write-Host '❌ Missing: init' }; if ($content -match 'desc') { Write-Host '✅ Found: desc' } else { Write-Host '❌ Missing: desc' }; if ($content -match 'call') { Write-Host '✅ Found: call' } else { Write-Host '❌ Missing: call' }; if ($content -match 'reset') { Write-Host '✅ Found: reset' } else { Write-Host '❌ Missing: reset' }; if ($content -match 'clear') { Write-Host '✅ Found: clear' } else { Write-Host '❌ Missing: clear' } } catch { Write-Host '❌ Error analyzing file:' $_.Exception.Message }"
)

echo.
echo === DLL Check Complete ===
pause
