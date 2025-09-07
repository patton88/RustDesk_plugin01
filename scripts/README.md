# RustDesk 编译脚本

## 脚本列表

### 1. check_environment.bat
检查编译环境是否完整

### 2. build_windows.bat  
编译RustDesk Windows版本

### 3. test_args.bat
测试命令行参数功能

### 4. clean_build.bat
清理构建文件

## 使用步骤

1. 运行 `check_environment.bat` 检查环境
2. 运行 `build_windows.bat` 编译项目
3. 运行 `test_args.bat` 测试功能

## 新增命令行参数

- `--fullscreen=true/false`: 设置全屏/窗口模式
- `--collapse_toolbar=true/false`: 设置工具栏隐藏/展开
- `--desktop_scaling=true/false`: 设置桌面缩放模式