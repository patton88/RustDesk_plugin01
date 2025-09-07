@echo off
chcp 65001 >nul
echo ========================================
echo RustDesk 清理构建文件脚本
echo ========================================
echo.

:: 进入项目根目录
cd /d "%~dp0.."

echo [1/4] 清理Flutter构建文件...
if exist "flutter\build" (
    rmdir /s /q "flutter\build"
    echo ✓ 已删除flutter\build目录
) else (
    echo - flutter\build目录不存在
)

if exist "flutter\.dart_tool" (
    rmdir /s /q "flutter\.dart_tool"
    echo ✓ 已删除flutter\.dart_tool目录
) else (
    echo - flutter\.dart_tool目录不存在
)
echo.

echo [2/4] 清理Rust构建文件...
if exist "target" (
    rmdir /s /q "target"
    echo ✓ 已删除target目录
) else (
    echo - target目录不存在
)
echo.

echo [3/4] 清理调试文件...
if exist "debug.txt" (
    del "debug.txt"
    echo ✓ 已删除debug.txt文件
) else (
    echo - debug.txt文件不存在
)

if exist "flutter\debug.txt" (
    del "flutter\debug.txt"
    echo ✓ 已删除flutter\debug.txt文件
) else (
    echo - flutter\debug.txt文件不存在
)
echo.

echo [4/4] 清理临时文件...
if exist "*.tmp" (
    del "*.tmp"
    echo ✓ 已删除临时文件
) else (
    echo - 无临时文件需要清理
)

if exist "flutter\*.tmp" (
    del "flutter\*.tmp"
    echo ✓ 已删除Flutter临时文件
) else (
    echo - 无Flutter临时文件需要清理
)
echo.

echo ========================================
echo 清理完成！
echo ========================================
echo.
echo 所有构建文件和临时文件已清理
echo 现在可以重新开始编译
echo.
pause
