@echo off
setlocal enabledelayedexpansion

echo ========================================
echo RustDesk UI插件部署脚本
echo ========================================

REM 检查DLL文件是否存在
set DLL_SOURCE=target\release\plugin_rd_ui_plugin.dll
if not exist "%DLL_SOURCE%" (
    echo 错误：找不到插件DLL文件 %DLL_SOURCE%
    echo 请先运行：cargo build -p rd_ui_plugin --release
    pause
    exit /b 1
)

REM 设置目标目录
set PLUGIN_DIR=C:\ProgramData\RustDesk\plugins\rd_ui_plugin
set CONFIG_FILE=%PLUGIN_DIR%\config.json

echo 正在部署插件到：%PLUGIN_DIR%

REM 创建目标目录
if not exist "%PLUGIN_DIR%" (
    echo 创建目录：%PLUGIN_DIR%
    mkdir "%PLUGIN_DIR%"
)

REM 复制DLL文件
echo 复制插件DLL文件...
copy "%DLL_SOURCE%" "%PLUGIN_DIR%\" >nul
if errorlevel 1 (
    echo 错误：复制DLL文件失败
    pause
    exit /b 1
)

REM 检查配置文件是否存在
if not exist "%CONFIG_FILE%" (
    echo 创建默认配置文件...
    echo {> "%CONFIG_FILE%"
    echo   "fullscreen": true,>> "%CONFIG_FILE%"
    echo   "scale": "fit",>> "%CONFIG_FILE%"
    echo   "toolbar": "hide">> "%CONFIG_FILE%"
    echo }>> "%CONFIG_FILE%"
    echo 配置文件已创建：%CONFIG_FILE%
) else (
    echo 配置文件已存在：%CONFIG_FILE%
)

echo.
echo ========================================
echo 部署完成！
echo ========================================
echo.
echo 插件文件：%PLUGIN_DIR%\plugin_rd_ui_plugin.dll
echo 配置文件：%CONFIG_FILE%
echo.
echo 现在可以启动RustDesk并测试插件功能
echo 使用以下命令连接远程桌面：
echo   rustdesk.exe --connect ^<IP地址^> --password "密码"
echo.
pause
