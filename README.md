# 个性分类聊天机器人 iOS 应用
# Personality Classification Chatbot iOS App

一个欢迎聊天机器人，可以分类用户个性并提供个性化互动的 iOS 应用。专为中国用户设计。

A welcome chatbot iOS application that can classify user personalities and provide personalized interactions. Designed specifically for Chinese users.

## 功能特点 Features

- 🎉 互动欢迎体验，支持语音功能测试
- 🧠 通过对话进行个性分类
- 💬 基于个性类型的个性化回应
- 📱 原生 iOS 应用界面
- 🇨🇳 完整中文界面设计
- 🎤 中文语音识别输入
- 🔊 智能语音合成朗读
- 🎨 专为中国用户设计的交互体验

## 开发环境要求 Requirements

- Xcode 14.0+
- iOS 15.0+
- Swift 5.7+
- macOS 12.0+

## 开始使用 Getting Started

1. 克隆项目 Clone the project:
   ```bash
   git clone [repository-url]
   cd personality-chatbot
   ```

2. 打开 Xcode 项目 Open in Xcode:
   ```bash
   open PersonalityChatbot.xcodeproj
   ```

3. 选择目标设备并运行 Select target device and run

## 项目结构 Project Structure

```
personality-chatbot/
├── PersonalityChatbot/
│   ├── App/
│   │   ├── PersonalityChatbotApp.swift    # 应用入口点
│   │   └── ContentView.swift              # 主视图
│   ├── Views/
│   │   ├── WelcomeView.swift              # 欢迎界面
│   │   ├── ChatView.swift                 # 聊天界面
│   │   └── ResultView.swift               # 结果展示界面
│   ├── Models/
│   │   ├── PersonalityType.swift          # 个性类型模型
│   │   ├── ChatMessage.swift              # 聊天消息模型
│   │   └── PersonalityAnalyzer.swift      # 个性分析器
│   ├── Resources/
│   │   ├── Localizable.strings (Chinese)  # 中文本地化
│   │   ├── Localizable.strings (English)  # 英文本地化
│   │   └── Assets.xcassets               # 应用资源
│   └── Data/
│       └── personality_questions.json    # 个性问题数据
├── PersonalityChatbotTests/
├── PersonalityChatbot.xcodeproj
└── README.md
```

## 个性类型系统 Personality Types

应用支持多种个性分类系统，包括：
- MBTI 16型人格
- 大五人格模型
- 适合中国文化的个性分类

The app supports multiple personality classification systems including MBTI, Big Five, and culturally adapted types for Chinese users.
