import 'dart:math';
import 'package:intl/intl.dart';
import '../models/knowledge_item.dart';

class KnowledgeService {
  static final List<KnowledgeItem> _sleepKnowledge = [
    KnowledgeItem(
      id: 1,
      category: 1,
      title: '优质睡眠的重要性',
      content: '睡眠是身体修复和大脑整理记忆的关键时期。长期睡眠不足会导致免疫力下降、记忆力减退、情绪波动等问题。建议每晚保证7-9小时的高质量睡眠。',
      source: '世界卫生组织',
    ),
    KnowledgeItem(
      id: 2,
      category: 1,
      title: '睡眠周期的奥秘',
      content: '一个完整的睡眠周期约90分钟，包含浅睡眠、深睡眠和快速眼动睡眠阶段。深睡眠阶段对身体修复至关重要，而REM睡眠则与梦境和学习记忆相关。',
      source: '美国睡眠医学学会',
    ),
    KnowledgeItem(
      id: 3,
      category: 1,
      title: '如何改善睡眠质量',
      content: '保持规律的作息时间，创造舒适的睡眠环境，避免睡前使用电子设备，适当进行体育锻炼，避免咖啡因和酒精摄入。',
      source: '中国睡眠研究会',
    ),
    KnowledgeItem(
      id: 4,
      category: 1,
      title: '午睡的好处',
      content: '适量的午睡（20-30分钟）可以有效提升下午的工作效率和注意力，改善情绪状态。但午睡时间过长可能会影响夜间睡眠。',
      source: '哈佛医学院',
    ),
    KnowledgeItem(
      id: 5,
      category: 1,
      title: '睡眠与长寿的关系',
      content: '研究表明，每晚睡眠7小时的人比睡眠少于6小时或多于8小时的人寿命更长。规律的睡眠模式是长寿的重要因素之一。',
      source: '《自然》杂志研究',
    ),
    KnowledgeItem(
      id: 6,
      category: 1,
      title: '睡眠障碍的信号',
      content: '如果经常入睡困难、夜间醒来多次，白天嗜睡、打鼾严重或有呼吸暂停现象，可能是睡眠障碍的信号，建议及时咨询医生。',
      source: '国际睡眠研究学会',
    ),
    KnowledgeItem(
      id: 7,
      category: 1,
      title: '褪黑素与睡眠',
      content: '褪黑素是调节睡眠周期的关键激素。天黑后体内褪黑素分泌增加，促使我们产生睡意。保持规律的作息有助于维持褪黑素的正常分泌。',
      source: '神经科学研究',
    ),
    KnowledgeItem(
      id: 8,
      category: 1,
      title: '睡眠与免疫系统',
      content: '睡眠不足会显著降低免疫力。充足的睡眠有助于免疫细胞的恢复和增殖，提高身体抵抗感染的能力。',
      source: '免疫学研究',
    ),
    KnowledgeItem(
      id: 9,
      category: 1,
      title: '最佳睡眠温度',
      content: '卧室温度对睡眠质量影响重大。研究表明，18-20摄氏度是最适宜的睡眠温度。过高或过低的温度都会影响入睡和睡眠深度。',
      source: '睡眠环境研究',
    ),
    KnowledgeItem(
      id: 10,
      category: 1,
      title: '睡眠与体重管理',
      content: '睡眠不足会影响调节食欲的激素，可能导致食欲增加和代谢减慢。保证充足睡眠是体重管理的重要环节。',
      source: '内分泌学研究',
    ),
    KnowledgeItem(
      id: 11,
      category: 1,
      title: '睡前饮食建议',
      content: '睡前2-3小时避免进食，特别是高脂肪、辛辣食物和咖啡因。如果需要宵夜，选择温牛奶或香蕉等易消化食物。',
      source: '营养学指南',
    ),
    KnowledgeItem(
      id: 12,
      category: 1,
      title: '光线对睡眠的影响',
      content: '蓝光会抑制褪黑素分泌，影响入睡。建议睡前1小时关闭手机、电脑等电子设备，或使用蓝光过滤应用。',
      source: '眼科研究',
    ),
    KnowledgeItem(
      id: 13,
      category: 1,
      title: '运动与睡眠的关系',
      content: '规律运动可以显著改善睡眠质量，但应避免在睡前3小时内进行剧烈运动。早晨或下午的运动最能促进夜间睡眠。',
      source: '运动医学研究',
    ),
    KnowledgeItem(
      id: 14,
      category: 1,
      title: '睡眠呼吸暂停综合征',
      content: '睡眠呼吸暂停会导致夜间反复缺氧，严重影响睡眠质量和白天精神状态。超重、吸烟、饮酒者风险较高，应及时就医。',
      source: '呼吸科医学',
    ),
    KnowledgeItem(
      id: 15,
      category: 1,
      title: '做梦的科学',
      content: 'REM睡眠阶段的梦境有助于情绪处理和记忆整合。每个人每晚平均做4-6个梦，梦的内容通常与近期经历和情绪相关。',
      source: '神经心理学研究',
    ),
    KnowledgeItem(
      id: 16,
      category: 1,
      title: '睡眠债务的累积',
      content: '周末补觉无法完全弥补工作日的睡眠债务。长期睡眠不足会累积健康风险。建议保持每天一致的睡眠时间。',
      source: '睡眠医学研究',
    ),
    KnowledgeItem(
      id: 17,
      category: 1,
      title: '酒精对睡眠的影响',
      content: '虽然酒精可以帮助入睡，但它会显著降低睡眠质量，导致夜间频繁醒来和浅睡眠。饮酒后睡眠往往休息不足。',
      source: '成瘾医学研究',
    ),
    KnowledgeItem(
      id: 18,
      category: 1,
      title: '睡眠与皮肤健康',
      content: '睡眠时皮肤会进行修复和再生。充足的睡眠促进胶原蛋白生成，延缓衰老。长期睡眠不足会导致黑眼圈和皮肤暗沉。',
      source: '皮肤科研究',
    ),
    KnowledgeItem(
      id: 19,
      category: 1,
      title: '创建睡眠仪式',
      content: '固定的睡前仪式（如洗澡、读书、冥想）可以帮助大脑识别睡眠信号，更容易进入放松状态，提高入睡效率。',
      source: '行为医学研究',
    ),
    KnowledgeItem(
      id: 20,
      category: 1,
      title: '床垫和枕头的重要性',
      content: '合适的床垫和枕头对睡眠质量至关重要。床垫应支撑脊椎自然曲线，枕头高度以保持颈椎中立位为宜。建议每7-10年更换床垫。',
      source: '骨科研究',
    ),
    KnowledgeItem(
      id: 21,
      category: 1,
      title: '睡眠与心脏健康',
      content: '长期睡眠不足会增加高血压、心脏病和中风的风险。每晚7-8小时的睡眠是维护心血管健康的理想时长。',
      source: '心脏病学研究',
    ),
    KnowledgeItem(
      id: 22,
      category: 1,
      title: '睡眠与糖尿病',
      content: '睡眠不足会降低胰岛素敏感性，影响血糖控制。长期睡眠问题可能增加2型糖尿病风险。良好的睡眠是糖尿病预防的重要措施。',
      source: '糖尿病研究',
    ),
    KnowledgeItem(
      id: 23,
      category: 1,
      title: '快速入睡的技巧',
      content: '尝试"4-7-8呼吸法"：吸气4秒，屏气7秒，呼气8秒，重复3-4次。这个技巧可以激活副交感神经，帮助放松和入睡。',
      source: '减压技术研究',
    ),
    KnowledgeItem(
      id: 24,
      category: 1,
      title: '睡眠与认知功能',
      content: '睡眠对记忆巩固至关重要。学习后睡眠有助于将短期记忆转化为长期记忆。睡眠不足会严重影响注意力和决策能力。',
      source: '认知科学研究',
    ),
    KnowledgeItem(
      id: 25,
      category: 1,
      title: '倒班工作者的睡眠',
      content: '倒班工作打乱生理节律，增加健康风险。建议利用遮光窗帘创造黑暗环境，坚持固定的睡眠-觉醒时间表。',
      source: '职业健康研究',
    ),
    KnowledgeItem(
      id: 26,
      category: 1,
      title: '睡前放松音乐',
      content: '舒缓的音乐可以降低心率和血压，促进放松。建议选择60-80 BPM的缓慢音乐，如古典音乐或白噪音。',
      source: '音乐疗法研究',
    ),
    KnowledgeItem(
      id: 27,
      category: 1,
      title: '睡眠与情绪调节',
      content: '睡眠不足会放大负面情绪，降低情绪调节能力。一晚好眠可以显著改善情绪状态和压力应对能力。',
      source: '情绪研究',
    ),
    KnowledgeItem(
      id: 28,
      category: 1,
      title: '卧室环境优化',
      content: '卧室应该只用于睡眠和休息，保持安静、黑暗和凉爽。移除电视、电脑等干扰物品，建立床与睡眠的强关联。',
      source: '睡眠卫生教育',
    ),
    KnowledgeItem(
      id: 29,
      category: 1,
      title: '咖啡因的影响',
      content: '咖啡因的半衰期约5-6小时，下午3点后摄入咖啡因可能影响夜间睡眠。巧克力、某些止痛药和能量饮料也含咖啡因。',
      source: '神经药理学研究',
    ),
    KnowledgeItem(
      id: 30,
      category: 1,
      title: '睡眠日志的价值',
      content: '记录睡眠日志有助于发现睡眠问题和模式。记录睡眠时间、醒来次数、白天精力水平等，可以为改善睡眠提供依据。',
      source: '自我健康管理',
    ),
  ];

  static final List<KnowledgeItem> _dietKnowledge = [
    KnowledgeItem(
      id: 31,
      category: 2,
      title: '均衡饮食的基本原则',
      content: '均衡饮食应包含适量的蛋白质、碳水化合物、脂肪、维生素和矿物质。建议每日摄入多种颜色的蔬菜和水果，保持饮食多样化。',
      source: '中国营养学会',
    ),
    KnowledgeItem(
      id: 32,
      category: 2,
      title: '地中海饮食与健康',
      content: '地中海饮食以橄榄油、鱼类、坚果、全谷物和大量蔬菜为特点，被证明能有效降低心脏病、糖尿病和某些癌症的风险。',
      source: '世界卫生组织',
    ),
    KnowledgeItem(
      id: 33,
      category: 2,
      title: '膳食纤维的重要性',
      content: '膳食纤维有助于维持肠道健康，促进消化，降低胆固醇水平，控制血糖。建议每日摄入25-30克膳食纤维。',
      source: '美国农业部',
    ),
    KnowledgeItem(
      id: 34,
      category: 2,
      title: '适量饮水的好处',
      content: '每天饮用足够的水有助于维持身体正常代谢，促进废物排出，保持皮肤健康。建议每日饮水量不少于1.5-2升。',
      source: '中国居民膳食指南',
    ),
    KnowledgeItem(
      id: 35,
      category: 2,
      title: '少食多餐的益处',
      content: '少食多餐可以避免暴饮暴食，保持血糖稳定，提高新陈代谢效率。建议每日三餐为主，可适当增加1-2次健康加餐。',
      source: '营养科学研究',
    ),
    KnowledgeItem(
      id: 36,
      category: 2,
      title: '抗氧化食物与抗衰老',
      content: '富含抗氧化剂的食物如蓝莓、西兰花、紫甘蓝等可以帮助清除体内自由基，减缓细胞老化，延缓衰老过程。',
      source: '美国国立卫生研究院',
    ),
    KnowledgeItem(
      id: 37,
      category: 2,
      title: '蛋白质的重要性',
      content: '蛋白质是身体建造和修复组织的基础。优质蛋白来源包括鱼、禽、瘦肉、蛋、奶、豆类。建议每餐都摄入适量蛋白质。',
      source: '营养学指南',
    ),
    KnowledgeItem(
      id: 38,
      category: 2,
      title: '健康脂肪的选择',
      content: '应优先选择不饱和脂肪酸，如橄榄油、鱼油、坚果中的脂肪。限制饱和脂肪和反式脂肪的摄入，有助于心血管健康。',
      source: '美国心脏协会',
    ),
    KnowledgeItem(
      id: 39,
      category: 2,
      title: '控糖的必要性',
      content: '过多摄入添加糖会导致肥胖、糖尿病和心血管疾病。世界卫生组织建议每日添加糖摄入不超过25克。',
      source: '世界卫生组织',
    ),
    KnowledgeItem(
      id: 40,
      category: 2,
      title: '蔬菜彩虹原则',
      content: '每天摄入多种颜色的蔬菜可获得全面的营养素。绿色提供叶酸，橙色提供胡萝卜素，紫色提供花青素。',
      source: '美国癌症协会',
    ),
    KnowledgeItem(
      id: 41,
      category: 2,
      title: '水果的健康益处',
      content: '水果富含维生素、矿物质和膳食纤维。建议每天摄入2-3份不同颜色的水果。优先选择完整水果而非果汁。',
      source: '营养学研究',
    ),
    KnowledgeItem(
      id: 42,
      category: 2,
      title: '全谷物的价值',
      content: '全谷物保留完整的麸皮和胚芽，富含B族维生素、膳食纤维和矿物质。推荐用全麦面包、糙米、燕麦等替代精制谷物。',
      source: '哈佛公共卫生学院',
    ),
    KnowledgeItem(
      id: 43,
      category: 2,
      title: 'Omega-3脂肪酸的健康功效',
      content: 'Omega-3主要存在于深海鱼类、亚麻籽和核桃中，有助于降低炎症，保护心脏和大脑健康。',
      source: '美国国立补充与整合健康中心',
    ),
    KnowledgeItem(
      id: 44,
      category: 2,
      title: '盐分摄入的控制',
      content: '高盐饮食与高血压密切相关。中国营养学会建议每日盐摄入不超过6克。减少腌制食品和加工食品的摄入。',
      source: '中国营养学会',
    ),
    KnowledgeItem(
      id: 45,
      category: 2,
      title: '益生菌与肠道健康',
      content: '益生菌有助于维护肠道菌群平衡，改善消化功能。富含益生菌的食物包括酸奶、泡菜、味增和康普茶。',
      source: '肠道微生物研究',
    ),
    KnowledgeItem(
      id: 46,
      category: 2,
      title: '早餐的重要性',
      content: '吃早餐可以启动新陈代谢，稳定血糖水平，提高上午的专注力和工作效率。一顿营养均衡的早餐应包含蛋白质、碳水和蔬果。',
      source: '营养心理学研究',
    ),
    KnowledgeItem(
      id: 47,
      category: 2,
      title: '坚果的营养价值',
      content: '坚果富含健康脂肪、蛋白质、纤维和抗氧化物质。每天适量食用一小把坚果（约30克）可以降低心脏病风险。',
      source: '美国心脏协会',
    ),
    KnowledgeItem(
      id: 48,
      category: 2,
      title: '蔬菜的烹饪方式',
      content: '过度烹饪会破坏蔬菜中的维生素。建议采用蒸、炒或生吃的方式保留营养。蔬菜沙拉可以保留最多的维生素和酶。',
      source: '食品科学',
    ),
    KnowledgeItem(
      id: 49,
      category: 2,
      title: '乳制品的选择',
      content: '乳制品是钙和维生素D的重要来源。对于乳糖不耐受的人，可以选择酸奶或低乳糖牛奶。',
      source: '中国营养学会',
    ),
    KnowledgeItem(
      id: 50,
      category: 2,
      title: '健康零食的选择',
      content: '选择健康的零食可以避免血糖波动和暴饮暴食。推荐水果、坚果、酸奶或蔬菜棒作为零食。',
      source: '营养学建议',
    ),
    KnowledgeItem(
      id: 51,
      category: 2,
      title: '深色蔬菜的营养优势',
      content: '深绿色、橙红色和紫红色蔬菜通常含有更丰富的营养素。如菠菜、西兰花、胡萝卜、甜菜等应成为日常饮食的重要组成部分。',
      source: 'USDA营养数据库',
    ),
    KnowledgeItem(
      id: 52,
      category: 2,
      title: '豆类的健康益处',
      content: '豆类是优质植物蛋白来源，同时含有丰富的膳食纤维和矿物质。经常食用豆腐、豆浆、黑豆等有助于降低胆固醇。',
      source: '美国糖尿病协会',
    ),
    KnowledgeItem(
      id: 53,
      category: 2,
      title: '食物过敏与不耐受',
      content: '食物过敏和不耐受会影响健康和生活质量。常见的过敏原包括牛奶、鸡蛋、花生、海鲜等。',
      source: '过敏与免疫学研究',
    ),
    KnowledgeItem(
      id: 54,
      category: 2,
      title: '调味品的健康选择',
      content: '过多的酱料和调味品会增加钠和糖的摄入。使用香草、香料、柠檬汁等天然调味品可以减少盐和糖的使用。',
      source: '营养建议',
    ),
    KnowledgeItem(
      id: 55,
      category: 2,
      title: '鱼类的好处',
      content: '鱼类是优质蛋白质和Omega-3脂肪酸的重要来源。经常食用鱼类可以降低心脏病风险、改善大脑功能。',
      source: '美国心脏协会',
    ),
    KnowledgeItem(
      id: 56,
      category: 2,
      title: '喝茶的健康益处',
      content: '茶叶富含抗氧化剂和儿茶素，有助于保护心脏、抗炎和改善新陈代谢。绿茶、乌龙茶和普洱茶各有不同的健康功效。',
      source: '茶与健康研究',
    ),
    KnowledgeItem(
      id: 57,
      category: 2,
      title: '咖啡的适量饮用',
      content: '适量饮用咖啡与多种健康益处相关，包括提高警觉性、降低帕金森病和2型糖尿病风险。',
      source: '咖啡健康研究',
    ),
    KnowledgeItem(
      id: 58,
      category: 2,
      title: '超级食物的迷思',
      content: '没有单一食物能提供所有营养。多样化的饮食比依赖所谓的"超级食物"更健康。',
      source: '营养科学',
    ),
    KnowledgeItem(
      id: 59,
      category: 2,
      title: '节日饮食的健康策略',
      content: '节日期间容易暴饮暴食。建议餐前喝一杯水，多吃蔬菜，控制甜食和酒精摄入。',
      source: '健康饮食指南',
    ),
    KnowledgeItem(
      id: 60,
      category: 2,
      title: '素食者的营养平衡',
      content: '素食者需要注意补充维生素B12、铁、锌和蛋白质。通过豆类、坚果、全谷物和强化食品来满足营养需求。',
      source: '营养学研究',
    ),
  ];

  static final List<KnowledgeItem> _exerciseKnowledge = [
    KnowledgeItem(
      id: 61,
      category: 3,
      title: '有氧运动的好处',
      content: '有氧运动如快走、跑步、游泳等可以增强心肺功能，提高耐力，燃烧脂肪，改善心血管健康。',
      source: '美国心脏协会',
    ),
    KnowledgeItem(
      id: 62,
      category: 3,
      title: '力量训练的重要性',
      content: '力量训练可以增加肌肉量，提高基础代谢率，增强骨骼密度，预防骨质疏松。建议每周进行2-3次力量训练。',
      source: '美国运动医学会',
    ),
    KnowledgeItem(
      id: 63,
      category: 3,
      title: '运动与心理健康',
      content: '规律运动可以释放内啡肽，改善情绪，减轻压力和焦虑，预防抑郁。运动后大脑更加清晰，思维更加敏捷。',
      source: '世界卫生组织',
    ),
    KnowledgeItem(
      id: 64,
      category: 3,
      title: '运动前后的热身与放松',
      content: '运动前热身可以预防受伤，运动后拉伸可以缓解肌肉酸痛，促进恢复。热身和放松各需5-10分钟。',
      source: '运动医学研究',
    ),
    KnowledgeItem(
      id: 65,
      category: 3,
      title: '循序渐进的原则',
      content: '开始新的运动计划时应循序渐进，逐渐增加运动强度和时长，给身体适应的时间，避免过度训练导致受伤。',
      source: '美国运动医学会',
    ),
    KnowledgeItem(
      id: 66,
      category: 3,
      title: '运动与长寿',
      content: '研究表明，规律运动的人比久坐不动的人寿命更长，患慢性疾病的风险更低。运动是延长健康寿命的有效途径。',
      source: '《柳叶刀》研究',
    ),
    KnowledgeItem(
      id: 67,
      category: 3,
      title: 'HIIT训练的效果',
      content: '高强度间歇训练（HIIT）可以在短时间内燃烧大量卡路里，提高代谢率。只需15-20分钟就能获得良好的训练效果。',
      source: '运动生理学研究',
    ),
    KnowledgeItem(
      id: 68,
      category: 3,
      title: '柔韧性训练的重要性',
      content: '定期拉伸可以提高柔韧性，减少受伤风险，改善姿势，缓解肌肉紧张。建议每次运动后进行10-15分钟的拉伸。',
      source: '运动医学指南',
    ),
    KnowledgeItem(
      id: 69,
      category: 3,
      title: '核心肌群训练',
      content: '核心肌群包括腹部、背部和骨盆周围的肌肉。强大的核心可以提高运动表现，改善平衡，预防腰背疼痛。',
      source: '健身研究',
    ),
    KnowledgeItem(
      id: 70,
      category: 3,
      title: '运动与骨骼健康',
      content: '负重运动如步行、跑步和力量训练可以增强骨密度，预防骨质疏松。建议每周进行至少150分钟的中等强度运动。',
      source: '骨科研究',
    ),
    KnowledgeItem(
      id: 71,
      category: 3,
      title: '运动后的恢复',
      content: '运动后24-48小时的恢复期同样重要。保证充足的睡眠，补充蛋白质和水分，进行轻度活动促进血液循环。',
      source: '运动科学',
    ),
    KnowledgeItem(
      id: 72,
      category: 3,
      title: '步行健身法',
      content: '快走是最简单有效的有氧运动之一。每天步行30-60分钟可以改善心血管健康，降低血压，控制体重。',
      source: '心脏病预防',
    ),
    KnowledgeItem(
      id: 73,
      category: 3,
      title: '瑜伽的身心益处',
      content: '瑜伽结合了体式、呼吸和冥想，可以改善柔韧性、平衡感和心理健康。规律的瑜伽练习可以减轻焦虑和压力。',
      source: '综合医学研究',
    ),
    KnowledgeItem(
      id: 74,
      category: 3,
      title: '游泳的全身锻炼',
      content: '游泳是极佳的有氧运动，对关节压力小，能同时锻炼全身肌肉。水中的阻力可以增强肌肉力量和心肺功能。',
      source: '运动医学',
    ),
    KnowledgeItem(
      id: 75,
      category: 3,
      title: '骑行的健康益处',
      content: '骑行可以强化心肺功能，锻炼下肢肌肉，对膝关节友好。无论是户外骑行还是室内动感单车，都是很好的运动选择。',
      source: '运动生理学',
    ),
    KnowledgeItem(
      id: 76,
      category: 3,
      title: '办公室运动指南',
      content: '久坐办公的人群应每小时起身活动5-10分钟。简单的伸展、深蹲、步行可以改善血液循环。',
      source: '职业健康',
    ),
    KnowledgeItem(
      id: 77,
      category: 3,
      title: '老年人运动建议',
      content: '老年人适合进行低冲击运动如散步、太极、水中运动等。每周进行2-3次力量训练可以预防肌肉流失。',
      source: '老年医学',
    ),
    KnowledgeItem(
      id: 78,
      category: 3,
      title: '运动前的热身',
      content: '热身可以提高肌肉温度，增加关节活动范围，减少受伤风险。建议进行5-10分钟的低强度有氧活动。',
      source: '运动训练学',
    ),
    KnowledgeItem(
      id: 79,
      category: 3,
      title: '运动强度的判断',
      content: '使用"说话测试"判断运动强度：能正常说话说明强度适中，无法说话说明强度过高。',
      source: '健身指南',
    ),
    KnowledgeItem(
      id: 80,
      category: 3,
      title: '儿童和青少年的运动',
      content: '儿童和青少年每天应进行至少60分钟的中等强度到高强度运动。这有助于身体发育和良好习惯的养成。',
      source: '青少年健康',
    ),
    KnowledgeItem(
      id: 81,
      category: 3,
      title: '运动与免疫力',
      content: '适度的规律运动可以增强免疫力，但过度训练会暂时削弱免疫功能。保持中等强度的运动频率最为理想。',
      source: '运动免疫学',
    ),
    KnowledgeItem(
      id: 82,
      category: 3,
      title: '居家健身计划',
      content: '不需要器械也能进行有效的锻炼。俯卧撑、深蹲、平板支撑等动作可以锻炼全身主要肌群。',
      source: '健身教学',
    ),
    KnowledgeItem(
      id: 83,
      category: 3,
      title: '跑步的正确姿势',
      content: '保持身体直立，目视前方，手臂自然摆动，步幅适中。着地时脚掌中部先触地，可以减少对关节的冲击。',
      source: '跑步研究',
    ),
    KnowledgeItem(
      id: 84,
      category: 3,
      title: '交叉训练的好处',
      content: '将不同类型的运动结合起来可以全面发展身体素质，避免单一运动带来的过度使用伤害。',
      source: '运动训练',
    ),
    KnowledgeItem(
      id: 85,
      category: 3,
      title: '运动与糖尿病预防',
      content: '规律运动可以提高胰岛素敏感性，帮助控制血糖。每周进行150分钟的中等强度运动可以显著降低2型糖尿病风险。',
      source: '糖尿病研究',
    ),
    KnowledgeItem(
      id: 86,
      category: 3,
      title: '普拉提的健身效果',
      content: '普拉提强调核心控制和精确的动作，可以增强深层肌肉，改善姿势，提高身体控制能力和平衡感。',
      source: '健身研究',
    ),
    KnowledgeItem(
      id: 87,
      category: 3,
      title: '如何坚持运动习惯',
      content: '从小目标开始，选择喜欢的运动，固定运动时间，记录进度，找运动伙伴都是保持运动习惯的有效策略。',
      source: '行为科学',
    ),
    KnowledgeItem(
      id: 88,
      category: 3,
      title: '登山和徒步的健康益处',
      content: '登山和徒步不仅能锻炼心肺功能和下肢力量，还能接触自然，减轻压力，提升心理健康。',
      source: '户外运动研究',
    ),
    KnowledgeItem(
      id: 89,
      category: 3,
      title: '冬季运动注意事项',
      content: '冬季运动要注意保暖热身，选择合适的时间，注意路面结冰情况。室内运动可以作为恶劣天气下的替代选择。',
      source: '运动医学',
    ),
    KnowledgeItem(
      id: 90,
      category: 3,
      title: '女性运动指南',
      content: '女性运动应注重力量训练维护骨密度，有氧运动控制体重，柔韧性训练缓解压力。',
      source: '女性健康',
    ),
  ];

  static final List<KnowledgeItem> _moodKnowledge = [
    KnowledgeItem(
      id: 91,
      category: 4,
      title: '积极心态的力量',
      content: '积极乐观的心态可以增强免疫力，降低压力激素水平，改善心血管健康。保持感恩之心，关注生活中的美好事物。',
      source: '积极心理学研究',
    ),
    KnowledgeItem(
      id: 92,
      category: 4,
      title: '正念冥想的益处',
      content: '正念冥想可以帮助我们更好地觉察当下，减少焦虑和抑郁，提高专注力和情绪调节能力。建议每天练习10-15分钟。',
      source: '哈佛医学院',
    ),
    KnowledgeItem(
      id: 93,
      category: 4,
      title: '压力管理技巧',
      content: '有效的压力管理包括深呼吸、冥想、运动、社交支持等。学会说"不"，合理安排工作和休息时间。',
      source: '美国心理学会',
    ),
    KnowledgeItem(
      id: 94,
      category: 4,
      title: '社交联系的重要性',
      content: '良好的人际关系和社交联系可以减少孤独感，提高幸福感，增强心理韧性。定期与亲友交流，参与社交活动。',
      source: '《美国国家科学院院刊》',
    ),
    KnowledgeItem(
      id: 95,
      category: 4,
      title: '培养兴趣爱好',
      content: '培养兴趣爱好可以丰富生活，提供成就感，缓解压力。无论是音乐、绘画、园艺还是阅读，都能带来心灵的满足。',
      source: '心理学研究',
    ),
    KnowledgeItem(
      id: 96,
      category: 4,
      title: '心理健康与长寿',
      content: '心理健康与身体健康密切相关。保持良好的心理状态可以降低心血管疾病风险，延长寿命，提高生活质量。',
      source: '世界卫生组织',
    ),
    KnowledgeItem(
      id: 97,
      category: 4,
      title: '感恩的力量',
      content: '每天花几分钟思考感恩的事物可以显著提升幸福感。写感恩日记或向他人表达感谢都是培养感恩心态的好方法。',
      source: '积极心理学',
    ),
    KnowledgeItem(
      id: 98,
      category: 4,
      title: '自我接纳的艺术',
      content: '接纳自己的不完美，不过分苛责自己，认识到每个人都有优点和不足，是心理健康的重要基础。',
      source: '心理学研究',
    ),
    KnowledgeItem(
      id: 99,
      category: 4,
      title: '情绪调节的技巧',
      content: '学会识别和命名自己的情绪，用健康的方式表达它们。深呼吸、转移注意力、寻求支持都是有效的情绪调节策略。',
      source: '情绪管理研究',
    ),
    KnowledgeItem(
      id: 100,
      category: 4,
      title: '睡眠与心理健康',
      content: '睡眠质量和心理健康相互影响。改善睡眠可以提升情绪，而良好的心态也有助于获得更好的睡眠。',
      source: '睡眠心理学',
    ),
    KnowledgeItem(
      id: 101,
      category: 4,
      title: '简化生活的好处',
      content: '减少不必要的物质和事务负担，专注于真正重要的事情，可以减轻心理压力，提升生活满意度。',
      source: '极简生活研究',
    ),
    KnowledgeItem(
      id: 102,
      category: 4,
      title: '大笑的健康益处',
      content: '笑可以释放内啡肽，降低压力激素，改善心肺功能，增强免疫系统。每天都找些让自己开心的事情吧。',
      source: '幽默疗法研究',
    ),
    KnowledgeItem(
      id: 103,
      category: 4,
      title: '数字时代的心理健康',
      content: '减少社交媒体使用时间，避免比较陷阱，保护个人隐私，有助于维护良好的心理健康状态。',
      source: '数字健康研究',
    ),
    KnowledgeItem(
      id: 104,
      category: 4,
      title: '亲密关系的价值',
      content: '高质量的人际关系是幸福感的重要来源。投资时间和精力培养亲密关系，对心理健康有深远影响。',
      source: '社会心理学',
    ),
    KnowledgeItem(
      id: 105,
      category: 4,
      title: '克服拖延症',
      content: '将大任务分解为小步骤，设定明确的截止时间，使用奖励机制，都是克服拖延、提高行动力的有效方法。',
      source: '行为心理学',
    ),
    KnowledgeItem(
      id: 106,
      category: 4,
      title: '音乐疗法的应用',
      content: '音乐可以影响情绪和生理状态。听舒缓的音乐可以降低焦虑和血压，而欢快的音乐可以提升情绪和能量。',
      source: '音乐治疗研究',
    ),
    KnowledgeItem(
      id: 107,
      category: 4,
      title: '拥抱变化的智慧',
      content: '生活中唯一不变的就是变化。培养适应能力和心理弹性，学会在变化中寻找机会，是心理健康的重要能力。',
      source: '心理学研究',
    ),
    KnowledgeItem(
      id: 108,
      category: 4,
      title: '园艺疗法的效果',
      content: '与植物互动可以降低皮质醇水平，减轻焦虑和抑郁症状。种植花草蔬菜能带来成就感和与自然的连接。',
      source: '自然疗法研究',
    ),
    KnowledgeItem(
      id: 109,
      category: 4,
      title: '志愿服务的好处',
      content: '帮助他人可以带来强烈的意义感和满足感。志愿服务不仅利人，也能显著提升自己的心理健康水平。',
      source: '社会学研究',
    ),
    KnowledgeItem(
      id: 110,
      category: 4,
      title: '批判性思维的培养',
      content: '培养批判性思维可以帮助我们更理性地看待问题，减少焦虑和担忧。学会质疑自己的思维模式很重要。',
      source: '认知心理学',
    ),
    KnowledgeItem(
      id: 111,
      category: 4,
      title: '呼吸练习的科学',
      content: '深呼吸可以激活副交感神经系统，降低心率和血压，减轻焦虑。规律的呼吸练习对心理健康有显著益处。',
      source: '神经科学',
    ),
    KnowledgeItem(
      id: 112,
      category: 4,
      title: '工作与生活平衡',
      content: '过度工作会损害心理健康。设定界限，留出时间给家人、朋友和兴趣爱好，是维护心理健康的关键。',
      source: '职业健康',
    ),
    KnowledgeItem(
      id: 113,
      category: 4,
      title: '色彩与情绪',
      content: '不同的颜色可以影响我们的情绪。蓝色和绿色有镇静作用，黄色和橙色可以提升能量和热情。',
      source: '色彩心理学',
    ),
    KnowledgeItem(
      id: 114,
      category: 4,
      title: '宠物与心理健康',
      content: '与宠物互动可以降低孤独感，减轻压力和焦虑。宠物提供无条件的爱和陪伴，对心理健康大有裨益。',
      source: '动物辅助治疗',
    ),
    KnowledgeItem(
      id: 115,
      category: 4,
      title: '设定界限的重要性',
      content: '学会对超出能力范围或违背价值观的事情说不。健康的界限是自我尊重的表现，也是保护心理健康的方式。',
      source: '人际关系心理学',
    ),
    KnowledgeItem(
      id: 116,
      category: 4,
      title: '户外活动的好处',
      content: '在大自然中度过时间可以显著降低压力激素水平，改善情绪。自然光线也有助于调节生物钟和褪黑素分泌。',
      source: '环境心理学',
    ),
    KnowledgeItem(
      id: 117,
      category: 4,
      title: '写作疗法的应用',
      content: '将情绪和想法写下来可以帮助整理思绪，释放情感。无论是日记、自由写作还是感恩记录，都有心理疗愈作用。',
      source: '表达性写作研究',
    ),
    KnowledgeItem(
      id: 118,
      category: 4,
      title: '认知重构技巧',
      content: '学会识别和挑战消极的思维模式，用更平衡、理性的想法替代它们。这种认知重构技术是认知行为疗法的核心。',
      source: '认知行为疗法',
    ),
    KnowledgeItem(
      id: 119,
      category: 4,
      title: '培养成长型思维',
      content: '相信能力可以通过努力和学习而发展，而不是固定的特质。这种思维方式可以增强抗压能力，减少对失败的恐惧。',
      source: '教育心理学',
    ),
    KnowledgeItem(
      id: 120,
      category: 4,
      title: '寻求专业帮助的勇气',
      content: '当心理困扰持续影响生活时，寻求心理咨询或治疗是明智的选择。心理健康专业人员可以提供有效的支持和帮助。',
      source: '心理健康指南',
    ),
  ];

  static List<KnowledgeItem> getKnowledgeByCategory(int category) {
    switch (category) {
      case 1:
        return _sleepKnowledge;
      case 2:
        return _dietKnowledge;
      case 3:
        return _exerciseKnowledge;
      case 4:
        return _moodKnowledge;
      default:
        return [];
    }
  }

  static KnowledgeItem getTodayKnowledge(String category) {
    int cat;
    switch (category) {
      case 'sleep':
        cat = 1;
        break;
      case 'diet':
        cat = 2;
        break;
      case 'exercise':
        cat = 3;
        break;
      case 'mood':
        cat = 4;
        break;
      default:
        return KnowledgeItem(
          id: 0,
          category: 0,
          title: '暂无内容',
          content: '敬请期待更多健康知识',
          source: '',
        );
    }

    List<KnowledgeItem> knowledgeList = getKnowledgeByCategory(cat);
    if (knowledgeList.isEmpty) {
      return KnowledgeItem(
        id: 0,
        category: cat,
        title: '暂无内容',
        content: '敬请期待更多健康知识',
        source: '',
      );
    }

    int dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
    int index = dayOfYear % knowledgeList.length;
    
    return knowledgeList[index];
  }

  static List<KnowledgeItem> getWeeklyKnowledge(String category) {
    int cat;
    switch (category) {
      case 'sleep':
        cat = 1;
        break;
      case 'diet':
        cat = 2;
        break;
      case 'exercise':
        cat = 3;
        break;
      case 'mood':
        cat = 4;
        break;
      default:
        return [];
    }

    List<KnowledgeItem> knowledgeList = getKnowledgeByCategory(cat);
    if (knowledgeList.isEmpty) return [];

    int dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
    int startIndex = (dayOfYear ~/ 7) % knowledgeList.length;
    
    List<KnowledgeItem> weekly = [];
    for (int i = 0; i < min(7, knowledgeList.length); i++) {
      weekly.add(knowledgeList[(startIndex + i) % knowledgeList.length]);
    }
    
    return weekly;
  }
}
