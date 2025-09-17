import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_campus_app/models/token.dart';

class SecureCredentialStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const _tokenKey = 'token';
  static const _usernameKey = 'username';
  static const _passwordKey = 'password';
  static String _calendarKey(String codigoAlumno) =>
      'calendarUrl-$codigoAlumno';

  static Future<void> setToken(Token token) async {
    if (token.token == null) return;

    await _storage.write(key: _tokenKey, value: token.token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<void> clearUserCredentials() async {
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _passwordKey);
  }

  static Future<void> clearAllAuthCredentials() async {
    await clearToken();
    await clearUserCredentials();
  }

  static Future<void> setUserCredentials(String user, String password) async {
    await _storage.write(key: _usernameKey, value: user);
    await _storage.write(key: _passwordKey, value: password);
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  static Future<String?> getPassword() async {
    return await _storage.read(key: _passwordKey);
  }

  static Future<Token?> getToken() async {
    final token = await _storage.read(key: _tokenKey);

    if (token == null) return null;
    return Token(token: token);
  }

  static Future<void> setCalendarUrl(String url, String codigoAlumno) async {
    final key = _calendarKey(codigoAlumno);
    await _storage.write(key: key, value: url);
  }

  static Future<String?> getCalendarUrl(String codigoAlumno) async {
    final key = _calendarKey(codigoAlumno);
    final cvalue = await _storage.read(key: key);
    return cvalue;
  }
}
