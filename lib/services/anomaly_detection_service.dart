import 'dart:math';
import 'package:intl/intl.dart';
import '../models/health_anomaly.dart';
import '../services/database_service.dart';

class AnomalyDetectionService {
  static final AnomalyDetectionService _instance = AnomalyDetectionService._internal();
  final DatabaseService _dbService = DatabaseService();
  final Random _random = Random();

  factory AnomalyDetectionService() {
    return _instance;
  }

  AnomalyDetectionService._internal();

  String _getUUID() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  Future<List<HealthAnomaly>> detectAllAnomalies() async {
    List<HealthAnomaly> anomalies = [];

    final sleepAnomalies = await _detectSleepAnomalies();
    anomalies.addAll(sleepAnomalies);

    final dietAnomalies = await _detectDietAnomalies();
    anomalies.addAll(dietAnomalies);

    final exerciseAnomalies = await _detectExerciseAnomalies();
    anomalies.addAll(exerciseAnomalies);

    final moodAnomalies = await _detectMoodAnomalies();
    anomalies.addAll(moodAnomalies);

    final scoreAnomalies = await _detectScoreAnomalies();
    anomalies.addAll(scoreAnomalies);

    return anomalies;
  }

  Future<List<HealthAnomaly>> _detectSleepAnomalies() async {
    List<HealthAnomaly> anomalies = [];
    final now = DateTime.now();
    final thirtyDaysAgo = DateFormat('yyyy-MM-dd').format(
      now.subtract(const Duration(days: 30)),
    );

    final sleepRecords = await _dbService.getSleepRecordsByDateRange(thirtyDaysAgo);
    
    if (sleepRecords.length < 3) return anomalies;

    final validDurations = sleepRecords.where((r) => r.duration != null).map((r) => r.duration!).toList();
    final avgDuration = validDurations.isNotEmpty 
        ? validDurations.reduce((a, b) => a + b) / validDurations.length 
        : 0.0;

    final validQualities = sleepRecords.where((r) => r.quality != null).map((r) => r.quality!).toList();
    final avgQuality = validQualities.isNotEmpty 
        ? validQualities.reduce((a, b) => a + b) / validQualities.length 
        : 0.0;

    for (final record in sleepRecords) {
      if (record.duration != null && avgDuration > 0 && 
          record.duration! < avgDuration * 0.6 && record.duration! > 0) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 1,
          title: '睡眠时间过短',
          description: '${record.date}的睡眠时长为${record.duration}小时，低于平均水平的60%。建议保证充足睡眠。',
          severity: 0.6,
          relatedRecords: '睡眠记录: ${record.id}',
          suggestions: '建议在晚上10-11点之间入睡，保持规律作息，睡前避免使用电子设备。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }

      if (record.quality != null && avgQuality > 0 && 
          record.quality! < avgQuality * 0.6 && record.quality! > 0) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 1,
          title: '睡眠质量下降',
          description: '${record.date}的睡眠质量为${record.quality}星，建议关注睡眠环境和习惯。',
          severity: 0.5,
          relatedRecords: '睡眠记录: ${record.id}',
          suggestions: '保持卧室安静、黑暗、凉爽，睡前可尝试冥想或深呼吸练习。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }
    }

    return anomalies;
  }

  Future<List<HealthAnomaly>> _detectDietAnomalies() async {
    List<HealthAnomaly> anomalies = [];
    final now = DateTime.now();
    final thirtyDaysAgo = DateFormat('yyyy-MM-dd').format(
      now.subtract(const Duration(days: 30)),
    );

    final dietRecords = await _dbService.getDietRecordsByDateRange(thirtyDaysAgo);
    
    if (dietRecords.length < 3) return anomalies;

    final avgCalories = dietRecords.map((r) => r.calories).reduce((a, b) => a + b) / dietRecords.length;
    final avgProtein = dietRecords.map((r) => r.protein).reduce((a, b) => a + b) / dietRecords.length;

    for (final record in dietRecords) {
      if (record.calories > avgCalories * 1.5) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 2,
          title: '热量摄入过高',
          description: '${record.date}的${record.foodName}摄入了${record.calories}kcal，超过平均水平50%。',
          severity: 0.4,
          relatedRecords: '饮食记录: ${record.id}',
          suggestions: '注意控制热量摄入，可增加蔬菜和水果的比例，减少高油高糖食物。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }

      if (record.calories > 0 && record.calories < avgCalories * 0.5) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 2,
          title: '热量摄入不足',
          description: '${record.date}的热量摄入为${record.calories}kcal，低于平均水平50%。',
          severity: 0.5,
          relatedRecords: '饮食记录: ${record.id}',
          suggestions: '确保营养充足，适当增加蛋白质和健康脂肪的摄入，保持规律饮食。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }
    }

    return anomalies;
  }

  Future<List<HealthAnomaly>> _detectExerciseAnomalies() async {
    List<HealthAnomaly> anomalies = [];
    final now = DateTime.now();
    final thirtyDaysAgo = DateFormat('yyyy-MM-dd').format(
      now.subtract(const Duration(days: 30)),
    );

    final exerciseRecords = await _dbService.getExerciseRecordsByDateRange(thirtyDaysAgo);
    
    if (exerciseRecords.length < 3) return anomalies;

    final avgDuration = exerciseRecords.map((r) => r.duration).reduce((a, b) => a + b) / exerciseRecords.length;
    final avgCalories = exerciseRecords.map((r) => r.caloriesBurned).reduce((a, b) => a + b) / exerciseRecords.length;

    for (final record in exerciseRecords) {
      if (record.duration > avgDuration * 2) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 3,
          title: '运动量过大',
          description: '${record.date}的${record.subType}运动时长为${record.duration}分钟，超过平均水平的2倍。注意避免过度运动。',
          severity: 0.4,
          relatedRecords: '运动记录: ${record.id}',
          suggestions: '运动应循序渐进，注意热身和拉伸，避免过度训练导致受伤。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }

      if (record.intensity >= 4 && record.duration > 60) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 3,
          title: '高强度运动时长过长',
          description: '${record.date}的高强度运动持续${record.duration}分钟，建议适当降低强度或时长。',
          severity: 0.5,
          relatedRecords: '运动记录: ${record.id}',
          suggestions: '高强度运动建议控制在45分钟内，注意心率监测，保持适度休息。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }
    }

    final lastSevenDays = DateFormat('yyyy-MM-dd').format(
      now.subtract(const Duration(days: 7)),
    );
    final recentExercise = exerciseRecords.where((r) => r.date.compareTo(lastSevenDays) >= 0).toList();
    
    if (recentExercise.isEmpty) {
      anomalies.add(HealthAnomaly(
        uuid: _getUUID(),
        anomalyType: 3,
        title: '近期缺乏运动',
        description: '近7天没有运动记录，建议保持规律运动习惯。',
        severity: 0.4,
        relatedRecords: '运动记录: 无',
        suggestions: '可以从轻度运动开始，如散步、瑜伽等，逐步增加运动量。',
        createdAt: DateTime.now().toIso8601String(),
      ));
    }

    return anomalies;
  }

  Future<List<HealthAnomaly>> _detectMoodAnomalies() async {
    List<HealthAnomaly> anomalies = [];
    final now = DateTime.now();
    final thirtyDaysAgo = DateFormat('yyyy-MM-dd').format(
      now.subtract(const Duration(days: 30)),
    );

    final voiceDiaries = await _dbService.getVoiceDiariesByDateRange(thirtyDaysAgo);
    
    if (voiceDiaries.length < 3) return anomalies;

    for (final record in voiceDiaries) {
      if (record.sentimentScore != null && record.sentimentScore! < 0.0) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 4,
          title: '心情低落',
          description: '${record.date}记录的情感评分为${record.sentimentScore?.toStringAsFixed(2)}，建议关注心理健康。',
          severity: 0.6,
          relatedRecords: '心情记录: ${record.id}',
          suggestions: '可以尝试与朋友交流、进行放松活动，如冥想、听音乐等。如持续低落，建议寻求专业帮助。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }

      if (record.anxietyLevel != null && record.anxietyLevel! >= 4) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 4,
          title: '焦虑水平较高',
          description: '${record.date}记录的焦虑水平为${record.anxietyLevel}级，建议关注压力管理。',
          severity: 0.7,
          relatedRecords: '心情记录: ${record.id}',
          suggestions: '尝试深呼吸练习、渐进式肌肉放松，保证充足睡眠。如焦虑持续，建议寻求专业心理咨询。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }
    }

    return anomalies;
  }

  Future<List<HealthAnomaly>> _detectScoreAnomalies() async {
    List<HealthAnomaly> anomalies = [];
    
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayScore = await _dbService.getDailyScore(today);
    
    if (todayScore != null) {
      if (todayScore.totalScore < 50) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 5,
          title: '健康评分偏低',
          description: '今日健康评分为${todayScore.totalScore}，建议关注各项健康指标。',
          severity: 0.5,
          relatedRecords: '健康评分: ${todayScore.id}',
          suggestions: '查看各维度评分，有针对性地改善睡眠、饮食或运动习惯。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }

      if (todayScore.sleepScore < 50) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 1,
          title: '睡眠评分偏低',
          description: '今日睡眠评分为${todayScore.sleepScore}，建议改善睡眠质量。',
          severity: 0.4,
          relatedRecords: '健康评分: ${todayScore.id}',
          suggestions: '保持规律作息，创造良好睡眠环境，睡前放松身心。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }

      if (todayScore.exerciseScore < 50) {
        anomalies.add(HealthAnomaly(
          uuid: _getUUID(),
          anomalyType: 3,
          title: '运动评分偏低',
          description: '今日运动评分为${todayScore.exerciseScore}，建议增加活动量。',
          severity: 0.3,
          relatedRecords: '健康评分: ${todayScore.id}',
          suggestions: '每天坚持30分钟中等强度运动，如快走、骑车等。',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }
    }

    return anomalies;
  }

  Future<void> saveAnomaly(HealthAnomaly anomaly) async {
    await _dbService.insertHealthAnomaly(anomaly);
  }

  Future<List<HealthAnomaly>> getActiveAnomalies() async {
    return await _dbService.getHealthAnomalies(
      acknowledged: false,
      resolved: false,
    );
  }

  Future<void> acknowledgeAnomaly(int anomalyId) async {
    final anomalies = await _dbService.getHealthAnomalies();
    final anomaly = anomalies.firstWhere((a) => a.id == anomalyId);
    
    anomaly.isAcknowledged = 1;
    await _dbService.updateHealthAnomaly(anomaly);
  }

  Future<void> resolveAnomaly(int anomalyId) async {
    final anomalies = await _dbService.getHealthAnomalies();
    final anomaly = anomalies.firstWhere((a) => a.id == anomalyId);
    
    anomaly.isResolved = 1;
    anomaly.resolvedAt = DateTime.now().toIso8601String();
    await _dbService.updateHealthAnomaly(anomaly);
  }

  Future<List<HealthAnomaly>> runDetectionAndSave() async {
    final anomalies = await detectAllAnomalies();
    
    for (final anomaly in anomalies) {
      await saveAnomaly(anomaly);
    }
    
    return anomalies;
  }
}
