# iOS版本部署指南

## 概述
由于你在Windows环境下开发，且不想支付99美元的Apple开发者费用，我们将使用以下方案：

1. **使用云编译服务**生成iOS应用（.ipa文件）
2. **使用AltStore**免费签名并安装到iPhone

---

## 方案一：使用GitHub Actions + 云编译（推荐）

### 第一步：准备GitHub仓库

1. 在GitHub上创建一个新仓库
2. 将本地代码推送到GitHub

```bash
# 在项目目录执行
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/你的用户名/仓库名.git
git branch -M main
git push -u origin main
```

### 第二步：设置GitHub Actions工作流

在项目中创建 `.github/workflows/ios-build.yml` 文件（我稍后会帮你创建）

### 第三步：获取编译好的.ipa文件

GitHub Actions会自动编译并生成.ipa文件，你可以从Actions页面下载

---

## 方案二：使用MacInCloud或其他云Mac服务

如果GitHub Actions无法满足需求，可以使用付费的云Mac服务：
- MacInCloud
- MacStadium
- AWS EC2 Mac实例

---

## AltStore安装和使用指南

### 1. 安装AltServer（电脑端）

**Windows用户：**
1. 下载AltServer：https://altstore.io
2. 安装iTunes（必须）
3. 安装iCloud（必须）
4. 运行AltServer
5. 在系统托盘找到AltServer图标

**Mac用户：**
1. 下载AltServer：https://altstore.io
2. 安装并运行AltServer
3. 在菜单栏找到AltServer图标

### 2. 安装AltStore（手机端）

1. 用数据线将iPhone连接到电脑
2. 在电脑上的AltServer中选择你的iPhone
3. 输入Apple ID和密码（用于签名）
4. AltStore会自动安装到你的iPhone

### 3. 信任开发者

在iPhone上：
- 打开 设置 → 通用 → VPN与设备管理
- 找到你的Apple ID
- 点击 "信任"

### 4. 安装.ipa文件

1. 将编译好的.ipa文件传输到iPhone
2. 在AltStore中点击 "My Apps" 标签
3. 点击 "+" 按钮
4. 选择.ipa文件进行安装

---

## 重要提示

1. **免费签名有效期为7天**，7天后需要重新签名
2. AltStore会在同一WiFi下自动重新签名
3. 建议保持AltServer在电脑上运行

---

## 下一步

我现在帮你：
1. 创建GitHub Actions工作流文件
2. 初始化Git仓库
3. 准备推送到GitHub

准备好了吗？
