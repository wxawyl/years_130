# AI食物识别功能 - 技术实施方案

## 📋 文档信息

- **项目名称**：活到130岁 - AI食物拍照识别
- **功能描述**：通过拍照自动识别食物名称和卡路里，支持一键记录到每日饮食管理
- **技术选型**：百度AI菜品识别API + Flutter image_picker
- **预计工期**：3-4天
- **文档版本**：v1.0

---

## 🎯 功能需求概述

### 核心功能

1. **拍照自动识别**
   - 用户点击拍照按钮
   - 系统调用相机拍照
   - 调用百度AI识别菜品
   - 显示识别结果供用户确认

2. **智能营养数据获取**
   - 自动获取食物名称
   - 自动获取卡路里（每100g）
   - 自动获取置信度评分

3. **便捷记录流程**
   - 拍照 → 识别 → 确认份量 → 保存
   - 一键添加到今日饮食记录
   - 自动累加到每日热量统计

4. **识别失败处理**
   - AI无法识别时，提示用户手动输入
   - 保留快捷记录入口（已实现）

---

## 🏗️ 系统架构设计

### 技术架构图

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter UI Layer                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ DietScreen   │  │ CameraPage   │  │ ResultDialog │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
└─────────┼────────────────┼────────────────┼───────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────┐
│                   Service Layer                          │
│  ┌──────────────────┐  ┌──────────────────────────────┐│
│  │ ImagePickerService│  │ BaiduFoodRecognitionService ││
│  └──────────────────┘  └──────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
          │                │
          ▼                ▼
┌─────────────────────────────────────────────────────────┐
│                   Data Layer                             │
│  ┌──────────────────┐  ┌──────────────────────────────┐│
│  │ LocalImageStorage │  │    SQLite Database          ││
│  └──────────────────┘  └──────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
```

---

## 📁 文件结构变更

### 新增文件

```
lib/
├── services/
│   ├── baidu_food_recognition_service.dart    # 百度AI识别服务
│   └── image_storage_service.dart             # 本地图片存储服务
├── screens/
│   └── camera_recognition_screen.dart         # 拍照识别页面
├── widgets/
│   ├── food_recognition_button.dart           # 拍照识别按钮
│   ├── recognition_result_card.dart           # 识别结果卡片
│   └── multi_food_selector.dart               # 多食物选择器
└── models/
    └── food_recognition_result.dart           # 识别结果数据模型
```

### 修改文件

```
lib/
├── pubspec.yaml                               # 添加插件依赖
├── models/
│   └── diet_record.dart                       # 添加图片路径字段
├── screens/
│   └── diet_screen.dart                       # 集成拍照识别功能
└── services/
    └── database_service.dart                  # 添加图片存储方法
```

---

## 🔧 技术实现详情

### 1. 依赖配置

#### pubspec.yaml 新增依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.0.7           # 相机拍照
  http: ^1.2.0                   # HTTP请求
  path_provider: ^2.1.2          # 文件路径
  path: ^1.9.0                   # 路径处理
  permission_handler: ^11.3.0     # 权限处理
```

### 2. 百度API集成

#### 2.1 API信息

- **接口地址**：`https://aip.baidubce.com/rest/2.0/image-classify/v2/dish`
- **请求方式**：POST
- **免费额度**：500次/天
- **返回数据**：菜品名称、卡路里、置信度

#### 2.2 Access Token 获取

```dart
// 令牌有效期：30天
// 建议：本地缓存，过期前刷新

String getAccessToken() async {
  // API Key 和 Secret Key 需在百度AI平台申请
  const apiKey = 'YOUR_API_KEY';
  const secretKey = 'YOUR_SECRET_KEY';

  final response = await http.get(
    Uri.parse(
      'https://aip.baidubce.com/oauth/2.0/token?'
      'grant_type=client_credentials&'
      'client_id=$apiKey&'
      'client_secret=$secretKey'
    )
  );

  return json.decode(response.body)['access_token'];
}
```

#### 2.3 菜品识别调用

```dart
Future<FoodRecognitionResult> recognizeFood(String imagePath) async {
  // 1. 图片Base64编码
  final imageBytes = await File(imagePath).readAsBytes();
  final imageBase64 = base64Encode(imageBytes);

  // 2. 调用API
  final response = await http.post(
    Uri.parse(
      'https://aip.baidubce.com/rest/2.0/image-classify/v2/dish'
      '?access_token=$accessToken'
    ),
    body: {
      'image': imageBase64,
      'top_num': 5,  // 返回前5个识别结果
      'filter_threshold': '0.95',
    },
  );

  // 3. 解析结果
  return FoodRecognitionResult.fromJson(json.decode(response.body));
}
```

### 3. 数据模型

#### 3.1 识别结果模型

```dart
class FoodRecognitionResult {
  final String name;           // 菜品名称
  final double calorie;         // 每100g卡路里
  final double probability;     // 置信度 0-1
  final bool hasCalorie;        // 是否有卡路里数据

  factory FoodRecognitionResult.fromJson(Map<String, dynamic> json) {
    return FoodRecognitionResult(
      name: json['name'] ?? '',
      calorie: double.tryParse(json['calorie'] ?? '0') ?? 0,
      probability: double.tryParse(json['probability'] ?? '0') ?? 0,
      hasCalorie: json['has_calorie'] ?? false,
    );
  }
}
```

#### 3.2 饮食记录模型（修改）

```dart
class DietRecord {
  // ... 现有字段 ...

  // 新增字段
  String? foodImagePath;        // 食物照片路径
  double? recognitionConfidence; // AI识别置信度
}
```

### 4. 数据库变更

#### ALTER TABLE 语句

```sql
ALTER TABLE diet_records
ADD COLUMN food_image TEXT;

ALTER TABLE diet_records
ADD COLUMN recognition_confidence REAL;
```

---

## 📱 UI/UX 设计

### 4.1 页面流程

```
┌─────────────┐
│  拍照按钮   │ ──────点击────────┌─────────────────┐
└─────────────┘                   │  相机预览页面    │
                                  │  (CameraPage)   │
                                  │                 │
                                  │  [快门按钮]     │
                                  └────────┬────────┘
                                           │ 拍照完成
                                           ▼
                                  ┌─────────────────┐
                                  │  识别结果页面    │
                                  │  (ResultDialog) │
                                  │                 │
                                  │  • 食物图片预览 │
                                  │  • 识别结果列表  │
                                  │  • 选择份量     │
                                  │  • [保存]按钮  │
                                  └─────────────────┘
```

### 4.2 识别结果确认弹窗

```
┌────────────────────────────────────────┐
│         🔍 识别结果                    │
├────────────────────────────────────────┤
│  ┌──────────────────────────────────┐ │
│  │                                  │ │
│  │         [食物照片预览]            │ │
│  │                                  │ │
│  └──────────────────────────────────┘ │
│                                        │
│  识别到以下食物：                       │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │ 🥢 鱼香肉丝                      │ │
│  │    119 kcal/100g  (置信度 89%)   │ │
│  │    [选择]                         │ │
│  └──────────────────────────────────┘ │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │ 🥢 宫保鸡丁                      │ │
│  │    108 kcal/100g  (置信度 72%)   │ │
│  │    [选择]                         │ │
│  └──────────────────────────────────┘ │
│                                        │
│  [识别失败？手动输入]                   │
│                                        │
│  份量：[-] 1 [+] (默认1份 = 100g)     │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │           保存记录               │ │
│  └──────────────────────────────────┘ │
└────────────────────────────────────────┘
```

### 4.3 识别失败降级

```
┌────────────────────────────────────────┐
│         ⚠️ 无法识别                     │
├────────────────────────────────────────┤
│                                        │
│  抱歉，AI未能识别这张图片中的食物        │
│                                        │
│  您可以：                               │
│  ┌──────────────────────────────────┐ │
│  │  📷 重新拍照                      │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  ✏️ 手动输入食物信息              │ │
│  └──────────────────────────────────┘ │
│  ┌──────────────────────────────────┐ │
│  │  ⚡ 使用快捷记录                  │ │
│  └──────────────────────────────────┘ │
│                                        │
└────────────────────────────────────────┘
```

---

## 🔐 隐私与安全

### 1. 图片存储

- **存储位置**：应用私有目录
- **存储方式**：加密存储
- **不上传云端**：所有处理在本地完成

### 2. API调用

- **Access Token**：本地缓存，定期刷新
- **敏感信息**：存储在安全区域（Keychain/iOS Secure Enclave）

### 3. 用户隐私

- **明确告知**：首次使用提示相机权限用途
- **可选功能**：拍照识别为可选项，用户可拒绝

---

## ⚠️ 风险与缓解

| 风险 | 影响 | 缓解方案 | 优先级 |
|------|------|---------|--------|
| API额度用尽 | 功能不可用 | 提示用户明日再用 + 手动输入 | 低 |
| 网络问题 | 识别失败 | 本地缓存 + 重试机制 | 中 |
| 识别准确率 | 数据不准 | 用户可修改 + 置信度显示 | 中 |
| 隐私顾虑 | 用户流失 | 明确隐私政策 + 本地处理 | 低 |

---

## 🧪 测试计划

### 功能测试

| 测试项 | 测试内容 | 预期结果 |
|--------|---------|---------|
| 拍照功能 | 正常拍照、取消、重拍 | 正常响应 |
| API调用 | 正常网络、弱网、无网 | 正确处理 |
| 识别结果 | 正确识别、识别失败 | 正确显示 |
| 保存功能 | 新增记录、修改份量 | 正确保存 |
| 热量统计 | 累加计算、每日重置 | 正确显示 |

### 边界测试

- 图片超过4M
- 识别多种食物（最多5种）
- 连续快速拍照
- 长时间不使用后重新打开

---

## 📦 发布检查清单

### 上线前

- [ ] 百度API Key 已申请并配置
- [ ] 相机权限已配置（iOS Info.plist / Android Manifest）
- [ ] 数据库迁移已测试
- [ ] 图片存储路径已验证
- [ ] API日配额已确认（500次/天）

### iOS 特殊配置

```xml
<!-- Info.plist -->
<key>NSCameraUsageDescription</key>
<string>需要使用相机来拍照识别食物</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册选择食物照片</string>
```

### Android 特殊配置

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

---

## 🚀 后续迭代方向

### Phase 2 功能

1. **多物体识别**
   - 一张照片识别多种食物
   - 用户勾选实际吃过的食物
   - 分别计算热量

2. **历史记录增强**
   - 查看历史拍照记录
   - 照片墙展示
   - 重复记录快捷添加

3. **营养分析增强**
   - 周/月营养趋势图
   - 饮食建议推送
   - 异常饮食提醒

---

## 📚 参考资源

- [百度AI菜品识别API文档](https://ai.baidu.com/ai-doc/IMAGERECOGNIZE/Jk3h6xgnb)
- [Flutter image_picker插件](https://pub.dev/packages/image_picker)
- [百度Access Token获取](https://ai.baidu.com/ai-doc/REFERENCE/Ok3hclg3q)

---

## ✅ 确认清单

在开始开发前，请确认：

- [ ] 已注册百度AI开放平台账号
- [ ] 已创建图像识别应用并获取 API Key / Secret Key
- [ ] 已开通菜品识别API服务
- [ ] 已了解免费额度（500次/天）
- [ ] 用户已同意隐私政策（可选）

---

**文档状态**：待确认
**最后更新**：2026-05-07
**技术负责人**：[待定]
