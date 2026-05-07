class MoodRecord {
  int? id;
  String date;
  int moodLevel;
  String? note;
  String? createdAt;
  int? stressLevel;
  String? gratitude;

  MoodRecord({
    this.id,
    required this.date,
    required this.moodLevel,
    this.note,
    this.createdAt,
    this.stressLevel,
    this.gratitude,
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