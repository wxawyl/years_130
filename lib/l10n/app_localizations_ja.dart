// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '130歳まで生きる';

  @override
  String get todayHealthScore => '今日の健康スコア';

  @override
  String get loadingFailed => '読み込みに失敗しました。再試行してください';

  @override
  String get fourDimensions => '四大次元';

  @override
  String get sleep => '睡眠';

  @override
  String get diet => '食事';

  @override
  String get exercise => '運動';

  @override
  String get mood => '心态';

  @override
  String get quickRecord => 'クイック記録';

  @override
  String get home => 'ホーム';

  @override
  String get veryGood => '🎉 素晴らしい！健康的な生活を続けてください！';

  @override
  String get good => '👍 良い！まだ改善の余地があります';

  @override
  String get needsWork => '💪 頑張って！もっと努力が必要です';

  @override
  String get takeCare => '😅 今日も 자신을 잘 챙기세요';

  @override
  String get todayIntake => '今日の摂取量';

  @override
  String get calories => 'カロリー';

  @override
  String get protein => 'タンパク質(g)';

  @override
  String get carbs => '炭水化物(g)';

  @override
  String get fat => '脂肪(g)';

  @override
  String get photoRecognize => '写真を撮って食べ物を認識';

  @override
  String get aiRecognition => 'AIスマート認識 · カロリー自動計算';

  @override
  String get quickAddFood => 'クイック追加食べ物';

  @override
  String get recordDiet => '食事を記録';

  @override
  String get mealType => '食事タイプ';

  @override
  String get breakfast => '朝食';

  @override
  String get lunch => '昼食';

  @override
  String get dinner => '夕食';

  @override
  String get snack => '間食';

  @override
  String get foodName => '食べ物名';

  @override
  String get servings => '份数';

  @override
  String get saveRecord => '記録を保存';

  @override
  String get todayRecords => '今日の記録';

  @override
  String get noRecordsToday => '今日の食事記録はありません';

  @override
  String get dietEducation => '食事の知識';

  @override
  String get source => '出典';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get confirmDelete => '削除の確認';

  @override
  String confirmDeleteMessage(String foodName) {
    return '「$foodName」の記録を削除してもよろしいですか？';
  }

  @override
  String get recordSaved => '食事の記録が保存されました！';

  @override
  String get recordUpdated => '記録が更新されました！';

  @override
  String get recordDeleted => '記録が削除されました';

  @override
  String foodsRecognized(int count, int calories) {
    return '$count種類の食べ物が認識されました。合計${calories}kcal';
  }

  @override
  String get editDietRecord => '食事記録を編集';

  @override
  String get sleepManagement => '睡眠管理';

  @override
  String get sleepDuration => '睡眠時間';

  @override
  String get sleepQuality => '睡眠の質';

  @override
  String get bedtime => '就寝時間';

  @override
  String get wakeTime => '起床時間';

  @override
  String get hours => '時間';

  @override
  String get recordSleep => '睡眠を記録';

  @override
  String get sleepRecordSaved => '睡眠記録が保存されました！';

  @override
  String get noSleepRecords => '今日の睡眠記録はありません';

  @override
  String get sleepEducation => '睡眠の知識';

  @override
  String get exerciseManagement => '運動管理';

  @override
  String get exerciseType => '運動タイプ';

  @override
  String get duration => '時間';

  @override
  String get minutes => '分';

  @override
  String get caloriesBurned => '消費カロリー';

  @override
  String get recordExercise => '運動を記録';

  @override
  String get exerciseRecordSaved => '運動記録が保存されました！';

  @override
  String get noExerciseRecords => '今日の運動記録はありません';

  @override
  String get exerciseEducation => '運動の知識';

  @override
  String get walking => 'ウォーキング';

  @override
  String get running => 'ランニング';

  @override
  String get cycling => 'サイクリング';

  @override
  String get swimming => '水泳';

  @override
  String get yoga => 'ヨガ';

  @override
  String get gym => 'トレーニング';

  @override
  String get moodManagement => '心态管理';

  @override
  String get moodLevel => '心态指数';

  @override
  String get note => 'メモ';

  @override
  String get recordMood => '心态を記録';

  @override
  String get moodRecordSaved => '心态記録が保存されました！';

  @override
  String get noMoodRecords => '今日の心态記録はありません';

  @override
  String get moodEducation => '心态の知識';

  @override
  String get veryHappy => 'とても幸せ';

  @override
  String get happy => '幸せ';

  @override
  String get normal => '普通';

  @override
  String get sad => '悲しい';

  @override
  String get verySad => 'とても悲しい';

  @override
  String get meditationMusic => '瞑想音楽';

  @override
  String get presetMusic => 'プリセット音楽';

  @override
  String get startMeditation => '瞑想を開始';

  @override
  String get stopMeditation => '瞑想を停止';

  @override
  String get nowPlaying => '再生中';

  @override
  String get playFailed => '再生に失敗しました。もう一度お試しください';

  @override
  String get language => '言語';

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
  String get selectLanguage => '言語を選択';

  @override
  String get settings => '設定';
}
