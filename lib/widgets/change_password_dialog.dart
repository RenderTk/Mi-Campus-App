import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/providers/student_provider.dart';
import 'package:usap_mobile/providers/user_provider.dart';
import 'package:usap_mobile/services/auth_service.dart';
import 'package:usap_mobile/services/dio_service.dart';
import 'package:usap_mobile/services/secure_credential_storage_service.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _statusMsg;
  Timer? _errorTimer;
  bool _isSucess = false;
  bool _isLoading = false;
  bool _isCurrentPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  final _authService = AuthService();
  final _dioService = DioService();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Ingresa tu contraseña actual";
    }
    if (value.length < 8) {
      return "Mínimo 8 caracteres";
    }
    if (value.length > 60) {
      return "Máximo 60 caracteres";
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Ingresa una nueva contraseña";
    }

    if (value.length < 8) {
      return "Mínimo 8 caracteres";
    }

    if (value.length > 60) {
      return "Máximo 60 caracteres";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Debe tener una minúscula";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Debe tener una mayúscula";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Debe tener un número";
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_+=\-\[\]\\;/~`]').hasMatch(value)) {
      return "Debe tener un símbolo";
    }

    if (RegExp(r'\s').hasMatch(value)) {
      return "Sin espacios";
    }

    if (_currentPasswordController.text.isNotEmpty &&
        _currentPasswordController.text == value) {
      return "Debe ser distinta a la actual";
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirma tu contraseña";
    }

    if (_newPasswordController.text != value) {
      return "No coinciden";
    }

    return null;
  }

  void _showMsg(String message) {
    setState(() {
      _statusMsg = message;
    });

    // Cancel any existing timer
    _errorTimer?.cancel();

    // Start a new 4-second timer to hide the error
    _errorTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _statusMsg = null;
        });
      }
    });
  }

  Future _onChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      final user = await ref.read(userProvider.future);
      if (user == null) {
        throw Exception('User not found');
      }

      final dio = await _dioService.getDioWithAutoRefresh();
      final msg = await _authService.changePassword(
        dio,
        user.id,
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      // If the message is null, then the password was changed successfully
      if (msg == null) {
        setState(() {
          _isSucess = true;
          _isLoading = false;
        });
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        //clear old password if saved locally for biometric auth
        await SecureCredentialStorageService.clearUserCredentials();

        _showMsg("Contraseña cambiada exitosamente");
        await Future.delayed(const Duration(seconds: 4));
        if (!mounted) return;
        Navigator.pop(context);
        return;
      }

      // Otherwise, show the error message
      setState(() {
        _isSucess = false;
        _isLoading = false;
      });
      _showMsg(msg);
    } catch (e) {
      setState(() {
        _isSucess = false;
        _isLoading = false;
      });
      if (e is TokenRefreshFailedException) {
        _showMsg("Su sesión ha expirado, por favor inicie sesión nuevamente");
        await Future.delayed(const Duration(seconds: 4));
        ref.invalidate(studentProvider);
        if (!mounted) return;
        Navigator.pop(context);
        return;
      }
      // Otherwise, show the error message
      _showMsg("Ocurrio un error inesperado");
    }
  }

  Widget _buildTitle(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.secondaryContainer.withValues(alpha: 0.1),

          shape: BoxShape.circle,
        ),
        child: Icon(
          FontAwesomeIcons.lock,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      title: Text(
        "Cambiar contraseña",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(FontAwesomeIcons.xmark, size: 20),
      ),
    );
  }

  Widget _buildPasswordTextField(
    BuildContext context,
    String title,
    String hintText,
    bool obscureText,
    TextEditingController controller,
    Function onToggleVisibility,
    String? Function(String?) validator,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodySmall,
              suffixIcon: IconButton(
                onPressed: () => onToggleVisibility(),
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextFields(BuildContext context) {
    return Column(
      children: [
        _buildPasswordTextField(
          context,
          "Contraseña actual",
          "Ingresa tu contraseña actual",
          _isCurrentPasswordHidden,
          _currentPasswordController,
          () {
            setState(() {
              _isCurrentPasswordHidden = !_isCurrentPasswordHidden;
            });
          },
          validateCurrentPassword,
        ),
        _buildPasswordTextField(
          context,
          "Nueva contraseña",
          "Mínimo 8 caracteres",
          _isNewPasswordHidden,
          _newPasswordController,
          () {
            setState(() {
              _isNewPasswordHidden = !_isNewPasswordHidden;
            });
          },
          validateNewPassword,
        ),
        _buildPasswordTextField(
          context,
          "Confirmar nueva contraseña",
          "Repite tu nueva contraseña",
          _isConfirmPasswordHidden,
          _confirmPasswordController,
          () {
            setState(() {
              _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
            });
          },
          validateConfirmPassword,
        ),
      ],
    );
  }

  Widget _buildPasswordRecomendationCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(FontAwesomeIcons.circleInfo, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Recomendaciones",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• Usa al menos 8 caracteres",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "• Usa letras mayúsculas y minúsculas",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "• Usa números y símbolos",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required String message,
    required bool isSuccess,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isSuccess
        ? Colors.green
        : Theme.of(context).colorScheme.error;
    final backgroundColor = isSuccess
        ? Colors.green.withValues(alpha: 0.1)
        : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1);
    final icon = isSuccess
        ? Icons.check_circle_outline_rounded
        : Icons.error_outline_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle(context),
              const SizedBox(height: 10),
              _buildPasswordTextFields(context),
              const SizedBox(height: 5),
              _buildPasswordRecomendationCard(context),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: _isLoading ? () {} : _onChangePassword,
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Cambiando contraseña..."),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      )
                    : const Text("Cambiar contraseña"),
              ),
              if (_statusMsg != null) ...[
                const SizedBox(height: 10),
                _buildStatusCard(
                  context,
                  message: _statusMsg!,
                  isSuccess: _isSucess,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
