import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/exceptions/token_refresh_failed_exception.dart';
import 'package:mi_campus_app/models/user.dart';
import 'package:mi_campus_app/services/secure_credential_storage_service.dart';

class UserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final token = await SecureCredentialStorageService.getToken();

    if (token == null) {
      return null;
    }

    late Map<String, dynamic> payload;
    try {
      payload = token.decode()!;
    } catch (e) {
      //probably expired
      throw TokenRefreshFailedException();
    }
    return User(
      id: payload["user"],
      name: payload["NOMBRE"],
      email: "${payload["user"]}@usap.edu",
      carrera: payload["CARRERA"],
    );
  }

  // Method to refresh or update user state manually
  Future<void> refreshUser() async {
    state = await AsyncValue.guard(() async {
      final token = await SecureCredentialStorageService.getToken();

      if (token == null) {
        return null;
      }

      final payload = token.decode()!;
      ref.read(isLoggedInProvider.notifier).setIsLoggedIn(true);
      return User(
        id: payload["user"],
        name: payload["NOMBRE"],
        email: "${payload["user"]}@usap.edu",
        carrera: payload["CARRERA"],
      );
    });
  }

  Future logOut() async {
    await SecureCredentialStorageService.clearToken();
    ref.read(isLoggedInProvider.notifier).setIsLoggedOut();
    state = const AsyncValue.data(null);
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(
  () => UserNotifier(),
);

class IsLoggedInNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setIsLoggedIn(bool value) {
    state = value;
  }

  void setIsLoggedOut() {
    state = false;
  }
}

final isLoggedInProvider = NotifierProvider<IsLoggedInNotifier, bool>(
  () => IsLoggedInNotifier(),
);
