import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../models/sleep_record.dart';
import '../models/knowledge_item.dart';
import '../l10n/app_localizations.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  List<SleepRecord> _todayRecords = [];
  List<KnowledgeItem> _knowledgeItems = [];
  int _sleepQuality = 3;
  TimeOfDay _bedtime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

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
    _knowledgeItems = await _dbService.getKnowledgeByCategory(1);
    setState(() {});
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getSleepRecords(today);
    setState(() {});
  }

  Future<void> _selectBedtime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _bedtime,
    );
    if (picked != null) {
      setState(() => _bedtime = picked);
    }
  }

  Future<void> _selectWakeTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null) {
      setState(() => _wakeTime = picked);
    }
  }

  Future<void> _saveRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String bedtimeStr = '${_bedtime.hour.toString().padLeft(2, '0')}:${_bedtime.minute.toString().padLeft(2, '0')}';
    String wakeTimeStr = '${_wakeTime.hour.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')}';

    double duration = _calculateSleepDuration();

    SleepRecord record = SleepRecord(
      date: today,
      bedtime: bedtimeStr,
      wakeTime: wakeTimeStr,
      duration: duration,
      quality: _sleepQuality,
    );

    await _dbService.insertSleepRecord(record);
    await _scoreService.calculateDailyScore(today);
    await _loadTodayRecords();

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.sleepRecordSaved)),
    );
  }

  double _calculateSleepDuration() {
    int bedtimeMinutes = _bedtime.hour * 60 + _bedtime.minute;
    int wakeTimeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    int durationMinutes = wakeTimeMinutes - bedtimeMinutes;
    if (durationMinutes < 0) {
      durationMinutes += 24 * 60;
    }
    return durationMinutes / 60.0;
  }

  String _getQualityText(int? quality, AppLocalizations l10n) {
    switch (quality) {
      case 5:
        return l10n.veryHappy;
      case 4:
        return l10n.happy;
      case 3:
        return l10n.normal;
      case 2:
        return l10n.sad;
      case 1:
        return l10n.verySad;
      default:
        return l10n.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sleepManagement),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sleepDuration,
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
                        Expanded(
                          child: InkWell(
                            onTap: _selectBedtime,
                            child: Column(
                              children: [
                                const Icon(Icons.bedtime, color: Color(0xFF66BB6A), size: 32),
                                const SizedBox(height: 8),
                                Text(l10n.bedtime, style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(
                                  '${_bedtime.hour.toString().padLeft(2, '0')}:${_bedtime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 2,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: _selectWakeTime,
                            child: Column(
                              children: [
                                const Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
                                const SizedBox(height: 8),
                                Text(l10n.wakeTime, style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(
                                  '${_wakeTime.hour.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF66BB6A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_calculateSleepDuration().toStringAsFixed(1)} ${l10n.hours}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF66BB6A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.sleepQuality,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        int quality = 5 - index;
                        return GestureDetector(
                          onTap: () => setState(() => _sleepQuality = quality),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _sleepQuality == quality
                                  ? const Color(0xFF66BB6A)
                                  : Colors.grey[200],
                            ),
                            child: Center(
                              child: Icon(
                                _getQualityIcon(quality),
                                color: _sleepQuality == quality ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getQualityText(_sleepQuality, l10n),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF66BB6A),
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
                backgroundColor: const Color(0xFF66BB6A),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.recordSleep, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.todayRecords,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _todayRecords.isEmpty
                ? Center(child: Text(l10n.noSleepRecords))
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
                              color: const Color(0xFF66BB6A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.bed, color: Color(0xFF66BB6A)),
                          ),
                          title: Text('${record.bedtime ?? '--:--'} - ${record.wakeTime ?? '--:--'}'),
                          subtitle: Text('${record.duration?.toStringAsFixed(1) ?? '--'} ${l10n.hours}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getQualityIcon(record.quality), color: const Color(0xFF66BB6A)),
                              const SizedBox(width: 4),
                              Text(_getQualityText(record.quality, l10n)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Text(
              l10n.sleepEducation,
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

  IconData _getQualityIcon(int? quality) {
    switch (quality) {
      case 5:
        return Icons.sentiment_very_satisfied;
      case 4:
        return Icons.sentiment_satisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 1:
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }
}