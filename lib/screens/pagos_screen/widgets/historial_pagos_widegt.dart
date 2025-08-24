import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usap_mobile/exceptions/token_refresh_failed_exception.dart';
import 'package:usap_mobile/models/historial_pago.dart';
import 'package:usap_mobile/providers/historial_pago_provider.dart';
import 'package:usap_mobile/screens/pagos_screen/widgets/historial_pago_card.dart';
import 'package:usap_mobile/widgets/error_state_widget.dart';

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            "No se encontraron historial de pagos",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            "Prueba seleccionando otro año o período\npara consultar registros anteriores.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ListHistorialPagoCards extends StatelessWidget {
  const _ListHistorialPagoCards({required this.historialPagos});

  final List<HistorialPago> historialPagos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: historialPagos.length,
      itemBuilder: (context, index) {
        final historialPago = historialPagos[index];

        //exclude shitty records
        if (historialPago.monto == 0 || historialPago.montoTotal == 0) {
          return const SizedBox.shrink();
        }
        return HistorialPagoCard(historialPago: historialPago);
      },
    );
  }
}

class _SucessState extends StatelessWidget {
  const _SucessState({required this.historialPagos});
  final List<HistorialPago> historialPagos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: historialPagos.isEmpty
          ? const _EmptyState()
          : _ListHistorialPagoCards(historialPagos: historialPagos),
    );
  }
}

class HistorialPagosWidget extends ConsumerWidget {
  const HistorialPagosWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historialPagos = ref.watch(historialPagosProvider);

    return historialPagos.when(
      data: (historialPagos) {
        return _SucessState(historialPagos: historialPagos);
      },
      error: (error, stackTrace) {
        if (error != TokenRefreshFailedException) {
          return const ErrorStateWidget(
            errorMessage:
                "Ocurrio un error al cargar el historial de pagos. Intente mas tarde.",
            onRetry: null,
            showExitButton: false,
          );
        }

        return const SizedBox.shrink();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
