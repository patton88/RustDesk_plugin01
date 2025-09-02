@echo off
setlocal

REM 设置RUST_LOG为info以获取详细日志
set RUST_LOG=info

REM 可选：设置插件环境变量（根据需要取消注释并调整）
REM set RD_UI_FULLSCREEN=true
REM set RD_UI_VIEW_STYLE=fit
REM set RD_UI_TOOLBAR=hide

REM 检查RustDesk可执行文件，优先使用flutter构建的版本
set RUSTDESK_EXE=
if exist "flutter\build\windows\x64\runner\Release\rustdesk.exe" (
    set RUSTDESK_EXE="flutter\build\windows\x64\runner\Release\rustdesk.exe"
) else if exist "target\release\rustdesk.exe" (
    set RUSTDESK_EXE="target\release\rustdesk.exe"
) else if exist "rustdesk.exe" (
    set RUSTDESK_EXE="rustdesk.exe"
)

if "%RUSTDESK_EXE%"=="" (
    echo 错误：找不到rustdesk.exe。请先构建它。
    goto :eof
)

REM 从参数中提取IP和密码
set IP=%1
set PASSWORD=%2

if "%IP%"=="" (
    echo 用法：%~nx0 ^<IP地址^> ^<密码^>
    echo 示例：%~nx0 10.2.10.216 Abcd$1234
    goto :eof
)

echo 正在启动RustDesk，RUST_LOG=%RUST_LOG%，连接到%IP%...
start "" %RUSTDESK_EXE% --connect %IP% --password "%PASSWORD%"

echo.
echo 正在实时监控RustDesk日志（按Ctrl+C停止日志监控）...
powershell -Command "Get-Content -Path \"$env:APPDATA\RustDesk\logs\rustdesk.log\" -Wait"

endlocal
