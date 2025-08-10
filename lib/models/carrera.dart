import 'package:copy_with_extension/copy_with_extension.dart';

part 'carrera.g.dart';

@CopyWith()
class Carrera {
  String nombre;
  int totalClases;

  Carrera({required this.nombre, required this.totalClases});
}
