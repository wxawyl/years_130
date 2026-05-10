class AIHealthReport {
  int? id;
  String date;
  double? totalScore;
  double? sleepScore;
  double? dietScore;
  double? exerciseScore;
  double? moodScore;
  String? healthIssues;
  String? sleepSuggestion;
  String? dietSuggestion;
  String? exerciseSuggestion;
  String? moodSuggestion;
  String? weeklyTrend;
  String? createdAt;

  AIHealthReport({
    this.id,
    required this.date,
    this.totalScore,
    this.sleepScore,
    this.dietScore,
    this.exerciseScore,
    this.moodScore,
    this.healthIssues,
    this.sleepSuggestion,
    this.dietSuggestion,
    this.exerciseSuggestion,
    this.moodSuggestion,
    this.weeklyTrend,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'total_score': totalScore,
      'sleep_score': sleepScore,
      'diet_score': dietScore,
      'exercise_score': exerciseScore,
      'mood_score': moodScore,
      'health_issues': healthIssues,
      'sleep_suggestion': sleepSuggestion,
      'diet_suggestion': dietSuggestion,
      'exercise_suggestion': exerciseSuggestion,
      'mood_suggestion': moodSuggestion,
      'weekly_trend': weeklyTrend,
      'created_at': createdAt,
    };
  }

  static AIHealthReport fromMap(Map<String, dynamic> map) {
    return AIHealthReport(
      id: map['id'] as int?,
      date: map['date'] as String,
      totalScore: map['total_score'] as double?,
      sleepScore: map['sleep_score'] as double?,
      dietScore: map['diet_score'] as double?,
      exerciseScore: map['exercise_score'] as double?,
      moodScore: map['mood_score'] as double?,
      healthIssues: map['health_issues'] as String?,
      sleepSuggestion: map['sleep_suggestion'] as String?,
      dietSuggestion: map['diet_suggestion'] as String?,
      exerciseSuggestion: map['exercise_suggestion'] as String?,
      moodSuggestion: map['mood_suggestion'] as String?,
      weeklyTrend: map['weekly_trend'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  List<String> get healthIssuesList {
    if (healthIssues == null || healthIssues!.isEmpty) {
      return [];
    }
    try {
      return healthIssues!.split(',').map((s) => s.trim()).toList();
    } catch (e) {
      return [];
    }
  }
}
