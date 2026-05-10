import 'dart:math';
import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../models/exercise_record.dart';
import '../models/diet_record.dart';
import '../models/mood_record.dart';

class HealthAnalysisService {
  static Future<SleepAnalysisResult> analyzeSleep(List<SleepRecord> records) async {
    if (records.isEmpty) {
      return SleepAnalysisResult(
        avgDuration: 0,
        avgQuality: 0,
        consistency: 0,
        recommendations: ['暂无睡眠数据'],
        totalRecords: 0,
      );
    }

    double totalDuration = 0;
    int totalQuality = 0;
    Set<String> dates = {};
    
    for (var record in records) {
      totalDuration += record.duration ?? 0;
      totalQuality += record.quality ?? 0;
      dates.add(record.date);
    }

    double avgDuration = totalDuration / records.length;
    double avgQuality = totalQuality / records.length;
    
    int consistency = (dates.length / (DateTime.now().difference(DateTime.parse(dates.first)).inDays + 1) * 100).round();

    List<String> recommendations = [];
    
    if (avgDuration < 7) {
      recommendations.add('建议每晚保证7-8小时睡眠，充足的睡眠对健康至关重要');
    }
    if (avgDuration > 9) {
      recommendations.add('睡眠时间过长可能影响睡眠质量，建议保持在7-9小时');
    }
    if (avgQuality < 3) {
      recommendations.add('睡眠质量有待提高，建议睡前避免使用电子设备');
    }
    if (consistency < 60) {
      recommendations.add('建议保持规律的作息时间，有助于稳定生物钟');
    }
    if (recommendations.isEmpty) {
      recommendations.add('您的睡眠状况良好，请继续保持！');
    }

    return SleepAnalysisResult(
      avgDuration: avgDuration,
      avgQuality: avgQuality,
      consistency: consistency,
      recommendations: recommendations,
      totalRecords: records.length,
    );
  }

  static Future<ExerciseAnalysisResult> analyzeExercise(List<ExerciseRecord> records) async {
    if (records.isEmpty) {
      return ExerciseAnalysisResult(
        totalMinutes: 0,
        totalCalories: 0,
        avgIntensity: 0,
        frequency: 0,
        recommendations: ['暂无运动数据'],
        totalRecords: 0,
        exerciseTypeDistribution: {},
      );
    }

    int totalMinutes = 0;
    double totalCalories = 0;
    int totalIntensity = 0;
    Set<String> dates = {};
    Map<String, int> typeDistribution = {};
    
    for (var record in records) {
      totalMinutes += record.duration;
      totalCalories += record.caloriesBurned;
      totalIntensity += record.intensity;
      dates.add(record.date);
      
      String typeName = _getExerciseTypeName(record.exerciseType);
      typeDistribution[typeName] = (typeDistribution[typeName] ?? 0) + 1;
    }

    double avgIntensity = totalIntensity / records.length;
    int frequency = dates.length;

    List<String> recommendations = [];
    
    if (totalMinutes < 150) {
      recommendations.add('建议每周至少运动150分钟，有助于维持身体健康');
    }
    if (totalMinutes >= 300) {
      recommendations.add('运动量充足，继续保持良好的运动习惯！');
    }
    if (avgIntensity < 3) {
      recommendations.add('适当增加运动强度，可以尝试更高强度的运动');
    }
    if (frequency < 3) {
      recommendations.add('建议每周至少运动3次，保持规律的运动习惯');
    }
    if (typeDistribution.length < 2) {
      recommendations.add('建议尝试多种运动类型，全面锻炼身体');
    }
    if (recommendations.isEmpty) {
      recommendations.add('您的运动状况良好，请继续保持！');
    }

    return ExerciseAnalysisResult(
      totalMinutes: totalMinutes,
      totalCalories: totalCalories,
      avgIntensity: avgIntensity,
      frequency: frequency,
      recommendations: recommendations,
      totalRecords: records.length,
      exerciseTypeDistribution: typeDistribution,
    );
  }

  static Future<DietAnalysisResult> analyzeDiet(List<DietRecord> records) async {
    if (records.isEmpty) {
      return DietAnalysisResult(
        avgCalories: 0,
        avgProtein: 0,
        avgCarbs: 0,
        avgFat: 0,
        recommendations: ['暂无饮食数据'],
        totalRecords: 0,
        mealDistribution: {},
      );
    }

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    Map<String, int> mealDistribution = {};
    
    for (var record in records) {
      totalCalories += record.calories * record.servings;
      totalProtein += record.protein * record.servings;
      totalCarbs += record.carbs * record.servings;
      totalFat += record.fat * record.servings;
      
      String mealName = _getMealTypeName(record.mealType);
      mealDistribution[mealName] = (mealDistribution[mealName] ?? 0) + 1;
    }

    double avgCalories = totalCalories / records.length;
    double avgProtein = totalProtein / records.length;
    double avgCarbs = totalCarbs / records.length;
    double avgFat = totalFat / records.length;

    List<String> recommendations = [];
    
    if (avgCalories < 1500) {
      recommendations.add('摄入热量偏低，建议适当增加营养摄入');
    }
    if (avgCalories > 2500) {
      recommendations.add('摄入热量偏高，建议控制饮食量');
    }
    if (avgProtein < 60) {
      recommendations.add('蛋白质摄入不足，建议增加优质蛋白质摄入');
    }
    if (avgFat > 70) {
      recommendations.add('脂肪摄入偏高，建议减少高脂肪食物');
    }
    if (mealDistribution.length < 3) {
      recommendations.add('建议三餐规律，保证营养均衡');
    }
    if (recommendations.isEmpty) {
      recommendations.add('您的饮食状况良好，请继续保持！');
    }

    return DietAnalysisResult(
      avgCalories: avgCalories,
      avgProtein: avgProtein,
      avgCarbs: avgCarbs,
      avgFat: avgFat,
      recommendations: recommendations,
      totalRecords: records.length,
      mealDistribution: mealDistribution,
    );
  }

  static Future<MoodAnalysisResult> analyzeMood(List<MoodRecord> records) async {
    if (records.isEmpty) {
      return MoodAnalysisResult(
        avgMood: 0,
        stability: 0,
        positiveDays: 0,
        recommendations: ['暂无心态数据'],
        totalRecords: 0,
      );
    }

    int totalMood = 0;
    int sumSquaredDiff = 0;
    int positiveCount = 0;
    Set<String> dates = {};
    
    for (var record in records) {
      totalMood += record.moodLevel;
      if (record.moodLevel >= 4) positiveCount++;
      dates.add(record.date);
    }

    double avgMood = totalMood / records.length;
    
    for (var record in records) {
      sumSquaredDiff += ((record.moodLevel - avgMood) * (record.moodLevel - avgMood)).round();
    }
    double variance = sumSquaredDiff / records.length;
    double stdDev = sqrt(variance);
    int stability = ((1 - stdDev / 2) * 100).clamp(0, 100).round();

    List<String> recommendations = [];
    
    if (avgMood < 3) {
      recommendations.add('近期情绪较低落，建议多进行户外活动和社交');
    }
    if (avgMood >= 4) {
      recommendations.add('情绪状态良好，继续保持积极心态！');
    }
    if (stability < 60) {
      recommendations.add('情绪波动较大，建议学习情绪管理技巧');
    }
    if (recommendations.isEmpty) {
      recommendations.add('您的心态状况良好，请继续保持！');
    }

    return MoodAnalysisResult(
      avgMood: avgMood,
      stability: stability,
      positiveDays: positiveCount,
      recommendations: recommendations,
      totalRecords: records.length,
    );
  }

  static String _getExerciseTypeName(int type) {
    switch (type) {
      case 1: return '步行';
      case 2: return '跑步';
      case 3: return '骑行';
      case 4: return '游泳';
      case 5: return '瑜伽';
      case 6: return '健身';
      default: return '其他';
    }
  }

  static String _getMealTypeName(int type) {
    switch (type) {
      case 1: return '早餐';
      case 2: return '午餐';
      case 3: return '晚餐';
      case 4: return '加餐';
      default: return '其他';
    }
  }
}

class SleepAnalysisResult {
  final double avgDuration;
  final double avgQuality;
  final int consistency;
  final List<String> recommendations;
  final int totalRecords;

  SleepAnalysisResult({
    required this.avgDuration,
    required this.avgQuality,
    required this.consistency,
    required this.recommendations,
    required this.totalRecords,
  });
}

class ExerciseAnalysisResult {
  final int totalMinutes;
  final double totalCalories;
  final double avgIntensity;
  final int frequency;
  final List<String> recommendations;
  final int totalRecords;
  final Map<String, int> exerciseTypeDistribution;

  ExerciseAnalysisResult({
    required this.totalMinutes,
    required this.totalCalories,
    required this.avgIntensity,
    required this.frequency,
    required this.recommendations,
    required this.totalRecords,
    required this.exerciseTypeDistribution,
  });
}

class DietAnalysisResult {
  final double avgCalories;
  final double avgProtein;
  final double avgCarbs;
  final double avgFat;
  final List<String> recommendations;
  final int totalRecords;
  final Map<String, int> mealDistribution;

  DietAnalysisResult({
    required this.avgCalories,
    required this.avgProtein,
    required this.avgCarbs,
    required this.avgFat,
    required this.recommendations,
    required this.totalRecords,
    required this.mealDistribution,
  });
}

class MoodAnalysisResult {
  final double avgMood;
  final int stability;
  final int positiveDays;
  final List<String> recommendations;
  final int totalRecords;

  MoodAnalysisResult({
    required this.avgMood,
    required this.stability,
    required this.positiveDays,
    required this.recommendations,
    required this.totalRecords,
  });
}

enum TimeRange {
  week,
  month,
  threeMonths,
  custom,
}

extension TimeRangeExtension on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.week: return '近7天';
      case TimeRange.month: return '近30天';
      case TimeRange.threeMonths: return '近90天';
      case TimeRange.custom: return '自定义';
    }
  }

  DateTime get startDate {
    switch (this) {
      case TimeRange.week:
        return DateTime.now().subtract(const Duration(days: 7));
      case TimeRange.month:
        return DateTime.now().subtract(const Duration(days: 30));
      case TimeRange.threeMonths:
        return DateTime.now().subtract(const Duration(days: 90));
      case TimeRange.custom:
        return DateTime.now().subtract(const Duration(days: 7));
    }
  }
}