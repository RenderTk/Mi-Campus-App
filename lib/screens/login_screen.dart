import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/providers/auth_provider.dart';
import 'package:usap_mobile/services/local_auth_service.dart';
import 'package:usap_mobile/utils/email_validator.dart';
import 'package:usap_mobile/utils/error_helper.dart';
import 'package:usap_mobile/utils/snackbar_helper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _globalKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final localAuthService = LocalAuthService();
  bool showBiometricButton = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildEmailTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: emailController,
        validator: (value) => EmailValidator.validateInstitutional(
          value,
          allowedDomains: ["usap.edu"],
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Correo institucional",
        ),
      ),
    );
  }

  Widget _buildPasswordTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: passwordController,
        validator: (value) => value == null || value.trim().isEmpty
            ? "Contraseña obligatoria"
            : null,
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Contraseña",
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (!_globalKey.currentState!.validate()) {
              return;
            }
            try {
              setState(() {
                isLoading = true;
              });
              final username = emailController.text.trim().split('@')[0];
              await ref
                  .read(authProvider.notifier)
                  .login(username, passwordController.text.trim());
            } catch (e) {
              if (!mounted) return;
              SnackbarHelper.showCustomSnackbar(
                context: context,
                type: SnackbarType.error,
                message: "Error al iniciar sesión.",
              );
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          },
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Iniciando sesión..."),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                )
              : const Text("Iniciar sesión"),
        ),
      ),
    );
  }

  Widget _buildBiometricLoginButton() {
    return IconButton(
      icon: const Icon(Icons.fingerprint, size: 60),
      onPressed: () async {
        try {
          setState(() {
            isLoading = true;
          });
          await ref.read(authProvider.notifier).biometricLogin();
        } catch (e) {
          if (!mounted) return;
          SnackbarHelper.showCustomSnackbar(
            context: context,
            type: SnackbarType.warning,
            message:
                "No se pudo iniciar sesión con biometría. Inicia sesión manualmente.",
          );
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;

    //show snackbar error when task list state is on error
    ref.listen(authProvider, (previous, next) {
      String error = next.error.toString();
      final userFriendlyError = ErrorHelper.getFriendlyErrorMessage(error);

      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: userFriendlyError,
          type: SnackbarType.warning,
        );
      }
    });

    return FutureBuilder(
      future: localAuthService.canUseBiometrics(),
      builder: (context, snapshot) {
        showBiometricButton = snapshot.data ?? false;

        if (snapshot.error != null) {
          showBiometricButton = false;
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  Image.asset("assets/usap_logo_big.png"),
                  const SizedBox(height: 30),
                  Text(
                    "¡Bienvenido a USAP móvil!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 35),
                  _buildEmailTextFormField(),
                  const SizedBox(height: 50),
                  _buildPasswordTextFormField(),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                  const SizedBox(height: 30),
                  if (showBiometricButton) _buildBiometricLoginButton(),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text("¿Olvidaste tu contraseña?"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
