class DietRecord {
  int? id;
  String date;
  int mealType;
  String foodName;
  double calories;
  double protein;
  double carbs;
  double fat;
  double servings;
  String? createdAt;

  DietRecord({
    this.id,
    required this.date,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servings,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'meal_type': mealType,
      'food_name': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'servings': servings,
      'created_at': createdAt,
    };
  }

  static DietRecord fromMap(Map<String, dynamic> map) {
    return DietRecord(
      id: map['id'] as int?,
      date: map['date'] as String,
      mealType: map['meal_type'] as int,
      foodName: map['food_name'] as String,
      calories: map['calories'] as double,
      protein: map['protein'] as double,
      carbs: map['carbs'] as double,
      fat: map['fat'] as double,
      servings: map['servings'] as double,
      createdAt: map['created_at'] as String?,
    );
  }

  String get mealTypeName {
    switch (mealType) {
      case 1: return '早餐';
      case 2: return '午餐';
      case 3: return '晚餐';
      case 4: return '零食';
      default: return '其他';
    }
  }
}