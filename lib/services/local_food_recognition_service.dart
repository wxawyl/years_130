import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'nutrition_database_service.dart';

/// 食物识别结果，包含营养信息
class FoodRecognitionResult {
  final String foodName;
  final double confidence;
  final String? category;
  final NutritionInfo? nutritionInfo;
  
  FoodRecognitionResult({
    required this.foodName,
    required this.confidence,
    this.category,
    this.nutritionInfo,
  });
  
  factory FoodRecognitionResult.fromJson(Map<String, dynamic> json) {
    return FoodRecognitionResult(
      foodName: json['foodName'] as String,
      confidence: json['confidence'] as double,
      category: json['category'] as String?,
      nutritionInfo: json['nutritionInfo'] != null 
          ? NutritionInfo.fromJson(json['nutritionInfo']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'confidence': confidence,
      'category': category,
      'nutritionInfo': nutritionInfo?.toJson(),
    };
  }
}

/// 食物识别响应
class FoodRecognitionResponse {
  final List<FoodRecognitionResult> results;
  final bool isLocalInference;
  final String? errorMessage;
  final Duration inferenceTime;
  
  FoodRecognitionResponse({
    required this.results,
    this.isLocalInference = true,
    this.errorMessage,
    required this.inferenceTime,
  });
  
  bool get hasError => errorMessage != null;
}

/// 本地食物识别服务
class LocalFoodRecognitionService {
  static final LocalFoodRecognitionService _instance = 
      LocalFoodRecognitionService._internal();
  factory LocalFoodRecognitionService() => _instance;
  LocalFoodRecognitionService._internal();
  
  final NutritionDatabaseService _nutritionService = NutritionDatabaseService();
  bool _isInitialized = false;
  bool _modelDownloaded = false;
  bool _useFallback = false; // 是否使用降级方案
  
  /// Food-101 数据集的101种食物类别（英文到中文的映射）
  static const Map<String, String> food101Mapping = {
    'apple_pie': '苹果派',
    'pizza': '披萨',
    'hamburger': '汉堡',
    'fried_rice': '炒饭',
    'dumplings': '饺子',
    'sushi': '寿司',
    'ramen': '拉面',
    'chicken_wings': '鸡翅',
    'ice_cream': '冰淇淋',
    'bread_pudding': '面包布丁',
    'breakfast_burrito': '早餐卷饼',
    'cheesecake': '芝士蛋糕',
    'chocolate_cake': '巧克力蛋糕',
    'donuts': '甜甜圈',
    'macarons': '马卡龙',
    'pancakes': '煎饼',
    'waffles': '华夫饼',
    'spaghetti_bolognese': '意大利肉酱面',
    'spaghetti_carbonara': '卡邦尼意面',
    'fish_and_chips': '炸鱼薯条',
    'steak': '牛排',
    'spring_rolls': '春卷',
  };
  
  /// 常见中餐类别
  static const List<Map<String, String>> commonChineseFoods = [
    {'name': '米饭', 'category': '主食'},
    {'name': '面条', 'category': '主食'},
    {'name': '馒头', 'category': '主食'},
    {'name': '饺子', 'category': '主食'},
    {'name': '包子', 'category': '主食'},
    {'name': '炒饭', 'category': '主食'},
    {'name': '鸡肉', 'category': '肉类'},
    {'name': '牛肉', 'category': '肉类'},
    {'name': '猪肉', 'category': '肉类'},
    {'name': '鱼', 'category': '肉类'},
    {'name': '鸡蛋', 'category': '蛋奶'},
    {'name': '牛奶', 'category': '蛋奶'},
    {'name': '豆腐', 'category': '豆类'},
    {'name': '苹果', 'category': '水果'},
    {'name': '香蕉', 'category': '水果'},
    {'name': '胡萝卜', 'category': '蔬菜'},
    {'name': '西兰花', 'category': '蔬菜'},
  ];
  
  /// 初始化服务
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    debugPrint('初始化本地食物识别服务...');
    
    // 检查模型是否已下载
    await _checkModelStatus();
    
    _isInitialized = true;
    debugPrint('本地食物识别服务初始化完成');
  }
  
  /// 检查模型状态
  Future<void> _checkModelStatus() async {
    try {
      // TODO: 实现模型存在性检查
      // 这里先标记为未下载，等待后续实现
      _modelDownloaded = false;
      
      if (!_modelDownloaded) {
        debugPrint('食物识别模型未下载，将使用降级方案');
        _useFallback = true;
      }
    } catch (e) {
      debugPrint('检查模型状态失败: $e');
      _useFallback = true;
    }
  }
  
  /// 下载模型
  Future<bool> downloadModel({
    Function(double)? onProgress,
    Function(String)? onError,
  }) async {
    try {
      debugPrint('开始下载食物识别模型...');
      
      // TODO: 实现实际的模型下载
      // 这里模拟下载过程
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        onProgress?.call(i / 100);
      }
      
      _modelDownloaded = true;
      _useFallback = false;
      debugPrint('食物识别模型下载完成');
      return true;
    } catch (e) {
      final error = '下载模型失败: $e';
      debugPrint(error);
      onError?.call(error);
      return false;
    }
  }
  
  /// 识别食物（从图片路径）
  Future<FoodRecognitionResponse> recognizeFood(String imagePath) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      if (_useFallback || !_modelDownloaded) {
        return _fallbackRecognition(stopwatch);
      }
      
      // TODO: 实现实际的本地模型推理
      return _simulateLocalInference(stopwatch);
      
    } catch (e) {
      stopwatch.stop();
      return FoodRecognitionResponse(
        results: [],
        isLocalInference: false,
        errorMessage: '识别失败: $e',
        inferenceTime: stopwatch.elapsed,
      );
    }
  }
  
  /// 识别食物（从图片字节）
  Future<FoodRecognitionResponse> recognizeFoodFromBytes(
    Uint8List imageBytes,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      if (_useFallback || !_modelDownloaded) {
        return _fallbackRecognition(stopwatch);
      }
      
      // TODO: 实现实际的本地模型推理
      return _simulateLocalInference(stopwatch);
      
    } catch (e) {
      stopwatch.stop();
      return FoodRecognitionResponse(
        results: [],
        isLocalInference: false,
        errorMessage: '识别失败: $e',
        inferenceTime: stopwatch.elapsed,
      );
    }
  }
  
  /// 降级方案：返回一些常见食物
  FoodRecognitionResponse _fallbackRecognition(Stopwatch stopwatch) {
    stopwatch.stop();
    
    final results = <FoodRecognitionResult>[];
    
    // 从常见食物中随机选择
    for (var food in commonChineseFoods.take(5)) {
      final nutritionInfo = _nutritionService.getNutritionInfo(food['name']!);
      results.add(FoodRecognitionResult(
        foodName: food['name']!,
        confidence: 0.6 + (0.3 * (results.length / 5)),
        category: food['category'],
        nutritionInfo: nutritionInfo,
      ));
    }
    
    return FoodRecognitionResponse(
      results: results,
      isLocalInference: true,
      errorMessage: '使用简化模式（模型未下载）',
      inferenceTime: stopwatch.elapsed,
    );
  }
  
  /// 模拟本地推理（演示用）
  FoodRecognitionResponse _simulateLocalInference(Stopwatch stopwatch) {
    stopwatch.stop();
    
    final results = <FoodRecognitionResult>[];
    
    final demoFoods = [
      {'name': '炒饭', 'confidence': 0.82, 'category': '中餐'},
      {'name': '饺子', 'confidence': 0.71, 'category': '中餐'},
      {'name': '寿司', 'confidence': 0.65, 'category': '日料'},
    ];
    
    for (var food in demoFoods) {
      final nutritionInfo = _nutritionService.getNutritionInfo(food['name'] as String);
      results.add(FoodRecognitionResult(
        foodName: food['name'] as String,
        confidence: food['confidence'] as double,
        category: food['category'] as String,
        nutritionInfo: nutritionInfo,
      ));
    }
    
    return FoodRecognitionResponse(
      results: results,
      isLocalInference: true,
      inferenceTime: stopwatch.elapsed,
    );
  }
  
  /// 获取食物营养信息
  NutritionInfo? getNutritionInfo(String foodName) {
    return _nutritionService.getNutritionInfo(foodName);
  }
  
  /// 搜索食物
  List<NutritionInfo> searchFoods(String query) {
    return _nutritionService.searchFoods(query);
  }
  
  /// 清除模型
  Future<void> clearModel() async {
    _modelDownloaded = false;
    _useFallback = true;
    // TODO: 实现模型文件删除
  }
  
  /// 获取服务状态
  Map<String, dynamic> get status {
    return {
      'isInitialized': _isInitialized,
      'modelDownloaded': _modelDownloaded,
      'useFallback': _useFallback,
      'supportedClasses': food101Mapping.length,
    };
  }
}
