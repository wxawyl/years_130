import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/share_service.dart';
import '../models/share_post.dart';
import '../l10n/app_localizations.dart';

class ShareCommunityScreen extends StatefulWidget {
  const ShareCommunityScreen({super.key});

  @override
  State<ShareCommunityScreen> createState() => _ShareCommunityScreenState();
}

class _ShareCommunityScreenState extends State<ShareCommunityScreen> {
  List<SharePost> _posts = [];
  bool _isLoading = true;
  String _selectedFilter = 'hot';

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(milliseconds: 500));
    
    _posts = [
      SharePost(
        id: 1,
        userId: 'user1',
        content: '坚持每天早起运动已经30天了！感觉精力比以前充沛多了，睡眠质量也明显改善。给大家一个建议：刚开始运动不要追求强度，循序渐进最重要！💪',
        type: 'insight',
        likes: 128,
        favorites: 45,
        createdAt: '2026-05-10 08:30:00',
        language: 'zh',
        isVerified: true,
      ),
      SharePost(
        id: 2,
        userId: 'user2',
        content: '分享一个简单有效的冥想方法：每天睡前花10分钟进行深呼吸冥想，专注于呼吸，让思绪自然流淌。坚持一周就能感受到内心的平静。🧘‍♀️',
        type: 'insight',
        likes: 96,
        favorites: 32,
        createdAt: '2026-05-10 20:15:00',
        language: 'zh',
      ),
      SharePost(
        id: 3,
        userId: 'user3',
        content: '最近尝试了间歇性禁食，感觉效果不错！午餐吃得更健康了，身体也更轻盈。建议大家可以从16:8开始尝试。🥗',
        type: 'insight',
        likes: 74,
        favorites: 28,
        createdAt: '2026-05-09 12:00:00',
        language: 'zh',
      ),
      SharePost(
        id: 4,
        userId: 'user4',
        content: 'The key to longevity is simple: eat well, move often, sleep enough, and stay positive. Small daily habits make a big difference over time. 🌟',
        type: 'insight',
        likes: 156,
        favorites: 54,
        createdAt: '2026-05-09 09:00:00',
        language: 'en',
        isVerified: true,
      ),
      SharePost(
        id: 5,
        userId: 'user5',
        content: '分享我的健康早餐配方：燕麦片+蓝莓+核桃+希腊酸奶。营养均衡，能量满满开启新的一天！🥣',
        type: 'insight',
        likes: 68,
        favorites: 22,
        createdAt: '2026-05-08 07:30:00',
        language: 'zh',
      ),
    ];

    setState(() => _isLoading = false);
  }

  void _toggleLike(SharePost post) {
    setState(() {
      post.addLike();
    });
  }

  void _toggleFavorite(SharePost post) {
    setState(() {
      post.addFavorite();
    });
  }

  void _openPostDetail(SharePost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PostDetailBottomSheet(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.community),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterBar(l10n),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      return _buildPostCard(_posts[index]);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: _buildCreatePostButton(l10n),
    );
  }

  Widget _buildFilterBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterTab(l10n.hot, 'hot'),
          const SizedBox(width: 8),
          _buildFilterTab(l10n.newest, 'new'),
          const SizedBox(width: 8),
          _buildFilterTab(l10n.following, 'following'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, String filter) {
    bool isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7E57C2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(SharePost post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(post),
            const SizedBox(height: 12),
            _buildPostContent(post),
            const SizedBox(height: 12),
            _buildPostActions(post),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(SharePost post) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF7E57C2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'User ${post.userId.replaceAll('user', '')}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (post.isVerified)
                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                ],
              ),
              Text(
                _formatDate(post.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildPostContent(SharePost post) {
    return InkWell(
      onTap: () => _openPostDetail(post),
      child: Text(
        post.content,
        style: const TextStyle(fontSize: 15, height: 1.5),
      ),
    );
  }

  Widget _buildPostActions(SharePost post) {
    return Row(
      children: [
        _buildActionButton(
          Icons.thumb_up,
          post.likes.toString(),
          () => _toggleLike(post),
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          Icons.bookmark_border,
          post.favorites.toString(),
          () => _toggleFavorite(post),
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          Icons.comment,
          '0',
          () => _openPostDetail(post),
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          Icons.share,
          '',
          () => _sharePost(post),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          if (count.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(count, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ),
        ],
      ),
    );
  }

  Widget _buildCreatePostButton(AppLocalizations l10n) {
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
        onPressed: () => _showCreatePostDialog(l10n),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _showCreatePostDialog(AppLocalizations l10n) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shareYourInsight),
        content: TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(hintText: l10n.whatDoYouThink),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                SharePost newPost = SharePost(
                  userId: 'current_user',
                  content: controller.text,
                  type: 'insight',
                  createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                  language: 'zh',
                );
                setState(() => _posts.insert(0, newPost));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.postShared)),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7E57C2)),
            child: Text(l10n.share),
          ),
        ],
      ),
    );
  }

  void _sharePost(SharePost post) {
    String content = ShareService.generateInsightShareContent(post.content);
    showModalBottomSheet(
      context: context,
      builder: (context) => ShareBottomSheet(content: content),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      Duration diff = now.difference(date);

      if (diff.inMinutes < 60) {
        return '${diff.inMinutes} ${AppLocalizations.of(context)!.minutesAgo}';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} ${AppLocalizations.of(context)!.hoursAgo}';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} ${AppLocalizations.of(context)!.daysAgo}';
      } else {
        return DateFormat('MM-dd').format(date);
      }
    } catch (_) {
      return dateString;
    }
  }
}

class PostDetailBottomSheet extends StatefulWidget {
  final SharePost post;

  const PostDetailBottomSheet({super.key, required this.post});

  @override
  State<PostDetailBottomSheet> createState() => _PostDetailBottomSheetState();
}

class _PostDetailBottomSheetState extends State<PostDetailBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  void _submitComment() {
    if (_commentController.text.isNotEmpty) {
      widget.post.addComment(Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        content: _commentController.text,
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      ));
      _commentController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPostHeader(),
          const SizedBox(height: 16),
          Text(widget.post.content),
          const SizedBox(height: 16),
          _buildActions(),
          const SizedBox(height: 16),
          if (widget.post.comments.isNotEmpty) _buildComments(),
          const SizedBox(height: 16),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF7E57C2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(child: Icon(Icons.person, color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (widget.post.isVerified)
                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                ],
              ),
              Text(_formatDate(widget.post.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _buildActionButton(Icons.thumb_up, widget.post.likes.toString()),
        const SizedBox(width: 24),
        _buildActionButton(Icons.bookmark_border, widget.post.favorites.toString()),
        const SizedBox(width: 24),
        _buildActionButton(Icons.comment, widget.post.comments.length.toString()),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        Text(count, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildComments() {
    return Column(
      children: widget.post.comments.map((comment) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Icon(Icons.person, color: Colors.grey, size: 16)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(comment.content),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.writeComment,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onSubmitted: (_) => _submitComment(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send, color: Color(0xFF7E57C2)),
          onPressed: _submitComment,
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MM-dd HH:mm').format(date);
    } catch (_) {
      return dateString;
    }
  }
}