import 'dart:math';
import 'package:intl/intl.dart';
import '../models/smart_reminder.dart';
import '../services/database_service.dart';

class SmartReminderService {
  static final SmartReminderService _instance = SmartReminderService._internal();
  final DatabaseService _dbService = DatabaseService();
  final Random _random = Random();

  factory SmartReminderService() {
    return _instance;
  }

  SmartReminderService._internal();

  String _getUUID() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  Future<List<SmartReminder>> generateSmartReminders() async {
    List<SmartReminder> reminders = [];

    final sleepReminder = await _generateSleepReminder();
    if (sleepReminder != null) {
      reminders.add(sleepReminder);
    }

    final waterReminder = await _generateWaterReminder();
    if (waterReminder != null) {
      reminders.add(waterReminder);
    }

    final exerciseReminder = await _generateExerciseReminder();
    if (exerciseReminder != null) {
      reminders.add(exerciseReminder);
    }

    final moodReminder = await _generateMoodReminder();
    if (moodReminder != null) {
      reminders.add(moodReminder);
    }

    final breakReminder = await _generateBreakReminder();
    if (breakReminder != null) {
      reminders.add(breakReminder);
    }

    return reminders;
  }

  Future<SmartReminder?> _generateSleepReminder() async {
    final now = DateTime.now();
    
    if (now.hour >= 21 && now.hour < 23) {
      return SmartReminder(
        uuid: _getUUID(),
        reminderType: 1,
        title: '该准备睡觉了',
        content: '现在是晚上${now.hour}点，建议在23点前入睡，保证7-8小时睡眠。睡前可做些放松活动。',
        priority: 2,
        triggerCondition: 'time_21_23',
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    if (now.hour >= 6 && now.hour < 8) {
      return SmartReminder(
        uuid: _getUUID(),
        reminderType: 1,
        title: '早上好',
        content: '新的一天开始了！昨晚睡得怎么样？记得记录您的睡眠情况。',
        priority: 3,
        triggerCondition: 'time_6_8',
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    return null;
  }

  Future<SmartReminder?> _generateWaterReminder() async {
    final now = DateTime.now();
    
    if ((now.hour == 9 || now.hour == 11 || now.hour == 15 || now.hour == 17) && now.minute < 30) {
      final messages = [
        '该喝水了！保持身体水分充足有助于新陈代谢。',
        '提醒您补充水分，建议每天喝1500-2000ml水。',
        '忙碌的工作别忘了喝水，现在来一杯吧！',
      ];
      
      return SmartReminder(
        uuid: _getUUID(),
        reminderType: 5,
        title: '喝水提醒',
        content: messages[_random.nextInt(messages.length)],
        priority: 3,
        triggerCondition: 'regular_water',
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    return null;
  }

  Future<SmartReminder?> _generateExerciseReminder() async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    
    final todayExercise = await _dbService.getExerciseRecords(today);
    
    if (todayExercise.isEmpty && now.hour >= 10 && now.hour < 20) {
      final messages = [
        '今天还没有运动记录哦！来活动一下身体吧，哪怕10分钟也好。',
        '建议进行30分钟中等强度运动，如快走、骑车或瑜伽。',
        '运动能让您心情更好，现在开始动起来吧！',
      ];
      
      return SmartReminder(
        uuid: _getUUID(),
        reminderType: 3,
        title: '运动提醒',
        content: messages[_random.nextInt(messages.length)],
        priority: 2,
        triggerCondition: 'no_exercise_today',
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    return null;
  }

  Future<SmartReminder?> _generateMoodReminder() async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    
    final todayMood = await _dbService.getVoiceDiary(today);
    
    if (todayMood == null && now.hour >= 18 && now.hour < 22) {
      return SmartReminder(
        uuid: _getUUID(),
        reminderType: 4,
        title: '记录心情',
        content: '今天还没有记录心情呢！花几分钟时间记录一下今天的感受吧。',
        priority: 3,
        triggerCondition: 'no_mood_record_today',
        createdAt: DateTime.now().toIso8601String(),
      );
    }

    return null;
  }

  Future<SmartReminder?> _generateBreakReminder() async {
    final now = DateTime.now();
    
    if (now.weekday >= 1 && now.weekday <= 5) {
      if ((now.hour == 10 && now.minute >= 30) || (now.hour == 15 && now.minute <= 30)) {
        return SmartReminder(
          uuid: _getUUID(),
          reminderType: 6,
          title: '休息提醒',
          content: '工作/学习一段时间了，起来活动一下吧！拉伸、远眺或走走。',
          priority: 3,
          triggerCondition: 'work_break',
          createdAt: DateTime.now().toIso8601String(),
        );
      }
    }

    return null;
  }

  Future<List<SmartReminder>> getActiveReminders() async {
    return await _dbService.getSmartReminders(
      active: true,
      snoozed: false,
    );
  }

  Future<SmartReminder> createCustomReminder({
    required int type,
    required String title,
    required String content,
    int priority = 2,
    required String triggerCondition,
  }) async {
    final reminder = SmartReminder(
      uuid: _getUUID(),
      reminderType: type,
      title: title,
      content: content,
      priority: priority,
      triggerCondition: triggerCondition,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    await _dbService.insertSmartReminder(reminder);
    return reminder;
  }

  Future<void> toggleReminder(int reminderId, bool isActive) async {
    final reminders = await _dbService.getSmartReminders();
    final reminder = reminders.firstWhere((r) => r.id == reminderId);
    
    reminder.isActive = isActive ? 1 : 0;
    await _dbService.updateSmartReminder(reminder);
  }

  Future<void> snoozeReminder(int reminderId, int minutes) async {
    final reminders = await _dbService.getSmartReminders();
    final reminder = reminders.firstWhere((r) => r.id == reminderId);
    
    reminder.isSnoozed = 1;
    reminder.snoozedUntil = DateTime.now().add(Duration(minutes: minutes)).toIso8601String();
    await _dbService.updateSmartReminder(reminder);
  }

  Future<void> dismissReminder(int reminderId) async {
    final reminders = await _dbService.getSmartReminders();
    final reminder = reminders.firstWhere((r) => r.id == reminderId);
    
    reminder.triggerCount += 1;
    reminder.lastTriggeredAt = DateTime.now().toIso8601String();
    await _dbService.updateSmartReminder(reminder);
  }

  Future<void> deleteReminder(int reminderId) async {
    await _dbService.deleteSmartReminder(reminderId);
  }

  Future<List<SmartReminder>> checkAndGenerate() async {
    final generated = await generateSmartReminders();
    
    for (final reminder in generated) {
      await _dbService.insertSmartReminder(reminder);
    }
    
    return generated;
  }

  Future<void> setupDefaultReminders() async {
    final existing = await _dbService.getSmartReminders();
    if (existing.isNotEmpty) return;

    final now = DateTime.now();
    final sleepTime = DateTime(now.year, now.month, now.day, 22, 30);
    final waterTimes = [9, 11, 15, 17];
    final exerciseTime = DateTime(now.year, now.month, now.day, 18, 0);

    await _dbService.insertSmartReminder(SmartReminder(
      uuid: _getUUID(),
      reminderType: 1,
      title: '睡眠提醒',
      content: '该睡觉了！保持规律作息，建议在23点前入睡。',
      priority: 2,
      triggerCondition: 'daily_22:30',
      nextTriggerAt: sleepTime.toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    ));

    for (final hour in waterTimes) {
      final time = DateTime(now.year, now.month, now.day, hour, 0);
      await _dbService.insertSmartReminder(SmartReminder(
        uuid: _getUUID(),
        reminderType: 5,
        title: '喝水提醒',
        content: '该喝水了！保持身体水分充足。',
        priority: 3,
        triggerCondition: 'daily_$hour:00',
        nextTriggerAt: time.toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
      ));
    }

    await _dbService.insertSmartReminder(SmartReminder(
      uuid: _getUUID(),
      reminderType: 3,
      title: '运动提醒',
      content: '别忘了今天的运动！哪怕10分钟也好。',
      priority: 2,
      triggerCondition: 'daily_18:00',
      nextTriggerAt: exerciseTime.toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    ));
  }
}
