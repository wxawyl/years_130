// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Live to 130';

  @override
  String get todayHealthScore => 'Today\'s Health Score';

  @override
  String get loadingFailed => 'Loading failed, please retry';

  @override
  String get fourDimensions => 'Four Dimensions';

  @override
  String get sleep => 'Sleep';

  @override
  String get diet => 'Diet';

  @override
  String get exercise => 'Exercise';

  @override
  String get mood => 'Mood';

  @override
  String get quickRecord => 'Quick Record';

  @override
  String get home => 'Home';

  @override
  String get veryGood => '🎉 Excellent! Keep up the healthy lifestyle!';

  @override
  String get good => '👍 Good! There\'s room for improvement';

  @override
  String get needsWork => '💪 Come on! Need to work harder';

  @override
  String get takeCare => '😅 Take good care of yourself today too';

  @override
  String get todayIntake => 'Today\'s Intake';

  @override
  String get calories => 'Calories';

  @override
  String get protein => 'Protein(g)';

  @override
  String get carbs => 'Carbs(g)';

  @override
  String get fat => 'Fat(g)';

  @override
  String get photoRecognize => 'Take Photo to Recognize Food';

  @override
  String get aiRecognition => 'AI Smart Recognition · Auto Calculate Calories';

  @override
  String get quickAddFood => 'Quick Add Food';

  @override
  String get recordDiet => 'Record Diet';

  @override
  String get mealType => 'Meal Type';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get foodName => 'Food Name';

  @override
  String get servings => 'Servings';

  @override
  String get saveRecord => 'Save Record';

  @override
  String get todayRecords => 'Today\'s Records';

  @override
  String get noRecordsToday => 'No diet records for today';

  @override
  String get dietEducation => 'Diet Education';

  @override
  String get source => 'Source';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String confirmDeleteMessage(String foodName) {
    return 'Are you sure you want to delete \"$foodName\" record?';
  }

  @override
  String get recordSaved => 'Diet record saved successfully!';

  @override
  String get recordUpdated => 'Record updated successfully!';

  @override
  String get recordDeleted => 'Record deleted';

  @override
  String foodsRecognized(int count, int calories) {
    return '$count types of food recognized, total $calories kcal';
  }

  @override
  String get editDietRecord => 'Edit Diet Record';

  @override
  String get sleepManagement => 'Sleep Management';

  @override
  String get sleepDuration => 'Sleep Duration';

  @override
  String get sleepQuality => 'Sleep Quality';

  @override
  String get bedtime => 'Bedtime';

  @override
  String get wakeTime => 'Wake Time';

  @override
  String get hours => 'hours';

  @override
  String get recordSleep => 'Record Sleep';

  @override
  String get sleepRecordSaved => 'Sleep record saved successfully!';

  @override
  String get noSleepRecords => 'No sleep records for today';

  @override
  String get sleepEducation => 'Sleep Education';

  @override
  String get exerciseManagement => 'Exercise Management';

  @override
  String get exerciseType => 'Exercise Type';

  @override
  String get duration => 'Duration';

  @override
  String get minutes => 'minutes';

  @override
  String get caloriesBurned => 'Calories Burned';

  @override
  String get recordExercise => 'Record Exercise';

  @override
  String get exerciseRecordSaved => 'Exercise record saved successfully!';

  @override
  String get noExerciseRecords => 'No exercise records for today';

  @override
  String get exerciseEducation => 'Exercise Education';

  @override
  String get walking => 'Walking';

  @override
  String get running => 'Running';

  @override
  String get cycling => 'Cycling';

  @override
  String get swimming => 'Swimming';

  @override
  String get yoga => 'Yoga';

  @override
  String get gym => 'Gym';

  @override
  String get moodManagement => 'Mood Management';

  @override
  String get moodLevel => 'Mood Level';

  @override
  String get note => 'Note';

  @override
  String get recordMood => 'Record Mood';

  @override
  String get moodRecordSaved => 'Mood record saved successfully!';

  @override
  String get noMoodRecords => 'No mood records for today';

  @override
  String get moodEducation => 'Mood Education';

  @override
  String get veryHappy => 'Very Happy';

  @override
  String get happy => 'Happy';

  @override
  String get normal => 'Normal';

  @override
  String get sad => 'Sad';

  @override
  String get verySad => 'Very Sad';

  @override
  String get meditationMusic => 'Meditation Music';

  @override
  String get presetMusic => 'Preset Music';

  @override
  String get startMeditation => 'Start Meditation';

  @override
  String get stopMeditation => 'Stop Meditation';

  @override
  String get nowPlaying => 'Now Playing';

  @override
  String get playFailed => 'Playback failed, please retry';

  @override
  String get language => 'Language';

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
  String get selectLanguage => 'Select Language';

  @override
  String get settings => 'Settings';
}
