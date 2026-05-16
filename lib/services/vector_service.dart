import 'dart:math';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/health_vector.dart';
import '../models/rag_search_result.dart';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/voice_diary_record.dart';
import '../models/daily_score.dart';
import '../services/database_service.dart';

class VectorService {
  static final VectorService _instance = VectorService._internal();
  final DatabaseService _dbService = DatabaseService();
  final Random _random = Random();

  factory VectorService() {
    return _instance;
  }

  VectorService._internal();

  List<double> _generateSimpleVector(String text, int dimensions) {
    final bytes = utf8.encode(text);
    List<double> vector = List.generate(dimensions, (i) => 0.0);
    
    for (int i = 0; i < bytes.length; i++) {
      int pos = i % dimensions;
      vector[pos] += bytes[i] / 255.0;
      vector[pos] = vector[pos] % 1.0;
    }
    
    double norm = sqrt(vector.fold(0.0, (sum, x) => sum + x * x));
    if (norm > 0) {
      vector = vector.map((x) => x / norm).toList();
    }
    
    return vector;
  }

  double _cosineSimilarity(List<double> v1, List<double> v2) {
    if (v1.length != v2.length) return 0.0;
    
    double dot = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;
    
    for (int i = 0; i < v1.length; i++) {
      dot += v1[i] * v2[i];
      norm1 += v1[i] * v1[i];
      norm2 += v2[i] * v2[i];
    }
    
    if (norm1 == 0 || norm2 == 0) return 0.0;
    return dot / (sqrt(norm1) * sqrt(norm2));
  }

  List<double> _parseVectorString(String vectorString) {
    try {
      List<dynamic> list = json.decode(vectorString);
      return list.map((x) => x as double).toList();
    } catch (e) {
      return List.generate(128, (i) => 0.0);
    }
  }

  String _generateVectorString(List<double> vector) {
    return json.encode(vector);
  }

  String _getUUID() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  String _formatSleepRecord(SleepRecord record) {
    return '睡眠记录：日期${record.date}，入睡${record.bedtime ?? '未知'}，起床${record.wakeTime ?? '未知'}，时长${record.duration?.toStringAsFixed(1) ?? '未知'}小时，质量${record.quality ?? '未知'}星，深睡${record.deepSleepRatio != null ? (record.deepSleepRatio! * 100).toStringAsFixed(0) : '未知'}%';
  }

  String _formatDietRecord(DietRecord record) {
    return '饮食记录：日期${record.date}，类型${record.mealType}，食物${record.foodName}，热量${record.calories}kcal，蛋白质${record.protein}g，碳水${record.carbs}g，脂肪${record.fat}g';
  }

  String _formatExerciseRecord(ExerciseRecord record) {
    return '运动记录：日期${record.date}，类型${record.subType}，时长${record.duration}分钟，强度${record.intensity}，消耗${record.caloriesBurned}kcal';
  }

  String _formatVoiceDiary(VoiceDiaryRecord record) {
    return '心情记录：日期${record.date}，心情${record.moodCategory ?? '未知'}，情感评分${record.sentimentScore?.toStringAsFixed(2) ?? '未知'}，内容${record.content}';
  }

  String _formatDailyScore(DailyScore score) {
    return '健康评分：日期${score.date}，总分${score.totalScore}，睡眠${score.sleepScore}，饮食${score.dietScore}，运动${score.exerciseScore}，心态${score.moodScore}';
  }

  Future<void> indexSleepRecord(SleepRecord record) async {
    final content = _formatSleepRecord(record);
    final vector = _generateSimpleVector(content, 128);
    
    final healthVector = HealthVector(
      uuid: _getUUID(),
      recordType: 1,
      recordId: record.id ?? 0,
      content: content,
      embedding: _generateVectorString(vector),
      score: 0.0,
      date: record.date,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    await _dbService.insertHealthVector(healthVector);
  }

  Future<void> indexDietRecord(DietRecord record) async {
    final content = _formatDietRecord(record);
    final vector = _generateSimpleVector(content, 128);
    
    final healthVector = HealthVector(
      uuid: _getUUID(),
      recordType: 2,
      recordId: record.id ?? 0,
      content: content,
      embedding: _generateVectorString(vector),
      score: 0.0,
      date: record.date,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    await _dbService.insertHealthVector(healthVector);
  }

  Future<void> indexExerciseRecord(ExerciseRecord record) async {
    final content = _formatExerciseRecord(record);
    final vector = _generateSimpleVector(content, 128);
    
    final healthVector = HealthVector(
      uuid: _getUUID(),
      recordType: 3,
      recordId: record.id ?? 0,
      content: content,
      embedding: _generateVectorString(vector),
      score: 0.0,
      date: record.date,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    await _dbService.insertHealthVector(healthVector);
  }

  Future<void> indexVoiceDiary(VoiceDiaryRecord record) async {
    final content = _formatVoiceDiary(record);
    final vector = _generateSimpleVector(content, 128);
    
    final healthVector = HealthVector(
      uuid: _getUUID(),
      recordType: 4,
      recordId: record.id ?? 0,
      content: content,
      embedding: _generateVectorString(vector),
      score: 0.0,
      date: record.date,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    await _dbService.insertHealthVector(healthVector);
  }

  Future<void> indexDailyScore(DailyScore score) async {
    final content = _formatDailyScore(score);
    final vector = _generateSimpleVector(content, 128);
    
    final healthVector = HealthVector(
      uuid: _getUUID(),
      recordType: 5,
      recordId: score.id ?? 0,
      content: content,
      embedding: _generateVectorString(vector),
      score: 0.0,
      date: score.date,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    await _dbService.insertHealthVector(healthVector);
  }

  Future<void> indexAllHealthRecords() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final oneYearAgo = DateFormat('yyyy-MM-dd').format(
      DateTime.now().subtract(const Duration(days: 365)),
    );

    final sleepRecords = await _dbService.getSleepRecordsByDateRange(oneYearAgo);
    for (final record in sleepRecords) {
      await indexSleepRecord(record);
    }

    final dietRecords = await _dbService.getDietRecordsByDateRange(oneYearAgo);
    for (final record in dietRecords) {
      await indexDietRecord(record);
    }

    final exerciseRecords = await _dbService.getExerciseRecordsByDateRange(oneYearAgo);
    for (final record in exerciseRecords) {
      await indexExerciseRecord(record);
    }

    final voiceDiaries = await _dbService.getVoiceDiariesByDateRange(oneYearAgo);
    for (final record in voiceDiaries) {
      await indexVoiceDiary(record);
    }
  }

  Future<List<RagSearchResult>> searchHealthRecords(String query, {int limit = 10, String? dateFilter}) async {
    final queryVector = _generateSimpleVector(query, 128);
    
    List<HealthVector> allVectors;
    if (dateFilter != null) {
      allVectors = await _dbService.getHealthVectors(date: dateFilter);
    } else {
      allVectors = await _dbService.getHealthVectors(limit: 100);
    }

    List<RagSearchResult> results = [];
    
    for (final vector in allVectors) {
      final storedVector = _parseVectorString(vector.embedding);
      final similarity = _cosineSimilarity(queryVector, storedVector);
      
      if (similarity > 0.1) {
        results.add(RagSearchResult(
          vector: vector,
          similarity: similarity,
        ));
      }
    }

    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    
    return results.take(limit).toList();
  }

  Future<String> buildRAGContext(String query, {int contextSize = 5}) async {
    final searchResults = await searchHealthRecords(query, limit: contextSize);
    
    if (searchResults.isEmpty) {
      return '暂未找到相关健康记录。';
    }

    StringBuffer context = StringBuffer();
    context.writeln('以下是您的健康记录，可帮助回答问题：\n');
    
    for (int i = 0; i < searchResults.length; i++) {
      final result = searchResults[i];
      context.writeln('${i + 1}. [${result.vector.recordTypeName}]');
      context.writeln('   ${result.vector.content}');
      context.writeln('   相关度：${(result.similarity * 100).toStringAsFixed(0)}%\n');
    }
    
    return context.toString();
  }

  Future<String> getHealthSummary(String timePeriod) async {
    final now = DateTime.now();
    String startDate;
    
    switch (timePeriod) {
      case 'week':
        startDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 7)));
        break;
      case 'month':
        startDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));
        break;
      case 'quarter':
        startDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 90)));
        break;
      case 'year':
      default:
        startDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 365)));
        break;
    }

    final vectors = await _dbService.getHealthVectorsByDateRange(startDate);
    
    if (vectors.isEmpty) {
      return '暂无健康记录。';
    }

    StringBuffer summary = StringBuffer();
    summary.writeln('健康记录概览（$timePeriod）：\n');
    
    final sleepRecords = vectors.where((v) => v.recordType == 1).length;
    final dietRecords = vectors.where((v) => v.recordType == 2).length;
    final exerciseRecords = vectors.where((v) => v.recordType == 3).length;
    final moodRecords = vectors.where((v) => v.recordType == 4).length;
    final scoreRecords = vectors.where((v) => v.recordType == 5).length;

    summary.writeln('- 睡眠记录：$sleepRecords 条');
    summary.writeln('- 饮食记录：$dietRecords 条');
    summary.writeln('- 运动记录：$exerciseRecords 条');
    summary.writeln('- 心情记录：$moodRecords 条');
    summary.writeln('- 健康评分：$scoreRecords 条');
    summary.writeln('\n总计：${vectors.length} 条记录');

    return summary.toString();
  }

  Future<void> clearAllVectors() async {
    final vectors = await _dbService.getHealthVectors();
    for (final vector in vectors) {
      if (vector.id != null) {
        await _dbService.deleteHealthVector(vector.id!);
      }
    }
  }

  Future<int> getVectorCount() async {
    final vectors = await _dbService.getHealthVectors();
    return vectors.length;
  }

  Future<List<HealthVector>> getAllVectors() async {
    return await _dbService.getHealthVectors();
  }
}
