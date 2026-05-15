import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/score_service.dart';
import '../services/locale_service.dart';
import '../services/share_service.dart';
import '../services/insight_discovery_service.dart';
import '../services/daily_schedule_service.dart';
import '../models/daily_score.dart';
import '../models/ai_insight.dart';
import '../models/daily_schedule.dart';
import '../widgets/score_card.dart';
import '../widgets/quick_action_button.dart';
import '../l10n/app_localizations.dart';
import 'sleep_screen.dart';
import 'diet_screen.dart';
import 'exercise_screen.dart';
import 'mood_screen.dart';
import 'feedback_screen.dart';
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<DailyScore?> _dailyScoreFuture = ScoreService().getTodayScore();
  final InsightDiscoveryService _insightService = InsightDiscoveryService();
  final DailyScheduleService _scheduleService = DailyScheduleService();
  List<AiInsight> _insights = [];
  List<DailySchedule> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final insights = await _insightService.getInsights(forceDemo: true);
      final schedules = await _scheduleService.getTodaySchedules(forceDemo: true);
      setState(() {
        _insights = insights;
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _getScoreMessage(double score, AppLocalizations l10n) {
    if (score >= 80) return l10n.veryGood;
    if (score >= 60) return l10n.good;
    if (score >= 40) return l10n.needsWork;
    return l10n.takeCare;
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF66BB6A);
    if (score >= 60) return const Color(0xFFFFCA28);
    if (score >= 40) return const Color(0xFFFF7043);
    return const Color(0xFFEF5350);
  }

  void _showLanguageSelector(BuildContext context) {
    final localeService = Provider.of<LocaleService>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleService.supportedLocales.map((locale) {
            return ListTile(
              title: Text(LocaleService.getLanguageName(locale.languageCode)),
              trailing: localeService.locale == locale
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                localeService.setLocale(locale);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showScheduleDialog(DailySchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(schedule.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(schedule.content),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(_getPriorityIcon(schedule.priority), color: _getPriorityColor(schedule.priority)),
                const SizedBox(width: 8),
                Text(_getPriorityLabel(schedule.priority)),
              ],
            ),
            if (schedule.scheduleTime != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text('时间: ${schedule.scheduleTime}'),
                ],
              ),
            ],
          ],
        ),
        actions: [
          if (schedule.actionRequired) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  schedule.isDismissed = true;
                });
              },
              child: const Text('稍后'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  schedule.isCompleted = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已完成！继续保持！')),
                );
              },
              child: const Text('接受'),
            ),
          ] else ...[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.priority_high;
      default:
        return Icons.low_priority;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'high':
        return '高优先级';
      case 'medium':
        return '中优先级';
      default:
        return '低优先级';
    }
  }

  Color _getInsightIconColor(String type) {
    switch (type) {
      case 'correlation':
        return Colors.purple;
      case 'pattern':
        return Colors.blue;
      case 'positive':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getInsightTypeLabel(String type) {
    switch (type) {
      case 'correlation':
        return '关联性发现';
      case 'pattern':
        return '行为模式';
      case 'positive':
        return '积极反馈';
      default:
        return '洞察';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageSelector(context),
          ),
          IconButton(
            icon: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            tooltip: '个人信息',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('yyyy年MM月dd日 EEEE').format(DateTime.now()),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            // 简化的今日健康评分
            FutureBuilder<DailyScore?>(
              future: _dailyScoreFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return Text(l10n.loadingFailed);
                }

                DailyScore score = snapshot.data!;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () {
                      String content = ShareService.generateHealthShareContent(score);
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ShareBottomSheet(content: content),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '今日健康评分',
                            style: const TextStyle(fontSize: 16, color: Color(0xFF757575)),
                          ),
                          Text(
                            '${score.totalScore.toStringAsFixed(0)}/100',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(score.totalScore),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // 今日日程 - 合并到一个卡片
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '今日日程',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('刷新'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_schedules.isEmpty)
              const Center(child: Text('暂无日程'))
            else
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _schedules.where((s) => !s.isDismissed).toList().asMap().entries.map((entry) {
                      int index = entry.key;
                      DailySchedule schedule = entry.value;
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => _showScheduleDialog(schedule),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(schedule.priority).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getPriorityIcon(schedule.priority),
                                    color: _getPriorityColor(schedule.priority),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        schedule.title,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        schedule.content,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      if (schedule.scheduleTime != null) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                                            const SizedBox(width: 4),
                                            Text(
                                              schedule.scheduleTime!,
                                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                              ],
                            ),
                          ),
                          if (index < _schedules.where((s) => !s.isDismissed).length - 1)
                            Divider(height: 24, color: Colors.grey[300]),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // 关联性发现 - 合并到一个卡片
            const Text(
              '关联性发现',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_insights.isEmpty)
              const Center(child: Text('继续记录健康数据以发现更多洞察'))
            else
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Builder(
                    builder: (context) {
                      final insight = _insights.first;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _getInsightIconColor(insight.insightType).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Icon(
                                  Icons.lightbulb,
                                  color: _getInsightIconColor(insight.insightType),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getInsightTypeLabel(insight.insightType),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _getInsightIconColor(insight.insightType),
                                      ),
                                    ),
                                    Text(
                                      insight.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${(insight.confidence * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            insight.description,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                          if (insight.suggestion != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.tips_and_updates, color: Color(0xFF66BB6A), size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '💡 ${insight.suggestion!}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF66BB6A),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.home),
          BottomNavigationBarItem(icon: const Icon(Icons.bed), label: l10n.sleep),
          BottomNavigationBarItem(icon: const Icon(Icons.food_bank), label: l10n.diet),
          BottomNavigationBarItem(icon: const Icon(Icons.directions_run), label: l10n.exercise),
          BottomNavigationBarItem(icon: const Icon(Icons.sentiment_satisfied), label: l10n.mood),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SleepScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DietScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ExerciseScreen()));
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodScreen()));
              break;
          }
        },
      ),
      floatingActionButton: _buildFeedbackFloatingButton(context, l10n),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFeedbackFloatingButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7E57C2).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FeedbackScreen()),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.lightbulb_outline, size: 28),
        tooltip: l10n.feedback,
      ),
    );
  }
}

class ShareBottomSheet extends StatelessWidget {
  final String content;

  const ShareBottomSheet({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '分享健康数据',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.copy),
                  label: const Text('复制'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.share),
                  label: const Text('分享'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB6A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
