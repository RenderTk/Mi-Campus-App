import 'package:usap_mobile/services/dio_service.dart';

const String degreeProgressUrl = "obtenerporcentajecarrera/{codigo_alumno}";

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
      throw Exception('Empty or null response data');
    }
  }
}
