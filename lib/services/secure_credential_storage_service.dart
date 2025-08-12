import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usap_mobile/models/token.dart';

class SecureCredentialStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const tokenKey = 'token';
  static const userKey = 'user';
  static const passwordKey = 'password';

  static Future<void> setToken(Token token) async {
    if (token.token == null) return;

    await _storage.write(key: tokenKey, value: token.token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: tokenKey);
  }

  static Future<void> clearUserCredentials() async {
    await _storage.delete(key: userKey);
    await _storage.delete(key: passwordKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> setUserCredentials(String user, String password) async {
    await _storage.write(key: userKey, value: user);
    await _storage.write(key: passwordKey, value: password);
  }

  static Future<String?> getUser() async {
    return await _storage.read(key: userKey);
  }

  static Future<String?> getPassword() async {
    return await _storage.read(key: passwordKey);
  }

  static Future<Token?> getToken() async {
    final token = await _storage.read(key: tokenKey);

    if (token == null) return null;
    return Token(token: token);
  }
}
