import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/score_service.dart';
import '../models/daily_score.dart';
import '../widgets/score_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/suggestion_card.dart';
import 'sleep_screen.dart';
import 'diet_screen.dart';
import 'exercise_screen.dart';
import 'mood_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('yyyy年MM月dd日 EEEE').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('活到130岁'),
        centerTitle: true,
        actions: [
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
              today,
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
                  return const Text('加载失败，请重试');
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
                              '今日健康评分',
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
                              _getScoreMessage(score.totalScore),
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
                    const Text(
                      '四大维度',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          title: '睡眠',
                          score: score.sleepScore,
                          icon: Icons.bed,
                          color: const Color(0xFF66BB6A),
                        ),
                        ScoreCard(
                          title: '饮食',
                          score: score.dietScore,
                          icon: Icons.food_bank,
                          color: const Color(0xFFFF7043),
                        ),
                        ScoreCard(
                          title: '运动',
                          score: score.exerciseScore,
                          icon: Icons.directions_run,
                          color: const Color(0xFF42A5F5),
                        ),
                        ScoreCard(
                          title: '心态',
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
            const SizedBox(height: 20),
            const Text(
              '快速记录',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  title: '睡眠',
                  icon: Icons.bed,
                  color: const Color(0xFF66BB6A),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SleepScreen()),
                  ),
                ),
                QuickActionButton(
                  title: '饮食',
                  icon: Icons.food_bank,
                  color: const Color(0xFFFF7043),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DietScreen()),
                  ),
                ),
                QuickActionButton(
                  title: '运动',
                  icon: Icons.directions_run,
                  color: const Color(0xFF42A5F5),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExerciseScreen()),
                  ),
                ),
                QuickActionButton(
                  title: '心态',
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.bed), label: '睡眠'),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: '饮食'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: '运动'),
          BottomNavigationBarItem(icon: Icon(Icons.sentiment_satisfied), label: '心态'),
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

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF66BB6A);
    if (score >= 60) return const Color(0xFFFFCA28);
    if (score >= 40) return const Color(0xFFFF7043);
    return const Color(0xFFEF5350);
  }

  String _getScoreMessage(double score) {
    if (score >= 80) return '🎉 非常棒！继续保持健康生活！';
    if (score >= 60) return '👍 不错！还有提升空间';
    if (score >= 40) return '💪 加油！需要更加努力';
    return '😅 今天也要好好照顾自己哦';
  }
}