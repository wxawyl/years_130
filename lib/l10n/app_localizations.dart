import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Live to 130'**
  String get appTitle;

  /// Today health score label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Health Score'**
  String get todayHealthScore;

  /// Loading failed message
  ///
  /// In en, this message translates to:
  /// **'Loading failed, please retry'**
  String get loadingFailed;

  /// Four dimensions section title
  ///
  /// In en, this message translates to:
  /// **'Four Dimensions'**
  String get fourDimensions;

  /// Sleep dimension
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// Diet dimension
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// Exercise dimension
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// Mood dimension
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// Quick record section title
  ///
  /// In en, this message translates to:
  /// **'Quick Record'**
  String get quickRecord;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Score message for >=80
  ///
  /// In en, this message translates to:
  /// **'🎉 Excellent! Keep up the healthy lifestyle!'**
  String get veryGood;

  /// Score message for >=60
  ///
  /// In en, this message translates to:
  /// **'👍 Good! There\'s room for improvement'**
  String get good;

  /// Score message for >=40
  ///
  /// In en, this message translates to:
  /// **'💪 Come on! Need to work harder'**
  String get needsWork;

  /// Score message for <40
  ///
  /// In en, this message translates to:
  /// **'😅 Take good care of yourself today too'**
  String get takeCare;

  /// Today intake section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Intake'**
  String get todayIntake;

  /// Calories label
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// Protein label
  ///
  /// In en, this message translates to:
  /// **'Protein(g)'**
  String get protein;

  /// Carbs label
  ///
  /// In en, this message translates to:
  /// **'Carbs(g)'**
  String get carbs;

  /// Fat label
  ///
  /// In en, this message translates to:
  /// **'Fat(g)'**
  String get fat;

  /// Photo recognition button
  ///
  /// In en, this message translates to:
  /// **'Take Photo to Recognize Food'**
  String get photoRecognize;

  /// AI recognition subtitle
  ///
  /// In en, this message translates to:
  /// **'AI Smart Recognition · Auto Calculate Calories'**
  String get aiRecognition;

  /// Quick add food section title
  ///
  /// In en, this message translates to:
  /// **'Quick Add Food'**
  String get quickAddFood;

  /// Record diet section title
  ///
  /// In en, this message translates to:
  /// **'Record Diet'**
  String get recordDiet;

  /// Meal type label
  ///
  /// In en, this message translates to:
  /// **'Meal Type'**
  String get mealType;

  /// Breakfast meal type
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// Lunch meal type
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// Dinner meal type
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// Snack meal type
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// Food name field label
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get foodName;

  /// Servings field label
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// Save record button
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get saveRecord;

  /// Today's records section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Records'**
  String get todayRecords;

  /// No records message
  ///
  /// In en, this message translates to:
  /// **'No diet records for today'**
  String get noRecordsToday;

  /// Diet education section title
  ///
  /// In en, this message translates to:
  /// **'Diet Education'**
  String get dietEducation;

  /// Source label
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Confirm delete dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Confirm delete message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{foodName}\" record?'**
  String confirmDeleteMessage(String foodName);

  /// Record saved message
  ///
  /// In en, this message translates to:
  /// **'Diet record saved successfully!'**
  String get recordSaved;

  /// Record updated message
  ///
  /// In en, this message translates to:
  /// **'Record updated successfully!'**
  String get recordUpdated;

  /// Record deleted message
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get recordDeleted;

  /// Foods recognized message
  ///
  /// In en, this message translates to:
  /// **'{count} types of food recognized, total {calories} kcal'**
  String foodsRecognized(int count, int calories);

  /// Edit diet record dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Diet Record'**
  String get editDietRecord;

  /// Sleep screen title
  ///
  /// In en, this message translates to:
  /// **'Sleep Management'**
  String get sleepManagement;

  /// Sleep duration label
  ///
  /// In en, this message translates to:
  /// **'Sleep Duration'**
  String get sleepDuration;

  /// Sleep quality label
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality'**
  String get sleepQuality;

  /// Bedtime label
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bedtime;

  /// Wake time label
  ///
  /// In en, this message translates to:
  /// **'Wake Time'**
  String get wakeTime;

  /// Hours unit
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// Record sleep button
  ///
  /// In en, this message translates to:
  /// **'Record Sleep'**
  String get recordSleep;

  /// Sleep record saved message
  ///
  /// In en, this message translates to:
  /// **'Sleep record saved successfully!'**
  String get sleepRecordSaved;

  /// No sleep records message
  ///
  /// In en, this message translates to:
  /// **'No sleep records for today'**
  String get noSleepRecords;

  /// Sleep education section title
  ///
  /// In en, this message translates to:
  /// **'Sleep Education'**
  String get sleepEducation;

  /// Exercise screen title
  ///
  /// In en, this message translates to:
  /// **'Exercise Management'**
  String get exerciseManagement;

  /// Exercise type label
  ///
  /// In en, this message translates to:
  /// **'Exercise Type'**
  String get exerciseType;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Calories burned label
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get caloriesBurned;

  /// Record exercise button
  ///
  /// In en, this message translates to:
  /// **'Record Exercise'**
  String get recordExercise;

  /// Exercise record saved message
  ///
  /// In en, this message translates to:
  /// **'Exercise record saved successfully!'**
  String get exerciseRecordSaved;

  /// No exercise records message
  ///
  /// In en, this message translates to:
  /// **'No exercise records for today'**
  String get noExerciseRecords;

  /// Exercise education section title
  ///
  /// In en, this message translates to:
  /// **'Exercise Education'**
  String get exerciseEducation;

  /// Walking exercise
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// Running exercise
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// Cycling exercise
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get cycling;

  /// Swimming exercise
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get swimming;

  /// Push-ups exercise
  ///
  /// In en, this message translates to:
  /// **'Push-ups'**
  String get pushups;

  /// Leg raises exercise
  ///
  /// In en, this message translates to:
  /// **'Leg Raises'**
  String get legRaises;

  /// Mood screen title
  ///
  /// In en, this message translates to:
  /// **'Mood Management'**
  String get moodManagement;

  /// Mood level label
  ///
  /// In en, this message translates to:
  /// **'Mood Level'**
  String get moodLevel;

  /// Note label
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// Record mood button
  ///
  /// In en, this message translates to:
  /// **'Record Mood'**
  String get recordMood;

  /// Mood record saved message
  ///
  /// In en, this message translates to:
  /// **'Mood record saved successfully!'**
  String get moodRecordSaved;

  /// No mood records message
  ///
  /// In en, this message translates to:
  /// **'No mood records for today'**
  String get noMoodRecords;

  /// Mood education section title
  ///
  /// In en, this message translates to:
  /// **'Mood Education'**
  String get moodEducation;

  /// Very happy mood
  ///
  /// In en, this message translates to:
  /// **'Very Happy'**
  String get veryHappy;

  /// Happy mood
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// Normal mood
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Sad mood
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// Very sad mood
  ///
  /// In en, this message translates to:
  /// **'Very Sad'**
  String get verySad;

  /// Meditation music screen title
  ///
  /// In en, this message translates to:
  /// **'Meditation Music'**
  String get meditationMusic;

  /// Preset music section
  ///
  /// In en, this message translates to:
  /// **'Preset Music'**
  String get presetMusic;

  /// Start meditation button
  ///
  /// In en, this message translates to:
  /// **'Start Meditation'**
  String get startMeditation;

  /// Stop meditation button
  ///
  /// In en, this message translates to:
  /// **'Stop Meditation'**
  String get stopMeditation;

  /// Now playing label
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// Play failed message
  ///
  /// In en, this message translates to:
  /// **'Playback failed, please retry'**
  String get playFailed;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Chinese language
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get chinese;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Japanese language
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// Korean language
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get korean;

  /// Spanish language
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// Select language dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Developer center label
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Developer center screen title
  ///
  /// In en, this message translates to:
  /// **'Developer Center'**
  String get developerCenter;

  /// Developer center hero title
  ///
  /// In en, this message translates to:
  /// **'Build Together for Health'**
  String get buildTogether;

  /// Developer center hero description
  ///
  /// In en, this message translates to:
  /// **'Join our community of developers to build the future of health technology'**
  String get developerDescription;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Plugin market section
  ///
  /// In en, this message translates to:
  /// **'Plugin Market'**
  String get pluginMarket;

  /// Plugin market description
  ///
  /// In en, this message translates to:
  /// **'Extend app functionality with plugins'**
  String get pluginMarketDescription;

  /// API documentation section
  ///
  /// In en, this message translates to:
  /// **'API Docs'**
  String get apiDocs;

  /// API docs description
  ///
  /// In en, this message translates to:
  /// **'Access our RESTful API documentation'**
  String get apiDocsDescription;

  /// GitHub section
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// GitHub description
  ///
  /// In en, this message translates to:
  /// **'Contribute to our open source project'**
  String get githubDescription;

  /// Community section
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// Community description
  ///
  /// In en, this message translates to:
  /// **'Connect with other developers'**
  String get communityDescription;

  /// AI model market section
  ///
  /// In en, this message translates to:
  /// **'AI Model Market'**
  String get aiMarket;

  /// AI market description
  ///
  /// In en, this message translates to:
  /// **'Share and discover AI models'**
  String get aiMarketDescription;

  /// Contributors section
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributors;

  /// Contributors description
  ///
  /// In en, this message translates to:
  /// **'Meet our amazing contributors'**
  String get contributorsDescription;

  /// Top contributors section title
  ///
  /// In en, this message translates to:
  /// **'Top Contributors'**
  String get topContributors;

  /// Plugins count label
  ///
  /// In en, this message translates to:
  /// **'Plugins'**
  String get plugins;

  /// Stars count label
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// Commits count label
  ///
  /// In en, this message translates to:
  /// **'Commits'**
  String get commits;

  /// Welcome dialog title
  ///
  /// In en, this message translates to:
  /// **'Welcome Developer!'**
  String get welcomeDeveloper;

  /// Welcome message for developers
  ///
  /// In en, this message translates to:
  /// **'Thank you for joining our developer community! Together, we can build amazing health solutions that benefit people around the world.'**
  String get developerWelcomeMessage;

  /// Coming soon placeholder
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Feedback label
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Feedback hero title
  ///
  /// In en, this message translates to:
  /// **'Your Voice Matters'**
  String get yourVoiceMatters;

  /// Feedback hero description
  ///
  /// In en, this message translates to:
  /// **'Help us improve by sharing your thoughts and ideas'**
  String get feedbackDescription;

  /// Feedback type label
  ///
  /// In en, this message translates to:
  /// **'Feedback Type'**
  String get feedbackType;

  /// Suggestion feedback type
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// Suggestion description
  ///
  /// In en, this message translates to:
  /// **'Help us improve'**
  String get improvement;

  /// Bug report feedback type
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get bugReport;

  /// Bug report description
  ///
  /// In en, this message translates to:
  /// **'Report technical issues'**
  String get issueFound;

  /// Feature request feedback type
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get featureRequest;

  /// Feature request description
  ///
  /// In en, this message translates to:
  /// **'Request new features'**
  String get newFeature;

  /// Praise feedback type
  ///
  /// In en, this message translates to:
  /// **'Praise'**
  String get praise;

  /// Praise description
  ///
  /// In en, this message translates to:
  /// **'Share positive experiences'**
  String get positiveFeedback;

  /// Other feedback type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Other description
  ///
  /// In en, this message translates to:
  /// **'Other feedback'**
  String get otherFeedback;

  /// Feedback content label
  ///
  /// In en, this message translates to:
  /// **'Feedback Content'**
  String get feedbackContent;

  /// Feedback content hint
  ///
  /// In en, this message translates to:
  /// **'Please describe your feedback in detail...'**
  String get feedbackHint;

  /// Contact info label
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfo;

  /// Contact info hint
  ///
  /// In en, this message translates to:
  /// **'Email address (optional)'**
  String get contactHint;

  /// Contact optional message
  ///
  /// In en, this message translates to:
  /// **'Optional - we may contact you for further details'**
  String get contactOptional;

  /// Submit feedback button
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// Content required validation
  ///
  /// In en, this message translates to:
  /// **'Please enter feedback content'**
  String get pleaseEnterContent;

  /// Minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Please provide more details (minimum 10 characters)'**
  String get minLengthWarning;

  /// Overall analysis button
  ///
  /// In en, this message translates to:
  /// **'Overall Analysis'**
  String get overallAnalysis;

  /// Sleep analysis button
  ///
  /// In en, this message translates to:
  /// **'Sleep Analysis'**
  String get sleepAnalysis;

  /// Diet analysis button
  ///
  /// In en, this message translates to:
  /// **'Diet Analysis'**
  String get dietAnalysis;

  /// Exercise analysis button
  ///
  /// In en, this message translates to:
  /// **'Exercise Analysis'**
  String get exerciseAnalysis;

  /// Mood analysis button
  ///
  /// In en, this message translates to:
  /// **'Mood Analysis'**
  String get moodAnalysis;

  /// Share insight dialog title
  ///
  /// In en, this message translates to:
  /// **'Share Your Insight'**
  String get shareYourInsight;

  /// Share insight hint
  ///
  /// In en, this message translates to:
  /// **'What do you think about health and longevity?'**
  String get whatDoYouThink;

  /// Share button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Post shared success message
  ///
  /// In en, this message translates to:
  /// **'Your post has been shared!'**
  String get postShared;

  /// Comment input hint
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeComment;

  /// Hot filter
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hot;

  /// Newest filter
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// Following filter
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// Minutes ago label
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutesAgo;

  /// Hours ago label
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// Days ago label
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Average sleep duration label
  ///
  /// In en, this message translates to:
  /// **'Average Sleep Duration'**
  String get avgSleepDuration;

  /// Average quality label
  ///
  /// In en, this message translates to:
  /// **'Average Quality'**
  String get avgQuality;

  /// Consistency label
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// Total minutes label
  ///
  /// In en, this message translates to:
  /// **'Total Minutes'**
  String get totalMinutes;

  /// Total calories label
  ///
  /// In en, this message translates to:
  /// **'Total Calories'**
  String get totalCalories;

  /// Average intensity label
  ///
  /// In en, this message translates to:
  /// **'Average Intensity'**
  String get avgIntensity;

  /// Frequency label
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// Days unit
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Average calories label
  ///
  /// In en, this message translates to:
  /// **'Average Calories'**
  String get avgCalories;

  /// Average protein label
  ///
  /// In en, this message translates to:
  /// **'Average Protein'**
  String get avgProtein;

  /// Average carbs label
  ///
  /// In en, this message translates to:
  /// **'Average Carbs'**
  String get avgCarbs;

  /// Average fat label
  ///
  /// In en, this message translates to:
  /// **'Average Fat'**
  String get avgFat;

  /// Average mood label
  ///
  /// In en, this message translates to:
  /// **'Average Mood'**
  String get avgMood;

  /// Stability label
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get stability;

  /// Positive days label
  ///
  /// In en, this message translates to:
  /// **'Positive Days'**
  String get positiveDays;

  /// Overall health score label
  ///
  /// In en, this message translates to:
  /// **'Overall Health Score'**
  String get overallHealthScore;

  /// Distribution label
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get distribution;

  /// Personalized advice label
  ///
  /// In en, this message translates to:
  /// **'Personalized Advice'**
  String get personalizedAdvice;

  /// Analysis label
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// Music uploaded message
  ///
  /// In en, this message translates to:
  /// **'Music uploaded successfully!'**
  String get musicUploaded;

  /// Upload failed message
  ///
  /// In en, this message translates to:
  /// **'Upload failed, please try again'**
  String get uploadFailed;

  /// Edit music dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Music'**
  String get editMusic;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Artist label
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// Delete music confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this music?'**
  String get deleteMusicConfirm;

  /// Music deleted message
  ///
  /// In en, this message translates to:
  /// **'Music deleted'**
  String get musicDeleted;

  /// Delete record confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get deleteRecordConfirm;

  /// Time range label
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get timeRange;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
