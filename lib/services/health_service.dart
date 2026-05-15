import 'package:health/health.dart';
import 'package:intl/intl.dart';
import '../models/sleep_record.dart';
import '../models/exercise_record.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();
  bool _hasPermissions = false;

  final List<HealthDataType> _healthDataTypes = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.EXERCISE_TIME,
  ];

  Future<bool> requestPermissions() async {
    try {
      _hasPermissions = await _health.requestAuthorization(_healthDataTypes) ?? false;
      return _hasPermissions;
    } catch (e) {
      print('Error requesting HealthKit permissions: $e');
      return false;
    }
  }

  Future<bool> checkPermissions() async {
    if (_hasPermissions) return true;
    try {
      _hasPermissions = await _health.hasPermissions(_healthDataTypes) ?? false;
      return _hasPermissions;
    } catch (e) {
      print('Error checking HealthKit permissions: $e');
      return false;
    }
  }

  Future<List<SleepRecord>> fetchSleepData(DateTime startDate, DateTime endDate) async {
    final List<SleepRecord> records = [];
    
    if (!await checkPermissions()) {
      if (!await requestPermissions()) {
        return records;
      }
    }

    try {
      final List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_AWAKE,
          HealthDataType.SLEEP_DEEP,
          HealthDataType.SLEEP_LIGHT,
          HealthDataType.SLEEP_REM,
        ],
      );

      if (healthData.isEmpty) return records;

      Map<String, List<HealthDataPoint>> sleepByDate = {};
      for (var dataPoint in healthData) {
        String date = DateFormat('yyyy-MM-dd').format(dataPoint.dateFrom!);
        if (!sleepByDate.containsKey(date)) {
          sleepByDate[date] = [];
        }
        sleepByDate[date]!.add(dataPoint);
      }

      for (var entry in sleepByDate.entries) {
        String date = entry.key;
        List<HealthDataPoint> dataPoints = entry.value;

        if (dataPoints.isEmpty) continue;

        DateTime? bedtime;
        DateTime? wakeTime;
        double totalSleepDuration = 0;
        double deepSleepDuration = 0;

        for (var dataPoint in dataPoints) {
          DateTime from = dataPoint.dateFrom!;
          DateTime to = dataPoint.dateTo!;
          
          Duration duration = to.difference(from);
          double hours = duration.inMinutes / 60.0;

          if (bedtime == null || from.isBefore(bedtime)) {
            bedtime = from;
          }
          if (wakeTime == null || to.isAfter(wakeTime)) {
            wakeTime = to;
          }

          if (dataPoint.type == HealthDataType.SLEEP_ASLEEP ||
              dataPoint.type == HealthDataType.SLEEP_DEEP ||
              dataPoint.type == HealthDataType.SLEEP_LIGHT ||
              dataPoint.type == HealthDataType.SLEEP_REM) {
            totalSleepDuration += hours;
            
            if (dataPoint.type == HealthDataType.SLEEP_DEEP) {
              deepSleepDuration += hours;
            }
          }
        }

        if (bedtime != null && wakeTime != null) {
          double? deepSleepRatio = totalSleepDuration > 0 ? deepSleepDuration / totalSleepDuration : null;
          
          SleepRecord record = SleepRecord(
            date: date,
            bedtime: '${bedtime.hour.toString().padLeft(2, '0')}:${bedtime.minute.toString().padLeft(2, '0')}',
            wakeTime: '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}',
            duration: totalSleepDuration,
            quality: _calculateSleepQuality(totalSleepDuration, deepSleepRatio),
            deepSleepRatio: deepSleepRatio,
            notes: 'HealthKit 自动同步',
          );
          
          records.add(record);
        }
      }
    } catch (e) {
      print('Error fetching sleep data: $e');
    }

    return records;
  }

  Future<List<ExerciseRecord>> fetchExerciseData(DateTime startDate, DateTime endDate) async {
    final List<ExerciseRecord> records = [];
    
    if (!await checkPermissions()) {
      if (!await requestPermissions()) {
        return records;
      }
    }

    try {
      final List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startDate,
        endTime: endDate,
        types: [
          HealthDataType.STEPS,
          HealthDataType.DISTANCE_WALKING_RUNNING,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.EXERCISE_TIME,
        ],
      );

      if (healthData.isEmpty) return records;

      Map<String, Map<String, dynamic>> exercisesByDate = {};

      for (var dataPoint in healthData) {
        String date = DateFormat('yyyy-MM-dd').format(dataPoint.dateFrom!);
        
        if (!exercisesByDate.containsKey(date)) {
          exercisesByDate[date] = {
            'steps': 0,
            'distance': 0.0,
            'calories': 0.0,
            'duration': 0,
          };
        }

        double? value = dataPoint.value is num ? (dataPoint.value as num).toDouble() : null;
        
        if (value != null) {
          switch (dataPoint.type) {
            case HealthDataType.STEPS:
              exercisesByDate[date]!['steps'] += value.toInt();
              break;
            case HealthDataType.DISTANCE_WALKING_RUNNING:
              exercisesByDate[date]!['distance'] += value;
              break;
            case HealthDataType.ACTIVE_ENERGY_BURNED:
              exercisesByDate[date]!['calories'] += value;
              break;
            case HealthDataType.EXERCISE_TIME:
              exercisesByDate[date]!['duration'] += value.toInt();
              break;
            default:
              break;
          }
        }
      }

      for (var entry in exercisesByDate.entries) {
        String date = entry.key;
        var data = entry.value;
        
        int steps = data['steps'] as int;
        int duration = data['duration'] as int;
        double calories = data['calories'] as double;
        
        if (steps > 0 || duration > 0 || calories > 0) {
          int exerciseType = _determineExerciseType(steps, data['distance'] as double);
          
          ExerciseRecord record = ExerciseRecord(
            date: date,
            exerciseType: exerciseType,
            subType: 'HealthKit 运动',
            duration: duration > 0 ? duration : (steps > 0 ? (steps / 100).round() : 30),
            intensity: 3,
            caloriesBurned: calories > 0 ? calories : (steps * 0.04),
          );
          
          records.add(record);
        }
      }
    } catch (e) {
      print('Error fetching exercise data: $e');
    }

    return records;
  }

  int _calculateSleepQuality(double duration, double? deepSleepRatio) {
    int score = 0;
    
    if (duration >= 7 && duration <= 9) {
      score += 3;
    } else if (duration >= 6 || duration <= 10) {
      score += 2;
    } else {
      score += 1;
    }
    
    if (deepSleepRatio != null) {
      if (deepSleepRatio >= 0.2 && deepSleepRatio <= 0.3) {
        score += 2;
      } else if (deepSleepRatio >= 0.15 || deepSleepRatio <= 0.35) {
        score += 1;
      }
    }
    
    return score.clamp(1, 5);
  }

  int _determineExerciseType(int steps, double distance) {
    if (distance > 5) {
      return 3;
    } else if (steps > 5000) {
      return 2;
    }
    return 1;
  }
}
