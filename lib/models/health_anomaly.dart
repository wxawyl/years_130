class HealthAnomaly {
  int? id;
  String uuid;
  int anomalyType;
  String title;
  String description;
  double severity;
  String relatedRecords;
  String suggestions;
  int isAcknowledged;
  int isResolved;
  String? resolvedAt;
  String createdAt;

  HealthAnomaly({
    this.id,
    required this.uuid,
    required this.anomalyType,
    required this.title,
    required this.description,
    required this.severity,
    required this.relatedRecords,
    required this.suggestions,
    this.isAcknowledged = 0,
    this.isResolved = 0,
    this.resolvedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'anomaly_type': anomalyType,
      'title': title,
      'description': description,
      'severity': severity,
      'related_records': relatedRecords,
      'suggestions': suggestions,
      'is_acknowledged': isAcknowledged,
      'is_resolved': isResolved,
      'resolved_at': resolvedAt,
      'created_at': createdAt,
    };
  }

  static HealthAnomaly fromMap(Map<String, dynamic> map) {
    return HealthAnomaly(
      id: map['id'] as int?,
      uuid: map['uuid'] as String,
      anomalyType: map['anomaly_type'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      severity: (map['severity'] as num?)?.toDouble() ?? 0.0,
      relatedRecords: map['related_records'] as String,
      suggestions: map['suggestions'] as String,
      isAcknowledged: map['is_acknowledged'] as int? ?? 0,
      isResolved: map['is_resolved'] as int? ?? 0,
      resolvedAt: map['resolved_at'] as String?,
      createdAt: map['created_at'] as String,
    );
  }

  String get anomalyTypeName {
    switch (anomalyType) {
      case 1:
        return '睡眠异常';
      case 2:
        return '饮食异常';
      case 3:
        return '运动异常';
      case 4:
        return '情绪异常';
      case 5:
        return '心率异常';
      case 6:
        return '体重异常';
      default:
        return '其他异常';
    }
  }

  String get severityDisplay {
    if (severity >= 0.8) {
      return '高';
    } else if (severity >= 0.5) {
      return '中';
    } else {
      return '低';
    }
  }

  String get emoji {
    switch (anomalyType) {
      case 1:
        return '😴';
      case 2:
        return '🥗';
      case 3:
        return '🏃';
      case 4:
        return '💭';
      case 5:
        return '❤️';
      case 6:
        return '⚖️';
      default:
        return '⚠️';
    }
  }
}
