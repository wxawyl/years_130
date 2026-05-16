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
  String get pushups => 'Push-ups';

  @override
  String get legRaises => 'Leg Raises';

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

  @override
  String get developer => 'Developer';

  @override
  String get developerCenter => 'Developer Center';

  @override
  String get buildTogether => 'Build Together for Health';

  @override
  String get developerDescription =>
      'Join our community of developers to build the future of health technology';

  @override
  String get getStarted => 'Get Started';

  @override
  String get pluginMarket => 'Plugin Market';

  @override
  String get pluginMarketDescription => 'Extend app functionality with plugins';

  @override
  String get apiDocs => 'API Docs';

  @override
  String get apiDocsDescription => 'Access our RESTful API documentation';

  @override
  String get github => 'GitHub';

  @override
  String get githubDescription => 'Contribute to our open source project';

  @override
  String get community => 'Community';

  @override
  String get communityDescription => 'Connect with other developers';

  @override
  String get aiMarket => 'AI Model Market';

  @override
  String get aiMarketDescription => 'Share and discover AI models';

  @override
  String get contributors => 'Contributors';

  @override
  String get contributorsDescription => 'Meet our amazing contributors';

  @override
  String get topContributors => 'Top Contributors';

  @override
  String get plugins => 'Plugins';

  @override
  String get stars => 'Stars';

  @override
  String get commits => 'Commits';

  @override
  String get welcomeDeveloper => 'Welcome Developer!';

  @override
  String get developerWelcomeMessage =>
      'Thank you for joining our developer community! Together, we can build amazing health solutions that benefit people around the world.';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get feedback => 'Feedback';

  @override
  String get yourVoiceMatters => 'Your Voice Matters';

  @override
  String get feedbackDescription =>
      'Help us improve by sharing your thoughts and ideas';

  @override
  String get feedbackType => 'Feedback Type';

  @override
  String get suggestion => 'Suggestion';

  @override
  String get improvement => 'Help us improve';

  @override
  String get bugReport => 'Bug Report';

  @override
  String get issueFound => 'Report technical issues';

  @override
  String get featureRequest => 'Feature Request';

  @override
  String get newFeature => 'Request new features';

  @override
  String get praise => 'Praise';

  @override
  String get positiveFeedback => 'Share positive experiences';

  @override
  String get other => 'Other';

  @override
  String get otherFeedback => 'Other feedback';

  @override
  String get feedbackContent => 'Feedback Content';

  @override
  String get feedbackHint => 'Please describe your feedback in detail...';

  @override
  String get contactInfo => 'Contact Information';

  @override
  String get contactHint => 'Email address (optional)';

  @override
  String get contactOptional =>
      'Optional - we may contact you for further details';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get pleaseEnterContent => 'Please enter feedback content';

  @override
  String get minLengthWarning =>
      'Please provide more details (minimum 10 characters)';

  @override
  String get overallAnalysis => 'Overall Analysis';

  @override
  String get sleepAnalysis => 'Sleep Analysis';

  @override
  String get dietAnalysis => 'Diet Analysis';

  @override
  String get exerciseAnalysis => 'Exercise Analysis';

  @override
  String get moodAnalysis => 'Mood Analysis';

  @override
  String get shareYourInsight => 'Share Your Insight';

  @override
  String get whatDoYouThink => 'What do you think about health and longevity?';

  @override
  String get share => 'Share';

  @override
  String get postShared => 'Your post has been shared!';

  @override
  String get writeComment => 'Write a comment...';

  @override
  String get hot => 'Hot';

  @override
  String get newest => 'Newest';

  @override
  String get following => 'Following';

  @override
  String get minutesAgo => 'minutes ago';

  @override
  String get hoursAgo => 'hours ago';

  @override
  String get daysAgo => 'days ago';

  @override
  String get ok => 'OK';

  @override
  String get noData => 'No data available';

  @override
  String get avgSleepDuration => 'Average Sleep Duration';

  @override
  String get avgQuality => 'Average Quality';

  @override
  String get consistency => 'Consistency';

  @override
  String get totalMinutes => 'Total Minutes';

  @override
  String get totalCalories => 'Total Calories';

  @override
  String get avgIntensity => 'Average Intensity';

  @override
  String get frequency => 'Frequency';

  @override
  String get days => 'days';

  @override
  String get avgCalories => 'Average Calories';

  @override
  String get avgProtein => 'Average Protein';

  @override
  String get avgCarbs => 'Average Carbs';

  @override
  String get avgFat => 'Average Fat';

  @override
  String get avgMood => 'Average Mood';

  @override
  String get stability => 'Stability';

  @override
  String get positiveDays => 'Positive Days';

  @override
  String get overallHealthScore => 'Overall Health Score';

  @override
  String get distribution => 'Distribution';

  @override
  String get personalizedAdvice => 'Personalized Advice';

  @override
  String get analysis => 'Analysis';

  @override
  String get musicUploaded => 'Music uploaded successfully!';

  @override
  String get uploadFailed => 'Upload failed, please try again';

  @override
  String get editMusic => 'Edit Music';

  @override
  String get title => 'Title';

  @override
  String get artist => 'Artist';

  @override
  String get deleteMusicConfirm =>
      'Are you sure you want to delete this music?';

  @override
  String get musicDeleted => 'Music deleted';

  @override
  String get deleteRecordConfirm =>
      'Are you sure you want to delete this record?';

  @override
  String get timeRange => 'Time Range';

  @override
  String get privacyProtection => 'Privacy Protection';

  @override
  String get absolutePrivacyGuarantee => 'Absolute Privacy Guarantee';

  @override
  String get privacyDescription =>
      'All your data is encrypted and stored locally. AI inference runs on your device, no data is uploaded to the cloud.';

  @override
  String get endToEndEncryption => 'End-to-End Encryption';

  @override
  String get encryptionDescription => 'All data encrypted with AES-256';

  @override
  String get noCloudUpload => 'Zero Cloud Upload';

  @override
  String get noCloudDescription => 'Your data never leaves your device';

  @override
  String get localInference => 'Local AI Inference';

  @override
  String get localInferenceDescription =>
      'AI models run directly on your device chip';

  @override
  String get zeroDataCollection => 'Zero Data Collection';

  @override
  String get zeroDataDescription => 'No personal data collected or analyzed';

  @override
  String get privacyVerified => 'Privacy Verified';

  @override
  String get privacyVerifiedDescription =>
      'All processing done locally, no internet required';

  @override
  String get aiModeSettings => 'AI Mode Settings';

  @override
  String get cloudMode => 'Cloud Mode';

  @override
  String get cloudModeDescription => 'Use cloud AI service, internet required';

  @override
  String get localMode => 'Local Mode';

  @override
  String get localModeDescription => 'Run entirely locally, maximum privacy';

  @override
  String get hybridMode => 'Hybrid Mode';

  @override
  String get hybridModeDescription => 'Prefer local, fall back to cloud';

  @override
  String get aiModeChanged => 'AI mode changed';

  @override
  String get securityInfo => 'Security Information';

  @override
  String get encryptionStandard => 'Encryption Standard';

  @override
  String get keyManagement => 'Key Management';

  @override
  String get secureKeyStorage => 'Device secure storage';

  @override
  String get dataStorage => 'Data Storage';

  @override
  String get localOnlyStorage => 'Local storage only';
}
