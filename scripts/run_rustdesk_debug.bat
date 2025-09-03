@echo off
chcp 65001 >nul
echo ========================================
echo RustDesk调试版启动脚本（带插件）
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

REM 显示插件文件信息
echo === 插件文件信息 ===
dir "%PLUGIN_DIR%"
echo.

REM 显示插件配置
echo === 插件配置内容 ===
type "%PLUGIN_DIR%\config.json"
echo.

REM 切换到RustDesk目录
cd /d "%RUSTDESK_DIR%"

echo 启动RustDesk（调试模式）...
echo 插件将自动加载并应用配置：
echo - 全屏模式: 启用
echo - 缩放模式: 适应窗口
echo - 工具栏: 隐藏
echo.

REM 设置环境变量启用插件调试
set RUST_LOG=info
set RUSTDESK_PLUGIN_DEBUG=1

echo 环境变量设置：
echo RUST_LOG=%RUST_LOG%
echo RUSTDESK_PLUGIN_DEBUG=%RUSTDESK_PLUGIN_DEBUG%
echo.

REM 启动RustDesk
start "" "rustdesk.exe"

echo RustDesk已启动！
echo 插件功能将在连接远程桌面时自动生效
echo 请查看日志文件以获取调试信息
echo.
echo 日志路径: %RUSTDESK_DIR%-log\RustDesk\log\rustdesk_rCURRENT.log
pause
