@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo RustDesk Environment Check Script
echo ========================================
echo.

:: Check Operating System
echo [1/8] Checking Operating System...
echo OS: %OS%
echo Architecture: %PROCESSOR_ARCHITECTURE%
echo.

:: Check Rust Environment
echo [2/8] Checking Rust Environment...
where rustc >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Rust compiler installed
    rustc --version
    where cargo >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Cargo package manager installed
        cargo --version
    ) else (
        echo [ERROR] Cargo not found
    )
) else (
    echo [ERROR] Rust not installed or not in PATH
    echo Please visit https://rustup.rs/ to install Rust
)
echo.

:: Check Flutter Environment
echo [3/8] Checking Flutter Environment...
where flutter >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Flutter SDK installed
    flutter --version
    flutter doctor
) else (
    echo [ERROR] Flutter not installed or not in PATH
    echo Please visit https://flutter.dev/docs/get-started/install/windows to install Flutter
)
echo.

:: Check Git Environment
echo [4/8] Checking Git Environment...
where git >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Git version control installed
    git --version
) else (
    echo [ERROR] Git not installed
    echo Please visit https://git-scm.com/download/win to install Git
)
echo.

:: Check Visual Studio Build Tools
echo [5/8] Checking Visual Studio Build Tools...
where cl >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] MSVC compiler found
    cl 2>&1 | findstr "Microsoft"
    where link >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Linker found
    ) else (
        echo [ERROR] Linker not found
    )
) else (
    echo [ERROR] Visual Studio Build Tools not installed
    echo Please install Visual Studio Build Tools or Visual Studio Community
    echo Download: https://visualstudio.microsoft.com/zh-hans/downloads/
)
echo.

:: Check Project Files
echo [6/8] Checking Project Files...
if exist "%~dp0..\Cargo.toml" (
    echo [OK] Cargo.toml exists
) else (
    echo [ERROR] Cargo.toml not found
)

if exist "%~dp0..\flutter\pubspec.yaml" (
    echo [OK] pubspec.yaml exists
) else (
    echo [ERROR] pubspec.yaml not found
)

if exist "%~dp0..\src\main.rs" (
    echo [OK] main.rs exists
) else (
    echo [ERROR] main.rs not found
)

if exist "%~dp0..\src\flutter_ffi.rs" (
    echo [OK] flutter_ffi.rs exists
) else (
    echo [ERROR] flutter_ffi.rs not found
)

if exist "%~dp0..\flutter\lib\main.dart" (
    echo [OK] main.dart exists
) else (
    echo [ERROR] main.dart not found
)
echo.

:: Check Disk Space
echo [7/8] Checking Disk Space...
for /f "tokens=3" %%a in ('dir /-c %~dp0.. 2^>nul ^| find "可用字节"') do set freespace=%%a
if defined freespace (
    set /a freespace_gb=!freespace!/1024/1024/1024
    echo Available space: !freespace_gb! GB
    if !freespace_gb! geq 5 (
        echo [OK] Sufficient disk space (>=5GB)
    ) else (
        echo [WARNING] Low disk space, recommend at least 5GB
    )
) else (
    echo [WARNING] Cannot get disk space information
)
echo.

:: Check Network Connection
echo [8/8] Checking Network Connection...
ping -n 1 -w 3000 crates.io >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] crates.io connection (Rust package source)
) else (
    echo [ERROR] crates.io connection failed
)

ping -n 1 -w 3000 pub.dev >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] pub.dev connection (Flutter package source)
) else (
    echo [ERROR] pub.dev connection failed
)

ping -n 1 -w 3000 github.com >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] github.com connection (source code)
) else (
    echo [ERROR] github.com connection failed
)
echo.

:: Summary
echo ========================================
echo Environment Check Summary
echo ========================================
echo.
echo If all items show [OK], you can proceed with compilation
echo If any items show [ERROR], please fix them first
echo.
echo Next steps:
echo 1. Run: scripts\build_windows.bat
echo 2. Test: scripts\test_args.bat
echo.
echo ========================================
echo Check completed at: %date% %time%
echo ========================================
echo.
pause