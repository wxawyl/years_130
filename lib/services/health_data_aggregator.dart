import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/voice_diary_record.dart';
import '../services/database_service.dart';

class HealthDataSummary {
  final String date;
  final SleepRecord? sleepRecord;
  final List<DietRecord> dietRecords;
  final List<ExerciseRecord> exerciseRecords;
  final VoiceDiaryRecord? voiceDiary;

  HealthDataSummary({
    required this.date,
    this.sleepRecord,
    this.dietRecords = const [],
    this.exerciseRecords = const [],
    this.voiceDiary,
  });

  bool get hasData =>
      sleepRecord != null ||
      dietRecords.isNotEmpty ||
      exerciseRecords.isNotEmpty ||
      voiceDiary != null;
}

class HealthDataAggregator {
  final DatabaseService _databaseService = DatabaseService();

  Future<HealthDataSummary> getDailySummary(String date) async {
    final sleepRecords = await _databaseService.getSleepRecords(date);
    final dietRecords = await _databaseService.getDietRecords(date);
    final exerciseRecords = await _databaseService.getExerciseRecords(date);
    final voiceDiary = await _databaseService.getVoiceDiary(date);

    return HealthDataSummary(
      date: date,
      sleepRecord: sleepRecords.isNotEmpty ? sleepRecords.first : null,
      dietRecords: dietRecords,
      exerciseRecords: exerciseRecords,
      voiceDiary: voiceDiary,
    );
  }

  Future<List<HealthDataSummary>> getHistoricalData(int days) async {
    final summaries = <HealthDataSummary>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
      final summary = await getDailySummary(date);
      if (summary.hasData) {
        summaries.add(summary);
      }
    }

    return summaries;
  }

  Map<String, dynamic> prepareDataForAi(List<HealthDataSummary> summaries) {
    final data = <String, dynamic>{
      'data_points': summaries.length,
      'sleep_data': <Map<String, dynamic>>[],
      'diet_data': <Map<String, dynamic>>[],
      'exercise_data': <Map<String, dynamic>>[],
      'mood_data': <Map<String, dynamic>>[],
    };

    for (final summary in summaries) {
      if (summary.sleepRecord != null) {
        data['sleep_data'].add({
          'date': summary.date,
          'duration_hours': summary.sleepRecord?.duration,
          'quality': summary.sleepRecord?.quality,
          'deep_sleep_ratio': summary.sleepRecord?.deepSleepRatio,
          'bed_time': summary.sleepRecord?.bedtime,
          'wake_time': summary.sleepRecord?.wakeTime,
        });
      }

      if (summary.dietRecords.isNotEmpty) {
        data['diet_data'].add({
          'date': summary.date,
          'total_calories': _sumCalories(summary.dietRecords),
          'meals_count': summary.dietRecords.length,
        });
      }

      if (summary.exerciseRecords.isNotEmpty) {
        data['exercise_data'].add({
          'date': summary.date,
          'total_duration_min': _sumDuration(summary.exerciseRecords),
          'total_calories': _sumExerciseCalories(summary.exerciseRecords),
          'has_high_intensity': _hasHighIntensity(summary.exerciseRecords),
        });
      }

      if (summary.voiceDiary != null) {
        data['mood_data'].add({
          'date': summary.date,
          'sentiment_score': summary.voiceDiary?.sentimentScore,
          'anxiety_level': summary.voiceDiary?.anxietyLevel,
          'mood_category': summary.voiceDiary?.moodCategory,
        });
      }
    }

    return data;
  }

  double _sumCalories(List<DietRecord> records) {
    return records.fold(0.0, (sum, r) => sum + (r.calories * r.servings));
  }

  int _sumDuration(List<ExerciseRecord> records) {
    return records.fold(0, (sum, r) => sum + r.duration);
  }

  double _sumExerciseCalories(List<ExerciseRecord> records) {
    return records.fold(0.0, (sum, r) => sum + r.caloriesBurned);
  }

  bool _hasHighIntensity(List<ExerciseRecord> records) {
    return records.any((r) => r.intensity >= 4);
  }
}