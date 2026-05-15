# Live to 130 - 健康生活应用

一个帮助用户养成健康生活习惯的Flutter应用，通过AI智能分析和健康数据追踪，助您活到130岁！

## 📱 功能特性

### 🏃‍♂️ 运动管理
- 多种运动类型支持：走路、跑步、骑行、游泳、羽毛球、舞蹈等
- HealthKit自动同步运动数据
- 基于个人信息精确计算卡路里消耗
- 运动类型卡片设计，直观选择

### 😴 睡眠管理
- 自动从Apple Watch同步睡眠数据
- 睡眠质量分析与建议
- 入睡时间、起床时间记录
- 今日睡眠建议功能

### 🍎 饮食管理
- 拍照识别食物（唯一记录入口）
- 基于个人信息的饮食建议
- 今日饮食清单查看
- 计划接入OCR和视觉大模型识别成分

### 😊 心情管理
- 语音日记记录心情
- AI情感分析（焦虑水平、压力源）
- 基于心情的今日建议
- 日记详情查看

### 🤖 AI智能洞察
- **关联性发现**：通过长周期数据发现健康模式（如：咖啡因与深度睡眠关系）
- **今日日程**：AI智能推荐健康提醒（如：连续睡眠不足自动提醒）
- 支持配置AI服务提供商（OpenAI、阿里云等）

### 👤 用户信息
- 个人健康档案管理
- 身高、体重、年龄、性别等信息
- 健康目标设置

## 🏗️ 项目结构

```
lib/
├── config/                    # 配置文件
│   └── ai_config.dart        # AI服务配置
├── models/                   # 数据模型
│   ├── ai_insight.dart       # AI洞察模型
│   ├── daily_schedule.dart    # 今日日程
│   ├── user_profile.dart      # 用户信息
│   ├── voice_diary_record.dart # 语音日记
│   ├── sleep_record.dart     # 睡眠记录
│   ├── exercise_record.dart   # 运动记录
│   └── diet_record.dart      # 饮食记录
├── screens/                  # 页面
│   ├── home_screen.dart       # 首页
│   ├── sleep_screen.dart      # 睡眠管理
│   ├── exercise_screen.dart    # 运动管理
│   ├── diet_screen.dart       # 饮食管理
│   ├── mood_screen.dart       # 心情管理
│   └── user_profile_screen.dart # 用户信息
├── services/                 # 服务层
│   ├── ai_integration_service.dart # AI集成
│   ├── health_service.dart    # HealthKit服务
│   ├── calorie_calculator_service.dart # 卡路里计算
│   ├── insight_discovery_service.dart # 洞察发现
│   └── ...
├── widgets/                  # 组件
│   └── daily_knowledge_card.dart # 知识卡片
├── l10n/                    # 国际化
└── main.dart
```

## 🚀 快速开始

### 环境要求
- Flutter 3.29.0+
- Xcode 15.0+ (iOS开发)
- Android Studio (Android开发)

### 安装运行
```bash
# 克隆项目
git clone <repository-url>
cd 130_years

# 安装依赖
flutter pub get

# 运行应用
flutter run -d chrome  # Web端
flutter run -d ios     # iOS模拟器
flutter run -d android # Android模拟器
```

### iOS部署
详细的iOS部署说明请参考：
- [IOS_DEPLOYMENT_GUIDE.md](IOS_DEPLOYMENT_GUIDE.md)
- [QUICK_START.md](QUICK_START.md)

## 📋 重要配置

### AI服务配置
在 `lib/config/ai_config.dart` 中配置：
```dart
static const bool enableAi = false; // 启用AI功能
static const String? apiKey = "your-api-key";
static const String baseUrl = "https://api.openai.com/v1";
```

### HealthKit配置
iOS端已配置HealthKit权限：
- Info.plist已更新权限描述
- Runner.entitlements已添加HealthKit支持

## 📄 文档

- [CHANGELOG.md](CHANGELOG.md) - 版本变更记录
- [IOS_DEPLOYMENT_GUIDE.md](IOS_DEPLOYMENT_GUIDE.md) - iOS部署指南
- [QUICK_START.md](QUICK_START.md) - 快速开始指南
- [FOOD_RECOGNITION_SPEC.md](FOOD_RECOGNITION_SPEC.md) - 食物识别说明

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

This project is licensed under the MIT License.

---

**健康生活，从今天开始！** 💪
