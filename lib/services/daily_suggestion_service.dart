import 'dart:math';
import 'package:intl/intl.dart';

class DailySuggestionService {
  static final List<DailySuggestion> _suggestions = [
    DailySuggestion(
      id: 'mood_1',
      title: '深呼吸练习',
      content: '每天花5分钟做深呼吸练习。吸气4秒，屏息7秒，呼气8秒。这能有效降低压力荷尔蒙，提升心情。',
      icon: '🌬️',
      category: 'breathing',
      source: '正念冥想指南',
      relatedStressors: ['工作压力', '学习压力', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_2',
      title: '感恩练习',
      content: '写下3件今天让你感恩的事情。感恩能显著提升幸福感，改变大脑的积极思维模式。',
      icon: '🙏',
      category: 'gratitude',
      source: '积极心理学',
      relatedStressors: ['人际关系', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_3',
      title: '户外散步',
      content: '走出去，晒晒太阳！每天20分钟的户外活动能提升血清素水平，改善心情和睡眠质量。',
      icon: '🚶',
      category: 'outdoor',
      source: '心理健康指南',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_4',
      title: '与亲友联系',
      content: '给朋友或家人打个电话，分享你的近况。社交联系是心理健康的重要组成部分。',
      icon: '📞',
      category: 'social',
      source: '人际关系研究',
      relatedStressors: ['人际关系', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_5',
      title: '聆听音乐',
      content: '播放你最喜欢的音乐，跟着节奏一起舞动。音乐能触发多巴胺释放，带来愉悦感。',
      icon: '🎵',
      category: 'music',
      source: '音乐疗法',
      relatedStressors: ['工作压力', '学习压力', '人际关系'],
    ),
    DailySuggestion(
      id: 'mood_6',
      title: '身体伸展',
      content: '做一些简单的伸展运动，缓解肌肉紧张。身体放松能带来心理的放松。',
      icon: '🧘',
      category: 'stretching',
      source: '运动心理学',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_7',
      title: '日记书写',
      content: '花10分钟写日记，记录你的感受和思考。书写能帮助整理情绪，获得新的视角。',
      icon: '📔',
      category: 'journaling',
      source: '表达性写作研究',
      relatedStressors: ['工作压力', '学习压力', '人际关系', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_8',
      title: '做善事',
      content: '为他人做一件好事，哪怕只是一个微笑或一句赞美。帮助他人能提升自己的价值感和幸福感。',
      icon: '💝',
      category: 'kindness',
      source: '利他行为研究',
      relatedStressors: ['人际关系'],
    ),
    DailySuggestion(
      id: 'mood_9',
      title: '冥想练习',
      content: '尝试5分钟的冥想。专注于呼吸，让思绪自由来去。冥想能培养专注力和情绪调节能力。',
      icon: '🧘‍♂️',
      category: 'meditation',
      source: '正念冥想',
      relatedStressors: ['工作压力', '学习压力', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_10',
      title: '享受美食',
      content: '为自己准备一顿喜欢的饭菜，慢慢品尝。美食能带来感官的愉悦和满足感。',
      icon: '🍲',
      category: 'food',
      source: '感官享受研究',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_11',
      title: '充足睡眠',
      content: '确保今晚有7-8小时的睡眠。良好的睡眠对情绪调节和心理健康至关重要。',
      icon: '😴',
      category: 'sleep',
      source: '睡眠医学',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_12',
      title: '学习新事物',
      content: '花30分钟学习一个新技能或了解一个新话题。学习能带来成就感和自我成长。',
      icon: '📚',
      category: 'learning',
      source: '终身学习',
      relatedStressors: ['学习压力'],
    ),
    DailySuggestion(
      id: 'mood_13',
      title: '自我激励',
      content: '对着镜子对自己说几句鼓励的话。自我肯定能增强自信心和积极心态。',
      icon: '💪',
      category: 'affirmation',
      source: '自我效能研究',
      relatedStressors: ['人际关系', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_14',
      title: '亲近自然',
      content: '到公园散步，看看花和树。与自然接触能降低焦虑，提升心理幸福感。',
      icon: '🌳',
      category: 'nature',
      source: '生态心理学',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_15',
      title: '享受爱好',
      content: '做一些你真正喜欢的事情，无论是画画、阅读还是运动。爱好是心灵的港湾。',
      icon: '🎨',
      category: 'hobby',
      source: '兴趣研究',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_16',
      title: '正面思考',
      content: '今天多关注事物的积极面。正面思维模式能带来更好的情绪和生活体验。',
      icon: '☀️',
      category: 'positivity',
      source: '积极心理学',
      relatedStressors: ['人际关系', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_17',
      title: '身体活动',
      content: '做30分钟的运动，哪怕只是快步走。运动能释放内啡肽，带来自然的愉悦感。',
      icon: '🏃',
      category: 'exercise',
      source: '运动心理学',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_18',
      title: '拥抱和接触',
      content: '给你爱的人一个拥抱。身体接触能释放催产素，带来安全感和幸福感。',
      icon: '🤗',
      category: 'touch',
      source: '触觉疗法',
      relatedStressors: ['人际关系'],
    ),
    DailySuggestion(
      id: 'mood_19',
      title: '放松技巧',
      content: '尝试渐进式肌肉放松，从脚趾开始，逐渐放松到头部。能有效缓解紧张和焦虑。',
      icon: '💆',
      category: 'relaxation',
      source: '放松训练',
      relatedStressors: ['工作压力', '学习压力', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_20',
      title: '设定目标',
      content: '为今天设定一个小目标并完成它。达成目标能带来成就感和对生活的掌控感。',
      icon: '🎯',
      category: 'goals',
      source: '目标设定理论',
      relatedStressors: ['学习压力', '工作压力'],
    ),
    DailySuggestion(
      id: 'mood_21',
      title: '断联电子设备',
      content: '花1小时不看手机和电脑。从数字世界中抽离，回归当下的真实生活。',
      icon: '📱',
      category: 'detox',
      source: '数字健康',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_22',
      title: '自我关怀',
      content: '像对待最好的朋友一样对待自己。自我关怀比自我批评更能促进成长和健康。',
      icon: '💗',
      category: 'self-care',
      source: '自我关怀理论',
      relatedStressors: ['人际关系', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_23',
      title: '呼吸新鲜空气',
      content: '打开窗户，深吸几口新鲜空气。氧气能提升大脑活力和心情。',
      icon: '🌬️',
      category: 'air',
      source: '环境心理学',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_24',
      title: '回忆美好',
      content: '翻看旧照片或纪念品，回忆美好的时光。怀旧能带来温暖和幸福感。',
      icon: '📸',
      category: 'memories',
      source: '怀旧心理学',
      relatedStressors: ['人际关系'],
    ),
    DailySuggestion(
      id: 'mood_25',
      title: '建立规律',
      content: '今天按照规律作息。规律性能带来安全感和对生活的掌控感。',
      icon: '📅',
      category: 'routine',
      source: '节律研究',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_26',
      title: '限制信息',
      content: '今天少看负面新闻和社交媒体。信息过载会增加焦虑和压力感。',
      icon: '🧘‍♀️',
      category: 'boundaries',
      source: '媒体心理学',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_27',
      title: '寻找幽默',
      content: '看一部喜剧或听一个笑话。笑是最好的良药，能即时改善心情。',
      icon: '😂',
      category: 'humor',
      source: '幽默研究',
      relatedStressors: ['人际关系', '工作压力'],
    ),
    DailySuggestion(
      id: 'mood_28',
      title: '品味当下',
      content: '停下来，真正地感受此刻。正念地感受周围的声音、气味和景象。',
      icon: '🌸',
      category: 'mindfulness',
      source: '正念练习',
      relatedStressors: ['工作压力', '学习压力'],
    ),
    DailySuggestion(
      id: 'mood_29',
      title: '原谅自己',
      content: '原谅自己的过错和不完美。自我原谅是心理健康的重要组成部分。',
      icon: '🕊️',
      category: 'forgiveness',
      source: '宽恕心理学',
      relatedStressors: ['人际关系', '经济压力'],
    ),
    DailySuggestion(
      id: 'mood_30',
      title: '期待明天',
      content: '为明天找一个期待的理由。希望和期待能带来积极的情绪和动力。',
      icon: '🌅',
      category: 'hope',
      source: '希望心理学',
      relatedStressors: ['经济压力', '学习压力'],
    ),
  ];

  static DailySuggestion getTodaySuggestion({List<String>? stressors, double? sentimentScore}) {
    List<DailySuggestion> candidates = _suggestions.toList();

    if (stressors != null && stressors.isNotEmpty) {
      candidates = _suggestions.where((s) {
        return s.relatedStressors.any((rs) => stressors.contains(rs));
      }).toList();
    }

    if (candidates.isEmpty) {
      candidates = _suggestions.toList();
    }

    if (sentimentScore != null && sentimentScore < -0.2) {
      candidates = candidates.where((s) {
        return ['breathing', 'meditation', 'relaxation', 'nature', 'music'].contains(s.category);
      }).toList();
      if (candidates.isEmpty) candidates = _suggestions.toList();
    }

    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat('D').format(now));
    int index = dayOfYear % candidates.length;
    return candidates[index];
  }

  static List<DailySuggestion> getAllSuggestions() {
    return List.unmodifiable(_suggestions);
  }
}

class DailySuggestion {
  final String id;
  final String title;
  final String content;
  final String icon;
  final String category;
  final String source;
  final List<String> relatedStressors;

  DailySuggestion({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
    required this.category,
    this.source = '',
    this.relatedStressors = const [],
  });
}