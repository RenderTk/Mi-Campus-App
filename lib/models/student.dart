import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:mi_campus_app/models/calificacion_curso.dart';
import 'package:mi_campus_app/models/carrera.dart';
import 'package:mi_campus_app/models/seccion_curso.dart';
import 'package:mi_campus_app/models/user.dart';

@CopyWith()
class Student {
  User user;
  int puntosCoProgramaticos;
  String? fotoBase64;
  Carrera carrera;
  List<SeccionCurso> secciones;
  List<CalificacionCurso> calificaciones;

  Student({
    required this.user,
    required this.puntosCoProgramaticos,
    required this.fotoBase64,
    required this.carrera,
    required this.secciones,
    required this.calificaciones,
  });
}
