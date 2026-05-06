class DailyScore {
  int? id;
  String date;
  double sleepScore;
  double dietScore;
  double exerciseScore;
  double moodScore;
  double totalScore;
  String? suggestions;
  String? createdAt;

  DailyScore({
    this.id,
    required this.date,
    required this.sleepScore,
    required this.dietScore,
    required this.exerciseScore,
    required this.moodScore,
    required this.totalScore,
    this.suggestions,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'sleep_score': sleepScore,
      'diet_score': dietScore,
      'exercise_score': exerciseScore,
      'mood_score': moodScore,
      'total_score': totalScore,
      'suggestions': suggestions,
      'created_at': createdAt,
    };
  }

  static DailyScore fromMap(Map<String, dynamic> map) {
    return DailyScore(
      id: map['id'] as int?,
      date: map['date'] as String,
      sleepScore: map['sleep_score'] as double,
      dietScore: map['diet_score'] as double,
      exerciseScore: map['exercise_score'] as double,
      moodScore: map['mood_score'] as double,
      totalScore: map['total_score'] as double,
      suggestions: map['suggestions'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }
}