# iOS HealthKit 部署指南

本指南说明如何将应用部署到 iOS 设备并配置 HealthKit 功能。

## 📋 已完成的配置

### 1. Info.plist 配置
已在 `ios/Runner/Info.plist` 中添加了 HealthKit 权限：
- `NSHealthShareUsageDescription` - 共享健康数据权限描述
- `NSHealthUpdateUsageDescription` - 更新健康数据权限描述

### 2. Entitlements 文件
创建了 `ios/Runner/Runner.entitlements` 文件，启用了：
- `com.apple.developer.healthkit` - HealthKit 功能
- `com.apple.developer.healthkit.access` - HealthKit 访问权限

### 3. Xcode 项目配置
在 `ios/Runner.xcodeproj/project.pbxproj` 的所有 build configuration 中：
- Debug: 添加了 `CODE_SIGN_ENTITLEMENTS` 配置
- Release: 添加了 `CODE_SIGN_ENTITLEMENTS` 配置
- Profile: 添加了 `CODE_SIGN_ENTITLEMENTS` 配置

## 🚀 部署到 iOS 设备的步骤

### 第一步：在 Apple Developer 中配置

1. 访问 [Apple Developer Portal](https://developer.apple.com/account/)
2. 登录您的 Apple ID
3. 进入 "Certificates, Identifiers & Profiles"
4. 在 "Identifiers" 中找到您的应用 bundle ID（com.example.liveTo130）
5. 编辑该 identifier，确保勾选了 "HealthKit" capability

### 第二步：连接 iOS 设备

1. 使用 USB 线连接您的 iPhone 到电脑
2. 在 iPhone 上 "设置" -> "通用" -> "设备管理" 中信任您的开发者证书
3. 在 Xcode 中打开项目：
   ```bash
   open ios/Runner.xcworkspace
   ```

### 第三步：部署到设备

#### 方法一：使用 Flutter CLI（推荐）

```bash
# 1. 确保 iOS 设备：
flutter devices

# 2. 运行到设备：
flutter run -d <device_id>
```

#### 方法二：使用 Xcode

1. 打开 `ios/Runner.xcworkspace`
2. 在顶部工具栏选择您的 iOS 设备
3. 点击 "Run" 按钮（或按 Cmd+R
4. 首次运行时会在设备上安装应用

### 第四步：授权 HealthKit 访问

应用首次运行时：
1. 进入睡眠或运动页面
2. 点击同步按钮
3. 系统会弹出 HealthKit 权限请求
4. 点击 "允许" 授权访问睡眠和运动数据

## 📱 功能说明

### 睡眠管理
- 自动从 Apple HealthKit 读取睡眠数据
- 显示入睡时间、起床时间、睡眠时长
- 根据睡眠质量自动评分
- 支持用户可编辑同步的数据
- 基于睡眠状态的智能建议

### 运动管理
- 自动从 Apple HealthKit 读取运动数据
- 同步步数、距离、卡路里消耗
- 支持手动记录作为备选
- 显示运动历史记录

## ⚠️ 注意事项

1. **HealthKit 仅限 iOS 设备可用
   - 在 Web 平台无法使用 HealthKit
   - 只能在真实的 iOS 设备或 iOS 模拟器上测试

2. **真机 vs 模拟器
   - 真机可以访问真实的健康数据
   - 模拟器只有模拟数据用于测试

3. **App Store 发布
   - 如果计划发布到 App Store：
     - 需要完整的权限说明
     - 隐私政策
     - 确保只在真正需要时才请求权限

4. **数据隐私
   - HealthKit 数据高度隐私敏感
   - 确保遵守 Apple 的隐私政策要求
   - 只在需要时才请求权限

## 🛠️ 故障排除

### 问题：HealthKit 权限未显示
- 检查 Apple Developer 中的 identifier 配置
- 确认 entitlements 文件被正确链接
- 重新构建项目：`flutter clean && flutter pub get && flutter run`

### 问题：无法读取数据
- 确认用户是否已授权
- 检查 HealthKit 中是否有数据
- 尝试重新授权：在 iPhone 设置中找到应用，检查权限设置

### 问题：应用无法安装到设备
- 确保设备信任开发者证书
- 检查 bundle ID 和签名
- 更新 provisioning profile
- 在 Xcode 中选择正确的 team

## 📚 相关资源

- [Apple HealthKit 文档](https://developer.apple.com/documentation/healthkit)
- [Flutter health 包文档](https://pub.dev/packages/health)
- [Flutter iOS 部署指南](https://docs.flutter.dev/deployment/ios)

## 🎉 下一步

1. 配置好 Apple Developer 账户后
2. 连接 iOS 设备
3. 运行 `flutter run`
4. 测试 HealthKit 同步功能！
