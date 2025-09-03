@echo off
echo ========================================
echo RustDesk System Plugin Deploy
echo ========================================

REM Set paths
set "SOURCE_DIR=%~dp0..\target\release"
set "SYSTEM_PLUGIN_DIR=C:\Users\%USERNAME%\AppData\Roaming\RustDesk\plugins\rd_ui_plugin"
set "PROGRAMDATA_PLUGIN_DIR=C:\ProgramData\RustDesk\plugins\rd_ui_plugin"

echo Source Directory: %SOURCE_DIR%
echo System Plugin Directory: %SYSTEM_PLUGIN_DIR%
echo ProgramData Plugin Directory: %PROGRAMDATA_PLUGIN_DIR%
echo.

REM Check source files
if not exist "%SOURCE_DIR%\plugin_rd_ui_plugin.dll" (
    echo ❌ Source DLL not found: %SOURCE_DIR%\plugin_rd_ui_plugin.dll
    echo Please compile the plugin first: cargo build --release --package rd_ui_plugin
    pause
    exit /b 1
)

echo ✅ Source DLL found
echo.

REM Create system plugin directory
if not exist "%SYSTEM_PLUGIN_DIR%" (
    echo Creating system plugin directory...
    mkdir "%SYSTEM_PLUGIN_DIR%"
)

REM Create ProgramData plugin directory
if not exist "%PROGRAMDATA_PLUGIN_DIR%" (
    echo Creating ProgramData plugin directory...
    mkdir "%PROGRAMDATA_PLUGIN_DIR%"
)

echo.
echo === Deploying to System Plugin Directory ===
copy "%SOURCE_DIR%\plugin_rd_ui_plugin.dll" "%SYSTEM_PLUGIN_DIR%\" /Y
if %ERRORLEVEL% EQU 0 (
    echo ✅ DLL copied to system directory
) else (
    echo ❌ Failed to copy DLL to system directory
)

echo.
echo === Deploying to ProgramData Plugin Directory ===
copy "%SOURCE_DIR%\plugin_rd_ui_plugin.dll" "%PROGRAMDATA_PLUGIN_DIR%\" /Y
if %ERRORLEVEL% EQU 0 (
    echo ✅ DLL copied to ProgramData directory
) else (
    echo ❌ Failed to copy DLL to ProgramData directory
)

echo.
echo === Creating Config Files ===

REM Create config.json in system directory
echo { > "%SYSTEM_PLUGIN_DIR%\config.json"
echo   "fullscreen": true, >> "%SYSTEM_PLUGIN_DIR%\config.json"
echo   "scale": "fit", >> "%SYSTEM_PLUGIN_DIR%\config.json"
echo   "toolbar": "hide" >> "%SYSTEM_PLUGIN_DIR%\config.json"
echo } >> "%SYSTEM_PLUGIN_DIR%\config.json"

REM Create config.json in ProgramData directory
echo { > "%PROGRAMDATA_PLUGIN_DIR%\config.json"
echo   "fullscreen": true, >> "%PROGRAMDATA_PLUGIN_DIR%\config.json"
echo   "scale": "fit", >> "%PROGRAMDATA_PLUGIN_DIR%\config.json"
echo   "toolbar": "hide" >> "%PROGRAMDATA_PLUGIN_DIR%\config.json"
echo } >> "%PROGRAMDATA_PLUGIN_DIR%\config.json"

echo ✅ Config files created
echo.

echo === Final Check ===
echo System Plugin Directory:
dir "%SYSTEM_PLUGIN_DIR%"
echo.
echo ProgramData Plugin Directory:
dir "%PROGRAMDATA_PLUGIN_DIR%"
echo.

echo ========================================
echo Plugin deployed to system locations!
echo ========================================
echo.
echo Now you can:
echo 1. Start RustDesk from Start Menu (installed version)
echo 2. Connect to remote desktop
echo 3. Plugin should auto-apply fullscreen settings
echo.
echo If it still doesn't work, check the system log:
echo %SYSTEM_PLUGIN_DIR%\..\..\log\
pause
