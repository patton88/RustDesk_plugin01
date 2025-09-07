@echo off
chcp 65001 >nul
echo ========================================
echo RustDesk 命令行参数测试脚本
echo ========================================
echo.

:: 设置可执行文件路径
set RUSTDESK_EXE=%~dp0..\flutter\build\windows\x64\runner\Release\rustdesk.exe

:: 检查可执行文件是否存在
if not exist "%RUSTDESK_EXE%" (
    echo 错误: 找不到RustDesk可执行文件
    echo 请先运行 build_windows.bat 进行编译
    pause
    exit /b 1
)

echo 测试1: 全屏模式 + 工具栏展开 + 适应窗口
echo 命令: %RUSTDESK_EXE% --fullscreen=true --collapse_toolbar=false --desktop_scaling=true
echo.
%RUSTDESK_EXE% --fullscreen=true --collapse_toolbar=false --desktop_scaling=true
echo.
echo 按任意键继续下一个测试...
pause >nul

echo.
echo 测试2: 窗口模式 + 工具栏隐藏 + 原始尺寸
echo 命令: %RUSTDESK_EXE% --fullscreen=false --collapse_toolbar=true --desktop_scaling=false
echo.
%RUSTDESK_EXE% --fullscreen=false --collapse_toolbar=true --desktop_scaling=false
echo.
echo 按任意键继续下一个测试...
pause >nul

echo.
echo 测试3: 混合参数测试
echo 命令: %RUSTDESK_EXE% --fullscreen=true --collapse_toolbar=true --desktop_scaling=false
echo.
%RUSTDESK_EXE% --fullscreen=true --collapse_toolbar=true --desktop_scaling=false
echo.
echo 按任意键继续下一个测试...
pause >nul

echo.
echo 测试4: 无参数启动（默认行为）
echo 命令: %RUSTDESK_EXE%
echo.
%RUSTDESK_EXE%
echo.
echo 按任意键查看调试日志...
pause >nul

echo.
echo ========================================
echo 测试完成！检查debug.txt文件查看调试信息
echo ========================================
if exist debug.txt (
    echo.
    echo 调试日志内容:
    echo ----------------------------------------
    type debug.txt
    echo ----------------------------------------
) else (
    echo 未找到debug.txt文件
)

echo.
cmd /k
:pause
