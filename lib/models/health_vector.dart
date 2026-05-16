class HealthVector {
  int? id;
  String uuid;
  int recordType;
  int recordId;
  String content;
  String embedding;
  double score;
  String date;
  String? metadata;
  String createdAt;

  HealthVector({
    this.id,
    required this.uuid,
    required this.recordType,
    required this.recordId,
    required this.content,
    required this.embedding,
    this.score = 0.0,
    required this.date,
    this.metadata,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'record_type': recordType,
      'record_id': recordId,
      'content': content,
      'embedding': embedding,
      'score': score,
      'date': date,
      'metadata': metadata,
      'created_at': createdAt,
    };
  }

  static HealthVector fromMap(Map<String, dynamic> map) {
    return HealthVector(
      id: map['id'] as int?,
      uuid: map['uuid'] as String,
      recordType: map['record_type'] as int,
      recordId: map['record_id'] as int,
      content: map['content'] as String,
      embedding: map['embedding'] as String,
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] as String,
      metadata: map['metadata'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  String get recordTypeName {
    switch (recordType) {
      case 1:
        return '睡眠';
      case 2:
        return '饮食';
      case 3:
        return '运动';
      case 4:
        return '心情';
      case 5:
        return '健康评分';
      default:
        return '其他';
    }
  }
}
