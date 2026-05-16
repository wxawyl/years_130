import 'package:flutter/material.dart';

enum MoodType {
  excellent,
  good,
  moderate,
  needsAttention,
  tired,
}

class MoodTheme {
  final MoodType type;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color accentColor;
  final List<Color> gradientColors;
  final String emoji;
  final String description;

  const MoodTheme({
    required this.type,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.accentColor,
    required this.gradientColors,
    required this.emoji,
    required this.description,
  });

  static const excellent = MoodTheme(
    type: MoodType.excellent,
    name: '充满活力',
    primaryColor: Color(0xFFFF9800),
    secondaryColor: Color(0xFFFFB74D),
    backgroundColor: Color(0xFFFFF8E1),
    surfaceColor: Color(0xFFFFFFFF),
    textColor: Color(0xFF333333),
    accentColor: Color(0xFFFF5722),
    gradientColors: [Color(0xFFFF9800), Color(0xFFFFB74D), Color(0xFFFFCC80)],
    emoji: '🌞',
    description: '今天状态很棒！继续保持！',
  );

  static const good = MoodTheme(
    type: MoodType.good,
    name: '舒适健康',
    primaryColor: Color(0xFF8BC34A),
    secondaryColor: Color(0xFFAED581),
    backgroundColor: Color(0xFFF1F8E9),
    surfaceColor: Color(0xFFFFFFFF),
    textColor: Color(0xFF333333),
    accentColor: Color(0xFF4CAF50),
    gradientColors: [Color(0xFF8BC34A), Color(0xFFAED581), Color(0xFFC5E1A5)],
    emoji: '🌿',
    description: '状态不错，继续保持健康习惯！',
  );

  static const moderate = MoodTheme(
    type: MoodType.moderate,
    name: '平静温和',
    primaryColor: Color(0xFF90CAF9),
    secondaryColor: Color(0xFFBBDEFB),
    backgroundColor: Color(0xFFE3F2FD),
    surfaceColor: Color(0xFFFFFFFF),
    textColor: Color(0xFF333333),
    accentColor: Color(0xFF2196F3),
    gradientColors: [Color(0xFF90CAF9), Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
    emoji: '☁️',
    description: '今天比较平静，可以适当活动一下。',
  );

  static const needsAttention = MoodTheme(
    type: MoodType.needsAttention,
    name: '需要关怀',
    primaryColor: Color(0xFF78909C),
    secondaryColor: Color(0xFFB0BEC5),
    backgroundColor: Color(0xFFECEFF1),
    surfaceColor: Color(0xFFFFFFFF),
    textColor: Color(0xFF333333),
    accentColor: Color(0xFF607D8B),
    gradientColors: [Color(0xFF78909C), Color(0xFFB0BEC5), Color(0xFFCFD8DC)],
    emoji: '🌙',
    description: '需要多关注一下自己的健康哦~',
  );

  static const tired = MoodTheme(
    type: MoodType.tired,
    name: '需要休息',
    primaryColor: Color(0xFF546E7A),
    secondaryColor: Color(0xFF78909C),
    backgroundColor: Color(0xFFECEFF1),
    surfaceColor: Color(0xFFFFFFFF),
    textColor: Color(0xFF333333),
    accentColor: Color(0xFF455A64),
    gradientColors: [Color(0xFF546E7A), Color(0xFF78909C), Color(0xFF90A4AE)],
    emoji: '😴',
    description: '看起来有些疲惫，好好休息一下吧。',
  );

  static List<MoodTheme> get all => [
    excellent,
    good,
    moderate,
    needsAttention,
    tired,
  ];

  static MoodTheme fromScore(double score, {
    bool hasSleptWell = true,
    bool hasExercised = false,
    bool isSleepDeprived = false,
  }) {
    if (isSleepDeprived) {
      return tired;
    }
    
    if (score >= 80 && hasSleptWell && hasExercised) {
      return excellent;
    }
    
    if (score >= 80) {
      return good;
    }
    
    if (score >= 60) {
      return good;
    }
    
    if (score >= 40) {
      return moderate;
    }
    
    return needsAttention;
  }

  static MoodTheme fromType(MoodType type) {
    switch (type) {
      case MoodType.excellent:
        return excellent;
      case MoodType.good:
        return good;
      case MoodType.moderate:
        return moderate;
      case MoodType.needsAttention:
        return needsAttention;
      case MoodType.tired:
        return tired;
    }
  }

  ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: surfaceColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
