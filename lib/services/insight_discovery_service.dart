import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/ai_insight.dart';
import '../services/health_data_aggregator.dart';
import '../services/ai_integration_service.dart';

class InsightDiscoveryService {
  final HealthDataAggregator _aggregator = HealthDataAggregator();
  final AiIntegrationService _aiService = AiIntegrationService();

  Future<List<AiInsight>> getInsights({bool forceDemo = false}) async {
    if (forceDemo || !_aiService.isConfigured) {
      return AiInsight.getDemoInsights();
    }

    try {
      final summaries = await _aggregator.getHistoricalData(30);
      if (summaries.length < 7) {
        return AiInsight.getDemoInsights();
      }

      final data = _aggregator.prepareDataForAi(summaries);
      final aiResponse = await _aiService.generateInsights(data);

      if (aiResponse == 'demo_mode') {
        return AiInsight.getDemoInsights();
      }

      return _parseInsightsResponse(aiResponse);
    } catch (e) {
      return AiInsight.getDemoInsights();
    }
  }

  List<AiInsight> _parseInsightsResponse(String response) {
    try {
      String cleanedResponse = _extractJson(response);
      
      final json = jsonDecode(cleanedResponse);
      final List<dynamic> insightsJson = json['insights'] ?? [];
      
      if (insightsJson.isEmpty) {
        return AiInsight.getDemoInsights();
      }

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      return insightsJson.take(1).map((item) {
        return AiInsight(
          date: today,
          insightType: _safeString(item['insightType'], 'pattern'),
          title: _safeString(item['title'], '健康洞察'),
          description: _safeString(item['description'], '发现了一些有趣的健康模式'),
          suggestion: item['suggestion'] as String?,
          confidence: _safeDouble(item['confidence'], 0.7),
          dataPoints: 0,
          relatedMetrics: null,
          category: _safeString(item['category'], 'overall'),
          createdAt: DateTime.now().toIso8601String(),
          isDemo: false,
        );
      }).toList();
    } catch (e) {
      return AiInsight.getDemoInsights();
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

  double _safeDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    try {
      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }
}
