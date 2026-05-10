import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../services/community_service.dart';
import '../l10n/app_localizations.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _contentController = TextEditingController();
  String _selectedCategory = 'all';

  final List<String> _categories = [
    'all',
    'sleep',
    'diet',
    'exercise',
    'mood',
  ];

  String _getCategoryName(String category, AppLocalizations l10n) {
    switch (category) {
      case 'all':
        return l10n.all;
      case 'sleep':
        return l10n.sleep;
      case 'diet':
        return l10n.diet;
      case 'exercise':
        return l10n.exercise;
      case 'mood':
        return l10n.mood;
      default:
        return l10n.all;
    }
  }

  Future<void> _submitPost() async {
    if (_contentController.text.isEmpty) return;

    Post post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _contentController.text,
      category: _selectedCategory,
      likes: 0,
      comments: 0,
      createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );

    await CommunityService().addPost(post);
    _contentController.clear();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.postSubmitted)),
    );
  }

  Future<void> _likePost(Post post) async {
    await CommunityService().likePost(post.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.community),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFE3F2FD),
              child: Column(
                children: [
                  Text(
                    l10n.communityWelcome,
                    style: const