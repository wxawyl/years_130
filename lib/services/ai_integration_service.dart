import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ai_config.dart';

class AiIntegrationService {
  final String? apiKey;
  final String baseUrl;
  final String model;

  AiIntegrationService({
    this.apiKey = AiConfig.apiKey,
    this.baseUrl = AiConfig.baseUrl,
    this.model = AiConfig.model,
  });

  bool get isConfigured => AiConfig.enableAi && apiKey != null && apiKey!.isNotEmpty;

  Future<String> generateInsights(Map<String, dynamic> data) async {
    if (!isConfigured) {
      return 'demo_mode';
    }

    try {
      final prompt = _buildInsightPrompt(data);
      
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': '你是一个专业的健康数据分析助手。请根据用户的健康数据，发现隐藏的关联性和模式。只返回JSON，不要包含任何其他文字说明。'},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      ).timeout(const Duration(seconds: AiConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'];
      }
      return 'demo_mode';
    } catch (e) {
      return 'demo_mode';
    }
  }

  Future<String> generateSchedule(Map<String, dynamic> data) async {
    if (!isConfigured) {
      return 'demo_mode';
    }

    try {
      final prompt = _buildSchedulePrompt(data);
      
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': '你是一个专业的健康管理助手。请根据用户的健康数据，给出个性化的日程建议和提醒。只返回JSON，不要包含任何其他文字说明。'},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 800,
        }),
      ).timeout(const Duration(seconds: AiConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'];
      }
      return 'demo_mode';
    } catch (e) {
      return 'demo_mode';
    }
  }

  String _buildInsightPrompt(Map<String, dynamic> data) {
    return '''请分析以下健康数据，发现其中的关联性和模式。

数据概览：
- 数据点数：${data['data_points']}天
- 睡眠记录：${(data['sleep_data'] as List).length}条
- 饮食记录：${(data['diet_data'] as List).length}条
- 运动记录：${(data['exercise_data'] as List).length}条
- 心态记录：${(data['mood_data'] as List).length}条

详细数据：
${jsonEncode(data)}

请返回1-3个有价值的发现。每个发现需要：
1. title - 简短标题
2. description - 详细描述（包括你发现的具体规律）
3. suggestion - 具体的改进建议
4. confidence - 置信度（0-1之间的小数）
5. insightType - 类型（"correlation" 表示相关性发现，"pattern" 表示行为模式，"positive" 表示积极反馈）
6. category - 分类（"sleep", "diet", "exercise", "mood", "overall"）

只返回纯JSON，不要任何其他文字：
{
  "insights": [
    {
      "title": "咖啡因与深度睡眠",
      "description": "当你在下午摄入超过500ml咖啡因时，当晚深度睡眠比例平均降低约40%",
      "suggestion": "建议下午2点后避免饮用咖啡、茶或含咖啡因的饮料",
      "confidence": 0.85,
      "insightType": "correlation",
      "category": "sleep"
    }
  ]
}''';
  }

  String _buildSchedulePrompt(Map<String, dynamic> data) {
    return '''请根据以下今日健康数据和历史数据，给出1-2个个性化的日程建议。

今日数据：
${jsonEncode(data['today'] ?? {})}

历史数据（最近7天）：
${jsonEncode(data['historical'] ?? {})}

请返回1-2个日程建议。每个建议需要：
1. title - 简短标题
2. content - 详细内容（温馨、鼓励的语气）
3. priority - 优先级（"high", "medium", "low"）
4. scheduleTime - 建议时间（格式"HH:MM"，例如"22:00"）
5. actionType - 动作类型（"sleep_mode", "exercise", "diet", "mood", "general"）
6. actionRequired - 是否需要用户确认（true/false）

只返回纯JSON，不要任何其他文字：
{
  "schedules": [
    {
      "title": "今晚助眠计划",
      "content": "根据你最近的睡眠模式，今晚22:00我为你开启助眠模式并提醒你放下手机，好吗？",
      "priority": "high",
      "scheduleTime": "22:00",
      "actionType": "sleep_mode",
      "actionRequired": true
    }
  ]
}''';
  }
}
