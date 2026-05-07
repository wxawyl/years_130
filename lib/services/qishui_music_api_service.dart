import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meditation_music.dart';

class QishuiMusicApiService {
  static const String _baseUrl = 'https://open-music.bytedance.net/api';
  static const String _apiKey = 'YOUR_QISHUI_MUSIC_API_KEY';

  Future<List<MeditationMusic>> searchMusic(String keyword) async {
    try {
      if (_apiKey == 'YOUR_QISHUI_MUSIC_API_KEY') {
        return _getMockSearchResults(keyword);
      }

      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {'keyword': keyword},
      );
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return _parseSearchResults(response.body);
      } else {
        return _getMockSearchResults(keyword);
      }
    } catch (e) {
      return _getMockSearchResults(keyword);
    }
  }

  List<MeditationMusic> _parseSearchResults(String body) {
    final data = json.decode(body);
    final List results = data['data']['songs'];
    return results.map((item) => MeditationMusic(
      id: item['id'].toString(),
      title: item['title'],
      artist: item['artist'],
      url: item['play_url'],
      coverUrl: item['cover_url'],
      duration: item['duration'],
      isPreset: false,
    )).toList();
  }

  List<MeditationMusic> _getMockSearchResults(String keyword) {
    final mockSongs = [
      MeditationMusic(
        id: 'q1',
        title: '禅意冥想',
        artist: '冥想大师',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        coverUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
        duration: 240,
        isPreset: false,
      ),
      MeditationMusic(
        id: 'q2',
        title: '深度放松',
        artist: '心灵音乐',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        coverUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b',
        duration: 300,
        isPreset: false,
      ),
      MeditationMusic(
        id: 'q3',
        title: '自然之声',
        artist: '环境音乐',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        coverUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
        duration: 360,
        isPreset: false,
      ),
    ];

    return mockSongs.where((song) => 
      song.title.contains(keyword) || song.artist.contains(keyword)
    ).toList();
  }
}
