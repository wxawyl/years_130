class SleepRecord {
  int? id;
  String date;
  String? bedTime;
  String? wakeTime;
  double? duration;
  int? quality;
  double? deepSleepRatio;
  String? notes;
  String? createdAt;

  SleepRecord({
    this.id,
    required this.date,
    this.bedTime,
    this.wakeTime,
    this.duration,
    this.quality,
    this.deepSleepRatio,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'bed_time': bedTime,
      'wake_time': wakeTime,
      'duration': duration,
      'quality': quality,
      'deep_sleep_ratio': deepSleepRatio,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  static SleepRecord fromMap(Map<String, dynamic> map) {
    return SleepRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      bedTime: map['bed_time'] as String?,
      wakeTime: map['wake_time'] as String?,
      duration: map['duration'] as double?,
      quality: map['quality'] as int?,
      deepSleepRatio: map['deep_sleep_ratio'] as double?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }
}