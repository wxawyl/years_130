import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../models/sleep_record.dart';
import '../models/knowledge_item.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  final _bedTimeController = TextEditingController();
  final _wakeTimeController = TextEditingController();
  final _notesController = TextEditingController();
  int _quality = 3;
  double _deepSleepRatio = 0.25;
  List<KnowledgeItem> _knowledgeItems = [];
  List<SleepRecord> _todayRecords = [];

  @override
  void initState() {
    super.initState();
    _loadKnowledge();
    _loadTodayRecords();
  }

  Future<void> _loadKnowledge() async {
    _knowledgeItems = await _dbService.getKnowledgeByCategory(1);
    setState(() {});
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getSleepRecords(today);
    setState(() {});
  }

  Future<void> _saveRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    SleepRecord record = SleepRecord(
      date: today,
      bedTime: _bedTimeController.text,
      wakeTime: _wakeTimeController.text,
      duration: _calculateDuration(),
      quality: _quality,
      deepSleepRatio: _deepSleepRatio,
      notes: _notesController.text,
    );

    await _dbService.insertSleepRecord(record);
    await _scoreService.calculateDailyScore(today);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('睡眠记录保存成功！')),
    );
    
    _bedTimeController.clear();
    _wakeTimeController.clear();
    _notesController.clear();
    _quality = 3;
    _deepSleepRatio = 0.25;
    await _loadTodayRecords();
  }

  double? _calculateDuration() {
    if (_bedTimeController.text.isEmpty || _wakeTimeController.text.isEmpty) {
      return null;
    }
    
    try {
      List<String> bedParts = _bedTimeController.text.split(':');
      List<String> wakeParts = _wakeTimeController.text.split(':');
      
      int bedHour = int.parse(bedParts[0]);
      int bedMin = int.parse(bedParts[1]);
      int wakeHour = int.parse(wakeParts[0]);
      int wakeMin = int.parse(wakeParts[1]);
      
      int bedTotal = bedHour * 60 + bedMin;
      int wakeTotal = wakeHour * 60 + wakeMin;
      
      int diff = wakeTotal - bedTotal;
      if (diff < 0) diff += 24 * 60;
      
      return diff / 60;
    } catch (_) {
      return null;
    }
  }

  void _editRecord(SleepRecord record) {
    _bedTimeController.text = record.bedTime ?? '';
    _wakeTimeController.text = record.wakeTime ?? '';
    _notesController.text = record.notes ?? '';
    _quality = record.quality ?? 3;
    _deepSleepRatio = record.deepSleepRatio ?? 0.25;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑睡眠记录'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _bedTimeController,
                decoration: const InputDecoration(labelText: '入睡时间'),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _wakeTimeController,
                decoration: const InputDecoration(labelText: '醒来时间'),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('睡眠质量'),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: index < _quality ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: () => setState(() => _quality = index + 1),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: '备注'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _bedTimeController.clear();
              _wakeTimeController.clear();
              _notesController.clear();
              _quality = 3;
              _deepSleepRatio = 0.25;
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              SleepRecord updatedRecord = SleepRecord(
                id: record.id,
                date: record.date,
                bedTime: _bedTimeController.text,
                wakeTime: _wakeTimeController.text,
                duration: _calculateDuration(),
                quality: _quality,
                deepSleepRatio: _deepSleepRatio,
                notes: _notesController.text,
              );
              
              await _dbService.updateSleepRecord(updatedRecord);
              await _scoreService.calculateDailyScore(record.date);
              await _loadTodayRecords();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('记录更新成功！')),
              );
              
              _bedTimeController.clear();
              _wakeTimeController.clear();
              _notesController.clear();
              _quality = 3;
              _deepSleepRatio = 0.25;
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _deleteRecord(SleepRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条睡眠记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await _dbService.deleteSleepRecord(record.id!);
              await _scoreService.calculateDailyScore(record.date);
              await _loadTodayRecords();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('记录已删除')),
              );
              
              Navigator.pop(context);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('睡眠管理'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '记录睡眠',
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
                        const Icon(Icons.nightlight_round, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text('入睡时间'),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _bedTimeController,
                            decoration: const InputDecoration(
                              hintText: '22:30',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny, color: Colors.amber),
                        const SizedBox(width: 8),
                        const Text('醒来时间'),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _wakeTimeController,
                            decoration: const InputDecoration(
                              hintText: '07:30',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        const SizedBox(width: 8),
                        const Text('睡眠质量'),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: index < _quality ? Colors.yellow : Colors.grey,
                              ),
                              onPressed: () => setState(() => _quality = index + 1),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.cloud, color: Colors.lightBlue),
                        const SizedBox(width: 8),
                        const Text('深度睡眠比例'),
                        const Spacer(),
                        Text('${(_deepSleepRatio * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                    Slider(
                      value: _deepSleepRatio,
                      min: 0.1,
                      max: 0.5,
                      onChanged: (value) => setState(() => _deepSleepRatio = value),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: '备注（可选）',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A),
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
                ? const Center(child: Text('暂无今日睡眠记录'))
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
                              label: '编辑',
                              backgroundColor: Colors.blue,
                              icon: Icons.edit,
                              onPressed: (context) => _editRecord(record),
                            ),
                            SlidableAction(
                              label: '删除',
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              onPressed: (context) => _deleteRecord(record),
                            ),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text('入睡: ${record.bedTime} - 醒来: ${record.wakeTime}'),
                            subtitle: Text(
                              '时长: ${record.duration?.toStringAsFixed(1)}小时 | 质量: ${'⭐' * (record.quality ?? 0)}',
                            ),
                            trailing: Text(record.notes ?? ''),
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            const Text(
              '睡眠科普',
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