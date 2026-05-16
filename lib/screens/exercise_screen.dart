import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../services/health_service.dart';
import '../services/calorie_calculator_service.dart';
import '../models/exercise_record.dart';
import '../models/user_profile.dart';
import '../widgets/daily_knowledge_card.dart';
import '../providers/theme_provider.dart';
import '../widgets/dynamic_background.dart';
import '../l10n/app_localizations.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  final _healthService = HealthService();
  List<ExerciseRecord> _todayRecords = [];
  UserProfile? _userProfile;
  bool _isSyncing = false;
  bool _isLoading = true;

  final Map<String, int> _selectedDurations = {};
  final Map<String, double> _selectedCalories = {};

  final List<Map<String, dynamic>> _exerciseTypes = [
    {
      'name': 'walking',
      'icon': Icons.directions_walk,
      'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=300&h=300&fit=crop',
      'color': Colors.green,
      'calories': 5.5,
    },
    {
      'name': 'running',
      'icon': Icons.directions_run,
      'image': 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=300&h=300&fit=crop',
      'color': Colors.red,
      'calories': 10,
    },
    {
      'name': 'cycling',
      'icon': Icons.directions_bike,
      'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
      'color': Colors.blue,
      'calories': 8,
    },
    {
      'name': 'swimming',
      'icon': Icons.pool,
      'image': 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=300&h=300&fit=crop',
      'color': Colors.cyan,
      'calories': 9,
    },
    {
      'name': 'pushups',
      'icon': Icons.sports_gymnastics,
      'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=300&h=300&fit=crop',
      'color': Colors.orange,
      'calories': 8,
    },
    {
      'name': 'legRaises',
      'icon': Icons.sports_martial_arts,
      'image': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=300&h=300&fit=crop',
      'color': Colors.purple,
      'calories': 6,
    },
    {
      'name': 'badminton',
      'icon': Icons.sports_tennis,
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&h=300&fit=crop',
      'color': Colors.amber,
      'calories': 8,
    },
    {
      'name': 'dancing',
      'icon': Icons.music_note,
      'image': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=300&h=300&fit=crop',
      'color': Colors.pink,
      'calories': 7,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _todayRecords = await _dbService.getExerciseRecords(today);
      _userProfile = await _dbService.getUserProfile();
      _initializeSelectedData();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _initializeSelectedData() {
    for (var record in _todayRecords) {
      final exerciseType = _exerciseTypes.firstWhere(
        (e) => e['name'] == record.subType.toLowerCase().replaceAll(' ', ''),
        orElse: () => _exerciseTypes.first,
      );
      _selectedDurations[exerciseType['name']] = record.duration;
      _selectedCalories[exerciseType['name']] = record.caloriesBurned;
    }
  }

  double get _totalCalories {
    return _selectedCalories.values.fold(0.0, (sum, c) => sum + c);
  }

  String _getExerciseName(String key, AppLocalizations l10n) {
    switch (key) {
      case 'walking':
        return l10n.walking;
      case 'running':
        return l10n.running;
      case 'cycling':
        return l10n.cycling;
      case 'swimming':
        return l10n.swimming;
      case 'pushups':
        return l10n.pushups;
      case 'legRaises':
        return l10n.legRaises;
      case 'badminton':
        return '羽毛球';
      case 'dancing':
        return '舞蹈';
      default:
        return key;
    }
  }

  Future<void> _saveAllRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    for (var exercise in _exerciseTypes) {
      final name = exercise['name'] as String;
      final duration = _selectedDurations[name];
      if (duration != null && duration > 0) {
        double calories = _selectedCalories[name] ??
            CalorieCalculatorService.calculateCalories(
              name,
              duration,
              _userProfile,
            );

        ExerciseRecord record = ExerciseRecord(
          id: null,
          date: today,
          exerciseType: _exerciseTypes.indexWhere((e) => e['name'] == name) + 1,
          subType: _getExerciseName(name, AppLocalizations.of(context)!),
          duration: duration,
          intensity: 3,
          caloriesBurned: calories,
        );
        await _dbService.insertExerciseRecord(record);
      }
    }

    await _scoreService.calculateDailyScore(today);
    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('运动记录保存成功！')),
      );
    }
  }

  Future<void> _syncWithHealthKit() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);

    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day - 7);
      final endDate = DateTime(now.year, now.month, now.day + 1);

      final exerciseRecords = await _healthService.fetchExerciseData(startDate, endDate);

      for (var record in exerciseRecords) {
        final existingRecords = await _dbService.getExerciseRecords(record.date);
        if (existingRecords.isEmpty) {
          await _dbService.insertExerciseRecord(record);
        }
      }

      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('运动数据同步成功！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('同步失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  void _editDuration(String exerciseName) {
    final currentDuration = _selectedDurations[exerciseName] ?? 30;
    TextEditingController controller = TextEditingController(text: currentDuration.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑时长'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '运动时长（分钟）',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              int? newDuration = int.tryParse(controller.text);
              if (newDuration != null && newDuration > 0) {
                setState(() {
                  _selectedDurations[exerciseName] = newDuration;
                  _selectedCalories[exerciseName] =
                      CalorieCalculatorService.calculateCalories(
                        exerciseName,
                        newDuration,
                        _userProfile,
                      );
                });
              }
              Navigator.pop(context);
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _editCalories(String exerciseName) {
    final currentCalories = _selectedCalories[exerciseName] ?? 0;
    TextEditingController controller = TextEditingController(text: currentCalories.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑卡路里'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '消耗卡路里（kcal）',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              double? newCalories = double.tryParse(controller.text);
              if (newCalories != null && newCalories > 0) {
                setState(() {
                  _selectedCalories[exerciseName] = newCalories;
                });
              }
              Navigator.pop(context);
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  String _getTodaySuggestion() {
    if (_todayRecords.isEmpty) {
      return '💡 还没有记录运动哦！建议今天进行30分钟的轻度运动，有助于身心健康。';
    }

    final totalDuration = _todayRecords.fold(0, (sum, r) => sum + r.duration);
    final totalCalories = _todayRecords.fold(0.0, (sum, r) => sum + r.caloriesBurned);

    if (totalDuration >= 60) {
      return '💪 太棒了！今天已经运动${totalDuration}分钟，消耗${totalCalories.toStringAsFixed(0)}卡路里。继续保持这个节奏！';
    } else if (totalDuration >= 30) {
      return '👍 不错！已运动${totalDuration}分钟，消耗${totalCalories.toStringAsFixed(0)}卡路里。建议再增加一点运动时间会更好哦！';
    } else {
      return '🏃 已运动${totalDuration}分钟，还需要加油哦！建议再增加一些运动时间来达到每日目标。';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.exerciseManagement),
            const SizedBox(width: 8),
            if (_isSyncing)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              InkWell(
                onTap: _syncWithHealthKit,
                child: const Tooltip(
                  message: '同步 HealthKit 数据',
                  child: Text(
                    'HealthKit',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        centerTitle: true,
      ),
      body: DynamicBackground(
        theme: themeProvider.currentTheme,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.exerciseType}（总消耗: ${_totalCalories.toStringAsFixed(0)} kcal）',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                    children: List.generate(_exerciseTypes.length, (index) {
                      final exercise = _exerciseTypes[index];
                      final name = exercise['name'] as String;
                      final duration = _selectedDurations[name];
                      final calories = _selectedCalories[name];
                      final hasData = duration != null && duration > 0;

                      return Card(
                        elevation: hasData ? 4 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: hasData
                              ? BorderSide(color: exercise['color'] as Color, width: 2)
                              : BorderSide.none,
                        ),
                        child: InkWell(
                          onTap: () => _editDuration(name),
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  exercise['image'] as String,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: (exercise['color'] as Color).withOpacity(0.2),
                                      child: Icon(
                                        exercise['icon'] as IconData,
                                        color: exercise['color'] as Color,
                                        size: 30,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getExerciseName(name, l10n),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (hasData) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            '$duration min',
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
                                          ),
                                          if (calories != null && calories > 0) ...[
                                            const SizedBox(width: 4),
                                            Text(
                                              '| ${calories.toStringAsFixed(0)} kcal',
                                              style: const TextStyle(
                                                fontSize: 9,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveAllRecords,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.recordExercise,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '今日建议',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getTodaySuggestion(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DailyKnowledgeSection(
                    category: 'exercise',
                    title: l10n.exerciseEducation,
                  ),
                ],
              ),
            ),
        ),
    );
  }
}
