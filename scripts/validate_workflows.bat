@echo off
echo ========================================
echo RustDesk 工作流文件验证脚本
echo ========================================
echo.

echo [1/4] 检查工作流文件是否存在...
if exist ".github\workflows\build-windows-plugin.yml" (
    echo ✓ 完整版工作流文件存在
) else (
    echo ✗ 完整版工作流文件不存在
    set /a error_count+=1
)

if exist ".github\workflows\build-windows-plugin-simple.yml" (
    echo ✓ 简化版工作流文件存在
) else (
    echo ✗ 简化版工作流文件不存在
    set /a error_count+=1
)

echo.
echo [2/4] 检查工作流文件结构...
echo 检查完整版工作流...
findstr /c:"name:" ".github\workflows\build-windows-plugin.yml" >nul
if %errorlevel% equ 0 (
    echo ✓ 完整版工作流有正确的name字段
) else (
    echo ✗ 完整版工作流缺少name字段
    set /a error_count+=1
)

echo 检查简化版工作流...
findstr /c:"name:" ".github\workflows\build-windows-plugin-simple.yml" >nul
if %errorlevel% equ 0 (
    echo ✓ 简化版工作流有正确的name字段
) else (
    echo ✗ 简化版工作流缺少name字段
    set /a error_count+=1
)

echo.
echo [3/4] 检查关键配置...
echo 检查完整版工作流配置...
findstr /c:"workflow_dispatch" ".github\workflows\build-windows-plugin.yml" >nul
if %errorlevel% equ 0 (
    echo ✓ 完整版工作流支持手动触发
) else (
    echo ✗ 完整版工作流缺少手动触发配置
    set /a error_count+=1
)

echo 检查简化版工作流配置...
findstr /c:"workflow_dispatch" ".github\workflows\build-windows-plugin-simple.yml" >nul
if %errorlevel% equ 0 (
    echo ✓ 简化版工作流支持手动触发
) else (
    echo ✗ 简化版工作流缺少手动触发配置
    set /a error_count+=1
)

echo.
echo [4/4] 检查插件相关配置...
echo 检查插件构建步骤...
findstr /c:"构建插件" ".github\workflows\build-windows-plugin-simple.yml" >nul
if %errorlevel% equ 0 (
    echo ✓ 简化版工作流包含插件构建步骤
) else (
    echo ✗ 简化版工作流缺少插件构建步骤
    set /a error_count+=1
)

echo 检查插件配置文件生成...
findstr /c:"创建插件配置文件" ".github\workflows\build-windows-plugin-simple.yml" >nul
if %errorlevel% equ 0 (
    echo ✓ 简化版工作流包含插件配置文件生成
) else (
    echo ✗ 简化版工作流缺少插件配置文件生成
    set /a error_count+=1
)

echo.
echo ========================================
echo 验证结果摘要
echo ========================================
if defined error_count (
    echo ✗ 发现 %error_count% 个问题，请检查上述错误
) else (
    echo ✓ 所有检查通过！工作流文件配置正确
)

echo.
echo 工作流文件概览:
echo - 完整版: build-windows-plugin.yml (包含Flutter构建)
echo - 简化版: build-windows-plugin-simple.yml (推荐，专注插件)
echo.
echo 推荐使用简化版工作流，更简单可靠！
echo.
echo 下一步:
echo 1. 推送代码到GitHub
echo 2. 在Actions页面测试工作流
echo 3. 选择简化版工作流进行首次测试
