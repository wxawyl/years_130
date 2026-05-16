// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '130세까지 살기';

  @override
  String get todayHealthScore => '오늘의 건강 점수';

  @override
  String get loadingFailed => '로드 실패, 다시 시도해 주세요';

  @override
  String get fourDimensions => '4대 차원';

  @override
  String get sleep => '수면';

  @override
  String get diet => '식단';

  @override
  String get exercise => '운동';

  @override
  String get mood => '마음가짐';

  @override
  String get quickRecord => '빠른 기록';

  @override
  String get home => '홈';

  @override
  String get veryGood => '🎉 훌륭합니다! 건강한 생활을 계속 유지하세요!';

  @override
  String get good => '👍 좋네요! 개선의 여지가 있어요';

  @override
  String get needsWork => '💪 화이팅! 더 노력해야 해요';

  @override
  String get takeCare => '😅 오늘도 잘 챙기세요';

  @override
  String get todayIntake => '오늘의 섭취량';

  @override
  String get calories => '칼로리';

  @override
  String get protein => '단백질(g)';

  @override
  String get carbs => '탄수화물(g)';

  @override
  String get fat => '지방(g)';

  @override
  String get photoRecognize => '사진으로 음식 인식';

  @override
  String get aiRecognition => 'AI 스마트 인식 · 칼로리 자동 계산';

  @override
  String get quickAddFood => '빠른 음식 추가';

  @override
  String get recordDiet => '식단 기록';

  @override
  String get mealType => '식사 유형';

  @override
  String get breakfast => '아침';

  @override
  String get lunch => '점심';

  @override
  String get dinner => '저녁';

  @override
  String get snack => '간식';

  @override
  String get foodName => '음식 이름';

  @override
  String get servings => '인분';

  @override
  String get saveRecord => '기록 저장';

  @override
  String get todayRecords => '오늘의 기록';

  @override
  String get noRecordsToday => '오늘의 식단 기록이 없습니다';

  @override
  String get dietEducation => '식단 상식';

  @override
  String get source => '출처';

  @override
  String get edit => '편집';

  @override
  String get delete => '삭제';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get confirmDelete => '삭제 확인';

  @override
  String confirmDeleteMessage(String foodName) {
    return '\"$foodName\" 기록을 삭제하시겠습니까?';
  }

  @override
  String get recordSaved => '식단 기록이 저장되었습니다!';

  @override
  String get recordUpdated => '기록이 업데이트되었습니다!';

  @override
  String get recordDeleted => '기록이 삭제되었습니다';

  @override
  String foodsRecognized(int count, int calories) {
    return '$count가지 음식이 인식되었으며, 총 ${calories}kcal';
  }

  @override
  String get editDietRecord => '식단 기록 편집';

  @override
  String get sleepManagement => '수면 관리';

  @override
  String get sleepDuration => '수면 시간';

  @override
  String get sleepQuality => '수면 품질';

  @override
  String get bedtime => '취침 시간';

  @override
  String get wakeTime => '기상 시간';

  @override
  String get hours => '시간';

  @override
  String get recordSleep => '수면 기록';

  @override
  String get sleepRecordSaved => '수면 기록이 저장되었습니다!';

  @override
  String get noSleepRecords => '오늘의 수면 기록이 없습니다';

  @override
  String get sleepEducation => '수면 상식';

  @override
  String get exerciseManagement => '운동 관리';

  @override
  String get exerciseType => '운동 유형';

  @override
  String get duration => '시간';

  @override
  String get minutes => '분';

  @override
  String get caloriesBurned => '소모 칼로리';

  @override
  String get recordExercise => '운동 기록';

  @override
  String get exerciseRecordSaved => '운동 기록이 저장되었습니다!';

  @override
  String get noExerciseRecords => '오늘의 운동 기록이 없습니다';

  @override
  String get exerciseEducation => '운동 상식';

  @override
  String get walking => '걷기';

  @override
  String get running => '달리기';

  @override
  String get cycling => '자전거 타기';

  @override
  String get swimming => '수영';

  @override
  String get pushups => 'Push-ups';

  @override
  String get legRaises => 'Leg Raises';

  @override
  String get moodManagement => '마음가짐 관리';

  @override
  String get moodLevel => '마음가짐 지수';

  @override
  String get note => '메모';

  @override
  String get recordMood => '마음가짐 기록';

  @override
  String get moodRecordSaved => '마음가짐 기록이 저장되었습니다!';

  @override
  String get noMoodRecords => '오늘의 마음가짐 기록이 없습니다';

  @override
  String get moodEducation => '마음가짐 상식';

  @override
  String get veryHappy => '매우 행복';

  @override
  String get happy => '행복';

  @override
  String get normal => '보통';

  @override
  String get sad => '슬픔';

  @override
  String get verySad => '매우 슬픔';

  @override
  String get meditationMusic => '명상 음악';

  @override
  String get presetMusic => '프리셋 음악';

  @override
  String get startMeditation => '명상 시작';

  @override
  String get stopMeditation => '명상 중지';

  @override
  String get nowPlaying => '재생 중';

  @override
  String get playFailed => '재생 실패, 다시 시도해 주세요';

  @override
  String get language => '언어';

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
  String get selectLanguage => '언어 선택';

  @override
  String get settings => '설정';

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
