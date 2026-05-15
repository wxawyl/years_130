class AiInsight {
  int? id;
  String date;
  String insightType;
  String title;
  String description;
  String? suggestion;
  double confidence;
  int dataPoints;
  List<String>? relatedMetrics;
  String? category;
  String? createdAt;
  bool isDemo;

  AiInsight({
    this.id,
    required this.date,
    required this.insightType,
    required this.title,
    required this.description,
    this.suggestion,
    this.confidence = 0.8,
    this.dataPoints = 0,
    this.relatedMetrics,
    this.category,
    this.createdAt,
    this.isDemo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'insight_type': insightType,
      'title': title,
      'description': description,
      'suggestion': suggestion,
      'confidence': confidence,
      'data_points': dataPoints,
      'related_metrics': relatedMetrics?.join(','),
      'category': category,
      'created_at': createdAt,
      'is_demo': isDemo ? 1 : 0,
    };
  }

  static AiInsight fromMap(Map<String, dynamic> map) {
    return AiInsight(
      id: map['id'] as int?,
      date: map['date'] as String,
      insightType: map['insight_type'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      suggestion: map['suggestion'] as String?,
      confidence: map['confidence'] as double? ?? 0.8,
      dataPoints: map['data_points'] as int? ?? 0,
      relatedMetrics: (map['related_metrics'] as String?)?.split(',').where((s) => s.isNotEmpty).toList(),
      category: map['category'] as String?,
      createdAt: map['created_at'] as String?,
      isDemo: (map['is_demo'] as int?) == 1,
    );
  }

  static List<AiInsight> getDemoInsights() {
    return [
      AiInsight(
        date: DateTime.now().toString().substring(0, 10),
        insightType: 'correlation',
        title: '咖啡因与深度睡眠',
        description: '每当你下午摄入超过500ml咖啡因，你当晚的深度睡眠会减少约40%。',
        suggestion: '建议下午2点后避免饮用咖啡、茶或含咖啡因的饮料。',
        confidence: 0.85,
        dataPoints: 14,
        relatedMetrics: ['sleep_deep_ratio', 'caffeine_intake'],
        category: 'sleep',
        isDemo: true,
      ),
    ];
  }
}