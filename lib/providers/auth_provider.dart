import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/token.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/auth_service.dart';
import 'package:usap_mobile/services/dio_service.dart';
import 'package:usap_mobile/services/local_auth_service.dart';
import 'package:usap_mobile/services/secure_credential_storage_service.dart';

class AuthNotifier extends AsyncNotifier<Token?> {
  final authService = AuthService();
  final localAuthService = LocalAuthService();
  final dioService = DioService();

  @override
  Future<Token?>? build() async {
    final token = await SecureCredentialStorageService.getToken();
    return token;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    if (username.isEmpty || password.isEmpty) return;
    final dio = dioService.getDio();

    state = await AsyncValue.guard(() async {
      final token = await authService.login(dio, username, password);
      // clear any previous credentials
      await SecureCredentialStorageService.clearAllAuthCredentials();

      await SecureCredentialStorageService.setToken(token);
      await SecureCredentialStorageService.setUserCredentials(
        username,
        password,
      );

      // wait for user provider to update
      await ref.read(userProvider.notifier).refreshUser();
      return token;
    });
  }

  Future<void> biometricLogin() async {
    state = const AsyncValue.loading();

    final dio = dioService.getDio();
    state = await AsyncValue.guard(() async {
      final isAuthenticated = await localAuthService.authenticate();
      if (!isAuthenticated) {
        throw Exception("No se pudo iniciar sesión con biometría.");
      }

      final username = await SecureCredentialStorageService.getUsername();
      final password = await SecureCredentialStorageService.getPassword();
      if (username == null || password == null) {
        throw Exception(
          "No se pudo iniciar sesión con biometría. Inicia sesión manualmente.",
        );
      }

      final token = await authService.login(dio, username, password);
      // clear any previous credentials
      await SecureCredentialStorageService.clearAllAuthCredentials();

      await SecureCredentialStorageService.setToken(token);
      await SecureCredentialStorageService.setUserCredentials(
        username,
        password,
      );

      // wait for user provider to update
      await ref.read(userProvider.notifier).refreshUser();
      return token;
    });
  }

  Future<void> refreshToken() async {
    state = const AsyncValue.loading();

    late Token token;
    try {
      final dio = dioService.getDio();

      final currentToken = state.valueOrNull;
      if (currentToken == null) throw Exception('No token available');

      dio.options.headers['Authorization'] = 'Bearer $currentToken';

      final payload = currentToken.decode();
      final user = payload?['user'] as String?;

      if (user == null) {
        throw Exception('User not found');
      }
      token = await authService.refreshToken(dio, user);
    } catch (e) {
      await SecureCredentialStorageService.clearToken();
      // wait for user provider to update
      await ref.read(userProvider.notifier).refreshUser();
      return;
    }

    state = await AsyncValue.guard(() async {
      await SecureCredentialStorageService.setToken(token);
      // wait for user provider to update
      await ref.read(userProvider.notifier).refreshUser();
      return token;
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, Token?>(
  AuthNotifier.new,
);
