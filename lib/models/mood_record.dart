class MoodRecord {
  int? id;
  String date;
  int moodScore;
  int stressLevel;
  String? diary;
  String? gratitude;
  String? createdAt;

  MoodRecord({
    this.id,
    required this.date,
    required this.moodScore,
    required this.stressLevel,
    this.diary,
    this.gratitude,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'mood_score': moodScore,
      'stress_level': stressLevel,
      'diary': diary,
      'gratitude': gratitude,
      'created_at': createdAt,
    };
  }

  static MoodRecord fromMap(Map<String, dynamic> map) {
    return MoodRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      moodScore: map['mood_score'] as int,
      stressLevel: map['stress_level'] as int,
      diary: map['diary'] as String?,
      gratitude: map['gratitude'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  String get moodEmoji {
    switch (moodScore) {
      case 1: return '😢';
      case 2: return '😔';
      case 3: return '😐';
      case 4: return '😊';
      case 5: return '😄';
      default: return '😐';
    }
  }

  String get moodText {
    switch (moodScore) {
      case 1: return '很糟糕';
      case 2: return '不太好';
      case 3: return '一般';
      case 4: return '不错';
      case 5: return '非常好';
      default: return '未知';
    }
  }

  String get stressText {
    switch (stressLevel) {
      case 1: return '无压力';
      case 2: return '轻微压力';
      case 3: return '中等压力';
      case 4: return '较大压力';
      case 5: return '压力很大';
      default: return '未知';
    }
  }
}