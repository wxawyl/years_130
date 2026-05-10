class UserSettings {
  int? id;
  String? name;
  int? age;
  String? gender;
  double? height;
  double? weight;
  double targetSleepHours;
  int targetCalories;
  String? healthIssues;
  String? healthGoal;
  String? createdAt;
  String? updatedAt;

  UserSettings({
    this.id,
    this.name,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.targetSleepHours = 8,
    this.targetCalories = 2000,
    this.healthIssues,
    this.healthGoal,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'target_sleep_hours': targetSleepHours,
      'target_calories': targetCalories,
      'health_issues': healthIssues,
      'health_goal': healthGoal,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static UserSettings fromMap(Map<String, dynamic> map) {
    return UserSettings(
      id: map['id'] as int?,
      name: map['name'] as String?,
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      height: map['height'] as double?,
      weight: map['weight'] as double?,
      targetSleepHours: (map['target_sleep_hours'] as double?) ?? 8,
      targetCalories: (map['target_calories'] as int?) ?? 2000,
      healthIssues: map['health_issues'] as String?,
      healthGoal: map['health_goal'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
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

  set healthIssuesList(List<String> issues) {
    healthIssues = issues.join(',');
  }
}
