import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meditation_music.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  static final List<MeditationMusic> presetMusic = [];
  static const String _customMusicKey = 'custom_music_list';

  List<MeditationMusic> _customMusic = [];

  List<MeditationMusic> getAllMusic() {
    return [...presetMusic, ..._customMusic];
  }

  Future<void> loadCustomMusic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final musicJson = prefs.getString(_customMusicKey);
      if (musicJson != null && musicJson.isNotEmpty) {
        final List<dynamic> musicList = json.decode(musicJson);
        _customMusic = musicList.map((m) => MeditationMusic.fromMap(m)).toList();
      }
    } catch (e) {
      print('MusicService: loadCustomMusic error: $e');
    }
  }

  Future<bool> addCustomMusic(MeditationMusic music) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> musicDataList = _customMusic.map((m) => m.toMap()).toList();

      final newMusicData = {
        'id': music.id,
        'title': music.title,
        'artist': music.artist,
        'url': kIsWeb ? '' : music.url,
        'cover_url': music.coverUrl,
        'duration': music.duration,
        'is_preset': music.isPreset ? 1 : 0,
        'is_favorite': music.isFavorite ? 1 : 0,
      };

      musicDataList.add(newMusicData);
      final musicJson = json.encode(musicDataList);
      await prefs.setString(_customMusicKey, musicJson);
      _customMusic.add(music);
      return true;
    } catch (e) {
      print('MusicService: addCustomMusic error: $e');
      return false;
    }
  }

  Future<void> removeCustomMusic(String id) async {
    try {
      _customMusic.removeWhere((m) => m.id == id);
      final prefs = await SharedPreferences.getInstance();
      final musicJson = json.encode(_customMusic.map((m) => m.toMap()).toList());
      await prefs.setString(_customMusicKey, musicJson);
    } catch (e) {
      print('MusicService: removeCustomMusic error: $e');
    }
  }

  Future<void> updateCustomMusic(MeditationMusic updatedMusic) async {
    try {
      int index = _customMusic.indexWhere((m) => m.id == updatedMusic.id);
      if (index != -1) {
        _customMusic[index] = updatedMusic;
        final prefs = await SharedPreferences.getInstance();
        final musicJson = json.encode(_customMusic.map((m) => m.toMap()).toList());
        await prefs.setString(_customMusicKey, musicJson);
      }
    } catch (e) {
      print('MusicService: updateCustomMusic error: $e');
    }
  }

  List<MeditationMusic> getPresetMusic() {
    return presetMusic;
  }

  MeditationMusic getRandomMusic() {
    if (presetMusic.isEmpty) {
      throw Exception('No music available');
    }
    final random = Random();
    return presetMusic[random.nextInt(presetMusic.length)];
  }
}