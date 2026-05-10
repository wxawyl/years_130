class SharePost {
  int? id;
  String userId;
  String content;
  String? imageUrl;
  String type;
  int likes;
  int favorites;
  List<Comment> comments;
  String createdAt;
  String language;
  String? region;
  bool isVerified;

  SharePost({
    this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.type,
    this.likes = 0,
    this.favorites = 0,
    this.comments = const [],
    required this.createdAt,
    this.language = 'zh',
    this.region,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'image_url': imageUrl,
      'type': type,
      'likes': likes,
      'favorites': favorites,
      'created_at': createdAt,
      'language': language,
      'region': region,
      'is_verified': isVerified ? 1 : 0,
    };
  }

  static SharePost fromMap(Map<String, dynamic> map) {
    return SharePost(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String?,
      type: map['type'] as String,
      likes: map['likes'] as int? ?? 0,
      favorites: map['favorites'] as int? ?? 0,
      comments: [],
      createdAt: map['created_at'] as String,
      language: map['language'] as String? ?? 'zh',
      region: map['region'] as String?,
      isVerified: (map['is_verified'] as int? ?? 0) == 1,
    );
  }

  double get engagementScore {
    return likes * 1 + favorites * 2 + comments.length * 3;
  }

  void addLike() {
    likes++;
  }

  void removeLike() {
    if (likes > 0) likes--;
  }

  void addFavorite() {
    favorites++;
  }

  void removeFavorite() {
    if (favorites > 0) favorites--;
  }

  void addComment(Comment comment) {
    comments.add(comment);
  }
}

class Comment {
  String id;
  String userId;
  String content;
  String createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
    };
  }

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}