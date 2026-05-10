import 'package:flutter/material.dart';
import '../models/ai_health_report.dart';
import '../services/ai_health_service.dart';
import '../services/database_service.dart';

class AIHealthReportScreen extends StatefulWidget {
  const AIHealthReportScreen({super.key});

  @override
  State<AIHealthReportScreen> createState() => _AIHealthReportScreenState();
}

class _AIHealthReportScreenState extends State<AIHealthReportScreen> {
  final DatabaseService _dbService = DatabaseService();
  AIHealthService? _aiService;
  AIHealthReport? _currentReport;
  List<AIHealthReport>? _historicalReports;
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _aiService = AIHealthService(_dbService);
    _selectedDate = _getTodayDateString();
    _loadReport(_selectedDate!);
    _loadHistoricalReports();
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadReport(String date) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final report = await _aiService?.getReportForDate(date);
      setState(() {
        _currentReport = report;
        _selectedDate = date;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载报告失败: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadHistoricalReports() async {
    try {
      final reports = await _aiService?.getHistoricalReports(days: 30);
      setState(() {
        _historicalReports = reports;
      });
    } catch (e) {
      debugPrint('加载历史报告失败: $e');
    }
  }

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
    });
    try {
      final report = await _aiService?.getHealthAnalysis(date: _selectedDate!);
      if (report != null) {
        await _aiService?.saveReport(report);
        setState(() {
          _currentReport = report;
        });
        await _loadHistoricalReports();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('报告生成成功！')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('报告生成失败: $e')),
        );
      }
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final dateString = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      await _loadReport(dateString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 健康报告'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildReportContent(),
    );
  }

  Widget _buildReportContent() {
    if (_currentReport == null) {
      return _buildNoReportView();
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(),
          const SizedBox(height: 24),
          _buildTotalScoreCard(),
          const SizedBox(height: 24),
          _buildScoreBreakdown(),
          const SizedBox(height: 24),
          _buildHealthIssues(),
          const SizedBox(height: 24),
          _buildSuggestions(),
          const SizedBox(height: 24),
          if (_currentReport?.weeklyTrend != null)
            _buildWeeklyTrend(),
          const SizedBox(height: 24),
          if (_historicalReports != null && _historicalReports!.isNotEmpty)
            _buildHistoricalReports(),
        ],
      ),
    );
  }

  Widget _buildNoReportView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '还没有健康报告',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              '点击下方按钮生成今日健康报告',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateReport,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: const Text('生成报告'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedDate!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ElevatedButton.icon(
          onPressed: _isGenerating ? null : _generateReport,
          icon: _isGenerating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
          label: const Text('重新生成'),
        ),
      ],
    );
  }

  Widget _buildTotalScoreCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              '今日健康总分',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: (_currentReport?.totalScore ?? 0) / 100,
                    strokeWidth: 12,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(_currentReport?.totalScore ?? 0),
            ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${_currentReport?.totalScore?.toInt() ?? 0}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '分项评分',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildScoreItem('睡眠', _currentReport?.sleepScore ?? 0, 25),
            const SizedBox(height: 12),
            _buildScoreItem('饮食', _currentReport?.dietScore ?? 0, 25),
            const SizedBox(height: 12),
            _buildScoreItem('运动', _currentReport?.exerciseScore ?? 0, 25),
            const SizedBox(height: 12),
            _buildScoreItem('心态', _currentReport?.moodScore ?? 0, 25),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, double score, double max) {
    final percentage = (score / max).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(score / max * 100),
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '${score.toInt()}',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthIssues() {
    if (_currentReport?.healthIssues == null ||
        _currentReport!.healthIssues!.isEmpty) {
      return const SizedBox.shrink();
    }

    final issues = _currentReport!.healthIssuesList;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_outlined, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  '健康隐患',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: issues.map((issue) {
                return Chip(
                  label: Text(issue),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '健康建议',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_currentReport?.sleepSuggestion != null)
              _buildSuggestionItem('😴 睡眠', _currentReport!.sleepSuggestion!),
            if (_currentReport?.dietSuggestion != null)
              _buildSuggestionItem('🍎 饮食', _currentReport!.dietSuggestion!),
            if (_currentReport?.exerciseSuggestion != null)
              _buildSuggestionItem('🏃 运动', _currentReport!.exerciseSuggestion!),
            if (_currentReport?.moodSuggestion != null)
              _buildSuggestionItem('😊 心态', _currentReport!.moodSuggestion!),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '趋势分析',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(_currentReport!.weeklyTrend!),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalReports() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '历史报告',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _historicalReports!.length,
                itemBuilder: (context, index) {
                  final report = _historicalReports![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => _loadReport(report.date),
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedDate == report.date
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: _selectedDate == report.date
                              ? Border.all(color: Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              report.date.substring(5),
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedDate == report.date
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${report.totalScore?.toInt() ?? 0}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _selectedDate == report.date
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : _getScoreColor(report.totalScore ?? 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
