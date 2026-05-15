import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../models/diet_record.dart';
import '../widgets/daily_knowledge_card.dart';
import '../models/food_recognition_result.dart';
import '../l10n/app_localizations.dart';
import 'camera_recognition_screen.dart';
import '../services/diet_suggestion_service.dart';
import '../models/user_profile.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  List<DietRecord> _todayRecords = [];
  DietSuggestion? _todaySuggestion;
  int _mealType = 1;

  @override
  void initState() {
    super.initState();
    _loadTodayRecords();
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getDietRecords(today);
    
    UserProfile? userProfile = await _dbService.getUserProfile();
    
    if (mounted) {
      setState(() {
        _todaySuggestion = DietSuggestionService.generateSuggestion(_todayRecords, userProfile);
      });
    }
  }

  Future<void> _openCameraRecognition() async {
    final l10n = AppLocalizations.of(context)!;
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraRecognitionScreen(
          onFoodConfirmed: (List<FoodRecognitionResult> foods, Map<String, int> servingsMap, String? imagePath) async {
            String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
            int totalCalories = 0;

            for (var food in foods) {
              int servings = servingsMap[food.name] ?? 1;
              double calories = food.calorie * servings;
              totalCalories += calories.toInt();

              DietRecord record = DietRecord(
                date: today,
                mealType: _mealType,
                foodName: food.name,
                calories: food.calorie,
                protein: 0,
                carbs: 0,
                fat: 0,
                servings: servings.toDouble(),
                foodImagePath: imagePath,
              );

              await _dbService.insertDietRecord(record);
            }

            await _scoreService.calculateDailyScore(today);
            await _loadTodayRecords();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.foodsRecognized(foods.length, totalCalories)),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showTodayDiet() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('今日饮食'),
        content: SizedBox(
          width: double.maxFinite,
          child: _todayRecords.isEmpty
              ? Center(child: Text('暂无记录'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _todayRecords.length,
                  itemBuilder: (context, index) {
                    var record = _todayRecords[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.restaurant, color: Colors.orange, size: 20),
                        ),
                        title: Text('${record.mealTypeName}: ${record.foodName}'),
                        subtitle: Text('${record.calories * record.servings} kcal'),
                        trailing: Text('x${record.servings}'),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diet),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: _openCameraRecognition,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.photoRecognize,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.aiRecognition,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_todayRecords.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showTodayDiet,
                  icon: const Icon(Icons.restaurant_menu),
                  label: Text('今日饮食 (${_todayRecords.length}项)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (_todaySuggestion != null) ...[
              Text(
                '今日建议',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: DietSuggestionService.getSuggestionTypeColor(_todaySuggestion!.type).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                _todaySuggestion!.icon,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DietSuggestionService.getSuggestionTypeText(_todaySuggestion!.type),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: DietSuggestionService.getSuggestionTypeColor(_todaySuggestion!.type),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _todaySuggestion!.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _todaySuggestion!.description,
                        style: const TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            DailyKnowledgeSection(
              category: 'diet',
              title: l10n.dietEducation,
            ),
          ],
        ),
      ),
    );
  }
}