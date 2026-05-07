import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageStorageService {
  static const String _imageFolder = 'food_images';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory(path.join(directory.path, _imageFolder));
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir.path;
  }

  Future<String> saveImage(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw Exception('源图片文件不存在');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(sourcePath);
    final fileName = 'food_$timestamp$extension';
    final localPath = await _localPath;
    final targetPath = path.join(localPath, fileName);

    await sourceFile.copy(targetPath);
    return targetPath;
  }

  Future<String> saveImageFromBytes(
      List<int> bytes, String extension) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'food_$timestamp$extension';
    final localPath = await _localPath;
    final targetPath = path.join(localPath, fileName);

    final file = File(targetPath);
    await file.writeAsBytes(bytes);
    return targetPath;
  }

  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> imageExists(String imagePath) async {
    return await File(imagePath).exists();
  }

  Future<List<String>> getAllImages() async {
    final localPath = await _localPath;
    final imageDir = Directory(localPath);
    if (!await imageDir.exists()) {
      return [];
    }

    final files = await imageDir.list().toList();
    return files
        .whereType<File>()
        .map((file) => file.path)
        .where((p) => p.endsWith('.jpg') || p.endsWith('.png'))
        .toList();
  }

  Future<void> clearAllImages() async {
    final localPath = await _localPath;
    final imageDir = Directory(localPath);
    if (await imageDir.exists()) {
      await imageDir.delete(recursive: true);
      await imageDir.create();
    }
  }

  String getImageFileName(String imagePath) {
    return path.basename(imagePath);
  }

  Future<int> getStorageSize() async {
    final localPath = await _localPath;
    final imageDir = Directory(localPath);
    if (!await imageDir.exists()) {
      return 0;
    }

    int totalSize = 0;
    await for (final entity in imageDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }

  String formatStorageSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
