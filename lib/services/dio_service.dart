import 'package:dio/dio.dart';
import 'package:usap_mobile/models/token.dart';

const baseApiUrl = "https://siga.usap.edu/api/";

class DioService {
  Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 4),
        receiveTimeout: const Duration(seconds: 4),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    return dio;
  }

  Future<Dio?> getDioWithAutoRefresh(
    Token token,
    Future Function() onRefresh,
  ) async {
    try {
      //if access token is expired, try to refresh
      if (token.isExpired) {
        await onRefresh();
      }
      final dio = Dio(
        BaseOptions(
          baseUrl: baseApiUrl,
          connectTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.token}',
          },
        ),
      );
      return dio;
    } catch (e) {
      return null;
    }
  }
}
