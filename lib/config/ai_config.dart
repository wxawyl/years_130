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
  static const bool enableAi = false;

  /// API密钥（从OpenAI或其他AI服务提供商获取）
  static const String? apiKey = null;

  /// API基础地址
  /// - OpenAI: https://api.openai.com/v1
  /// - 阿里云百炼: 请查看对应文档
  static const String baseUrl = 'https://api.openai.com/v1';

  /// 使用的模型
  /// - OpenAI: gpt-3.5-turbo, gpt-4, etc.
  static const String model = 'gpt-3.5-turbo';

  /// 请求超时时间（秒）
  static const int timeoutSeconds = 30;
}
