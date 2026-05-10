class Feedback {
  int? id;
  String type;
  String content;
  String? contact;
  String createdAt;

  Feedback({
    this.id,
    required this.type,
    required this.content,
    this.contact,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'contact': contact,
      'created_at': createdAt,
    };
  }

  static Feedback fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'] as int?,
      type: map['type'] as String,
      content: map['content'] as String,
      contact: map['contact'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}