# RustDesk 插件构建工作流说明

## 工作流文件概览

本项目包含三个GitHub Actions工作流文件，用于构建支持插件功能的Windows客户端：

### 1. `build-windows-plugin.yml` - 完整版工作流
- **功能**: 完整的Flutter + RustDesk构建流程
- **特点**: 包含桥接代码生成、Flutter构建、驱动集成等
- **适用场景**: 需要完整Flutter界面的构建
- **状态**: ⚠️ 已知桥接代码生成问题

### 2. `build-windows-plugin-fixed.yml` - 修复版完整工作流 ⭐ **推荐完整版**
- **功能**: 修复了桥接代码生成问题的完整工作流
- **特点**: 增强的错误处理、依赖检查和自动修复
- **适用场景**: 需要完整Flutter界面的构建
- **状态**: ✅ 已修复桥接代码生成问题

### 3. `build-windows-plugin-simple.yml` - 简化版工作流 ⭐ **推荐插件版**
- **功能**: 专注于RustDesk核心功能和插件支持
- **特点**: 更简单、更可靠、构建速度更快
- **适用场景**: 主要需要插件功能，不需要完整Flutter界面
- **状态**: ✅ 稳定可靠

## 推荐使用策略

### 为什么推荐修复版和简化版？

1. **修复版完整工作流**: 解决了原始完整版的桥接代码生成问题
2. **简化版工作流**: 更可靠、更快速，专注于插件功能
3. **原始完整版**: 存在已知问题，建议使用修复版替代

### 选择建议

- **需要完整Flutter界面**: 使用 `build-windows-plugin-fixed.yml` (修复版)
- **主要需要插件功能**: 使用 `build-windows-plugin-simple.yml` (简化版)
- **避免使用**: `build-windows-plugin.yml` (原始版，有已知问题)

## 修复的问题

### 桥接代码生成问题
- **问题**: `flutter_rust_bridge_codegen` 依赖缺失
- **解决方案**: 自动检测和安装缺失依赖
- **增强功能**: 多步骤验证和错误处理

### 依赖管理改进
- **自动依赖检查**: 检测缺失的Flutter依赖
- **智能安装**: 自动添加必要的开发依赖
- **版本兼容性**: 处理依赖版本冲突

## 使用方法

### 手动触发构建

1. 在GitHub仓库页面点击 "Actions" 标签
2. 选择工作流：
    - **推荐完整版**: "构建支持插件的Windows客户端 (修复版)"
    - **推荐插件版**: "构建支持插件的Windows客户端 (简化版)"
    - **避免使用**: "构建支持插件的Windows客户端" (原始版)
3. 点击 "Run workflow" 按钮
4. 配置构建参数：
    - **是否上传构建产物**: true/false
    - **构建类型**: release/debug
    - **启用特性**: flutter,plugin_framework (仅完整版)
5. 点击 "Run workflow" 开始构建

### 自动触发

- 创建Pull Request时自动触发
- 推送到master分支时自动触发

## 构建流程对比

### 修复版完整工作流
```
1. 生成Flutter桥接代码 (Ubuntu) - 增强版
   - 自动依赖检查和安装
   - 多步骤验证
   - 错误处理和自动修复
2. 构建Windows客户端 (Windows)
   - 安装LLVM、Flutter、Rust
   - 设置vcpkg依赖
   - 构建插件
   - 构建RustDesk主程序
   - 集成驱动文件
   - 打包产物
```

### 简化版工作流
```
1. 构建Windows客户端 (Windows)
   - 安装Rust工具链
   - 构建插件
   - 生成配置文件
   - 打包产物
```

## 输出产物

### 修复版完整工作流输出
```
rustdesk/
├── rustdesk.exe              # 主程序 (支持插件框架)
├── plugin_config.json        # 插件框架配置
├── build_info.txt            # 构建信息
├── plugins/                  # 插件目录
│   ├── rd_ui_plugin.dll     # UI控制插件
│   └── rd_ui_plugin_config.json  # 插件配置
└── drivers/                  # 驱动文件
    └── RustDeskPrinterDriver/
```

### 简化版工作流输出
```
output/
├── plugin_config.json        # 插件框架配置
├── build_info.txt            # 构建信息
├── README.md                 # 使用说明
└── plugins/                  # 插件目录
    ├── rd_ui_plugin.dll     # UI控制插件
    └── rd_ui_plugin_config.json  # 插件配置
```

## 故障排除

### 常见问题

1. **桥接代码生成失败**
   - 使用修复版工作流，自动处理依赖问题
   - 检查Flutter版本兼容性

2. **构建失败**
   - 从简化版工作流开始测试
   - 检查插件目录结构是否正确

3. **依赖问题**
   - 修复版工作流自动处理依赖安装
   - 简化版工作流避免复杂依赖

### 调试建议

- 查看GitHub Actions的详细构建日志
- 从简化版工作流开始测试
- 逐步升级到修复版完整工作流

## 迁移建议

### 从原始版迁移

1. **立即停止使用**: `build-windows-plugin.yml`
2. **选择替代方案**:
   - 需要完整功能: 使用 `build-windows-plugin-fixed.yml`
   - 专注插件: 使用 `build-windows-plugin-simple.yml`

### 升级路径

1. **测试简化版**: 确保基本插件功能正常
2. **测试修复版**: 验证完整Flutter构建
3. **生产使用**: 根据需求选择合适的工作流

## 注意事项

1. **构建时间**: 
   - 简化版: 5-15分钟
   - 修复版: 15-30分钟
   - 原始版: 不推荐使用

2. **资源消耗**: 简化版消耗更少的GitHub Actions资源

3. **功能范围**: 
   - 简化版: 专注插件功能
   - 修复版: 完整Flutter界面 + 插件

4. **兼容性**: 修复版和简化版兼容性更好

---

**推荐使用**:
- **完整功能**: `build-windows-plugin-fixed.yml` (修复版)
- **插件功能**: `build-windows-plugin-simple.yml` (简化版)

**避免使用**: `build-windows-plugin.yml` (原始版，有已知问题)
