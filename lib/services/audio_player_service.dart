import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/meditation_music.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  MeditationMusic? _currentMusic;
  bool _isPlaying = false;
  double _volume = 1.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _lastError;

  bool get isPlaying => _isPlaying;
  MeditationMusic? get currentMusic => _currentMusic;
  double get volume => _volume;
  Duration get duration => _duration;
  Duration get position => _position;
  String? get lastError => _lastError;

  Stream<Duration> get onPositionChanged => _audioPlayer.positionStream;
  Stream<Duration?> get onDurationChanged => _audioPlayer.durationStream;
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.playerStateStream;

  Future<void> play(MeditationMusic music) async {
    _currentMusic = music;
    _lastError = null;
    
    try {
      print('=== 音频播放调试 ===');
      print('平台: ${kIsWeb ? "Web" : "Mobile"}');
      print('音乐标题: ${music.title}');
      print('音频URL: ${music.url}');
      
      await _audioPlayer.setVolume(_volume);
      
      print('准备播放...');
      await _audioPlayer.setUrl(music.url);
      await _audioPlayer.play();
      print('播放命令已发送');
      
      _isPlaying = true;
    
      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          _duration = duration;
          print('音频时长: $duration');
        }
      });
      
      _audioPlayer.positionStream.listen((position) {
        _position = position;
      });
      
      _audioPlayer.playerStateStream.listen((state) {
        print('播放状态变化: ${state.processingState}');
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          print('播放完成');
        } else if (state.processingState == ProcessingState.ready && state.playing) {
          _isPlaying = true;
        } else if (state.processingState == ProcessingState.loading || 
                   state.processingState == ProcessingState.buffering) {
          _isPlaying = true;
        } else if (state.processingState == ProcessingState.idle) {
          _isPlaying = false;
        }
      });
      
    } catch (e) {
      _isPlaying = false;
      _lastError = '播放失败: $e';
      print('播放异常: $e');
      print('异常类型: ${e.runtimeType}');
      rethrow;
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
      print('已暂停');
    } catch (e) {
      print('暂停异常: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.play();
      _isPlaying = true;
      print('已恢复播放');
    } catch (e) {
      print('恢复异常: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _position = Duration.zero;
      print('已停止');
    } catch (e) {
      print('停止异常: $e');
    }
  }

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _audioPlayer.setVolume(_volume);
    print('音量设置为: $_volume');
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _position = position;
      print('已跳转到: $position');
    } catch (e) {
      print('跳转异常: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    print('音频播放器已释放');
  }
}