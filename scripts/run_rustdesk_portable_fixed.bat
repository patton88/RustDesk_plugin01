@echo off
chcp 65001 >nul
echo ========================================
echo RustDesk便携版启动脚本（带插件）
echo ========================================

REM 设置工作目录
set "RUSTDESK_DIR=%~dp0..\target\Soft\RustDesk-1.4.1-x86-sciter"
set "PLUGIN_DIR=%RUSTDESK_DIR%\plugins\rd_ui_plugin"

echo RustDesk目录: %RUSTDESK_DIR%
echo 插件目录: %PLUGIN_DIR%

REM 检查RustDesk可执行文件
if not exist "%RUSTDESK_DIR%\rustdesk.exe" (
    echo ❌ 错误：找不到rustdesk.exe
    echo 请先编译RustDesk项目
    pause
    exit /b 1
)

REM 检查插件文件
if not exist "%PLUGIN_DIR%\plugin_rd_ui_plugin.dll" (
    echo ❌ 错误：找不到插件文件
    echo 请先编译插件
    pause
    exit /b 1
)

if not exist "%PLUGIN_DIR%\config.json" (
    echo ❌ 错误：找不到插件配置文件
    pause
    exit /b 1
)

echo ✅ 所有文件检查通过
echo.

REM 切换到RustDesk目录
cd /d "%RUSTDESK_DIR%"

echo 启动RustDesk（便携版）...
echo 插件将自动加载并应用配置：
echo - 全屏模式: 启用
echo - 缩放模式: 适应窗口
echo - 工具栏: 隐藏
echo.

REM 启动RustDesk
start "" "rustdesk.exe"

echo RustDesk已启动！
echo 插件功能将在连接远程桌面时自动生效
pause
