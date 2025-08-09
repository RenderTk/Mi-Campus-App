import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/models/matricula.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/services/dio_service.dart';

const String degreeProgressUrl = "obtenerporcentajecarrera/{codigo_alumno}";
const String scheduleUrl =
    "Horariosalumno/obtener_horarios_alumno/{codigo_alumno}";
const String calificationsUrl = "historial/informacion/{codigo_alumno}/140";
const String ofertaMatriculaUrl =
    "matricula/oferta/{codigo_alumno1}/{codigo_alumno2}/1";

const String ofertaMatriculaOptativaUrl =
    "matricula/oferta_optativa/{codigo_alumno1}/{id_seccion}/1/{codigo_alumno2}";

const String addOrRemoveClassUrl = "matricula";

enum AccionClase { agregar, quitar }

enum TipoModalidad { presencial, videoconferencia }

class StudentDataService {
  final _dioService = DioService();

  Future<int> getDegreeProgress(String codigoAlumno) async {
    final url = degreeProgressUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
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

  Future<List<SeccionCurso>> getStudentsSchedule(String codigoAlumno) async {
    final url = scheduleUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null) {
      return data.map((e) => SeccionCurso.fromJson(e)).toList();
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<List<CalificacionCurso>> getStudentCalifications(
    String codigoAlumno,
  ) async {
    final url = calificationsUrl.replaceFirst("{codigo_alumno}", codigoAlumno);
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;
    if (data != null) {
      final calificaciones = data
          .map((e) => CalificacionCurso.fromJson(e))
          .toList();
      return calificaciones;
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<List<Matricula>> getStudentMatricula(String codigoAlumno) async {
    final url = ofertaMatriculaUrl
        .replaceFirst("{codigo_alumno1}", codigoAlumno)
        .replaceFirst("{codigo_alumno2}", codigoAlumno);
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.get<List<dynamic>>(url);
    final data = response.data;

    if (data != null) {
      final matriculas = data.map((e) => Matricula.fromJson(e)).toList();

      // get ids of secciones optativas
      final idsSeccionesOptativas = matriculas
          .where((matricula) => matricula.esOptativa)
          .map((matricula) => matricula.idSeccion)
          .toList();

      if (idsSeccionesOptativas.isNotEmpty) {
        final matriculasOptativas = await getStudentMatriculaOptativa(
          codigoAlumno,
          idsSeccionesOptativas,
        );
        matriculas.addAll(matriculasOptativas);
      }

      //remove invalid matriculas
      matriculas.removeWhere(
        (matricula) =>
            matricula.cupos == null ||
            matricula.dias == null ||
            matricula.dias == "" ||
            matricula.modalidad == null ||
            matricula.modalidad == "" ||
            matricula.esHDR,
      );
      return matriculas;
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }

  Future<List<Matricula>> getStudentMatriculaOptativa(
    String codigoAlumno,
    List<int?> idsSeccionesOptativas,
  ) async {
    final url = ofertaMatriculaOptativaUrl
        .replaceFirst("{codigo_alumno1}", codigoAlumno)
        .replaceFirst("{codigo_alumno2}", codigoAlumno);

    final dio = await _dioService.getDioWithAutoRefresh();

    // Create a list of futures for all requests
    final futures = idsSeccionesOptativas.map((idSeccion) async {
      final fullUrl = url.replaceFirst("{id_seccion}", idSeccion.toString());
      final response = await dio.get<List<dynamic>>(fullUrl);
      final data = response.data;

      if (data != null) {
        final matriculas = data.map((e) => Matricula.fromJson(e)).toList();
        if (matriculas.isNotEmpty) {
          for (int i = 0; i < matriculas.length; i++) {
            matriculas[i].idDetallePlan = idSeccion;
            matriculas[i].optativa = 1;
          }
        }
        return matriculas;
      } else {
        throw Exception('Empty, null or invalid response data');
      }
    }).toList();

    // Run all requests in parallel and flatten the results
    final results = await Future.wait(futures);
    return results.expand((list) => list).toList();
  }

  Future<String?> addClaseOrRemoveClaseFromStudent(
    Matricula matricula,
    String codigoAlumno,
    AccionClase accion,
    TipoModalidad? tipo,
  ) async {
    int accionAsInt = accion == AccionClase.agregar ? 1 : 2;

    // valor por defecto si no es clase hibrida
    int? modalidadAfectadaAsInt = 0;

    if (tipo != null) {
      // si es clase hibrida
      modalidadAfectadaAsInt = tipo == TipoModalidad.presencial ? 1 : 0;
    }

    if (accion == AccionClase.agregar && matricula.estaSeleccionada == 1) {
      throw Exception(
        "La clase ya se encuentra seleccionada, no se puede agregar",
      );
    }

    if (accion == AccionClase.quitar && matricula.estaSeleccionada == 0) {
      throw Exception(
        "La clase no se encuentra seleccionada, no se puede quitar",
      );
    }

    final payload = {
      "id_seccion": matricula.idSeccion,
      "id_seccion_co": "null",
      "codigo_curso": matricula.codigoCurso,
      "codigo_curso_co": "null",
      "cuenta_alumno": codigoAlumno,
      "id_plan": 140,
      "ad_usuario": codigoAlumno,
      "id_cajero": 2,
      "id_detalle_plan": matricula.esOptativa
          ? matricula.idDetallePlan
          : "null",
      "lista_espera": 0,
      "hibrida": modalidadAfectadaAsInt,
      "hibrida_co": "null",
      "tipo": accionAsInt,
    };
    final dio = await _dioService.getDioWithAutoRefresh();
    final response = await dio.post(addOrRemoveClassUrl, data: payload);

    if (response.statusCode != 200) {
      throw Exception("Ocurrio un error al ${accion.name} la clase");
    }

    //silly bussiness logic in this fucking API
    final resp = response.data[0]["RESP"];
    if (resp != "OK") {
      return resp;
    }

    return null;
  }
}
