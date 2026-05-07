class MoodRecord {
  int? id;
  String date;
  int moodLevel;
  String? note;
  String? createdAt;

  MoodRecord({
    this.id,
    required this.date,
    required this.moodLevel,
    this.note,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'mood_score': moodLevel,
      'diary': note,
      'created_at': createdAt,
    };
  }

  static MoodRecord fromMap(Map<String, dynamic> map) {
    return MoodRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      moodLevel: map['mood_score'] as int,
      note: map['diary'] as String?,
      createdAt: map['created_at'] as String?,
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