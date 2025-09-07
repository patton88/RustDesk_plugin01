@echo off
chcp 65001 >nul
echo ========================================
echo RustDesk Windows Flutter 编译脚本
echo ========================================
echo.

:: 设置环境变量
set RUST_LOG=info
set FLUTTER_ROOT=C:\flutter
set PATH=%FLUTTER_ROOT%\bin;%PATH%

:: 检查Flutter环境
echo [1/6] 检查Flutter环境...
flutter --version
if %errorlevel% neq 0 (
    echo 错误: Flutter未安装或未添加到PATH
    pause
    exit /b 1
)

:: 检查Rust环境
echo.
echo [2/6] 检查Rust环境...
cargo --version
if %errorlevel% neq 0 (
    echo 错误: Rust未安装或未添加到PATH
    pause
    exit /b 1
)

:: 进入Flutter目录
echo.
echo [3/6] 进入Flutter目录...
cd /d "%~dp0..\flutter"

:: 清理之前的构建
echo.
echo [4/6] 清理之前的构建...
flutter clean
if exist debug.txt del debug.txt

:: 获取依赖
echo.
echo [5/6] 获取Flutter依赖...
flutter pub get
if %errorlevel% neq 0 (
    echo 错误: Flutter依赖获取失败
    pause
    exit /b 1
)

:: 生成Flutter Rust Bridge代码
echo.
echo [6/6] 生成Flutter Rust Bridge代码...
cargo install flutter_rust_bridge_codegen --version 1.80.1 --features uuid
if %errorlevel% neq 0 (
    echo 错误: flutter_rust_bridge_codegen安装失败
    pause
    exit /b 1
)

%USERPROFILE%\.cargo\bin\flutter_rust_bridge_codegen --rust-input ..\src\flutter_ffi.rs --dart-output .\lib\generated_bridge.dart --c-output .\macos\Runner\bridge_generated.h
if %errorlevel% neq 0 (
    echo 错误: Flutter Rust Bridge代码生成失败
    pause
    exit /b 1
)

:: 编译Rust代码
echo.
echo [7/8] 编译Rust代码...
cd /d "%~dp0.."
cargo build --features flutter --release
if %errorlevel% neq 0 (
    echo 错误: Rust代码编译失败
    pause
    exit /b 1
)

:: 编译Flutter应用
echo.
echo [8/8] 编译Flutter Windows应用...
cd /d "%~dp0..\flutter"
flutter build windows --release
if %errorlevel% neq 0 (
    echo 错误: Flutter应用编译失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo 编译完成！
echo 输出目录: flutter\build\windows\x64\runner\Release\
echo ========================================
echo.
echo 测试命令行参数:
echo rustdesk.exe --fullscreen=true --collapse_toolbar=false --desktop_scaling=true
echo.
pause
