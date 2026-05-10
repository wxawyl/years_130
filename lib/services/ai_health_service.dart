import 'package:flutter/foundation.dart';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/mood_record.dart';
import '../models/user_settings.dart';
import '../models/ai_health_report.dart';
import 'database_service.dart';

class AIHealthService {
  // 专业提示词模板 - 健康专家人设
  static const String systemPrompt = '''
你是一位专业的健康管理师，同时也是营养师、睡眠咨询师和心理疏导师。

请根据用户提供的数据，给出专业、个性化、可落地的健康建议。

要求：
1. 给出0-100分的整体健康总分
2. 分别给出睡眠、饮食、运动、心态4项分数（每项0-25分）
3. 指出健康隐患
4. 给出接地气、能立刻执行的日常建议
5. 不要医疗诊断，只给生活健康指导
6. 用中文回答，语言通俗易懂
7. 建议要具体，不要说空话

输出格式（严格按照JSON格式，不要有其他文字）：
{
  "total_score": 85,
  "sleep_score": 20,
  "diet_score": 22,
  "exercise_score": 21,
  "mood_score": 22,
  "health_issues": ["睡眠不足", "久坐过多"],
  "sleep_suggestion": "建议调整作息，保证7-8小时睡眠",
  "diet_suggestion": "注意控制热量摄入",
  "exercise_suggestion": "增加运动量",
  "mood_suggestion": "适当放松减压",
  "weekly_trend": "整体健康状况良好，需要注意睡眠和运动"
}
''';

  final DatabaseService _dbService;

  AIHealthService(this._dbService);

  // 构建用户数据摘要
  String _buildUserDataSummary({
    required UserSettings userSettings,
    List<SleepRecord>? sleepRecords,
    List<DietRecord>? dietRecords,
    List<ExerciseRecord>? exerciseRecords,
    List<MoodRecord>? moodRecords,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('【用户基本信息】');
    if (userSettings.age != null) buffer.writeln('年龄: ${userSettings.age}岁');
    if (userSettings.gender != null) buffer.writeln('性别: ${userSettings.gender}');
    if (userSettings.height != null) buffer.writeln('身高: ${userSettings.height}cm');
    if (userSettings.weight != null) buffer.writeln('体重: ${userSettings.weight}kg');
    if (userSettings.healthGoal != null) buffer.writeln('健康目标: ${userSettings.healthGoal}');
    if (userSettings.healthIssues != null && userSettings.healthIssues!.isNotEmpty) {
      buffer.writeln('健康问题: ${userSettings.healthIssues}');
    }

    buffer.writeln('\n【睡眠情况】');
    if (sleepRecords != null && sleepRecords.isNotEmpty) {
      final recentSleep = sleepRecords.first;
      if (recentSleep.duration != null) buffer.writeln('睡眠时长: ${recentSleep.duration}小时');
      buffer.writeln('睡眠质量评分: ${recentSleep.sleepQualityScore}/10');
      buffer.writeln('夜间醒来次数: ${recentSleep.awakenCount}次');
    } else {
      buffer.writeln('暂无睡眠记录');
    }

    buffer.writeln('\n【饮食情况】');
    if (dietRecords != null && dietRecords.isNotEmpty) {
      double totalCalories = 0;
      for (var record in dietRecords) {
        totalCalories += record.calories * record.servings;
      }
      buffer.writeln('摄入热量: ${totalCalories.toStringAsFixed(0)}卡路里');
      final recentDiet = dietRecords.first;
      buffer.writeln('饮食规律: ${recentDiet.isRegular == 1 ? "规律" : "不规律"}');
      if (recentDiet.hasFried == 1) buffer.writeln('食用了油炸食品');
      if (recentDiet.hasSweet == 1) buffer.writeln('食用了甜食');
      if (recentDiet.hasSnack == 1) buffer.writeln('食用了零食');
      buffer.writeln('喝水量: ${_waterLevelToString(recentDiet.waterLevel)}');
      buffer.writeln('饮酒量: ${_alcoholLevelToString(recentDiet.alcoholLevel)}');
    } else {
      buffer.writeln('暂无饮食记录');
    }

    buffer.writeln('\n【运动情况】');
    if (exerciseRecords != null && exerciseRecords.isNotEmpty) {
      int totalMinutes = 0;
      int totalSteps = 0;
      for (var record in exerciseRecords) {
        totalMinutes += record.duration;
        if (record.steps != null) totalSteps += record.steps!;
      }
      buffer.writeln('运动时长: $totalMinutes分钟');
      if (totalSteps > 0) buffer.writeln('步数: $totalSteps步');
      final recentExercise = exerciseRecords.first;
      buffer.writeln('刻意运动: ${recentExercise.hasIntentionalExercise == 1 ? "是" : "否"}');
      buffer.writeln('久坐程度: ${_sedentaryLevelToString(recentExercise.sedentaryLevel)}');
    } else {
      buffer.writeln('暂无运动记录');
    }

    buffer.writeln('\n【心情情况】');
    if (moodRecords != null && moodRecords.isNotEmpty) {
      final recentMood = moodRecords.first;
      buffer.writeln('心情评分: ${recentMood.moodLevel}/5');
      if (recentMood.stressLevel != null) buffer.writeln('压力水平: ${recentMood.stressLevel}');
      if (recentMood.hasAnxiety == 1) buffer.writeln('有焦虑情绪');
      if (recentMood.hasOverthinking == 1) buffer.writeln('有内耗情况');
      if (recentMood.hasLowMood == 1) buffer.writeln('有低落情绪');
    } else {
      buffer.writeln('暂无心情记录');
    }

    return buffer.toString();
  }

  String _waterLevelToString(int? level) {
    switch (level) {
      case 0: return '少';
      case 1: return '偏少';
      case 2: return '正常';
      case 3: return '充足';
      default: return '正常';
    }
  }

  String _alcoholLevelToString(int? level) {
    switch (level) {
      case 0: return '无';
      case 1: return '少量';
      case 2: return '中等';
      case 3: return '多';
      default: return '无';
    }
  }

  String _sedentaryLevelToString(int? level) {
    switch (level) {
      case 0: return '严重';
      case 1: return '偏多';
      case 2: return '一般';
      case 3: return '正常';
      default: return '一般';
    }
  }

  // 调用大模型API获取健康分析
  Future<AIHealthReport?> getHealthAnalysis({
    required String date,
  }) async {
    try {
      // 1. 获取所有需要的数据
    final userSettings = (await _dbService.getUserSettings()) ?? UserSettings();
    final sleepRecords = await _dbService.getSleepRecordsForDays(7); // 近7天
    final dietRecords = await _dbService.getDietRecordsForDays(7);
    final exerciseRecords = await _dbService.getExerciseRecordsForDays(7);
    final moodRecords = await _dbService.getMoodRecordsForDays(7);

    // 2. 构建用户数据摘要
    final userData = _buildUserDataSummary(
      userSettings: userSettings,
      sleepRecords: sleepRecords,
      dietRecords: dietRecords,
      exerciseRecords: exerciseRecords,
      moodRecords: moodRecords,
    );

      // 3. 调用大模型API (这里是示例实现)
      // 实际使用时需要替换为真实的API调用
      final report = await _callAIAPI(date, userData);

      return report;
    } catch (e) {
      debugPrint('AI分析失败: $e');
      return null;
    }
  }

  // 调用大模型API的内部方法 - 示例实现
  Future<AIHealthReport> _callAIAPI(String date, String userData) async {
    // 这是一个示例实现，实际使用时需要:
    // 1. 配置真实的API密钥和地址
    // 2. 调用真实的大模型API
    // 3. 解析返回的JSON
    
    // 这里我们先用模拟数据演示
    return _getMockReport(date);
  }

  // 模拟返回报告 - 用于演示
  AIHealthReport _getMockReport(String date) {
    return AIHealthReport(
      date: date,
      totalScore: 78,
      sleepScore: 18,
      dietScore: 20,
      exerciseScore: 20,
      moodScore: 20,
      healthIssues: '睡眠略不足,运动量偏少',
      sleepSuggestion: '建议保证每晚7-8小时睡眠，固定上床时间和起床时间',
      dietSuggestion: '注意饮食规律，多吃蔬菜水果，少吃油炸食品',
      exerciseSuggestion: '每天至少30分钟中等强度运动，如快走、跑步等',
      moodSuggestion: '每天花10分钟进行深呼吸或冥想，缓解压力',
      weeklyTrend: '整体健康状况较好，需要重点改善睡眠和增加运动',
    );
  }

  // 保存AI报告到数据库
  Future<void> saveReport(AIHealthReport report) async {
    await _dbService.insertAIReport(report);
  }

  // 获取历史报告
  Future<List<AIHealthReport>> getHistoricalReports({int days = 7}) async {
    return await _dbService.getAIReportsForDays(days);
  }

  // 获取指定日期的报告
  Future<AIHealthReport?> getReportForDate(String date) async {
    return await _dbService.getAIReport(date);
  }
}
