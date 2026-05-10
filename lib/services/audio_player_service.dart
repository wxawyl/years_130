import 'package:audioplayers/audioplayers.dart';
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

  bool get isPlaying => _isPlaying;
  MeditationMusic? get currentMusic => _currentMusic;
  double get volume => _volume;
  Duration get duration => _duration;
  Duration get position => _position;

  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  Future<void> play(MeditationMusic music) async {
    _currentMusic = music;
    
    try {
      print('=== 音频播放调试 ===');
      print('平台: iOS/Android');
      print('音乐标题: ${music.title}');
      print('音频URL: ${music.url}');
      
      await _audioPlayer.setVolume(_volume);
      
      Source source;
      if (music.url.startsWith('http://') || music.url.startsWith('https://')) {
        source = UrlSource(music.url);
        print('使用网络音频源 (UrlSource)');
      } else if (music.url.startsWith('asset://')) {
        final assetPath = music.url.replaceFirst('asset://', '');
        source = AssetSource(assetPath);
        print('使用资产音频源 (AssetSource): $assetPath');
      } else {
        source = DeviceFileSource(music.url);
        print('使用本地文件源 (DeviceFileSource)');
      }
      
      print('准备播放...');
      await _audioPlayer.play(source);
      print('播放命令已发送');
      
      _isPlaying = true;
      
      _audioPlayer.onDurationChanged.listen((duration) {
        _duration = duration;
        print('音频时长: $duration');
      });
      
      _audioPlayer.onPositionChanged.listen((position) {
        _position = position;
      });
      
      _audioPlayer.onPlayerStateChanged.listen((state) {
        print('播放状态变化: $state');
        if (state == PlayerState.completed) {
          _isPlaying = false;
          print('播放完成');
        } else if (state == PlayerState.playing) {
          _isPlaying = true;
        } else if (state == PlayerState.paused) {
          _isPlaying = false;
        } else if (state == PlayerState.stopped) {
          _isPlaying = false;
          _position = Duration.zero;
        }
      });
      
      _audioPlayer.onPlayerError.listen((error) {
        print('音频错误: $error');
        _isPlaying = false;
      });
      
    } catch (e) {
      _isPlaying = false;
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
      print('暂停失败: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
      _isPlaying = true;
      print('已恢复播放');
    } catch (e) {
      print('恢复播放失败: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _position = Duration.zero;
      print('已停止');
    } catch (e) {
      print('停止失败: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _position = position;
    } catch (e) {
      print('跳转失败: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    try {
      await _audioPlayer.setVolume(_volume);
      print('音量设置为: $_volume');
    } catch (e) {
      print('音量设置失败: $e');
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void dispose() {
    try {
      _audioPlayer.dispose();
      print('音频播放器已释放');
    } catch (e) {
      print('释放播放器失败: $e');
    }
  }
}