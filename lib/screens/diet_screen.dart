import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../services/database_service_unified.dart';
import '../services/score_service.dart';
import '../models/diet_record.dart';
import '../models/knowledge_item.dart';
import '../models/food_recognition_result.dart';
import '../l10n/app_localizations.dart';
import 'camera_recognition_screen.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final _dbService = DatabaseServiceUnified();
  final _scoreService = ScoreService();
  int _mealType = 1;
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _servingsController = TextEditingController(text: '1');
  List<KnowledgeItem> _knowledgeItems = [];
  List<DietRecord> _todayRecords = [];
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbs = 0;
  double _totalFat = 0;

  @override
  void initState() {
    super.initState();
    _loadKnowledge();
    _loadTodayRecords();
  }

  Future<void> _loadKnowledge() async {
    _knowledgeItems = await _dbService.getKnowledgeByCategory(2);
    setState(() {});
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getDietRecords(today);
    _calculateTotals();
    setState(() {});
  }

  void _calculateTotals() {
    _totalCalories = 0;
    _totalProtein = 0;
    _totalCarbs = 0;
    _totalFat = 0;
    for (var record in _todayRecords) {
      _totalCalories += record.calories * record.servings;
      _totalProtein += record.protein * record.servings;
      _totalCarbs += record.carbs * record.servings;
      _totalFat += record.fat * record.servings;
    }
  }

  Future<void> _saveRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DietRecord record = DietRecord(
      date: today,
      mealType: _mealType,
      foodName: _foodNameController.text,
      calories: double.tryParse(_caloriesController.text) ?? 0,
      protein: double.tryParse(_proteinController.text) ?? 0,
      carbs: double.tryParse(_carbsController.text) ?? 0,
      fat: double.tryParse(_fatController.text) ?? 0,
      servings: double.tryParse(_servingsController.text) ?? 1,
    );

    await _dbService.insertDietRecord(record);
    await _scoreService.calculateDailyScore(today);

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.recordSaved)),
    );

    _clearForm();
    await _loadTodayRecords();
  }

  void _clearForm() {
    _foodNameController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
    _servingsController.text = '1';
  }

  void _selectQuickFood(Map<String, dynamic> food) {
    _foodNameController.text = food['name'];
    _caloriesController.text = food['calories'].toString();
    _proteinController.text = food['protein'].toString();
    _carbsController.text = food['carbs'].toString();
    _fatController.text = food['fat'].toString();
  }

  void _editRecord(DietRecord record) {
    final l10n = AppLocalizations.of(context)!;
    _mealType = record.mealType;
    _foodNameController.text = record.foodName;
    _caloriesController.text = record.calories.toString();
    _proteinController.text = record.protein.toString();
    _carbsController.text = record.carbs.toString();
    _fatController.text = record.fat.toString();
    _servingsController.text = record.servings.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editDietRecord),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _mealType,
                items: [
                  DropdownMenuItem(value: 1, child: Text(l10n.breakfast)),
                  DropdownMenuItem(value: 2, child: Text(l10n.lunch)),
                  DropdownMenuItem(value: 3, child: Text(l10n.dinner)),
                  DropdownMenuItem(value: 4, child: Text(l10n.snack)),
                ],
                onChanged: (value) => setState(() => _mealType = value!),
                decoration: InputDecoration(labelText: l10n.mealType),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _foodNameController,
                decoration: InputDecoration(labelText: l10n.foodName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: l10n.calories),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _servingsController,
                decoration: InputDecoration(labelText: l10n.servings),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _proteinController,
                decoration: InputDecoration(labelText: l10n.protein),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _carbsController,
                decoration: InputDecoration(labelText: l10n.carbs),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fatController,
                decoration: InputDecoration(labelText: l10n.fat),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearForm();
              Navigator.pop(context);
            },
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              DietRecord updatedRecord = DietRecord(
                id: record.id,
                date: record.date,
                mealType: _mealType,
                foodName: _foodNameController.text,
                calories: double.tryParse(_caloriesController.text) ?? 0,
                protein: double.tryParse(_proteinController.text) ?? 0,
                carbs: double.tryParse(_carbsController.text) ?? 0,
                fat: double.tryParse(_fatController.text) ?? 0,
                servings: double.tryParse(_servingsController.text) ?? 1,
              );

              await _dbService.updateDietRecord(updatedRecord);
              await _scoreService.calculateDailyScore(record.date);
              await _loadTodayRecords();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.recordUpdated)),
              );

              _clearForm();
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _deleteRecord(DietRecord record) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteMessage(record.foodName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await _dbService.deleteDietRecord(record.id!);
              await _scoreService.calculateDailyScore(record.date);
              await _loadTodayRecords();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.recordDeleted)),
              );

              Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
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

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.foodsRecognized(foods.length, totalCalories)),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> mealTypes = [l10n.breakfast, l10n.lunch, l10n.dinner, l10n.snack];
    final List<Map<String, dynamic>> quickFoods = [
      {'name': '米饭', 'calories': 130, 'protein': 2.7, 'carbs': 28, 'fat': 0.3},
      {'name': '鸡蛋', 'calories': 143, 'protein': 13, 'carbs': 1.1, 'fat': 10},
      {'name': '牛奶', 'calories': 60, 'protein': 3.2, 'carbs': 5, 'fat': 3.2},
      {'name': '苹果', 'calories': 52, 'protein': 0.3, 'carbs': 14, 'fat': 0.2},
      {'name': '香蕉', 'calories': 91, 'protein': 1.1, 'carbs': 23, 'fat': 0.3},
      {'name': '鸡胸肉', 'calories': 165, 'protein': 31, 'carbs': 0, 'fat': 3.6},
      {'name': '西兰花', 'calories': 34, 'protein': 2.8, 'carbs': 7, 'fat': 0.4},
      {'name': '燕麦', 'calories': 389, 'protein': 17, 'carbs': 66, 'fat': 7},
    ];

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
            Text(
              l10n.todayIntake,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          Text('${_totalCalories.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(l10n.calories),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_totalProtein.toStringAsFixed(1)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(l10n.protein),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_totalCarbs.toStringAsFixed(1)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(l10n.carbs),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_totalFat.toStringAsFixed(1)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(l10n.fat),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: _openCameraRecognition,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Column(
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
                      const Spacer(),
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
            Text(
              l10n.quickAddFood,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              children: quickFoods.map((food) {
                return GestureDetector(
                  onTap: () => _selectQuickFood(food),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(food['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${food['calories']} kcal', style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.recordDiet,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        const Icon(Icons.restaurant, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(l10n.mealType),
                        const Spacer(),
                        DropdownButton<int>(
                          value: _mealType,
                          items: List.generate(4, (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text(mealTypes[index]),
                          )),
                          onChanged: (value) => setState(() => _mealType = value!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _foodNameController,
                      decoration: InputDecoration(
                        labelText: l10n.foodName,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _caloriesController,
                            decoration: InputDecoration(
                              labelText: l10n.calories,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _servingsController,
                            decoration: InputDecoration(
                              labelText: l10n.servings,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _proteinController,
                            decoration: InputDecoration(
                              labelText: l10n.protein,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _carbsController,
                            decoration: InputDecoration(
                              labelText: l10n.carbs,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _fatController,
                            decoration: InputDecoration(
                              labelText: l10n.fat,
                              border: const OutlineInputBorder(),
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
                        backgroundColor: const Color(0xFFFF7043),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.saveRecord, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.todayRecords,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _todayRecords.isEmpty
                ? Center(child: Text(l10n.noRecordsToday))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _todayRecords.length,
                    itemBuilder: (context, index) {
                      var record = _todayRecords[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              label: l10n.edit,
                              backgroundColor: Colors.blue,
                              icon: Icons.edit,
                              onPressed: (context) => _editRecord(record),
                            ),
                            SlidableAction(
                              label: l10n.delete,
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              onPressed: (context) => _deleteRecord(record),
                            ),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text('${record.mealTypeName}: ${record.foodName}'),
                            subtitle: Text(
                              '${record.calories * record.servings} kcal | ${record.protein * record.servings}g${l10n.protein}',
                            ),
                            trailing: Text('x${record.servings}'),
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Text(
              l10n.dietEducation,
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