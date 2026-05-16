/// AI 模型提供者抽象接口
abstract class ModelProvider {
  /// 提供者名称
  String get providerName;
  
  /// 提供者描述
  String get description;
  
  /// 是否可用（API 密钥已配置）
  bool get isAvailable;
  
  /// 成本等级（1-5，1最便宜）
  int get costLevel;
  
  /// 质量等级（1-5，5最高）
  int get qualityLevel;
  
  /// 生成健康洞察分析
  Future<String> generateInsights(Map<String, dynamic> data);
  
  /// 生成日程建议
  Future<String> generateSchedule(Map<String, dynamic> data);
  
  /// 分析情感（可选，默认使用本地规则引擎）
  Future<SentimentAnalysisResult>? analyzeSentiment(String text) => null;
}

/// AI 任务类型
enum AITaskType {
  /// 健康洞察分析
  insights,
  /// 日程建议生成
  schedule,
  /// 情感分析
  sentiment,
}

/// 情感分析结果（与现有服务保持一致）
class SentimentAnalysisResult {
  final double sentimentScore;
  final int anxietyLevel;
  final List<String> stressors;
  final String moodCategory;
  final List<String> suggestions;

  SentimentAnalysisResult({
    required this.sentimentScore,
    required this.anxietyLevel,
    required this.stressors,
    required this.moodCategory,
    required this.suggestions,
  });
}
