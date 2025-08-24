import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usap_mobile/screens/home_screen/perfil_widgets/change_password_dialog.dart';

class ConfigurationCard extends ConsumerStatefulWidget {
  const ConfigurationCard({super.key});

  @override
  ConsumerState<ConfigurationCard> createState() => _ConfigurationCardState();
}

class _ConfigurationCardState extends ConsumerState<ConfigurationCard> {
  Future<void> _showChangePasswordDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const Dialog(child: ChangePasswordDialog()),
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
