import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../models/mood_record.dart';
import '../models/knowledge_item.dart';
import '../l10n/app_localizations.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  List<MoodRecord> _todayRecords = [];
  List<KnowledgeItem> _knowledgeItems = [];
  int _moodLevel = 3;
  final _noteController = TextEditingController();

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
    _knowledgeItems = await _dbService.getKnowledgeByCategory(4);
    setState(() {});
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getMoodRecords(today);
    setState(() {});
  }

  String _getMoodText(int level, AppLocalizations l10n) {
    switch (level) {
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

  IconData _getMoodIcon(int level) {
    switch (level) {
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

  Color _getMoodColor(int level) {
    switch (level) {
      case 5:
        return const Color(0xFF66BB6A);
      case 4:
        return const Color(0xFF9CCC65);
      case 3:
        return const Color(0xFFFFCA28);
      case 2:
        return const Color(0xFFFF7043);
      case 1:
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFFFFCA28);
    }
  }

  Future<void> _saveRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    MoodRecord record = MoodRecord(
      date: today,
      moodLevel: _moodLevel,
      note: _noteController.text,
    );

    await _dbService.insertMoodRecord(record);
    await _scoreService.calculateDailyScore(today);
    await _loadTodayRecords();

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.moodRecordSaved)),
    );

    _noteController.clear();
    setState(() {
      _moodLevel = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moodManagement),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.moodLevel,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getMoodColor(_moodLevel).withOpacity(0.2),
                      ),
                      child: Icon(
                        _getMoodIcon(_moodLevel),
                        size: 80,
                        color: _getMoodColor(_moodLevel),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getMoodText(_moodLevel, l10n),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getMoodColor(_moodLevel),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        int level = 5 - index;
                        bool isSelected = _moodLevel == level;
                        return GestureDetector(
                          onTap: () => setState(() => _moodLevel = level),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? _getMoodColor(level)
                                  : _getMoodColor(level).withOpacity(0.2),
                              border: isSelected
                                  ? Border.all(color: _getMoodColor(level), width: 3)
                                  : null,
                            ),
                            child: Center(
                              child: Icon(
                                _getMoodIcon(level),
                                color: isSelected ? Colors.white : _getMoodColor(level),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.note,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.note,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getMoodColor(_moodLevel),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.recordMood, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.todayRecords,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _todayRecords.isEmpty
                ? Center(child: Text(l10n.noMoodRecords))
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
                              color: _getMoodColor(record.moodLevel).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getMoodIcon(record.moodLevel),
                              color: _getMoodColor(record.moodLevel),
                            ),
                          ),
                          title: Text(_getMoodText(record.moodLevel, l10n)),
                          subtitle: record.note != null && record.note!.isNotEmpty
                              ? Text(record.note!)
                              : null,
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Text(
              l10n.moodEducation,
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