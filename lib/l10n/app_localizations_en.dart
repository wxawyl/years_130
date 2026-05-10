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
  String get pushups => 'Push-ups';

  @override
  String get legRaises => 'Leg Raises';

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
}
