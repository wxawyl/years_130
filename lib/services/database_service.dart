import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/sleep_record.dart';
import '../models/diet_record.dart';
import '../models/exercise_record.dart';
import '../models/mood_record.dart';
import '../models/daily_score.dart';
import '../models/knowledge_item.dart';
import '../models/reminder.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'health_life.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        gender TEXT,
        height REAL,
        weight REAL,
        target_sleep_hours REAL DEFAULT 8,
        target_calories INTEGER DEFAULT 2000,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE sleep_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        bed_time TEXT,
        wake_time TEXT,
        duration REAL,
        quality INTEGER,
        deep_sleep_ratio REAL,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE diet_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        meal_type INTEGER,
        food_name TEXT,
        calories REAL,
        protein REAL,
        carbs REAL,
        fat REAL,
        servings REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE exercise_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        type INTEGER,
        sub_type TEXT,
        duration INTEGER,
        intensity INTEGER,
        calories_burned REAL,
        steps INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE mood_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        mood_score INTEGER,
        stress_level INTEGER,
        diary TEXT,
        gratitude TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        sleep_score REAL,
        diet_score REAL,
        exercise_score REAL,
        mood_score REAL,
        total_score REAL,
        suggestions TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE knowledge_base (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category INTEGER,
        title TEXT,
        content TEXT,
        source TEXT,
        is_video INTEGER DEFAULT 0,
        url TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type INTEGER,
        time TEXT,
        enabled INTEGER DEFAULT 1,
        repeat_days TEXT,
        message TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE habit_tracking (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER,
        habit_name TEXT,
        date TEXT NOT NULL,
        completed INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await _insertInitialKnowledge(db);
    await _insertInitialReminders(db);
  }

  Future<void> _insertInitialKnowledge(Database db) async {
    List<Map<String, dynamic>> knowledgeItems = [
      {
        'category': 1,
        'title': '良好睡眠的重要性',
        'content': '睡眠是身体修复和充电的时间。成年人建议每天睡7-9小时。深度睡眠有助于记忆巩固和身体恢复。',
        'source': '世界卫生组织'
      },
      {
        'category': 1,
        'title': '改善睡眠质量的方法',
        'content': '保持规律的睡眠时间，创建舒适的睡眠环境，避免睡前使用电子设备，限制咖啡因摄入。',
        'source': '睡眠研究中心'
      },
      {
        'category': 2,
        'title': '均衡饮食的原则',
        'content': '每天摄入适量的蛋白质、碳水化合物和健康脂肪。多吃蔬菜和水果，保证营养均衡。',
        'source': '中国营养学会'
      },
      {
        'category': 2,
        'title': '健康饮水习惯',
        'content': '每天饮水量建议为1500-2000毫升。分多次小口饮用，避免一次性大量饮水。',
        'source': '健康指南'
      },
      {
        'category': 3,
        'title': '有氧运动的好处',
        'content': '有氧运动可以增强心肺功能，提高新陈代谢，有助于减肥和保持健康体重。',
        'source': '运动医学杂志'
      },
      {
        'category': 3,
        'title': '适度运动的建议',
        'content': '每周至少进行150分钟中等强度有氧运动，或75分钟高强度运动。结合力量训练效果更佳。',
        'source': '美国心脏协会'
      },
      {
        'category': 4,
        'title': '保持良好心态的方法',
        'content': '学会感恩，保持积极乐观的心态，定期进行冥想和放松训练，与他人保持良好关系。',
        'source': '心理健康协会'
      },
      {
        'category': 4,
        'title': '压力管理技巧',
        'content': '通过运动、冥想、深呼吸等方式缓解压力。学会说"不"，合理安排工作和休息时间。',
        'source': '心理研究中心'
      }
    ];

    for (var item in knowledgeItems) {
      await db.insert('knowledge_base', item);
    }
  }

  Future<void> _insertInitialReminders(Database db) async {
    List<Map<String, dynamic>> reminders = [
      {'type': 1, 'time': '22:30', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '该睡觉了，保持规律作息有助于健康！'},
      {'type': 2, 'time': '09:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '记得喝水，保持身体水分平衡'},
      {'type': 2, 'time': '11:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '休息一下，喝杯水吧'},
      {'type': 2, 'time': '15:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '下午好，记得补充水分'},
      {'type': 2, 'time': '17:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '下班前再喝一杯水'},
      {'type': 3, 'time': '07:00', 'enabled': 0, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '早上好，该运动了！'},
      {'type': 4, 'time': '20:00', 'enabled': 1, 'repeat_days': '[0,1,2,3,4,5,6]', 'message': '放松一下，进行冥想练习吧'}
    ];

    for (var reminder in reminders) {
      await db.insert('reminders', reminder);
    }
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

  Future<int> insertMoodRecord(MoodRecord record) async {
    final db = await database;
    return await db.insert('mood_records', record.toMap());
  }

  Future<MoodRecord?> getMoodRecord(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mood_records',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return MoodRecord.fromMap(maps.first);
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
}