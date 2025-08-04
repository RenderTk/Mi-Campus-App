import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:usap_mobile/models/seccion_curso.dart';
import 'package:usap_mobile/models/user.dart';

@CopyWith()
class Student {
  User user;
  int progresoCarrera;
  List<SeccionCurso> secciones;

  Student({
    required this.user,
    required this.progresoCarrera,
    required this.secciones,
  });
}
