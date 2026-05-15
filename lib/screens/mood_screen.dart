import 'package:flutter/material.dart';
import '../widgets/daily_knowledge_card.dart';
import '../services/daily_suggestion_service.dart';
import '../services/sentiment_analysis_service.dart';
import '../services/database_service.dart';
import '../models/voice_diary_record.dart';
import '../l10n/app_localizations.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final TextEditingController _diaryController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  List<VoiceDiaryRecord> _diaries = [];
  bool _isAnalyzing = false;
  DailySuggestion? _todaySuggestion;
  List<String> _recentStressors = [];
  double? _recentSentimentScore;

  @override
  void initState() {
    super.initState();
    _loadDiaries();
    _loadSuggestion();
  }

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  Future<void> _loadDiaries() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final diaries = await _dbService.getVoiceDiariesByDateRange(today);
    if (mounted) {
      setState(() {
        _diaries = diaries.reversed.toList();
      });
    }
  }

  Future<void> _loadSuggestion() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final diaries = await _dbService.getVoiceDiariesByDateRange(today);
    
    List<String> stressors = [];
    double? sentimentScore;
    
    if (diaries.isNotEmpty) {
      for (var diary in diaries) {
        if (diary.stressors != null) {
          stressors.addAll(diary.stressors!);
        }
        if (diary.sentimentScore != null) {
          sentimentScore = diary.sentimentScore;
        }
      }
      stressors = stressors.toSet().toList();
    }

    if (mounted) {
      setState(() {
        _recentStressors = stressors;
        _recentSentimentScore = sentimentScore;
        _todaySuggestion = DailySuggestionService.getTodaySuggestion(
          stressors: stressors.isEmpty ? null : stressors,
          sentimentScore: sentimentScore,
        );
      });
    }
  }

  Future<void> _saveDiary() async {
    if (_diaryController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = SentimentAnalysisService.analyze(_diaryController.text);
      final today = DateTime.now().toIso8601String().substring(0, 10);

      final record = VoiceDiaryRecord(
        date: today,
        content: _diaryController.text,
        durationSeconds: null,
        sentimentScore: result.sentimentScore,
        anxietyLevel: result.anxietyLevel,
        stressors: result.stressors,
        moodCategory: result.moodCategory,
      );

      await _dbService.insertVoiceDiary(record);
      
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        _diaryController.clear();
        await _loadDiaries();
        await _loadSuggestion();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  Future<void> _deleteDiary(int id) async {
    await _dbService.deleteVoiceDiary(id);
    await _loadDiaries();
    await _loadSuggestion();
  }

  void _showDiaryDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('日记详情'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _diaries.length,
            itemBuilder: (context, index) {
              final diary = _diaries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      diary.moodCategory ?? '未知',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFCA28),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getAnxietyColor(diary.anxietyLevel).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _getAnxietyLabel(diary.anxietyLevel),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getAnxietyColor(diary.anxietyLevel),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (diary.createdAt != null)
                                  Text(
                                    diary.createdAt!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey),
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteDialog(diary.id!);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(diary.content),
                      if (diary.stressors != null && diary.stressors!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: diary.stressors!.map((stressor) => Chip(
                            label: Text(stressor, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.grey[100],
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
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
        title: Text(l10n.moodManagement),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '心情日记',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    TextField(
                      controller: _diaryController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: '写下你现在的心情...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isAnalyzing ? null : _saveDiary,
                        icon: _isAnalyzing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isAnalyzing ? '保存中...' : '保存'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCA28),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_diaries.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _showDiaryDetails,
                          icon: const Icon(Icons.list_alt),
                          label: const Text('日记详情'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_todaySuggestion != null) ...[
              const Text(
                '今日建议',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              color: const Color(0xFFFFCA28).withOpacity(0.2),
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
                            child: Text(
                              _todaySuggestion!.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFCA28),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _todaySuggestion!.content,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      if (_todaySuggestion!.source.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _todaySuggestion!.source,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (_recentStressors.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _recentStressors.map((stressor) => Chip(
                            label: Text(stressor),
                            backgroundColor: const Color(0xFFFFCA28).withOpacity(0.2),
                            side: BorderSide.none,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            DailyKnowledgeSection(
              category: 'mood',
              title: l10n.moodEducation,
            ),
          ],
        ),
      ),
    );
  }

  String _getAnxietyLabel(int? level) {
    switch (level) {
      case 1:
        return '放松';
      case 2:
        return '平静';
      case 3:
        return '轻微焦虑';
      case 4:
        return '中度焦虑';
      case 5:
        return '高度焦虑';
      default:
        return '未知';
    }
  }

  Color _getAnxietyColor(int? level) {
    switch (level) {
      case 1:
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除日记'),
        content: const Text('确定要删除这篇日记吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDiary(id);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
