import '../models/user_profile.dart';

class CalorieCalculatorService {
  static const Map<String, double> activityFactors = {
    'walking': 1.37,
    'running': 1.725,
    'cycling': 1.55,
    'swimming': 1.725,
    'pushups': 1.37,
    'legRaises': 1.275,
    'badminton': 1.55,
    'dancing': 1.45,
  };

  static double calculateBMR(UserProfile? user) {
    if (user == null || user.weight == null || user.height == null || user.age == null) {
      return 1500;
    }

    double weight = user.weight!;
    double height = user.height!;
    int age = user.age!;

    if (user.gender.toLowerCase() == 'female') {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    } else {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    }
  }

  static double calculateCalories(
    String activity,
    int durationMinutes,
    UserProfile? user,
  ) {
    double bmr = calculateBMR(user);
    double factor = activityFactors[activity] ?? 1.0;
    double durationHours = durationMinutes / 60;
    return bmr * factor * durationHours;
  }
}
