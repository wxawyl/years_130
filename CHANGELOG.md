# Change Log

## [Unreleased]

### v1.0.0 - 2024-05-16

#### 🏗️ 项目重构与优化

##### 📱 界面优化
- **首页重构**：移除四大维度菜单，简化健康评分卡片
- **睡眠管理**：移除手动记录功能，优化HealthKit同步按钮样式
- **运动管理**：重构运动类型选择，添加羽毛球、舞蹈等类型
- **健康同步**：统一HealthKit按钮样式，移至标题栏

##### 🤖 AI功能集成
- **AI洞察发现**：基于历史数据分析健康模式
- **今日日程**：AI智能推荐健康提醒
- **数据聚合**：统一健康数据接口
- **AI配置**：支持OpenAI等多平台集成

##### 📊 数据管理优化
- **用户信息**：新增用户个人信息管理
- **语音日记**：新增语音记录与情感分析
- **饮食管理**：照片识别为唯一入口
- **运动计算**：基于个人信息的精确卡路里计算

##### 🗂️ 文件结构调整
**新增文件：**
- `lib/config/ai_config.dart` - AI配置
- `lib/models/ai_insight.dart` - AI洞察模型
- `lib/models/daily_schedule.dart` - 日程模型
- `lib/models/user_profile.dart` - 用户信息模型
- `lib/models/voice_diary_record.dart` - 语音日记模型
- `lib/screens/user_profile_screen.dart` - 用户信息页面
- `lib/services/ai_integration_service.dart` - AI集成服务
- `lib/services/calorie_calculator_service.dart` - 卡路里计算
- `lib/services/daily_schedule_service.dart` - 日程服务
- `lib/services/daily_suggestion_service.dart` - 建议服务
- `lib/services/diet_suggestion_service.dart` - 饮食建议
- `lib/services/health_data_aggregator.dart` - 数据聚合
- `lib/services/health_service.dart` - 健康服务
- `lib/services/insight_discovery_service.dart` - 洞察服务
- `lib/services/sentiment_analysis_service.dart` - 情感分析
- `lib/services/sleep_suggestion_service.dart` - 睡眠建议
- `lib/services/speech_recognition_service.dart` - 语音识别
- `lib/widgets/daily_knowledge_card.dart` - 知识卡片
- `ios/Runner/Runner.entitlements` - iOS权限配置

**删除文件：**
- `lib/models/mood_record.dart` - 旧心情记录模型
- `lib/screens/analysis_screen.dart` - 分析页面
- `lib/screens/music_selection_screen.dart` - 音乐选择页面

**修改文件：**
- `pubspec.yaml` - 添加health等依赖
- `ios/Runner/Info.plist` - 更新权限配置
- `lib/screens/home_screen.dart` - 首页重构
- `lib/screens/sleep_screen.dart` - 睡眠管理重构
- `lib/screens/mood_screen.dart` - 心情管理重构
- `lib/screens/diet_screen.dart` - 饮食管理重构
- `lib/screens/exercise_screen.dart` - 运动管理重构
- `lib/services/database_service.dart` - 数据库服务
- `lib/l10n/` - 本地化文件更新

#### ⚙️ iOS配置
- 添加HealthKit权限配置
- 更新Info.plist
- 添加Runner.entitlements

#### 📝 文档
- 更新 `IOS_DEPLOYMENT_GUIDE.md`
- 新增本CHANGELOG.md

---

## [v0.9.0] - 2024-05-15
- 完善多端音乐播放
- 食物识别功能优化
- 演示数据增强

---

## [v0.8.0] - 2024-05-14
- iOS权限配置优化
- 音频服务升级
- 跨端功能对齐

---

## [v0.7.0] - 2024-05-13
- iOS构建修复
- 依赖升级（Flutter 3.29.0）
