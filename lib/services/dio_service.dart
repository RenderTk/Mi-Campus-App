import 'package:dio/dio.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/services/auth_service.dart';
import 'package:usap_mobile/services/secure_credential_storage_service.dart';

const baseApiUrl = "https://siga.usap.edu/api/";
// const baseApiUrl = "https://melioris.usap.edu/api/";

class DioService {
  final authService = AuthService();

  Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    return dio;
  }

  Future<Dio> getDioWithAutoRefresh() async {
    final token = await SecureCredentialStorageService.getToken();
    try {
      if (token == null) {
        throw TokenRefreshFailedException();
      }
      //if access token is expired, try to refresh
      if (token.isExpired) {
        final user = token.decode()!['user'];
        await authService.refreshToken(getDio(), user);
      }
    } catch (e) {
      throw TokenRefreshFailedException();
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.token}',
        },
      ),
    );
    return dio;
  }
}
