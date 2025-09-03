@echo off
echo ========================================
echo RustDesk Version Comparison
echo ========================================

echo.
echo === Critical Discovery ===
echo Install version supports fullscreen!
echo Portable version does NOT support fullscreen!
echo Need to investigate the differences.
echo.

set "INSTALL_DIR=C:\Program Files (x86)\RustDesk"
set "PORTABLE_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"

echo === Version Comparison ===
echo.

echo === Install Version ===
echo Directory: %INSTALL_DIR%
if exist "%INSTALL_DIR%\rustdesk.exe" (
    echo ✅ Install version found
    echo.
    echo === Install Version Details ===
    echo File size:
    dir "%INSTALL_DIR%\rustdesk.exe" | findstr "rustdesk.exe"
    echo.
    echo === Install Version Test ===
    echo Testing install version capabilities...
    echo.
    echo 1. Testing --version...
    "%INSTALL_DIR%\rustdesk.exe" --version 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Install version supports --version
    ) else (
        echo ❌ Install version --version failed
    )
    echo.
    echo 2. Testing --help...
    "%INSTALL_DIR%\rustdesk.exe" --help 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Install version supports --help
    ) else (
        echo ❌ Install version --help failed
    )
    echo.
    echo 3. Testing --fullscreen...
    echo Starting install version with --fullscreen...
    start "" "%INSTALL_DIR%\rustdesk.exe" --fullscreen
    echo ✅ Install version started with --fullscreen
    echo.
) else (
    echo ❌ Install version not found
    echo This suggests RustDesk is not installed
)

echo.
echo === Portable Version ===
echo Directory: %PORTABLE_DIR%
if exist "%PORTABLE_DIR%\rustdesk.exe" (
    echo ✅ Portable version found
    echo.
    echo === Portable Version Details ===
    echo File size:
    dir "%PORTABLE_DIR%\rustdesk.exe" | findstr "rustdesk.exe"
    echo.
    echo === Portable Version Test ===
    echo Testing portable version capabilities...
    echo.
    echo 1. Testing --version...
    "%PORTABLE_DIR%\rustdesk.exe" --version 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Portable version supports --version
    ) else (
        echo ❌ Portable version --version failed
    )
    echo.
    echo 2. Testing --help...
    "%PORTABLE_DIR%\rustdesk.exe" --help 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Portable version supports --help
    ) else (
        echo ❌ Portable version --help failed
    )
    echo.
    echo 3. Testing --fullscreen...
    echo Starting portable version with --fullscreen...
    start "" "%PORTABLE_DIR%\rustdesk.exe" --fullscreen
    echo ✅ Portable version started with --fullscreen
    echo.
) else (
    echo ❌ Portable version not found
)

echo.
echo === Key Differences ===
echo Based on the comparison:
echo.
echo 1. **Install Version**: Full RustDesk with full features
echo 2. **Portable Version**: Limited version with restricted features
echo.
echo === Possible Reasons ===
echo 1. **Different Builds**: Install vs Portable builds
echo 2. **Version Mismatch**: Different RustDesk versions
echo 3. **Feature Flags**: Different compilation options
echo 4. **Dependencies**: Missing libraries in portable version
echo.

echo === Solution Options ===
echo.
echo Option 1: **Use Install Version**
echo - Copy install version to portable location
echo - Use install version for fullscreen support
echo.
echo Option 2: **Update Portable Version**
echo - Download newer portable version
echo - Check if newer version supports fullscreen
echo.
echo Option 3: **Hybrid Approach**
echo - Use install version for fullscreen
echo - Use portable version for other features
echo.

echo === Immediate Action ===
echo Since install version works:
echo 1. Use install version for fullscreen connections
echo 2. Test fullscreen with install version
echo 3. Compare behavior between versions
echo.

pause
