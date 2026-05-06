# iOS部署快速开始指南

## 🎉 第一步已完成！
我们已经成功：
✅ 初始化了Git仓库
✅ 创建了GitHub Actions自动编译工作流
✅ 准备了iOS部署所需的所有配置文件

---

## 📋 接下来你需要做的

### 1️⃣ 创建GitHub仓库
1. 访问 https://github.com/new
2. 创建一个新的公开仓库（名称随意，比如 `live_to_130`）
3. **不要**勾选 "Initialize this repository with a README"

### 2️⃣ 推送代码到GitHub
在项目目录（`d:\AiCoding\130_years`）打开终端，执行：

```bash
git remote add origin https://github.com/你的用户名/你的仓库名.git
git branch -M main
git push -u origin main
```

### 3️⃣ 触发GitHub Actions编译
1. 打开你的GitHub仓库页面
2. 点击 "Actions" 标签
3. 你会看到 "iOS Build" 工作流正在运行
4. 等待编译完成（大约需要5-10分钟）

### 4️⃣ 下载.ipa文件
1. 在Actions页面，点击最新的工作流运行记录
2. 滚动到底部，找到 "Artifacts" 部分
3. 下载 `live_to_130_ios.zip`
4. 解压得到 `live_to_130.ipa`

### 5️⃣ 安装AltStore
**Windows用户：**
1. 下载AltServer：https://altstore.io
2. 安装iTunes（必须）：https://www.apple.com/itunes/download/
3. 安装iCloud（必须）：https://www.icloud.com/
4. 运行AltServer，它会在系统托盘
5. 用数据线连接iPhone到电脑
6. 在AltServer中选择你的iPhone，输入Apple ID

**iPhone上：**
1. 打开 设置 → 通用 → VPN与设备管理
2. 信任你的Apple ID
3. AltStore应该已经安装在手机上了

### 6️⃣ 安装APP到iPhone
1. 将 `live_to_130.ipa` 传输到iPhone（可以用AirDrop、微信文件助手等）
2. 打开AltStore
3. 点击 "My Apps" 标签
4. 点击右上角的 "+" 按钮
5. 选择 `live_to_130.ipa`
6. 等待安装完成！

---

## ⚠️ 重要提示

1. **免费签名有效期7天** - 7天后需要重新用AltStore签名
2. **保持AltServer运行** - 同一WiFi下AltStore会自动重新签名
3. **需要Apple ID** - 不需要付费开发者账号，普通Apple ID即可

---

## 🆘 遇到问题？

查看 `IOS_DEPLOYMENT_GUIDE.md` 获取更详细的说明！
