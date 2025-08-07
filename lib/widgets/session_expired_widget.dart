import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class SessionExpiredWidget extends StatelessWidget {
  final VoidCallback? onLogin;
  final bool showExitButton;

  const SessionExpiredWidget({
    super.key,
    this.onLogin,
    this.showExitButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Icon(
              Icons.access_time,
              size: 120,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Sesión Expirada",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "Tu sesión ha expirado por seguridad. Necesitas iniciar sesión nuevamente para continuar.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          OutlinedButton.icon(
            onPressed: onLogin,
            icon: const Icon(Icons.login),
            label: const Text("Iniciar Sesión"),
          ),
          if (showExitButton) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text("Salir de la app"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
