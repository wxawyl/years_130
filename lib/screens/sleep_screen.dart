import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/score_service.dart';
import '../services/health_service.dart';
import '../services/sleep_suggestion_service.dart';
import '../models/sleep_record.dart';
import '../models/user_profile.dart';
import '../widgets/daily_knowledge_card.dart';
import '../providers/theme_provider.dart';
import '../widgets/dynamic_background.dart';
import '../l10n/app_localizations.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _dbService = DatabaseService();
  final _scoreService = ScoreService();
  final _healthService = HealthService();
  List<SleepRecord> _todayRecords = [];
  SleepSuggestion? _todaySuggestion;
  UserProfile? _userProfile;
  bool _isSyncing = false;
  bool _hasSynced = false;

  @override
  void initState() {
    super.initState();
    _loadTodayRecords();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    _userProfile = await _dbService.getUserProfile();
  }

  Future<void> _loadTodayRecords() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _todayRecords = await _dbService.getSleepRecords(today);
    
    final todayRecord = _todayRecords.isNotEmpty ? _todayRecords.first : null;
    _todaySuggestion = SleepSuggestionService.generateSuggestion(todayRecord, _userProfile);
    
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _syncWithHealthKit() async {
    if (_isSyncing) return;
    
    setState(() => _isSyncing = true);
    
    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day - 7);
      final endDate = DateTime(now.year, now.month, now.day + 1);
      
      final sleepRecords = await _healthService.fetchSleepData(startDate, endDate);
      
      for (var record in sleepRecords) {
        final existingRecords = await _dbService.getSleepRecords(record.date);
        if (existingRecords.isEmpty) {
          await _dbService.insertSleepRecord(record);
        }
      }
      
      await _loadTodayRecords();
      
      if (mounted) {
        setState(() => _hasSynced = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('睡眠数据同步成功！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('同步失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  void _editRecord(SleepRecord record) {
    showDialog(
      context: context,
      builder: (context) => SleepEditDialog(
        record: record,
        onSave: (updatedRecord) async {
          await _dbService.updateSleepRecord(updatedRecord);
          await _scoreService.calculateDailyScore(updatedRecord.date);
          await _loadTodayRecords();
          if (mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _deleteRecord(SleepRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除这条睡眠记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await _dbService.deleteSleepRecord(record.id!);
              await _scoreService.calculateDailyScore(DateFormat('yyyy-MM-dd').format(DateTime.now()));
              await _loadTodayRecords();
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getSuggestionTypeColor(SuggestionType type) {
    switch (type) {
      case SuggestionType.positive:
        return Colors.green;
      case SuggestionType.warning:
        return Colors.orange;
      case SuggestionType.improvement:
        return Colors.blue;
      case SuggestionType.info:
        return Colors.grey;
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayRecord = _todayRecords.isNotEmpty ? _todayRecords.first : null;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.sleepManagement),
            const SizedBox(width: 8),
            if (_isSyncing)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              InkWell(
                onTap: _syncWithHealthKit,
                child: const Tooltip(
                  message: '同步 HealthKit 数据',
                  child: Text(
                    'HealthKit',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        centerTitle: true,
      ),
      body: DynamicBackground(
        theme: themeProvider.currentTheme,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              color: _getSuggestionTypeColor(_todaySuggestion!.type).withOpacity(0.1),
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
                                  _todaySuggestion!.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getSuggestionTypeColor(_todaySuggestion!.type),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _todaySuggestion!.description,
                        style: const TextStyle(fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            if (todayRecord != null) ...[
              const Text(
                '今日睡眠',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _SleepStatCard(
                            icon: Icons.bedtime,
                            label: '入睡',
                            value: todayRecord.bedtime ?? '--:--',
                            color: const Color(0xFF66BB6A),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          _SleepStatCard(
                            icon: Icons.wb_sunny,
                            label: '起床',
                            value: todayRecord.wakeTime ?? '--:--',
                            color: Colors.orange,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          _SleepStatCard(
                            icon: Icons.timer,
                            label: '时长',
                            value: '${todayRecord.duration?.toStringAsFixed(1) ?? '--'}h',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (todayRecord.quality != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getQualityIcon(todayRecord.quality),
                              color: const Color(0xFF66BB6A),
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '睡眠质量: ${_getQualityText(todayRecord.quality)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF66BB6A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (todayRecord.deepSleepRatio != null)
                        Text(
                          '深度睡眠: ${(todayRecord.deepSleepRatio! * 100).toStringAsFixed(0)}%',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => _editRecord(todayRecord),
                        icon: const Icon(Icons.edit),
                        label: const Text('编辑睡眠记录'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (_todayRecords.length > 1) ...[
              const Text(
                '历史记录',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._todayRecords.skip(1).map((record) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
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
                      subtitle: Text('${record.duration?.toStringAsFixed(1) ?? '--'} 小时'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                  )),
              const SizedBox(height: 24),
            ],
            DailyKnowledgeSection(
              category: 'sleep',
              title: l10n.sleepEducation,
            ),
          ],
        ),
        ),
      ),
    );
  }

  String _getQualityText(int? quality) {
    switch (quality) {
      case 5:
        return '非常好';
      case 4:
        return '很好';
      case 3:
        return '一般';
      case 2:
        return '较差';
      case 1:
        return '很差';
      default:
        return '一般';
    }
  }
}

class _SleepStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SleepStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class SleepEditDialog extends StatefulWidget {
  final SleepRecord record;
  final Function(SleepRecord) onSave;

  const SleepEditDialog({
    super.key,
    required this.record,
    required this.onSave,
  });

  @override
  State<SleepEditDialog> createState() => _SleepEditDialogState();
}

class _SleepEditDialogState extends State<SleepEditDialog> {
  late TimeOfDay _bedtime;
  late TimeOfDay _wakeTime;
  int _quality = 3;

  @override
  void initState() {
    super.initState();
    _quality = widget.record.quality ?? 3;
    
    if (widget.record.bedtime != null) {
      final parts = widget.record.bedtime!.split(':');
      _bedtime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 23,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    } else {
      _bedtime = const TimeOfDay(hour: 23, minute: 0);
    }
    
    if (widget.record.wakeTime != null) {
      final parts = widget.record.wakeTime!.split(':');
      _wakeTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 7,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    } else {
      _wakeTime = const TimeOfDay(hour: 7, minute: 0);
    }
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

  double _calculateSleepDuration() {
    int bedtimeMinutes = _bedtime.hour * 60 + _bedtime.minute;
    int wakeTimeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    int durationMinutes = wakeTimeMinutes - bedtimeMinutes;
    if (durationMinutes < 0) {
      durationMinutes += 24 * 60;
    }
    return durationMinutes / 60.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑睡眠记录'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('入睡时间'),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectBedtime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_bedtime.hour.toString().padLeft(2, '0')}:${_bedtime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('起床时间'),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectWakeTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_wakeTime.hour.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('睡眠质量'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                int quality = 5 - index;
                return GestureDetector(
                  onTap: () => setState(() => _quality = quality),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _quality == quality ? const Color(0xFF66BB6A) : Colors.grey[200],
                    ),
                    child: Center(
                      child: Icon(
                        _getQualityIcon(quality),
                        color: _quality == quality ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF66BB6A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '睡眠时长: ${_calculateSleepDuration().toStringAsFixed(1)} 小时',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF66BB6A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedRecord = SleepRecord(
              id: widget.record.id,
              date: widget.record.date,
              bedtime: '${_bedtime.hour.toString().padLeft(2, '0')}:${_bedtime.minute.toString().padLeft(2, '0')}',
              wakeTime: '${_wakeTime.hour.toString().padLeft(2, '0')}:${_wakeTime.minute.toString().padLeft(2, '0')}',
              duration: _calculateSleepDuration(),
              quality: _quality,
              deepSleepRatio: widget.record.deepSleepRatio,
              notes: widget.record.notes,
              createdAt: widget.record.createdAt,
            );
            widget.onSave(updatedRecord);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF66BB6A),
          ),
          child: const Text('保存'),
        ),
      ],
    );
  }

  IconData _getQualityIcon(int quality) {
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
