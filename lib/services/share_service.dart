import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/share_post.dart';
import '../models/daily_score.dart';
import '../services/database_service.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  final DatabaseService _dbService = DatabaseService();

  Future<void> savePost(SharePost post) async {
    final db = await _dbService.database;
    await db.insert(
      'share_posts',
      post.toMap(),
    );
  }

  Future<List<SharePost>> getPosts({
    int limit = 20,
    int offset = 0,
    String? type,
    String? language,
  }) async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> maps;

    String query = '''
      SELECT * FROM share_posts 
      WHERE 1=1
      ${type != null ? 'AND type = ?' : ''}
      ${language != null ? 'AND language = ?' : ''}
      ORDER BY likes DESC, created_at DESC
      LIMIT ? OFFSET ?
    ''';

    List<dynamic> params = [];
    if (type != null) params.add(type);
    if (language != null) params.add(language);
    params.add(limit);
    params.add(offset);

    maps = await db.rawQuery(query, params);
    return List.generate(maps.length, (i) => SharePost.fromMap(maps[i]));
  }

  Future<void> likePost(int postId) async {
    final db = await _dbService.database;
    await db.rawUpdate(
      'UPDATE share_posts SET likes = likes + 1 WHERE id = ?',
      [postId],
    );
  }

  Future<void> unlikePost(int postId) async {
    final db = await _dbService.database;
    await db.rawUpdate(
      'UPDATE share_posts SET likes = MAX(0, likes - 1) WHERE id = ?',
      [postId],
    );
  }

  Future<void> favoritePost(int postId) async {
    final db = await _dbService.database;
    await db.rawUpdate(
      'UPDATE share_posts SET favorites = favorites + 1 WHERE id = ?',
      [postId],
    );
  }

  Future<void> unfavoritePost(int postId) async {
    final db = await _dbService.database;
    await db.rawUpdate(
      'UPDATE share_posts SET favorites = MAX(0, favorites - 1) WHERE id = ?',
      [postId],
    );
  }

  static String generateHealthShareContent(DailyScore score) {
    String moodText = '';
    if (score.totalScore >= 80) {
      moodText = 'Excellent';
    } else if (score.totalScore >= 60) {
      moodText = 'Good';
    } else if (score.totalScore >= 40) {
      moodText = 'Needs Improvement';
    } else {
      moodText = 'Needs Attention';
    }

    return '''📊 Today's Health Score: ${score.totalScore.toStringAsFixed(0)} ($moodText)

💤 Sleep: ${score.sleepScore.toStringAsFixed(0)}
🥗 Diet: ${score.dietScore.toStringAsFixed(0)}
🏃 Exercise: ${score.exerciseScore.toStringAsFixed(0)}
😊 Mood: ${score.moodScore.toStringAsFixed(0)}

#HealthyLiving #Longevity #LiveTo130''';
  }

  static String generateInsightShareContent(String content) {
    return '''💡 My Health Insight:

$content

#HealthTips #Wellness #LiveTo130''';
  }

  static Future<void> shareText(String content) async {
    await Share.share(content);
  }
}

class SharePlatform {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> regions;

  SharePlatform({
    required this.name,
    required this.icon,
    required this.color,
    required this.regions,
  });

  static final List<SharePlatform> allPlatforms = [
    SharePlatform(
      name: 'WeChat',
      icon: Icons.message,
      color: Colors.green,
      regions: ['CN', 'HK', 'TW', 'SG'],
    ),
    SharePlatform(
      name: 'WeChat Moments',
      icon: Icons.photo_album,
      color: Colors.green[600]!,
      regions: ['CN', 'HK', 'TW', 'SG'],
    ),
    SharePlatform(
      name: 'QQ',
      icon: Icons.chat,
      color: Colors.blue,
      regions: ['CN', 'HK', 'TW'],
    ),
    SharePlatform(
      name: 'Xiaohongshu',
      icon: Icons.book,
      color: const Color(0xFFFF6B6B),
      regions: ['CN'],
    ),
    SharePlatform(
      name: 'Facebook',
      icon: Icons.facebook,
      color: const Color(0xFF1877F2),
      regions: ['US', 'EU', 'Global'],
    ),
    SharePlatform(
      name: 'Instagram',
      icon: Icons.camera_alt,
      color: const Color(0xFFE4405F),
      regions: ['US', 'EU', 'Global'],
    ),
    SharePlatform(
      name: 'Twitter',
      icon: Icons.message_outlined,
      color: const Color(0xFF1DA1F2),
      regions: ['US', 'EU', 'Global'],
    ),
    SharePlatform(
      name: 'Copy Link',
      icon: Icons.link,
      color: Colors.grey,
      regions: ['Global'],
    ),
  ];

  static List<SharePlatform> getPlatformsForRegion(String region) {
    return allPlatforms.where((p) => p.regions.contains(region) || p.regions.contains('Global')).toList();
  }
}

class ShareBottomSheet extends StatelessWidget {
  final String content;
  final String? imageUrl;

  const ShareBottomSheet({super.key, required this.content, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Share to',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            children: SharePlatform.allPlatforms.map((platform) {
              return _buildShareButton(
                context,
                platform.icon,
                platform.name,
                platform.color,
                () => _shareToPlatform(context, platform.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
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
        ],
      ),
    );
  }

  Widget _buildShareButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  void _shareToPlatform(BuildContext context, String platform) async {
    if (platform == 'Copy Link') {
      await Clipboard.setData(ClipboardData(text: content));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content copied to clipboard')),
      );
    } else {
      await ShareService.shareText(content);
    }
    Navigator.pop(context);
  }
}