# RustDesk 插件构建工作流说明

## 工作流文件概览

本项目包含两个GitHub Actions工作流文件，用于构建支持插件功能的Windows客户端：

### 1. `build-windows-plugin.yml` - 完整版工作流
- **功能**: 完整的Flutter + RustDesk构建流程
- **特点**: 包含桥接代码生成、Flutter构建、驱动集成等
- **适用场景**: 需要完整Flutter界面的构建

### 2. `build-windows-plugin-simple.yml` - 简化版工作流 ⭐ 推荐
- **功能**: 专注于RustDesk核心功能和插件支持
- **特点**: 更简单、更可靠、构建速度更快
- **适用场景**: 主要需要插件功能，不需要完整Flutter界面

## 推荐使用简化版工作流

### 为什么推荐简化版？

1. **更可靠**: 减少了复杂的Flutter构建步骤，降低失败率
2. **更快速**: 专注于核心功能，构建时间更短
3. **更简单**: 步骤清晰，易于调试和维护
4. **更稳定**: 避免了Flutter版本兼容性问题

### 简化版工作流功能

- ✅ 构建rd_ui_plugin插件
- ✅ 构建支持插件框架的RustDesk主程序
- ✅ 生成插件配置文件
- ✅ 打包和上传构建产物
- ✅ 支持Release和Debug构建模式

## 使用方法

### 手动触发构建

1. 在GitHub仓库页面点击 "Actions" 标签
2. 选择工作流：
   - **推荐**: "构建支持插件的Windows客户端 (简化版)"
   - **备选**: "构建支持插件的Windows客户端"
3. 点击 "Run workflow" 按钮
4. 配置构建参数：
   - **是否上传构建产物**: true/false
   - **构建类型**: release/debug
5. 点击 "Run workflow" 开始构建

### 自动触发

- 创建Pull Request时自动触发
- 推送到master分支时自动触发

## 构建流程对比

### 完整版工作流
```
1. 生成Flutter桥接代码 (Ubuntu)
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
   - 安装Flutter、Rust
   - 设置vcpkg依赖
   - 构建插件
   - 构建RustDesk主程序
   - 打包产物
```

## 输出产物

### 简化版工作流输出
```
output/
├── rustdesk.exe              # 主程序 (支持插件框架)
├── plugin_config.json        # 插件框架配置
├── build_info.txt            # 构建信息
└── plugins/                  # 插件目录
    ├── rd_ui_plugin.dll     # UI控制插件
    └── rd_ui_plugin_config.json  # 插件配置
```

## 故障排除

### 常见问题

1. **Flutter版本问题**
   - 简化版工作流使用标准Flutter版本，兼容性更好

2. **构建失败**
   - 检查插件目录结构是否正确
   - 确认Cargo.toml配置正确

3. **依赖问题**
   - 简化版工作流使用标准的vcpkg依赖管理

### 调试建议

- 查看GitHub Actions的详细构建日志
- 从简化版工作流开始测试
- 逐步添加复杂功能

## 迁移建议

如果你之前使用完整版工作流遇到问题：

1. **先尝试简化版**: 使用`build-windows-plugin-simple.yml`
2. **测试基本功能**: 确保插件构建和加载正常
3. **逐步添加功能**: 根据需要添加Flutter界面等复杂功能

## 注意事项

1. **构建时间**: 简化版通常需要5-15分钟，完整版需要15-30分钟
2. **资源消耗**: 简化版消耗更少的GitHub Actions资源
3. **功能范围**: 简化版专注于插件功能，不包含完整的Flutter界面
4. **兼容性**: 简化版兼容性更好，适合大多数使用场景

---

**推荐**: 优先使用简化版工作流 `build-windows-plugin-simple.yml`
**备选**: 需要完整Flutter界面时使用完整版工作流 `build-windows-plugin.yml`
