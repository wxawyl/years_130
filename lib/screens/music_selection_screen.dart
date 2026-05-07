import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/meditation_music.dart';
import '../services/music_service.dart';
import '../services/audio_player_service.dart';
import '../l10n/app_localizations.dart';

class MusicSelectionScreen extends StatefulWidget {
  const MusicSelectionScreen({super.key});

  @override
  State<MusicSelectionScreen> createState() => _MusicSelectionScreenState();
}

class _MusicSelectionScreenState extends State<MusicSelectionScreen> {
  final MusicService _musicService = MusicService();
  final AudioPlayerService _audioPlayer = AudioPlayerService();
  List<MeditationMusic> _musicList = [];
  MeditationMusic? _selectedMusic;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadMusic();
    _initPlayerState();
    _setupAudioListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadMusic() {
    setState(() {
      _musicList = _musicService.getPresetMusic();
    });
  }

  void _initPlayerState() {
    setState(() {
      _selectedMusic = _audioPlayer.currentMusic;
      _isPlaying = _audioPlayer.isPlaying;
      _position = _audioPlayer.position;
      _duration = _audioPlayer.duration;
    });
  }

  void _setupAudioListeners() {
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> _playMusic(MeditationMusic music) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_selectedMusic?.id == music.id && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {});
      return;
    }

    _selectedMusic = music;
    
    try {
      await _audioPlayer.play(music);
      setState(() {});
    } catch (e) {
      print('播放失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.playFailed),
          backgroundColor: Colors.red,
        ),
      );
      _selectedMusic = null;
      setState(() {});
    }
  }

  Future<void> _pauseMusic() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _resumeMusic() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  void _seekMusic(double value) {
    Duration newPosition = Duration(seconds: value.toInt());
    _audioPlayer.seek(newPosition);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.meditationMusic),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_selectedMusic != null) _buildNowPlayingBar(l10n),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _musicList.length,
              itemBuilder: (context, index) {
                final music = _musicList[index];
                final isSelected = _selectedMusic?.id == music.id;
                
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: music.coverUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(music.coverUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey[200],
                      ),
                      child: music.coverUrl.isEmpty
                          ? const Icon(Icons.music_note, size: 24)
                          : null,
                    ),
                    title: Text(music.title),
                    subtitle: Text('${music.artist} · ${music.formattedDuration}'),
                    trailing: IconButton(
                      icon: isSelected && _isPlaying
                          ? const Icon(Icons.pause, color: Colors.orange)
                          : const Icon(Icons.play_arrow, color: Colors.orange),
                      onPressed: () => _playMusic(music),
                    ),
                    onTap: () => _playMusic(music),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingBar(AppLocalizations l10n) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedMusic!.coverUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(_selectedMusic!.coverUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[200],
                  ),
                  child: _selectedMusic!.coverUrl.isEmpty
                      ? const Icon(Icons.music_note, size: 32)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedMusic!.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(_selectedMusic!.artist),
                    ],
                  ),
                ),
                IconButton(
                  icon: _isPlaying
                      ? const Icon(Icons.pause, size: 32, color: Colors.orange)
                      : const Icon(Icons.play_arrow, size: 32, color: Colors.orange),
                  onPressed: _isPlaying ? _pauseMusic : _resumeMusic,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(_formatDuration(_position)),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _duration.inSeconds > 0 
                        ? _position.inSeconds.clamp(0, _duration.inSeconds).toDouble() 
                        : 0.0,
                    max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                    onChanged: _duration.inSeconds > 0 ? _seekMusic : null,
                    activeColor: Colors.orange,
                    inactiveColor: Colors.grey[300],
                  ),
                ),
                Text(_formatDuration(_duration)),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}