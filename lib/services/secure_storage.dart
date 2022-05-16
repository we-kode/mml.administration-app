import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String appKeyStorageKey = 'appKey';
  static const String clientIdStorageKey = 'clientId';
  static const String serverNameStorageKey = 'serverName';
  static const String accessTokenStorageKey = 'a';
  static const String refreshTokenStorageKey = 'r';

  static final SecureStorageService _instance = SecureStorageService();
  final _storage = const FlutterSecureStorage();

  static SecureStorageService getInstance() {
    return _instance;
  }

  Future<String?> get(String key) async {
    return await _storage.read(key: key);
  }

  Future<bool> has(String key) async {
    return (await get(key)) != null;
  }

  Future<void> set(String key, String? value) async {
    return await _storage.write(key: key, value: value);
  }

  delete(String key) async {
    await _storage.delete(key: key);
  }
}
