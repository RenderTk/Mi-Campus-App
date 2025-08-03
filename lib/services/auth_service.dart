import 'package:dio/dio.dart';
import 'package:usap_mobile/models/token.dart';

const String tokenUrl = "generar_token";
const String renovarTokenUrl = "renovar_token";

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
}
