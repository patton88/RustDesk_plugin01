Flutter的Windows版本RustDesk完全编译步骤-OK：

请按下面顺序执行（稳定可复现）：

双击运行 e:\QTcode\RustDesk_plugin01.bak\RustDesk编译05-连接成功后隐藏远程电脑弹出的窗口\setup_build_env_11-OK.bat
内容如下：
```bat
CALL "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

CD /d E:\QTcode\RustDesk_plugin01
rustc --version
cargo --version

cmd /k
```


1) 初始化 Flutter 依赖
```bat
cd flutter
flutter pub get
cd ..
```

若末尾报 desktop_drop 插件“Android 入口类”告警，可以手动删除缓存后重取：
```bat
rmdir /s /q %LOCALAPPDATA%\Pub\Cache\hosted
cd flutter
flutter pub get
cd ..
```
2) 设置两个核心插件、两个渲染插件为本地源码（RustDesk 分支）
- 下载 ZIP 并解压为以下目录名（直接包含 pubspec.yaml 和 windows/CMakeLists.txt）：
  - rustdesk_desktop_multi_window
    - ZIP: https://github.com/rustdesk-org/rustdesk_desktop_multi_window/archive/refs/heads/master.zip
    - 放到: 项目根目录/flutter/flutter_plugins/rustdesk_desktop_multi_window
  - window_manager（RustDesk fork）
    - ZIP: https://github.com/rustdesk-org/window_manager/archive/refs/heads/master.zip
    - 放到: 项目根目录/flutter/flutter_plugins/window_manager

- 下载地址（对应已验证的 commit）:
  - flutter_gpu_texture_renderer:
    - 直接 ZIP: `https://github.com/rustdesk-org/flutter_gpu_texture_renderer/archive/08a471bb8ceccdd50483c81cdfa8b81b07b14b87.zip`
    - 放到：项目根目录/flutter/flutter_plugins/flutter_gpu_texture_renderer
  - flutter_texture_rgba_renderer:
    - 直接 ZIP: `https://github.com/rustdesk-org/flutter_texture_rgba_renderer/archive/42797e0f03141dc2b585f76c64a13974508058b4.zip`
    - 放到：项目根目录/flutter/flutter_plugins/texture_rgba_renderer
	- 目录中需包含 `windows\CMakeLists.txt` 等平台实现文件

- 将 pubspec.yaml 中4处依赖改为本地 path：
```yaml
# 两个核心插件本地路径
dependencies:
  # 替换为本地路径（RustDesk 分支 API 与现有代码匹配）
  desktop_multi_window:
    path: ./flutter_plugins/rustdesk_desktop_multi_window
  window_manager:
    path: ./flutter_plugins/window_manager

# 两个渲染插件本地路径
texture_rgba_renderer:
  path: ./flutter_plugins/texture_rgba_renderer
flutter_gpu_texture_renderer:
  path: ./flutter_plugins/flutter_gpu_texture_renderer
```


3) 拉取并同步子模块
```bat
git submodule sync --recursive
git submodule update --init --recursive
```

4) 生成 FRB 桥接代码（Windows 头文件路径）
```bat
%USERPROFILE%\.cargo\bin\flutter_rust_bridge_codegen ^
  --rust-input src\flutter_ffi.rs ^
  --dart-output flutter\lib\generated_bridge.dart ^
  --c-output flutter\windows\runner\bridge_generated.h
```

5) 编译 Rust
```bat
cargo build --features flutter --release
```

6) 编译 Flutter（Windows）
```bat
cd flutter
flutter build windows --release
cd ..
```

====================================================
可选清理
- 版本/接口变更较多时，先清理再编译更稳：
```bat
cargo clean
cd flutter && flutter clean && cd ..
```

运行文件
- 生成后可直接运行：
`flutter\build\windows\x64\runner\Release\rustdesk.exe`

说明
- 如果 `flutter_rust_bridge_codegen` 不在 PATH：
```bat
cargo install flutter_rust_bridge_codegen
```
- 以上流程不会依赖任何新增命令行参数；服务端连接管理器窗口在创建时即隐藏，并会写入 `RustDesk_debug.log` 一条启动日志用于确认。
