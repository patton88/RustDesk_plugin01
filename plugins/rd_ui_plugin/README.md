# rd_ui_plugin - RustDesk UI控制器插件

这是一个RustDesk Windows客户端插件，用于在远程桌面连接后自动控制UI设置。

## 功能特性

- **全屏控制**: 自动设置远程桌面为全屏或窗口模式
- **视图样式**: 控制远程桌面的缩放模式（适应屏幕或原始尺寸）
- **工具栏**: 自动隐藏或显示工具栏

## 安装方法

### 1. 复制DLL文件
将编译生成的 `plugin_rd_ui_plugin.dll` 复制到：
```
C:\ProgramData\RustDesk\plugins\rd_ui_plugin\
```

### 2. 创建配置文件
在同一目录下创建 `config.json`：
```json
{
  "fullscreen": true,
  "scale": "fit",
  "toolbar": "hide"
}
```

## 配置选项

### 环境变量（优先级最高）
- `RD_UI_FULLSCREEN`: 设置为 `true` 或 `false`
- `RD_UI_VIEW_STYLE`: 设置为 `fit`（适应屏幕）或 `original`（原始尺寸）
- `RD_UI_TOOLBAR`: 设置为 `show` 或 `hide`

### 配置文件选项
- `fullscreen`: 布尔值，是否全屏
- `scale`: 字符串，视图样式（`fit` 或 `original`）
- `toolbar`: 字符串，工具栏状态（`show` 或 `hide`）

## 使用方法

1. 确保RustDesk已启用插件框架功能
2. 安装插件到指定目录
3. 使用命令行连接远程桌面：
   ```cmd
   rustdesk.exe --connect 192.168.1.100 --password "your_password"
   ```
4. 插件会在连接成功后自动应用配置的UI设置

## 构建方法

```cmd
cargo build -p rd_ui_plugin --release
```

生成的DLL文件位于 `target/release/plugin_rd_ui_plugin.dll`

## 注意事项

- 需要RustDesk支持插件框架
- 配置文件路径必须正确
- 环境变量优先级高于配置文件
- 插件仅在连接成功后生效
