import 'dart:math';
import 'package:intl/intl.dart';
import '../models/knowledge.dart';

class KnowledgeService {
  static final List<Knowledge> _sleepKnowledge = [
    Knowledge(
      id: 's1',
      title: '优质睡眠的重要性',
      content: '睡眠是身体修复和大脑整理记忆的关键时期。长期睡眠不足会导致免疫力下降、记忆力减退、情绪波动等问题。建议每晚保证7-9小时的高质量睡眠。',
      category: 'sleep',
      source: '世界卫生组织',
    ),
    Knowledge(
      id: 's2',
      title: '睡眠周期的奥秘',
      content: '一个完整的睡眠周期约90分钟，包含浅睡眠、深睡眠和快速眼动睡眠阶段。深睡眠阶段对身体修复至关重要，而REM睡眠则与梦境和学习记忆相关。',
      category: 'sleep',
      source: '美国睡眠医学学会',
    ),
    Knowledge(
      id: 's3',
      title: '如何改善睡眠质量',
      content: '保持规律的作息时间，创造舒适的睡眠环境，避免睡前使用电子设备，适当进行体育锻炼，避免咖啡因和酒精摄入。',
      category: 'sleep',
      source: '中国睡眠研究会',
    ),
    Knowledge(
      id: 's4',
      title: '午睡的好处',
      content: '适量的午睡（20-30分钟）可以有效提升下午的工作效率和注意力，改善情绪状态。但午睡时间过长可能会影响夜间睡眠。',
      category: 'sleep',
      source: '哈佛医学院',
    ),
    Knowledge(
      id: 's5',
      title: '睡眠与长寿的关系',
      content: '研究表明，每晚睡眠7小时的人比睡眠少于6小时或多于8小时的人寿命更长。规律的睡眠模式是长寿的重要因素之一。',
      category: 'sleep',
      source: '《自然》杂志研究',
    ),
    Knowledge(
      id: 's6',
      title: '睡眠障碍的信号',
      content: '如果经常入睡困难、夜间醒来多次、白天嗜睡、打鼾严重或有呼吸暂停现象，可能是睡眠障碍的信号，建议及时咨询医生。',
      category: 'sleep',
      source: '国际睡眠研究学会',
    ),
  ];

  static final List<Knowledge> _dietKnowledge = [
    Knowledge(
      id: 'd1',
      title: '均衡饮食的基本原则',
      content: '均衡饮食应包含适量的蛋白质、碳水化合物、脂肪、维生素和矿物质。建议每日摄入多种颜色的蔬菜和水果，保持饮食多样化。',
      category: 'diet',
      source: '中国营养学会',
    ),
    Knowledge(
      id: 'd2',
      title: '地中海饮食与健康',
      content: '地中海饮食以橄榄油、鱼类、坚果、全谷物和大量蔬菜为特点，被证明能有效降低心脏病、糖尿病和某些癌症的风险。',
      category: 'diet',
      source: '世界卫生组织',
    ),
    Knowledge(
      id: 'd3',
      title: '膳食纤维的重要性',
      content: '膳食纤维有助于维持肠道健康，促进消化，降低胆固醇水平，控制血糖。建议每日摄入25-30克膳食纤维。',
      category: 'diet',
      source: '美国农业部',
    ),
    Knowledge(
      id: 'd4',
      title: '适量饮水的好处',
      content: '每天饮用足够的水有助于维持身体正常代谢，促进废物排出，保持皮肤健康。建议每日饮水量不少于1.5-2升。',
      category: 'diet',
      source: '中国居民膳食指南',
    ),
    Knowledge(
      id: 'd5',
      title: '少食多餐的益处',
      content: '少食多餐可以避免暴饮暴食，保持血糖稳定，提高新陈代谢效率。建议每日三餐为主，可适当增加1-2次健康加餐。',
      category: 'diet',
      source: '营养科学研究',
    ),
    Knowledge(
      id: 'd6',
      title: '抗氧化食物与抗衰老',
      content: '富含抗氧化剂的食物如蓝莓、西兰花、紫甘蓝等可以帮助清除体内自由基，减缓细胞老化，延缓衰老过程。',
      category: 'diet',
      source: '美国国立卫生研究院',
    ),
  ];

  static final List<Knowledge> _exerciseKnowledge = [
    Knowledge(
      id: 'e1',
      title: '有氧运动的好处',
      content: '有氧运动如快走、跑步、游泳等可以增强心肺功能，提高耐力，燃烧脂肪，改善心血管健康。建议每周进行至少150分钟中等强度有氧运动。',
      category: 'exercise',
      source: '美国心脏协会',
    ),
    Knowledge(
      id: 'e2',
      title: '力量训练的重要性',
      content: '力量训练可以增加肌肉量，提高基础代谢率，增强骨骼密度，预防骨质疏松。建议每周进行2-3次力量训练。',
      category: 'exercise',
      source: '美国运动医学会',
    ),
    Knowledge(
      id: 'e3',
      title: '运动与心理健康',
      content: '规律运动可以释放内啡肽，改善情绪，减轻压力和焦虑，预防抑郁。运动后大脑更加清晰，思维更加敏捷。',
      category: 'exercise',
      source: '世界卫生组织',
    ),
    Knowledge(
      id: 'e4',
      title: '运动前后的热身与放松',
      content: '运动前热身可以预防受伤，运动后拉伸可以缓解肌肉酸痛，促进恢复。热身和放松各需5-10分钟。',
      category: 'exercise',
      source: '运动医学研究',
    ),
    Knowledge(
      id: 'e5',
      title: '循序渐进的原则',
      content: '开始新的运动计划时应循序渐进，逐渐增加运动强度和时长，给身体适应的时间，避免过度训练导致受伤。',
      category: 'exercise',
      source: '美国运动医学会',
    ),
    Knowledge(
      id: 'e6',
      title: '运动与长寿',
      content: '研究表明，规律运动的人比久坐不动的人寿命更长，患慢性疾病的风险更低。运动是延长健康寿命的有效途径。',
      category: 'exercise',
      source: '《柳叶刀》研究',
    ),
  ];

  static final List<Knowledge> _moodKnowledge = [
    Knowledge(
      id: 'm1',
      title: '积极心态的力量',
      content: '积极乐观的心态可以增强免疫力，降低压力激素水平，改善心血管健康。保持感恩之心，关注生活中的美好事物。',
      category: 'mood',
      source: '积极心理学研究',
    ),
    Knowledge(
      id: 'm2',
      title: '正念冥想的益处',
      content: '正念冥想可以帮助我们更好地觉察当下，减少焦虑和抑郁，提高专注力和情绪调节能力。建议每天练习10-15分钟。',
      category: 'mood',
      source: '哈佛医学院',
    ),
    Knowledge(
      id: 'm3',
      title: '压力管理技巧',
      content: '有效的压力管理包括深呼吸、冥想、运动、社交支持等。学会说"不"，合理安排工作和休息时间。',
      category: 'mood',
      source: '美国心理学会',
    ),
    Knowledge(
      id: 'm4',
      title: '社交联系的重要性',
      content: '良好的人际关系和社交联系可以减少孤独感，提高幸福感，增强心理韧性。定期与亲友交流，参与社交活动。',
      category: 'mood',
      source: '《美国国家科学院院刊》',
    ),
    Knowledge(
      id: 'm5',
      title: '培养兴趣爱好',
      content: '培养兴趣爱好可以丰富生活，提供成就感，缓解压力。无论是音乐、绘画、园艺还是阅读，都能带来心灵的满足。',
      category: 'mood',
      source: '心理学研究',
    ),
    Knowledge(
      id: 'm6',
      title: '心理健康与长寿',
      content: '心理健康与身体健康密切相关。保持良好的心理状态可以降低心血管疾病风险，延长寿命，提高生活质量。',
      category: 'mood',
      source: '世界卫生组织',
    ),
  ];

  static List<Knowledge> getKnowledgeByCategory(String category) {
    switch (category) {
      case 'sleep':
        return _sleepKnowledge;
      case 'diet':
        return _dietKnowledge;
      case 'exercise':
        return _exerciseKnowledge;
      case 'mood':
        return _moodKnowledge;
      default:
        return [];
    }
  }

  static Knowledge getTodayKnowledge(String category) {
    List<Knowledge> knowledgeList = getKnowledgeByCategory(category);
    if (knowledgeList.isEmpty) {
      return Knowledge(
        id: 'default',
        title: '暂无内容',
        content: '敬请期待更多健康知识',
        category: category,
        source: '',
      );
    }

    int dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
    int index = dayOfYear % knowledgeList.length;
    
    return knowledgeList[index];
  }

  static List<Knowledge> getWeeklyKnowledge(String category) {
    List<Knowledge> knowledgeList = getKnowledgeByCategory(category);
    if (knowledgeList.isEmpty) return [];

    int dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
    int startIndex = (dayOfYear ~/ 7) % knowledgeList.length;
    
    List<Knowledge> weekly = [];
    for (int i = 0; i < min(7, knowledgeList.length); i++) {
      weekly.add(knowledgeList[(startIndex + i) % knowledgeList.length]);
    }
    
    return weekly;
  }
}