import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usap_mobile/providers/pagos_pendientes_provider.dart';
import 'package:usap_mobile/utils/helper_functions.dart';

Future<void> _launchSigaUrl() async {
  await launchUrl(
    Uri.parse("https://siga.usap.edu"),
    mode: LaunchMode.externalApplication,
  );
}

class TotalSaldoPendienteCard extends ConsumerWidget {
  const TotalSaldoPendienteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(pagosPendientesProvider.future),
      builder: (context, snapshot) {
        final pagosPendientes = snapshot.data ?? [];

        final totalPendiente = pagosPendientes
            .map((pagoPendiente) => pagoPendiente.monto ?? 0)
            .fold<double>(0, (a, b) => a + b);

        return Card(
          color: Theme.of(
            context,
          ).colorScheme.secondaryFixed.withValues(alpha: 0.1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Total pendiente",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.attach_money,
                      color: Colors.green,
                      size: 20,
                    ),
                    if (pagosPendientes.isNotEmpty)
                      Text(
                        "${pagosPendientes.length} pagos",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "L ${formatNumber(totalPendiente)}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    border: Border(
                      left: BorderSide(color: Colors.amber.shade600, width: 4),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.amber.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Importante",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Para realizar tus pagos visita siga.usap.edu",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _launchSigaUrl,
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text("Ir a SIGA"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
