class SleepRecord {
  int? id;
  String date;
  String? bedtime;
  String? wakeTime;
  double? duration;
  int? quality;
  double? deepSleepRatio;
  int awakenCount;
  int sleepQualityScore;
  String? notes;
  String? createdAt;

  SleepRecord({
    this.id,
    required this.date,
    this.bedtime,
    this.wakeTime,
    this.duration,
    this.quality,
    this.deepSleepRatio,
    this.awakenCount = 0,
    this.sleepQualityScore = 5,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'bed_time': bedtime,
      'wake_time': wakeTime,
      'duration': duration,
      'quality': quality,
      'deep_sleep_ratio': deepSleepRatio,
      'awaken_count': awakenCount,
      'sleep_quality_score': sleepQualityScore,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  static SleepRecord fromMap(Map<String, dynamic> map) {
    return SleepRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      bedtime: map['bed_time'] as String?,
      wakeTime: map['wake_time'] as String?,
      duration: map['duration'] as double?,
      quality: map['quality'] as int?,
      deepSleepRatio: map['deep_sleep_ratio'] as double?,
      awakenCount: (map['awaken_count'] as int?) ?? 0,
      sleepQualityScore: (map['sleep_quality_score'] as int?) ?? 5,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }
}
