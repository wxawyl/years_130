import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'database_service.dart';
import 'web_database_service.dart';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/mood_record.dart';
import '../models/daily_score.dart';
import '../models/knowledge_item.dart';
import '../models/reminder.dart';
import '../models/ai_health_report.dart';
import '../models/user_settings.dart';

class DatabaseServiceUnified {
  static final DatabaseServiceUnified _instance = DatabaseServiceUnified._internal();
  factory DatabaseServiceUnified() => _instance;
  DatabaseServiceUnified._internal();

  DatabaseService? _nativeDb;
  WebDatabaseService? _webDb;

  Future<void> initDatabase() async {
    if (kIsWeb) {
      _webDb = WebDatabaseService();
      await _webDb!.initDatabase();
    } else {
      _nativeDb = DatabaseService();
      await _nativeDb!.initDatabase();
    }
  }

  // Sleep Records
  Future<int> insertSleepRecord(SleepRecord record) async {
    if (kIsWeb) {
      return await _webDb!.insertSleepRecord(record);
    } else {
      return await _nativeDb!.insertSleepRecord(record);
    }
  }

  Future<List<SleepRecord>> getSleepRecords(String date) async {
    if (kIsWeb) {
      return await _webDb!.getSleepRecords(date);
    } else {
      return await _nativeDb!.getSleepRecords(date);
    }
  }

  Future<List<SleepRecord>> getSleepRecordsForDays(int days) async {
    if (kIsWeb) {
      return await _webDb!.getSleepRecordsForDays(days);
    } else {
      return await _nativeDb!.getSleepRecordsForDays(days);
    }
  }

  Future<int> updateSleepRecord(SleepRecord record) async {
    if (kIsWeb) {
      return await _webDb!.updateSleepRecord(record);
    } else {
      return await _nativeDb!.updateSleepRecord(record);
    }
  }

  Future<int> deleteSleepRecord(int id) async {
    if (kIsWeb) {
      return await _webDb!.deleteSleepRecord(id);
    } else {
      return await _nativeDb!.deleteSleepRecord(id);
    }
  }

  // Diet Records
  Future<int> insertDietRecord(DietRecord record) async {
    if (kIsWeb) {
      return await _webDb!.insertDietRecord(record);
    } else {
      return await _nativeDb!.insertDietRecord(record);
    }
  }

  Future<List<DietRecord>> getDietRecords(String date) async {
    if (kIsWeb) {
      return await _webDb!.getDietRecords(date);
    } else {
      return await _nativeDb!.getDietRecords(date);
    }
  }

  Future<List<DietRecord>> getDietRecordsForDays(int days) async {
    if (kIsWeb) {
      return await _webDb!.getDietRecordsForDays(days);
    } else {
      return await _nativeDb!.getDietRecordsForDays(days);
    }
  }

  Future<int> updateDietRecord(DietRecord record) async {
    if (kIsWeb) {
      return await _webDb!.updateDietRecord(record);
    } else {
      return await _nativeDb!.updateDietRecord(record);
    }
  }

  Future<int> deleteDietRecord(int id) async {
    if (kIsWeb) {
      return await _webDb!.deleteDietRecord(id);
    } else {
      return await _nativeDb!.deleteDietRecord(id);
    }
  }

  // Exercise Records
  Future<int> insertExerciseRecord(ExerciseRecord record) async {
    if (kIsWeb) {
      return await _webDb!.insertExerciseRecord(record);
    } else {
      return await _nativeDb!.insertExerciseRecord(record);
    }
  }

  Future<List<ExerciseRecord>> getExerciseRecords(String date) async {
    if (kIsWeb) {
      return await _webDb!.getExerciseRecords(date);
    } else {
      return await _nativeDb!.getExerciseRecords(date);
    }
  }

  Future<List<ExerciseRecord>> getExerciseRecordsForDays(int days) async {
    if (kIsWeb) {
      return await _webDb!.getExerciseRecordsForDays(days);
    } else {
      return await _nativeDb!.getExerciseRecordsForDays(days);
    }
  }

  Future<int> updateExerciseRecord(ExerciseRecord record) async {
    if (kIsWeb) {
      return await _webDb!.updateExerciseRecord(record);
    } else {
      return await _nativeDb!.updateExerciseRecord(record);
    }
  }

  Future<int> deleteExerciseRecord(int id) async {
    if (kIsWeb) {
      return await _webDb!.deleteExerciseRecord(id);
    } else {
      return await _nativeDb!.deleteExerciseRecord(id);
    }
  }

  // Mood Records
  Future<int> insertMoodRecord(MoodRecord record) async {
    if (kIsWeb) {
      return await _webDb!.insertMoodRecord(record);
    } else {
      return await _nativeDb!.insertMoodRecord(record);
    }
  }

  Future<List<MoodRecord>> getMoodRecords(String date) async {
    if (kIsWeb) {
      return await _webDb!.getMoodRecords(date);
    } else {
      return await _nativeDb!.getMoodRecords(date);
    }
  }

  Future<List<MoodRecord>> getMoodRecordsForDays(int days) async {
    if (kIsWeb) {
      return await _webDb!.getMoodRecordsForDays(days);
    } else {
      return await _nativeDb!.getMoodRecordsForDays(days);
    }
  }

  Future<MoodRecord?> getMoodRecord(String date) async {
    if (kIsWeb) {
      return await _webDb!.getMoodRecord(date);
    } else {
      return await _nativeDb!.getMoodRecord(date);
    }
  }

  Future<int> updateMoodRecord(MoodRecord record) async {
    if (kIsWeb) {
      return await _webDb!.updateMoodRecord(record);
    } else {
      return await _nativeDb!.updateMoodRecord(record);
    }
  }

  Future<int> deleteMoodRecord(int id) async {
    if (kIsWeb) {
      return await _webDb!.deleteMoodRecord(id);
    } else {
      return await _nativeDb!.deleteMoodRecord(id);
    }
  }

  // Daily Scores
  Future<int> insertDailyScore(DailyScore score) async {
    if (kIsWeb) {
      return await _webDb!.insertDailyScore(score);
    } else {
      return await _nativeDb!.insertDailyScore(score);
    }
  }

  Future<DailyScore?> getDailyScore(String date) async {
    if (kIsWeb) {
      return await _webDb!.getDailyScore(date);
    } else {
      return await _nativeDb!.getDailyScore(date);
    }
  }

  Future<List<DailyScore>> getDailyScoresForDays(int days) async {
    if (kIsWeb) {
      return await _webDb!.getDailyScoresForDays(days);
    } else {
      return await _nativeDb!.getDailyScoresForDays(days);
    }
  }

  // AI Reports
  Future<int> insertAIReport(AIHealthReport report) async {
    if (kIsWeb) {
      return await _webDb!.insertAIReport(report);
    } else {
      return await _nativeDb!.insertAIReport(report);
    }
  }

  Future<AIHealthReport?> getAIReport(String date) async {
    if (kIsWeb) {
      return await _webDb!.getAIReport(date);
    } else {
      return await _nativeDb!.getAIReport(date);
    }
  }

  Future<List<AIHealthReport>> getAIReportsForDays(int days) async {
    if (kIsWeb) {
      return await _webDb!.getAIReportsForDays(days);
    } else {
      return await _nativeDb!.getAIReportsForDays(days);
    }
  }

  // Knowledge Base
  Future<List<KnowledgeItem>> getKnowledgeByCategory(int category) async {
    if (kIsWeb) {
      return await _webDb!.getKnowledgeByCategory(category);
    } else {
      return await _nativeDb!.getKnowledgeByCategory(category);
    }
  }

  // Reminders
  Future<List<Reminder>> getAllReminders() async {
    if (kIsWeb) {
      return await _webDb!.getAllReminders();
    } else {
      return await _nativeDb!.getAllReminders();
    }
  }

  Future<int> updateReminder(Reminder reminder) async {
    if (kIsWeb) {
      return await _webDb!.updateReminder(reminder);
    } else {
      return await _nativeDb!.updateReminder(reminder);
    }
  }

  // User Settings
  Future<int> insertUserSettings(UserSettings settings) async {
    if (kIsWeb) {
      return await _webDb!.insertUserSettings(settings);
    } else {
      return await _nativeDb!.insertUserSettings(settings);
    }
  }

  Future<UserSettings?> getUserSettings() async {
    if (kIsWeb) {
      return await _webDb!.getUserSettings();
    } else {
      return await _nativeDb!.getUserSettings();
    }
  }

  Future<int> updateUserSettings(UserSettings settings) async {
    if (kIsWeb) {
      return await _webDb!.updateUserSettings(settings);
    } else {
      return await _nativeDb!.updateUserSettings(settings);
    }
  }

  // Habit Tracking
  Future<int> insertHabitTracking(int habitId, String habitName, String date, int completed) async {
    if (kIsWeb) {
      return await _webDb!.insertHabitTracking(habitId, habitName, date, completed);
    } else {
      return await _nativeDb!.insertHabitTracking(habitId, habitName, date, completed);
    }
  }

  Future<int> updateHabitTracking(int habitId, String date, int completed) async {
    if (kIsWeb) {
      return await _webDb!.updateHabitTracking(habitId, date, completed);
    } else {
      return await _nativeDb!.updateHabitTracking(habitId, date, completed);
    }
  }

  Future<int?> getHabitCompletion(int habitId, String date) async {
    if (kIsWeb) {
      return await _webDb!.getHabitCompletion(habitId, date);
    } else {
      return await _nativeDb!.getHabitCompletion(habitId, date);
    }
  }
}
