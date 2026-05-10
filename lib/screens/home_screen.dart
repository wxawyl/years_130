import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/score_service.dart';
import '../services/locale_service.dart';
import '../models/daily_score.dart';
import '../widgets/score_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/suggestion_card.dart';
import '../l10n/app_localizations.dart';
import 'sleep_screen.dart';
import 'diet_screen.dart';
import 'exercise_screen.dart';
import 'mood_screen.dart';
import 'health_profile_screen.dart';
import 'ai_health_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DailyScore?> _dailyScoreFuture;

  @override
  void initState() {
    super.initState();
    _refreshScore();
  }

  void _refreshScore() {
    setState(() {
      _dailyScoreFuture = ScoreService().getTodayScore();
    });
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HealthProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageSelector(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshScore,
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
                List<String> suggestions = score.suggestions != null
                    ? score.suggestions!.split('||').where((s) => s.isNotEmpty).toList()
                    : [];

                return Column(
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              l10n.todayHealthScore,
                              style: const TextStyle(fontSize: 16, color: Color(0xFF757575)),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(26, _getScoreColor(score.totalScore).red, _getScoreColor(score.totalScore).green, _getScoreColor(score.totalScore).blue),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      score.totalScore.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: _getScoreColor(score.totalScore),
                                      ),
                                    ),
                                    Text(
                                      '/100',
                                      style: const TextStyle(fontSize: 18, color: Color(0xFF9E9E9E)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _getScoreMessage(score.totalScore, l10n),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _getScoreColor(score.totalScore),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.fourDimensions,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        ScoreCard(
                          title: l10n.sleep,
                          score: score.sleepScore,
                          icon: Icons.bed,
                          color: const Color(0xFF66BB6A),
                        ),
                        ScoreCard(
                          title: l10n.diet,
                          score: score.dietScore,
                          icon: Icons.food_bank,
                          color: const Color(0xFFFF7043),
                        ),
                        ScoreCard(
                          title: l10n.exercise,
                          score: score.exerciseScore,
                          icon: Icons.directions_run,
                          color: const Color(0xFF42A5F5),
                        ),
                        ScoreCard(
                          title: l10n.mood,
                          score: score.moodScore,
                          icon: Icons.sentiment_satisfied,
                          color: const Color(0xFFFFCA28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SuggestionCard(suggestions: suggestions),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AIHealthReportScreen()),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Color(0xFF2E7D32), size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI 健康报告',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '智能分析你的健康数据',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.quickRecord,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                QuickActionButton(
                  title: l10n.sleep,
                  icon: Icons.bed,
                  color: const Color(0xFF66BB6A),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SleepScreen()),
                  ),
                ),
                QuickActionButton(
                  title: l10n.diet,
                  icon: Icons.food_bank,
                  color: const Color(0xFFFF7043),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DietScreen()),
                  ),
                ),
                QuickActionButton(
                  title: l10n.exercise,
                  icon: Icons.directions_run,
                  color: const Color(0xFF42A5F5),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExerciseScreen()),
                  ),
                ),
                QuickActionButton(
                  title: l10n.mood,
                  icon: Icons.sentiment_satisfied,
                  color: const Color(0xFFFFCA28),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoodScreen()),
                  ),
                ),
              ],
            ),
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
    );
  }
}
