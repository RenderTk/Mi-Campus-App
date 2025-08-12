import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfigurationCard extends StatefulWidget {
  const ConfigurationCard({super.key});

  @override
  State<ConfigurationCard> createState() => _ConfigurationCardState();
}

class _ConfigurationCardState extends State<ConfigurationCard> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Ingresa tu contraseña actual";
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

    if (currentPasswordController.text.isNotEmpty &&
        currentPasswordController.text == value) {
      return "Debe ser distinta a la actual";
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirma tu contraseña";
    }

    if (newPasswordController.text != value) {
      return "No coinciden";
    }

    return null;
  }

  Future _onChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }

  Widget buildTitle(BuildContext context) {
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

  Widget buildPasswordTextField(
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
                icon: const Icon(FontAwesomeIcons.eye, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordRecomendationCard(BuildContext context) {
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
                    "Recomendaciones de contraseña",
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

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    bool isCurrentPasswordHidden = true;
    bool isNewPasswordHidden = true;
    bool isConfirmPasswordHidden = true;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTitle(context),
                      const SizedBox(height: 10),
                      buildPasswordTextField(
                        context,
                        "Contraseña actual",
                        "Ingresa tu contraseña actual",
                        isCurrentPasswordHidden,
                        currentPasswordController,
                        () {
                          isCurrentPasswordHidden = !isCurrentPasswordHidden;
                          setState(() {});
                        },
                        validateCurrentPassword,
                      ),
                      buildPasswordTextField(
                        context,
                        "Nueva contraseña",
                        "Mínimo 8 caracteres",
                        isNewPasswordHidden,
                        newPasswordController,
                        () {
                          isNewPasswordHidden = !isNewPasswordHidden;
                          setState(() {});
                        },
                        validateNewPassword,
                      ),
                      buildPasswordTextField(
                        context,
                        "Confirmar nueva contraseña",
                        "Repite tu nueva contraseña",
                        isConfirmPasswordHidden,
                        confirmPasswordController,
                        () {
                          isConfirmPasswordHidden = !isConfirmPasswordHidden;
                          setState(() {});
                        },
                        validateConfirmPassword,
                      ),
                      const SizedBox(height: 5),
                      buildPasswordRecomendationCard(context),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () async => _onChangePassword(),
                        child: const Text("Cambiar contraseña"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  "Configuración",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.lock),
                title: const Text("Cambio de contraseña"),
                trailing: const Icon(FontAwesomeIcons.chevronRight),
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
