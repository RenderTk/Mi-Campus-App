import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/user.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/services/student_data_service.dart';
import 'package:usap_mobile/services/token_secure_storage_service.dart';

final userProvider = FutureProvider<User>((ref) async {
  final token = await TokenSecureStorageService.getToken();
  final studentDataService = StudentDataService();

  if (token == null) {
    await ref.read(authProvider.notifier).closeSession();
    return User.empty();
  }

  final payload = token.decode()!;
  final progresoCarrera = await studentDataService.getDegreeProgress(
    payload["user"]!,
  );
  return User(
    id: payload["user"],
    name: payload["NOMBRE"],
    email: "${payload["user"]}@usap.edu",
    carrera: payload["CARRERA"],
    progresoCarrera: progresoCarrera,
  );
});
