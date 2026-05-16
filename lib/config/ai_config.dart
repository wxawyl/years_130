/// AI 配置类
/// 使用说明：
/// 1. 将 apiKey 设置为您的 OpenAI API Key 或其他AI服务的密钥
/// 2. 根据需要修改 baseUrl 和 model
/// 3. 配置后，重新运行应用即可生效
/// 
/// 注意：
/// - API Key请妥善保管，不要提交到公开仓库
/// - 国内用户可以考虑使用阿里云百炼等国内服务
class AiConfig {
  /// 是否启用AI功能（设为false时使用演示数据）
  static const bool enableAi = true;
  
  /// AI模式选择
  static const AiMode aiMode = AiMode.hybrid;
  
  /// 默认云端模型选择
  static const CloudModelType defaultCloudModel = CloudModelType.openai;

  /// API密钥（向后兼容）
  static const String? apiKey = null;
  
  /// OpenAI API Key
  static const String? openAiApiKey = null;
  
  /// Claude API Key
  static const String? claudeApiKey = null;
  
  /// 豆包 API Key
  static const String? doubaoApiKey = null;

  /// API基础地址（向后兼容）
  static const String baseUrl = 'https://api.openai.com/v1';
  
  /// OpenAI API基础地址
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  
  /// Claude API基础地址
  static const String claudeBaseUrl = 'https://api.anthropic.com/v1';
  
  /// 豆包 API基础地址
  static const String doubaoBaseUrl = 'https://ark.cn-beijing.volces.com/api/v3';

  /// 使用的模型（向后兼容）
  static const String model = 'gpt-3.5-turbo';
  
  /// OpenAI 使用的模型
  static const String openAiModel = 'gpt-3.5-turbo';
  
  /// Claude 使用的模型
  static const String claudeModel = 'claude-3-sonnet-20240229';
  
  /// 豆包 使用的模型
  static const String doubaoModel = 'ep-20241205095253-5j9z2';

  /// 请求超时时间（秒）
  static const int timeoutSeconds = 30;
  
  /// 本地模型配置
  static const LocalModelConfig localModel = LocalModelConfig();
}

enum AiMode {
  /// 云端AI模式（使用OpenAI等API）
  cloud,
  /// 本地AI模式（使用设备端模型）
  local,
  /// 混合模式（优先本地，失败时降级云端）
  hybrid,
}

enum CloudModelType {
  openai,
  claude,
  doubao,
}

extension CloudModelTypeExtension on CloudModelType {
  String get displayName {
    switch (this) {
      case CloudModelType.openai:
        return 'OpenAI';
      case CloudModelType.claude:
        return 'Claude';
      case CloudModelType.doubao:
        return '豆包';
    }
  }
  
  String get description {
    switch (this) {
      case CloudModelType.openai:
        return 'GPT-3.5/4 模型，全球最佳质量';
      case CloudModelType.claude:
        return 'Claude 3 模型，隐私友好，健康领域强';
      case CloudModelType.doubao:
        return '中文优化，国内访问速度快';
    }
  }
}

class LocalModelConfig {
  const LocalModelConfig();
  
  /// 是否启用本地数据加密
  bool get enableEncryption => true;
  
  /// 默认模型类型
  LocalModelType get defaultModel => LocalModelType.phi3Mini;
  
  /// 模型存储路径
  String get modelPath => 'models';
  
  /// 是否启用硬件加速
  bool get enableHardwareAcceleration => true;
  
  /// 推理超时时间（秒）
  int get inferenceTimeout => 60;
}

enum LocalModelType {
  /// Phi-3 Mini (3.8B参数，适合移动端)
  phi3Mini,
  /// TinyBERT (情感分析专用)
  tinyBert,
  /// Mistral-7B (量化版)
  mistral7b,
  /// Whisper Tiny (语音识别)
  whisperTiny,
}

extension LocalModelTypeExtension on LocalModelType {
  String get displayName {
    switch (this) {
      case LocalModelType.phi3Mini:
        return 'Phi-3 Mini';
      case LocalModelType.tinyBert:
        return 'TinyBERT';
      case LocalModelType.mistral7b:
        return 'Mistral-7B';
      case LocalModelType.whisperTiny:
        return 'Whisper Tiny';
    }
  }
  
  String get description {
    switch (this) {
      case LocalModelType.phi3Mini:
        return '通用对话与分析';
      case LocalModelType.tinyBert:
        return '情感分析专用';
      case LocalModelType.mistral7b:
        return '高质量文本生成';
      case LocalModelType.whisperTiny:
        return '语音识别';
    }
  }
  
  int get approximateSizeMB {
    switch (this) {
      case LocalModelType.phi3Mini:
        return 2000;
      case LocalModelType.tinyBert:
        return 100;
      case LocalModelType.mistral7b:
        return 4000;
      case LocalModelType.whisperTiny:
        return 150;
    }
  }
}
