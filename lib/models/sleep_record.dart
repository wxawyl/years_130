class SleepRecord {
  int? id;
  String date;
  String? bedtime;
  String? wakeTime;
  double? duration;
  int? quality;
  double? deepSleepRatio;
  String? notes;
  String? createdAt;
  String? healthKitId;
  bool? isSynced;
  String? syncTime;
  String? source;

  SleepRecord({
    this.id,
    required this.date,
    this.bedtime,
    this.wakeTime,
    this.duration,
    this.quality,
    this.deepSleepRatio,
    this.notes,
    this.createdAt,
    this.healthKitId,
    this.isSynced,
    this.syncTime,
    this.source,
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
      'notes': notes,
      'created_at': createdAt,
      'health_kit_id': healthKitId,
      'is_synced': isSynced,
      'sync_time': syncTime,
      'source': source,
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
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String?,
      healthKitId: map['health_kit_id'] as String?,
      isSynced: map['is_synced'] as bool?,
      syncTime: map['sync_time'] as String?,
      source: map['source'] as String?,
    );
  }
}
