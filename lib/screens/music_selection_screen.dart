import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
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

  Future<void> _loadMusic() async {
    await _musicService.loadCustomMusic();
    setState(() {
      _musicList = _musicService.getAllMusic();
    });
  }

  Future<void> _uploadMusic() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        String fileName = file.name.replaceAll(RegExp(r'\.[^/.]+$'), '');

        String audioUrl;
        if (file.bytes != null) {
          final base64Data = base64Encode(file.bytes!);
          audioUrl = 'data:audio/mp3;base64,$base64Data';
        } else if (file.path != null) {
          audioUrl = file.path!;
        } else {
          audioUrl = file.name;
        }

        MeditationMusic newMusic = MeditationMusic(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: fileName,
          artist: '自定义',
          url: audioUrl,
          coverUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
          duration: 0,
          isPreset: false,
        );

        bool success = await _musicService.addCustomMusic(newMusic);
        if (success) {
          await _loadMusic();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.musicUploaded)),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.uploadFailed)),
            );
          }
        }
      }
    } catch (e) {
      print('上传失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.uploadFailed)),
        );
      }
    }
  }

  void _showMusicOptions(MeditationMusic music) {
    final l10n = AppLocalizations.of(context)!;

    if (music.isPreset) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.editMusic),
            onTap: () {
              Navigator.pop(context);
              _editMusic(music);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('删除'),
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _deleteMusic(music);
            },
          ),
        ],
      ),
    );
  }

  void _editMusic(MeditationMusic music) {
    final l10n = AppLocalizations.of(context)!;
    TextEditingController titleController = TextEditingController(text: music.title);
    TextEditingController artistController = TextEditingController(text: music.artist);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editMusic),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: l10n.title),
            ),
            TextField(
              controller: artistController,
              decoration: InputDecoration(labelText: l10n.artist),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              music.title = titleController.text;
              music.artist = artistController.text;
              await _musicService.updateCustomMusic(music);
              _loadMusic();
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _deleteMusic(MeditationMusic music) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除音乐'),
        content: Text(l10n.deleteMusicConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await _musicService.removeCustomMusic(music.id);
              _loadMusic();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.musicDeleted)),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _initPlayerState() async {
    _isPlaying = _audioPlayer.isPlaying;
    _selectedMusic = _audioPlayer.currentMusic;
    _position = _audioPlayer.position;
    _duration = _audioPlayer.duration;
  }

  void _setupAudioListeners() {
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (duration != null) {
        setState(() => _duration = duration);
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state.processingState == ProcessingState.ready && state.playing;
        if (state.processingState == ProcessingState.completed) {
          _selectedMusic = null;
        }
      });
    });
  }

  Future<void> _togglePlay(MeditationMusic music) async {
    final l10n = AppLocalizations.of(context)!;

    if (music.url.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请重新选择音频文件')),
        );
      }
      return;
    }

    try {
      if (_isPlaying && _selectedMusic?.id == music.id) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(music);
        setState(() => _selectedMusic = music);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.playFailed)),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${hours != '00' ? '$hours:' : ''}$minutes:$seconds';
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _musicList.length,
              itemBuilder: (context, index) {
                final music = _musicList[index];
                final isSelected = _selectedMusic?.id == music.id;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF7E57C2) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isSelected
                          ? const Icon(Icons.music_note, color: Colors.white)
                          : const Icon(Icons.music_note_outlined),
                    ),
                    title: Text(music.title),
                    subtitle: Text(music.artist),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!music.isPreset)
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => _showMusicOptions(music),
                          ),
                        IconButton(
                          icon: Icon(
                            isSelected && _isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: isSelected ? const Color(0xFF7E57C2) : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () => _togglePlay(music),
                        ),
                      ],
                    ),
                    onTap: () => _togglePlay(music),
                  ),
                );
              },
            ),
          ),
          if (_selectedMusic != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedMusic!.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_selectedMusic!.artist),
                          ],
                        ),
                      ),
                      Text(_formatDuration(_position)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) => _audioPlayer.seek(Duration(seconds: value.toInt())),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position)),
                      Text(_formatDuration(_duration)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadMusic,
        backgroundColor: const Color(0xFF7E57C2),
        child: const Icon(Icons.add),
      ),
    );
  }
}