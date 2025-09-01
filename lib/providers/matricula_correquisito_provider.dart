import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/matricula.dart';
import 'package:usap_mobile/services/matricula_data_service.dart';

// Create a record type to hold the parameters
typedef MatriculaCorrequisitoParams = ({
  String codigoAlumno,
  Matricula matricula,
});

final matriculaCorrequisitoProvider = FutureProvider.family
    .autoDispose<List<Matricula>, MatriculaCorrequisitoParams>((
      ref,
      params,
    ) async {
      final matriculaDataService = MatriculaDataService();

      final matriculasDeCorrequisito = await matriculaDataService
          .getStudentMatriculaCorrequisito(
            params.codigoAlumno,
            params.matricula.idDetallePlan ?? 0,
          );

      return matriculasDeCorrequisito.map((matricula) {
        return matricula.copyWith(idPlan: params.matricula.idPlan);
      }).toList();
    });
