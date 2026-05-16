import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/voice_diary_record.dart';
import '../models/daily_score.dart';
import '../models/knowledge_item.dart';
import '../models/reminder.dart';
import '../models/meditation_music.dart';
import '../models/user_profile.dart';
import '../models/health_vector.dart';
import '../models/health_anomaly.dart';
import '../models/smart_reminder.dart';

class MemoryDatabase {
  static MemoryDatabase? _instance;
  List<Map<String, dynamic>> _sleepRecords = [];
  List<Map<String, dynamic>> _dietRecords = [];
  List<Map<String, dynamic>> _exerciseRecords = [];
  List<Map<String, dynamic>> _voiceDiaries = [];
  List<Map<String, dynamic>> _dailyScores = [];
  List<Map<String, dynamic>> _knowledgeBase = [];
  List<Map<String, dynamic>> _reminders = [];
  List<Map<String, dynamic>> _habitTracking = [];
  List<Map<String, dynamic>> _sharePosts = [];
  List<Map<String, dynamic>> _customMusic = [];
  List<Map<String, dynamic>> _healthVectors = [];
  List<Map<String, dynamic>> _healthAnomalies = [];
  List<Map<String, dynamic>> _smartReminders = [];
  Map<String, dynamic>? _userProfile;
  int _nextId = 1;
  bool _isInitialized = false;

  MemoryDatabase._();

  factory MemoryDatabase() {
    _instance ??= MemoryDatabase._();
    return _instance!;
  }

  int _generateId() => _nextId++;

  Future<void> _initializeIfNeeded() async {
    if (_isInitialized) return;
    
    _knowledgeBase = [
      {'id': _generateId(), 'category': 1, 'title': '良好睡眠的重要性', 'content': '睡眠是身体修复和充电的时间。成年人建议每天睡7-9小时。深度睡眠有助于记忆巩固和身体恢复。', 'source': '世界卫生组织', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'category': 1, 'title': '改善睡眠质量的方法', 'content': '保持规律的睡眠时间，创建舒适的睡眠环境，避免睡前使用电子设备，限制咖啡因摄入。', 'source': '睡眠研究中心', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'category': 2, 'title': '均衡饮食的原则', 'content': '每天摄入适量的蛋白质、碳水化合物和健康脂肪。多吃蔬菜和水果，保证营养均衡。', 'source': '中国营养学会', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'category': 2, 'title': '健康饮水习惯', 'content': '每天饮水量建议为1500-2000毫升。分多次小口饮用，避免一次性大量饮水。', 'source': '健康指南', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'category': 3, 'title': '有氧运动的好处', 'content': '有氧运动可以增强心肺功能，提高新陈代谢，有助于减肥和保持健康体重。', 'source': '运动医学杂志', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'category': 3, 'title': '适度运动的建议', 'content': '每周至少进行150分钟中等强度有氧运动，或75分钟高强度运动。结合力量训练效果更佳。', 'source': '美国心脏协会', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'category': 4, 'title': '保持良好心态的方法', 'content': '学会感恩，保持积极乐观的心态，定期进行冥想和放松训练，与他人保持良好关系。', 'source': '心理健康协会', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'category': 4, 'title': '压力管理技巧', 'content': '通过运动、冥想、深呼吸等方式缓解压力。学会说"不"，合理安排工作和休息时间。', 'source': '心理研究中心', 'is_video': 0, 'url': '', 'created_at': DateTime.now().toIso8601String()},
    ];

    _reminders = [
      {'id': _generateId(), 'type': 1, 'time': '22:30', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '该睡觉了，保持规律作息有助于健康！', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'type': 2, 'time': '09:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '记得喝水，保持身体水分平衡', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'type': 2, 'time': '11:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '休息一下，喝杯水吧', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'type': 2, 'time': '15:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '下午好，记得补充水分', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'type': 2, 'time': '17:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '下班前再喝一杯水', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'type': 3, 'time': '07:00', 'enabled': 0, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '早上好，该运动了！', 'created_at': DateTime.now().toIso8601String()},
      {'id': _generateId(), 'type': 4, 'time': '20:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '放松一下，进行冥想练习吧', 'created_at': DateTime.now().toIso8601String()},
    ];

    _isInitialized = true;
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    await _initializeIfNeeded();
    data['id'] = _generateId();
    data['created_at'] = DateTime.now().toIso8601String();
    
    switch (table) {
      case 'sleep_records':
        _sleepRecords.add(data);
        break;
      case 'diet_records':
        _dietRecords.add(data);
        break;
      case 'exercise_records':
        _exerciseRecords.add(data);
        break;
      case 'voice_diaries':
        _voiceDiaries.add(data);
        break;
      case 'daily_scores':
        _dailyScores.add(data);
        break;
      case 'habit_tracking':
        _habitTracking.add(data);
        break;
      case 'share_posts':
        _sharePosts.add(data);
        break;
      case 'custom_music':
        _customMusic.add(data);
        break;
      case 'health_vectors':
        _healthVectors.add(data);
        break;
      case 'health_anomalies':
        _healthAnomalies.add(data);
        break;
      case 'smart_reminders':
        _smartReminders.add(data);
        break;
    }
    return data['id'];
  }

  Future<void> saveUserProfile(Map<String, dynamic> data) async {
    await _initializeIfNeeded();
    if (_userProfile == null) {
      data['id'] = 1;
      data['created_at'] = DateTime.now().toIso8601String();
    }
    data['updated_at'] = DateTime.now().toIso8601String();
    _userProfile = {...?_userProfile, ...data};
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    await _initializeIfNeeded();
    return _userProfile;
  }

  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs, int? limit}) async {
    await _initializeIfNeeded();
    List<Map<String, dynamic>> records;
    
    switch (table) {
      case 'sleep_records':
        records = List.from(_sleepRecords);
        break;
      case 'diet_records':
        records = List.from(_dietRecords);
        break;
      case 'exercise_records':
        records = List.from(_exerciseRecords);
        break;
      case 'voice_diaries':
        records = List.from(_voiceDiaries);
        break;
      case 'daily_scores':
        records = List.from(_dailyScores);
        break;
      case 'knowledge_base':
        records = List.from(_knowledgeBase);
        break;
      case 'reminders':
        records = List.from(_reminders);
        break;
      case 'habit_tracking':
        records = List.from(_habitTracking);
        break;
      case 'share_posts':
        records = List.from(_sharePosts);
        break;
      case 'custom_music':
        records = List.from(_customMusic);
        break;
      case 'health_vectors':
        records = List.from(_healthVectors);
        break;
      case 'health_anomalies':
        records = List.from(_healthAnomalies);
        break;
      case 'smart_reminders':
        records = List.from(_smartReminders);
        break;
      default:
        records = [];
    }

    if (where != null && whereArgs != null) {
      records = records.where((record) {
        if (where.contains('date = ?')) {
          return record['date'] == whereArgs[0];
        }
        if (where.contains('date >= ?')) {
          return record['date'] != null && record['date'].compareTo(whereArgs[0]) >= 0;
        }
        if (where.contains('category = ?')) {
          return record['category'] == whereArgs[0];
        }
        if (where.contains('habit_id = ? AND date = ?')) {
          return record['habit_id'] == whereArgs[0] && record['date'] == whereArgs[1];
        }
        if (where.contains('id = ?')) {
          return record['id'] == whereArgs[0];
        }
        return true;
      }).toList();
    }

    if (limit != null) {
      records = records.take(limit).toList();
    }

    return records;
  }

  Future<int> update(String table, Map<String, dynamic> data, {String? where, List<dynamic>? whereArgs}) async {
    await _initializeIfNeeded();
    int updated = 0;
    int id = whereArgs?.first ?? data['id'];

    switch (table) {
      case 'sleep_records':
        updated = _updateRecord(_sleepRecords, data, id);
        break;
      case 'diet_records':
        updated = _updateRecord(_dietRecords, data, id);
        break;
      case 'exercise_records':
        updated = _updateRecord(_exerciseRecords, data, id);
        break;
      case 'voice_diaries':
        updated = _updateRecord(_voiceDiaries, data, id);
        break;
      case 'reminders':
        updated = _updateRecord(_reminders, data, id);
        break;
      case 'habit_tracking':
        if (where?.contains('habit_id = ? AND date = ?') ?? false) {
          final habitId = whereArgs?[0];
          final date = whereArgs?[1];
          for (var i = 0; i < _habitTracking.length; i++) {
            if (_habitTracking[i]['habit_id'] == habitId && _habitTracking[i]['date'] == date) {
              _habitTracking[i] = {..._habitTracking[i], ...data};
              updated = 1;
              break;
            }
          }
        }
        break;
      case 'health_vectors':
        updated = _updateRecord(_healthVectors, data, id);
        break;
      case 'health_anomalies':
        updated = _updateRecord(_healthAnomalies, data, id);
        break;
      case 'smart_reminders':
        updated = _updateRecord(_smartReminders, data, id);
        break;
    }
    return updated;
  }

  int _updateRecord(List<Map<String, dynamic>> records, Map<String, dynamic> data, int id) {
    for (var i = 0; i < records.length; i++) {
      if (records[i]['id'] == id) {
        records[i] = {...records[i], ...data};
        return 1;
      }
    }
    return 0;
  }

  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    await _initializeIfNeeded();
    int id = whereArgs?.first ?? 0;
    int deleted = 0;

    switch (table) {
      case 'sleep_records':
        deleted = _deleteRecord(_sleepRecords, id);
        break;
      case 'diet_records':
        deleted = _deleteRecord(_dietRecords, id);
        break;
      case 'exercise_records':
        deleted = _deleteRecord(_exerciseRecords, id);
        break;
      case 'voice_diaries':
        deleted = _deleteRecord(_voiceDiaries, id);
        break;
      case 'custom_music':
        deleted = _deleteRecord(_customMusic, id);
        break;
      case 'health_vectors':
        deleted = _deleteRecord(_healthVectors, id);
        break;
      case 'health_anomalies':
        deleted = _deleteRecord(_healthAnomalies, id);
        break;
      case 'smart_reminders':
        deleted = _deleteRecord(_smartReminders, id);
        break;
    }
    return deleted;
  }

  int _deleteRecord(List<Map<String, dynamic>> records, int id) {
    int initialLength = records.length;
    records.removeWhere((r) => r['id'] == id);
    return initialLength - records.length;
  }
}

class DatabaseService {
  static MemoryDatabase? _memoryDb;

  Future<dynamic> get database async {
    _memoryDb ??= MemoryDatabase();
    await _memoryDb!._initializeIfNeeded();
    return _memoryDb!;
  }

  Future<void> generateDemoData() async {
    final db = await database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));

    await db.insert('sleep_records', {
      'date': today,
      'bed_time': '22:30',
      'wake_time': '06:30',
      'duration': 8.0,
      'quality': 4,
      'deep_sleep_ratio': 0.25,
    });

    await db.insert('diet_records', {
      'date': today,
      'meal_type': 1,
      'food_name': '燕麦粥+鸡蛋',
      'calories': 350,
      'protein': 15,
      'carbs': 45,
      'fat': 10,
      'servings': 1,
    });

    await db.insert('exercise_records', {
      'date': today,
      'type': 1,
      'sub_type': '跑步',
      'duration': 30,
      'intensity': 4,
      'calories_burned': 200,
    });
  }

  Future<int> insertSleepRecord(SleepRecord record) async {
    final db = await database;
    return await db.insert('sleep_records', record.toMap());
  }

  Future<List<SleepRecord>> getSleepRecords(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sleep_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => SleepRecord.fromMap(maps[i]));
  }

  Future<int> updateSleepRecord(SleepRecord record) async {
    final db = await database;
    return await db.update(
      'sleep_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteSleepRecord(int id) async {
    final db = await database;
    return await db.delete(
      'sleep_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<SleepRecord>> getSleepRecordsByDateRange(String startDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sleep_records',
      where: 'date >= ?',
      whereArgs: [startDate],
    );
    return List.generate(maps.length, (i) => SleepRecord.fromMap(maps[i]));
  }

  Future<int> insertDietRecord(DietRecord record) async {
    final db = await database;
    return await db.insert('diet_records', record.toMap());
  }

  Future<List<DietRecord>> getDietRecords(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diet_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => DietRecord.fromMap(maps[i]));
  }

  Future<int> updateDietRecord(DietRecord record) async {
    final db = await database;
    return await db.update(
      'diet_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteDietRecord(int id) async {
    final db = await database;
    return await db.delete(
      'diet_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<DietRecord>> getDietRecordsByDateRange(String startDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diet_records',
      where: 'date >= ?',
      whereArgs: [startDate],
    );
    return List.generate(maps.length, (i) => DietRecord.fromMap(maps[i]));
  }

  Future<int> insertExerciseRecord(ExerciseRecord record) async {
    final db = await database;
    return await db.insert('exercise_records', record.toMap());
  }

  Future<List<ExerciseRecord>> getExerciseRecords(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise_records',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => ExerciseRecord.fromMap(maps[i]));
  }

  Future<int> updateExerciseRecord(ExerciseRecord record) async {
    final db = await database;
    return await db.update(
      'exercise_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteExerciseRecord(int id) async {
    final db = await database;
    return await db.delete(
      'exercise_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ExerciseRecord>> getExerciseRecordsByDateRange(String startDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise_records',
      where: 'date >= ?',
      whereArgs: [startDate],
    );
    return List.generate(maps.length, (i) => ExerciseRecord.fromMap(maps[i]));
  }

  Future<int> insertVoiceDiary(VoiceDiaryRecord record) async {
    final db = await database;
    return await db.insert('voice_diaries', record.toMap());
  }

  Future<List<VoiceDiaryRecord>> getVoiceDiaries(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voice_diaries',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => VoiceDiaryRecord.fromMap(maps[i]));
  }

  Future<VoiceDiaryRecord?> getVoiceDiary(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voice_diaries',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return VoiceDiaryRecord.fromMap(maps.first);
  }

  Future<int> updateVoiceDiary(VoiceDiaryRecord record) async {
    final db = await database;
    return await db.update(
      'voice_diaries',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteVoiceDiary(int id) async {
    final db = await database;
    return await db.delete(
      'voice_diaries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<VoiceDiaryRecord>> getVoiceDiariesByDateRange(String startDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voice_diaries',
      where: 'date >= ?',
      whereArgs: [startDate],
    );
    return List.generate(maps.length, (i) => VoiceDiaryRecord.fromMap(maps[i]));
  }

  Future<int> insertDailyScore(DailyScore score) async {
    final db = await database;
    return await db.insert('daily_scores', score.toMap());
  }

  Future<DailyScore?> getDailyScore(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_scores',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return DailyScore.fromMap(maps.first);
  }

  Future<List<KnowledgeItem>> getKnowledgeByCategory(int category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'knowledge_base',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => KnowledgeItem.fromMap(maps[i]));
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> insertHabitTracking(int habitId, String habitName, String date, int completed) async {
    final db = await database;
    return await db.insert('habit_tracking', {
      'habit_id': habitId,
      'habit_name': habitName,
      'date': date,
      'completed': completed,
    });
  }

  Future<int> updateHabitTracking(int habitId, String date, int completed) async {
    final db = await database;
    return await db.update(
      'habit_tracking',
      {'completed': completed},
      where: 'habit_id = ? AND date = ?',
      whereArgs: [habitId, date],
    );
  }

  Future<int?> getHabitCompletion(int habitId, String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_tracking',
      where: 'habit_id = ? AND date = ?',
      whereArgs: [habitId, date],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first['completed'] as int;
  }

  Future<int> insertCustomMusic(MeditationMusic music) async {
    final db = await database;
    return await db.insert('custom_music', music.toMap());
  }

  Future<List<MeditationMusic>> getCustomMusic() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('custom_music');
    return List.generate(maps.length, (i) => MeditationMusic.fromMap(maps[i]));
  }

  Future<int> deleteCustomMusic(String musicId) async {
    final db = await database;
    return await db.delete(
      'custom_music',
      where: 'id = ?',
      whereArgs: [musicId],
    );
  }

  Future<int> updateCustomMusic(MeditationMusic music) async {
    final db = await database;
    return await db.update(
      'custom_music',
      music.toMap(),
      where: 'music_id = ?',
      whereArgs: [music.id],
    );
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await database;
    await db.saveUserProfile(profile.toMap());
  }

  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final map = await db.getUserProfile();
    if (map == null) return null;
    return UserProfile.fromMap(map);
  }

  Future<int> insertHealthVector(HealthVector vector) async {
    final db = await database;
    return await db.insert('health_vectors', vector.toMap());
  }

  Future<List<HealthVector>> getHealthVectors({String? date, int? recordType, int? limit}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    
    if (date != null) {
      maps = await db.query(
        'health_vectors',
        where: 'date = ?',
        whereArgs: [date],
        limit: limit,
      );
    } else if (recordType != null) {
      maps = await db.query(
        'health_vectors',
        where: 'record_type = ?',
        whereArgs: [recordType],
        limit: limit,
      );
    } else {
      maps = await db.query('health_vectors', limit: limit);
    }
    
    return List.generate(maps.length, (i) => HealthVector.fromMap(maps[i]));
  }

  Future<List<HealthVector>> getHealthVectorsByDateRange(String startDate) async {
    final db = await database;
    final maps = await db.query(
      'health_vectors',
      where: 'date >= ?',
      whereArgs: [startDate],
    );
    return List.generate(maps.length, (i) => HealthVector.fromMap(maps[i]));
  }

  Future<int> updateHealthVector(HealthVector vector) async {
    final db = await database;
    return await db.update(
      'health_vectors',
      vector.toMap(),
      where: 'id = ?',
      whereArgs: [vector.id],
    );
  }

  Future<int> deleteHealthVector(int id) async {
    final db = await database;
    return await db.delete(
      'health_vectors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertHealthAnomaly(HealthAnomaly anomaly) async {
    final db = await database;
    return await db.insert('health_anomalies', anomaly.toMap());
  }

  Future<List<HealthAnomaly>> getHealthAnomalies({bool? acknowledged, bool? resolved, int? limit}) async {
    final db = await database;
    final maps = await db.query('health_anomalies', limit: limit);
    
    var results = List.generate(maps.length, (i) => HealthAnomaly.fromMap(maps[i]));
    
    if (acknowledged != null) {
      results = results.where((a) => a.isAcknowledged == (acknowledged ? 1 : 0)).toList();
    }
    if (resolved != null) {
      results = results.where((a) => a.isResolved == (resolved ? 1 : 0)).toList();
    }
    
    return results;
  }

  Future<int> updateHealthAnomaly(HealthAnomaly anomaly) async {
    final db = await database;
    return await db.update(
      'health_anomalies',
      anomaly.toMap(),
      where: 'id = ?',
      whereArgs: [anomaly.id],
    );
  }

  Future<int> deleteHealthAnomaly(int id) async {
    final db = await database;
    return await db.delete(
      'health_anomalies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertSmartReminder(SmartReminder reminder) async {
    final db = await database;
    return await db.insert('smart_reminders', reminder.toMap());
  }

  Future<List<SmartReminder>> getSmartReminders({bool? active, bool? snoozed, int? reminderType}) async {
    final db = await database;
    final maps = await db.query('smart_reminders');
    
    var results = List.generate(maps.length, (i) => SmartReminder.fromMap(maps[i]));
    
    if (active != null) {
      results = results.where((r) => r.isActive == (active ? 1 : 0)).toList();
    }
    if (snoozed != null) {
      results = results.where((r) => r.isSnoozed == (snoozed ? 1 : 0)).toList();
    }
    if (reminderType != null) {
      results = results.where((r) => r.reminderType == reminderType).toList();
    }
    
    return results;
  }

  Future<int> updateSmartReminder(SmartReminder reminder) async {
    final db = await database;
    return await db.update(
      'smart_reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteSmartReminder(int id) async {
    final db = await database;
    return await db.delete(
      'smart_reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}