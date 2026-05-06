import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../models/exercise_record.dart';
import '../models/knowledge_item.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  int _type = 1;
  final _subTypeController = TextEditingController();
  final _durationController = TextEditingController();
  int _intensity = 3;
  final _caloriesController = TextEditingController();
  final _stepsController = TextEditingController();
  List<KnowledgeItem> _knowledgeItems = [];
  List<ExerciseRecord> _todayRecords = [];
  int _totalDuration = 0;
  double _totalCalories = 0;
  int _totalSteps = 0;

  final List<String> _exerciseTypes = ['有氧运动', '力量训练', '柔韧性训练', '日常活动'];
  final List<String> _intensityLevels = ['低强度', '中低强度', '中等强度', '中高强度', '高强度'];
  final List<Map<String, dynamic>> _quickExercises = [
    {'name': '跑步', 'type': 1, 'duration': 30, 'intensity': 4, 'calories': 300},
    {'name': '游泳', 'type': 1, 'duration': 45, 'intensity': 3, 'calories': 400},
    {'name': '瑜伽', 'type': 3, 'duration': 60, 'intensity': 2, 'calories': 200},
    {'name': '哑铃训练', 'type': 2, 'duration': 40, 'intensity': 4, 'calories': 250},
    {'name': '散步', 'type': 1, 'duration': 30, 'intensity': 1, 'calories': 100},
    {'name': '跳绳', 'type': 1, 'duration': 15, 'intensity': 5, 'calories': 200},
    {'name': '俯卧撑', 'type': 2, 'duration': 10, 'intensity': 4, 'calories': 50},
    {'name': '拉伸', 'type': 3, 'duration': 15, 'intensity': 1, 'calories': 30},
  ];

  @override
  void initState() {
    super.initState();
    _loadKnowledge();
    _loadTodayRecords();
  }

  Future<void> _loadKnowledge() async {
    _knowledgeItems = await _dbService.getKnowledgeByCategory(3);
    setState(() {});
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getExerciseRecords(today);
    _calculateTotals();
    setState(() {});
  }

  void _calculateTotals() {
    _totalDuration = 0;
    _totalCalories = 0;
    _totalSteps = 0;
    for (var record in _todayRecords) {
      _totalDuration += record.duration;
      _totalCalories += record.caloriesBurned;
      _totalSteps += record.steps ?? 0;
    }
  }

  Future<void> _saveRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    ExerciseRecord record = ExerciseRecord(
      date: today,
      type: _type,
      subType: _subTypeController.text,
      duration: int.tryParse(_durationController.text) ?? 0,
      intensity: _intensity,
      caloriesBurned: double.tryParse(_caloriesController.text) ?? 0,
      steps: int.tryParse(_stepsController.text),
    );

    await _dbService.insertExerciseRecord(record);
    await _scoreService.calculateDailyScore(today);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('运动记录保存成功！')),
    );
    
    _clearForm();
    await _loadTodayRecords();
  }

  void _clearForm() {
    _subTypeController.clear();
    _durationController.clear();
    _intensity = 3;
    _caloriesController.clear();
    _stepsController.clear();
  }

  void _selectQuickExercise(Map<String, dynamic> exercise) {
    _type = exercise['type'];
    _subTypeController.text = exercise['name'];
    _durationController.text = exercise['duration'].toString();
    _intensity = exercise['intensity'];
    _caloriesController.text = exercise['calories'].toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('运动管理'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今日运动',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_totalDuration}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const Text('分钟'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_totalCalories.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const Text('卡路里'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_totalSteps}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const Text('步数'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '快速选择运动',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              children: _quickExercises.map((exercise) {
                return GestureDetector(
                  onTap: () => _selectQuickExercise(exercise),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(exercise['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${exercise['duration']}分钟', style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              '记录运动',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_run, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text('运动类型'),
                        const Spacer(),
                        DropdownButton<int>(
                          value: _type,
                          items: List.generate(4, (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text(_exerciseTypes[index]),
                          )),
                          onChanged: (value) => setState(() => _type = value!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _subTypeController,
                      decoration: const InputDecoration(
                        labelText: '运动项目',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text('运动时长'),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _durationController,
                            decoration: const InputDecoration(
                              hintText: '30',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('分钟'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text('运动强度'),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.local_fire_department,
                                color: index < _intensity ? Colors.orange : Colors.grey,
                              ),
                              onPressed: () => setState(() => _intensity = index + 1),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _caloriesController,
                            decoration: const InputDecoration(
                              labelText: '消耗卡路里',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _stepsController,
                            decoration: const InputDecoration(
                              labelText: '步数（可选）',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF42A5F5),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('保存记录', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '今日记录',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _todayRecords.isEmpty
                ? const Center(child: Text('暂无今日运动记录'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _todayRecords.length,
                    itemBuilder: (context, index) {
                      var record = _todayRecords[index];
                      return Card(
                        child: ListTile(
                          title: Text('${record.typeName}: ${record.subType}'),
                          subtitle: Text(
                            '${record.duration}分钟 | ${record.intensityName} | ${record.caloriesBurned}卡路里',
                          ),
                          trailing: record.steps != null ? Text('${record.steps}步') : null,
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            const Text(
              '运动科普',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    subtitle: Text('来源: ${item.source}'),
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