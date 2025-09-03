@echo off
echo ========================================
echo RustDesk System Log Check
echo ========================================

set "SYSTEM_LOG_DIR=C:\Users\%USERNAME%\AppData\Roaming\RustDesk"
set "PROGRAMDATA_LOG_DIR=C:\ProgramData\RustDesk"

echo System Log Directory: %SYSTEM_LOG_DIR%
echo ProgramData Log Directory: %PROGRAMDATA_LOG_DIR%
echo.

REM Check if directories exist
if exist "%SYSTEM_LOG_DIR%" (
    echo ✅ System log directory exists
    echo.
    echo === System Log Contents ===
    dir "%SYSTEM_LOG_DIR%"
    echo.
    
    REM Check for log files
    if exist "%SYSTEM_LOG_DIR%\log" (
        echo === System Log Files ===
        dir "%SYSTEM_LOG_DIR%\log\"
        echo.
        
        REM Look for latest log file
        for /f "tokens=*" %%i in ('dir /b /o-d "%SYSTEM_LOG_DIR%\log\*.log" 2^>nul') do (
            echo === Latest System Log: %%i ===
            echo Searching for plugin-related entries...
            findstr /i "plugin" "%SYSTEM_LOG_DIR%\log\%%i" | findstr /v "clipboard"
            goto :found_log
        )
        echo No log files found in system directory
    ) else (
        echo No log subdirectory found
    )
) else (
    echo ❌ System log directory not found
)

:found_log
echo.
echo === ProgramData Log Check ===
if exist "%PROGRAMDATA_LOG_DIR%" (
    echo ✅ ProgramData log directory exists
    dir "%PROGRAMDATA_LOG_DIR%"
    
    if exist "%PROGRAMDATA_LOG_DIR%\log" (
        echo.
        echo === ProgramData Log Files ===
        dir "%PROGRAMDATA_LOG_DIR%\log\"
    )
) else (
    echo ❌ ProgramData log directory not found
)

echo.
echo === Plugin Directory Check ===
if exist "%SYSTEM_LOG_DIR%\plugins" (
    echo ✅ System plugins directory exists
    dir "%SYSTEM_LOG_DIR%\plugins\"
) else (
    echo ❌ System plugins directory not found
)

if exist "%PROGRAMDATA_LOG_DIR%\plugins" (
    echo ✅ ProgramData plugins directory exists
    dir "%PROGRAMDATA_LOG_DIR%\plugins\"
) else (
    echo ❌ ProgramData plugins directory not found
)

echo.
echo === Log Check Complete ===
echo.
echo If you see plugin-related entries, the plugin is being loaded
echo If no plugin entries found, the plugin is not being loaded
pause
