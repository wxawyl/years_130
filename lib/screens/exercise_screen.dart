import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../models/exercise_record.dart';
import '../models/knowledge_item.dart';
import '../l10n/app_localizations.dart';
import 'analysis_screen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  List<ExerciseRecord> _todayRecords = [];
  List<KnowledgeItem> _knowledgeItems = [];
  int _exerciseType = 1;
  int _duration = 30;
  double _caloriesBurned = 0;
  final List<Map<String, dynamic>> _exerciseTypes = [
    {
      'name': 'walking',
      'icon': Icons.directions_walk,
      'image': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=300&h=300&fit=crop',
      'color': Colors.green,
      'calories': 5.5
    },
    {
      'name': 'running',
      'icon': Icons.directions_run,
      'image': 'https://images.unsplash.com/photo-1461896836934-ffe607ba821?w=300&h=300&fit=crop',
      'color': Colors.red,
      'calories': 10
    },
    {
      'name': 'cycling',
      'icon': Icons.directions_bike,
      'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
      'color': Colors.blue,
      'calories': 8
    },
    {
      'name': 'swimming',
      'icon': Icons.pool,
      'image': 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=300&h=300&fit=crop',
      'color': Colors.cyan,
      'calories': 9
    },
    {
      'name': 'pushups',
      'icon': Icons.sports_gymnastics,
      'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=300&h=300&fit=crop',
      'color': Colors.orange,
      'calories': 8
    },
    {
      'name': 'legRaises',
      'icon': Icons.sports_martial_arts,
      'image': 'https://images.unsplash.com/photo-1549060293-54c9e3fa1d00?w=300&h=300&fit=crop',
      'color': Colors.purple,
      'calories': 6
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateCalories();
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
        return l10n.pushups;
      case 6:
        return l10n.legRaises;
      default:
        return l10n.walking;
    }
  }

  Future<void> _saveRecord({int? editId}) async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    ExerciseRecord record = ExerciseRecord(
      id: editId,
      date: today,
      exerciseType: _exerciseType,
      subType: '',
      duration: _duration,
      intensity: 3,
      caloriesBurned: _caloriesBurned,
    );

    if (editId != null) {
      await _dbService.updateExerciseRecord(record);
    } else {
      await _dbService.insertExerciseRecord(record);
    }
    await _scoreService.calculateDailyScore(today);
    await _loadTodayRecords();

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(editId != null ? l10n.recordUpdated : l10n.exerciseRecordSaved)),
    );
  }

  void _editRecord(ExerciseRecord record) {
    setState(() {
      _exerciseType = record.exerciseType;
      _duration = record.duration;
      _caloriesBurned = record.caloriesBurned;
    });
  }

  void _deleteRecord(ExerciseRecord record) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteRecordConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await _dbService.deleteExerciseRecord(record.id!);
              await _scoreService.calculateDailyScore(DateFormat('yyyy-MM-dd').format(DateTime.now()));
              await _loadTodayRecords();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.recordDeleted)),
              );
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
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
              childAspectRatio: 0.8,
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
                          ? BorderSide(color: _exerciseTypes[index]['color'], width: 3)
                          : BorderSide.none,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              image: DecorationImage(
                                image: NetworkImage(_exerciseTypes[index]['image']),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  _exerciseTypes[index]['color'].withOpacity(0.3),
                                  BlendMode.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _exerciseTypes[index]['icon'],
                                  size: 28,
                                  color: isSelected 
                                    ? _exerciseTypes[index]['color'] 
                                    : Colors.grey[600],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getExerciseName(type, l10n),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected 
                                      ? _exerciseTypes[index]['color'] 
                                      : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
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
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalysisScreen(analysisType: AnalysisType.exercise)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF42A5F5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.bar_chart),
              label: Text(l10n.exerciseAnalysis, style: const TextStyle(fontSize: 16)),
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
                      var exerciseType = _exerciseTypes[record.exerciseType - 1];
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: exerciseType['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              exerciseType['icon'],
                              color: exerciseType['color'],
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
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editRecord(record),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteRecord(record),
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