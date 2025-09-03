@echo off
echo ========================================
echo DLL Export Function Check
echo ========================================

set "DLL_PATH=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter\plugins\rd_ui_plugin\plugin_rd_ui_plugin.dll"

echo Checking DLL: %DLL_PATH%
echo.

REM Check if DLL exists
if not exist "%DLL_PATH%" (
    echo ❌ DLL not found!
    pause
    exit /b 1
)

echo ✅ DLL exists
echo.

REM Try to check DLL with dumpbin
echo === Using dumpbin to check exports ===
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\dumpbin.exe" /exports "%DLL_PATH%" 2>nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ dumpbin failed, trying alternative method...
    echo.
    
    REM Alternative: check file size and basic info
    echo === Basic DLL Info ===
    dir "%DLL_PATH%"
    echo.
    
    REM Check if it's a valid PE file
    echo === Checking PE Header ===
    powershell -Command "try { $bytes = [System.IO.File]::ReadAllBytes('%DLL_PATH%'); if ($bytes[0] -eq 0x4D -and $bytes[1] -eq 0x5A) { Write-Host '✅ Valid PE file (MZ header found)' } else { Write-Host '❌ Not a valid PE file' } } catch { Write-Host '❌ Error reading file:' $_.Exception.Message }"
)

echo.
echo === DLL Check Complete ===
pause
