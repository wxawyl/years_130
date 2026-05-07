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
  String get yoga => '요가';

  @override
  String get gym => '헬스';

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
}
