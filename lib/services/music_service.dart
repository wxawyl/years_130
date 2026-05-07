import 'dart:math';
import '../models/meditation_music.dart';

class MusicService {
  static final List<MeditationMusic> presetMusic = [
    MeditationMusic(
      id: '1',
      title: '森林雨声',
      artist: '自然之声',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      coverUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b',
      duration: 300,
      isPreset: true,
    ),
    MeditationMusic(
      id: '2',
      title: '海浪轻拍',
      artist: '海洋之声',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      coverUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
      duration: 360,
      isPreset: true,
    ),
    MeditationMusic(
      id: '3',
      title: '山间清风',
      artist: '自然之声',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      coverUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
      duration: 240,
      isPreset: true,
    ),
    MeditationMusic(
      id: '4',
      title: '冥想禅音',
      artist: '禅修音乐',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      coverUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      duration: 420,
      isPreset: true,
    ),
    MeditationMusic(
      id: '5',
      title: '星空冥想',
      artist: '宇宙之声',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      coverUrl: 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a',
      duration: 300,
      isPreset: true,
    ),
    MeditationMusic(
      id: '6',
      title: '清晨鸟鸣',
      artist: '自然之声',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      coverUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000',
      duration: 280,
      isPreset: true,
    ),
  ];

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
