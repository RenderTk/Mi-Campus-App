import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/models/user.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/services/secure_credential_storage_service.dart';

final userProvider = FutureProvider<User>((ref) async {
  final token = await SecureCredentialStorageService.getToken();

  if (token == null) {
    await ref.read(authProvider.notifier).closeSession();
    return User.empty();
  }

  final payload = token.decode()!;
  return User(
    id: payload["user"],
    name: payload["NOMBRE"],
    email: "${payload["user"]}@usap.edu",
    carrera: payload["CARRERA"],
  );
});
