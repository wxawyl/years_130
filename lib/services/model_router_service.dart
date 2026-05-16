import 'package:flutter/foundation.dart';
import 'model_provider.dart';
import 'providers/openai_provider.dart';
import 'providers/claude_provider.dart';
import 'providers/doubao_provider.dart';
import 'providers/local_provider.dart';
import '../config/ai_config.dart';

/// 用户模型配置
class UserModelConfig extends ChangeNotifier {
  AiMode _aiMode = AiConfig.aiMode;
  CloudModelType _cloudModel = AiConfig.defaultCloudModel;
  String? _openAiApiKey = AiConfig.openAiApiKey;
  String? _claudeApiKey = AiConfig.claudeApiKey;
  String? _doubaoApiKey = AiConfig.doubaoApiKey;

  AiMode get aiMode => _aiMode;
  CloudModelType get cloudModel => _cloudModel;
  String? get openAiApiKey => _openAiApiKey;
  String? get claudeApiKey => _claudeApiKey;
  String? get doubaoApiKey => _doubaoApiKey;

  void updateAiMode(AiMode mode) {
    _aiMode = mode;
    notifyListeners();
  }

  void updateCloudModel(CloudModelType model) {
    _cloudModel = model;
    notifyListeners();
  }

  void updateOpenAiApiKey(String key) {
    _openAiApiKey = key;
    notifyListeners();
  }

  void updateClaudeApiKey(String key) {
    _claudeApiKey = key;
    notifyListeners();
  }

  void updateDoubaoApiKey(String key) {
    _doubaoApiKey = key;
    notifyListeners();
  }
}

/// 模型路由服务
class ModelRouterService {
  final UserModelConfig _config;

  ModelRouterService(this._config);

  /// 获取当前配置的云端模型提供者
  ModelProvider getCurrentCloudProvider() {
    switch (_config.cloudModel) {
      case CloudModelType.openai:
        return OpenAIProvider(
          apiKey: _config.openAiApiKey,
          baseUrl: AiConfig.openAiBaseUrl,
          model: AiConfig.openAiModel,
        );
      case CloudModelType.claude:
        return ClaudeProvider(
          apiKey: _config.claudeApiKey,
          baseUrl: AiConfig.claudeBaseUrl,
          model: AiConfig.claudeModel,
        );
      case CloudModelType.doubao:
        return DoubaoProvider(
          apiKey: _config.doubaoApiKey,
          baseUrl: AiConfig.doubaoBaseUrl,
          model: AiConfig.doubaoModel,
        );
    }
  }

  /// 获取本地模型提供者
  ModelProvider getLocalProvider() {
    return LocalProvider();
  }

  /// 获取所有可用的云端模型提供者（无论是否有密钥）
  List<ModelProvider> getAllCloudProviders() {
    return [
      OpenAIProvider(apiKey: _config.openAiApiKey),
      ClaudeProvider(apiKey: _config.claudeApiKey),
      DoubaoProvider(apiKey: _config.doubaoApiKey),
    ];
  }

  /// 根据当前配置和任务类型获取最佳模型提供者
  Future<String> generateInsights(Map<String, dynamic> data) async {
    final localProvider = getLocalProvider();
    final cloudProvider = getCurrentCloudProvider();

    switch (_config.aiMode) {
      case AiMode.local:
        return await localProvider.generateInsights(data);
      case AiMode.cloud:
        return await cloudProvider.generateInsights(data);
      case AiMode.hybrid:
        try {
          final localResult = await localProvider.generateInsights(data);
          if (localResult != 'demo_mode' && localResult.isNotEmpty) {
            return localResult;
          }
        } catch (_) {
          // 本地失败，尝试云端
        }
        return await cloudProvider.generateInsights(data);
    }
  }

  /// 生成日程建议
  Future<String> generateSchedule(Map<String, dynamic> data) async {
    final localProvider = getLocalProvider();
    final cloudProvider = getCurrentCloudProvider();

    switch (_config.aiMode) {
      case AiMode.local:
        return await localProvider.generateSchedule(data);
      case AiMode.cloud:
        return await cloudProvider.generateSchedule(data);
      case AiMode.hybrid:
        try {
          final localResult = await localProvider.generateSchedule(data);
          if (localResult != 'demo_mode' && localResult.isNotEmpty) {
            return localResult;
          }
        } catch (_) {
          // 本地失败，尝试云端
        }
        return await cloudProvider.generateSchedule(data);
    }
  }

  /// 分析情感（始终使用本地）
  Future<SentimentAnalysisResult> analyzeSentiment(String text) async {
    final localProvider = getLocalProvider();
    final result = await localProvider.analyzeSentiment(text);
    if (result != null) {
      return result;
    }
    // Fallback
    return SentimentAnalysisResult(
      sentimentScore: 0,
      anxietyLevel: 3,
      stressors: [],
      moodCategory: '中性',
      suggestions: ['继续记录心态'],
    );
  }
}
