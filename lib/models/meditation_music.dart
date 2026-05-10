class MeditationMusic {
  final String id;
  String title;
  String artist;
  String url;
  final String coverUrl;
  final int duration;
  final bool isPreset;
  final bool isFavorite;

  MeditationMusic({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    this.coverUrl = '',
    this.duration = 0,
    this.isPreset = false,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'url': url,
      'cover_url': coverUrl,
      'duration': duration,
      'is_preset': isPreset ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  static MeditationMusic fromMap(Map<String, dynamic> map) {
    return MeditationMusic(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      url: map['url'] as String,
      coverUrl: map['cover_url'] as String? ?? '',
      duration: map['duration'] as int? ?? 0,
      isPreset: (map['is_preset'] as int?) == 1,
      isFavorite: (map['is_favorite'] as int?) == 1,
    );
  }

  String get formattedDuration {
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
