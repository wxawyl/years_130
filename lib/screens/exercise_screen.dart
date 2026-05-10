import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service_unified.dart';
import '../services/score_service.dart';
import '../models/exercise_record.dart';
import '../models/knowledge_item.dart';
import '../l10n/app_localizations.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _dbService = DatabaseServiceUnified();
  final _scoreService = ScoreService();
  List<ExerciseRecord> _todayRecords = [];
  List<KnowledgeItem> _knowledgeItems = [];
  int _exerciseType = 1;
  int _duration = 30;
  double _caloriesBurned = 0;
  final List<Map<String, dynamic>> _exerciseTypes = [
    {'name': 'walking', 'icon': Icons.directions_walk, 'calories': 5.5},
    {'name': 'running', 'icon': Icons.directions_run, 'calories': 10},
    {'name': 'cycling', 'icon': Icons.directions_bike, 'calories': 8},
    {'name': 'swimming', 'icon': Icons.pool, 'calories': 9},
    {'name': 'yoga', 'icon': Icons.self_improvement, 'calories': 3.5},
    {'name': 'gym', 'icon': Icons.fitness_center, 'calories': 7},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadKnowledge();
    await _loadTodayRecords();
  }

  Future<void> _loadKnowledge() async {
    _knowledgeItems = await _dbService.getKnowledgeByCategory(3);
    setState(() {});
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getExerciseRecords(today);
    setState(() {});
  }

  void _updateCalories() {
    double caloriesPerMinute = _exerciseTypes[_exerciseType - 1]['calories'];
    setState(() {
      _caloriesBurned = caloriesPerMinute * _duration;
    });
  }

  String _getExerciseName(int type, AppLocalizations l10n) {
    switch (type) {
      case 1:
        return l10n.walking;
      case 2:
        return l10n.running;
      case 3:
        return l10n.cycling;
      case 4:
        return l10n.swimming;
      case 5:
        return l10n.yoga;
      case 6:
        return l10n.gym;
      default:
        return l10n.walking;
    }
  }

  Future<void> _saveRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    ExerciseRecord record = ExerciseRecord(
      date: today,
      exerciseType: _exerciseType,
      subType: '',
      duration: _duration,
      intensity: 3,
      caloriesBurned: _caloriesBurned,
    );

    await _dbService.insertExerciseRecord(record);
    await _scoreService.calculateDailyScore(today);
    await _loadTodayRecords();

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.exerciseRecordSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exerciseManagement),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.exerciseType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: List.generate(_exerciseTypes.length, (index) {
                int type = index + 1;
                bool isSelected = _exerciseType == type;
                return GestureDetector(
                  onTap: () {
                    setState(() => _exerciseType = type);
                    _updateCalories();
                  },
                  child: Card(
                    elevation: isSelected ? 8 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: isSelected
                          ? const BorderSide(color: Color(0xFF42A5F5), width: 2)
                          : BorderSide.none,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _exerciseTypes[index]['icon'],
                          size: 36,
                          color: isSelected ? const Color(0xFF42A5F5) : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getExerciseName(type, l10n),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF42A5F5) : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.duration,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Color(0xFF42A5F5), size: 32),
                        const SizedBox(width: 16),
                        Text(
                          '$_duration ${l10n.minutes}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF42A5F5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: _duration.toDouble(),
                      min: 5,
                      max: 180,
                      divisions: 35,
                      activeColor: const Color(0xFF42A5F5),
                      onChanged: (value) {
                        setState(() => _duration = value.toInt());
                        _updateCalories();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('5 ${l10n.minutes}'),
                        Text('180 ${l10n.minutes}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.caloriesBurned,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 40),
                    const SizedBox(width: 12),
                    Text(
                      '${_caloriesBurned.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF42A5F5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.recordExercise, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.todayRecords,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _todayRecords.isEmpty
                ? Center(child: Text(l10n.noExerciseRecords))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _todayRecords.length,
                    itemBuilder: (context, index) {
                      var record = _todayRecords[index];
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF42A5F5).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _exerciseTypes[record.exerciseType - 1]['icon'],
                              color: const Color(0xFF42A5F5),
                            ),
                          ),
                          title: Text(_getExerciseName(record.exerciseType, l10n)),
                          subtitle: Text('${record.duration} ${l10n.minutes}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${record.caloriesBurned.toStringAsFixed(0)} kcal',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Text(
              l10n.exerciseEducation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _knowledgeItems.length,
              itemBuilder: (context, index) {
                var item = _knowledgeItems[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(item.title),
                    subtitle: Text('${l10n.source}: ${item.source}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(item.content),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}