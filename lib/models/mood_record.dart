class MoodRecord {
  int? id;
  String date;
  int moodLevel;
  String? note;
  String? createdAt;
  int? stressLevel;
  String? gratitude;
  int hasAnxiety;
  int hasOverthinking;
  int hasLowMood;

  MoodRecord({
    this.id,
    required this.date,
    required this.moodLevel,
    this.note,
    this.createdAt,
    this.stressLevel,
    this.gratitude,
    this.hasAnxiety = 0,
    this.hasOverthinking = 0,
    this.hasLowMood = 0,
  });

  int get moodScore => moodLevel;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'mood_score': moodLevel,
      'diary': note,
      'created_at': createdAt,
      'stress_level': stressLevel,
      'gratitude': gratitude,
      'has_anxiety': hasAnxiety,
      'has_overthinking': hasOverthinking,
      'has_low_mood': hasLowMood,
    };
  }

  static MoodRecord fromMap(Map<String, dynamic> map) {
    return MoodRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      moodLevel: map['mood_score'] as int,
      note: map['diary'] as String?,
      createdAt: map['created_at'] as String?,
      stressLevel: map['stress_level'] as int?,
      gratitude: map['gratitude'] as String?,
      hasAnxiety: (map['has_anxiety'] as int?) ?? 0,
      hasOverthinking: (map['has_overthinking'] as int?) ?? 0,
      hasLowMood: (map['has_low_mood'] as int?) ?? 0,
    );
  }

  String get moodEmoji {
    switch (moodLevel) {
      case 5: return '😄';
      case 4: return '😊';
      case 3: return '😐';
      case 2: return '😔';
      case 1: return '😢';
      default: return '😐';
    }
  }
}
