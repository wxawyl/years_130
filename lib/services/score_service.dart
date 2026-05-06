import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/mood_record.dart';
import '../models/daily_score.dart';
import '../services/database_service.dart';

class ScoreService {
  final DatabaseService _dbService = DatabaseService();

  Future<double> calculateSleepScore(String date) async {
    final records = await _dbService.getSleepRecords(date);
    if (records.isEmpty) return 0;

    final record = records.first;
    double score = 0;

    if (record.duration != null) {
      if (record.duration! >= 7 && record.duration! <= 9) {
        score += 15;
      } else if (record.duration! >= 6 && record.duration! <= 10) {
        score += 10;
      } else if (record.duration! >= 5 && record.duration! <= 11) {
        score += 5;
      }
    }

    if (record.quality != null) {
      score += record.quality! * 2;
    }

    if (record.deepSleepRatio != null) {
      if (record.deepSleepRatio! >= 0.25) {
        score += 3;
      } else if (record.deepSleepRatio! >= 0.2) {
        score += 2;
      } else {
        score += 1;
      }
    }

    return score.clamp(0, 25);
  }

  Future<double> calculateDietScore(String date) async {
    final records = await _dbService.getDietRecords(date);
    if (records.isEmpty) return 0;

    double score = 0;
    double totalCalories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;
    int mealCount = 0;

    for (var record in records) {
      totalCalories += record.calories;
      protein += record.protein;
      carbs += record.carbs;
      fat += record.fat;
      if (record.mealType >= 1 && record.mealType <= 3) {
        mealCount++;
      }
    }

    if (mealCount >= 3) {
      score += 8;
    } else if (mealCount >= 2) {
      score += 4;
    }

    if (totalCalories >= 1500 && totalCalories <= 2500) {
      score += 8;
    } else if (totalCalories >= 1200 && totalCalories <= 3000) {
      score += 4;
    }

    double totalNutrients = protein + carbs + fat;
    if (totalNutrients > 0) {
      double proteinRatio = protein / totalNutrients;
      double carbsRatio = carbs / totalNutrients;
      double fatRatio = fat / totalNutrients;

      if (proteinRatio >= 0.15 && proteinRatio <= 0.3) {
        score += 3;
      } else if (proteinRatio >= 0.1 && proteinRatio <= 0.35) {
        score += 2;
      }

      if (carbsRatio >= 0.4 && carbsRatio <= 0.6) {
        score += 3;
      } else if (carbsRatio >= 0.35 && carbsRatio <= 0.65) {
        score += 2;
      }

      if (fatRatio >= 0.2 && fatRatio <= 0.35) {
        score += 3;
      } else if (fatRatio >= 0.15 && fatRatio <= 0.4) {
        score += 2;
      }
    }

    return score.clamp(0, 25);
  }

  Future<double> calculateExerciseScore(String date) async {
    final records = await _dbService.getExerciseRecords(date);
    if (records.isEmpty) return 0;

    double score = 0;
    int totalDuration = 0;
    int totalIntensity = 0;

    for (var record in records) {
      totalDuration += record.duration;
      totalIntensity += record.intensity;
    }

    if (totalDuration >= 30) {
      score += 10;
    } else if (totalDuration >= 15) {
      score += 5;
    }

    double avgIntensity = totalIntensity / records.length;
    if (avgIntensity >= 3) {
      score += 8;
    } else if (avgIntensity >= 2) {
      score += 4;
    }

    for (var record in records) {
      if (record.type == 1) {
        score += 4;
        break;
      }
    }

    for (var record in records) {
      if (record.type == 2) {
        score += 3;
        break;
      }
    }

    return score.clamp(0, 25);
  }

  Future<double> calculateMoodScore(String date) async {
    final record = await _dbService.getMoodRecord(date);
    if (record == null) return 0;

    double score = 0;

    score += record.moodScore * 3;

    if (record.stressLevel <= 2) {
      score += 10;
    } else if (record.stressLevel <= 3) {
      score += 5;
    }

    if (record.gratitude != null && record.gratitude!.isNotEmpty) {
      score += 5;
    }

    return score.clamp(0, 25);
  }

  Future<List<String>> generateSuggestions(
      double sleepScore, double dietScore, double exerciseScore, double moodScore) async {
    List<String> suggestions = [];

    if (sleepScore < 15) {
      suggestions.add('建议保证每天7-9小时的睡眠时间');
      suggestions.add('保持规律的作息时间有助于提高睡眠质量');
    }

    if (dietScore < 15) {
      suggestions.add('建议每天三餐规律进食');
      suggestions.add('注意饮食均衡，合理搭配蛋白质、碳水和脂肪');
    }

    if (exerciseScore < 15) {
      suggestions.add('建议每天进行30分钟以上的运动');
      suggestions.add('有氧运动和力量训练相结合效果更佳');
    }

    if (moodScore < 15) {
      suggestions.add('保持积极心态，每天记录一件感恩的事');
      suggestions.add('适当进行冥想和放松训练');
    }

    return suggestions;
  }

  Future<DailyScore> calculateDailyScore(String date) async {
    double sleepScore = await calculateSleepScore(date);
    double dietScore = await calculateDietScore(date);
    double exerciseScore = await calculateExerciseScore(date);
    double moodScore = await calculateMoodScore(date);

    double totalScore = sleepScore + dietScore + exerciseScore + moodScore;

    List<String> suggestions = await generateSuggestions(
      sleepScore, dietScore, exerciseScore, moodScore
    );

    DailyScore dailyScore = DailyScore(
      date: date,
      sleepScore: sleepScore,
      dietScore: dietScore,
      exerciseScore: exerciseScore,
      moodScore: moodScore,
      totalScore: totalScore,
      suggestions: suggestions.join('||'),
    );

    await _dbService.insertDailyScore(dailyScore);

    return dailyScore;
  }

  Future<DailyScore?> getTodayScore() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var existing = await _dbService.getDailyScore(today);
    if (existing != null) return existing;
    return await calculateDailyScore(today);
  }
}