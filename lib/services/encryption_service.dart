import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const String _encryptionKeyKey = 'encryption_key';
  static const String _ivKey = 'encryption_iv';
  
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Encrypter? _encrypter;
  IV? _iv;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    final existingKey = await _storage.read(key: _encryptionKeyKey);
    final existingIv = await _storage.read(key: _ivKey);
    
    if (existingKey != null && existingIv != null) {
      _encrypter = Encrypter(AES(Key(base64Decode(existingKey))));
      _iv = IV(base64Decode(existingIv));
    } else {
      final key = Key.fromSecureRandom(32);
      final iv = IV.fromSecureRandom(16);
      
      await _storage.write(key: _encryptionKeyKey, value: base64Encode(key.bytes));
      await _storage.write(key: _ivKey, value: base64Encode(iv.bytes));
      
      _encrypter = Encrypter(AES(key));
      _iv = iv;
    }
    
    _initialized = true;
  }

  String encrypt(String plainText) {
    if (!_initialized || _encrypter == null || _iv == null) {
      throw StateError('EncryptionService not initialized');
    }
    return _encrypter!.encrypt(plainText, iv: _iv).base64;
  }

  String decrypt(String encryptedBase64) {
    if (!_initialized || _encrypter == null || _iv == null) {
      throw StateError('EncryptionService not initialized');
    }
    return _encrypter!.decrypt64(encryptedBase64, iv: _iv);
  }

  String encryptJson(Map<String, dynamic> json) {
    return encrypt(jsonEncode(json));
  }

  Map<String, dynamic> decryptJson(String encryptedBase64) {
    return jsonDecode(decrypt(encryptedBase64)) as Map<String, dynamic>;
  }

  Future<void> destroyKeys() async {
    await _storage.delete(key: _encryptionKeyKey);
    await _storage.delete(key: _ivKey);
    _encrypter = null;
    _iv = null;
    _initialized = false;
  }

  String hashData(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }
}
