class ExerciseRecord {
  int? id;
  String date;
  int exerciseType;
  String subType;
  int duration;
  int intensity;
  double caloriesBurned;
  int? steps;
  String? createdAt;
  String? healthKitId;
  bool? isSynced;
  String? syncTime;
  String? source;

  ExerciseRecord({
    this.id,
    required this.date,
    required this.exerciseType,
    required this.subType,
    required this.duration,
    required this.intensity,
    required this.caloriesBurned,
    this.steps,
    this.createdAt,
    this.healthKitId,
    this.isSynced,
    this.syncTime,
    this.source,
  });

  int get type => exerciseType;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'type': exerciseType,
      'sub_type': subType,
      'duration': duration,
      'intensity': intensity,
      'calories_burned': caloriesBurned,
      'steps': steps,
      'created_at': createdAt,
      'health_kit_id': healthKitId,
      'is_synced': isSynced,
      'sync_time': syncTime,
      'source': source,
    };
  }

  static ExerciseRecord fromMap(Map<String, dynamic> map) {
    return ExerciseRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      exerciseType: map['type'] as int,
      subType: map['sub_type'] as String,
      duration: map['duration'] as int,
      intensity: map['intensity'] as int,
      caloriesBurned: map['calories_burned'] as double,
      steps: map['steps'] as int?,
      createdAt: map['created_at'] as String?,
      healthKitId: map['health_kit_id'] as String?,
      isSynced: map['is_synced'] as bool?,
      syncTime: map['sync_time'] as String?,
      source: map['source'] as String?,
    );
  }

  String get typeName {
    switch (exerciseType) {
      case 1: return '有氧运动';
      case 2: return '力量训练';
      case 3: return '柔韧性训练';
      case 4: return '日常活动';
      default: return '其他';
    }
  }

  String get intensityName {
    switch (intensity) {
      case 1: return '低强度';
      case 2: return '中低强度';
      case 3: return '中等强度';
      case 4: return '中高强度';
      case 5: return '高强度';
      default: return '未知';
    }
  }
}
