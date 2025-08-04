import 'package:copy_with_extension/copy_with_extension.dart';

@CopyWith()
class User {
  final String id;
  final String name;
  final String email;
  final String carrera;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.carrera,
  });

  User.empty() : id = '', name = '', email = '', carrera = '';
}
