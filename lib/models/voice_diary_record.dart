class VoiceDiaryRecord {
  int? id;
  String date;
  String content;
  int? durationSeconds;
  double? sentimentScore;
  int? anxietyLevel;
  List<String>? stressors;
  String? moodCategory;
  String? createdAt;

  VoiceDiaryRecord({
    this.id,
    required this.date,
    required this.content,
    this.durationSeconds,
    this.sentimentScore,
    this.anxietyLevel,
    this.stressors,
    this.moodCategory,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'content': content,
      'duration_seconds': durationSeconds,
      'sentiment_score': sentimentScore,
      'anxiety_level': anxietyLevel,
      'stressors': stressors?.join(','),
      'mood_category': moodCategory,
      'created_at': createdAt,
    };
  }

  static VoiceDiaryRecord fromMap(Map<String, dynamic> map) {
    return VoiceDiaryRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      content: map['content'] as String,
      durationSeconds: map['duration_seconds'] as int?,
      sentimentScore: map['sentiment_score'] as double?,
      anxietyLevel: map['anxiety_level'] as int?,
      stressors: (map['stressors'] as String?)?.split(',').where((s) => s.isNotEmpty).toList(),
      moodCategory: map['mood_category'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  String get anxietyLevelLabel {
    switch (anxietyLevel) {
      case 1:
        return '放松';
      case 2:
        return '平静';
      case 3:
        return '轻微焦虑';
      case 4:
        return '中度焦虑';
      case 5:
        return '高度焦虑';
      default:
        return '未知';
    }
  }

  String get sentimentLabel {
    if (sentimentScore == null) return '未知';
    if (sentimentScore! >= 0.7) return '非常积极';
    if (sentimentScore! >= 0.4) return '积极';
    if (sentimentScore! >= -0.1) return '中性';
    if (sentimentScore! >= -0.4) return '消极';
    return '非常消极';
  }
}
