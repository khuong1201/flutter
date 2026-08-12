import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage;

  SecureStorageHelper(this._storage);

  static const String _tokenKey = 'jwt_token';
  static const String _languageKey = 'app_language';
  static const String _themeKey = 'app_theme';



  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveLanguage(String languageCode) async {
    await _storage.write(key: _languageKey, value: languageCode);
  }

  Future<String?> getLanguage() async {
    return await _storage.read(key: _languageKey);
  }

  Future<void> saveTheme(String theme) async {
    await _storage.write(key: _themeKey, value: theme);
  }

  Future<String?> getTheme() async {
    return await _storage.read(key: _themeKey);
  }
}