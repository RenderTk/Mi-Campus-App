import 'package:copy_with_extension/copy_with_extension.dart';

@CopyWith()
class User {
  final String id;
  final String name;
  final String email;
  final String carrera;
  final int progresoCarrera;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.carrera,
    required this.progresoCarrera,
  });

  User.empty()
    : id = '',
      name = '',
      email = '',
      carrera = '',
      progresoCarrera = 0;
}
