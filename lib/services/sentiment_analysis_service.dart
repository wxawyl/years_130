class SentimentAnalysisResult {
  final double sentimentScore;
  final int anxietyLevel;
  final List<String> stressors;
  final String moodCategory;
  final List<String> suggestions;

  SentimentAnalysisResult({
    required this.sentimentScore,
    required this.anxietyLevel,
    required this.stressors,
    required this.moodCategory,
    required this.suggestions,
  });
}

class SentimentAnalysisService {
  static final Map<String, double> _positiveWords = {
    '好': 0.5,
    '开心': 0.6,
    '快乐': 0.7,
    '幸福': 0.8,
    '满足': 0.5,
    '感激': 0.6,
    '平静': 0.4,
    '放松': 0.5,
    '愉快': 0.6,
    '乐观': 0.5,
    '积极': 0.5,
    '太棒了': 0.7,
    '喜欢': 0.5,
    '爱': 0.7,
    '完美': 0.6,
    '顺利': 0.4,
    '成功': 0.5,
    '胜利': 0.6,
    '美好': 0.5,
    '温暖': 0.4,
  };

  static final Map<String, double> _negativeWords = {
    '不好': -0.5,
    '难过': -0.6,
    '伤心': -0.7,
    '痛苦': -0.8,
    '焦虑': -0.6,
    '紧张': -0.5,
    '压力': -0.5,
    '烦': -0.4,
    '生气': -0.5,
    '愤怒': -0.7,
    '害怕': -0.6,
    '恐惧': -0.7,
    '担心': -0.5,
    '担忧': -0.5,
    '郁闷': -0.5,
    '沮丧': -0.6,
    '失望': -0.5,
    '累': -0.3,
    '疲倦': -0.3,
    '辛苦': -0.4,
  };

  static final Map<String, String> _stressorKeywords = {
    '工作': '工作压力',
    '加班': '工作压力',
    '老板': '人际关系',
    '同事': '人际关系',
    '学习': '学习压力',
    '考试': '学习压力',
    '作业': '学习压力',
    '钱': '经济压力',
    '财务': '经济压力',
    '房贷': '经济压力',
    '房租': '经济压力',
    '家庭': '家庭关系',
    '孩子': '家庭关系',
    '父母': '家庭关系',
    '感情': '情感关系',
    '恋爱': '情感关系',
    '分手': '情感关系',
    '健康': '健康担忧',
    '生病': '健康担忧',
    '未来': '未来焦虑',
    '迷茫': '未来焦虑',
  };

  static SentimentAnalysisResult analyze(String text) {
    double sentimentScore = 0;
    int wordCount = 0;
    List<String> stressors = [];

    final lowerText = text.toLowerCase();

    for (var word in _positiveWords.keys) {
      if (lowerText.contains(word)) {
        sentimentScore += _positiveWords[word]!;
        wordCount++;
      }
    }

    for (var word in _negativeWords.keys) {
      if (lowerText.contains(word)) {
        sentimentScore += _negativeWords[word]!;
        wordCount++;
      }
    }

    for (var keyword in _stressorKeywords.keys) {
      if (lowerText.contains(keyword)) {
        final stressor = _stressorKeywords[keyword]!;
        if (!stressors.contains(stressor)) {
          stressors.add(stressor);
        }
      }
    }

    if (wordCount > 0) {
      sentimentScore = sentimentScore / wordCount;
    }

    sentimentScore = sentimentScore.clamp(-1.0, 1.0);

    int anxietyLevel = _calculateAnxietyLevel(sentimentScore, stressors, text);
    String moodCategory = _determineMoodCategory(sentimentScore);
    List<String> suggestions = _generateSuggestions(sentimentScore, anxietyLevel, stressors);

    return SentimentAnalysisResult(
      sentimentScore: sentimentScore,
      anxietyLevel: anxietyLevel,
      stressors: stressors,
      moodCategory: moodCategory,
      suggestions: suggestions,
    );
  }

  static int _calculateAnxietyLevel(double sentimentScore, List<String> stressors, String text) {
    int anxietyScore = 3;

    if (sentimentScore < -0.3) {
      anxietyScore += 1;
    }
    if (sentimentScore < -0.6) {
      anxietyScore += 1;
    }

    anxietyScore += stressors.length;

    if (text.length > 200) {
      anxietyScore += 1;
    }

    return anxietyScore.clamp(1, 5);
  }

  static String _determineMoodCategory(double sentimentScore) {
    if (sentimentScore >= 0.4) return '积极';
    if (sentimentScore >= 0.1) return '中性偏积极';
    if (sentimentScore >= -0.1) return '中性';
    if (sentimentScore >= -0.4) return '中性偏消极';
    return '消极';
  }

  static List<String> _generateSuggestions(double sentimentScore, int anxietyLevel, List<String> stressors) {
    List<String> suggestions = [];

    if (anxietyLevel >= 4) {
      suggestions.add('建议进行深呼吸放松练习，每次5分钟');
      suggestions.add('可以尝试冥想5分钟，帮助缓解焦虑');
    } else if (anxietyLevel >= 3) {
      suggestions.add('适当休息一下，听听轻松的音乐');
    }

    if (sentimentScore < -0.2) {
      suggestions.add('今天试着做一件自己喜欢的事情');
      suggestions.add('和朋友聊聊天，分享你的感受');
    }

    if (stressors.contains('工作压力')) {
      suggestions.add('尝试将大任务分解成小步骤，逐个完成');
      suggestions.add('每工作1小时休息5分钟，避免过劳');
    }

    if (stressors.contains('学习压力')) {
      suggestions.add('制定合理的学习计划，避免临时抱佛脚');
      suggestions.add('学习之余安排适当的休息和娱乐时间');
    }

    if (stressors.contains('人际关系')) {
      suggestions.add('试着用平和的方式沟通你的感受');
      suggestions.add('有时候远离冲突也是一种智慧');
    }

    if (stressors.contains('经济压力')) {
      suggestions.add('列出收入支出清单，做一个预算计划');
      suggestions.add('专注于你能控制的部分，一步一步改善');
    }

    if (sentimentScore >= 0.4 && anxietyLevel <= 2) {
      suggestions.add('心情不错！继续保持良好的状态');
      suggestions.add('把这份好心情分享给身边的人');
    }

    if (suggestions.isEmpty) {
      suggestions.add('今天状态很好，继续保持！');
    }

    return suggestions;
  }
}
