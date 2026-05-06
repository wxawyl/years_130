class KnowledgeItem {
  int? id;
  int category;
  String title;
  String content;
  String source;
  int isVideo;
  String? url;
  String? createdAt;

  KnowledgeItem({
    this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.source,
    this.isVideo = 0,
    this.url,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'content': content,
      'source': source,
      'is_video': isVideo,
      'url': url,
      'created_at': createdAt,
    };
  }

  static KnowledgeItem fromMap(Map<String, dynamic> map) {
    return KnowledgeItem(
      id: map['id'] as int?,
      category: map['category'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      source: map['source'] as String,
      isVideo: map['is_video'] as int,
      url: map['url'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }

  String get categoryName {
    switch (category) {
      case 1: return '睡眠';
      case 2: return '饮食';
      case 3: return '运动';
      case 4: return '心态';
      default: return '其他';
    }
  }
}