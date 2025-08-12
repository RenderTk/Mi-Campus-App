import 'package:dio/dio.dart';
import 'package:usap_mobile/models/token.dart';

const String tokenUrl = "generar_token";
const String renovarTokenUrl = "renovar_token";
const String changePasswordUrl = "cambiar_clave/cambiar";

class AuthService {
  Future<Token> login(Dio dio, String email, String password) async {
    final request = await dio.post(
      tokenUrl,
      data: {
        "username": email,
        "password": password,
        "tokenGoo": "",
        "sucursal": 1,
      },
    );

    if (request.statusCode != 200) {
      throw Exception(request.data);
    }

    final token = Token.fromJson(request.data);

    try {
      token.decode();
    } catch (e) {
      throw Exception("Correo o contraseña incorrecta");
    }

    return Token.fromJson(request.data);
  }

  Future<Token> refreshToken(Dio dio, String user) async {
    final request = await dio.post(
      renovarTokenUrl,
      data: {"username": user, "sucursal": 1},
    );

    if (request.statusCode != 200) {
      throw Exception("Error al iniciar sesión. Ingresa tus credenciales.");
    }

    String token = request.data;
    return Token(token: token);
  }

  Future<String?> changePassword(
    Dio dio,
    String codigoAlumno,
    String oldPassword,
    String newPassword,
  ) async {
    final url = changePasswordUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
    final payload = {
      "USER": codigoAlumno,
      "OLD_PASS": oldPassword,
      "NEW_PASS": newPassword,
    };
    final response = await dio.post<List<dynamic>>(
      url,
      data: payload,
      options: Options(
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Ocurrió un error al cambiar la contraseña");
    }

    //kinda funny, checking for errors when is a 200 response
    if (response.statusCode == 200) {
      final data = response.data;

      final int result = data?[0]['RESULT'] ?? 0;
      final msg = data?[0]['RESP'] ?? "Error al cambiar la contraseña";

      // if result is 0, an error occurred
      if (result == 0) {
        return msg;
      }
    }
    return null;
  }
}
