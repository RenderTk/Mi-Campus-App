import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:usap_mobile/models/calificacion_curso.dart';
import 'package:usap_mobile/models/carrera.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/models/user.dart';

@CopyWith()
class Student {
  User user;
  int puntosCoProgramaticos;
  Carrera carrera;
  List<SeccionCurso> secciones;
  List<CalificacionCurso> calificaciones;

  Student({
    required this.user,
    required this.puntosCoProgramaticos,
    required this.carrera,
    required this.secciones,
    required this.calificaciones,
  });
}
