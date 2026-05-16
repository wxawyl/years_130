/// 营养信息数据模型
class NutritionInfo {
  final String foodName;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double? fiberPer100g;
  final double? sodiumPer100g;
  final double? sugarPer100g;
  final String? category;

  NutritionInfo({
    required this.foodName,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.fiberPer100g,
    this.sodiumPer100g,
    this.sugarPer100g,
    this.category,
  });

  /// 计算给定重量的营养信息
  NutritionInfo calculateForWeight(double weightGrams) {
    final ratio = weightGrams / 100;
    return NutritionInfo(
      foodName: foodName,
      caloriesPer100g: caloriesPer100g * ratio,
      proteinPer100g: proteinPer100g * ratio,
      carbsPer100g: carbsPer100g * ratio,
      fatPer100g: fatPer100g * ratio,
      fiberPer100g: fiberPer100g != null ? fiberPer100g! * ratio : null,
      sodiumPer100g: sodiumPer100g != null ? sodiumPer100g! * ratio : null,
      sugarPer100g: sugarPer100g != null ? sugarPer100g! * ratio : null,
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'caloriesPer100g': caloriesPer100g,
      'proteinPer100g': proteinPer100g,
      'carbsPer100g': carbsPer100g,
      'fatPer100g': fatPer100g,
      'fiberPer100g': fiberPer100g,
      'sodiumPer100g': sodiumPer100g,
      'sugarPer100g': sugarPer100g,
      'category': category,
    };
  }

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      foodName: json['foodName'] as String,
      caloriesPer100g: (json['caloriesPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num).toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num).toDouble(),
      fatPer100g: (json['fatPer100g'] as num).toDouble(),
      fiberPer100g: json['fiberPer100g'] != null 
          ? (json['fiberPer100g'] as num).toDouble() 
          : null,
      sodiumPer100g: json['sodiumPer100g'] != null 
          ? (json['sodiumPer100g'] as num).toDouble() 
          : null,
      sugarPer100g: json['sugarPer100g'] != null 
          ? (json['sugarPer100g'] as num).toDouble() 
          : null,
      category: json['category'] as String?,
    );
  }
}

/// 营养数据库服务
class NutritionDatabaseService {
  static final NutritionDatabaseService _instance = NutritionDatabaseService._internal();
  factory NutritionDatabaseService() => _instance;
  NutritionDatabaseService._internal();

  /// 内置常见食物营养数据库
  static final Map<String, NutritionInfo> _nutritionDatabase = {
    // 主食类
    '米饭': NutritionInfo(
      foodName: '米饭',
      caloriesPer100g: 116,
      proteinPer100g: 2.6,
      carbsPer100g: 25.6,
      fatPer100g: 0.3,
      category: '主食',
    ),
    '面条': NutritionInfo(
      foodName: '面条',
      caloriesPer100g: 284,
      proteinPer100g: 8.3,
      carbsPer100g: 56.8,
      fatPer100g: 2.3,
      category: '主食',
    ),
    '面包': NutritionInfo(
      foodName: '面包',
      caloriesPer100g: 312,
      proteinPer100g: 9.0,
      carbsPer100g: 50.1,
      fatPer100g: 7.7,
      category: '主食',
    ),
    '馒头': NutritionInfo(
      foodName: '馒头',
      caloriesPer100g: 221,
      proteinPer100g: 7.0,
      carbsPer100g: 45.7,
      fatPer100g: 1.1,
      category: '主食',
    ),
    
    // 肉类
    '鸡肉': NutritionInfo(
      foodName: '鸡肉',
      caloriesPer100g: 167,
      proteinPer100g: 19.3,
      carbsPer100g: 1.3,
      fatPer100g: 9.4,
      category: '肉类',
    ),
    '牛肉': NutritionInfo(
      foodName: '牛肉',
      caloriesPer100g: 125,
      proteinPer100g: 22.3,
      carbsPer100g: 0,
      fatPer100g: 4.2,
      category: '肉类',
    ),
    '猪肉': NutritionInfo(
      foodName: '猪肉',
      caloriesPer100g: 143,
      proteinPer100g: 20.3,
      carbsPer100g: 1.5,
      fatPer100g: 6.2,
      category: '肉类',
    ),
    '鱼': NutritionInfo(
      foodName: '鱼',
      caloriesPer100g: 105,
      proteinPer100g: 18.5,
      carbsPer100g: 0,
      fatPer100g: 3.5,
      category: '肉类',
    ),
    
    // 蔬菜水果类
    '苹果': NutritionInfo(
      foodName: '苹果',
      caloriesPer100g: 52,
      proteinPer100g: 0.2,
      carbsPer100g: 13.8,
      fatPer100g: 0.2,
      fiberPer100g: 2.4,
      category: '水果',
    ),
    '香蕉': NutritionInfo(
      foodName: '香蕉',
      caloriesPer100g: 89,
      proteinPer100g: 1.1,
      carbsPer100g: 22.8,
      fatPer100g: 0.3,
      fiberPer100g: 2.6,
      category: '水果',
    ),
    '胡萝卜': NutritionInfo(
      foodName: '胡萝卜',
      caloriesPer100g: 41,
      proteinPer100g: 0.9,
      carbsPer100g: 9.6,
      fatPer100g: 0.2,
      fiberPer100g: 2.8,
      category: '蔬菜',
    ),
    '西兰花': NutritionInfo(
      foodName: '西兰花',
      caloriesPer100g: 34,
      proteinPer100g: 2.8,
      carbsPer100g: 6.6,
      fatPer100g: 0.4,
      fiberPer100g: 2.6,
      category: '蔬菜',
    ),
    
    // 蛋奶豆类
    '鸡蛋': NutritionInfo(
      foodName: '鸡蛋',
      caloriesPer100g: 144,
      proteinPer100g: 12.8,
      carbsPer100g: 1.5,
      fatPer100g: 9.9,
      category: '蛋奶',
    ),
    '牛奶': NutritionInfo(
      foodName: '牛奶',
      caloriesPer100g: 42,
      proteinPer100g: 3.0,
      carbsPer100g: 5.0,
      fatPer100g: 1.0,
      category: '蛋奶',
    ),
    '豆腐': NutritionInfo(
      foodName: '豆腐',
      caloriesPer100g: 81,
      proteinPer100g: 8.1,
      carbsPer100g: 1.7,
      fatPer100g: 4.2,
      category: '豆类',
    ),
    
    // 零食饮料
    '巧克力': NutritionInfo(
      foodName: '巧克力',
      caloriesPer100g: 546,
      proteinPer100g: 4.9,
      carbsPer100g: 59.5,
      fatPer100g: 31.6,
      category: '零食',
    ),
    '咖啡': NutritionInfo(
      foodName: '咖啡',
      caloriesPer100g: 1,
      proteinPer100g: 0.1,
      carbsPer100g: 0,
      fatPer100g: 0,
      category: '饮料',
    ),
    '茶': NutritionInfo(
      foodName: '茶',
      caloriesPer100g: 1,
      proteinPer100g: 0.1,
      carbsPer100g: 0.3,
      fatPer100g: 0,
      category: '饮料',
    ),
    
    // 补充 Food-101 常见类别
    '披萨': NutritionInfo(
      foodName: '披萨',
      caloriesPer100g: 266,
      proteinPer100g: 11.4,
      carbsPer100g: 29.5,
      fatPer100g: 11.1,
      category: '西餐',
    ),
    '汉堡': NutritionInfo(
      foodName: '汉堡',
      caloriesPer100g: 295,
      proteinPer100g: 13.0,
      carbsPer100g: 27.0,
      fatPer100g: 13.0,
      category: '西餐',
    ),
  };

  /// 食物名称别名映射
  static final Map<String, String> _foodAliases = {
    '白米饭': '米饭',
    '鸡': '鸡肉',
    '鸡胸肉': '鸡肉',
    '牛排': '牛肉',
    '五花肉': '猪肉',
    '米饭': '米饭',
    '苹果派': '苹果',
    '香蕉': '香蕉',
  };

  /// 获取食物营养信息
  NutritionInfo? getNutritionInfo(String foodName) {
    final normalizedName = _normalizeFoodName(foodName);
    
    if (_nutritionDatabase.containsKey(normalizedName)) {
      return _nutritionDatabase[normalizedName];
    }
    
    if (_foodAliases.containsKey(normalizedName)) {
      return _nutritionDatabase[_foodAliases[normalizedName]];
    }
    
    return null;
  }

  /// 搜索食物（模糊匹配）
  List<NutritionInfo> searchFoods(String query) {
    final normalizedQuery = _normalizeFoodName(query);
    final results = <NutritionInfo>[];
    
    for (var entry in _nutritionDatabase.entries) {
      final foodName = _normalizeFoodName(entry.key);
      if (foodName.contains(normalizedQuery) || 
          normalizedQuery.contains(foodName)) {
        results.add(entry.value);
      }
    }
    
    return results;
  }

  /// 获取所有食物
  List<NutritionInfo> getAllFoods() {
    return _nutritionDatabase.values.toList();
  }

  /// 根据分类获取食物
  List<NutritionInfo> getFoodsByCategory(String category) {
    return _nutritionDatabase.values
        .where((food) => food.category == category)
        .toList();
  }

  /// 标准化食物名称
  String _normalizeFoodName(String name) {
    return name.toLowerCase().trim();
  }

  /// 获取默认的营养信息（当找不到时使用）
  NutritionInfo getDefaultNutritionInfo(String foodName) {
    return NutritionInfo(
      foodName: foodName,
      caloriesPer100g: 100,
      proteinPer100g: 5.0,
      carbsPer100g: 15.0,
      fatPer100g: 3.0,
      category: '其他',
    );
  }
}
