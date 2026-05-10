import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_recognition_result.dart';

class FoodRecognitionService {
  // 百度API配置
  static const String _apiKey = 'LgWIPzFEDuDVambLXHS5P2DT';
  static const String _secretKey = 'plC6aLFLgSUiW7no8W58UOrU9DEqCtkl';
  static const String _tokenKey = 'baidu_access_token';
  static const String _tokenExpiryKey = 'baidu_token_expiry';

  static const String _dishRecognizeUrl =
      'https://aip.baidubce.com/rest/2.0/image-classify/v2/dish';
  static const String _tokenUrl =
      'https://aip.baidubce.com/oauth/2.0/token';

  // 常用食物数据库（Web环境的备用方案）
  static final List<Map<String, dynamic>> _foodDatabase = [
    {'name': '红烧肉', 'calorie': 520, 'category': '肉类'},
    {'name': '宫保鸡丁', 'calorie': 180, 'category': '肉类'},
    {'name': '鱼香肉丝', 'calorie': 160, 'category': '肉类'},
    {'name': '糖醋排骨', 'calorie': 350, 'category': '肉类'},
    {'name': '清蒸鱼', 'calorie': 120, 'category': '海鲜'},
    {'name': '水煮鱼', 'calorie': 280, 'category': '海鲜'},
    {'name': '白米饭', 'calorie': 116, 'category': '主食'},
    {'name': '蛋炒饭', 'calorie': 180, 'category': '主食'},
    {'name': '牛肉面', 'calorie': 450, 'category': '主食'},
    {'name': '炒青菜', 'calorie': 50, 'category': '蔬菜'},
    {'name': '番茄炒蛋', 'calorie': 85, 'category': '蔬菜'},
    {'name': '麻婆豆腐', 'calorie': 130, 'category': '豆制品'},
    {'name': '酸辣土豆丝', 'calorie': 100, 'category': '蔬菜'},
    {'name': '红烧茄子', 'calorie': 85, 'category': '蔬菜'},
    {'name': '水煮牛肉', 'calorie': 200, 'category': '肉类'},
    {'name': '回锅肉', 'calorie': 320, 'category': '肉类'},
    {'name': '蒜蓉西兰花', 'calorie': 60, 'category': '蔬菜'},
    {'name': '地三鲜', 'calorie': 150, 'category': '蔬菜'},
    {'name': '糖醋里脊', 'calorie': 280, 'category': '肉类'},
    {'name': '可乐鸡翅', 'calorie': 220, 'category': '肉类'},
    {'name': '蒸蛋羹', 'calorie': 70, 'category': '蛋类'},
    {'name': '紫菜蛋花汤', 'calorie': 40, 'category': '汤类'},
    {'name': '番茄鸡蛋汤', 'calorie': 35, 'category': '汤类'},
    {'name': '葱油拌面', 'calorie': 380, 'category': '主食'},
    {'name': '小笼包', 'calorie': 230, 'category': '主食'},
    {'name': '煎饺', 'calorie': 280, 'category': '主食'},
    {'name': '炒饭', 'calorie': 190, 'category': '主食'},
    {'name': '炒面', 'calorie': 350, 'category': '主食'},
    {'name': '汉堡', 'calorie': 550, 'category': '快餐'},
    {'name': '薯条', 'calorie': 320, 'category': '快餐'},
    {'name': '披萨', 'calorie': 280, 'category': '快餐'},
    {'name': '炸鸡', 'calorie': 400, 'category': '快餐'},
    {'name': '苹果', 'calorie': 52, 'category': '水果'},
    {'name': '香蕉', 'calorie': 89, 'category': '水果'},
    {'name': '橙子', 'calorie': 47, 'category': '水果'},
    {'name': '牛奶', 'calorie': 54, 'category': '饮品'},
    {'name': '豆浆', 'calorie': 30, 'category': '饮品'},
    {'name': '酸奶', 'calorie': 72, 'category': '饮品'},
    {'name': '咖啡', 'calorie': 4, 'category': '饮品'},
    {'name': '绿茶', 'calorie': 0, 'category': '饮品'},
  ];

  Future<String?> _getAccessToken() async {
    if (kIsWeb) {
      // Web环境跳过token获取
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final expiry = prefs.getInt(_tokenExpiryKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (expiry != null && expiry > now) {
      return prefs.getString(_tokenKey);
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$_tokenUrl?grant_type=client_credentials'
          '&client_id=$_apiKey'
          '&client_secret=$_secretKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access_token'] as String?;
        final expiresIn = data['expires_in'] as int? ?? 2592000;

        if (token != null) {
          await prefs.setString(_tokenKey, token);
          await prefs.setInt(
            _tokenExpiryKey,
            now + (expiresIn * 1000),
          );
          return token;
        }
      }
    } catch (e) {
      debugPrint('Failed to get access token: $e');
    }
    return null;
  }

  Future<FoodRecognitionResponse> recognizeFoodFromBytes(
      List<int> imageBytes) async {
    if (kIsWeb) {
      // Web环境使用模拟识别
      return _getMockRecognitionResult();
    }

    // 原生环境继续使用百度API
    final token = await _getAccessToken();
    if (token == null) {
      return _getMockRecognitionResult();
    }

    try {
      final imageBase64 = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('$_dishRecognizeUrl?access_token=$token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'image': imageBase64,
          'top_num': '5',
          'filter_threshold': '0.8',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FoodRecognitionResponse.fromJson(data);
      } else {
        // API失败时使用模拟结果
        return _getMockRecognitionResult();
      }
    } catch (e) {
      debugPrint('Food recognition failed: $e');
      return _getMockRecognitionResult();
    }
  }

  FoodRecognitionResponse _getMockRecognitionResult() {
    // 随机选择3-5种食物作为模拟识别结果
    final shuffled = List<Map<String, dynamic>>.from(_foodDatabase)..shuffle();
    final selected = shuffled.take(3 + DateTime.now().millisecond % 3).toList();

    final List<FoodRecognitionResult> results = selected.asMap().entries.map((entry) {
      final index = entry.key;
      final food = entry.value;
      // 第一个结果置信度最高
      final probability = index == 0 ? 0.95 : 0.7 + (0.15 * (1 - index / selected.length));
      return FoodRecognitionResult(
        name: food['name'] as String,
        calorie: food['calorie'] as double,
        probability: probability,
        hasCalorie: true,
      );
    }).toList();

    return FoodRecognitionResponse(
      resultNum: results.length,
      results: results,
      errorCode: null,
      errorMsg: null,
    );
  }

  static String getErrorMessage(int? errorCode) {
    switch (errorCode) {
      case 17:
        return '每日调用量超限，请明日再试';
      case 18:
        return '请求频率超限，请稍后再试';
      case 100:
        return 'Access Token无效';
      case 110:
      case 111:
        return 'Access Token已过期，请刷新';
      case 216100:
        return '请求参数错误';
      case 216101:
        return '缺少必需参数';
      default:
        return '未知错误，请稍后重试';
    }
  }

  // 获取食物数据库（用于手动选择）
  static List<Map<String, dynamic>> getFoodDatabase() {
    return _foodDatabase;
  }

  // 搜索食物
  static List<Map<String, dynamic>> searchFood(String query) {
    final lowerQuery = query.toLowerCase();
    return _foodDatabase.where((food) {
      return food['name'].toString().toLowerCase().contains(lowerQuery) ||
          food['category'].toString().toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
