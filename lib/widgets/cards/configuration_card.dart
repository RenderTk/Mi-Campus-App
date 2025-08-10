import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfigurationCard extends StatelessWidget {
  const ConfigurationCard({super.key});

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
                  "Configuración",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(FontAwesomeIcons.lock),
                title: const Text("Cambio de contraseña"),
                trailing: const Icon(FontAwesomeIcons.chevronRight),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
