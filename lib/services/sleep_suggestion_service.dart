import '../models/sleep_record.dart';
import '../models/user_profile.dart';

class SleepSuggestion {
  final String icon;
  final String title;
  final String description;
  final SuggestionType type;

  SleepSuggestion({
    required this.icon,
    required this.title,
    required this.description,
    required this.type,
  });
}

enum SuggestionType {
  positive,
  warning,
  info,
  improvement,
}

class SleepSuggestionService {
  static SleepSuggestion generateSuggestion(SleepRecord? sleepRecord, UserProfile? userProfile) {
    if (sleepRecord == null) {
      return SleepSuggestion(
        icon: '🌙',
        title: '开始记录睡眠',
        description: '连接 Apple HealthKit 自动同步您的睡眠数据，或手动添加睡眠记录来获取个性化建议。',
        type: SuggestionType.info,
      );
    }

    List<SleepSuggestion> suggestions = [];

    final duration = sleepRecord.duration ?? 0;
    final quality = sleepRecord.quality ?? 3;
    final deepSleepRatio = sleepRecord.deepSleepRatio;

    if (duration < 6) {
      suggestions.add(SleepSuggestion(
        icon: '😴',
        title: '睡眠时长不足',
        description: '您昨晚只睡了 ${duration.toStringAsFixed(1)} 小时，建议每天保证 7-9 小时的睡眠时间。尝试提早 30 分钟上床休息。',
        type: SuggestionType.warning,
      ));
    } else if (duration > 10) {
      suggestions.add(SleepSuggestion(
        icon: '😵',
        title: '睡眠时长过长',
        description: '您昨晚睡了 ${duration.toStringAsFixed(1)} 小时，过长的睡眠可能影响日间精力。建议保持规律的起床时间。',
        type: SuggestionType.warning,
      ));
    } else if (duration >= 7 && duration <= 9) {
      suggestions.add(SleepSuggestion(
        icon: '✨',
        title: '睡眠时长完美',
        description: '太棒了！您昨晚睡了 ${duration.toStringAsFixed(1)} 小时，正好在推荐的 7-9 小时范围内。继续保持！',
        type: SuggestionType.positive,
      ));
    }

    if (quality <= 2) {
      suggestions.add(SleepSuggestion(
        icon: '💤',
        title: '睡眠质量需要改善',
        description: '您的睡眠质量评分较低。建议睡前避免使用电子设备，保持卧室黑暗凉爽，尝试放松冥想。',
        type: SuggestionType.improvement,
      ));
    } else if (quality >= 4) {
      suggestions.add(SleepSuggestion(
        icon: '🌟',
        title: '睡眠质量优秀',
        description: '您的睡眠质量非常好！继续保持良好的睡眠习惯，这对您的健康非常有益。',
        type: SuggestionType.positive,
      ));
    }

    if (deepSleepRatio != null) {
      if (deepSleepRatio < 0.15) {
        suggestions.add(SleepSuggestion(
          icon: '🌊',
          title: '深度睡眠偏少',
          description: '您的深度睡眠比例较低。深度睡眠对身体恢复很重要，建议睡前避免咖啡因和酒精。',
          type: SuggestionType.improvement,
        ));
      } else if (deepSleepRatio > 0.35) {
        suggestions.add(SleepSuggestion(
          icon: '📊',
          title: '睡眠结构分析',
          description: '您的深度睡眠比例偏高，这可能表明身体需要更多恢复。注意观察日间精力状态。',
          type: SuggestionType.info,
        ));
      }
    }

    final bedtime = sleepRecord.bedtime;
    if (bedtime != null) {
      final parts = bedtime.split(':');
      final hour = int.tryParse(parts[0]) ?? 0;
      if (hour >= 23 || hour < 1) {
        suggestions.add(SleepSuggestion(
          icon: '🕐',
          title: '睡觉时间偏晚',
          description: '您昨晚 $bedtime 才睡觉，建议尽量在 22:30 前上床，遵循生物钟规律。',
          type: SuggestionType.improvement,
        ));
      } else if (hour >= 21 && hour < 23) {
        suggestions.add(SleepSuggestion(
          icon: '👍',
          title: '睡觉时间规律',
          description: '很好！您在 $bedtime 上床睡觉，这个时间段非常适合睡眠，继续保持！',
          type: SuggestionType.positive,
        ));
      }
    }

    if (suggestions.isEmpty) {
      return SleepSuggestion(
        icon: '😊',
        title: '睡眠状况良好',
        description: '您的睡眠整体状况不错！继续保持规律的作息时间，这是健康长寿的重要基础。',
        type: SuggestionType.positive,
      );
    }

    return suggestions.first;
  }

  static List<SleepSuggestion> generateMultipleSuggestions(SleepRecord? sleepRecord, UserProfile? userProfile) {
    if (sleepRecord == null) {
      return [
        SleepSuggestion(
          icon: '🌙',
          title: '开始记录睡眠',
          description: '连接 Apple HealthKit 自动同步您的睡眠数据，或手动添加睡眠记录来获取个性化建议。',
          type: SuggestionType.info,
        ),
      ];
    }

    List<SleepSuggestion> suggestions = [];

    final duration = sleepRecord.duration ?? 0;
    final quality = sleepRecord.quality ?? 3;
    final deepSleepRatio = sleepRecord.deepSleepRatio;

    if (duration < 6) {
      suggestions.add(SleepSuggestion(
        icon: '😴',
        title: '睡眠时长不足',
        description: '您昨晚只睡了 ${duration.toStringAsFixed(1)} 小时，建议每天保证 7-9 小时的睡眠时间。',
        type: SuggestionType.warning,
      ));
    } else if (duration >= 7 && duration <= 9) {
      suggestions.add(SleepSuggestion(
        icon: '✨',
        title: '睡眠时长完美',
        description: '太棒了！您昨晚睡了 ${duration.toStringAsFixed(1)} 小时，正好在推荐范围内。',
        type: SuggestionType.positive,
      ));
    }

    if (quality <= 2) {
      suggestions.add(SleepSuggestion(
        icon: '💤',
        title: '改善睡眠质量',
        description: '建议睡前避免使用电子设备，保持卧室黑暗凉爽，尝试放松冥想。',
        type: SuggestionType.improvement,
      ));
    }

    if (deepSleepRatio != null && deepSleepRatio < 0.15) {
      suggestions.add(SleepSuggestion(
        icon: '🌊',
        title: '增加深度睡眠',
        description: '深度睡眠对身体恢复很重要，建议睡前避免咖啡因和酒精，规律运动。',
        type: SuggestionType.improvement,
      ));
    }

    if (suggestions.isEmpty) {
      suggestions.add(SleepSuggestion(
        icon: '😊',
        title: '睡眠状况良好',
        description: '您的睡眠整体状况不错！继续保持规律的作息时间。',
        type: SuggestionType.positive,
      ));
    }

    return suggestions;
  }
}
