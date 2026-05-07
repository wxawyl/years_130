// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '活到130岁';

  @override
  String get todayHealthScore => '今日健康评分';

  @override
  String get loadingFailed => '加载失败，请重试';

  @override
  String get fourDimensions => '四大维度';

  @override
  String get sleep => '睡眠';

  @override
  String get diet => '饮食';

  @override
  String get exercise => '运动';

  @override
  String get mood => '心态';

  @override
  String get quickRecord => '快速记录';

  @override
  String get home => '首页';

  @override
  String get veryGood => '🎉 非常棒！继续保持健康生活！';

  @override
  String get good => '👍 不错！还有提升空间';

  @override
  String get needsWork => '💪 加油！需要更加努力';

  @override
  String get takeCare => '😅 今天也要好好照顾自己哦';

  @override
  String get todayIntake => '今日摄入';

  @override
  String get calories => '卡路里';

  @override
  String get protein => '蛋白质(g)';

  @override
  String get carbs => '碳水(g)';

  @override
  String get fat => '脂肪(g)';

  @override
  String get photoRecognize => '拍照识别食物';

  @override
  String get aiRecognition => 'AI智能识别 · 自动计算卡路里';

  @override
  String get quickAddFood => '快速添加食物';

  @override
  String get recordDiet => '记录饮食';

  @override
  String get mealType => '餐次';

  @override
  String get breakfast => '早餐';

  @override
  String get lunch => '午餐';

  @override
  String get dinner => '晚餐';

  @override
  String get snack => '零食';

  @override
  String get foodName => '食物名称';

  @override
  String get servings => '份量';

  @override
  String get saveRecord => '保存记录';

  @override
  String get todayRecords => '今日记录';

  @override
  String get noRecordsToday => '暂无今日饮食记录';

  @override
  String get dietEducation => '饮食科普';

  @override
  String get source => '来源';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get confirmDelete => '确认删除';

  @override
  String confirmDeleteMessage(String foodName) {
    return '确定要删除 \"$foodName\" 这条记录吗？';
  }

  @override
  String get recordSaved => '饮食记录保存成功！';

  @override
  String get recordUpdated => '记录更新成功！';

  @override
  String get recordDeleted => '记录已删除';

  @override
  String foodsRecognized(int count, int calories) {
    return '已识别 $count 种食物，总计 $calories kcal';
  }

  @override
  String get editDietRecord => '编辑饮食记录';

  @override
  String get sleepManagement => '睡眠管理';

  @override
  String get sleepDuration => '睡眠时长';

  @override
  String get sleepQuality => '睡眠质量';

  @override
  String get bedtime => '入睡时间';

  @override
  String get wakeTime => '起床时间';

  @override
  String get hours => '小时';

  @override
  String get recordSleep => '记录睡眠';

  @override
  String get sleepRecordSaved => '睡眠记录保存成功！';

  @override
  String get noSleepRecords => '暂无今日睡眠记录';

  @override
  String get sleepEducation => '睡眠科普';

  @override
  String get exerciseManagement => '运动管理';

  @override
  String get exerciseType => '运动类型';

  @override
  String get duration => '时长';

  @override
  String get minutes => '分钟';

  @override
  String get caloriesBurned => '消耗卡路里';

  @override
  String get recordExercise => '记录运动';

  @override
  String get exerciseRecordSaved => '运动记录保存成功！';

  @override
  String get noExerciseRecords => '暂无今日运动记录';

  @override
  String get exerciseEducation => '运动科普';

  @override
  String get walking => '步行';

  @override
  String get running => '跑步';

  @override
  String get cycling => '骑行';

  @override
  String get swimming => '游泳';

  @override
  String get yoga => '瑜伽';

  @override
  String get gym => '健身';

  @override
  String get moodManagement => '心态管理';

  @override
  String get moodLevel => '心态指数';

  @override
  String get note => '备注';

  @override
  String get recordMood => '记录心态';

  @override
  String get moodRecordSaved => '心态记录保存成功！';

  @override
  String get noMoodRecords => '暂无今日心态记录';

  @override
  String get moodEducation => '心态科普';

  @override
  String get veryHappy => '非常开心';

  @override
  String get happy => '开心';

  @override
  String get normal => '一般';

  @override
  String get sad => '难过';

  @override
  String get verySad => '非常难过';

  @override
  String get meditationMusic => '冥想音乐';

  @override
  String get presetMusic => '预置音乐';

  @override
  String get startMeditation => '开始冥想';

  @override
  String get stopMeditation => '停止冥想';

  @override
  String get nowPlaying => '正在播放';

  @override
  String get playFailed => '播放失败，请重试';

  @override
  String get language => '语言';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get spanish => 'Español';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get settings => '设置';
}
