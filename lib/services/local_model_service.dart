import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:live_to_130/config/ai_config.dart';

class LocalModelService {
  static final LocalModelService _instance = LocalModelService._internal();
  factory LocalModelService() => _instance;
  LocalModelService._internal();

  bool _isInitialized = false;
  Directory? _modelDirectory;
  Map<LocalModelType, ModelStatus> _modelStatus = {};

  Future<void> initialize() async {
    if (_isInitialized) return;

    final appDir = await getApplicationDocumentsDirectory();
    _modelDirectory = Directory('${appDir.path}/models');
    
    if (!await _modelDirectory!.exists()) {
      await _modelDirectory!.create(recursive: true);
    }

    for (var modelType in LocalModelType.values) {
      _modelStatus[modelType] = await _checkModelStatus(modelType);
    }

    _isInitialized = true;
  }

  Future<ModelStatus> _checkModelStatus(LocalModelType modelType) async {
    final modelFile = File('${_modelDirectory!.path}/${modelType.name}.gguf');
    if (await modelFile.exists()) {
      return ModelStatus.downloaded;
    }
    return ModelStatus.notDownloaded;
  }

  ModelStatus getModelStatus(LocalModelType modelType) {
    return _modelStatus[modelType] ?? ModelStatus.notDownloaded;
  }

  Future<void> downloadModel(
    LocalModelType modelType, {
    Function(double)? onProgress,
    Function(String)? onError,
  }) async {
    _modelStatus[modelType] = ModelStatus.downloading;
    
    try {
      final modelFile = File('${_modelDirectory!.path}/${modelType.name}.gguf');
      
      await _simulateDownload(onProgress);
      
      await modelFile.writeAsString('simulated_model_content');
      
      _modelStatus[modelType] = ModelStatus.downloaded;
      onProgress?.call(1.0);
    } catch (e) {
      _modelStatus[modelType] = ModelStatus.error;
      onError?.call(e.toString());
    }
  }

  Future<void> _simulateDownload(Function(double)? onProgress) async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      onProgress?.call(i / 100);
    }
  }

  Future<void> deleteModel(LocalModelType modelType) async {
    final modelFile = File('${_modelDirectory!.path}/${modelType.name}.gguf');
    if (await modelFile.exists()) {
      await modelFile.delete();
      _modelStatus[modelType] = ModelStatus.notDownloaded;
    }
  }

  Future<String> generateText(
    String prompt, {
    LocalModelType modelType = LocalModelType.phi3Mini,
    int maxTokens = 512,
    double temperature = 0.7,
  }) async {
    final status = getModelStatus(modelType);
    if (status != ModelStatus.downloaded) {
      throw ModelNotDownloadedException(modelType);
    }

    return 'This is a placeholder for local model inference. In a real implementation, '
           'this would call the native plugin to run inference on ${modelType.displayName}.';
  }

  Future<double> analyzeSentiment(String text) async {
    final status = getModelStatus(LocalModelType.tinyBert);
    if (status != ModelStatus.downloaded) {
      throw ModelNotDownloadedException(LocalModelType.tinyBert);
    }

    return 0.5;
  }

  List<LocalModelType> getAvailableModels() {
    return LocalModelType.values;
  }

  int getModelSizeMB(LocalModelType modelType) {
    return modelType.approximateSizeMB;
  }
}

enum ModelStatus {
  notDownloaded,
  downloading,
  downloaded,
  error,
}

class ModelNotDownloadedException implements Exception {
  final LocalModelType modelType;

  ModelNotDownloadedException(this.modelType);

  @override
  String toString() {
    return 'Model ${modelType.displayName} is not downloaded';
  }
}
