// Función para mostrar el diálogo de token expirado (versión completa)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:usap_mobile/providers/auth_provider.dart';

void showTokenExpiredDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false, // No puede cerrar tocando fuera
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(
          Icons.access_time,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        title: const Text("Sesión Expirada"),
        content: const Text(
          "Tu sesión ha expirado por seguridad. Necesitas iniciar sesión nuevamente para continuar.",
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              // Cerrar la app si el usuario prefiere
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: const Text("Salir"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              ref
                  .read(isLoggedInProvider.notifier)
                  .setLoggedOut(); // Redirigir al login
            },
            child: const Text("Iniciar Sesión"),
          ),
        ],
      );
    },
  );
}

// Función simple (solo login)
void showSimpleTokenExpiredDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(
          Icons.access_time,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        title: const Text("Sesión Expirada"),
        content: const Text(
          "Tu sesión ha expirado por seguridad. Necesitas iniciar sesión nuevamente para continuar.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              ref
                  .read(isLoggedInProvider.notifier)
                  .setLoggedOut(); // Redirigir al login
            },
            child: const Text("Iniciar Sesión"),
          ),
        ],
      );
    },
  );
}
