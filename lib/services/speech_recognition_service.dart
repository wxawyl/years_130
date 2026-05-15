import 'dart:async';

class SpeechRecognitionService {
  bool _isListening = false;
  final StreamController<String> _textStreamController =
      StreamController<String>.broadcast();
  final StreamController<bool> _statusStreamController =
      StreamController<bool>.broadcast();
  final StreamController<String> _errorStreamController =
      StreamController<String>.broadcast();

  Stream<String> get onTextChanged => _textStreamController.stream;
  Stream<bool> get onStatusChanged => _statusStreamController.stream;
  Stream<String> get onError => _errorStreamController.stream;
  bool get isListening => _isListening;

  SpeechRecognitionService();

  Future<void> startListening() async {
    _isListening = true;
    _statusStreamController.add(true);
    _errorStreamController.add('语音识别功能暂不可用，请使用文本输入');
    _stopListening();
  }

  Future<void> stopListening() async {
    _stopListening();
  }

  void _stopListening() {
    _isListening = false;
    _statusStreamController.add(false);
  }

  void dispose() {
    _textStreamController.close();
    _statusStreamController.close();
    _errorStreamController.close();
  }
}