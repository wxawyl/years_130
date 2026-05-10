import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class ImageStorageService {
  static const String _imageFolder = 'food_images';
  static Map<String, Uint8List> _webImageCache = {};

  Future<String> get _localPath async {
    return 'images';
  }

  Future<String> saveImage(String sourcePath) async {
    if (kIsWeb) {
      throw Exception('Web 端不支持文件路径操作');
    }
    
    throw Exception('移动端功能');
  }

  Future<String> saveImageFromBytes(List<int> bytes, String extension) async {
    if (kIsWeb) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'food_$timestamp$extension';
      _webImageCache[fileName] = Uint8List.fromList(bytes);
      return fileName;
    }
    throw Exception('移动端功能');
  }

  Future<void> deleteImage(String imagePath) async {
    if (kIsWeb) {
      final fileName = path.basename(imagePath);
      _webImageCache.remove(fileName);
      return;
    }
  }

  Future<bool> imageExists(String imagePath) async {
    if (kIsWeb) {
      final fileName = path.basename(imagePath);
      return _webImageCache.containsKey(fileName);
    }
    return false;
  }

  Future<Uint8List?> getImageBytes(String imagePath) async {
    if (kIsWeb) {
      final fileName = path.basename(imagePath);
      return _webImageCache[fileName];
    }
    return null;
  }

  Future<List<String>> getAllImages() async {
    if (kIsWeb) {
      return _webImageCache.keys.toList();
    }
    return [];
  }

  Future<void> clearAllImages() async {
    if (kIsWeb) {
      _webImageCache.clear();
      return;
    }
  }

  String getImageFileName(String imagePath) {
    return path.basename(imagePath);
  }

  Future<int> getStorageSize() async {
    if (kIsWeb) {
      int total = 0;
      _webImageCache.values.forEach((bytes) => total += bytes.length);
      return total;
    }
    return 0;
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