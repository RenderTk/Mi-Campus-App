import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usap_mobile/models/token.dart';

class TokenSecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const tokenKey = 'token';

  static Future<void> setToken(Token token) async {
    if (token.token == null) return;

    await _storage.write(key: tokenKey, value: token.token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: tokenKey);
  }

  static Future<Token?> getToken() async {
    final token = await _storage.read(key: tokenKey);

    if (token == null) return null;
    return Token(token: token);
  }
}
