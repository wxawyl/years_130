import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meditation_music.dart';

class QQMusicApiService {
  static const String _baseUrl = 'https://c.y.qq.com/soso/fcgi-bin/client_search_cp';
  static const String _appId = 'YOUR_QQ_MUSIC_APP_ID';
  static const String _appKey = 'YOUR_QQ_MUSIC_APP_KEY';

  Future<List<MeditationMusic>> searchMusic(String keyword) async {
    try {
      if (_appId == 'YOUR_QQ_MUSIC_APP_ID') {
        return _getMockSearchResults(keyword);
      }

      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'g_tk': '5381',
          'uin': '0',
          'format': 'json',
          'inCharset': 'utf-8',
          'outCharset': 'utf-8',
          'notice': '0',
          'platform': 'h5',
          'needNewCode': '1',
          'w': keyword,
          'zhidaqu': '1',
          'catZhida': '1',
          't': '0',
          'flag': '1',
          'ie': 'utf-8',
          'sem': '1',
          'aggr': '0',
          'perpage': '10',
          'n': '10',
          'p': '1',
          'remoteplace': 'txt.mqq.all',
        },
      );

      final response = await http.get(uri);

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
    final List results = data['data']['song']['list'];
    return results.map((item) => MeditationMusic(
      id: item['songid'].toString(),
      title: item['songname'],
      artist: item['singer'].first['name'],
      url: 'https://ws.stream.qqmusic.qq.com/${item['songid']}.m4a',
      coverUrl: item['albumid'] != null 
          ? 'https://y.gtimg.cn/music/photo_new/T002R300x300M000${item['albumid']}.jpg'
          : '',
      duration: item['interval'] ?? 0,
      isPreset: false,
    )).toList();
  }

  List<MeditationMusic> _getMockSearchResults(String keyword) {
    final mockSongs = [
      MeditationMusic(
        id: 'qq1',
        title: '禅意冥想',
        artist: '冥想大师',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        coverUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
        duration: 240,
        isPreset: false,
      ),
      MeditationMusic(
        id: 'qq2',
        title: '深度放松',
        artist: '心灵音乐',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        coverUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b',
        duration: 300,
        isPreset: false,
      ),
      MeditationMusic(
        id: 'qq3',
        title: '自然之声',
        artist: '环境音乐',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        coverUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
        duration: 360,
        isPreset: false,
      ),
      MeditationMusic(
        id: 'qq4',
        title: '静心禅乐',
        artist: '禅修音乐',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        coverUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
        duration: 280,
        isPreset: false,
      ),
    ];

    return mockSongs.where((song) => 
      song.title.contains(keyword) || song.artist.contains(keyword)
    ).toList();
  }
}
