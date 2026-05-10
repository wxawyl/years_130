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
  int isRegular;
  int hasFried;
  int hasSweet;
  int hasSnack;
  int waterLevel;
  int alcoholLevel;
  String? createdAt;
  String? foodImagePath;
  double? recognitionConfidence;

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
    this.isRegular = 1,
    this.hasFried = 0,
    this.hasSweet = 0,
    this.hasSnack = 0,
    this.waterLevel = 2,
    this.alcoholLevel = 0,
    this.createdAt,
    this.foodImagePath,
    this.recognitionConfidence,
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
      'is_regular': isRegular,
      'has_fried': hasFried,
      'has_sweet': hasSweet,
      'has_snack': hasSnack,
      'water_level': waterLevel,
      'alcohol_level': alcoholLevel,
      'created_at': createdAt,
      'food_image': foodImagePath,
      'recognition_confidence': recognitionConfidence,
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
      isRegular: (map['is_regular'] as int?) ?? 1,
      hasFried: (map['has_fried'] as int?) ?? 0,
      hasSweet: (map['has_sweet'] as int?) ?? 0,
      hasSnack: (map['has_snack'] as int?) ?? 0,
      waterLevel: (map['water_level'] as int?) ?? 2,
      alcoholLevel: (map['alcohol_level'] as int?) ?? 0,
      createdAt: map['created_at'] as String?,
      foodImagePath: map['food_image'] as String?,
      recognitionConfidence: map['recognition_confidence'] as double?,
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
