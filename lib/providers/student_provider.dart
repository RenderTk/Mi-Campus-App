import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/models/carrera.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/models/user.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/student_data_service.dart';

class StudentNotifier extends AsyncNotifier<Student> {
  final studentDataService = StudentDataService();

  @override
  Future<Student> build() async {
    state = const AsyncValue.loading();

    // wait for user provider to update
    final user = await ref.watch(userProvider.future);

    if (user == null) {
      throw Exception('User not found');
    }

    final progresoCarrera = await studentDataService.getDegreeProgress(user.id);
    final puntosCoProgramaticos = await studentDataService
        .getPuntosCoProgramaticos(user.id);
    final carrera = await studentDataService.getDegree(user.id);
    final secciones = await studentDataService.getStudentsSchedule(user.id);
    final calificaciones = await studentDataService.getStudentCalifications(
      user.id,
    );

    // Ordenar las secciones por día y hora
    final seccionesOrdenadas = _ordenarSecciones(secciones);

    return Student(
      user: user,
      progresoCarrera: progresoCarrera,
      puntosCoProgramaticos: puntosCoProgramaticos,
      carrera: carrera,
      secciones: seccionesOrdenadas,
      calificaciones: calificaciones,
    );
  }

  Future<void> updateSchedule() async {
    final student = _makeDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      final user = await ref.read(userProvider.future);

      if (user == null) {
        throw Exception('User not found');
      }

      final refreshedSecciones = await studentDataService.getStudentsSchedule(
        user.id,
      );

      student.secciones = refreshedSecciones;

      return student;
    });
  }

  //create a deep copy of the state
  Student _makeDeepCopyOfState() {
    return Student(
      user: state.value!.user.copyWith(),
      progresoCarrera: state.value!.progresoCarrera,
      puntosCoProgramaticos: state.value!.puntosCoProgramaticos,
      carrera: state.value!.carrera.copyWith(),
      secciones: state.value!.secciones
          .map((seccion) => seccion.copyWith())
          .toList(),
      calificaciones: state.value!.calificaciones
          .map((calificacion) => calificacion.copyWith())
          .toList(),
    );
  }

  /// Ordena las secciones por día de la semana y luego por hora
  List<SeccionCurso> _ordenarSecciones(List<SeccionCurso> secciones) {
    final seccionesCopia = List<SeccionCurso>.from(secciones);

    seccionesCopia.sort((a, b) {
      // Primero ordenar por día de la semana
      final diaA = a.numeroDia ?? 8; // Si no tiene día, va al final
      final diaB = b.numeroDia ?? 8;

      if (diaA != diaB) {
        return diaA.compareTo(diaB);
      }

      // Si es el mismo día, ordenar por hora
      final horaA = _convertirHoraAMinutos(a.inicio);
      final horaB = _convertirHoraAMinutos(b.inicio);

      return horaA.compareTo(horaB);
    });

    return seccionesCopia;
  }

  /// Convierte una hora en formato "10:45AM" a minutos desde medianoche
  int _convertirHoraAMinutos(String? horaTexto) {
    if (horaTexto == null) return 9999; // Si no tiene hora, va al final

    try {
      final horaLimpia = horaTexto.toUpperCase().trim();
      final esAM = horaLimpia.contains('AM');
      final esPM = horaLimpia.contains('PM');

      if (!esAM && !esPM) return 9999;

      final horaSinAMPM = horaLimpia.replaceAll(RegExp(r'[AP]M'), '');
      final partes = horaSinAMPM.split(':');

      if (partes.length != 2) return 9999;

      int hora = int.parse(partes[0]);
      final minuto = int.parse(partes[1]);

      // Convertir a formato 24 horas
      if (esPM && hora != 12) hora += 12;
      if (esAM && hora == 12) hora = 0;

      // Convertir a minutos desde medianoche
      return (hora * 60) + minuto;
    } catch (e) {
      return 9999; // En caso de error, va al final
    }
  }
}

final studentProvider = AsyncNotifierProvider<StudentNotifier, Student>(
  StudentNotifier.new,
);
