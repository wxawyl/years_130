import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/health_analysis_service.dart';
import '../l10n/app_localizations.dart';
import '../services/health_analysis_service.dart';
import 'package:intl/intl.dart';

enum AnalysisType {
  sleep,
  exercise,
  diet,
  mood,
  overall,
}

class AnalysisScreen extends StatefulWidget {
  final AnalysisType analysisType;

  const AnalysisScreen({super.key, required this.analysisType});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final _dbService = DatabaseService();
  TimeRange _selectedTimeRange = TimeRange.week;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(widget.analysisType, l10n)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTimeRangeSelector(l10n),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder(
                    future: _performAnalysis(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text(l10n.loadingFailed));
                      }
                      return _buildAnalysisContent(snapshot.data, l10n);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(l10n.timeRange, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: TimeRange.values.map((range) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedTimeRange = range);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedTimeRange == range 
                            ? const Color(0xFF42A5F5) 
                            : Colors.grey[200],
                        foregroundColor: _selectedTimeRange == range 
                            ? Colors.white 
                            : Colors.black,
                      ),
                      child: Text(range.label),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _performAnalysis() async {
    setState(() => _isLoading = true);
    
    DateTime startDate = _selectedTimeRange.startDate;
    String startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
    
    switch (widget.analysisType) {
      case AnalysisType.sleep:
        final records = await _dbService.getSleepRecordsByDateRange(startDateStr);
        return await HealthAnalysisService.analyzeSleep(records);
      case AnalysisType.exercise:
        final records = await _dbService.getExerciseRecordsByDateRange(startDateStr);
        return await HealthAnalysisService.analyzeExercise(records);
      case AnalysisType.diet:
        final records = await _dbService.getDietRecordsByDateRange(startDateStr);
        return await HealthAnalysisService.analyzeDiet(records);
      case AnalysisType.mood:
        final records = await _dbService.getMoodRecordsByDateRange(startDateStr);
        return await HealthAnalysisService.analyzeMood(records);
      case AnalysisType.overall:
        return await _analyzeOverall(startDateStr);
    }
  }

  Future<OverallAnalysisResult> _analyzeOverall(String startDateStr) async {
    final sleepRecords = await _dbService.getSleepRecordsByDateRange(startDateStr);
    final exerciseRecords = await _dbService.getExerciseRecordsByDateRange(startDateStr);
    final dietRecords = await _dbService.getDietRecordsByDateRange(startDateStr);
    final moodRecords = await _dbService.getMoodRecordsByDateRange(startDateStr);

    final sleepResult = await HealthAnalysisService.analyzeSleep(sleepRecords);
    final exerciseResult = await HealthAnalysisService.analyzeExercise(exerciseRecords);
    final dietResult = await HealthAnalysisService.analyzeDiet(dietRecords);
    final moodResult = await HealthAnalysisService.analyzeMood(moodRecords);

    double sleepScore = sleepRecords.isNotEmpty ? (sleepResult.avgQuality / 5) * 100 : 0;
    double exerciseScore = exerciseRecords.isNotEmpty ? 
        (exerciseResult.totalMinutes >= 150 ? 100 : (exerciseResult.totalMinutes / 150) * 100) : 0;
    double dietScore = dietRecords.isNotEmpty ? 
        (dietResult.avgCalories >= 1500 && dietResult.avgCalories <= 2500 ? 100 : 
            (dietResult.avgCalories < 1500 ? (dietResult.avgCalories / 1500) * 100 : 
                (1 - (dietResult.avgCalories - 2500) / 1000) * 100)) : 0;
    double moodScore = moodRecords.isNotEmpty ? (moodResult.avgMood / 5) * 100 : 0;

    double overallScore = (sleepScore * 0.3 + exerciseScore * 0.25 + dietScore * 0.25 + moodScore * 0.2).clamp(0, 100);

    List<String> recommendations = [];
    recommendations.addAll(sleepResult.recommendations.take(1));
    recommendations.addAll(exerciseResult.recommendations.take(1));
    recommendations.addAll(dietResult.recommendations.take(1));
    recommendations.addAll(moodResult.recommendations.take(1));

    setState(() => _isLoading = false);

    return OverallAnalysisResult(
      overallScore: overallScore,
      sleepScore: sleepScore,
      exerciseScore: exerciseScore,
      dietScore: dietScore,
      moodScore: moodScore,
      recommendations: recommendations,
      totalSleepRecords: sleepRecords.length,
      totalExerciseRecords: exerciseRecords.length,
      totalDietRecords: dietRecords.length,
      totalMoodRecords: moodRecords.length,
    );
  }

  Widget _buildAnalysisContent(dynamic result, AppLocalizations l10n) {
    if (result == null) {
      return Center(child: Text(l10n.noData));
    }

    switch (widget.analysisType) {
      case AnalysisType.sleep:
        return _buildSleepAnalysis(result as SleepAnalysisResult, l10n);
      case AnalysisType.exercise:
        return _buildExerciseAnalysis(result as ExerciseAnalysisResult, l10n);
      case AnalysisType.diet:
        return _buildDietAnalysis(result as DietAnalysisResult, l10n);
      case AnalysisType.mood:
        return _buildMoodAnalysis(result as MoodAnalysisResult, l10n);
      case AnalysisType.overall:
        return _buildOverallAnalysis(result as OverallAnalysisResult, l10n);
    }
  }

  Widget _buildSleepAnalysis(SleepAnalysisResult result, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMetricCard(
            l10n.avgSleepDuration,
            '${result.avgDuration.toStringAsFixed(1)} ${l10n.hours}',
            const Color(0xFF66BB6A),
          ),
          _buildMetricCard(
            l10n.avgQuality,
            result.avgQuality.toStringAsFixed(1),
            const Color(0xFF42A5F5),
          ),
          _buildMetricCard(
            l10n.consistency,
            '${result.consistency}%',
            const Color(0xFFFFCA28),
          ),
          _buildRecommendations(result.recommendations, l10n),
        ],
      ),
    );
  }

  Widget _buildExerciseAnalysis(ExerciseAnalysisResult result, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMetricCard(
            l10n.totalMinutes,
            '${result.totalMinutes} ${l10n.minutes}',
            const Color(0xFF42A5F5),
          ),
          _buildMetricCard(
            l10n.totalCalories,
            '${result.totalCalories.toStringAsFixed(0)} kcal',
            Colors.orange,
          ),
          _buildMetricCard(
            l10n.avgIntensity,
            result.avgIntensity.toStringAsFixed(1),
            const Color(0xFF7E57C2),
          ),
          _buildMetricCard(
            l10n.frequency,
            '${result.frequency} ${l10n.days}',
            const Color(0xFF26C6DA),
          ),
          if (result.exerciseTypeDistribution.isNotEmpty)
            _buildDistributionCard(result.exerciseTypeDistribution, l10n),
          _buildRecommendations(result.recommendations, l10n),
        ],
      ),
    );
  }

  Widget _buildDietAnalysis(DietAnalysisResult result, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMetricCard(
            l10n.avgCalories,
            '${result.avgCalories.toStringAsFixed(0)} kcal',
            Colors.orange,
          ),
          _buildMetricCard(
            l10n.avgProtein,
            '${result.avgProtein.toStringAsFixed(1)}g',
            const Color(0xFF66BB6A),
          ),
          _buildMetricCard(
            l10n.avgCarbs,
            '${result.avgCarbs.toStringAsFixed(1)}g',
            const Color(0xFF42A5F5),
          ),
          _buildMetricCard(
            l10n.avgFat,
            '${result.avgFat.toStringAsFixed(1)}g',
            const Color(0xFFFF7043),
          ),
          if (result.mealDistribution.isNotEmpty)
            _buildDistributionCard(result.mealDistribution, l10n),
          _buildRecommendations(result.recommendations, l10n),
        ],
      ),
    );
  }

  Widget _buildMoodAnalysis(MoodAnalysisResult result, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMetricCard(
            l10n.avgMood,
            result.avgMood.toStringAsFixed(1),
            const Color(0xFFFFCA28),
          ),
          _buildMetricCard(
            l10n.stability,
            '${result.stability}%',
            const Color(0xFF7E57C2),
          ),
          _buildMetricCard(
            l10n.positiveDays,
            '${result.positiveDays} ${l10n.days}',
            const Color(0xFF66BB6A),
          ),
          _buildRecommendations(result.recommendations, l10n),
        ],
      ),
    );
  }

  Widget _buildOverallAnalysis(OverallAnalysisResult result, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    l10n.overallHealthScore,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF757575)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getScoreColor(result.overallScore).withOpacity(0.1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            result.overallScore.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(result.overallScore),
                            ),
                          ),
                          const Text('/100', style: TextStyle(fontSize: 18, color: Color(0xFF9E9E9E))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getScoreMessage(result.overallScore, l10n),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _getScoreColor(result.overallScore),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildSmallMetricCard(l10n.sleep, result.sleepScore.toStringAsFixed(0), const Color(0xFF66BB6A)),
              _buildSmallMetricCard(l10n.exercise, result.exerciseScore.toStringAsFixed(0), const Color(0xFF42A5F5)),
              _buildSmallMetricCard(l10n.diet, result.dietScore.toStringAsFixed(0), const Color(0xFFFF7043)),
              _buildSmallMetricCard(l10n.mood, result.moodScore.toStringAsFixed(0), const Color(0xFFFFCA28)),
            ],
          ),
          const SizedBox(height: 20),
          _buildRecommendations(result.recommendations, l10n),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(Icons.bar_chart, color: color)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallMetricCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionCard(Map<String, int> distribution, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.distribution, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: distribution.entries.map((entry) {
                return Row(
                  children: [
                    Text(entry.key, style: const TextStyle(fontSize: 14)),
                    const Spacer(),
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: entry.value / distribution.values.reduce((a, b) => a + b),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF42A5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(entry.value.toString()),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(List<String> recommendations, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.personalizedAdvice, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: recommendations.map((rec) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(rec)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF66BB6A);
    if (score >= 60) return const Color(0xFFFFCA28);
    if (score >= 40) return const Color(0xFFFF7043);
    return const Color(0xFFEF5350);
  }

  String _getScoreMessage(double score, AppLocalizations l10n) {
    if (score >= 80) return l10n.veryGood;
    if (score >= 60) return l10n.good;
    if (score >= 40) return l10n.needsWork;
    return l10n.takeCare;
  }

  String _getTitle(AnalysisType type, AppLocalizations l10n) {
    switch (type) {
      case AnalysisType.sleep:
        return '${l10n.sleep} ${l10n.analysis}';
      case AnalysisType.exercise:
        return '${l10n.exercise} ${l10n.analysis}';
      case AnalysisType.diet:
        return '${l10n.diet} ${l10n.analysis}';
      case AnalysisType.mood:
        return '${l10n.mood} ${l10n.analysis}';
      case AnalysisType.overall:
        return l10n.overallAnalysis;
    }
  }
}

class OverallAnalysisResult {
  final double overallScore;
  final double sleepScore;
  final double exerciseScore;
  final double dietScore;
  final double moodScore;
  final List<String> recommendations;
  final int totalSleepRecords;
  final int totalExerciseRecords;
  final int totalDietRecords;
  final int totalMoodRecords;

  OverallAnalysisResult({
    required this.overallScore,
    required this.sleepScore,
    required this.exerciseScore,
    required this.dietScore,
    required this.moodScore,
    required this.recommendations,
    required this.totalSleepRecords,
    required this.totalExerciseRecords,
    required this.totalDietRecords,
    required this.totalMoodRecords,
  });
}