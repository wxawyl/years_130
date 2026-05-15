import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/knowledge_service.dart';
import '../models/knowledge_item.dart';

class DailyKnowledgeCard extends StatelessWidget {
  final String category;
  final String title;

  const DailyKnowledgeCard({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(),
                  color: _getCategoryColor(),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            FutureBuilder<KnowledgeItem?>(
              future: _getTodayKnowledge(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('暂无科普内容');
                }

                final knowledge = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      knowledge.content,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.source,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          knowledge.source,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildDayIndicator(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (category) {
      case 'sleep':
        return Icons.bedtime;
      case 'diet':
        return Icons.restaurant;
      case 'exercise':
        return Icons.fitness_center;
      case 'mood':
        return Icons.psychology;
      default:
        return Icons.lightbulb;
    }
  }

  Color _getCategoryColor() {
    switch (category) {
      case 'sleep':
        return const Color(0xFF66BB6A);
      case 'diet':
        return const Color(0xFFFF7043);
      case 'exercise':
        return const Color(0xFF42A5F5);
      case 'mood':
        return const Color(0xFFFFCA28);
      default:
        return const Color(0xFF7E57C2);
    }
  }

  Future<KnowledgeItem?> _getTodayKnowledge() async {
    return KnowledgeService.getTodayKnowledge(category);
  }

  Widget _buildDayIndicator() {
    final dayOfMonth = DateTime.now().day;
    final dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getCategoryColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 14,
            color: _getCategoryColor(),
          ),
          const SizedBox(width: 4),
          Text(
            '今日科普 · 第$dayOfMonth天 · 第$dayOfYear天',
            style: TextStyle(
              fontSize: 12,
              color: _getCategoryColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyKnowledgeSection extends StatelessWidget {
  final String category;
  final String title;

  const DailyKnowledgeSection({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        DailyKnowledgeCard(
          category: category,
          title: '每日健康科普',
        ),
      ],
    );
  }
}