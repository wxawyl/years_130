import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model_provider.dart';

/// 豆包（字节跳动）模型提供者
class DoubaoProvider implements ModelProvider {
  final String? apiKey;
  final String baseUrl;
  final String model;
  final int timeoutSeconds;

  DoubaoProvider({
    this.apiKey,
    this.baseUrl = 'https://ark.cn-beijing.volces.com/api/v3',
    this.model = 'ep-20241205095253-5j9z2',
    this.timeoutSeconds = 30,
  });

  @override
  String get providerName => '豆包';

  @override
  String get description => '中文优化，国内访问速度快';

  @override
  bool get isAvailable => apiKey?.isNotEmpty ?? false;

  @override
  int get costLevel => 2;

  @override
  int get qualityLevel => 4;

  @override
  Future<String> generateInsights(Map<String, dynamic> data) async {
    try {
      final prompt = _buildInsightPrompt(data);
      final response = await _makeApiRequest([
        {'role': 'system', 'content': '你是一个专业的健康数据分析助手。请根据用户的健康数据，发现隐藏的关联性和模式。只返回JSON，不要包含任何其他文字说明。'},
        {'role': 'user', 'content': prompt},
      ]);
      return response;
    } catch (e) {
      return 'demo_mode';
    }
  }

  @override
  Future<String> generateSchedule(Map<String, dynamic> data) async {
    try {
      final prompt = _buildSchedulePrompt(data);
      final response = await _makeApiRequest([
        {'role': 'system', 'content': '你是一个专业的健康管理助手。请根据用户的健康数据，给出个性化的日程建议和提醒。只返回JSON，不要包含任何其他文字说明。'},
        {'role': 'user', 'content': prompt},
      ]);
      return response;
    } catch (e) {
      return 'demo_mode';
    }
  }

  @override
  Future<SentimentAnalysisResult>? analyzeSentiment(String text) => null;

  Future<String> _makeApiRequest(List<Map<String, String>> messages) async {
    if (apiKey == null || apiKey!.isEmpty) {
      return 'demo_mode';
    }

    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 1000,
      }),
    ).timeout(Duration(seconds: timeoutSeconds));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['choices'][0]['message']['content'];
    }
    return 'demo_mode';
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
  "insights": [...]
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
  "schedules": [...]
}''';
  }
}
