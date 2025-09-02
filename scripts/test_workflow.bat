@echo off
echo 测试GitHub Actions工作流配置...
echo.

echo 检查工作流文件是否存在...
if exist ".github\workflows\build-windows-plugin.yml" (
    echo ✓ 工作流文件存在
) else (
    echo ✗ 工作流文件不存在
    exit /b 1
)

echo.
echo 检查工作流文件语法...
cd .github\workflows
yamllint build-windows-plugin.yml >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ YAML语法正确
) else (
    echo ✗ YAML语法有错误
    exit /b 1
)
cd ..\..

echo.
echo 检查插件目录结构...
if exist "plugins\rd_ui_plugin\Cargo.toml" (
    echo ✓ 插件Cargo.toml存在
) else (
    echo ✗ 插件Cargo.toml不存在
)

if exist "plugins\rd_ui_plugin\src\lib.rs" (
    echo ✓ 插件源码存在
) else (
    echo ✗ 插件源码不存在
)

echo.
echo 检查工作流配置摘要:
echo - 工作流名称: 构建支持插件的Windows客户端
echo - 目标平台: x86_64-pc-windows-msvc
echo - 构建类型: release/debug
echo - 启用特性: flutter,plugin_framework
echo - 运行环境: Windows 2022 + Ubuntu 22.04
echo.
echo 工作流配置检查完成！
echo.
echo 使用方法:
echo 1. 推送代码到GitHub
echo 2. 在Actions页面手动触发工作流
echo 3. 选择构建参数并运行
echo 4. 等待构建完成并下载产物
