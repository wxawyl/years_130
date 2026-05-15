import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/daily_schedule.dart';
import '../services/health_data_aggregator.dart';
import '../services/ai_integration_service.dart';

class DailyScheduleService {
  final HealthDataAggregator _aggregator = HealthDataAggregator();
  final AiIntegrationService _aiService = AiIntegrationService();

  Future<List<DailySchedule>> getTodaySchedules({bool forceDemo = false}) async {
    if (forceDemo || !_aiService.isConfigured) {
      return DailySchedule.getDemoSchedules();
    }

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final todaySummary = await _aggregator.getDailySummary(today);
      
      final historicalSummaries = await _aggregator.getHistoricalData(7);
      
      final data = {
        'today': _aggregator.prepareDataForAi([todaySummary]),
        'historical': _aggregator.prepareDataForAi(historicalSummaries),
      };
      
      final aiResponse = await _aiService.generateSchedule(data);
      
      if (aiResponse == 'demo_mode') {
        return DailySchedule.getDemoSchedules();
      }

      return _parseSchedulesResponse(aiResponse);
    } catch (e) {
      return DailySchedule.getDemoSchedules();
    }
  }

  List<DailySchedule> _parseSchedulesResponse(String response) {
    try {
      String cleanedResponse = _extractJson(response);
      
      final json = jsonDecode(cleanedResponse);
      final List<dynamic> schedulesJson = json['schedules'] ?? [];
      
      if (schedulesJson.isEmpty) {
        return DailySchedule.getDemoSchedules();
      }

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      return schedulesJson.map((item) {
        return DailySchedule(
          date: today,
          title: _safeString(item['title'], '健康提醒'),
          content: _safeString(item['content'], '记得保持健康的生活习惯！'),
          priority: _safePriority(item['priority']),
          actionRequired: _safeBool(item['actionRequired'], true),
          triggeredBy: null,
          scheduleTime: item['scheduleTime'] as String?,
          actionType: _safeActionType(item['actionType']),
          isCompleted: false,
          isDismissed: false,
          createdAt: DateTime.now().toIso8601String(),
          isDemo: false,
        );
      }).toList();
    } catch (e) {
      return DailySchedule.getDemoSchedules();
    }
  }

  String _extractJson(String response) {
    final jsonStart = response.indexOf('{');
    final jsonEnd = response.lastIndexOf('}');
    
    if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
      return response.substring(jsonStart, jsonEnd + 1);
    }
    
    return response;
  }

  String _safeString(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;
    return value.toString().trim();
  }

  bool _safeBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  String _safePriority(dynamic value) {
    if (value == null) return 'medium';
    final v = value.toString().toLowerCase();
    if (v == 'high' || v == 'low' || v == 'medium') {
      return v;
    }
    return 'medium';
  }

  String _safeActionType(dynamic value) {
    if (value == null) return 'general';
    final v = value.toString().toLowerCase();
    if (['sleep_mode', 'exercise', 'diet', 'mood', 'general'].contains(v)) {
      return v;
    }
    return 'general';
  }
}
