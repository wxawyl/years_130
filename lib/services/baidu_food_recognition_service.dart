import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_recognition_result.dart';

class BaiduFoodRecognitionService {
  static const String _apiKey = 'LgWIPzFEDuDVambLXHS5P2DT';
  static const String _secretKey = 'plC6aLFLgSUiW7no8W58UOrU9DEqCtkl';
  static const String _tokenKey = 'baidu_access_token';
  static const String _tokenExpiryKey = 'baidu_token_expiry';

  static const String _dishRecognizeUrl =
      'https://aip.baidubce.com/rest/2.0/image-classify/v2/dish';
  static const String _tokenUrl =
      'https://aip.baidubce.com/oauth/2.0/token';

  Future<String?> _getAccessToken() async {
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
      print('Failed to get access token: $e');
    }
    return null;
  }

  Future<FoodRecognitionResponse> recognizeFood(String imagePath) async {
    final token = await _getAccessToken();
    if (token == null) {
      return FoodRecognitionResponse(
        resultNum: 0,
        results: [],
        errorCode: -1,
        errorMsg: '无法获取访问令牌，请检查网络连接',
      );
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return FoodRecognitionResponse(
          resultNum: 0,
          results: [],
          errorCode: -2,
          errorMsg: '图片文件不存在',
        );
      }

      final imageBytes = await file.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('$_dishRecognizeUrl?access_token=$token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'image': imageBase64,
          'top_num': '5',
          'filter_threshold': '0.95',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FoodRecognitionResponse.fromJson(data);
      } else {
        return FoodRecognitionResponse(
          resultNum: 0,
          results: [],
          errorCode: response.statusCode,
          errorMsg: '服务器响应错误: ${response.statusCode}',
        );
      }
    } on HttpException catch (e) {
      return FoodRecognitionResponse(
        resultNum: 0,
        results: [],
        errorCode: -3,
        errorMsg: '网络错误: ${e.message}',
      );
    } on Exception catch (e) {
      return FoodRecognitionResponse(
        resultNum: 0,
        results: [],
        errorCode: -4,
        errorMsg: '识别失败: $e',
      );
    }
  }

  Future<FoodRecognitionResponse> recognizeFoodFromBytes(
      List<int> imageBytes) async {
    final token = await _getAccessToken();
    if (token == null) {
      return FoodRecognitionResponse(
        resultNum: 0,
        results: [],
        errorCode: -1,
        errorMsg: '无法获取访问令牌，请检查网络连接',
      );
    }

    try {
      final imageBase64 = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('$_dishRecognizeUrl?access_token=$token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'image': imageBase64,
          'top_num': '5',
          'filter_threshold': '0.95',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FoodRecognitionResponse.fromJson(data);
      } else {
        return FoodRecognitionResponse(
          resultNum: 0,
          results: [],
          errorCode: response.statusCode,
          errorMsg: '服务器响应错误: ${response.statusCode}',
        );
      }
    } on HttpException catch (e) {
      return FoodRecognitionResponse(
        resultNum: 0,
        results: [],
        errorCode: -3,
        errorMsg: '网络错误: ${e.message}',
      );
    } on Exception catch (e) {
      return FoodRecognitionResponse(
        resultNum: 0,
        results: [],
        errorCode: -4,
        errorMsg: '识别失败: $e',
      );
    }
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
        return 'Access Token已过期';
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
}
