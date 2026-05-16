class SmartReminder {
  int? id;
  String uuid;
  int reminderType;
  String title;
  String content;
  int priority;
  String triggerCondition;
  int isActive;
  int isSnoozed;
  String? snoozedUntil;
  int triggerCount;
  String? lastTriggeredAt;
  String? nextTriggerAt;
  String createdAt;

  SmartReminder({
    this.id,
    required this.uuid,
    required this.reminderType,
    required this.title,
    required this.content,
    this.priority = 2,
    required this.triggerCondition,
    this.isActive = 1,
    this.isSnoozed = 0,
    this.snoozedUntil,
    this.triggerCount = 0,
    this.lastTriggeredAt,
    this.nextTriggerAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'reminder_type': reminderType,
      'title': title,
      'content': content,
      'priority': priority,
      'trigger_condition': triggerCondition,
      'is_active': isActive,
      'is_snoozed': isSnoozed,
      'snoozed_until': snoozedUntil,
      'trigger_count': triggerCount,
      'last_triggered_at': lastTriggeredAt,
      'next_trigger_at': nextTriggerAt,
      'created_at': createdAt,
    };
  }

  static SmartReminder fromMap(Map<String, dynamic> map) {
    return SmartReminder(
      id: map['id'] as int?,
      uuid: map['uuid'] as String,
      reminderType: map['reminder_type'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      priority: map['priority'] as int? ?? 2,
      triggerCondition: map['trigger_condition'] as String,
      isActive: map['is_active'] as int? ?? 1,
      isSnoozed: map['is_snoozed'] as int? ?? 0,
      snoozedUntil: map['snoozed_until'] as String?,
      triggerCount: map['trigger_count'] as int? ?? 0,
      lastTriggeredAt: map['last_triggered_at'] as String?,
      nextTriggerAt: map['next_trigger_at'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  String get reminderTypeName {
    switch (reminderType) {
      case 1:
        return '睡眠提醒';
      case 2:
        return '饮食提醒';
      case 3:
        return '运动提醒';
      case 4:
        return '情绪关怀';
      case 5:
        return '喝水提醒';
      case 6:
        return '休息提醒';
      default:
        return '其他提醒';
    }
  }

  String get priorityDisplay {
    switch (priority) {
      case 1:
        return '紧急';
      case 2:
        return '普通';
      case 3:
        return '轻量';
      default:
        return '普通';
    }
  }

  String get emoji {
    switch (reminderType) {
      case 1:
        return '🌙';
      case 2:
        return '🥗';
      case 3:
        return '🏃';
      case 4:
        return '💗';
      case 5:
        return '💧';
      case 6:
        return '☕';
      default:
        return '🔔';
    }
  }
}
