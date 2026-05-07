import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../services/music_service.dart';
import '../services/audio_player_service.dart';
import '../models/mood_record.dart';
import '../models/knowledge_item.dart';
import '../models/meditation_music.dart';
import 'music_selection_screen.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  final _musicService = MusicService();
  final _audioPlayer = AudioPlayerService();
  int _moodScore = 3;
  int _stressLevel = 3;
  final _diaryController = TextEditingController();
  final _gratitudeController = TextEditingController();
  List<KnowledgeItem> _knowledgeItems = [];
  MoodRecord? _todayRecord;
  bool _isMeditating = false;
  int _meditationSeconds = 0;
  Timer? _meditationTimer;
  MeditationMusic? _currentMusic;

  @override
  void initState() {
    super.initState();
    _loadKnowledge();
    _loadTodayRecord();
  }

  @override
  void dispose() {
    _meditationTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadKnowledge() async {
    _knowledgeItems = await _dbService.getKnowledgeByCategory(4);
    setState(() {});
  }

  Future<void> _loadTodayRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecord = await _dbService.getMoodRecord(today);
    if (_todayRecord != null) {
      setState(() {
        _moodScore = _todayRecord!.moodScore;
        _stressLevel = _todayRecord!.stressLevel;
        _diaryController.text = _todayRecord!.diary ?? '';
        _gratitudeController.text = _todayRecord!.gratitude ?? '';
      });
    }
    setState(() {});
  }

  Future<void> _saveRecord() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    MoodRecord record = MoodRecord(
      date: today,
      moodScore: _moodScore,
      stressLevel: _stressLevel,
      diary: _diaryController.text,
      gratitude: _gratitudeController.text,
    );

    await _dbService.insertMoodRecord(record);
    await _scoreService.calculateDailyScore(today);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('心情记录保存成功！')),
    );
    
    await _loadTodayRecord();
  }

  void _startMeditation() async {
    setState(() {
      _isMeditating = true;
      _meditationSeconds = 0;
    });
    
    _meditationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _meditationSeconds++;
      });
    });
    
    try {
      _currentMusic = _musicService.getRandomMusic();
      await _audioPlayer.play(_currentMusic!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始播放: ${_currentMusic!.title}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('音乐播放失败，请检查网络')),
      );
    }
  }

  void _stopMeditation() {
    _meditationTimer?.cancel();
    _audioPlayer.stop();
    setState(() {
      _isMeditating = false;
      _currentMusic = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('冥想完成！共 ${_meditationSeconds ~/ 60}分${_meditationSeconds % 60}秒')),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _editRecord() {
    if (_todayRecord == null) return;
    
    _moodScore = _todayRecord!.moodScore;
    _stressLevel = _todayRecord!.stressLevel;
    _diaryController.text = _todayRecord!.diary ?? '';
    _gratitudeController.text = _todayRecord!.gratitude ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑心情记录'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Text('今日心情'),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        iconSize: 32,
                        icon: Icon(
                          index < _moodScore ? Icons.sentiment_very_satisfied : Icons.sentiment_neutral,
                          color: index < _moodScore ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: () => setState(() => _moodScore = index + 1),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('压力水平'),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.speed,
                          color: index < _stressLevel ? Colors.orange : Colors.grey,
                        ),
                        onPressed: () => setState(() => _stressLevel = index + 1),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _diaryController,
                decoration: const InputDecoration(labelText: '心情日记'),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _gratitudeController,
                decoration: const InputDecoration(labelText: '感恩事项'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _loadTodayRecord();
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              MoodRecord updatedRecord = MoodRecord(
                id: _todayRecord!.id,
                date: _todayRecord!.date,
                moodScore: _moodScore,
                stressLevel: _stressLevel,
                diary: _diaryController.text,
                gratitude: _gratitudeController.text,
              );
              
              await _dbService.updateMoodRecord(updatedRecord);
              await _scoreService.calculateDailyScore(_todayRecord!.date);
              await _loadTodayRecord();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('记录更新成功！')),
              );
              
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _deleteRecord() {
    if (_todayRecord == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除今天的心情记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await _dbService.deleteMoodRecord(_todayRecord!.id!);
              await _scoreService.calculateDailyScore(_todayRecord!.date);
              _todayRecord = null;
              _moodScore = 3;
              _stressLevel = 3;
              _diaryController.clear();
              _gratitudeController.clear();
              setState(() {});
              
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
        title: const Text('心态管理'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今日心情',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      _todayRecord?.moodEmoji ?? '😐',
                      style: const TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _todayRecord?.moodText ?? '尚未记录',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (_todayRecord != null) ...[
                      const SizedBox(height: 8),
                      Text('压力水平: ${_todayRecord!.stressText}'),
                      if (_todayRecord!.diary?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 8),
                        Text('日记: ${_todayRecord!.diary}'),
                      ],
                      if (_todayRecord!.gratitude?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 8),
                        Text('感恩: ${_todayRecord!.gratitude}'),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _editRecord(),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => _deleteRecord(),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '记录心情',
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
                        const Icon(Icons.sentiment_satisfied, color: Colors.yellow),
                        const SizedBox(width: 8),
                        const Text('今日心情'),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              iconSize: 40,
                              icon: Icon(
                                index < _moodScore ? Icons.sentiment_very_satisfied : Icons.sentiment_neutral,
                                color: index < _moodScore ? Colors.yellow : Colors.grey,
                              ),
                              onPressed: () => setState(() => _moodScore = index + 1),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text('压力水平'),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.speed,
                                color: index < _stressLevel ? Colors.orange : Colors.grey,
                              ),
                              onPressed: () => setState(() => _stressLevel = index + 1),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _diaryController,
                      decoration: const InputDecoration(
                        labelText: '心情日记',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _gratitudeController,
                      decoration: const InputDecoration(
                        labelText: '感恩事项（每天记录一件感恩的事）',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFCA28),
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
              '冥想放松',
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
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isMeditating ? Colors.green[100] : Colors.grey[100],
                      ),
                      child: Center(
                        child: Text(
                          _formatTime(_meditationSeconds),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isMeditating
                        ? ElevatedButton(
                            onPressed: _stopMeditation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('结束冥想', style: TextStyle(fontSize: 16)),
                          )
                        : ElevatedButton(
                            onPressed: _startMeditation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF66BB6A),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('开始冥想', style: TextStyle(fontSize: 16)),
                          ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MusicSelectionScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.music_note, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('选择冥想音乐', style: TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '心态科普',
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