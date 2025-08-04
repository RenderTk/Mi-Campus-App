import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/student.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/student_data_service.dart';

class StudentNotifier extends AsyncNotifier<Student> {
  final studentDataService = StudentDataService();

  @override
  Future<Student> build() async {
    state = const AsyncValue.loading();

    // await Future.delayed(const Duration(seconds: 5));
    final user = await ref.read(userProvider.future);
    final progresoCarrera = await studentDataService.getDegreeProgress(user.id);
    final secciones = await studentDataService.getStudentsSchedule(user.id);
    return Student(
      user: user,
      progresoCarrera: progresoCarrera,
      secciones: secciones,
    );
  }
}

final studentProvider = AsyncNotifierProvider<StudentNotifier, Student>(
  StudentNotifier.new,
);
