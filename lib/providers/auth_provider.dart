import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/token.dart';
import 'package:usap_mobile/services/auth_service.dart';
import 'package:usap_mobile/services/dio_service.dart';
import 'package:usap_mobile/services/token_secure_storage_service.dart';

class AuthNotifier extends AsyncNotifier<Token?> {
  final authService = AuthService();
  final dioService = DioService();

  @override
  Future<Token?>? build() async {
    final token = await SecureCredentialStorageService.getToken();
    return token;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    if (email.isEmpty || password.isEmpty) return;
    final dio = dioService.getDio();

    state = await AsyncValue.guard(() async {
      final token = await authService.login(dio, email, password);
      await SecureCredentialStorageService.setToken(token);
      ref.read(isLoggedInProvider.notifier).setLoggedIn();
      return token;
    });
  }

  Future<void> closeSession() async {
    state = await AsyncValue.guard(() async {
      await SecureCredentialStorageService.clearToken();
      ref.read(isLoggedInProvider.notifier).setLoggedOut();
      return null;
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
      ref.read(isLoggedInProvider.notifier).setLoggedOut();
      return;
    }

    state = await AsyncValue.guard(() async {
      await SecureCredentialStorageService.setToken(token);
      ref.read(isLoggedInProvider.notifier).setLoggedIn();
      return token;
    });
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, Token?>(
  AuthNotifier.new,
);

class IsLoggedInNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setLoggedIn() {
    state = true;
  }

  void setLoggedOut() {
    state = false;
  }
}

final isLoggedInProvider = NotifierProvider<IsLoggedInNotifier, bool>(
  IsLoggedInNotifier.new,
);
