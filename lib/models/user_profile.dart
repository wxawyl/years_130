class UserProfile {
  final int? id;
  final String name;
  final String gender;
  final int? age;
  final double? height;
  final double? weight;
  final List<String> goals;
  final List<String> medicalHistory;
  final List<String> dietaryNotes;
  final String? activityLevel;
  final String? sleepGoal;
  final String? stressLevel;
  final String? occupation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    this.id,
    this.name = '',
    this.gender = '',
    this.age,
    this.height,
    this.weight,
    this.goals = const [],
    this.medicalHistory = const [],
    this.dietaryNotes = const [],
    this.activityLevel,
    this.sleepGoal,
    this.stressLevel,
    this.occupation,
    this.createdAt,
    this.updatedAt,
  });

  double? get bmi {
    if (height != null && weight != null && height! > 0) {
      final heightInM = height! / 100;
      return weight! / (heightInM * heightInM);
    }
    return null;
  }

  UserProfile copyWith({
    int? id,
    String? name,
    String? gender,
    int? age,
    double? height,
    double? weight,
    List<String>? goals,
    List<String>? medicalHistory,
    List<String>? dietaryNotes,
    String? activityLevel,
    String? sleepGoal,
    String? stressLevel,
    String? occupation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goals: goals ?? this.goals,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      dietaryNotes: dietaryNotes ?? this.dietaryNotes,
      activityLevel: activityLevel ?? this.activityLevel,
      sleepGoal: sleepGoal ?? this.sleepGoal,
      stressLevel: stressLevel ?? this.stressLevel,
      occupation: occupation ?? this.occupation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'goals': goals.join('||'),
      'medical_history': medicalHistory.join('||'),
      'dietary_notes': dietaryNotes.join('||'),
      'activity_level': activityLevel,
      'sleep_goal': sleepGoal,
      'stress_level': stressLevel,
      'occupation': occupation,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      age: map['age'] as int?,
      height: map['height'] as double?,
      weight: map['weight'] as double?,
      goals: (map['goals'] as String? ?? '').split('||').where((s) => s.isNotEmpty).toList(),
      medicalHistory: (map['medical_history'] as String? ?? '').split('||').where((s) => s.isNotEmpty).toList(),
      dietaryNotes: (map['dietary_notes'] as String? ?? '').split('||').where((s) => s.isNotEmpty).toList(),
      activityLevel: map['activity_level'] as String?,
      sleepGoal: map['sleep_goal'] as String?,
      stressLevel: map['stress_level'] as String?,
      occupation: map['occupation'] as String?,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at'] as String) : null,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at'] as String) : null,
    );
  }
}
