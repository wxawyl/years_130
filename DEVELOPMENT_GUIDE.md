# 开发指南

本指南帮助开发者快速了解项目结构和开发规范。

## 📂 项目架构

### 核心目录说明

```
lib/
├── config/                    # 配置文件目录
│   └── ai_config.dart        # AI服务配置（重要！）
├── models/                   # 数据模型（纯数据类）
├── screens/                  # 页面/UI层
├── services/                 # 业务逻辑服务层
├── widgets/                  # 可复用组件
├── l10n/                    # 国际化文件
└── main.dart                # 应用入口
```

### 各层级职责

- **Models**: 只包含数据结构，不包含业务逻辑
- **Services**: 处理所有业务逻辑、API调用、数据存储
- **Screens**: UI展示和用户交互，调用Services处理业务
- **Widgets**: 可复用的UI组件

## 🎯 开发规范

### 代码风格
- 遵循Flutter官方最佳实践
- 保持现有代码风格一致性
- 使用 `flutter analyze` 检查代码

### Git提交规范
- 提交信息清晰描述变更内容
- 尽量做到原子提交（一个提交一个功能）
- 重大变更请更新CHANGELOG.md

## 🤖 AI功能开发

### 配置AI服务
1. 编辑 `lib/config/ai_config.dart`
2. 设置 `enableAi = true`
3. 填入你的API Key和Base URL
4. 可选：调整模型参数

### 扩展AI功能
1. 在 `lib/services/` 中创建新的服务
2. 使用 `AiIntegrationService` 调用AI
3. 参考 `InsightDiscoveryService` 和 `DailyScheduleService` 的实现

## 🩺 HealthKit开发

### iOS权限配置
- Info.plist: 已配置权限描述
- Runner.entitlements: 已添加HealthKit支持
- Apple Developer Portal: 需在Identifier中启用HealthKit

### 数据同步流程
1. 检查权限 → 请求权限 → 获取数据 → 处理数据 → 保存本地
2. 参考 `HealthService` 的实现

## 📊 数据管理

### 数据库操作
所有数据库操作通过 `DatabaseService` 进行：
- 睡眠记录: `getSleepRecords()`, `insertSleepRecord()`
- 运动记录: `getExerciseRecords()`, `insertExerciseRecord()`
- 饮食记录: `getDietRecords()`, `insertDietRecord()`
- 用户信息: `getUserProfile()`, `saveUserProfile()`

### 数据模型扩展
在 `lib/models/` 中添加新模型，参考现有模型格式。

## 🌐 多语言支持

### 添加新语言
1. 在 `lib/l10n/` 中创建 `app_XX.arb` 文件
2. 运行 `flutter gen-l10n` 生成代码
3. 在应用中自动生效

### 更新现有翻译
直接编辑对应语言的 `.arb` 文件即可。

## 🚀 常见开发任务

### 添加新页面
1. 在 `lib/screens/` 创建新页面
2. 在 `lib/main.dart` 或对应导航位置添加路由
3. 参考现有页面的结构

### 添加新服务
1. 在 `lib/services/` 创建新服务类
2. 在对应页面中初始化和使用
3. 遵循单例模式（可选）

### 调试技巧
- 使用 `flutter run --debug` 调试应用
- 查看控制台日志输出
- 使用DevTools进行性能分析

## 📱 平台特定开发

### iOS特定
- HealthKit仅在iOS真机可用
- 需要在Apple Developer配置能力
- 参考 `IOS_DEPLOYMENT_GUIDE.md`

### Android特定
- 项目目前主要面向iOS开发
- 如需支持Android，需要适配Health Connect等服务

### Web平台
- HealthKit不可用，使用模拟数据
- 适合快速开发和UI测试

## 🐛 常见问题

### 依赖问题
```bash
flutter pub get
flutter clean
flutter pub get
```

### iOS构建问题
- 检查Xcode版本兼容性
- 确认签名配置正确
- 查看 `IOS_DEPLOYMENT_GUIDE.md`

### AI功能不工作
- 确认API Key配置正确
- 检查网络连接
- 查看控制台错误信息

## 📚 相关文档

- [README.md](README.md) - 项目概览
- [CHANGELOG.md](CHANGELOG.md) - 版本历史
- [IOS_DEPLOYMENT_GUIDE.md](IOS_DEPLOYMENT_GUIDE.md) - iOS部署
- [QUICK_START.md](QUICK_START.md) - 快速开始

---

**有问题？先看文档！** 📖
