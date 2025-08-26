import 'package:copy_with_extension/copy_with_extension.dart';

part 'carrera.g.dart';

@CopyWith()
class Carrera {
  String nombre;
  int progresoCarrera;
  int totalClasesCompletadas;
  int totalClases;

  Carrera({
    required this.nombre,
    required this.progresoCarrera,
    required this.totalClasesCompletadas,
    required this.totalClases,
  });
}
