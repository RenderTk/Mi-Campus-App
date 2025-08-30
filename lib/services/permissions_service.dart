import 'package:usap_mobile/models/pantalla_bloqueada.dart';
import 'package:usap_mobile/services/dio_service.dart';

String pantallasBloqueadasUrl = 'Obtener_paginas_bloqueo/{codigo_alumno}/2';

class PermissionsService {
  final _dioService = DioService();

  Future<List<PantallaBloqueada>> getPantallasBloqueadas(
    String codigoAlumno,
  ) async {
    final url = pantallasBloqueadasUrl;
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null) {
      return data.map((e) => PantallaBloqueada.fromJson(e)).toList();
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }
}
