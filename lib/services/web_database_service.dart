import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/mood_record.dart';
import '../models/daily_score.dart';
import '../models/knowledge_item.dart';
import '../models/reminder.dart';
import '../models/ai_health_report.dart';
import '../models/user_settings.dart';

class WebDatabaseService {
  static const String _sleepRecordsKey = 'sleep_records';
  static const String _dietRecordsKey = 'diet_records';
  static const String _exerciseRecordsKey = 'exercise_records';
  static const String _moodRecordsKey = 'mood_records';
  static const String _dailyScoresKey = 'daily_scores';
  static const String _aiReportsKey = 'ai_reports';
  static const String _userSettingsKey = 'user_settings';
  static const String _remindersKey = 'reminders';
  static const String _knowledgeKey = 'knowledge_base';
  static const String _initializedKey = 'db_initialized';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<void> initDatabase() async {
    final prefs = await _prefs;
    final initialized = prefs.getBool(_initializedKey) ?? false;
    if (!initialized) {
      await _insertInitialKnowledge();
      await _insertInitialReminders();
      await prefs.setBool(_initializedKey, true);
    }
  }

  Future<void> _insertInitialKnowledge() async {
    final prefs = await _prefs;
    List<Map<String, dynamic>> knowledgeItems = [
      {
        'id': 1,
        'category': 1,
        'title': '良好睡眠的重要性',
        'content': '睡眠是身体修复和充电的时间。成年人建议每天睡7-9小时。深度睡眠有助于记忆巩固和身体恢复。',
        'source': '世界卫生组织'
      },
      {
        'id': 2,
        'category': 1,
        'title': '改善睡眠质量的方法',
        'content': '保持规律的睡眠时间，创建舒适的睡眠环境，避免睡前使用电子设备，限制咖啡因摄入。',
        'source': '睡眠研究中心'
      },
      {
        'id': 3,
        'category': 2,
        'title': '均衡饮食的原则',
        'content': '每天摄入适量的蛋白质、碳水化合物和健康脂肪。多吃蔬菜和水果，保证营养均衡。',
        'source': '中国营养学会'
      },
      {
        'id': 4,
        'category': 2,
        'title': '健康饮水习惯',
        'content': '每天饮水量建议为1500-2000毫升。分多次小口饮用，避免一次性大量饮水。',
        'source': '健康指南'
      },
      {
        'id': 5,
        'category': 3,
        'title': '有氧运动的好处',
        'content': '有氧运动可以增强心肺功能，提高新陈代谢，有助于减肥和保持健康体重。',
        'source': '运动医学杂志'
      },
      {
        'id': 6,
        'category': 3,
        'title': '适度运动的建议',
        'content': '每周至少进行150分钟中等强度有氧运动，或75分钟高强度运动。结合力量训练效果更佳。',
        'source': '美国心脏协会'
      },
      {
        'id': 7,
        'category': 4,
        'title': '保持良好心态的方法',
        'content': '学会感恩，保持积极乐观的心态，定期进行冥想和放松训练，与他人保持良好关系。',
        'source': '心理健康协会'
      },
      {
        'id': 8,
        'category': 4,
        'title': '压力管理技巧',
        'content': '通过运动、冥想、深呼吸等方式缓解压力。学会说\"不\"，合理安排工作和休息时间。',
        'source': '心理研究中心'
      }
    ];
    await prefs.setString(_knowledgeKey, jsonEncode(knowledgeItems));
  }

  Future<void> _insertInitialReminders() async {
    final prefs = await _prefs;
    List<Map<String, dynamic>> reminders = [
      {'id': 1, 'type': 1, 'time': '22:30', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '该睡觉了，保持规律作息有助于健康！'},
      {'id': 2, 'type': 2, 'time': '09:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '记得喝水，保持身体水分平衡'},
      {'id': 3, 'type': 2, 'time': '11:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '休息一下，喝杯水吧'},
      {'id': 4, 'type': 2, 'time': '15:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '下午好，记得补充水分'},
      {'id': 5, 'type': 2, 'time': '17:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '下班前再喝一杯水'},
      {'id': 6, 'type': 3, 'time': '07:00', 'enabled': 0, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '早上好，该运动了！'},
      {'id': 7, 'type': 4, 'time': '20:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '放松一下，进行冥想练习吧'}
    ];
    await prefs.setString(_remindersKey, jsonEncode(reminders));
  }

  Future<List<Map<String, dynamic>>> _getList(String key) async {
    final prefs = await _prefs;
    final data = prefs.getString(key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  Future<void> _saveList(String key, List<Map<String, dynamic>> list) async {
    final prefs = await _prefs;
    await prefs.setString(key, jsonEncode(list));
  }

  Future<int> _getNextId(String key) async {
    final list = await _getList(key);
    if (list.isEmpty) return 1;
    return list.map((item) => item['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
  }

  // Sleep Records
  Future<int> insertSleepRecord(SleepRecord record) async {
    final list = await _getList(_sleepRecordsKey);
    final id = await _getNextId(_sleepRecordsKey);
    final map = record.toMap();
    map['id'] = id;
    list.add(map);
    await _saveList(_sleepRecordsKey, list);
    return id;
  }

  Future<List<SleepRecord>> getSleepRecords(String date) async {
    final list = await _getList(_sleepRecordsKey);
    return list
        .where((item) => item['date'] == date)
        .map((item) => SleepRecord.fromMap(item))
        .toList();
  }

  Future<List<SleepRecord>> getSleepRecordsForDays(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final list = await _getList(_sleepRecordsKey);
    return list
        .where((item) => item['date'].compareTo(startDateStr) >= 0)
        .map((item) => SleepRecord.fromMap(item))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<int> updateSleepRecord(SleepRecord record) async {
    final list = await _getList(_sleepRecordsKey);
    final index = list.indexWhere((item) => item['id'] == record.id);
    if (index != -1) {
      list[index] = record.toMap();
      await _saveList(_sleepRecordsKey, list);
    }
    return record.id ?? 0;
  }

  Future<int> deleteSleepRecord(int id) async {
    final list = await _getList(_sleepRecordsKey);
    list.removeWhere((item) => item['id'] == id);
    await _saveList(_sleepRecordsKey, list);
    return id;
  }

  // Diet Records
  Future<int> insertDietRecord(DietRecord record) async {
    final list = await _getList(_dietRecordsKey);
    final id = await _getNextId(_dietRecordsKey);
    final map = record.toMap();
    map['id'] = id;
    list.add(map);
    await _saveList(_dietRecordsKey, list);
    return id;
  }

  Future<List<DietRecord>> getDietRecords(String date) async {
    final list = await _getList(_dietRecordsKey);
    return list
        .where((item) => item['date'] == date)
        .map((item) => DietRecord.fromMap(item))
        .toList();
  }

  Future<List<DietRecord>> getDietRecordsForDays(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final list = await _getList(_dietRecordsKey);
    return list
        .where((item) => item['date'].compareTo(startDateStr) >= 0)
        .map((item) => DietRecord.fromMap(item))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<int> updateDietRecord(DietRecord record) async {
    final list = await _getList(_dietRecordsKey);
    final index = list.indexWhere((item) => item['id'] == record.id);
    if (index != -1) {
      list[index] = record.toMap();
      await _saveList(_dietRecordsKey, list);
    }
    return record.id ?? 0;
  }

  Future<int> deleteDietRecord(int id) async {
    final list = await _getList(_dietRecordsKey);
    list.removeWhere((item) => item['id'] == id);
    await _saveList(_dietRecordsKey, list);
    return id;
  }

  // Exercise Records
  Future<int> insertExerciseRecord(ExerciseRecord record) async {
    final list = await _getList(_exerciseRecordsKey);
    final id = await _getNextId(_exerciseRecordsKey);
    final map = record.toMap();
    map['id'] = id;
    list.add(map);
    await _saveList(_exerciseRecordsKey, list);
    return id;
  }

  Future<List<ExerciseRecord>> getExerciseRecords(String date) async {
    final list = await _getList(_exerciseRecordsKey);
    return list
        .where((item) => item['date'] == date)
        .map((item) => ExerciseRecord.fromMap(item))
        .toList();
  }

  Future<List<ExerciseRecord>> getExerciseRecordsForDays(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final list = await _getList(_exerciseRecordsKey);
    return list
        .where((item) => item['date'].compareTo(startDateStr) >= 0)
        .map((item) => ExerciseRecord.fromMap(item))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<int> updateExerciseRecord(ExerciseRecord record) async {
    final list = await _getList(_exerciseRecordsKey);
    final index = list.indexWhere((item) => item['id'] == record.id);
    if (index != -1) {
      list[index] = record.toMap();
      await _saveList(_exerciseRecordsKey, list);
    }
    return record.id ?? 0;
  }

  Future<int> deleteExerciseRecord(int id) async {
    final list = await _getList(_exerciseRecordsKey);
    list.removeWhere((item) => item['id'] == id);
    await _saveList(_exerciseRecordsKey, list);
    return id;
  }

  // Mood Records
  Future<int> insertMoodRecord(MoodRecord record) async {
    final list = await _getList(_moodRecordsKey);
    final id = await _getNextId(_moodRecordsKey);
    final map = record.toMap();
    map['id'] = id;
    list.add(map);
    await _saveList(_moodRecordsKey, list);
    return id;
  }

  Future<List<MoodRecord>> getMoodRecords(String date) async {
    final list = await _getList(_moodRecordsKey);
    return list
        .where((item) => item['date'] == date)
        .map((item) => MoodRecord.fromMap(item))
        .toList();
  }

  Future<List<MoodRecord>> getMoodRecordsForDays(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final list = await _getList(_moodRecordsKey);
    return list
        .where((item) => item['date'].compareTo(startDateStr) >= 0)
        .map((item) => MoodRecord.fromMap(item))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<MoodRecord?> getMoodRecord(String date) async {
    final list = await _getList(_moodRecordsKey);
    final items = list.where((item) => item['date'] == date).toList();
    if (items.isEmpty) return null;
    return MoodRecord.fromMap(items.first);
  }

  Future<int> updateMoodRecord(MoodRecord record) async {
    final list = await _getList(_moodRecordsKey);
    final index = list.indexWhere((item) => item['id'] == record.id);
    if (index != -1) {
      list[index] = record.toMap();
      await _saveList(_moodRecordsKey, list);
    }
    return record.id ?? 0;
  }

  Future<int> deleteMoodRecord(int id) async {
    final list = await _getList(_moodRecordsKey);
    list.removeWhere((item) => item['id'] == id);
    await _saveList(_moodRecordsKey, list);
    return id;
  }

  // Daily Scores
  Future<int> insertDailyScore(DailyScore score) async {
    final list = await _getList(_dailyScoresKey);
    final id = await _getNextId(_dailyScoresKey);
    final map = score.toMap();
    map['id'] = id;
    list.add(map);
    await _saveList(_dailyScoresKey, list);
    return id;
  }

  Future<DailyScore?> getDailyScore(String date) async {
    final list = await _getList(_dailyScoresKey);
    final items = list.where((item) => item['date'] == date).toList();
    if (items.isEmpty) return null;
    return DailyScore.fromMap(items.first);
  }

  Future<List<DailyScore>> getDailyScoresForDays(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final list = await _getList(_dailyScoresKey);
    return list
        .where((item) => item['date'].compareTo(startDateStr) >= 0)
        .map((item) => DailyScore.fromMap(item))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // AI Reports
  Future<int> insertAIReport(AIHealthReport report) async {
    final list = await _getList(_aiReportsKey);
    final id = await _getNextId(_aiReportsKey);
    final map = report.toMap();
    map['id'] = id;
    list.add(map);
    await _saveList(_aiReportsKey, list);
    return id;
  }

  Future<AIHealthReport?> getAIReport(String date) async {
    final list = await _getList(_aiReportsKey);
    final items = list.where((item) => item['date'] == date).toList();
    if (items.isEmpty) return null;
    return AIHealthReport.fromMap(items.first);
  }

  Future<List<AIHealthReport>> getAIReportsForDays(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final list = await _getList(_aiReportsKey);
    return list
        .where((item) => item['date'].compareTo(startDateStr) >= 0)
        .map((item) => AIHealthReport.fromMap(item))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Knowledge Base
  Future<List<KnowledgeItem>> getKnowledgeByCategory(int category) async {
    final list = await _getList(_knowledgeKey);
    return list
        .where((item) => item['category'] == category)
        .map((item) => KnowledgeItem.fromMap(item))
        .toList();
  }

  // Reminders
  Future<List<Reminder>> getAllReminders() async {
    final list = await _getList(_remindersKey);
    return list.map((item) => Reminder.fromMap(item)).toList();
  }

  Future<int> updateReminder(Reminder reminder) async {
    final list = await _getList(_remindersKey);
    final index = list.indexWhere((item) => item['id'] == reminder.id);
    if (index != -1) {
      list[index] = reminder.toMap();
      await _saveList(_remindersKey, list);
    }
    return reminder.id ?? 0;
  }

  // User Settings
  Future<int> insertUserSettings(UserSettings settings) async {
    final prefs = await _prefs;
    final now = DateTime.now().toIso8601String();
    settings.createdAt = now;
    settings.updatedAt = now;
    settings.id = 1;
    await prefs.setString(_userSettingsKey, jsonEncode(settings.toMap()));
    return 1;
  }

  Future<UserSettings?> getUserSettings() async {
    final prefs = await _prefs;
    final data = prefs.getString(_userSettingsKey);
    if (data == null) return null;
    return UserSettings.fromMap(jsonDecode(data));
  }

  Future<int> updateUserSettings(UserSettings settings) async {
    final prefs = await _prefs;
    settings.updatedAt = DateTime.now().toIso8601String();
    settings.id = 1;
    await prefs.setString(_userSettingsKey, jsonEncode(settings.toMap()));
    return 1;
  }

  // Habit Tracking (simplified)
  Future<int> insertHabitTracking(int habitId, String habitName, String date, int completed) async {
    return 1;
  }

  Future<int> updateHabitTracking(int habitId, String date, int completed) async {
    return 1;
  }

  Future<int?> getHabitCompletion(int habitId, String date) async {
    return null;
  }
}
