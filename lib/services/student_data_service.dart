import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/services/dio_service.dart';

const String degreeProgressUrl = "obtenerporcentajecarrera/{codigo_alumno}";
const String scheduleUrl =
    "https://siga.usap.edu/api/Horariosalumno/obtener_horarios_alumno/{codigo_alumno}";

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
    if (data != null && data.isNotEmpty) {
      return data.map((e) => SeccionCurso.fromJson(e)).toList();
    } else {
      throw Exception('Empty, null or invalid response data');
    }
  }
}
