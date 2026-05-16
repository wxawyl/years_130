# Change Log

## [Unreleased]

### v1.1.0 - 2026-05-16

#### 🌟 数字孪生健康仪表盘

##### 核心功能
- **动态数字孪生形象**：可视化健康状态，熬夜脸色变差，运动肌肉线条变清晰
- **实时状态映射**：
  - 睡眠状态 → 眼神明亮度、黑眼圈
  - 运动状态 → 肌肉线条、体态
  - 饮食状态 → 皮肤光泽
  - 情绪状态 → 表情变化
- **呼吸动画**：自然的呼吸效果
- **特效系统**：光晕、星星闪烁等视觉效果

##### 技术实现
- 使用 CustomPaint 实现高性能渲染（60fps）
- 与 MoodTheme 系统无缝集成
- 平滑的状态过渡动画

##### 新增文件
- `lib/models/twin_visual_params.dart` - 数字孪生参数模型
- `lib/widgets/digital_twin_widget.dart` - 数字孪生主组件
- `lib/widgets/twin_face_widget.dart` - 面部渲染组件
- `lib/widgets/twin_body_widget.dart` - 身体渲染组件
- `lib/widgets/twin_effects_widget.dart` - 特效组件

#### 🎨 情绪主题系统

##### 功能特性
- 5种情绪主题（极佳、良好、一般、需要关注、疲惫）
- 动态渐变背景
- 与健康数据联动的主题切换
- 本地化存储主题偏好

##### 新增文件
- `lib/theme/mood_colors.dart` - 情绪色彩系统
- `lib/widgets/dynamic_background.dart` - 动态背景组件
- `lib/widgets/mood_indicator.dart` - 情绪指示器
- `lib/providers/theme_provider.dart` - 主题状态管理
- `lib/screens/theme_demo_screen.dart` - 主题演示页面

#### 🔍 RAG健康知识库

##### 功能特性
- 向量检索系统
- 健康知识智能问答
- 营养信息查询

##### 新增文件
- `lib/services/vector_service.dart` - 向量服务
- `lib/models/health_vector.dart` - 健康向量模型
- `lib/models/rag_search_result.dart` - RAG搜索结果
- `lib/screens/knowledge_base_screen.dart` - 知识库页面

#### ⚠️ 主动式关怀系统

##### 功能特性
- 异常检测服务
- 智能提醒系统
- 个性化健康建议

##### 新增文件
- `lib/services/anomaly_detection_service.dart` - 异常检测服务
- `lib/services/smart_reminder_service.dart` - 智能提醒服务
- `lib/models/health_anomaly.dart` - 健康异常模型
- `lib/models/smart_reminder.dart` - 智能提醒模型
- `lib/screens/proactive_interaction_screen.dart` - 主动关怀页面

#### 🤖 AI服务增强

##### 功能特性
- 多AI提供商支持（OpenAI、Claude、豆包、本地）
- 模型路由服务
- 本地模型服务

##### 新增文件
- `lib/services/model_router_service.dart` - 模型路由服务
- `lib/services/local_model_service.dart` - 本地模型服务
- `lib/services/providers/` - AI提供商实现
- `lib/screens/model_settings_screen.dart` - AI模型设置页面

#### 🔒 隐私与安全

##### 功能特性
- 加密服务（AES-256）
- 本地食物识别
- 营养数据库

##### 新增文件
- `lib/services/encryption_service.dart` - 加密服务
- `lib/services/local_food_recognition_service.dart` - 本地食物识别
- `lib/services/nutrition_database_service.dart` - 营养数据库

#### 📄 文档更新

##### 新增文档
- `docs/健康仪表盘需求分析.md` - 数字孪生需求分析
- `docs/健康仪表盘需求影响分析.md` - 技术影响评估
- `docs/数字孪生集成方案.md` - 集成方案
- `docs/数字孪生设计方案.md` - 详细设计

---

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
