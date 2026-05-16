import 'package:flutter/foundation.dart';
import '../theme/mood_colors.dart';

class ThemeProvider extends ChangeNotifier {
  late MoodTheme _currentTheme;
  bool _animationsEnabled = true;
  bool _isInitialized = false;

  ThemeProvider({MoodTheme? initialTheme}) {
    _currentTheme = initialTheme ?? MoodTheme.good;
  }

  MoodTheme get currentTheme => _currentTheme;

  bool get animationsEnabled => _animationsEnabled;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _isInitialized = true;
    notifyListeners();
  }

  void updateFromHealthData({
    required double healthScore,
    bool hasSleptWell = true,
    bool hasExercised = false,
    bool isSleepDeprived = false,
  }) {
    final newTheme = MoodTheme.fromScore(
      healthScore,
      hasSleptWell: hasSleptWell,
      hasExercised: hasExercised,
      isSleepDeprived: isSleepDeprived,
    );

    if (newTheme.type != _currentTheme.type) {
      _currentTheme = newTheme;
      notifyListeners();
    }
  }

  void setTheme(MoodTheme theme) {
    if (theme.type != _currentTheme.type) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  void toggleAnimations(bool enabled) {
    _animationsEnabled = enabled;
    notifyListeners();
  }

  void resetToDefault() {
    _currentTheme = MoodTheme.good;
    notifyListeners();
  }
}
