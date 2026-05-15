import 'package:flutter/material.dart';
import '../models/diet_record.dart';
import '../models/user_profile.dart';

class DietSuggestion {
  final String icon;
  final String title;
  final String description;
  final SuggestionType type;
  final String? targetFood;

  DietSuggestion({
    required this.icon,
    required this.title,
    required this.description,
    required this.type,
    this.targetFood,
  });
}

enum SuggestionType {
  increase,  // 增加摄入
  decrease,  // 减少摄入
  maintain,  // 保持
  warning,   // 健康警告
  info,      // 一般信息
}

class DietSuggestionService {
  static DietSuggestion generateSuggestion(List<DietRecord> todayRecords, UserProfile? userProfile) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    List<String> foods = [];

    for (var record in todayRecords) {
      totalCalories += record.calories * record.servings;
      totalProtein += record.protein * record.servings;
      totalCarbs += record.carbs * record.servings;
      totalFat += record.fat * record.servings;
      foods.add(record.foodName);
    }

    double targetCalories = _calculateTargetCalories(userProfile);
    
    if (totalCalories == 0) {
      return _getEmptyStateSuggestion();
    }

    List<DietSuggestion> suggestions = [];

    if (totalCalories > targetCalories * 1.2) {
      suggestions.add(_getHighCalorieSuggestion(totalCalories, targetCalories));
    }

    if (totalProtein < 50) {
      suggestions.add(_getLowProteinSuggestion());
    }

    if (totalFat > 65) {
      suggestions.add(_getHighFatSuggestion());
    }

    if (foods.any((f) => f.contains('油炸') || f.contains('薯条') || f.contains('汉堡'))) {
      suggestions.add(_getProcessedFoodWarning());
    }

    if (foods.any((f) => f.contains('蔬菜') || f.contains('水果') || f.contains('沙拉'))) {
      suggestions.add(_getHealthyEatingSuggestion());
    }

    if (suggestions.isEmpty) {
      suggestions.add(_getMaintainSuggestion());
    }

    return suggestions.first;
  }

  static double _calculateTargetCalories(UserProfile? userProfile) {
    if (userProfile == null) {
      return 2000;
    }

    double bmr;
    if (userProfile.gender == '男') {
      bmr = 88.362 + (13.397 * (userProfile.weight ?? 70)) + (4.799 * (userProfile.height ?? 170)) - (5.677 * (userProfile.age ?? 30));
    } else {
      bmr = 447.593 + (9.247 * (userProfile.weight ?? 60)) + (3.098 * (userProfile.height ?? 160)) - (4.330 * (userProfile.age ?? 30));
    }

    return bmr * 1.2;
  }

  static DietSuggestion _getEmptyStateSuggestion() {
    return DietSuggestion(
      icon: '📷',
      title: '开始记录您的饮食',
      description: '点击上方拍照按钮，识别食物开始记录，AI将为您提供个性化饮食建议。',
      type: SuggestionType.info,
    );
  }

  static DietSuggestion _getHighCalorieSuggestion(double current, double target) {
    return DietSuggestion(
      icon: '⚠️',
      title: '热量摄入偏高',
      description: '今日热量摄入（${current.toStringAsFixed(0)} kcal）已超过推荐值（${target.toStringAsFixed(0)} kcal）。建议减少高热量食物，增加蔬菜摄入。',
      type: SuggestionType.decrease,
    );
  }

  static DietSuggestion _getLowProteinSuggestion() {
    return DietSuggestion(
      icon: '🥩',
      title: '增加蛋白质摄入',
      description: '今日蛋白质摄入偏低，建议增加优质蛋白质食物，如鸡胸肉、鱼类、豆腐等。',
      type: SuggestionType.increase,
    );
  }

  static DietSuggestion _getHighFatSuggestion() {
    return DietSuggestion(
      icon: '🚫',
      title: '减少脂肪摄入',
      description: '今日脂肪摄入较高，建议选择更健康的脂肪来源，如橄榄油、坚果，避免油炸食品。',
      type: SuggestionType.decrease,
    );
  }

  static DietSuggestion _getProcessedFoodWarning() {
    return DietSuggestion(
      icon: '🚨',
      title: '注意加工食品',
      description: '检测到摄入加工食品，建议减少此类食物，它们通常含有过多添加剂和反式脂肪。',
      type: SuggestionType.warning,
    );
  }

  static DietSuggestion _getHealthyEatingSuggestion() {
    return DietSuggestion(
      icon: '👏',
      title: '健康饮食习惯',
      description: '很好！您在摄入蔬菜水果，继续保持这种健康的饮食习惯！',
      type: SuggestionType.maintain,
    );
  }

  static DietSuggestion _getMaintainSuggestion() {
    return DietSuggestion(
      icon: '✅',
      title: '饮食状况良好',
      description: '您的饮食记录状况良好！继续保持均衡饮食，多吃蔬菜水果，适量摄入蛋白质。',
      type: SuggestionType.maintain,
    );
  }

  static String getSuggestionTypeText(SuggestionType type) {
    switch (type) {
      case SuggestionType.increase:
        return '建议增加';
      case SuggestionType.decrease:
        return '建议减少';
      case SuggestionType.maintain:
        return '请保持';
      case SuggestionType.warning:
        return '健康提醒';
      case SuggestionType.info:
        return '温馨提示';
    }
  }

  static Color getSuggestionTypeColor(SuggestionType type) {
    switch (type) {
      case SuggestionType.increase:
        return Colors.green;
      case SuggestionType.decrease:
        return Colors.orange;
      case SuggestionType.maintain:
        return Colors.blue;
      case SuggestionType.warning:
        return Colors.red;
      case SuggestionType.info:
        return Colors.grey;
    }
  }
}