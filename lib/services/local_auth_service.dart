import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:mi_campus_app/services/auth_service.dart';
import 'package:mi_campus_app/services/dio_service.dart';
import 'package:mi_campus_app/services/secure_credential_storage_service.dart';

class LocalAuthService {
  final localAuth = LocalAuthentication();
  final authService = AuthService();
  final dioService = DioService();

  Future<bool> canUseBiometrics() async {
    try {
      // Check if user has alredy logged in, and theres a token on the device
      final username = await SecureCredentialStorageService.getUsername();
      final password = await SecureCredentialStorageService.getPassword();
      if (username == null || password == null) {
        return false;
      }

      final bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        return false;
      }

      final List<BiometricType> availableBiometrics = await localAuth
          .getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> get hasBiometrics => canUseBiometrics();

  Future<bool> authenticate({String msg = "Ingreso biométrico"}) async {
    try {
      final bool hasBiometrics = await canUseBiometrics();
      if (!hasBiometrics) {
        return false;
      }

      final bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Por favor, autentícate para continuar',
        options: const AuthenticationOptions(biometricOnly: true),
        authMessages: <AuthMessages>[
          const AndroidAuthMessages(
            signInTitle: 'Autenticación requerida',
            cancelButton: 'Cancelar',
            biometricHint: 'Confirma tu identidad',
          ),
          const IOSAuthMessages(cancelButton: 'Cancelar'),
        ],
      );

      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
