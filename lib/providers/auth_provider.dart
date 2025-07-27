import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/token.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/auth_service.dart';
import 'package:usap_mobile/services/dio_service.dart';
import 'package:usap_mobile/services/token_secure_storage_service.dart';

class AuthNotifier extends AsyncNotifier<Token?> {
  final authService = AuthService();
  final dioService = DioService();

  @override
  Future<Token?>? build() async {
    final token = await TokenSecureStorageService.getToken();
    return token;
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;
    final dio = dioService.getDio();

    state = await AsyncValue.guard(() async {
      final token = await authService.login(dio, email, password);
      await TokenSecureStorageService.setToken(token);
      ref.read(isLoggedInProvider.notifier).setLoggedIn();
      return token;
    });
  }

  Future<void> closeSession() async {
    state = await AsyncValue.guard(() async {
      await TokenSecureStorageService.clearToken();
      ref.read(isLoggedInProvider.notifier).setLoggedOut();

      return null;
    });
  }

  Future<void> refreshToken() async {
    late Token token;
    try {
      final dio = dioService.getDio();

      final currentToken = state.valueOrNull?.token;
      if (currentToken == null) throw Exception('No token available');

      dio.options.headers['Authorization'] = 'Bearer $currentToken';

      final user = ref.watch(userProvider).valueOrNull;
      if (user == null) {
        throw Exception('User not found');
      }
      token = await authService.refreshToken(dio, user);
    } catch (e) {
      ref.read(isLoggedInProvider.notifier).setLoggedOut();
      return;
    }

    state = await AsyncValue.guard(() async {
      await TokenSecureStorageService.setToken(token);
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
    final token = ref.watch(authProvider);
    if (token.isLoading) {
      return false;
    }
    if (token.valueOrNull == null) {
      return false;
    }
    try {
      final isExpired = token.value!.isExpired;
      if (isExpired) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void setLoggedIn() async {
    state = true;
  }

  void setLoggedOut() async {
    state = false;
  }
}

final isLoggedInProvider = NotifierProvider<IsLoggedInNotifier, bool>(
  IsLoggedInNotifier.new,
);
