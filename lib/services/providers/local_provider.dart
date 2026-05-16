import 'dart:convert';
import '../model_provider.dart';
import '../sentiment_analysis_service.dart' as sentiment;
import '../../config/ai_config.dart';

/// 本地模型提供者
class LocalProvider implements ModelProvider {
  final LocalModelType modelType;

  LocalProvider({
    this.modelType = LocalModelType.phi3Mini,
  });

  @override
  String get providerName => '本地模型';

  @override
  String get description => '100% 隐私保护，无网络请求';

  @override
  bool get isAvailable => true;

  @override
  int get costLevel => 1;

  @override
  int get qualityLevel => 3;

  @override
  Future<String> generateInsights(Map<String, dynamic> data) async {
    try {
      final insights = <Map<String, dynamic>>[];
      final sleepData = data['sleep_data'] as List?;
      final dietData = data['diet_data'] as List?;
      final exerciseData = data['exercise_data'] as List?;
      final moodData = data['mood_data'] as List?;

      if (sleepData != null && sleepData.length > 5) {
        insights.add({
          'title': '睡眠模式识别',
          'description': '根据你过去${sleepData.length}天的睡眠记录显示规律的作息模式',
          'suggestion': '继续保持规律的睡眠时间，有助于身体健康',
          'confidence': 0.8,
          'insightType': 'pattern',
          'category': 'sleep'
        });
      }

      if (exerciseData != null && exerciseData.length > 3) {
        insights.add({
          'title': '运动习惯分析',
          'description': '你有${exerciseData.length}条运动记录，保持运动的好习惯',
          'suggestion': '继续保持适量运动，每周至少3次',
          'confidence': 0.75,
          'insightType': 'positive',
          'category': 'exercise'
        });
      }

      if (dietData != null && dietData.length > 0) {
        insights.add({
          'title': '饮食记录',
          'description': '保持记录饮食的好习惯',
          'suggestion': '继续记录饮食有助于了解营养摄入情况',
          'confidence': 0.7,
          'insightType': 'positive',
          'category': 'diet'
        });
      }

      if (insights.isEmpty) {
        insights.add({
          'title': '开始记录',
          'description': '继续保持记录健康数据的好习惯',
          'suggestion': '持续记录更多数据，我能提供更精准的分析',
          'confidence': 0.6,
          'insightType': 'positive',
          'category': 'overall'
        });
      }

      return jsonEncode({'insights': insights});
    } catch (e) {
      return 'demo_mode';
    }
  }

  @override
  Future<String> generateSchedule(Map<String, dynamic> data) async {
    try {
      final schedules = <Map<String, dynamic>>[];

      schedules.add({
        'title': '健康提醒',
        'content': '根据你的健康记录，记得保持良好的作息习惯',
        'priority': 'medium',
        'scheduleTime': '22:00',
        'actionType': 'general',
        'actionRequired': false
      });

      schedules.add({
        'title': '运动建议',
        'content': '今天记得花30分钟做一些轻松的运动，保持身体健康',
        'priority': 'low',
        'scheduleTime': '18:00',
        'actionType': 'exercise',
        'actionRequired': false
      });

      return jsonEncode({'schedules': schedules});
    } catch (e) {
      return 'demo_mode';
    }
  }

  @override
  Future<SentimentAnalysisResult> analyzeSentiment(String text) async {
    final result = sentiment.SentimentAnalysisService.analyze(text);
    return SentimentAnalysisResult(
      sentimentScore: result.sentimentScore,
      anxietyLevel: result.anxietyLevel,
      stressors: result.stressors,
      moodCategory: result.moodCategory,
      suggestions: result.suggestions,
    );
  }
}
