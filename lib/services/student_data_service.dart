import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/models/carrera.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/services/dio_service.dart';
import 'package:usap_mobile/services/secure_credential_storage_service.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

const String progresoCarreraUrl = "obtenerporcentajecarrera/{codigo_alumno}";

const String totalClasesEnCarreraUrl =
    "actividades_coprogramaticas/planes/{codigo_alumno}/2";

const String clasesCompletadasUrl =
    "historial/total_cumplidos/{codigo_alumno}/{id_plan}";

const String horarioUrl =
    "Horariosalumno/obtener_horarios_alumno/{codigo_alumno}";

const String calificacionesUrl =
    "historial/informacion/{codigo_alumno}/{id_plan}";

const String puntosCoProgramaticosUrl =
    "actividades_coprogramaticas/alumno/historial/{codigo_alumno}/{id_plan}";

const String carreraIdPlanUrl =
    "actividades_coprogramaticas/planes/{codigo_alumno}/2";

const String promediosCalificacionesUrl =
    "historial/promedios/{codigo_alumno}/{id_plan}";

const String fotoCarnetAlumnoUrl = "obtenerfoto_carnet/{codigo_alumno}";

class StudentDataService {
  final _dioService = DioService();

  Future<String?> getFotoCarnetAlumno(String codigoAlumno) async {
    final url = fotoCarnetAlumnoUrl.replaceFirst(
      "{codigo_alumno}",
      codigoAlumno,
    );
    final dio = _dioService.getDio();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final String base64String = data[0]['FOTO'];
      String cleanBase64 = base64String
          .replaceAll('<FOTO>', '')
          .replaceAll('</FOTO>', '');

      return cleanBase64;
    } else {
      return null;
    }
  }

  Future<int> _getCarreraProgress(String codigoAlumno) async {
    final url = progresoCarreraUrl.replaceFirst(
      "{codigo_alumno}",
      codigoAlumno,
    );
    final dio = _dioService.getDio();
    final response = await dio.get<List<dynamic>>(url);

    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final int progress = (data[0]['PORCENTAJE'] as num).toInt();
      return progress;
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<Map<String, double>> getPromediosCalificaciones(
    String codigoAlumno,
  ) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = promediosCalificacionesUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;

    if (data != null && data.isNotEmpty) {
      final promedioGraduacion = (data[0]['PROMEDIO_GRADUACION'] as num);
      final promedioHistorico = (data[0]['PROMEDIO_HISTORICO'] as num);

      return {
        "PROMEDIO_GRADUACION": promedioGraduacion.toDouble(),
        "PROMEDIO_HISTORICO": promedioHistorico.toDouble(),
      };
    } else {
      return {"PROMEDIO_GRADUACION": 0, "PROMEDIO_HISTORICO": 0};
    }
  }

  Future<int> _getTotalClasesCompletadas(String codigoAlumno) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = clasesCompletadasUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final int totalClasesCumplidas = (data[0]['TOTAL_CUMPLIDAS'] as num)
          .toInt();
      return totalClasesCumplidas;
    } else {
      return 0;
    }
  }

  Future<int> _getCarreraIdPlan(String codigoAlumno) async {
    final url = carreraIdPlanUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      return (data[0]['ID_PLAN'] as num).toInt();
    } else {
      return 0;
    }
  }

  Future<int> getPuntosCoProgramaticos(String codigoAlumno) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = puntosCoProgramaticosUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      int puntos = 0;
      for (var item in data) {
        puntos += (item['PUNTAJE'] as num).toInt();
      }
      return puntos;
    } else {
      return 0;
    }
  }

  Future<Carrera> getCarrera(String codigoAlumno) async {
    final url = totalClasesEnCarreraUrl.replaceFirst(
      "{codigo_alumno}",
      codigoAlumno,
    );
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      final totalClasesCumplidas = await _getTotalClasesCompletadas(
        codigoAlumno,
      );

      final progresoCarrera = await _getCarreraProgress(codigoAlumno);

      final int totalClases = (data[0]['TOTAL_CURSOS_PLAN'] as num).toInt();
      final String nombreCarrera = data[0]['DESCRIPCION_PLAN'];
      final promedios = await getPromediosCalificaciones(codigoAlumno);
      return Carrera(
        nombre: nombreCarrera,
        progresoCarrera: progresoCarrera,
        promedioGraduacion: promedios["PROMEDIO_GRADUACION"] ?? 0,
        promedioHistorico: promedios["PROMEDIO_HISTORICO"] ?? 0,
        totalClasesCompletadas: totalClasesCumplidas,
        totalClases: totalClases,
      );
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<List<SeccionCurso>> getHorarioAlumno(String codigoAlumno) async {
    final url = horarioUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null) {
      return data.map((e) => SeccionCurso.fromJson(e)).toList();
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<List<CalificacionCurso>> getCalificacionesAlumno(
    String codigoAlumno,
  ) async {
    final idPlan = await _getCarreraIdPlan(codigoAlumno);
    final url = calificacionesUrl
        .replaceFirst("{codigo_alumno}", codigoAlumno)
        .replaceFirst("{id_plan}", idPlan.toString());
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;

    data?.removeWhere((e) => e['ESTATUS'] == "Equivalencia");

    if (data != null) {
      final calificaciones = data
          .map((e) => CalificacionCurso.fromJson(e))
          .toList();
      return calificaciones;
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<String?> descargarCalendarioAlumno(
    String url,
    String codigoAlumno,
  ) async {
    try {
      final dio = _dioService.getDio();

      // Download the ICS file
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        // The response.data should contain the ICS file as text
        String icsContent = utf8.decode(response.data);

        // Basic validation that it's an ICS file
        if (icsContent.contains('BEGIN:VCALENDAR') &&
            icsContent.contains('END:VCALENDAR')) {
          //save calendar url
          await SecureCredentialStorageService.setCalendarUrl(
            url,
            codigoAlumno,
          );

          return icsContent;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
