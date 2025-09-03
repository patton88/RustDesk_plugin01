@echo off
echo ========================================
echo Create Correct Plugin Structure
echo ========================================

echo.
echo === Problem Analysis ===
echo RustDesk supports plugins, but our structure is wrong!
echo Need to create correct plugin directory structure.
echo.

set "SYSTEM_PLUGIN_DIR=%ProgramData%\RustDesk\plugins"
set "PLUGIN_ID=rd_ui_control"
set "PLUGIN_DIR=%SYSTEM_PLUGIN_DIR%\%PLUGIN_ID%"
set "SOURCE_PLUGIN=%~dp0..\target\release\plugin_rd_ui_control.dll"

echo === Plugin Directory Structure ===
echo System Plugin Dir: %SYSTEM_PLUGIN_DIR%
echo Plugin ID: %PLUGIN_ID%
echo Plugin Dir: %PLUGIN_DIR%
echo Source Plugin: %SOURCE_PLUGIN%
echo.

echo === Creating Plugin Directory ===
if not exist "%SYSTEM_PLUGIN_DIR%" (
    echo Creating system plugin directory...
    mkdir "%SYSTEM_PLUGIN_DIR%"
    if %ERRORLEVEL% EQU 0 (
        echo ✅ System plugin directory created
    ) else (
        echo ❌ Failed to create system plugin directory
        pause
        exit /b 1
    )
) else (
    echo ✅ System plugin directory exists
)

if not exist "%PLUGIN_DIR%" (
    echo Creating plugin subdirectory...
    mkdir "%PLUGIN_DIR%"
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Plugin subdirectory created
    ) else (
        echo ❌ Failed to create plugin subdirectory
        pause
        exit /b 1
    )
) else (
    echo ✅ Plugin subdirectory exists
)

echo.
echo === Copying Plugin Files ===
if exist "%SOURCE_PLUGIN%" (
    echo Copying plugin DLL...
    copy "%SOURCE_PLUGIN%" "%PLUGIN_DIR%\plugin_rd_ui_control.dll" >nul
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Plugin DLL copied
    ) else (
        echo ❌ Failed to copy plugin DLL
    )
) else (
    echo ❌ Source plugin not found: %SOURCE_PLUGIN%
    echo Please build the plugin first!
    pause
    exit /b 1
)

echo.
echo === Creating Plugin Config ===
echo Creating config.json...
(
    echo {
    echo   "fullscreen": true,
    echo   "scale": "fit",
    echo   "toolbar": "hide"
    echo }
) > "%PLUGIN_DIR%\config.json"

if %ERRORLEVEL% EQU 0 (
    echo ✅ Plugin config created
) else (
    echo ❌ Failed to create plugin config
)

echo.
echo === Creating Plugin Description ===
echo Creating plugin.json...
(
    echo {
    echo   "id": "rd_ui_control",
    echo   "name": "RustDesk UI Control Plugin",
    echo   "version": "1.0.0",
    echo   "description": "Automatically apply UI settings on connection",
    echo   "author": "User",
    echo   "platform": "windows"
    echo }
) > "%PLUGIN_DIR%\plugin.json"

if %ERRORLEVEL% EQU 0 (
    echo ✅ Plugin description created
) else (
    echo ❌ Failed to create plugin description
)

echo.
echo === Final Plugin Structure ===
echo Plugin directory: %PLUGIN_DIR%
echo.
echo Contents:
dir "%PLUGIN_DIR%"
echo.

echo === Verification ===
echo Plugin structure should now be:
echo %PLUGIN_DIR%\
echo ├── plugin_rd_ui_control.dll
echo ├── config.json
echo └── plugin.json
echo.

echo === Next Steps ===
echo 1. Restart RustDesk completely
echo 2. Check if plugin is loaded (look for plugin-related logs)
echo 3. Connect to remote desktop: 10.2.10.216
echo 4. Check if fullscreen is applied automatically
echo.

echo === Troubleshooting ===
echo If plugin still doesn't work:
echo 1. Check RustDesk logs for plugin loading errors
echo 2. Verify plugin directory permissions
echo 3. Check if plugin_framework feature is enabled
echo.

pause
