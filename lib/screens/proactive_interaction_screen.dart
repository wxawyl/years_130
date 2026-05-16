import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/health_anomaly.dart';
import '../models/smart_reminder.dart';
import '../services/anomaly_detection_service.dart';
import '../services/smart_reminder_service.dart';
import '../providers/theme_provider.dart';
import '../widgets/dynamic_background.dart';

class ProactiveInteractionScreen extends StatefulWidget {
  const ProactiveInteractionScreen({super.key});

  @override
  State<ProactiveInteractionScreen> createState() => _ProactiveInteractionScreenState();
}

class _ProactiveInteractionScreenState extends State<ProactiveInteractionScreen> {
  final AnomalyDetectionService _anomalyService = AnomalyDetectionService();
  final SmartReminderService _reminderService = SmartReminderService();

  List<HealthAnomaly> _activeAnomalies = [];
  List<SmartReminder> _activeReminders = [];
  bool _isLoading = false;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final anomalies = await _anomalyService.getActiveAnomalies();
      final reminders = await _reminderService.getActiveReminders();
      setState(() {
        _activeAnomalies = anomalies;
        _activeReminders = reminders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scanForAnomalies() async {
    setState(() => _isScanning = true);
    try {
      final anomalies = await _anomalyService.runDetectionAndSave();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发现 ${anomalies.length} 个潜在问题')),
        );
      }
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('扫描失败: $e')),
        );
      }
    } finally {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _acknowledgeAnomaly(HealthAnomaly anomaly) async {
    try {
      await _anomalyService.acknowledgeAnomaly(anomaly.id!);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已标记为已读')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  Future<void> _resolveAnomaly(HealthAnomaly anomaly) async {
    try {
      await _anomalyService.resolveAnomaly(anomaly.id!);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已标记为已解决')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  Future<void> _dismissReminder(SmartReminder reminder) async {
    try {
      await _reminderService.dismissReminder(reminder.id!);
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  Future<void> _snoozeReminder(SmartReminder reminder, int minutes) async {
    try {
      await _reminderService.snoozeReminder(reminder.id!, minutes);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已推迟 $minutes 分钟')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('主动关怀'),
      ),
      body: DynamicBackground(
        theme: themeProvider.currentTheme,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.health_and_safety, size: 32, color: Colors.red),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '智能监控',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '自动监测健康数据异常',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isScanning ? null : _scanForAnomalies,
                          icon: _isScanning
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.radar),
                          label: Text(_isScanning ? '扫描中...' : '立即扫描'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '健康预警',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_activeAnomalies.isEmpty)
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, size: 48, color: Colors.green[400]),
                        const SizedBox(height: 12),
                        Text(
                          '一切正常',
                          style: TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '没有发现健康异常',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._activeAnomalies.map((anomaly) {
                  final severityColor = anomaly.severity >= 0.7
                      ? Colors.red
                      : anomaly.severity >= 0.5
                          ? Colors.orange
                          : Colors.blue;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: severityColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    anomaly.emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            anomaly.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: severityColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${anomaly.severityDisplay}',
                                            style: TextStyle(
                                              color: severityColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      anomaly.anomalyTypeName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            anomaly.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lightbulb, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    anomaly.suggestions,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: anomaly.isAcknowledged == 1
                                    ? null
                                    : () => _acknowledgeAnomaly(anomaly),
                                icon: const Icon(Icons.check),
                                label: const Text('已知晓'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: anomaly.isResolved == 1
                                    ? null
                                    : () => _resolveAnomaly(anomaly),
                                icon: const Icon(Icons.done),
                                label: const Text('已解决'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              const SizedBox(height: 24),
              const Text(
                '智能提醒',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_activeReminders.isEmpty)
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.notifications_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          '暂无提醒',
                          style: TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '系统会根据时间和行为自动生成提醒',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._activeReminders.map((reminder) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _getReminderColor(reminder.reminderType).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    reminder.emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            reminder.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getPriorityColor(reminder.priority).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            reminder.priorityDisplay,
                                            style: TextStyle(
                                              color: _getPriorityColor(reminder.priority),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      reminder.reminderTypeName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            reminder.content,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _snoozeReminder(reminder, 15),
                                icon: const Icon(Icons.snooze),
                                label: const Text('推迟15分钟'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () => _snoozeReminder(reminder, 60),
                                icon: const Icon(Icons.timer_off),
                                label: const Text('推迟1小时'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _dismissReminder(reminder),
                                  icon: const Icon(Icons.check),
                                  label: const Text('知道了'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getReminderColor(int type) {
    switch (type) {
      case 1:
        return Colors.purple;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      case 4:
        return Colors.blue;
      case 5:
        return Colors.cyan;
      case 6:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
