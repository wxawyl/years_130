class DailySchedule {
  int? id;
  String date;
  String title;
  String content;
  String priority;
  bool actionRequired;
  List<String>? triggeredBy;
  String? scheduleTime;
  String? actionType;
  bool isCompleted;
  bool isDismissed;
  String? createdAt;
  bool isDemo;

  DailySchedule({
    this.id,
    required this.date,
    required this.title,
    required this.content,
    this.priority = 'medium',
    this.actionRequired = false,
    this.triggeredBy,
    this.scheduleTime,
    this.actionType,
    this.isCompleted = false,
    this.isDismissed = false,
    this.createdAt,
    this.isDemo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'content': content,
      'priority': priority,
      'action_required': actionRequired ? 1 : 0,
      'triggered_by': triggeredBy?.join(','),
      'schedule_time': scheduleTime,
      'action_type': actionType,
      'is_completed': isCompleted ? 1 : 0,
      'is_dismissed': isDismissed ? 1 : 0,
      'created_at': createdAt,
      'is_demo': isDemo ? 1 : 0,
    };
  }

  static DailySchedule fromMap(Map<String, dynamic> map) {
    return DailySchedule(
      id: map['id'] as int?,
      date: map['date'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      priority: map['priority'] as String? ?? 'medium',
      actionRequired: (map['action_required'] as int?) == 1,
      triggeredBy: (map['triggered_by'] as String?)?.split(',').where((s) => s.isNotEmpty).toList(),
      scheduleTime: map['schedule_time'] as String?,
      actionType: map['action_type'] as String?,
      isCompleted: (map['is_completed'] as int?) == 1,
      isDismissed: (map['is_dismissed'] as int?) == 1,
      createdAt: map['created_at'] as String?,
      isDemo: (map['is_demo'] as int?) == 1,
    );
  }

  static List<DailySchedule> getDemoSchedules() {
    return [
      DailySchedule(
        date: DateTime.now().toString().substring(0, 10),
        title: '今晚助眠计划',
        content: '今晚22:00我为你开启助眠模式并提醒你放下手机，好吗？',
        priority: 'high',
        actionRequired: true,
        triggeredBy: ['sleep_quality_low', 'anxiety_high'],
        scheduleTime: '22:00',
        actionType: 'sleep_mode',
        isDemo: true,
      ),
      DailySchedule(
        date: DateTime.now().toString().substring(0, 10),
        title: '晨间运动提醒',
        content: '根据你的运动习惯，建议你在08:30进行30分钟轻度运动，这将帮助提升你一整天的精神状态。',
        priority: 'medium',
        actionRequired: true,
        triggeredBy: ['exercise_consistency_low'],
        scheduleTime: '08:30',
        actionType: 'exercise',
        isDemo: true,
      ),
    ];
  }
}