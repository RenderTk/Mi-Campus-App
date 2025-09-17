import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_campus_app/exceptions/token_refresh_failed_exception.dart';
import 'package:mi_campus_app/models/pago_pendiente.dart';
import 'package:mi_campus_app/providers/pagos_pendientes_provider.dart';
import 'package:mi_campus_app/screens/pagos_screen/widgets/pago_pendiente_card.dart';
import 'package:mi_campus_app/widgets/error_state_widget.dart';

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
            "No se encontraron pagos pendientes",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SucessState extends StatelessWidget {
  const _SucessState({required this.pagosPendientes});
  final List<PagoPendiente> pagosPendientes;

  @override
  Widget build(BuildContext context) {
    return pagosPendientes.isEmpty
        ? const _EmptyState()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: pagosPendientes.length,
            itemBuilder: (context, index) {
              final pagoPendiente = pagosPendientes[index];
              return PagoPendienteCard(pagoPendiente: pagoPendiente);
            },
          );
  }
}

class PagosPendientesWidget extends ConsumerWidget {
  const PagosPendientesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagosPendientes = ref.watch(pagosPendientesProvider);

    return pagosPendientes.when(
      data: (pagosPendientes) {
        return _SucessState(pagosPendientes: pagosPendientes);
      },
      error: (error, stackTrace) {
        if (error != TokenRefreshFailedException) {
          return const ErrorStateWidget(
            errorMessage:
                "Ocurrio un error al cargar sus pagos pendientes. Intente mas tarde.",
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
