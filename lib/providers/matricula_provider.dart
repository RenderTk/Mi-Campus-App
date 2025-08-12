import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/matricula.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/student_data_service.dart';

class MatriculaNotifier extends AsyncNotifier<List<Matricula>> {
  final StudentDataService studentDataService = StudentDataService();

  @override
  Future<List<Matricula>> build() async {
    final user = await ref.watch(userProvider.future);

    if (user == null) {
      throw Exception('User not found');
    }

    final matriculas = await studentDataService.getStudentMatricula(user.id);
    return matriculas;
  }

  List<Matricula> _makeDeepCopyOfState() {
    return state.value!.map((matricula) => matricula.copyWith()).toList();
  }

  Future<bool> addOrRemoveClaseFromStudent(
    Matricula matricula,
    AccionClase accion,
    TipoModalidad? tipo,
    bool esHibrida,
  ) async {
    final matriculas = _makeDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      if (!matriculas.any((m) => m.idSeccion == matricula.idSeccion)) {
        throw Exception("Se presenta un error, la clase no es valida");
      }

      // update state locally
      matriculas.removeWhere((m) => m.idSeccion == matricula.idSeccion);

      if (accion == AccionClase.quitar) {
        matricula.estaSeleccionada = 0;

        // si es presencial
        if (tipo == TipoModalidad.presencial) {
          matricula.cuposModalidad = matricula.cuposModalidad! + 1;

          //indica que se escogio la version presencial en esta clase hibrida
          if (esHibrida) {
            matricula.hibrida = 1;
          }
        }
        // si es videoconferencia o virtual
        else {
          matricula.cupos = matricula.cupos! + 1;

          //indica que se escogio la version virtual o videoconferencia en esta clase hibrida
          if (esHibrida) {
            matricula.hibrida = 0;
          }
        }
      }

      if (accion == AccionClase.agregar) {
        matricula.estaSeleccionada = 1;
        // si es presencial
        if (tipo == TipoModalidad.presencial) {
          matricula.cuposModalidad = matricula.cuposModalidad! - 1;

          //indica que se escogio la version presencial en esta clase hibrida
          if (esHibrida) {
            matricula.hibrida = 1;
          }
        }
        // si es videoconferencia o virtual
        else {
          matricula.cupos = matricula.cupos! - 1;

          //indica que se escogio la version virtual o videoconferencia en esta clase hibrida
          if (esHibrida) {
            matricula.hibrida = 0;
          }
        }
      }

      matriculas.add(matricula);
      // update horario of student
      await ref.read(studentProvider.notifier).updateSchedule();

      return matriculas;
    });

    return true;
  }
}

final matriculaProvider =
    AsyncNotifierProvider<MatriculaNotifier, List<Matricula>>(
      () => MatriculaNotifier(),
    );
