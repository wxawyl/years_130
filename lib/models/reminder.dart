class Reminder {
  int? id;
  int type;
  String time;
  int enabled;
  String repeatDays;
  String message;
  String? createdAt;

  Reminder({
    this.id,
    required this.type,
    required this.time,
    this.enabled = 1,
    required this.repeatDays,
    required this.message,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'time': time,
      'enabled': enabled,
      'repeat_days': repeatDays,
      'message': message,
      'created_at': createdAt,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      type: map['type'] as int,
      time: map['time'] as String,
      enabled: map['enabled'] as int,
      repeatDays: map['repeat_days'] as String,
      message: map['message'] as String,
      createdAt: map['created_at'] as String?,
    );
  }

  String get typeName {
    switch (type) {
      case 1: return '睡眠提醒';
      case 2: return '饮水提醒';
      case 3: return '运动提醒';
      case 4: return '冥想提醒';
      default: return '其他提醒';
    }
  }

  bool get isEnabled => enabled == 1;
}